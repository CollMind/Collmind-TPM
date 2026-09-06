# Halka-2 · **QA ŞERİDİ** — kırmızı testler · `INV-R-001/002` e2e'ye · `T-064` TZ pini

> **Hüküm:** `Z99 §5/§6` (ürün sahibi, 2026-09-06)
> ⛔ Ağaçta **commit'siz backend işi var** (halka-2 yolu + kapanış şeridi). `git checkout`/
> `git stash`/`git reset` **YASAK**. Sen yalnız **test dosyalarına** dokunursun.

## `İŞ 1` · 9/30 KIRMIZI — fixture'lar sözleşmeye uyar

`sales-actuals-validation.service.spec.ts` (+ `sales-actuals.service.spec.ts`): import
sözleşmesi değişti — **FU-kodu ya da SKU-kodu ZORUNLU**. Eski fixture'lar taşımıyor.
```
güncelle   fixture'lara fu_code / sku_code
ekle       sözleşmenin AYIRT EDİCİ vakaları — aynı suite'te:
             FU-kodu → fu_id dolu
             SKU-kodu → fu_id SKU'dan TÜRETİLMİŞ (fu_code'suz)
             ikisi yok → RED, sebep MISSING_REQUIRED_FIELD
             SKU'nun fu_id'si NULL → ölçülmüş davranış ne ise O (sessiz varsayılan YOK)
             fu_code ↔ sku_code UYUŞMUYOR → FU_SKU_MISMATCH
             invoice_no var → taşınır · yok → NULL
```
⛔ **Yeşile boyama YASAK:** bir test kırmızıysa ve düzeltmesi **üretim kodunda** ise —
**raporla, düzeltme**.

## `İŞ 2` · `INV-R-001` / `INV-R-002` → **E2E** (kanıt DB'de değil, e2e'de yaşar)

Backend şeridi bu ikisini canlı DB'de **bir kez** ölçtü ve satırları temizledi. Sen onu
**her koşumda** yapan e2e'yi yazarsın: **üret → ölç → sil**.
```
INV-R-001   COMPLETED partideki HER on_invoice_entries satırı:
            POSTED + karşılık gelen ledger DEBIT   |   ERROR + BOŞ OLMAYAN validation_errors
INV-R-002   Σ ledger DEBIT (o partiden) == Σ POSTED discount
```
**Ayırt etme gücü ŞART:** bir mutasyonla (ör. DEBIT'i yazmayan bir dal) testin **kırmızı
yandığını** göster; mutasyonu kopyala→uygula→kopyadan geri yükle→`shasum -a 256 -c` ile
al. **`git checkout` YASAK.**
⚠️ `ledger_entries` **audit-immutable** — temizlik yolu için backend şeridinin **ne
bulduğunu** oku (`Z99 §5`); silinemiyorsa **izole dönem + T-047 dışı** deseniyle yaşa,
ve bunu testin yorumuna yaz.
⚠️ `afterAll` temizliği FK sıralı, **kapsamlı**, ve `DELETE`'in dönüş değerine değil
**sonraki sayıma** bakar (`BL-4a` e2e emsali).

## `İŞ 3` · `T-064` TZ PİNİ — `T-333` harness deseni

`invoiceDate` artık **string** (TypeORM `date` → string). Pin: date-string **üç TZ'de
birebir aynı**.
```
TZ=UTC · TZ=Europe/Istanbul · TZ=America/Los_Angeles   — AYRI SÜREÇLERDE
⛔ process.env.TZ Jest İÇİNDE ATILDIR (Z81'de ölçüldü) — harness'i emsalden al:
   test/…/excel-serial-date.spec.ts komşu uyarısı + T-333'ün koşum deseni
```

## `§X` · YAPILMAZ
`getSummaryByFu` rotası testi (rota YOK) · `M2`/`NOT NULL` testi (M2 sonra) · üretim kodu.

## ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → boş
- Test dosyası **TASK NUMARASI değil SÖZLEŞME ADI** taşır
- Mock, taklit ettiği şeyin **TİPİNE** bağlanır (envelopeId/budgetEnvelopeId vakası)
- İzole `git worktree` · `.env` okuma · commit/push **YAPMA** · `git add -A` YASAK
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — dokunma
- Exit kodunu boruya sokma · `grep -c` sıfırda exit 1 (`|| echo 0` YASAK)
- **Tam e2e'yi KOŞMA**; kendi dosyalarını `npx jest --config test/jest-e2e.json <dosya>` ile
- **`ölçemedim` meşru, `flaky` DEĞİL**

## PİNLER
```
PİN 1  sales-actuals suite 30/30 (ya da ölçülen N/N) — kırmızı kalan varsa ÜRETİM KUSURU olarak adıyla
PİN 2  INV-R-001/002 e2e: yeşil + mutasyonla KIRMIZI (ayırt etme gücü) + afterAll sonrası sayım
PİN 3  T-064 TZ: üç süreç, üç aynı string
PİN 4  npm run guards exit 0 (lint-ratchet yeni dosyalarda temiz)
```
