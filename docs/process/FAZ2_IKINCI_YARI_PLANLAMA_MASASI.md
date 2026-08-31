# `FAZ-2` İKİNCİ YARI — PLANLAMA MASASI

> **Tarih:** 2026-08-31 · **Yazan:** Team Lead · **Statü:** karar-bekleyen
> **Girdiler:** `KUYRUK_TRIYAJI.md` · `FRONTEND_DURUM_ENVANTERI.md` ·
> `TTM_ELIGIBILITY_ENVANTERI.md` · `KPI_EVRENI_TURETILMIS_LISTE.md` · `Z62`–`Z74`
> **İşaretleme:** `[ÖLÇÜLDÜ]` TL birinci elden · `[AJAN]` ölçüm ajandan, doğrulanmadı

---

## `§0` · ZEMİN — `W2`'nin hasadı

```
KANONİK FORMÜLLER   TO/NIV ayrıştırıldı · GP tabanı TO · off-invoice tabanı NIV
                    ROI paydası BÖLÜNDÜ (bütçe TOTAL okur, ROI INCR_PROMO okur)
KADRAN RAG          iki eksen · AMBER "kârsız büyüme" · LTA_ONLY tanımlı-yokluk
TEK SUBMIT YOLU     /submit  (SubmissionResult'ı aldı) · /submit-for-approval ÖLDÜ
                    ⇒ Q13 uyarıları CANLI YÜZEYE ilk kez çıktı
ELIGIBILITY KEŞFİ   TTM envanteri: bu bir PORT değil, BAĞLAMA işi
İKİ LATENT KUSUR    parser sessiz-null (iki negatif operand) · targetRoi dizge çökmesi
```
**Kapı durumu `[ÖLÇÜLDÜ]`:** `e2e 843/843` · `unit BE 1318` · `FE 589` · `tsc BE/FE 0` ·
`guards EXIT 0` · ratchet'ler temiz · `T-047 PASS`.

---

## `§1` · `ŞART-6` × `T-334`/`T-342` KESİŞİMİ `[ÖLÇÜLDÜ]`

```
KAPANDI (2)    INCR_NIV · INCR_TO          ← main.kpis'te CANLI
KALAN (4)      iGSV · LTA_On_Pct · LTA_Off_Pct · TotalPlannedSpendOff
POZ. KONTROL   `LTA` içeren dört kod VAR (hepsi TUTAR, yüzde DEĞİL) ⇒ tarama kör değil
canlı kpi      29 aktif + 3 pasif = 32     (24 + T-334'ün beşi ✓)
```
⛔ **Kalan dördü tek aile:** *"hesaplanıyor ama KPI olarak DOĞMUYOR"* — `T-334`'ün
formül-kanon işinden **farklı bir iş sınıfı**. En acili **`TotalPlannedSpendOff`**
(iki türetim + iki sessiz sıfır).

---

## `§2` · KUYRUK GERÇEĞİ `[ÖLÇÜLDÜ ×3]`

```
358 task · 99 done · 259 NON-DONE      ⛔ ama 65'i "review" = İNMİŞ, kapatılmamış
GERÇEK AÇIK 194 · triyaj edilen 48
A canlı-yanlış 11 · B pencere 16 · C kapı-körlüğü 10 · D borç 8
KAPANMIŞ AMA AÇIK GÖRÜNEN  9  ·  indeks sürüklenmesi  8
```
> **Kuyruğun `259`'u bir hacim değil, bir MUHASEBE ARTIĞI.**

**TL'nin doğruladığı üç kalem** — tam metin `KUYRUK_TRIYAJI.md §7`:
`spend-validation:41-44` (`50/30/60/80` **hardcode**, yorumu *"Configurable"* diyor) ·
`T-099` (sağlayıcı **inmiş**, kilit **bayat**) · `T-240` (erteleme gerekçesi **çürüdü**:
task *"`ledger_entries` 0 satır"*, **canlı 3**).

---

## `§3` · FRONTEND'İN HÂLİ `[AJAN, iki kalem TL doğruladı]`

