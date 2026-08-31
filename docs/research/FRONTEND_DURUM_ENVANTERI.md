# `collmind.frontend` — DURUM ENVANTERİ (salt-okunur ölçüm)

- **Tarih:** 2026-08-31
- **Ölçüm temeli:** `collmind.frontend` @ `280035d` *(T-344 (Q14) FE — B3 ölümü, submit geri-bildirimi)*
- **Yöntem:** yalnız statik ölçüm (`rg`/`sed`/dosya sayımı). **Hiçbir test, guard, e2e ya da dev
  sunucu koşturulmadı** (brief yasağı) — bu, `§7`'nin birinci maddesidir.
- **Kapsam:** `src` (147 `.tsx` + 76 `.ts`, 43.768 satır) · `tests` (68 test dosyası) ·
  doğrulama için `collmind.backend/src` (salt-okunur)

> ⚠️ **Ölçüm aracı notu (bir kez yakalandı, kayda geçiyor):** bu turda `rg` çıktısı renk
> kaçış dizileriyle **okunamaz hâle geldi** ve `audit-log` bir noktada `il-log` gibi
> göründü. Aşağıdaki tüm sayımlar `--color never` ile **yeniden** alınmıştır.
> İkinci araç hatası: `sed 's/\.tsx\?$//'` BSD `sed` BRE'sinde `\?` desteklemediği için
> **hiçbir şey yapmadı** ve ilk ölü-kod taraması `src`'in TAMAMINI "ölü" ilan etti
> (`DISIPLIN` maskeleme sınıfı #5). `sed -E` ile düzeltildi; poz. kontrol:
> `DashboardPage` listeden düştü.

---

# `§1` · `🔒` VAKALARI — "mekanizma var, ona giden yol yok"

## 1.1 `EK_E`'nin üç `🔒` kalemi — bugünkü hâli

| `EK_E` kalemi | backend ucu | FE'de çağıran | ekranda yol | bugünkü işaret |
|---|---|---|---|---|
| **Anlaşma kapanışı** | ✅ `POST actuals-first/settlements/close/:agreementId` (`settlement.controller.ts:112`) | **YOK** — FE'de `settlement*` adlı **hiçbir endpoint dosyası yok** | yok | **`🔒` DEVAM** |
| **Formül doğrulaması** | ✅ `POST /master-data/kpis/validate-formula` (`kpi.controller.ts:168`) | `kpiEndpoints.validateFormula` **tanımlı** (`kpi.endpoints.ts:93`), **çağıran 0** | yok | **`🔒` DEVAM** |
| **Kapsam atama** | ✅ `POST /users` (`scope`) + `PATCH /users/:id/scope` (`update-user-scope.dto.ts`) | **YARIM**: `UserForm.tsx:229` → `UserScopeFields`, `UserForm.tsx:105-119` `scope` payload'u kuruyor → **create yolu KAPANDI**. `PATCH …/scope` için FE'de **sıfır** iz (`rg "/scope\|updateScope\|UpdateUserScope" src` → boş) | create ✅ / update ❌ | **YARI-AÇIK — güncelleme hâlâ `🔒`** |

⛔ **`EK_E` bu üç satırda GÜNCEL DEĞİL** (kapsam-create kapandı). `EK_E` donmuş belge olduğu
için burada **rapor edilir**, düzeltilmez — karar Team Lead'de.

## 1.2 Team Lead'in vakası — **DOĞRULANDI ve ÜÇ KUSUR taşıyor**

`PlanningGridEnhanced.tsx:825-841`:

```
825  const { data: applicableMechanics = [] } = useQuery({
828    queryFn: async () => {
830        const res = await mechanicEndpoints.getAll(true);      ← YANLIŞ UÇ
832        return res.data.filter((m: any) => {
833          // TODO: Implement applicability rules check          ← KURAL YOK
834          return m.isActive;
836      } catch {
837        return [];                                              ← SESSİZ YUTMA
```

- **Uç var:** `mechanicEndpoints.getApplicable` — `master-data.endpoints.ts:141`
- **Backend canlı:** `mechanic.controller.ts:196` `@Post('applicable')` → `getApplicableMechanics`
- **Çağıran:** `getApplicable` için **repo genelinde 0** (aşağıdaki tabloda doğrulandı)
- **Sonuç:** grid'in **hangi mekanik kolonlarının görüneceği** kararı, plan bağlamı
  (`channelId`/`categoryId`) **hiç kullanılmadan** veriliyor — `queryKey` o iki alanı
  taşıyor ama `queryFn` kullanmıyor. Hata hâlinde kullanıcı **kolonsuz** bir grid görür
  ve **hata görmez** → `EK_E`'nin *"sessiz kırıklık"* sınıfı.

## 1.3 DESENİN TARANMASI — *tanımlı ama çağrılmayan uç*

Yöntem: `src/api/endpoints/*.ts` içindeki her üst-düzey anahtar için, `src` genelinde
(`endpoints/` hariç) `.<anahtar>(` sayımı. **Poz. kontrol:** aynı tarama `validateFormula`
(bilinen `🔒`) ve `getApplicable` (TL vakası) için `0` döndü — yani tarama körlemesine
sıfır üretmiyor.

**ÜRETİMDE HİÇ ÇAĞRILMAYAN UÇLAR (20 adet, 8 dosya):**

| dosya | çağrılmayan anahtarlar |
|---|---|
| **`spend-calculation.endpoints.ts`** | `distributeMechanicSpend` · `recalculateOnVolumeChange` · `getDistributionBreakdown` · `validateDistribution` · `validateInputs` · `validateCombinations` · `validateBudget` · `validateBeforeSubmission` — **SEKİZİ DE**. Dosyanın kendisi hiçbir yerden import edilmiyor (`spendCalculationEndpoints` → **0 dosya**) |
| **`audit.endpoints.ts`** | `getAll` · `getByAdmin` · `getHighRisk` — **ÜÇÜ DE**; `auditEndpoints` → **0 dosya** |
| `kpi.endpoints.ts` | `validateFormula` |
| `master-data.endpoints.ts` | `getApplicable` |
| `off-invoice.endpoints.ts` | `getTransaction` · `getTransactionsByAgreement` · `getTransactionsByBatch` |
| `on-invoice.endpoints.ts` | `getBatch` · `validateBatch` |
| `plans.endpoints.ts` | `calculateKpis` |
| `customers.endpoints.ts` | `createBulk` · `getByCode` · `getByChannel` · `getByCity` · `getVip` |

> ⛔ **`spend-calculation.endpoints.ts` (149 satır) ÜRÜNÜN ÇEKİRDEĞİNDE.** `validateBudget`,
> `validateCombinations` (`max_combined_discount` ailesi), `validateBeforeSubmission`,
> `getDistributionBreakdown` (`EK_E E.1` *"Dağıtım görünürlüğü ❌ **MVP şartı** `K-2.1.8i`"*)
> — **hepsi FE'de yazılmış ve hiç çağrılmamış.** Bu, `EK_E`'nin bilmediği **dördüncü `🔒`
> kümesidir** ve tek kalemli değil, **sekiz kalemli**.

## 1.4 `🔒`'in ROTA TARAFI — *rota var, MENÜ yok*

`routes/index.tsx` 44 rota tanımlıyor; `Sidebar.tsx` 25 tekil `href` üretiyor. Fark:

**Menüden ULAŞILAMAYAN, ama rotası + RBAC'ı olan ekranlar:**

| rota | rol kapısı | `src` içinde bağlantı |
|---|---|---|
| **`/finance`** (`FinanceDashboard`, 8 widget) | `{ADMIN,FINANCE,CATEGORY_MANAGER,READONLY}` | **0** *(tek eşleşme `FinanceDashboard.tsx:44`'te bir **yorum**)* |
| `/admin/brand-management` | `{ADMIN}` | **0** |
| `/admin/category-management` | `{ADMIN}` | **0** |
| `/admin/channel-management` | `{ADMIN}` | **0** |
| `/admin/generic-unit-management` | `{ADMIN}` | **0** |
| `/admin/region-management` | `{ADMIN}` | **0** |
| **`/customers/new`** | `{ADMIN,PLANNER}` | **0** *(müşteri YARATMA ekranı — `CustomerList` yalnız `/customers/:id`'ye gidiyor)* |

> `/finance`: `EK_E E.7` *"Finans gösterge paneli ⚠️ **hata ekranı gösteriyor**"* diyor.
> **Ölçüm daha kötüsünü söylüyor:** ekrana **hiçbir menüden ve hiçbir butondan
> gidilemiyor.** `T-287 K3` bu ekranın rol kapısını daralttı, `Z43` backend'ini açtı —
> **menü ayağı hiç kapanmadı.**

## 1.5 `🔒`'in ROL TARAFI — `READONLY` için *yol var, yüzey yok*

`Sidebar.tsx:580-590` persona seçimi: `ADMIN`/`PLANNER`/`CATEGORY_MANAGER`/`FINANCE` dışındaki
her rol → `defaultNavigation` (`Sidebar.tsx:487`). O menüde **Dashboard · Customers ·
Users(ADMIN) · Budget · Reports · Analytics · Calendar · Products** var.

**Yani `READONLY` kullanıcı bugün şu ekranların HİÇBİRİNİ menüden göremiyor** — oysa
`routes/index.tsx` ve (`Z43 §2/§4` ile) backend ona açık:

```
/plans · /plans/:id · /plan-approvals · /agreements · /agreements/:id
/agreement-approvals · /budget/ledger · /off-invoice · /off-invoice/transactions
/on-invoice · /finance
```

⛔ **`Z43`'ün *"İKİ-REPO-TEK-KAPANIŞ"* kuralının ÜÇÜNCÜ AYAĞI açık kaldı:** backend `+RO`
indi, rota kapısı `+READONLY` açıldı, **menü açılmadı.** `200` dönen bir API ve giriş izni
veren bir rota, **linki olmayan** bir ekrana çıkıyor.

---

# `§2` · SESSİZ SIFIR / SESSİZ BOŞ ENVANTERİ (`§2.5`)

## 2.1 Ham sayımlar

| desen | eşleşme | dosya | not |
|---|---|---|---|
| `toNumberOrZero` (ham) | **64** | **19** | TL'nin sayısı **doğrulandı** |
| ↳ `import` satırı | 16 | | |
| ↳ yorum/dokümantasyon | 10 | | *(bir kısmı `§2.5`'i **anlatan** yorumlar — kusur değil)* |
| ↳ **gerçek çağrı** | **35** | 16 | sınıflandırma aşağıda |
| `?? 0` | **269** | **10** | **197'si tek dosyada:** `PlanningGridEnhanced.tsx` |
| `\|\| 0` | **78** | **24** | 14'ü ölü `PlanningGrid.tsx`'te |
| `catch { return [] }` | **2** | 2 | `PlanningGridEnhanced:836` · `PlanningGrid:243` (**ölü dosya**) |
| `catch { return null }` | **0** | — | *(ilk gevşek desen 12 saydı; `--multiline` daraltmasıyla **sıfır** çıktı — sayı LİSTESİYLE verilmezse yanıltır)* |
| toplam `catch` bloğu | **68** | — | gövdesi tamamen boş olan: **0** |

> ✅ **`ledger.service.ts`'in 6 `catch`'i temiz** — hepsi `toast.error(...)` + `throw error`
> (satır 39/61/84/108/131/155). Finansal okuma yolunda sessiz yutma yok.

## 2.2 SINIFLANDIRMA

### `A` — EŞİK/KARAR veren ⇒ **KUSUR** (7 üye, adıyla)

| # | yer | ne yapıyor |
|---|---|---|
| **A1** | `BudgetEnvelopeList.tsx:136-141` | `safeNumber`(=`toNumberOrZero`) → `allocated/consumed/reserved` → `utilization` → **`getRAGStatus()`** → **RAG filtresi**. Ayrıca `allocated > 0 ? … : 0` ⇒ **tahsis okunamayınca zarf `%0` = `good` (YEŞİL)** |
| **A2** | `BudgetEnvelopeList.tsx:374-380` | aynı hesabın **ikinci kopyası**, bu kez satır rozetini ve progress bar'ı boyuyor |
| **A3** | `AgreementApprovalsPage.tsx:157` | `toNumberOrZero(a.capTotalAmount) > 100000` → **`highSpendCount` KPI'ı**. Tavan okunamayan anlaşma **"yüksek harcama değil"** sayılıyor |
| **A4** | `AgreementApprovalsPage.tsx:386-388` | `totalSpend = toNumberOrZero(cap)` → `isHighSpend = totalSpend > 100000` → **onay kartındaki risk rozeti** |
| **A5** | `BudgetEnvelopeCard.tsx:40-44` | `allocatedAmount > 0 ? … : 0` → `consumptionPercent` → `isNearLimit(≥80)` / `isOverLimit(≥100)`. *(bileşenin **üretim tüketicisi yok** — bkz. `§3`; yine de A sınıfı, çünkü kablolandığı an karar verir)* |
| **A6** | `PlanningGridEnhanced.tsx:836-838` | `catch { return [] }` → **mekanik kolonlarının varlığı** kararı. Hata = "hiç mekanik yok", kullanıcıya bildirim **yok** |
| **A7** | `AgreementApprovalsPage.tsx:140` · `PlanApprovalsPage.tsx:141` | `const approvedTodayCount = 0; // TODO` — **sabit sıfır bir KPI olarak ekrana basılıyor.** Kullanıcı "bugün 0 onay" diye okur; ölçüm hiç yapılmıyor |

### `B` — TOPLAMA / ORTALAMA / TÜRETME ⇒ **ürün sorusu** (~24 üye)

Emsal: `avgRoi` (`PlanApprovalsPage.tsx:150`) — `§2.4` gereği dokunulmadı.

- Toplamlar (`!= null` ön-kapısıyla korunmuş): `PlansPage:95,104` · `AgreementsPage:97` ·
  `AgreementApprovalsPage:148` · `BudgetEnvelopeList:82-92` · `BudgetDashboard:30-46`
- Plan/FU türetmeleri: `GrandTotals:110,118` · `PlanApprovalsPage:422` ·
  `PlanApprovalDetailModal:102,276,317,391` · `PlanningGridEnhanced:416,422,555`
- Tavan bakiyesi: `OffInvoiceManualEntryModal:148,150,217,756` (`cap − total`)
- Bütçe payı: `BudgetDashboard:51,53` (`onInv`/`offInv` yüzdesi)

> ⛔ **VE `B`'nin İÇİNDE BİR KÜTLE VAR:** `PlanningGridEnhanced.tsx`'in **197 adet `?? 0`**'ı
> `BASE_TO` · `PLAN_TO` · `BASE_NIV` · `PLAN_NIV` · `BASE_GP` · `INCR_GM_PCT` … formüllerini
> **frontend'de yeniden hesaplıyor**. Dosyanın **kendi başlık yorumu** bunu kabul ediyor
> (`PlanningGridEnhanced.tsx:23-26`): *"Bu dosya bugün **üçüncü bir formül kopyası** taşıyor
> (ve `?? 0` ile eksik girdiyi sıfıra çeviriyor — `§2.5` sınıfı). İkisi de **temizlik
> listesindedir**; `T-334` kapsamında çözülmedi."*
>
> Yani `CLAUDE.md §2.3`'ün *"hesaplamalar asla frontend'de yapılmaz"* kuralının **en büyük
> tek ihlali** burada, ve **kayıtlı**.

### `C` — BİÇİMLENDİRME ⇒ **meşru** (11 üye)

`formatCurrency(toNumberOrZero(...))` kalıbı: `AgreementForm:616` · `AgreementDetail:233` ·
`AgreementList:384` · `LTAAgreementForm:1092` · `STAAgreementForm:1066` ·
`PlanApprovalDetailModal:227,491` · `PlanApprovalsPage:480` · `PlanList:220` ·
`OffInvoiceManualEntryModal:803` · `STAAgreementForm:789`

Görünürlük kapıları (`> 0 &&` ile bir bloğu gizlemek): `AgreementForm:614` ·
`AgreementList:388` — **C**, çünkü bir iş yargısı üretmiyor, yalnız boş bir kutu gizliyor.

**Sınıf toplamı: `A` = 7 · `B` ≈ 24 · `C` = 11** *(35 çağrı + `catch`/`TODO` kaynaklı 3 ek
`A` üyesi; `A5` ölü bileşende)*

---

# `§3` · ÖLÜ / İKİZ BİLEŞENLER

**Yöntem:** her modül için `from '…/<ad>'` biçimli import araması, tüketici evreni **yalnız
`src`** (tests hariç — gerekçe aşağıda). Poz. kontrol: `DashboardPage` **alive** çıkıyor.

## 3.1 ÜRETİM TÜKETİCİSİ OLMAYAN MODÜLLER

| modül | satır | test referansı | not |
|---|---|---|---|
| **`components/features/plans/PlanningGrid.tsx`** | **854** | **7** | ✅ TL'nin bilgisi doğrulandı: `PlanDetailPage.tsx:32` → `import { PlanningGridEnhanced as PlanningGrid }`. **İKİZ:** `Enhanced` 1796 satır |
| **`api/endpoints/spend-calculation.endpoints.ts`** | 149 | **0** | `§1.3` — sekiz uç |
| **`api/endpoints/audit.endpoints.ts`** | 34 | **0** | `§1.3` — üç uç |
| **`components/agreements/CreateTacticModal.tsx`** | **238** | **0** | barrel'da bile yok |
| `components/common/RoleGuard.tsx` | 25 | 0 | RBAC yardımcısı; kullanılmıyor |
| **`components/features/dashboard/ProfitabilityChart.tsx`** | 149 | **3** | **`dummyData` (Migros/Yerel/Gratis/Mopaş, `₺1.0M`…) render ediyor** |
| **`components/features/dashboard/RecentTransactions.tsx`** | — | **3** | **`dummyTransactions`** |
| `utils/export.ts` | 334 | 10 | dışa aktarma yeteneği (`EK_E E.7` *"Dışa aktarma ❌"*) — **kod var, çağıran yok** |
| **`utils/tokenStorage.ts`** | — | 1 | **İKİZ:** token saklama `auth.slice.ts:28-64` + `auth.service.ts:95`'te **ham `localStorage`** ile ikinci kez yazılmış (`§7`) |
| `utils/retry.ts` | — | **29** | 29 test referansı, **sıfır üretim çağrısı** |
| `hooks/useAuth.ts` | — | 2 | `services/auth.service.ts` ile örtüşüyor |
| `components/budget/BudgetEnvelopeCard.tsx` | — | 0 | yalnız barrel'dan export ediliyor (`A5`'in evi) |

## 3.2 ⛔ SINIFIN YENİ YÜZÜ — **TEST, ÖLÜ KODU CANLI GÖSTERİYOR**

TL'nin uyarısı *"dosya adına bakarak sayılan bir tüketici hiç koşmuyor olabilir"* idi.
Ölçüm **simetriğini** buldu:

```
ProfitabilityChart.tsx     üretim tüketicisi 0
                           tests/components/features/dashboard/ProfitabilityChart.test.tsx
                           → render ediyor, "başlık/legend/kategoriler" assert ediyor  ✅ YEŞİL
                           → ASSERT ETTİĞİ VERİ `dummyData`
```

**Bir test, ölü kodu hem "canlı" gösteriyor hem de uydurma veriyi ŞARTNAME hâline getiriyor.**
Aynı şey `RecentTransactions` ve `retry.ts` (29 referans!) için de geçerli. Tüketici evreni
`tests`'i içerdiğinde bu üç modül **ölü görünmez** — ilk taramamda görünmediler.

## 3.3 İKİZLER (`§7`: "aynı yetenek birden çok kez yazıldı")

| yetenek | kopya 1 | kopya 2 | kopya 3 |
|---|---|---|---|
| plan gridi | `PlanningGrid.tsx` (**ölü**, 854) | `PlanningGridEnhanced.tsx` (1796) | — |
| KPI formülleri | backend KPI motoru (**kanonik**) | `PlanningGridEnhanced` `getSkuCellValue` | `PlanningGridEnhanced` `getFuCellValue` |
| token saklama | `utils/tokenStorage.ts` (**ölü**) | `store/slices/auth.slice.ts` | `services/auth.service.ts:95` |
| bütçe RAG merdiveni | `BudgetEnvelopeList:27-30` (`<80/<95`) | `BudgetEnvelopeCard:43-44` (`≥80/≥100`) | `AgreementList:162-164` (`≥95/≥80`) |
| bütçe durumu | **backend `GET /budget/status` → `status:'GREEN'\|'AMBER'\|'RED'`** *(tek çağıran: `STAAgreementForm.tsx:197`)* | yukarıdaki üç yerel merdiven | — |

---

# `§4` · TEST KAPSAMI — yüzey yüzey

## 4.1 Sayım ve bir SAYIM FARKI

```
test dosyası           68        ✅ brief ile aynı
statik `it(`/`test(`  538
`.each` bildirimi      15        ← runtime'da genişler
`.skip`                 0
e2e spec (Playwright)   5        (01-login-rbac · 02-version-conflict · 03-file-upload
                                  · 04-grid-cell-kpi · 05-grid-column-alignment)
```

⚠️ **Brief `589` diyor, statik sayım `538`.** Fark **açıklanmadı, ölçülmedi** — en olası
kaynak `it.each` genişlemesi (15 bildirim), ama bunu doğrulamak **suite'i koşturmayı**
gerektirir ve bu turda yasaktı. `§7`'ye yazıldı.

## 4.2 PİNLİ (doğrulandı)

| yüzey | pin |
|---|---|
| **submit akışı** ✅ *(TL'nin doğrulama isteği)* | `tests/api/plans.submit.test.tsx` (2 `describe`, 3 `it`) · `tests/components/features/plans/PlanDetailPage.submit-wiring.test.tsx` (4 `it`) · `tests/components/features/plans/SubmissionFeedback.test.tsx` (5 `it`) — **`T-344` pini yerinde** |
| grid hücre commit / editör | `grid-cell-commit.test.tsx` (`PlanningGridEnhanced`'i **gerçekten import ediyor**) · `editable-cell-coordinator.test.tsx` |
| RAG kapsama | `tests/utils/ragCoverage.test.ts` |
| Target-ROI kararı | `tests/utils/targetRoi.test.ts` |
| rota/RBAC kapısı | `routeGuards.test.tsx` · `route-gate-matches-route-roles.test.tsx` · `roleEnumContract.test.ts` |
| defter (ledger) | `BudgetLedgerPage.test.tsx` · `ledger.service.test.tsx` |
| off-invoice dayanıklılık | `OffInvoiceTransactionsPage.resilience.test.tsx` |
| onay kartları | `PlanApprovalCard.test.tsx` · `AgreementApprovalCard.test.tsx` |
| kullanıcı/kapsam formu | `UserForm.test.tsx` (`UserScopeFields` render sırasını pinliyor) |

## 4.3 PİNSİZ KRİTİK YÜZEYLER

**Poz. kontrol:** aynı arama `PlanningGridEnhanced` için **7**, `Sidebar` için **4**,
`GrandTotals` için **3** dosya buluyor — yani `0` sonuçları aramanın körlüğünden değil.

| yüzey | `tests` içinde |
|---|---|
| **`useTargetRoiThreshold.ts`** (eşiğin **tek okuma noktası**) | **0** |
| **`PlansPage.tsx`** · **`AgreementsPage.tsx`** (iki ana liste) | **0** / **0** |
| **`AgreementForm` · `LTAAgreementForm` · `STAAgreementForm`** (anlaşma yaratma/düzenleme) | **0** / **0** / **0** |
| **`AgreementDetail.tsx`** | **0** |
| **`BudgetEnvelopeList` · `BudgetEnvelopeForm` · `BudgetDashboard` · `BudgetSummaryCard`** | **0** (dördü de) — **`A1`/`A2`/`A5` tam burada** |
| **`KpiManagementPage`** (formül düzenleme ekranı) | **0** |
| `AdminOverviewPage` · `ragColorUtils.ts` · `OnInvoiceUploadPage` | **0** |
| `PlanningGridEnhanced` **formül gövdesi** | *anılıyor* (7 dosya) ama **yalnız 1'i import ediyor**; `getSkuCellValue`/`getFuCellValue`'nun **hiçbir formülü** birim testte pinli değil |

> ⛔ **En keskin boşluk:** `§2`'nin `A` sınıfının **yedi üyesinden altısı** (A1, A2, A3, A4,
> A5, A7) **pinsiz dosyalarda.** Yani düzeltilseler bile **regresyon kapısı yok**.

---

# `§5` · `§2.3` HARDCODE ENVANTERİ

**Yöntem — `T-344`'ün dersi uygulandı:** *değişken adı değil KARAR arandı*
(`if (… <|> sayı)`, `>= 80|95|100`, `100000`, `targetRoi`, `const … = <sayı>; // TODO`).

## 5.1 EŞİK KARARLARI

| yer | sabit | kararı |
|---|---|---|
| `BudgetEnvelopeList.tsx:28-29` | `< 80` → `good`, `< 95` → `warning`, aksi `critical` | RAG rozeti **+ RAG filtresi** |
| `BudgetEnvelopeCard.tsx:43-44` | `>= 80` , `>= 100` | `isNearLimit` / `isOverLimit` |
| `BudgetSummaryCard.tsx:31-32` | `>= 80` , `>= 100` | aynı ikili *(ama `undefined`'a **dürüst** — `usagePercent !== undefined` kapısı var)* |
| **`AgreementList.tsx:162-164`** | `>= 95` **KIRMIZI**, `>= 80` **SARI**, `> 0` sarı-açık | anlaşma **tavan kullanım çubuğu** |
| `AgreementApprovalsPage.tsx:157` | `> 100000` | `highSpendCount` KPI |
| `AgreementApprovalsPage.tsx:388` | `> 100000` | onay kartı **risk rozeti** |
| `STAAgreementForm.tsx:252` | `days > 90` | STA süre uyarısı |
| `BudgetApprovalModal.tsx:90` | `Math.max(planTotalSpend * 2, 100000)` | **varsayılan bütçe tutarı** — `100.000` bir **taban** olarak koda gömülü |
| `PlanPerformanceWidget.tsx:128` | `rows.length > 100` | lazy-loading (teknik — **meşru**) |

⛔ **ÜÇ FARKLI MERDİVEN:** `<80/<95` · `≥80/≥100` · `≥95/≥80`. `CLAUDE.md §2.3`'ün *"sınır
semantiği (`>95` mi `>=95` mi) çözülmemiştir"* uyarısı burada **üç ayrı cevaba** dönüşmüş.

## 5.2 ⛔ VE BU BORÇ **KAPATILAMAZ DURUMDA** — bir KİLİT

```
backend  BudgetAlertConfiguration  → 8 dosyada geçiyor (entity · seed · service · module)
         CONTROLLER'da             → SIFIR   (rg --color never -l "BudgetAlertConfiguration" src --glob '*.controller.ts' → boş)
```

**Eşik konfigürasyonu HTTP'den okunamıyor.** Frontend hardcode'u kaldırmak istese
**okuyacak bir uç yok** — `T-101`/`T-108`'in *"konfigürasyon üretimde ulaşılamaz"* bulgusu
**bugün de geçerli**. Bu bir FE task'ı değil, **iki-repo task'ı**.

📌 **AMA BİR YOL VAR ve kullanılmıyor:** backend `GET /budget/status`
**sunucu tarafından hesaplanmış `status: 'GREEN'|'AMBER'|'RED'`** döndürüyor
(`budget.endpoints.ts:33-45`) — ve tek çağıranı `STAAgreementForm.tsx:197`.
`ragColorUtils.ts` de zaten *"backend'den gelen status string'ini render eder, hesap
yapılmaz"* diyor. **Doğru kalıp kod tabanında MEVCUT; üç bütçe bileşeni onu kullanmıyor.**

## 5.3 ADI ARKASINA SAKLANMIŞ EŞİKLER — **BUGÜN TEMİZ**

`T-344`'ün beşinci kopyası (`GrandTotals.tsx`'teki `const targetRoi = 20.0 // TODO`)
**kapatılmış**: `GrandTotals.tsx:143` artık `useTargetRoiThreshold()` + `resolveBelowTarget()`
çağırıyor. Aynı desen için tarama (`targetRoi`, `const … = 20`, `roi < `) **başka kopya
bulmadı**. `useTargetRoiThreshold.ts:34` eşiği `kpi.targetRoiThreshold`'dan okuyor. ✅

⚠️ **Ama:** `useTargetRoiThreshold.ts`'in **hiç testi yok** (`§4.3`) — yani `T-344`'ün
düzeltmesi **pinsiz**.

## 5.4 UYDURMA VERİ ve SABİT SIFIRLAR (hardcode'un en yanıltıcı türü)

| yer | ne |
|---|---|
| `ProfitabilityChart.tsx:10-35` | **`dummyData`** — `Migros ₺1.0M`, `Gratis %30` … *(bileşen ölü, testi canlı)* |
| `RecentTransactions.tsx:12` | **`dummyTransactions`** *(aynı durum)* |
| **`Sidebar.tsx:75, 156, 320, 413`** | **`badge: 1, // TODO: Get from API`** — **dört persona menüsünde de** "Plan Onayları **1**" / "Anlaşma Onayları **1**" rozeti. Kuyruk boşken bile **1 bekleyen iş** gösteriyor |
| `AgreementApprovalsPage.tsx:140` · `PlanApprovalsPage.tsx:141` | `approvedTodayCount = 0; // TODO` |
| `ForecastingUnitManagementPage.tsx:132-133` | `const activePlans = 0; // Placeholder` |
| `AuditLogPage.tsx:11` | *"Bu sayfa yakında eklenecek."* — 15 satırlık **stub**, `/admin/audit-log` rotasında ve **admin menüsünde** (`Sidebar.tsx:210`) |

> `EK_E E.8` *"Denetim kaydı görünümü 🔶 yalnız yönetici işlemleri"* diyor.
> **Ölçüm:** ekran bir placeholder, `audit.endpoints.ts`'in üç ucunun **hiçbiri** çağrılmıyor.
> Doğru işaret **`❌`** ve **menüde görünüyor** — `EK_E E.7`'nin *"beş rapor menüde,
> tıklanamıyor"* ailesinin yedinci üyesi.

## 5.5 ROTASI OLMAYAN MENÜ LİNKLERİ — **404'e giden 4 link**

`defaultNavigation` (`Sidebar.tsx:487-538`, yani **`READONLY` + eşleşmeyen her rol**):

```
/reports     /analytics     /calendar     /products
```

Dördünün de `routes/index.tsx`'te **karşılığı yok** → `path: '*'` → **404 sayfası**.

---

# `§6` · EKRAN → YETENEK HARİTASI (`EK_E` ile çakıştırma)

44 rota (35'i parametresiz/teknik-olmayan) · 25 tekil menü linki.

| ekran (rota) | rol kapısı | menü | `EK_E` karşılığı | ölçülen sapma |
|---|---|---|---|---|
| `/dashboard` | hepsi | ✅ | — *(`EK_E`'de **yok**)* | ⚠️ **`EK_E` bu ekranı hiç saymıyor** |
| `/plans`, `/plans/:id` | A,P,CM,F,RO | ✅ (RO hariç) | `E.1` Plan listesi ✅ / grid ✅ | RO menüsüz |
| `/plan-approvals` | A,CM,RO | ✅ (RO hariç) | `E.3` Bekleyen planlar ✅ | `approvedTodayCount=0` sabit |
| `/agreements`, `/:id`, `/:id/edit` | A,P,CM,F,RO | ✅ (RO hariç) | `E.4` liste ✅ / detay ⚠️ | detayda hâlâ `channelName \|\| channelId` (`AgreementDetail.tsx:144,158-160`) — **isim yoksa kimlik** |
| `/agreement-approvals` | A,CM,F,RO | ✅ (RO hariç) | `E.3` ✅ | `A3`/`A4` hardcode |
| `/budget`, `/budget/:id` | hepsi | ✅ | `E.2` zarf listesi ✅ / oranlar ✅ | `A1`/`A2` üç merdiven |
| `/budget/ledger` | A,F,P,RO | ✅ (RO hariç) | `E.2` hareket defteri ✅ | RO menüsüz *(`Z43` yarım kapandı)* |
| **`/finance`** | A,F,CM,RO | **❌ menüde YOK** | `E.7` Finans paneli ⚠️ | **ULAŞILAMAZ** — `EK_E` "hata ekranı" diyor, ölçüm "**ekran yok**" diyor |
| `/off-invoice`, `/off-invoice/transactions`, `/off-invoice/upload` | A,F,P,RO (+upload A,F) | ✅ / kısmen | `E.5` yükleme ✅ / elle giriş ✅ | `upload` yalnız sayfa-içi butondan |
| `/on-invoice`, `/on-invoice/upload` | A,F,P,RO | ✅ | `E.5` ✅ | `validateBatch`/`getBatch` **çağrılmıyor** |
| `/customers` ailesi (5 rota) | A,P | kısmen | `E.8` Müşteri yönetimi ✅ | **`/customers/new` ULAŞILAMAZ** |
| `/users`, `/users/:id`, `/admin/users` | A | ✅ | `E.8` Kullanıcı yönetimi ⚠️ *(`T-243`)* | **`EK_E` BAYAT** — `UserScopeFields` bağlandı, create yolu çalışıyor |
| `/admin/kpi-management` | A | ✅ | `E.6` gösterge + formül ✅ | **`validateFormula` çağrılmıyor** → `EK_E` `🔒` doğrulandı |
| `/admin/{sku,cpl,tactic,mechanic,forecasting-unit}-management` | A | ✅ | `E.8` ✅ | — |
| **`/admin/{brand,category,channel,generic-unit,region}-management`** | A | **❌ menüde YOK** | `E.8` Ürün ağacı ✅ / Bölge ✅ | **BEŞ ADMİN EKRANI ULAŞILAMAZ** — `EK_E` bunları `✅` sayıyor |
| `/admin/audit-log` | A | ✅ | `E.8` Denetim kaydı 🔶 | **stub** — doğru işaret `❌` |
| `/admin/overview` | A | ✅ | `EK_E`'de **yok** | — |
| `/settings` | hepsi | Header'dan (4 iz) | `EK_E`'de **yok** | **iskelet** (`routes/index.tsx:57-92`: tema/dil `select`'leri, hiçbir yere yazmıyor) |
| `/profile` | hepsi | Header'dan | `EK_E`'de **yok** | — |
| `/login` | — | — | — | — |

## 6.1 `EK_E`'nin BİLMEDİĞİ EKRANLAR
`/dashboard` · `/admin/overview` · `/settings` · `/profile` · `/customers/import` ·
`/customers/new` · `/customers/:id/edit`

## 6.2 `EK_E`'DE VAR, FRONTEND'DE HİÇBİR EKRAN YOK
`E.5` hakkediş zincirinin **tamamı** (dış talep alımı · eşleştirme · eşleşmeyen kuyruğu ·
mutabakat · fark çözümleme · tahakkuk · toplu onay) · `E.2` transfer · politika tablosu ·
`E.4` anlaşma kapanışı + dönem kapanışı · `E.7` **on rapor** · `E.9` üç YZ kenarı.

**Poz. kontrol:** `rg -i "settlement|actuals-first|claim|recognition|accrual"` →
frontend `src`'te **10 dosya** (hepsi tip/etiket düzeyinde, hiçbiri uç çağırmıyor),
aynı grep backend `src`'te **41 dosya**. Yani asimetri gerçek, aramanın körlüğü değil.

---

# `§7` · ÖLÇEMEDİM

1. **Hiçbir şey KOŞTURULMADI** (brief yasağı): `npm test` · `npm run type-check` ·
   `npm run lint` · `npx playwright` · `npm run dev`. Bu raporun **tamamı statiktir**.
   ⇒ *"pinli"* dediğim testlerin **geçtiğini** ölçmedim; yalnız **var olduklarını** ölçtüm.
2. **`538` ↔ `589` test sayısı farkı.** Kaynağı gösterilmeden yorumlanamaz
   (`DISIPLIN`: *"bir SAYIM FARKI, farkın KAYNAĞI gösterilmeden yorumlanamaz"*).
   En olası açıklama `it.each` (15 bildirim) ama **doğrulanmadı**.
3. **`EK_E` `⚠️` kalemlerinin bugünkü davranışı.** *"Taktik değeri hücreye dönmüyor"*,
   *"Finans paneli hata ekranı"*, *"kapsama oranı istemciye ulaşmıyor"* — üçü de
   **çalışan bir uygulama** ister. `/finance` için yalnız **ulaşılabilirliği** ölçtüm.
4. **`T-293` (LTA kopukluğu) bugünkü hâli.** Ölçtüğüm: FE'de `lta-agreements` yoluna
   **sıfır** referans var (`rg` boş; poz. kontrol: `lta` 19 FE dosyasında geçiyor).
   Ölçmediğim: `POST /agreements` üzerinden yazılanın motora **ulaşıp ulaşmadığı** —
   bu bir DB + çalışan backend ölçümü.
5. **Ulaşılamazlık iddialarının tamamı dizge-tabanlı.** `/customers/new`, `/finance` ve beş
   admin ekranı için `'yol'` / `"yol"` / `` `yol` `` aradım. **Şablon ile kurulan bir yol**
   (`navigate(\`/admin/${slug}\`)`) bu taramadan **kaçar**. Ölçüm bu sınırla okunmalı.
6. **Backend rota evreninin TAMAMI × FE tüketicisi** çapraz farkını almadım — yalnız
   `EK_E`'nin adlandırdığı kalemler + FE endpoint dosyalarından türeyen 20 çağrılmayan uç.
   ⇒ *"FE'de karşılığı olmayan backend ucu"* için **tam sayı veremem**.
7. **`?? 0`'ın 269 eşleşmesinin canlı veride hangi sayıyı bozduğu.** Sınıflandırma
   **statik**tir; hangi alanın üretimde `null` geldiği bir **DB ölçümü** ister
   (`DISIPLIN`: *"verinin yokluğu örter"* — fixture olmadan bu yol koşmuyor olabilir).
8. **`git blame` / tarihsel eksen yok:** hangi bulgunun `T-344` öncesinden kaldığını,
   hangisinin yeni doğduğunu ölçmedim.

**ÖLÇEMEDİM sayısı: 8**

---

# `§8` · EN ACİL BEŞ KALEM (gerekçeli sıralama)

## `1` · `spend-calculation.endpoints.ts` — SEKİZ UÇ, SIFIR ÇAĞRI
`src/api/endpoints/spend-calculation.endpoints.ts` (149 satır, **hiçbir yerden import
edilmiyor**)

**Neden birinci:** `EK_E`'nin *"`🔒` israftır"* tanımının **en büyük tek örneği** ve içinde
bir **MVP şartı** var — `getDistributionBreakdown` = `E.1` *"Dağıtım görünürlüğü ❌ **MVP
şartı** (`K-2.1.8i`)"*. Ayrıca `validateBudget` · `validateCombinations` ·
`validateBeforeSubmission`: bugün plan **hiçbir istemci-tarafı doğrulamadan** submit
ediliyor. **Yeni kod değil, kablolama** — ve `EK_E` bu kümeyi **hiç bilmiyor**
(dördüncü `🔒`, tek kalemli değil sekiz kalemli).

## `2` · `A1`/`A2` — BÜTÇE RAG'İ: sessiz sıfır + üç merdiven, hepsi PİNSİZ
`BudgetEnvelopeList.tsx:27-30, 136-141, 374-380` · `BudgetEnvelopeCard.tsx:40-44` ·
`AgreementList.tsx:162-164`

**Neden ikinci:** `§2.5` (`allocated>0?…:0` ⇒ **okunamayan tahsis = YEŞİL zarf**) ve `§2.3`
(hardcode eşik) **aynı satırda** ihlal ediliyor, karar **kullanıcıya renk olarak** çıkıyor,
ve **hiçbir bütçe bileşeninin testi yok**. ⚠️ **Kısmen kilitli:** `BudgetAlertConfiguration`
controller'ı yok. **Ama tam kilitli değil** — `GET /budget/status` sunucu-tarafı
`GREEN/AMBER/RED` döndürüyor ve `ragColorUtils.ts` kalıbı zaten doğru. **Doğru çözüm kod
tabanında mevcut, üç bileşen onu kullanmıyor.**

## `3` · `READONLY` + `/finance` + 5 admin ekranı — *rota var, MENÜ yok*
`Sidebar.tsx:487-538` (`defaultNavigation`) · `routes/index.tsx` (`/finance` +
`/admin/{brand,category,channel,generic-unit,region}-management` + `/customers/new`)

**Neden üçüncü:** `Z43`'ün **"İKİ-REPO-TEK-KAPANIŞ"** kuralı **üçüncü ayakta kırıldı** —
backend `+READONLY` indi, rota kapısı açıldı, **menü hiç açılmadı**. Yedi ekran (biri
**tüm finans paneli**, biri **müşteri yaratma**) hiçbir yerden tıklanamıyor. Aynı dosyada
`defaultNavigation` **4 adet 404 linki** sunuyor. **Maliyeti en düşük, görünürlüğü en
yüksek kalem** — `Sidebar.tsx` tek dosya.

## `4` · `PlanningGridEnhanced` — 197 `?? 0` + üçüncü formül kopyası + `catch{return []}`
`PlanningGridEnhanced.tsx:23-26` (kendi itirafı) · `:113-260` (formüller) · `:825-841`

**Neden dördüncü:** `CLAUDE.md §2.3`'ün *"hesaplama frontend'de YAPILMAZ"* kuralının **en
büyük ihlali**, `§2.5`'in en yoğun bölgesi, ve `§1.2`'nin sessiz-yutma vakası burada.
**Birinciden aşağıda, çünkü:** `T-334` bu formüllerin **bugün motorla aynı sonucu ürettiğini
ölçtü** — yani şu an **yanlış sayı üretmiyor**, ama **her motor değişikliğinde sessizce
sapabilir** ve hiçbir formülü birim testte pinli değil. Bu bir **acil hata değil, acil
kırılganlık**.

## `5` · UYDURMA VERİ ve SABİT SIFIRLAR — kullanıcı ÇALIŞTIĞINI SANIYOR
`Sidebar.tsx:75,156,320,413` (`badge: 1`) · `AgreementApprovalsPage.tsx:140` ·
`PlanApprovalsPage.tsx:141` · `ForecastingUnitManagementPage.tsx:132` ·
`AuditLogPage.tsx:11` · `ProfitabilityChart.tsx:10` · `RecentTransactions.tsx:12`

**Neden beşinci ve neden LİSTEDE:** `EK_E`'nin **sessiz kırıklık** sınıfı — *"kullanıcı
çalıştığını sanır"*, ve `EK_E`'nin kendi hükmüne göre **üçünün en pahalısı**. Dört persona
menüsünde de "**1** bekleyen onay" yazıyor, iki onay ekranı "bugün **0** onay" diyor, bir
admin ekranı "yakında" diyor **ama menüde**. ⚠️ Ve `ProfitabilityChart`/`RecentTransactions`
için **bir test uydurma veriyi ŞARTNAME olarak pinliyor** (`§3.2`) — silinmeleri o testlerin
de kaldırılmasını gerektirir, yani **temizlik bir karar ister**, bir refactor değil.

---

## Bu envanterin bakımı

Bu belge **bir ölçüm kaydıdır**, bir şartname değil. Her sayı yukarıda **komutuyla ve
poz. kontrolüyle** üretildi; bir sonraki tur aynı komutları koşturup **farkı** ölçmelidir.
`EK_E` ile çakışmayan her satır (`§1.1`, `§6`) `EK_E`'nin **donmuş** olduğu için burada
raporlanır — düzeltme kararı ürün sahibinindir.
