# TTM — Eligibility (uygunluk) yapısının ENVANTERİ

**Task:** `T-345` · **Statü: İNCELEME — TAŞIMA DEĞİL.**
**Kaynak repo:** `/Users/sertact/Documents/CollMind/Code/TTM` — **SALT-OKUNUR**, dondurulmuş
(`docs/decisions/0001-ctpm-ana-urun-ttm-dondurma.md`). Bu turda TTM'e tek bayt yazılmadı, TTM'de
hiçbir komut çalıştırılmadı (`§8` kanıt).
**Ölçüm tarihi:** 2026-08-31 · Ölçen: data-analyst
**TTM ölçüm anı:** branch `codex/239-lta-validity-range` (repo o branch'te duruyordu; checkout
YAPILMADI). Kanonik kod yolu `apps/api` + `apps/web`; repoda ayrıca **ölü** `backend/`,
`frontend/`, `web/` ve `.claude/worktrees/` ağaçları var — bunlar ölçüme **alınmadı**.

> ⚠️ **Bu belge bir spec değildir.** TTM davranışı bir *girdidir*, kanıt değil
> (`CLAUDE.md §2.1.2`). Hiçbir kalemi yerel ölçüm/hüküm olmadan karar taşımaz.

---

## §1 · VERİ MODELİ — eşleşme hangi TABLODA, hangi ŞEKİLDE?

### 1.1 Tek tablo, JUNCTION YOK — eşleşme DENORMALİZE kolonlarda

TTM'de `kategori × CPL × tactic` diye **ayrı bir eşleşme tablosu YOKTUR.** Uygunluk,
`tactic_definitions` satırının **kendi kolonlarında** taşınır:

| kolon | tip | geldiği migration | semantik |
|---|---|---|---|
| `tenant_id` | uuid NOT NULL | `1760910000000-InitMvpSchema.ts:240` | kiracı sınırı |
| `tactic_code` | varchar(50) | `…InitMvpSchema.ts:241` | kimlik (`UQ_tactic_definitions_tenant_code`, `:249`) |
| `value_unit` | varchar(50) | `…InitMvpSchema.ts:243` | `PERCENT` / `AMOUNT` / `PER_UNIT` |
| `is_active` | bool DEFAULT true | `…InitMvpSchema.ts:244` | genel kapatma |
| `show_in_grid` | bool DEFAULT true | `1760910200000-PlanGridSupport.ts:40` | **grid ekseni** |
| `applicable_channels` | `customer_channel_enum[]` NULL | `…PlanGridSupport.ts:43` | **kanal ekseni** |
| `applicable_categories` | `text[]` NULL | `…PlanGridSupport.ts:46` | **kategori ekseni** |
| `claim_trigger` | text NOT NULL DEFAULT `'SALES'` | `1760911200000-AgreementManualClaimsV03.ts:9-11` | `SALES`\|`MANUAL` (`CHK_…_claim_trigger`, `:27`) |
| `pop_required` | bool DEFAULT false | `…AgreementManualClaimsV03.ts:13-14` | `CHK_…_pop_requires_manual` (`:37`) |
| `default_amount` | numeric(14,2) NULL | `…AgreementManualClaimsV03.ts:17-18` | — |
| `spending_type` | text NOT NULL DEFAULT `'OFF_INVOICE'` | `…AgreementManualClaimsV03.ts:21-22` | `ON_INVOICE`\|`OFF_INVOICE` (`CHK_…`, `:32`) |
| `cpl_id` | uuid NULL → `cpls(id)` | `1760911400000-AgreementPhase1Policy.ts:82`, FK `:94-98`, IDX `:102` | **CPL ekseni** |

**Uygunluk eksenleri ÜÇ:** `cpl_id` · `applicable_channels` · `applicable_categories`.
Üçünün de **wildcard semantiği aynı:** `NULL` (veya dizi için `cardinality = 0`) → *"hepsi"*.

⛔ **Excel'in "Mechanic (aile)" ekseninin DB karşılığı YOK.** `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md §2`
9 tactic → 6 mekanik ailesi diyor; TTM'de `tactic_code` **tek kimliktir**, mekanik-ailesi kolonu
yoktur. Aynı şekilde Excel'in **"Calc Type"** ekseninin de DB kolonu yoktur (bkz. `§4`, kalem 3).

### 1.2 Tabloyu tüketen tablolar (uygunluğun bağlandığı yerler)

| tablo | FK | kaynak |
|---|---|---|
| `tactic_values` | `tactic_definition_id` | `…InitMvpSchema.ts:334` (+ `fu_id` `:332`, `sku_id` `:333`) |
| `agreement_tactics` | `tactic_definition_id` | `1760910900000-AgreementsV0.ts:62` |
| `agreement_claims` | `tactic_definition_id` | `1760911200000-AgreementManualClaimsV03.ts:69` |
| `on_invoice_run_matches` | `tactic_definition_id` | `17609380000000-OnInvoiceBucketColumns.ts:34` |

### 1.3 ⛔ SEED mi ADMIN-CRUD mu — **İKİSİ DE VAR** (DUR şartı: ikisi de yazıldı, seçim yapılmadı)

**(a) SEED yolu** — `apps/api/src/database/seed-wella-walkthrough.ts:236-244`
(`ensureTactics`, sabit `TACTICS` listesi `:33-43`, 9 kalem).

```
INSERT INTO tactic_definitions (id, tenant_id, tactic_code, tactic_name, value_unit,
  is_active, show_in_grid, claim_trigger, pop_required, default_amount, spending_type)
```

