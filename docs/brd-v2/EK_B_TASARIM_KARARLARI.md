# CollMind TPM — Verilmiş Tasarım Kararları

- **Tarih:** 2026-08-11
- **Kime:** ürün sahibi + danışman
- **Kaynak:** `docs/decisions/0001–0011` · `docs/contracts/SYSTEM_INVARIANTS.md`

---

## Bu doküman nasıl okunur

**Baştan sona okunmak için yazılmadı.** Her karar tek başına anlaşılır; bir soru tartışılırken
ilgili bölüme atlanır.

Her karar dört parça taşıyor:

```
NE KARAR VERİLDİ    tek cümle
NEDEN               gerekçe, domain dilinde
NEYİ REDDETTİK      değerlendirilen ama seçilmeyen seçenekler
BUGÜN NASIL DURUYOR uygulandı mı, dayanağı hâlâ geçerli mi
```

Son satır önemli: bazı kararlar **verildi ama uygulanmadı**, bazılarının **dayanağı sonradan
düştü**. İkisi de işaretli.

### Kararların ortak teması

On bir kararın yedisi aynı sorunun farklı yüzleri: **sistem bir bilgiyi bilmediğinde ne
yapmalı?**

Cevap her seferinde aynı yöne çıktı — **sessizce bir şey uydurma, gürültülü hata ver.**
Eksik veriye sıfır atamak, eksik ayara varsayılan koymak, hesaplanamayan bir orana renk
vermek: üçü de aynı sınıf. Ve ölçüldü ki bu sınıftan gelen hatalar en pahalıları, çünkü
kimse fark etmiyor.

---

# 1 · Hangi kod tabanı ürün olacak

**NE KARAR VERİLDİ**
CollMind-TPM ana ürün. Bir saha pilotu için yazılmış ikinci kod tabanı donduruldu —
silinmiyor, ama geliştirme orada yapılmıyor. O kod tabanı artık yalnız **referans**:
kabul testinden geçmiş akışlar oradan okunup ana ürüne yeniden yazılabilir.

**NEDEN**
İki kod tabanının ortak geçmişi yok, farklı veritabanı şemaları kullanıyorlar, ve ikincisi
tek bir müşterinin özel kararlarıyla şekillenmiş. Ana ürün çok müşterili olacak şekilde
tasarlandı — bu bir mimari karardır ve ilk müşterinin tek başına çalışacak olması onu
değiştirmez.

**NEYİ REDDETTİK**
TTM üzerinden devam etmek. Ölçüldü: TTM'de nesne modeli yok (ham SQL sorguları), para
alanları daha az hassas, ve ana üründe kurulmuş olan doğrulama katmanı orada yok.

**BUGÜN NASIL DURUYOR**
Geçerli, ve bu turlarda ölçümle desteklendi. Bir noktada TTM önde çıktı — kârlılık formülünün
paydası — ve o fark ana ürüne taşındı (Karar 11).

Ve önemli bir düzeltme: **kopyalama yasak.** TTM'den bir akış alınırsa ana ürünün bugünkü
sözleşmelerine uyarlanır, olduğu gibi taşınmaz.

---

# 2 · Finans yöneticisi hangi planları onaylar

**NE KARAR VERİLDİ**
Finans yöneticisi **yalnızca** kendisine yükseltilmiş (escalate edilmiş) planları onaylar.
Normal onay akışı kategori müdürünündür.

**NEDEN**
Finans yöneticisi bütçe zarflarının sahibi; yüksek tutarlı planlarda finansal onay makul.
Ama normal akışı ona açmak, kategori müdürünün yetkisini sulandırır.

**NEYİ REDDETTİK**
Yükseltilen planları yöneticiye (admin) göndermek — operasyonel darboğaz yaratır ve yöneticiyi
gereksizce iş akışına sokar. Yükseltme hattını tümüyle kapatmak — üründe mevcut ve ihtiyaç.

**BUGÜN NASIL DURUYOR**
⚠️ **Uygulandı, ama dayanağı düştü.**

Karar bir özet belgeye dayanıyordu ve o belge sonradan **geçersiz ilan edildi** — asıl kaynak
paketi bulunduğunda özetin eksik ve kısmen yanlış olduğu ölçüldü.

