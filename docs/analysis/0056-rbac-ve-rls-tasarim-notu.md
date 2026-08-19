# 0056 — RBAC ve RLS **tasarım notu** ([[T-167]] + [[T-165]])

- **Tarih:** 2026-08-11
- **Task:** [[T-167]] (RLS) + [[T-165]] (RBAC / rol modeli) — **salt-okunur tur.** Bu turda kod,
  şema ve migration **yazılmadı**.
- **Ölçüm ortamı:** meta `8e6281c` · backend `b7b5f6f` (staging) · frontend `4b61d29` (staging)
  · dev DB `collmind_tpm`, şema `main`, port 5434, PostgreSQL 16.13
- **Statü:** **karar bekliyor.** Bu bir uygulama planı değildir; ürün sahibinin onaylayacağı
  bir **karar listesidir** (§C).

---

## 0. Bu belge nasıl okunur

| bölüm | ne var |
|---|---|
| **§A** | Bugün ne var — **ölçüm**. Her satırın `dosya:satır` ya da SQL karşılığı var. |
| **§B** | Kaynak modeli (`§3.2`/`§7.1`/`§7.2`) ↔ bizim model — karşılaştırma tablosu. |
| **§C** | ⭐ **Karar maddeleri.** Asıl çıktı. Her madde: soru · seçenekler · her seçeneğin sonucu. |
| **§D** | RLS'in somut riski ve maliyeti — ve bugünkü mimariyle **uyumsuzluk** bulguları. |
| **§E** | Sıra ve bağımlılık: T-167 ↔ T-165 ↔ [[T-168]] ↔ [[T-170]]. |
| **§F** | ⛔ **DUR listesi** — kendim karar vermediğim, ürün sahibine giden çelişkiler. |
| **§G** | 📄 **Tek sayfalık karar özeti.** Yalnız bu okunup karar verilebilir. |

`CLAUDE.md §2.4` gereği: kaynakların sessiz ya da çok anlamlı olduğu her nokta bir **karar
maddesi**dir, bir varsayım değil. `CLAUDE.md §2.1.2` gereği: kaynağın bir maddesi yanlış
göründüğünde **söylenmiştir** (§F).

---

# A. Bugünkü durum — ölçüm

## A.1 Kimlik ve tenant nasıl taşınıyor

Zincir tek ve kısa:

```
Authorization: Bearer <JWT>
  → JwtStrategy.validate()            src/modules/user/strategies/jwt.strategy.ts
      findOne({ id: payload.sub, tenantId: payload.tenantId })
      → request.user = { id, sub, email, role, tenantId }
  → @TenantId()                       src/common/decorators/tenant.decorator.ts
      return request.tenantId || request.user?.tenantId
  → servis imzası: method(dto, tenantId, userId)
  → repository: where: { tenantId, ... }
```

**`@TenantId()` kullanımı:** 215 çağrı noktası, 30 dosya
(`grep -rn "@TenantId()" collmind.backend/src`).

> **Tenant predicate'i bir katman değil, bir ARGÜMAN.** Her sorgu onu ayrı ayrı taşımak
> zorunda; unutulan bir yer sessizce tüm tenantları döndürür. `INV-T-003`'ün *"not only by
> application predicates"* cümlesinin somut karşılığı budur.

### 🔴 A.1.1 `request.tenantId` **hiçbir zaman set edilmiyor** — dört ölü mekanizma

`@TenantId()`'nin ilk dalı (`request.tenantId`) ölü, çünkü onu dolduracak dört bileşenin
**hiçbiri kayıtlı değil**:

| bileşen | dosya | üretim referansı |
|---|---|---|
| `TenantGuard` | `src/common/guards/tenant.guard.ts` | **0** |
| `TenantMiddleware` | `src/common/middleware/tenant.middleware.ts` | **0** |
| `TenantInterceptor` | `src/common/interceptors/tenant.interceptor.ts` | **0** |
| `AdminRestrictionsGuard` | `src/common/guards/admin-restrictions.guard.ts` | **0** |

**Ölçüm** (kendi tanım dosyaları hariç, `src` + `test` + `tests` taraması):

```bash
grep -rn "TenantMiddleware\|TenantInterceptor\|TenantGuard\|AdminRestrictionsGuard" \
  collmind.backend/src collmind.backend/test collmind.backend/tests \
  | grep -vE "guards/tenant.guard.ts|middleware/tenant.middleware.ts|interceptors/tenant.interceptor.ts|guards/admin-restrictions.guard.ts"
# exit=1  (hiç eşleşme yok)
```

Ve `APP_GUARD` provider'ı da yok (`grep -rn "APP_GUARD" src` → 0) — yani global guard
kaydı hiç yapılmamış.

> Bu, CLAUDE.md §4.2'nin *"mekanizma var, ona giden yol yok"* sınıfının **dördüzü**.

⚠️ **Ve bunlar "canlandırılacak" bileşenler DEĞİL.** `TenantMiddleware` ve `TenantInterceptor`
`x-tenant-id` başlığını **JWT ile karşılaştırmadan** kabul ediyor
(`tenant.middleware.ts` — `req.headers['x-tenant-id']` → `req.tenantId`). Kaydedilirlerse
`@TenantId()`'nin **ilk** dalı kazanır ve kimliği doğrulanmış bir kullanıcı başka bir
tenant'ın verisini bir HTTP başlığıyla okuyabilir. **Bu dördü kaydedilmemeli, silinmeli
ya da yeniden yazılmalı** — karar maddesi **K9**.

### A.1.2 Login yolu tenant'ı **e-posta ile** çözüyor

`src/modules/user/auth.controller.ts` `POST /auth/login`: `x-tenant-id` başlığı yoksa

```
findByEmailWithoutTenant(email)  →  user.tenantId
   = repository.findOne({ where: { email } })      user.repository.ts
```

Kısıt ise `(tenant_id, email)` **çiftinde** tekil:

```sql
-- pg_indexes, şema-nitelendirilmiş
IDX_USERS_TENANT_EMAIL  UNIQUE btree (tenant_id, email)
```

> **Aynı e-posta iki tenant'ta bulunabilir; `findOne` `ORDER BY`'sız çalışır.** Bugün
> `main.tenants` **1 satır** olduğu için görünmez. İkinci tenant geldiği gün: kullanıcı ya
> yanlış tenant'a düşer ya da hiç giriş yapamaz — **hata üretmeden**. Karar maddesi **K10**.

## A.2 Yetkilendirme — **üç canlı mekanizma**, tek kaynak yok

| # | mekanizma | nerede | kapsam (ölçüldü) |
|---|---|---|---|
| 1 | `@Roles()` + `RolesGuard` | `common/guards/roles.guard.ts`, `common/decorators/roles.decorator.ts` | **236 route'un 159'unda** |
| 2 | Özel guard'lar | `settlement.guard.ts` · `reversal.guard.ts` | 2 route |
| 3 | Servis içi rol kontrolü | `approval-workflow.service.ts` (ADR 0002) · `AccessScopeService` | 8 servis dosyası |

### A.2.1 `RolesGuard` **fail-open**

```ts
// src/common/guards/roles.guard.ts
const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [...]);
if (!requiredRoles) {
  return true;          // ← metadata yoksa HERKESE açık
}
```

**Ölçüm** (`.controller.ts` dosyalarında HTTP decorator sayımı, `@Roles` decorator bloğu
ileri yönde taranarak):

```
toplam route            236
@Roles taşıyan          159
@Roles taşımayan         77   ← rol filtresi YOK, yalnız JwtAuthGuard
   bunlardan GET olmayan 17
```

77'nin çoğu okuma (`customer.controller.ts` tek başına **10 GET**) — yani her rol, `READONLY`
dahil, tüm müşteri/master-data okumalarına erişiyor. Ama **yazma tarafında da açık kalanlar
var**; en keskini:

```
POST /spend-calculation/recalculate-on-volume-change/:skuId
  src/modules/shared/spend-calculation/spend-calculation.controller.ts:65
  body: { newVolume }  →  recalculateDistributionOnVolumeChange(tenantId, skuId, newVolume)
  @Roles YOK · AccessScope kontrolü YOK
```

> Bir `READONLY` kullanıcı bir SKU'nun hacmini değiştirip harcama dağıtımını yeniden
> hesaplatabilir. `§7.1` Read-Only rolü: *"❌ Create, edit, or approve anything."*

⚠️ **Ölçmedim, iddia etmiyorum:** 77'nin tamamının tek tek hangi rolün erişmesi gerektiği
bir **ürün kararıdır** (K7), bir kusur listesi değil. Ölçülen tek şey **filtre olmadığı**.

### A.2.2 Rol enum'u: DB'de 8 etiket, üretim kodunda **5**

```sql
-- pg_enum, main.users_role_enum
ADMIN · PLANNER · APPROVER · FINANCE · FINANCE_MANAGER · CATEGORY_MANAGER · MANAGER · READONLY
```

