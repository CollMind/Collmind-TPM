# `ADIM 5` — `RLS` KARAR PAKETİ

**Tarih:** 2026-08-27 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Statü:** ⏳ **HÜKÜM BEKLER** · **Ön-koşul:** ✅ `SYSTEM_INVARIANTS` uzlaşısı `FAZ-1` **kapandı**

> ## ⛔ PAKETİN GİRDİSİ DÜZELTİLDİ — `INV-T-004` ≠ `INV-T-005`
>
> ```
> "boş kapsam = erişim yok"   TEK CÜMLE, İKİ KATMAN
>    YETENEK kapsamı  CapabilityGuard (A′)    → INV-T-004  ✅ HOLDS
>    SATIR   kapsamı  AccessScopeService R-2  → INV-T-005  🔴 VIOLATED
> ```
> ⇒ **`RLS`'in konusu `INV-T-005`/`INV-T-006`'dır, `INV-T-004` DEĞİL.**
>
> ⛔ Ve `INV-T-005`'in **KÖKÜ**: `SCOPE_ENFORCEMENT_ENABLED = false` (varsayılan
> **kapalı**) ⇒ `PLANNER` için *"boş kapsam"* diye bir durum **yok**, koşulsuz
> `UNRESTRICTED`. **Bu, `T-304`'ün gerçek kapsamıdır.**
> ⚠️ Canlı `.env` değeri **`VARSAYIM`** — bu paket onu **ölçümle** getirmeli
> *(sandbox okumayı reddetti; `.env.example:42` + kod varsayılanı ölçüldü)*.

