# 0063 — BRD okuma turu **40**: `Section_02 §2.1–§2.2`

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_02_Product_Overview.md` **8–438** — §2.1 Platform Architecture
  (`2.1.1` felsefe · `2.1.2` paylaşılan çekirdek · `2.1.3` moda özel · `2.1.4` teknoloji) +
  §2.2 Mode Selection Framework (`2.2.1` karar faktörleri/ağacı · `2.2.2` senaryolar +
  workflow çözümü · `2.2.3` hibrit)
- **Ölçüm ortamı:** meta `e99a5fc`. ⚠️ Submodule'ler checkout **edilmemiş** — kod tarafı
  iddiası yok; koda dair her cümle mevcut **kayıtlardan** alıntıdır ve öyle işaretlidir.
- **Neden bu bölüm:** `0059`'un girer kovasında en büyük okunmamış parça (~%89'u
  okunmamıştı) ve yeni BRD'nin ilk bölümü büyük ölçüde buradan gelecek.

---

## 1. 🔴 Rol listesi — paket **üçüncü** bir sayı veriyor

`§2.1.2` paylaşılan çekirdeği anlatırken RBAC'ı şöyle tanımlıyor:

> **Roles:** Admin, Planner, **Approver**, Finance (mode-agnostic)

**Dört rol.** Ve paketin diğer iki beyanı:

| kaynak | rol sayısı | liste |
|---|---|---|
| **`§2.1.2`** (bu tur) | **4** | Admin · Planner · **Approver** · Finance |
| `§7.1` (`0049`) | **5** | (çekirdek roller, Phase 1) |
| `Sprint_0 EA-001` (`0060`) | **+1** | **Super Admin** (*"separate from Admin"*) |

> **Üç belge, üç farklı rol kümesi** — ve hiçbiri diğerine atıf vermiyor.

### 📌 Ve bu, `0056-K1`'in kökenine bir aday getiriyor

`0056-K1` bizdeki **deprecated enum etiketlerini** açık bir karar olarak kaydediyor:
`MANAGER` · `FINANCE` · `APPROVER`. `§2.1.2`'nin listesinde **`Approver` ve `Finance`
aynen** var; `§7.1`'in beş rolünde (`0049`'a göre) bu adlandırma yok.

⚠️ **Bu bir hipotezdir, ölçüm değil:** enum'un bu satırdan mı türediği **kod okunmadan**
söylenemez ve bu turda kod yok. Kaydediliyor ki [[T-165]] tartışırken *"bu etiketler
nereden geldi"* sorusunun bir adayı olsun.

### Ve yetenek adlandırması da üç biçimli

| yer | biçim |
|---|---|
| `§2.1.2` | `can_create_agreement` · `can_create_plan` · `can_approve` |
| `§2.2.2` (workflow çözümü) | **`plans.create`** · **`agreements.create`** |
| `§7.2` (20 yetenek, `0039`) | **`agreements.create`** biçimi ([[T-165]] başlığındaki) |

> İkisi uyuşuyor, `§2.1.2` **tek başına sapıyor**. Yeni BRD'de tek biçim seçilmeli —
> ve `§7.2` çoğunluk.

---

## 2. 🔴 SSO: bir bölüm *"Day 1"* diyor, **iki bölüm Phase 1'de yok** diyor

```
§2.1.4 Integrations:   "SSO: SAML 2.0 / OAuth 2.0 (Day 1)"
§7.7:592               "❌ SSO integration (SAML, OAuth)"      ← Explicitly NOT in Phase 1
§10.1:105              "❌ SSO/SAML integration"                ← Explicitly NOT in Phase 1
```

### Uzlaştıran okuma **adayı** (tur 17'nin dersi)

Aynı `§2.1.4` bloğu, **Authentication** satırında şunu diyor: *"JWT-based, **SSO-ready**
(SAML 2.0 / OAuth 2.0)"*. Yani okuma şu olabilir: **mimari gün 1'de hazır**, **entegrasyon
Phase 1'de yok**.

⚠️ Ama *"(Day 1)"* ibaresi `Integrations` başlığının altında ve yanındaki üç satır
(`ERP Integration (Phase 2)`, `BI Tools (Phase 2)`) **faz etiketi** taşıyor — yani o
sütunda `Day 1` bir **faz beyanıdır**, hazırlık beyanı değil.

> **Sayım:** bir tanık *"Day 1"*, **iki tanık** *"Phase 1'de yok"*. `§2.1.1`'in bölüm
> hiyerarşisi de aynı yöne işaret ediyor: faz kapsamı `§10`'a, güvenlik kapsamı `§7.7`'ye
> aittir; `§2.1.4` bir **teknoloji özeti**dir.
>
> Karar `§2.4` gereği ürün sahibinin, ama **yeni BRD'de `§2.1.4` düzeltilmeden
> taşınmamalı** — bugünkü hâliyle bir okuyucuya *"SSO gün 1'de var"* dedirtir.

---

## 3. ✅ Ledger kapsam sınırı — **ikinci bağımsız tanık**

`SYSTEM_INVARIANTS §3`, `INV-L-*` ailesinin üst sınırını `Section_03 §3.6`'nın cümlesine
bağlıyor (*"not an accounting system"*, kaydeden `0023 §2.7`).

`§2.1.2` **aynı sınırı bağımsız olarak** çiziyor:

> *"**Scope Clarity:** Ledger entries are **not accounting postings** but **audit-grade**
> promotional spend records"*

Ölçüm: `grep -rn "accounting posting" docs/brd/` → **yalnız `Section_02:149`**. Yani bu
ifade `§3.6`'nın tekrarı değil, **ikinci bir yerde ve farklı sözcüklerle** kurulmuş bir sınır.

📌 *"Audit-grade"* nitelemesi `§3.6`'nınkinden **daha güçlü**: ledger muhasebe değildir ama
**denetim düzeyinde** olmak zorundadır. `INV-L-*` ailesinin gerekçesine eklenmeli.

**Ve şema ifadesi:** *"Single `ledger_entries` table with `source_type` (**AGREEMENT | PLAN**)"*
— tek tablo, mod ayrımı bir kolonda. ([[T-188]]'in *"ledger satırları zarfa bağlı değil"*
bulgusuyla aynı tabloyu konu ediyor; **bu turda kod ölçülmedi**.)

---

## 4. Veri modeli ifadeleri — üçü yeni, biri açık soruyu besliyor

| ifade | not |
|---|---|
| **`GU → FU → SKU`** ürün hiyerarşisi | `Section_06 §6.1`'de de var (`0059`); `GU` *"optional"* |
| **`CPL → Customer → Outlet`** müşteri hiyerarşisi | ⚠️ `Outlet` seviyesi — ölçüm: `§3.1:310` *"Customer hierarchy (**optional** outlet detail)"*, `§3.1:125` *"Individual outlet or sub-customer"*. **Zorunlu bir seviye değil** |
| **Bütçe yapısı: `Channel → Category → Period`** | `0053 §2`'nin zarf şekliyle ve `§11.2 D4` azaltmasıyla (`0054 §4`) **örtüşüyor** — üçüncü tanık |
| **`STA ≤30 gün` / `LTA >30 gün`** | `OPEN_DECISIONS → 0020 #8`'in **ikinci tanığı** (`§1.3` ile birlikte üçüncü). Soru *"ayrım doğru mu"* değil, *"kodda karşılığı var mı"* — bu turda ölçülmedi |