`MANAGER`/`FINANCE`/`APPROVER` **deprecated alias**'tır (migration
`1775000000000-AddManagerAndReadonlyRoles` + `1791000000000-ConsolidateRolesToBrd`;
PostgreSQL enum'dan değer silinemediği için etiketler kalıyor) ve bir **ESLint kalkanı**
onları koruyor:

```
.eslintrc.js  no-restricted-syntax  ×3   files: ['src/modules/**/*.ts']
                                          excludedFiles: ['**/*.spec.ts', ...]
```

**Ölçüm — backend üretim kodunda deprecated alias kullanımı: hiçbiri.**
`grep -rn "UserRole.MANAGER\b\|UserRole.FINANCE\b" src` → 4 eşleşme, **dördü de `.spec.ts`**
(ve ikisi *"denies deprecated UserRole.MANAGER"* diyen negatif testler).

`main.users` bugün (9 satır): `CATEGORY_MANAGER 3 · PLANNER 2 · FINANCE_MANAGER 2 ·
ADMIN 1 · READONLY 1`. **Deprecated bir rol taşıyan kullanıcı yok.**

## A.3 Kapsam (scope) — `AccessScopeService`, tek çıkış noktası

`src/modules/shared/access-scope/access-scope.service.ts` — **8 üretim servisi** tüketiyor
(`plan.service` · `plan.repository` · `approval-workflow.service` · `agreement.service` ·
`agreement.repository` · `settlement-summary.service` · `dashboard.service` ·
`finance-reporting.service`).

Sözleşmesi (sınıf başlığında yazılı, `docs/analysis/0004 §4`):

```
resolveScope(tenantId, userId, role) -> { kind:'UNRESTRICTED' } | { kind:'SCOPED', pairs }
assertEntityInScope · isInScope · applyToQueryBuilder
```

Ölçülen davranış:

| rol | scope |
|---|---|
| `ADMIN` · `FINANCE_MANAGER` · `READONLY` | `UNRESTRICTED` (kod: `UNRESTRICTED_ROLES`) |
| `CATEGORY_MANAGER` | yalnız `category` boyutu (`cplId` normalize edilip `null`'a düşürülür) |
| `PLANNER` | `(cplId, categoryId)` **çifti** — ama **`SCOPE_ENFORCEMENT_ENABLED` bayrağına bağlı, varsayılan `false`** |

✅ **Doğru yapılmış iki şey, kayda geçer:**
- **Fail-closed (R-2):** `pairs.length === 0` → `1=0` predicate'i. `CLAUDE.md §2.5`'in scope
  tarafındaki doğru uygulaması.
- **`NULL` = "hepsi"**, ve bir önceki ad-hoc kopyanın (`dashboard.service` `.filter(id=>!!id)`)
  bunu sessizce *"hiçbiri"*ye çevirdiği hata (F6) burada düzeltilmiş.

### 🔴 A.3.1 `PLANNER` kapsamı bugün **kapalı**

```ts
this.scopeEnforcementEnabled =
  this.configService.get<string>('SCOPE_ENFORCEMENT_ENABLED') === 'true';   // varsayılan false
```

> Yani bugün **bir PLANNER tüm tenant'ı görüyor** — `§7.1`'in *"Can only create
> plans/agreements for assigned channels"* kısıtı **çalışmıyor**. Bu bilinçli ve gerekçesi
> yazılı (backfill doğrulanana kadar fail-closed yıkıcı olur), ama bir **açık taahhüt**tür:
> bayrağı açacak bir task yok. Karar maddesi **K6**.

### A.3.2 `channel_id` kolonu var, **kapsam çözümleyicisi onu okumuyor**

```
main.user_scopes kolonları : cpl_id · category_id · channel_id   (region_id YOK)
UQ_user_scopes_user_cpl_category UNIQUE (user_id, cpl_id, category_id)   ← channel_id DAHİL DEĞİL
ScopePair                  : { cplId, categoryId }               ← channelId YOK
```

`channelId`'nin `access-scope` altındaki tek geçişi bir **spec fixture'ı**
(`access-scope.service.spec.ts:21 channelId: undefined`). Yani **BRD'nin birincil kapsam
ekseni (channel) şemada var, mantıkta yok.**

⚠️ Ayrıca `UQ_user_scopes_user_cpl_category` nullable kolonlar üzerinde: PostgreSQL'de
`NULL`'lar tekillik açısından **birbirinden farklıdır**, dolayısıyla
`(user, NULL, NULL)` satırı **birden çok kez** eklenebilir. Ölçülmüş bir uyuşmazlık yok
(dev'de tek tenant), ama kısıt sandığı işi yapmıyor.

## A.4 Frontend — **ikinci, senkronize olmayan bir yetki kopyası** ve ölçülmüş bir sapma

Frontend rol→eylem eşlemesini **kendi başına** yazıyor:

```
src/utils/roleUtils.ts                 hasRole / isRole / isReadOnly / getPrimaryPersona
src/components/layout/ProtectedRoute.tsx  requiredRole: string[]  → hasRole
src/services/agreements.service.ts:210 useAgreementPermissions()  → canEdit/canApprove/...
src/routes/index.tsx                   ~40 route'ta requiredRole dizisi
```

Ve backend'in ESLint kalkanının **frontend karşılığı yok**
(`grep -rn "MANAGER\|FINANCE" collmind.frontend/.eslintrc*` → deprecated rol kuralı yok).

### 🔴 A.4.1 Ölçülmüş sapma: kanonik roller route'lardan **dışlanmış**

Frontend hâlâ deprecated `'MANAGER'`/`'FINANCE'` dizelerine göre kapı kuruyor; hiçbir
kullanıcı bu rolleri taşımıyor (A.2.2). `hasRole` `ADMIN` dışında **deny-by-default**
(`roleUtils.ts` — `return requiredRoles.includes(userRole)`), sonuç:

| route | `requiredRole` (`src/routes/index.tsx`) | dışlanan kanonik rol |
|---|---|---|
| `/plan-approvals` | `['ADMIN','MANAGER','READONLY']` | **`CATEGORY_MANAGER`** (onaycı! DB'de 3 kullanıcı) |
| `/agreement-approvals` | `['ADMIN','MANAGER','FINANCE','READONLY']` | **`CATEGORY_MANAGER`** + **`FINANCE_MANAGER`** |
| `/finance` | `['ADMIN','FINANCE','CATEGORY_MANAGER','READONLY']` | **`FINANCE_MANAGER`** |
| `/off-invoice/upload` | `['ADMIN','FINANCE']` | **`FINANCE_MANAGER`** + `PLANNER` |

> **BRD'nin birincil onaycısı (`Approver = Category Manager`) plan onay ekranına giremiyor**
> — `<Navigate to="/dashboard" replace />`. Backend `@Roles(...CATEGORY_MANAGER...)` onay
> route'unu açıyor, frontend kapıyı kapatıyor.

Bunu tutan bir test **yok**: `grep -rln "plan-approvals\|agreement-approvals"` → yalnız
`Sidebar.tsx` ve `routes/index.tsx`.

⚠️ Son satır (`/off-invoice/upload` PLANNER'ı dışlıyor) `§7.2`'nin `import.invoice`
yeteneğiyle de çelişiyor: *"Typical Roles: **Planner**, Finance"*.

⚠️ Ve `useAgreementPermissions` içindeki *"isOwner"* satırı kendi yorumuyla yanlış olduğunu
söylüyor: `agreement.tenantId === user.tenantId; // Basit kontrol, gerçekte createdBy
kontrol edilmeli` — yani sahiplik kontrolü **tenant kontrolüne** indirgenmiş, ve değişken
hiç kullanılmıyor.

> Bu, `CLAUDE.md §7`'nin *"aynı yetenek birden çok kez yazıldı"* sınıfının **yetki
> katmanındaki** hâli — ve bu sefer iki kopya **ölçülebilir biçimde farklı** cevap veriyor.

## A.5 Tenant izolasyonu veritabanında — **sıfır**

```sql
-- şema-nitelendirilmiş (CLAUDE.md §4.2)
SELECT count(*) FILTER (WHERE relrowsecurity), count(*)
  FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
 WHERE n.nspname='main' AND c.relkind='r';
-- rls_enabled = 0 | total_tables = 43

SELECT count(*) FROM pg_policies WHERE schemaname='main';   -- 0

SELECT count(*) FROM information_schema.columns
 WHERE table_schema='main' AND column_name='tenant_id';     -- 40
```

`tenant_id` taşımayan 4 tablo: `tenants` · `migrations` · `typeorm_metadata` ·
`_t019_backfilled_tx` — **üçü altyapı, biri tenant'ın kendisi.** Yani `§7.5`'in *"Every table
has `tenant_id`"* şartı **veri tablolarında sağlanıyor**.

Migration tarafında da sıfır:
`grep -rniE "row level security|CREATE POLICY|current_setting|SET LOCAL" collmind.backend/src`
→ **0** (59 migration).

`INV-T-003` — 🔴 **VIOLATED**, kanıt değişmemiş.

---

# B. Kaynak modeli ↔ bizim model

## B.1 Roller — `§7.1` beş rol ↔ bizde **beş kanonik** (0049 §4'e düzeltme)

| `§7.1` Core Role (Phase 1) | bizdeki kanonik enum | eşleme ölçüldü mü |
|---|---|---|
| **Planner** | `PLANNER` | ✅ ad ve yetki örtüşüyor |
| **Approver (Category Manager)** | `CATEGORY_MANAGER` | ✅ `1791000000000-ConsolidateRolesToBrd` `MANAGER`→`CATEGORY_MANAGER`; `1775` `APPROVER`→`MANAGER` |
| **Finance Approver** | `FINANCE_MANAGER` | ✅ aynı migration `FINANCE`→`FINANCE_MANAGER` |
| **Admin** | `ADMIN` | ✅ |
| **Read-Only (Analyst / Executive)** | `READONLY` | ✅ migration `1775000000000`; 37 kod referansı; 1 kullanıcı |

### ⚠️ `docs/analysis/0049 §4`'ün *"`Read-Only`'nin karşılığı yok"* satırı **bayat**

Ölçüm (bu tur): `READONLY` enum'da var (migration 1775), backend'de 37 referans,
frontend'de 13 dize, `main.users`'ta 1 satır, ve `agreements.service.ts:226`'da özel bir
yazma-yasağı dalı var.

> `CLAUDE.md`'nin *"bir düzeltme de bir iddiadır"* kuralı gereği bunu **ölçerek** düzeltiyorum:
> 0049 §4'ün *"karşılığı yok"* ifadesi bugün **yanlış**. `MANAGER`/`FINANCE`'ın hangi BRD
> rolüne düştüğü de artık ölçülü (migration 1791) — **ikisi de deprecated alias**, üretim
> kodunda sıfır kullanım.

> ### Sonuç: **rol kümesi zaten BRD ile hizalı.** [[T-165]]'in *"altı rol vs beş rol"*
> çerçevesi ölçüldüğünde çözülüyor. Kalan tek soru bir **temizlik** sorusu (K1) ve bir
> **modelleme** sorusu (K2/K3).

## B.2 Tek rol ↔ junction

| | BRD `§3.2` | bizde |
|---|---|---|
| taşıyıcı | `user_roles` **junction** (many-to-many) | `main.users.role` **tek enum kolonu** |
| senaryo | *"An NKA Planner may create a Plan … and an Agreement … **same user, same session**"* | tek rol |
| `§7.1` | *"Users can hold **multiple roles**, but with explicit scope boundaries"* + örnek: Planner@NKA **ve** Approver@ModernTrade | temsil **edilemez** |

⚠️ **Ölçüm — bugün bir kısıt üretiyor mu?** `§3.2`'nin *"same user, same session"* cümlesi
aslında **çok-rol** değil, **çok-mod** senaryosudur: aynı kullanıcının hem plan hem anlaşma
yaratması. Bizde `PLANNER` **ikisini birden** yapabiliyor
(`plan.controller.ts:58 @Roles(ADMIN, PLANNER)` ve `agreement.controller.ts:42`), yani
o cümle **karşılanıyor**.

Gerçekten temsil edilemeyen şey `§7.1`'in **ikinci** örneği: *bir kanalda planlayıcı, başka
bir kanalda onaycı*. Ve `§7.1` bunu hemen ardından **politika uyarısına** bağlıyor:
*"User cannot be both Planner and Approver for the same channel/CPL (**policy warning**)"*.

> **Yani BRD çok-rolü istiyor ve aynı cümlede tehlikeli buluyor.** Karar maddesi **K2**.

## B.3 Kapsam eksenleri

| eksen | `§7.1` Planner Scope Constraints | `§7.2` örnek scope | bizde |
|---|---|---|---|
| **channel** | ✅ birincil | `channels: ['NKA','Modern Trade']` | 🟡 kolon var, **çözümleyici okumuyor** (A.3.2) |
| **region** | ✅ opsiyonel | `regions: ['Turkey']` | ❌ `user_scopes`'ta kolon yok |
| **cpl** | ✅ opsiyonel | `cpls: null` | ✅ |
| **category** | — (listede **yok**) | — | ✅ **ve tek çalışan eksen** |

`docs/analysis/0052 §1` bu soruyu kapattı: `category` **ürün hiyerarşisi**, `region`
**organizasyonel boyut** — `§3.1` bunu iki kez *"Critical"* etiketiyle söylüyor. **İkisi
ikame değil.**

`region` durumu (0052 §1'de ölçülü, burada tekrarlanmıyor): `main.regions` tablo **var**,
controller **var**, satır **0**, `cpls.region_id` dolu **0/29**.

> **Bugün fiilen tek boyutlu bir kapsam modelimiz var (`category`), ve o boyut BRD'nin
> kapsam listesinde geçmiyor.** Karar maddesi **K5**.

## B.4 Yetenek katmanı (CBAC)

`§7.2` **20 yetenek** tanımlıyor (`plan.create` … `audit.view`). Bizde:

```
grep -rin "capabilit" collmind.backend/src   → 3 eşleşme, ÜÇÜ DE ilgisiz yorum
                                               (plan.service.ts:684/689, update-fu-tactic.dto.ts:21)
```

### 📌 Ama **kısmi bir mekanizma zaten var** — ve ölü (`CLAUDE.md §7`: "önce ara")

```
main.users.permissions   jsonb, nullable        migration 1704067260000-CreateUsers:174
entity                   src/database/entities/user.entity.ts:171  permissions?: string[]
DTO                      src/modules/user/dto/create-user.dto.ts:73

okuyucu (backend üretim kodu)  : 0
dolu satır (main.users, 9 satır): 0   →  SELECT permissions, count(*) ... → (null, 9)
```

Frontend'de de karşılığı var ve o da ölü: `src/types/user.types.ts:50` ·
`src/schemas/user.schema.ts:22`.

> **Yetenek katmanı için `users.permissions` diye bir kolon zaten yaratılmış, hiç
> okunmamış, hiç doldurulmamış.** Bir `permissions` tablosu eklenirse yetkinin **üçüncü**
> yaşayabileceği yer olur (rol enum'u · bu kolon · yeni tablolar). Karar maddeleri
> **K3/K4** bunu açıkça ele almalı.

### ⚠️ Kaynağın kendi içinde yetenek adı tutarsız

```
§2.6  (Section_02:886-893) : 'agreements.create' · 'plans.create'   ← ÇOĞUL
§7.2  (Section_07:186-201) : 'agreement.create' · 'plan.create'     ← TEKİL
§12 Glossary               : tekil
```

Yetenek kodları **dize eşleşmesiyle** çalışır: biri seçilirse diğeri **sessizce**
başarısız olur — `CLAUDE.md §2.5`'in dize tarafındaki hâli. Karar maddesi **K3c**.

## B.5 RBAC tabloları

| `§3.2` Database Table | bizde | ölçüm |
|---|---|---|
| `users` | ✅ | — |
| `roles` | ❌ | `information_schema` · migration taraması |
| `permissions` | ❌ | " |
| `role_permissions` (junction) | ❌ | " |
| `user_roles` (junction) | ❌ | " |
| `user_permission_overrides` | ❌ | " |

`docs/analysis/0055 §2.1`: **TTM'de de altısının beşi yok** (51 migration tarandı) — yani
port-kaynağı **yok**, bu greenfield bir katman.

📌 `user_permission_overrides` kaynağın kendi uyarısıyla geliyor: *"(use sparingly)"*.

---

# C. ⭐ Karar maddeleri

> Kuyruk kuralı uygulandı: **BRD'nin modeli bir seçenek olarak yazılıdır, varsayılan olarak
> değil**; ve her maddede **daha sade bir alternatif** var.

---

## K1 — Deprecated enum etiketleri (`MANAGER` · `FINANCE` · `APPROVER`) ne olacak?

**Bağlam:** üretim kodunda **sıfır** kullanım (A.2.2), `main.users`'ta **sıfır** satır, ESLint
kalkanı **yalnız backend `src/modules/**`**'ı kapsıyor, frontend'de **hâlâ kapı kuruyorlar**
ve ölçülmüş bir sapma üretiyorlar (A.4.1).

| seçenek | sonuç |
|---|---|
| **a) Durum korunur** | Frontend sapması (A.4.1) devam eder; her yeni ekranda tekrar edebilir. **Ölçülen kusur açık kalır.** |
| **b) Frontend'de de kanonikleştir + ESLint kuralını frontend'e port et** (SADE) | A.4.1 kapanır. Enum etiketleri DB'de kalır (PostgreSQL silemez) ama hiçbir kod onlara bakmaz. **Migration gerekmez.** ⚠️ `CLAUDE.md`'nin port kuralı: kuralı doğru kılan bağlam (`files:` glob'u, `excludedFiles`) de port edilmeli. |
| **c) Enum'u yeniden yaz** (yeni tip + `ALTER TABLE ... TYPE` + eski tipi düşür) | Temiz enum. **Veri taşıyan bir ortamda geri alınması pahalı** → §F'ye tabi. Kazanımı (b)'nin üzerine yalnız kozmetik. |

**Önerilen tartışma noktası:** (b) ucuz, ölçülmüş bir kusuru kapatıyor ve geri alınabilir.
(c) için bugün bir gerekçe **ölçülmedi**.

---

## K2 — Çok-rol gerekiyor mu? (junction ↔ enum)

**Bağlam:** B.2. `§3.2`'nin *"same user, same session"* senaryosu bugün **zaten
karşılanıyor**; karşılanmayan `§7.1`'in *"bir kanalda Planner, başka kanalda Approver"*
örneği — ve kaynak aynı paragrafta bunu *"policy warning"* ile işaretliyor.

| seçenek | sonuç |
|---|---|
| **a) `user_roles` junction'a geç (BRD modeli)** | `§3.2`/`§7.1` ile birebir. **Bedeli büyük ve dağınık:** `RolesGuard` `user.role === role` yerine küme kesişimi; JWT payload'ı `role: string` → `roles: string[]` (**tüm oturumlar geçersizleşir**); `AccessScopeService`'in rol-tabanlı `UNRESTRICTED_ROLES` mantığı çok-rol için **yeniden tanımlanmalı** (iki rolden biri unrestricted ise sonuç ne?); frontend `hasRole` ve ~40 `requiredRole` dizisi; ADR 0002'nin *"FM yalnız `PENDING_FINANCE_REVIEW`"* kuralı bir kullanıcı hem CM hem FM ise **belirsizleşir**. |
| **b) Enum kalır; çok-rol ihtiyacı ortaya çıkarsa yeniden değerlendirilir** (SADE) | Bugün ölçülmüş bir kısıt yok (tek tenant, 9 kullanıcı, çok-rol talebi kaydı yok). `§7.1`'in çatışma uyarısı zaten *"aynı kanalda ikisi birden olma"* diyor — enum bunu **yapısal olarak** garanti ediyor. |
| **c) Ara yol: enum + `user_permission_overrides` tarzı istisna** | Çok-rolün ihtiyacını "bir kullanıcıya ek yetenek" olarak karşılar. ⚠️ Ama K4'te reddedilmesi önerilen mekanizmayı geri getirir; **iki karar birlikte alınmalı.** |

⛔ **§F'ye bağlı:** (a) seçilirse **ADR 0002 yeniden yazılmalıdır** — "FM yalnız
`PENDING_FINANCE_REVIEW` onaylar" kuralı tek-rol varsayımı üzerine kurulu.

---

## K3 — Yetenek granularitesi: `§7.2`'nin 20 yeteneği mi, daha kaba bir küme mi?

**Bağlam:** B.4. `@Roles()` bugün **route** granülaritesinde çalışıyor ve 159 route'ta
uygulanmış — yani fiilen "route = yetenek" gibi bir eşleme zaten var, sadece **adı yok ve
veri değil**.

| seçenek | sonuç |
|---|---|
| **a) `§7.2`'nin 20 yeteneği, tam CBAC** (BRD modeli): `permissions` + `role_permissions` tabloları, `@RequireCapability('plan.approve_L1')` decorator'ı | Kaynakla birebir; `policy.configure`/`budget.override`/`audit.view` gibi bugün adsız olan yetkiler **adlanır**. **Bedeli:** 159 route'un her birinin bir yeteneğe eşlenmesi + eşlemenin **seed'lenmesi** + `§7.7`'nin *"custom role UI"*sinin Phase 1 dışı olması nedeniyle yönetim yolu yok (yani veri seed/migration ile girer). ⚠️ **Ve K8'e bağlı:** yeteneği veri yapmak, onu **konfigüre edilebilir** yapar; konfigürasyon üretimde ulaşılamazsa `CLAUDE.md §2.3`'ün `BudgetAlertConfiguration` vakası **tekrarlanır**. |
| **b) Yetenek **sabit** olarak tanımlanır, tablo yok** (SADE): `capabilities.ts`'te bir `const CAPABILITIES` + `ROLE_CAPABILITIES: Record<UserRole, Capability[]>`, `@RequireCapability()` decorator'ı bunu okur | Yetenek adları **tek kaynaktan** gelir (frontend de aynı tanımı import edebilir → A.4.1 sınıfı yapısal olarak kapanır). Şema değişikliği **yok**, migration **yok**, geri alınabilir. ⚠️ **Ama BRD'nin dinamik-konfigürasyon ilkesine göre bir sapmadır** ve öyle kaydedilmelidir. |
| **c) Bugünkü rol-tabanlı `@Roles()` korunur, yalnız kapsamı tamamlanır** (EN SADE) | 77 filtresiz route'a (A.2.1) `@Roles` eklenir; `RolesGuard` **fail-closed**'a çevrilir (K7). Yetenek katmanı hiç gelmez. `§7.7`'nin *"✅ Capability-based permissions"* Phase 1 maddesi **karşılanmaz** ve bu bilinçli bir sapma olarak yazılır. |

