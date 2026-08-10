# ADR 0009 — Konfigürasyon tavanında `0` yazılamaz

- **Tarih:** 2026-08-10
- **Statü:** **Kabul edildi**
- **Karar veren:** ürün sahibi (Sertaç Tuzcu)
- **Kapsam:** `mechanics.max_combined_discount_percentage` — ve genel olarak **bir tavan
  taşıyan konfigürasyon kolonları**
- **Kanıt:** `docs/analysis/0017-max-combined-discount-semantics.md`
- **İlgili:** ADR 0008 (kardeş karar, **farklı eksen**) · `SYSTEM_INVARIANTS §9` D-15 eksen B ·
  ADR 0007 E8 · açtığı task'lar: [[T-138]], [[T-139]], [[T-140]]

---

## Soru

Bir konfigürasyon tavanına `0` yazmak ne demek: *"tavan sıfır, yani hiçbir şeye izin verme"*
mi, *"tavan yok"* mu?

## Neden bu ayrı bir ADR, ADR 0008'e ek değil

ADR 0008 *"girilen değerde `null` ile `0` arasında anlam farkı yoktur"* der ve kapsamını
açıkça **planner'ın girdiği mekanik değeri** ile sınırlar. Bu karar **admin'in girdiği bir
konfigürasyon** hakkında.

Fark yalnız kim yazdığı değil: girilen değerde `0`'ın iş anlamı *"%0 indirim"*dir ve
*"indirim yok"* ile ekonomik olarak aynıdır. Bir **tavanda** `0` ile yokluk **zıt** anlamlar
taşır — biri en kısıtlayıcı, diğeri kısıtsız. ADR 0008'i burada dayanak göstermek, onu
vermediği bir kararın gerekçesi yapmak olurdu.

---

## Ölçüm (2026-08-10, backend `d7b6b76`, dev DB `main`)

`0017`'nin tamamı kanıttır. Karara doğrudan giren dördü:

**1. `0` bugün istenen şeyi ifade etmiyor.** Tavan yalnız mekanik **aktifken** sınanıyor
(`activeMechanics` girdinin `≠ 0` olmasını şart koşuyor), ve aktif bir PERCENT mekaniğin
katkısı tanımı gereği `≠ 0`. Yani `0` tavanı **"bu mekanik hiç kullanılamaz"** demek —
*"bu FU'da indirim olmasın"* değil. Mekanik kullanılmadığında tavan **hiç sınanmıyor**.

**2. İki implementasyon `0`'ı zıt okuyor.** `spend-validation.service.ts` (`!== null`,
canlı yaptırım) bağlayıcı sayıyor; `mechanic.service.ts` (`|| 100`, placeholder tavsiye)
tavansız sayıyor.

**3. `0` yazılabilir bir girdi.** `POST /mechanics` · `PATCH /mechanics/:id`,
`@Roles(ADMIN)`, `@Min(0) @Max(100)`.

**4. Veri boş.** Üç ayrı ölçüm (`0010`, `0011`, `0016 §7`), bir hafta arayla: **6/6 NULL**,
`= 0` olan **hiç yok**. `mechanic.seed.ts` bu alanı hiç yazmıyor.

### BRD doğrulaması (2026-08-10, `poppler` kurulduktan sonra — `0017 §7`)

`TPM_Base_BRD_Code_Prompts.pdf`, mekanik yönetimi ekranının mockup'ı:

```
│ Combination Rules:                                    │
│ [✓] Can combine with other on-invoice discounts       │
│ [ ] Maximum combined discount: [____] %               │
```

ve aynı belgedeki şema taslağı:

```sql
can_combine_with_others BOOLEAN DEFAULT true,
mutually_exclusive_with JSONB,
max_combined_discount   DECIMAL(15,4),
```

**BRD "birleşemez"i ayrı bir boolean ile ifade ediyor.** Tavan alanı bir **onay kutusu +
değer** çiftidir: kutu işaretsizken tavan yoktur, işaretliyken alan bir yüzde taşır.
`0`'ın BRD tasarımında **hiçbir rolü yok.**

---

## Karar

