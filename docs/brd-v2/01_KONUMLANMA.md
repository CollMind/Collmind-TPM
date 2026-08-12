# CollMind TPM — Ürün Konumlanması

> **Taslak.** Ürün sahibinin düzeltmesi için yazıldı. Bir karar kaydı değil — bir
> **öneri**, ve onaylanana kadar hiçbir şeyi bağlamaz.

- **Tarih:** 2026-08-11
- **Neden yazıldı:** 45 turluk kaynak okuması *"kaynak ne diyor, biz ne yapıyoruz"*
  sorusunu cevapladı. *"Bu ürün ne olmalı"* sorusu hiç sorulmadı — ve yeni BRD onun
  üstüne kurulacak.
- **Güncelleme (2026-08-11):** rakip/segment analizi geldi
  (`Settlement-First TPM SaaS: Comparative Vendor Analysis and Positioning`). Beş bölüm
  değişti; en önemlisi §1 (settlement-first çekirdek) ve §1.3 (üç modlu merdiven).

---

## 0 · Bu doküman neyi çözmeye çalışıyor

Elimizde on açık domain sorusu var (`SORULAR.md`) ve çoğu aynı şekli taşıyor:

> *"Kaynak karmaşık bir model tanımlıyor. Daha sade bir alternatif var. Hangisi?"*

Mod ayrımı üç katman istiyor — tek akış yeterli olabilir. Politika motoru dört tür kural
istiyor — az sayıda görüşlü kural yeterli olabilir. Hakediş atfı bir dağıtım algoritması
istiyor — hiç atfetmemek de bir seçenek.

Bu soruların hiçbiri tek başına cevaplanamaz. **Bir ürün duruşu gerektiriyorlar** — ve o
duruş bugün hiçbir yerde yazılı değil.

---

## 1 · Ne olmalı

### Tek cümle

> **CollMind TPM, ticari harcamanın anlaşmadan hakedişe ve kapanışa kadar doğru
> muhasebeleştirildiği, kurulumu ve kullanımı bir Excel dosyasından karmaşık olmayan bir
> üründür.**

Üç iddia var ve üçü de sınanabilir:

### 1 · Farklılaşma analitik değil, muhasebe doğruluğu

Çekirdek: **anlaşma → hakediş talebi → mutabakat → bütçe defteri.**

Bu bir eksik parça değil, **konumlanmanın kendisi.** Rakip analizi bunu doğruluyor: sektörün
TPM tanımının merkezinde *"settle"* var, ve pazarın gerçek acısı deduction/tahakkuk yükü.
Kullanıcıların %92'si süreci *"külfetli"* buluyor, %91'i tabloya geri dönüyor.

Analitik tarafta (senaryo, optimizasyon, lift modelleme) yarışmıyoruz — orada güçlü rakipler
var ve pazar onu bugün satın almıyor. Muhasebe doğruluğunda yarışıyoruz.

> Bunun bir sonucu var: **hakediş katmanı ürünün yarısı değil, ürünün kendisi.**

**Ve bu katmanın bugünkü durumu ölçüldü** (2026-08-12). Sonuç *"yok"* değil, *"yarısı var"*:

| | Durum |
|---|---|
| Hakediş talebi **üretimi** | ✅ var, canlı ve arayüzlü |
| Anlaşma **kapanışı** | ✅ var ve olgun — ama kullanıcı yüzeyi yok |
| Bir **talep nesnesi** | ❌ yok |
| **Karşı taraf perspektifi** | ❌ yok — gelen talep durumu diye bir şey yok |
| **Eşleştirme mantığı** | ❌ yok — eşleştirme kullanıcının girdiği bir alan |
| **Dönem kapanışı** | ❌ yok |

Eksik olanın şekli önemli: sisteme bugün giren şey *"perakendecinin kesinti belgesi"* değil,
**bizim kaydettiğimiz fatura satırı.** Yani veri akıyor ama **yönü ters** — ve *"gelen ama
henüz kabul edilmemiş"* diye bir durum yok.

Kapanış tarafında ise farklı bir sorun var: mekanizma olgun (eşzamanlılık koruması, çift
sayma koruması, iki uçtan uca test), ama **hiçbir ekrandan çağrılamıyor.**

