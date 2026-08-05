# ADR 0008 — Girilen değerde `null` ile sıfır ayrımı yoktur

- **Tarih:** 2026-08-05
- **Statü:** **Kabul edildi**
- **Karar veren:** ürün sahibi
- **Kapsam:** planner'ın girdiği mekanik değeri (`plan_fus.tactics`, `plan_mechanic_values.entered_*`)
- **Kapattığı task'lar:** [[T-078]], [[T-082]] · **Blokajını kaldırdığı:** [[T-083]]

---

## Soru

Planner'ın bir mekaniğe **`0` girmesi**, o mekaniğe **hiç değer girmemesinden** farklı bir şey
ifade ediyor mu?

Kodda bu soru üç ayrı yerde, üç ayrı biçimde duruyordu ve hiçbiri karara bağlanmamıştı. Soru
[[T-078]] olarak açılmış, "iş sonucu ölçülmeli" notuyla ertelenmişti. F2/C3 yazma tarafına bir
ölçek kapısı koyunca soru üçüncü bir yüz kazandı ([[T-082]]) ve bir dördüncüsü ([[T-083]]) buna
bağlandı — yani ertelemenin maliyeti birikiyordu.

## Neden bu bir ADR, ADR 0007'ye errata değil

`null` ile `0` ayrımı bir **temsil** sorusu değil, bir **anlam** sorusu. ADR 0007 sayısal
kontrattır: bir sayının hangi ölçekte olduğu, kaç ondalık taşıdığı, float mı tamsayı mı olduğu.
Bu karar ise sayının *ne demek olduğu* hakkında. 0007'ye eklemek onu sayısal kontratın bir alt
başlığı gibi gösterirdi; öyle değil — aynı ölçek ve aynı temsil altında bile sorulabilecek bir
domain sorusu.

---

## Ölçüm (2026-08-05, backend `029ab26`)

### Yer 1 — aritmetik yolu: `rawOf` / `readEnteredValue` içindeki `?? 0`

`src/common/numeric/mechanic-input.ts` iki yerde "değer yok"u sessizce `0`'a çöker
(`rawOf`, `readEnteredValue`). Bunun **15 çağıranı** var.

**Kritik bulgu: hepsi çökertmenin hemen ardından falsy kontrolü yapıyor.**

```ts
spend-calculation.service.ts:139   const enteredValue = rawOf(...);            if (!enteredValue) return 0;
spend-calculation.service.ts:323   const enteredValue = rawOf(...);            if (!enteredValue) continue;
spend-validation.service.ts:268    const entered = readEnteredValue(...);      if (!entered)      continue;
```

`!enteredValue` **hem** çökertilmiş "değer yok"u **hem** gerçekten girilmiş `0`'ı yakalar. Yani
bu sitelerde ikisi zaten ayırt edilemez ve çıktıları aynı: **harcama yok.**

Sonuç: `?? 0` çökertmesinin bugün **gözlemlenebilir hiçbir sonucu yok.**

### Yer 2 — okuma/yazma asimetrisi

| Katman | `null` girdiye cevabı |
|---|---|
| C3 yazma kapısı (`checkEnteredScale`) | **400** — "value must be a finite number" |
| `buildMechanicValues` (kolon döngüsü `:714-715`, JSONB döngüsü `:718-720`) | sessizce **atla** |

Asimetri gerçek. **Ama yönü doğrudur** ve kusur değildir: yazma sıkı (yeni veri temiz girer),
okuma toleranslı (diskteki eski veri planı kilitlemez). Bu, CLAUDE.md §2.5'in doğru uygulanmış
hâlidir — **kapı girişte durur, temizlik değildir.**

### Yer 3 — tel protokolü

`update-fu-tactic.dto.ts` `@IsOptional()` kullanıyor; class-validator'da `@IsOptional()`
**`null`'ı da atlar**. Dolayısıyla `{"tactics": null}` gövdesi `updateFuTactic`'in ternary'sinde
falsy dala düşüp "dokunma" anlamına geliyor.

Bu davranış **kazara** oluşmuştu — kimse `null`'ın ne demek olduğuna karar vermemişti.

### Ayrımın en olası gerekçe adayı da ayırt etmiyor

ADR 0006 ailesi (lumpsum dağıtımı) ayrımın gerekeceği en makul yerdi. Ölçüldü:
`spend-calculation.service.ts:323` lumpsum yolunda da `if (!enteredValue) continue`. Orada da
girilen `0` ile girilmemiş aynı sonucu veriyor.

---

## Karar

> **Girilen değerde `null` ile `0` arasında anlam farkı YOKTUR.**

Gerekçe veriyle değil, **iş anlamıyla**: trade promotion bağlamında **%0 indirim ile indirim
yok arasında ekonomik fark yoktur** — ikisi de sıfır harcama, sıfır hakediş, sıfır bütçe etkisi
üretir. Ayrım kurmak, **hiçbir yerde tüketilmeyen bir bilgiyi taşımak** olurdu.

