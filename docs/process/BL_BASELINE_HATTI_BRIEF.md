# `BL` — BASELINE HATTI BRIEF

> ⚠️ **BU BELGE İKİ KEZ AD DEĞİŞTİRDİ. YÜRÜRLÜKTEKİ AD: `BL`.**
> *(`DISIPLIN`: "kendi düzeltmesini taşıyan belge, erken duran okuyucuyu hâlâ yanıltır" —
> bu satır o kuralın **yazan tarafı**.)*
>
> **Hükümler:** `Z79 §1-§8` (ürün sahibi, 2026-08-31) · **Masa:** `W3_BASELINE_PLANLAMA_MASASI.md`
> **Statü:** açık — sıra `8b-FE ∥ T-346 → BL`

---

## `§0` · AD — `W`-SERİSİ KAPANDI

```
KANONİK   BL          iç adımlar BL-1 … BL-4
TARİHÎ    "W3"        yalnız FAZ2_PLANLAMA_BRIEF'in SIRA REFERANSI (F12 notuyla yaşar)
          B3-RBAC W'leri  TARİHSEL — dokunulmaz
```
⛔ **GENEL KURAL (`Z79 §1`):** bundan sonra **her dalga benzersiz önek alır.**
Gerekçe ölçüldü: *"aynı harfin dört işi, bu masanın **ilk bulgusu** olacak kadar pahalıydı."*

---

## `§1` · ⛔ İLK MADDE — `T-333` `TZ` ÖLÇÜMÜ (`Z79 §9.2`)

**`BL`'nin ilk işi kod değil, bir ölçüm.**
> *"Baseline-import **tarih/dönem** işleyecek; temsil hatası **tam o katmanda** ateşlenir."*

```
ölç   1) çalışma zamanı TZ        (node process · postgres session · container)
      2) etiket TÜKETİCİLERİ      timestamp kolonlarını OKUYAN yollar — enjeksiyon değil ÇAĞRI
sınıflandır  T-333: etiket bir ANAHTAR mı, yoksa bir GÖSTERİM mi?
```
📌 Bu kalem **dört tur** *"ölçemedim"* olarak kayıtlıydı ve bir **kuyruk satırı** olarak
çözülmedi. Bir **dalganın ön koşulu** olunca çözülür — `DISIPLIN`'in *"bir `improved` satırı
bir bilgi değil, o turun kapanmamış işidir"* kuralının ölçüm tarafı.

---

## `§2` · HAT — `BL-1 … BL-4`

```
BL-1  ŞEMA        baseline tablosu (D3) — 12 ay tarihsel hacim
                  ⚠️ İlke 1: bugün ihtiyacı ÖLÇÜLMEYEN esneklik AÇILMAZ
BL-2  GİRİŞ       upload ucu + parse
                  ⛔ YENİ PARSER YAZMA — emsal DÖRT (aşağıda), oku ve UYARLA
BL-3  DOĞRULAMA   D2 SKU eşleme + D4 kapsam kapısı
                  ⛔ kapsam hesaplanamıyorsa AÇIK HATA — sessiz geçiş YOK (§2.5)
BL-4  YÜZEY       sayfa GERÇEĞİYLE doğar
```

### `2a` · PARSER EMSALİ — **dört**, ve biri dar `[ÖLÇÜLDÜ]`
```
common/services/csv-parser.service.ts                    96   CSV-only   ⚠️ sales-actuals bunu kullanıyor
customer/services/file-parser.service.ts                698   XLSX+CSV
on-invoice/services/on-invoice-file-parser.service.ts   741   XLSX+CSV
agreement-transaction/.../off-invoice-file-parser.ts    634   XLSX+CSV
```
Son üçü **import blokları satır-satır aynı**, yalnız DTO satırında ayrışıyor; ortak taban
sınıf **yok**. ⇒ `BL-2` bu üçünden birini **uyarlar**; `csv-parser` XLSX taşımıyor.

