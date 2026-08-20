# BRD v2.0 — L1 · Yetenek Haritası

> **En son yazıldı, ve bilerek.** Yetenek haritası kuralların özeti gibi çalışır — 21 karar
> verilmeden yazılsaydı, üç bölümü yeniden yazmak gerekirdi.

- **Sürüm:** taslak, 2026-08-12
- **Kime:** ürünü anlamak isteyen herkes — ekip, danışman, müşteri, yeni katılan
- **Uzunluk:** ~15 sayfa
- **İlişki:** `L0` neden'i, bu katman **ne**'yi, `L2` **nasıl**'ı anlatır

---

## Bu belge nasıl okunur

Baştan sona okunabilir — `L2`'nin aksine. Bir yeteneğin **ne yaptığını** anlatır, kuralını
değil.

Bir kuralın tam metni gerektiğinde `L2`'ye atıf verilir (`K-2.3.11` gibi). Kural burada
**tekrar edilmez.**

**İşaretler:** ✅ çalışıyor · 🔶 kısmen · ❌ yok · ⛔ karar bekliyor

---

# 1.1 · Değer zinciri

Ürün altı halkalı bir zincirdir. **Her halka bir öncekinin çıktısını girdi alır**, ve her
adım defterde iz bırakır.

```
BÜTÇE  →  PLAN  →  ONAY  →  ANLAŞMA  →  GERÇEKLEŞEN  →  HAKEDİŞ  →  KAPANIŞ
```

| Halka | Girdi | Çıktı | Durum |
|---|---|---|---|
| Bütçe | Dönemsel tahsis | Zarflar | ✅ |
| Plan | Hacim + taktik | Beklenen harcama | ✅ |
| Onay | Plan | Bütçe taahhüdü | ✅ |
| Anlaşma | Onaylanmış plan **veya** doğrudan giriş | Yükümlülük | ✅ |
| Gerçekleşen | Satış verisi + fatura | Kanıt | 🔶 |
| Hakediş | Kanıt + karşı taraf talebi | Mutabık tutar | 🔶 |
| Kapanış | Mutabakat | Kapalı dönem | 🔶 |

**Son üç halka ürünün çekirdeğidir** (`L0 §1`) ve bugün yarısı eksiktir. Ayrıntı: `§1.7`.

## Planlama zorunlu bir aşama değildir

⚠️ **Ürünün iki çalışma biçimi yoktur.**

Her şey planla başlar. Geçmiş satış verisi olmayan durumlarda hacim alanı boş kalır, hacme
bağlı göstergeler hesaplanmaz, **akışın geri kalanı aynı yürür.**

Bir kurulumda planlama giriş yüzeyleri kapatılabilir — ama bu **yalnız bir görünürlük
tercihidir.** Hiçbir hesabı değiştirmez (`K-2.1.12i`).

> Bu, kaynağın modelinden bilinçli bir sapmadır. Kaynak üç katmanlı bir çalışma biçimi
> çözümleyicisi tanımlıyor; ölçüm gösterdi ki o rejimin belirlediği hiçbir finansal davranış
> kalmamıştır — her biri gerçek sahibine dağıtıldı (`K-2.1.12g`).

---

# 1.2 · Hiyerarşiler

İki eksen vardır ve **karıştırılmamalıdır.**

```
ÜRÜN           Marka → Kategori → Ürün Grubu → Tahmin Birimi (FU) → SKU
ORGANİZASYON   Kanal → Bölge → Müşteri
```

| | Ürün ekseni | Organizasyon ekseni |
|---|---|---|
| Neyi böler | Ne satılıyor | Kime, nereden satılıyor |
| Planlama | FU seviyesinde | Müşteri seviyesinde |
| Bütçe boyutu | Kategori | Kanal |
| Yetki kapsamı | Kategori | Kanal · Müşteri |

**Bölge** bir organizasyon eksenidir, mekanizması kuruludur, ama **bugün kullanılmıyor** ve
yetki kapsamına bağlı değildir (`K-2.6.7a`).

> ⚠️ Kaynak yetkiyi yalnız organizasyon ekseninde tanımlıyor. Kategori'nin yetki ekseni
> olarak korunması bilinçli bir sapmadır: **onay sorumluluğu kategori müdüründedir**, ve
> yetki ekseni onay sorumluluğunu izler (`K-2.6.7`).

