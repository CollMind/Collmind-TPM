# 0004 — RBAC / BRD Hizalama Tasarımı — T-028

- **Tarih:** 2026-07-28 · **Kaynak:** T-028 architect
- **Karar:** KOŞULLU ONAY — **tek task olarak yapılamaz**, 4 parçaya bölünür (T-028a/b/c/d)

## Bağlayıcı koşullar
1. **Scope mantığı 3. kez elle yazılmayacak** → `shared/access-scope/access-scope.service.ts` tek çıkış noktası; dashboard + settlement kopyaları buna refactor edilir.
2. **Deny-by-default:** scope satırı olmayan PLANNER/CM **hiçbir şey görmez**.
3. **Enum'dan değer SİLİNMEYECEK** (PostgreSQL kısıtı, migration 1775 dersi) → konsolidasyon = veri göçü + koddan çıkarma.
4. **FINANCE_MANAGER'a genel plan onay yetkisi VERİLMEYECEK** — yalnız `PENDING_FINANCE_REVIEW` hattı; **bu BRD sınırında, ürün onayı gerekir (R-3).**

## 1. Kanıtlanmış bulgular
| # | Bulgu | Kanıt |
|---|---|---|
| F1 | CM plan modülünde **hiç yok** | `plan.controller.ts` 22 `@Roles` listesinin hiçbirinde CATEGORY_MANAGER yok; approve/reject = `(ADMIN, MANAGER)` |
| F2 | Plan scope yok | `plan.service.findAll/findById` `userId`/`role` **parametresi bile almıyor** |
| F3 | Approval queue filtresiz | `approval-workflow.service.ts:575` `// TODO: Implement role-based filtering` — userId alınıyor, kullanılmıyor |
| F4 | `findPendingApprovals` tenant-wide | yalnız status filtresi |
| F5 | UserScope yalnız 2 yerde | dashboard + settlement-summary |
| **F6** | **Latent bug:** `resolveCplScope` `cplId=null` ("tüm CPL'ler") → `.filter(id => !!id)` ile sessizce **"hiçbiri"** oluyor | `dashboard.service.ts:304` |
| **F7** | Legacy approve'da **self-approval koruması YOK** | `plan.service.approve()` — Planner+Admin çift hesabıyla bypass |
| F8 | FM finance-reporting'de 403 (ama CM var — ters) | `finance-reporting.controller.ts:39` |
| F9 | Planner kendi planının budget-check'ine 403 | `plan.controller.ts:99` |
| F10 | Master-data okuma tüm rollere açık (`@Roles` yok → guard true) — kasıtlı, belgelenmeli | `cpl.controller.ts:49,60` |
| F11 | JWT her istekte DB'den user çekiyor → rol değişikliği **anında** yansır ✅ | `jwt.strategy.ts:21` |

## 2. Rol konsolidasyonu — Seçenek C
"Canonical 4 + 1 operasyonel, alias'lar dondurulur"

| Enum | Statü | Hedef |
|---|---|---|
| ADMIN / PLANNER / CATEGORY_MANAGER / FINANCE_MANAGER | **canonical** | BRD'nin 4 rolü |
| READONLY | operasyonel (BRD-dışı, korunur) | Yeni yetki vermez, Admin okumasının alt kümesi; **hiçbir write route'unda görünmez** |
| MANAGER → CATEGORY_MANAGER · FINANCE → FINANCE_MANAGER · APPROVER → CATEGORY_MANAGER | **deprecated alias** | enum'da kalır, kodda kullanılmaz |

**Eşleme yönü gerekçesi:** MANAGER bugün fiilen plan/agreement onaylıyor → BRD'de bu iş CM'nin.
FINANCE bugün budget+raporlama sahibi → BRD'de bu FM'nin. Ters eşleme BRD adını kaybettirir.

