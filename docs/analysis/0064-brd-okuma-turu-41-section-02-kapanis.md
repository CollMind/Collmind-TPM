# 0064 — BRD okuma turu **41**: `Section_02 §2.3–§2.5` (bölüm kapandı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_02_Product_Overview.md` **439–670** — §2.3 Operational Modes
  Comparison (`2.3.1` actuals derin · `2.3.2` planning derin · `2.3.3` yan yana tablo) ·
  §2.4 Supported Organizational Patterns · §2.5 Scalability & Extensibility
- **Ölçüm ortamı:** meta `b22ea91`. Submodule'ler checkout **edilmemiş**.
- **Durum:** `Section_02` **tamamen okundu** (§2.6 `0037` · §2.7 `0036` · §2.1–2.2 `0063` ·
  §2.3–2.5 bu tur).

---

## 1. 🔴 GP ROI eşiği: paket **iki farklı ölçek** kullanıyor — 7 tanığa karşı 2

`§2.3.2`'nin kullanıcı yolculuğu:

> 9. **System:** Calculates GP ROI = **145% (AMBER, target is 150%+)**
> 10. **Planner:** Reduces discount to 12% → GP ROI = **162% (GREEN)**

`§5.2`'nin normatif kuralı ise **bir formül** olarak yazılı:

```
Section_05:432  RAG Status = IF(GP_ROI ≥ 20%, GREEN, IF(GP_ROI ≥ 10%, AMBER, RED))
```

**Enumerasyon (ölçüldü, hafızadan değil — `grep -rniE` tüm `01_Main_BRD`):**

| ölçek | tanık sayısı | yerler |
|---|---|---|
| **`≥20%` Green · `10-20` Amber · `<10` Red** | **7** | `§5.2` ×3 (`:94`, `:432` **formül**, `:455`) · `§5.6:1706` · `§8.1:284-285` · `§10.1:235` · `§10.2:366` · `§10.6:547` · Glossary ×2 (`:253`, `:544`) |
| **`150%+` hedef** | **2** | `§1.3:163` (*"Example:"*) · **`§2.3.2:561`** (*"Typical User Journey (**Example**)"*) |

> ### İkisi de aynı metriği (`GP ROI`) adlandırıyor ve bir **büyüklük mertebesi** farkla
> ayrışıyor. Ama dağılım tesadüfi değil: **`150%`'in iki geçişi de anlatı örneğinin
> içinde**; normatif olanların hepsi kural, formül, gate ölçütü ya da sözlük maddesi.

**Uzlaştıran okuma (tur 17 disiplini):** normatif ölçek `≥20`'dir; `150%` ibareleri
**illüstrasyon hatası** ya da farklı bir konvansiyon (1,5× getiriyi *"%150"* diye yazmak)
kalıntısıdır. `§8.1`'in kendi verisi bunu destekliyor: `598K / 2.450K = %24,4` ve o değer
**🟢 GREEN** basılıyor — `150%` ölçeğinde aynı sayı **kırmızı** olurdu.

⚠️ **Ürün etkisi yok bugün** (`§2.3`: RAG eşikleri KPI konfigürasyonundan gelir, hardcode
yasak) ama **yeni BRD için karar gerekiyor:** iki örnek ya düzeltilmeli ya çıkarılmalı.
Bir okuyucu `§1.3` + `§2.3.2`'yi okuyup **150 hedefiyle** yola çıkabilir.

📌 Ve `§10.2` Gate 3 ölçütü aynı ölçeğe yaslanıyor: *"70%+ plans achieve Green status
(**ROI ≥20%**)"* — [[T-177]]'nin *"Gate 3 ölçülebilirliği"* bağlantısının kaynağı budur.

---

## 2. 📌 `§2.5` Multi-tenancy: *"Current: **single-tenant**"* — `§9.2` ile ters

```
§2.5  "4. Multi-Tenancy (SaaS Roadmap)
       Current:  Single-tenant deployments
       Roadmap:  Multi-tenant SaaS architecture (tenant-level data isolation)"

§9.2  "Tenant Isolation Model: Shared database (logical isolation via tenant_id),
       Row-Level Security (RLS) enforced"
      "Concurrent Tenants: 100 tenants (Phase 1 hedef tablosu)"
```

`§9.2` çok-kiracılığı **Phase 1 kapasite hedefi** olarak veriyor; `§2.5` onu **yol haritası**
sayıyor. İkisi aynı fazı tarif ediyor ve **ters** söylüyor.

⚠️ Ve bizim tarafımızda bu soyut değil: `0056`'nın RLS/tenant çalışması, `0056-K10`
(*"login'in tenant çözümü çok-tenant'ta ne yapacak"*) ve [[T-179]] hep çok-kiracılı bir
model varsayıyor. **Bu turda kod ölçülmedi**; ama kaynak tarafındaki çelişki ölçüldü ve
`§9.2` **iki bakımdan** daha güçlü: sayısal hedef veriyor ve NFR bölümünde (kapsamın
kanonik yeri, `§2.1.1`).

---

## 3. 📌 Ölçek sayıları: **üç beyan, üç farklı sayı**

