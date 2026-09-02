# `W3` — BASELINE PLANLAMA MASASI

> **Tarih:** 2026-08-31 · **Kuran:** Team Lead · **Girdi:** iki ölçüm şeridi + `Z62`–`Z78`
> **Statü:** ⛔ **HÜKÜM BEKLİYOR** — bu belge karar vermez, **karar için ölçüm** sunar.
> **Kuyruk:** `DALGA-2 artıkları — yerleşim masada` (`§7`).

---

## `§0` · ⛔ ÖNCE BİR AD ÇAKIŞMASI — masayı bozabilecek cinsten

`W3` bu repoda **üç ayrı numaralandırmada** geçiyor:

| `W3` | nerede | ne |
|---|---|---|
| ✅ **`Faz-2` dalgası `W3` = BASELINE** | `Z62 §3` (`04_KARAR_KAYDI.md:6221`) | **bu masanın konusu** |
| ❌ **hat-içi `W3`** | `FAZ2_PLANLAMA_BRIEF.md:101` — baseline hattının **kendi** `W3`'ü = **DOĞRULAMA** adımı | her hattın kendi `W1..W4`'ü |
| ❌ `B3` RBAC dalgası `W3` | `B3B1_DALGA_PLANI_ONERI.md:228` vd. | `GET /users` göçü, ayrı program |

⚠️ **Ve dördüncü bir ad:** `KUYRUK_TRIYAJI §6` / `PLANLAMA_MASASI §5` aynı işi **`DALGA 4`**
diye anıyor. `Faz-2 W3` ≡ `DALGA 4`.

> ### **AYNI İŞİN DÖRT ADI VAR VE İKİSİ AYNI HARFİ KULLANIYOR.**
> `F8` ailesinin (*"aynı sayı dört yerde dört farklı"*) **ad** tarafı. Masanın ilk
> teslimatı bir kod değil, bir **adlandırma hükmü** olmalı.

---

## `§1` · GÜNDEM-1 — BASELINE HATTI TASARIMI

### `1a` · Hat şekli **zaten verilmiş** (`FAZ2_PLANLAMA_BRIEF.md:97-107`)
```
W1  ŞEMA       baseline tablosu (D3) — 12 ay tarihsel hacim   ⚠️ İlke 1: ölçülmemiş esneklik AÇILMAZ
W2  GİRİŞ      upload ucu + parse                             ⛔ YENİ PARSER YAZMA
W3  DOĞRULAMA  D2 SKU eşleme + D4 kapsam kapısı               ⛔ hesaplanamıyorsa AÇIK HATA
W4  YÜZEY      sayfa GERÇEĞİYLE doğar
```

### `1b` · ⛔ **VERİ ŞEKLİ HÜKMÜ CTPM'DE HİÇBİR GİRDİ YAPISINA OTURMUYOR** `[ÖLÇÜLDÜ]`

`Z74 §1` hükmü: **`tactic_values.sku_id` NULLABLE ANLAM KAZANIR** (`NULL`=FU değeri · dolu=EZME).

```
main şemasında tactic_values TABLOSU YOK          (information_schema, ölçüldü)
tactic_values TTM'in tablosu                      (T-345 raporu :50 — TTM'e DOKUNULMADAN)
CTPM karşılığı "VAR (FARKLI ŞEKİL)"               (T-345 :259)
```

⇒ Hüküm **TTM'in söz dağarcığıyla** yazıldı. `DISIPLIN`: *"port ederken davranış taşınır,
onu **doğru kılan bağlam** taşınmaz"* — burada taşınmayan şey **kolonun kendisi**.

**Bugünkü üç aday taşıyıcı `[ÖLÇÜLDÜ]`:**

| aday | bugünkü şekli | SKU ekseni | maliyet |
|---|---|---|---|
| `plan_fus.tactics` | `jsonb`, **GİRDİ**, FU düzeyi (`{'CPP_ON_PCT': 10}`) | ⛔ YOK | şemasız ama **tipsiz**; `jsonb` içinde eksen açmak guard'sız |
| `plan_mechanic_values` | `entered_rate_pct/unit_amount/total_amount`, **GİRDİ** | ⛔ YOK — `UNIQUE(plan_fu_id, mechanic_id)` | **MIGRATION**: `plan_sku_id` + UNIQUE revizyonu |
| `mechanic_spend_breakdown` | `calculated_amount`, **TÜRETİLMİŞ ÇIKTI** | ✅ **VAR** — `UNIQUE(plan_sku_id, mechanic_id)` | migration yok, ama **girdi/türev ayrımını çiğner** |

