# 0032 — BRD okuma turu **14**: §5.3 Calculation Engine Logic

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md` §5.3 (1199–1355, tamamı)
- **Ölçüm ortamı:** meta `bfe0afd` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 1. 🟢 **Bizim implementasyonumuz kaynaktan DAHA KATI** — ve fark maddi

BRD **Step 2**, bağımlılık değerlerini yerine koyarken:

```typescript
for (const depCode of kpi.depends_on_kpis) {
  const value = context.get(depCode) || 0;        // ← SESSİZ SIFIR
  formula = formula.replaceAll(depCode, value.toString());
}
```

Bizim `formula-parser.service.ts`:

```typescript
for (const dep of dependencies) {
  if (context[dep] === undefined || context[dep] === null) {
    return null;                                   // ← EKSİK BAĞIMLILIK → NULL
  }
}
…
const value = Number(context[dep]);
if (isNaN(value)) return null;                     // ← NaN de null
```

### Fark neden maddi

BRD'nin `|| 0`'ı **eksik bir bağımlılığı sıfır sayar**. Bugünkü veriyle somut:

`skus.cogs` **4/170 dolu** (`0016 §7.4`). BRD'nin pseudo-kodu uygulansaydı:

```
COGS eksik → 0
PLANNED_COGS = PLAN_VOL * 0 = 0
PLANNED_GP   = PLANNED_TO - 0 = PLANNED_TO        ← maliyetsiz kâr
GP_ROI_PCT   → şişirilmiş, ve RAG YEŞİL
```

> **Bugün 166 SKU'da ROI, maliyet sıfır sanılarak hesaplanırdı.** Bizim `null` propagasyonu
> bunu engelliyor — ve [[T-135]]'in bulduğu kusur (`gpRoi: plan.overallRoi || 0`, raporlama
> katmanı) tam olarak **BRD'nin bu satırının bir kopyası**.

⚠️ **Ve BRD kendi içinde tutarsız:** aynı bölümün 40 satır aşağısındaki *Edge Case Handling*
`IF(BASE_VOL = 0, **NULL**, …)` diyor. Yani BRD **null propagasyonunu formül seviyesinde
istiyor**, ama motor pseudo-kodunda `|| 0` yazıyor.

**Kaynağın pseudo-kodu §2.5'i ihlal ediyor; bizim kodumuz etmiyor.** Bu, kaynak denetiminin
tersine işlediği ilk vaka.

→ [[T-164]] (kayda geçsin: bir *"BRD'ye uyum"* turu bu satırı geri getirmemeli)

---

## 2. ✅ `formula_type` envanteri — H5'in en kötü vektörü **bizde yok**

BRD beş `formula_type` tanımlıyor: `user_input` · `external` · `expression` ·
`conditional` · **`javascript`**.

Sonuncusu:

```typescript
case 'javascript':
  const fn = new Function('context', kpi.formula_text);
  return fn(context);                               // ← keyfi JS
