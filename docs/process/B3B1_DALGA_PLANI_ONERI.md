# `B3b-1` DALGA PLANI — **ÖNERİ** (onay bekliyor)

**Tarih:** 2026-08-24 · **Hazırlayan:** Team Lead · **Statü:** ⏳ **ÖNERİ — onaylanmadan
göç commit'i atılmaz** (`B3B1_DEVIR_BRIEF §3`)

> Bu belgedeki her sayı **ölçümdür**, çıkarma değil. Kanonik kaynak:
> `collmind.backend/scripts/analysis/route-cell-map.py` (+ `MUTABAKAT` çıktısı).
> **Sayılar bu belgede BAKIM GEREKTİRİR** — dalga kapandıkça ratchet listesi düşer;
> statü için üreticiyi koştur.

---

## 0 · ⛔ ÖNCE BİR AD ÇAKIŞMASI — *"Dalga-0 kapandı"* İKİ FARKLI ŞEYE İŞARET EDİYOR

```
B3b-0                  HARİTA DÜZELTME dalgası      ✅ KAPANDI (+ ADIM 0, Z35 bölünmesi)
brief §3 "Dalga-0"     MEKANİZMA dalgası            ⛔ KURULMADI
```

**Ölçüldü (2026-08-24):**

| ölçüm | sonuç |
|---|---|
| `src/common/authorization/` içeriği | **yalnız `capabilities.ts`** |
| `class CapabilityGuard` · `RequireCapability =` | **`0`** |
| `find-importers.sh capabilities` | **`0` tüketici** |
| `@RequireCapability` | **yalnız yorumlarda** |
| **POZ.KONTROL** `class RolesGuard` | **bulundu** (`src/common/guards/roles.guard.ts:7`) — desen çalışıyor |

⇒ **Yetenek katmanı bugün ATIL.** Hiçbir modül dalgası mekanizma kurulmadan koşamaz.
Bu planda o dalgaya **`Dalga-M`** denir — `B3b-0` ile karıştırılmasın.

📌 **Sınıf: `F2` (bir ad, iki anlam) — plan seviyesinde.** *"Dalga-0"* bir **sıra
numarasıydı** ve iki farklı içeriğe yapıştı. Ders: **aşama adları İÇERİK taşımalı, sıra
numarası değil.** `Dalga-M(ekanizma)` bunu yapıyor; bundan sonraki aşama adları da
öyle kurulur.

---

## 1 · TABAN (ölçüldü, `ADIM 0` sonrası)

```
@Roles taşıyan rota          211        toplam rota 223
karar-bekler (DOKUNULMAZ)     72        MODES_READ 34 · SHARED_READ 20
                                        SUMMARY_READ 12 · MODES_APPROVE 6
göçebilir                    139        211 − 72
```

`MODES_APPROVE`'un `6`'sı `review`+`escalate` dahil — **karar paketiyle** ürün sahibine
gider, dalgaya girmez.

---

## 2 · DİLİM `H8` — ERKEN, AYRI, **ATOMİK**

> **Modül dalgalarına KARIŞMAZ.** Gerekçe: Finance-ayrışması aday kararının **ön koşulu**,
> ve mekanik olarak küçük.

### Neden küçük — mekanizma YARI-CANLI (ölçüldü)

`buildScope`'un `hasUnrestrictedRow` dalı **bugün çalışıyor** (`access-scope.service.ts:205`),
ve `READONLY` **zaten şık-(c) modelinde yaşıyor**: `WILDCARD_SCOPE_ROLES`'ta olduğu için
yaratmada joker satır alıyor, `UNRESTRICTED_ROLES`'ta **olmadığı** için (`T-235 ADIM 2`)
kapsamsızlığı **o satırdan** kazanıyor.

⇒ `H8` **yeni mekanizma inşası değil**; `ADMIN`/`FINANCE`'ı `READONLY`'nin zaten yaşadığı
modele taşımak.

### İKİ SABİT — ve `H8` İKİSİNİ BİRDEN öldürmeli

