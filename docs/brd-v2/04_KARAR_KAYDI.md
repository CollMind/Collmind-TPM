# CollMind TPM — Karar Kaydı

> **Bu doküman bir soru listesi olarak başladı, karar kaydı olarak bitti.**
>
> 2026-08-12'de yapılan üç oturumluk karar turunda **21 kararın tamamı** alındı. On domain
> sorusu, altı kapsam sorusu, beş doğrulama.

- **Karar tarihi:** 2026-08-12
- **Karar veren:** ürün sahibi
- **Girdi:** 45 turluk kaynak okuması · rakip/segment analizi · `L0` konumlanma taslağı
- **Çıktı:** `L2`'ye işlendi (~160 kural) · `L1` bunun üstüne yazıldı

---

## Nasıl okunur

Her karar dört parça taşıyor:

```
SORU        neydi
KARAR       ne verildi
GEREKÇE     neden — ürün sahibinin kendi ifadesiyle
AÇTIĞI      hangi kuralları serbest bıraktı
```

**Reddedilen seçenekler de yazılı.** Bir seçeneğin neden **seçilmediği**, seçilenin
gerekçesi kadar değerlidir — ve altı ay sonra *"bu neden yok"* sorusuna cevap verir.

---

## Karar turunun kendi bulgusu

⚠️ Yirmi bir karardan **altısı, sorunun yanlış kurulduğunu** gösterdi:

| Soru | Neyi keşfetti |
|---|---|
| `A2` hacim seviyesi | *"Hangi seviyede girilir"* değil — **giriş grain'i ≠ hesap grain'i** |
| `A3` hakediş atfı | *"Toplamı nasıl bölüştürürüz"* değil — **gerçekleşme kanıttan gelir** |
| `A5` tavan aşımı | *"Kaydedilsin mi"* değil — **onay ödemenin kapısı, kaydın değil** |
| `A6` tahakkuk | *"Bizim işimiz mi"* değil — **operasyonel evet, muhasebe hayır** |
| `A9` götürü dağıtım | *"Hangi taban"* önce — **dağıtım hangi katmanda yaşar** |
| `A1` mod ayrımı | *"Gerekli mi"* değil — **beş karar sonrası konusuz kaldı** |

Ve `A1` özellikle: mod kendi kararıyla değil, **davranışları teker teker sahiplerine
dağıtıldığı için** öldü.

---

# BÖLÜM A · Domain kararları

---

## A1 · Çalışma biçimi ayrımı

**SORU** — Ürün iki çalışma biçimi tanımalı mı (plandan başlayan / anlaşmadan başlayan), ve
kaynağın üç katmanlı çözümleyicisi gerekli mi?

**KARAR** — ❌ **Mod, bir davranış belirleyici olarak öldü.** Kapsam politikası, öncelik
eşleşmesi ve karma biçim **reddedildi.** Geriye yalnız bir **görünürlük bayrağı** kalır.

**GEREKÇE** — Bu oturumun beş kararı modun taşıdığı **her davranışı gerçek sahibine
dağıttı:**

| Davranış | Yeni sahibi |
|---|---|
| Hesaplaşma kadansı | Taktik tipi (`A-1.3`) |
| Baseline yokluğu | Dağıtım bayrağı (`A2`) |
| Talep yaşam döngüsü | Kaynak alanı (`A3.a`) |
| Tahakkuk | Kadans (`A6`) |
| Birim | Çekirdek teklik (`A8`) |

> Geriye kalan rejimin belirlediği **hiçbir finansal davranış yok.** Davranış belirlemeyen
> bir rejim için üç katmanlı çözümleyici kurmak, **cevabı olmayan bir soruya motor
> yazmaktır.**

**Karma biçim özellikle reddedildi:** kullanıcıya *"hangi biçimde çalışmak istersin"* diye
sormak, **ürünün veremediği bir kararı kullanıcıya devretmektir.**

**Ve bir ilke resmileşti:** hesaplaşma her koşulda gerçekleşen veriye dayanır — bu bir mod
adı değil, ürünün değişmez zemini.

→ `K-2.1.12g` … `K-2.1.12k` · `L1 §1.3`

---

## A2 · Hacim tahmini hangi seviyede

**SORU** — Hacim FU'da mı girilir, SKU'da mı? Dağıtım kuralı ne? SKU kırılımı zorunlu mu?

**KARAR** — Giriş **FU'da**; SKU katmanı **türetilmiş ve düzeltilebilir.** Dağıtım **geçmiş
hacim payı**; tarihi olmayan SKU **sıfır + görünür bayrak**; hiç tarih yoksa eşit pay +
bayrak. Zorunlu genişletme **kaldırılır.**