### 2 · Veri olgunluğuyla ölçeklenen tek ürün

Ürün üç modda çalışır ve modlar **veri geldikçe kendiliğinden açılır:**

| Mod | Ön koşul | Ne verir |
|---|---|---|
| **Harcama & Mutabakat** | yok | Bütçe kontrolü, tahakkuk, hakediş eşleştirme, plan-gerçekleşen |
| **+ Kârlılık** | SKU maliyeti | Marj ve brüt kâr göstergeleri |
| **+ Artımsallık** | geçmiş satış / POS | Lift, kârlılık oranı, ikame etkisi |

Eksik veri bir hata üretmez, bir göstergeyi **gizler.** Ve alt mod tek başına satılabilir
bir üründür — çünkü çekirdek değer muhasebede.

*Bu model sektörde doğrulanmış: birden çok rakip aynı kademeli yapıyı ticari olarak
uyguluyor.*

### 3 · Sadelik bir özellik

Bir kategori müdürü ürünü eğitim almadan kullanabilmeli. Bir implementasyon aylarla değil
haftalarla ölçülmeli.

Bu bir pazarlama cümlesi değil — aşağıdaki her karar buna göre verilecek. Ve rakip
analizinin en net bulgusu bunu destekliyor: **kurulum yükü ve veri girişi, sektörün ortak
zayıflığı.**

### Kime

FMCG üreticileri — ve hedef segment **tek uçlu değil:**

**Veri olgunluğu düşük olanlar.** Ticari harcamasını bugün Excel'de yöneten, maliyet ve
geçmiş hacim verisi eksik veya güvenilmez şirketler. Bugünkü veri setinde ölçüldü: 170
üründen 166'sında maliyet verisi yok. Bu bir veri kalitesi sorunu değil, bu ucun gerçeği.

**Veri olgunluğu yüksek olanlar.** Küresel FMCG şirketleri — maliyet verisi var, geçmiş
satış derin, ERP entegrasyonu beklenen bir yetenek. Onlar için ürün daha derin çalışmalı,
daha fazla gösterge açmalı.

### Ve bu bir kısıt değil, tasarım ilkesi

> **Veri olgunluğu bir ön koşul değil, bir yeteneği açan eşiktir.**

Somut karşılığı §1'in üç modlu merdiveni. İki ayrı ürün, iki ayrı kurulum değil.

⚠️ **Ama bir eşik kuralı var ve bugün ölçülemiyor:** hedef müşterilerin çoğunda güvenilir
SKU maliyeti varsa, kârlılık modu ilk günden zorunlu olmalı — opsiyonel değil. Bu, müşteri
karması netleşince cevaplanır.

**Ve bir üçüncü öngörü:** kurumsal uca (Tier 1) açılındığında genel amaçlı iş akışı motoru
ve derin ERP entegrasyonu gerekli hale gelir. Orta ölçekte gerekmez. Yani bu iki yetenek
**segmentin fonksiyonu**, ürünün varsayılanı değil.

Bu ayrım aynı zamanda mod tartışmasının cevabına işaret ediyor: iki müşteri tipi için **iki
mod** değil, **tek akış + opsiyonel girdi.**

---

## 2 · Neyi reddediyoruz

Bir ürünün ne **olmadığını** söylemek, ne olduğunu söylemek kadar belirleyici. Beş ret:

### 2.1 · Muhasebe sistemi değil

Defter tutuyoruz ama genel muhasebe defteri değil. Fatura işlemiyoruz, ödeme yapmıyoruz,
vergi hesaplamıyoruz. Kaydımız **denetim düzeyinde izlenebilirlik** sağlar; muhasebe
kaydının kendisi ERP'de oluşur.

*Kaynak bu sınırı üç ayrı yerde çiziyor ve üçü de aynı şeyi söylüyor.*

### 2.2 · Veri ambarı değil — ama raporlama zayıf bir alan değil

Serbest keşif platformu değiliz: ad-hoc sorgulama, boyut serbest analiz, kurumsal veri
madenciliği — bunlar BI aracının işi.

**Ama raporlama ve karar desteği ürünün asıl işlerinden biri.** Elimizde ciddi bir satış
verisi var ve o veri planlamanın girdisi. Onu iyi kullanmak veri ambarı olmak değil.

