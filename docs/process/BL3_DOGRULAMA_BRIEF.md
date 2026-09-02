# `BL-3` — DOĞRULAMA (`D2` SKU eşleme + `D4` kapsam kapısı)

> **Girdiler:** `Z79 §4` · `Z84` · `Z85 §3` · `Z86` · **`Z87`** (red satırlarının evi + iki metrik)
> **Ön koşul:** `BL-2` **kapandı** (`3c6d23b`) — upload + parser + iki pin canlı.
> **Kapandığında:** `D2` (eşleme) + `D4` (coverage) **biter**; geriye **`BL-4`** (yüzey) kalır.

---

## `§0` · HAT

```
ön iş  ✅ T-333 TZ ölçümü                          676ff7f
BL-1   ✅ ŞEMA (baseline_volumes + batches)        d6c83e7 · Z84 + Z85
BL-2   ✅ GİRİŞ (upload + parser + PİN 1/PİN 2)    3c6d23b · Z86
BL-3   ⬅ DOĞRULAMA                                 BU BELGE
BL-4     YÜZEY
```

---

## `§1` · ADIM 1 — `import_batch_rows` MIGRATION (`Z87 §1`)

⛔ **`data-engineer` yazar.** Numara **`1823000000000`** TAHSİSLİ (`MIGRATION_SEQUENCE`).

```
batch_id FK RESTRICT · row_no · raw jsonb (hücre-ham)
status   ENUM(ACCEPTED, REJECTED)
reason   ENUM(SKU_NOT_FOUND, CPL_NOT_FOUND, INVALID_PERIOD, INVALID_VALUE, DUPLICATE)
resolved_sku_id / resolved_cpl_id  NULLABLE — kabul edilende DOLU (baseline_volumes'a KÖPRÜ)
GRANT  SELECT + INSERT · ⛔ UPDATE/DELETE YOK (satır IMMUTABLE)
RLS    tenant_id + politika TANIMLI / ENABLE KAPALI   (BL-1 · Z85 §2 deseni)
```

⛔ **ŞART — `ACCEPTED` SATIRLAR DA BURADA YAŞAR** (`Z87 §2`):
> Yalnız red kaydedilirse **`sourceMatchRatio`'nun PAYDASI kaybolur** ve *"kabul edilen
> satır **hangi kaynak satırdan** geldi"* izi **kopar**.
Köprü: `baseline_volumes` ↔ `batch_id` + `row_no`.

⚠️ **AD KONVANSİYONUNU ÖLÇ:** ürün dilinde `import_batch_rows`; kardeşi
`baseline_volume_import_batches`. Konvansiyondan **sapıyorsan gerekçe yaz** (`F8`).

---

## `§2` · ADIM 2 — `≥%95` KAPISI, **KATALOG PAYDASINDAN**

`Z85 §3` + `BL-2`'nin **`PİN 2`**'si üstüne:
```
coverageRatio  =  KABUL EDİLMİŞ baseline  /  KATALOG evreni
                                              aktif-SKU × aktif-CPL × 12-period
                                              [G5: TÜRETİLMİŞ evren]
```
⛔ **Pasif SKU/CPL paydaya GİRMEZ** · ⛔ **reddedilen satır tabloda YOK ⇒ paydada
"EKSİK" GÖRÜNÜR** — `Z79 §4`'ün *"payda toplam evren"* hükmü **böyle** karşılanır.
> **Yoksa *"kötü satırları atıp kabul-edilenlerin %95'i"* oyunu doğar.**

**Eşik `[ÇÖZÜLMÜŞ — yeniden açma]`:**
```
%95  KAPI      Section_10 §10.2 Gate 2 · Glossary · L2_02:55
%80  AZALTMA   Section_11 §11.3 R3 mitigation ≡ Addendum H4 MVB-2
```
⛔ Kapsam **hesaplanamıyorsa AÇIK HATA** — sessiz geçiş YOK (`§2.5`).

### `2a` · ⛔ `coverage_ratio` AD ÇAKIŞMASI — **BU ADIMDA KAPANIR**
`plans.coverage_ratio` bugün **KPI toplama kapsaması** (`kpi-engine.service.ts:572`),
`D4` kapsam kapısı **DEĞİL**. `BL` brief'i bunu *"dalganın ilk kod işi"* diye kaydetmişti.
```
1  ayrım EK_C'ye yazılır
2  YENİ alan AYRI adlanır — aynı adı ikinci anlamla yüklemek F8 ailesidir
```