⛔ **Üçüncüsü cazip ve tuzak:** ekseni hazır, ama o tablo **hesabın çıktısı**. Girdiyi oraya
koymak, `DISIPLIN`'in *"denetlenen ≠ okunan"* ekseninin veri tarafındaki ihlali olur —
**bir satır hem kaynak hem sonuç** olamaz.

📌 Ve `Z78 §1a` bunu zaten yazmıştı: *"`Z74`'ün SKU tarafı **henüz şemada yok**; geldiği gün
evren büyür ⇒ **adlandırılmış tek sabit**"*. Masa o günü **bugün** yapıyor.

### `1c` · `Q20` ÜÇLÜSÜNÜN IMPORT'A UYGULANMASI — **açık soru, ve hüküm gerektiriyor**

`Q20` satır olgusunu üçe ayırdı: **DOKUNULMAMIŞ · KISMİ · DOLU.** Import bunu **kimin**
ürettiğini değiştiriyor:

```
bugün      satır elle doğar (grid hücresi)   ⇒ "dokunulmamış" = planner girmedi
W3 sonrası satır IMPORT'tan doğar            ⇒ "eksik alan" = DOSYADA yoktu / EŞLEŞMEDİ
```
⛔ **İkisi aynı olgu DEĞİL.** Import edilen bir satırda `PLAN_VOL` eksikse bu *"planner
henüz girmedi"* mi, *"kaynak dosyada yoktu"* mu, *"SKU eşleşmedi"* mi? `Q20` üçlüsü
**dördüncü bir olguya** genişlemek zorunda olabilir. **Hüküm gerekiyor.**

### `1d` · PARSER — emsal **DÖRT**, ve biri diğerlerinden dar `[ÖLÇÜLDÜ]`
```
common/services/csv-parser.service.ts                    96 sat   CSV-only   tüketici: sales-actuals + seed
customer/services/file-parser.service.ts                698 sat   XLSX+CSV
on-invoice/services/on-invoice-file-parser.service.ts   741 sat   XLSX+CSV
agreement-transaction/.../off-invoice-file-parser.ts    634 sat   XLSX+CSV
```
Son üçü **import blokları satır-satır aynı**, yalnız DTO satırında ayrışıyor; **ortak taban
sınıf yok**. ⇒ `A3`'ün *"yeni parser yazma"* kuralı doğru, ama **hangisini** okuyacağı da
söylenmeli: `sales-actuals` yolu **XLSX kabul etmiyor**.

### `1e` · KISMİ KABUL **DÖRT YOLDA DA** `[ÖLÇÜLDÜ]`
`sales-actuals` (`:115-119`) · `off-invoice batchImport` (`:279-305`) · `on-invoice
processBatch` (`:553-606`) · `customer import` — **dördü de** geçerli satırları yazıp
geçersizleri raporluyor; rollback yok. Tek *tümü-ya-hiç* anı `sales-actuals`'ın
`dataSource.transaction`'ı (`:160`) ve o **zaten filtrelenmiş** satırları sarıyor.
⇒ **`W3` bu emsali izlerse baseline de kısmi kabul olur** — ve `D4` kapsam kapısıyla
**etkileşir** (kısmi kabul, kapsamı düşürür). **Hüküm gerekiyor.**

---

## `§2` · GÜNDEM-2 — `≥%95` KAPISI

### `2a` · ⭐ EŞİK SORUSU **AÇIK DEĞİL — ÇÖZÜLMÜŞ** `[TL DOĞRULADI]`
```
%95  KAPI      Section_10 §10.2 Gate 2 + Glossary + L2_02:55 "| Tamlık | ≥ %95 |"
%80  AZALTMA   Section_11 §11.3 R3 mitigation (baseline yoksa) ≡ Addendum H4 MVB-2
⇒ ÇELİŞKİ DEĞİL — hedef + contingency çifti
```
⛔ **Ve bu masanın kendi ölçüm şeridi burada YANILDI:** *"iki kaynak birbirini yalanlıyor"*
diye raporladı — oysa cevap **alıntıladığı dosyanın 20 satır aşağısındaydı** (`T-024.md:78`
`⚠️ DÜZELTME`, `:99` `✅ ÇÖZÜLDÜ`). Ve dosya okuyucusunu **isim isim** uyarıyor:
> *"Bu task **iki kez** düzeltildi: önce 'kapı %80' (tek kaynak genellemesi), sonra
> 'çelişki' (**üçüncü kaynağı aramadan**). Doğrusu bu."*

