# 0012 — Finansal kayıtlar fiziksel olarak silinemez; silme yolu **soft delete + RESTRICT**

- **Durum:** **Kabul edildi (Accepted)** — 2026-08-11, ürün sahibi
- **Ön koşullar:** üçü de karşılandı — backfill yollarının sayımı · `*/users` kova düzeltmesi · beş tablonun sarkık satır ölçümü
- **Tarih:** 2026-08-11
- **Kapsar:** [[T-188]] · **`D-04`** (append-only zorlama seviyesi) — *ikisi tek karardır*
- **Ölçüm:** `.claude/backlog/tasks/T-188.md` · `docs/contracts/SYSTEM_INVARIANTS.md §3`

> **`D-04` bu ADR'ye katıldı.** *"Append-only hangi seviyede zorlanır"* sorusu ile
> *"bir zarf silinince ledger'a ne olur"* sorusu **aynı sorudur**; ayrı ADR'lere bölünürse
> iki farklı cevap alma riski doğar — bu projede sekiz kez ölçülmüş sınıf.

---

## Bağlam

`main.ledger_entries`: **1231 satır · ₺6.080.000 · `budget_envelope_id` %100 NULL ·
`agreement_id` 1231/1231 var olmayan bir anlaşmaya işaret ediyor.**

Kök neden **şemada**, kodda değil:

```sql
FK ledger_entries → budget_envelopes   ON DELETE = SET NULL   -- 1704067540000:243
FK ledger_entries → tenants            ON DELETE = CASCADE
FK ledger_entries → agreements         YOK
```

### Bilgi taşınmadı — **yok edildi**. Dört yol sayıldı, dördü de kapalı

⚠️ **Bir yokluk iddiası ancak yolların sayımıyla kanıtlanır.** İlk turda tek yol
(`idempotency_key`) kapatılmış ve *"imkânsız"* denilmişti — o çıkarım geçersizdi. Dört yol
ölçüldü:

**1. `idempotency_key` — kapalı.** Biçim `ledger.service.ts:50,:69`:
```
LEDGER|AGREEMENT|{agreement_id}|{transaction_id}      ← p4 zarf DEĞİL, işlem kimliği
main.agreement_transactions          → 0 satır (o da silinmiş)
o tabloda zarf kolonu                → YOK
p4 → agreement_transactions eşleşen  → 0 / 1231
```

**2. Audit log — kapalı, ve sebebi kusurdan büyük.**

⚠️ İlk ölçüm `table_name ~ 'audit'` deseniyle yapıldı ve *"yalnız `admin_audit_logs`"*
dedi — **eksik desen**. Genişletilince:

```
audit|event|log|history|trail deseni → admin_audit_logs · budget_transaction_logs · plan_approval_history
admin_audit_logs        16 satır   (dört jenerik action_type, hiçbiri bütçe hareketi değil)
budget_transaction_logs  0 satır   ← bütçe hareketinin KENDİ log tablosu
plan_approval_history    0 satır
ledger yazımı         1231
```

### ⛔ DÜZELTME (2026-08-11, `T-096` doğrulama turu) — **bu tablo ledger'ın ikinci kopyası DEĞİL**

İlk taslak *"ikinci kopya tablosu var ve boş"* diyordu. **Ölçüldü, yanlış.**

```
budget_transaction_logs kolonları → budget_allocation_id · plan_id
                                     budget_envelope_id YOK · agreement_id YOK
ledger_entries                    → budget_envelope_id VAR · agreement_id VAR
```

| tablo | yazan | grain |
|---|---|---|
| `budget_transaction_logs` | yalnız `budget-allocation.service.ts` (**planning-first**) | allocation + plan |
| `ledger_entries` | `agreement-transaction` · `on-invoice` · `reversal` · `settlement` (**actuals-first**) | envelope + agreement |

> **İki ayrı aile, ve kesişmiyorlar.** 1231 sarkık ledger satırının burada karşılığı **yok
> ve olamaz** — tablo o hareketi kaydeden yol tarafından **hiç yazılmıyor**.

**Sonuç:** `T-096` kapansa bile bugünkü senaryo tekrarlandığında bu tablo **işe yaramaz**.
İkinci kopya isteniyorsa **yeni bir kolon/tablo kararı** gerekir — ölçümle kapanmaz,
[[T-193]]'ün konusudur. Ve bu, T-193'ün kapsamını **daraltıyor**: aranan şey *"boş bir
tabloyu doldurmak"* değil, **olmayan bir atıf yolunu tasarlamak**.