| ölçüt | `§2.5` | `§9.2` | diğer |
|---|---|---|---|
| SKU | **10.000+** | **5.000** (Yıl 1) | — |
| eşzamanlı kullanıcı | **100+** (`<2s` sayfa) | **50** (tek tenant, tepe) · 500 (toplam) | — |
| batch fatura | **500+ / batch** | — | **40-50+** (`§1.3`, `§2.1.3`) · 50K satır/gün (`§9.1`) |
| aktif promosyon | 1.000+ eşzamanlı | 2.000 agreement/yıl · 500 plan/yıl | — |

> Hiçbiri diğerine atıf vermiyor ve hiçbiri *"gösterge"* demiyor. **Yeni BRD'de tek bir
> ölçek tablosu olmalı** — bugünkü hâliyle bir performans testi hangi sayıyı hedefleyeceğini
> kaynaktan **seçemez**.

📌 Bu, [[T-154]]'ün (`MC-001` ↔ `H2` eşzamanlılık ölçütü) ve `CANDIDATE-007`'nin
(SLA katmanları) aynı ailesi: **kaynak birden çok yerde sayı veriyor, uzlaştırmıyor.**

---

## 4. ✅ `§2.3` — iki modun uçtan uca akışı: yeni BRD'nin ürün özeti için **en iyi kaynak**

`§2.3.1`/`§2.3.2` her modu **tetikleyiciden ledger'a** kadar adım adım veriyor, ve
`§2.3.3` on üç eksende yan yana koyuyor (birincil nesne · zaman ufku · yaratma süresi ·
veri girişi hacmi · hacim planlama · ROI simülasyonu · **onay temeli** · yürütme
tetikleyicisi · harcama izleme · KPI'lar · esneklik · stratejik değer · raporlama odağı).

Üç ifade doğrudan sözleşme diline çevrilebilir:

| ifade | not |
|---|---|
| **`Ledger Entry: double-entry optional, audit-focused`** | `INV-L-007`'nin (`Σ DEBIT − Σ CREDIT`) çerçevesiyle uyumlu — çift kayıt **zorunlu değil** |
| **Core Objects (Actuals):** Agreement · **Agreement Transaction** · Ledger Entry | bizdeki modül adlarıyla birebir örtüşüyor (`0058`'in rota envanterine göre) |
| **Core Objects (Planning):** Plan · **Plan Item (FU seviyesi)** · **SKU Volume** · KPI Calculation | `0057`/`0019 #2`'nin *"taktik FU'da, hacim SKU'da"* sorusunun **dördüncü tanığı** — `Plan Item` FU seviyesinde tanımlanmış |

---

## 5. `§2.4` — organizasyon desenleri: yapılandırmayla, kodla değil

Dört desen (Traditional-Heavy · NKA-Centric · Balanced Multi-Channel · Premium Brand) ve
her biri **`scope_policies` konfigürasyonu** olarak ifade edilmiş — yani `§2.2`/`§2.6`'nın
çözümleyicisinin **iş karşılığı**. Yeni BRD'de bu tablo `scope_policies`'in **neden var
olduğunu** anlatan yerdir.

⚠️ **Bir faz gerilimi kaydediliyor** (çelişki ilan edilmiyor): *"Premium Brands → Phase 1
Focus: **Planning-First accelerated (10-12 hafta)**"* ve *"NKA-Centric → **dual-mode
deployment (23 hafta)**"*. `§10.1`'in faz modeli ise Phase 1 = **13 hafta Actuals**,
Phase 2 = **10 hafta Planning**, ve Phase 2'nin **gate ön koşulları** var (baseline
hazırlığı, `Gate 2`). 23 = 13+10 olduğu için ikincisi uzlaşıyor; **birincisi (Planning'i
öne alma) `§10`'un gate modeliyle uzlaşmıyor** ve `§2.4` bunu bir istisna olarak
işaretlemiyor.

📌 *"Note for Internal Teams: detaylı müşteri senaryoları **Sales Enablement Deck** ve
**Implementation Playbook**'ta"* — pakette **ikisi de yok** (`0059`'un dosya envanteri).
Bu, `04_Reviews`'ın *"`05_ARCHIVE` klasörü yok"* boşluğuyla (ADR 0010) aynı sınıf: paket
var olmayan belgelere atıf veriyor.

---

## 6. Bu turun sınırları (ZORUNLU)

- **Kod tarafı ölçülmedi.** §2'nin çok-kiracılık gerilimi ve §4'ün modül eşlemesi
  `0056`/`0058` **kayıtlarından**; bu turda hiçbir dosya açılmadı.
- §1'in *"ürün etkisi yok bugün"* cümlesi `CLAUDE.md §2.3`'ün *"RAG eşikleri KPI
  konfigürasyonundan"* kuralına dayanır — **kodda doğrulanmadı**.
- `§2.3.3` tablosunun on üç ekseni okundu; her eksenin ürün karşılığı **aranmadı**.
- `Section_02` bitti; `Section_06 §6.1/6.2/6.6` ve `Section_09` sırada
  (`0059`'un girer kovası).
