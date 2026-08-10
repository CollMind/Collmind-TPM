# 0054 — BRD okuma turu **36 (son)**: §10.3/§10.4 · §11.2 · Addendum H5.2–5.4

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur. **🟡 kuyruğu bu turla bitti.**
- **Kaynak:** `Section_10` §10.3 (376–437) + §10.4 (438–501) · `Section_11` §11.2 (132–229) ·
  `02_Addendum` H5.2 (840–909) · H5.3 (910–958) · H5.4 (959–1014)
- **Ölçüm ortamı:** meta `ae9fb68` · backend `99ee9e6` · dev DB `main` şeması

---

## 1. ⛔ En büyük bulgu: **formül doğrulaması hiçbir yoldan çalışmıyor**

Addendum `H5.2 Add Formula Validation on Save` üç adım şart koşuyor: **sözdizimi → örnek
veriyle deneme çalıştırma (`isFinite` kontrolü) → audit'li kayıt**.

**Ölçüm:**

| yol | doğrulama çağrılıyor mu |
|---|---|
| `KpiService.create()` | ❌ — yalnız `extractDependencies`, sonra `save` |
| `KpiService.update()` | ❌ — yalnız `extractDependencies`, sonra `updateVersioned` |
| `POST /kpis/validate-formula` (uç **var**) | — |
| frontend `kpiEndpoints.validateFormula` (sarmalayıcı **var**) | ❌ **sıfır çağıran** |

```
collmind.frontend/src: "validateFormula" → yalnız api/endpoints/kpi.endpoints.ts
                                            (tanım), başka hiçbir yerde yok
```

> ### Doğrulama yazılmış, uç açılmış, istemci sarmalayıcısı bile yazılmış — ve **hiçbiri
> çağrılmıyor**.
>
> Bir admin bugün **sözdizimi bozuk** ya da **sonsuz/NaN üreten** bir formülü doğrudan
> kaydedebilir. Kusur çalışma zamanında, hesaplama sırasında ortaya çıkar.

Bu, [[T-052]] ailesinin bir üyesi daha — ve **en pahalı yerdeki**: Addendum H5 paketin
**ZORUNLU** bölümü, ve konusu **formül motoru güvenliği**.

→ [[T-160]] ölçümle güncellendi.

⚠️ Ve `formula-parser.service.ts:255`'te `isFinite` kontrolü **var** — yani mekanizma
çalışma zamanında koruyor. Eksik olan **kaydetme zamanı**: kötü formül kabul ediliyor,
sonra her hesaplamada `null` üretiyor. `§7.1`'in *"doğrulamaya girdi ulaşmıyor"* dersinin
tersi: burada girdi ulaşıyor, **doğrulama çağrılmıyor**.

---

## 2. 📌 H5.3 — formül değişikliği audit'i **yok**

> `H5.3`: audit olayı `KPI_FORMULA_CHANGED`, alanları `old_formula` / `new_formula`

```
KPI_FORMULA_CHANGED | formula.*chang  → backend'de 0 (yalnız iki kod yorumu)
main.admin_audit_logs distinct action_type → APPROVE · SALES_ACTUALS_UPLOAD · SUBMIT · UPDATE
```

> Dört tür, ve formül değişikliği bunların hiçbiri değil. → [[T-168]]

Ve bu, `§9.5`'in uyum çerçevesiyle birleşiyor (turu 32): *"All **configuration changes**
(KPIs, policies)"* audit kapsamında sayılıyor.

---

## 3. 🔴 H5.4 — kaynak **istemci tarafı** çalıştırma istiyor; biz sunucuda çalıştırıyoruz

> `H5.4`: *"**No server-side eval() or new Function()**"* — formüller tarayıcıda koşmalı.

Bizde `formula-parser.service.ts` **sunucuda** `new Function(...)` çalıştırıyor (karakter
beyaz listesi + `"use strict"` ile daraltılmış).

### ⚠️ Ama kaynağın modeli burada **daha zayıf** görünüyor — ve kendi analizi bunu saymıyor

`H5.4`'ün akışı: *"Step 3: Calculate KPIs **in browser** → Step 4: **Send results to
server** (for save)"*.

> Yani sunucu, **tarayıcının hesapladığı finansal sayıyı** kaydediyor. Bir kullanıcı
> `savePlanKPIs`'a istediği ROI'yi gönderebilir; sunucunun doğrulayacak bir şeyi yok.
>
> `H5.4`'ün **Trade-off** listesi üç madde sayıyor: güvenlik ✅, **CPU** ⚠️, **çevrimdışı** ⚠️.
> **Sonuç bütünlüğü listede yok.**