⚠️ Aşağıdaki *"tablosu var ve boş"* okuması bu düzeltmeyle **geçersizdir**; tarihsel kayıt
olarak bırakılıyor.

> ~~**İkinci kopya "hiç düşünülmemiş" değil — TABLOSU VAR ve BOŞ.**~~

**Neden boş — ve burada bir tarih ölçümü gerekti.** [[T-096]] `created_by`'ın iki kez
map'lendiğini, her `INSERT`'in `42701` verdiğini ve dört bütçe rotasının **500** döndüğünü
ölçmüştü. Ama o kusur **bugün kodda değil**:

```
T-096 düzeltmeleri indi   → 2026-08-06  (e915da4 · 1bce53f)
ledger satırlarının tarihi → 2026-06-24 … 2026-07-29
```

> **Tablo boş çünkü düzeltme o koşumlardan SONRA geldi** — ve o günden beri hiçbir bütçe
> rotası çalıştırılmadı. Yani *"yazma hatası bugün de var"* **denemez**.

⚠️ Ve bu, `CLAUDE.md`'nin *"başka bir bileşen hakkındaki iddiayı ölç"* kuralının bir vakası:
ilk taslak T-096'nın bulgusunu **bugünkü durum** gibi yazmıştı. T-096 `review` durumunda,
yani **doğrulanmamış** — ama **düzeltilmemiş değil**.

Zincir şöyle düzeltilir: **log o dönemde yazamıyordu → kopya oluşmadı → `SET NULL` atfı
sildi → geri kuracak kopya yok.** Bugünkü yazma yolunun çalışıp çalışmadığı **ayrı bir
ölçüm** ve tasfiyenin ön koşulu (aşağıda).

⚠️ **Ve `budget_transaction_logs`'un grain'i zarf değil** (`budget_allocation_id`,
`plan_id`) — yani çalışsaydı bile **zarf atfını taşır mıydı, ölçülmedi**. İddia şu kadar:
*bütçe hareketinin log yüzeyi vardı ve yazmıyordu.*

→ [[T-193]] · [[T-096]]

**3. `description` — kapalı.**
```
DEBIT satırlarda description  → 689 / 689 NULL
non-null 542 kayıt            → "Reversal of ledger entry {uuid}" — ledger id'si, zarf değil
```

**4. Zarfların kendisinden türetme — kapalı, ve sebebi ayırt edici.**
```
ledger tarafı DOLU:   period_month 2026-02 (tek çift) · spend_type OFF_INVOICE
                      channel NKA · cpl_id/fu_id/tactic_id 1231/1231
budget_envelopes:     4 satır · deleted_at dolu 0  → orijinaller HARD DELETE edilmiş
2026-02 zarfı:        2 adet, ve ikisinde de channel/category/spend_type NULL
```

