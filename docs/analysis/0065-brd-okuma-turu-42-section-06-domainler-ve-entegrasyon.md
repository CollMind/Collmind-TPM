# 0065 — BRD okuma turu **42**: `Section_06 §6.1 · §6.2 · §6.6` (bölüm kapandı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_06_Data_Integration.md` **22–233** (§6.1 Data Domains · §6.2
  Integration Patterns) + **521–538** (§6.6 Data Refresh Frequencies)
- **Ölçüm ortamı:** meta `4f06c7b`. Submodule'ler checkout **edilmemiş** — kod iddiası yok.
- **Durum:** `Section_06` **tamamen okundu** (§6.3/§6.5/§6.7 `0053` · §6.4 `0038` ·
  §6.1/§6.2/§6.6 bu tur).

---

## 1. §6.1 — veri domainleri: **ölçülebilir kalite kuralları**

Üç domain (Master · Transactional · Reference) ve her birinde **sayısal kabul ölçütleri**:

| domain | kural |
|---|---|
| **Master** | Completeness **%100** (aktif müşteri/ürün) · ID'ler kaynak sistemler arası **eşleşmeli** · Recency: master **≤7 gün**, **fiyat/COGS ≤1 gün** |
| **Transactional** | Completeness **≥%95** (boşluklar işaretlenir) · Timeliness **T+1** · Accuracy: hacim/tutar sapması **<%2 tolerans** |
| **Reference** | Kaynak: **CollMind UI (Admin konfigürasyonu)** |

> Bunlar bir **kabul kapısına** çevrilebilecek tek kalite ifadeleri — paketin başka
> yerinde bu netlikte yok. Yeni BRD'ye aynen girmeli.

### 📌 `Domain 3` bir açık task'ı doğruluyor

```
| RAG Thresholds  | Green/Amber/Red boundaries | Managed By: Finance Admin | Manual (annually) |
| Approval Policies | Workflow routing rules   | System Admin              | Manual (as needed) |
| KPI Definitions | Formula and calculation rules | System Admin           | Manual (rarely) |
```

Yani eşikler, politikalar ve KPI formülleri **konfigürasyon verisidir ve admin tarafından
yönetilir**. [[T-108]] (eşiklerin üretimden ulaşılamaz olması) ve `0056-K8` (*"yetki veri
mi olacak"*) için doğrudan kaynak cümlesi. (`0059 §2.3`'te ilk kez not edilmişti; burada
tam bağlamıyla okundu.)

### Entity listesi — `GU` ve `Outlet` yine "opsiyonel"

`Master Data` tablosu sekiz varlık sayıyor; ikisi bu turda dikkat çekti:
- **`GU (Group Unit)`** — *"Aggregation of FUs (**optional**)"*
- **`Organizational Hierarchy`** — Region ID, Channel, **Category Tree** (çeyreklik yenileme)