Bu, `CLAUDE.md §2.1.2`'nin ölçülmüş beşinci vakası: **bağlayıcı kaynak bir girdidir, kanıt
değil.** Bizim sapmamız (sunucu tarafı, dar beyaz listeli) bir finansal sistem için
**muhtemelen daha güçlü**.

⚠️ **Ama "muhtemelen" bir ölçüm değil.** Karar ürün sahibinin; ölçülen şey:
(a) sapma gerçek ve **hiçbir yerde yazılı değil**, (b) kaynağın gerekçesi eksik.
→ [[T-160]]'a bir karar maddesi olarak eklendi ([[T-164]] koruma listesine aday).

---

## 4. ✅ §11.2 — [[T-148]] ve [[T-153]] **yeniden çerçeveleniyor**

İki bağımlılık maddesi, bugünkü durumumuzu **kaynağın kendi azaltma planı** olarak tarif
ediyor:

| bağımlılık | *"Impact if Not Met"* | **Mitigation** | bizdeki durum |
|---|---|---|---|
| **D5** Approval Policy Definition | *"All approvals default to **manual routing**"* | *"Start with **simple 2-level sequential approval for all**"* | ✅ tam olarak bu ([[T-153]]) |
| **D10** Tactic Applicability Rules | *"Users see **irrelevant tactics**"* | *"Start with **'all tactics available to all channels'** (permissive)"* | ✅ tam olarak bu ([[T-148]]) |

> **Yani politika tablolarının yokluğu, kaynağın öngördüğü *"politikalar henüz
> tanımlanmadı"* durumunun ta kendisi.** Bir unutma değil, adı konmuş bir başlangıç hâli.
>
> Turu 30'un CANDIDATE-004 yeniden çerçevelemesiyle aynı sınıf: **statü değişmiyor,
> çerçeve değişiyor.**

⚠️ **İki sınır:**
1. Kaynak bedeli de sayıyor (*"irrelevant tactics"*, *"workflow inefficiency"*) — yani
   azaltma **kalıcı** değil, geçici.
2. **[[T-153]]'ün asıl kusuru bundan etkilenmiyor:** `approval_policy_id` **var olmayan bir
   tabloya** işaret ediyor. Politikaların tanımlanmamış olması, sarkan bir FK'yi meşru
   kılmaz.

📌 D4'ün azaltması (*"simplified budget structure (**Channel × Category only**)"*) da
bugünkü zarf şeklimizle örtüşüyor (`0053 §2`).

---

## 5. 📌 §10.3 — dördüncü tanık ve iki uygulanmamış azaltma

**Risk 1 azaltması:** *"Accept lower coverage (**80% instead of 95%**) for pilot"* —
turu 16-17'nin `%95 hedef / %80 azaltma` çözümünün **dördüncü** bağımsız tanığı
(`§11.3 R3` · Glossary · `§10.1` · burada).

**Risk 2 (KPI performansı) azaltmaları — ikisi de yok:**

```
materialized view (main şeması)  → YOK   (yalnız normal view: v_budget_summary)
plan başına SKU limiti           → 0 dosya  (maxSku|sku limit|100 sku)
```

> ⚠️ Bunlar **kusur değil**: azaltmalar bir risk **gerçekleşirse** uygulanır, ve risk
> bugün ölçülemez (deploy edilmiş ortam yok — [[T-157]]). Kayda geçiyor.

---

## 6. ✅ §10.4 *"Will Not Build"* — ölçülen ihlal **yok**

GL/AP/AR · tedarik zinciri · CRM · serbest SQL/ETL/ML · pazarlama otomasyonu — hiçbirinde
bir uygulama yok.

📌 Tek yakın temas: `cpls` üzerinde `contact_person` · `contact_email` · `contact_phone` ·
`customer_tier` · `is_vip` · `annual_revenue`. Bunlar **içe aktarılabiliyor ve
filtrelenebiliyor** ama **hiçbiri dolu değil** (`is_vip` 0/29, diğerleri 0).

> **Bunu `§10.4` ihlali saymıyorum:** öznitelikli bir müşteri master'ı tutmak CRM inşa
> etmek değildir. Gerçek soru sahiplik sorusudur (`§6.5`) ve o zaten [[T-175]].
> **Task açmıyorum** — ölçülen bir kusur yok (`§7.1`: fazla ölçüm iş üretir).

---

## 7. [[T-143]] durumu

**🔴 ve 🟡 kuyruklarının ikisi de bitti.** Bitiş ölçütlerinden **beşte dördü** tamam;
kalan tek madde **TTM ölçümü** (`0014 §7`'de de açık bırakılmıştı) — BRD okuması değil,
ayrı bir iş.

Turu 29 envanterinde ⚪ işaretlenen ~8.150 satır **gerekçeleriyle atlandı** ve gerekçeler
`0047 §2`'de yazılı.