> **Boyut bilgisi ledger tarafında duruyor; eşleşecek zarf yok.** Orijinal zarflar fiziksel
> olarak silindi (kalan 4'ün hiçbiri soft-silinmiş değil), ve `2026-02` için kalan **iki**
> zarfın ikisi de boyutsuz — yani ayırt edici yok.
>
> Mevcut bir zarfa yazmak **atfı geri getirmek değil, uydurmak** olurdu.

**Sonuç: backfill dört yoldan da mümkün değil** — ve ikinci yolun kapalı olma sebebi
kusurun kendisinden büyük.

⚠️ Ve bir idempotency sonucu: anahtar **zarf-kapsamlı değil** (`agreement|transaction`).
Yani hipotetik bir backfill anahtarı **değiştirmezdi** — bu, kararın veri tarafını
basitleştiriyor; ama backfill zaten mümkün değil.

`v_budget_summary` ledger'ı okuyor ama zarfsız satırları join edemiyor → **₺1.120.000 net
DEBIT bütçe özetine hiç girmiyor.** Bütçe panosu *"harcama ₺0"* diyor, ledger sayfası 1231
satır gösteriyor.

---

## Karar aslında **verilmiş** — kaynak üç yerde aynı şeyi söylüyor

Bu ADR yeni bir kural icat etmiyor; **yazılı olanı şemaya bağlıyor.**

| kaynak | ifade |
|---|---|
| `Section_12_Glossary.md:382` | *"Ledger is **append-only** (transactions **never deleted**, only corrective transactions added)."* |
| `Section_09_NFR.md:296` | **Ledger Entries · 7 years · Financial compliance** (Vergi Usul) |
| `Sprint_0_Mandatory_Items.md:281-284` | *"Admins **CANNOT delete** approved agreements · **CANNOT delete** consumed budget transactions · **CANNOT modify** ledger entries (append-only)"* |

Ve *"silinemez ama görünmemeli"* ihtiyacının cevabı da kaynakta kurulu: **soft delete /
anonimleştirme**, fiziksel silme değil (`Section_09_NFR.md:303,:314,:319` — silinen
kullanıcı **anonimleştirilir**, `user_id` audit izi için **kalır**).

⚠️ `CLAUDE.md §2.1.2` gereği: kaynak bir **girdi**dir. Ama burada üç bağımsız yer aynı
kuralı söylüyor **ve** biri yasal yükümlülüğe (Vergi Usul, 7 yıl) dayanıyor — bu bir
tasarım tercihi değil.

---

## Karar

### 1. Finansal kayıtlar **fiziksel olarak silinemez**

Bir tablo **7 yıllık saklama kapsamında bir finansal kayıt** tutuyorsa, ona giden hiçbir FK
`CASCADE` ya da `SET NULL` **olamaz**.

⚠️ **Sınıflandırma ekseni bu — *"tenant_id mi, değil mi"* değil.** Tenant offboarding'de
ledger'ı fiziksel silmek `Section_09`'un 7 yıl maddesini **doğrudan ihlal eder**; KVKK
silme hakkı ile vergi saklama yükümlülüğü çatışmasının kaynaktaki çözümü zaten
**anonimleştirme**.

### 2. Silme yolu **soft delete**, ve FK `RESTRICT`

`budget_envelopes` **soft-delete edilebilir olmalı** ve FK `RESTRICT`/`NO ACTION` olur.

> ⚠️ **DÜZELTME (2026-08-11, uygulama turu):** bu madde *"`deleted_at` **eklenir**"* diyordu.
> **Yanlış — kolon zaten vardı**, ilk migration'dan beri
> (`1704067500000-CreateBudgetEnvelopes.ts:142`, `BaseEntity.@DeleteDateColumn`), ve beş
> kısmi index de `WHERE deleted_at IS NULL` taşıyor.
>
> Yani bu ADR'nin *"tek parça inmeli"* gerekçesi **zaten karşılanmıştı**; eksik olan yalnız
> FK tarafıydı. Gerekçe değişmiyor, **iddia düzeltiliyor** — kaynak okunmadan yazılmış bir
> cümleydi (`CLAUDE.md`: *"başka bir bileşen hakkındaki iddiayı ölç"*).

> **`RESTRICT` tek başına eksik bir karardır.** Zarf artık hiç silinemez, operasyonel bir
> ihtiyaç kapatılmış olur — ve bir süre sonra biri onu `DELETE` yerine `TRUNCATE` ya da
> elle SQL ile çözer. İkisi **tek parça** inmeli.

### 3. `agreement_id`'ye FK eklenir

Bugün **hiç yok** — ve 1231 sarkık satır bunun ölçülmüş bedeli. Anlaşmalar silindiğinde
hiçbir şey uyarmadı.

---

## FK sınıflandırması — ölçülmüş 22 FK, üç kova

| kova | FK'lar | gerekçe |
|---|---|---|
| **⛔ Kapsam içi — değişmeli** | `ledger_entries → budget_envelopes` (SET NULL) · `ledger_entries → tenants` (CASCADE) · `agreement_transactions → agreements/tenants` (CASCADE) · `budget_transactions → budget_envelopes/tenants` (CASCADE) · `on_invoice_entries → budget_envelopes` (SET NULL) · `on_invoice_entries → tenants/customers/skus/on_invoice_batches` (CASCADE) | çocuk satır **7 yıl saklama kapsamında finansal kayıt** |
| **⛔ Kapsam içi — `sales_actuals`** | `→ tenants` · `→ sales_actual_batches` (CASCADE) | **saklama yükümlülüğü** — aşağıda |
| **⛔ Kapsam içi — `budget_reservations`** | `→ budget_envelopes` · `→ tenants` (CASCADE) | **tasarım tekdüzeliği** — aşağıda |
| **⛔ Kapsam içi — `*/users → SET NULL`** (6 adet) | `agreement_transactions` ×2 · `on_invoice_entries` ×2 · `sales_actuals` ×2 | aşağıda |
| **📌 Kapsam dışı** | `agreement_transactions → customers` (SET NULL) | müşteri finansal kayıt değil; `Section_09` saklama tablosunda geçmiyor |

### İki tablo ⛔'ye alındı — ama **gerekçeleri ayrı**, ve bu ayrım kalıcı

*"7 yıl saklama kapsamında finansal kayıt mı"* sorusu bu ikisinde net cevap vermiyor. Asıl
ayırt edici başka:

> **Satır, kendisi saklama korumalı olan yetkili bir kaynaktan yeniden kurulabilir mi?**

**`sales_actuals` — saklama yükümlülüğünden.** Hiçbir şeyden türetilemez; **kaynak
veridir**, ve settlement'ın deterministik yeniden hesaplanabilirliği buna bağlıdır.
`Section_09`'un saklama tablosunda `Baseline Data · 5 yıl` satırına oturuyor (7 değil, ama
sıfır da değil), ve `FINAL` upload değişmezliği K-kararlarında zaten var.
→ **`RESTRICT`, tartışmasız.**