**K3c — kanonik yazım:** (a) ya da (b) seçilirse `plan.create` (tekil, `§7.2` + Glossary) ile
`plans.create` (çoğul, `§2.6`) arasında **bir seçim yapılmalı ve tek yerden üretilmelidir**
(enum/`as const`), çünkü hata sessizdir (B.4).

---

## K4 — `user_permission_overrides` gelecek mi?

| seçenek | sonuç |
|---|---|
| **a) Gelsin (BRD modeli)** | `§3.2`'nin altıncı tablosu tamamlanır. ⚠️ Kaynağın kendisi *"use sparingly"* diyor. Ve **etkin yetki hesabı** (rol → yetenek → override) **audit edilmesi zor** bir katman ekler: `§7.4`'ün `PERMISSION_DENIED` olayı bu durumda "hangi katman reddetti" bilgisini taşımalı. |
| **b) Gelmesin** (SADE) | Etkin yetki = rol → yetenek. Tek adımlı, açıklanabilir, `audit.view` çıktısı okunabilir. İstisna gerekirse **yeni bir rol** açılır (ki `§7.7` *"custom role creation (UI)"*'ı Phase 1 dışı bırakıyor ama **veri** olarak rol açmayı yasaklamıyor). |
| **c) Ertelensin** | K3(a) seçilirse tablolar zaten gelir; override'ı sonradan eklemek migration olarak ucuz. **Karar, ihtiyaç ölçülene kadar yazılmaz.** |

📌 **`users.permissions` (B.4) ile birlikte karara bağlanmalı:** bugün ölü bir jsonb kolon
duruyor. Hangisi seçilirse seçilsin o kolon ya **kullanılmalı** ya **düşürülmeli** — ölü
bırakılırsa yetkinin üçüncü olası yeri olarak kalır.

---

## K5 — Kapsam eksenleri: `category` kalsın mı, `channel` açılsın mı, `region` eklensin mi?

**Bağlam:** B.3 + A.3.2. Bugün **fiilen tek eksen** çalışıyor (`category`); `channel_id`
kolonu var ama okunmuyor; `region` hiç yok (ve `main.regions` **0 satır**).

| seçenek | sonuç |
|---|---|
| **a) Üç eksen: channel + region + cpl (BRD modeli)** | `§7.1`/`§7.2` ile birebir. **Bedeli:** `user_scopes`'a `region_id` migration'ı + `ScopePair`'in 2'den 4 boyuta çıkması + `applyToQueryBuilder`'ın predicate'inin genişlemesi. ⚠️ **Ve `region` bugün BOŞ** (`main.regions` 0 satır, `cpls.region_id` 0/29 dolu) — fail-closed bir kapsam ekseni **boş referans verisiyle** açılırsa herkes her şeyi kaybeder. Önce master-data doldurulmalı. |
| **b) `channel`'ı aç, `category`'yi koru, `region`'ı erteleme olarak kaydet** | `channel` BRD'nin **birincil** ekseni. ⚠️ **BU SATIR ARTIK YANLIŞ (2026-08-18, `Z11`):** *"kolonu zaten var … migration gerekmez"* diyordu — `user_scopes.channel_id` `T-238` ile **DÜŞÜRÜLDÜ** (migration `1809`). `(b)` şıkkı artık **bir migration gerektirir**; `K5` fiilen `(c)` yönünde kapandı ve gerekçesi `Z11`'de. Eski metin `F12` deseniyle korunuyor: ~~kolonu zaten var, migration gerekmez~~ (⚠️ `UQ_user_scopes_user_cpl_category` `channel_id`'yi kapsamıyor → tekillik yeniden düşünülmeli). `category`'nin gerekçesi yazılır (`§3.1`: bütçe boyutu). |
| **c) Bugünkü tek eksen korunur** (EN SADE) | Değişiklik yok. `§7.1`'in channel kısıtı **karşılanmamış** olarak kaydedilir. ⚠️ Bu, **bugünkü fiili durumun yazıya geçirilmesidir** — bir seçenek olarak sayılıyor çünkü ölçülmüş bir talep yok. |