---

## 5. §2.2 — mod seçimi: karar **kullanıcıya bırakılmıyor**, kapsam politikasına bağlanıyor

`0037`'nin `§2.6`'da ölçtüğü üç katmanlı çözümleyici burada **senaryoyla** gösteriliyor:

```
1) scope_policies sorgulanır  → execution_model (ACTUALS_FIRST | PLANNING_FIRST | HYBRID)
2) kullanıcı yetenekleri      → plans.create / agreements.create
3) yalnız HYBRID ise          → modal ile kullanıcıya sorulur
```

Ve **karşıt senaryo** aynı netlikte: `execution_model = ACTUALS_FIRST` olan bir kanalda
**modal gösterilmez**, agreement formu doğrudan açılır (*"Zero confusion, faster workflow"*).

> **Best Practice (kaynağın kendi cümlesi):** *"Use ACTUALS_FIRST or PLANNING_FIRST
> (**deterministic**) wherever possible. Reserve **HYBRID** for contexts where both
> workflows are genuinely needed."*

📌 Bu, `OPEN_DECISIONS → 0019 #1`'in sorusunu **netleştiriyor**: soru *"mod bağlamla mı
çözülür"* değil (cevap açıkça evet), **"HYBRID varsayılan mı, istisna mı"**. Kaynak
**istisna** diyor.