**GEREKÇE** — Üç kaynak aynı yeri gösteriyordu (kaynağın çekirdek bölümü, rakip analizi,
adopsiyon kanıtı) — ama asıl ikna edici olan **kendi ölçümümüz:** taktik tarafında
FU-giriş → SKU-uygulama modeli **zaten çalışıyor.**

**Yeni ürüne eşit pay reddedildi:**

> Yeni ürünün lansman hacmi tarihsel bir türetme değil, **ticari bir karardır.** Sistemin
> sessizce uydurduğu eşit pay, sessiz sıfırın kardeşi olan bir **sessiz tahmindir.**

**Ve kritik ayrım:** giriş grain'i ≠ hesap grain'i. SKU katmanı hesapta yaşamaya devam eder;
değişen şey **satır olarak malzemeleşmesi.**

**Miras görünürlüğü bu kararın parçasıdır**, ayrı bir kusur değil — kullanıcı dağılımı
göremeden düzeltemez.

→ `K-2.1.7` … `K-2.1.8i` · `L1 §1.3`

---

## A3 · Hakediş — üç parça

`A3` ölçüm sonrası üçe bölündü.

### A3.a · İç ve dış talep aynı varlık mı

**KARAR** — **Tek varlık**, `kaynak: İÇ | DIŞ` alanıyla.

**GEREKÇE** — İkisi **aynı ekonomik olayın iki taraftaki görünümü.** Ayrı varlık yapılırsa
eşleştirme, iki şemayı normalize eden bir ara katman ister — **ve o katman fiilen ortak talep
modelidir.** Yani ayrı varlık, tek varlığı bir dolaylama arkasında yeniden icat eder.

**Üç itiraz da varlık ayrımı gerektirmiyor:** doğrulama kaynak-koşullu kural, yetki
eylem-bazlı, durumlar tek enum + kaynağa duyarlı geçiş tablosu.

⚠️ **Ama eşleştirme ayrı bir bağ varlığıdır.** `1:1` varsaymak yanlış: bir dış kesinti birden
çok iç talebe — ya da hiçbirine — denk düşebilir.

→ `K-2.13.5` … `K-2.13.5g`

### A3.b · Eşleştirme ölçütü ve tolerans

**KARAR** — Kademeli daralan tek merdiven: referans → hakediş grain'i → kuyruk. Otomatik
kesinleşme **yalnız tekil adayda.** Tolerans **ikili eşik** (oran + mutlak, küçük bağlar),
dar başlar.

**GEREKÇE** — Grain seçimi tartışmasız: iç talepler zaten o grain'de doğuyor. Daha dar ölçüt
karşı tarafın vermediği kırılımı bekler; daha geniş ölçüt kanalları karıştırır.

**Ve tekillik şartı `n:m` riskinin cevabı:**

> Sistem geniş ölçütle **bulur**, belirsizlikte **karar vermez.** Yanlış eşleşme,
> eşleşmemekten pahalıdır — eşleşmeyen talep kuyrukta görünür, yanlış eşleşen talep dönem
> kapanışına gömülür.

**Tolerans dar başlar** çünkü otomatik kabul edilen fark **sessizce gider olur;**
genişletmek kolay, geri almak zordur.

⚠️ **Tolerans içi fark yok olmaz, yazılır** — sessiz yutma, sessiz sıfırın **para hâli**
olurdu.

→ `K-2.13.12` … `K-2.13.14d`

### A3.c · Atıf kuralı

**KARAR** — Atıf **kanıt merdiveniyle** yapılır. Açıklanamayan kalıntı hiçbir taktiğe
dağıtılmaz — açık bir `FARK` kalemi olarak kalır. **Orantısal dağıtım reddedildi.**

**GEREKÇE** — ⚠️ **Soru yanlış kurulmuştu:**

> Actuals-first ilkesi zaten tersini söylüyor: **taktik gerçekleşmesi dış talepten
> türetilmez, kendi kanıtından hesaplanır.** Dış talep bir doğrulamadır, bir veri kaynağı
> değil.

Üç kanıt sınıfı: **gözlenen** (fatura satırında var) · **türetilebilir** (oran × hacim) ·
**sözleşmesel** (koşul sağlandıysa tamamı).

**Orantısal dağıtımın tehlikesi:** bir `%96` çarpanı üç taktiğe de *"gerçekleşti"* damgası
vurur ve **hassas görünen çöp** üretir — *"hangi taktik işe yaradı"* sorusuna **güvenle
yanlış** cevap verir.

→ `K-2.13.14e` … `K-2.13.14l`