**`budget_reservations` — tasarım tekdüzeliğinden.** *"Türev"* etiketi doğruysa ledger'dan
yeniden kurulabilir demektir, ve `RESTRICT` teknik olarak **zorunlu değildir**. Ama:

> **Bugün ölçtüğümüz kusurun mekanizması tam olarak buydu:** bir tablo kardeşlerinden
> **farklı** bir silme kuralı taşıyordu ve fark **hiçbir yerde gerekçelendirilmemişti**.
> İki kuralın bir arada yaşadığı pencere **kusurun kendisidir** — süresi ne kadar kısa
> olursa olsun.

→ **`RESTRICT`, gerekçe *"türev olduğu için değil, sapma maliyetli olduğu için"*.**

⚠️ **Bu ayrım ileride işe yarayacak:** *"`RESTRICT`'i gevşetebilir miyiz"* sorusu geldiğinde
**hangisinin** gevşetilebilir olduğunu bu belirler. `sales_actuals`'ınki bir yükümlülük;
`budget_reservations`'ınki bir tercih.

### ⛔ `*/users → SET NULL` **kapsam dışı değil, ihlal**

İlk taslak bunu *"kaynağın anonimleştirme modeliyle uyumlu"* diye kapsam dışına koymuştu.
**Yanlış okuma.** `Section_09:303`'ün ifadesi:

> *"Deleted users: **Anonymized** (`user_id` **retained** for audit trail)"*

**Korunan şey tam olarak kimlik referansının kendisi.** `created_by`'ı `NULL`'lamak referansı
korumaz — **imha eder**; anonimleştirmenin **karşıtıdır**.

Doğru kalıp: `users` satırı **kalır**, PII alanları anonimleştirilir, FK **`RESTRICT`**.
→ [[T-170]] · `INV-C-002` ile aynı iş.

### Bugünkü sarkık satır maliyeti — ölçüldü (2026-08-11)

```
ledger_entries         1231 satır · budget_envelope_id NULL 1231   ⛔
budget_transactions       4 satır · envelope NULL 0
budget_reservations       0 satır
on_invoice_entries        0 satır
agreement_transactions    0 satır
sales_actuals             3 satır
ledger.created_by NULL    0 / 1231   ·  users 9 satır
```

> **Sarkık satır yalnız `ledger_entries`'te.** Yani *"karar gerekli"* kovasının bedeli
> **bugün sıfır** — ve tam olarak bu, pencerenin açık olduğu an.
>
> ⚠️ Bu maliyet ölçümü **dev veritabanına** özeldir; veri taşıyan bir ortam doğduğunda
> aynı kararın maliyeti başkadır.

---

## Sonuçları

### `INV-L-001` bugün **yanlış** yazıyor

> *"**No statement** may modify `ledger_entries.amount`, `entry_direction`,
> **`budget_envelope_id`**, or `period_month` after insert."*

`budget_envelope_id` o listede, ve `ON DELETE SET NULL` tam onu değiştiriyor — **bir
ifadeyle değil, başka bir tablodaki DELETE ile**. Invariant `HOLDS` işaretli; **değil**.