---

## `§3` · IMPORT OLGUSU — **ÜÇLÜ DÖRDE ÇIKMAZ** (`Z79 §3`)

> ### **IMPORT BİLİNÇLİ BİR VERİ-GETİRME EYLEMİDİR;**
> ### **GRID'İN *"HENÜZ GİRİLMEDİ"* ARA-DURUMU ORADA YOKTUR.**

```
tam satır                 →  DOLU olgu
zorunlu alanı eksik satır →  SATIR REDDİ + import raporuna SATIR NO + ALAN ADI
                             ⛔ plana HİÇ girmez — YARIM SATIR İTHAL EDİLMEZ
```
⇒ `Q20` üçlüsü **değişmez**, ve **`NOT_EVALUABLE` import yoluyla ÜRETİLMEZ** — yalnız
**grid girişiyle** doğabilir.

⛔ **PİN:** bir e2e, eksik-alanlı bir satır içeren dosya yükleyip **o satırın `plan_skus`'ta
OLMADIĞINI** okumalı. *(Ayırt edicilik: aynı dosyadaki tam satır **girmiş** olmalı —
`§2.7 #6`, "kabul ve red aynı koşumda ayrışmalı".)*

---

## `§4` · KISMİ KABUL + `D4` — TEK CÜMLE (`Z79 §4`)

```
satır düzeyi kabul/red + ADLI hata raporu
coverage kapısı  TOPLAM EVREN üzerinden — REDDEDİLEN SATIR "EKSİK"TİR
```
> ### **YOKSA *"KÖTÜ SATIRLARI ATIP KABUL-EDİLENLERİN %95'İ"* OYUNU DOĞAR.**
> `%95`'e ulaşmanın **tek yolu satırları düzeltmek**.

**Eşik `[ÇÖZÜLMÜŞ — yeniden açma]`:**
```
%95  KAPI      Section_10 §10.2 Gate 2 · Glossary · L2_02:55 "| Tamlık | ≥ %95 |"
%80  AZALTMA   Section_11 §11.3 R3 mitigation ≡ Addendum H4 MVB-2
```
⛔ Bu bir **çelişki değil**, hedef+contingency çifti. Bir tur bunu *"çözülmemiş"* diye
raporladı ve **yanıldı** — `T-024.md:78` / `:99` okunmamıştı.

### `4a` · ⛔ `coverage_ratio` AD ÇAKIŞMASI — **dalganın YAZILI ilk kod işi**
`plans.coverage_ratio` bugün **KPI toplama kapsaması** (`|kesişim|/|çocuk|`,
`kpi-engine.service.ts:572`); `D4` kapsam kapısı **DEĞİL**. Tek karşılaştırması `!== 1`
(`:456`); `0.95` ile karşılaştıran satır **yok**.
⇒ Ayrım **`EK_C`'ye yazılır** ve **yeni alan ayrı adlanır** — aynı adı ikinci anlamla
yüklemek `F8` ailesidir.

---

## `§5` · VERİ ŞEKLİ — `plan_mechanic_values.plan_sku_id` (`Z79 §2`)

```
plan_sku_id NULL  = FU değeri geçerli
plan_sku_id dolu  = o SKU için EZME
çözümleme          TEK RESOLVER — SKU satırı varsa O, yoksa FU  (targetRoi deseni)
```

**İki bağlayıcı şart:**
1. ⛔ **UNIQUE `K-2.2.8c` dersiyle** (`L2_01:561-569` — *"en spesifik kayıt kazanır"*):
   **`NULLS NOT DISTINCT`** + resolver'da **açık öncelik**. **Gizli tie-break YOK** (`§2.5`).
   Bugünkü `UNIQUE(plan_fu_id, mechanic_id)` **revize edilir**.
2. ⛔ **`plans=0` penceresinde iner.** Pencere kapanırsa iş bir **veri taşıma** işine
   dönüşür — ve o **başka bir karardır**, bu migration'ın kapsamı değil.