### Üç yerin her biri için sonuç

**1. Aritmetik yolu — `?? 0` KALIR.**
Bu bir borç değil, karar. Kod yorumları "bu bilinçli, ayrım yok" demeli; bugünkü "T-078 bunu
ölçecek" ifadeleri bu ADR'ye referansla değiştirilir.

`spend-validation.service.ts:75`'in `readEnteredRaw` kullanması bir **istisna değildir**: orada
`null` kontrolü doğrulamanın kendisidir ("boş giriş doğrulanmaz, atlanır") ve sıfırla ilgisi
yoktur. İki site farklı sorulara cevap veriyor ve **ikisi de doğru**:

| Site | Soru | Doğru araç |
|---|---|---|
| `spend-validation.service.ts:75` | "bu satırda bir giriş var mı?" | `readEnteredRaw` (null korur) |
| `spend-validation.service.ts:268` | "bu girişin harcama etkisi var mı?" | `readEnteredValue` (`?? 0`) |

**2. Okuma/yazma asimetrisi — KORUNUR.**
Yazma sıkı, okuma toleranslı. Bu yön bilinçlidir ve kayda geçmiştir.

**3. Tel protokolü — `{"tactics": null}` = "değişiklik yok" olarak SABİTLENİR.**
Bugünkü davranış zaten budur; bu karar onu **kazara olmaktan çıkarıp bilinçli hâle getirir.**

Ve bir sonucu daha vardır: **silme yolu `null` üzerinden gelmeyecektir.** Bir taktiği kaldırmak
gerekirse açık bir uç (`DELETE .../tactics/:code`) veya açık bir sentinel gerekir — `null` o
anlam için harcanmamıştır çünkü zaten "dokunma" demektedir.

---

## ADR 0006 Karar 2 ile çelişki YOKTUR

ADR 0006 Karar 2 *"null base'li SKU pay almaz"* der ve bu, ilk bakışta "null ile 0 farklıdır"
diyen bir kural gibi okunabilir. **Farklı eksendir:**

- ADR 0006 Karar 2 → **baseline hacmi** hakkında (SKU'nun `base_volume`'ü)
- ADR 0008 → **planner'ın girdiği mekanik değeri** hakkında

Biri veri kalitesi sorusudur (hacim bilinmiyor → dağıtıma katılamaz), diğeri niyet sorusudur
(%0 indirim ≡ indirim yok). İkisi aynı anda geçerlidir.

Bu paragraf, ileride birinin çelişki sanmaması için yazılmıştır.

---

## Etkilenen task'lar

| Task | Sonuç |
|---|---|
| [[T-078]] | **Kapanır** — "ayrım yok, bilinçli". Ölçüm bu ADR'de kayıtlı. |
| [[T-082]] | **Kapanır** — asimetri kusur değil, yönü doğru. |
| [[T-083]] | **Blokaj kalkar.** Ve iki vakası artık ayrı ayrı ele alınabilir. |

### T-083 hakkında bir ayrım

T-083 iki farklı vaka taşıyor ve bu ADR yalnız birini serbest bırakmıyor — **ikisini birbirinden
ayırıyor:**

1. **Planner'ın kasıtlı silmesi** — bu ADR'nin doğrudan konusu. Silme `null` üzerinden
   gelmeyecek. Ayrıca bu yetenek bugün **talep edilmemiştir**; gerekirse açık bir uç eklenir.
2. **Yetim anahtar** — admin bir mekaniği pasifleştirdiğinde diskte kalan anahtar. Plan her
   düzenlemede ve her submit'te 400 alır: **kalıcı kilit**, ve planner'ın yaptığı bir şeyden
   değil, admin'in yaptığından.

**İkincisi asıl aciliyettir ve bu ADR'yi hiç beklemiyordu** — çözümü `null` semantiğinden
bağımsızdır (recalc'in yetim anahtarı adıyla raporlayıp atlaması, veya mekanik pasifleştirmede
kullanımda olup olmadığının kontrolü). İkisini tek blokaja bağlamak, ikisini de gereksiz
bekletiyordu.

---

## Uygulama

Bu karar **davranış değiştirmez** — bugünkü davranışı onaylar ve gerekçelendirir. Uygulama
tümüyle kayıt düzeyindedir:

- `mechanic-input.ts`'teki "T-078 bunu ölçecek" ifadeleri bu ADR'ye referansla değiştirilir
- `update-fu-tactic.dto.ts`'e `null` = "değişiklik yok" kararı yazılır
- T-078 / T-082 kapatılır, T-083'ün blokajı kaldırılır ve iki vakası ayrılır

Davranış değişmediği için yeni test gerekmez; mevcut 673 unit + 256 e2e testi bu davranışı zaten
sabitliyor. **Değişen tek şey, davranışın artık kazara değil kararlı olması.**