---

## A4 · Hakediş tabanı

**SORU** — *"Ciro üzerinden %5"* — hangi ciro?

**KARAR** — Türetilebilir sınıfın tabanı **net satış** (varsayılan), ve taban **mekanik
tanımının açık bir alanıdır.** Oran bazlı mekanikler tutara, birim bazlı mekanikler hacme
uygulanır — **hacim yoksa birim bazlı mekanik tanımlanamaz.**

**GEREKÇE** — Üç kat:

**Çifte sayım.** Brüt üzerinden hesaplanan bir ciro primi, fatura-içi indirimin uygulandığı
ciroya **bir kez daha** prim öder.

**Karşı tarafla hizalanma.** Kesinti neredeyse her zaman net üzerinden gelir.

**Eşleştirme verimi.** Brüt tabanlı bir iç talep, net tabanlı dış kesintiyle **her dönem fark
üretir** ve kuyruğu şişirir. Bu bir muhasebe zarafeti değil, **motorun verimi.**

⚠️ **Alanın var olması gerekli**, çünkü gerçek sözleşmelerde brüt tabanlı oran da yazar:

> Bunu ifade edemeyen bir sistem, kullanıcıyı **oranı elle bozarak** tabanı taklit etmeye
> iter. **Hesap doğru görünür, denetim izi yalan söyler.**

⛔ **İade davranışı açık** — veride nasıl temsil edildiği ölçülmeden formül yazılmaz.

→ `K-2.13.14h1` … `K-2.13.14h7`

---

## A5 · Tavan aşımı

**SORU** — Anlaşma tavanı aşıldığında ne olur? Ve atomik red korunmalı mı?

**KARAR** — Tavan aşımı **gerçekleşmeyi durdurmaz:** hakediş tavana **kırpılır**, tavan üstü
tutar **açık bir kalem** olarak yazılır. Finans onayı **ödemenin kapısıdır, kaydın değil.**
Atomik red **korunur.**

**GEREKÇE** — Aşımı üreten şey bir **hesap**, bir talep değil. Bu noktada *"reddet"* veya
*"atla"* **gerçeği inkâr eder** — borç ekonomik olarak doğmuştur.

**Ve üç eski seçeneğin çelişkisi çözüldü:**

> *"Kırp"* **defter** tarafında doğru, *"kabul et + işaretle"* **iş akışı** tarafında doğru —
> ikisi aynı modelin iki katmanı.

**Atomik red neden dokunulmaz** — simetri:

```
rezervasyon = taahhüt   → sert
gerçekleşme = olgu      → akar
```

Kısmi kabul, kullanıcının gönderdiğinden **farklı bir planın** sessizce onaylanması demektir.

**Ve sürtünmenin panzehiri kısmilik değil, teşhis netliğidir** — red mesajı hangi kalemin
takıldığını söyler.

**Ek:** anlaşma tavanına `%90` erken uyarı — *"aşım anında öğrenilen tavan, kötü tavandır."*

→ `K-2.2.17` … `K-2.2.17d` · `K-2.2.11a`

---

## A6 · Tahakkuk

**SORU** — Tahakkuk sistemin işi mi, ERP'nin mi?

**KARAR** — **Operasyonel tahakkuk bizim**, muhasebe tahakkuku ERP'nin. Ayrı bir kova; dönem
kapanışında çözülür.

**GEREKÇE** — İki soru var ve sahipleri farklı:

| Soru | Sahibi |
|---|---|
| *"Muhasebeye ne yazılmalı?"* | ERP |
| *"Karşı taraf dönem sonunda ne kesecek?"* | **Biz** |

İkincisi **mutabakatın kendisidir** — eşleştirme dönem sonunda gelen kesintiyi bir iç
birikimle karşılaştırıyor, ve **o birikim tahakkuktur.**

> Bu birikimi tutmayan bir hakediş ürünü, kendi çekirdek sorusuna **dönem ortasında** cevap
> veremez.

**Ve *"ERP'nin işi"* demenin görünmez maliyeti:** hedef segmentte ERP'de bu bilinç yok —
dolayısıyla tahakkuk **tablonun işi** olur, ve gölge dosya geri gelir.

**Tek hesap yolu, iki çıktı tipi:** ayrı bir tahakkuk formülü yazılmaz; aynı kanıt merdiveni
ara dönemde tahakkuk, dönem sonunda talep üretir.

→ `K-2.13.25` … `K-2.13.25f`

---

## A7 · Yetki kapsamı ekseni

**SORU** — Kapsam hangi eksenlerde tanımlanır? Kaynak kategoriyi bir **ürün** ekseni sayıyor
ve yetkiye almıyor.