**Migration `1821000000000`** tahsis edildi ⇒ ⛔ **`data-engineer` yazar** (`CLAUDE.md §3`).

**Reddedilen adaylar — gerekçeleriyle, ki bir daha tartışılmasın:**
| aday | red |
|---|---|
| `plan_fus.tactics` jsonb | **tipsiz** — `SKUContext` markasıyla kurduğumuz tip-zorlaması ailesine aykırı |
| `mechanic_spend_breakdown` | eksen **hazırdı** (`UNIQUE(plan_sku_id, mechanic_id)`) — **tuzak buydu**: çıktı tablosuna girdi koymak bir satırı **hem kaynak hem sonuç** yapar |

---

## `§6` · ⛔ RİSK — İKİNCİ ATEŞLEME DALGASI (`Z68 §3b`, brief'e ZORUNLU)

> ### **VERİ-SIFIR DÜNYADA YEŞİL OLAN HER ŞEY,**
> ### **İLK GERÇEK DEĞER-DAĞILIMINDA YENİDEN SINANMAMIŞ DEMEKTİR.**

**Bugün `0` satırda koşan yollar `[ÖLÇÜLDÜ — 47 tablo sayıldı]`:**
```
🔴 plans · plan_fus · plan_skus · plan_mechanic_values
   ⇒ recalc · spend-calculation · kpi-engine · lta-calculation · finance-reporting
     · BÜTÇE REZERVASYONU — planning-first zincirinin TAMAMI
🟠 plan_approval_history · mechanic_spend_breakdown · lta_agreements · lta_rates
⚪ claims · claim_matches · tactic_realizations · lta_plan_overrides  (tüketici SIFIR)
```
⚠️ `n_live_tup` **yanılttı** (`on_invoice_entries` tahmin `2`, gerçek `0`) — sayım
`count(*)` ile yapılır.

**Bilinen adaylar:** `T-347` (blok yorumu beyaz listeyi geçiyor) · `T-102` (hata-`null` ↔
kural-`null`) · `T-099` (`Number.isNaN(Infinity)===false`, dört canlı para yolu).
*(`T-341` kapandı — `DALGA 2b`.)*

**Ve beklenen-değişim listesi bir satır taşıyor (`Z77 §4`):**
> **REZERVASYONLAR ARTACAK** — Finance gözünde *"bütçe daha hızlı doluyor"* okunur.

---

## `§7` · `8a` — ALTI YAZARSIZ KOLON: **KARAR TABLOSU ÖNCE** (`Z79 §8`)

```
finance-reporting.service.ts:584-585   spendOf(planSku.plannedLtaOn/OffInvoiceSpend)  ← OKUYOR
lta-calculation                        değeri DTO DÖNÜŞÜNE koyuyor, plan_skus'a YAZMIYOR
plan.repository.ts:630-637 Pick<>      incrementalVolume·plannedTurnover·tacticSpend·
                                       plannedGp·gpRoi·ragStatus·calculatedKpis
                                       ⇒ ALTI KOLONUN HİÇBİRİ YOK
```
⛔ **Her biri `T-270` kuralından geçer: YA YAZAR KAZANIR YA ÖLÜR.**
```
okunan ikili (plannedLtaOn/OffInvoiceSpend)  →  YAZAR KAZANMAK ZORUNDA
kalan dördü (base_lta_on/off · promo_on/off) →  KADERİ ÖLÇÜMLE
```
📌 **`BL` bunu DÜZELTMEZ — GÖRÜNÜR KILAR.** Bugün her şey `0` olduğu için `0` doğru
görünüyor; `plan_skus` dolduğunda o iki kolon **dolu satırların yanında `0`** kalır.

---

## `§8` · `BL` KABUL ÇERÇEVESİ — OMURGA (`Z79 §5`)

`BL` indiğinde akışın kaçta kaçı canlı? Ölçüt **bu dört ayırt-edici**:

```
SC-O1 PLAN DOĞUMU    ay+CPL+kategori → plan; kategorinin aktif SKU'ları FU-hiyerarşisiyle
                     ✓ farklı kategori → farklı liste
                     ✓ boş kategori → GÖRÜNÜR MESAJ   ⛔ boş-açıklamasız grid YASAK
SC-O2 ELIGIBILITY    kategori×CPL'de tanımlı tactic'ler KOLON olur; tanımsız HİÇ görünmez
                     ✓ aynı kategori İKİ CPL'de FARKLI kolon kümesi
                     ✓ eligibility-boş → "bu eşleşmede tactic tanımlı değil"
                     ⛔ catch{return[]} ÖLÜR  (T-346)
SC-O3 HACİM GİRİŞİ   ✓ 1-dolu + 51-boş plan submit OLUR
                     ✓ rezervasyon YALNIZ dolu satırı taşır          [Q20 — PİNLİ]
SC-O4 MEKANİK GİRİŞİ FU'ya oran → SKU'larda görünür → bir SKU'da ezilir
                     ✓ override'lı SKU FARKLI spend üretir
                     ? FU değeri SİLİNİRSE SKU-override YAŞAR MI  → RESOLVER TESTİ
5-6                  T-334/Q13 zinciriyle KAPALI — mevcut pinlere ATIFLA bağlanır,
                     YENİDEN YAZILMAZ
```
⛔ `SC-O4` bir senaryo değil **PİN SÖZLEŞMESİ** (`Z74 §2`): fixture **ezme olan VE olmayan
SKU'yu birlikte** taşır, assertion **spend'in ayrıştığını OKUR**.

---

## `§9` · SIRA VE BAĞIMLILIK

```
1  8b-FE dalgası   ∥   T-346 ELIGIBILITY          ← ikisi paralel, farklı repo/bölge
2  W7 temizliği    (calculateAllSpendsForFU ÖLÜR — tek küçük commit)
3  BL              BL-1 … BL-4
```

### `9a` · `T-346` ÖNCE — ve gerekçe **deneyim** (`Z79 §6`)
> **`BL` kullanıcının İLK GERÇEK VERİSİNİ getirecek. O veriyi eligibility'siz yarım grid'e
> dökmek, ilk-gerçek-an'ı BİTMEMİŞ YÜZEYE kurmak olur.**

⛔ **Ve `touches:` kuralını aşan bir hüküm:** grid'e iki dokunuş **farklı bölgelere**
(kolon-türetme ↔ satır-veri). *"`touches:` ölçümü çakışma derse **bile** sıra değişmez;
kesişen dosya ikinci dalgada **rebase edilir**."*
📌 `CLAUDE.md §4` **paralelliği** yasaklar, **sırayı** belirlemez — sırayı **ürün** belirler.

⛔ `T-346`'nın kendi kapısı duruyor: **`S2`–`S6` hükme bağlanmadan kod başlamaz.**

### `9b` · `8b` — FE'nin 40 SESSİZ SIFIRI, `BL`-ÖNCESİ
```
PlanningGridEnhanced.tsx   baseVolume ?? 0 / || 0   →  40 vaka  [ÖLÇÜLDÜ]
```
> **`Q20`'nin bütün işi, GÖRÜNTÜ katmanında geri alınıyor.**
`NOT_EVALUABLE` ekranda **`—` / "hesaplanamadı"** olur (`targetRoi` emsali) ⇒ gerçek
eksik-veri geldiğinde **kullanıcının ilk gördüğü şey dürüst olur**.

### `9c` · `W7` — ÖLÜM, `BL` ÖNCESİ
`calculateAllSpendsForFU` + testleri + üç yanlış-iddialı yorum kalıntısı (`2a`'da
düzelmediyse). `Z75 §4`: **tüketici kazanmadı, öldü.** ⇒ `Z78 §7b`'nin randevusu kapandı.