**Düzeltme ifadenin kendisinde:**

- ❌ *"No statement may modify X"* — ölçüm yüzeyini **ifadelere** daraltıyor
- ✅ *"For every row, X observed at time T equals X at insert"* — **durum tabanlı**,
  gözlemlenebilir, ve şemadaki bir kuralı da yakalar

### Ve doğrulama yöntemi de değişmeli

Invariant kontrolüne bir **şema sorgusu** eklenir:

```sql
-- finansal tablolara giden FK'larda confdeltype ∈ {a, r} dışında değer OLAMAZ
select … from pg_constraint where contype='f' and confdeltype not in ('a','r') …
```

> Bu bir **invariant testidir, bir migration kontrolü değil** — her koşuda çalışmalı.
> `npm run guards`'a bağlanır.

⚠️ **Guard bir tablo allowlist'i taşımalı.** Finansal olmayan tablolarda `CASCADE` meşrudur
(`plan_skus → plans` gibi); allowlist'siz bir guard **gürültü üretir**, ve gürültü üreten
guard **kapatılır**. Kapsam listesi bu ADR'nin ⛔ kovasıdır, ve listeye ekleme bir
**karardır** — `money-float-domain-a.txt` ile aynı şekil.

### ⚠️ Ve `deleted_at` yeni bir ihlal yüzeyi açıyor — ADR bunu yazmazsa kardeş kusur doğar

`RESTRICT` + `deleted_at` doğru karar. Ama `deleted_at`'in kendisi **`INV-T-001`'in
(*"No financial query…"*) ihlal yüzeyidir:

> Soft-silinmiş bir zarf, `Available = Allocated − COMMIT − RESERVE − CONSUME + RELEASE`
> hesabına **sessizce girmeye devam eder** — her sorgu `deleted_at IS NULL` filtresini
> taşımazsa.

⛔ **DÜZELTME (2026-08-11, review turu): `v_budget_summary`'de yön TERS.**

```sql
v_budget_summary … FROM main.budget_envelopes be WHERE (deleted_at IS NULL);
```

View **zaten filtreliyor** — yani soft-silinen bir zarf özetten **tümüyle düşüyor**,
ledger satırları o zarfa atfedilmiş hâlde **kalmasına rağmen**.

> **Korkulan:** silinen zarf hesaba **girmeye devam eder**.
> **Gerçek:** silinen zarfın **gerçek harcaması sessizce kayboluyor**.

İkisi de sessiz, ama ikinci yön **daha kötü**: `Allocated` da `consumed` da gider, ve
harcanmış para hiçbir toplamda görünmez. → [[T-201]]

**Ve çözüm kodda filtre aramak değildir** — bu, `INV-L-001`'in düştüğü tuzağın aynısı:
yanlış yüzeyde ölçmek. Kalıcı çözüm **görünüm (view)** ya da **RLS predicate'i**, yani
[[T-167]] ile aynı yere bakıyor.

> **Bir kusuru kapatırken kardeşini açmamak, bu ADR'nin kabul koşuludur.**

### Aynı kalıp beş invariant'ta var — taranmalı

```
INV-L-001  "No statement may …"        ← ölçülen ihlal
INV-L-003  "No ledger row …"           ← CASCADE satırı hiç bırakmıyor, deleted_at bile yok
INV-B-005  "No realized economic …"
INV-T-001  "No financial query …"
INV-C-001  "No financial record …"
```

Beşi de *"kod ne yapıyor"* üzerinden yazılmış. **Şema aynı etkiyi hiç kod olmadan
üretebiliyor mu?** — her biri için ayrı sorulmalı. `INV-L-003`'te cevap **evet** ve ölçüldü.

---

## ⛔ Bu ADR'nin **kapsamadığı**

**Audit boşluğu bu kararla kapanmıyor.**

> Backfill'i imkânsız kılan `SET NULL` değil — **ikinci kopyanın hiç yazılmamış olmasıydı.**
> FK kuralı `RESTRICT` olduğunda bu boşluk **olduğu yerde kalır**.

`budget_transaction_logs` bugün **0 satır** ([[T-096]]: `42701`, her `INSERT` düşüyor). Bu
ADR onu düzeltmiyor, düzeltiyormuş izlenimi de vermemeli. → [[T-193]] (ve [[T-168]] ·
[[T-170]] · [[T-173]] ile birlikte, **tek** audit sözlüğü işi olarak)

