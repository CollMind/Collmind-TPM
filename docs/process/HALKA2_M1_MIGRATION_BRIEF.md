# `M1` — `sales_actuals` **grain anahtarları** (halka-2, migration şeridi)

> **Okunan HEAD:** meta `d28de9d` · be `b28ccf2` · fe `b391857` — **push'lu**
> **Migration numarası:** **`1824000000000`** — Team Lead tahsis etti, **ajan kendi
> numarasını SEÇMEZ** (`CLAUDE.md §4`). `M2` = `1825000000000`, **bu turda YAZILMAZ**.

## `§0` · NEDEN BU SIRA — ölçülmüş gerekçe

```
sales_actuals bugün:  fiscal_period NOT NULL · cpl_id NOT NULL
                      fu_id NULLABLE · sku_id NULLABLE
ölçüm:                toplam 3 · fu_dolu 0 · sku_dolu 0
fu_id YAZARI:         grep fuId src/modules/shared/sales-actuals/ → 0
raw_row anahtarları:  category · cpl_code · net_amount · channel_code ·
                      gross_amount · discount_amount     ⇒ FU/SKU BİLGİSİ YOK
```

> ### ⛔ **YAZARSIZLIK BİR KOD BOŞLUĞU DEĞİL, BİR *IMPORT SÖZLEŞMESİ* BOŞLUĞUDUR.**
> Bugünkü actuals dosya formatı **kategori × CPL × dönem** grain'inde. `FU × CPL × Ay`
> eşleştirmesi bu formatla **hiç yapılamaz** — kaynakta doldurulacak şey yok.

⇒ `fu_id`'yi bugün `NOT NULL` yapmak **yazarı olmayan bir kolona kısıt koymaktır** ve her
ingest'i kırar. `Z88 §1`'in tersi: **kısıt yazardan ÖNCE gelirse yolu ÖLDÜRÜR.**

## `§1` · KAPSAM — bu migration NE YAPAR

```
1  event_type    NULLABLE enum · TEK ÜYE: 'SALE'
2  invoice_no    NULLABLE varchar
3  batch-scope ≠ match-grain    AD AYRIMI (aşağıda §3)
4  CHECK'ler     her biri NULL-vakalı negatif kontrolle
⛔ fu_id NULLABLE KALIR — bu turda DOKUNULMAZ
```

### `§1a` · `event_type` — ⛔ **TEK ÜYELİ ENUM, VE BU BİLİNÇLİ**

