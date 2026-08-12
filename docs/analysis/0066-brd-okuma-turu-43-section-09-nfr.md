# 0066 — BRD okuma turu **43**: `Section_09 §9.1–§9.4 · §9.6 · §9.7` (bölüm kapandı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_09_NFR.md` **26–264** (§9.1 performans · §9.2 ölçeklenebilirlik ·
  §9.3 erişilebilirlik/DR · §9.4 güvenlik) + **324–417** (§9.6 izleme · §9.7 kullanılabilirlik)
- **Ölçüm ortamı:** meta `2d3211a`. Submodule'ler checkout **edilmemiş**.
- **Durum:** `Section_09` **tamamen okundu** (§9.5 + §9.8 `0050` · kalanı bu tur).

---

## 1. ✅ `0063-SSO` çözüldü — ve tablo düşündüğümden **daha net**

`0063` bunu *"1 tanığa karşı 2"* diye kaydetmişti. Tam enumerasyon (`grep -rniE "sso|saml"`,
tüm `01_Main_BRD` + `02_Addendum`) başka bir tablo veriyor:

| ne diyor | tanık | yer |
|---|---|---|
| **Phase 1'de YOK / Phase 2** | **4** | `§7.7:592` · **`§9.4:210`** (*"❌ SSO/SAML (Phase 2)"*) · `§9.8:462` · `§10.1:105` |
| **yetenek olarak var** | 5 | `§2.1.4:199` (*"SSO-**ready**"*) · `§2.1.4:214` (*"**(Day 1)**"*) · `§2.5:720` (entegrasyon stratejisi) · `§3.2:332` (Key Capabilities) · `§3.2:380` (Functional Scope) |

### Ve beş "var" tanığının dördü, kaynağın **kendi sözleşmesiyle** açıklanıyor

`Section_03`'ün girişi (8–29) bu ayrımı **açıkça kuruyor**:

> *"**IMPORTANT — Target State vs Implementation Phasing:** This section describes the
> **target architecture** … **not all capabilities will be implemented in Phase 1**."*

Aynı konvansiyon `Section_05`'in girişinde de var (*"covers target product capabilities;
Phase 1 implementation constraints are noted explicitly"*).

> ### Yani `§3.2`, `§2.5` ve `§2.1.4:199` (*"SSO-ready"*) **hedef durumu** anlatıyor;
> `§7.7`/`§9.4`/`§9.8`/`§10.1` **fazı** söylüyor. Çelişki yok.
>
> **Geriye tek bir aykırı ifade kalıyor: `§2.1.4:214`'ün `(Day 1)` ibaresi.** Dört
> faz-beyanına karşı bir kelime, ve komşuları (`ERP Integration (Phase 2)`,
> `BI Tools (Phase 2)`) faz etiketi taşıyor.

**Öneri (karar ürün sahibinin):** `0063-SSO` bir çelişki değil, **bir yazım hatası**;
yeni BRD'de `(Day 1)` → `(Phase 2)` ya da `(SSO-ready: Day 1, entegrasyon: Phase 2)`.

---

## 2. `0064-SCALE` daralıyor — sayılar **farklı şeyleri** ölçüyor

`0064 §3` üç beyanı yan yana koyup *"bir performans testi hedefini seçemez"* demişti.
Bu tur `§9.2`'yi bağlamıyla okuyunca tablo değişti:

| kaynak | ifadenin **türü** | örnek |
|---|---|---|
| `§2.5` | **kapasite iddiası** (*"Tested with…"*, *"Supports…"*, *"scales to…"*) | 10.000+ SKU · 100+ eşzamanlı kullanıcı · 500+ fatura/batch |
| `§9.2` | **talep projeksiyonu** (*"Year 1 Projections"*) + **Phase 1 hedef tablosu** | 5.000 SKU (Yıl 1) · 50 eşzamanlı (tek tenant tepe) · 500 toplam |
| `§1.3`/`§2.1.3` | **kullanım örneği** (*"40-50**+** invoices"*, `+` ile) | tavan değil |

