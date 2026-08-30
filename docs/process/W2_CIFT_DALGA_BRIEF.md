# `W2` — ÇİFT DALGA BRIEF'İ
### `DALGA-A` KPI eşleme  ∥  `DALGA-B` `T-293`+`T-291`

> **Tarih:** 2026-08-29 · **Yazan:** Team Lead · **Başlık:** **`A1`** *(mod ayrımı öldü —
> bir yeteneğin adresi "hangi modda" değil, **"tek akışın neresinde"**)*
> **Zemin:** `unit 1230/1230` · `e2e 832/832` · `guards 0` · `T-047 PASS`
> **İşaretleme:** `[ÖLÇÜLDÜ]` bugün canlı · `[GEREKÇELİ]` · `ÖLÇEMEDİM`

---

## 0 · ⛔ `touches` ÖLÇÜMÜ — **DİSJOINT**, ama bir şartla

```
DALGA-A   docs/ (meta) · main.kpis (OKUMA) · kod OKUMASI (spend-calculation, kpi-engine)
          ⇒ ÜRETİM KODU YAZMAZ — bu bir EŞLEME turu
DALGA-B   src/modules/shared/lta/** · agreements ↔ lta_agreements bağı
          + migration (numara TAHSİS EDİLECEK)

DOSYA KESİŞİMİ   ∅
```

⛔ **AMA ÜÇÜNCÜ ŞART — DOĞRULAMA İZOLASYONU:** `T-325` (e2e tek-çalıştıran kilidi +
taban temizliği) **hâlâ yok**. `DALGA-B` migration + e2e koşacak; `DALGA-A` **koşmayacak**
(üretim kodu yazmıyor).

⇒ **PARALEL İNEBİLİRLER** — çünkü `DALGA-A`'nın e2e ihtiyacı **yok**.
**Şart:** `DALGA-A` ajanı **hiçbir e2e koşmaz**; `DALGA-B` ajanı **hedefli** koşar,
**tam koşumu Team Lead** yapar.

---

# `DALGA-A` · KPI EŞLEME — `52 × canlı-24`

## `A0` · ⭐ İLK MADDENİN CEVABI **BÜYÜK ÖLÇÜDE HAZIR** — ve terim farkında saklıydı

Soru: *"Canlı motor off-invoice'u neye dayandırıyor — `NIV` katmanı kodda var mı?"*

**`NIV` kodda VAR — `TO` (Turnover) adıyla** `[ÖLÇÜLDÜ]`:
```
migration 1781000000000  "T-008 — PLANNED_TO / BASE_TO NIV Semantics Fix"
                         "BRD NIV semantiği: Turnover YALNIZCA ON-INVOICE
                          kesintilerle azalır"
canlı kpis:
  PLANNED_TO  =  PLANNED_GSV - PLANNED_ON_INVOICE_SPEND
  BASE_TO     =  BASE_GSV    - BASE_LTA_ON
```
⇒ `NIV = GSV − on-invoice kesintiler` **tanımı birebir**.

📌 **`DISIPLIN`: *"arama terimi, ARANAN YERİN DİLİYLE seçilir"*** — Excel `NIV` diyor,
kod `TO` diyor. **Bu, bugün DÖRDÜNCÜ vaka** *(mod ayrımı · `scopeEnforcementEnabled` ·
`TODO: Implement` · `LTACalculationService`)*.

## `A0'` · ⛔ HÜKÜM — SORU **"NIV ≡ TO mu?"** DEĞİL, **"CANLI-TO HANGİSİ?"**
*(ürün sahibi hükmü, 2026-08-30)*

Yukarıdaki okuma **yarım**. Migration metni Excel sözlüğüyle yan yana konduğunda
**iki kavramın tek ada sıkıştığı** görülüyor:

```
canlı  PLANNED_TO = GSV − ON_INVOICE_SPEND     ≡ Excel PlannedNIV  (GSV − TotalSpendOn)
canlı  BASE_TO    = GSV − LTA_ON               ≡ Excel BaseNIV     (GSV × (1−LTAOnPct))
Excel  PlannedTO  = GSV − PlannedPromoTotalSpend
                            ↑ ON + OFF BİRLİKTE düşülmüş — BAŞKA KAVRAM
```

⇒ **Canlıdaki "TO", Excel'in NIV'idir.** Excel'in **gerçek TO**'su (off-invoice de
düşülmüş net ciro) canlıda **hiç olmayabilir**.

⛔ **BU YÜZDEN AD-DÜZEYİ EŞLEME YASAK.** *"`TO` var ⇒ `Turnover(4)` eşleşti"* demek
**yanlış** olur: `NIV(3)` gerçekten eşleşir, `Turnover(4)` **eşleşmez** — ve eksik-`18`
**küçülmüş GÖRÜNÜR** ama gerçekte küçülmemiştir.

> **Bir ad eşleşmesi, bir kavram eşleşmesi değildir.** İki farklı kavram tek ada
> sıkıştığında, ad-düzeyi eşleme **boşluğu SİLER**, kapatmaz.

