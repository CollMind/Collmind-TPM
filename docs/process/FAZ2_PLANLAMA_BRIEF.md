# `FAZ-2` PLANLAMA OTURUMU — Brief

> **Tarih:** 2026-08-28 · **Yazan:** Team Lead · **Statü:** ⏳ **hükümler bekliyor**
> **Kaynak:** `FAZ1_KAPANIS_BEYANI.md` (mühürlü) `§5` açılış tezi + bu turun ölçümleri
> **İşaretleme:** `[ÖLÇÜLDÜ]` bugün canlı · `[GEREKÇELİ]` · `ÖLÇEMEDİM`

---

## 0 · ⚡ AÇILIŞ TEZİ — ve brief'in ona kattığı

> **`Faz-2` bir *inşa* fazı değil, bir *doğrulama + tamamlama* fazıdır.**

**Bu turda tez GÜÇLENDİ**, çünkü dört işten **birincisinin en büyük belirsizliği
çözüldü** (`§1i`) ve **çözülürken bir bulgu üretti**: `Faz-1` kapanışında yazdığımız
*"33/30 aktif"* sayısının kendisi **kirliydi.**

---

# 1 · DÖRT İŞİN DALGA-PLANI TASLAĞI

## `1i` · KPI MÜHÜRLEME

### ⭐ KANONİK LİSTE **BULUNDU** — `ÖLÇEMEDİM` düştü

Kapanış beyanı şöyle diyordu: *"kanonik `40+` listesi `Section-10`'da **yok**;
karşılaştırma evreni kurulamadı."* **Bu doğruydu — ama liste BAŞKA BÖLÜMDE:**

```
docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md:587
  "### Complete KPI Library (40 KPIs)"   §5.3 KPI Calculation Engine
```

📌 `DISIPLIN`: *"bir yokluk iddiası için üçüncü soru: **HANGİ BÖLÜM**"* — envanter
ajanı `Section-10`'a **doğru şekilde** dar bakmıştı (brief öyle diyordu), ve liste
`Section-05`'te yaşıyor. **Yokluk iddiası kapsamıyla birlikte doğruydu; evrensel
okununca yanlış olurdu.**

### ⛔ VE ÜÇ SAYI DA YANLIŞ ÇIKTI

```
BRD BAŞLIĞI      "40 KPIs"
BRD GRUPLARI     2+4+3+8+11+6+5+3 = 42        ← başlık kendi içeriğiyle TUTMUYOR
canlı "aktif"    30                            ← kapanış beyanının sayısı
canlı ÜRÜN       24 aktif / 27 toplam          ← GERÇEK
fark             30 − 24 = 6  ⇒  kpi_group='Test'
                 E2E_KPILOCK_* × 6, created_at 2026-08-16, is_active=TRUE
```

⛔ **Altı e2e artığı canlı DB'de `is_active` olarak duruyor** — yani *"aktif KPI"*
sayan **her** ölçüm bugün `+6` şişik. `T-047` evreni artık `48/48` ve bunları
**bundan sonra** yakalar; bunlar **öncesinden** kalma.

