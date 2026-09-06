# Halka-2 doğrulama artığı temizliği — 2026-09-06

> Ürün sahibi şartı: **snapshot → sil → diff, ne sildiğini basarak** (`T-325`).
> ⛔ Ve *"teardown eksik"* öncülü **ÇÜRÜDÜ** — ölçüm aşağıda.

## Sızdıran yol var mı — ÖLÇÜLDÜ, YOK
```
E2E-HALKA2-VERIFY üreten dosya (src/ · test/ · scripts/):  0
POZİTİF KONTROL (benzer önek arayan aynı grep):            1   ⇒ tarama kör değil
ilgili e2e (on-invoice-ledger-invariants):  kendi zarfını ZATEN siliyor,
                                            ve silmeyi SAYARAK doğruluyor (:162-172)
```
Öneki koyan şey bir **e2e değil**, artık var olmayan bir **ad-hoc doğrulama script'i**
— e2e'ye benzesin diye o öneki seçmişti. **Kapatılacak teardown yok.**

## Silinenler — FK sırasıyla (ledger → envelope)
```
LEDGER    435463a0-803b-4e5f-be73-d52ed0e48f68  2026-01-15  1000.00  DEBIT  ON_INVOICE
ENVELOPE  8de315dc-ffcd-41b0-b28d-30b2ea692fe7  E2E-HALKA2-VERIFY-NKA-2027-02
```
⚠️ Ledger satırının `posting_date`'i **`2026-01-15`** — ilk taramam `WHERE posting_date >= '2027-01-01'`
ile **boş** dönmüştü ve neredeyse *"ledger temiz"* diyecektim. `budget_envelope_id` üzerinden
`JOIN` yakaladı. *(`DISIPLIN`: tarih/dönem filtreli negatif sonuçlar özellikle şüphelidir —
filtre ekseni verinin gerçek ekseniyle aynı olmayabilir.)*

## ÖNCE → SONRA
```
ledger_entries        4 → 3
budget_envelopes      5 → 4
E2E-HALKA2 kalan          0
sales_actuals         6 → 3   (M2: üç seed-soylu REPLACED satır)
sales_actual_batches  6 → 3   (REPLACED 0)
```

## Snapshot diff — KAYBOLAN yalnız hedeflenen iki satır
```
envelope|8de315dc-ffcd-41b0-b28d-30b2ea692fe7|E2E-HALKA2-VERIFY-NKA-2027-02|
ledger|435463a0-803b-4e5f-be73-d52ed0e48f68|2026-01-15|1000.00
```
## EKLENEN — hiçbiri
```
```