Ve asıl kaynak farklı bir şey söylüyor: finans yöneticisine **eşik ve kârlılık tetikli genel
ikinci kademe onay** yetkisi veriyor, yalnız yükseltme hattı değil.

Karar yeniden onay bekliyor. `SORULAR.md`'de kayıtlı değil çünkü bir domain sorusu değil —
kaynak açık, yalnız bizim kararımız ondan sapıyor ve sapmanın gerekçesi geçersizleşti.

---

# 3 · "500 milisaniyede hesaplanır" ne demek

**NE KARAR VERİLDİ**
Kaynak *"hesaplama 500ms'den kısa"* diyor. Bu, **kullanıcının bir hücreye değer girmesinden
güncellenmiş göstergeleri görmesine kadar geçen toplam süre** olarak yorumlandı — tek bir
formülün hesaplanma süresi değil.

**NEDEN**
Kaynağın aynı tablosunda ölçüm yöntemi yazılı: *"girdi değişiminden ekran güncellemesine kadar
geçen süre."* Ve başka bir yerde saniyede 10.000 hesaplama hedefi var — tek formülün 500ms
sürmesi bununla çelişirdi.

**NEYİ REDDETTİK**
"Tek formül değerlendirmesi" yorumu. Hiçbir kaynakta bu nitelendirme geçmiyor; bir varsayımdı.

**BUGÜN NASIL DURUYOR**
✅ Yorum doğru çıktı — asıl kaynak paketi bulunduğunda ölçüm yöntemi orada birebir aynı
şekilde yazılı, hatta yüzdelik dilim hedefleriyle birlikte.

Ama **hedef bugün karşılanmıyor**: 52 ürünlük bir planda tek hesaplama ~540ms, eşzamanlı iki
işlemde ~1100ms. Ve hiçbir yerde ölçüm/telemetri yok — yani uyum iddia edilemez.

Bu bir kayıt, bir alarm değil: ürün henüz yayında değil ve hedefler kaynağın kendi ifadesiyle
*"gösterge niteliğinde, sözleşmesel değil."*

---

# 4 · Fatura-içi ve fatura-dışı bütçe ayrımı

**NE KARAR VERİLDİ**
Bütçe zarfları harcama tipine göre ayrılabilir (fatura-içi / fatura-dışı). Beş alt karar:

1. Bir anlaşmanın harcama tipi belirsizse, ayrılmış bir bütçeye rezervasyon **reddedilir**
2. İki tipten biri tavanı aşarsa istek **tümüyle** reddedilir — kısmi rezervasyon oluşmaz
3. Aynı kural, plan yalnız tek tip harcıyorsa yalnız o tipe uygulanır
4. Tip belirtmeden ayrılmış bir bütçeye erişim **açık hata** verir
5. Bölme özelliği, tüm erişim yolları tipli hale gelene kadar üretimde kullanılmamalı

**NEDEN**
Belirsiz tipe varsayılan atamak *sessizce yanlış bütçeyi düşürür* — ve bu, en pahalı hata
sınıfı. Yarım rezerve edilmiş bir plan ise yönetilmesi gereken bir ara durum yaratıyor;
atomik red onu tümüyle ortadan kaldırıyor.

**NEYİ REDDETTİK**
Belirsiz tipi fatura-dışı saymak (varsayım üretir). Tavanı orantısal bölmek (uydurma).
Yalnız aşan tipi bloklamak — reddedildi, ama sonra **kapsamı netleştirildi**: yalnız tek tip
harcayan bir plan diğer tipin doluluğundan etkilenmiyor.

**BUGÜN NASIL DURUYOR**
Uygulandı. Ama Karar 2'nin bedeli açık: fatura-dışı bütçesi bol bir plan, fatura-içi
aşımı yüzünden tümüyle bloklanıyor. Bu bilinçli kabul edildi ve `SORULAR.md` A5'te yeniden
sorulmak üzere kayıtlı.

---

# 5 · Tek bir gönderme yolu

**NE KARAR VERİLDİ**
Planı onaya gönderen iki farklı uç vardı ve ikisi farklı davranıyordu. Kullanıcı arayüzünün
çağırdığı uç kanonik kabul edildi; diğerinin işlevi ona taşındı.

