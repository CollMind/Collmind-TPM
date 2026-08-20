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

## Tablo bazlı envanter (ölçülmüş — `information_schema` sorgusu, 2026-08-16;
## KARAR 1 sonrası GÜNCELLENDİ, 2026-08-16 devam turu)

> ⚠️ **K-2.6.13 KARAR 1 (ürün sahibi, 2026-08-16):** `ledger_entries` /
> `admin_audit_logs` / `agreement_transactions` satırlarındaki DELETE ✅
> işaretleri BİLİNÇLİ OLARAK KALDIRILDI — bu üç tablo bir defter/denetim
> kaydıdır (K-2.3.4 "hiçbir defter kaydı silinemez", K-2.11.6 "denetim kaydı
> silinemez", K-2.11.7 "DB seviyesinde korunur", INV-L-003 "ledger_entries'te
> `deleted_at` yok"). Aşağıdaki tablo bu kararla GÜNCEL; kaldırılan hak ve
> gerekçe için `scripts/db-roles/02-runtime-grants.sql`'deki "KARAR 1" bloğuna
> bakınız (yürütülebilir tek doğruluk kaynağı, bu tablo onun bir yansımasıdır).
> Ölçüm: `npm run test:e2e` GRANT kaldırıldıktan sonra kırıldı (permission
> denied for table X), kırılan HER nokta test temizliğiydi (üretim yolu 0) —
> düzeltme `test/helpers/admin-datasource.ts` (yeni, `app_migrate`
> bağlantısı) ile test tarafında yapıldı, GRANT geri verilmedi. İki ardışık
> `npm run test:e2e` koşumu: 20/20 suite, 283/283 test, EXIT 0.

| Tablo/View | SELECT | INSERT | UPDATE | DELETE | Kaynak (tur) |
|---|---|---|---|---|---|
| `admin_audit_logs` | ✅ | ✅ | **yalnız `alert_sent`** | ⛔ **KARAR 1 (2026-08-16)** — bkz. not | 1,4,5,16 |
| `agreement_transactions` | ✅ | ✅ | **yalnız `is_reversed`,`updated_at`** | ⛔ **KARAR 1 (2026-08-16)** — bkz. not | 5,6,16,18 |
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
| `ledger_entries` | ✅ | ✅ | **yalnız `is_reversed`,`updated_at`** | ⛔ **KARAR 1 (2026-08-16)** — bkz. not | 4,5,9,17 |
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
| `user_scopes` | ✅ | ✅ | **yalnız `created_by`,`updated_by`,`is_active`,`updated_at`** | — | 3,21,**22** |
| `users` | ✅ | ✅ | ✅ | ✅ | 1,2,4,5 |
| `v_budget_summary` (VIEW) | ✅ | — | — | — | 14 |

> ⚠️ **S3 tur 22 ([[T-242a]], 2026-08-20) — `user_scopes` UPDATE, KOLON DÜZEYİNDE.**
> `PATCH /users/:id/scope` (`UserService#updateScope`) replace semantiğinde satırları
> **silmez**, `is_active` ile deaktive/reaktive eder — bu `UPDATE` gerektiriyor
> (ölçüldü: izole e2e, `app_runtime` → *"permission denied for table user_scopes"*).
>
> Kolon listesi **ölçülerek** çıkarıldı, tahminle değil: `NODE_ENV=development` SQL
> logu, **iki farklı aktörle**. ⚠️ Tek aktörle ölçülseydi liste **eksik** çıkardı —
> TypeORM'un diff-tabanlı `UPDATE`'i değişmeyen kolonu `SET`'ten atlar, yani
> `created_by` hiç görünmezdi:
> ```
> deaktivasyon:  SET updated_by, is_active, updated_at
> reaktivasyon:  SET created_by, updated_by, is_active, updated_at
> ```
> `created_by` reaktivasyonda **bilerek** yazılıyor (`M2`, ürün sahibi kararı):
> reaktivasyon **yeni bir verme eylemidir**, satırın yeniden kullanılması olayın
> aynı olduğu anlamına gelmez.
>
> **`DELETE` verilmedi ve bu tutarlı** — replace semantiği satır silmiyor.
> ⚠️ Ve bu tablo özellikle dar tutuldu: **kimin neyi gördüğünü tanımlayan tablo.**
> `app_runtime`'ın `user_id`'yi yazabilmesi, bir kullanıcının kapsamını **başkasına
> taşıyabilmesi** demektir — `K-2.6.13f` asgari yetki.
>
> Kapı: `test/db-role-negative-yetki.e2e-spec.ts` (negatif: `user_id` UPDATE reddedilir
> · pozitif kontrol: `is_active` reddedilMEZ).

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

## KARAR 1 sonrası re-verification (2026-08-16, devam turu)

```
npm run test:e2e (koşum 1)  → 20/20 suite, 283/283 test, EXIT 0
npm run test:e2e (koşum 2)  → 20/20 suite, 283/283 test, EXIT 0
[T-047 invariant] PASS — her iki koşumda da
npx jest test/db-role-negative-yetki.e2e-spec.ts -t "K-2.6.13"
                             → 10/10 test, EXIT 0 (üç yeni DELETE-reddedilir
                               vakası + bir pozitif kontrol)
```

Suite sayısı (17→20) ve test sayısı (270→283) bu turdan ÖNCE de büyümüştü
(başka task'ların eklediği spec dosyaları) — KARAR 1'in kendisi 0 yeni test
dosyası eklemedi, `test/db-role-negative-yetki.e2e-spec.ts`'e 4 `it()` ekledi
(3 tablo × DELETE reddi + 1 pozitif kontrol).

`information_schema.role_table_grants` doğrulaması (KARAR 1 sonrası):

```sql
SELECT table_name, string_agg(privilege_type, ',' ORDER BY privilege_type)
FROM information_schema.role_table_grants
WHERE grantee='app_runtime' AND table_schema='main'
  AND table_name IN ('ledger_entries','admin_audit_logs','agreement_transactions','tenants','users')
GROUP BY table_name ORDER BY table_name;
--        table_name       |            privs
-- ------------------------+-----------------------------
--  admin_audit_logs       | INSERT,SELECT
--  agreement_transactions | INSERT,SELECT
--  ledger_entries         | INSERT,SELECT
--  tenants                | DELETE,INSERT,SELECT        ← kapsam dışı, DOKUNULMADI
--  users                  | DELETE,INSERT,SELECT,UPDATE ← kapsam dışı, DOKUNULMADI
```

Davranışsal doğrulama (canlı `psql -U app_runtime`, `ON_ERROR_STOP=1`):

```
DELETE FROM main.ledger_entries WHERE false;          → ERROR permission denied, EXIT 3
DELETE FROM main.admin_audit_logs WHERE false;        → ERROR permission denied, EXIT 1
DELETE FROM main.agreement_transactions WHERE false;  → ERROR permission denied, EXIT 1
```

## Bilinen sınır (AC#3/negatif testler — bu turun KAPSAMI DIŞI)

Bu envanter yalnız **pozitif** yolu (suite'in ihtiyacı) ölçer. `K-2.6.13`
`AC#3` (`CREATE TABLE`/`ALTER TABLE`/envanter-dışı tabloya yazma → reddedilir)
ve `AC#2` (RLS sonda testi) **qa-engineer**'a devredildi (brief'in "YAPMA"
listesi) — bu envanterin "asgari küme" iddiası yalnız suite'i yeşilleten
kümedir, negatif kanıt bu dosyada yoktur.

## KARAR 2 (ürün sahibi, 2026-08-16) — şema yaratma, `app_migrate`'e DB-düzeyi CREATE VERİLMEDİ

Kaynak: `scripts/db-roles/01-roles-and-ownership.sql`'in "2b) K-2.6.13 KARAR 2"
bloğu (yürütülebilir tek doğruluk kaynağı). Bu bölüm o kararın **izole,
tek kullanımlık container'da (`k2613-decision2-test`, gerçek dev DB'ye
DOKUNULMADI)** ölçülmüş sonucudur.

**Yapılan:** `db-roles-setup.sh` (`01-roles-and-ownership.sql`) artık
`CREATE SCHEMA IF NOT EXISTS :"schema"` içeriyor — SUPERUSER bağlantısıyla
(betik zaten böyle çalışıyor) ve göçlerden ÖNCE. `app_migrate`'e
`GRANT CREATE ON DATABASE` **verilmedi**.

**Doğrulandı (EXIT 0):**
```
taze container (init-schema.sql YOK, main şeması YOK)
  → db-roles-setup.sh (superuser)              → EXIT 0, CREATE SCHEMA (main yaratıldı)
  → has_database_privilege('app_migrate', db, 'CREATE')  → f  (hak verilmedi)
```

**⚠️ AMA — Karar 2'nin brief'teki gerekçesi ("göçteki CREATE SCHEMA IF NOT
EXISTS → KALABİLİR, idempotent, şema varsa no-op") EMPİRİK OLARAK YANLIŞ
ÇIKTI.** Aynı izole container'da devam ölçümü:

```
(şema YUKARIDA zaten yaratılmışken)
psql -U app_migrate -c "CREATE SCHEMA IF NOT EXISTS main;"
  → ERROR: permission denied for database collmind_tpm_iso   (42501)

npm run migration:run (DB_MIGRATE_USERNAME=app_migrate, taze `migrations` tablosu)
  → EXIT 1, CreateTenants1704067200000.up()'ın İLK SATIRINDA (42501, aclchk.c:2812)
```

PostgreSQL `CREATE SCHEMA IF NOT EXISTS`, DATABASE-düzeyi CREATE iznini
şemanın önceden var olup olmadığına BAKMADAN denetliyor — `IF NOT EXISTS`
yalnız "already exists" hatasını bastırıyor, izin denetimini değil. Yani
şemayı önceden yaratmak (Karar 2'nin yaptığı) bu satırı KURTARMIYOR.

**Neden gerçek dev DB'de görünmüyor:** `CreateTenants1704067200000` o DB'nin
`main.migrations` tablosunda zaten kayıtlı (`id=133`, superuser ile,
`app_migrate` var olmadan önce uygulanmış) — TypeORM bunu bir daha
çalıştırmıyor. **Tamamen taze bir kurulumda (`migrations` tablosu boş —
ör. yeni bir ortam/Cloud SQL) `migration:run` İLK ADIMDA hâlâ düşer.**

**Sonuç — Karar 2 KISMEN kapalı:**
- ✅ Şema artık `app_migrate`'e DB-düzeyi hak vermeden yaratılabiliyor
  (betiğin kendi iddiası, doğrulandı).
- ⛔ Tam taze bir DB'de `npm run migration:run` (app_migrate ile) hâlâ
  başarısız — bu turun KAPSAMI DIŞINDA kalan iki yoldan biri gerekiyor:
  (a) `app_migrate`'e `GRANT CREATE ON DATABASE` (ürün sahibi REDDETTİ), ya
  da (b) `src/database/migrations/1704067200000-CreateTenants.ts`'nin
  `CREATE SCHEMA IF NOT EXISTS` satırını kaldırmak/korumak (bu task'ın
  "`src/`'ye DOKUNMA" sınırı içinde — ayrı bir tur, B4 deseniyle aynı).
  **Team Lead'e bildirildi.**

## S3 tur 21 (T-241, 2026-08-19) — `user_scopes` INSERT

**Ölçen:** `backend-engineer`. **Kaynak:** `.claude/backlog/tasks/T-241.md`
(`POST /users` artık rol + kapsam BİRLİKTE alır; kapsamsız kullanıcı
YARATILMAZ).

`user_scopes` bugüne kadar yalnız SELECT taşıyordu (tur 3 —
`AccessScopeService#resolveScope`'un OKUMA yolu). T-241 ile `POST /users`
PLANNER/CATEGORY_MANAGER yaratılırken kapsam satır(lar)ını **aynı
transaction'da** yazıyor (`user.service.ts#create`,
`dataSource.transaction` içinde `manager.getRepository(UserScope).save`).

**Ölçüm (izole e2e koşumu, `test/user-scope-creation.e2e-spec.ts`,
`app_runtime` bağlantısı):**

```
GRANT öncesi:
  INSERT INTO "main"."user_scopes"(...) → error: permission denied for
  table user_scopes
  → transaction ROLLBACK — kullanıcı satırı da GERİ ALINDI (atomiklik tam
    tasarlandığı gibi çalıştı; eksik olan yalnızca DB-rol izniydi)

GRANT sonrası (GRANT INSERT ON :"schema".user_scopes TO app_runtime;):
  test/user-scope-creation.e2e-spec.ts: 9/9 yeşil
  test/role-journey.e2e-spec.ts (N9 dahil, tam suite): 86/86 yeşil
  [T-047 invariant] PASS — satır sayıları suite öncesi/sonrası birebir aynı
```

**UPDATE/DELETE bilerek verilmedi** — T-241'in kapsamı yalnız YARATMA
(`isActive: true` ile INSERT); kapsam GÜNCELLEME ayrı bir task ([[T-242]]),
kendi GRANT ihtiyacını kendi S3 turunda ölçer.

`scripts/db-roles/02-runtime-grants.sql`'e uygulandı (yerel dev DB'de
`bash scripts/db-roles-grants.sh` ile doğrulandı — yakınsak betik, REVOKE
ALL + ölçülmüş envanteri yeniden kurar).