⚠️ **Her üç seçenekte de ayrıca karara bağlanmalı:** `UQ_user_scopes_user_cpl_category`
nullable kolonlar üzerinde tekillik sağlamıyor (A.3.2) — kısıt ya `NULLS NOT DISTINCT`
(PG15+) ile düzeltilmeli ya da beklentiden vazgeçilmeli.

---

## K6 — `SCOPE_ENFORCEMENT_ENABLED` ne zaman açılacak?

**Bağlam:** A.3.1. Bugün `false` → **PLANNER tüm tenant'ı görüyor.**

| seçenek | sonuç |
|---|---|
| **a) Bu turda açılır** | `§7.1` Planner kısıtı yürürlüğe girer. ⚠️ Fail-closed: `user_scopes` satırı olmayan her PLANNER **her şeyi kaybeder**. Backfill migration'ı (`1792000000000`) kendi log'unda *"NO derivable scope"* uyarısı basıyor — yani kapsamsız planner **beklenen bir durum**. |
| **b) Bayrak kalır, ama bir kapatma tarihi/koşulu yazılır** | Bugünkü davranış korunur, taahhüt kayda geçer. |
| **c) Bayrak kaldırılır, enforcement kalıcı olarak KAPALI kabul edilir** | Dürüst ama `§7.7`'nin *"✅ Scope-based filtering"* Phase 1 maddesinden vazgeçmek demektir. |

📌 **Bu bir "bayrak" kararı değil, bir güvenlik kararıdır:** bayrak `false` olduğu sürece
`§7.1`'in Planner scope constraint'i **yoktur**, ve bunu bugün kimse bir invariant olarak
takip etmiyor.

---

## K7 — `RolesGuard` fail-open kalacak mı?

**Bağlam:** A.2.1 — 236 route'un 77'sinde rol filtresi yok; bunlardan biri `READONLY`
kullanıcının **veri değiştirebildiği** bir yol (`spend-calculation/recalculate-on-volume-change`).

| seçenek | sonuç |
|---|---|
| **a) Fail-closed'a çevir** (`@Roles` yoksa **reddet**), + `@Public()`/`@AnyRole()` gibi açık bir muafiyet decorator'ı | `CLAUDE.md §2.5`'in yetki tarafındaki karşılığı: eksik bildirim → **açık hata**. **Bedeli:** 77 route'un her biri için bir karar verilmeli (aksi hâlde uygulama tümüyle kilitlenir) — yani bu bir **envanter işi**, tek satırlık bir değişiklik değil. |
| **b) Fail-open kalır, 77 route'a `@Roles` eklenir** (SADE) | Aynı sonuç, daha az yapısal koruma: bir sonraki yeni route yine sessizce açık doğar. |
| **c) (a) + bir guard script'i:** `@Roles` ya da açık muafiyet taşımayan route için CI/lint hatası | Regresyon kapatılır. `CLAUDE.md §4.2`'nin *"bağlayıcı koşul bir guard'a bağlanır"* maddesi. ⚠️ `CLAUDE.md §2.7 #9`: kapsamı dinamik bir kapı (`changed-ts.sh`) bunu **kör** yakalar — guard **tüm** controller'ları taramalı. |

---

## K8 — Yetkiyi **veri** yapmak: konfigürasyon üretimden ulaşılabilir mi?

K3(a)/K4(a) seçilirse `roles`/`permissions`/`role_permissions` **konfigürasyon** olur.

⚠️ **Bu projede tam olarak bu şeklin ölçülmüş bir başarısızlığı var** (`CLAUDE.md §2.3`,
T-101): `BudgetAlertConfiguration` tablosu var, seed var, **controller yok**,
`TenantService.create` satır kurmuyor → API'den yaratılan her tenant hardcoded eşiklerle
**doğuyor**.

| seçenek | sonuç |
|---|---|
| **a) Tablolar + admin controller + `TenantService.create` provisioning** aynı task'ta | Konfigürasyon gerçekten konfigüre edilebilir. **Kapsam büyür.** |
| **b) Tablolar önce, controller sonraki task'a** | ⛔ **T-101'in tekrarı.** Yeni tenant yetkisiz doğar. `CLAUDE.md §4.2`: üretim çağrı yolu yoksa status `done` değil, **`blocked-unreachable`**. |
| **c) Yetenek sabit kalır** (K3b/K3c) | Konfigürasyon sorusu **hiç doğmaz.** |

> **Bu madde bir tercih değil, K3/K4'ün ön koşuludur:** K3(a) ya da K4(a) seçilirse
> K8(a) **zorunludur**, K8(b) kabul edilemez.

---

## K9 — Dört ölü tenant/admin mekanizması ne olacak? (A.1.1)

| seçenek | sonuç |
|---|---|
| **a) Silinsin** (SADE) | Yanlış bir güvenlik hissi ortadan kalkar. `TenantMiddleware`'in başlık-güvenen mantığı bir daha kimseyi yanıltmaz. ⚠️ `CLAUDE.md`: *"spec'i olmayan bir dosya kaybolduğunda geriye hiçbir şartname kalmaz"* — silinmeden önce niyeti bu belgeye (A.1.1) yazıldı. |
| **b) RLS için yeniden yazılsın** | §D'nin tenant-context katmanı zaten bir "her istekte çalışan bileşen" istiyor — o bileşen **yeni** yazılacaksa bu dördü yine de silinmeli. |
| **c) Bırakılsın** | ⛔ **Önerilmez:** biri gelecekte "zaten var" diye kaydederse cross-tenant okuma açılır. |

---

## K10 — Login'in tenant çözümü (A.1.2)

| seçenek | sonuç |
|---|---|
| **a) `x-tenant-id` zorunlu kılınsın** | Belirsizlik biter. Frontend'in login öncesi tenant'ı bilmesi gerekir (subdomain / tenant seçici). |
| **b) E-posta global tekil olsun** (`UNIQUE (email)`) | Basit, ama **çok-tenant bir üründe** aynı kişinin iki müşteride hesabı olmasını yasaklar. Ve mevcut veriye bir migration gerektirir. |
| **c) Çoklu eşleşmede **açık hata** fırlat** (SADE, `CLAUDE.md §2.5`) | Bugünkü akış korunur; belirsizlik sessiz seçim yerine **400/409** üretir. Migration gerekmez. |

---

# D. RLS'in somut riski ve maliyeti

## D.1 `INV-T-003` bugün ne durumda, ve RLS onu kapatır mı

`docs/contracts/SYSTEM_INVARIANTS.md`:

```
INV-T-003 — Tenant isolation is enforced by the database, not only by application predicates.
  Status: 🔴 VIOLATED   Guard: NONE → target DB (RLS) + CI (policy-presence check)
  Remediation: blocked on D-11
```

[[T-167]] D-11'in **her iki yarısını** kapattı (tasarım: `§7.5` → evet; fazlama: `§7.7` →
Phase 1). Yani `INV-T-003`'ün *"blocked on D-11"* ifadesi bayattır ve
**"unimplemented Phase 1 requirement (`§7.7`)"** olmalıdır.

**RLS onu kapatır mı? — Aşağıdaki dört koşul sağlanırsa evet; bugün DÖRDÜ DE sağlanmıyor.**

## D.2 🔴 Uyumsuzluk 1 — uygulama **superuser** olarak bağlanıyor: RLS **tümüyle etkisiz** olur

```sql
SELECT rolname, rolsuper, rolbypassrls FROM pg_roles WHERE rolcanlogin;
-- postgres | t | t      ← login yapabilen TEK rol
```

```ts
// src/config/typeorm.config.ts:63
username: getEnvVar('DB_USERNAME') || 'postgres',
```

> **PostgreSQL'de superuser ve `BYPASSRLS` taşıyan roller satır güvenlik politikalarına tabi
> değildir — `FORCE ROW LEVEL SECURITY` de superuser'ı bağlamaz.** Yani bugünkü bağlantı
> kullanıcısıyla 43 tabloya politika yazılsa **hiçbiri uygulanmaz**, ve testler yeşil geçer.

Bu tam olarak `CLAUDE.md §2.7`'nin ailesidir: **koruma yazılmış görünür, hiçbir şey yapmaz.**

**Gereken:** ayrı, `NOSUPERUSER NOBYPASSRLS` bir uygulama rolü + `DB_USERNAME` değişikliği +
migration'ları çalıştıran rolün (tablo sahibi) **ayrı** kalması. Bu bir **dağıtım
kararıdır**, migration'la çözülmez (bugün deploy edilmiş ortam yok — [[T-157]]).

⚠️ Tablo **sahibi** de politikalara varsayılan olarak tabi değildir → her tabloda
`FORCE ROW LEVEL SECURITY` gerekir, yoksa migration/seed rolüyle yapılan her okuma sınırı
aşar.

## D.3 🔴 Uyumsuzluk 2 — `v_budget_summary` RLS'i **atlar**

```sql
SELECT viewname, viewowner FROM pg_views WHERE schemaname='main';   -- v_budget_summary | postgres
SELECT relname, reloptions FROM pg_class ... relkind IN ('v','m');  -- v_budget_summary | (null)
```