Sınır **kapsamdan** değil, **amaç ve veri sahipliğinden** geçer:

| | Bizim işimiz | BI'ın işi |
|---|---|---|
| Amaç | Ticari harcama kararı | Serbest keşif |
| Veri | Kendi verimiz + ticari bağlam | Kurumsal tüm veri |
| Şekil | Tanımlı, standart, karar odaklı | Ad-hoc, boyut serbest |

Yani **tanımlı raporlar derin olabilir** — plan performansı, kârlılık dağılımı, harcama
kırılımı, bütçe kullanımı, anlaşma durumu. Kaynak sekiz standart rapor tanımlıyor ve
hiçbiri ad-hoc değil; sınır tam orada.

⚠️ Ve bu bugün ürünün **en zayıf yeri**: beş rapor menüde görünüyor, hiçbiri çalışmıyor.

### 2.3 · Ana veri kaynağı değil

Ürün ağacı, müşteri listesi, fiyat, maliyet — hiçbiri bizde doğmaz. ERP'den gelir, biz
kullanırız. **Üzerine yazmayız.**

Ve bunun bir sonucu var: ERP verisi eksikse ürün çalışmaya devam etmeli, eksikliği
**görünür kılarak.** Bugün maliyet verisi %98 eksik ve sistem doğru davranıyor — uydurmuyor,
"hesaplanamadı" diyor. Bu davranış bir istisna değil, **tasarım ilkesi.**

### 2.4 · Konfigürasyon platformu değil

Her şeyin ayarlanabilir olduğu bir ürün, hiçbir şeyin varsayılan olmadığı bir üründür — ve
kurulumu aylar sürer.

Ayarlanabilirlik **kanıtlanmış ihtiyaç** üzerine eklenir, öngörülen senaryo üzerine değil.
Az sayıda, görüşlü, iyi seçilmiş varsayılan; ve gerçekten farklılaşan yerlerde ayar.

*Kaynak da bunu söylüyor: "politikalar bilinçli olarak küçük ve görüşlü bir kümeyle
sınırlıdır; kademeli olarak gerçek kullanım desenlerine göre genişletilir."*

### 2.5 · Tahmin ve optimizasyon motoru değil

Hacim tahmini, talep planlaması, senaryo optimizasyonu — bunlar ayrı bir disiplin. Biz
kullanıcının girdiği tahmini alır, sonuçlarını hesaplar, ve **kararını görünür kılarız.**

*"Yapay zeka ile optimize edilmiş promosyon planlaması"* bu ürünün vaadi değil.

**Ve bu bir sıralama kararı, kalıcı bir ret değil.** Senaryo analizi üst kademede (§1 mod 3)
yerini alır — ama ilk günden değil. Pazar verisi bunu destekliyor: katılımcıların yalnızca
üçte biri yakın vadede otomatik senaryo analizi kurmayı planlıyor. Erken yapılan bir
optimizasyon katmanı, besleyecek verisi olmadığı için çalışmaz.

---

## 3 · Tasarım ilkeleri

Aşağıdaki beş ilke, açık soruların cevaplanmasında **kullanılacak ölçüt.** Bir seçenek
ilkeye uyuyorsa tercih edilir; uymuyorsa gerekçesi yazılır.

### İlke 1 — Sadelik varsayılan, karmaşıklık gerekçelidir

İki tasarım aynı işi yapıyorsa sade olan seçilir. Karmaşık olanın seçilmesi için **ölçülmüş
bir ihtiyaç** gösterilmeli — *"ileride gerekebilir"* bir gerekçe değil.

> Uygulaması: mod ayrımı üç katmanlı bir kural motoru gerektiriyorsa, önce tek akışın neden
> yetmediği gösterilmeli.

### İlke 2 — Eksik veri akışı durdurmaz, görünür olur

Ürün eksik veriyle çalışabilmeli. Ama eksikliği **gizlememeli**: hesaplanamayan bir gösterge
`null` döner, sıfır değil; renk verilmez, yeşil verilmez; ve sebebi kullanıcıya söylenir.

> Uygulaması: bu ilke bugün motor katmanında doğru uygulanıyor, raporlama katmanında ihlal
> ediliyor. İhlal düzeltilecek, ilke değil.