**NEDEN**
İki yolun ayrı evrilmesi, ölçülen hataların ana kaynağıydı: taktikler yalnız bir yolda
okunuyordu, ret→yeniden gönder döngüsü yalnız bir yolda kapsanıyordu. Ve fatura-içi/dışı
ayrımının tamamı, ürünün **hiç çağırmadığı** bir uçta yaşıyordu.

**NEYİ REDDETTİK**
Arayüzü diğer uca çevirmek — o uçta eşzamanlılık koruması yoktu, taşımak onu sessizce
kaybettirirdi.

Ve üç ek karar:
- Eski uç bir anda kaldırılmadı, iki aşamada emekliye ayrıldı
- Yeni yol **ek doğrulama almadı**: kullanıcının bugün gönderebildiği plan yarın da
  gönderebilmeli
- Harcama kolonları hesaplanmamışken gönderme denenirse **açık hata** verilir — sessizce sıfır
  rezerve etmek bütçeyi eksik düşürürdü

**BUGÜN NASIL DURUYOR**
Uygulandı. Üçüncü ek karar (*"bayat veriyle gönderme reddedilir"*) bu ürünün tekrar eden hata
sınıfına karşı en net korumalardan biri.

---

# 6 · Götürü harcama nasıl dağıtılır

**NE KARAR VERİLDİ**
Götürü harcamalar (raf kirası, insert) ürünlere **geçmiş satış hacmine orantılı** dağıtılır —
yalnız üst toplama eklenmez.

**NEDEN**
Ürün bazında kârlılık, götürü harcamayı görmeden yanlış kalır. Ve dağıtım tabanı olarak geçmiş
hacim seçildi çünkü tek eldeki kanıt bunu ima ediyor: *"geçmiş hacmi olmayan ürüne pay yok."*

**NEYİ REDDETTİK**
Planlanan hacme göre dağıtmak — o zaman geçmişi olmayan yeni ürün de pay alırdı, ve eldeki tek
kanıtla çelişirdi. Ürünlere eşit bölmek — hacim farkını yok sayar, kârlılığı çarpıtır.

**BUGÜN NASIL DURUYOR**
🔴 **Öncülü yanlışlandı** (2026-08-11).

ADR *"kaynakta açık formül yok"* diyordu. Ölçüm gösterdi ki **formül var** — planlama modu
bölümünde, tabanıyla birlikte: *"planlanan hacme orantılı"*. O bölüm daha önce "gerekçeyle
atla" kovasındaydı ve ölçüt değişince okundu.

Ve fark davranışsal: kararın gerekçesi *"geçmişi olmayan ürüne pay yok"*tu. Planlanan
tabanında yeni bir ürün de pay alır — ve kaynak bunu desteklenen bir senaryo olarak
anlatıyor.

Karar değişmedi (ölçüm bekliyor), ama dayanağı geçersiz. `SORULAR.md` A9'da yeniden
soruluyor.

Ayrıca bir açık nokta: aynı işi yapan **iki ayrı dağıtım kodu** var ve hangisinin kanonik
olduğu ölçülerek karara bağlanmalı.

---

# 7 · Para aritmetiği nasıl yapılır

**NE KARAR VERİLDİ**
Sistem ikiye ayrıldı:

- **Para alanı** — bütçe, defter, anlaşma, harcama hesabı, hakediş. Burada aritmetik **tam**
  olmalı, yuvarlama hatası kabul edilmez.
- **Analitik alan** — kârlılık oranları, yüzdeler, renk göstergeleri, raporlar. Burada kayan
  nokta hassasiyeti kabul edilebilir.

Ve bağlayıcı bir sınır: **analitik alanın çıktısı para olarak kaydedilemez ve bir para
eşiğiyle karşılaştırılamaz.**

Uygulama yaklaşımı: yeni yazılan modüller tam temsille doğar (para kuruş cinsinden tam sayı),
mevcut kod dokunuldukça dönüşür. Tek seferlik büyük bir dönüşüm yapılmıyor.

**NEDEN**
Veritabanı zaten tam ondalık tutuyor; kayıp, veri kodda okunurken oluşuyor. Ve altı yerde
"yaklaşık eşitlik" toleransı bulundu — bu, kayan nokta hatasının telafi edildiğinin işareti.

