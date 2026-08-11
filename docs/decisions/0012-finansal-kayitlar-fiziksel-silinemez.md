# 0012 — Finansal kayıtlar fiziksel olarak silinemez; silme yolu **soft delete + RESTRICT**

- **Durum:** Önerilen (Proposed) — ürün sahibi onayı bekliyor
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

### ⛔ Ve bilgi taşınmadı — **yok edildi**

İlk okuma *"`SET NULL` bilgiyi yok etmedi, yer değiştirdi"* olabilirdi. **Ölçüldü, yanlış:**

```
idempotency_key biçimi (ledger.service.ts:50,:69):
    LEDGER|AGREEMENT|{agreement_id}|{transaction_id}
                                    ↑ zarf DEĞİL, işlem kimliği

main.agreement_transactions               → 0 satır (o da silinmiş)
o tabloda zarf kolonu                     → YOK
p4 → agreement_transactions eşleşen       → 0 / 1231
```

> **Backfill imkânsız.** `CASCADE` ve `SET NULL` birlikte hem atfı hem onu yeniden kurmanın
> aracını sildi. 1231 satır artık hangi bütçeye ait olduğunu **hiçbir yerden** bilmiyor.

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

`budget_envelopes`'a `deleted_at` eklenir **ve** FK `RESTRICT`/`NO ACTION` olur.

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
| **⚠️ Tartışmalı — karar gerekli** | `budget_reservations → budget_envelopes/tenants` (CASCADE) · `sales_actuals → tenants/sales_actual_batches` (CASCADE) | rezervasyon **türev** bir kayıt; actuals **kaynak veri**. `Section_09`'un tablosunda ikisi de adıyla geçmiyor |
| **📌 Kapsam dışı** | `*/users → SET NULL` (6 adet) · `agreement_transactions → customers` (SET NULL) | `Section_09:303`: silinen kullanıcı **anonimleştirilir**, `user_id` audit için kalır. `SET NULL` burada **kaynağın modeliyle uyumlu** — ama anonimleştirme uygulanmadan bu da eksik ([[T-170]], `INV-C-002`) |

⚠️ **Sarkık satır sayısı bu tabloda ölçülmedi** — yalnız `ledger_entries` ölçüldü. Diğer
beş tablonun bugünkü durumu **bilinmiyor**.

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

## Uygulama sırası (ürün sahibinin sıralaması)

1. ✅ `idempotency_key` ölçümü — **backfill imkânsız** (yukarıda)
2. FK sınıflandırması — yukarıdaki üç kova, **tartışmalı kova karara bağlanacak**
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
