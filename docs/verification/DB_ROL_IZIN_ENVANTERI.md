# `app_runtime` İzin Envanteri — K-2.6.13f

> **Kaynak:** `docs/brd-v2/_ISSUE_DB_ROLU.md` (S3) · `K-2.6.13f`
> (`docs/brd-v2/03_IS_KURALLARI/L2_03_onay_yetki_uyum.md`).
> **Yürütülebilir hâli:** `collmind.backend/scripts/db-roles/02-runtime-grants.sql`
> — bu iki dosya BİREBİR eşleşir. Yeni bir hak gerektiğinde önce buraya kanıtla
> yazılır, sonra `.sql`'e GRANT satırı eklenir.
> **Ölçüm tarihi:** 2026-08-16. **Ölçen:** `data-engineer` (ADIM 1 devam turu).

## Yöntem (issue S3)

```
1. app_runtime altında SIFIR GRANT ile başla (toptan GRANT ALL YASAK).
2. npm run test:e2e çalıştır (tam suite, --runInBand).
3. docker container log'undan (log_min_error_statement=error, öntanımlı)
   "permission denied for TABLE|VIEW|SEQUENCE X" + eşlik eden STATEMENT
   satırlarını çıkar → (fiil, nesne türü, nesne adı) tekilleştir.
4. Yalnız DÜŞEN izinleri GRANT et, sql dosyasına KAYNAK yorumuyla ekle.
5. Suite'i yeniden koştur. 3-4'ü tekrarla.
6. Suite tam yeşil (270/270) + T-047/T-060 satır-sayısı invaryantı PASS
   olana kadar (invaryant, cleanup fonksiyonlarının GERÇEKTEN DELETE
   yapabildiğinin — yani envanterin sadece "istek başarılı" değil "suite'in
   kendi kendini temizleyebildiği" ölçüsüdür).
```

**19 tur** sürdü (`02-runtime-grants.sql`'deki "S3 tur 1"…"S3 tur 19" blokları).
Turların hiçbiri elle tahmin değil — her biri ya bir docker log ölçümü ya da
`test/helpers/seed-e2e.ts`'in statik okunmasıyla (bir DELETE zinciri ilk
adımda düşünce JS zincirinin kalan adımlara hiç ulaşmaması nedeniyle log'da
görünmeyen ihtiyaçlar için) çıkarıldı.

## Ölçülmüş iki genel kural (tekrar vakaların kaynağı)