⚠️ Ve `0019 #1`'in bugünkü hâli zaten *"soru değişti: 'doğru mu' değil, 'tablo neden yok'"*
diyor (`0021:108`). Bu tur o çerçeveyi **korur ve bir ölçüt ekler**: `scope_policies`
yazıldığında **varsayılan satırın `HYBRID` olmaması** kaynağa uygun olandır.

### §2.2.1 — karar faktörleri tablosu yeni BRD'ye aynen girebilir

Sekiz eksen (*Time Horizon · Planning Window · **Baseline Availability** · Decision Driver ·
Volume Predictability · **Approval Basis** · Execution Trigger · KPI Focus*) ve bir karar
ağacı. Kanal **değil**, sürecin karakteri belirleyici:

> *"The choice … is **not** about channel type (Traditional vs. NKA) but about the
> **characteristics of the promotion process itself**."*

Bu cümle `§2.2.2`'nin kanal-bazlı senaryo tablosuyla **çelişmiyor**: senaryolar örnek,
karar ekseni süreç.

---

## 6. §2.1.4 Teknoloji temeli — **kaynak bir yığın öneriyor, biz sapıyoruz**

| kaynak | bizde (`CLAUDE.md §1`'den) |
|---|---|
| Backend: **Express.js / Fastify** | **NestJS 10** |
| UI: **Material-UI / Ant Design** | **Tailwind + shadcn/ui** |
| State: Redux Toolkit / React Query | Redux Toolkit + TanStack Query ✅ |
| PostgreSQL **14+** | PostgreSQL **16** ✅ (üstü) |
| React 18+ · JWT · RESTful | ✅ |
| **Materialized views** (raporlama) | `0054 §5`: **yok** (yalnız `v_budget_summary`) |
| *"~20 core tables (10 shared, 5 actuals, 5 planning)"* | bu turda **sayılmadı** |

> İki sapma (**NestJS**, **shadcn**) gerçek ve **hiçbir yerde kayıtlı değil**. Bunlar
> `§2.1.4`'ün kendi çerçevesine göre *"implementation detail"* sayılabilir — ama o çerçeveyi
> `§2.1.4` **kendisi kurmuyor**; `§7`'nin girişi kuruyor (*"does NOT prescribe specific
> IAM vendors…"*).
>
> **Yeni BRD kararı:** `§2.1.4` ya güncellenmeli ya da *"gösterge niteliğinde"* diye
> işaretlenmeli. Bugünkü hâliyle bir mimari şartname gibi okunuyor.

📌 **`materialized views` üçüncü kez geçti:** `§10.3` (risk azaltması, `0054`) · `§8.3`
(drill-down performans şartı, `0062`) · `§2.1.4` (teknoloji temeli). Üç bağımsız yer aynı
mekanizmayı istiyor ve `0054`'e göre **yok** → [[T-157]] bağlamı güçleniyor.

---

## 7. ⚠️ Bu turda bir ölçüm hatası **yakalandı** (kayda geçiyor)

`source_type` taraması ilk kez `| head -6` ile koşuldu ve çıktının **altısı da**
`04_Reviews`'tan geldi. Bu hâliyle okunsaydı iddia şu olurdu: *"`source_type` yalnız
kopya dosyada var, Main BRD'de yok."*

**Dosya bazlı sayım gerçeği gösterdi:**

```
Section_02:1 · Section_03:6 · Section_04:4 · Section_05:1 · 04_Reviews:7
```

> `head`, çıktıyı **dosya sırasına göre** kesti; kesilen yer tam da iddianın dayanağıydı.
> `CLAUDE.md §2.7`'nin boru hattı ailesinin bir üyesi daha: **filtre doğru, pencere yanlış.**
> Kural: bir **yokluk** iddiası kurarken `head` kullanma — **sayım** kullan (`grep -rc`).

---

## 8. Bu turun sınırları (ZORUNLU)

- **Kod tarafı ölçülmedi.** §1'in enum hipotezi, §3'ün T-188 bağlantısı, §6'nın sapma
  tablosu: hepsi `0054`/`0056`/`CLAUDE.md` **kayıtlarından** alıntı.
- **`§2.3`–`§2.5` okunmadı** — turu 41'e bırakıldı (modlar derin karşılaştırma ·
  organizasyonel desenler · ölçeklenebilirlik/genişletilebilirlik).
- `§2.2.1`'in karar ağacının **tamamı** (ASCII, 300 satır civarı) satır satır izlenmedi;
  faktör tablosu ve iki senaryo okundu.
- *"~20 core tables"* iddiası ne kaynakta doğrulandı ne bizde sayıldı.