`reloptions` boş → `security_invoker` **kapalı**. PostgreSQL'de bir view'ın alt tablolarındaki
RLS politikaları, `security_invoker=true` verilmedikçe **view sahibine** göre değerlendirilir
— sahip `postgres` (superuser) olduğu için politikalar **hiç uygulanmaz**.

`v_budget_summary` bir bütçe okuma yolu (`BudgetSummaryView` entity'si
`typeorm.config.ts`'te kayıtlı). Yani RLS yazılsa bile **bütçe özeti tüm tenantları
döndürmeye devam ederdi.**

**Gereken:** view `WITH (security_invoker = true)` ile yeniden yaratılmalı (PG15+; bizde
16.13 → destekleniyor).

## D.4 🔴 Uyumsuzluk 3 — TypeORM havuzu + oturum değişkeni: **sızma yüzeyi**

Bugünkü veri erişim şekli:

```
@InjectRepository(...)   71 çağrı noktası / 40 dosya      ← singleton, varsayılan DataSource
createQueryRunner()      16
dataSource.transaction()  7
raw .query()             27 (migration'lar hariç)
typeorm.config.ts        `extra`/pool ayarı YOK → pg varsayılan havuzu
```

`@InjectRepository` ile alınan bir repository **istek başına bir bağlantıya bağlı değildir**;
her sorgu havuzdan **rastgele** bir bağlantı alır. Buradan iki tehlike doğuyor:

| yaklaşım | risk |
|---|---|
| `SET app.current_tenant = ...` (**oturum** kapsamlı) | Değişken bağlantı havuza **geri döndüğünde silinmez**. Bir sonraki isteğin sorgusu o bağlantıyı alırsa **önceki tenant'ın** bağlamında koşar. Bu, RLS'siz durumdan **daha kötüdür**: uygulama predicate'i doğruyken DB politikası yanlış tenant'ı açar. |
| `SET LOCAL app.current_tenant = ...` (**transaction** kapsamlı) | Güvenli — **ama yalnız açık bir transaction içinde anlamlıdır.** Bugünkü okumaların çoğu transaction'sız (implicit) çalışıyor; `SET LOCAL` kendi implicit transaction'ıyla biter ve **bir sonraki sorguda yoktur** → politika `current_setting`'i boş bulur. |

> **Yani RLS, bugünkü veri erişim şekline "bir migration ekleyerek" takılamaz.** Ya her
> istek bir `QueryRunner`'a/transaction'a bağlanmalı ve **tüm repository'ler o runner'dan
> türetilmeli**, ya da politika `current_setting('app.current_tenant', true)` boşken
> **fail-closed** davranacak biçimde yazılmalı (o zaman da transaction dışındaki her okuma
> **sıfır satır** döndürür — 71 çağrı noktası etkilenir).

⚠️ **Bu bir tasarım riskidir, bir ölçüm değildir.** Yukarıdaki iki satır PostgreSQL ve
TypeORM'un belgelenmiş davranışından çıkarılmıştır; **bu turda koşturularak ölçülmedi.**

📌 `CLAUDE.md §7` (önce ara): repo'da **zaten** bir istek-kapsamlı bağlam mekanizması var —
`src/common/services/recalc-telemetry.service.ts` `AsyncLocalStorage` kullanıyor. Yeni bir
tenant-context katmanı yazılacaksa **o desen incelenmeli**, sıfırdan başlanmamalı. Ve
`AccessScopeService`'in sınıf başlığı `Scope.REQUEST`'in **bilinçli olarak kullanılmadığını**
ve gerekçesini yazıyor — o gerekçe bu kararda yeniden okunmalı.

### 🔬 Bunu ölçecek deney (öneri — bu turda YAPILMADI)

Amaç: *"havuzdan gelen bir bağlantı önceki isteğin tenant bağlamını taşıyor mu?"*

1. Bir migration ile **tek bir tabloda** (öneri: `main.notifications` — finansal değil,
   geri alması ucuz) RLS + `FORCE` + `USING (tenant_id = current_setting('app.current_tenant')::uuid)`.
2. `NOSUPERUSER NOBYPASSRLS` bir test rolü yarat, `DB_USERNAME`'i ona çevir.
3. Havuzu **kasten daralt** (`extra: { max: 1 }`) — böylece iki istek **aynı** bağlantıyı alır.
4. Tenant A'nın isteği `SET` (LOCAL değil) ile bağlamı kursun; hemen ardından **tenant B'nin**
   isteği aynı bağlantıdan bir okuma yapsın.
5. **Ölçüm:** B'nin okuması A'nın satırlarını görüyor mu? `SELECT current_setting('app.current_tenant', true)`
   B'nin isteğinde ne dönüyor?
6. Aynı deneyi `SET LOCAL` + transaction'sız okuma ile tekrarla — beklenen sonuç **sıfır satır**
   (fail-closed), ve o da ayrıca ölçülmeli çünkü **77 route'un davranışını değiştirir**.

⚠️ `CLAUDE.md §2.7`: deney kurulumunun ölçtüğü durumu değiştirmediğini doğrula — özellikle
adım 3'te havuzu daraltmak **yarışı üretmek için** yapılıyor; darlığı kaldırınca risk
kaybolmaz, yalnız **seyrekleşir** (yani "geçti" sonucu havuz geniştken bir kanıt değildir).

## D.5 Migration'ın geri alınabilirliği

**İyi haber:** RLS DDL'i **veri taşımaz.**

```sql
-- up
ALTER TABLE main.<t> ENABLE ROW LEVEL SECURITY;
ALTER TABLE main.<t> FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON main.<t> USING (...);
-- down
DROP POLICY tenant_isolation ON main.<t>;
ALTER TABLE main.<t> NO FORCE ROW LEVEL SECURITY;
ALTER TABLE main.<t> DISABLE ROW LEVEL SECURITY;
```

`down` **tam** ve **veri kaybı yok** — K1(c)'nin enum yeniden yazımından farklı olarak bu
karar **geri alınabilir**. §F'nin "geri alınamaz" maddesi RLS migration'ına **uygulanmaz**.

**Ama geri alınabilir OLMAYAN üç yan bileşen var** ve karar bunları ayırmalı:

| bileşen | geri alınabilir mi |
|---|---|
| RLS politikaları (40 tablo) | ✅ tam |
| `v_budget_summary`'nin `security_invoker` ile yeniden yaratılması | ✅ (view yeniden yaratılır) |
| **Ayrı DB rolü + `DB_USERNAME` değişikliği** | 🟡 dağıtım kararı — kod değil |
| **İstek-kapsamlı transaction/QueryRunner refactor'ü** (D.4) | 🔴 **71 çağrı noktasına dokunur; geri alması bir migration değil, bir revert'tür** |

> **Asıl maliyet migration'da değil, D.4'ün refactor'ünde.** Karar verilirken ölçek buradan
> okunmalı.

## D.6 Guard: RLS'in kendisi de korunmalı

`INV-T-003` bugün `Guard: NONE`. Politikalar yazılırsa bir sonraki migration onları
**sessizce** düşürebilir (ya da yeni bir tablo politikasız doğabilir — 43'ten 44'e).

Gereken guard (`scripts/guards/`):

```
main şemasındaki, tenant_id taşıyan HER tabloda relrowsecurity = true
  ve en az bir pg_policies satırı  →  aksi hâlde exit 1
```

⚠️ `CLAUDE.md §2.7 #9`: kapsamı **çalışan ağaçtan** değil, **katalogdan** türetilmeli
(yeni bir tablo eklendiğinde otomatik kapsansın), ve guard **kasten bir tabloyu politikasız
bırakarak** sınanmalı — yoksa "hep yeşil" bir kapı olur.

---

# E. Sıra ve bağımlılık

## E.1 T-167 (RLS) ↔ T-165 (RBAC) — hangisi önce?

**Bağımsızlar; ama T-165 daha ucuz, daha az geri alınamaz ve ölçülmüş bir kusur kapatıyor.**

| | T-165 (RBAC) | T-167 (RLS) |
|---|---|---|
| bugün ölçülmüş **aktif** kusur | ✅ A.4.1 (CM onay ekranına giremiyor) · A.2.1 (READONLY yazabiliyor) | ❌ tek tenant, cross-tenant sızıntı bugün **gözlenemez** |
| ön koşulu var mı | ❌ | ✅ **D.2 (ayrı DB rolü)** + **D.4 (transaction katmanı)** |
| geri alınabilirlik | yüksek (K1b/K3b/K3c migration'sız) | politikalar ✅, refactor 🔴 |
| Phase 1 statüsü (`§7.7`) | ✅ | ✅ |

> **Öneri (karar ürün sahibinin):** `T-165 → T-167`. Gerekçe ölçülü: T-165'in en ucuz
> seçenekleri (K1b · K7 · K3c) **şema değiştirmiyor** ve bugün **canlı** bir yanlış
> davranışı kapatıyor; T-167 ise iki ön koşulu (D.2, D.4) çözülmeden **yazılsa bile
> etkisiz** olur — ve etkisiz bir RLS, `INV-T-003`'ü **kapalı gösterir**. Bu, bu projede
> ölçülmüş en pahalı hata sınıfıdır.

⚠️ **Ama bir karşı-argüman var ve kaydedilmeli:** RLS *"second-customer gate"*tir
(`SYSTEM_INVARIANTS §9 D-11`). İkinci müşteri taahhüdü **T-165 bitmeden** gelirse sıra
tersine döner — ve o zaman A.1.2 (login tenant çözümü, K10) de **aynı anda** çözülmelidir.

## E.2 [[T-168]] (audit sözlüğü) nasıl bağlanıyor

İki yönlü, ve **T-165'ten sonra gelmeli**:

- `§7.4`'ün 20 olayından **üçü doğrudan bu belgenin konusu**: `PERMISSION_DENIED` ·
  `USER_LOGIN` · `USER_LOGOUT`. `PERMISSION_DENIED`'ın **şekli** K3'e bağlı: yetenek katmanı
  varsa olay `capability` alanı taşır, yoksa yalnız `role` + `route`. **Sözlük, yetki
  modelinden önce yazılamaz.**
- `§3.2` Functional Scope: *"Audit logging (login attempts, **permission checks**, role
  changes)"* — yani rol değişikliği bir audit olayıdır, ve K2 (çok-rol) seçilirse
  *"hangi rol eklendi/çıkarıldı"* şekli değişir.
- Ters yön: `§7.6` *"**Role change** → all sessions invalidated"* bugün **ölçülmedi**
  (`docs/analysis/0040 §5`). Bu bir T-165 çıktısı mı T-168 çıktısı mı — **sınır belirsiz**,
  önerim T-165'e bağlanması (yetki değişikliğinin etkisi).

## E.3 [[T-170]] (regülasyon) nasıl bağlanıyor

**T-167'ye bağlı, T-165'e teğet:**

- KVKK/GDPR *"Deleted users: **Anonymized** (`user_id` retained for audit trail)"* → kullanıcı
  silme akışı yetki modelinin bir parçası. K2(a) (junction) seçilirse anonimleştirme
  `user_roles` satırlarını da kapsamalı.
- 7 yıl saklama + `INV-T-003` birlikte: **RLS'siz bir sistemde 7 yıllık finansal veri
  tutmak**, bir tenant sınırı hatasının 7 yıllık geçmişi açması demektir. T-170'in risk
  argümanı T-167'yi **güçlendiriyor**, ama sırasını değiştirmiyor (bugün deploy edilmiş
  ortam ve gerçek veri yok — [[T-157]]).

