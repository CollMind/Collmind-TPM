# Halka-2 · **BACKEND YOLU** — sözleşme · `fu_id` yazarı · tüketici · on-invoice canlı · resolver arayüzü

> **Okunan HEAD:** meta `93fc355` · be `6aada26` · fe `b391857` — **push'lu**
> **Şema hazır:** `M1` (`1824`) indi — `event_type` (tek üye `SALE`, nullable) ·
> `invoice_no` (nullable) · `fu_id` **hâlâ NULLABLE** (bilerek)
> **Hüküm kaynağı:** `Z98` (ürün sahibi, 2026-09-05)

## `§0` · NEDEN BU İŞ VAR — ölçülmüş

```
sales_actuals   fu_id NULLABLE · 3/3 satırda BOŞ · YAZARI 0
raw_row         category · cpl_code · net_amount · channel_code · gross_amount ·
                discount_amount          ⇒  FU/SKU BİLGİSİ YOK
```
> ### **YAZARSIZLIK BİR KOD BOŞLUĞU DEĞİL, BİR *IMPORT SÖZLEŞMESİ* BOŞLUĞU.**
> Bugünkü dosya formatı `kategori × CPL × dönem` grain'inde; `FU × CPL × Ay`
> eşleştirmesi bu formatla **hiç yapılamaz**.

## `§1` · ACTUALS IMPORT SÖZLEŞMESİ `[ürün sahibi, Z98]`

```
GRAIN        tenant politikası: FU-düzeyi (VARSAYILAN) · SKU-düzeyi · fatura-düzeyi
DOSYADA      FU-kodu  YA DA  SKU-kodu  ZORUNLU
             ikisi de yoksa satır RED: MISSING_REQUIRED_FIELD
SKU→FU       DOĞRUDAN türetilir (GU YOK bu zincirde)
invoice_no   OPSİYONEL (aylık veride yok); gelirse TAŞINIR, ATILMAZ
DÖNEM        aylık varsayılan; fiscal_period zaten NOT NULL
```

**`SKU → FU` ölçüldü `[TL]`:** `skus.fu_id` **doğrudan**, ara tablo **yok**, `170/170` dolu.
⚠️ Ama kolon **nullable** — `fu_id`'si olmayan bir SKU gelirse **ne olacağı** bir karardır:
bugün vakası yok (`170/170`), **ölç ve raporla**; sessiz varsayılan **YASAK** (`§2.5`).

⛔ **RED SÖZLÜĞÜ — `BL-2` DESENİ, KOPYA DEĞİL.** `MISSING_REQUIRED_FIELD` **aynı enum
ailesinden**; `baseline-volume`'un sözlüğünü **çoğaltma**, deseni izle. Nereden geldiğini
ve neden kopyalamadığını **yaz** (`§7`: *önce ara*).

## `§2` · AGREGASYON SÖZLEŞMESİ — RESOLVER ARAYÜZÜNÜN **TEMELİ**

```
girdi-grain  ≤  değerlendirme-grain
resolver ALT katmanı ÜST katmana TOPLAR:   fatura → SKU → FU → CPL × Ay
```
> ### ⛔ **TERS YÖN YASAK: FU-BAZLI GELEN VERİ SKU'LARA *DAĞITILMAZ*.**
> ### **UYDURMADIR (`§2.5`).**

Girdi hedeften **KABA** ise (FU verisiyle SKU eşleştirme istenirse) ⇒ **AÇIK RED**.

**`GU`'nun yeri `[Z98 §7]`:** toplama hedefi **DEĞİL**, kategori-türetme **ara katmanı**
(`FU → GU → category`). **Tenant grain menüsünde `GU` YOKTUR** (`FU` · `SKU` · `fatura`).

## `§3` · RESOLVER ARAYÜZÜ — **İMZA + SÖZLEŞME, GÖVDE YOK**

```
girdi   actuals satırı + tenant grain politikası (girdi-grain + hedef-grain)
çıktı   AYRIK BİRLEŞİM:   Matched{ key }   |   NotMatched{ reason }
```

⛔ **`reason` TİPİ BU DALGADA KASITLI BOŞ** — `never`-benzeri bir yer tutucu + JSDoc:
```
"üyeler halka-3'te ÜRETİCİLERİYLE doğar: NOT_AGGREGATABLE · GRAIN_MISMATCH · …"
```
`Z91` net: **üretici yoksa üye yok.** Bedel **sıfır**, çünkü bu dalgada hiçbir kod
`NotMatched` **üretmiyor ya da tüketmiyor** — imza derlenir, gövde yok; halka-3 enum'u
tanımladığında **yalnız tip genişler, davranış değişmez**.

⛔ **`reason`'ı `string` TAŞIMA — REDDEDİLDİ.** Tipsiz sebep bir **sessiz kayıp** yoludur;
ölçülmüş emsal: frontend'in `raw === 'LTA_ONLY' ? … : null` vakası (`Z94 §2`) — tanınmayan
her sebep **sessizce `null`'a düşüyordu**.

📌 Randevu damgası **`M1`'in `event_type`'ıyla aynı**: *"KAPANMIŞ DEĞİL, BEKLEYEN"*
(`T-084` tuzağı — bir eksikliği belgelemek onu **koruma altına alır**).

## `§4` · `sales_actuals` TÜKETİCİ KAZANIR — *"çıkmaz bacak ölür"*