**KARAR** — Kapsam **kanal + müşteri + kategori** kalır. **Kaynaktan bilinçli sapma.** Bölge
mekanizması korunur ama kapsama bağlanmaz.

**GEREKÇE** — İki kat:

**Yetki ekseni, onay sorumluluğunun eksenini izler.** Onay şablonu *"kategori müdürü
onaylar"* diyor — kategori müdürünün kapsamı kategoriyle sınırlanamıyorsa **rolün adıyla
kapsamı çelişir.**

> Kaynağın eksen listesi bir **organizasyon varsayımıdır**, bir yetki ilkesi değil.

**Ve bölge için tersi kanıt var:** mekanizma tam kurulu (tablo, ekran, üç yabancı anahtar),
kullanım **sıfır satır.** İhtiyaç kanıtlanmamış, **ihtiyaçsızlık ölçülmüş.**

⚠️ **Ve bir ayrım:** yetki kapsamı ile bütçe boyutu **ayrı mekanizmalardır** — örtüşmeleri
tesadüfi. Tek bir *"boyut motoru"*nda birleştirme reddedildi.

→ `K-2.6.7` … `K-2.6.8a`

---

## A8 · Çok birim desteği

**SORU** — Koli/adet ayrımı desteklenecek mi?

**KARAR** — **Tek kanonik birim: adet.** Çevrim yalnız içe aktarma sınırında. Çekirdek
tablolarda birim alanı **hiç yok.**

**GEREKÇE** — Çok birim bir **iletişim** sorunudur, bir hesap sorunu değil.

> Çekirdekte iki birim yaşatmak, her hesap noktasına bir *"hangi birimde?"* sorusu enjekte
> eder. O soruların **biri** unutulduğunda on iki kat hata sessizce doğar. Tek kanonik birim,
> hata sınıfını **sınıfça yok eder.**

**Ve para tarafındaki kararın simetriği:** tek kanonik temsil, çevrim kenarda.

> **En iyi doğrulama, doğrulanacak alanın olmamasıdır.**

**Alanı silmek (üçüncü seçenek) yetmezdi** — kusuru kaldırır ama sorunu geleceğe iter, ve o
gün şema pahalı olur.

→ `K-2.1.12a` … `K-2.1.12f`

---

## A9 · Götürü harcama dağıtımı

**SORU** — Götürü harcama SKU'lara hangi tabana göre dağıtılır?

**KARAR** — Taban **planlanan hacim.** Ve dağıtım bir **rapor katmanı hesabıdır** — deftere
yazılmaz.

**GEREKÇE** — ⚠️ Önce **kritik ayrım:**

```
Hakediş/mutabakat:  götürü ANLAŞMA seviyesinde, dağıtılmaz
Kârlılık raporu:    görüntüleme anında dağıtılır
```

Üç kazanç: hakediş grain'i kirlenmez · plan revize edildiğinde dağıtım güncel kalır · pay
fonksiyonu `A2` ile ortaktır.

**Ve taban seçimi:** `A2` sonrası planlanan hacim **iki kaynağın birleşimi** — türetilmiş
paylar + insan kararları. Geçmiş hacimden **daha zengin.**

**Geçmiş hacim tabanı iki yönlü bozulma üretir:**

> Yeni ürün pay almaz, **ve** lansman maliyeti eski ürünlerin sırtına biner — onların
> kârlılığı da haksız kötüleşir.

⚠️ **`ADR 0006`'nın eski gerekçesi ölçümle yanlışlandı** — *"kaynakta formül yok"* deniyordu;
formül vardı, atlanan bir bölümdeydi.

→ `K-2.4.16` … `K-2.4.17c`

---

## A10 · Kısmi hesaplanmış gösterge

**SORU** — Kapsama eşiği olmalı mı?

**KARAR** — **Eşik yok.** Renk yalnız tam kapsamada. Ve `GRİ` **dördüncü bir birinci-sınıf
durumdur** — değer + kapsama rozeti + eksik listesi.

**GEREKÇE** — Üç kat:

**Kısmi kapsama, kısmi doğruluk değildir — bilinmeyen yönde yanlılıktır.**

> Maliyeti girilmemiş ürünler rastgele değil: tipik olarak yeni ürünler (lansman, düşük
> marj) ya da ithal/karma kalemler. Eksik dilim **sistematik olarak farklı marj** taşır.

**Eşik kaynaksız bir sabit olurdu.** Ve konfigüre edilebilir yapmak sorunu çözmez, **taşır**
— tenant yöneticisi o sayıyı neye göre seçecek?