1. **`WHERE`/`RETURNING` bir sütuna referans veren her `UPDATE`/`DELETE`,
   tablo-düzeyi `UPDATE`/`DELETE` bitine EK OLARAK o sütun(lar) üzerinde
   `SELECT` de ister.** Ampirik doğrulandı (`aclcheck_error, aclchk.c:2812`,
   `has_table_privilege(...,'DELETE')=true` İKEN yine "permission denied").
   `plan_approval_history` bunun tek istisnasıydı (tur 5'te SELECT'siz
   DELETE verildi) — tur 7'de düzeltildi. Geri kalan HİÇBİR satırda bu
   kusur yoktu (kontrol edildi: `information_schema.role_table_grants`'ta
   SELECT'siz UPDATE/DELETE satırı **sıfır**, ölçüm bu dosyanın sonunda).
2. **View'lar ayrı bir SELECT gerektirir** — alttaki tabloların sahibi
   (`app_migrate`) olsa bile, view'ın KENDİSİNE `SELECT` verilmeden
   `app_runtime` onu sorgulayamaz. `v_budget_summary` 14 tur boyunca bu
   yüzden görünmez kaldı: ölçüm sorgusu (`information_schema.
   role_table_grants`, "table" filtresi) bir VIEW'ı hiç saymıyordu — kapsam
   eksikti, terim değil. `grep -o 'permission denied for [a-z]+ [a-zA-Z_]+'`
   (nesne TÜRÜNÜ de yakalayan bir tarama) ile tur 14'te bulundu.

## Tablo bazlı envanter (ölçülmüş — `information_schema` sorgusu, 2026-08-16)

| Tablo/View | SELECT | INSERT | UPDATE | DELETE | Kaynak (tur) |
|---|---|---|---|---|---|
| `admin_audit_logs` | ✅ | ✅ | **yalnız `alert_sent`** | ✅ | 1,4,5,16 |
| `agreement_transactions` | ✅ | ✅ | **yalnız `is_reversed`,`updated_at`** | ✅ | 5,6,16,18 |
| `agreements` | ✅ | ✅ | ✅ | ✅ | 1,4,5 |
| `approval_requests` | ✅ | ✅ | ✅ | ✅ | 1,6,5,15 |
| `budget_alert_configurations` | ✅ | — | — | — | 3 |
| `budget_allocations` | ✅ | ✅ | — | ✅ | 3,4 |
| `budget_envelopes` | ✅ | ✅ | ✅ | ✅ | 4,6 |
| `budget_transaction_logs` | ✅ | ✅ | — | — | 4 |
| `budget_transactions` | ✅ | ✅ | — | ✅ | 3,5 |
| `categories` | ✅ | — | — | — | 3 |
| `channels` | ✅ | — | — | — | 3 |
| `cpls` | ✅ | — | — | — | 2 |
| `customers` | ✅ | ✅ | — | ✅ | 3,4 |
| `forecasting_units` | ✅ | — | — | — | 3 |
| `generic_units` | ✅ | — | — | — | 4 |
| `kpis` | ✅ | ✅ | ✅ | ✅ | 4,5,6 |
| `ledger_entries` | ✅ | ✅ | **yalnız `is_reversed`,`updated_at`** | ✅ | 4,5,9,17 |
| `lta_agreements` | ✅ | — | — | — | 10 |
| `lta_rates` | ✅ | — | — | — | 11 |
| `mechanics` | ✅ | ✅ | ✅ | ✅ | 3,4,19 |
| `on_invoice_batches` | ✅ | ✅ | ✅ | ✅ | 5,7,10 |
| `on_invoice_entries` | ✅ | ✅ | ✅ | ✅ | 6,8,9 |
| `plan_approval_history` | ✅ | ✅ | — | ✅ | 5,7,15 |
| `plan_fus` | ✅ | ✅ | ✅ | ✅ | 1,8,5,13 |
| `plan_mechanic_values` | ✅ | — | — | ✅ | 5,6 |
| `plan_skus` | ✅ | ✅ | ✅ | ✅ | 1,9,5,12 |
| `plans` | ✅ | ✅ | ✅ | ✅ | 1,4,5,7 |
| `regions` | ✅ | — | — | — | 4 |
| `sales_actual_batches` | ✅ | ✅ | ✅ | ✅ | 3,5,4 |
| `sales_actuals` | ✅ | ✅ | — | ✅ | 4,6,5 |
| `skus` | ✅ | — | — | — | 5 |
| `tactics` | ✅ | — | — | — | 3 |
| `tenants` | ✅ | ✅ | — | ✅ | 1,3 |
| `user_scopes` | ✅ | — | — | — | 3 |
| `users` | ✅ | ✅ | ✅ | ✅ | 1,2,4,5 |
| `v_budget_summary` (VIEW) | ✅ | — | — | — | 14 |

**Kapsam dışı bırakılan tablolar:** yukarıdaki 35 nesne DIŞINDA hiçbir tabloya
`app_runtime` erişimi yoktur. Katalogda bundan fazla tablo/sequence varsa
(ör. gelecekteki B/C dalgası şema kalemleri), bu envanter onlar için henüz
BİR HAK VERMEMEKTEDİR — yeni bir e2e/production yolu o tabloya dokunduğunda
aynı S3 döngüsüyle genişletilir.

**Sequence:** hiçbir sequence'e `USAGE`/`SELECT` verilmedi çünkü ölçümde hiç
gerekmedi — repo genelinde birincil anahtarlar `uuid` (varsayılan
`gen_random_uuid()`/uygulama tarafı üretim), `serial`/`bigserial` yok.

## `app_migrate` ile karşılaştırma (K-2.6.13a/b)

`app_migrate` DDL yetkili VE tablo sahibi (`arwdDxt` — ALL). `app_runtime`
hiçbir nesnenin sahibi değil, yalnız yukarıdaki tabloya özel DML alt-kümesi.
Doğrulama sorgusu (AC#4):

```sql
SELECT tableowner, count(*) FROM pg_tables WHERE schemaname='main' GROUP BY 1;
-- app_migrate | 52   (app_runtime: 0 satır — hiçbir tablonun sahibi değil)
```

## Sağlık kontrolü — "SELECT'siz UPDATE/DELETE" sınıfı sıfır mı

```sql
SELECT table_name FROM information_schema.role_table_grants
WHERE grantee='app_runtime' AND table_schema='main'
GROUP BY table_name
HAVING (bool_or(privilege_type='UPDATE') OR bool_or(privilege_type='DELETE'))
   AND NOT bool_or(privilege_type='SELECT');
-- 0 satır (2026-08-16 ölçümü)
```

## Suite sonucu (bu envanterle)

```
npm run test:e2e   → 17/17 suite, 270/270 test, EXIT 0 (iki ardışık koşumda)
npm test           → 65/65 suite, 1118/1118 test, EXIT 0
npx tsc --noEmit   → EXIT 0
npm run guards     → EXIT 0 (money-float --ratchet temiz, lint-ratchet --ratchet temiz)
```

## Bilinen sınır (AC#3/negatif testler — bu turun KAPSAMI DIŞI)

Bu envanter yalnız **pozitif** yolu (suite'in ihtiyacı) ölçer. `K-2.6.13`
`AC#3` (`CREATE TABLE`/`ALTER TABLE`/envanter-dışı tabloya yazma → reddedilir)
ve `AC#2` (RLS sonda testi) **qa-engineer**'a devredildi (brief'in "YAPMA"
listesi) — bu envanterin "asgari küme" iddiası yalnız suite'i yeşilleten
kümedir, negatif kanıt bu dosyada yoktur.