⇒ ⛔ **YENİ DİSİPLİN VAKASI — `FAZ TABLOSU` kuralının kardeşi:**
> ### **KENDİ DÜZELTME GEÇMİŞİNİ TAŞIYAN BİR BELGE, ERKEN DURAN OKUYUCUYU HÂLÂ YANILTIR.**
> Ve yanıltma **eski hatayı yeniden üretir** — burada *"turu 16"*nın hatası **üçüncü kez**.

### `2b` · KODDA **SIFIR** UYGULAMA `[ÖLÇÜLDÜ, POZİTİF KONTROLLÜ]`
`0\.95|>= ?95|95 ?%|%95` → backend `src/` içinde **4 eşleşme, dördü de yorum** ve dördü de
**bütçe eşiği** merdivenine ait. `submission-checks.ts`'in yedi kontrolünün hiçbiri kapsama
oranına bakmıyor. *(Poz. kontrol: aynı desen şekli `ragStatus ===` için eşleşme üretti.)*
⇒ **Belgede bağlayıcı bir ONAY KAPISI, kodda hiç yok.**

### `2c` · `coverage_ratio` AD ÇAKIŞMASI — **dalganın yazılı ilk işi**
`plans.coverage_ratio` bugün **KPI toplama kapsaması** (`|kesişim|/|çocuk|`,
`kpi-engine.service.ts:572`), `D4` kapsam kapısı **değil**. Tek karşılaştırması `!== 1`
(`:456`); `0.95` ile karşılaştıran **tek satır yok**.
`FAZ2_PLANLAMA_BRIEF.md:91-93`: *"dalganın ilk işi bu ayrımı `EK_C`'ye yazmak"* — **bugün
yapılmamış.**

---

## `§3` · GÜNDEM-3 — `T-346` ELIGIBILITY, ve grid iki kez mi dokunuluyor

`T-346` **açık** (`status: todo`, `P1`) ve **beş soru** taşıyor; kendi kabul ölçütü
*"`S2`–`S6` hükme bağlandı — **kod bundan ÖNCE başlamaz**"*:

```
S2  Uygunluk ekseni kaç boyutlu?   (applicableCpls + exclusionRules + mutuallyExclusiveWith)
S3  Uygun olmayan tactic REDDEDİLİR mi, LİSTEDEN DÜŞER mi?     ⇒ UX kararı
S4  Uygunluk kuralları hangi yüzeyden yönetilir?  (CSV / form / ikisi)
S5  `Calc Type` ekseni nerede yaşar?
S6  `spend_type='BOTH'`ın bütçe-kapısındaki karşılığı           ⇒ zarf tarafında BOTH YOK
```
⛔ **Beşi de `W3`'ün önünde.** Ve `S6` bir **sessiz eşleşmeme** riski taşıyor — `§2.5` ailesi.

**Grid kesişimi — masanın sorusu:** `W3`'ün `W4` (yüzey) adımı ile `T-346`'nın grid işi
**aynı dosyaları** tutuyor (`PlanningGridEnhanced.tsx`, `grid-cells.tsx`).
⇒ **Ya aynı dalgada birleşir, ya grid iki kez açılır.** `CLAUDE.md §4`'ün `touches:`
kesişim kuralı ikisini **paralel çalıştırmayı yasaklıyor**.

---

## `§4` · GÜNDEM-4 — VERİ-SIFIR YEŞİLİ: ATEŞLEME DALGASI ADAY LİSTESİ `[ÖLÇÜLDÜ]`

`main` şemasının **47 tablosu** kesin sayıldı (`count(*)`; ⚠️ `n_live_tup` **yanılttı** —
`on_invoice_entries` tahmin `2`, gerçek `0`).

