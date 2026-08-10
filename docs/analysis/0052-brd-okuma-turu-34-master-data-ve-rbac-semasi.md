# 0052 — BRD okuma turu **34**: §3.1 Master Data + §3.2 RBAC — **eksen karışıklığı çözüldü**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_03_Core_Components.md` §3.1 (30–320) · §3.2 (322–384) — **ikisi de tam**
- **Ölçüm ortamı:** meta `66f03ef` · backend `99ee9e6` · dev DB `main` şeması

---

## 1. ✅ [[T-165]]'in `region ↔ category` sorusu **kapandı** — ikame değil, **farklı eksen**

BRD `§3.1` bunu **iki kez** ve *"Critical"* etiketiyle söylüyor:

> *"**Critical:** Category is part of **Product Hierarchy**, not organizational dimensions"*
> *"Categories are part of Product Hierarchy (not organizational dimensions), but serve
> **dual purpose**: Product attribute · **Budget dimension** (Channel × Category × Period)"*

| eksen | üyeler |
|---|---|
| **Ürün hiyerarşisi** | Brand → **Category** → GU → FU → SKU |
| **Organizasyonel boyut** | Channel · **Region** · Sales Team |

> **Yani `category` bir `region` ikamesi olamaz — ikisi farklı eksende.**
> Turu 31'in *"bilinçli ikame mi?"* sorusunun cevabı: **hayır, olamaz.**

### Ve `region` **bizde var** — turu 31'in ifadesi daraltılmalı

Turu 31 *"bizde `region` yok"* demişti. Doğru olan kapsam **`user_scopes`**'tu; ölçüm:

```
main.regions            → TABLO VAR (parent_region_id, level, country — tam hiyerarşi)
region_id FK'leri       → cpls · plans · agreements
region.controller.ts    → ÜRETİM YOLU VAR
main.regions satır      → 0        · cpls.region_id dolu → 0/29
main.user_scopes        → cpl_id · category_id · channel_id   (region_id YOK)
```

> **Bu, tanıdık *"mekanizma var, yol yok"* sınıfı DEĞİL** — controller var, FK'ler var.
> Bu, *"yol var, **veri yok**"*: boyut modellenmiş ve hiç kullanılmamış.

**Gerçek fark ise başka bir yerde ve daha keskin:**

| `§7.1` Planner scope | bizde |
|---|---|
| Channel-based | ✅ |
| **Region-based** (opsiyonel) | ❌ `user_scopes`'ta yok |
| CPL-based (opsiyonel) | ✅ |
| — | ✅ **`category_id`** ← BRD'nin listesinde **yok** |

> **Kapsam eksenimizde BRD'nin saymadığı bir ÜRÜN ekseni var, saydığı bir ORGANİZASYON
> ekseni yok.** [[T-165]]'in sorusu buydu ve cevap bu.

⚠️ `category`'nin kapsam ekseni olması **yanlış** demiyorum — BRD onu bir **bütçe boyutu**
olarak zaten meşrulaştırıyor. Ölçülen şey, **listede olmadığı ve gerekçesinin yazılı
olmadığı**.

---

## 2. ✅ Bir uyum: *"one CPL = one channel"* **yapısal olarak** zorlanıyor

> `§3.1`: *"**Critical:** Channel is NOT part of customer hierarchy. Channel is an
> **attribute** of CPL (one CPL = one channel)"*

```
main.cpls.channel_id → NOT NULL, tekil FK (junction tablo yok)
```

> Tek FK + `NOT NULL` = *"bir CPL'in tam olarak bir kanalı vardır"* **şemada** garanti.
> Habersiz yakınsamaların yedincisi.

### 📌 Ama `customers`'ta paralel bir kanal alanı var

```
main.customers.channel  → enum (USER-DEFINED)     main.customers.region → varchar
main.customers.cpl_id   → 27/93 dolu              → 66 müşterinin CPL'i YOK
uyuşmazlık (cpl_id dolu olan 27'de): 0
```