> **Bir konfigürasyon tavanı ya bir pozitif değer taşır, ya da yoktur (`NULL`). `0`
> yazılamaz.**

`mechanics.max_combined_discount_percentage` için:

```sql
CHECK (max_combined_discount_percentage IS NULL
       OR max_combined_discount_percentage > 0)
```

DTO `@Min(0)` → pozitif kısıt; `0` **400** ile reddedilir, sessizce yok sayılmaz.

### Gerekçeler (ürün sahibinin ifadesiyle)

**Ö1 (`0` bağlayıcı) savunulamaz.** `0` = *"bu mekanik hiç kullanılamaz"* — ve o zaten
`is_active = false`. İki mekanizma, aynı sonuç, biri adıyla yalan söylüyor.

**Ö2 (`0` → tavansız) §2.5'in sessiz ailesinden.** Admin `0` yazıyor, API kabul ediyor,
hiçbir etki üretmiyor. Kabul edilen bir girdinin sessizce yok sayılması.

**Ö3 farkı konusuz kılıyor ve veri boş — dönüşüm maliyeti sıfır. Pencere açık.**

### Ön koşulun karşılığı

*"Hiç indirim olmasın"* bugün zaten ifade edilemiyor — `0` onu yapmıyor. Yani `0`'ı
kaldırmak **bir yeteneği kaldırmıyor.** İhtiyaç doğarsa ayrı bir mekanizma gerekir ve o
zaman doğru tasarlanır.

⚠️ Ve BRD'de o mekanizmanın **adı zaten var**: `can_combine_with_others`. Bizde yok →
[[T-140]].

---

## Kapsam: yalnız bu kolon mu?

**Karar bu kolon için bağlayıcıdır.** Genel kural olarak ifade edilmiştir çünkü aynı şekil
başka kolonlarda da doğabilir; ama **başka bir kolona uygulanmadan önce o kolon ölçülmelidir**
— bu turun dersi tam olarak budur: `0`'ın ne ifade ettiği, kolonun adından değil
**tüketicisinden** çıkar.

Ayırt edici soru: *bu kolonda `0` ile `NULL` zıt anlamlar mı taşıyor?* Evetse bu karar
uygulanır; hayırsa (ör. girilen bir değer) ADR 0008 uygulanır.

---

## Bu kararın KAPATMADIĞI şeyler

Üçü de ayrı task, ve ikisi Ö3'ten bağımsız:

| | Neden açık kalıyor |
|---|---|
| [[T-138]] | `MAX_COMBINED_DISCOUNT = 60` hardcoded ve `ERROR` severity'li. Konfigüre edilebilir tavan yalnız %60'ın **altında** anlam taşıyor. BRD ölçümü bunu **ağırlaştırdı**: 50 ve 60 için BRD'de indirim bağlamında **hiçbir dayanak yok**, ve BRD ceza değil **uyarı** diliyle yazıyor (*"Recommended max"*, *"shows warning if discount exceeds typical range"*) |
| [[T-139]] | Toplama yönü: yaptırım **en katı** tavanı bağlıyor, tavsiye `Math.max` ile **en gevşeğini** duyuruyor. `0`'dan bağımsız — tavanlar 20 ve 80 iken de çelişiyorlar |
| [[T-140]] | BRD'nin `can_combine_with_others` ve `typical_range_min/max` alanları bizde **hiç yok** |

---

## Uygulama

`data-engineer` yazar (CLAUDE.md §3 — migration yalnız `data-engineer`):

1. `CHECK` kısıtı — migration numarası `MIGRATION_SEQUENCE.md`'den tahsis edilir
2. `create-mechanic.dto.ts`: `@Min(0)` → pozitif kısıt
3. ⚠️ **Aynı commit'te değil, ama aynı turda:** `mechanic.service.ts`'in `|| 100`'ü artık
   `0`'ı hiç görmeyecek — ama **`Math.max` çelişkisi kalıyor** ([[T-139]]). Bu ADR onu
   çözdüğü sanılmamalı.
4. Test: `0` gönderen bir istek **400** alıyor; `NULL` ve pozitif değer geçiyor

**Veri dönüşümü yok** — 6/6 NULL (üç ölçümle doğrulandı).