```

**Ölçüm** (`main.kpis`, şema-nitelendirilmiş):

```
expression = 16   ·   external = 9   ·   user_input = 2
```

> **`javascript` tipi bizde YOK.** H5'in tehdit modelinin (*"admin hesabı ele geçirilirse
> `fetch(...)` + `while(true)`"*) dayandığı tip hiç kullanılmıyor — ve `safeEval`'in karakter
> beyaz listesi zaten onu reddederdi.

### ⚠️ Ama `conditional` de yok — ve bu bir boşluk

BRD'nin **edge-case çözümü** `conditional` formüllerle ifade ediliyor
(`IF(BASE_VOL = 0, NULL, …)`), ve `RAG_STATUS` da öyle.

**Bizde sıfır `conditional` KPI var.** Bölme-sıfır'ı **motor** hallediyor
(`safeEval`'in `/\/\s*0/` guard'ı → `null`), formül değil.

| | BRD | bizde |
|---|---|---|
| bölme-sıfır koruması | **her formülde ayrı** (`IF(... = 0, NULL, ...)`) | **motorda tek yerde** |
| unutulabilir mi | ✅ evet — bir formül yazarı `IF`'i atlarsa koruma yok | ❌ hayır |

> **Bizimki daha sağlam** — koruma formül yazarının disiplinine bağlı değil. Ama sonuç:
> BRD'nin `conditional` mekanizması bizde **kullanılmıyor**, ve [[T-160]]'ın
> *"`parseConditional` BRD biçimini kabul ediyor mu"* sorusu **bugün konusuz** (kabul etse
> de etmese de kimse kullanmıyor).

---

## 3. ⚠️ `topologicalSort` bir **yanlış adlandırma** — ve biz aynısını yapıyoruz

BRD Step 1 bir bağımlılık grafiği kuruyor (`buildDependencyGraph`), sonra:

```typescript
function topologicalSort(kpis: KPI[]): KPI[] {
  // Sort by calculation_order (already stored in database)
  return kpis.sort((a, b) => a.calculation_order - b.calculation_order);
}
```

**Topolojik sıralama değil, sayısal sıralama.** Ve `buildDependencyGraph`'ın çıktısı
**hiçbir yerde kullanılmıyor.**

Bizde: `kpi-engine.service.ts` → `order: { calculationOrder: 'ASC' }`. **Aynı yaklaşım.**

> Ortak risk: `calculation_order` gerçek bağımlılık sırasıyla **çelişirse** hiçbir şey
> yakalamaz — grafik kuruluyor ama **doğrulama için kullanılmıyor**.
>
> Glossary bunu *"40+ KPIs calculated in **dependency order (topological sort)**"* diye
> anlatıyor; **gerçekte sıra elle atanmış bir tamsayı.**

⚠️ Bizde bu bugün zararsız olabilir (`kpi.seed.ts` sıraları elle veriyor ve
`dependsOnKpis` da yazılı) — ama **doğrulanmıyor**. → [[T-164]]

---

## 4. 📌 FU toplama — üç yöntem, ve iki nokta kayda değer

BRD Step 4: `sum` · `avg` · `weighted_avg` (ağırlık: `PLANNED_VOL`).

**(a) `weighted_avg`'de bölme-sıfır guard'ı YOK:**

```typescript
aggregatedValue = numerator / denominator;   // tüm PLANNED_VOL = 0 → NaN
```

Aynı belgenin *Edge Case Handling*'i bunu tam olarak yasaklıyor. **BRD'nin kendi
pseudo-kodu, kendi kuralını üçüncü kez ihlal ediyor** (§1'in `|| 0`'ı, burada eksik guard).

**(b) `LIST_PRICE`'ın FU toplaması `sum`:** BRD'nin KPI 1 tanımında
*"`sum` — When aggregating to FU: **sum all SKU prices**"*.

> Fiyatları toplamak semantik olarak tuhaf — ve [[T-133]]'ün bulduğu frontend kusurunun
> (*"Toplam Hacim" aslında birim fiyat toplamı*) **kaynaktaki yankısı**.
>
> ⚠️ **İkisi aynı şey DEĞİL:** T-133'te bir **hacim** alanı boş olduğu için fiyata düşülüyor
> (sessiz ikame). Burada BRD bilinçli olarak fiyatları topluyor. Ama T-133'ü değerlendirirken
> bu satır bilinmelidir — *"fiyat toplamak her zaman hatadır"* denemez.

**(c) FU seviyesinde `GP_ROI_PCT` yeniden hesaplanıyor**, SKU ROI'lerinin ortalaması
**alınmıyor** (Step 4 sonu: *"Calculate FU-specific KPIs (e.g., GP_ROI_PCT)"* — toplanmış
context üzerinden). Doğru yaklaşım; bizdeki karşılığı **ölçülmedi**.

---

## 5. [[T-163]] için bağlam — **bulunamadı**

Bu bölüm `GP_ROI_PCT`'nin paydasına dair **hiçbir ek bilgi vermiyor**. Step 3/4 formülü
`executeFormula`'ya devrediyor; formül metni `§5.3` KPI kütüphanesinde ve orada
`(INCR_GP / TOTAL_PLANNED_SPEND) * 100`.

> **T-163'ün sapması bu turla açıklanmadı.** Sonraki aday: `§5.4 ROI Simulation` ve
> `04_Reviews`.

---

## 6. Okunmayan

`§5.4` ROI Simulation ve sonrası (~640 satır) · `§5.2`'nin grid mimarisi (246–437) ·
KPI kütüphanesinin açıklama metinleri.

**Section_05: ~430 / 2013 (%21).**

---

## 7. Sonraki tur

1. `§5.4` ROI Simulation & What-If — [[T-163]]'ün ikinci adayı
2. `Section_02` (1026) · `Section_10/11`
3. `04_Reviews` (5249) — [[T-161]]