### `A0'` ÇIKTI ŞARTI — **yedi kalem, kalem kalem**
`NIV(3)` + `Turnover(4)` = **7 kalem.** Her biri için:
```
1  canlı-karşılık        kpis satırı (KOD) ya da "YOK"
2  SEMANTİK KANIT        FORMÜL karşılaştırması — ad karşılaştırması DEĞİL
3  verdict               eşleşen-doğru | eşleşen-sapmalı | YOK
```
⛔ **Ve iki kavram tek addaysa bu bir `AD-BORCU` olarak KAYDA GİRER.**
Yeniden-adlandırma hükmü **eşleme-sonrası** verilir, ve **VERİ-DOKUNMASIZ** ilkesiyle
*(ad borcu bir kayıt kalemidir; bu turda kolon/enum adı DEĞİŞTİRİLMEZ)*.

> **`A1` eşlemesi `A0'` raporundan SONRA başlar.** *(TL görüşüyle aynı — gerekçesi
> artık daha sert: mesele evrenin büyüklüğü değil, evrenin **yanlış yerde küçülmesi**.)*


## `A1` · EŞLEME — üç kova

| kova | ne demek |
|---|---|
| **eşleşen-doğru** | kalem var, formül **anlamca aynı** |
| **eşleşen-sapmalı** | kalem var, formül **farklı** ⇒ ⚠️ **sapma KAYDEDİLİR, sessizce hizalanmaz** |
| **YOK** | kalem canlıda **yok** ⇒ süzgeçli yerleşim önerisi |

⛔ **`YOK` kovasının HER kalemi için yerleşim** *(`Z62 §0` süzgeci)*:
```
Faz-2-ŞART   ilk-müşteri değeri için GEREKLİ
aday         gerekli değil ama yakın
Faz-3        ölçek-hazırlığı ⇒ OLAY-TETİKLİ koşul satırı (sağlayıcı + tetikleyici YAZILI)
```

**Karşılaştırma tabanı:** referans belgenin **`§1` Excel formül sözlüğü**, satır satır.
**`§3` agregasyon işaretleri AYRI SÜTUN** *(bir kalem "var" ama **yanlış seviyede
toplanıyor** olabilir — bu `eşleşen-sapmalı`dır)*.

## `A2` · AÇIK-SORU STATÜLERİ — hükümlerden gelen `[KAPANDI]`

| # | hüküm | eşlemedeki karşılığı |
|---|---|---|
| `§6-1` | **KESİN** — evren **`52`** (11 grup), `NIV`/`TO`/`GM` **geri geldi**, düşüş **bilinçsizdi** | evren `52` |
| `§6-2` | **AÇIK-SORU** — `EffectiveTotalIMSVolumePC` kaynağı | `PriceSupport` ve `PlannedCOGS` **"kaynağı-belirsiz-girdi"** statüsü taşır ⛔ **sell-in hacmi SESSİZ VEKİL YASAK** |
| `§6-3` | **ROI paydası** = yalnız promo-spend (**LTA hariç**) **varsayılan** | ⛔ tanım **motorda SABİTLENMEZ** — **tek noktadan** okunur; tenant-konfigür ekseni **olay-tetikli**. ⇒ `DALGA-B`'nin motor-bağı tasarımına **girdi** |
| `§6-4` | **BMI kapsam-dışı** | *"Excl. BMI"* şerhi eşlemede **korunur** |
| `§6-5` | mekanik **satır düzeyi** | `W2` **kod ölçümü** |

⚠️ **`§6-2`'nin şekli önemli:** *"kaynağı belirsiz"* bir **kova değil, bir ETİKETTİR** —
kalem üç kovadan birine girer **ve** bu etiketi taşır. `[ÖLÇEMEDİM]`'in eşleme tablosundaki
hâli.

## `A3` · `F12` DÜZELTMELERİ — **aynı dokunuşta**
```
1  Section_05_Planning_First_Mode.md
     §5.3 başlığı  "40 KPIs" → gerçek sayı, F12 iziyle
     grup listesi  42 → 52   (NIV 3 + Turnover 4 + Gross Margin 3 geri)
     ⚠️ ESKİ METİN SİLİNMEZ — üstü çizilir (K-2.2.8c emsali:
        DONMUŞ BRD'nin ÖLÇÜMLE İKİNCİ düzeltmesi)
2  FAZ1_KAPANIS_BEYANI.md §9   33/30 → 24/27   (ZATEN İNDİ, append-only)
```

## `A4` · ⛔ DÖRDÜNCÜ KAYNAK — **repoda adresi yok**
`A1`-promptunun grup ağacı (**11 grup / 52 kalem**) **proje bilgisinde, repoda DEĞİL**.
> **Bir evren, kaynağı gösterilemiyorsa *"türetilmiş"* değil *"YAZILMIŞ"*tır** (`G5` ailesi).