| tablo | bugün besleyen yol | sınıf |
|---|---|---|
| **`plans` · `plan_fus` · `plan_skus` · `plan_mechanic_values`** | recalc · spend-calculation · kpi-engine · lta-calculation · finance-reporting · **bütçe rezervasyonu** | 🔴 **ANA DALGA** — planning-first zincirinin **tamamı** bugün `0` satırda koşuyor |
| `plan_approval_history` | approval-workflow | 🟠 |
| `mechanic_spend_breakdown` | spend-distribution · finance-reporting | 🟠 tüketici **var**, veri yok |
| `lta_agreements` · `lta_rates` | lta-calculation · `base_lta_*` zinciri | 🟠 **zincir hiç koşmadı** |
| `claims` · `claim_matches` · `tactic_realizations` · `lta_plan_overrides` | **üretim tüketicisi SIFIR** | ⚪ veri gelse de kimse okumaz |

**Risk notu birebir (`Z68 §3b`, `W3` brief'ine ZORUNLU):**
> **VERİ-SIFIR DÜNYADA YEŞİL OLAN HER ŞEY, İLK GERÇEK DEĞER-DAĞILIMINDA YENİDEN
> SINANMAMIŞ DEMEKTİR.**

**Aday listesi `T-341`'den GENİŞ** (`T-341` kapandı): `T-347` (blok yorumu beyaz listeyi
geçiyor, TL doğruladı) · `T-102` (hata-`null` ↔ kural-`null` ayırt edilemiyor) ·
`T-099` (`Number.isNaN(Infinity)===false`, dört canlı para yolu).

⚠️ **Metodolojik uyarı, ölçüm şeridinden:** ilk tarama `LtaAgreement` kasasıyla **sıfır**
döndürdü ve *"tüketici yok"* diye raporlanacaktı; doğru kasa (`LTAAgreement`) **28** üretim
referansı verdi. `DISIPLIN`: *"arama terimi, aranan yerin diliyle seçilir"* — burada **dili
kasa belirledi**.

---

## `§5` · GÜNDEM-5 — `7b` RANDEVUSU: `calculateAllSpendsForFU`

**Cevap ölçüldü: `W3`'ün ona İHTİYACI YOK.**
```
plan.service.ts:2632  for (const planSku of planFu.planSkus || [])
              :2685    → calculateAllSpendsForSKU(..., cachedActiveMechanics, cachedLtaContext)
⇒ FU-TOPLU HESAP ZATEN VAR, sadece plan.service içinde (önbelleklenmiş bağlamla)
üretim çağıranı: SIFIR (yalnız *.spec.ts + yorum atıfları)
```

⛔ **AMA ÖLÜMÜ ACELE DEĞİL, AYRIŞMASI ACİL:**
```
plan.service     kind !== 'UNTOUCHED' && ctx !== null ⇒ ÇAĞIRIR ⇒ taban zinciri KOŞAR
FU metodu        kind === 'NOT_EVALUABLE' ⇒ continue  ⇒ satırı ATAR ⇒ FU tabanı AYRIŞIR
```
> ### **`W3` `plan_skus`'u İLK KEZ GERÇEK `NOT_EVALUABLE` SATIRLARLA DOLDURUYOR —**
> ### **YANİ BU AYRIŞMANIN CANLIYA ÇIKMA ANI TAM OLARAK `W3`'TÜR.**