Yani alan **gereksiz değil** (CPL'siz müşteriler için tek kanal kaynağı) ve bugün
**tutarlı**. Ama tutarlılığı **hiçbir kısıt zorlamıyor** — bir enum kolonu ile bir FK'den
türeyen kodu eşit tutan bildirimsel bir kısıt yoktur.

> **Task açmıyorum:** ölçülen bir uyuşmazlık yok ve alanın bir gerekçesi var. Kayda
> geçiyorum — *"fazla ölçüm olmayan kusur için iş üretir"* (`§7.1`).

---

## 3. 🔴 Yeni: **UOM dönüşümü hiç yok** — ve BRD onu fatura doğrulamasına bağlıyor

> `§3.1`: *"**Conversion Factors:** 1 CS = 12 EA (**configurable per SKU**) — Used for:
> Volume planning, **invoice validation**"*
> *"**Multi-UOM:** Planning: Forecast in **EA** · Invoicing: Receive in **CS**"*

**Ölçüm:**

```
uom / uoms tablosu                              → YOK
uom benzeri kolon                               → forecasting_units.unit_of_measure · skus.unit_of_measure
skus.unit_of_measure distinct değerleri         → (boş — hiç doldurulmamış)
conversionFactor|conversion_factor|caseSize|unitsPerCase (backend) → 0 dosya
```

> **Birim bilgisi taşınıyor ama hiçbir yerde DÖNÜŞTÜRÜLMÜYOR** — ve bugün alanlar boş
> olduğu için tüm hacimler **örtük olarak aynı birimde** varsayılıyor.
>
> Planlar `EA`, faturalar `CS` geldiği gün karşılaştırma **12 kat** yanlış olur ve
> **hiçbir hata üretmez**: bu, `§2.5`'in birim tarafındaki hâli.

⚠️ Ve `§7.1`'in *"doğrulamaya girdi ulaşmıyor"* dersinin bir adayı: bugün alanlar boş
olduğu için hiçbir birim çatışması **oluşamıyor**; kolon doldurulduğu gün sessizce
oluşmaya başlar. → [[T-174]]

---

## 4. ⛔ §3.2 RBAC — **altı tablodan beşi yok**, rol tek bir enum kolonu

| BRD `§3.2` tablosu | bizde |
|---|---|
| `users` | ✅ |
| `roles` | ❌ |
| `permissions` | ❌ |
| `role_permissions` (junction) | ❌ |
| `user_roles` (junction) | ❌ |
| `user_permission_overrides` | ❌ |

```
main.users.role → USER-DEFINED (enum kolonu)
```

**İki sonuç, ikisi de yapısal:**

1. **Yetenek izinleri yok** ([[T-167]]) — `agreements.create` gibi 20 yetenek hiçbir yerde
   veri değil. Bu daha önce ölçülmüştü; **yeni olan, altında hiç şema olmadığı**.
2. **Bir kullanıcı tek rol taşıyabilir.** BRD `user_roles`'ü **junction** tanımlıyor
   (many-to-many). Bizde enum → *"hem Planner hem Approver"* **temsil edilemez**.
   `§3.2`'nin *"An NKA Planner may create a Plan … and an Agreement … same user, same
   session"* cümlesi bunu varsayıyor.

> ⚠️ Ve `§3.3`'ün *"**The schema supports all these capabilities today**"* iddiası
> **üçüncü kez** ölçülüp yanlış çıktı ([[T-156]] · [[T-148]] · burada).
> Kaynak bir **girdi**dir (`§2.1.2`) — ve bu cümle bir **ölçüm iddiası** olarak yanlış.

📌 `user_permission_overrides` BRD'nin kendi uyarısıyla geliyor: *"(use sparingly)"* —
yani kaynak da onu bir kaçış kapağı sayıyor. Bir uygulamada **atlanabilir**.

---

## 5. 📌 Diğer eksikler (kayda geçer, task açmıyor)

| BRD tablosu | bizde | not |
|---|---|---|
| `sales_teams` | ❌ (kodda da 0 dosya) | BRD onu **onay yönlendirmesine** bağlıyor → `approval_policies` ile aynı boşluk ([[T-153]]) |
| `subchannels` | ❌ | `scope_policies`'in bir ekseni ([[T-148]]) — o task'la birlikte gelir |
| `generic_units` (GU) | ✅ | hiyerarşi tam: Brand → Category → GU → FU → SKU |
| `categories.parent_category_id` + `level` | ✅ | BRD şemasıyla **birebir** |
| `regions.parent_region_id` + `level` + `country` | ✅ | BRD *"Country → Region → City"* diyor; bizde `country` kolon, `city` **`cpls`'te** |

---

## 6. Okunmayan / sonraki tur

`Section_03` §3.1 ve §3.2 **tamamlandı** (§3.3–3.6 daha önce okundu). Kalan 🟡:
`§6.3/6.5` · `§11.2`+P2/P3 · `§10.3` · Addendum H5.2/5.3 (~590 satır, **~1–2 tur**).