> **Boşluk `7`–`10` değil: `42 − 24 = 18`.** Ve `Faz-1`'in kendi kapanış sayısı
> (`33/30`) bir **envanterdi**, ve **kirliydi** — `B1` disiplininin (*"sayı bir
> envanterdir, teşhis değil"*) kendi üstüne katlanmış hâli.

### Karşılaştırma evreni — **ÖNERİ**

| | |
|---|---|
| **evren** | `Section_05 §5.3` **`GROUP 1`–`GROUP 8`**, kalem kalem *(Master Data 2 · Volume 4 · GSV 3 · LTA Spend 8 · Promo Spend by Mechanic 11 · Total Planned Spend 6 · Gross Profit 5 · ROI&RAG 3)* |
| **eşleme anahtarı** | `kpi_group` + **anlam**, `kpi_code` **değil** — BRD kod vermiyor, ad veriyor ⇒ eşleme **elle ve gerekçeli** |
| **çıktı** | üç kova: **VAR** · **YOK** · **VAR AMA FARKLI** *(ör. `BASE_TO`/`PLANNED_TO` BRD'de karşılığı ne?)* |
| ⛔ **şart** | **sayıyla değil, KALEM KALEM.** `42` ve `24` birer envanterdir; teşhis **eşlemedir** |

### Dalga şekli
```
W1  temizlik   6 e2e artığını öldür + üretecini bul (test KPI YARATMASIN, ya da
               afterAll temizlesin) ⇒ T-047 evreni bunu ARTIK yakalar, kapı kurulur
W2  eşleme     42 × 24 kalem-kalem, üç kova, gerekçeli
W3  <500ms     CANLI ölçüm — enstrüman KURULU (PlanningGridEnhanced:788-800 +
               performanceMonitor.ts). Ölçüm şartı: BRD'nin kendi koşulu
               "50 SKU × 40 KPI" (Addendum:40) — bugün 170 SKU var, fixture kurulur
```
⚠️ `W3` bir **NFR ölçümüdür** ve `ADR 0003`'ün kapsam kararına tabidir
(*"input değişiminden UI güncellemesine"*, tek formül **değil**).

---

## `1ii` · BASELINE HATTI

### Bugünkü hâl `[ÖLÇÜLDÜ]`
```
D1 baseline import      🔴 rota+menü ÖLDÜ (bu turda) · backend ucu YOK
D2 baseline doğrulama   ⛔ inşa edilmemiş
D3 tarihsel hacim 12 ay ⛔ tablo YOK (48 tabloda baseline/historical yok)
D4 ≥%95 kapsam kapısı   ⛔ YOK — ve plans.coverage_ratio BAŞKA ANLAM taşıyor
                           (KPI-çocuk çözünürlük oranı, migration 1804000000000)
```

⛔ **`D4` bir ad çakışması taşıyor ve bu bir tuzak:** `coverage_ratio` **var** ve bir
sonraki tur onu *"kapsam kapısı yapılmış"* sanabilir. **Dalganın ilk işi bu ayrımı
`EK_C`'ye yazmak.**

### Dalga şekli
```
W1  ŞEMA       baseline tablosu (D3) — 12 ay tarihsel hacim
               ⚠️ İlke 1: bugün ihtiyaç ölçülmeyen esneklik AÇILMAZ
W2  GİRİŞ      upload ucu + parse (emsal VAR: dört FileInterceptor ucu)
               ⛔ §7: yeni parser YAZMA — sales-actuals/on-invoice deseni oku
W3  DOĞRULAMA  D2 SKU eşleme + D4 ≥%95 kapısı
               ⛔ §2.5: kapsam hesaplanamıyorsa AÇIK HATA, sessiz geçiş YOK
W4  YÜZEY      sayfa GERÇEĞİYLE doğar (bu turda ölen rota geri gelir)
```

📌 **Ve bir bağ:** `D3` inşa edilirse `sales_actuals`'ın **çıkmaz bacağı** da adres
kazanır — gerçekleşen hacim baseline'a **karşı** anlam kazanır. *(`§4`'te ele alınıyor.)*

---

## `1iii` · `T-293` BİRLEŞMESİ

### Mimari çerçeve **`Z38 §3(a)`'da HÜKÜMLÜ** — tasarım tartışması KAPALI
```
agreements   = YAŞAM DÖNGÜSÜNÜN kanonik yeri   (onay · audit · SoD · defter bağı)
lta_rates    = ORAN ŞARTLARININ kanonik yeri   (kanal×kategori kademe)
bağ          AÇIK — agreements-LTA kaydı EBEVEYN, oran kademesi ona BAĞLI doğar
oran girişi  KENDİ YÜZEYİNİ alır
```
**Reddedilenler kayıtlı:** *devir* (onay/audit'i koparır) · *otomatik besleme*
(**yarım** — başlığı üretir, **oranları üretemez**).

### İniş taslağı
```
W1  BAĞ          agreements ↔ lta_agreements FK + ebeveyn-çocuk semantiği
                 ⚠️ migration_seq TAHSİS EDİLECEK · üç durum ayrımı zorunlu
W2  ORAN YÜZEYİ  EK_E'nin 🔒 satırı — "yetenek var, arayüzü yok"un LTA hâli
                 kanal×kategori kademe girişi
W3  MOTOR BAĞI   T-291 ile BİRLİKTE: lta-calculation.service.ts:45,46,49,67,142
                 dört ‖0 düşüşü — §2.5 ihlali, YÖN TEHLİKELİ
                 (eksik fiyat ⇒ LTA harcaması olduğundan KÜÇÜK görünür)
W4  PİN          lta_plan_overrides bugün 0 satır ⇒ cascade yolu HİÇ KOŞMADI
                 ⛔ FIXTURE ŞART — "verinin yokluğu örter" (T-273 vakası)
```

⚠️ **`T-291` bu dalgadan ayrılamaz:** `T-293` bağı kurar, `T-291` bağın **taşıdığı
sayının doğruluğunu** kurar. Ayrı inerlerse `T-293`'ün pini **`0`'larla yeşil geçer**.

---

## `1iv` · SENARYO LİSTESİ — **ilk dalga adayı**

### Format önerisi
```
SC-<halka><no>   ad
  ROL           hangi kimlik(ler)
  ÖN KOŞUL      hangi veri VAR olmalı        ← "verinin yokluğu örter"in panzehiri
  ADIMLAR       gerçek HTTP, mock YOK
  AYIRT EDİCİ   bu senaryo hangi İKİ sonucu ayırt ediyor?   ⛔ ZORUNLU ALAN
  KANIT         hangi SQL/uç okunacak
```
⛔ **`AYIRT EDİCİ` alanı zorunlu, çünkü `§2.7 #6`:** on bir e2e testi bir davranışı
kapsıyordu ve **hiçbiri iki semantiği ayırt edemiyordu.** Bu alan doldurulamıyorsa
senaryo **yazılmaz**.

### `FU`/`SKU` tohumu
```
FU     bugünkü grid hiyerarşisi (Plan → FU → SKU), miras kuralı K-2.x
SKU    canlı 170 SKU · 29 CPL — fixture BUNLARDAN türetilir, uydurulmaz
```

### ⭐ 5-HALKA BOŞLUKLARINDAN TÜREYEN ADAYLAR
*(kapanış beyanı `§2`'nin doğrudan çıktısı — boşluklar senaryo-spec'e dönüşüyor)*

| # | senaryo | hangi boşluktan | ayırt edici |
|---|---|---|---|
| `SC-1a` | `POST /plans/:id/review` uçtan uca | **halka 1** — e2e **sıfır** | RBAC reddi ↔ durum geçişi ↔ audit satırı; bugün **hiçbiri** ölçülmüyor |
| `SC-1b` | `escalate-to-finance` uçtan uca | **halka 1** | yükselme **bildirim mi onay mı** (`K-2.2.7b` `notify\|approve`) |
| `SC-2a` | on-invoice **okuma** yüzeyi | **halka 2** — `entries`/`count`/`batch` e2e'de **hiç çağrılmıyor** | dolu batch ↔ boş batch; bugün **ikisi de boş küme** |
| `SC-2b` | on-invoice **ikamet** senaryosu | **halka 2** — `on_invoice_entries=0`, `ON_INVOICE` defter satırı **0** | aşağı-akış (dashboard/raporlama) **boş küme üstünde sessiz** ↔ dolu |
| `SC-2c` | `sales_actuals` **tüketicisi** | **halka 2** — çıkmaz bacak | gerçekleşen hacim bir motora **girdi mi**; bugün cevap **hayır** |
| `SC-4a` | `claim` yarısı | **halka 4** — şema var, kod yok | *(inşa sonrası)* — bugün **senaryo yazılamaz**, kayda geçer |
| `SC-5a` | `ledger` liste/detay uçları | **halka 5** — `GET /ledger`, `/ledger/:id` doğrudan ölçülmüyor | yön ayrımının **okuma yüzeyinde** de tuttuğu |

⛔ **`SC-4a` bilerek yazılamaz durumda** — ve bu **bir kayıttır**: eşleştirme/claim
halkası inşa edilmeden senaryosu **yazılamaz**, ve *"senaryo yok"* bir eksiklik değil,
**halkanın yokluğunun yansımasıdır**.

---

# 2 · DEVİR-LİSTESİ KARAR PAKETİ

> **Beş kalem, her biri tek paragraf durum + seçenekler.**
> **Hükümler ürün sahibi + `Fable` masasında; Team Lead görüşü işaretli.**

### `2a` · `FINANCE` KAPSAM AYRIŞMASI
**Durum:** `FAZ2_ACIK_KARARLAR:68` **aday karar** olarak duruyor (2026-08-24),
bugünkü hâl ölçülü (`:92`), ve karar açılırsa **üç zincirleme kalem** doğuyor
(`:104` — *"kapsam budur; daha azı YARIMDIR"*). Uygulama maliyeti karar **sonrası
düşük** (`:117`). Yani pahalı olan **inşa değil, karar**.
**Seçenekler:** `(a)` `FINANCE` tenant-geneli kalır *(bugünkü hâl)* · `(b)` kapsama
tabi olur, üç kalem birlikte iner · `(c)` **koşullu**: ikinci müşteride açılır.
**TL görüşü:** `(c)` — bugün tek tenant var, ayrışmanın **ölçülebilir** bir etkisi
yok; `RLS` aktivasyon eşiğiyle **aynı tetikleyiciyi** paylaşabilir.

### `2b` · `T-292` — ONAY MOTORU: `DEĞİŞTİR`/`ONAYLA` EKSENİ
**Durum:** *"`Faz 2` onay-motoru girdisi — `DEĞİŞTİR`/`ONAYLA` ekseni `L2`'de
**kayıtsız**"*. Yani bir davranış ekseni var ve **kural gövdesinde karşılığı yok**.
**Seçenekler:** `(a)` eksen `L2`'ye yazılır *(donmuş belge ⇒ `Z1` kaydı gerekir)* ·
`(b)` `Faz-2` onay motorunun **tasarım girdisi** olarak kalır, `L2`'ye motor
inerken yazılır · `(c)` eksen **reddedilir** (onaylayan değiştiremez).
**TL görüşü:** `(b)` — `L2`'ye bir davranışı **inşa etmeden** yazmak, `E2`'nin
(`tier_roles`) **ölü kolon** vakasının kural tarafını üretir.

### `2c` · `T-321` — `%100 BLOCKED`
**Durum:** `K-2.2.7a`'nın üç kademesinden **`%80` dışında hiçbiri uygulanmamış**;
`%90` bu oturumda indi, **`%100 BLOCKED` yolu `0`**. Ürün sahibinin **ön-eğilimi
kayıtlı** (`Z57 §3b`): *çekirdek-döngü koruması, `Faz-1`-artığı olarak adresli kalır,
inşası kapanışı bloklamaz.*
**Seçenekler:** `(a)` `Faz-2` `W1`'de iner *(eşik zaten `BudgetPolicy`'de okunuyor —
`blockThresholdPct`, maliyeti düşük)* · `(b)` deploy eşiğine bağlanır · `(c)` `Faz-3`.
**TL görüşü:** `(a)` — **altyapı hazır**: `budget_policies.block_threshold_pct`
canlı `100.00`, `BudgetPolicyService` onu **zaten okuyor**, ve `BudgetTierNotificationService`
`BLOCKED` kademesini **bilerek boş bırakmış**. Kalan iş bir **kapı**, bir motor değil.

### `2d` · `+CM` / `T-304` `D1`
**Durum:** `T-304` = *"`KAPSAM BORCU` — tek çatı programı (48-çerçevesi, **38
adressiz kalem**)"*. `CM`-genişlemeleri **kapsam-koşullu** (`Z25` koşul satırı):
kapsam zorlaması o rotalara inmeden `CM` **tenant-geneli görür** = **açılım**.
**Seçenekler:** `(a)` `T-304` programı `Faz-2`'de açılır *(38 kalem — büyük)* ·
`(b)` yalnız `CM`-genişlemelerinin dokunduğu alt küme iner · `(c)` `RLS`
aktivasyonuyla birlikte, çünkü ikisi de **izolasyon** ailesinden.
**TL görüşü:** `(b)` — `Z25` koşul satırı **zaten** dar bir sağlayıcı adlandırıyor;
`38` kalemin tamamı bir `Faz-2` dalgasını **yutar**.