### İlke 3 — Kural veridir, kod değil

Eşikler, politikalar, formüller, roller — bunlar konfigürasyon olarak yaşar. Kodda gömülü
bir kural, ikinci müşteride kod değişikliği demektir.

**Ama İlke 1 geçerli:** az sayıda kural, iyi seçilmiş varsayılanlarla. Boş bir kural motoru
da kurulum yükü üretir.

> Uygulaması: bugün altı kural kategorisi kodda gömülü. Hangilerinin gerçekten
> farklılaştığı ölçülmeli — hepsi değil.

### İlke 4 — Bir yetenek, bir yol

Aynı işi yapan iki kod yolu zamanla ayrışır ve fark sessizce yanlış sonuç üretir. Bu, bu
kod tabanında sekiz kez ölçüldü.

> Uygulaması: mod ayrımı bugün iki paralel dünya yaratıyor. Ayrım gerekliyse **çalışma
> zamanında** çözülmeli, kod düzeyinde değil.

### İlke 5 — Ürün, müşteri profilinden ayrıdır

Bir müşteri için verilen karar, ürün kuralı değildir. Saha pilotlarından çıkan kararlar bir
**tenant profili** olarak ayrı yaşar; ürün varsayılanı ayrı.

> Uygulaması: pilot döneminde alınan 45 karar bugün ürün deposunda ürün kararı gibi
> duruyor. Ayrılmalı.

---

## 4 · Çok müşterili ürün, tek müşterili başlangıç

Bu ayrım planlamayı doğrudan etkiliyor ve karıştırılması pahalı:

| | |
|---|---|
| **Mimari** | Çok müşterili. Veri modeli, izolasyon, konfigürasyon katmanı buna göre |
| **Konuşlandırma** | İlk müşteri bir süre tek başına çalışacak |

Sonucu: bazı korumalar mimaride zorunlu ama uygulanması **sıralanabilir.**

⚠️ **Ama izolasyon o kategoride değil — ve bu, önceki bir değerlendirmenin düzeltmesidir.**

Hakediş bir finansal işlemdir, ve finansal kontrol denetimi (SOC 1 benzeri) sektörde bir
**satın alma kriteri.** Rakiplerin ikisi bunu ana satış argümanı olarak kullanıyor.

Yani veritabanı seviyesinde izolasyon *"ikinci müşteri gate'i"* değil, **ilk kurumsal
satışın ön koşulu.** Şema baştan doğru kurulduğu için eklenebilir bir katman — ama
ertelenebilir değil.

**İkinci ertelenemeyen:** kuralların koda gömülü olması. İkinci müşteri geldiğinde asıl
engel o, ve sonradan çıkarmak izolasyon eklemekten zor.

---

## 5 · Nasıl fark yaratıyoruz

Üç iddia, ve üçü de sınanabilir olmalı:

**Kurulum haftalarla ölçülür, aylarla değil.** Ölçütü: bir müşterinin ürünü kullanmaya
başlaması için gereken konfigürasyon adımı sayısı.

Rakip analizi bunu somutlaştırdı: sektörde tipik teknik kurulum dört-altı ay, karmaşık
kurulumlar bir yılı aşıyor, ve sürenin çoğu yazılıma değil **ana veri temizliğine** gidiyor.
Buna karşılık ön-konfigüre bir başlangıç paketiyle iki haftada devreye alınan örnekler de
var — yani fark üründe değil, **kurulum modelinde.**

Pratik sonuç: ön-konfigüre bir başlangıç paketi (hazır mekanik kütüphanesi, hazır onay
şablonları, hazır rapor seti) bir özellik değil, **bir konumlanma aracı.**

**Excel bir rakip değil, bir köprü.** Tabloya kopyala-yapıştır giriş ve çıkış birinci sınıf
bir özellik olmalı. Sektörde kullanıcıların büyük çoğunluğu TPM ürününü tabloyla
tamamlıyor — bunu engellemek yerine yolunu açmak geçişi kolaylaştırıyor.