Bugün `sales_actuals` bir **yazma** ucu taşıyor (`@Post('upload')`,
`sales-actuals.controller.ts:52`) ama **tüketicisi** ölçülmeli.
⛔ **ÖNCE ÖLÇ:** bugün kim okuyor? (`grep`, sayıyla, **pozitif kontrollü**). Tüketici
yoksa bu dalga onu **kazandırır**; varsa **ne olduğunu yaz** ve iş buna göre daralır.

## `§5` · ON-INVOICE **CANLI** — `INV-R-001` / `INV-R-002` İLK KEZ ÖLÇÜLÜR

```
on_invoice_batches  0   ·   on_invoice_entries  0        [ÖLÇÜLDÜ, TL]
SYSTEM_INVARIANTS.md:1402
  INV-R-001  ⚠️ HOLDS VACUOUSLY  →  ⛔ ÖLÇÜLMEDİ   "düzeltme indi, VERİ GELMEDİ"
  INV-R-002  ⚠️ HOLDS VACUOUSLY  →  ⛔ ÖLÇÜLMEDİ   "aynı ölçüm"
```
> ### **BİR İNVARYANT *"BOŞ KÜMEDE SAĞLANIYOR"* İSE, HİÇ ÖLÇÜLMEMİŞTİR.**
> `T-273` körlüğü: **verinin yokluğu örter.**

⇒ **Gerçek bir on-invoice partisi uçtan uca geçirilir** ve iki invaryant **sayıyla**
doğrulanır:
```
INV-R-001  COMPLETED bir partideki HER on_invoice_entries satırı ya POSTED + karşılık
           gelen ledger DEBIT, ya ERROR + BOŞ OLMAYAN validation_errors
INV-R-002  o partiden doğan ledger DEBIT toplamı == POSTED satırların `discount` toplamı
```
⚠️ **`T-064` (`todo`) diyor ki: *"validate yolu hâlâ kırık"*.** Bu bir **iddiadır** —
**ÖLÇ**. Doğruysa kapsamı raporla ve **DUR** (bu dalganın işi mi, ayrı task mı — Team Lead
karar verir). Yanlışsa *"iddia ölçüldü, geçersiz"* diye yaz; `T-064` güncellenir.

## `§6` · ⛔ BU TURDA **YAPILMAZ**
```
eşleştirme MANTIĞI (gövde)      → halka-3
plan/anlaşmaya BAĞ · hakediş etkisi → halka-3
NotMatched reason ÜYELERİ        → halka-3 (üreticileriyle)
RETURN enum üyesi                → iade hükmü + üreticisi
fu_id NOT NULL · üç eski satırın silinmesi → M2 (1825), BU YOL İNDİKTEN SONRA
```
> ### **HALKA-2 *"MATCH-READY"* ÜRETİR, *"MATCHED"* DEĞİL — SINIR ADIYLA BEYANDA.**

## `§7` · PİNLER — sayıyla, ve `PİN 5`/`PİN 6` **AYNI KOŞUMDAN**
```
PİN 1  FU-kodu ile satır  ⇒ fu_id DOLU
PİN 2  SKU-kodu ile satır ⇒ fu_id SKU'dan TÜRETİLDİ (aynı koşumda PİN 1'den ayrışır)
PİN 3  ikisi de yok       ⇒ satır RED, sebep MISSING_REQUIRED_FIELD
PİN 4  invoice_no gelirse TAŞINIR (atılmıyor) · gelmezse NULL (sessiz varsayılan YOK)
PİN 5  INV-R-001 gerçek bir partide ÖLÇÜLDÜ — sayıyla
PİN 6  INV-R-002 aynı partide ÖLÇÜLDÜ — DEBIT toplamı == discount toplamı, sayıyla
PİN 7  ters yön REDDİ: FU-grain veriyle SKU-hedef istenirse AÇIK RED (test)
PİN 8  sales_actuals tüketicisi: ÖNCE kaç, SONRA kaç
```
⚠️ **Reprodüksiyon şartı YÖNSÜZDÜR:** bir kusurun bugün **olmadığını** görmen de bir
sonuçtur — gizleme, raporla.

## `§8` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- **Container'a DOKUNMA** · canlı DB'ye **DDL yazma** (migration `data-engineer` işi —
  şema değişikliği gerekiyorsa **DUR ve raporla**, `M2` zaten `1825`'te tahsisli)
- DB port **5434**, şema **`main`**; şemasız katalog sorgusu **yanlış ürünü** okur
- `git stash` YASAK · geri alma için `git checkout` YASAK (kopyala → uygula → kopyadan
  geri yükle → `shasum -a 256 -c`) · `git add -A` YASAK · `.env` **okuma** ·
  **commit/push YAPMA**
- Doğrulamanı **izole `git worktree`'de** yap
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma,
  tek komut koşma**. Bu repo `Collmind-TPM`.
- Exit kodunu **boruya sokma** · ⛔ **`grep -c` sıfır bulunca exit 1 verir** (`|| echo 0`
  ile toplama sokma; **pozitif kontrol** göster)
- **Testini SEN yazmazsın** (`CLAUDE.md §3`) — `qa-engineer` ayrı el. Ama **ölçümlerini**
  sen yaparsın.
- **Tam e2e'yi KOŞMA** (kilit Team Lead'de)
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR.**