---

## `§3` · İKİ METRİK, İKİ AD — VE **ÖZET KOLON YOK** (`Z87 §3`)

```
coverageRatio      KABUL EDİLMİŞ baseline / KATALOG evreni    ⇒ KAPI (≥%95)
sourceMatchRatio   eşleşen satır / DOSYA satırı               ⇒ batch düzeyi, TEŞHİS
```
⛔ **İkisi karışmaz.** ⛔ **İkisi de SORGUYLA türer — batch'te ÖZET KOLON YOK**
(`INV-B-009`: senkron mekanizmasız kopya-kolon; **batch immutable olsa bile TEK-KAYNAK**).

⚠️ Ve **kapı girdisi yalnız `coverageRatio`**. `sourceMatchRatio` bir **teşhistir**
(`Z85 §3a`): *"SKU eşleşmedi"* **kataloğun dışında bir iddiadır** ⇒ coverage'ı **düşürmez**.

---

## `§4` · ADIM 3 — TEŞHİS RAPORU YÜZEYİ

**Yükleyenin gördüğü:** `batch → satırlar → NEDEN`
```
filtrelenebilir: reason (SKU_NOT_FOUND × CPL_NOT_FOUND × INVALID_*) · status · row_no
```
⛔ Bu yüzey **`BASELINE_WRITE`/`MASTER_DATA_READ` hücrelerinden** okunur — **yeni hücre
AÇMA**, ve açman gerektiğini düşünüyorsan **DUR ve bildir** (`Z86`: *hüküm uç listesiyle
verilir, adıyla değil*).

---

## `§5` · ⛔ PİNLER

```
1  KATALOG PAYDASI      pasif SKU/CPL GİRMEZ · reddedilen "EKSİK" görünür
                        (iki-girdi-iki-çıktı — BL-2'de doğdu, BURADA KAPIYA BAĞLANIR)
2  EŞİK                 %94.9 → RED · %95.0 → GEÇER   (sınır ÖLÇÜLÜR, >= mi > mü —
                        CLAUDE.md §2.3: F12 ile `>=` ölçülmüştü, AYNI semantiği kullan)
3  ACCEPTED SATIR İZİ   baseline_volumes satırı → batch_id+row_no → import_batch_rows
                        (köprü KOPMAMALI)
4  HESAPLANAMAZ         kapsam hesaplanamıyorsa AÇIK HATA, sessiz geçiş YOK
```

---

## `§6` · DUR LİSTESİ

```
⛔ MIGRATION: 1823 TAHSİSLİ, data-engineer'ın. Başka migration gerekirse DUR ve bildir
⛔ docs/brd-v2/ DONMUŞ · commit/push YOK
⛔ git stash · git checkout ile geri alma · git add -A · --fix YASAK
⛔ konteynere DOKUNMA · .env okuma YOK
⛔ e2e KİLİTLİ (T-325): ikinci koşum 30 dk BEKLER — paralel e2e BAŞLATMA
⛔ improved-KAPISI (Z82) · new-table-rls KADEME 1 (Z85) · scope-ratchet (yeni rota →
  kova KARARI ürün sahibinin, guard KENDİ VERMEZ — T-266) CANLI
⛔ YENİ RBAC HÜCRESİ AÇMA — gerekirse DUR (Z86 dersi)
⛔ /Users/…/Code/TTM ve /Users/…/Code/TPM — tek bayt yazma, komut çalıştırma YOK
⛔ exit kodunu boruya sokma: cmd > /tmp/x.log 2>&1; echo $?
⛔ "kapılar yeşil" demeden önce hangi kapıları koştuğunu ADLA say
⛔ TZ kuran her test CHILD-PROCESS ile kurar — süreç içi process.env.TZ ETKİSİZ
  (emsal: baseline-volume-file-parser.service.spec.ts · excel-serial-date.spec.ts)
```

## `§7` · KANIT