> **Bunlar çelişmiyor:** 10.000'e kadar test edilmiş bir sistem 5.000'lik bir projeksiyona
> hizmet edebilir; `40-50+` bir tavan iddiası değil.

⚠️ **Bu, `0064 §3`'ün çerçevesinin düzeltilmesidir** — ölçüm doğruydu (sayılar farklı),
**yorum eksikti** (türleri karşılaştırılmamıştı). `CLAUDE.md`'nin *"bir düzeltme de bir
iddiadır"* kuralı gereği kayda geçiyor.

**Geriye kalan gerçek soru — ve dar:** bir performans testi **hangisini** hedefler,
kapasite tavanını mı (10.000 SKU / 100 kullanıcı) yoksa Yıl-1 projeksiyonunu mu
(5.000 / 50)? `§9.1`'in *"KPI Calculation (**50 SKUs**) <500ms"* satırı üçüncü bir
büyüklük daha veriyor (tek plan ölçeği). `0064-SCALE` bu dar hâliyle güncellendi.

---

## 3. 🔴 `0064-TENANT` **çözülmedi** — ve `§9.2` tarafı faz etiketli

`§9.2`'nin ilgili bloğu (bağlamıyla):

```
Multi-Tenant Scalability
  Tenant Isolation Model:
    - Shared database (logical isolation via tenant_id)
    - Row-Level Security (RLS) enforced
    - Noisy neighbor protection (query timeouts, rate limiting)

  Target Platform Capacity (PHASE 1):
    Concurrent Tenants           100 tenants   (Shared infrastructure)
    Concurrent Users (Total)     500 users
    Concurrent Users (Peak, Single Tenant)  50 users
    TPS                          500
    Database Connections         200 (pgBouncer)
```

`§2.5` ise: *"**Current:** Single-tenant deployments · **Roadmap:** Multi-tenant SaaS
architecture (tenant-level data isolation)"*.

**§1'in "hedef durum ↔ faz" sözleşmesi burada İŞE YARAMIYOR**, çünkü yön ters: orada
yetenek bölümü *"var"*, faz bölümü *"Phase 2"* diyordu. Burada **faz bölümü (`§9.2`,
"Phase 1") *var* diyor**, yetenek bölümü (`§2.5`) *"roadmap"* diyor.

İki okuma mümkün ve **ikisi de ölçülemiyor**:
- (a) `§2.5`'in *"Current"*'ı **yazıldığı gündeki kurulum modelini** anlatıyor (as-is),
  `§9.2` **Phase 1 hedefini**;
- (b) ikisi gerçekten çelişiyor.

> **`§2.4`: DUR.** `0064-TENANT` açık kalıyor — ama artık *"hangi bölüm hangi tür ifade
> veriyor"* sorusu cevaplı: `§9.2` **faz etiketli, sayısal ve mekanizma seviyesinde**
> (RLS, pgBouncer); `§2.5` **tek cümlelik bir yol haritası notu**.

---

## 4. §9.4 — paketin **tek** parola/oturum güvenlik politikası

Ölçüm: `password (policy|expiry|history)|bcrypt|minimum 8` → `§9.4` (beş satır) ve
`§7.5:527` (yalnız *"bcrypt"* tekrarı). Yani politika **tek yerde**:

- **Min 8 karakter**, büyük+küçük+rakam
- **Parola süresi: 90 gün (configurable)**
- **Parola geçmişi: son 5 parola tekrar kullanılamaz**
- Auth (Phase 1): e-posta+parola (bcrypt) · **session 30-dk idle** · ❌ SSO · ❌ **MFA**

Ve iki ağ/oturum kuralı daha, yine tek yerde:
- **Rate limit: 100 istek/dakika/kullanıcı (API)**
- **5 başarısız denemeden sonra CAPTCHA**
- Güvenlik yamaları **7 gün içinde**, yıllık sızma testi, aylık zafiyet taraması

📌 `§7.6`'nın (`0059 §2.2`) oturum kuralları + `§9.4`'ün parola kuralları birlikte
**yeni BRD'nin kimlik doğrulama bölümünü** oluşturur. İkisi de bugün **tek tanıklı**.

