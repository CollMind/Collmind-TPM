# 0058 — Ekran Envanteri + BRD Taslak Karşılaştırması

- **Tarih:** 2026-08-11
- **Rol:** QA Engineer (ölçüm turu — ürün kodu değiştirilmedi)
- **Kapsam:** `collmind.frontend/src/routes/index.tsx`'teki tüm rotalar, `docs/brd/01_Main_BRD/Section_04` ve `Section_05`'teki ASCII ekran taslakları

---

## 0. Ölçüm ortamı (ZORUNLU — koşulu ölçümle birlikte yaz)

| | değer |
|---|---|
| backend commit | `5bc2787` (fix(kpi-engine): oran KPI'ları Σnum/Σden — T-177 adım 2) |
| backend süreci | **yeniden başlatıldı** 2026-08-11 01:46:50 — önceki süreç `dist/main` (start:prod derlemesi) 01:33:30'da başlamıştı, yani kaynak commit'inden (01:37:07) **eski**; `npm run start:dev` ile taze başlatıldı, `nest start --watch` |
| frontend commit | `git -C collmind.frontend log -1` çalıştırılmadı ayrıca ama `npm run dev` bu oturumda taze başlatıldı (Vite 5.4.21, port 5173) |
| DB | Docker `collmind-tpm-postgres`, port 5434, şema `main`, **tek tenant**: `Wella Turkey` (`598a895e-…`) |
| DB seed anlık görüntüsü | `plans=0` · `agreements=3` · `agreement_transactions=0` · `customers=29` · `budget_envelopes=4` · `users=9` · `ledger_entries=1231` (ölçüldü, §5) |
| Rol | ADMIN (`admin@wella.com`) — T-179 sonrası en geniş erişim, talimat gereği |
| Araç | Playwright 1.62.1, mevcut altyapı (`collmind.frontend/playwright.config.ts`, `tests/e2e/support/{api,ui-auth}.ts`) — **önce arandı**, sıfırdan kurulmadı |
| Script konumu | Geçici spec dosyaları `tests/e2e/` altına **geçici** kondu (module resolution `@playwright/test`'i yalnız proje `node_modules`'ünden çözebiliyor — saf scratchpad'ten `playwright test` çalıştırılamadı, ölçüldü), koşturuldu, **silindi** — `git status --short tests/e2e/` her ikisinden sonra da temiz. Repoya commit edilmedi. |

⚠️ **Bir ölçüm hatası kendi içinde bulundu ve düzeltildi (kayıt altında, §7.1 disiplini gereği):** ilk konsol-hatası yakalama kodu `results[page.url()]` (tam URL) ile `results[route.path]` (yalnız path) anahtarlarını karıştırıyordu — hiçbir zaman eşleşmedi, yani **ilk koşuda `consoleErrors: []` her rota için yanlış negatifti**, "hata yok" değil "ölçülmedi" demekti. Anahtarlama düzeltilip ikinci kez koşuldu; gerçek sonuçlar §5'te.

---

## 1. Route tablosu

`routeConfig` (`collmind.frontend/src/routes/index.tsx`) — 39 tekil rota + `/login` + `*` (404). ADMIN ile gezildi, `waitUntil: networkidle` + 600ms ek bekleme, konsol/`pageerror` dinleyicisi ile.

| Yol | Durum | BRD bölümü | Görüntü |
|---|---|---|---|
| `/dashboard` | açılıyor | `Section_04` KPI Dashboard (yakın) | `01-dashboard.png` |
| `/customers` | açılıyor | — (master data, BRD'de ayrı ekran taslağı yok) | `02-customers.png` |
| `/customers/new` | açılıyor | — | `03-customers-new.png` |
| `/customers/import` | açılıyor | `Section_04` Batch Import (yakın — CSV/Excel) | `04-customers-import.png` |
| `/users` | açılıyor | `Section_07` (rol tanımları — ekran taslağı yok) | `05-users.png` |
| `/tenants` | açılıyor | — | `06-tenants.png` |
| `/tenants/new` | açılıyor | — | `07-tenants-new.png` |
| `/settings` | açılıyor (statik yer tutucu — Theme/Language, backend'e bağlı değil) | — | `08-settings.png` |
| `/profile` | açılıyor | — | `09-profile.png` |
| `/budget` | açılıyor | `Section_04` Alert/Envelope örnekleri | `10-budget.png` |
| `/budget/ledger` | açılıyor (**ilk ölçüm `404` yanlış pozitifti** — büyük body'de rastgele "404" alt-dizisi eşleşti; `has404` kuralı `Page not found` **VE** ayrı sözcük `404` ikisini birden arayacak şekilde düzeltildi, düzeltmeden sonra `rendered`) | `Section_04` §4.9 Ledger Posting | `11-budget-ledger.png` (⚠️ **1280×80385px**, 1231 satır **paginasyon/virtualizasyon olmadan tek sayfada** render ediliyor — bkz. §6 D3) |
| `/agreements` | açılıyor | `Section_04` Agreement Lifecycle | `12-agreements.png` |
| `/agreement-approvals` | açılıyor | `Section_04` "Approval UI" (Batch Approval Request) | `13-agreement-approvals.png` |
| `/plans` | açılıyor (boş — `plans=0`) | `Section_05` §5.1 | `14-plans.png` |
| `/plan-approvals` | açılıyor (boş) | `Section_05` "Approval UI (Approver View)" | `15-plan-approvals.png` |
| `/finance` | **açılıyor ama React ile çöküyor** — bkz. §6 D1 | `Section_04` KPI Dashboard | `16-finance.png` (ErrorBoundary ekranı) |
| `/off-invoice/upload` | açılıyor | `Section_04` Batch Import Workflow + Validation Results UI (adım 1/3) | `17-off-invoice-upload.png` |
| `/off-invoice/transactions` | açılıyor (boş — `agreement_transactions=0`) | — | `18-off-invoice-transactions.png` |
| `/off-invoice` (alias) | açılıyor, aynı bileşen | — | `19-off-invoice-alias.png` |
| `/on-invoice/upload` | açılıyor | `Section_04` Batch Import (yakın) | `20-on-invoice-upload.png` |
| `/on-invoice` (alias) | açılıyor, aynı bileşen | — | `21-on-invoice-alias.png` |
| `/admin/channel-management` | açılıyor | — | `22-admin-channel-mgmt.png` |
| `/admin/category-management` | açılıyor | — | `23-admin-category-mgmt.png` |
| `/admin/cpl-management` | açılıyor | — | `24-admin-cpl-mgmt.png` |
| `/admin/brand-management` | açılıyor | — | `25-admin-brand-mgmt.png` |
| `/admin/region-management` | açılıyor | — | `26-admin-region-mgmt.png` |
| `/admin/tactic-management` | açılıyor | — | `27-admin-tactic-mgmt.png` |
| `/admin/mechanic-management` | açılıyor | — | `28-admin-mechanic-mgmt.png` |
| `/admin/generic-unit-management` | açılıyor | — | `29-admin-generic-unit-mgmt.png` |
| `/admin/forecasting-unit-management` | açılıyor | — | `30-admin-fu-mgmt.png` |
| `/admin/sku-management` | açılıyor (170 satır, paginasyon yok — bkz. §6 D3) | — | `31-admin-sku-mgmt.png` |
| `/admin/overview` | açılıyor | — | `32-admin-overview.png` |
| `/admin/users` (alias) | açılıyor, `UsersPage` ile aynı | — | `33-admin-users-alias.png` |
| `/admin/baseline-import` | açılıyor | `Section_05` baseline yeterlilik akışı (yakın) | `34-admin-baseline-import.png` |
| `/admin/kpi-management` | açılıyor, **dolu ve çalışıyor** (27 KPI, dinamik formül editörü) | §2.3 "hesaplamalar hardcode edilmez" | `35-admin-kpi-mgmt.png` |
| `/admin/customers` (alias) | açılıyor, `CustomersPage` ile aynı | — | `36-admin-customers-alias.png` |
| `/admin/audit-log` | **açılıyor ama YER TUTUCU** — "Bu sayfa yakında eklenecek." | §2.3 "Audit: immutable, her işlem loglanır" | `37-admin-audit-log.png` |
| `/admin/configuration` | **açılıyor ama YER TUTUCU** — "Bu sayfa yakında eklenecek." | (BudgetAlertConfiguration, T-108) | `38-admin-configuration.png` |
| `/does-not-exist-xyz` | 404 sayfası doğru render ediliyor | — | `39-not-found.png` |
| `/plans/:id` | açılıyor (gerçek grid ile, fixture plan oluşturulup ölçüldü — bkz. §2) | `Section_05` §5.2 grid + §5.4 Grand Totals | `46-plan-detail-grid.png` |
| `/agreements/:id` | açılıyor — bkz. §6 D2 (çözülmemiş FK'ler ham UUID basıyor) | `Section_04` Agreement detay | `41-agreement-detail.png` |
| `/budget/:id` | açılıyor | `Section_04` Envelope detayı | `42-budget-envelope-detail.png` |
| `/customers/:id` | açılıyor | — | `43-customer-detail.png` |
| `/tenants/:id` | açılıyor | — | `44-tenant-detail.png` |
| `/users/:id` | açılıyor | — | `45-user-detail.png` |

**Konsol/`pageerror` taraması** (düzeltilmiş anahtarlamayla, tüm 39 rota): **yalnızca `/finance`'te hata var** (19 kayıt — 6× `400 Bad Request`, 6× `API Error`, React "Rendered more hooks" hatası ve ilişkili `pageerror`'lar). Diğer 38 rotanın hiçbirinde konsol hatası **ölçülmedi**.

---

## 2. BRD taslağı ↔ gerçek ekran — alan bazında

### 2.1 Sayım — bağımsız doğrulama (ZORUNLU)

Görev talimatı *"Section_04'te 7 ASCII taslak var"* diyordu. **Kendi ölçümüm 8 çıkardı** —
bulgu olarak kaydediyorum, sessizce kabul etmiyorum:

Box-drawing (`┌│└┐┘├┤┬┴`) içeren tüm kod bloklarını taradım (`Section_04`: 19 blok,
`Section_05`: 12 blok), her birinin başlığına baktım, **süreç/state diyagramlarını** (ör.
"Operational Workflow", "Agreement Lifecycle", "Budget Flow", "Budget & Ledger State
Transitions") ve **rapor çıktı örneklerini** (ör. "SPEND BY CHANNEL") **UI ekran taslağı
saymadım** — bunlar bir ekranın alan düzenini değil bir akışı/örnek metni tarif ediyor.

**Section_04 — 8 gerçek UI taslağı (satır aralığı, `Section_04_Actuals_First_Mode.md`):**

| # | Taslak | Satır | Karşılığı ekran |
|---|---|---|---|
| 1 | Agreement Creation Wizard — Step 2 (Basics) | 332–350 | Anlaşma oluşturma formu (ölçülemedi — ayrı bir "yeni anlaşma" rotası routeConfig'te yok, `AgreementsPage` içi modal/wizard olabilir, **doğrulanmadı**) |
| 2 | Agreement Creation Wizard — Step 3 (Tactic & Mechanics) | 353–372 | aynı — doğrulanmadı |
| 3 | Agreement Creation Wizard — Step 4 (Justification) | 375–389 | aynı — doğrulanmadı |
| 4 | Validation Results UI (batch import) | 633–659 | `/off-invoice/upload` adım 2 "Validasyon" (görülmedi — dosya yüklenmedi, bkz. §4 "Ölçülmeyenler") |
| 5 | Approval UI = **Batch Approval Request** | 721–759 | **ekran yok** → §3 üçüncü kova |
| 6 | KPI Dashboard (Actuals-First) | 919–954 | `/dashboard` ve `/finance` (kısmi — bkz. aşağı) |
| 7 | UI Widget = **Price Simulation** | 1141–1174 | **ekran yok** → §3 üçüncü kova (T-149, bilinen) |
| 8 | Alert Example (Budget Alert) | 1704–1722 | **ekran yok** → §3 üçüncü kova |

`routeConfig`'te `/agreements/new` yok; `AgreementsPage`'in "+ Yeni Anlaşma" düğmesinin
neye açıldığı (modal mı, ayrı sayfa mı) **bu turda tıklanmadı — ölçülmedi**. 1-3 numaralı
taslakların ekran karşılığı bu yüzden **doğrulanamadı**, "yok" da denemez.

### 2.2 Section_04 — alan bazında karşılaştırma

**KPI Dashboard (Actuals-First) — BRD 919-954 ↔ `/dashboard` (`01-dashboard.png`)**

| BRD alanı | ekranda var mı | not |
|---|---|---|
| Period selector | ✅ | "Dönem: 2026-08" |
| Total Spend / trend oku (↑12%) | ❌ kısmen | gerçek ekranda "Bütçe Kullanımı" var ama BRD'deki "↑ 12% vs Dec" trend göstergesi yok |
| Budget Utilization % (Amber/Green) | ✅ | "%0.0" — RAG rengi yok, sadece yüzde |
| On-Invoice/Off-Invoice split | ✅ | "On-Invoice / Off-Invoice" satırları var |
| BY CHANNEL bar chart | ❌ | yok — kanal kırılımı `/dashboard`'da yok |
| Efficiency Metrics (Effective Discount, Agreement Coverage, Avg Agreement Value, Approval Time) | ❌ | **hiçbiri yok** |
| `[📊 Detailed Report] [📥 Export Excel]` | ❌ | dashboard'da export yok |

> Gerçek `/dashboard` BRD'nin KPI Dashboard taslağından **farklı bir ekran** — operasyonel
> bir "iş listesi" paneli (bekleyen onaylar, hakediş, müşteri listesi). BRD'nin tarif ettiği
> analitik dashboard'a en yakın olan `/finance` (**çöküyor**, bkz. §6 D1).

**Alan zorunluluğu/varsayılan farkları (agreement detail, `41-agreement-detail.png`):**

BRD Step 2-4 taslakları her alan için **çözümlenmiş görünen değer** gösteriyor
("Özgür Kozmetik", "Wella SP Shampoo 500ml", "Competitive Response", "Off-Invoice Rebate").
Gerçek `/agreements/:id` ekranı **ham UUID** gösteriyor — bkz. §6 D2. Bu bir "alan eksik"
değil, **"alan var ama davranışı farklı"** (BRD: insan-okunur; gerçek: FK id) — §2.1'in üçüncü
sorusu ("Alanların DAVRANIŞI aynı mı?") burada **hayır**.

### 2.3 Section_05 — alan bazında karşılaştırma

**§5.2 Grid ("Example Column Set", BRD 298-318) ↔ `/plans/:id` Planning Grid (`46-plan-detail-grid.png`, fixture ile ölçüldü)**

| BRD kolonu | ekranda var mı |
|---|---|
| `[+]` expand / SKU Name / Brand | ✅ (Item Name, Item Code) |
| List Price / Base Volume / Planned Volume | ✅ |
| Uplift % | ✅ (Volume Uplift %) |
| Incremental Volume | ✅ |
| CPP On% / Display Fee (taktik alanları) | **doğrulanmadı** — fixture FU'da taktik atanmamıştı, grid'de görünmedi |
| GP ROI % | ✅ (Grand-Totals benzeri panelde: "GP ROI 0.0%") |
| RAG (🟢🟡🔴) | ✅ ama fixture'da veri yok → "N/A" gösteriyor |
| `[locked]`/`[edit]`/`[calc]`/`[parent]` legend'i | **doğrulanmadı** — hangi hücrelerin salt-okunur/hesaplı olduğu görsel olarak ayırt edilmedi (küçük görüntüde net değil) |

**§5.4 Grand Totals Panel (BRD 1434-1456) ↔ aynı ekranın üst paneli**

| BRD alanı | ekranda |
|---|---|
| Volume (Base/Planned/Uplift) | ✅ "BASE VOLUME / PLANNED VOLUME / INCREMENTAL" |
| Profit (Incremental GP) | ❌ görünmüyor (panelde yok, muhtemelen Analiz & Rapor sekmesinde) |
| Spend (Total Planned + Budget) | ✅ "TOTAL SPEND" — ama BRD'deki "(Budget: 50K)" karşılaştırması yok |
| ROI (GP ROI + Target) | ✅ "GP ROI 0.0% / Target: %20 (▼20.0pp)" — **hedef %20 sabit görünüyor**, `docs/analysis/0051`'in ölçtüğü `GrandTotals.tsx:66`'daki `targetRoi = 20.0` hardcode'unu bu ekran görüntüsü **doğruluyor** (bağımsız, taze ölçüm) |

**§5.4 Inline Optimization Hints (1460-1475), Undo/Redo Stack (1479-1500)** — ekranda **yok**.
`docs/analysis/0051`'in bulgusuyla tutarlı (kod arama: `whatif|what-if|simulat` → 0 dosya;
undo/redo → yalnız 2 İngilizce yorum cümlesi). Bu turda **görsel olarak da doğrulandı**: grid
ekranında `[↶ Undo] [↷ Redo]` araç çubuğu yok, hiçbir hücrede "⚠️ OPTIMIZATION SUGGESTION" kutusu
yok.

**§5.6 Approval UI (Approver View, BRD 1587-1643) ↔ `/plan-approvals` (`15-plan-approvals.png`)**

`plans=0` olduğu için onay bekleyen bir plan **gösterilemedi** — sayfa "Onay bekleyen plan
bulunmamaktadır" boş durumunda. BRD'nin öngördüğü alanlar (Key Metrics, Profitability
Breakdown by FU, Tactical Mix, Planner Notes, Decision: Approve/Reject/Request Changes) **bu
turda hiç gözlemlenemedi** — ne var ne yok denilebilir, sadece **ölçülemedi**.

**§5.3 RAG Aggregation (Visual Example, BRD 470-487)** — kural metni (`SKU Red → FU Red`,
karışık → Amber, hepsi Green → Green) kodda daha önce doğrulanmış (bu turun kapsamı dışı,
bkz. sistem promptu "Öncelikli test edilecek BRD kuralları"); bu turda yalnızca **görsel**
karşılığı arandı — grid'de RAG kolonu var (`46-plan-detail-grid.png`) ama fixture verisi
olmadığı için gerçek bir Red/Amber/Green karışımı **gözlemlenmedi**.

---

## 3. ⛔ Üçüncü kova: BRD'de çizilmiş, ekranı olmayan

Bilinen ikisi doğrulandı, **taramada beşe çıktı**:

| # | Taslak | Kaynak | Durum |
|---|---|---|---|
| 1 | **Price Simulation Widget** | `Section_04` 1141-1174 | [[T-149]] — doğrulandı, `routeConfig`'te ilgili bir bileşen/rota yok, `/agreements/:id` detay ekranında da yok |
| 2 | **Batch Approval Request** UI | `Section_04` 721-759 | doğrulandı — `agreement-transactions` batch onay ekranı yok; `/off-invoice/upload` yalnız "Dosya Yükleme → Validasyon → Onay" 3 adımlı bir stepper (adım 3 içeriği bu turda gözlemlenmedi) |
| 3 | **What-If Analysis** | `Section_05` §5.4 | `docs/analysis/0051` — `whatif\|what-if\|simulat` → 0 dosya |
| 4 | **Undo/Redo Stack** | `Section_05` §5.4, 1479-1500 | `docs/analysis/0051` + bu turda görsel doğrulama (§2.3) |
| 5 | **Inline Optimization Hints** | `Section_05` §5.4, 1460-1475 | `docs/analysis/0051` + bu turda görsel doğrulama (§2.3) |
| 6 | **Reports (5 rapor türü)** — Plan Performans, ROI Dağılım Analizi, Trade Spend Özeti, Bütçe Kullanım Raporu, Anlaşma Durum Raporu | `Section_04` 1759-1832 ("SPEND BY CHANNEL", "AGREEMENT PERFORMANCE", "BUDGET UTILIZATION" örnek çıktıları) | **YENİ — bu turda bulundu.** `Sidebar.tsx:128-151`'de "Raporlar" menü grubunun **5 alt öğesinin hiçbirinde `href` yok** — kod bunu bilerek `cursor-not-allowed`, gri, tıklanamaz render ediyor (`Sidebar.tsx:722-738`, yorum: *"e.g., report items without links"*). Yani bu **kazara boş bir rota değil, kasıtlı olarak devre dışı bırakılmış bir menü grubu** — ama kullanıcı arayüzünde 5 rapor adı **görünüyor**, hiçbiri çalışmıyor. |

Madde 6, diğerlerinden farklı bir alt sınıf: 1-5'te BRD taslağının **hiçbir izi** yok (rota yok,
menü girişi yok). 6'da **menüde görünen ama işlevsiz** bir "hayalet" var — kullanıcı raporun
var olduğunu sanıp tıklıyor, hiçbir şey olmuyor. Bu, boş bir eksiklikten daha kötü bir UX
sinyali olabilir; ürün sahibine ayrıca bildirilmeli.

---

## 4. Bulunan defektler

### D1 — `/finance` (FinanceDashboard) React ile çöküyor + 4 rapor endpoint'i `400` dönüyor

**Tekrar üretim:** ADMIN olarak giriş yap → `/finance`'e git.

**Beklenen:** BRD KPI Dashboard taslağına yakın bir finans özet ekranı.

**Gerçek:** `ErrorBoundary` yakalıyor — "Something went wrong: Rendered more hooks than
during the previous render." Konsol:

```
400 Bad Request × 6  — /finance-reporting/spend-trend, /finance-reporting/variance-analysis,
                        /finance-reporting/cash-flow-projection, /finance-reporting/plan-performance (×2)
API Error body: "property granularity should not exist", "property comparisonType should not exist",
                 "property months should not exist", "property startDate/endDate should not exist"
pageerror: Rendered more hooks than during the previous render.
  at SpendCompositionWidget (src/components/finance/widgets/SpendCompositionWidget.tsx:33:3)
```

**Kök neden ipucu (debugger için, düzeltilmedi):** `400` gövdesi NestJS'in
`ValidationPipe({ forbidNonWhitelisted: true })` imzası — frontend `finance-reporting.endpoints.ts`
(`spend-trend`/`variance-analysis`/`cash-flow-projection`/`plan-performance`, `FinanceDashboard.tsx:114,126,148,158`)
DTO'da tanımlı olmayan query parametreleri (`granularity`, `comparisonType`, `months`,
`startDate`, `endDate`) gönderiyor. Sonraki hook hatası muhtemelen bu 400'lerin bir widget'ı
(`SpendCompositionWidget`) koşullu bir erken-return'e düşürmesinden geliyor — **doğrulanmadı**,
sadece iki belirtinin aynı sayfada aynı anda göründüğü ölçüldü.

**Etki:** BRD'nin öngördüğü finans dashboard'u **tamamen kullanılamaz durumda**.

### D2 — Agreement detay ekranı, çözümlenmiş isim yerine ham UUID gösteriyor

**Tekrar üretim:** `/agreements/:id` (`41-agreement-detail.png`).

**Beklenen (BRD Step 2 taslağı):** "Customer (CPL): Özgür Kozmetik", "FU: Wella SP Shampoo
500ml", "Tactic: Competitive Response", "Mechanic: Off-Invoice Rebate".

**Gerçek:** "Müşteri: `b39ade6a-ea33-413f-95a0-281c859f32fd`", "Forecasting Unit (FU):
`c451e8b8-…`", "Kanal: `5431c4ae-…`", "Taktik: `41b55aae-…`", "Mekanik: `8f8ba312-…`".
Ayrıca "Mekanik Değeri: **TRY**" — bir para birimi kodu, beklenen sayısal destek değeri değil
(ör. "15.00 TL/adet").

**Etki:** Ekran teknik olarak "açılıyor" ama BRD'nin varsaydığı okunabilirlikte değil — bir
kullanıcı bu ekrandan hangi müşteri/ürün/taktik olduğunu **okuyamaz**.

### D3 — Ledger ve budget dashboard sayısal olarak tutarsız (1231 kayıt vs ₺0)

**Tekrar üretim:** `/budget` (Dashboard sekmesi) ile `/budget/ledger` (Ledger Read Only) aynı
oturumda karşılaştırıldı.

**Ölçüm (DB, doğrudan sorgu):**

```
main.ledger_entries:     1231 satır, toplam |amount| = 6.080.000 TRY
                          → budget_envelope_id: TÜMÜNDE NULL (1231/1231)
main.budget_envelopes:   4 zarf, hepsinde consumed_amount = 0.00
main.budget_transactions: yalnız 4 satır (muhtemelen ilk tahsis)
main.budget_reservations: 0 satır
```

**Ekranda görünen:**
- `/budget/ledger`: 1231 kayıt, RESERVE/CONSUME işlemleri, negatif tutarlar (`-₺4.000` vb.) —
  gerçek veri gösteriyor.
- `/budget` dashboard'u ve her envelope detay ekranı (`42-budget-envelope-detail.png`):
  "Rezerve Edilmiş: 0 TRY", "Tüketilen: 0 TRY", "İşlem Geçmişi: Henüz işlem geçmişi
  bulunmamaktadır."

**Bulgu:** `ledger_entries` tablosundaki 1231 kaydın **hiçbiri** herhangi bir
`budget_envelope_id`'ye bağlı değil, bu yüzden hiçbiri envelope'ların
`consumed`/`reserved`/`available` hesabına **girmiyor**. Ledger sayfası (kendi başına
doğru bir kayıt listesi olabilir) ile Budget Dashboard/Envelope Detail (kendi başına
`budget_envelopes` tablosuyla tutarlı) **birbiriyle çelişen iki gerçeklik** sunuyor: biri
"₺6.080.000'lık hareket oldu" diyor, diğeri "₺0 tüketildi" diyor.

⚠️ **Kök neden bu turda araştırılmadı** — ölçüm modundayım, kod değiştirilmedi. Olası
açıklamalar (hiçbiri doğrulanmadı): (a) bu 1231 kayıt e2e/manuel test koşumlarından kalan ve
`budget_envelope_id`'yi hiç doldurmayan bir seed/test yolu, (b) envelope bağlama gerçek üretim
akışında opsiyonel bırakılmış bir alan, (c) `ledger_entries` ile bütçe yaşam döngüsü
(`RESERVE/COMMIT/RELEASE`) kasıtlı olarak ayrı iki mekanizma. Debugger/backend-engineer'a
devredilecek soru: **`budget_envelope_id` NULL olan bir ledger kaydı üretim akışında normal
mi, ve öyleyse Budget Dashboard'un bunu hiç yansıtmaması BRD'nin "her rezervasyon ve harcama
burada listelenir" (Ledger sayfası açıklama metni) iddiasıyla nasıl bağdaşıyor?**

### D4 — Sidebar onay rozetleri hardcoded `1`, gerçek veriyle uyuşmuyor

**Tekrar üretim:** ADMIN girişi, sidebar'da "Plan Onayları" ve "Anlaşma Onayları" rozetlerine
bak; `/plan-approvals` ve `/agreement-approvals` sayfalarını aç.

**Ölçüm:**

```
Sidebar.tsx:76,157,331,424 — dört ayrı yerde: badge: 1, // TODO: Get from API
API (gerçek):  GET /plans        → []           (0 bekleyen)
               GET /agreements   → 0 PENDING (3 kayıt: 2×DRAFT, 1×APPROVED)
Sayfa içi kartlar: "BEKLEYEN: 0" (her iki sayfada da)
```

**Etki:** Sidebar her zaman "1 bekleyen onay var" gösteriyor, sayfanın kendisi ve API "0"
diyor. Düşük önem ama **CLAUDE.md'nin "TODO ile değil task ile kaydedilir" kuralının** tam bir
örneği — dört kopya TODO, hiçbiri task'a bağlanmamış.

### D5 (bilgi amaçlı, defekt değil) — "Raporlar" menüsü kasıtlı olarak devre dışı

§3 madde 6'da detaylandırıldı. Kod, bunun bilinçli bir yer tutucu olduğunu (`cursor-not-allowed`,
yorum: *"e.g., report items without links"*) gösteriyor — bir regresyon değil, **BRD'nin rapor
setinin (§4 son bölümü) hiç başlanmamış olduğunun** UI'daki izi.

---

## 5. Ölçülmeyenler (ZORUNLU — açıkça listele)

- **Agreement Creation Wizard (BRD Step 2-4, §2.1 madde 1-3):** `routeConfig`'te ayrı bir
  `/agreements/new` rotası yok; "+ Yeni Anlaşma" düğmesinin bir modal mı ayrı sayfa mı açtığı
  **tıklanmadı, ölçülmedi**.
- **Off-Invoice Upload adım 2 (Validasyon) ve adım 3 (Onay):** gerçek bir dosya
  yüklenmediği için stepper'ın sonraki adımları **görsel olarak doğrulanmadı**. Mevcut e2e
  (`03-file-upload.spec.ts`) yalnızca müşteri CSV import akışını kapsıyor, off-invoice
  batch akışını değil.
- **Plan Approval (Approver View) alan karşılaştırması (§2.3):** `plans=0` olduğu için onay
  bekleyen gerçek bir plan **hiç gözlemlenemedi**; sayfa yalnızca boş durumda görüldü.
- **RAG kırmızı/sarı/yeşil karışımının görsel karşılığı:** fixture plan'da veri girilmediği
  için grid'de gerçek bir Red/Amber/Green karışımı **oluşturulmadı** — yalnızca "N/A" görüldü.
- **`[locked]`/`[edit]`/`[calc]`/`[parent]` hücre-tipi ayrımının görsel netliği:** ekran
  görüntüsünde küçük ölçekte ayırt edilemedi, yakından incelenmedi.
- **RBAC'a göre farklı rollerin gördüğü ekran farkları:** bu tur yalnızca ADMIN ile gezildi
  (talimat gereği "en geniş erişim"); PLANNER/CATEGORY_MANAGER/FINANCE_MANAGER/READONLY'nin
  aynı rotalarda gördüğü daha dar kümeler **bu belgede yok** (bu, mevcut
  `01-login-rbac.spec.ts`'nin konusu, tekrarlanmadı).
- **`/finance` dışındaki 38 rotanın performansı / network şelalesi (waterfall):** yalnızca
  konsol hata/hata yokluğu ölçüldü, yükleme süresi veya gereksiz istek sayısı **ölçülmedi**.
- **D1'in kök nedeni** (`SpendCompositionWidget`'ın "Rendered more hooks" hatasının 400'lerle
  ilişkisi): iki belirti aynı anda gözlemlendi, aralarındaki nedensellik **doğrulanmadı** —
  bu debugger'ın işi.
- **D3'ün kök nedeni** (1231 ledger kaydının neden envelope'suz kaldığı — seed mi, test
  kalıntısı mı, tasarım mı): yalnızca **sayısal tutarsızlığın kendisi** ölçüldü, sebep
  **araştırılmadı**.
