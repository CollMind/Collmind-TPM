# 0061 — BRD okuma turu **38**: `Section_08 §8.1` — sekiz rapor

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_08_Reporting.md` **1–489** (Introduction + §8.1
  tamamı, ASCII görselleştirmeler dahil)
- **Ölçüm ortamı:** meta `87bbe3d`. ⚠️ **Submodule'ler checkout edilmemiş** — bu turda
  ürün-tarafı **canlı** ölçüm yok; ürünle karşılaştırmalar `0058`'in **kayıtlı** ölçümüne
  dayanır ve öyle işaretlenmiştir.

---

## 1. 🔴 En büyük bulgu: kaynak **T-177'nin cevabını aritmetiğiyle veriyor**

`Report 4: Plan Performance` metrik listesi:

> **Average GP ROI % (weighted by spend)**

Ve aynı raporun örnek çıktısı **üç sayıyı birlikte** basıyor:

```
Total Planned Spend:   2,450,000 TL
Total Incremental GP:    598,000 TL
Weighted Avg GP ROI:        24.4% 🟢
```

**Ölçüm:**

| okuma | hesap | sonuç |
|---|---|---|
| **Σ pay / Σ payda** (ratio-of-sums) | `598.000 / 2.450.000` | **%24,41 → 24.4** ✅ |
| ortalama-oran (average-of-ratios) | plan bazlı ROI'lerin aritmetik ortalaması | örnekte **verilmiyor**; 24.4 ile eşitlenmesi için özel bir dağılım gerekir |

> ### Kaynağın kendi sayısı **Σnum/Σden**'e oturuyor — yani [[T-177]] adım 2'nin
> (`5bc2787`, *"oran KPI'ları Σnum/Σden"*) uyguladığı okuma.
>
> *"Weighted by spend"* ifadesi ile `Σ iGP / Σ spend` **aynı şeydir**: ağırlık payda ise,
> ağırlıklı ortalama oranların toplamına indirgenir. Kaynak bunu hem **kelimeyle** hem
> **sayıyla** söylüyor.

⚠️ **Sınır:** bu, T-177'nin *"kısmi null bir plan ne gösterir"* sorusunu **cevaplamıyor**.
`Section_08` toplama şeklini veriyor, eksik girdinin nasıl ele alınacağını değil — o soru
(`OPEN_DECISIONS` → [[T-177]]) açık kalıyor. Ve `Section_05 §5.3 Edge Case Handling`'in
`NULL` kuralları toplama düzeyine **taşınmıyor**.

📌 `0059`'un envanteri bu bölümü ⚪'dan çıkarmasaydı, yürürlükteki bir P1 kararın **dördüncü
tanığı** okunmamış kalacaktı.

---

## 2. Plan RAG merdiveni — ikinci tanık, **sınırlar açık yazılmış**

```
Report 4 → RAG DISTRIBUTION:
  🟢 Green (ROI ≥20%)
  🟡 Amber (ROI 10-20%)
  🔴 Red   (ROI <10%)