Tek seferlik dönüşüm reddedildi çünkü 68 kolon, 23 tablo etkileniyor ve iki bağımsız ölçüm
**kanıtlanmış bir yanlış para tutarı** gösteremedi. Kanıtlanmamış bir risk için ürün işini
haftalarca bekletmek orantısız.

**NEYİ REDDETTİK**
Ondalık aritmetik kütüphanesi kullanmak — her dönüşüm noktasında sessiz kayıp riski taşıyor.
Tek seferlik tam dönüşüm — geri dönüşü pahalı, ve yarım kalamaz.

**BUGÜN NASIL DURUYOR**
Uygulandı, ve on sekiz düzeltme (errata) aldı. En önemlileri:

- Tip sisteminin çarpımı engellediği iddiası **yanlış çıktı** — koruma atama noktasında
- Yuvarlama yönü negatif tutarlar için netleştirildi
- Bir ölçek sınırı yanlış hesaplanmıştı, düzeltildi

Bu düzeltmelerin sayısı bir zayıflık değil — kararın **ölçümle sınandığının** göstergesi.

---

# 8 · Girilen değerde boş ile sıfır

**NE KARAR VERİLDİ**
Planlamacının girdiği bir taktik değerinde **boş bırakmak ile sıfır yazmak arasında anlam farkı
yoktur.**

**NEDEN**
%0 indirim ile indirim yok, ekonomik olarak aynı şey. Ve kod bunu zaten tutarlı biçimde
uyguluyor — on beş kullanım yerinin hepsi ikisini aynı işliyor.

**NEYİ REDDETTİK**
Ayrım kurmak. Ölçüldü: hiçbir yerde ayrımın gözlemlenebilir bir sonucu yok, ve ayrım kurmak
on beş yeri değiştirmeyi gerektirirdi.

**BUGÜN NASIL DURUYOR**
Uygulandı. Ve kapsamı **bilinçli olarak dar**: yalnız planlamacının girdiği değerler.
Hesaplanan göstergeler ve konfigürasyon ayarları bu kararın dışında — ikisi farklı eksen, ve
biri (Karar 9) tam tersi yönde karar verdi.

---

# 9 · Konfigürasyon tavanında sıfır yazılamaz

**NE KARAR VERİLDİ**
Bir konfigürasyon tavanı ya pozitif bir değer taşır, ya da yoktur. **Sıfır yazılamaz** —
denenirse reddedilir.

**NEDEN**
Girilen değerde sıfır ile boş aynı şeydi (Karar 8). Bir **tavanda** ise **zıt** anlamlar
taşıyor: biri "hiçbir şeye izin verme", diğeri "sınırsız".

Ve ölçüldü ki bugün sıfır zaten istenen şeyi ifade etmiyor: bir tavana sıfır yazmak fiilen
*"bu mekanik hiç kullanılamaz"* demek — ki bunun için zaten "pasif" işareti var. İki
mekanizma, aynı sonuç, biri adıyla yalan söylüyor.

Kaynak da bunu doğruladı: *"birleşemez"* için ayrı bir onay kutusu tanımlıyor, tavan alanının
sıfır değerinin tasarımda hiçbir rolü yok.

**NEYİ REDDETTİK**
Sıfırı "sınırsız" saymak — admin bir değer yazıyor, sistem kabul ediyor, hiçbir etki
üretmiyor. Kabul edilen bir girdinin sessizce yok sayılması.

**BUGÜN NASIL DURUYOR**
Uygulandı, ve maliyeti sıfır — hiçbir kayıtta bu alan dolu değil.

⚠️ Ama bu karar **üç şeyi çözmüyor** ve o üçü açık: kodda gömülü bir `%60` sabiti bu tavanı
gölgeliyor, iki farklı yerde çelişkili hesaplanıyor, ve kaynağın *"birleşemez"* alanı bizde
hiç yok.

---

# 10 · Hangi belge bağlayıcı

**NE KARAR VERİLDİ**
İki farklı iş gereksinim belgesi bulundu, ikisi de "v1.0" numaralı, farklı kapsamda. Sonradan
tarihli ve iki modu da kapsayan **paket** bağlayıcı; erken tarihli PDF geçersiz.