⛔ **Kolon listesinde `cpl_id`, `applicable_channels`, `applicable_categories` YOK.**
Yani seed'in ürettiği dokuz tactic'in **üç uygunluk ekseni de NULL** — hepsi wildcard.

**(b) ADMIN-CRUD yolu** — CSV upsert:
- route: `POST /admin/master-data/tactics/csv` → `admin-master-data.controller.ts:113`
- liste: `GET /admin/master-data/tactics` → `admin-master-data.controller.ts:107`
- servis: `admin-master-data.service.ts` — `listTactics` `:543`, CSV upsert `UPDATE` `:708-717`,
  `INSERT` `:737-745`
- UI: `apps/web/src/app/admin/master-data/tactics-tab.tsx` — CSV şablonu `:18`, kolon
  gösterimi `:631-637`
- CSV kolonları: `tactic_code,tactic_name,value_unit,spending_type,claim_trigger,pop_required,default_amount,cpl_name,applicable_channels,applicable_categories` (`tactics-tab.tsx:18`)
- `cpl_name` → `cpl_id` çözümü: `admin-master-data.service.ts:679-698` (bulunamazsa satır
  **reddedilir**, `:691` — sessiz-atlama YOK, bu iyi bir desen)

**İki yolun ÇELİŞTİĞİ noktalar (ölçüldü, karar VERİLMEDİ):**

| # | fark | kanıt |
|---|---|---|
| 1 | Seed uygunluk kolonlarını **hiç yazmaz**; CSV yolu yazar | `seed-wella-walkthrough.ts:238` ↔ `admin-master-data.service.ts:740` |
| 2 | CSV upsert `is_active = true` **sabit yazar** — CSV'den pasifleştirme YOK | `admin-master-data.service.ts:718` (`is_active = true,`) |
| 3 | CSV yolu `show_in_grid`'e **hiç dokunmaz** → DEFAULT `true`'da kalır; UI'da da alanı yok | `admin-master-data.service.ts:708-745`'te `show_in_grid` geçmez (`rg` ile doğrulandı, `§6`-PK1) |
| 4 | Tekil `PATCH`/`POST` tactic ucu **yok** — yalnız toplu CSV | `admin-master-data.controller.ts` rota listesi (`cpls` için `Patch/Delete` var, `tactics` için yok) |

### 1.4 ⛔ VERİNİN YOKLUĞU ÖRTÜYOR (`CLAUDE.md §2.7`)

`applicable_channels` / `applicable_categories` / tactic `cpl_id` kolonlarını **yazan tek yol
admin CSV import'udur.** Repodaki **hiçbir seed** (`seed.ts`, `seed-wella-walkthrough.ts`,
`seed-e2e-phase1.ts`, `seed-e2e-phase2.ts`) bu üç kolona değmez — tam liste `§6`-PK2.

⇒ **TTM'in UAT/e2e verisinde uygunluk filtreleri hiçbir zaman AYIRT ETMEDİ.** Üç eksenin
üçü de wildcard olduğu için her filtre `TRUE` döndü. *"UAT'de kanıtlanmış"* nitelemesi bu
mekanizma için **geçerli değildir**; `ADR 0001`'in *"dört vakada kanıtlanmış bir akış"*
nitelendirmesinin bu kalemdeki karşılığı **sıfır vakadır**.

---

## §2 · GRID KOLONLARI — sorgu → kolon akışı

### 2.1 Akış (backend → API → React)

```
tactic_definitions
   │  SQL filtresi: tenant + show_in_grid + applicable_channels + applicable_categories
   │  plans.service.ts:316-352  getApplicableTacticDefinitions()
   ▼
GridTactic[] { id, mechanic_code, mechanic_name, value_unit }      plans.service.ts:347-352
   │  (SQL'deki tactic_code → API'de "mechanic_code" olarak YENİDEN ADLANDIRILIR :350)
   ▼
PlanGridResponse.tactics                                           plans.service.ts:1025
   ▼
const tactics = grid?.tactics ?? []                    apps/web/src/app/planning/page.tsx:160
   ▼
<th>{t.mechanic_code}</th>   → her tactic BİR KOLON     apps/web/src/app/planning/page.tsx:827-831
```

**Kolonlar STATİK DEĞİL, DB'den türetilir.** Kolon başlığı = `tactic_code` (kullanıcı-görünür
`tactic_name` değil — `page.tsx:829`). Sıra = `ORDER BY tactic_code ASC` (`plans.service.ts:339`)
— **kolon-sırası kolonu yoktur.**

### 2.2 Filtre iki katmanda ve İKİ FARKLI ŞEKİLDE kesişiyor