```

`Section_05 §5.2 RAG Status Visualization` ile **birebir aynı** (Green ≥20 · Amber 10-20 ·
Red <10).

Ve burada sınır semantiği **belirsiz değil**: `≥20` ve `<10` operatörle yazılmış. Yani
`20` **Green**, `10` **Amber**. Bu, [[T-144]]'ün bütçe tarafında çözülmemiş bıraktığı
soruyla **aynı sınıf** ama **farklı merdiven** — ikisi karıştırılmamalı:

| merdiven | ölçtüğü | sınırlar | kaynak |
|---|---|---|---|
| **plan RAG** | GP ROI % | `≥20` / `10-20` / `<10` | `§5.2` · `§8.1 Report 4` |
| **bütçe RAG** | utilization % | `<80` / `80-95` / `>95` | Glossary · `§4.4` · `§8.1 Report 2` |

---

## 3. Sekiz rapor — envanter ve ürün karşılığı

⚠️ **Sağ sütun canlı ölçüm DEĞİL:** `0058`'in (2026-08-11) kayıtlı ekran envanterinden
alınmıştır; bu turda doğrulanmadı.

| # | Rapor | Birincil kullanıcı | `0058`'in kaydına göre ürün karşılığı |
|---|---|---|---|
| 1 | Trade Spend Summary | Finance, Executive | Sidebar *"Trade Spend Özeti"* — **href yok, tıklanamaz** |
| 2 | Budget Utilization | Finance, Budget Controller, CM | Sidebar *"Bütçe Kullanım Raporu"* — **href yok** · kısmen `/budget` |
| 3 | Agreement Status | Planner, Approver, Finance | Sidebar *"Anlaşma Durum Raporu"* — **href yok** · kısmen `/agreements` |
| 4 | Plan Performance | CM, Planner, Finance | Sidebar *"Plan Performans"* + *"ROI Dağılım Analizi"* — **ikisi de href yok** |
| 5 | **Planner Performance** | Sales Director, Trade Mkt Mgr | **menüde bile yok** |
| 6 | **Spend by Tactic** | Finance, CM | **menüde bile yok** |
| 7 | Variance Analysis | CM, Finance | kaynağın kendisi **Phase 2** diyor |
| 8 | Executive Dashboard | CEO/CFO/CMO/SD | kısmen `/dashboard` · `/finance` **çöküyor** ([[T-189]]) |

> `0058`'in *"5 rapor menü öğesinin hiçbirinde `href` yok, kod bunu bilerek
> `cursor-not-allowed` render ediyor"* bulgusu artık **kaynak tarafından da ölçülebilir**:
> BRD sekiz rapor tanımlıyor, menü beşini adlandırıyor, **sıfırı çalışıyor**.

---

## 4. Metrik tanımları — yeni BRD'ye aynen taşınacak dört formül

`Report 2` bütçe metriklerini **formülle** veriyor (paketin başka yerinde bu şekilde yok):

```
Available    = Allocated − Reserved − Committed − Consumed
Utilization% = (Reserved + Committed + Consumed) / Allocated
```

Ve **mod ayrımını** kimin doldurduğunu söylüyor:

| kova | kaynağı |
|---|---|
| **Reserved** | Actuals-First **agreement**'ları |
| **Committed** | Planning-First **plan**'ları |
| **Consumed** | gerçekleşmiş harcama |

📌 Bu, [[T-188]] (1231 ledger satırının %100'ünde `budget_envelope_id` NULL, bütçe panosu
*"harcama ₺0"* diyor) için **beklenen davranışın kaynak tanımı**: `Consumed` ledger'dan
gelir ve zarfa bağlı olmak zorundadır. **Doğrulama bu turda yapılmadı** (kod yok).

Diğer raporlardan taşınacak tanımlar:
- `Report 3`: **Average Approval Time** = `approved_at − created_at` · **Cap Utilization** =
  `consumed / cap`
- `Report 4`: **Approval Rate** = `approved / submitted`
- `Report 5`: **Average Time to Approval** (gün) — hedef **<2 gün**
- `Report 6`: **Average Spend per Use** (taktik başına)

---

## 5. `Report 5` bir **veri modeli** şartı getiriyor

*Planner Performance* raporu kişi bazında ölçüyor: yaratılan/onaylanan plan sayısı, onay
oranı, ortalama onay süresi, **onaylanmış planların ortalama ROI'si**.

Yani plan üzerinde **yaratıcı kimliği** ve **durum geçişlerinin zaman damgaları** kalıcı
olmalı; *"Insights"* bloğu (ör. *"Can T. has low approval rate → review plan quality"*)
kişi bazlı kıyas yapıyor.

⚠️ İki soru **açılmadı, kaydediliyor**:
1. Bu rapor bir **performans değerlendirme** aracı (kaynağın kendi *"Use Case"*'i:
   *"Performance reviews"*). Kişisel veri + KVKK boyutu [[T-170]]'in kapsamına girer mi —
   **sorulmadı**.
2. `§7.2`'nin yetenek listesinde *"başkalarının performansını görme"* diye bir yetenek
   **arandı mı** — bu turda **aranmadı**.

---

## 6. `Report 8` — pano tazeleme sıklığı

> **Refresh:** Real-time (updates **every 5 minutes**)

*"Real-time"* ile *"5 dakika"* aynı cümlede; yani kaynak **gerçek zamanlı değil, 5 dakikalık
periyodik** tazelemeyi kastediyor. `§9.1`'in *"Report Generation <5s"* hedefiyle çelişmez —
farklı şeyler (üretim süresi ↔ tazeleme aralığı).

📌 `Section_06 §6.6` *"Plans/Agreements: **Real-time** (N/A)"* diyor; yani paket
*"real-time"* terimini **üç farklı anlamda** kullanıyor: UI'de anında (`§5.2`, `<500ms`) ·
kullanıcı girişiyle eşzamanlı (`§6.6`) · **5 dakikalık periyodik iş** (`§8.1 Report 8`).

Yeni BRD'de terim **tanımlanmalı**. Ölçüm (`Section_12_Glossary.md`): kelime **geçiyor**
ama **kendi maddesi yok** — yalnız `Planning Grid` tanımının gövdesinde (`:496`
*"see real-time KPI calculations"*) ve onun özellik listesinde (`:504` *"Real-time
calculation (<500ms)"*). Yani sözlük terimi **kullanıyor**, **tanımlamıyor**.

---

## 7. Bu turun sınırları (ZORUNLU)

- **Ürün tarafı canlı ölçülmedi.** §3'ün sağ sütunu ve §4'ün T-188 bağlantısı `0058`/`T-188`
  kayıtlarına dayanır; bu turda **hiçbiri yeniden ölçülmedi**.
- **§8.2–§8.6 okunmadı** — turu 39'a bırakıldı (mode-aware raporlama, drill-down, export,
  non-goals, Phase 1 kapsamı).
- `Report 7`'nin *"root cause analysis"* maddesinin ne kadarının Phase 2, ne kadarının
  Phase 3 (`§10.1 Phase 3` *"Variance Analysis"* başlığı) olduğu **karşılaştırılmadı**.