---

## `§10` · `DALGA-2` ARTIKLARININ YERLEŞİMİ (`Z79` masası `§7`)

| kalem | yeri |
|---|---|
| `7b` sözleşme sapması | ⇒ `§9c` ile **aynı commit** (ölüm) |
| `🟡-5` `incrementalVolume` üç türetimi | ⇒ `BL-1`/`BL-4` ile — `base_volume` ilk kez gerçek olunca ayrışır |
| `🟢-5` lumpsum `Number(...)||0` | ⇒ **`BL` öncesi** — ağırlık `base_volume`'e bakıyor |
| `🟡-7` katman yönü · `🟢-1` ölü export | ⇒ bağımsız, `BL` sonrası |
| `19↔16` sayım borcu (`Z78 §8`) | ⇒ **ucuz arkeoloji** (`git log` + test-sayım diff'i), `DALGA 1` tahliyesiyle |

---

## `§11` · AÇIK — `BL` AÇILMADAN CEVAPLANACAK

```
T-346 S2  uygunluk ekseni kaç boyutlu
      S3  uygun olmayan tactic REDDEDİLİR mi, LİSTEDEN DÜŞER mi   (UX)
      S4  uygunluk kuralları hangi yüzeyden yönetilir
      S5  Calc Type ekseni nerede yaşar
      S6  spend_type='BOTH'ın bütçe-kapısı karşılığı   ⛔ zarfta BOTH YOK ⇒ sessiz eşleşmeme
SC-O4     FU değeri silinirse SKU-override yaşar mı    ⇒ resolver testi cevaplayacak
ŞART-6    iGSV · LTA_On_Pct · LTA_Off_Pct · TotalPlannedSpendOff
          ⛔ dördünün de TASK'I YOK — "canlıda hesaplanıyor, KPI olarak doğmuyor"
          ⇒ kuyruk karşılığı ÜRETİLMELİ  (Z75 §2: "verilen hükümlerin indeksi sürükleniyor")
```

---

## `§12` · HER AJANA — BU BRIEF'İN DUR LİSTESİ

```
⛔ docs/brd-v2/ DONMUŞ — 04_KARAR_KAYDI dışında yazma; kayıt Team Lead'in
⛔ migration YALNIZ data-engineer · numara 1821000000000 TAHSİS EDİLDİ, kendi numaranı seçme
⛔ git stash YASAK · git checkout ile geri alma YASAK (kopyala→uygula→yükle→shasum -a 256 -c)
⛔ git add -A YASAK · commit ETME — commit Team Lead'in
⛔ konteynere DOKUNMA (canlı geliştirme DB'si) · .env okuma
⛔ /Users/…/Code/TTM ve /Users/…/Code/TPM — tek bayt yazma, komut çalıştırma
⛔ paylaşılan ağaç: --fix / mutasyon / git checkout YOK; SENİN OLMAYAN dosyada
   tsc hatası görürsen DÜZELTME — DUR ve bildir  (T-269∥T-270; Z78 §5'te ATEŞLENDİ ve ÇALIŞTI)
⛔ exit kodunu boruya sokma: cmd > /tmp/x.log 2>&1; echo $?
⛔ ölçüm ortamı: docker ps --filter "label=com.docker.compose.project=tpm" BOŞ olmalı
⛔ negatif sonuç POZİTİF KONTROLSÜZ raporlanamaz
⛔ arama terimi ARANAN YERİN DİLİYLE seçilir — kasa dâhil (LTAAgreement ≠ LtaAgreement,
   ölçülmüş: yanlış kasa 0 döndürdü, doğrusu 28)
⛔ bir belgede "çelişki buldum" demeden önce DOSYANIN SONUNA KADAR bak
   ("DÜZELTME" · "ÇÖZÜLDÜ" · "revize" · "geri alındı")
⛔ "ölçemedim" MEŞRU bir çıktıdır — uydurma bir sayıdan iyidir
```