```
çözümleme  access-scope.service.ts:121  UNRESTRICTED_ROLES   = {ADMIN, FINANCE}
yaratma    user-scope.entity.ts:26      WILDCARD_SCOPE_ROLES = {ADMIN, FINANCE, READONLY}
```

**Farklı üyeler, farklı katmanlar.** Yalnız birini öldürmek *"aynı soru iki sabitten
cevaplanıyor"* (`İlke 4`) hâlini bırakır. **Kapsam: ikisinin de veriye inmesi.**

### Sıra `3 → 1 → 2` — ve **TEK DALGA**

```
3  FINANCE + ADMIN'in K-2.6.4 gerekçesi YAZILIR      ← Z35 eklemesi: ADMIN de
1  ADMIN + FINANCE'a joker user_scopes satırı        (seed + migration)
2  UNRESTRICTED_ROLES kod dalı KALDIRILIR            ← SON
```

⛔ **`1` inmeden `2` inemez** ve ara durum **deploy edilemez**. Mekanizma ölçüldü:
`resolveScope:169` `UNRESTRICTED_ROLES` dalında **satırları OKUMADAN** kısa devre yapıyor;
dal ölür de satırlar gelmezse `buildScope` `rows.length===0` → `SCOPED{pairs:[]}` →
`ADMIN`/`FINANCE` **fail-closed düşer**. `T-272` dersinin **ters** uygulaması: **sıra
yetmez, atomiklik şart.**

### Gerekçe cümlesi — **BÖLÜNEBİLİRLİĞE AÇIK** kurulur

- ❌ *"Finans tenant-genelidir"*
- ✅ *"Finans **bugün** tenant-geneldir; kategori-bölünmesi `OPEN_DECISIONS`'ta **aday**."*

### Pin seti — iki-girdi-iki-çıktı

| girdi | beklenen |
|---|---|
| joker-satırlı kullanıcı | `UNRESTRICTED` → `null` (kısıtsız) |
| satırsız / boş kullanıcı | `SCOPED{pairs:[]}` → `[]` (**erişim yok**) |

Array-filter sözleşmesi **davranışsal olarak aynı kalır**; değişen tek şey
`UNRESTRICTED`'in **kaynağı** (sabit → satır). `T-254`/`T-272` pinleri **dokunulmaz
listede**.

### Kabul kriteri

- [ ] İki sabit de veriye indi (`UNRESTRICTED_ROLES` **ve** `WILDCARD_SCOPE_ROLES`)
- [ ] Pin seti yeşil, **iki girdi iki çıktı** üretiyor (mutasyonla ayırt ediciliği kanıtlı)
- [ ] `T-254`/`T-272` pin dosyalarına **dokunulmadı** (`shasum -a 256 -c`)
- [ ] Gerekçe cümlesi **bölünebilirliğe açık** yazıldı
- [ ] ⛔ **`FAZ2_ACIK_KARARLAR`'daki Finance-ayrışması satırının TETİĞİ güncellendi** —
      *"tetik ateşledi — karar görüşülebilir"* (`Z25` rejimi + türev-belge kuralı)
- [ ] Migration numarası `MIGRATION_SEQUENCE.md`'den **tahsis edildi** (ajan seçmez)
- [ ] `data-engineer` yazdı (migration yalnız onun işi), `qa-engineer` pinledi,
      `code-reviewer` onayladı — **davranış değiştiren tur**

### Dosya-bölgesi beyanı (iki-thread kuralı)

```
access-scope.service.ts · user.service.ts · user-scope.entity.ts · user-scope.seed.ts
+ bir migration
```

**Kesişim ölçüldü:** göçebilir `139` rotanın **25 controller dosyası** ↔ `H8`'in **4
dosyası** → **kesişim `0`** (poz.kontrol: `comm` bilerek ortak satırla sınandı, `1` döndü).
⚠️ **Ama bunlar KAPSAM HATTININ dosyaları** — kapsam hattında eşzamanlı tur varsa
`H8` **sıralanır**, paralel koşmaz.

### ⛔ DOKUNULMAZ-KOMŞU (brief'e AYNEN girer)