## E.4 Bu belgenin doğrudan ürettiği takip işleri (task, TODO değil)

`CLAUDE.md`: *"Bilinen eksiklik TODO ile değil, TASK ile kaydedilir."* Aşağıdakiler karar
gerektirmeyen, **ölçülmüş** kusurlardır ve kendi task'larını hak ediyor:

| # | bulgu | referans |
|---|---|---|
| 1 | Frontend route'ları kanonik rolleri dışlıyor (CM plan onayına giremiyor) | A.4.1 |
| 2 | `POST /spend-calculation/recalculate-on-volume-change/:skuId` — rol filtresi ve scope kontrolü yok | A.2.1 |
| 3 | Dört ölü tenant/admin mekanizması (ikisi başlık-güvenir) | A.1.1 · K9 |
| 4 | `findByEmailWithoutTenant` — çok-tenant'ta belirsiz login | A.1.2 · K10 |
| 5 | `users.permissions` — ölü jsonb kolon | B.4 · K4 |
| 6 | `UQ_user_scopes_user_cpl_category` nullable kolonlarda tekillik sağlamıyor | A.3.2 · K5 |
| 7 | `docs/analysis/0049 §4`'ün *"Read-Only karşılığı yok"* satırı bayat | B.1 |

⚠️ **Bunları ben açmadım** — bu tur salt-okunur. Task açma kararı Team Lead'indir.

---

# F. ⛔ DUR — kendim karar vermediğim noktalar

## F.1 🔴 ADR 0002 ile `§7.1`/`§7.3` **çelişiyor** — ve ADR'nin dayanağı süperseded bir kaynak

**ADR 0002** (`docs/decisions/0002-finance-manager-escalation-onayi.md`):

> *"BRD'nin sabit RBAC tanımında **Finance Manager = "okuma + bütçe"** olarak geçiyor; onay
> yetkisi Category Manager'a verilmiş."*
> **Karar:** *"Finance Manager, YALNIZCA `PENDING_FINANCE_REVIEW` durumundaki planları
> onaylayabilir. Normal `PENDING_APPROVAL` akışında FM'nin onay yetkisi YOKTUR (403)."*

**Ama bağlayıcı BRD bunu söylemiyor.** `Section_07 §7.1` Role 3 *Finance Approver*:

```
✅ View all approval requests (cross-channel visibility)
✅ Approve plans/agreements (Level 2, typically final)
✅ Override budget warnings (with audit trail)
Scope Constraints: No channel/region constraints (global view)
                   Approval triggered by: amount threshold OR ROI threshold
```

ve `§7.3` politika yapısı L2'yi **eşiğe göre** `APPROVER_FINANCE`'a yönlendiriyor
(`{"order": 2, "role": "APPROVER_FINANCE", "when": {"OR":[{"amount_gte":50000},{"gp_roi_pct_lt":15}]}}`).

**ADR 0002'nin dayandığı cümlenin kaynağı ölçüldü:**

```
.cursor/rules.md:43   "Finance Manager → okuma + bütçe yönetimi"
docs/brd/01_Main_BRD/Section_07 §7.1  → "Approve plans/agreements (Level 2, typically final)"
```

> `.cursor/rules.md` `CLAUDE.md §2.1`'e göre **normatif değildir** ve ADR 0010 `.cursor/*.pdf`'i
> **süperseded** ilan etmiştir. **ADR 0002 "BRD'nin bilinçli genişletmesi" olarak yazılmış,
> ama ölçüm onun BRD'nin bir DARALTMASI olduğunu gösteriyor** — ve daraltmanın gerekçesi
> (*"BRD'de FM okuma+bütçe"*) bağlayıcı kaynakta yok.

**Neden şimdi önemli:** K3 yetenek katmanını getirirse `plan.approve_L2` yeteneği
`FINANCE_MANAGER`'a verilecek — ve ADR 0002 onu `PENDING_FINANCE_REVIEW` dışında
**reddediyor**. İki kural aynı anda kodlanamaz.

**Seçenekler (karar ürün sahibinin, `CLAUDE.md §2.1`: ADR kazanır — ama bilerek):**

| | sonuç |
|---|---|
| **a) ADR 0002 korunur** | Bugünkü davranış sürer. ADR'ye bir **errata** eklenmeli: dayanak `rules.md`'ydi, bağlayıcı BRD farklı diyor, karar yine de bilinçli olarak korunuyor **çünkü …**. Aksi hâlde bir sonraki okuyucu ADR'nin gerekçesini doğrulayamaz. |
| **b) ADR 0002 `§7.3`'e göre yeniden yazılır** | FM, eşik/ROI ile tetiklenen L2 onaycısı olur. ⚠️ Ama `approval_policies` tablosu **yok** ([[T-153]]) — yani eşik yönlendirmesi bugün **uygulanamaz**. Yani (b) **T-156'ya bağımlıdır**. |
| **c) Karar T-156'ya ertelenir** | Bu belge yalnız çelişkiyi kaydeder; K3 uygulanırken ADR 0002 **istisna olarak** kodlanır ve gerekçesi yorumda ADR'ye atıfla yazılır. |

## F.2 ⚠️ Veri taşıyan ortamda geri alınamaz sonucu olan kararlar

`CLAUDE.md`: geri alınamaz sonucu olan kararı ajan vermez.

| karar | geri alınabilirlik |
|---|---|
| **K1(c)** enum yeniden yazımı (`ALTER TABLE ... TYPE` + eski tipi düşür) | 🔴 Veri taşıyan ortamda `down`'ı yazmak, düşürülmüş enum tipini ve satır değerlerini yeniden kurmayı gerektirir. **Kazanımı kozmetik** — K1(b) aynı sonucu migration'sız veriyor. |
| **K5(a)** `region_id` kolonu + fail-closed enforcement | 🟡 Kolon geri alınabilir; ama `main.regions` **0 satır** iken enforcement açılırsa **her kullanıcı her şeyi kaybeder** ve bunu geri almak bir migration değil, bir **veri doldurma** işidir. |
| **K2(a)** junction'a geçiş | 🔴 `users.role` kolonundan `user_roles` satırlarına taşınan veri; `down` çoklu rolü tekile indirmek zorunda kalır → **kayıp**. |
| **D.5** RLS migration'ı | ✅ **geri alınabilir** — bu belgede tek "güvenli" büyük madde. |