`RETURN` üyesi **EKLENMEZ** — üreticisi yok (`Z91`: *"bir enum üyesi ekleyen tur üreticisini
AYNI TURDA bağlar ya da DUR"*). İade hükmü geldiğinde `RETURN` **üreticisiyle birlikte** doğar.

⛔ **JSDoc'a bu RANDEVU yazılır — ve `T-084` tuzağına düşmesin diye damgası:**
```
"KAPANMIŞ DEĞİL, BEKLEYEN" — tek üyelilik bir tasarım kararı DEĞİL, bir SIRA kararıdır.
```
📌 `T-084` dersi: *bir hatayı (ya da bir eksikliği) belgelemek, onu koruma altına alır* —
yorum *"tek üye yeterli"* der gibi okunursa, iade turu onu **dokunulmaz** sanır.

⚠️ Kolon **nullable** doğar: iade hükmü geldiğinde **şema değişmez** (ürün sahibi kararı).

### `§1b` · `CHECK`'ler — ⛔ `Z87` NULL-COLLAPSE KURALI
```
Postgres'te NULL değerlendiren bir CHECK SAĞLANMIŞ sayılır.
⇒ HER CHECK'in negatif kontrolünde BİR NULL GİRDİ VAKASI ZORUNLUDUR.
⇒ CHECK KODDAN KURULUR, SİMETRİDEN DEĞİL.
```
Emsal ve tuzak: `1823000000000-CreateBaselineVolumeImportBatchRowsTable.ts` — orada bir
`OR` zinciri `NULL`'a çöküyordu ve **18/19 pozitif kontrol geçiyordu**; iç içe `CASE` ile
düzeltildi. **O dosyayı OKU.**

## `§2` · ŞABLON — `BL-1` (`1822000000000`) DESENİ

**`1822000000000-CreateBaselineVolumesTable.ts`'i OKU ve deseni izle:**
- şema-nitelendirilmiş katalog sorguları (`nspname`/`schemaname`/`table_schema = 'main'`)
- assert taşıyan migration **üç durumu ayırt eder**: hepsi / hiçbiri / **kısmi ⇒ throw**
- `down()` gerçek ve **tam**

⛔ **run → revert → run**, ve **`shasum` ile BAYT-BİREBİR** doğrulama:
```
şema dökümü ÖNCE  →  run  →  revert  →  şema dökümü SONRA  →  BİREBİR olmalı
```
Ve `±` kontrolü: `up()` neyi eklediyse `down()` **tam onu** düşürür — fazlasını değil.

⚠️ **`plans = 0` penceresi hâlâ açık** — ölç ve raporla; kapanmışsa bu bir **DUR** sebebidir
(şema değişikliğinin maliyeti değişir).

## `§3` · AD AYRIMI — `batch-scope` ≠ `match-grain`

`Z96 §6`: **iki kavram, tek ad riski** (`F8` ailesinin tersi).
```
batch-scope   bir YÜKLEME PARTİSİNİN kapsamı      (hangi dosya, hangi dönem aralığı)
match-grain   bir EŞLEŞTİRMENİN taneliliği        (FU × CPL × Ay — varsayılan)
```
Aynı adı taşırlarsa **`AD-BORCU`** doğar (`T-366` emsali: *"iki defter aynı kelimeyi farklı
anlamda kullanıyor"*).
⇒ Şemada/yorumda **iki ad ayrı ayrı yazılır**; hangi kolonun hangisini taşıdığı **açıkça**
belirtilir. Yeni bir kolon gerekiyorsa **gerekçesiyle** ekle; gerekmiyorsa **yorumla ayır**
ve *"gerekmedi, çünkü …"* yaz.

## `§4` · ⛔ BU TURDA **YAPILMAZ**
```
fu_id NOT NULL            → M2 (1825), YOL İNDİKTEN SONRA
üç eski satırın silinmesi → M2
RETURN enum üyesi         → iade hükmü + üreticisi
ingest yolu / servis kodu → backend şeridi (SONRAKİ şerit)
resolver arayüzü          → backend şeridi
```

## `§5` · PİNLER — sayıyla
```
PİN 1  run → revert → run  ⇒  şema dökümü BAYT-BİREBİR (shasum)
PİN 2  her CHECK için: pozitif kontrol + negatif kontrol + ⛔ NULL GİRDİ VAKASI
PİN 3  event_type: tek üye SALE · nullable · JSDoc'ta "KAPANMIŞ DEĞİL, BEKLEYEN" damgası
PİN 4  fu_id'ye DOKUNULMADI (şema dökümünde nullable olarak duruyor)
PİN 5  plans satır sayısı (pencere açık mı) · sales_actuals satır sayısı
PİN 6  npm run guards exit 0 (migration-schema · new-table-rls · schema-isolation dahil)
```

## `§6` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- ⛔ **Container'a DOKUNMA** (`docker stop/rm/rename` **yasak**) — canlı geliştirme DB'si.
- DB: port **5434**, şema **`main`**. Aynı instance **başka bir ürünün `public` şemasını**
  da barındırıyor ⇒ **şemasız katalog/migrations sorgusu YANLIŞ ürünün geçmişini döndürür**.
- `git stash` **YASAK** · geri alma için `git checkout` **YASAK** (kopyala → uygula →
  kopyadan geri yükle → `shasum -a 256 -c`) · `git add -A` **YASAK** · `.env` **okuma** ·
  **commit/push YAPMA**.
- Doğrulamanı **izole `git worktree`'de** yap.
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma, tek
  komut koşma**. Bu repo `Collmind-TPM`.
- Exit kodunu **boruya sokma**: `cmd > /tmp/x.log 2>&1; echo $?`
- ⛔ **`grep -c` SIFIR bulunca exit 1 verir** — `|| echo 0` ile toplama sokma; sayarken
  **pozitif kontrol** göster.
- **Tam e2e'yi KOŞMA** (kilit Team Lead'de).
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR.**