### ✅ Ve `EA-001`'in self-approval maddesi **üçüncü tanığını** aldı

```
§9.4:223   "Conflict-of-interest prevention (cannot approve own submissions)"
§7.1:68    "❌ Approve own submissions (conflict of interest)"
§7.1:171   "User cannot approve own submissions (SYSTEM BLOCKS)"
§7.3:243-245  approval kontrolünde kod seviyesinde: 'Cannot approve own submission'
```

> [[T-201]]'ün matrisindeki *"Admin kendi yarattığı agreement'ı onaylayamaz"* maddesi
> `EA-001`'e özgü **değil** — paket bunu **tüm kullanıcılar için** dört yerde söylüyor ve
> biri *"system blocks"* diyerek **zorlayıcı** kılıyor. T-201'ün ölçüm adımında bu madde
> öncelikli olmalı.

---

## 5. §9.3 / §9.6 / §9.7 — üç davranış kuralı ve dördüncü kayıp bildirim

**§9.3 Degraded Mode — üç senaryo, ve ikisi kullanıcıya görünür davranış tarif ediyor:**

| senaryo | kaynak ne diyor |
|---|---|
| Read replica düşerse | otomatik failover, **<30 sn**, kullanıcıya etkisiz |
| **Job queue düşerse** | *"Users notified: **'Export processing delayed, you'll receive email when ready'**"* + **kritik importlar için manuel tetikleme** |
| **ERP API düşerse** | **cache'lenmiş veri + bayatlık uyarısı**: *"Product data last updated 2 hours ago"* |

📌 Üçüncüsü bir **UI sözleşmesi**: bayat master data ile çalışmaya izin var, **ama uyarı
zorunlu**. Yeni BRD'ye girmeli.

⚠️ Ve ikincisi **dördüncü kayıp bildirim** (`0065 §3`): *"export gecikti"* de `MC-002`'nin
altı olayında yok. Sayı **dokuzdan ona** çıktı.

**§9.6 — alarm tablosu ve log seviyeleri:** CPU >85%/5dk · DB down (PagerDuty + **SMS**) ·
P95 >3s · hata oranı >%5 · **bütçe aşımı → Finance (email)** · import başarısız →
Data Engineering. Ve **iş metrikleri** (günlük plan/agreement sayısı, bütçe kullanımı,
başarısız import sayısı) izleme kapsamında.

**§9.7 — bugüne kadar hiç kaydedilmemiş üç şart:**
- **i18n: Phase 1 Türkçe + İngilizce**, dil değiştirici
- **Sayı biçimi: locale-aware (`1,000.00` ↔ `1.000,00`)**, para birimi TL/USD/EUR
- **Erişilebilirlik: WCAG 2.1 Level A** (klavye, ARIA, kontrast **≥4.5:1**, %200 zoom),
  Level AA → Phase 2
- Cihaz: masaüstü birincil, tablet duyarlı, **mobil yalnız görüntüleme**

📌 **Sayı biçimi satırı doğrudan bizim para/tarih ayrıştırma işimizin konusu** (`0015`,
[[T-106]], `numeric-text.ts`): kaynak **locale-aware biçimlendirmeyi Phase 1'de şart
koşuyor**. Bu, `1.234,56` girdisinin neden ciddiye alınması gerektiğinin **kaynak
gerekçesidir** — bugüne kadar hiçbir analiz belgesinde atıf verilmemişti.

---

## 6. Bu turun sınırları (ZORUNLU)

- **Kod ölçülmedi.** §4'ün T-201 önerisi ve §5'in para biçimi bağlantısı kaynak
  tarafındadır; ürün karşılığı **aranmadı**.
- `§9.1`'in tablosu (`0059`'da okunmuştu) bu turda **yeniden ölçülmedi**; buradaki atıflar
  ondan.
- `0064-TENANT` **çözülmedi**, yalnız iki tarafın **ifade türü** netleşti.
- `§9.2`'nin *"Scaling Strategy"* tablosu (yük seviyesine göre aksiyon) okundu ama
  ürün/altyapı karşılığı **aranmadı**.