**Bugünkü katılık bir hata değil, dürüst teşhistir.**

> **Renk bir güven beyanıdır, ve güven beyanı kısmi olamaz.**

**Ve mod açılma eşiği de aynı kararla çözüldü:** kademe açılması **tenant kararıdır**, bir
oran değil — `GRİ` mekanizması dürüstlüğü zaten taşıyor.

→ `K-2.4.22` … `K-2.4.22c` · `K-2.7.11`

---

# BÖLÜM B · Kapsam kararları

## B1 · Onay politikaları

**KARAR** — Politika **tablosu** + **üç görüşlü şablon.** Koşullu kural motoru **yok.**
Tenant şablon seçer ve eşik ayarlar — **kural yazamaz.**

**GEREKÇE** — Sabit akış artık bir seçenek değil, **birikmiş borç:** üç kararın Faz 2'si aynı
tabloya iniyor. Tablo gelmezse `İlke 3` **üç kez** ihlal edilir.

Ve tam motor bu segmentte kanıtlanmış aşırı mühendislik — *"ilk müşteride kimsenin
doldurmayacağı boş bir kural editörü."*

**Genişleme adayı şimdiden belli:** tutar eşiği + rol yönlendirmesi, otomatik ret değil.

## B2 · Bütçe politika modeli

**KARAR** — **İki boyut** (kanal, kategori), **çakışmasız**, **öncelik kolonu yok.** Zorunlu
joker varsayılan. Denetimli yazma. **İleriye dönük yürürlük.**

**GEREKÇE** — Öncelik eşleşmesi reddedildi:

> *"Çakışmada düşük öncelik kazanır"* kuralı, kullanıcının hangi eşiğin uygulandığını **tüm
> satırları zihinsel sıralamadan** bilememesi demektir — tabloya kaçışı üreten opaklığın ta
> kendisi.
>
> En-spesifik-kazanır + tekillik kısıtı ile **açıklanabilirlik bedava gelir.**

**Ve ileriye dönük yürürlük şart:** yazılmazsa *"eşiği düşürdüm, sistem neden eski planı
bloklamadı"* tartışması kapıda.

## B3 · Çok rollülük ve yetki istisnası

**KARAR** — Çok rollülük **evet** (birleştirme tablosu, union çözümleme). Kişiye özel yetki
istisnası **hayır** — kaynaktan bilinçli sapma.

**GEREKÇE** — Hedef segment 3-5 kişilik ekipler, ve *"en az iki onaycı"* kuralı tek-rol
modelinde tutmuyor. **Bu orta ölçeğin normali, istisnası değil.**

⚠️ **Kritik şart:** görev ayrılığı **kişiye bakar, role değil.**

> Yazılmazsa çok rollülük görev ayrılığını sessizce delerdi: *"finans rolüm var, kendi planımı
> finans sıfatıyla onayladım."* **Invariantların öznesi kullanıcıdır.**

**Kişi bazlı istisna**, *"yetki modeliniz nedir"* sorusuna **"tablo + kişiye özel delikler"**
cevabı verdirir.

## B4 · Onay zaman aşımı

**KARAR** — Faz 1'de **bildirim** (7 gün hatırlatma, 14 gün yükseltilmiş bildirim). Otomatik
durum değişikliği Faz 2. **Otomatik yükseltme reddedildi.**

**GEREKÇE** — Planlar meşru olarak gecikir (bayram, dönem kapanışı, fuar). Otomatik süre
dolumu **toplu plan ölümü** üretir — çözdüğü sorundan büyük gürültü.

**Ve otomatik yükseltme:** kimsenin vermediği bir onay kararını **zamanlayıcıya** verdirir.

⚠️ **Zamanlayıcı sıralaması:** ilk işler **idempotent-okuma** sınıfından.

> **Motoru zararsız işlerle pişir, finansal işi sonra bağla.**

## B5 · Kapasite hedefi

**KARAR** — Hedef **Yıl-1 projeksiyonu** (5.000 SKU · 10 eşzamanlı onay). Tavan iddiası
belgelerden **çıkarıldı.**

**GEREKÇE** — Test hedefi **kanıtlanacak iddiaya** göre seçilir, ve kanıtlanması gereken
iddia tavan değil. `10.000` testi **alakasız-pahalı.**

⚠️ **Ve ölçümün şekli:** SKU sayısı tek başına anlamsız — risk **SKU'ya çarpan işlemlerde.**

**Telemetri ön koşul:** *"hedef, ölçülemiyorsa süstür."*

## B6 · Bütçe transferi ve devir

**KARAR** — `TRANSFER` **Faz 1'e girer** ve blok kararının resmi kaçış yoludur. Devir **Faz 1
dışı.**