| bulgu | sayı |
|---|---|
| **tanımlı ama ÇAĞRILMAYAN uç** | **20 uç / 8 dosya** — `spend-calculation.endpoints.ts`'in **sekizi de** ⛔ `[ÖLÇÜLDÜ]` sıfır tüketici *(poz. kontrol: `planEndpoints` **16 dosyada**)* |
| `EK_E`'nin `🔒` kalemleri | 3'ten **2'si aynen duruyor**, 1'i **yarı açıldı** ⇒ **`EK_E` bayat** |
| sessiz sıfır | `toNumberOrZero` 64/19 · `?? 0` **269/10** *(197'si TEK dosyada)* · sınıf **`A`=7** |
| ölü/ikiz modül | **12** üretim tüketicisi yok · bütçe RAG merdiveni **ÜÇ ayrı kopya** |
| hardcode eşik | **9 karar** · **ÜÇ farklı merdiven** (`<80/<95` · `≥80/≥100` · `≥95/≥80`) |
| menü | **4 link 404'e gidiyor** `[ÖLÇÜLDÜ]` (`/reports /analytics /calendar /products` — rota tanımı **sıfır**) |
| rol | `READONLY` `Sidebar.tsx:589 defaultNavigation`'a düşüyor `[ÖLÇÜLDÜ]` ⇒ `Z43`'ün açtığı 11 rotayı **menüde göremiyor** |

### ⭐ İKİ YENİ SINIF
**`3a` · *"Bir test ÖLÜ kodu CANLI gösteriyor."*** `ProfitabilityChart`/`RecentTransactions`
üretimde çağrılmıyor **ama testleri `dummyData`'yı ŞARTNAME olarak pinliyor**.
> `T-084`'ün test tarafı: **bir ölü yolu pinlemek, onu canlı sanmaya yol açar.**

**`3b` · *"`🔒` yalnız ARAYÜZ eksikliği değil, ROTA ve ROL eksikliği de olabilir."***
`/finance` — **8 widget'lık tüm finans paneli** — menüde **yok**. `EK_E` bunu `❌`/`🔒`
eksenlerinden **hiçbirinde** görmüyor.

---

## `§4` · `W3` ÖNÜ — dokuz önkoşul, biri **açılmamış**

`T-341` · `T-337` *(⛔ `T-027` **ürün sahibi kararı**)* · `T-338` · `T-335` · `T-336` ·
`T-333` *(kapanmak değil **SINIFLANDIRILMAK** zorunda)* · `T-325` · `T-339` ·
**`T-346`** *(⛔ **dosyası yok** — `Z74 §2` W3 veri şeklini ona bağladı)*

**Veri-sıfır körlüğü adayı: 10.** `plans/plan_fus/plan_skus/lta_* = 0`, `tenants=1`.

---

## `§5` · DALGA PLANI — her dalganın **öncülü yazılı**

```
DALGA 0   KUYRUK MUTABAKATI            kod YOK · tam paralel-güvenli
          9 kapanmış iş kapatılır · 8 indeks sürüklenmesi düzeltilir
          T-346 AÇILIR · birleştirmeler işlenir (T-118/T-180/T-134)
          ⛔ VE: "review = inmiş" genellemesi 65'ten ÜÇ vakayla kuruldu ⇒ 62'si ÖLÇÜLÜR
          ÖNCÜLÜ  yok — diğer HER dalganın GİRDİSİ

DALGA 1   REVIEW TAHLİYESİ (dar)       T-316…T-345 arası ~20 kalem
          ÖNCÜLÜ  Dalga 0
          NEDEN   W3 pinlerinin ZEMİNİ; W3'te bir kırmızı çıkarsa
                  kapanmamış inişlere ATFEDİLEMEZ

DALGA 2   W3 ÖNKOŞULU — FORMÜL/SPEND
          2a  T-230(SAYIM) → T-337 → T-338      [SIRALI, aynı dosya]
          2b  T-341 + T-102 + T-099             [SIRALI, aynı parser]
          2c  T-335 → T-336                     [SIRALI, aynı lta modülü]
              ⇒ 2a ∥ 2b ∥ 2c  (touches kesişimi ∅)
          ⛔ brief'lere "doğrulamanı İZOLE git worktree'de yap" — aynı test ağacı
          ⛔ T-337 KODLA BAŞLAMAZ: T-027 ürün sahibi kararı

DALGA 3   ÖLÇÜM KAPILARI               T-325 · T-339 · T-308 · T-262
          ÖNCÜLÜ  Dalga 2 — T-339'un TÜRETTİĞİ Alan A evreni Dalga 2'nin
                  dokunduğu dosyaları İÇERMELİ; önce koşarsa evren EKSİK doğar (G5)

DALGA 4   W3 BASELINE
          ÖNCÜLÜ  Dalga 2+3 + T-333 sınıflandırması + T-346 açılmış olması
          ŞART    Z68 §3b risk notu brief'e YAZILI · T-341 pini RANDEVU olarak taşınır

ŞERİT A'  CANLI-YANLIŞ                 dalga-bağımsız, HEMEN
          spend-validation 50/30/60/80 · T-280 · T-279 · T-295 · T-311 · T-310 · T-135
          + FE: Sidebar (READONLY + /finance + 4×404) · bütçe RAG (sessiz sıfır + hardcode)
          NEDEN AYRI  T-318 emsali: "CANLI-YANLIŞ ÖNCELİK ALIR"

ŞERİT B'  BORÇ                         en son · T-240'ın öncülü ÖNCE yeniden ölçülür
```

---

## `§6` · ⛔ KARAR GEREKTİRENLER — **ürün sahibine**

| # | karar | neden şimdi |
|---|---|---|
| **`K1`** | **`T-027` yeniden açılıyor mu?** (canlı spend yolunda `?? 0`) | `T-337` **kodla başlayamaz**; `W3` önkoşulu ve **bütçe eşiğini** besliyor |
| **`K2`** | `plan.service:2915`'in **`20.0` fallback**'i — kalsın mı? | `B3` ile **aynı aile**; `T-344` bilinçli korudu, kendi sözleşmesi var |
| **`K3`** | **`EK_E` bayat** — güncellensin mi, yoksa `FRONTEND_DURUM_ENVANTERI` mi kanonik olsun? | `🔒` sayımı **yanlış**, ve **rota/rol ekseni** hiç yok |
| **`K4`** | **`spend-calculation.endpoints.ts`** — 8 uç kablolansın mı? İçinde **MVP şartı `K-2.1.8i`** var | `§3`'ün **en acil** kalemi; `W3`'ün dağıtım görünürlüğü buna bağlı |
| **`K5`** | **Ölü kod + uydurma veri** temizliği — bir karar ister, çünkü **testler uydurma veriyi pinliyor** | `§3a`: bir test ölü kodu **canlı gösteriyor** |
| **`K6`** | Dalga planı **onaylanıyor mu**, `ŞERİT A'` gerçekten **paralel** mi insin? | `A` sınıfı 11 kalem, `touches` kesişimi `∅` |

---

## `§7` · `ÖLÇEMEDİM` — masanın kendi sınırları

1. **~150 `todo` satır düzeyinde ölçülmedi** — `§2` tipinde **daha fazla kapanmış iş olması olası**
2. **`review` `65`'ten `3`'ü örneklendi** — `62`'si **doğrulanmadı**
3. FE raporu **tamamen statik** — *"pinli"* denen testlerin **geçtiği** ölçülmedi
4. FE ulaşılamazlık iddiaları **dizge tabanlı** — **şablonla kurulan** bir yol taramadan **kaçar**
5. `T-346`'nın kapsamı `Z74 §2`'den **okundu**, ürün sahibi niyetiyle örtüşmesi doğrulanmadı
6. `T-333` `TZ` ölçümü **yapılmadı** — task'ın **kendi** kabul ölçütü
7. `T-273`'ün kapandığı **doğrulanamadı** (`lta_plan_overrides=0` ⇒ reprodüksiyon imkânsız)