```
migration    run→revert→run · ÜÇ DURUM (beklenen · no-op · İPTAL) · down() byte-birebir
             new-table-rls KADEME 1 yeşil
kapı         %94.9 RED / %95.0 GEÇER — iki-girdi-iki-çıktı
payda        pasif SKU/CPL dışarıda · reddedilen "eksik" — ÖLÇÜLMÜŞ, iddia DEĞİL
köprü        ACCEPTED satır izi kopmuyor
kapılar      tsc · unit · TAM e2e (TL'de) · guards · ratchet'ler — ADLA + exit kodu
```
*"Ölçemedim"* meşru bir çıktıdır; **"flaky" değildir.**

---

# `ADIM 2-3` BRIEF — `≥%95` KAPISI + TEŞHİS YÜZEYİ

> **Yazıldı:** 2026-09-03, **push'lu `HEAD`'den** (`eeda8b3` / `df6bebf`) — *yarım-devir
> yasası: brief, çalışma ağacını değil **push'lu `HEAD`'i** okur.*
> **Ön koşul:** `ADIM 1` indi — `baseline_volume_import_batch_rows` canlı, enum **7 üye**.

## `§A` · ⛔ İLK MADDE — `1821`/`1822` `CHECK`'LERİNİN **`NULL` TARAMASI**

`ADIM 1`'in dersi: `OR` zincirli bir `CHECK`, `NULL` girdide **`NULL`'a collapse olur** ve
Postgres onu **geçerli sayar** ⇒ satır **girer**. Orada **pozitif kontroller `18/19`
geçiyordu** ve hata **görünmüyordu**.

```
1  1821 · 1822'nin TÜM CHECK'lerini listele (pg_constraint, ŞEMA NİTELENDİRİLMİŞ)
2  HER BİRİ için NULL-girdi negatif vakası FİİLEN INSERT EDİLİR (BEGIN … ROLLBACK)
   ⛔ "OR zinciri yok" diye STATİK OKUMAYLA GEÇİLMEZ
3  her vakada ETKİLENEN SATIR SAYISI BASILIR
   ⛔ INSERT 0 0 ⇒ "hata yok" DEĞİL, "ÖLÇÜLMEDİ" — deney KURULMAMIŞTIR
4  NULL'da FALSE üretmeyen her CHECK nested CASE'e çevrilir
```
⚠️ Bulgu **çıkmayabilir** — o da bir sonuçtur, ama **ölçülerek** yazılır.

---

## `§B` · `≥%95` KAPISI — KATALOG PAYDASI, VE **ÜÇ ÇIKTI**

```
coverageRatio  =  KABUL EDİLMİŞ baseline / KATALOG evreni
                                            aktif-SKU × aktif-CPL × 12-period
                                            [G5: TÜRETİLMİŞ]
```
**Sınır semantiği `[F12 İLE ÖLÇÜLDÜ]`:** **`>=`** — `budget-threshold.service.ts:228-230`
kanonik uygulaması (`CLAUDE.md §2.3`). ⛔ **Aynı semantiği kullan**, ikinci bir eşik
karşılaştırması **yazma** (`F8`).

### ⛔ KAPININ **ÜÇ ÇIKTISI** — ve üçüncüsü brief'in kalbi
```
YEŞİL       coverageRatio >= 0.95
KIRMIZI     coverageRatio <  0.95   → TEŞHİS RAPORUNA link (§C)
ÖLÇEMEDİM   KATALOG EVRENİ BOŞ (aktif-SKU × aktif-CPL = 0 ⇒ 0/0)
            ⛔ "TEMİZ" DEĞİL — "ÖLÇEMEDİM"
```
> ### **`0/0` BİR ORAN DEĞİLDİR. BOŞ EVRENDE `%100` DE `%0` DA YANLIŞTIR.**

📌 `T-273` körlüğünün **kapı hâli** — ve `plans=0` dünyasında **ilk koşum tam bunu
görecek**. Kapının bugünkü ilk cevabı **`ÖLÇEMEDİM` olmalı**; *"yeşil"* dönerse kapı
**kör** demektir.
⇒ **PİN:** boş katalog → `ÖLÇEMEDİM` · dolu katalog + eksik baseline → `KIRMIZI` ·
dolu + tam → `YEŞİL`. **Üçü de aynı koşumda ayrışmalı.**