> Bugün üretim ortamı **yok** ([[T-157]]) — yani bu maddelerin bugünkü maliyeti düşük. **Ama
> karar bugün verilip yarın uygulanırsa maliyet değişir.** Kararın yanına **hangi ortamda
> geçerli olduğu** yazılmalı (`CLAUDE.md`: *"bir ölçümün geçerliliği koşullarına bağlıdır"*).

## F.3 ⚠️ Kaynağın kendisine itiraz (`CLAUDE.md §2.1.2` — BRD bir girdidir, kanıt değil)

| `§7.2` ne diyor | itiraz |
|---|---|
| `canUserAccessPlan` sözde-kodu: `if (!user.capabilities.includes(action)) return {allowed:false}` ve ardından **sırayla** scope kontrolleri | Sözde-kod **`user.scope.channels` `null` ise kontrolü atlıyor** (`if (user.scope.channels && ...)`). Yani **kapsamsız kullanıcı = sınırsız kullanıcı** — bu bir **fail-open**'dır. Bizim `AccessScopeService` R-2 ile **fail-closed** yapıyor ve **daha doğru**. `CLAUDE.md`: sapmayı gerekçesiyle kaydet, sessizce uyma. **Bu sapma korunmalı.** |
| `§7.2` `plan.create` ↔ `§2.6` `plans.create` | Kaynak kendi içinde tutarsız (B.4). Bir kanonik yazım **seçilmeli**, ve seçimin kaynağı bu belge olmalı. |
| `§7.1` *"Users can hold multiple roles"* ↔ *"User cannot be both Planner and Approver for the same channel/CPL (**policy warning**)"* | Kaynak çok-rolü istiyor ve tehlikesini aynı paragrafta *"uyarı"* düzeyinde bırakıyor. **Bir finansal onay sisteminde görev ayrılığı bir uyarı değil, bir kısıt olmalıdır.** K2(a) seçilirse bu **hata** olarak uygulanmalı, uyarı olarak değil — ve bu bir sapmadır, kaydedilmeli. |

## F.4 ⚠️ RLS'in bugünkü mimariyle uyumsuz olduğunu düşündüren somut şeyler

Üçü de §D'de ölçüldü ve **karar öncesi bilinmeli**:

1. **D.2** — uygulama superuser olarak bağlanıyor; RLS **hiç uygulanmaz**, testler yine yeşil geçer.
2. **D.3** — `v_budget_summary` `security_invoker` kapalı; RLS'i **atlar**.
3. **D.4** — `@InjectRepository` singleton repository'leri + havuz; `SET`/`SET LOCAL` ikisi de
   olduğu gibi güvenli değil. Bu bir **tasarım riski** olarak yazıldı, **ölçülmedi** — ölçecek
   deney D.4'te önerildi.

> **T-167 "43 tabloya politika yaz" olarak kapsamlanırsa üçü de kapsam dışında kalır ve
> sonuç etkisiz bir korumadır.** Kapsam bu üçünü içermeli, ya da task bilinçli olarak
> "yalnız hazırlık" diye adlandırılmalı.

---

# G. 📄 Tek sayfalık karar özeti

> **Ürün sahibi için.** Her satır bir karar; ⭐ = bu turda cevap gerekiyor.

### Ölçülen durum, üç cümlede

1. **Rol kümemiz BRD ile zaten hizalı** (5 kanonik rol: `ADMIN · PLANNER · CATEGORY_MANAGER ·
   FINANCE_MANAGER · READONLY`). Eksik olan **yetenek katmanı** ve **kapsam eksenleri**.
2. **Yetkilendirme üç ayrı yerde yazılı** (backend guard'lar · backend servisler · frontend
   hook'ları) ve **frontend ile backend ölçülebilir biçimde çelişiyor**: Category Manager,
   BRD'nin birincil onaycısı, plan onay ekranına **giremiyor**.
3. **Tenant izolasyonu veritabanında sıfır** (0/43 tablo, 0 politika) ve RLS bugünkü
   mimariye **olduğu gibi takılamaz**: uygulama superuser bağlanıyor (politikalar etkisiz
   olur), bir view RLS'i atlar, ve havuzlu bağlantılarda tenant değişkeni **sızabilir**.

### Kararlar

| # | soru | seçenekler | en sade olan |
|---|---|---|---|
| ⭐ **K1** | Deprecated rol etiketleri | a) dokunma · **b) frontend'i kanonikleştir + lint'i port et** · c) enum'u yeniden yaz | **b** — migration yok, ölçülmüş kusuru kapatır |
| ⭐ **K2** | Çok-rol (junction) gerekli mi | a) `user_roles` (BRD) · **b) enum kalsın** · c) override ile ara yol | **b** — bugün ölçülmüş bir kısıt yok; (a) ADR 0002'yi yeniden açar |
| ⭐ **K3** | Yetenek granularitesi | a) 20 yetenek + tablolar (BRD) · **b) sabit yetenek listesi, tablo yok** · c) yalnız `@Roles` tamamlansın | **b/c** — (a) K8'i zorunlu kılar |
| **K4** | `user_permission_overrides` | a) gelsin (BRD) · **b) gelmesin** · c) ertelensin | **b** — kaynak bile *"use sparingly"* diyor |
| ⭐ **K5** | Kapsam eksenleri | a) channel+region+cpl (BRD) · **b) channel'ı aç, region'ı ertele** · c) bugünkü tek eksen | **b** — kolon zaten var, migration gerekmez |
| ⭐ **K6** | `SCOPE_ENFORCEMENT_ENABLED` | a) şimdi aç · b) koşul yaz · c) kalıcı kapalı | — **bugün PLANNER tüm tenant'ı görüyor** |
| ⭐ **K7** | `RolesGuard` fail-open | a) fail-closed · b) 77 route'a `@Roles` · **c) fail-closed + guard script** | **c** — regresyonu da kapatır |
| **K8** | Yetki veri olursa konfigürasyon yolu | **a) tablo+controller+provisioning birlikte** · b) tablo önce · c) sabit kalsın | K3(a)/K4(a) seçilirse **a zorunlu**; **b kabul edilemez** (T-101 tekrarı) |
| **K9** | Dört ölü mekanizma | **a) silinsin** · b) yeniden yazılsın · c) bırakılsın | **a** — ikisi başlık-güvenir, canlandırılırsa sızıntı |
| **K10** | Login'in tenant çözümü | a) `x-tenant-id` zorunlu · b) e-posta global tekil · **c) çoklu eşleşmede açık hata** | **c** — migration yok, sessiz seçimi bitirir |

### ⛔ Ürün sahibine giden çelişki

**ADR 0002 ile bağlayıcı BRD `§7.1`/`§7.3` çelişiyor** (§F.1). ADR, Finance Manager'ı yalnız
`PENDING_FINANCE_REVIEW`'a kısıtlıyor; BRD ona eşik/ROI ile tetiklenen **genel Level-2 onay
yetkisi** veriyor. ADR'nin gerekçe cümlesinin kaynağı `.cursor/rules.md:43` — **normatif
olmayan, süperseded bir özet**. Karar: **korunsun + errata** · **BRD'ye göre yeniden
yazılsın (T-156'ya bağımlı)** · **ertelensin**.

### Sıra önerisi

```
T-165 (RBAC)  →  T-167 (RLS)  →  T-168 (audit sözlüğü)  →  T-156 (politika katmanı)
```

**Gerekçe:** T-165'in ucuz seçenekleri şema değiştirmiyor ve **bugün canlı** bir yanlış
davranışı kapatıyor; T-167 ise iki ön koşulu (ayrı DB rolü · istek-kapsamlı transaction
katmanı) çözülmeden **yazılsa bile etkisiz** olur — ve etkisiz bir RLS `INV-T-003`'ü
**kapalı gösterir**.

⚠️ **Bunu değiştirecek şey:** ikinci bir müşteri/tenant taahhüdü. O durumda T-167 öne geçer
ve **K10 aynı anda** çözülmelidir.

### Bu turda YAPILMAYAN

Kod, şema, migration **yazılmadı**. D.4'ün havuz/RLS deneyi **koşturulmadı** (tasarım riski
olarak yazıldı, ölçüm olarak değil). 77 filtresiz route'un her biri için hangi rolün doğru
olduğu **belirlenmedi** — o bir ürün kararı (K7).

---

**Kaynaklar:** `docs/brd/01_Main_BRD/Section_03_Core_Components.md §3.2` (322–384) ·
`Section_07_Security_Roles.md §7.1` (22–176) `§7.2` (176–253) `§7.5` (487–531) `§7.7` (547–601) ·
`Section_02_Product_Overview.md` "Permission Model Integration" (880–906) ·
`Section_11_Assumptions_Risks.md` D5/D10 (174–228) ·
`docs/decisions/0002` · `0010` · `docs/contracts/SYSTEM_INVARIANTS.md` `INV-T-001/002/003`, `§9 D-11`, `§11` ·
`docs/analysis/0037` · `0039 §2` · `0040` · `0041 §1,§4` · `0049 §4` · `0052 §1,§4` · `0055 §2.1`