| # | çağrı yeri | eksen: `show_in_grid` | kanal | kategori | **CPL** |
|---|---|:--:|:--:|:--:|:--:|
| 1 | `plans.service.ts:316-352` — grid kolonları + plan kurulumu | ✅ `:328` | ✅ `:330-332` | ✅ `:335-337` | ⛔ **YOK** |
| 2 | `plans.service.ts:937-962` — grid *değerleri* (JOIN'de filtre TEKRAR) | ✅ `:951` | ✅ `:953-955` | ✅ `:958-960` | ⛔ **YOK** |
| 3 | `agreements.service.ts:585-666` — `GET /tactics/definitions` | ⛔ **YOK** | ✅ `:624-625` | ✅ `:632-633` | ✅ `:617` |
| 4 | `agreements.service.ts:143-172` — `createAgreement` doğrulaması | ⛔ YOK | ✅ `:147` | ✅ `:148` | ✅ `:146` |
| 5 | `agreements.service.ts:1024-1053` — `updateAgreement` doğrulaması | ⛔ YOK | ✅ `:1028` | ✅ `:1029` | ✅ `:1027` |
| 6 | `apps/web/src/lib/agreementsCatalog.ts:71-95` — **istemci tarafı** filtre | ⛔ YOK | ✅ `:85-88` | ✅ `:90-93` | ⛔ **YOK** |

⛔ **AYNI KURALIN ALTI AYRI İMPLEMENTASYONU, ÜÇ FARKLI EKSEN KÜMESİYLE.**
`CLAUDE.md §7`'nin *"üç kez yazılmış scope mantığı"* deseninin TTM'deki karşılığı — ve burada
**altı.** `4` ile `5` **birbirinin bayt-kopyasıdır.**

**İki ölçülmüş SAPMA (karar verilmedi, bildiriliyor):**

1. **Plan-grid CPL'i hiç sormuyor.** Bir tactic yalnız `CPL-X` için tanımlanmış olsa bile
   `CPL-Y`'nin planında **kolon olarak çıkar** (`plans.service.ts:316-352`'de `cpl_id`
   predicate'i yok), ama aynı tactic anlaşma yolunda `TACTIC_NOT_ELIGIBLE_FOR_AGREEMENT`
   ile **reddedilir** (`agreements.service.ts:167`). Bugün görünmüyor, çünkü `§1.4`.
2. **Kategori karşılaştırmasının BÜYÜK/KÜÇÜK HARF davranışı iki katmanda farklı.**
   SQL tarafı: `$3 = ANY(applicable_categories)` — **tam eşleşme**, yalnız `.trim()`
   (`agreements.service.ts:630`). İstemci tarafı: `c.trim().toLowerCase() === normalizedCategory`
   — **case-insensitive** (`agreementsCatalog.ts:92-93`). Aynı veri iki katmanda farklı
   sınıflanabilir.

---

## §3 · MEKANİK **DEĞER** GİRİŞİ — girişin ŞEKLİ

### 3.1 Şekil: **FU düzeyi.** SKU düzeyi DEĞİL.

`tactic_values` şeması hem `fu_id` hem `sku_id` taşır (`…InitMvpSchema.ts:332-333`) — ama:

- **Tek yazma yolu** `plans.service.ts:510-544`: döngü `for (fuId of fuIds) → for (tactic of tactics)`,
  ve `INSERT` kolon listesi `(id, tenant_id, plan_id, fu_id, tactic_definition_id, entered_value, created_by, …)`
  (`:513-521`) — **`sku_id` kolonu INSERT'te YOKTUR** ⇒ her satır `sku_id IS NULL` doğar.
  (Repoda `INSERT INTO tactic_values` **tek** geçer — `§6`-PK3.)
- **Okuma** `plans.service.ts:937-962`: `WHERE … AND tv.fu_id IS NOT NULL` (`:950`) —
  `sku_id`'li satır **hiç okunmaz**.
- **Sözlük anahtarı FU başına**: `fu.tactic_values[row.tactic_code]` (`plans.service.ts:1007`),
  yani bir FU × tactic için **tek** değer.
- **Güncelleme** `plans.service.ts:786-800`: `UPDATE … WHERE id = $2` — hedef `tactic_value_id`,
  ölçek değişmiyor.
- **UI kanıtı (yük taşıyan):** FU satırında mekanik hücresi `<input type="number">`
  (`apps/web/src/app/planning/page.tsx:915-933`); SKU satırında **aynı kolonlar sabit tire**:
  ```tsx
  {tactics.map((t) => (
    <td key={t.id} className="border-b px-3 py-2">
      <span className="text-gray-400">–</span>
    </td>
  ))}
  ```
  `apps/web/src/app/planning/page.tsx:973-977`

⇒ **SKU düzeyinde mekanik girişi TTM'de YOKTUR.** SKU satırında düzenlenebilir tek alan
`planned_volume`'dur (`page.tsx:955-968`).

### 3.2 ⛔ EXCEL KANONUYLA ÇELİŞİYOR — çelişki yazıldı, hüküm VERİLMEDİ

| kaynak | ne diyor |
|---|---|
| `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md §2`, son paragraf | *"değerler SKU-satırı düzeyinde farklılaşabilir (aynı mekanik R15'te 0.16, R14'te 0.18) ⇒ Mekanik değeri plan-başlığının değil, plan-satırının özniteliğidir."* |
| `…§6` kalem 5 | *"Mekanik-değerinin SKU-düzeyi yaşaması — CTPM'de mekanik nerede yaşıyor?"* — **açık soru** |
| **TTM ölçümü** | mekanik değeri **FU** düzeyinde yaşar; SKU hücresi salt-okunur tire |

**Hangi tarafın doğru olduğuna karar VERİLMEDİ** (`CLAUDE.md §2.4`). Ürün sahibi sorusu `§7`-S1.

📌 Not: `tactic_values.sku_id` kolonu + FK'si **duruyor** (`…InitMvpSchema.ts:333`, IDX `:347`).
Yani şema SKU-düzeyini destekleyecek şekilde açılmış, **yol açılmamış**. Bu bir *"mekanizma var,
yol yok"* vakasıdır (`CLAUDE.md §4.2`, üçüncü madde) — ve Excel'in istediği şekle şema
tarafından **zaten hazır**.

### 3.3 Agregasyon semantiği — Excel `§3` ile karşılaştırma

Excel `§3`: *"oranlar SUM'lanmaz, toplam-satırda yeniden hesaplanır."*
TTM: FU satırında oran hücresi **kullanıcı girdisidir**, türetilmiş bir toplam değil — yani
*"oranı toplama"* sorusu grid'de **doğmuyor**. Lumpsum tarafında TTM ters yöne dağıtım yapıyor:
FU'ya girilen lumpsum, SKU'lara `base_volume` ağırlığıyla **paylaştırılıyor**
(`apps/api/src/kpi/kpi-engine-v0.ts:376-432`), kuruş farkı son SKU'ya yazılıyor (`:420-426`).
⇒ Excel'in *"toplamdan yeniden hesapla"* kuralıyla **çelişmiyor**, ama onu da **karşılamıyor** —
TTM'de plan-listesi toplam-satırı davranışı bu ölçümün kapsamında değildi (`§6`-Ö1).

---

## §4 · ⭐ ÇEVİRİ NOTLARI — neyin DESENİ alınır, neyin MİMARİSİ ALINMAZ

`CLAUDE.md §1` kuralı: *düz kopyalama YASAK; TTM davranışı CTPM'in katmanlı/DDD modül yapısına
uyarlanır; Next.js UI yalnız davranış referansıdır; BRD'nin dinamik-formül kuralı korunur.*
Aşağıda **kalem kalem hangisi** ve **neden**.

| # | TTM kalemi | karar | gerekçe |
|---|---|---|---|
| 1 | **Üç eksenli wildcard uygunluk modeli** (`cpl_id` + `applicable_channels[]` + `applicable_categories[]`, `NULL`/boş = hepsi) — `…PlanGridSupport.ts:43-46`, `…AgreementPhase1Policy.ts:82` | ✅ **DESENİ ALINIR** | Model doğru ve CTPM'de **zaten var** (`§5.1`). Alınacak olan yeni bir şema değil, **wildcard semantiğinin tek yerde tanımlanması**. |
| 2 | `TACTIC_NOT_ELIGIBLE_FOR_AGREEMENT` — **açık hata kodu**, sessiz filtreleme değil (`agreements.service.ts:166-169`; UI karşılığı `useAgreementSubmit.ts:238`) | ✅ **DESENİ ALINIR** | `CLAUDE.md §2.5` ile **birebir uyumlu**: uygun olmayan tactic sessizce düşürülmüyor, **reddediliyor**. CTPM'de karşılığı yok (`§5.4`). |
| 3 | **Calc-type'ı `tactic_code` SONEKİNDEN türetmek** — `code.endsWith('_LS')` (`kpi-engine-v0.ts:376`), `getSpendCodeForTactic` `_LS`/`_PU`/`_PCT` → `_SPEND` (`:288-299`) | ⛔ **MİMARİSİ ALINMAZ** | Hesap davranışı bir **adlandırma konvansiyonuna** gömülü — `CLAUDE.md §2.3`'ün *"hesaplamalar asla hardcode edilmez"* kuralının ihlali. `value_unit` kolonu zaten var ama motor onu okumuyor. Kod adı değişirse hesap sessizce bozulur. |
| 4 | **`calculation_type` (rate/per_unit/lumpsum) yalnız FRONTEND tipinde yaşıyor** — `agreementsCatalog.ts:5`, DB kolonu yok; ayrıca `resolveTacticInputType` `value_unit`'ten tahmin ediyor (`:96-108`) | ⛔ **MİMARİSİ ALINMAZ** | Excel `§2`'nin **üçlü karakteri** (`mechanic + spending-type + calc-type`) TTM'de **üç ayrı yerde üç farklı şekilde** temsil ediliyor: DB (`spending_type` + `value_unit`), motor (kod soneki), UI (`calculation_type` literal). CTPM'de tek bir sınıflandırma alanı olmalı. |
| 5 | **İstemci tarafındaki `fallbackAgreementTacticDefinitions`** — üç tactic UUID'siyle birlikte frontend'e gömülü (`agreementsCatalog.ts:24-58`) | ⛔ **MİMARİSİ ALINMAZ** | Master data'nın UI'a **hardcode kopyası**; üstelik seed UUID'lerine (`c0000000-…-0001/2/3`) bağlı. `CLAUDE.md §2.3`: *"Frontend sadece sonucu render eder."* |
| 6 | **`ctx[code] = v ?? 0`** — girilmemiş mekanik değeri sessizce `0` (`kpi-engine-v0.ts:447`); ayrıca `PLANNED_LTA_ON: 0` sabit (`:442`) ve `const total = fu.tactic_inputs[tacticCode] ?? 0` (`:385`) | ⛔ **MİMARİSİ ALINMAZ** | `CLAUDE.md §2.5` **sessiz sıfır yasağı** — üç ayrı yerde. Dahası `PLANNED_LTA_ON = 0`, `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md §1`'in *"LTA oranı on-invoice mekanik-tabanına girer"* kuralını **çift yönlü** bozar (o belgenin kendi uyarısı: `§1`, "Taban kuralı" bloğu). |
| 7 | **Aynı uygunluk kuralının altı kopyası** (`§2.2` tablosu), ikisi bayt-kopya (`agreements.service.ts:143-172` ≡ `:1024-1053`) | ⛔ **MİMARİSİ ALINMAZ** | `CLAUDE.md §7`. CTPM'de tek bir uygulama noktası olmalı — port sırasında **kopya sayısı çoğaltılmamalı**. |
| 8 | **`apps/web` Next.js sayfa/route yapısı** (`app/planning/page.tsx`, `app/admin/master-data/tactics-tab.tsx`, `_hooks/`, `_components/`) | ⛔ **MİMARİSİ ALINMAZ** | `CLAUDE.md §1`: Next.js UI yalnız **davranış** referansıdır; CTPM Vite/React + TanStack Query'ye **yeniden yazılır**. Alınacak olan `§2.1` akış şekli ve `§3.1` giriş şekli — dosya yapısı değil. |
| 9 | **Ham SQL + `queryRunner.query` + entity'siz katman** (`apps/api` genelinde; `plans.service.ts`, `agreements.service.ts`) | ⛔ **MİMARİSİ ALINMAZ** | `ADR 0001` gerekçe 1 ve 2026-08-10 geriye dönük doğrulaması: CTPM katmanlı/DDD + TypeORM entity. Uygunluk sorgusu CTPM'de repository katmanına iner. |
| 10 | **Toplu CSV upsert = tek yazma yolu; tekil CRUD ucu yok** (`admin-master-data.controller.ts:107,113`) | 🟡 **KISMEN** — CSV **DESENİ** (satır-satır doğrulama + `errors[]` toplama + reddetme, `admin-master-data.service.ts:654-698`) alınır; **tekil CRUD'un yokluğu** alınmaz | Doğrulama deseni sağlam (bilinmeyen `cpl_name` satırı **reddediyor**, `:691`). Ama CSV `is_active = true` sabitliyor (`:718`) ve `show_in_grid`'e hiç dokunmuyor — bu iki kalem **taşınmaz**. |
| 11 | **Grid kolonlarının DB'den türetilmesi** (`plans.service.ts:316-352` → `page.tsx:827`) | ✅ **DESENİ ALINIR** | Kolon evreni statik listede değil, konfigürasyonda. BRD'nin dinamik-formül ilkesinin **kolon tarafındaki** karşılığı. |
| 12 | **Kolon başlığı olarak `tactic_code`** (`page.tsx:829`) ve **kolon sırası `ORDER BY tactic_code`** (`plans.service.ts:339`) | ⛔ **ALINMAZ** | Kullanıcı-görünür ad `tactic_name` alanında duruyor ama gösterilmiyor; kolon-sırası kolonu yok. CTPM'de `gridColumnOrder`/`groupHeader` **zaten var** (`§5.1`) — TTM burada **daha fakir**, geriye adım olur. |
| 13 | **Grid filtresinde `cpl_id` ekseninin atlanması** (`§2.2` sapma 1) | ⛔ **ALINMAZ — bir HATA olarak kaydedilir** | Anlaşma yolu reddederken plan yolu gösteriyor. `CLAUDE.md §2.1.2`: TTM davranışı bir girdidir, doğruluk kanıtı değil. |

> **KORUNUR (her koşulda):** KPI formüllerinin **DB'den** okunup RPN ile değerlendirilmesi —
> TTM'de de böyle (`kpi.formula_text`, `kpi-engine-v0.ts:461-467`). Bu, BRD'nin dinamik-formül
> kuralının TTM'de **korunmuş** yarısıdır ve port sırasında **zayıflatılmamalıdır**. Zayıf olan
> yarı kalem 3/6'dır.

---

## §5 · CTPM KARŞILIKLARI — her TTM yapısı için: var mı, hangi adla?

**Sözlük farkı önemli:** TTM `tactic_definitions` **tek tablodur**; CTPM'de kavram **ikiye
bölünmüştür** — `main.tactics` (aile) + `main.mechanics` (kalem). Yani TTM'in bir satırının
CTPM karşılığı bir `mechanics` satırıdır, `tactics` değil.

| # | TTM yapısı | CTPM'de var mı | CTPM adı / yeri |
|---|---|---|---|
| 1 | `tactic_definitions` tablosu | ✅ **VAR (bölünmüş)** | `main.tactics` — `collmind.backend/src/database/entities/tactic.entity.ts:14`; `main.mechanics` — `mechanic.entity.ts:72` |
| 2 | `applicable_channels` (enum[]) | ✅ **VAR** (jsonb) | `Tactic.applicableChannels` `tactic.entity.ts:42`; `Mechanic.applicableChannels` `mechanic.entity.ts:199` |
| 3 | `applicable_categories` (text[]) | ✅ **VAR** (jsonb) | `tactic.entity.ts:45`; `mechanic.entity.ts:202` |
| 4 | `cpl_id` (tekil uuid) | ✅ **VAR — ve DAHA GENİŞ** | `Mechanic.applicableCpls` **uuid[]** (`mechanic.entity.ts:205-211`) — TTM'de tek CPL, CTPM'de **çoklu** |
| 5 | `show_in_grid` | ✅ **VAR** | `Mechanic.showInGrid` `mechanic.entity.ts:217` |
| 6 | (yok) kolon sırası / grup başlığı | ✅ **CTPM'de FAZLA** | `gridColumnOrder` `:220`, `gridColumnWidth` `:223`, `groupHeader` `:226` |
| 7 | `spending_type` (`ON_/OFF_INVOICE`) | ✅ **VAR — üç değerli** | `Tactic.spendType` `tactic.entity.ts:33-39` (`ON_INVOICE`\|`OFF_INVOICE`\|**`BOTH`**); `Mechanic.spendingType` `mechanic.entity.ts:98-104` |
| 8 | `value_unit` (`PERCENT`/`AMOUNT`/`PER_UNIT`) | ✅ **VAR — ve iki alanda** | `MechanicType` enum `mechanic.entity.ts:6-10` (`PERCENT`/`AMOUNT`/`AMOUNT_PER_UNIT`) + `InputType` `:26-31` + `unitSymbol` `:180` |
| 9 | (yok) calc-type / mekanik-ailesi | ✅ **CTPM'de FAZLA** | `MechanicCategory` enum `mechanic.entity.ts:18-24` — Excel `§2`'nin *"Calc Type"* eksenine **en yakın** yapı |
| 10 | `claim_trigger` (`SALES`/`MANUAL`) | 🟡 **DOLAYLI** | Doğrudan karşılığı **ölçülmedi** (`§6`-Ö2). Yakın kavramlar: `EvidenceClass` `mechanic.entity.ts:48-52`, `SettlementCadence` `:55-58` |
| 11 | `pop_required` | ❓ **ÖLÇEMEDİM** | `§6`-Ö3 |
| 12 | `default_amount` | ✅ **VAR** | `Mechanic.defaultValue` `mechanic.entity.ts:159-166` |
| 13 | `tactic_values` (plan × FU × tactic girdi satırı) | ✅ **VAR (farklı şekil)** | `Plan.tactics?: Record<string, number>` — `plan.entity.ts` (`'CPP_ON_PCT': 10` yorumu); kolon `tactic_spend` |
| 14 | SQL'de uygunluk filtresi | 🟡 **VAR ama BELLEKTE** | `MechanicService.getApplicableMechanics` — `mechanic.service.ts:502-565` (JS `filter`, SQL değil) |
| 15 | `GET /tactics/definitions` (kapsama göre) | ✅ **VAR** | `POST /master-data/mechanics/applicable` — `mechanic.controller.ts:196-207` |
| 16 | Anlaşma yolunda kapsam filtresi | ✅ **VAR** | `agreement.service.ts:1229-1247` |
| 17 | `TACTIC_NOT_ELIGIBLE_FOR_AGREEMENT` reddi | ⛔ **YOK** | CTPM anlaşma yolu uygun olmayanı **listeden düşürüyor** (`agreement.service.ts:1229-1247`), reddeden bir kontrol ölçülmedi — TTM burada **daha katı** |
| 18 | Tactic CSV import | ❓ **ÖLÇEMEDİM** | `§6`-Ö4 |
| 19 | Grid kolonlarının uygunluğa göre türetilmesi | ⛔ **YOK — mekanizma var, YOL YOK** | aşağıda `§5.2` |

**Sayım: 19 kalem — ✅ tam karşılık 11 · 🟡 kısmi 3 · ⛔ yok 3 · ❓ ölçemedim 2.**

### 5.1 CTPM eligibility modeli TTM'inkinin **ÜST KÜMESİ**

`Mechanic` üzerinde TTM'de olmayan alanlar: `applicableCpls` (çoklu), `exclusionRules` (`:213`),
`mutuallyExclusiveWith` (`:255-261`), `gridColumnOrder`/`gridColumnWidth`/`groupHeader`,
`MechanicCategory`, `trackAgainstBudget` (`:230`), `budgetType` (`:233-239`),
`requiresApprovalThreshold` (`:241-249`).

⇒ **Bu bir port değil, bir BAĞLAMA işidir.** CTPM'in eksiği şema değil, **yol**.

### 5.2 ⛔ CTPM'de mekanizma VAR, YOL YOK — ölçüldü

```
tanımlı ama ÇAĞRILMAYAN uç:
  collmind.frontend/src/api/endpoints/master-data.endpoints.ts:141  getApplicable(...)
  → çağıran sayısı: 0            (pozitif kontrol: mechanicEndpoints.getAll → 5 çağıran)

grid ne yapıyor onun yerine:
  collmind.frontend/src/components/features/plans/PlanningGridEnhanced.tsx:826-841
      const res = await mechanicEndpoints.getAll(true);
      return res.data.filter((m: any) => {
        // TODO: Implement applicability rules check
        return m.isActive;
      });
      } catch { return []; }
```

Üç ayrı kusur tek yerde:
1. **Uygunluk filtresi hiç uygulanmıyor** — backend `getApplicableMechanics` hazır, grid onu
   çağırmıyor; `queryKey`'de `plan.channelId`/`plan.categoryId` **var** ama sorguda kullanılmıyor
   (`:827` ↔ `:830`).
2. **`// TODO: Implement applicability rules check`** — `CLAUDE.md §2.7`, *"TODO arkasına
   saklanmış"* sınıfı.
3. **`catch { return []; }`** — hata yutuluyor, kolon evreni sessizce **boşalıyor**
   (`CLAUDE.md §2.5`).

### 5.3 Ve CTPM'de de VERİNİN YOKLUĞU ÖRTÜYOR — canlı DB ölçümü

```sql
SELECT code, show_in_grid, grid_column_order, group_header,
       applicable_channels, applicable_categories, applicable_cpls, exclusion_rules
FROM main.mechanics ORDER BY grid_column_order NULLS LAST;
```
```
     code     | show_in_grid | grid_column_order |     group_header      | applicable_channels | applicable_categories | applicable_cpls | exclusion_rules
--------------+--------------+-------------------+-----------------------+---------------------+-----------------------+-----------------+-----------------
 CPP_ON_PCT   | t            |                10 | On-Invoice Discounts  |                     |                       |                 |
 MEC-DISCOUNT | t            |                11 | On-Invoice Discounts  |                     |                       |                 |
 CPP_OFF_PCT  | t            |                20 | Off-Invoice Discounts |                     |                       |                 |
 VIS_LS       | t            |                30 | Off-Invoice Lump Sum  |                     |                       |                 |
 DISPLAY_FEE  | t            |                31 | Off-Invoice Lump Sum  |                     |                       |                 |
 PRICE_SUP    | t            |                40 | Off-Invoice Per Unit  |                     |                       |                 |
(6 satır)
```
`main.tactics` (5 satır) — `applicable_channels` / `applicable_categories` **hepsi NULL**.

⇒ **Uygunluk ayrımı bugün CTPM'de de HİÇ KOŞMUYOR.** `CLAUDE.md §2.7`: *"bu yol bugün koşuyor
mu?"* sorusunun cevabı **hayır**, ve cevabı bir **fixture** olmalı — iki tarafta **farklı**
değer taşıyan (`DISIPLIN`: *"Fixture, ayırt etmek istediği iki tarafta FARKLI değer taşımalı"*).

### 5.4 CTPM tarafında iki ek gözlem (bu turda görüldü — düzeltme YAPILMADI)

- `mechanic.service.ts:559-562` — `if (mechanic.exclusionRules) { /* placeholder */ }` →
  gövde boş, kural varsa bile **sessizce geçiyor** (`CLAUDE.md §2.5`, *"if yazıp else
  bırakmamak"*ın kardeşi).
- `agreement.service.ts:1219-1227` — `categoryId` çözülemezse `console.warn` + `categoryCode`
  `undefined` kalıyor; sonuçta kategori filtresi **tamamen atlanıyor** (`:1240`), yani
  çözülemeyen girdi **daha geniş** bir sonuç üretiyor. `DISIPLIN`: *"Beklenen YÖNE yanılan bir
  hata, ters yöne yanılandan tehlikelidir."*

Bunlar bu task'ın kapsamı değil; **bulgu olarak** kaydedildi.

---

## §6 · ⛔ ÖLÇEMEDİM — ve POZİTİF KONTROLLER

*"Ölçemedim" meşru bir çıktıdır. Aşağıdakiler ölçülmedi ve ölçülmüş gibi kullanılamaz.*

| # | ölçülemeyen | neden |
|---|---|---|
| **Ö1** | TTM plan-listesi **toplam-satırı** agregasyon davranışı (Excel `§3`: oranlar SUM'lanmaz) | Kapsam dışıydı; `apps/api/src/reports/` ve dashboard yolları taranmadı |
| **Ö2** | CTPM'de `claim_trigger` (`SALES`/`MANUAL`) karşılığı | `EvidenceClass`/`SettlementCadence` **yakın** ama eşdeğerliği ölçülmedi — *"benziyor"* eşleşme değildir |
| **Ö3** | CTPM'de `pop_required` (kanıt-belgesi zorunluluğu) karşılığı | Aranmadı |
| **Ö4** | CTPM'de tactic/mechanic **CSV import** ucu var mı | Aranmadı |
| **Ö5** | TTM `main`/`freeze/2026-06-24` tag'indeki hâl | Repo `codex/239-lta-validity-range` branch'inde duruyordu; **checkout yasak** ⇒ ölçüm o branch'in hâlidir. Bu satırlar `freeze` tag'inde farklı olabilir |
| **Ö6** | TTM'in **canlı DB'sinde** `applicable_*` kolonlarının gerçekten boş olduğu | TTM'de komut çalıştırmak yasak; `§1.4` iddiası **koddan** (tüm yazma yollarının taranmasıyla) kuruldu, DB'den değil |
| **Ö7** | TTM `backend/`, `frontend/`, `web/`, `.claude/worktrees/` ağaçları | Ölü/yinelenmiş ağaçlar; kanonik `apps/*` ölçüldü. Buralarda **farklı** bir implementasyon olabilir |
| **Ö8** | `agreement_tactics` satır düzeyinde (SKU/FU) değer taşıyor mu | `§3` plan-grid yolunu ölçtü; anlaşma tarafının değer-şekli ölçülmedi |

### Pozitif kontroller (negatif iddiaları taşıyan ölçümler)

| # | iddia | pozitif kontrol |
|---|---|---|
| **PK1** | CSV yolu `show_in_grid`'e dokunmuyor | `rg -n 'show_in_grid' apps/api/src apps/web/src packages` → **7 eşleşme** döndü (`plans.service.ts:328,951` · `seed-wella-walkthrough.ts:238,241` · migration `:40,63` · spec `:183`) — **`admin-master-data.service.ts` listede YOK.** Arama çalışıyor. |
| **PK2** | Hiçbir seed `applicable_*` yazmıyor | `rg -n 'applicable_categories\|applicable_channels' apps` → **44 eşleşme** (migration, plans, agreements, admin, web). Seed dosyalarından **sıfır**; aynı seed dosyaları `cpl_id` için **eşleşiyor** (`seed-e2e-phase1.ts:84`, `seed.ts:188`…) ⇒ dosyalar taranıyor, terim yok. |
| **PK3** | `tactic_values`'a `sku_id` hiç yazılmıyor | `rg -n 'INSERT INTO tactic_values\|sku_id' apps/api/src/plans/plans.service.ts` → `sku_id` **13 kez** geçiyor (`plan_skus` insert `:483`, select `:901` …), `INSERT INTO tactic_values` **1 kez** (`:513`) ve o bloğun kolon listesinde `sku_id` yok. |
| **PK4** | CTPM'de `getApplicable` çağrılmıyor | Aynı dosyadaki `mechanicEndpoints.getAll` → **5 çağıran**. Arama şekli aynı, sonuç farklı. |
| **PK5** | CTPM'de `applicable_*` verisi boş | Aynı sorgu `show_in_grid`/`group_header`/`grid_column_order` için **dolu** değer döndürdü ⇒ satırlar var, kolonlar boş. |

> ⚠️ **Bir ARAÇ HATASI kaydı (`DISIPLIN`: ölçümün kendisi de bir iddiadır):** bu turda
> `rg -ril 'tactic'` yazıldı; `rg` bunu `-r il` (**replace**) diye ayrıştırdı ve çıktıdaki her
> `tactic`i `il`e çevirdi (`tactic.entity.ts:@Entity({ name: 'ils' })` gibi **var olmayan** bir
> tablo adı üretti). Fark edildi, `-l -i` ile yeniden koşuldu ve **bu belgedeki hiçbir bulgu o
> koşumdan gelmiyor.** `CLAUDE.md §2.7` #5 (*"desen yazıldı, sıfır şey yapıyor"*) ailesinin
> **ters yönü**: desen yazıldı, **fazladan** bir şey yaptı.

---

## §7 · ÜRÜN SAHİBİNE AÇIK SORULAR

**S1 — Mekanik değeri hangi düzeyde yaşar: FU mu, SKU mu?**
Excel `§2`/`§6-5`: **SKU-satırı**. TTM: **FU** (`§3.1`). CTPM bugün: **FU**
(`PlanningGridEnhanced.tsx:876` — `editableAt: 'FU'`). Şema her iki tarafta da SKU'ya hazır
(`tactic_values.sku_id`). *Bu bir ürün kararıdır; ölçüm karar veremez.*

**S2 — Uygunluk ekseni kaç boyutlu olmalı?**
TTM: `CPL` + `kanal` + `kategori` (tekil CPL). CTPM şeması: `applicableCpls` **çoklu** +
`exclusionRules` + `mutuallyExclusiveWith`. Faz-2'de **hangi eksen kümesi yürürlüğe girecek?**

**S3 — Uygun olmayan tactic: REDDEDİLİR mi, LİSTEDEN DÜŞER mi?**
TTM ikisini de yapıyor: grid'de düşürüyor (`plans.service.ts:328-337`), anlaşmada
**reddediyor** (`agreements.service.ts:167`). CTPM yalnız düşürüyor. `§2.5` açısından **reddetme**
daha güvenli — ama bu bir UX kararıdır.

**S4 — Uygunluk kuralları hangi yüzeyden yönetilir?**
TTM: yalnız **toplu CSV** (tekil CRUD yok, `§1.3`-d4). CTPM: `Mechanic` CRUD var ama uygunluk
alanları **grid'e bağlı değil** (`§5.2`). Yönetim yüzeyi CSV mi, form mu, ikisi mi?

**S5 — "Calc Type" ekseni nerede yaşayacak?**
Excel `§2` üç eksenli (`mechanic` + `spending-type` + `calc-type`). TTM'de `calc-type`ın **DB
karşılığı yok** — kod sonekinden türetiliyor (`§4`-3). CTPM'de `MechanicCategory` enum'u
(`mechanic.entity.ts:18-24`) bu ekseni taşıyabilir. **Kanonik alan hangisi?**

**S6 — `spend_type = 'BOTH'` (CTPM `tactic.entity.ts:36`) uygunluk açısından ne demek?**
TTM'de böyle bir değer yok (`CHK_tactic_definitions_spending_type`, iki değer).
`budget-envelope.entity.ts` yorumu *"zarf tarafında BOTH diye bir değer YOKTUR"* diyor —
tactic tarafındaki `BOTH`'un bütçe-kapısındaki karşılığı **tanımlı mı?**

---

## §8 · ⛔ TTM TEMİZLİK KANITI

TTM'de **hiçbir komut çalıştırılmadı** (`npm`/migration/test/seed — hiçbiri); yalnız
`rg` · `sed` · `cat` · `ls` · `awk` · `grep` kullanıldı. TTM'e **tek bayt yazılmadı.**

**Tur BAŞINDA** (`git -C /Users/sertact/Documents/CollMind/Code/TTM status --short`):
```
?? .playwright-mcp/
?? docs/audits/LTA_EXECUTION_SEMANTICS_AUDIT.md
?? docs/uat/
?? docs/verification/
?? fabric-current.png
```
Beş kalemin beşi de **bu turdan ÖNCE** vardı (tur açılışında ölçüldü) ve **hiçbiri bu turun
ürünü değildir**.

**Tur SONUNDA:** `§8-SONUÇ` bloğuna bakınız (aşağıya, kapanışta yazıldı).

### §8-SONUÇ — tur kapanışında ölçüm

```
$ git -C /Users/sertact/Documents/CollMind/Code/TTM status --short
?? .playwright-mcp/
?? docs/audits/LTA_EXECUTION_SEMANTICS_AUDIT.md
?? docs/uat/
?? docs/verification/
?? fabric-current.png
```

**ÖNCE ≡ SONRA — bayt bayt aynı. Fark: SIFIR.**

⚠️ Ve bu bir *"boş çıktı"* değil, **değişmemiş** bir çıktıdır — bu yüzden ÖNCE ölçümü tur
açılışında alındı. Bir baz ölçümü olmasaydı bu beş satır *"bu tur mu bıraktı?"* sorusuna cevap
veremezdi (`DISIPLIN`: *"Boş gelen bir çıktı, BEKLENEN içerikle doldurulamaz"*; burada çıktı boş
değil, **sabit**).

`git -C TTM` kullanıldı — TTM dizinine `cd` edilmedi, orada hiçbir komut çalıştırılmadı.