⇒ **`DALGA-A`'nın ilk commit'i:** o grup ağacı `docs/research/` altına alınır
(**kaynağı ve tarihi yazılı**).

---

# `DALGA-B` · `T-293` + `T-291` — **BİRLİKTE**

## `B0` · DURUM `[ÖLÇÜLDÜ]` — ve `T-293` sayılarla kesinleşti

```
lta_agreements   0        lta_rates  0        lta_plan_overrides  0
agreements WHERE type='LTA'          1        ← FORM BURAYA YAZIYOR
LTACalculationService                ENJEKTE + GERÇEKTEN ÇAĞRILIYOR
  lta-agreement.controller.ts:238  calculateBaseLTASpend
  lta-agreement.controller.ts:265  calculatePlannedLTASpend
  (canlı rotalar: POST · GET · PATCH · activate · terminate · GET cpl/:id/active)
```

⛔ **Yani motor ÖLÜ DEĞİL — AÇ.** Rotası var, çağrılıyor, ama **okuyacağı tablolar boş**
çünkü **form başka tabloya yazıyor**. `Z38 §3`'ün *"bağ + eksik yüzey"* teşhisi **birebir**.

📌 **Ve bir arama dersi:** `LtaCalculationService` (küçük harf) → **sıfır**;
`LTACalculationService` → **üç dosya**. `DISIPLIN` **dördüncü vaka**.

## `B1` · `T-291` — dört `|| 0` düşüşü `[ÖLÇÜLDÜ]`
```
lta-calculation.service.ts:45   planSku.baseVolume    || 0
                          :46   sku.unitPrice         || 0
                          :120  planSku.plannedVolume || 0
                          :121  sku.unitPrice         || 0
```
⛔ **Yön TEHLİKELİ:** eksik fiyat ⇒ LTA harcaması **olduğundan KÜÇÜK** görünür
⇒ ROI **olduğundan İYİ**. `§2.5` ihlali.

## `B2` · ⛔ NEDEN AYRILAMAZLAR
> `T-293` **bağı** kurar; `T-291` bağın **taşıdığı sayının doğruluğunu** kurar.
> **Ayrı inerlerse `T-293`'ün pini `0`'larla YEŞİL GEÇER.**

## `B3` · PİN — **LTA TABAN ZİNCİRİNİ** ölçer
Referans belge `§1` taban kuralı:
```
on-invoice mekanik tabanı  =  GSV − LTA_On
```
⇒ Pin bu zinciri **uçtan uca** ölçer: `agreements`(LTA) → `lta_agreements`+`lta_rates`
→ `LTACalculationService` → `BASE_LTA_ON` → `BASE_TO` → mekanik tabanı.

⛔ **FIXTURE ŞART:** `lta_plan_overrides = 0` ve `lta_rates = 0` ⇒ **bugün bu yol HİÇ
KOŞMUYOR.** `T-273` vakası (*"cascade dizisi boş, yol hiç koşmadı"*) burada **iki tabloda
birden** duruyor. **Kalıcı değer taşıyan bir fixture kurulur.**

## `B4` · ROI-PAYDA TASARIM NOTU (`§6-3`)
> Payda = **yalnız promo-spend** (LTA hariç) **varsayılan**; ama **motorda sabitlenmez**
> — **tek noktadan** okunur, tenant-konfigür ekseni **olay-tetikli**.

⇒ Bu, `B`'nin **motor-bağı** işine dahil: bağ kurulurken paydanın **nereden okunacağı**
da kararlaştırılır. ⚠️ `İlke 1`: **konfigürasyon yüzeyi bugün AÇILMAZ** — yalnız
*"tek nokta"* kurulur.

---

## `1` · ⛔ ÜÇ HÜKÜM **İNDİ** (ürün sahibi, 2026-08-30)

| # | hüküm |
|---|---|
| 1 | **`A0'` ÖNCE** — ve sorusu keskinleştirildi *(yukarı bkz.)*: **"canlı-TO hangisi?"** |
| 2 | **PARALEL İNİŞ ONAYLI** — `A` = analiz + `F12` + rapor (**e2e YOK**) · `B` = kod dalgası |
| 3 | **MİGRATION TAHSİS EDİLDİ** → **`1817000000000`** *(`DALGA-B`)* |

### ⛔ HÜKÜM 2'NİN EK-SATIRI — `F12` DOKUNUŞLARI
```
B'nin migration'ı  ∩  A'nın F12 dokunuşları (Section_05, beyan)
  KESİŞİMSİZ  ⇒  TAM PARALEL          ← bugün ölçülen durum
  kesişirse   ⇒  F12'ler B-SONRASI tek commit
```
📌 `A` **meta-repo `docs/`**'a, `B` **submodule `src/`**'ye yazıyor ⇒ **farklı repo**,
kesişim yapısal olarak `∅`. Yine de `A` ajanı `docs/process/` altındaki **canlı brief'lere
dokunmaz** — yalnız `docs/research/` + `Section_05` + `FAZ1_KAPANIS_BEYANI §9`.