### `2e` · IDEMPOTENCY KÖKEN SEGMENTİ
**Durum:** idempotency bugün **üç ayrı yerde** kanıtlı (`sales-actuals`
`IDEMPOTENT_DUPLICATE` · settlement ikinci-close **tek** `RELEASE` · envelope-split)
— ama **köken segmenti** (aynı anahtarın hangi kaynaktan geldiği) **kayıtsız**.
**Seçenekler:** `(a)` anahtar şemasına köken segmenti eklenir *(migration)* ·
`(b)` sözleşme belgesine yazılır, şema değişmez · `(c)` `Faz-3`.
**TL görüşü:** `(b)` **önce** — `İlke 1`: bugün iki farklı kaynağın **aynı anahtarı
ürettiği ölçülmedi**. Ölçülürse `(a)`.
⚠️ **ÖLÇÜM ÖNERİSİ:** bu kalem bir hüküm istemeden **ölçülebilir** — *"iki farklı
yükleme yolu aynı idempotency anahtarını üretebilir mi?"* Bir turluk `grep` + fixture.

---

# 3 · SIRALAMA — bağımlılık grafiği **ölçümle**

**Ürün sahibinin tahmini:** `senaryo → KPI-mühürleme ∥ T-293 → baseline`

### Ölçüm sonucu — **tahmin ÜÇ NOKTADA DÜZELİYOR**