**NEDEN**
Erken belge kendini *"başlangıç"* diye adlandırıyor, iki ay önce tarihli, ve ürünün iki
çalışma biçiminden hiç söz etmiyor. Sonraki paket üç kat hacimli ve ikisini de kapsıyor.

**NEYİ REDDETTİK**
İkisini birden bağlayıcı saymak. Yeni paket eskisinin kapsadığı her şeyi kapsıyor — eskisinin
ek bir katkısı yok, yalnız daha az söylüyor.

**BUGÜN NASIL DURUYOR**
Uygulandı, ve sonucu ağır: bu paket altı aydır depoda duruyordu ve hiçbir yerde ondan söz
edilmiyordu. Paketin kendi kurulum listesi *"ekip kurallarına referans ekle"* maddesini
taşıyor — o madde uygulanmamış, ve tam olarak öngörülen sonuç olmuş.

Ve bir ikinci bulgu: hakediş, tanıma, tahakkuk ve mutabakat kavramları **hiçbir kapsam
listesinde yok** — ne "ertelendi" ne "kapsam dışı". Yani kaynak bu yeteneği ertelememiş bile.

---

# 11 · Kârlılık göstergesi neye bölünür

**NE KARAR VERİLDİ**
Kârlılık oranı = **artımsal brüt kâr ÷ toplam planlanan harcama**.

Önceki hesap paydada "artımsal harcama" kullanıyordu — daha küçük bir sayı, dolayısıyla daha
yüksek bir oran.

**NEDEN**
Karar tanık sayısına dayanmıyor (dört bağımsız kaynak aynı paydayı veriyor, biri karşı) —
**eşik kalibrasyonuna** dayanıyor.

Ürünün dört ayrı eşiği bu paydaya göre ayarlanmış: yeşil sayılma sınırı, otomatik ret sınırı,
finans onayı sınırı, ve bir faz kapısı (*"planların %70'i yeşil olmalı"*). Paydayı küçültmek
oranı şişirir, yani **dört eşik de gevşer** — ve o faz kapısı kendiliğinden geçilir.

Sapma bir sayıyı değil, ürünün kabul kapılarını devre dışı bırakıyordu.

**NEYİ REDDETTİK**
Mevcut paydayı korumak. Savunulabilir bir metrik ama **başka bir metrik** — seçilseydi tüm
eşiklerin yeniden kalibre edilmesi gerekirdi ve bunun için bir gerekçe yok.

**BUGÜN NASIL DURUYOR**
Uygulandı. Ve nasıl oluştuğu öğretici: sapma bir **düzeltme turunda** girmiş — önceki formül
gerçekten yanlıştı, düzeltme gerçekti, hedef yanlıştı. Ve *"kaynağa uygun"* diye
etiketlenmişti, kaynak okunmadan.

Doğru payda aynı düzeltmede veritabanına eklenmiş ve kullanılmamıştı.

---

# Kararların bugünkü durumu — özet

| # | Karar | Durum |
|---|---|---|
| 1 | Ana ürün seçimi | ✅ uygulandı, ölçümle desteklendi |
| 2 | Finans yöneticisi onay yetkisi | ⚠️ uygulandı, **dayanağı düştü** |
| 3 | Performans hedefinin kapsamı | ✅ yorum doğrulandı, hedef karşılanmıyor |
| 4 | Fatura-içi/dışı bütçe ayrımı | ✅ uygulandı, bedeli yeniden soruluyor |
| 5 | Tek gönderme yolu | ✅ uygulandı |
| 6 | Götürü harcama dağıtımı | 🔴 uygulandı, **öncülü yanlışlandı** |
| 7 | Para aritmetiği | ✅ uygulandı, 18 düzeltmeyle |
| 8 | Girilen değerde boş/sıfır | ✅ uygulandı |
| 9 | Konfigürasyon tavanında sıfır | ✅ uygulandı |
| 10 | Bağlayıcı belge | ✅ uygulandı |
| 11 | Kârlılık paydası | ✅ uygulandı |

**İki karar yeniden bakılmalı:** 2 (dayanağı geçersiz bir belgeydi) ve 6 (öncülü ölçümle
yanlışlandı — kaynakta formül vardı ve tabanı farklı).
