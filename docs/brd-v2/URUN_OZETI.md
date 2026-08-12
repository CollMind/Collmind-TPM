# CollMind TPM — Ürün Özeti

- **Tarih:** 2026-08-11
- **Kime:** herkes — danışman, yeni ekip üyesi, müşteri, yatırımcı
- **Uzunluk:** ~5 sayfa. Teknik terim yok.

---

## Bir çerçeve notu

Bu doküman bir **ürünü** anlatıyor, bir müşteri uygulamasını değil. Yürütülen saha pilotu
bir doğrulama vakasıydı; oradan çıkan kararlar bir müşteri profili olarak ayrı tutuluyor.

Ve ürün **çok müşterili** olarak tasarlandı — ilk müşterinin bir süre tek başına çalışacak
olması bir konuşlandırma gerçeği, mimari bir kısıt değil. Bu ayrım planlamayı doğrudan
etkiliyor: bazı korumalar mimaride zorunlu ama uygulanması ikinci müşteriye kadar
bekleyebilir.

---

## Ürün ne yapıyor

**CollMind TPM, bir FMCG üreticisinin perakendeciye verdiği ticari desteği baştan sona
yöneten bir sistemdir.**

"Ticari destek" burada şu anlama geliyor: bir şampuan üreticisi bir zincir markete ürününü
sattırmak için indirim verir, raf kirası öder, insert bastırır, aktivasyon yapar. Bu
harcamalar bir FMCG şirketinin **ikinci en büyük gider kalemidir** — genelde cironun %10-20'si.

Ve çoğu şirkette Excel'de yönetilir.

Sistemin çözdüğü problem üç aşamalı:

```
PLANLA        Hangi ürüne, hangi müşteride, ne zaman, ne kadar destek verilecek?
              Bütçeye sığıyor mu? Getirisi ne olacak?

ONAYLA        Kim onaylıyor, hangi eşikte kimin onayı gerekiyor?
              Bütçe gerçekten ayrıldı mı?

KAPAT         Ne kadarı gerçekleşti? Fatura geldi mi, tutuyor mu?
              Hangi destek işe yaradı?
```

Bugün sistem **birinci ve ikinci aşamayı** yapıyor. Üçüncü aşama henüz yok — bu, dokümanın
son bölümünde ayrıntılı.

---

## Kime, ve neden Excel yetmiyor

**Kullanıcılar:**

| Rol | Ne yapar |
|---|---|
| Kategori müdürü | Planı hazırlar, taktikleri girer, onaya gönderir |
| Finans yöneticisi | Bütçeyi tanımlar, yüksek tutarlı planları onaylar |
| Yönetici | Ürün ağacını, müşteri listesini, kuralları tanımlar |

**Excel'in çözemediği dört şey:**

**Bütçe gerçekten düşmüyor.** Excel'de bir plan onaylandığında bütçeden bir şey eksilmiyor.
İki kategori müdürü aynı bütçeyi ayrı ayrı planlayabiliyor ve kimse fark etmiyor.

**Getiri hesabı elle yapılıyor.** Her planın kârlılığı ayrı bir formülle, ayrı bir dosyada.
Formül değişince eski dosyalar eski formülle kalıyor.

**Onay izi yok.** Kim, ne zaman, hangi rakama bakarak onayladı — e-posta zincirinde.

**Gerçekleşen ile planlanan buluşmuyor.** Fatura geldiğinde hangi plana ait olduğu elle
eşleştiriliyor.

---

## Nasıl çalışıyor

### İki başlangıç noktası — ve bu bir açık soru

Sistem bugün iki farklı çalışma biçimi tanıyor, ve fark **nereden başladığında**:

**Plandan başlayan.** Kategori müdürü geçmiş satış verisine bakarak hacim tahmini yapar,
taktikleri girer, sistem harcamayı ve getiriyi hesaplar, plan onaya gider, onaylanınca
bütçeden düşer ve bir anlaşmaya dönüşür.