```
        ┌──────────────────────────────────────────────┐
W0      │ KPI TEMİZLİK (6 e2e artığı)                  │  ← YENİ, en başa
        │ bağımsız · 1 tur · HİÇBİR ŞEYE bağlı değil   │
        └──────────────────────────────────────────────┘
                          │
        ┌─────────────────┴────────────────────────────┐
W1      │ SENARYO FORMATI + ilk yedi spec              │
        │ ⛔ AMA: SC-2a/2b/2c BASELINE'a bağlı DEĞİL,  │
        │    VERİYE bağlı — on-invoice ikamet fixture'ı │
        └──────────────────────────────────────────────┘
                          │
          ┌───────────────┼────────────────┐
W2        │ KPI EŞLEME    │  T-293 + T-291 │   ← PARALEL, touches: disjoint
          │ (42×24)       │  (bağ+oran+motor)│
          └───────────────┴────────────────┘
                          │
W3      ┌──────────────────────────────────────────────┐
        │ BASELINE HATTI (D3→D2/D4→yüzey)              │
        └──────────────────────────────────────────────┘
                          │
W4      ┌──────────────────────────────────────────────┐
        │ <500ms CANLI ÖLÇÜM                            │
        │ ⛔ KPI EŞLEMESİNDEN SONRA — eksik 18 KPI      │
        │    inerse ölçüm DEĞİŞİR; önce ölçmek BOŞA     │
        └──────────────────────────────────────────────┘
```