**İki ölçülmemiş nokta, karara engel değil ama açık:**

1. **`budget_reservations` gerçekten türev mi, yoksa ikinci hakikat kaynağı mı?**
   `Section_12`: *"ledger bütçe kullanımının **tek** hakikat kaynağıdır."* Rezervasyonlar
   ledger'daki `RESERVE` ile aynı niceliği tutuyorsa o ifade **zaten ihlal** ediliyor ve
   `Available` iki yerden beslenebilir.
   ⚠️ **Bugün ölçülemiyor** — `budget_reservations` **0 satır**. → [[T-194]]
2. **`budget_transaction_logs`'un grain'i zarf atfını taşır mıydı?** Kolonları
   `budget_allocation_id`/`plan_id`; **ölçülmedi**.

---

## Uygulama sırası (ürün sahibinin sıralaması)

### ⛔ Sıralama düzeltildi — **tasfiye FK'dan ÖNCE, ve migration'ın İÇİNDE**

İlk taslak tasfiyeyi 5. adım yapmıştı. **Yanlış:** `agreement_id`'ye FK **eklenemez** —
1231 satırın hepsi var olmayan anlaşmalara işaret ediyor, PostgreSQL constraint'i reddeder.

İki seçenek vardı ve ikisi de bugün seçildi:

| seçenek | sonuç |
|---|---|
| **tasfiye önce, sonra FK** | ✅ temiz |
| `NOT VALID` | ⛔ **kalıcı olarak doğrulanmamış** bir constraint + ledger'da sonsuza kadar atfedilemez 1231 satır — **bugünkü kusuru şemaya yazılı hâle getirir** |

> **Migration sırası: `purge → FK → RESTRICT → deleted_at`.** Tasfiye ayrı bir adım olarak
> sonraya bırakılamaz; migration'ın **içindedir**.

### ⚠️ Ve tasfiye bu ADR'nin **ihlalidir** — açık, tek seferlik istisna olarak yazılır

Bu belgeyi imzaladıktan sonra yapılacak ilk iş **1231 finansal kaydı fiziksel olarak
silmek**. Gerekçesiz yapılırsa belgenin ilk uygulaması onun karşıtı olur, ve bir sonraki
okuyan kişi **kuralın esnetilebilir olduğunu** öğrenir.

**İstisnanın gerekçesi — ve sınırı:**

> Bu satırlar kuralın **koruduğu şeyi zaten kaybetmiş** durumda: atfı yok, kanıtı yok,
> dört yoldan da yeniden kurulamıyor. Silme kararı **deploy öncesi** ve dışarıda hiçbir
> kaydı yok. **Kural atfı olan kayıtları koruyor; bunlar o kümede değil.**

- [ ] **Silmeden önce 1231 satırın tam dökümü bir dosyaya alınır ve commit'lenir.**
      Ucuz sigorta, ve istisnanın **kanıtı**.
- [ ] **Tasfiyeden ÖNCE [[T-096]] doğrulanır** — `budget_transaction_logs`'a bugün gerçekten
      yazılabildiği **ölçülür** (bir bütçe rotası koşturulur, satır oluştuğu görülür).

      ⚠️ Gerekçe sıralamayı belirliyor: **istisnayı kaydeden mekanizma, istisnayı uygularken
      çalışıyor olmalı.** Log yazmıyorken tasfiye yapılırsa, 1231 satırın silinmesi de
      **loglanmaz** — yani ADR'nin tek istisnası, kaydı olmayan bir işlem olur.

### Migration kapsamı: `ledger_entries` değil, **⛔ kovasının tamamı**

⚠️ Yalnız `ledger_entries` düzeltilirse **iki saat önce reddettiğimiz yapı kurulur**: bazı
tablolar `RESTRICT`, bazıları `CASCADE`, fark gerekçesiz. Sınıflandırmanın **tamamı** tek
migration'da uygulanır — `*/users` dahil.

📌 Diğer beş tablo **temiz** çıktığı için bu ucuz: constraint değişikliği dışında iş yok.

### ⛔ DÜZELTME (2026-08-11, uygulama turu) — **`tenants` GİRDİ**

Aşağıdaki bölüm **inen şemayla çelişiyor** ve tarihsel kayıt olarak bırakılıyor.