---

# 1.3 · Planlama

## Ne yapar

Bir kategori müdürü, bir dönem için hangi ürün grubuna hangi taktikleri uygulayacağını ve ne
kadar hacim beklediğini girer. Sistem harcamayı ve beklenen getiriyi hesaplar.

## Nasıl çalışır

**Giriş Tahmin Birimi (FU) seviyesindedir** — hem taktik hem hacim.

SKU seviyesi **türetilir**: hacim geçmiş paya göre dağıtılır, taktik her SKU'nun kendi
cirosuna uygulanır.

```
FU: 500ml Şampuan     hacim 10.000    taktik %10 indirim
     ↓ dağıtım                          ↓ uygulama
SKU A  (geçmiş pay %36)   3.600         kendi cirosunun %10'u
SKU B  (geçmiş pay %48)   4.800         kendi cirosunun %10'u
SKU C  (yeni ürün)            0  ⚑      elle girilir
```

**Yeni ürün sıfır pay alır ve işaretlenir** — sistem lansman hacmini tahmin etmez, çünkü o
bir ticari karardır (`K-2.1.8b`).

**Her hücre elle düzeltilebilir**; düzeltilen hücre kilitlenir ve kalan miktar yeniden
dağıtılır. FU toplamı her an korunur.

## Ne göstermeli

⚠️ **Dağıtımın görünürlüğü bu yeteneğin parçasıdır** (`K-2.1.8i`).

Kullanıcı FU'ya girdiği değerin nereye nasıl indiğini görmelidir — yoksa güvenmez, ve tabloya
döner.

## Durum

| | |
|---|---|
| Taktik girişi ve uygulaması | ✅ hesap tarafı çalışıyor |
| Taktik değerinin ekrana dönmesi | ❌ **kırık** |
| FU seviyesinde hacim girişi | ❌ bugün SKU'da |
| Dağıtım ve miras gösterimi | ❌ |

---

# 1.4 · Bütçe

## Ne yapar

Bütçeyi zarflara böler, planlar onaylandıkça taahhüt eder, gerçekleşme oldukça tüketir, ve
her hareketi deftere yazar.

## Zarf ve kovalar

```
Zarf boyutu:   Kanal × Kategori × Dönem
```

Dört kova:

| Kova | Ne zaman dolar |
|---|---|
| Ayrılan | Zarf tanımlandığında |
| Rezerve | Bir **anlaşma** onaylandığında |
| Taahhüt | Bir **plan** onaylandığında |
| Tüketilen | Gerçekleşen fatura kaydedildiğinde |

**Rezerve ve Taahhüt ayrı kovalardır** ve birleştirilemez (`K-2.2.6`) — *"bu zarfın ne kadarı
plandan, ne kadarı anlaşmadan"* sorusu cevaplanabilir olmalıdır.

## İki merdiven

⚠️ Eşikler **iki ayrı merdivendir** ve karıştırılmaz:

| | Değerler | Ne yapar |
|---|---|---|
| **Davranış** | %80 · %90 · %100 | Uyarı · Finans bildirimi · Blok |
| **Renk** | <80 · 80–95 · >95 | Yalnız görünüm |

`%90` kademesi Faz 1'de **bildirimdir**; onay kapısına dönüşmesi bir konfigürasyondur ve
varsayılan değildir (`K-2.2.7b`).

> Gerekçe: dönem ortasında durduran bir onay kapısı, en yoğun haftada sürtünme üretir ve ya
> atlanır ya nefret edilir. Finansın istediği çoğunlukla onay yetkisi değil, **haberdar
> olmak.**

## Blok ve kaçış

`%100` bloğu **istisnasızdır** — bir geçersiz kılma yolu yoktur.

Ama iki meşru kaçış vardır:

```
Zarf revizyonu   finans zarfı büyütür         (denetlenebilir)
Transfer         başka bir zarftan aktarır    (atomik, Σ = 0)
```

> Toplam bütçe gerçek hayatta sabittir — para bir yerden gelir. Transfer bu gerçeğin
> mekanizmasıdır (`K-2.2.9j`).