**Geçiş:** migration UPDATE-only (enum'a dokunma) + `@deprecated` JSDoc + **ESLint `no-restricted-syntax`**
ile `UserRole.MANAGER|FINANCE|APPROVER` kullanımını `src/modules/**` altında hata yap (asıl regresyon kalkanı).
`user.seed.ts` rolleri güncellenir (**e-posta adresleri korunur** ki e2e login'leri kırılmasın).
Frontend etkisi düşük: `agreements.service.ts`, `DashboardPage.tsx`'e yeni rol adları **eklenir** (silme yok → geriye uyumlu).

> ⚠️ Migration numarası: architect `1790` demiş ama **1790 kullanıldı** (T-030 backfill) → **1791+** kullanılacak.

## 3. CM kategori-scoped onay
Scope kaynağı `user_scopes.category_id`; CM için `cpl_id` yok sayılır (kategori sahibi, kanaldan bağımsız).

| Yol | CM |
|---|---|
| `GET /plans` | `categoryId IN (CM kategorileri)` |
| `GET /plans/:id` kapsam dışı | **404** (varlık sızdırma yok) |
| approval-queue / pending-approvals | PENDING_APPROVAL **AND** kategori kesişimi |
| approve / reject / review | kesişim yoksa **403**; `submittedById === user.id` → **403** (F7) |
| create / update / FU / SKU | **403** — BRD "CM plan düzenleyemez" |
| budget-check / analysis / approval-history | kategori-scoped okuma (onay kararı için) |

## 4. AccessScopeService (ortak)
```
resolveScope(tenantId, userId, role) → { kind:'UNRESTRICTED' } | { kind:'SCOPED', pairs:[{cplId,categoryId}] }
assertEntityInScope(scope, {cplId, categoryId})   // 403
isInScope(scope, {...})                            // 404 kararı
applyToQueryBuilder(qb, alias, scope)              // OR-grubu
```
**Kritik tasarım noktaları:**
1. **Pair semantiği — düzleştirme YASAK (R-1).** `cplIds[] × categoryIds[]` düzleştirmesi **fazladan yetki verir**:
   (CPL1,CatA) + (CPL2,CatB) atanmışsa düzleştirme (CPL2,CatA)'yı da açar. Predicate satır-bazlı OR:
   `(row.cplId IS NULL OR plan.cplId=:cpl_i) AND (row.categoryId IS NULL OR plan.categoryId=:cat_i)`
2. **NULL = "hepsi"** (F6 fix) — tek satır `{null,null}` varsa `UNRESTRICTED`.
3. Rol semantiği tek yerde: ADMIN/FM/READONLY → UNRESTRICTED · PLANNER → cpl+category pair · CM → yalnız category · `pairs.length===0` → **`1=0`** (fail-closed, R-2).
4. Perf: request başına 1 sorgu + kısa TTL cache (`Scope.REQUEST` **kullanma** — tüm zinciri request-scoped yapar).
5. Multi-tenant: `tenantId` zorunlu.
6. **Guard değil servis** — enforcement service katmanında (DTO şekilleri heterojen); guard yalnız rol filtresi.

## 5. Modül × rol hedef matrisi (özet)
`R`=read `W`=write `A`=approve `(s)`=scope `(c)`=kategori-scope

| Modül | ADMIN | PLANNER | CATEGORY_MANAGER | FINANCE_MANAGER | READONLY |
|---|---|---|---|---|---|
| plan | RWA | RW (s) | R (c) · **A (c)** | R | R |
| plan · budget-check | R | **R (s)** ←F9 | R (c) | R | R |
| plan · approval-queue | R | – | **R (c)** ←F1 | R (yalnız PENDING_FINANCE_REVIEW) | R |
| agreement | RWA | RW (s) | R (c) · A (c) | R | R |
| reversal | RW | – | – | **RW** | R |
| budget / budget-allocation | RW | R / – | R | **RW** ←FINANCE→FM | R |
| finance-reporting | R | R (s) | R (c) | **R** ←F8 | R |
| dashboard | R | R (s) | R (c) | R | R |
| master-data | RW | R | R | R | R |
| admin (KPI/config) / tenant | RW | – | – | – | – |

**Değişmez sertlikler:** PLANNER hiçbir approve route'unda yok · CM hiçbir plan/agreement write'ında yok · READONLY hiçbir POST/PATCH/DELETE'te yok.

## 6. UserScope seed
| Kullanıcı | Scope | Amaç |
|---|---|---|
| `planner@wella.com` | NKA kanalı CPL'leri × `categoryId=null` | pozitif yol |
| **YENİ** `planner2@wella.com` | Distribütör CPL'leri | cross-planner negatif test |
| `category.manager@wella.com` | `cplId=null` × 2 kategori | CM pozitif + kategori-dışı 403 |
| **YENİ** `category.manager2@wella.com` | farklı 1 kategori | CM cross-category negatif |
| ADMIN/FM/READONLY | satır yok | UNRESTRICTED |

**Geçiş riski (kritik):** Deny-by-default açıldığı anda seed'i olmayan PLANNER **her şeyi kaybeder**.
Sıra zorunlu: **önce seed, sonra enforcement**. Prod/UAT için backfill migration — mevcut Planner'lara
geçmiş planlarının CPL/Category kümesinden scope türet; planı olmayan için manuel atama (release notu).

## 7. Riskler
| Risk | Azaltım |
|---|---|
| **R-1 scope düzleştirme** (yüksek, BRD ihlali) | pair semantiği zorunlu |
| **R-2 boş scope = her şey** (fail-open, yüksek) | `pairs.length===0 → 1=0` |
| ~~R-3 FM'nin escalation onayı~~ **ÇÖZÜLDÜ** | ✅ Ürün sahibi onayladı (2026-07-28): FM **yalnız `PENDING_FINANCE_REVIEW`** onaylar; `PENDING_APPROVAL`'da 403. Karar kaydı: `docs/decisions/0002-finance-manager-escalation-onayi.md` |
| R-4 READONLY BRD'de yok | yeni yetki vermez; e2e N10 sürekli koruma |
| R-5 rol/scope değişikliği audit'lenmezse | BRD §10 ihlali |
| **R-6 F7 self-approval** | düzeltilmezse "Planner onaylayamaz" dolaylı delinir |
| Deny-by-default prod'da körleşme | backfill + feature flag `SCOPE_ENFORCEMENT_ENABLED` |
| OR-grubu index kullanmaz | `cplId IN (...)` ön-filtresi + EXPLAIN <500ms |

## 8. Kapsam bölme
| Task | İçerik | Bağımlılık | Risk |
|---|---|---|---|
| **T-028a** | Rol konsolidasyonu (migration + @Roles matrisi + seed + frontend; F8/F9 fix) | — | Orta |
| **T-028b** | AccessScopeService + UserScope seed + CM kategori-scoped onay (F1/F3/F4/F7) | T-028a | Orta |
| **T-028c** | Planner scope enforcement (plan+agreement) + backfill + feature flag | T-028b | **Yüksek** — ayrı release |
| **T-028d** | dashboard/settlement refactor → ortak servis + **F6 fix** | T-028b | Düşük |

## 9. E2E — "roller birbirinin yetkisini kullanamaz" negatif testleri
N1 CM→create 403 · N2 CM→update 403 · N3 CM→başka kategori GET **404** · N4 CM→başka kategori approve 403 ·
N5 PLANNER→approve 403 · **N6 PLANNER→yetkisiz CPL create 403 (bugün 201)** · N7 PLANNER liste < ADMIN ·
N8 PLANNER→başka planner'ın planı 404 · N9 scope'suz PLANNER → `[]` · N10 READONLY→her write 403 ·
N11 FM→PENDING_APPROVAL approve 403 · **N12 self-approval 403 (F7)** · N13 cross-tenant · N14 `user_scopes` boş değil.
