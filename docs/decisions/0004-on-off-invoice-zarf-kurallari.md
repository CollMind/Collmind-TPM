# ADR 0004 — On/Off-Invoice zarf ayrımı: NULL ve blok kuralları

- **Tarih:** 2026-08-02
- **Durum:** Kabul edildi
- **Karar veren:** Ürün sahibi
- **Tasarım:** `docs/analysis/0008-on-off-invoice-envelope-design.md`
- **İlgili:** [[T-019]] (uygulama), [[T-048]] (canlı hata)

## Bağlam
BRD (`.cursor/rules.md` §8): bütçe zarfı boyutları **Period / Channel / Category (opsiyonel)** ve
**"Ayrı ayrı: On-Invoice / Off-Invoice"**; eşikler **%80 Warning, %95 Critical, %100+ Exceeded (block)**.
Bugün `budget_envelopes`'ta bu ayrım yok; `reserveForPlan` tek `amount` alıyor.

Tasarım aşamasında iki nokta BRD'de karşılıksız çıktı ve ürün sahibine soruldu.

## Karar 1 — Agreement `spend_type` NULL ise: **400 ile reddet**
`agreements.spend_type` kolonu **zaten var** (enum, nullable; seed'deki 3 kaydın üçü de
`OFF_INVOICE`) ama **rezervasyonda hiç kullanılmıyor** (Team Lead doğruladı).

Bölünmüş zarf boyutunda `spend_type` **zorunlu**. NULL gelirse istek **400** ile reddedilir.

**Gerekçe:** varsayılan atamak (ör. "NULL → off-invoice") *sessizce yanlış zarfı tutturur*.
Bu oturumda tam bu sınıftan **7 hata** çıktı (kodun izlediğini iddia ettiği bir boyutu fiilen
taşımaması). Mevcut verinin tamamı dolu olduğu için kırılma riski düşük.

**Reddedilenler:** legacy zarfa yazmak (BRD'nin "ayrı ayrı" kuralı o kayıtlar için geçersiz kalırdı),
varsayılan `OFF_INVOICE` (varsayım üretir), mekanik kategorisinden türetmek (agreement'ın **açık**
`spend_type` alanını görmezden gelirdi).

> Not: **plan tarafında bu soru yok.** `spend-calculation.service.ts:424-505`
> `SpendingType.BOTH`'u `MechanicCategory` ile deterministik çözüyor (BOTH + ON_INVOICE_DISCOUNT →
> on-invoice; BOTH + diğer → off-invoice; tanınmayan kategori → uyar + atla). Bütçe katmanına gelen
> iki skaler BOTH içermez ve budget modülü bu kararı **yeniden uygulamaz**.

## Karar 2 — %100 aşımında: **herhangi biri aşarsa TÜM istek reddedilir** (atomik)
İki tipten biri bile eşiği aşıyorsa submit/approve **tamamen** reddedilir; kısmi rezervasyon
**oluşmaz**.

**Gerekçe:** yarım rezerve edilmiş plan, bu oturumda tekrar tekrar sorun çıkaran "yarım durum"
sınıfıdır ([[T-029]], [[T-030]], [[T-032]] kompanzasyonları). Atomiklik, yönetilmesi gereken bir
ara durumu tamamen ortadan kaldırır.

**Bedeli bilinçli kabul edildi:** off-invoice zarfı bol bütçeliyken on-invoice aşımı yüzünden plan
tümüyle bloklanır. Tasarımın önerisi ("yalnız aşan tip bloklanır") **reddedildi** — BRD'nin
"ayrı ayrı" ifadesi eşiklerin ayrı **değerlendirilmesini** gerektirir, ayrı ayrı **yazılmasını**
değil.

**Uygulama sonucu:** her iki tip de **yazımdan ÖNCE** kontrol edilmeli; biri bile aşıyorsa hiçbir
rezervasyon satırı yazılmaz.
