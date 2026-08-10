# 0035 — BRD okuma turu **17**: §11.1 Assumptions · §11.3 Risks (P1)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_11_Assumptions_Risks.md` §11.1 Technical+Data
  (64–131) · §11.3 P1 riskleri (234–302)
- **Ölçüm ortamı:** meta `70b388c` · backend `99ee9e6` · dev DB `main`

---

## 1. ✅ **%80 ↔ %95 çelişkisi ÇÖZÜLDÜ** — ve iki turumu birden düzeltiyor

`§11.3 R3: Baseline Data Unavailable`, **Mitigation** maddesi:

```
- Start data extraction in Phase 1 (parallel)
- Accept lower granularity (monthly instead of weekly)
- Accept lower coverage (80% instead of 95% SKUs)      ← ⚠️
```

> **%95 KAPIDIR; %80, R3 gerçekleşirse kabul edilen AZALTMADIR.**

Bu, `§10.2` Gate 2 (%95) ile Addendum H4 (MVB-2 %80) arasındaki gerilimi **çelişki
olmaktan çıkarıyor**: biri hedef, diğeri belgelenmiş geri çekilme.

### İki turumun da yarısı yanlıştı

| tur | ne demiştim | doğrusu |
|---|---|---|
| **10** (`0028`) | *"%95 tam kapasite hedefi, **fırlatma kapısı %80**"* | %80 bir **kapı değil**, bir **mitigation** |
| **16** (`0034`) | *"Bu bir **çelişki**, çözülmüş bir soru değil"* | Çelişki değil — **hedef + contingency** çifti |

> Turu 10 tek kaynağa (Addendum) bakıp genelledi. Turu 16 iki kaynağı görüp **çelişki ilan
> etti** — ama üçüncüsünü aramadı. **İkisi de erken sonuçtu**, ve ikincisi birincinin
> düzeltmesi olduğu için daha sinsiydi: *"düzelttim"* duygusu aramayı durdurdu.

⚠️ Ders, §2.1.1'in haritasının bir uzantısı: **bir çelişki ilan etmeden önce, uzlaştıran
üçüncü belgeyi ara.** Faz/risk kararları `§10`/`§11`'de; ve granülarite için de aynı satır
cevap veriyor (*"monthly instead of weekly"*).

→ [[T-159]]'un **beşinci vakası düşüyor**; dört vaka kalıyor.
→ [[T-024]] **ikinci kez** düzeltildi.

---

## 2. 🔴 **A12 bugün ihlal** — ve BRD'nin "Risk if False"u tam olarak bulduğumuz şey

`§11.1 A12: COGS Data Accuracy`:

> - **Assumption:** *"COGS per SKU is accurate and **refreshed monthly**"*
> - **Why Critical:** *"GP ROI calculation depends on COGS; inaccurate COGS = wrong ROI"*
> - **Risk if False:** *"**Plans approved based on incorrect profitability**, Finance loses
>   confidence"*

**Ölçüm** (`0016 §7.4`): `skus.cogs` **4 / 170 dolu**.

> **Varsayım *"doğru ve aylık tazelenmiş"* diyor; gerçek **%97,6'sı boş**.**

Ve bu, [[T-164]]'ün senaryosunun **kaynaktaki karşılığı**: BRD'nin `|| 0` pseudo-kodu
uygulansaydı eksik COGS sıfır sayılır, kâr maliyetsiz görünür, ve *"plans approved based on
incorrect profitability"* aynen gerçekleşirdi.

⚠️ **Bizim `null` propagasyonumuz bunu engelliyor** — ama sonuç *"ROI hesaplanamıyor"*
oluyor, ve [[T-135]] o `null`'ın raporda `0` olarak gösterildiğini buldu. **Yani A12'nin
riski bugün başka bir yüzden gerçekleşiyor:** ROI yanlış değil, **yanlış görünüyor**.

---

## 3. 📌 R2 gerçekleşmiş durumda

`§11.3 R2: Data Quality Issues` — **Probability: High (60%)**:

> *"Master data (customers, products, **COGS**) contains errors, duplicates, stale values"*

Bugüne kadarki ölçümler bu riskin **gerçekleştiğini** gösteriyor:

| ölçüm | task |
|---|---|
| `skus.cogs` 4/170 | §2 |
| `mechanics.max_combined_discount_percentage` 6/6 NULL | [[T-137]] |
| `agreements.mechanic_value` 3/3 NULL | ADR 0007 A4 |
| `skus.default_base_volume` **hiç yok** (frontend hayalet alan bildiriyor) | [[T-133]] |

⚠️ R2'nin mitigation'ları arasında **"Data quality dashboard (admins can see error rates)"**
var — bizde **yok**. Ve *"Contingency: if error rate >10%, pause new user onboarding"* —
bugün ölçülen oran çok daha yüksek.

---

## 4. ✅ R4'ün contingency'si — **üçüncü kez aynı fallback**

`§11.3 R4: Performance Degradation`:

> *"**Contingency:** Reduce UI KPI count (**show 10 instead of 40**), async calculation"*

Aynı çözüm üç bağımsız yerde:

| yer | ifade |
|---|---|
| Addendum **H1 Option C** | *"Show only 10-12 'essential' KPIs … 11 KPIs only"* |
| `§5.3` KPI kütüphanesi girişi | *"only a **curated subset** … ~11 KPI columns"* |
| **`§11.3` R4 contingency** | *"show 10 instead of 40"* |

> **Fallback ana tasarıma zaten girmiş** (turu 13'te kaydedilmişti) — ve şimdi üçüncü
> kaynakla doğrulandı. [[T-157]]'nin *"fallback seçilmemiş"* endişesi bu madde için
> **konusuz**: seçilmiş ve uygulanmış.

---

## 5. 📌 Diğer varsayımlar — bizim ADR'lerimizle kesişim

| varsayım | bizdeki karşılığı |
|---|---|
| **A9** Baseline var (12 ay, Customer × SKU × Week) | [[T-024]]'ün konusu; **doğrulanmadı** |
| **A10** Master data %95+ doğru | [[T-133]] · R2 ile birlikte **ihlal** |
| **A11** Off-invoice verisi ERP'den çıkarılabilir | `0002`'nin Wella CSV'si bunu doğruluyor |
| **A8** Bulut sağlayıcı %99,9 uptime | ⛔ **konusuz — deploy edilmiş ortam yok** (CLAUDE.md §1) |
| **A5** ERP REST API'leri | ölçülmedi; entegrasyon Phase 3 |

⚠️ **A8 ilginç:** varsayım *"bulut %99,9 verir"* diyor ve `§10.2` Gate 1/2 uptime ölçüyor.
İkisi de **bir ortam varsayıyor**. [[T-157]]'nin *"faz kapısı zinciri ölçülemez"* bulgusunun
kaynak tarafındaki dayanağı bu.

---

## 6. Okunmayan

`§11.1` Organizational Assumptions (30–64) · `§11.2` Dependencies (132–230) · `§11.3`
P2/P3 riskleri (303–390) · `§11.4` Change Management · `§11.5` Risk Matrix · `§11.6`
Critical Success Factors.

**Section_11: ~140 / 465 (%30).**

---

## 7. Sonraki tur

1. `§11.2 Dependencies` + P2/P3 riskleri — kalan risk envanteri
2. `§10.1` faz tanımları (dört fazın içeriği) + `§10.3`
3. `Section_02` (1026) — ürün çerçevesi, hiç açılmadı
4. `04_Reviews` (5249) — [[T-161]]; [[T-163]]'ün son kaynak adayı