`0063 §4`'ün `CPL → Customer → Outlet` ölçümüyle birlikte: **hiyerarşilerin uç seviyeleri
kaynakta opsiyonel**. `0056-K5` (*"kapsam eksenleri: category kalsın mı, region eklensin
mi"*) bu tabloyu bir girdi olarak kullanabilir — `Region` burada **birinci sınıf** bir
master data boyutu.

---

## 2. §6.2 — üç entegrasyon deseni, ve **ikisi de zamanlanmış iş istiyor**

| desen | yön | sıklık | taşıma |
|---|---|---|---|
| **API** | çift yönlü | on-demand (**<500ms ort · P95 <2s · timeout 10s**) | REST/JSON, OAuth2 veya API key |
| **File** | gelen | zamanlanmış (günlük/haftalık) | **SFTP** (tercih), S3, Azure Blob |
| **Manual (UI)** | gelen | ad-hoc | web form |

**ERP'den Phase 1'de istenen dört uç** açıkça listelenmiş:
`GET /customers` · `GET /customers/{id}` · `GET /products` · `GET /products/{sku}`
(*price, COGS, UOM*).

**Dosya işleme akışı sekiz adım** ve iki adımı altyapı şartı:

```
2. CollMind: Detect file (POLLING EVERY 5 MINUTES)
7. CollMind: Archive file (RETAIN 90 DAYS)
8. CollMind: Send notification (email/webhook on failure)
```

📌 **`§6.6` ile birleşince** zamanlanmış iş listesi netleşiyor: master 02:00 · sales 03:00 ·
invoice 04:00, **SLA: master 06:00'ya kadar, transactional 08:00'e kadar**.

⚠️ [[T-158]] *"gece işi altyapısı da yok"* diyor (`0026 §3.2`). Bu tur o task'a **ikinci bir
gerekçe** ekliyor: yalnız `EXPIRED` zaman aşımı değil, **dosya polling'i + üç gecelik iş +
saatli SLA** de aynı altyapıyı istiyor. **Kod ölçülmedi** — kaynak tarafı kaydediliyor.

**Dosya limitleri:** max **500 MB**, max **1.000.000 satır**, öneri: büyük dosyaları böl.

**Manuel giriş sınırı (kural):** *"When NOT to Use: high-volume data entry (**>50 records**)
→ use file import"*.

---

## 3. 🔴 Bildirim kümesi: `MC-002`'nin **altı olayı** paketin tamamını kapsamıyor

`0060 §4` `MC-002`'yi (Sprint-0 taslağı) paketin **tek bildirim spesifikasyonu** olarak
ölçmüştü — altı olay. Bu tur ve `0062`, o altının **dışında** kalan üç bildirim buldu:

| bildirim | kaynak | `MC-002`'nin altısında var mı |
|---|---|---|
| **Export hazır** (arka plan işi bitti) | `§8.4:622` (`0062`) | ❌ |
| **Import başarısız** (email/webhook) | `§6.2:201` (bu tur) | ❌ |
| **Veri yenileme başarısız** → *"Immediate (email to **Data Engineering**)"* | `§6.6:535` (bu tur) | ❌ |

> **Yani paket en az dokuz bildirim olayı tarif ediyor, spesifikasyon altısını sayıyor.**
> Ve üçünün alıcısı `MC-002`'nin rol kümesinde bile yok (`Data Engineering`).

Bu, `CLAUDE.md`'nin **enumerasyon** kuralının bir vakası: *"altı olay"* bir sayıdır ve
**kaynağın tamamı taranmadan** yazılmıştır. [[T-158]]/[[T-192]] ailesine değil, **yeni
BRD'nin bildirim bölümüne** iş çıkarıyor.

---

## 4. 📌 Saklama kuralları — **dokuz farklı süre**, dört bölüme dağılmış (enumerasyon ölçüldü)

`grep -rniE "retain|retention|expires? after|archived? after"` tüm pakette:

| ne | süre | yer |
|---|---|---|
| **Plan (Draft)** | **90 gün hareketsiz → SİL** | `§9.5:291` |
| Plan (Approved/Closed) | 5 yıl | `§9.5` |
| **Agreement · Invoice · Ledger** | **7 yıl** | `§9.5` |
| Baseline verisi | 5 yıl | `§9.5` |
| **Audit log** | **7 yıl** | `§9.5` · `§9.8:443` |
| Audit log (arşive taşıma) | **2 yıl sonra** | `§9.2:86` |
| Uygulama logu | 30 gün sıcak · 1 yıl soğuk | `§9.6:367` |
| DB yedeği | tam: 30 gün · artımlı (WAL): 7 gün | `§9.3:186` |
| **İçe aktarılan dosya arşivi** | **90 gün** | `§6.2:200` |
| **Export dosyası** | **7 gün** sonra link expire | `§8.4:624` |

⚠️ **Bir tanesi bir SİLME kuralı:** *"Plans (Draft): 90 days inactive → **delete**"*. Soft mu
hard mı **yazmıyor**, ve `§7.7:587` *"Audit log retention policies (auto-archive)"*'ı
**Phase 1 dışı** sayıyor — yani saklama otomasyonu Phase 1'de yok ama saklama **süreleri**
tanımlı.

📌 [[T-170]] (7 yıl saklama · KVKK anonimleştirme · E-Fatura arşivi) bu tabloyu **kapsam
listesi** olarak kullanmalı: bugün task'ta yalnız *7 yıl* var; ölçülen **on** kural, ve
ikisi (`Draft silme`, `export 7 gün`) tamamen farklı eksende.

---

## 5. `§6.1`'in mimari cümlesi — yeni BRD'nin ilk paragraflarından biri

> *"CollMind is intentionally **not a data warehouse**; it is a **decision and execution
> system** that consumes, validates, and contextualizes enterprise data."*

Ve dört sonucu açıkça yazıyor: CollMind **tüm kurumsal verinin** doğruluk kaynağı değildir ·
**planlama artefaktlarının** (plan, agreement, budget) doğruluk kaynağıdır · master data
ERP'de yaşar · transactional data ERP'de yaşar, CollMind **analiz için** içe aktarır.

📌 Bu, `§3.6`/`§2.1.2`'nin ledger sınırıyla (`0063 §3`) **aynı aileden üçüncü sınır
cümlesi** — ve en genel olanı. `SYSTEM_INVARIANTS`'ın kapsam bölümüne referans olarak
eklenebilir.

---

## 6. Bu turun sınırları (ZORUNLU)

- **Kod ölçülmedi.** *"Zamanlanmış iş altyapısı yok"* [[T-158]]'in kaydından alıntıdır
  (`0026 §3.2`), bu turda doğrulanmadı.
- **§4'ün saklama tablosu `Section_09`'un içinden okundu** ama `Section_09`'un kendisi
  (§9.1–§9.4, §9.6, §9.7) **okunmadı** — sıradaki tur. Tablo o turda **genişleyebilir**.
- ERP'den istenen dört ucun bizdeki karşılığı (entegrasyon var mı) **aranmadı**.
- `§6.2`'nin dosya adlandırma sözleşmesi (`{entity}_{YYYYMMDD}_{HHmmss}.{ext}`) ürün
  tarafında **aranmadı**.
