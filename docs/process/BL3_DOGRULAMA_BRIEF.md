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