**Gerçek:** migration `1802000000000` altı finansal tablodan `tenants`'e giden **6 FK'nın
6'sını da `RESTRICT`** yaptı (ölçüldü: `confdeltype='r'`, 6/6).

**Gerekçe** ürün sahibinin üçüncü seçeneği (`.claude/backlog/tasks/T-188.md`, not 3):

> `RESTRICT`, offboarding yolu tanımlanmadan. Bugün hiçbir şey kırmıyor (tenant silme yolu
> yok — ölçüldü: `tenant.service.ts:100` `softRemove`), ve ihtiyaç doğduğunda **bir hata
> mesajıyla durup** [[T-195]]'i tetikleyecek. *"Dışarıda kalsın"* seçeneği bugünkü
> `CASCADE`'in kalması demekti — yani `Section_09`'un 7 yıl maddesinin **ihlalinin
> sürmesi**.

⚠️ **Ve bu düzeltme geç kaldı:** karar T-188'in gövdesinde verildi, ADR metni
güncellenmedi. `CLAUDE.md §2.1`'e göre **ADR en üstte** — bunu okuyan biri şemayı *"ADR
ihlali"* sanıp geri çevirebilirdi. Aynı commit `deleted_at` iddiasını düzeltirken bunu
**atladı**.

> **Bir kararı task gövdesinde vermek, ADR'yi güncellemek değildir.**

---

### ~~⛔ `tenants` bu migration'a GİRMİYOR — offboarding yolu tanımlı değil~~ *(süperseded)*

Zarf için *"`RESTRICT` tek başına eksik"* dedik ve `deleted_at` ekledik. `tenants`
`CASCADE → RESTRICT` olduğunda **aynı tuzak**: tenant artık silinemez, ve tenant
offboarding için **tanımlı bir yol yok**.

**Bu ADR onu kapatmıyor.** Kaynağın kalıbı kurulu (kullanıcı silme = anonimleştirme);
tenant için aynısı **yazılmamış**.

> Bu yüzden `*/tenants` FK'ları bu migration'ın **dışında**. Ya offboarding yolu (deaktivasyon
> + anonimleştirme) tanımlanır ve beraberinde girer, ya da ayrı bir kararla gelir.
> → [[T-195]]

---

## Uygulama sırası — düzeltilmiş

1. ✅ **Backfill yollarının sayımı** — dört yol, dördü de kapalı (yukarıda). Ve ikinci
   yolun (audit) kapalı olma sebebi ayrı ve daha büyük bir P1: [[T-193]]
2. ✅ **FK sınıflandırması** — kovalar yukarıda, ve bugünkü sarkık satır maliyeti ölçüldü:
   sarkık satır **yalnız `ledger_entries`'te**. Açık kalan tek şey *"karar gerekli"*
   kovası: `budget_reservations` (türev kayıt) · `sales_actuals` (kaynak veri) —
   **ürün sahibinin çağrısı**
3. Şema: `budget_envelopes.deleted_at` + FK `RESTRICT` + `agreement_id` FK'sı
   — **tek migration**, `data-engineer`, numara `MIGRATION_SEQUENCE.md`'den
4. Invariant kalıbı taraması + durum-tabanlı yeniden ifade + şema guard'ı
5. 1231 sarkık satırın tasfiyesi

⚠️ **Bu pencere kapanacak.** Deploy edilmiş ortam yok ([[T-157]]) — 1231 satır bugün sıfır
maliyetle silinebilir. İlk gerçek deploy'dan sonra aynı iş migration + geri alma planı +
veri doğrulama gerektirir.

---

## Ölçümün kendisi hakkında bir not

**Dört hipotez yazılmıştı; dördü de yanlıştı.** *"Test artefaktı"* hipotezi *"en ucuz ve en
olası"* diye öne alındı ve **kısmen** doğruydu (satırlar gerçekten e2e koşumlarından) — ama
**sebebi** o değildi. Satırlar zarfsız **yazılmadı**; sonradan zarfsız **bırakıldı**.

> `CLAUDE.md §7.1`: *"Bir sayının en az iki açıklaması vardır."* Burada beş vardı, ve
> doğrusu listede yoktu. Doğru cevabı veren şey hipotez üretmek değil, **zinciri adım adım
> elemekti**: kolon ne zaman eklendi → yazan kod ne geçiyor → satırlar ne zaman yazıldı →
> `agreement_id` nereye işaret ediyor.