**Anlaşmadan başlayan.** Geçmiş satış verisi yoksa veya güvenilmezse plan aşaması atlanır,
doğrudan müşteriyle anlaşma yapılır ve sisteme girilir.

İkisi de aynı yere varır: **bir anlaşma, bir bütçe rezervasyonu, ve gerçekleşme takibi.**

⚠️ **Bu ayrımın gerekliliği açık bir sorudur.** Alternatif bir okuma var ve daha sade:
*her şey planla başlar, bazı durumlarda geçmiş veri yoktur.* O durumda hacim alanı boş
kalır, hacme bağlı göstergeler hesaplanmaz, akışın geri kalanı aynı yürür — ve ayrı bir
"mod" kavramına gerek kalmaz.

Bugünkü ürün ayrımı bir kod düzeni olarak taşıyor. Kaynak belge ise onu üç katmanlı bir
kural motoruyla çözüyor (kanal bazında varsayılan, kullanıcı yetkisi, tenant ayarı) — ve
kendi metninde *"mümkün olduğunca deterministik ol, karma biçimi istisna için sakla"*
diyor. Yani kaynak da karmaşıklığı istisna sayıyor.

Karar verilmedi.

### Ürün ağacı

Planlama beş seviyeli bir hiyerarşide yapılıyor:

```
Marka  →  Kategori  →  Ürün Grubu  →  Tahmin Birimi  →  SKU
                                       (500ml Şampuan)   (Şampuan 500ml, X markası)
```

**Taktikler tahmin birimi seviyesinde** giriliyor (*"bu ürün grubuna %10 indirim"*), **hacim
SKU seviyesinde** (*"bu ürünün 5.000 adedi"*). Taktik aşağı iniyor: %10, her SKU'nun kendi
cirosuna uygulanıp o SKU'ya düşen **para** olarak hesaplanıyor.

### Bütçe nasıl çalışıyor

Bütçe **zarflara** bölünmüş: kanal × kategori × dönem. Bir plan onaylandığında ilgili zarftan
tutar **rezerve** ediliyor — henüz harcanmadı ama söz verildi.

Her hareket bir **deftere** yazılıyor: rezervasyon, tüketim, iade. Defter silinemez;
düzeltme, ters kayıtla yapılır.

Ve üç eşik var: bütçenin %80'i kullanılınca uyarı, %90'ında finans onayı gerekir, %100'de
işlem durur.

### Göstergeler

Sistem her plan için kârlılık hesaplıyor — ama formüller **koda gömülü değil**, veritabanında
tanımlı. Yönetici bir formülü değiştirebiliyor, sistem yeni formülle hesaplıyor.

En önemlisi **artımsal kârlılık**: destek verilmeseydi ne satılacaktı, destekle ne satılacak,
aradaki ek kâr harcamaya bölünüyor.

Ve her gösterge bir **renk** alıyor — yeşil/sarı/kırmızı. Renk eşikleri de konfigüre
edilebilir.

---

## Bugün ne var

45 ekran görüntüsüyle ölçüldü (2026-08-11; ölçüm 2026-08-12'de doğrulandı — görüntüler
bugünkü koda ait). Çalışan ana ekranlar:

**Planlama tablosu.** Ürün ağacı açılıp kapanan bir tablo. Hacim ve taktik girişi, anlık
hesaplama, üstte toplam paneli (hacim, harcama, kârlılık, hedefe uzaklık).

**Anlaşma yönetimi.** Kısa ve uzun dönemli anlaşmalar, durum takibi, onay akışı.

**Bütçe.** Zarf listesi, kullanım oranları, hareket defteri.

**Onay kuyrukları.** Bekleyen planlar ve anlaşmalar, onay/ret.

**Fatura yükleme.** Excel/CSV ile fatura verisi içe aktarma, doğrulama adımı.

**Yönetim ekranları.** Ürün ağacı, müşteri listesi, kanal, taktik, mekanik tanımları — on
ayrı ekran.

**Gösterge yönetimi.** 27 gösterge, formülleriyle birlikte, düzenlenebilir.

---

## Bugün ne yok

Bu bölüm dokümanın en önemli kısmı. Üç kategoride:

### 1 · Değer zincirinin alt yarısı

```
Bütçe ✅   Plan ✅   Anlaşma ✅   Rezervasyon ✅
Gerçekleşen 🔶   Tanıma ❌   Hakediş ❌   Mutabakat ❌   Kapanış ❌
```

Sistem bir planın **ne kadar harcayacağını** biliyor, ve harcamayı kaydedebiliyor. Zincirin
kalanı ölçüldü (2026-08-12) ve sonuç *"hiç yok"* değil — **yarısı var, yarısı yok:**

| | Durum |
|---|---|
| Hakediş talebi üretimi | ✅ çalışıyor, arayüzü var |
| Anlaşma kapanışı | ✅ çalışıyor — ama **hiçbir ekrandan çağrılamıyor** |
| Talep nesnesi | ❌ yok |
| Gelen talebin karşılanması | ❌ yok |
| Eşleştirme | ❌ yok — kullanıcı elle giriyor |
| Dönem kapanışı | ❌ yok |

**Eksik olanın şekli:** bugün sisteme giren veri *"perakendeci şu kadar kesinti yaptı"*
değil, *"biz şu kadar harcadık"*. Yani akış tek yönlü — karşı tarafın talebi diye bir kavram
yok, ve dolayısıyla *"gelen talep ile bizim kaydımız tutuyor mu"* sorusu sorulamıyor.

Ve bir taktikle bir gerçekleşmeyi eşleştirmek bugün **kullanıcının işi:** dosyayı yükleyen
kişi hangi anlaşmaya ait olduğunu kendisi yazıyor. Sistem bunu çıkarmıyor.

Bu, FMCG'de "kapalı döngü" denen şeyin ikinci yarısı — ve TPM ürünlerinin asıl değer vaadi
orada.

⚠️ **Ve bu bir gecikme değil, bir kapsam boşluğu:** kaynak belgede bu kavramların hiçbiri
geçmiyor — ne "yapılacak" ne "ertelendi" listesinde. Yani planlanmamış.

### 2 · Çizilmiş ama yapılmamış ekranlar

Kaynak belge altı ekran tarif ediyor ve hiçbirinin karşılığı yok:

| Ekran | Ne yapacaktı |
|---|---|
| Fiyat simülasyonu | İndirim öncesi/sonrası fiyat ve rakip karşılaştırması |
| Toplu onay | Bir fatura partisinin tamamını tek ekranda onaylama |
| Senaryo analizi | *"Ya %15 indirim verseydim?"* — kaydetmeden deneme |
| Geri al / ileri al | Planlama tablosunda değişiklik geçmişi |
| Öneri kutusu | *"Bu taktik hedefin altında, şunu deneyin"* |
| Raporlar (5 adet) | Plan performansı, kârlılık dağılımı, harcama özeti, bütçe kullanımı, anlaşma durumu |

Sonuncusu farklı bir durumda: **menüde görünüyor ama tıklanamıyor.** Kullanıcı raporun var
olduğunu sanıyor.

Ve ilk üçü birlikte, kaynağın planlama modu için yazdığı değer vaadinin kendisi: *"karar
vermeden önce simüle et."* Altyapı yapılmış, karar destek katmanı yapılmamış.

### 3 · Temel katmanlar

Kaynak, ilk sürümde olması gereken dört şey sayıyor ve dördü de yok:

**Veritabanı seviyesinde müşteri izolasyonu.** Ürün çok müşterili olacak şekilde
tasarlandı ve veri modeli buna uygun — her kayıt hangi müşteriye ait olduğunu taşıyor.
Eksik olan ikinci koruma katmanı: veritabanının kendisi de bu ayrımı zorlamalı.

Bugün ayrım yalnız uygulama katmanında yapılıyor. Şema baştan doğru kurulduğu için bu
**eklenebilir** bir katman — sonradan dönüştürme gerektirmiyor.

⚠️ Ama **ertelenebilir değil.** Hakediş bir finansal işlemdir, ve finansal kontrol denetimi
sektörde bir satın alma kriteridir. Yani izolasyon *"ikinci müşteri gate'i"* değil, ilk
kurumsal satışın ön koşulu.