**Üç düzeltme, gerekçeleriyle:**

| # | düzeltme | gerekçe `[ÖLÇÜLDÜ]` |
|---|---|---|
| 1 | **`W0` KPI temizliği en başa** | `6` e2e artığı `is_active` — **her** KPI ölçümü bugün `+6` şişik. Eşlemeyi kirli evrenle yapmak **`42×30`** olur, doğrusu **`42×24`** |
| 2 | **`<500ms` senaryodan değil, EŞLEMEDEN sonra** | Eksik `18` KPI inerse hesap yükü **değişir**. `50 SKU × 40 KPI` (BRD koşulu) bugün **`24` KPI** ile ölçülürse sonuç **iyimser** ve **yanıltıcı** |
| 3 | **`T-291`, `T-293` ile AYNI dalgada** | Ayrı inerse `T-293`'ün pini **`0`'larla yeşil geçer** — `lta-calculation.service.ts`'in dört `\|\| 0` düşüşü, `lta_plan_overrides=0` ile **birleşince** yol hiç koşmaz |

⚠️ **Ve senaryonun önceliği DOĞRU** — ama sebebi *"önce test yazılır"* değil:
senaryolar **fixture ihtiyacını** ortaya çıkarır, ve `on-invoice`/`LTA` boşluklarının
**hepsi bir veri-yokluğu problemidir**. Senaryo yazımı, **hangi fixture'ın kalıcı
olması gerektiğini** söyler.