| komşu | nerede | statü | bu tur |
|---|---|---|---|
| **`T-028c` bayrak dalı** | `access-scope.service.ts:175` — `PLANNER` flag-gated `UNRESTRICTED`, **`H8`'in düzenlediği fonksiyonun İÇİNDE** | `Z25` tablosunda **⛔ KİLİT** (sağlayıcı: prod/UAT — bugün YOK) | ⛔ **DOKUNULMAZ** |

> **Sessiz komşuluk, üç ay sonraki *"madem oradayız şunu da düzeltelim"* turunun
> davetiyesidir.** Adlandırılmış komşuluk o kapıyı kapatır — bu yüzden komşu **adıyla**
> anılır, *"dikkatli ol"* denmez.

---

## 3 · `Dalga-M` — MEKANİZMA (göçten ÖNCE, zorunlu)

Kurulacak: `@RequireCapability` dekoratörü + `CapabilityGuard` çözümlemesi.

- **Harita tek kaynak:** `capabilities.ts` (`ROLE_CAPABILITIES`)
- **Rota-başına TEK mekanizma:** `@Roles` + `@RequireCapability` **aynı rotada yaşayamaz** —
  bu bir **guard kontrolü** olur, bir konvansiyon değil
- **Pin:** iki-girdi-iki-çıktı — doğru capability → `200` · yanlış → `403`
- **Kapsam:** `0` rota göçürülür. Mekanizma iner, kullanılmaz.

### ⛔ KABUL KRİTERİ — `G5` çapraz-kontrolü ŞARTTIR (gelecek-uyarısı DEĞİL)

`route-cell-map.py`'nin `EXPECT` sabiti `ROLE_CAPABILITIES`'ten **bağımsız** yazılı ve
script o dosyayı **okumuyor**. **Harita ATIL olduğu sürece sorun yok** — guard atıl bir
haritayı denetliyor. **Ama harita canlıya döndüğü an iki bağımsız temsil
(`G5` sabiti ↔ çalışan harita) bir `İlke 4` çiftine dönüşür.**

- [ ] `Dalga-M` kapanırken **ya `G5` `EXPECT`'i üreticiden/`ROLE_CAPABILITIES`'ten okur**,
      **ya da** mutabakat kapısı ikisini **çakıştırır**
- [ ] Mekanizma pini — **iki-girdi-iki-çıktı, mekanizmanın KENDİSİNDE** (test rotası ya da
      fixture ile):

```
doğru capability   → 200
yanlış capability  → 403
haritasız rota     → MEVCUT DAVRANIŞ DEĞİŞMEDİ
```

- [ ] `0` rota göçer — mekanizma iner, kullanılmaz

---

## 4 · MODÜL DALGALARI — `139`, sekiz dalga

| # | dalga | rota | neden bu sırada |
|---|---|---|---|
| `W1` | `notification` + `admin` | **3** | **pilot** — ratchet · pin şekli · `§5` metrikleri burada doğrulanır |
| `W2` | `tenant` | **8** | tek controller, dar |
| `W3` | `user` | **9** | ⚠️ `Z20` bölgesi (`USER_MANAGE`) — istisna kaydı okunarak |
| `W4` | `shared` | **13** | 4 controller (`lta-agreement` 7 · `budget` 3 · `spend-calculation` 2 · `approval-policy` 1) |
| `W5` | `customer` | **17** | tek controller |
| `W6` | `modes` | **25** | ⚠️ `Z35` bölünmesi burada iner · `T-277` pinleri **dokunulmaz** |
| `W7` | `master-data` katalog | **45** | 9 controller × 5 (`brand`…`tactic`) — tek desen, tekrarlı |
| `W8` | `master-data` `kpi` + `mechanic` | **19** | `kpi.controller` bayat yorum taşıyor (`Z`-kaydı: *"PLAN verisi"* ↔ katalog okuma) |
| | **TOPLAM** | **139** | |

### Her dalganın ZORUNLU bileşenleri

```
PİN ÇİFTİ      göç öncesi/sonrası AYNI davranış — izinli 200 · izinsiz 403
RATCHET        kalan-@Roles LİSTESİ düşer (SAYI DEĞİL — Z29: "biri düştü, biri girdi"
               gerilemesini yalnız liste görür)
CÜMLE BORCU    Z18 §4 cümle şartını karşılamayan satırlar DOKUNULAN DALGAYLA cümlelenir
DOSYA BEYANI   touches: + kapsam hattıyla kesişim beyanı
```

