# 0006 — Lumpsum (götürü) harcamanın dağıtımı

**Tarih:** 2026-08-03
**Durum:** Kabul edildi (ürün sahibi)
**İlgili:** [[T-062]], [[T-056]] (bulunduğu yer), `docs/analysis/0001-kpi-parity-analysis.md`

---

## Bulgu

`MechanicCategory.LUMPSUM_SPEND` mekanikleri **tanınıyor** ve off-invoice'a yönlendiriliyor
(`spend-calculation.service.ts:474`), ama değerini üreten `calculateMechanicSpend` onlar için
**0 döndürüyor** (`:165-167`). Koddaki yorum "Will be handled in distributeSpendToSKUs" diyor;
o metot (`:226`) ise **yalnız spec dosyalarından** çağrılıyor, hiçbir üretim yolundan değil.

**Sonuç:** götürü harcama içeren bir plan, o harcamayı bütçeden **hiç düşürmüyor** ve SKU
seviyesindeki ROI/KPI onu görmüyor. Sessiz eksik rezervasyon.

Oturumun ana temasının sekizinci örneği: *mekanizma var, ona giden çağrı yok.*

## BRD kanıt durumu

BRD'de lumpsum dağıtımı için **açık formül yok**. Eldeki iki dolaylı dayanak:
- `.cursor/rules.md:79` — "FU level → Tactic (discount, lumpsum) girilir" → lumpsum **FU
  seviyesinde girilen** bir tutardır (seed'de `mechanicType: AMOUNT`, `unitSymbol: 'TRY'`).
- `docs/analysis/0001-kpi-parity-analysis.md:36` — "Set C (new-product null base): lumpsum null
  base'e **pay yok**" → SKU'lara **pay edilir** ve **null base** olan SKU pay almaz.

## Karar 1 — SKU'lara dağıtılır (yalnız FU toplamına eklenmez)

`distributeSpendToSKUs` üretim yoluna bağlanır. Hem bütçe toplamı hem SKU seviyesindeki ROI/KPI
düzelir.

**Gerekçe:** iki yol da aynı FU toplamını verir (yani bütçe eksik rezervasyonu ikisinde de
kapanır), fark SKU seviyesinde. SKU bazında kârlılık lumpsum'ı görmeden **yanlış** kalır; BRD'nin
"hesaplar dinamik formülden gelir" ilkesi rapor katmanında sessiz eksiklik bırakmayı desteklemez.

**Reddedilen:** yalnız FU toplamına ekleme (daha küçük ve düşük riskli, ama SKU ROI/KPI'sında
sessiz eksiklik bırakır ve dağıtımı ayrı task'a erteler).

## Karar 2 — Dağıtım tabanı: **base hacme göre orantılı**

**Gerekçe:** `0001`'in "null base'e pay yok" ifadesiyle birebir tutarlı **tek** okuma — taban base
ise null base olan SKU doğal olarak pay alamaz. Kanıt TTM parite analizinden geliyor.

**Reddedilenler:**
- *Planlanan hacme göre*: "null base'e pay yok" kuralını açıklamaz (planlanan hacmi olan yeni ürün
  pay alırdı) → mevcut tek kanıtla çelişir.
- *SKU'lara eşit bölme*: hacim büyüklüğünü yok sayar, ROI'yi çarpıtır, kanıtı yok.

## Uygulama kısıtı (bağlayıcı)

⚠️ **İki ayrı dağıtım implementasyonu var** ve bu, oturumun tekrar eden hata sınıfıdır:
- `spend-calculation.service.ts:226` `distributeSpendToSKUs` (üretimde çağrılmıyor)
- `spend-distribution.service.ts` (`DistributionMethod.LUMPSUM` dalı dahil; modüle kayıtlı ve
  `spend-calculation.controller.ts`'e enjekte — yani ayrı bir uçtan erişilebilir)

İkisi **birleştirilmeli veya sınırları netleştirilmeli**; iki ayrı doğruluk kaynağı bırakılmamalı
(tasarım 0008 §5.7; [[T-049]]/[[T-052]]/[[T-053]] dersleri). Hangi tarafın kanonik olacağı
**ölçülerek** karara bağlanmalı — varsayımla değil.

**Ayrıca:** `total === on + off` özdeşliği ([[T-056]] adım 4) bozulmamalı; lumpsum off-invoice
tarafına yazılır.

---

## ⚠️ SONRADAN ÖLÇÜLDÜ (2026-08-11) — bu ADR'nin "BRD kanıt durumu" öncülü **yanlış**

> **Bu bölüm kararı değiştirmez.** Karar ürün sahibinindir ve yürürlüktedir. Kaydedilen
> şey, kararın dayandığı **öncülün** ölçümle yanlışlanmış olmasıdır → [[T-202]].

Yukarıda *"BRD'de lumpsum dağıtımı için **açık formül yok**"* yazıyor. `docs/analysis/0067`
(okuma turu 44) ölçtü — **var**:

```
Section_05 §5.2:360-363
  Display Fee (Lumpsum):
  - Distributed to SKUs proportionally by PLANNED VOLUME
  - SKU_DisplayFee = FU_DisplayFee × (SKU_PlannedVol / FU_PlannedVol)
```

**Karar 2 `base volume` seçti; kaynak `planned volume` diyor.**

Neden görülmemişti: `§5.3:956-958` *"proportionally"* diyor ama **tabanı vermiyor**, ve
tabanı tanımlayan `§5.2` o tarihte `docs/analysis/0047`'de ⚪ *"gerekçeyle atla"*
işaretliydi. `0059`'un ölçüt değişikliği onu girer kovasına aldı.

⚠️ Ve Karar 2'nin gerekçesi (*"null base'e pay yok"*) planned-volume tabanında **geçersiz**:
`base = 0`, `planned > 0` olan yeni ürün SKU'su pay **alır** — ve `§5.6 Scenario 2` bunu
desteklenen bir senaryo olarak anlatıyor.

📌 Üçüncü sinyal: `§5.2`'nin **kendi kolon örneği** (1.667 / 2.133) **kendi formülünü**
(1.500 / 2.000) izlemiyor. Üç sinyal [[T-202]]'te tek tabloda toplanıyor.
