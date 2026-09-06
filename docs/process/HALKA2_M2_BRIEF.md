# `M2` (`1825`) — üç seed-soylu satır ölür, `fu_id` **`NOT NULL`**

> **Hüküm:** ürün sahibi, 2026-09-06 — şık **`(b)`**, `Z29` istisna disipliniyle
> **Migration numarası:** **`1825000000000`** — tahsisli. **Ajan kendi numarasını seçmez.**

## `§0` · SIRA TAMAM — kısıtın günü bu
```
tanım   M1 (1824)          event_type · invoice_no · fu_id NULLABLE
yazar   halka-2 backend    FU-kodu ya da SKU-kodu ZORUNLU → fu_id DOLUYOR
kısıt   M2 (BU)            fu_id NOT NULL
```
`Z98 §3`: *bir kolonun ömrü `tanım → yazar → kısıt`; sıra atlanamaz.* Üçüncü adım.

## `§1` · KAPALI LİSTE — üç satır, `[TL ÖLÇTÜ, canlı DB]`
```
7c7b2c18-9bf4-45ca-ae87-4c596ecf5a34  actuals_2026-01.csv  REPLACED  1 satır  fu_dolu 0
d0fe7bc1-3f85-4eb8-bf59-4258264eefa6  actuals_2026-01.csv  REPLACED  1 satır  fu_dolu 0
23c727be-b06c-4724-b9e2-74f288ec9345  actuals_2026-02.csv  REPLACED  1 satır  fu_dolu 0
```
Karşılık gelen üç `ACTIVE` batch (`4740c0b0…`, `2353173e…`, `5adb05d4…`) **fu_dolu 1/1** —
**dokunulmaz**.

⛔ **`INV-R-004` İSTİSNASI — kapalı liste, genel kapı DEĞİL.**
`INV-R-004`: *"A replaced sales-actuals batch is **never deleted**."* Bu üçü **seed-soylu**:
```
SEED-SOYLU tanımı:  batch seed'e ait  ∧  sözleşme-öncesi
```
İnvaryantın amacı **gerçek yükleme geçmişini** korumak; sözleşme-öncesi kurgu onun
**evreninde değil**. ⛔ *"Seed silinebilir"* diye **genel bir kapı açılmaz** — bu üç `id`'lik
**kapalı liste**.

⛔ **Migration bu üç `id`'yi HARD-CODE eder mi, yoksa şartla mı bulur?** Karar senin, ama:
`WHERE status='REPLACED' AND fu_id IS NULL` gibi bir **şart**, gelecekte meşru bir REPLACED
satırı da silebilir. **Hangisini seçtiğini ve NEDEN'ini yaz.** (TL görüşü: `id` listesi —
kapalı liste hükmü zaten öyle diyor; şart bir **kapı** olur, hüküm bir **liste** dedi.)

## `§2` · `SYSTEM_INVARIANTS.md`'YE İSTİSNA — `F12` DESENİ, ZORUNLU
`docs/contracts/SYSTEM_INVARIANTS.md`'de `INV-R-004`'ün yanına, **eski metin silinmeden**:
```
istisna adı        seed-soylu tek seferlik silme (Z100, migration 1825)
üç batch id        (yukarıdaki liste, birebir)
tanım              batch seed'e ait ∧ sözleşme-öncesi
snapshot referansı migration'ın kendi ÖNCE/SONRA sayımı (aşağıda PİN 2)
kapsam             KAPALI LİSTE — genel "seed silinebilir" kuralı DEĞİL
```
⚠️ Meta repodadır (`docs/`), submodule'de değil — **yolu doğrula**.

## `§3` · MIGRATION ŞEKLİ — `1822`/`1824` DESENİ
`1824000000000-AddSalesActualsGrainAnchors.ts`'i **oku** (en yakın emsal, aynı tablo).
```
üç durum ayrımı   hepsi / hiçbiri / KISMİ ⇒ throw   (assert taşıyan migration)
şema-nitelendirme nspname / table_schema = 'main'
down()            GERÇEK ve TAM
run → revert → run  şema dökümü BAYT-BİREBİR (shasum; pg_dump nonce'ı normalize)
```
⛔ **`down()` SİLİNEN SATIRLARI GERİ GETİREMEZ** — bu bir **veri** migration'ı.
`down()` `NOT NULL`'ı kaldırır; silinen üç satır için **açık bir yorum**: geri gelmez,
ve **neden kabul edilebilir** (seed-soylu, `npm run seed` yeniden üretir).
⚠️ `down()` çalıştığında `fu_id` `NULL` satır **varsa** ne olacağı da yazılı olmalı.

## `§4` · PİNLER
```
PİN 1  run öncesi: fu_id NULL satır sayısı = 3 (ve üçü de kapalı listede) — BAS
PİN 2  run sonrası: sales_actuals 6→3 · batches 6→3 (REPLACED 0) · fu_id NULL = 0 — BAS
PİN 3  fu_id NOT NULL: information_schema is_nullable = 'NO'
PİN 4  NEGATİF KONTROL: fu_id NULL bir satır INSERT denemesi ⇒ REDDEDİLİR (canlı, rollback'li)
PİN 5  run → revert → run bayt-birebir (revert sonrası is_nullable='YES')
PİN 6  npm run guards exit 0 (migration-schema · schema-isolation dahil) · tsc 0
```

## `§5` · ⛔ PARALEL ŞERİT VAR
Aynı anda bir `backend-engineer` `sales-actuals-validation.service.ts` + red sözlüğüne
dokunuyor (`FU_CATEGORY_MISMATCH`). **`src/modules/**` altına DOKUNMA** — senin dosyan
yalnız `src/database/migrations/1825000000000-*.ts` (+ meta'da `SYSTEM_INVARIANTS.md`).

## ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- Container'a **dokunma** · `.env` **okuma** · **commit/push YAPMA** · `git add -A` YASAK
- `git stash`/`git checkout`/`git reset` **YASAK** (ağaçta 26 dosyalık commit'siz iş var)
- Geri alma: kopyala → uygula → kopyadan geri yükle → `shasum -a 256 -c`
- DB port **5434**, şema **`main`** · şemasız katalog sorgusu **yanlış ürünü** okur
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **dokunma**
- Exit kodunu boruya sokma · `grep -c` sıfırda exit 1 (`|| echo 0` YASAK)
- **Tam e2e KOŞMA** (birleşme sonrası Team Lead koşar)
- **`ölçemedim` meşru, `flaky` DEĞİL**
