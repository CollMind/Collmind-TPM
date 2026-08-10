# 0039 — BRD okuma turu **21**: §7.2 CBAC · §7.3 Approval Authority

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_07_Security_Roles.md` §7.2 (176–252) · §7.3'ün başı (254–295)
- **Ölçüm ortamı:** meta `9cd6b8f` · backend `99ee9e6` · dev DB `main`

---

## 1. ✅ `INV-T-002` — **kaynakta doğrulandı** (altıncı yakınsama)

`§7.2` Permission Check Logic, **Check 3**:

```typescript
if (action.startsWith('approve') && plan.created_by === userId) {
  return { allowed: false, reason: 'Cannot approve own submission' };
}
```

`SYSTEM_INVARIANTS` **`INV-T-002`**: *"A user may not approve a request they submitted."* —
**Status: HOLDS · Guard: TEST ✅**

> **Kaynak, invariantı birebir yazıyor.** Ve bizde hem geçerli hem test'e bağlı.
> H2/H1/H3/§5.3-edge-cases'ten sonra **altıncı** habersiz yakınsama.

---

## 2. Yetki modeli — **scope katmanı VAR, capability katmanı YOK**

### 2.1 BRD iki katman tanımlıyor

| katman | BRD | bizde (ölçüldü) |
|---|---|---|
| **Capability** — *"CBAC rather than screen-based permissions … action level, not UI level"* | **20 yetenek** (`plan.create`, `agreement.approve_L2`, `budget.override`, `policy.configure`, `kpi.configure`, `audit.view` …) | ❌ **yok** — rol enum'u ([[T-165]]) |
| **Scope** — *"a filter that limits which records a user can access"* | `{ channels, regions, cpls }` | ✅ **`user_scopes`** var: `cpl_id`, **`category_id`**, `channel_id` |

> **[[T-165]]'in resmi yarıya indi:** yetki modelinin **kapsam** yarısı bizde var ve
> yapısı benziyor. Eksik olan **yetenek** yarısı.

⚠️ **Bir fark, iddia değil:** BRD `regions` sayıyor, bizde **`category_id`** var. İkisi
farklı boyut. `§7.1 Role Model` okunmadan *"eksik"* ya da *"fazla"* denemez — `Section_03`
`§3.1`'in Organizational Dimensions bloğu da okunmadı.

### 2.2 📌 İki yetenek doğrudan açık task'larımıza denk düşüyor

| yetenek | BRD'de kimde | bizdeki karşılığı |
|---|---|---|
| **`policy.configure`** — *"Define approval policies"* | Admin | ⚠️ yetenek tanımlı, **tablo yok** ([[T-153]]) |
| **`budget.override`** — *"Override budget warnings"* | Finance Approver | ⚠️ **D-01'in Finance override'ı bir yetenek olarak** — ama kapı yok ([[T-144]]) |

> Yani BRD, bizim *"mekanizma yok"* dediğimiz iki şey için **yetki adını** zaten koymuş.
> Bu, T-153/T-144'ün *"adı konmuş, mekanizması yazılmamış"* ailesine bir üye daha ekliyor —
> **bu sefer yetki katmanında**.

---

## 3. §7.3 — `auto_reject` ve koşullu yönlendirme **yapı olarak** tanımlı

```jsonc
"approval_levels": [
  { "order": 1, "role": "APPROVER_CATEGORY_MANAGER", "when": {"amount_gte": 0} },
  { "order": 2, "role": "APPROVER_FINANCE",
    "when": { "OR": [ {"amount_gte": 50000}, {"gp_roi_pct_lt": 15} ] } }
],
"auto_reject_conditions": [
  { "condition": {"gp_roi_pct_lt": 5}, "message": "ROI too low (<5%), plan auto-rejected" }
]
```

### 📌 [[T-159]]'un dördüncü vakası — muhtemelen o da uzlaşıyor

Dördüncü vaka şuydu: Glossary *"Auto-Reject if GP ROI <5%"* ↔ `§5.7` *"Conditional routing
(if ROI <15%, route to CFO) → **Phase 2**"*.

**Uzlaştıran okuma adayı** (turu 17'nin dersi uygulanarak arandı):

| kaynak | ne diyor |
|---|---|
| `§7.3` | **hedef yapı** — `when` koşulları, `OR`, `auto_reject_conditions` |
| `§3.4` | *"**Phase 1 Guardrail:** policies intentionally constrained to a **small, opinionated set**. **Complex multi-conditional** policies … introduced progressively"* |
| `§5.7` | ertelenen: *"**Conditional routing**"* — yani **çok koşullu** yönlendirme |

> **Okuma:** `§7.3` hedef yapıyı gösteriyor; Phase 1'de yalnız **basit eşik** (`amount_gte`)
> kullanılıyor; **`OR`'lu çok koşullu yönlendirme** Phase 2'ye erteleniyor.
>
> ⚠️ **Bu bir ÇIKARIMDIR.** `§7.3`'ün kalanı (295–374) okunmadı ve orada Phase 1/2 ayrımı
> açıkça yazılı olabilir. Vakayı **kapatmıyorum**, *"muhtemelen uzlaşıyor"* diye
> işaretliyorum.

### ⚠️ Ve `gp_roi_pct_lt` [[T-163]]'ü yine gündeme getiriyor

`auto_reject` ve seviye-2 yönlendirmesi **ROI değerine** bakıyor. T-163'ün paydası farklı
olduğu için **hangi planların otomatik reddedileceği de farklı** olur.

Turu 15'te *"auto-reject Phase 1'de yok"* diye T-163'ün bir bacağını düşürmüştüm. **§7.3
onu yapı olarak geri getiriyor** — ama Phase 1'de etkin olup olmadığı hâlâ açık.
**T-163'ün ağırlığı değişmiyor**, argüman durumu *"belirsiz"*.

---

## 4. 📌 Dördüncü BRD-içi adlandırma tutarsızlığı

```
§2.6  Permission Model Integration :  'plans.create'   (çoğul)
§7.2  Core Capabilities            :  'plan.create'    (tekil)
Glossary Mode maddesi              :  'plan.create'    (tekil)
```

İki-bir. Önemsiz görünüyor ama **yetenek kodları dize eşleşmesiyle çalışır** — bir
uygulama hangisini seçerse diğeri sessizce başarısız olur.

⚠️ Kayda geçer; [[T-165]]'e madde olarak eklendi.

---

## 5. Okunmayan

`§7.1` Role Model (22–176) · `§7.3`'ün kalanı (295–374) · `§7.4` Audit & Traceability ·
**`§7.5` Data Security & Isolation** · `§7.6` Session · `§7.7` Phase 1 Security Scope.

**Section_07: ~120 / 601 (%20).**

---

## 6. Sonraki tur

1. **`§7.5` Data Security & Isolation** — `INV-T-003` bugün **VIOLATED**, D-11 (RLS);
   kaynağın ne dediği **hiç bilinmiyor**
2. `§7.3`'ün kalanı + `§7.1` Role Model — [[T-165]] ve [[T-153]]'ün kapanışı
3. `§7.4` Audit — `INV-*` audit invariantları
4. `04_Reviews` ([[T-161]] · [[T-163]]'ün son adayı)
