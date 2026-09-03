# GRANT uzlaştırması — `npm run db:roles:grants` · 2026-09-03

> Ürün sahibi şartı: **koşmadan önce snapshot, koştuktan sonra diff — ne değişti adıyla.**
> Gerekçe (`Z51`): *"canlı ortam betikten üretilebilmelidir"* — elle verilmiş bir hak
> üretim yolunu besliyorsa o hak **kayıt dışıdır**; kırılırsa ölçülür ve betiğe girer.

```
TABLO DÜZEYİ   önce 530  →  sonra 532
KOLON DÜZEYİ   önce 6966 →  sonra 6994
```

## KAYBOLAN — **SIFIR**

Üç rolün (`app_runtime` · `app_operator` · `app_migrate`) hiçbir ayrıcalığı düşmedi.
`REVOKE ALL` etkisiz kaldı ⇒ **kayıt dışı elle verilmiş hak YOKTU.**

## EKLENEN — tablo düzeyi (2 satır)
```
main|baseline_volume_import_batch_rows|app_runtime|INSERT
main|baseline_volume_import_batch_rows|app_runtime|SELECT
```

## EKLENEN — kolon düzeyi (28 satır, hepsi AYNI tablo: 14 kolon × 2 ayrıcalık)
```
main|baseline_volume_import_batch_rows|batch_id|app_runtime|INSERT
main|baseline_volume_import_batch_rows|batch_id|app_runtime|SELECT
main|baseline_volume_import_batch_rows|created_at|app_runtime|INSERT
main|baseline_volume_import_batch_rows|created_at|app_runtime|SELECT
main|baseline_volume_import_batch_rows|created_by|app_runtime|INSERT
main|baseline_volume_import_batch_rows|created_by|app_runtime|SELECT
main|baseline_volume_import_batch_rows|deleted_at|app_runtime|INSERT
main|baseline_volume_import_batch_rows|deleted_at|app_runtime|SELECT
main|baseline_volume_import_batch_rows|id|app_runtime|INSERT
main|baseline_volume_import_batch_rows|id|app_runtime|SELECT
main|baseline_volume_import_batch_rows|raw|app_runtime|INSERT
main|baseline_volume_import_batch_rows|raw|app_runtime|SELECT
main|baseline_volume_import_batch_rows|reason|app_runtime|INSERT
main|baseline_volume_import_batch_rows|reason|app_runtime|SELECT
main|baseline_volume_import_batch_rows|resolved_cpl_id|app_runtime|INSERT
main|baseline_volume_import_batch_rows|resolved_cpl_id|app_runtime|SELECT
main|baseline_volume_import_batch_rows|resolved_sku_id|app_runtime|INSERT
main|baseline_volume_import_batch_rows|resolved_sku_id|app_runtime|SELECT
main|baseline_volume_import_batch_rows|row_no|app_runtime|INSERT
main|baseline_volume_import_batch_rows|row_no|app_runtime|SELECT
main|baseline_volume_import_batch_rows|status|app_runtime|INSERT
main|baseline_volume_import_batch_rows|status|app_runtime|SELECT
main|baseline_volume_import_batch_rows|tenant_id|app_runtime|INSERT
main|baseline_volume_import_batch_rows|tenant_id|app_runtime|SELECT
main|baseline_volume_import_batch_rows|updated_at|app_runtime|INSERT
main|baseline_volume_import_batch_rows|updated_at|app_runtime|SELECT
main|baseline_volume_import_batch_rows|updated_by|app_runtime|INSERT
main|baseline_volume_import_batch_rows|updated_by|app_runtime|SELECT
```

## Nedensellik — önce ve sonra
```
ÖNCE   SET ROLE app_runtime; SELECT … → ERROR: permission denied for table
                                                baseline_volume_import_batch_rows
SONRA  SET ROLE app_runtime; SELECT … → okuyabiliyor: 0
```