## ⚠️ Eşikler hakedişi durduramaz

**Bütçe eşikleri yalnız plan ve taahhüt tarafına uygulanır.** Gerçekleşen bir hakediş hiçbir
eşiğe takılmaz — **borç doğmuştur** (`K-2.2.7c`).

Aşım kaydedilir, işaretlenir, raporlanır; süreç durmaz.

## Durum

Zarf modeli ✅ · rezervasyon ✅ · eşzamanlılık koruması ✅ · eşik davranışı 🔶 · transfer ❌ ·
politika tablosu ❌

---

# 1.5 · Onay

## Ne yapar

Bir planın veya anlaşmanın yürürlüğe girmeden önce yetkili bir kişi tarafından
onaylanmasını sağlar, ve kararı iziyle birlikte saklar.

## İki ayrı sistem

⚠️ Bunlar farklı sorular sorar ve karıştırılmamalıdır:

| Sistem | Sorusu |
|---|---|
| **Onay motoru** | Bu varlık onaydan geçmeli mi, kimden? |
| **Bütçe politikası** | Bu harcama zarf kullanımı nedeniyle ek onay gerektiriyor mu? |

## Politika ve şablonlar

Onay akışı bir **tabloda** yaşar ve **üç görüşlü şablonla** doğar:

| Şablon | Akış |
|---|---|
| Standart *(varsayılan)* | Kategori müdürü onaylar; bütçe aşımı finansa yükselir |
| Çift kademe | Her plan kategori müdürü + finans |
| Eşikli | Tutar altında tek onay, üstünde finans eklenir |

**Tenant şablon seçer ve eşik ayarlar — kural yazmaz** (`K-2.5.13c`).

> Serbest biçimli bir kural motoru bu segmentte aşırı mühendisliktir: ilk müşteride kimsenin
> doldurmayacağı boş bir editör demek.

## Görev ayrılığı

⚠️ **Hiç kimse kendi gönderdiği veya son değiştirdiği bir planı onaylayamaz** — istisnasız
(`K-2.5.11`).

Ve kural **kişiye bakar, role değil.** Çift rollü bir kullanıcı kendi planını finans sıfatıyla
da onaylayamaz.

İki senaryo istisnayla değil, mekanizmayla çözülür:

```
Tek kişilik ekip   → kurulum kuralı: en az iki onay yetkili kullanıcı
Sahipsiz plan      → devir mekanizması (Faz 2); Faz 1'de başka yetkili onaylar
```

## Gecikme

Cevapsız kalan bir onay Faz 1'de **otomatik durum değiştirmez** — yalnız bildirim üretir
(7. gün hatırlatma, 14. gün yöneticiye).

> Planlar bayram, dönem kapanışı, fuar haftası gibi sebeplerle meşru olarak gecikir. Otomatik
> süre dolumu **toplu plan ölümü** üretir — çözdüğü sorundan büyük gürültü.

⚠️ **Otomatik yükseltme reddedildi:** kimsenin vermediği bir onay kararını zamanlayıcıya
verdirir (`K-2.5.10c`).

## Durum

Durum makinesi ✅ · görev ayrılığı ✅ · politika tablosu ❌ · gecikme bildirimi ❌ · devir ❌

---

# 1.6 · Göstergeler

## Ne yapar

Her plan ve anlaşma için harcama, kârlılık ve artımsallık göstergelerini hesaplar; renkle
özetler.

## Formüller konfigürasyondadır

Göstergeler kodda gömülü değil, **tanımlı formüllerle** hesaplanır. Yönetici bir formülü
değiştirebilir.

Formül değerlendirmesi **sunucuda** yapılır ve kaydedilirken doğrulanır (`K-2.4.24`,
`K-2.4.26`).

## Eksik veri

⚠️ **Bir bağımlılık eksikse sonuç boş döner, sıfır değil** (`K-2.4.4`).