**Yetenek tabanlı yetkilendirme.** Bugün kullanıcı tek bir rol taşıyor. Kaynak yirmi ayrı
yetenek tanımlıyor (*"plan oluşturabilir"*, *"bütçe uyarısını aşabilir"*) ve rollerin
bunlardan oluşmasını istiyor.

**Konfigürasyon tabloları.** Kaynak altı ayrı kural tablosu tanımlıyor — hangi kanalda hangi
çalışma biçimi, hangi taktik nerede kullanılabilir, hangi eşikte kim onaylar. Bugün bu
kuralların hepsi **koda gömülü**. Yani her müşteri için kod değiştirmek gerekir.

**Denetim kaydı sözlüğü.** Kaynak yirmi olay tipi sayıyor (plan oluşturuldu, bütçe aşıldı,
yetki reddedildi). Bizde denetim kaydı var ama yönetici işlemleriyle sınırlı, ve regülasyon
gereği tutulması gereken kapsamı karşılamıyor.

### Ve bilinen kusurlar

Üç tanesi kullanıcıya doğrudan görünür:

**Finans ekranı açılmıyor.** Kaynak belgenin tarif ettiği analitik gösterge paneli, bir
yazılım hatası nedeniyle hata ekranı gösteriyor.

**Anlaşma detayında isimler yerine kimlik numaraları görünüyor.** *"Müşteri: Özgür Kozmetik"*
yerine *"Müşteri: b39ade6a-ea33-…"*.

**Girilen taktik değeri ekrana geri gelmiyor.** Kullanıcı %10 yazıyor, hesaplama doğru
çalışıyor, ama hücre boş dönüyor.

Üçü de kayıtlı ve düzeltme sırasında.

---

## Bugünkü veri durumu

Sistem henüz **hiçbir ortamda yayında değil** — yalnız geliştirme makinesinde çalışıyor.
Bir saha pilotu yürütüldü ve kapandı; oradan çıkan kararlar bir müşteri profili olarak
kayıtlı, ürün kuralı olarak değil.

Ve bir ölçüm, ürünün olgunluğu hakkında en çok şeyi söylüyor:

> **170 üründen 166'sında maliyet verisi yok.**

Kârlılık hesabı maliyete bağlı. Yani bugün çoğu ürün için kârlılık **hesaplanamıyor** — ve
sistem bunu doğru yapıyor: uydurmuyor, "hesaplanamadı" diyor.

Ama bu, ürünün asıl bağımlılığını gösteriyor: **TPM sistemi verisi kadar iyidir.** Maliyet,
geçmiş satış, ürün ağacı — üçü de ERP'den gelmeli, ve bugün gelmiyor.

---

## Nerede duruyoruz

**Yapılanlar:** planlama, bütçe, onay, anlaşma yönetimi, gösterge motoru, yönetim ekranları.
Ve son dönemde: para aritmetiğinin doğruluğu, veri içe aktarmanın Türkçe sayı/tarih
biçimleriyle uyumu, yetki kapılarının hizalanması.

**Eksikler üç öbekte:** değer zincirinin alt yarısı (hakediş, mutabakat, kapanış), karar
destek katmanı (simülasyon, senaryo, öneri), ve temel altyapı (izolasyon, yetkilendirme,
konfigürasyon, denetim).

**Ve bir yapısal bulgu:** ürün, kaynak belgenin ikinci faza koyduğu yetenekleri yapmış, ilk
faza koyduğu temel katmanları atlamış. Bu bilinçli bir tercih olabilir — ama hiçbir yerde
yazılı değil, ve şimdi karara bağlanması gerekiyor.

Bir sonraki adım: `SORULAR.md`'deki on domain sorusunun karara bağlanması. Bunların çoğu
kaynak belgede cevabı olmayan, deneyim gerektiren sorular — ve cevapları hem eksiklerin
sırasını hem bazılarının gerekli olup olmadığını belirleyecek.