⇒ Karar **koşul satırıyla**: *ölürse* `W3` öncesi ölür; *yaşarsa* `NOT_EVALUABLE` davranışı
**recalc'in şekline getirilir** — ikisi arası bir seçenek yok, çünkü ikisi arası
*"aynı plan iki farklı FU tabanı"* demek (`T-049` postmortem'i).

---

## `§6` · GÜNDEM-6 — OMURGA SENARYO: ⛔ **GÖVDESİ YAZILI DEĞİL**

```
5. adım  ✓  Z74 §2 — "FU'ya girilen oran SKU'larda GÖRÜNÜR; bir SKU'da EZİLİR; spend AYRIŞIR"
            ⛔ ve bu bir senaryo DEĞİL, bir PİN SÖZLEŞMESİ: fixture ezme olan VE olmayan
               SKU'yu birlikte taşır, assertion spend'in AYRIŞTIĞINI okur
6. adım  ✓  Z75 — "planner'ın spend dağılımını görmesi omurga akışın 6. adımının parçası"
            ⇒ K-2.1.8i taşıyan uç KABLOLANIR
1-4      ⛔  HİÇBİR YERDE YOK
```
**Arandı:** `docs/**` + `.claude/**` + **oturum transkripti** (26 MB) — terimler `omurga` ·
`OMURGA` · `SC-mech` · `adım`. Bulunan **her** geçiş bir **atıf**; gövde yok.

> ### **BİR UÇ, YAZILMAMIŞ BİR BELGEYE DAYANARAK KABLOLANMAYA KARAR VERİLDİ** (`Z75`).
> `EK_E`'nin **🔒** sınıfının belge tarafı: *"yetenek var, arayüzü yok"* değil —
> **"ölçüt var, metni yok."**

⇒ **1-4. adımlar ürün sahibinden alınır.** Masa onları **uydurmaz**.

---

## `§7` · GÜNDEM-7 — `DALGA-2` ARTIKLARININ YERLEŞİMİ

| kalem | masadaki yeri | gerekçe |
|---|---|---|
| `7b` sözleşme sapması | ⇒ **`§5` ile aynı karar** | zaten *"RANDEVU: `W3` kararı"* etiketli |
| `🟡-5` `incrementalVolume` üç türetimi | ⇒ **`W1`/`W4` ile birlikte** | `W3` `base_volume` yazacak ⇒ `incremental = planned − base` **ilk kez gerçek** olur; üç türetim o gün ayrışır |
| `🟡-7` `src/common/` → `src/modules/` yönü | ⇒ **bağımsız, `W3` sonrası** | `W3`'ün yüzeyine değmiyor |
| `🟢-1` ölü `SPEND_INPUT_FIELDS` · `🟢-5` lumpsum `Number(...)\|\|0` | ⇒ `🟢-5` **`W3` öncesi** | lumpsum ağırlığı `base_volume`'e bakıyor; `W3` onu **ilk kez NULL-dışı** yapacak |
| **`19↔16` sayım borcu** (`Z78 §8`) | ⇒ **ucuz arkeoloji**, `DALGA 1` tahliyesiyle | `git log` + test-sayım diff'i; tek başına tur hak etmiyor |

---

## `§8` · ⛔ MASANIN KENDİ BULGULARI — üçü de **yeni**, üçü de `W3`'ü etkiliyor

### `8a` · 🔴 ALTI `*_spend` KOLONUNUN **ÜRETİM YAZARI YOK** — VE İKİSİ **OKUNUYOR**
```
finance-reporting.service.ts:584-585   spendOf(planSku.plannedLtaOnInvoiceSpend)
                                       spendOf(planSku.plannedLtaOffInvoiceSpend)
yazan?  lta-calculation.service.ts     değerleri DTO DÖNÜŞ NESNESİNE koyuyor, plan_skus'a YAZMIYOR
recalc? plan.repository.ts:630-637     Pick<> listesi: incrementalVolume · plannedTurnover ·
                                       tacticSpend · plannedGp · gpRoi · ragStatus · calculatedKpis
                                       ⇒ ALTI KOLONUN HİÇBİRİ YOK
```
⇒ **Finans raporu, hiç kimsenin yazmadığı iki kolonu okuyor ⇒ bugün daima `0`.**
`T-270`'in ailesi (*"canlı finansal ekranda yanlış rakam"*), ve ⛔ **`W3` bunu DÜZELTMEZ —
GÖRÜNÜR KILAR**: `plan_skus` dolduğunda kolonlar hâlâ `0` kalır, ama artık **yanında dolu
satırlar** olur.

### `8b` · 🔴 FRONTEND, BACKEND'İN REDDETTİĞİNİ **SESSİZCE `0`'LIYOR** `[ÖLÇÜLDÜ: 40 VAKA]`
```
PlanningGridEnhanced.tsx   baseVolume ?? 0 / || 0   → 40 KEZ
```
Backend `Z77`/`Q20` ile `null` propagasyonuna geçti; istemci **hâlâ sessiz sıfıra** düşüyor
⇒ `NOT_EVALUABLE` bir satır ekranda **`0` olarak** görünür, *"hesaplanamadı"* olarak değil.
> **`Q20`'nin bütün işi, GÖRÜNTÜ katmanında geri alınıyor.**
`W3` gerçek eksik-veri satırları ürettiğinde bu **kullanıcının gördüğü ilk şey** olur.

### `8c` · FRONTEND'DE `baseline` KELİMESİ **HİÇ GEÇMİYOR** `[POZİTİF KONTROLLÜ]`
```
grep -rni "baseline" collmind.frontend/src/   →  0     ⟵ negatif
grep -rni "on-invoice" collmind.frontend/src/ →  79    ⟵ POZİTİF KONTROL
```
Ve `POST /actuals-first/sales-actuals/upload` ucunun **frontend tüketicisi yok**
(`sales-actual` → `0` eşleşme). ⇒ *"mekanizma var, yol yok"* ailesinin **dokuzuncu** vakası.
Baseline'ın bugünkü **tek** girişi: `PlanningGridEnhanced.tsx:1030` grid hücresi →
`PATCH .../volume`.

---

## `§9` · ⛔ KARAR GEREKTİRENLER — ürün sahibine

```
W1  ADLANDIRMA       "W3" dört ada sahip, ikisi aynı harf. Kanonik ad nedir?
W2  VERİ ŞEKLİ       Z74'ün SKU-override'ı hangi taşıyıcıya iner?
                     (a) plan_mechanic_values + plan_sku_id  → MIGRATION
                     (b) plan_fus.tactics jsonb içinde eksen → tipsiz, guard'sız
                     (c) mechanic_spend_breakdown            → eksen hazır, GİRDİ/TÜREV İHLALİ
                     TL görüşü: (a) — üçüncüsü bir satırı hem kaynak hem sonuç yapar
W3  IMPORT OLGUSU    Q20 üçlüsü import'ta DÖRDE mi çıkar?
                     ("dosyada yoktu" ≠ "SKU eşleşmedi" ≠ "planner girmedi")
W4  KISMİ KABUL      baseline dört emsali izleyip kısmi kabul mü, tümü-ya-hiç mi?
                     ⇒ D4 kapsam kapısıyla ETKİLEŞİR
W5  OMURGA 1-4       gövde senden gelmeli — masa uydurmaz
W6  T-346 × GRID     aynı dalgada mı, grid iki kez mi açılır?
W7  7b               calculateAllSpendsForFU: ölüm mü, recalc şekline hizalama mı?
                     ⇒ ayrışmanın canlıya çıkma anı W3'ün KENDİSİ
W8  8a / 8b          altı yazarsız kolon ve FE'nin 40 sessiz sıfırı — W3'ün İÇİNDE mi,
                     ÖNCESİNDE mi? TL görüşü: 8b ÖNCE (kullanıcının göreceği ilk şey)
```

---

## `§10` · `ÖLÇEMEDİM` — masanın kendi sınırları

- **Omurga 1-4. adım** — arandı (üç yüzey, dört terim), **yok**. Uydurulmadı.
- **`T-333` `TZ` ölçümü** — **dört** turdur *"ölçemedim"* olarak kayıtlı; bu masa da ölçmedi.
- **`19↔16` farkı** (`Z78 §8`) — hâlâ **çözülmemiş**; kapanışı `§7`'ye yerleştirildi.
- **`EK_C`'de `coverage_ratio` ayrımı** — *"dalganın ilk işi"* yazılı, **yapılmamış**; masa
  bunu **doğruladı ama kendisi yapmadı** (belge donmuş, `04_KARAR_KAYDI` dışı yazım yasak).
- **Şerit hatası kayda:** ölçüm şeridi `§2a`'da **çözülmüş bir soruyu açık** raporladı.
  Team Lead yakaladı. ⇒ `Z78 §4`'ün kuralı (*"bir ajan bulgusu da bir iddiadır"*) bu masada
  **ikinci kez** iş gördü.
- **`ŞART-6` kalan dördü** (`iGSV` · `LTA_On_Pct` · `LTA_Off_Pct` · `TotalPlannedSpendOff`)
  ölçüldü ve **hiçbirinin task'ı yok** — hepsi *"canlıda hesaplanıyor, KPI olarak
  doğmuyor"* ailesinden. Kuyruk karşılığı **üretilmedi**; `Z75 §2`'nin sınıfı
  (*"verilen hükümlerin de indeksi sürükleniyor"*).