---

# 4 · TEMİZLİK LİSTESİ — **fırsatçı biniş**

| kalem | biner | gerekçe |
|---|---|---|
| **ölü ikiz grid** (854 satır, `PlanningGrid.tsx`) | **`W2` KPI eşleme** | eşleme grid'e dokunacak; ölü ikiz **yanlış dosyayı okuma** riski üretir *(alias yüzünden `grep` canlı gösteriyor)* |
| **`tier_roles` ölü kolon** | **`2b` `T-292` hükmüyle** | kolonun kaderi onay-motoru kararına **bağlı** — hüküm `(c)` ise kolon **düşer**, `(a)`/`(b)` ise **kalır** ⇒ **hükümden önce dokunma** |
| **`calculate-kpis` ucu** (UI tüketicisi `0`) | **`W2` KPI eşleme** | *"grid işi çağıracak ya da ölecek"* — eşleme turu bunu **doğal olarak** cevaplar |
| **`ledger.repository.spec.ts`** (`§2.7 #8`) | **`W1` senaryo** | senaryo formatı **`AYIRT EDİCİ`** alanı getiriyor; bu dosya o alanı **dolduramaz** ⇒ ya gerçek testle değişir ya ölür |
| **bayat `claim` yorumları** (×2) | **`SC-4a` kaydı** | *"CTPM does not have a separate Claim entity yet"* — entity `2026-08`'de doğdu; yorum **iki yönde yanıltıyor** |
| **filtrelemeyen filtre** (`PlanningGridEnhanced:810`) | **`W2`** | yorum *"filter by plan context"* diyor, kod `m.isActive` döndürüyor + `catch{return []}` ⇒ `§2.7 #5` **ve** `§2.5` |
| **`6` e2e KPI artığı** | **`W0`** | ↑ `§3` |

---

# 5 · `ÖLÇEMEDİM` — kapanış beyanından devralınan statüler

| ne | statü bugün |
|---|---|
| `B1`'in eksik KPI'ları **hangileri** | ⭐ **EVREN KURULDU** (`Section_05 §5.3`, `42` kalem) ⇒ `W2`'de **ölçülebilir**. Sayı `18`; **kalemler henüz eşlenmedi** |
| `A4`'ün `<500ms` hedefi | ⏳ **`W4`'e planlandı** — enstrüman kurulu, fixture (`50 SKU × 40 KPI`) kurulacak |
| baseline'ın **kolon** düzeyinde saklanması | ⏳ `1ii W1`'in **ilk adımı** — şema yazılmadan önce taranır |
| `review`/`escalate` unit'lerinin **mutasyonla** sınanmışlığı | ⏳ `SC-1a`/`SC-1b` bunu **gereksiz kılar** (canlı e2e gelince) |
| tam e2e'nin envanter turunda koşturulmaması | ✅ **kapandı** — Team Lead ayrıca koştu: `792/792` |

---

# 6 · SENDEN BEKLENEN

```
1  DEVİR PAKETİ — beş hüküm (2a–2e); TL görüşleri işaretli
2  SIRALAMA      — üç düzeltmeli grafik onaylanıyor mu (özellikle W0'ın başa alınması)
3  SENARYO       — format + AYIRT EDİCİ zorunlu alanı onayı; ilk dalga YEDİ spec
4  KPI EVRENİ    — Section_05 §5.3'ün kanonik evren olarak KABULÜ
                   ⚠️ ve bir kayıt: BRD'nin kendi başlığı "40" diyor, grupları 42
                   ediyor — hangisi kanonik? (TL: GRUPLAR, çünkü başlık bir SAYI,
                   gruplar bir LİSTE — "sayı listesiyle anılır ya da hiç anılmaz")
```