> ## ⛔ HER ÖLÇÜME İŞLENMİŞ ŞART (`Z45 §2.3`)
> **`main.tenants = 1` iken HER TEST YEŞİL.**
> **Fixture ikinci kiracıyı taşımadan HİÇBİR tenant-izolasyon pini PİN DEĞİLDİR.**
> *(`T-273`'ün `RLS` hâli — `boş sonuç FARK DEĞİLDİR`.)*

---

# BÖLÜM A — ÜÇ AÇILIŞ KARARI

## `K1` · OPERATÖR ERİŞİMİ — ⛔ **PAKETİN EN AĞIR KALEMİ**

**Ön-hüküm:** ayrı DB-rolü, `RLS`-bypass'lı ama **DENETİM-OLAYLI**.

### Ölçülen: ayrım **fiilen yürürlükte** — ama operatör yolu **onun dışında**

| rol | super | bypassrls | tablo sahibi |
|---|---|---|---|
| `app_runtime` | f | **f** | hayır |
| `app_migrate` | f | **f** | **48/48 + view** |
| `postgres` | **t** | **t** | — |

`K-2.6.13` **kağıt üstünde değil**: `database.module.ts:42` → `app_runtime`; migration/seed → `app_migrate`; `db-role-env.ts` eksik env'de **açık hata** (sessiz `postgres` düşüşü yok).

⛔ **AMA operatörün bugünkü TEK yolu:**
```
scripts/db-query.sh → docker exec psql -U postgres     SUPERUSER + BYPASSRLS
                                                        PAROLASIZ · KAYITSIZ
üç tüketici:  schema-isolation.sh (BİR KAPI) · plan-scale-validation.e2e · data-analyst ajan talimatı
```

### ⛔ VE *"DENETİM-OLAYLI"* YARISININ **SAĞLAYICISI YOK** — iki ayrı boşluk

```
DB tarafı          pgaudit → pg_available_extensions'ta 0 SATIR · log_statement = none
                   ⇒ imaj/konfig değişikliği gerektirir
UYGULAMA tarafı    admin_audit_logs.{tenant_id, admin_id, admin_email} → ÜÇÜ DE NOT NULL
                   ⇒ TENANT'SIZ BİR AKTÖRÜ KAYDEDEMEZ
```

> ⛔ Ön-hükmün *"denetim çekirdeğinin ilk müşterisi"* cümlesi, **mevcut denetim
> tablosunun ŞEMASIYLA UYUMSUZ.** `DISIPLIN`: *"bir şartın SAĞLAYICISI yoksa, şart bir
> erteleme değil bir **KİLİTTİR**."*

### İki okuma

| | |
|---|---|
| **A · ön-hüküm ayakta, SAĞLAYICI BORCUYLA** | `app_operator` (`BYPASSRLS`, **`NOSUPERUSER`**) üçüncü rol olarak eklenir; `db-query.sh` çevrilir. **Kazanç bugün bile gerçek:** `postgres`'in `SUPERUSER`'ı düşer (rol yaratma, dosya okuma, `COPY PROGRAM` **biter**). Denetim `pgaudit`'e bağlanana kadar **eksik** kalır ve bu **yazılı bir borç** olur |
| **B · SIRA TERS** | denetim sağlayıcısı inmeden operatör rolü yazmak, *"denetim-olaylı"* şartını **ilk günden ihlal eden** bir rol üretir |

⛔ **Ve `mevcut pratiği yasaklamama` şartı ÖLÇÜLDÜ:** `postgres` yolunu kapatmak bugün
**`schema-isolation.sh` KAPISINI** ve bir **e2e**'yi kırar. Tasarım bu **üç tüketiciyi
ADIYLA** taşımalı — taşımazsa `.env`/`db-query.sh` **sessizce `postgres`'e geri döner**.

## `K2` · ZAMANLAYICI × KİRACI — **ÖZNESİ YOK**

```
@Cron / @Interval / @Timeout / ScheduleModule / SchedulerRegistry  → 0
@Processor / BullModule / bullmq / @OnEvent / setInterval          → 0
package.json: @nestjs/schedule YOK · bull/bullmq YOK · event-emitter YOK
POZ. KONTROL: @Injectable( taşıyan dosya = 88   ⇒ tarama ÇALIŞIYOR
```

⇒ Soru **çürümedi, BOŞ ÇIKTI.** *"Envantersiz karar verilmez"* şartı bugün **envanterin
boş olmasıyla** karşılanıyor — bu bir **cevap değil**, cevabın **ertelenme gerekçesi**.

**İki okuma:** `(A)` desen kararı **bugün** yazılır (bedeli sıfır, ilk job doğduğunda
uyulacak kural olur) · `(B)` faz süzgeci **ADAY**'a atar — ama **beklediği şey ADIYLA
yazılı olmalı**: *"ilk `@Cron`/kuyruk tüketicisi doğduğu an."*

📌 **Mimari not:** `(i)`'nin altyapısı **kısmen var** — `recalc-telemetry.service.ts:32`
bir `AsyncLocalStorage` taşıyor. ⛔ **Kiracı bağlamı için İKİNCİ bir mekanizma
YAZILMAMALI** *(bkz. `T-309`: üç ölü mekanizma zaten var)*.

## `K3` · POLİTİKA ↔ UYGULAMA — **kapsam ekseninde AYAKTA, BAŞKA eksende EKSİK**

**Kapsam ekseninde çürüten vaka BULUNAMADI, ve gerekçesi ölçülü:**
```
Üretim kodunda HAM SQL: 2 çağrı yeri
  plan.repository.ts:187  pg_advisory_xact_lock   (satır okumuyor)
  plan.repository.ts:676  UPDATE ... WHERE ps.tenant_id = $N::uuid   ✅
⇒ HER satır okuması TypeORM repository'sinden geçiyor ⇒ uygulama kancası HER TABLODA
```
Ve kapsamın kaynağı `user_scopes`'un kendisi ⇒ `RLS`'e gömmek **özyinelemeli politika**
gerektirir — ön-hükmün *"tek yumak"* gerekçesinin **DB tarafındaki somut hâli**.

⛔ **AMA `tenant_id` TAŞIMAYAN TABLOLAR ekseninde EKSİK** → `T-307` (`Z45 §2`'de hükme
bağlandı) + kalan üç tablo (Bölüm B/1).

---

# BÖLÜM B — ALTI ENVANTER KALEMİ

## 1 · `tenant_id` taşımayan tablolar — **dördü**

| tablo | satır | `app_runtime` hakları | durum |
|---|---|---|---|
| **`tenants`** | 1 | **SELECT, INSERT, DELETE** | ⛔ **`T-307`** — hükme bağlandı (`Z45 §2`) |
| `migrations` | — | hak yok | ⏳ *"global-meşru"* cümlesi bekliyor |
| `typeorm_metadata` | — | hak yok | ⏳ aynı |
| `_t019_backfilled_tx` | **1** | hak yok | ⛔ tek kolon `tx_id`, hiçbir entity'ye bağlı **değil** — **sahipsiz backfill artığı** |

⛔ `Z45 §2.4`: **kalan üçü ya *"global-meşru"* cümlesi alır ya `T-307`'nin kardeşi çıkar.**

## 2 · BAĞLANTI DÜZENİ — ⛔ **`SET` BUGÜNKÜ HAVUZDA BİLE GÜVENSİZ**

```
database.module.ts:55-60   extra: { max: 10 }   ← node-pg havuzu, bağlantı İSTEKLER ARASI YENİDEN KULLANILIYOR
pgbouncer/pgpool/pool_mode taraması → 0 satır   (POZ.KONTROL: "max: 10" bulundu)
transaction/queryRunner çağrı yeri → 19         (411 sorgu çağrı yerine karşı)

PROBE E1  SET (session)  COMMIT SONRASI OTURUMDA KALIYOR   ⛔ FAIL-OPEN
PROBE E2  SET LOCAL      COMMIT'te geri alınıyor — ama geri döndüğü yer NULL DEĞİL,
                         ÖNCEKİ SESSION DEĞERİ ⇒ oturum seviyesinde ASLA SET yapılmamalı
```

| desen | güvenli mi | bedel |
|---|---|---|
| `SET` (session) + havuz | ⛔ **hayır** | — |
| **`SET LOCAL` + her istek bir tx** | ✅ | **411 çağrı yerinin çoğunda tx sarmalama** |
| havuz kancasında `SET`+`RESET` | ⚠️ | hata yolunda `RESET` atlanırsa **sessiz sızıntı** |
| `SET LOCAL` + `pgbouncer transaction` | ✅ | ileride uyumlu (`SET` ile **uyumsuz**) |

> ⛔ **Bu bir POLİTİKA TERCİHİ DEĞİL, MİMARİ KARAR** — ve `NFR-1.2` (`<500ms`) ile
> ölçülmesi gereken, **bugün ölçülmemiş** bir maliyet taşıyor.

## 3 · `FORCE ROW LEVEL SECURITY` — bir kusur değil, **bir KALDIRAÇ**

```
main: 48/48 tablo sahibi app_migrate · relforcerowsecurity 48/48 = f
PROBE D: sahip, FORCE kapalıyken politikayı ATLIYOR; açıkken TABİ
```
Uygulama `app_runtime` ile bağlanıyor (**sahip değil**) ⇒ izolasyon için `FORCE`
**gerekmiyor**; `FORCE` **açılırsa** migration/seed **kırılır**.
**Karar:** `FORCE` **kapalı** (doğal bypass) mı, **açık + `app_migrate`'e muafiyet
politikası** mı?

## 4 · VIEW'LAR — ⛔ **`T-308`, `Z45 §1`'de hükme bağlandı**

```
v_budget_summary · reloptions NULL · owner app_migrate · app_runtime SELECT hakkı VAR
PROBE B: invoker'sız → İKİ TENANT · invoker'lı → TEK
```
⇒ Politikalar yazılsa bile view **hepsini atlar**, ve **`guards` yeşil kalır**. **Alan A**
yüzeyinde, canlı (`budget.repository.ts:488,502`).

## 5 · SEED / MIGRATION — bedavaya doğru şekil

`app_migrate` = tablo sahibi ⇒ `FORCE` kapalıyken **otomatik bypass**.
⚠️ **Ama e2e farklı:** `test/helpers/app-bootstrap.ts:23` → `AppModule` → **`app_runtime`**.
**48 spec / 790 test** `app_runtime` ile koşuyor ⇒ **`RLS` açıldığı an, bağlam kablolaması
inmeden 790 test KIRMIZIYA DÖNER.**

> ⛔ **Bu bir risk değil, İSTENEN KANIT:** kapsamın tam olduğunun ölçüsü.

📌 Fixture'lar `admin-datasource` (`app_migrate`) ile kuruluyor ⇒ **kurulum bypass,
doğrulama tabi** — izolasyon testinin **doğru şekli**, ve **bedavaya** geliyor.

## 6 · CROSS-TENANT TARAMA

**Rota düzeyi:** `@TenantId`/`@CurrentUser` taşımayan **üç** dosya — `app.controller`
(health), `auth.controller` (`@Public`, tenant'tan **önce**), ve ⛔ **`tenant.controller`
(8 rota)** → **`T-307`**.

**İkinci cross-tenant yol → `T-310`:** `findByEmailWithoutTenant` — `UNIQUE(tenant_id,
email)`, e-posta **global benzersiz değil** ⇒ **gizli tie-break** (`§2.5`), bir **kimlik
doğrulama** yolunda. Ve `RLS` altında **bağlamsız** koşar ⇒ **login kırılır**.
**Üç seçenek hüküm bekliyor:** `users` `RLS`'ten **muaf** · login **dar bir rolle** ·
`x-tenant-id` **zorunlu** (istemciden gelen kiracı — yetki yüzeyi).

**ID-only erişimler** (`RLS` altında **davranış değiştirirler** — yazma sessizce `0`
satıra düşer), tam liste:
```
on-invoice.repository.ts:27   batchRepo.update(id, data)     ⛔ YAZMA · Alan A
on-invoice.repository.ts:211  entryRepo.update(id, data)     ⛔ YAZMA · Alan A
on-invoice.repository.ts:212  entryRepo.findOne({where:{id}})
admin-audit.service.ts:227 · tenant.service.ts:84 · user.service.ts:1033
```

⚠️ **Tarama sınırı — dürüstlük kaydı:** ham *"99 çağrı yeri `tenantId` içermiyor"*
sayısı **bir bulgu DEĞİLDİR**; elle örneklendiğinde çoğu `Array.find`, çağıranın kurduğu
`where` değişkeni, ya da tenant-nitelendirilmiş ebeveynden türeyen yüklem çıktı. **Bulgu,
yukarıdaki iki adlandırılmış listedir.**

---

# BÖLÜM C — ÇÜRÜYEN VARSAYIMLAR

| # | çürüyen | çürüten |
|---|---|---|
| 1 | `K2`'nin *"(i) mi (ii) mi"* sorusu | **öznesi yok** — envanter **sıfır** |
| 2 | `K1`'in *"denetim-olaylı"* yarısı | **sağlayıcısı yok** — `pgaudit` yok ∧ `admin_audit_logs` tenant'sız aktörü **kaydedemez** ⇒ **KİLİT** |
| 3 | *"Kiracı bağlamı yazılacak"* | ⛔ **ÜÇÜ ZATEN YAZILMIŞ, ÜÇÜ DE ÖLÜ** (`T-309`) — ve üçü de **`x-tenant-id` header fallback'i** taşıyor |
| 4 | *"`RLS` sondası yazılacak"* | ⛔ **ZATEN VAR**: `test/db-role-rls-sonda.e2e-spec.ts`, **mutasyonla sınanmış**. **Boşluğu:** tek tablo, `USING(false)`, **TEK KİRACI** ⇒ *"iki kiracı FARKLI sonuç alır"*ı **kanıtlamıyor**. ⇒ `ADIM 5`'in testi bunun **GENİŞLETİLMESİ** olmalı, **ikinci bir dosya değil** |
| 5 | *(ajanın kendi ölçümü)* `@Tenant(` | yanlış terim — doğrusu **`@TenantId`**. Ham `15` **raporlanmadan** düzeltildi → **3**. `DISIPLIN`: *"arama terimi, aranan yerin diliyle seçilir"* |

---

# BÖLÜM D — ÜÇ ÖN-KOŞUL *(architect: `RLS` tasarımı ilerleyebilir, ama bunlar hükümden ÖNCE kapanmalı)*

```
1  BAĞLANTI DESENİ bir HÜKÜM ister, bir tercih değil   (E1 SET'i eliyor; SET LOCAL 19/411)
2  security_invoker POLİTİKALARDAN ÖNCE                 → Z45 §1, ZİNCİRDE
3  tenants tablosu + /tenants rota ailesi bir KARAR ister → Z45 §2, ZİNCİRDE
```
⇒ `2` ve `3` **zaten iniyor**. **Açık kalan tek yapısal ön-koşul: `1`.**

# BÖLÜM E — ÖLÇÜLEMEDİ *(doldurulmadı)*

| ne | neden |
|---|---|
| `RLS` açıkken **CTPM'in gerçek şemasında** iki-kiracı davranışı | tur salt-okunurdu; probe **aynı şekilli** throwaway DB'de koştu ⇒ genelleme **`GEREKÇELİ`**, `ÖLÇÜLDÜ` değil |
| `SET LOCAL`'ın `<500ms` maliyeti | o kod yok — **ölçülecek durum mevcut değil** |
| `GET /tenants/:id` sızıntısının **davranışsal** kanıtı | `main.tenants = 1`; bulgu **kod okumasından** ⇒ ⛔ `Z44 §7` gereği **repro pini ister** (`T-307`'de şart) |
| canlı `SCOPE_ENFORCEMENT_ENABLED` | sandbox reddetti — **`VARSAYIM`** olarak işaretli |
| `_t019_backfilled_tx`'in sahibi/amacı | `T019` migration'ı okunmadı |

---

# ⛔ HÜKÜM BEKLEYENLER — özet

| # | soru |
|---|---|
| **1** | **`K1`:** okuma `A` mı `B` mi — operatör rolü **şimdi** (sağlayıcı borcuyla) mı, **denetim çekirdeğinden sonra** mı? *(paketin **en ağır** kalemi; çözümü denetim-çekirdeği tasarımıyla **aynı masa**)* |
| **2** | **`K2`:** desen **bugün** yazılsın mı (`A`), yoksa **`ADAY`** + tetikleyici cümle mi (`B`)? |
| **3** | ⛔ **BAĞLANTI DESENİ** — dört seçenekten hangisi? *(Açık kalan tek yapısal ön-koşul.)* |
| **4** | **`FORCE RLS`:** kapalı (doğal bypass) mı, açık + muafiyet politikası mı? |
| **5** | **`T-310` login yolu:** `users` muaf · dar rol · `x-tenant-id` zorunlu — hangisi? |
| **6** | Kalan **üç `tenant_id`'siz tablo:** *"global-meşru"* mu, `T-307` kardeşi mi? |