> Kaynağın motor sözde-kodu eksik bağımlılığa `0` atıyor. Bu, maliyeti olmayan bir ürünü
> *"maliyetsiz kâr"* gibi hesaplar. Bugünkü veriyle (170 üründen 166'sında maliyet yok)
> planların neredeyse tamamı **yanlış yeşil** görünürdü.
>
> Bu, kaynaktan bilinçli bir sapmadır.

Ve koruma **motorda** uygulanır, her formülde değil — formül yazarının disiplinine bağlı bir
koruma unutulabilir.

## Toplama ve kapsama

Oran göstergeleri üst seviyelere **pay ve payda ayrı toplanarak** taşınır — alt oranların
ortalaması alınmaz (`K-2.4.19`).

Ve toplama **tüm bağımlılıkların çözüldüğü kesişim** üzerinden yapılır: bir öğenin bir
bağımlılığı eksikse, o öğe hem paydan hem paydadan düşer.

## Dört durum

⚠️ Renk üçlü değil, **dörtlüdür:**

| Durum | Ne zaman | Ne gösterilir |
|---|---|---|
| Yeşil / Sarı / Kırmızı | Tam kapsama | Değer + renk |
| **Gri** — *"hesaplanamadı"* | Kısmi kapsama | Değer + kapsama oranı + eksik listesi |

**Kapsama eşiği yoktur.** Kısmi kapsama kısmi doğruluk değil, **bilinmeyen yönde
yanlılıktır** — maliyeti eksik ürünler tipik olarak yeni ürünlerdir ve sistematik olarak
farklı marj taşırlar (`K-2.4.22`).

> **Renk bir güven beyanıdır, ve güven beyanı kısmi olamaz.**

## Veri olgunluğu kademeleri

Göstergeler veri geldikçe açılır:

| Kademe | Ön koşul | Açılan |
|---|---|---|
| Harcama & Mutabakat | — | Bütçe kontrolü, hakediş, plan-gerçekleşen |
| + Kârlılık | SKU maliyeti | Marj, brüt kâr |
| + Artımsallık | Geçmiş satış hacmi | Lift, kârlılık oranı |

Bir kademenin açılması **tenant kararıdır**, otomatik bir eşik değil (`K-2.7.11`).

## Durum

Formül motoru ✅ · eksik veri davranışı ✅ · toplama ✅ · kapsama oranının gösterimi ❌ ·
formül doğrulamasının çağrılması ❌ · finans yolunda gri→yeşil sızıntısı ❌

---

# 1.7 · Gerçekleşen ve hakediş

> **Ürünün çekirdeği** (`L0 §1`). Ve bugün en eksik parçası.

## Ne yapar

Bir anlaşmadan doğan yükümlülüğü hesaplar, karşı tarafın talebiyle karşılaştırır, farkı
mutabakata bağlar, ve dönemi kapatır.

## Zincir

```
Talep üretimi  →  Talep alımı  →  Eşleştirme  →  Mutabakat  →  Kapanış
   (biz)           (karşı taraf)                   (fark)      (dönem/anlaşma)
```

## Gerçekleşme kanıttan gelir

⚠️ **Taktik gerçekleşmesi dış talepten türetilmez.** Dış talep bir **doğrulamadır**, bir veri
kaynağı değil (`K-2.13.14e`).

Her mekanik bir **kanıt sınıfı** taşır:

| Sınıf | Nasıl hesaplanır |
|---|---|
| Gözlenen | Satır satır kayıtta var (fatura-içi indirim) |
| Türetilebilir | Oran × gerçekleşen hacim (birim başı destek) |
| Sözleşmesel | Dönem koşulu sağlandıysa tamamı doğar (götürü raf kirası) |

> Bu, *"gelen toplamı taktiklere nasıl bölüştürürüz"* sorusunu ortadan kaldırır — o soru
> yanlış kurulmuştu, çünkü dış talebi doğruluk kaynağı sayıyordu.

**Oran bazlı mekaniklerin tabanı net satıştır** (varsayılan; mekanik tanımında bir alan).
Brüt taban çifte sayım üretir ve karşı tarafın hesabıyla uyuşmaz (`K-2.13.14h3`).

## Talep tek varlıktır

İç talep (biz üretiriz) ve dış talep (karşı taraf gönderir) **tek bir kayıt türüdür**; ayrım
bir alandır.

> İkisi **aynı ekonomik olayın iki taraftaki görünümüdür.** Ayrı varlık yapmak, eşleştirme
> için bir normalize katmanı gerektirir — ve o katman fiilen ortak talep modelidir.

Ama **eşleştirme ayrı bir bağ varlığıdır:** bir dış kesinti birden çok iç talebe — ya da
hiçbirine — denk düşebilir.

## Eşleştirme

Üç kademeli:

```
1  karşı taraf referansı varsa              → doğrudan
2  dönem + müşteri + kategori + kanal       → aday kümesi
3  eşleşmeyen                               → kuyruk
```

⚠️ **Otomatik kesinleşme tekillik ister.** Birden çok aday varsa sistem **seçim yapmaz** —
kuyruğa adaylarıyla birlikte düşer.

> **Yanlış eşleşme, eşleşmemekten pahalıdır:** eşleşmeyen talep kuyrukta görünür, yanlış
> eşleşen talep dönem kapanışına gömülür.

**Tolerans ikili bir eşiktir** (oran ve mutlak, küçük olan bağlar) ve dar başlar. Tolerans
içi fark **yok olmaz, deftere ayrı bir kalem olarak yazılır.**

## Fark

Açıklanamayan kalıntı **hiçbir taktiğe dağıtılmaz.** Açık bir `FARK` kalemi olarak durur.

```
Σ(taktik gerçekleşmeleri) + FARK = dış talep tutarı
```

> Orantısal dağıtım reddedildi: bir `%96` çarpanı üç taktiğe de *"gerçekleşti"* damgası vurur
> ve **hassas görünen çöp** üretir.

## Tahakkuk

Dönemsel kadanslı anlaşmalar aylık **tahakkuk** eder — ve bu **operasyonel** bir tahakkuktur,
muhasebe kaydı değil.

| Soru | Sahibi |
|---|---|
| *"Muhasebeye ne yazılmalı?"* | ERP |
| *"Karşı taraf dönem sonunda ne kesecek?"* | **Biz** |

İkincisi mutabakatın kendisidir. Sistem bir **tahakkuk raporu** verir; yevmiye kaydını
muhasebe o rapordan atar (`K-2.13.25e`).

## Kapanış

İki kapanış vardır ve karıştırılmaz:

```
Anlaşma kapanışı   bir anlaşmanın yaşam döngüsü
Dönem kapanışı     bir muhasebe döneminin hareketleri
```

Kapanışta kalan bakiye **serbest bırakılır**, yeni döneme taşınmaz (`K-2.2.9r`).

## Durum

| Parça | |
|---|---|
| Talep üretimi | ✅ dört uç, canlı arayüz |
| Anlaşma kapanışı | ✅ olgun — ama **hiçbir ekrandan çağrılamıyor** |
| Talep alımı | 🔶 tek yönlü — bizim kaydımız giriyor, karşı tarafın talebi değil |
| Talep nesnesi | ❌ |
| Karşı taraf perspektifi | ❌ |
| Eşleştirme | ❌ kullanıcı elle giriyor |
| Mutabakat | ❌ |
| Dönem kapanışı | ❌ |
| Tahakkuk | ❌ şema hazır, davranış yok |

---

# 1.8 · Veri ve entegrasyon

## Sahiplik

Her verinin **tek bir sahip sistemi** vardır. Ürün sahibi olmadığı veriyi okur, **üzerine
yazmaz.**

```
ERP'den gelir:   ürün ağacı · müşteri · fiyat · maliyet · gerçekleşen satış
Bizde doğar:     plan · taktik · anlaşma · bütçe · hakediş · defter
```

## İçe aktarma

Üç adımlı: **yükle → doğrula → onayla.**

Doğrulama **satır bazındadır**: geçerli satırlar yazılır, geçersizler reddedilir ve
raporlanır. Dosyanın tümü yalnız hiçbir satır geçerli değilse reddedilir (`K-2.8.7`).

⚠️ **Belirsiz biçimler tahmin edilmez, reddedilir:**

```
1.234      belirsiz — ondalık mı binlik mi?     → hata
3/4/26     belirsiz — 3 Nisan mı 4 Mart mı?     → hata
1.234,56   açık                                  → kabul
```

> Yanlış bir tahmin, **doğru görünen yanlış bir değerdir.** Ölçüldü: tahmin eden bir
> ayrıştırıcı `1.000,00`'ı `1` olarak okuyordu.

## Tek birim

Sistemde **tek bir hacim birimi** vardır: adet. Çevrim yalnız içe aktarma sınırında yapılır,
ve çekirdek tablolarda birim alanı **hiç yoktur.**

> **En iyi doğrulama, doğrulanacak alanın olmamasıdır.**

## Bayat veri

Kaynak sistem erişilemezse ürün son bilinen veriyle çalışır — ama bunu **söyler**, verinin
yaşıyla birlikte.

## Tablo köprüsü

Elektronik tabloya kopyala-yapıştır **birinci sınıf bir özelliktir**, bir kaçış yolu değil.

> Sektörde kullanıcıların büyük çoğunluğu ürünü tabloyla tamamlıyor. Engellemek yerine yolunu
> açmak geçişi kolaylaştırır.

## Durum

Dosya içe aktarma ✅ · sayı/tarih grameri ✅ · ERP entegrasyonu ❌ · dosya arşivi ❌ · birim
çevrimi ❌

---

# 1.9 · Yetki ve izolasyon

## İki katman

Bir işlem, **her ikisi** sağlandığında gerçekleşir:

```
Yetenek   kullanıcı bu işlemi yapabilir mi?
Kapsam    kullanıcı bu kaydı görebilir mi?
```

## Roller

Yetkiler **yetenek** olarak tanımlanır; roller yetenek kümeleridir. Bir kullanıcı **birden
çok rol** taşıyabilir ve etkin yetkisi rollerinin birleşimidir.

⚠️ Ama **görev ayrılığı kişiye bakar, role değil** — çift rollü bir kullanıcı kendi planını
onaylayamaz (`K-2.6.5c`).

**Kişiye özel yetki istisnası yoktur.** Yetki eksikliği rol atamasıyla çözülür.

> Kişi bazlı bir delik, *"yetki modeliniz nedir"* sorusuna **"tablo + kişiye özel delikler"**
> cevabı verdirir.

## Kapsam

Üç eksende: **kanal · müşteri · kategori.**

**Boş kapsam = erişim yok.** Tüm veriye erişim açık bir joker atamasıyla verilir.

## İzolasyon

Her kayıt hangi müşteriye ait olduğunu taşır, ve izolasyon **iki katmanda** korunur:
uygulama filtresi **ve** veritabanı seviyesinde zorlama.

⚠️ **Ve bu ertelenebilir değildir:** hakediş bir finansal işlemdir ve finansal kontrol
denetimi sektörde bir **satın alma kriteridir.** İzolasyon *"ikinci müşteri kapısı"* değil,
**ilk kurumsal satışın ön koşuludur** (`K-2.6.12`).

## Durum

Kapsam katmanı 🔶 · yetenek katmanı ❌ · çok rollülük ❌ · veritabanı izolasyonu ❌ ·
kapsam filtresi ❌ *(kapalı — bir planlamacı tüm veriyi görüyor)*

---

# 1.10 · Raporlama

## Sınır

Ürün bir **veri ambarı değildir** — ama raporlaması zayıf da değildir.

| | Bizim işimiz | BI aracının işi |
|---|---|---|
| Amaç | Ticari harcama kararı | Serbest keşif |
| Veri | Kendi verimiz + ticari bağlam | Kurumsal tüm veri |
| Şekil | Tanımlı, standart | Ad-hoc, boyut serbest |

**Satış verisi bizde ve planlamanın girdisidir.** Onu derinlemesine kullanmak veri ambarı
olmak değil — ürünün asıl işi.

## Standart raporlar

Sekiz tanımlı rapor: plan performansı · kârlılık dağılımı · harcama kırılımı · bütçe
kullanımı · anlaşma durumu · planlamacı performansı · nakit akışı projeksiyonu · fark analizi.

## Dağıtım rapor katmanındadır

⚠️ Götürü harcamanın SKU'lara dağıtımı bir **rapor hesabıdır**, deftere yazılmaz.

Taban **planlanan hacimdir**, ve dönem kapanışında donar (`K-2.4.17`).

> Geçmiş hacim tabanı **iki yönlü bozulma** üretirdi: yeni ürün pay almaz, ve lansman maliyeti
> eski ürünlerin sırtına biner.

## Durum

❌ **Menüde beş rapor adı görünüyor, hiçbiri çalışmıyor.** Karar destek katmanı,
konumlanmanın gerektirdiği seviyenin çok altında.

---

# 1.11 · Denetim ve uyum

## Denetim kaydı

Sistemde yapılan **her anlamlı işlem** kaydedilir: kim, ne zaman, neye dayanarak.

Kapsam yönetici işlemleriyle sınırlı değildir — plan yaşam döngüsü, bütçe hareketleri,
anlaşma değişiklikleri, veri işlemleri, erişim, konfigürasyon.

⚠️ Bir onay kaydı **karar anındaki göstergeleri** de taşır — çünkü göstergeler sonradan
yeniden hesaplanır (`K-2.11.5`).

Denetim kaydı **değiştirilemez ve silinemez**, ve bu veritabanı seviyesinde korunur.

## Saklama

| Kayıt | Süre |
|---|---|
| Anlaşma · fatura · defter · denetim | 7 yıl |
| Onaylanmış plan · geçmiş satış | 5 yıl |
| İçe aktarılan dosya | 90 gün |
| Dışa aktarılan çıktı | 7 gün |

⏸️ **Bu tablo bugün ASKIDA** (`K-2.9.0`, 2026-08-12): hukuki mütalaa gelene dek **hiçbir
kayıt silinmez** — `90 gün` ve `7 gün` satırları dahil. Ve `7 yıl` rakamının kaynağı yerel
bir mevzuata atıf vermiyor; gerekçe ve ölçüm `L2_03 §2.9`'da.

⚠️ **Bugün bu kural kazara sağlanıyor** — hiçbir şey silinmiyor çünkü silme mekanizması yok.

> **Kazara sağlanan bir kural korunmuyor demektir.** Bir temizlik işi eklendiği gün sessizce
> ihlal edilir, ve hiçbir test yakalamaz — çünkü ihlali bir kod değişikliği değil, bir **veri
> işlemi** tetikler.

## Durum

Denetim kaydı 🔶 *(yönetici odaklı, olay sözlüğü yok)* · değişmezlik koruması ❌ ·
saklama otomasyonu ❌ · anonimleştirme ⛔ *ölçülmedi*

---

# 1.12 · Yapay zeka sınırı

Ürün **analitik yapay zekayı reddeder, kenar yapay zekayı benimser.**

| | Reddedilen | Benimsenen |
|---|---|---|
| Ne | Lift tahmini, senaryo optimizasyonu | Belge okuma, açıklama, kurulum asistanı |
| Neden | Beslenecek veri hedef segmentte yok | Tarihsel veri gerektirmez, ilk günden çalışır |

## Sınır

⚠️ **Dil modeli asla para hesaplamaz.** Hesaplayan deterministik motordur; yapay zeka
**önerir**, insan onaylar, defter deterministik yazılır (`K-2.4.28`).

Ve sıralama bağlayıcıdır: **önce izolasyon, sonra asistan.** Bir asistan, onu çağıran
kullanıcının göremediği veriyi göremez.

## Üç kenar

| Kenar | Ne yapar | Ne yapmaz |
|---|---|---|
| Alım asistanı | Dış hakediş belgesini yapıya çevirir | Tutarı hesaplamaz |
| Açıklama katmanı | *"Bu rakam neden böyle"* — denetim izinden | Rakamı yeniden hesaplamaz |
| Kurulum asistanı | Mevcut veriden konfigürasyon önerir | Yürürlüğe koymaz |

## Durum

❌ Hiçbiri yok. Sınır kuralları yazıldı; uygulama izolasyon katmanının arkasında.

---

# 1.13 · Kurulum

## Ne yapar

Yeni bir kurulumu **çalışır durumda** teslim eder — boş bir kabuk olarak değil.

## Başlangıç paketi

Hazır gelir: mekanik kütüphanesi · gösterge tanımları · onay şablonları · rapor seti ·
varsayılan eşikler · rol tanımları.

**Bu bir örnek değil, çalışan bir varsayılandır** — müşteri değiştirmeden kullanabilmelidir.

## Zorunlu adımlar

Kurulumda atlanamayan adımlar açıkça listelidir, ve **bir adımın zorunlu olması için tek
geçerli gerekçe: varsayılanı olamaz** (`K-2.14.5`).

```
Zorunlu:      ürün ağacı · müşteri listesi    (müşteriye özgü, varsayılanı olamaz)
Zorunlu değil: eşikler · onay şablonu · roller  (görüşlü varsayılan var)
```

## Ölçüt

**Boş bir kurulumdan ilk onaylanmış plana ≤ 1 iş günü.**

Hedef doğrulanmadı — ilk gerçek kurulumda ölçülecek. Tutmazsa **hedef revize edilir, ölçüt
değil.**

## Durum

❌ Başlangıç paketi tanımlanmadı, kurulum akışı yok, ölçüm yapılmadı.

---

# 1.14 · Faz kapsamı

## Bugün nerede duruyoruz

⚠️ **Ürün, kaynağın öngördüğü fazın önündedir ve tabanının gerisindedir.**

| | Kaynak Faz 1'de ne diyor | Bizde |
|---|---|---|
| Planlama modu | ❌ sonraki faz | ✅ var |
| Gösterge motoru | ❌ sonraki faz | ✅ var |
| Veritabanı izolasyonu | ✅ Faz 1 | ❌ yok |
| Yetenek tabanlı yetki | ✅ Faz 1 | ❌ yok |
| Konfigürasyon tabloları | ✅ Faz 1 | ❌ yok |
| Denetim olay sözlüğü | ✅ Faz 1 | ❌ eksik |

Yani Faz 2 yetenekleri inşa edilirken Faz 1 tabanı atlanmış.

## Sıralama

Ölçüm bir bağımlılık gösterdi: **Faz 2'nin eksik yarısı, Faz 1 tabanının üstünde duruyor.**
Kârlılık tabanlı onay politikaları politika tablosunu, baseline zorlaması veri modelini
gerektiriyor.

Yani *"önce taban"* bir tercih değil — Faz 2'nin de ön koşulu.

## Bu sürümde olmayanlar

```
Devir (carry-forward)          bir sonraki faz
Onay politikası kural yazımı   kanıtlanmış desen gelince
Otomatik zaman aşımı           ölçüm sonrası
Senaryo analizi                veri olgunluğu kademesi 3
Bölge ekseni                   saha örgütlü müşteri gelince
Muhasebe tahakkuku             hiçbir faz — ERP'nin işi
```

---

# Açık kalanlar

> ⚠️ **Bu tablo bir KOPYADIR ve 2026-08-13'te bayat yakalandı** — üç satırı kapanmıştı ve
> burada açık görünüyordu. Kanonik liste `04_KARAR_KAYDI.md §Hâlâ açık`; guard bunu
> **görmüyor** (`L2` kural kimliklerine bakıyor, `L1` metnine değil).

| Konu | Bekliyor |
|---|---|
| ~~Rol kümesi~~ | ✅ **kapandı** 2026-08-12 → `K-2.6.4` ailesi |
| ~~Finans yöneticisinin onay hattı~~ | ✅ **kapandı** 2026-08-12 → `K-2.5.12` ailesi · `ADR 0002-R` |
| Saklama sürelerinin bağlayıcılığı | Hukuk — ⏸️ `K-2.9.0` askısı altında |
| ~~Kişi bazlı raporlama~~ | ✅ **kapandı** 2026-08-12 → `K-2.9.6` (süreç metriği) |
| Veri ayrımı modeli | Teknik ölçüm |
| İadenin veri temsili | Teknik ölçüm — ⚠️ `C2` ölçüldü: temsil **yok**, kanal **açık** ([[T-208]]) |

---

# Kaynak notu

Bu belge `L2`'nin özetidir ve **on dört bölümünün her biri** oradaki kurallara atıf verir.

Üç bölümün kaynakta karşılığı **yoktur** ve bu bilinçlidir: `§1.7` (hakediş) kaynağın on bir
kapsam listesinin hiçbirinde geçmiyor · `§1.12` (yapay zeka sınırı) ve `§1.13` (kurulum)
konumlanmadan türedi.

> **Sıfırdan yazmak, sıfırdan düşünmektir** — ve bu üç bölüm o farkın kanıtı.