**GEREKÇE** — FMCG'de toplam bütçe **sabittir** — para bir yerden gelir. Transfer olmadan
kaçış yolu *"iki bağlanmamış işlem"* olur ve bütünlük sessizce kırılır.

> Transfer bir özellik değil, blok kararının **bütünlük tamamlayıcısı.**

⚠️ **Ve devir için bir cümle şart:** kapanışta kalan bakiye serbest bırakılır.

> Yazılmazsa kapanış kodu **fiili bir devir davranışı icat eder** — ve o varsayılan sonradan
> *"karar buymuş"* diye okunur.

---

# BÖLÜM C · Doğrulamalar

| # | Karar |
|---|---|
| C1 | Eşikler **iki merdiven**: davranış `80/90/100`, renk `80/95`. `%90` Faz 1'de **bildirim**, onay kapısı konfigürasyon. Ve ⚠️ **eşikler hakedişi durduramaz.** |
| C2 | `%100` bloğu **istisnasız.** Override yolu yok; meşru çözüm **zarf revizyonu** ve **transfer.** İki kontrol noktası, **tek hesap yolu.** |
| C3 | Süre bir **sınıflandırıcı olmaktan çıkarıldı** — davranışı `settlement_cadence` belirler. ⚠️ **Uçurum yerine kapı.** |
| C4 | Kendi gönderdiğini onaylama: **istisna yok.** Kapsam **gönderen ∪ son değiştiren** — bir bypass kapandı. |
| C5 | İçe aktarma yetkisi **fazlanır**: bugün finans, eşleştirme gelince planlamacı. Ve yeni bir görev ayrılığı invariantı: **importer ≠ eşleştirme onaylayan.** |

---

# Hâlâ açık

| Konu | Neyi bekliyor |
|---|---|
| ~~Rol kümesi~~ | ✅ **KAPANDI 2026-08-12** → `K-2.6.4` ailesi: beş rol, `Süper Yönetici` reddedildi |
| ~~Finans yöneticisinin onay hattı~~ | ✅ **KAPANDI 2026-08-12** → `K-2.5.12` ailesi: tek hat (şablon), devir bir **eylem**. `ADR 0002` → **`0002-R`** |
| Saklama sürelerinin bağlayıcılığı | **Hukuk** — ⏸️ `K-2.9.0`: mütalaaya dek **hiçbir kayıt silinmez** |
| ~~Kişi bazlı performans raporlaması~~ | ✅ **KAPANDI 2026-08-12** → `K-2.9.6`: rapor **süreç metriğidir**, kişi kimliği kırılım boyutu değil. Kişi bazlı versiyon `K-2.9.6a` ile **hukuk şartlı ertelendi** |
| Veri ayrımı modeli | Teknik ölçüm — geçiş maliyetleri |
| İadenin veri temsili | Teknik ölçüm — tek sorgu |

---

# Gerekçesi zayıf kararlar

> Dış denetim (`F5` ekseni) beş kararı *"sonuç muhtemelen doğru, dayanak zayıf"* diye
> işaretledi. Sonuçlar değişmiyor; **etiketleri** düzeltiliyor.

| Karar | Zayıflık | Düzeltme |
|---|---|---|
| `B4` zaman aşımı | *"Toplu plan ölümü"* senaryosu ölçümsüz | Metrik-önce kararı telafi ediyor. Ve `F3` temizlenince gerekçenin bir bacağı düştü: bekleyen plan bütçe yazmadığı için **finansal risk zaten yoktu** |
| `K-2.2.7b` %90 | *"Finansın istediği haberdar olmak"* doğrulanmadı | **Doğrulanmamış kullanıcı varsayımı** olarak etiketlendi |
| `A7` bölge | *"İhtiyaçsızlık ölçüldü"* fazla güçlü | **Tek vaka gözlemi** — kapanmış bir pilotun örneklemi. Karar ayakta; onay-ekseni gerekçesi tek başına yeter |
| `C4` görev ayrılığı | *"Bypass kapandı"* fazla güçlü | **Daraltıldı.** Artık açık: A hazırlar, B'ye tek hücre değiştirtip gönderttirir, A onaylar. Telafi: `K-2.5.14` karar anı göstergeleri + denetim izi |
| `B5` kapasite | *"Tipik kullanımın ~100 katı"* elma-armut | Aritmetik cümle **düşürüldü** — 40-50 plan satırı ile 5.000 katalog SKU'su aynı büyüklük değil |

---

# Kapsam dışı — bilerek