⛔ **Ratchet sıfır-güvenli olmalı** (`Z29`): kalan liste **boşaldığı gün** bu bir
**BAŞARI OLAYIDIR**, setup hatası değil — ve `72`'de duracak, `0`'da değil.

---

## 5 · İZLEME METRİKLERİ — `W1` raporuyla başlar

```
çürüyen-iddia oranı    Team Lead doğrulamasında düşen ajan iddiası / toplam
DUR sıklığı            dalga başına DUR'a çarpma sayısı (SINIFIYLA)
pin kırmızıları        beklenmeyen kırmızı = davranış değişti = DALGA DURUR
```

Sonnet'e inen ajanlarda bu üçü bozulursa model eşlemesi **ürün sahibiyle revize edilir** —
varsayımla değil, bu ölçümle.

### ⛔ `W1`'DE ORAN RAPORLANMAZ — MUTLAK SAYI + SINIF

`W1` **`3` rota** — küçük örneklem. *"Çürüyen-iddia oranı"* gibi bir oran `3` rotada
**anlamlı çıkmaz**; bir düşen iddia `%33` görünür ve karar bozar.

```
❌  "çürüyen-iddia oranı %33"
✅  "1 iddia düştü — sınıf: enjeksiyon↔çağrı ayrımı"
✅  "DUR 2 kez — biri kapsam-sütunu sınırı, biri numara tahsisi"
```

**Oran yorumu `W2`–`W3` birikimine bırakılır.** Küçük örneklemden oran türetmek,
*"sayı değil liste"* kuralının **istatistik hâlidir**.

---

## 6 · ⛔ DUR — plana dahil OLMAYANLAR

- **Karar-bekler `72`'ye dokunulmaz.** `READ`-üçlemesi + `MODES_APPROVE` (`review`/
  `escalate` dahil) **ayrı bir karar paketi** olarak ürün sahibine gider.
- **Kapsam sütunu ve `scope-*` baseline'ları DOKUNULMAZ** (`Z19b` iki-hat ayrımı).
  Kapsamsız `READ` **`47`**'nin önceliklendirmesi **kapsam hattının**, `B3`'ün değil.
- **Rota-başına tek mekanizma** — `@Roles` + `@RequireCapability` aynı rotada yaşayamaz.
- **Kural/hücre/task/migration numarası** ajan tarafından tahsis edilmez.
- **`T-028c` bayrağı** (`Z25` ⛔ KİLİT) bu planın konusu değil.

---

## 7 · ÖNERİLEN SIRA

```
1  H8            erken dilim, atomik, code-reviewer'lı
2  Dalga-M       mekanizma — 0 rota göçer
3  W1            pilot + §5 metrik raporu           ← ONAY NOKTASI
4  W2…W8         metrikler sağlamsa mekanik akış
```

⚠️ **`W1`'den sonra bir onay noktası var ve bu bilinçli:** `§5` metrikleri model
eşlemesinin ölçümüdür, ve *"iki değişken aynı anda oynamaz"* (`brief §6`).

---

## 8 · AÇIK SORU — ürün sahibine

`H8` ile `Dalga-M` **paralel yürüyebilir mi?** `H8`'in kayıtlı şerhi *"`UNRESTRICTED_ROLES`'un
tek okuyucusu `AccessScopeService`, `@RequireCapability` `RolesGuard` hattında — **sıfır
çağrı bağı → PARALEL yürür**"* diyor.

**Bugün doğrulandı:** dosya kesişimi `0`. ⚠️ **Ama `§4`'ün paylaşılan-ağaç kuralı gereği
`touches:` kesişimi YETMEZ** — `Dalga-M` bir guard kurar ve `npm test` **ağacın tamamını**
derler. Paralel yürüyeceklerse ikisi de **izole `git worktree`'de** doğrulanmalı.

**Öneri:** `H8` **önce ve tek başına** — kazanç küçük, risk (atomiklik + fail-closed)
büyük.