### `B1` · `coverage_ratio` AD ÇAKIŞMASI — **BU ADIMDA KAPANIR**
`plans.coverage_ratio` bugün **KPI toplama kapsaması** (`kpi-engine.service.ts:572`),
`D4` kapsam kapısı **DEĞİL**. ⇒ ayrım `EK_C`'ye yazılır, **yeni alan AYRI adlanır**.
*Aynı adı ikinci anlamla yüklemek `F8` ailesidir.*

---

## `§C` · TEŞHİS YÜZEYİ — `batch → satırlar → NEDEN`

⛔ **Yedi enum üyesinin HER BİRİ ayrı bir DÜZELTME EYLEMİ cümlesi taşır** — raporun
**taşıyıcı gerekçesi** buydu (`Z87 §F12`):
```
SKU_NOT_FOUND           SKU kodu katalogda yok — kodu düzelt ya da SKU'yu tanımla
CPL_NOT_FOUND           CPL kodu katalogda yok — kodu düzelt ya da CPL'i tanımla
INVALID_PERIOD          dönem hücresi okunamadı — 'YYYY-MM' ya da geçerli tarih ver
INVALID_VOLUME_FORMAT   hücre BİÇİMİ sayı değil — hücreyi düzelt
NEGATIVE_VOLUME         DEĞER negatif — değeri düzelt
MISSING_REQUIRED_FIELD  zorunlu hücre boş — doldur
DUPLICATE_GRAIN         aynı tenant×SKU×CPL×dönem İKİ KEZ — birini kaldır
```
⛔ **`NEGATIVE_VOLUME` ("değeri düzelt") ≠ `INVALID_VOLUME_FORMAT` ("biçimi düzelt")** —
bu ayrım `Z87 §F12`'nin **enum'u 7'ye çıkarma gerekçesiydi**; cümleler **ayrışmazsa
gerekçe boşa gider**.

### `C1` · İKİ METRİK **EKRANDA DA KARIŞMAZ**
```
sourceMatchRatio   BATCH BAŞLIĞINDA   (eşleşen satır / dosya satırı — TEŞHİS)
coverageRatio      AYRI YERDE          (kabul edilmiş / KATALOG evreni — KAPI)
```
⛔ Aynı ekranda yan yana **iki oran** varsa hangisinin **kapı** olduğu **yazılı** olmalı.

---

## `§D` · RBAC
```
okuma uçları     MASTER_DATA_READ        (mevcut, DEĞİŞMEZ)
yazma            BASELINE_WRITE          (Z86, {ADMIN, FINANCE})
```
⛔ **YENİ HÜCRE GEREKİRSE DUR VE BİLDİR** — `Z86` refleksi: *hüküm **uç listesiyle**
verilir, **adıyla** değil.*
⚠️ Yeni rota eklersen `scope-ratchet` **kova kararı** ister (`T-266`: guard ürün kararını
**kendi vermez**) ⇒ o da **DUR**.

---

## `§E` · DUR LİSTESİ (`§6`'ya EK)
```
⛔ MIGRATION: yeni gerekirse DUR — numara Team Lead'in
⛔ 1821/1822/1823'e DOKUNMA (CHECK düzeltmesi GEREKİRSE yeni migration ⇒ DUR ve bildir)
⛔ elle kapı koşumu için: bash scripts/gate.sh <be|fe|meta> <komut>
  (dizini KENDİ seçer, pwd'yi BASAR — cwd kayması bu oturumda ÜÇ KEZ ölçümü bozdu)
⛔ TZ kuran her test CHILD-PROCESS ile kurar (baseline-volume-file-parser.service.spec.ts emsali)
⛔ her CHECK negatif kontrolünde bir NULL-girdi vakası ZORUNLU
```

## `§F` · KANIT
```
§A  her CHECK için NULL-girdi vakası + ETKİLENEN SATIR SAYISI basılmış
§B  kapının ÜÇ çıktısı aynı koşumda ayrışıyor (boş / eksik / tam)
    >= semantiği: %94.9 RED · %95.0 GEÇER
§C  yedi enum, yedi AYRI düzeltme cümlesi — ikisi aynı cümleyi taşımıyor
kapılar  gate.sh ile, ADLA + exit kodu · TAM e2e Team Lead'de
```