**Faz 2'ye bırakıldı:** devir · onay politikası kural yazımı · otomatik zaman aşımı · senaryo
analizi · bölge ekseni · yapay zeka kenarları.

**Hiçbir faza girmiyor:** muhasebe tahakkuku (ERP'nin işi) · kişiye özel yetki istisnası ·
karma çalışma biçimi · serbest biçimli kural motoru · orantısal atıf · kapsama eşiği.

> **Reddedilmiş bir seçenek, unutulmuş bir seçenekten iyidir.**

---

# Bu turun yöntem notu

Karar turuna girerken bir kural vardı: **kaynak bir girdidir, kanıt değil.**

Ve kullanıldı. Ama **ilk sayım yanlıştı** — dış denetim (`F4`) iki yanlış sınıflama ve üç
eksik madde ölçtü.

> Ve bu, `ADR 0006`'nın deseninin **kendi kayıtlarımızdaki** tekrarı: bir sınıflandırma
> ölçülmeden yazıldı.

## Kaynak ilişkisi — tek tablo

Dört tür ayrılır, ve karıştırılmamalıdır:

| Tür | Anlamı |
|---|---|
| **Sapma** | Kaynak açık bir şey diyor, biz başkasını seçtik |
| **Kaynağa dönüş** | Uygulamamız sapmıştı, karar kaynağa döndü |
| **Kaynak sessiz** | Kaynakta karşılığı yok — yeni karar, sapma değil |
| **Ekleme** | Kaynağın hiç sormadığı bir soruya kural |

| Kural / karar | Kaynak ne diyor | Bizim kararımız | Tür |
|---|---|---|---|
| `K-2.6.4` rol kümesi | `§2.1.2`'nin dörtlüsü (jenerik Approver) | Beş rol, bütçe-sahibi onaycı | **Sapma** — `§7.1`'in beşlisiyle fiilen hizalanma |
| `A7` yetki ekseni | Kanal · bölge · satış ekibi | + kategori | **Sapma** |
| `A1` çalışma biçimi | Üç katmanlı çözümleyici | Reddedildi | **Sapma** |
| `B3` yetki istisnası | Kişiye özel istisna tablosu | Yapılmaz | **Sapma** |
| `K-2.4.4` eksik veri | Eksik bağımlılığa `0` | `boş` | **Sapma** |
| `K-2.2.7b` %90 kademesi | *"Finans onayı gerekir"* — davranış | Varsayılan **bildirim** | **Sapma** ⚠️ |
| `K-2.6.14` içe aktarma | *"Planlamacı, Finans"* | Bugün yalnız finans | **Sapma** — geçici |
| `A9` götürü dağıtım | Planlanan hacim | Planlanan hacim | **Kaynağa dönüş** |
| `A3.c` atıf kuralı | — sessiz | Kanıt merdiveni | **Kaynak sessiz** |
| `A6` tahakkuk | Adı var, mekanizması yok | Operasyonel evet | **Kaynak sessiz** |
| `K-2.8.13/14` biçim | — sessiz | Belirsizlik reddedilir | **Ekleme** |
| `K-2.6.13` DB rolü | — sessiz | Ayrıcalıksız rol şart | **Ekleme** |
| `2.14` kurulum · `2.4.8` AI | — sessiz | Konumlanmadan türedi | **Ekleme** |

⚠️ **`K-2.2.7b` en dikkat gerektireni:** kaynağın açık davranış merdiveninden sapıyor ve
kural gövdesinde **sapma olarak işaretli değildi.** Ve gerekçesi (*"finansın istediği haberdar
olmak"*) hiçbir finans kullanıcısıyla **doğrulanmadı** — ilk müşteri finansıyla sınanacak.

## Ve kaynağın haklı çıktığı yerler

`A2`'de çekirdek bölüm · `A9`'da dağıtım tabanı · `C1`'de eşik değeri · `A4`'te iki örneğin
taban ayrımı.

> Kaynağı ne körü körüne izlemek ne toptan reddetmek — **madde madde ölçmek.**

---

# BÖLÜM Z · Dondurma ve faz kapanışı

> ⚠️ Bu bölüm **append**'tir. Yukarıdaki hiçbir kayda dokunulmamıştır.

## Z1 · BRD v2.0 DONDURULDU

```
KARAR — BRD v2.0 DONDURULDU (2026-08-15, ürün sahibi)

Kapsam: docs/brd-v2/ altındaki L0 · L1 · L2 · EK_A–EK_E paketi.
Kural sayısının kanonik kaynağı guard çıktısıdır (elle sayı yazılmaz).

Anlamı: yazma modu kapandı, bakım modu açıldı. Bu tarihten sonra pakette
hiçbir değişiklik doğrudan yapılmaz — her değişiklik önce karar defterine
kayıtla girer ve F12/0006-R deseniyle işlenir: eski kayıt silinmez,
"geri alındı / revize edildi (tarih, gerekçe)" iziyle üstüne yazılır.

Dondurma, açık madde yokluğu demek DEĞİLDİR. Açık kalanlar adreslidir ve
dondurmayı engellemez:
  · Hukuk-şartlı: K-2.9.0 (geçici askı) · K-2.9.6a · K-2.8.11/K-2.9.5/K-2.9.7
  · Ölçüm-şartlı: T-209 (discount_amount) · iade temsili · veri ayrımı modeli
  · Domain kuyruğu: F15 (dış talepte kategori) — ilk gerçek kesinti
    belgesiyle ya da danışman B-seti cevabıyla açılır

Sürüm işareti: git tag (brd-v2.0, annotated) — Team Lead atar ve origin'e
push'lar; tag push'u git log/ls-remote ile doğrulanır (rapor kanıt değildir).
```

### Dondurma anının kanıtı — ⚠️ SAYI DEĞİL, ÇIKTI

Dondurma anındaki guard koşusu **olduğu gibi** iliştirilmiştir:

> **`docs/verification/BRD_V2_DONDURMA_GUARD_CIKTISI_2026-08-15.txt`** — `EXIT 0`

⚠️ **Kural sayısı bu kayda YAZILMAMIŞTIR ve yazılmayacaktır.** Sabit bir sayı, dondurma
kaydının kendisinde `F8` üretirdi (*"sayı dört yerde dört farklıydı"*). Sayı sorulduğunda
guard koşulur; kanonik kaynak odur.

Üç ön koşul dondurma anında ölçüldü ve **üçü de tuttu**:

```
guard        EXIT 0    (temiz)
⛔ açık      0         (beklenen 0)
⏸️ askı      1         (beklenen 1 — K-2.9.0, hukuki mütalaa)
```

## Z2 · FAZ 0 KAPANDI

```
KAYIT — FAZ 0 KAPANDI (2026-08-15)

Üç çıkış ölçütü:
  1. Şema yeni modelle uyumlu — B dalgası: tek up/down, çıkarmalar dahil,
     seed atomik (kanıt: 0071 §1.1)
  2. Invariant/regresyon yeşil — 65/65 unit · 17/17 e2e · üç para baseline'ı
     kıpırdamadı (kanıt: 0071 §1.5)
  3. BRD v2.0 donduruldu — bu dağıtımın KAYIT 1'i

İNDİ ≠ KAPANDI — devredilenler bu kapanışın parçasıdır. Kanonik kaynak
0071 §1–§4 VE bu kayıt anındaki durum (0071'den sonra üç kalem kapandı):
  · T-212 KAPANDI — caaa6a5, dört kapı kırmızı-kanıtlı
  · T-113 KAPANDI — b0c8576, iki yönlü kanıt (yeni hata kırmızı ·
    baseline yeşil)
  · T-225 → pin KAPANDI — c671c22, beş dosya, üç dal ampirik
  · Hukuk paketi gönderimi AÇIK — DUR: muhatap kayıtta yok.
    Adım 0'ın tek kalan kalemi; muhatap tanımlanınca gönderilir
  · T-214 (Adım 3 ön kararı) · T-209/T-228/T-230 (kuyruk) ·
    K-2.9.0 askısı (hukuk dönüşüne dek)

Faz 1 durum anı (kapanış anında):
  Adım 0          3/4 kapandı — kalan: hukuk gönderimi (muhatap)
  Adım 1          K-2.6.13 BLOKLAYICISIZ — K-2.6.13a–f ve RLS sonda
                  kabul testi ONAYLANDI (ürün sahibi, 2026-08-15).
                  Başlayabilir.
  Adım 2          ölçüm paketi (5 ölçüm) — Adım 1 ile paralel
  Ürün sahibi     tek girdi: 0056-K3 (seed kararı) — Adım 3'ü bloklar,
                  Adım 1'i DEĞİL
  Dış kuyruk      hukuk paketi (muhatap bekliyor) · danışman turu
```

> 📌 **`Rev 2` izi:** bu bloğun ilk sürümündeki ileriye bakan tablo **bayattı**
> (`Adım 0`'ın üç kalemi kapanmış, `K-2.6.13a` onaylanmıştı). Dağıtımdan önce
> düzeltildi; **bayat sürüm dağıtılmadı.** Kaynak: `FAZ0_KAPANIS_VE_V2_DONDURMA.md`
> başlığındaki `Rev 2` notu.