**Veri olgunluğuna göre ölçeklenir.** Tam olgunlukta ERP verisi bir ön koşul değil — ama
olgun veriyle çalışan müşteride ürün daha derin çalışır. Elindeki veriyle başlar, eksik
olanı söyler, veri geldikçe daha çok gösterge ve daha güçlü karar desteği açılır.

**Kapalı döngü tek üründe.** Planlama bir üründe, hakediş başka bir üründe, mutabakat
Excel'de — bugünkü tipik durum bu. Tek üründe olması operasyonel farkın kendisi.

---

## 6 · Bu konumlanma neyi değiştirir

Onaylanırsa açık soruların bir kısmı **kendiliğinden daralır:**

| Soru | Konumlanmanın etkisi |
|---|---|
| Hacim girişi hangi seviyede? | **Rakip analizi cevapladı:** grup seviyesinde giriş + otomatik dağıtım + elle düzeltme. Sektör SKU zorunlu girişi *"adopsiyon düşmanı"* sayıyor — **ve bugünkü modelimiz tam olarak öyle** (bir FU plana eklendiğinde tüm SKU'ları zorunlu ekleniyor). Yani bu bir teyit değil, düzeltilecek bir sapma |
| Hakediş atfı gerekli mi? | Bölüm 1 → **evet, ürünün tanımı.** Eksik değil, çekirdek |
| Mod ayrımı üç katmanlı olmalı mı? | İlke 1 + 4 → sade alternatif önde, karmaşık olan gerekçe borçlu |
| Onay politikaları ne kadar esnek? | İlke 1 → **2-3 sabit şablon + politika tablosu.** Genel amaçlı iş akışı motoru orta ölçekte aşırı mühendislik |
| Taktik kütüphanesi serbest mi? | İlke 1 → **8-10 parametrik sabit tip.** Serbest form, hakediş tutarlılığını bozuyor |
| Simülasyon/senaryo katmanı? | Bölüm 2.5 → üst kademede, ilk günden değil |
| Raporlama derinliği ne olmalı? | Bölüm 2.2 → tanımlı raporlar derin olabilir; serbest keşif hayır |
| Çok birim (koli/adet) desteği? | İlke 1 → gerçek ihtiyaç ölçülmeden eklenmez |
| Veritabanı izolasyonu ne zaman? | Bölüm 4 → **ilk kurumsal satıştan önce**, ikinci müşteriden değil |

Ve bazıları **değişmez** — regülasyon, veri doğruluğu, izolasyon bir duruş meselesi değil.

---

## 7 · Ne ölçülmedi

1. ✅ **Rakip analizi yapıldı** (2026-08-11). *"Küresel ürünler fazla ağır"* iddiası
   desteklendi: tipik kurulum dört-altı ay, karmaşık kurulumlarda daha uzun, ve yükün
   çoğu ana veri temizliğinde. Kaynak, iddiaların hangilerinin doğrulanmış hangilerinin
   gerekçeli-ama-doğrulanamaz olduğunu ayrı ayrı işaretliyor.
2. ⚠️ **Müşteri karması hâlâ bilinmiyor** — ve bu, üç kararı birden askıda tutuyor:
   kârlılık modunun ilk günden zorunlu olup olmayacağı, artımsallık katmanının ne zaman
   çekirdeğe yaklaşacağı, ve genel amaçlı iş akışı motorunun gerekip gerekmediği. Üçü de
   *"hedef müşterilerin ne kadarında şu veri var"* sorusuna bağlı.
3. **SKU seviyesinde maliyet verisi yaygınlığı için yayınlanmış bir dağılım bulunamadı.**
   Gerekçeli gözlem: satış hacmi SKU seviyesinde neredeyse her yerde var (faturalar SKU'lu),
   maliyet ise teoride var ama ticari ekibin erişimine açık ve temiz olması istisna.
4. **"Haftalarla kurulum" bir hedef, bir ölçüm değil.** Bugünkü kurulum süresi bilinmiyor.
5. **Sadelik ölçütü tanımlı değil.** *"Excel'den karmaşık olmasın"* iyi bir yön ama
   ölçülebilir değil — bir ölçüt gerekiyor (konfigürasyon adımı sayısı? ilk plana kadar
   geçen süre?).

Bu dördü, danışman turunun girdisi olabilir — ve ilk ikisi için harici bilgi gerekiyor.
