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

---

## Karar 2 — kapsam netleştirmesi (2026-08-02, T-019b öncesi)
T-019b hazırlığında Karar 2'nin lafzı ("yalnız aşan tip bloklanır → reddedildi") tasarım §8 Q4 ile
çelişiyor göründü. Ürün sahibi netleştirdi: **ikisi farklı durumdur, ikisi de geçerlidir.**

Atomiklik kuralı **isteğin KENDİ tutarlarına** uygulanır:
- Plan **hem on hem off** harcıyor ve bunlardan biri eşiği aşıyor → istek **tümüyle** reddedilir,
  kısmi rezervasyon oluşmaz. **Karar 2 aynen geçerli, değişmedi.**
- Plan **yalnız tek tip** harcıyor (diğer tutar 0) → yalnız o tipin zarfı değerlendirilir.
  Harcamadığı tipin zarfının dolu/aşılmış olması o planı **bloklamaz**.

**Gerekçe:** sıfır tutarlı bir rezervasyonun dolu bir zarfa karşı ölçülmesi anlamsızdır; plan o
zarfla hiçbir alışverişe girmez. BRD'nin "ayrı ayrı değerlendirilir" ifadesi bu okumayı destekler.
Karar 2'nin kaçındığı şey **yarım rezerve edilmiş plan** durumudur ([[T-029]]/[[T-030]]/[[T-032]]
sınıfı) — tek tipli bir planda böyle bir ara durum zaten oluşamaz.

**Uygulama sonucu (§5.6):** eşik değerlendirmesi, planın **fiilen harcadığı** tipler kümesi
üzerinden yapılır. Harcanan tiplerden biri bile aşıyorsa hiçbir satır yazılmaz.

Bu, tasarım §8 **Q4'ü kapatır**.

## Karar 3 — BOTH agreement, SPLIT EDİLMİŞ boyutta: **400 ile reddedilir** (§8 Q2)
`agreements.spend_type = BOTH` (veya NULL) bir agreement, split edilmiş bir boyuta rezerve
edilmek istendiğinde `400 AGREEMENT_SPEND_TYPE_SPLIT_REQUIRED` döner. UNSPLIT boyutta **bugünkü
davranış korunur** (değişiklik yok).

**Gerekçe:** BRD'de BOTH kavramı hiç geçmiyor ve cap'in on/off kırılımı yok. Cap'in bir kısmını
rastgele/orantısal bir zarfa koymak **sessiz mis-attribution** üretir — bu oturumun tekrar eden
hata sınıfı. Operatör agreement'ı tipli hale getirmeye zorlanır.

**Reddedilenler:** cap'i orantılı bölmek (uydurma varsayım); agreement'a
`cap_on_invoice_amount`/`cap_off_invoice_amount` kolonları eklemek (BRD dayanağı yok, migration +
yeni veri giriş UI'ı gerektirir — gerekirse ayrı task).

## Karar 4 — T-019b kapsamı: **split ucu + re-home**
Faz 2 tek oturumda doğrulanabilir büyüklükte tutulur: `POST /budget/envelopes/:id/split`,
append-only re-home, `UNTYPED_ENCUMBRANCE_PRESENT` guard, §5.5 tip bazlı `checkBudgetAvailability`.
Seed 4→8 zarf ([[T-054]]) ve `unsplit` geri alma ucu ([[T-055]]) **ayrı task'lara** bırakıldı.

**Gerekçe (seed):** tasarım §4, seed değişikliğinin yalnız temiz DB (`db:reset` + `seed`) ile
gidebileceğini söylüyor; kirli DB'de ikinci bir 75.000'lik rezervasyon üretir. Bu, T-047
invaryantının 3-ardışık-koşum doğrulama zeminini bozar → ayrı, izole edilmiş task.

## Karar 5 — bölünmüş boyutta tipsiz çözüm: **guard ile gürültülü hata** (2026-08-02)
[[T-019b]] split ucunu eklerken, `findEnvelopeByDimensions`'ı `spendType` vermeden çağıran 5 yer
tespit edildi (`plan.service.ts:810/910/1019`, `agreement-transaction.service.ts:142`,
`on-invoice.service.ts:439`). Bölünmüş bir boyutta bunlar iki tipli satır arasında **rastgele**
seçim yapardı — sessiz mis-attribution.

**Karar:** bölünmüş boyutta tipsiz çözüm denenirse `SPEND_TYPE_REQUIRED_FOR_SPLIT_DIMENSION` ile
**açık hata** fırlatılır. Gerçek göç [[T-056]]'ya bırakıldı.

**Gerekçe:** sessiz yanlış atıf, bu oturumda yedi kez tekrarlanan hata sınıfıdır; gürültülü hata
yapısal olarak onu imkânsız kılar. Bedeli bilinçli kabul edildi: **[[T-056]] kapanana kadar
`POST /budget/envelopes/:id/split` üretimde kullanılmamalıdır.** Bugün hiçbir zarf bölünmüş
olmadığı için mevcut davranış hiç etkilenmez.

**Reddedilenler:** T-019b'yi 5 çağrı yerini kapsayacak şekilde genişletmek (`plan.service.ts:810`
canlı UI rotası — legacy tek-tutar rezervasyonunun tipli dünyaya eşlenmesi başlı başına tasarım
kararı, tek oturumda doğrulanamaz); riski yalnız belgeleyip kodu olduğu gibi bırakmak (split
çağrıldığı anda sessiz mis-attribution başlardı).
