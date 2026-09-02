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

---

## Z3 · `K-2.6.13f`'ye ölçüm-evreni notu — dondurma sonrası İLK düzenleme

```
KAYIT — K-2.6.13f'ye NOT eklenir (2026-08-15, ürün sahibi)

Dondurma sonrası L2'ye yapılan İLK düzenleme. Kayıt önce gelir (Z1'in
şartı); bu kayıt o düzenlemeyi AÇAR.

Ne değişiyor: K-2.6.13f'nin gövdesi DEĞİL — altına bir ölçüm-evreni notu
eklenir. Kural aynı kalır.

Neden: ADIM 1'de S3 döngüsü koşturuldu ve bir izin FAZLALIĞI üretti —
app_runtime'a ledger_entries · admin_audit_logs · agreement_transactions
üzerinde DELETE. Ölçüldü: üretimde o tabloları silen yol 0; fazlalığın
kaynağı TEST temizliğiydi.

Sebep bir uygulama hatası değil, YÖNTEMİN EVRENİ:

  K-2.6.13f  "UYGULAMANIN fiilen hangi yetkileri kullandığı"
  S3 yöntemi "tam test SUITE koşulur → düşen izinler"

  Suite uygulama değildir.

Ve fazlalık zararsız değildi: K-2.11.7 "denetim kaydı uygulama katmanında
DEĞİL veritabanı seviyesinde korunur" diyor. DELETE hakkı, K-2.3.4 /
K-2.11.6 / INV-L-003'ün DB seviyesinde ihlal EDİLEBİLİR olması demekti.

Çözüm uygulandı (commit be00663): test temizliği artık app_migrate ile
bağlanıyor (test/helpers/admin-datasource.ts), üç DELETE kaldırıldı,
davranışsal olarak reddedildiği doğrulandı.

⚠️ Not KALICI olmalı çünkü sorun TEKRARLAYACAK: bir sonraki S3 turu (RLS
rolü, ya da başka bir ayrıcalıksız rol) aynı yöntemi kullanacak ve aynı
fazlalığı üretecek. Yöntemi kullanan kişi sınırı ÖNCEDEN bilmeli.
```

> **`F12`/`0006-R` deseni:** `K-2.6.13f`'nin gövdesi **silinmedi ve değişmedi** — altına
> bir not eklendi. Kural ne söylüyorsa onu söylemeye devam ediyor; eklenen şey **yöntemin
> sınırı**.

---

## Z4 · `0056-K3` KARARA BAĞLANDI — `EK_C`'nin `capabilities` satırını açan kayıt

```
KARAR — 0056-K3: yetenek granularitesi (2026-08-16, ürün sahibi)

Seçim: (b) — yetenek SABİT tanımlanır, TABLO YOK.
  capabilities.ts'te `const CAPABILITIES` + `ROLE_CAPABILITIES` haritası.
  Yetenek bir AD kazanır ve @RequireCapability yazılabilir; ama VERİ DEĞİL,
  yani tenant başına özelleştirilemez.

Reddedilenler:
  (a) 20 yetenek + tam CBAC tabloları — BRD modeli, ama seed kararını
      GEREKTİRİR ve tenant-başına özelleştirme bugün istenmiyor.
  (c) yalnız @Roles kapsamını tamamlamak — K-2.6.3'ü ("yetenekler tanımlı
      değil") karşılamaz, erteler.

Karar bugünkü ölçüme dayanıyor (Team Lead, 2026-08-16):
  toplam route 236 · @Roles taşıyan 159 · filtresiz 77
  → 0056'nın sayıları BAYAT DEĞİL, birebir tutuyor.

⚠️ SONUCU: `capabilities` ve `role_capabilities` TABLOLARI ÖLÜ YAPIYA düşer.
   B dalgası onları "T-165 ile dolacak" diye indirmişti; (b) ile dolmayacaklar.
   Ölçüldü: capabilities 10 kolon/0 satır · role_capabilities 9 kolon/0 satır ·
   Capability entity dosyası 0.
   Düşürülmeleri AYRI bir karar — [[T-233]].

İKİNCİ KARAR — users.permissions (ölü jsonb) DÜŞÜRÜLECEK.
  Ölçüldü: entity 1 · DB 1 · kodda OKUYAN 0.
  0056'nın uyarısı: "ölü bırakılırsa yetkinin ÜÇÜNCÜ olası yeri olarak kalır."
  Migration 1806000000000 tahsis edildi.
```

> **`F12`/`0006-R`:** `EK_C`'nin ilgili satırı **silinmiyor** — üstüne bu kararın izi
> yazılıyor. *"Neden `⏸️` idi"* kayıtta kalır.

---

## Z5 · `Z4`'ün bir ölçümü YANLIŞTI — *"Capability entity dosyası 0"*

```
DÜZELTME — Z4'ün ölçüm satırı (2026-08-16, Team Lead)

Z4 ve ona dayanan üç kayıt şunu yazdı:
    "Capability entity dosyası 0"

YANLIŞ. Ölçüm `ls entities/ | grep -ci capabilit` idi — o komut DOSYA ADI
sayar, SINIF değil. Doğru soru "bir @Entity sınıfı var mı"ydı, ve cevabı:

    role.entity.ts:36   @Entity({ name: 'capabilities' })       class Capability
    role.entity.ts:49   @Entity({ name: 'role_capabilities' })  class RoleCapability
    ALL_ENTITIES'te     4 atıf

İkisi de `role.entity.ts` İÇİNDE tanımlıydı — ayrı dosyada değil.

⚠️ Sonucu SESSİZ olurdu: yalnız DROP TABLE yazılsaydı, bir sonraki
`migration:generate` iki tabloyu GEREKÇESİZ geri getirirdi (T-101'in vakası:
"şema kararını geri alırken entity metadata'sını da geri al").

Yakalayan: data-engineer, migration'ı yazarken. Team Lead'in ölçümü değil.

📌 SINIF: yanlış yüzeyin dilinde arama. `decimal`↔`numeric` ve barrel-import
tuzağının aynısı — desen çalıştı, EVREN yanlıştı.

Kararın kendisi DEĞİŞMEDİ: tablolar ölü yapıydı (0 satır, üretim tüketicisi
0) ve düşürüldü. Değişen tek şey İŞİN KAPSAMI: entity sınıfları da kaldırıldı.
```

> **`F12`/`0006-R`:** `Z4`'ün metni **silinmedi** — bu kayıt onun üstüne yazıyor.
> *"Ne ölçülmüştü ve neden yanlıştı"* ikisi de kalsın.

---

## Z6 · `EŞİKLİ` kalemi KAPANDI — `EK_C`'nin *"seçim yolu yok"* cümlesi artık geçersiz

```
KAYIT — T-214 kapandı, EK_C'nin EŞİKLİ bloğu güncellenir (2026-08-17)

Dondurma sonrası DÖRDÜNCÜ EK düzenlemesi. Kayıt önce; düzenlemeyi bu açar.

⚠️ EK_C'nin bloğu BAYAT DEĞİL — teşhisi DOĞRUYDU ve öyle kalıyor:
  · "satır = tenant'ın politikası" (tenant_id NOT NULL)
  · CHECK, THRESHOLD + NULL'u INSERT anında reddediyor
  · THRESHOLD satırı eşik girilene kadar YAZILMAZ

Bayatlayan TEK cümle şu:

  "approval_policies'i tüketen 0 modül var, SEÇİM YOLU YOK. Yani kısıt
   kaldırılır, yerine HİÇBİR ŞEY konmaz (§4.2: mekanizma var, yol yok)."

b92a725 o yolu AÇTI: PATCH /approval-policies/:id, @Roles(ADMIN), tek
çağrıda şablon + eşik (K-2.5.13c: "seçer VE ayarlar").

Yani kabul şartının "GÖSTERİLEMEZ" dediği ikinci yarısı — "seçilmeye
çalışılınca reddedilir" — artık GÖSTERİLİYOR:

  THRESHOLD + eşiksiz  → 400, açık mesaj (500 DEĞİL)   e2e ile pinli
  STANDARD  + eşik     → 400                            e2e ile pinli

📌 Bu bir DÜZELTME değil, bir KAPANIŞ: blok bir eksikliği doğru teşhis
etmişti ve eksiklik kapandı.

── VE T-214'ün asıl kararı ─────────────────────────────────────────────

Model DEĞİŞMEDİ (78de03e): katalog = enum (kod) · seçim = satır (veri) ·
parametre = aynı satır. Şema bunu ZATEN zorluyordu; eksik olan yoldu.

⚠️ THRESHOLD hâlâ SEED'LENMEZ ve bu doğru: X bir tenant değeridir, ürün
varsayılanı değil. Tenant onu ucu kullanarak girer.
```

> **`F12`/`0006-R`:** blok **silinmiyor** ve teşhisi **değişmiyor** — yalnız *"seçim yolu
> yok"* cümlesinin üstüne kapanış izi yazılıyor.

---

## Z7 · `R2b`'nin enum KEY kısmı `ADIM 3`'e girer — erteleme gerekçesi GEÇERSİZLEŞTİ

```
KARAR — R2b/key ADIM 3 kapsamına alınır (2026-08-17, ürün sahibi)

EK_C 2026-08-13'te şöyle ertelemişti:
  "Enum KEY'i R2b'ye ertelendi. ... Değer doğru, key kozmetik —
   DALGAYI BÜYÜTMEYE DEĞMEZ."

⚡ O gerekçe ARTIK GEÇERSİZ, ve iki sebeple:

1 · DALGA ZATEN O DOSYALARA DOKUNUYOR. ADIM 3 (K-2.6.3 + K-2.6.6) @Roles
    dekoratörlerini ve rol haritasını yazacak — yani "dalgayı büyütme"
    maliyeti sıfıra indi.

2 · KOZMETİK OLMAKTAN ÇIKTI. ROLE_CAPABILITIES rollerle ANAHTARLANACAK, ve
    UserRole.FINANCE_MANAGER'ın DEĞERİ 'FINANCE' — yani haritanın anahtarı
    ile veri değeri AYRIŞIR. EK_C'nin kendi uyarısı bunu adlandırıyor:
    "ad benzerliği ile anlam ayrışması — bu turda İKİ KEZ ısırdı."

Ölçülmüş zemin (0072, 2026-08-17):
  ölü DEĞERLER  APPROVER 0 · MANAGER 0 · eski FINANCE 0   ✅ R2b'nin bu
                yarısı İNDİ
  enum KEY      FINANCE_MANAGER = 'FINANCE'               ⏸️ inmedi
  kullanım      64 uçta UserRole.FINANCE_MANAGER

⚠️ MİGRASYON SIRASI UYARISI HÂLÂ GEÇERLİ (EK_C): "önce SİL, sonra YENİDEN
ADLANDIR" — ama eski FINANCE zaten silindi, yani bu tur yalnız yeniden
adlandırma. Yine de 64 çağrı yeri değişir → ADIM 3'ün DUR listesine girer.
```

> **`F12`/`0006-R`:** `EK_C`'nin erteleme notu **silinmiyor** — üstüne bu kaydın izi
> yazılıyor. *"Neden ertelenmişti"* kayıtta kalır.

---

## Z8 · Plan → bütçe etkisinin netleştirilmesi

**Tarih:** 2026-08-16 · **Kaynak:** dış değerlendirme turu
**Kaydeden:** Team Lead (tek kanal) · **Karar:** ürün sahibi

Dört madde `L2`'ye girer. Üçü kural, biri ölçüm.

⚠️ **Dondurma sonrası ilk kayıtlı `L2` KURAL EKLEMESİ** — `Z1` rejiminin ilk gerçek
testi. Guard'ın kural sayısı **artacak; bu beklenen.**

> 📌 `Z3` dondurma sonrası ilk **düzenlemeydi** (mevcut bir kurala not); bu, ilk
> **ekleme**. İkisi farklı sınıf: birincisi metni değiştirir, ikincisi sayıyı.

### Girdi belgesi

`docs/decisions/PLAN_BUTCE_NETLESTIRME.md` (2026-08-15, Fable derledi, ürün sahibi
onayladı). Çekirdek karar **değişmedi**: onay bekleyen plan deftere yazmaz; bütçeye
dokunan tek an onaydır (`K-2.2.9i` ailesi). Kilitleme / soft-reserve **reddedildi**.

> Uzman itirazının kabul edilen çekirdeği: **kilitlemesiz model, görünürlük olmadan
> savunulamaz.**

### Ne indi — ve nereye

| # | kural | dosya · yer | numara |
|---|---|---|---|
| 1 | bekleyen kuyruk görünürlüğü + değişmez sınır | `L2_01` · `K-2.2.9i`'den sonra | `K-2.2.9i1` · `K-2.2.9i2` |
| 2 | toplu onay = sıralı tekil onaylar | `L2_03` · `K-2.5.6`'dan sonra | `K-2.5.6a` · `K-2.5.6b` |
| 3 | raporlama yolları kiracı izolasyonuna tabi | `L2_03` · `K-2.6.12`'den sonra | `K-2.6.12a` |
| 4 | negatif kullanılabilirlik invariantı — **ölçüm** | `FAZ1_PLAN` `Adım 2`, 6. satır | — |

### ⚠️ Kural 3'ün yeri Team Lead tarafından DEĞİŞTİRİLDİ — gerekçesiyle

Ürün sahibi *"`L2_02` · `2.11` bölümüne, `K-2.11.x`"* dedi ve **numara tahsisini Team
Lead'e bıraktı.** Ölçüldü:

```
L2_02 §2.11        DENETİM KAYDI bölümü  (2.11.1 Kapsam … 2.11.4 Saklama)
K-2.6.12           KİRACI İZOLASYONU     — L2_03 §2.6.5 "Veri izolasyonu", satır 594
```

Kural metninin konusu **kiracı izolasyonu** (`K-2.6.12`'ye açık atıf), denetim kaydı
değil. `K-2.11.x` olarak yazılsaydı **denetim bölümünün içinde izolasyon kuralı**
dururdu — `F8` sınıfının belge tarafındaki hâli (*"aynı soru iki yerde"*).
`K-2.6.12a` olarak, kaynağının **yanına** yazıldı.

### ⚠️ Ve girdi belgesiyle bir SAPMA — kayda geçiyor, sessiz kalmıyor

`PLAN_BUTCE_NETLESTIRME.md`'nin 3. maddesi *"rapor izolasyonu"* diyordu ve konusu
**bekleyen talebin raporlara girmemesiydi.** Bu kayıttaki Kural 3'ün konusu ise
**kiracı izolasyonu** — farklı bir şey.

**Team Lead okuması:** ikisi çelişmiyor, çünkü girdi belgesinin 3. maddesi
`K-2.2.9i2` tarafından **zaten kapsanıyor** (*"bekleyen toplam hesaba, renge ve blok
mantığına asla girmez"* — bir rapor rakamı bir hesaptır). Kural 3 bunun **yerine
geçmiyor, üstüne ekleniyor.**

> Bu bir **okuma**dır, ölçüm değil. Ürün sahibi aksini söylerse `F12` deseniyle
> düzeltilir.

### Kullanıcı dili — `L2`'ye GİRMEZ

> *"Gönderim bir taleptir, onay bir taahhüttür; para taahhütte ayrılır, talepte
> görünür. Sıradaki herkes aynı bakiyeyi görür — bakiyeyi yalnız onaylanan alır."*

Yeri: `URUN_OZETI` ya da bir arayüz metni kaynağı. **`L2` bir iş kuralı belgesidir,
bir anlatım kaynağı değil.**

### Açık kalan (bu kayıtla kapanmaz)

`PLAN_BUTCE_NETLESTIRME.md`'nin dağıtım listesinden **danışman C-seti sorusu** hâlâ
açık: *"Gönderilen ama onaylanmamış talepler sahada bütçeyi fiilen 'tutar' mı; hangi
model kaosa dönüşür?"* — uzman görüşü ilk saha verisi olarak işlenir (dayanak:
**gözlem**).

Ve gelecek seçenek, **bugün yapılmıyor**, kayıt için: pilotta kronik çekişme kaosu
**ölçülürse** *"gönderim kontrolü: bilgilendirici | katı"* bir tenant politikası olarak
eklenebilir. `İlke 1` — kanıt gelmeden eklenmez.

---

## Z9 · `00_PAKET_INDEKSI`'nden bölüm dağılımı satırı KALDIRILDI

**Tarih:** 2026-08-18 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead (tek kanal)
**Açtığı düzenleme:** `00_PAKET_INDEKSI.md` — donmuş belge, `Z1` şartı gereği bu kayıt önce.

### Bulgu (`Z8` turunun yan ürünü)

`guard.sh` kural **toplamını** denetliyor ve `Z8`'de doğru şekilde ateşledi
(`indeks 375 ↔ gerçek 380` → ⛔). Ama **bölüm dağılımını yalnız BASIYOR**, kontrol
etmiyor. Ölçüldü:

```
indeks satırı   147 + 49 + 89 + 89 = 374
kendi toplamı   375        ← KENDİYLE bile tutmuyordu
gerçek          150 + 49 + 92 + 89 = 380
```

**Ne zaman bayatladığı bilinmiyor — çünkü hiç kırmızıya dönmedi.**

### Karar: **(b)** — satır tümüyle kalkar

| şık | neden reddedildi / seçildi |
|---|---|
| (a) guard dağılımı da denetlesin | ⛔ indekste **elle tutulan bir sayı daha** kalır — `F8`'i çözmez, ikinci bir bekçiyle **erteler** |
| (c) satır kalsın + uyarı | ⛔ *"bir uyarı bir kapı değildir"* — `Z8` turunda bu geçici olarak yapıldı, kalıcı çözüm değil |
| **(b) satır kalksın** | ✅ `CLAUDE.md`: *"kural sayısı hiçbir belgeye yazılmaz — **kanonik kaynak `guard.sh` çıktısıdır**."* Dağılım bir **teşhis bilgisidir, bir sözleşme değil**; guard onu zaten basıyor, okumak isteyen oradan okur |

> **Ürün sahibi gerekçesi:** *"İndeksin bölüm dağılımı ikinci bir kopya — guard onu
> denetlemiyor, yani `F8`'in tam tanımı: elle tutulan sayı bayatlar, ve bayatladığını
> söylemez."*

⚠️ **Ve `L2` kural toplamı satırı KALIYOR** — o guard tarafından denetleniyor, yani
bayatladığında **kırmızıya döner**. Ayrım budur: **denetlenen sayı kalır, denetlenmeyen
sayı kalkar.**

### `F12` izi

Satır **silinmiş** olarak kaydedilir; *"burada bir dağılım vardı ve neden kaldırıldı"*
sorusunun cevabı bu kayıttır. Silinen içerik (son doğru hâli):
`150 · 49 · 92 · 89`.

---

## Z10 · `Açık karar (kural dışı)` satırından SAYI düşürüldü — liste kalır

**Tarih:** 2026-08-18 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead (tek kanal)
**Açtığı düzenleme:** `00_PAKET_INDEKSI.md` (donmuş belge — `Z1` şartı)
**Bağlam:** `Z9`'un kör nokta taramasının bulduğu ikinci vaka.

### `Z9` kararı VERMEDİ, soruyu SORDU — cevap bu kayıt

`Z9` şunu ölçmüştü: `Açık karar (kural dışı) | **2** — veri ayrımı modeli · iade
temsili` satırı **guard tarafından denetlenmiyor**, yani bölüm dağılımıyla **aynı
sınıf**. Ama *"daha zayıf vaka"* diye işaretlendi ve karar ürün sahibine bırakıldı —
çünkü o hücre sayıyı **kendi listesiyle** taşıyor, yani aynı hücrede doğrulanabilir.

### Karar: **sayı düşer, liste kalır**

> **Ürün sahibi gerekçesi:** *"Sınıf aynı: liste ile sayı ayrışırsa hiç kırmızıya
> dönmez. Ve sayının hiçbir işi yok — liste zaten iki madde gösteriyor. `2` yazmak,
> okuyucuya saymayı kolaylaştırmıyor, yalnız bir **bayatlama yüzeyi** ekliyor."*

```
önce   | Açık karar (kural dışı) | **2** — veri ayrımı modeli · iade temsili |
sonra  | Açık karar (kural dışı) | veri ayrımı modeli · iade temsili |
```

📌 **`Z9`'dan farkı:** orada satırın **tamamı** kalktı, çünkü taşıdığı dört sayının
hiçbiri kendi içinde doğrulanamıyordu. Burada **taşıyıcı bilgi (liste) değerli**,
yalnız sayı gereksiz. **Aynı ilke, farklı kesim.**

### İlkenin son hâli — üç kayıtta oluştu

```
Z8   guard'ın denetlediği sayı bayatladı → kapı ateşledi, sayı güncellendi
Z9   guard'ın denetlemediği sayı → satır KALKTI
Z10  guard'ın denetlemediği sayı, ama taşıyıcı bilgi değerli → SAYI kalktı, LİSTE kaldı
```

> **Denetlenen sayı kalır. Denetlenmeyen sayı kalkar — ve yanındaki bilgi değerliyse
> yalnız sayı kalkar.**

---

## Z11 · `A7`'nin **kanal ekseni** kod tarafında DÜŞTÜ — `user_scopes.channel_id` kaldırıldı

**Tarih:** 2026-08-18 · **Karar:** ürün sahibi (`T-238`) · **Kaydeden:** Team Lead
**Açtığı düzenleme:** `L2_03` `K-2.6.7` · `EK_C_VERI_SOZLUGU.md` (ikisi de donmuş — `Z1`)
**Bulan:** `code-reviewer` (`7ece5a9` review'u) — **blocker olarak**

### ⚠️ Bu kayıt bir DÜZELTMEDİR: `T-238` gerekçesi EKSİKTİ

`T-238` `DROP`'u `K-2.1.4` · `K-2.6.7a` · `K-2.6.7b` ile gerekçelendirdi. **Kanalı eksen
ilan eden üç kaynağa hiç değinmedi:**

```
04_KARAR_KAYDI  A7   "KARAR — Kapsam kanal + müşteri + kategori KALIR"
L2_03           K-2.6.7  "Yetki kapsamı ÜÇ EKSENDE tanımlanır: kanal · müşteri · kategori"
EK_C            kullanici_kapsamlari → "kanal · müşteri · kategori referansları"
```

Ve karar defterinde `T-238` · `channel_id` · *"kanal ekseni"* için **sıfır** kayıt vardı
(ölçüldü). Yani dondurulmuş bir ek (`EK_C`) **kayıtsız olarak yanlış kılınıyordu.**

### ⛔ Ve gerekçenin YÖNÜ eksikti — asıl bulgu bu

`T-238` şöyle diyordu: *"`DROP` bir yetenek kaybetmiyor, kullanılmayan bir kısayolu
kapatıyor."* **Bugünkü KOD için doğru** (okuyan `0`, yazan `0` — ölçüldü). **Kural için
DEĞİL:**

```
K-2.1.4 garanti eder   müşteri → kanal       GARANTİLİ (cpls.channel_id NOT NULL, tekil FK)
kapsamın ihtiyacı      kanal → {müşteri}     ZAMAN İÇİNDE SABİT DEĞİL
```

*"X kanalındaki tüm müşteriler"* kapsamı, kolon düştükten sonra ancak CPL'ler **tek tek
sayılarak** yazılabilir — ve **sayım eşdeğer değildir**: yarın o kanala eklenen bir CPL
kullanıcının kapsamına **girmez**.

📌 **Ve bu varsayımsal değil, ürünün bugünkü davranışı:**
`src/database/seeds/user-scope.seed.ts:217-219` planlamacıların kanal kapsamını tam olarak
böyle kuruyor — `cplRepo.find({ where: { channelId } })`, yani **o anki** CPL listesi.

> `CLAUDE.md`: *"bir düzeltmenin iki ekseni vardır: hedefi ve yönü. Hedef hatası görünür;
> yön hatası görünmez."* Burada hedef doğruydu (kolon gerçekten ölüydü), **yön eksikti**
> (kolonun ölü olması, eksenin gereksiz olduğunu göstermez).

### KARAR — `DROP` GEÇERLİ, ama sapma olarak KAYITLI

Ürün sahibi kararı **değişmiyor**: kolon düştü (`7ece5a9`, migration `1809`). Gerekçe
`İlke 1` (ihtiyaçsızlık ölçüldü) + `İlke 4` (ikinci ve zorlanmayan kaynak) — ve
**yeniden tartışılmıyor.**

Değişen şey **kaydın kendisi**: `A7`'nin kanal ekseni bugün **uygulanmıyor**, ve bu
artık `K-2.6.9`'un deseniyle **görünür**:

```
A7 KARAR        kanal + müşteri + kategori          ← KURAL, geçerli
kod bugün       müşteri (cpl) + kategori            ← UYGULAMA, eksik
kanal kapsamı   CPL sayımıyla ifade edilir          ← ve sayım EŞDEĞER DEĞİL
```

**`F12` izi:** `A7` kaydı **silinmiyor** — bu kayıt onun üstüne *"kod tarafında
uygulanmıyor (2026-08-18, `T-238`)"* izini yazıyor. Karar hâlâ karar; **uygulama** sapıyor.

### Bunun açtığı iş

`docs/analysis/0056` `K5` (*"Kapsam eksenleri: `channel` açılsın mı?"*) **açık bir
karardı** ve bu commit onu fiilen `(c)` yönünde kapatıyor. ⚠️ Ve `0056:510`'un
`(b)` şıkkı *"kolonu **zaten var** … migration **gerekmez**"* diyordu — **bu cümle
artık YANLIŞ**, düzeltildi.

⚠️ `ADR 0001:101` de *"CTPM `user_scopes` cpl+category+**channel**"* diyordu — bağlayıcı
bir belgede bayat bir olgu; düzeltildi.

→ Kanal ekseni bir gün gerekirse yol **`K-2.6.7a`'nın bölge deseni**: mekanizma
**kanıtlanmış talep** üzerine açılır. Fark: bölgede mekanizma tam kuruluydu ve korundu;
burada kolon boştu ve düştü — **yeniden açmak bir migration gerektirir.** Bu bedel
bilinçli kabul edildi.

---

## Z12 · `EK_E`'de iki satır güncellendi — `T-241` arayüzü KIRDI

**Tarih:** 2026-08-20 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead
**Açtığı düzenleme:** `EK_E_YETENEK_ARAYUZ_ESLEMESI.md` (donmuş — `Z1`, **yedinci
uygulama**)
**Bulan:** `code-reviewer` (`dfdbe7f` review'u) — **`B2` blocker'ı**

### Bulgu

`T-241` (`POST /users` rol + kapsam birlikte) **backend sözleşmesini değiştirdi**, ve
frontend'in kullanıcı ekleme formu bu sözleşmeyi bilmiyor:

```
collmind.frontend/src/types/user.types.ts:52-65   CreateUserDto'da `scope` alanı YOK
collmind.frontend/src/components/forms/UserForm.tsx:153   Object.values(UserRole)
                                                          → PLANNER ve CM seçilebilir
collmind.frontend/src/components/forms/UserForm.tsx:54    VARSAYILAN rol = PLANNER
```

⚠️ **Yani varsayılan yol kırık:** formu açıp hiçbir şey değiştirmeden kullanıcı
yaratmak artık **`400`** döner.

📌 `CLAUDE.md`'nin *"bir DUR listesi her sınırı saymalı"* + *"kabul listesi
BOZABİLECEĞİNİ de saymalı"* maddelerinin vakası: `T-241`'in `touches:` alanı yalnız
backend'i sayıyordu ve metninde **`frontend`/`arayüz` kelimesi hiç geçmiyordu**.
Eksiklik yapılmamış değil — **kayıtlı da değildi.**

### `EK_E`'de iki satır

| satır | önce | sonra | gerekçe |
|---|---|---|---|
| Kullanıcı yönetimi | `🔶` | **`⚠️`** | `EK_E`'nin kendi tanımı: *"yetenek var, arayüzü var, **kırık**"* |
| Kapsam atama | `🔶` filtre kapalı | **`🔒`** | *"yetenek var, arayüzü **yok**"* — `T-241` yazma yolunu **açtı**, ama onu besleyecek **hiçbir ekran yok** |

> `EK_E`: *"`🔒` en pahalı durumdur: iş yapılmış, tamamlanmış, test edilmiş — ve
> kullanıcıya ulaşmıyor. Bir `❌` dürüsttür; bir `🔒` israftır."*
>
> ⚠️ Ve *"`🔒` bir kabul değil, bir **alarmdır**"* — bu yüzden [[T-243]] açıldı.

### Sıralama kararı — `B1` önce, `B2` sonra (ürün sahibi)

```
B1   güvenlik kusuru, fail-open, CATEGORY_MANAGER'da BUGÜN CANLI   → önce (25f6b07)
B2   yetenek kaybı, ekran çalışmıyor, prod etkisi YOK (lokal)      → sonra (T-243)
```

> *"`B1` açık bir delik, `B2` kapalı bir kapı. Ve kapalı bir kapı kimseye zarar
> vermiyor."*

Ve `B2`'nin brief'i **`B1` kararından SONRA** yazıldı — bilinçli: joker yasaklandığına
göre `UserForm`'un kapsam seçicisi **zorunlu** olacak, opsiyonel değil. Önce yazılsaydı
**iki kez** yazılacaktı.

### ⚠️ Bir yan gözlem — `EK_E`'nin sayım bloğu GUARD'SIZ

Bu düzenleme `EK_E`'nin *"Sayım"* tablosunu da değiştirdi (`🔶 8→6` · `⚠️ 5→6` ·
`🔒 2→3`). O tablo **elle tutuluyor ve `guard.sh` ona bakmıyor** — `Z9`/`Z10`'un
kapattığı sınıfın **aynısı**, `EK_E` yüzeyinde.

**Bu turda kaldırılmadı** — `Z10`'un ayrımı gereği karar ürün sahibinin: sayılar
yanlarındaki listeyle (dört durum satırı) doğrulanabilir mi, yoksa bağımsız bir
bayatlama yüzeyi mi? Şimdilik **güncellendi ve doğru**; kalıcı karar açık.

---

## Z13 · `EK_E`'nin SAYIM bloğu KALDIRILDI — `Z10`'un birebir uygulaması

**Tarih:** 2026-08-20 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead
**Açtığı düzenleme:** `EK_E_YETENEK_ARAYUZ_ESLEMESI.md` (donmuş — `Z1`, **sekizinci
uygulama**)
**Bulan:** Team Lead, `Z12` turunun yan gözlemi

### Bulgu

`Z12` `EK_E`'de iki satır değiştirdi, ve bu **sayım bloğunu** da değiştirmek zorunda
bıraktı (`🔶 8→6` · `⚠️ 5→6` · `🔒 2→3`). O blok **elle tutuluyor** ve `guard.sh` ona
**bakmıyor** — `Z9`/`Z10`'un kapattığı sınıfın aynısı, `EK_E` yüzeyinde.

### Karar: **sayım bloğu kalkar** — `Z10`'un ayrımı birebir

> **Ürün sahibi:**
> ```
> sayılar   dört durum satırının TÜREVİ — bağımsız bilgi taşımıyor
> liste     her yeteneğin işareti ZATEN satırında
> ```
> *"Sayım bloğu hesaplanabilir, ve elle tutulduğu için bayatlar."*

`Z10`'da hücre sayıyı **kendi listesiyle** taşıyordu ve *"daha zayıf vaka"* diye
işaretlenmişti; orada **sayı** düştü, **liste** kaldı. Burada aynı ilke tabloya
uygulanıyor: **işaretler satırlarında kalır, toplamları kalkar.**

⚠️ **Ve `Z9`'dan farkı yok** (ürün sahibi tespiti): orada dağılım guard'ın **bastığı**
bir teşhisti; burada sayım **tablonun kendisinden** okunuyor. **İkisi de türev.**

### İlkenin tamamlanmış hâli — beş kayıtta

```
Z8    guard'ın DENETLEDİĞİ sayı bayatladı        → kapı ateşledi, sayı güncellendi
Z9    guard'ın denetlemediği sayı, taşıyıcı YOK  → SATIR kalktı
Z10   guard'ın denetlemediği sayı, taşıyıcı VAR  → SAYI kalktı, LİSTE kaldı
Z12   (yan gözlem) aynı sınıf EK_E'de bulundu
Z13   türev bir sayım tablosu                    → TABLO kalktı, işaretler kaldı
```

> **Denetlenen sayı kalır. Denetlenmeyen sayı kalkar. Türev bir sayı hiç yazılmaz —
> kaynağından okunur.**

### `F12` izi

Silinen bloğun son doğru hâli (2026-08-20, `Z12` sonrası):
`✅ 21 · 🔶 6 · ⚠️ 6 · 🔒 3 · ❌ 38`.

📌 Yerine **nasıl sayılacağı** yazıldı — sayının kendisi değil. *"Bu tabloyu okuyan,
işaretleri satırlardan sayar"*: bir sonraki okuyucu sayıyı **isterse üretir**, ve
ürettiği sayı **tanımı gereği güncel** olur.

⚠️ **`İki 🔒 vakası — öncelikli`** başlığı da bir sayı taşıyordu ve artık **üç** vaka
var (`Kapsam atama` eklendi). Başlık sayısızlaştırıldı; bölümün kendisi vakaları
**adıyla** sayıyor.

---

## Z14 · `EK_E`'ye `T-220`'nin SINIFI eklendi — semptom kayıtlıydı, sınıf değil

**Tarih:** 2026-08-20 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead
**Açtığı düzenleme:** `EK_E_YETENEK_ARAYUZ_ESLEMESI.md` (donmuş — `Z1`, **dokuzuncu**)

### Bulgu (`0074 §6.2`'nin şerh ölçümü)

`T-220` **ertelendi** (izolasyon kusuru değil, `Faz 3` konusu) — ve ürün sahibi
*"sessizce ertelenmesin"* dedi. Ölçüldü: `EK_E`'de **görünür**, ama **yanlış
seviyede**:

```
EK_E:124  "Renk (RAG) ⚠️ — Kapsama oranı istemciye ulaşmıyor"    ← SEMPTOM
T-220     "hesaplanamayan bir değer NEREDE bir iş yargısına
           çöküyor" — beş nokta, iki repo                         ← SINIF
```

> **Ürün sahibi:** *"`D1` turunda tam bu ısırdı: `|| 'GREEN'` aradık, `AMBER`'e çökme
> kaçtı. `EK_E`'ye bir satır yeterli — sınıfın adı ve `T-220` adresi. Yoksa bir
> sonraki okuyucu **semptomu kapatıp sınıfı açık bırakır.**"*

### Eklenen

`E.5` bölümüne bir satır: **`null` → iş yargısı çöküşü** · `⚠️` · adres `T-220`.

📌 Bu, `Z13`'ün *"liste kendini doğrular — **ancak liste TAMSA**"* dersinin ikinci
uygulaması: orada eksik olan bir **vaka**ydı, burada eksik olan bir **sınıf**.

---

## Z15 · Kapsam güncelleme — **sıra + üç karar**, ve denetim biçimi SÖZLÜĞÜN İLK MADDESİ

**Tarih:** 2026-08-20 · **Karar:** ürün sahibi · **Kaydeden:** Team Lead (tek kanal)
**Etkilediği:** [[T-244]] · [[T-242a]] · `FAZ1_PLAN` `ADIM 6`

### 0 · SIRA — `T-244` önce, **dar kapsamla ve bir ÇAPA şartıyla**

`İlke 4`, **iki seviyede**:

```
seviye 1   T-242a önce giderse   → ikinci bir kayıt biçimi doğar,
                                    ve birleştirilmesi HİÇ YAPILMAZ
seviye 2   T-244 kendi başına    → sözlük (ADIM 6) geldiğinde ÜÇÜNCÜ
           bir biçim tanımlarsa    uyumsuzluk adayı oluruz
```

> **Çözüm (ürün sahibi):** *"`T-244`'ün biçimi, **denetim sözlüğünün ilk maddesi**
> olarak tanımlansın — yani `T-244` **bağımsız bir format değil**, **sözlüğün erken
> açılan ilk sayfası**. Böylece hem `T-242a` bloktan çıkar hem `ADIM 6` geldiğinde
> biçim zaten **evinde**."*

📌 Bu, `ADIM 2` ölçümünün bulgusunu doğrudan adresliyor: *"kanonik sözlük **YOK**,
dört ayrı aile"* — sözlük **artık var**, tek maddeyle açıldı.

⚠️ **Ve `ADIM 2`'nin ölçümü sözlüğün TABANI**, yeniden sayılmaz.

### 1 · Uç şekli — **TAM DEĞİŞTİRME** (declarative replace)

> **Kapsam bir KÜME DURUMUDUR, olay akışı değil.**

Ekle/çıkar modelinin üç maliyeti:

```
sıra bağımlılığı
kısmi-başarı ara durumları
⚠️ ve ASIL ÖNEMLİSİ: R1/R2 guard'larının ARA DURUMLARI denetleme zorunluluğu
   — CATEGORY_MANAGER joker sızıntısı tam böyle bir ara-durum vakasıydı
```

**Replace'te:** güvenlik kontrolleri **tek noktada**, **hedef durum** üzerinde koşar ·
istek **idempotent** · denetim kaydı doğal olarak *"eski küme → yeni küme"* olur ve
**`T-244` biçimini basitleştirir.**

📌 Ekle/çıkar **ergonomisi UI'nin işi**: ekran diff'i hesaplar, **tek replace** gönderir.
Ve `T-241`'in **atomik-yaratma** deseniyle **simetrik**.

### 2 · Boşaltma — **izinli, ama SESSİZ OLAMAZ**

`K-2.6.8a` doğru kural, ve boş küme **meşru bir hedef durum** (ayrılan kullanıcı,
askıya alma). ⚠️ **Risk kural değil, KAZA:**

> UI hatası boş dizi yollar → kullanıcı **sessizce kilitlenir** → ve bunu **hiçbir test
> yakalamaz**. **Sessiz-yıkım sınıfı.**

**Çözüm onay diyaloğu DEĞİL** (o UI katmanında yaşar ve **API'yi korumaz**) —
**açık niyet alanı**:

```
aynı uçta      intent: UPDATE | REVOKE_ALL
doğrulama      boş küme ∧ intent ≠ REVOKE_ALL  →  RET
```

**Tek uç, tek kod yolu** (`İlke 4` korunur) — boşaltma **ayrı mekanizma değil**, aynı
ucun **bilinçli-niyet doğrulaması**.

**Ve iki bağ:**
- `REVOKE_ALL` denetim kaydında **ayrı olay türü** — `T-244` biçiminin **ilk alan
  gereksinimi** bu ayrımı taşımak
- **Gerekçe zorunluluğu** `K-2.5.15` ailesiyle tutarlı **bölünür**: `REVOKE_ALL`'da
  **zorunlu**, normal güncellemede **opsiyonel**

### 3 · Yürüme sırası

```
T-244    dar: kayıt biçimi = SÖZLÜĞÜN İLK MADDESİ
         alanlar: eski küme · yeni küme · kim · ne zaman · niyet ·
                  gerekçe[REVOKE_ALL'da zorunlu]
T-242a   üç karar kabul listesine İŞLENMİŞ hâlde
```

### ⚠️ Team Lead notu — L2'ye kural EKLENMEDİ, ve bu bir tercih

Ürün sahibi *"kural/olay numaralarını ben seçmiyorum"* dedi. Ölçüldü ve **L2'ye yeni
kural yazılmadı**, gerekçesi:

- `K-2.11.2` **zaten** olay gruplarını zorunlu kılıyor; sözlük onu **uygular**, yeni
  bir kural koymaz
- Sözlük bir **süreç artefaktıdır** (`ADIM 6` teslimi, erken açıldı) — `L2` bir **iş
  kuralı** belgesi
- Yeni bir `L2` kuralı guard sayısını değiştirir ve **`Z1` kaydı** ister; bugün
  **karşılığı olmayan** bir kural yazmak `İlke 1` ihlali olurdu

> **Aksi kararlaştırılırsa** `K-2.11` ailesinden bir numara tahsis edilir ve `F12`
> deseniyle işlenir. **Bu satır o kararın adresidir.**
>
> ⚠️ İlk yazımda buraya somut bir kural numarası yazılmıştı ve `guard.sh` onu
> **sarkan atıf** olarak yakaladı (*"var olmayan kurala atıf"*) — **doğru davranış**:
> var olmayan bir kurala atıf, o kural varmış gibi okunur. Numara **tahsis edildiğinde**
> yazılır, önce değil.

---

## Z16 · Sözlük ↔ `L2` bağı **iki yönlü** oldu — ve `T-244`'ün kapsamı yazılı olarak daraldı

> **Tarih:** 2026-08-20 · **Karar veren:** ürün sahibi · **Yazan:** Team Lead
> **Açtığı düzenleme:** `L2_02` `K-2.11.2` altına **atıf notu** (`Z1` dondurma kuralı gereği
> bu kayıt olmadan düzenlenemezdi)

### 0 · Neden bu kayıt var

`Z15`'in Team Lead notu şöyle bitiyordu: *"**Aksi kararlaştırılırsa** … **Bu satır o
kararın adresidir.**"* Aksi kararlaştırıldı — ama **yazıldığı biçimde değil.**

```
Z15'in reddettiği    L2'ye YENİ KURAL yazmak        → hâlâ reddedilmiş durumda
Z16'nın açtığı       L2'den sözlüğe ATIF NOTU       → yeni kural DEĞİL
```

⚠️ **Ayrım korunuyor:** yeni bir `K-2.11.x` **tahsis edilmedi**, kural sayısı
değişmedi, guard'ın tanım deseni (`^\*\*K-`) hiç tetiklenmiyor — not **atıf**
biçiminde (`` `K-2.11.2` ``). `İlke 1` ihlali doğmuyor, çünkü karşılığı olmayan bir
kural yazılmıyor; **var olan** bir kuralın uygulamasına yol gösteriliyor.

### 1 · Karar — bağ **iki yönlü** olmalı

> **Ürün sahibi:** *"sözlük `K-2.11.2`'ye atıf versin, `L2` sözlüğe. İki yönlü olmazsa
> sözlük dayanaksız görünür."*

```
sözlük → K-2.11.2    "bu belge o kuralı UYGULAR"        (dayanağını gösterir)
L2     → sözlük       "kanonik biçim orada"              (uygulamasını gösterir)
```

**Tek yönlü bağın ölçülmüş riski:** sözlük `docs/process/` altında, `L2` okuyan biri onu
**hiç görmez**. Sözlük dayanağını gösterse bile, `K-2.11.2`'yi okuyan biri kanonik biçimin
var olduğunu bilemez ve **beşinci aileyi** yazar — yani `Z15`'in tam olarak engellemek için
açtığı sözlük, görünmediği için işlevsiz kalır.

> 📌 Bu, `CLAUDE.md`'nin *"port ederken davranış taşınır, onu DOĞRU KILAN BAĞLAM
> taşınmaz"* dersinin belge tarafındaki hâli: sözlük doğruluğunu taşıyor, **bağını**
> taşımıyordu.

### 2 · `T-244`'ün kapsamı — iki soru, iki karar

| soru | karar | gerekçe |
|---|---|---|
| Yaratma anındaki kapsam verme hangi olay türü? | **`SCOPE_UPDATE`, eski küme = `∅`** | üçüncü tür açılmadı |
| Kullanıcı yaratmanın **kendisi** bu turda kaydedilsin mi? | **HAYIR** — sözlük `Madde 2`'ye | `T-244`'ün dar kapsamı korunuyor |

**Birinci kararın gerekçesi (ürün sahibi):**

- Sözlüğün ayrımı **"hedef küme boşalıyor mu"** ekseninde — *"ilk verme mi"* ekseninde
  değil. Üçüncü tür **farklı bir eksende** bölerdi ve `T-242a`'nın kayıtlarıyla
  **karşılaştırılamaz** hâle gelirdi.
- Asıl test: *"bugün bu kullanıcı neyi görüyor"* sorusu **iki durumda da aynı okunur** —
  eski küme `∅` ise yeni küme her şeyi anlatıyor.
- `İlke 1`: üçüncü tür için **kanıtlanmış ihtiyaç yok.** *"Bu erişim doğuştan mı geldi"*
  sorusu bugün sorulmuyor — sorulursa `before_values = ∅` **zaten cevaplıyor.**

**İkinci kararın gerekçesi:** `T-244`'ün dar kapsamı *"başka olay türü tanımlanmaz"*
şartını taşıyor ve o şartın gerekçesi `ADIM 2`'nin **dört aile** ölçümüydü. Kullanıcı
yaşam döngüsünü bu turda tanımlamak, `Z15`'in engellemek için yazıldığı **erken-tanım**
hatasının kendisi olurdu.

### 3 · ⛔ Ve `A7` YARIM kapanıyor — bu bir kilit, sessiz kalmıyor

```
A7'nin iddiası    "kullanıcı yaratma VE kapsam verme hiçbir yere loglanmıyor"
T-244 kapatıyor   kapsam verme          ✅
T-244 kapatMIYOR  kullanıcı yaratma     ⛔ → adres: sözlük Madde 2 (AÇIK)
```

⚠️ **`CLAUDE.md` gereği bir adres yazıldı** (*"bilinen eksiklik TODO ile değil, TASK ile
kaydedilir"* · *"bir şartın SAĞLAYICISI yoksa şart bir kilittir"*):

```
ŞART        kullanıcı yaratma olayı kaydedilsin
SAĞLAYICI   sözlük Madde 2 (kullanıcı yaşam döngüsü)
DURUM       ⛔ bugün YOK — ADIM 6'da yazılacak, sözlükte AÇIK olarak işaretli
```

Yani `§2.3`'ün *"her işlem loglanır"* ihlali **sürüyor ve biliniyor** — kapandı diye
işaretlenmiyor.

### 4 · ⚠️ Sınır — `A1` bu turda, ve kayıt biçimiyle KARIŞTIRILMAZ

> **Ürün sahibi:** *"`A1` bir kusur, kayıt biçimi değil. Yaratma olayının kaydedilmesi
> ayrı, `createdBy`'ın doğru yazılması bu turda. İkisi karışmasın."*

```
A1  createdBy: savedUser.id → gerçek aktör       ⚡ BU TURDA (kusur)
A7  kapsam kaydı SCOPE_UPDATE                    ⚡ BU TURDA (biçim uygulaması)
—   kullanıcı yaratma OLAYI                      ⛔ kapsam dışı (Madde 2)
```

`A1`'in yaratma olayının kaydedilmemesiyle **ilgisi yok**: `createdBy` bir denetim kaydı
alanı değil, `user_scopes` satırının **kendi kolonu**. Yanlış aktör yazması, olay
kaydedilse de kaydedilmese de bir kusurdur.

---

## Z17 · Sözlük `Madde 1`'in iki belirsizliği kapandı — `niyet` ve `hedef`

> **Tarih:** 2026-08-20 · **Karar veren:** ürün sahibi · **Yazan:** Team Lead
> **Kaynak:** `T-244` `code-reviewer` turu, bulgular `m2` ve `m1`
> **Etkilediği belge:** `docs/process/DENETIM_SOZLUGU.md` `Madde 1` (süreç artefaktı,
> `Z1` dondurması kapsamında **değil**) — `L2`'ye dokunulmadı

### 1 · `niyet` kayıtta AYRI bir alan değil (`m2`)

```
UÇ'ta      intent: UPDATE | REVOKE_ALL              girdi alanı, ZORUNLU
KAYITTA    ne = SCOPE_UPDATE | SCOPE_REVOKE_ALL     tek alan, aynı bilgi
```

**Gerekçe (ürün sahibi):** `Z15`'in `intent` kararı **ucun girdi alanıydı** — boş bir
dizinin *"temizle"* mi *"hata"* mı olduğunu ayırmak için. Kayıt tarafında ikinci bir
kolona ihtiyaç yok, çünkü **iki tür zaten iki değer**.

- `İlke 1`: ayrı bir `niyet` kolonu yaratmada **her zaman sabit `UPDATE`** olurdu →
  hiçbir bilgi taşımaz.
- *"Çağıran ne demek istedi ↔ sistem ne kaydetti"* sapması **oluşamaz**: doğrulama
  katmanı `boş küme ∧ intent ≠ REVOKE_ALL → ret` ile onu zaten reddediyor.

⚠️ **`code-reviewer` varsaymadı, `§2.4`'ü uyguladı:** iki okumanın da belgeyle uyumlu
olduğunu ölçüp **DUR** dedi. Belirsizlik iki tur sonra iki farklı kayıt üretecekti.

### 2 · `hedef` = KULLANICI, kapsam satırı değil (`m1`) — **bir DÜZELTME**

```
❌ entity_type='user_scope'  entity_id=<kullanıcı id>     ilk uygulama
✅ entity_type='user'        entity_id=<kullanıcı id>     düzeltilmiş
```

**Ölçüm (`code-reviewer`):** repodaki **16 `logAdminAction` üreticisinin 16'sında**
`entity_id`, `entity_type`'ın adlandırdığı tablonun id'sidir. `T-244` **tek istisnaydı**,
ve sonucu ölçüldü: `JOIN user_scopes ON id = entity_id` **her zaman 0 satır** döner —
üstelik `@Index(['entityType','entityId'])` tam da o aramayı hızlandırmak için var.

**Gerekçe (ürün sahibi):** olay **kullanıcının kapsamının değişmesidir**, bir kapsam
satırının değil. `replace` semantiği bunu zaten söylüyor: hedef bir **küme**, kümenin
sahibi **kullanıcı**. Ve küme `eski küme`/`yeni küme` alanlarında yaşıyor — `hedef`in
taşımasına gerek yok.

> **Reddedilen alternatif:** `entity_type='user_scope'` + `entity_id=<kapsam satırı id>`.
> ⛔ `replace` semantiğinde **tek bir satır yok** — küme değişiyor.

### ⚠️ Ve asıl bedel biçimin YAYILMASI olurdu

`Z15` bu biçimi *"sözlüğün ilk maddesi"* ilan etti. Düzeltilmeseydi [[T-242a]]
istisnayı **miras alır** ve sözlük **yanlış bir deseni kanonikleştirirdi** — yani hata
bir uygulamada kalmaz, **kanona** girerdi.

📌 `CLAUDE.md`'nin *"bir düzeltme de bir iddiadır"* dersinin tersi yönü: burada
**düzeltmenin kendisi** değil, **kanonikleştirilecek biçim** ölçüldü. Bir biçim
kanona girmeden önce, onu **miras alacak** tüketici sorulmalı.

---

## Z18 · `K1` — `READ` üçe ayrıldı, ve `UNRESTRICTED` üyeliği STATÜ değiştirdi

> **Tarih:** 2026-08-21 · **Karar veren:** ürün sahibi · **Yazan:** Team Lead
> **Bağlam:** `ADIM 3` `Faz B`, üç `READ` hücresinin union çöküşü
> **Açtığı düzenleme:** `L2`'de `UNRESTRICTED` üyeliğinin **statüsü** (`Z1` dondurma
> kuralı gereği bu kayıt olmadan düzenlenemezdi)

### 0 · Kapı neden şimdi açıldı

`FAZ1_PLAN §5`'in bağlayıcı sırası: *"üç `READ` hücresinin union'ı **`T-235`
kapanmadan** değerlendirilmez."* `T-235` **2026-08-20'de kapandı** (bayrak canlı,
davranışsal doğrulandı).

**Ve engelin gerekçesi de değişti — ölçülerek:**

```
o gün    kapsam filtresi 5 rolün 1'inde aktif  →  @Roles TEK kapı  →  union onu gevşetir
bugün    bayrak AÇIK, PLANNER de kapsamlı      →  İKİNCİ KAPI ÇALIŞIYOR
```

### 1 · `READ` **ÜÇ SINIFA** ayrılır

```
READ_OWN      işlem ekseninin SÖZLÜK GENİŞLEMESİ — dördüncü eksen DEĞİL
ÖZET          kendi hücresi — çapraz-modül yüzey
modül-READ    kalan, YENİDEN ÖLÇÜLÜR
```

### 2 · ⛔ DÖRDÜNCÜ EKSEN YOK — ve zemin değişimi kararı GÜÇLENDİRDİ

`0073` bunu zaten teyit etmişti. Yeni gerekçe **daha güçlü**:

> **Yeteneğe kapsam taşımak, artık ÇALIŞAN bir katmanı KOPYALAMAK olurdu.**

Bayrak kapalıyken kapsam katmanı `5` rolün `1`'inde etkindi — o gün *"yeteneğe kapsam
taşıyalım"* savunulabilir görünüyordu. Bayrak açıldığında ikinci kapı **gerçek** oldu,
ve aynı öneri `İlke 4`'ün (aynı yetenek iki kez) doğrudan ihlali hâline geldi.

📌 Yani zemin değişimi bir kararı **bozmadı, sağlamlaştırdı** — ve bu, `T-235`'i
`ADIM 3`'ün önüne koymanın ölçülmüş getirisidir.

### 3 · `UNRESTRICTED` üyeliği — koşulsuz SABİT → kayıtlı ROL ÖZELLİĞİ

```
küme      AYNI kalır       {ADMIN, FINANCE, READONLY}
statü     DEĞİŞİR          koşulsuz  →  gerekçeli
```

| rol | statü | gerekçe |
|---|---|---|
| `ADMIN` | **tanımsal** | `K-2.6.4` |
| `READONLY` | **tanımsal** | `K-2.6.4` |
| `FINANCE` | ⚠️ **işlevsel savunulabilir ama BUGÜN KAYITSIZ** | yazılmalı |

⚠️ **`FINANCE`'ın satırı bir kilittir, bir kabul değil:** *"savunulabilir"* ile
*"savunulmuş"* aynı şey değildir. Gerekçe yazılana kadar bu satır **açık** sayılır.

📌 Terfinin tamamlanması `ADIM 3`'ün **ertelenen** yarısındadır
(`UNRESTRICTED_ROLES` kod dalının kaldırılması) — **ama kaydı bugün**, çünkü kararı
veren tur budur.

### 4 · ⛔ HİÇBİR hücre-rol çifti UNION gerekçesiyle YAŞAYAMAZ

**Ve korunan şey bugünkü erişim değil, EMSAL:**

> **Ürün sahibi:** *"Çöküşün gerçek maliyeti bugünkü erişim değil, o emsal.
> **'Union'la 5/5 olsun, zararsız' kabul edilirse, aynı tembellik `WRITE`/`MANAGE`
> hücrelerinde tekrarlar.**"*

`READ` hücrelerinde `5/5` bugün **görece zararsız** görünür — okuma, ve kapsam katmanı
altta daraltıyor. Ama kabul edilen şey bir **küme** değil, bir **yöntem**: *"union ne
diyorsa o."* O yöntem `WRITE`'a uygulandığında zararsız değildir.

**Bu bir KURAL olarak yazılır** (`CLAUDE.md`), yalnız `B2`'nin kabul kriteri olarak
değil.

### 5 · Çapraz sınama — iki bağımsız yol AYNI taksonomiye vardı

`0072 §4c`'nin `A`/`C` sınıf ayrımıyla örtüştü:

```
READ_OWN + ÖZET  ⊂  A sınıfı   (servis kapsamı VAR)
sales-actuals    =  C sınıfı   (kapsam YOK)
```

⚠️ **Ve `sales-actuals`'ın açık bırakılan sınıfı `C`'nin ölçümüyle cevaplandı:**
`SHARED_READ`'in **meşru sakini değil** — kapsamsız ham finansal veri. Adresi
`ADIM 4`.

📌 İki bağımsız yolun aynı yere varması **güçlü sinyaldir** — ve `CLAUDE.md`'nin
*"bir hipotezi DOĞRULAYAN ölçüm, ÇÜRÜTEN ölçümden daha fazla doğrulama ister"*
maddesinin karşılandığı hâli: burada ikinci ölçüm **farklı bir yüzeyden** geldi.

### 6 · `K2` kendiliğinden kapandı

`K-2.5.12` bu oturumda karara bağlandı: **onay yetkisi bir rol kümesi değil, şablonun
kademesi.** Yani `MODES_APPROVE`/`SHARED_APPROVE` hücreleri `@RequireCapability`
**almaz**.

Ve sorunun kalan yarısı — *"onay ekranını görebilir mi"* — `READ_OWN`'ın **tam
örneğidir** (`approval my-requests`).

### 7 · `K3` ölçüldü — ZATEN KAPALIYDI

`PATCH /approval-policies/:id`: `capabilities.ts:206` *"UNION'DAN ÇIKARILDI
(2026-08-17)"* → `SHARED_MANAGE`, `ADMIN` kalıyor. Canlı controller doğruladı
(`@Roles(UserRole.ADMIN)`).

⚠️ **Team Lead planı onu "açık" saymıştı** — `FAZ1_PLAN §5`'in **uyarısı** okunmuş,
`capabilities.ts`'in **çözümü** okunmamıştı. `§7.1`: *"bir kaynakta bulunan uyarı,
başka bir kaynakta çözülmüş olabilir."*

---

## Z19 · `Z18`'in *"ayrı katman"* hükmüne ÖN KOŞUL — katmanın uygulandığı ÖLÇÜLMELİ

> **Tarih:** 2026-08-21 · **Karar veren:** ürün sahibi · **Yazan:** Team Lead
> **Biçim:** `F12`/`0006-R` deseni — `Z18` **silinmiyor**, üstüne bir ön koşul yazılıyor.

### Neyi düzeltiyor

`Z18 §2` şöyle diyordu:

> *"Yeteneğe kapsam taşımak, artık **ÇALIŞAN** bir katmanı KOPYALAMAK olurdu."*

Bu hüküm doğruydu **ve bir varsayım taşıyordu**: kapsam katmanının **çalıştığı**.
`Z18` o varlığı **ölçmeden** varsaydı.

### Ölçüm hükmü çürüttü — katman KISMİ

```
T-253   /users/dashboard-summary   @Roles'lu BEŞ ROL, ve kapsam YOK
                                   iki farklı kapsamlı PLANNER → BİREBİR AYNI yanıt
        plan-performance · agreement-transactions ×2  →  aynı sınıf
T-254   boş kapsam [] iki katmanda ZIT → budgetUtilization tüm tenant'ı veriyor
```

### ✅ EK HÜKÜM

> **Bir *"ayrı katman"* hükmü, o katmanın **uygulandığının ÖLÇÜLMESİNE** bağlıdır.
> **Uygulanmayan bir yüzeyde, hüküm koruma ÜRETMEZ — yalnız koruma VARSAYAR.**

⚠️ `Z18`'in **kararı** geçerli (dördüncü eksen yok, `İlke 4` gerekçesi ayakta). Değişen
şey: o kararın **koruma ürettiği iddiası**, artık yüzey-bazlı **ölçüme** bağlı.

### 📌 VE BU, BU OTURUMUN TEKRAR EDEN SINIFI

```
T-028c bayrağı      şart: "prod/UAT'de doğrulanana kadar"   sağlayıcı: prod/UAT YOK
report-only         şart: "fiili trafikte doğrulanır"        sağlayıcı: trafik YOK
B4                  şart: "ölçüm sonrası"                    sağlayıcı: örneklem 0
Z18 §2              hüküm: "çalışan bir katman"              ölçüm: katman KISMİ
```

**Dördü de aynı şekil: sağlayıcısı ölçülmemiş şartlar.** `CLAUDE.md` bunu *"bir şartın
SAĞLAYICISI yoksa, şart bir erteleme değil bir KİLİTTİR"* diye kaydetmişti — `Z18`
dördüncü vaka, ve farkı şu ki burada eksik olan bir **ortam** değil, bir **kod
katmanının kapsamı**.

## Z19a · `S1` kararı — `11` uç `B2`'de KALIR, rol katmanı uygulanır

```
S1 kapsamı   customer 10 · lta /cpl/:cplId/active 1
```

**Reddedilen `(c)` (uçları çıkar):** *"çıkarmak onları **tamamen filtresiz** bırakır;
`(a)` en azından **bir** katmanı kapatır."*

📌 **Rol katmanı gereksiz değil — YETERSİZ.** Tür-düzeyi koruma, kapsam gelse **de**
gerekli.

### ⚠️ RİSK SINIFI DÜZELTİLDİ — dış sızıntı DEĞİL

```
customer.service.ts   tenantId  →  37 atıf
                      tenantId'siz `where: {` →  YOK (ölçüldü, pozitif kontrollü)
```

Yani risk **tenant-içi AŞIRI GÖRÜNÜRLÜK**, dış sızıntı değil.

> **Ürün sahibi:** *"Kanayan yara değil, **yanlış-teminat**."*

⚠️ Ve bu ayrım `DUR` analizini değiştiriyor: `S1` bir **güvenlik açığı** değil, bir
**koruma iddiasının fazla geniş olması**.

## Z19b · Kapsam sütunu KENDİ RATCHET'ini alır

`B1` taslağı `B2`'nin kabul kriterine *"uç · `@Roles` durumu · **kapsam** durumu"* diye
iki sütun koymuştu. **Yetersiz:**

> **Ürün sahibi:** *"**'Adresle'** fiilinin yumuşaklığı — adres bir **metin notuysa**,
> `59→0` olduğunda ratchet yeşillenir ve kapsamsız uçlar **korunmuş sayılır**."*

```
@Roles sütunu    59 → 0        B2 KAPATIR
kapsam sütunu    AYRI RATCHET  bugün ❌ olanların LİSTESİ, tek yön AŞAĞI
                 T-253/T-254 kapanışları listeyi ERİTİR
```

### ⛔ VE `B2`'NİN *"BİTTİ"* TANIMI İKİYE AYRILIR

> **`B2`'nin yeşili YALNIZ `@Roles` sütununu kapatır.**

Kapsam sütunu **ayrı bir kapanış** ister. Bir metin notu değil, bir **ratchet** —
`T-252`'nin deseni (`liste, sayı değil` · `yalnız artış kırmızı` · `baseline 0 → kapıya
terfi`).

## Z19c · `T-242a`'nın *"bitti"* tanımına bir satır

```
REVOKE_ALL, T-254'ün tek-nokta düzeltmesi PİNLENMEDEN canlı kabul edilmez.
```

**Gerekçe:** `T-242a` bu oturumda **inşa edildi** ve **var olan** bir fail-open'a **yol
açtı** (`T-254`: boş kapsam → `budgetUtilization` tüm tenant'ı veriyor). Kusur tek
noktada, ve `T-254`'ün `AC` sırası zaten doğru:

```
1  fixture + REPRODÜKSİYON   ← kusur önce GÖRÜLMELİ
2  düzeltme
3  `length > 0` taraması     ← sınıfın diğer örnekleri
```

⚠️ **Bu `B2`'yi BEKLETMEZ** — paralel yürür.

---

## Z20 · `USER_READ` ikiye ayrıldı — `USER_MANAGE` + `SELF`, ve `SELF` DÖRDÜNCÜ KOVA

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Bağlam:** `ADIM 3` `B1` taksonomisi ·
**Tetikleyen:** `T-253` (`dashboard-summary` silindi → hücrenin çöküş öncülü ortadan kalktı)

### Karar

```
USER_MANAGE   GET /users · GET /users/:id · (yazma uçları)   →  @Roles(ADMIN)
SELF          /users/me ailesi (3 uç)                        →  DÖRDÜNCÜ KOVA
```

`GET /users` (tenant listesi) ile `GET /users/me` (self-servis kimlik) **farklı
yeteneklerdir** — ve bu `K-2.6.6`'nın değil **`K-2.6.4`'ün** konusudur (rol kataloğu).

**Kardeş gerekçesi:** `/users/:id` `T-255`'te `ADMIN` oldu. `GET /users` onun **liste
hâlidir** — aynı veri sınıfı, aynı rol. Yani `USER_MANAGE` bir union'dan değil, **ölçülmüş
bir emsalden** türüyor (`Z18`: *"mekanik olarak türetilmiş bir değer gerekçe değildir"*).

**`SELF` rol gerektirmez, kimlik gerektirir.** Üç uç bir rol kümesine değil, *"istek sahibi
kaydın sahibi mi"* koşuluna bağlanır.

### Ve bu `B4`'ün ÖN KOŞULUNU çözüyor

`B4` (`roles.guard.ts` default-deny) `FILTRESIZ = 0` şartına bağlıydı; bugün `3`.
**Ölçüldü — o üç uç tam olarak `me` ailesi:**

```
route-scope-baseline.txt
  F user.controller.ts|GET  |users/me
  F user.controller.ts|PATCH|users/me
  F user.controller.ts|PATCH|users/me/password
```

Üçü `@Roles` **almaz**, `SELF` alır → `FILTRESIZ` sıfırlanır ve `B4`'ün önü açılır.
Yani `SELF` kovası bir sınıflandırma kolaylığı değil, **bir kilidin anahtarı**.

### ⚠️ ÜÇÜNCÜ HÜCRE — kararın kapsamı dışında, ve ÖLÇÜLDÜ

Karar yazılırken *"bu ne bozabilir"* sorusu soruldu (`§ KABUL LİSTESİ`) ve **canlı bir
regresyon** çıktı. `T-255` `/users/:id`'yi `ADMIN`'e daralttı; frontend o ucu **dört yerden**
çağırıyor ve çağıran sayfalar `ADMIN`'e kapalı değil:

```
davranışsal ölçüm 2026-08-23 (poz.kontrol: aynı tokenlarla /users/me → 4/4 200)
GET /users/:id    ADMIN 200 · CM 403 · FIN 403 · PLANNER 403 · READONLY 403

çağıran                       rota                    guard
PlanApprovalsPage             /plan-approvals         ADMIN·CM·READONLY
PlanDetailPage                /plans/:id              BEŞ ROLÜN HEPSİ
AgreementApprovalsPage        /agreement-approvals    ADMIN·CM·FIN·READONLY
PlanApprovalDetailModal       (alt bileşen)
```

Dördü de aynı işi yapıyor: `plan.createdBy` **UUID**'sini **görünen ada** çevirmek. Ve
fallback sessiz — `creatorUser?.fullName || plan.createdBy || 'N/A'` → 403'te ekranda
**ham UUID** görünüyor, hata değil.

> **Yani ne `USER_MANAGE` ne `SELF` olan üçüncü bir yetenek var: `USER_LOOKUP` — bir
> kullanıcı kimliğini GÖRÜNEN ADA çözmek.** Bugün onun **arayüzü yok**, ve ihtiyaç bir
> **yönetim ucundan** karşılanıyordu.

📌 `EK_E`'nin **`🔒`** sınıfının tersi: orada *yetenek var, arayüzü yok*; burada
**ihtiyaç var, arayüzü bir başka yeteneğin ucu.** `T-255` o ödünç yolu kapattı ve
ihtiyaç açıkta kaldı.

⚠️ **Ve `T-255` bunu göremezdi, çünkü kabul listesi ne EKLEDİĞİNİ sayıyordu
(korumayı), ne BOZDUĞUNU değil** — `§`'nin *"bir kabul listesi değişikliğin
BOZABİLECEĞİNİ de saymalıdır"* kuralının yeni bir vakası, ve `DUR` listesinin
**çapraz-repo** satırında.

### Sonuç

| hücre | uçlar | katman | durum |
|---|---|---|---|
| `USER_MANAGE` | `GET /users` · `/users/:id` · yazma uçları | `@Roles(ADMIN)` | ✅ karar verildi |
| `SELF` | `/users/me` ailesi (3) | dördüncü kova, kimlik koşulu | ✅ karar verildi |
| `USER_LOOKUP` | **bugün yok** — ihtiyaç `/users/:id`'ye biniyordu | ⛔ **AÇIK** | `T-268` |

`USER_LOOKUP`'ın **kararı bu kayıtta verilmiyor** — ölçüm bu turda doğdu ve bir
tasarım sorusu (dar bir `{id, fullName}` ucu mu, plan/agreement yanıtına gömülü bir
alan mı) ayrı ele alınmalı. Kayda giren şey **boşluğun varlığı ve ölçüsü**.

### Değiştirdiği kayıt

`Z18`'in `USER_READ` satırı **⛔ DUR**'daydı, gerekçesi *"`dashboard-summary` zaten `5/5`
rol taşıyor → union otomatik çöküyor"*du. `T-253` o ucu sildi, öncül kalktı, ve hücre
**union'a düşmeden** çözüldü. `Z1` append-only: `Z18`'in satırı silinmedi.

---

## Z21 · Bütçe: **zarf modeli kanonik**, `budget_allocations` ölü ilan edildi

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Ölçüm:** `T-270`

### Karar

> **Doğrulama zarf modeline taşınır, `cplId` boyutu DÜŞÜRÜLEREK.**

Ve *"bedel"* satırı **reddedildi**: `budget_allocations`'ın `cplId` boyutu bir **yetenek
değildi**, bir **eksen ihlaliydi**.

### ⛔ DAYANAK HİYERARŞİSİ (ürün sahibi, 2026-08-23) — ve sebebi GELECEKTE

```
BİRİNCİL      K-2.2.3 İHLALİ                    ← doğrudan NORM ihlali
DESTEKLEYİCİ  K-2.2.1 + A7 eksen ayrımı         ← KAPSAM argümanı
```

**Neden bu sıra:** kapsam argümanı (*"bu yetenek hiç kararlaştırılmadı"*) savunulabilir
ama **kıyaslamalıdır** — müzakere edilebilir. Norm ihlali kaydı ise müzakere edilmez.

> **Altı ay sonra biri *"CPL bazlı bütçe ekleyelim"* dediğinde, kapsam argümanı tartışılır;
> norm ihlali kaydı ise *"önce `K-2.2.3`'ü revize et"* der — ve DOĞRU KAPIYA yönlendirir.**

### 📌 Ve bu `L2`'nin bir BAŞARI ANI

**Kural, ihlalinden ÖNCE yazılmıştı ve ihlali ADIYLA yakaladı.**

`K-2.2.3`'ün gerekçe cümlesi (*"aynı harcamanın iki farklı zarfa düşmesi, ve fark
sessizdir"*) `findMatchingAllocation`'ın **tam tarifidir** — kural yazılırken bu vaka
bilinmiyordu.

> *"Kural veridir"* yatırımının **ilk somut temettüsü.**

### Üç dayanak — ikisi ürün sahibinin, üçüncüsü ölçümden

**1 · `K-2.2.1` zarfı ÜÇ boyutla tanımlıyor, ve CPL onlardan biri değil**

```
K-2.2.1   Kanal × Kategori × Dönem
K-2.2.2   (isteğe bağlı) harcama tipi bölünmesi
```

⚠️ *"Kategori bazlı bütçe kaybolur"* iddiası **zaten yanlıştı** — kategori **zarfın kendi
boyutu**. Kaybolan tek şey `cplId`, ve CPL-bazlı bütçe hiçbir kararda, kaynakta ya da
kural gövdesinde **yok**.

📌 Ölçüldü: `L2_01_veri_butce_defter_hesaplama.md`'de `cpl` **iki kez** geçiyor ve
**ikisi de `K-2.2` bloğunun dışında** — `:76` `Kanal → Bölge → Müşteri (CPL)` (ana veri
hiyerarşisi) ve `:82` (`cpls.channel_id` yabancı anahtarı). **Bütçe kurallarında sıfır.**

**2 · `A7`: yetki-kapsamı ≠ bütçe-boyutu**

`A7` kapsamı *"kanal + müşteri + kategori, bölge `Faz 2`"* diye kararlaştırdı
(`FAZ1_PLAN.md:442`). CPL'in sistemdeki yeri **kapsam katmanıdır** — *kim hangi satırı
görür*. Bir zarfın boyutu değil.

> `budget_allocations`'ın `cplId` taşıması, **iki katmanın aynı tabloda karışmasıdır** —
> `İlke 4`'ün veri-modeli ihlaline bir **eksen ihlali** ekliyor.

**3 · ⛔ `K-2.2.3` bu vakayı ADIYLA yasaklıyor** — ölçüm sırasında bulundu

```
K-2.2.3 — Zarf çözümlemesi TÜM YOLLARDA AYNI boyut kümesini kullanır.
          Farklı bir yol farklı bir boyut kümesiyle zarf arayamaz.

Gerekçe:  iki farklı çözümleme, aynı harcamanın iki farklı zarfa düşmesine
          yol açar ve FARK SESSİZDİR.
```

`findMatchingAllocation` tam olarak bunu yapıyor: **farklı bir yol**, **farklı bir boyut
kümesi** (`cplId + kanal + kategori + tarih ARALIĞI`). Yani `budget_allocations` yalnız
*"benimsenmemiş"* değil — **var olduğu andan beri `K-2.2.3` ihlali.**

📌 Bu üçüncü dayanak, ilk ikisinden **güçlüdür**: ilk ikisi *"bu yetenek hiç olmadı"*
diyor, üçüncüsü *"kural bu şekli ve neden tehlikeli olduğunu yazmış"* diyor.

### Reddedilen seçenekler

| # | seçenek | statü |
|---|---|---|
| 2 | boyutları **zarfa ekle** (`cpl_id` + tarih aralığı) | **bugün RET** — ama **kayıtlı gelecek-seçenek**: CPL-bazlı bütçe gerçek bir müşteri ihtiyacı olarak kanıtlanırsa (danışman turu / ilk müşteri), o gün **karar defteri kaydıyla** zarf boyutu tartışılır. Bugün eklemek, **kanıtsız ihtiyaca şema karmaşası** (`İlke 1`) |
| 3 | `budget_allocations`'ı **doldur** | **RET** — iki mutabakatsız model, `İlke 4`'ün tam tanımı. Ölçüm de desteklemiyor: zarfın `available`'ı **defterden** türetiliyor, tahsisinki **denormalize kolon** |

### ⚠️ Ölü kod bir yetenek sayılmaz — ve bu genel bir hüküm

> **Kullanıcısı olmayan, mutabakatsız, iki haftalık ölü-doğmuş bir tabloda yaşayan
> davranış, yetenek sayılmaz — sayılırsa her ölü kod bir "kayıp" üretir ve hiçbir
> temizlik yapılamaz.**

📌 `T-253`'ün *"`@deprecated` bir niyet beyanıdır"* kuralının **ters yönü**: orada bir
etiket ölçümü durduruyordu; burada bir **varlık** temizliği durduracaktı.

### Tamamlanma tanımı — DÖRT şart

Bu bir **taşıma değil davranış değişikliğidir**, o yüzden **her fark pinlenir**.

**1 · Davranışsal pin ÇİFTİ** (iki girdi, iki çıktı):

```
bugünkü gerçek veri (4 zarf · ₺1.600.000)  →  dashboard'da GÖRÜNÜR
boş-zarf durumu                            →  `unavailable` / GRİ  —  `GREEN` DEĞİL
```

**2 · Üç davranış farkı TEK TEK pinlenir:**

```
sıfır-bacak semantiği   →  sıfır harcayan plan "Shortfall: 0.00" ÜRETMEMELİ
dönem modeli            →  aralık ↔ ay
para kaynağı            →  denormalize kolon ↔ defter (v_budget_summary)
```

**3 · ⛔ `POST /budget-allocations` bu kararla ÇELİŞKİ taşıyor ve çözülmeli**

> **Tabloyu ölü ilan edip canlı yazma yolu bırakmak, ölü modeli yeniden dolduran bir
> MUSLUK bırakmaktır.**

`T-265` ölçümü o ucu tutuyorsa (`t254` e2e'si çağırıyor), sorular **`A2`'nin kapsamına
girer**: tüketicisi kim, ve zarf yoluna göçü ne? *"POST kalır"* ancak **geçiş dönemi +
kapanış kaydıyla** kalabilir.

> ### ⛔ REVİZE — ŞARTIN HESABI DEĞİŞTİ (`T-265` ölçümü, 2026-08-23)
>
> Bu şartın *"`POST` kalmalı"* tarafı **iki bacağa** dayanıyordu. **Biri düştü:**
>
> ```
> bacak 1  "t254 e2e'si onu çağırıyor"    →  ⛔ ARTIK YANLIŞ
>          dosya T-270/Z21 turunda yeniden yazıldı, artık POST /budget/envelopes
>          çağırıyor. `budget-allocations` literaline SIFIR atıf.
> bacak 2  "tablonun tek yazma yolu"      →  ✅ hâlâ doğru
>          ama Z21'e göre bu bir TUTMA gerekçesi değil, MUSLUK'un TANIMI
> ```
>
> **Ölçüldü (poz.kontrollü):** repo genelinde `POST /budget-allocations`'ın
> **controller dışında hiçbir çağıranı yok** — ne e2e, ne seed, ne frontend.
>
> ⇒ **Musluk kararı artık çok daha ucuz:** *"geçiş dönemi"* bir **kimin için**
> sorusuydu, ve cevap **hiç kimse**. Kapanış koşulu (*"e2e akışları zarf yoluna
> göçtüğünde"*) **zaten karşılanmış** — göç `T-270`'te oldu.
>
> 📌 Ve bu, `CLAUDE.md`'nin *"test dosyası sözleşme adı taşır"* kuralının **öngördüğü**
> durum: dosya yeniden yazıldı, **adı** düzeltildi, ama ona **atıf veren bir gerekçe
> metni** bayatladı. Sarkan atıf **dosya adında değil, KARARIN GEREKÇESİNDE**.

> ### ⛔ VE KAPANIŞ BİR TAKVİM TARİHİ DEĞİL, BİR KOŞUL (ürün sahibi, 2026-08-23)
>
> ```
> ❌  "2026-10-01'de kaldırılacak"
> ✅  "e2e akışları zarf yoluna göçtüğünde kaldırılır"
> ```
>
> **Gerekçe:** tarih gelir, e2e hâlâ eski yoldadır, ve tarih **ertelenir** — *bayat-tarih
> deseni*. Bir koşul ertelenemez; ve bu koşul **e2e göçünü de birinin işi yapar.**
>
> 📌 `§`'nin *"şartın SAĞLAYICISI yoksa bu bir KİLİTTİR"* kuralının **tersi**: orada
> sağlayıcısı olmayan bir şart kilit oluyordu; burada koşul, **sağlayıcıyı bir işe
> dönüştürüyor**.

**4 · Tablonun kendisi:** karar defterine **`F12` deseni** kayıt (iki hafta önce bir
migration'la doğdu — **geri alış iziyle**). Silme, şema penceresi açıkken **ucuz**; ama
**`3.` şart çözülmeden silinmez.**

### `A1` — ayrıca onaylandı, ve gerekçesi bir üst kata bağlandı

`getBudgetUtilization` boş kümede `unavailable` döner. **Model kararından bağımsız
doğru, çünkü GRİ kuralının kod hâlidir** — `allocated: 0 + GREEN` sessiz-yeşilin
finansal ekran hâli, ve *"kapsama yoksa renk yok"* kuralının kodda ihlali.

### `T-265` etkisi

Dört uç (`GET` liste · `GET :id` · `reports/utilization` · `reports/forecast`)
**silinebilir**. `check-availability` **artık zarf yoluna işaret ediyor** —
`A2` onu bir bekleyen olmaktan çıkardı.

---

## Z22 · Zarf özeti **tenant-yapısal veridir** — kapsam kapısı kaldırılır

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Ölçüm:** `T-270` `A2` yan bulgusu ·
**Uygulama:** `T-272`

### Karar

> **`T-270`'in interim fail-closed kapısı KALDIRILIR.** CPL-kapsamlı bir `PLANNER` zarf
> özetini **görür**.

### Birincil dayanak — *"görebilir"* değil, **"GÖRMEK ZORUNDA"**

`docs/decisions/PLAN_BUTCE_NETLESTIRME.md` **`netleştirme-1`** (2026-08-15, ürün sahibi):

```
Uzman itirazının kabul edilen çekirdeği:
  kilitlemesiz model, GÖRÜNÜRLÜK OLMADAN SAVUNULAMAZ.

1 · BEKLEYEN-TALEP GÖRÜNÜRLÜĞÜ: aday → ZORUNLU.
    (a) zarf görünümünde kalıcı "bekleyen talep" satırı
        (PLANLAMACI PLANLARKEN GÖRÜR)
    Statü: gönderim kontrolünün implement edildiği dalganın ŞARTI —
           kontrol GÖRÜNÜRLÜKSÜZ İNEMEZ.
```

Gönderim kontrolü **bilgilendiricidir** (kilitleme reddedildi, `K-2.2.9i` ailesi). Bu
modelin savunulabilirlik şartı, planlamacının zarf doluluğunu **gönderimden önce
görmesidir**.

> ⇒ **Fail-closed kapı kalırsa `PLANNER` köre gönderir.** Seçenek `1` bir güvenlik duruşu
> değil, `netleştirme-1`'in **ihlalidir**.

### `K-2.6.8a` gerilimi — çözüm taksonomide zaten duruyordu

`K-2.6.8a` (*"boş kapsam = erişim yok"*) **müşteri-satırı verisini** yönetir — `A7`'nin
koruduğu sınıf. **Zarf müşteri-satırı verisi değildir**: `Kanal × Kategori × Dönem`
agregasyonu, içinde tek bir müşteri satırı yok.

**Emsal `B1`'de çoktan kararlaştı — ve bu turda DAVRANIŞSAL olarak ölçüldü:**

```
master-data uçları:  scope-c (kapsam YOK) 63 · scope-b 1
planner  (11 CPL) → GET /master-data/categories → 8
planner2 (17 CPL) → GET /master-data/categories → 8      ← AYNI
POZ.KONTROL  /dashboard/cpl-status → farklı CPL kümeleri  ← kapsam GERÇEKTEN farklı
ayırt etme gücü: toplam 8 kategori (1 değil) — fixture ayrımı ölçebiliyor
```

**Kayıt cümlesi:**

> **`REVOKE_ALL` müşteri-satırı erişimini kaldırır; tenant-yapısal veriler (katalog, zarf
> özeti) ROL KATMANININ konusudur. Tam kilitleme isteniyorsa aracı HESAP ASKIYA ALMADIR,
> kapsam boşaltma değil.**

⚠️ Ve bu, `T-254`'ün *"artık hiçbir şey göremez"* beklentisini **dürüstçe daraltır** —
beklenti **müşteri verisi** için doğruydu, **yapısal veri** için yanlıştı.

### ⛔ HASSASİYET — karar *"bütçe kapsam-duyarsızdır"* diye YAZILMAZ

**Doğru cümle:**

> **Bütçe, `CPL` ekseninde TANIMSAL olarak duyarsızdır** (`A7`: kapsam ≠ bütçe-boyutu).
> **Kapsamla PAYLAŞTIĞI eksenlerde (kanal · kategori) duyarlılık MEŞRUDUR** — ama bugün
> veri onu ayırt etmiyor (dört zarfın dördü de **kanal-joker**, ölçüldü) ve **talep yok**.

**Fark neden önemli:** düz *"duyarsızdır"* yazılırsa, yarın kanal-bazlı zarflar
doğduğunda bir **Distribütör-`PLANNER`'ının Ulusal-Zincir zarfını görmesi** bu kayda
yaslanarak savunulur.

**Paylaşılan-eksen filtresi bugün YAPILMAZ, gelecek-seçenek olarak kayda girer** —
`Z21` deseninin aynısı.

> ### 📌 EK — gelecek-seçeneğin MALİYETİ ölçüldü (`T-272`, 2026-08-23)
>
> ```
> computeBudgetUtilization   filters.channels    →  UYGULUYOR   (:45)
>                            filters.categories  →  UYGULUYOR   (:50)
>                            filters.cplIds      →  HİÇ OKUMUYOR
> dashboard budgetFilters    startDate · endDate · cplIds        ← channels/categories YOK
> POZ.KONTROL  aynı metotta 6 where/filtre yapısı — desen çalışıyor
> ```
>
> **Tüketici tarafı ZATEN KURULU.** Paylaşılan-eksen filtresi *"yeni bir filtre
> yazmak"* değil, **var olan bir filtreyi doldurmak** — eksik olan yalnız kapsamdan
> kanal/kategori türetmek.
>
> ⇒ Maliyet tahmini bu yönde **revize edilmeli**; karar (bugün yapılmaz) değişmiyor,
> ama *"pahalı"* gerekçesi artık geçerli değil — geçerli gerekçe **talep yokluğu**.
>
> ⚠️ Ve bir yan bulgu: `dashboard` `cplIds`'i **özenle hesaplayıp** geçiriyor, ve onu
> **kimse okumuyor**. *"Mekanizma var, yol yok"* ailesinin **ters** hâli — değer doğru
> üretiliyor, tüketicisi yok.

### `Z21` seçenek 2'nin şerhi AYNEN taşınır

> `CPL` bir gün **görünürlük boyutu** olarak dönerse, **çözümleme boyutu olmadığı** açıkça
> yazılmadan giremez — `K-2.2.3`'ün **geri gelme kapısı**.

### Uygulama pinleri (`T-272`)

```
kapı kaldırılır  →  CPL-kapsamlı PLANNER gerçek zarf verisini görür (4 zarf · ₺1.6M)
       ∧            boş-zarf durumu `unavailable` KALIR (A1 korunur)
       ∧            REVOKE_ALL'lı kullanıcı fixture'ı:
                      müşteri panelleri KAPALI · zarf paneli AÇIK
```

📌 **`A1` ile bu karar birbirine karışmaz:** *veri yokluğu* ile *kapsam* **ayrı
sinyallerdir**. `unavailable` birincisinin cevabıdır; kapsam ikincisinin — ve zarf
özetinde ikincisi **uygulanmaz**.

---

## Z23 · ORM `cascade` KALDIRILIR — iki tablodan birden

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Uygulama:** `T-273`

### Karar

```
@OneToMany('LTARate',         'ltaAgreement', { cascade: true })   →  KALDIRILIR
@OneToMany('LTAPlanOverride', 'ltaAgreement', { cascade: true })   →  KALDIRILIR
```

Yazma **serviste açık** yapılır.

### Üç kat gerekçe — güçlüden zayıfa

**1 · Cascade, BEŞİNCİ YÜZEY bulgusunun KAYNAĞI — semptomu değil**

`{ cascade: true }`, *"hiçbir dosyada çağrı olarak görünmeyen yazma yolu"* üretiyor. Bu,
dört-yüzey dersinin doğurduğu **kural sınıfının ta kendisi**:

```
T-271   bu yol bir kusuru MASKELEDİ   (DI-çağrı taraması "UPDATE gerekmiyor" dedi, çürüdü)
T-273   uykuda bir 500 taşıyor         (lta_plan_overrides yalnız SELECT)
        ↑ aynı mekanizma, iki vaka, iki tur
```

> **Görünmez yazma yolunu YÖNETMEK** (GRANT genişletmek, davranış pinlemek) yerine
> **ORTADAN KALDIRMAK** bir **sınıf düzeltmesidir**; tutmak, vakaları **tek tek
> kovalamaktır**.

📌 `§7.1`: *"kapsam, kusurun SINIFIYLA tanımlanır — bulunduğu ilk vakanın yazımıyla
değil."*

**2 · Ayrıcalık daralması yönü doğru ve ÖLÇÜLEBİLİR**

```
cascade düşerse  →  lta_rates UPDATE gerekçesi DÜŞER          (T-271'in kendi tespiti)
                 →  lta_plan_overrides'a hiç UPDATE AÇILMAZ
                 →  app_runtime izin envanteri İKİ TABLODA daralır
```

`K-2.6.13`'ün **asgari küme** ilkesiyle aynı yön. Ve izin envanteri **`ADIM 5` (RLS)'in
girdisi** olduğu için daralma **ileriye de ödüyor**.

**3 · Açık yazma, ilişkinin GERÇEK SAHİPLİĞİNİ koda getirir**

`rates`/`overrides` değişimi bilinçli bir servis eylemi olur
(`ratesRepository.save(...)` **açıkça**) — okunabilir, grep'lenebilir, `GRANT`'la
**birebir**.

⚠️ ORM konforu kaybı **gerçek ama küçük** — ve bu kod tabanında konfor/görünürlük
takasının yönü **hep aynı** seçildi: sessiz-tahmin yasağı (`§2.5`), açık kalem, `niyet`
alanı (`Z17`).

### ⛔ ÜÇ UYGULAMA ŞARTI

**1 · ÖNCE ÖLÇÜM — bugün cascade'e yaslanan MEŞRU yol var mı?**

`T-271` *"gereksiz `UPDATE`"* gösterdi. Ama **create akışı** rate'leri ebeveynle **tek
`.save()`**'de yazıyorsa, cascade kaldırma o yolu **kırar** — ve düzeltmesi açık yazmaya
taşımaktır.

> **Kaldırma commit'i bu ölçümün SONUCUYLA şekillenir** — *"cascade'i sil, yeşile bak"*
> **değil**.

Tek grep + create e2e'si söyler.

**2 · `T-273`'ün `500`'ü KALDIRMADAN ÖNCE REPRODÜKLENİR**

```
override satırı fixture'ı  +  PATCH   →  500 GÖRÜLÜR
düzeltme
aynı fixture                            →  YEŞİL
```

`T-254`'ün *"kusur önce görülmeli"* disiplini — yoksa *"düzelttik"* iddiası, **hiç
ateşlenmemiş kod hakkında bir inanç** olur.

📌 Ve bu fixture **kalıcı değer** taşır: `lta_plan_overrides`'ın **`0`-satır körlüğünü**
(*verinin-yokluğu-örter* alt sınıfının) **kalıcı olarak kırar**.

**3 · `GRANT` SİMETRİSİ AYNI COMMIT'TE**

Cascade düşünce `lta_rates` `UPDATE`'i envanterden **çıkar**. `GRANT` bırakılırsa
**kullanılmayan izin** doğar ve **envanter↔`GRANT` birebirlik kriteri**
(`K-2.6.13` kabul-5) **sessizce bozulur**.

### Sıra notu

**`Z21` şart `3`/`4` (`POST` musluğu + tablo silme) `T-273`'ten SONRA kalır.** Cascade
kararı LTA entity'lerine dokunuyor, tablo silme migration'ı **aynı şema bölgesinde**;
iki şema dokunuşunun sırası netken çakışma riski **sıfır**, tersken bir **rebase turu**.

---

## Z24 · Musluk KAPANIR ve tablo ÖLÜR — `Z21` şart 3+4, tek turda

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Migration:** `1811000000000`

### Karar

```
POST /budget-allocations   SİLİNİR      (ve kalan altı uç, hepsi aynı tabloya bakıyor)
main.budget_allocations    DROP
main.budget_transaction_logs  DROP      (tek tüketicisi BudgetAllocationService'ti)
```

### Gerekçe zinciri — iki bacak da ÖLÇÜMLE düştü

`Z21` şart `3`, `POST`'u iki bacakla tutuyordu:

| bacak | akıbet |
|---|---|
| *"e2e tüketicisi var"* | **ÖLÇÜMLE DÜŞTÜ** — `T-270`'te zarf yoluna göçtü; kapanış koşulu **kendiliğinden karşılandı** |
| *"tablonun tek yazma yolu"* | **`Z21`'in kendi diliyle bu bir gerekçe değil, MUSLUĞUN TANIMI** |

> **"Geçiş dönemi kimin için?" sorusunun cevabı HİÇ KİMSE ise, geçiş dönemi YOKTUR.**

### Ve şart `4` aynı tura girer — ardışığı otomatik

Yazma yolu ölünce `budget_allocations`'ın **canlılık iddiası kalmaz**. Şart `3` ve `4`'ü
ayrı tutmanın **tek gerekçesi `POST`'un yaşama ihtimaliydi** — o ihtimal düştü.

```
tek migration          1811000000000
F12-deseni kayıt       tablo iki hafta önce DOĞDU, K-2.2.3 ihlali olarak ÖLDÜ
                       — doğum ve ölüm AYNI kayıtta, iziyle
app_runtime GRANT'ları aynı commit'te düşer            (K-2.6.13 birebirlik)
budget-report.dto.ts   bu turun doğal parçası — öksüzlüğü A2/T-265 zincirinin ürünü
                       (aynı ölüm, aynı mezar)
capabilities.ts:49     tek satırlık yorum düzeltmesi, bindirildi
```

### 📌 `budget_allocations`'ın doğum-ölüm kaydı (`F12` deseni)

```
2024-01-01   CreateBudgetEnvelopes             ← ZARF modeli ÖNCE
2026-02-15   UpdateBudgetAllocationStructure   ← tahsis tablosu doğdu (~14 ay SONRA)
2026-08-06   AddMetadataToBudgetAllocations    ← son bakım, ölümünden İKİ HAFTA önce
2026-08-23   Z24                               ← DROP
```

**Bir göç kalıntısı değildi — ölü doğmuş paralel bir modeldi**, ve `K-2.2.3`'ü
*"farklı bir yol farklı bir boyut kümesiyle zarf arayamaz"* **doğduğu andan beri**
ihlal ediyordu. Ölçülen tüketim: **sıfır satır, sıfır dış çağıran.**

### ⛔ EMSAL — `down()` DOĞRULAMASININ KANONİK BİÇİMİ (ürün sahibi, 2026-08-23)

> **Şema-dokunuşlu her migration'ın kabul kriterine girer:**
>
> ```
> pg_dump --schema-only   →   DROP ÖNCESİ dump saklanır
> migration:run
> migration:revert
> pg_dump --schema-only   →   ve iki dump BYTE-BİREBİR karşılaştırılır
> ```
>
> **`down()` elle eski migration metinleri birleştirilerek YAZILMAZ** — canlı katalogdan
> alınan DDL ile yazılır. `1811000000000` böyle yazıldı ve PK/index/FK adları dahil
> **birebir** tuttu.

**Neden emsal ilan ediliyor:** *"`down()` yazıldı ✅"* bir **niyet beyanıdır**
(`CLAUDE.md`: *"`@deprecated` bir niyet beyanıdır"* ailesi). Byte-karşılaştırma bir
**ölçümdür**. Yazılmazsa bir sonraki migration niyetle geçer ve **emsal bir kereliğe
düşer**.

⚠️ Ve bu, `§`'nin *"assert taşıyan migration ÜÇ durumu ayırt etmeli"* kuralının
**tamamlayıcısı**: o `up()`'ın dallarını, bu `down()`'ın **doğruluğunu** kapatıyor.

### 📌 MİKRO-DERS — sınıf düzeltmesi verilirken SINIFIN ENVANTERİ de ölçülür

`Z23` cascade'i **iki vaka** sayarak kaldırdı (`LTAAgreement.rates` ·
`LTAAgreement.planOverrides`). `Z24` turunda **üçüncüsü** çıktı:

```
budget-allocation.entity.ts:193   @OneToMany('BudgetTransactionLog', …, { cascade: true })
```

**Karar doğruydu, envanter eksikti.** Sınıf temelli bir karar verilirken *"bu sınıfın
başka üyesi var mı"* sorusu **tek grep'lik iş** — ve sorulmadı.

📌 Desen tanıdık: **sapma envanteri** vakası (`§`: *"sekiz vaka gibi bir sayı, LİSTESİYLE
anılır ya da HİÇ anılmaz"*). Burada sayı **iki** diye anıldı ve **üç**tü.

---

## Z25 · Kapanış-KOŞULLU her karar, koşulun ÖLÇÜM ADRESİYLE yaşar

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Kaynak:** `Z21` şart `3`'ün vakası

### Ölçülmüş vaka

`Z21` şart `3` şunu yazmıştı — ve **doğru yazmıştı** (`Z22`: kapanış bir takvim tarihi
değil, bir **koşul**):

> *"`POST` kalır ancak geçiş dönemi + kapanış kaydıyla — **e2e akışları zarf yoluna
> göçtüğünde** kaldırılır."*

**Göç `T-270`'te gerçekleşti.** Ve **kimse o karara geri bildirmedi.** Koşul
karşılanmıştı, karar hâlâ *"bekliyor"* görünüyordu — üç tur boyunca.

⚠️ Bulan şey bir mekanizma değil, `T-265` ajanının **brief taramasıydı**: brief'teki
gerekçe bayattı, ajan onu doğrulamaya çalışırken göçü fark etti. **Tesadüf değil ama
mekanik de değil.**

### Kural

> **Kapanış-koşullu her karar, koşulu TETİKLEYEN task'ın *"kapattıkları"* listesine
> girmelidir.**

`T-270`'in kapanışı *"`Z21`-3 koşulu karşılandı"* satırını taşısaydı, bu tur
**kendiliğinden** açılırdı.

**Mekanik alan** — `OPEN_DECISIONS`'a:

```
KOŞUL           ne olursa kapanır
TETİKLEYEN      hangi task o koşulu karşılar          ← BU ALAN
DURUM           bekliyor | koşul karşılandı | kapandı
```

📌 Ve bu, `§`'nin *"sağlayıcısı olmayan şart bir KİLİTTİR"* kuralının **kardeşi**: orada
sağlayıcı **yoktu**; burada sağlayıcı **vardı, geldi, ve kimse fark etmedi**.

⚠️ **Sarkan atıf dosya adında değil, KARARIN GEREKÇESİNDEYDİ** — `CLAUDE.md`'nin
*"test dosyası sözleşme adı taşır"* kuralının bir bükülmesi: ad düzeltilebilir,
**ona atıf veren gerekçe metni** düzeltilmez, çünkü onu kimse okumaz.

---

## Z26 · `SELF` = **yüklem + ALAN-SÖZLEŞMESİ**, ve ikincisi dekoratörün PARAMETRESİ

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Ölçüm:** `docs/process/SELF_OLCUM_RAPORU.md`

### Karar

> **`SELF` bir kova değil, bir YÜKLEM SINIFIDIR** — ve sözleşmesi **iki parçalıdır**:
>
> ```
> YÜKLEM   "kayıt benim mi"      →  @SelfScoped() dekoratörü
> ALAN     "neyi yazabilirim"    →  DAR DTO  (dekoratörün parametresi, AYRI mekanizma DEĞİL)
> ```

`Z18`'in reddettiği **dördüncü eksen** korunuyor: `SELF_WRITE` diye bir **yetenek hücresi
açılmaz** — *kapsam-varyantlı yetenek neyse, özne-varyantlı yetenek de o*.

### Neden genişledi — iskeletin KENDİ `DUR` koşulu ateşledi

İskelet, `PATCH /users/me`'nin **dar alan-listeli** olduğunu **örtük olarak** varsayıyordu.
**Ölçüm tersini gösterdi:**

```
PATCH /users/me   KENDİ DTO'SUNA SAHİP DEĞİL
                  PATCH /users/:id ile (USER_MANAGE ile) AYNI UpdateUserDto'yu paylaşıyor
                  daraltma:  tek satırlık  `delete dto.role`   (controller:111)
```

⇒ Bir `SELF` ucu, bir `ADMIN` ucunun yazma yüzeyinin **12 alanının 10'unu** taşıyor;
ikisi bir **kimlik kapısı** (`status`), biri **kimliğin kendisi** (`email`).

### ⛔ GENİŞLEMENİN ŞEKLİ — `İlke 4` gözetilir

> **Alan sınırını `delete dto.role` gibi **imperative daraltmalarla** ya da paylaşılan
> DTO'ya **istisna yamalarıyla** çözmek, tam da `T-269`/`T-273`'te öldürdüğümüz
> **"görünmez davranış"** sınıfını yeniden üretir.**

**Doğru temsil — `SELF` ucu KENDİ DAR DTO'sunu taşır:**

```
UpdateSelfDto     alanlar ÖLÇÜMDEN gelir (bugünkü ölçüm: fullName · firstName · lastName
                  · phoneNumber · department · jobTitle)
                  ⛔ role · scope · status · tenantId  TİPTE YOKTUR
ValidationPipe    forbidNonWhitelisted: true  → fazlalığı 400 ile REDDEDER
```

> **Böylece *"neyi yazabilirim"* sorusunun cevabı TİP SİSTEMİNDE yaşar** —
> grep'lenebilir, guard'lanabilir, **sessizce genişleyemez**.

### ⛔ SINIF KURALI — `SELF` ucu `MANAGE` ucunun DTO'sunu MİRAS ALAMAZ

Bugünkü kusurun **sınıf-kuralı hâli**. İki uç aynı DTO'yu paylaşırsa, `MANAGE` tarafına
eklenen her alan `SELF` tarafına **sessizce** düşer.

### `status` bulgusu — ayrı karar GEREKMEZ

Ölçüm: `status` **rolsüz bir uçtan yazılabiliyor**, ve `POST /users/:id/activate`
(`@Roles(ADMIN)`) o kolonun **resmî ucu**. Yönü **fail-closed** (kilitlenebilir, geri
açamaz — `JwtStrategy` her istekte yeniden okur).

> **"Kendi hesabını kilitleyebilme" bir ÖZELLİK değil, bir KAZA.**

Dar DTO onu **zaten dışarıda bırakır** — ayrı bir karar gerekmez.

📌 Ve `status` bir **alan değil, bir DURUM GEÇİŞİDİR** — `activate`/`deactivate` uçları
zaten öyle modelliyor. Genel bir `PATCH` gövdesinden yazılması bir **tasarım kazası**.

### Açık kalan (bu kararın DIŞINDA, kayda geçiyor)

```
role → 200 SESSİZ DÜŞÜRME · permissions → 200 SESSİZ NO-OP · tenantId/scope → 400
```

Dar DTO `SELF` tarafında bunu kapatır. **`PATCH /users/:id` (`USER_MANAGE`) tarafında
kapatmaz** — `T-242a`'nın `scope` için yaptığı düzeltme (`§2.5`: *"sessiz no-op'u açık bir
hataya çevirir"*) `role`/`permissions` için **yapılmadı**.

⚠️ Ve `user.service.ts:807 update()` **hiçbir denetim kaydı yazmıyor** — hem `/users/me`
hem **`/users/:id` (rol değişimi dahil)** bu yoldan geçiyor, `updated_by` da `NULL`.
`§2.3` (*"her işlem loglanır"*) ihlali; `Z20`'nin `USER_MANAGE` hücresini ilgilendirir.

---

## Z27 · `GET /approvals/pending` = **ONAYCI perspektifi**, `SELF` yüklemi DEĞİL

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi · **Uygulama:** `T-276`

### Karar

```
(a) "benim onayımı bekleyenler"      →  ✅ SEÇİLDİ — meşru bir ekran
(b) "benim gönderdiklerimden bekleyenler"  →  ⛔ RET — /my-requests'in KOPYASI (İlke 4)
```

⚠️ **Ve `(a)` bir `SELF` yüklemi DEĞİL** — *"onay kademesinde ben varım"* yüklemi. Yani
`SELF` kovasına **girmez**; `rol + kapsam` kesişimidir.

**Ürün dayanağı:** `PLAN_BUTCE_NETLESTIRME` `netleştirme-1(c)` — *"onay kuyruğunda zarf
bazlı toplam talep"*. Onay kuyruğu **onaycıya** gösterilen bir yüzey.

### Yüklem — bugünkü ASGARİ DOĞRU uygulama

Tam çözüm **şablon çözümlemesi + `K-2.5.12-R`'nin tek-hat kuralı** ister, ve o **`Faz 2`
işi**. Bugün uygulanacak:

```
kullanıcının rolü  ==  isteğin MEVCUT KADEME rolü
        ∧
kapsam kesişimi    !=  ∅
```

**Ölçüm doğrulaması:** `FINANCE`'in `ADMIN`'in kaydını görmesi **bu yüklemle de düşer**.

### ⛔ FIXTURE BORCU AÇIK KALIR — `Z25` tablosuna tetikleyicisiyle

```
KOŞUL       approval_levels DOLDUĞUNDA
NE OLUR     yüklem ŞABLON-ÇÖZÜMLEMELİ hâline göç eder
TETİKLEYEN  şablon motoru (Faz 2)
DURUM       ⏳ koşul — AKTİF İZLENİR (Z25 rejimi)
```

📌 **`(a)`/`(b)` ayrımının koddan okunamaması bir ÖLÇÜM SINIRI değil, bir VERİ
YOKLUĞUDUR** — `approval_levels` **`0` satır**. `CLAUDE.md`'nin *"verinin yokluğu örter"*
alt sınıfı: yol bugün koşmuyor, o yüzden semantiği **kod söylemiyor**.

---

## Z28 · `B4`'ün kabul kriteri **ÜÇ SAYACIN SIFIRI**

**Tarih:** 2026-08-23 · **Karar veren:** ürün sahibi

`FILTRESIZ = 0` **gerekli ama YETERLİ DEĞİL** — ölçüm üç ayrı sayaç gösterdi:

```
1  FILTRESIZ = 0                                    bugün 3   (/users/me ailesi)
2  @Roles taşıyan SELF uçları = 0                   bugün 4   (logout · 2× notifications
                                                                · my-requests)
3  guard DÖRDÜNCÜ KOVAYI iki-girdi-iki-çıktı ile TANIYOR      bugün ⛔ TANIMIYOR
```

### `3.` neden bir kabul kriteri — ölçülmüş sessizlik

`route-scope.awk` yalnız `Roles` · `Public` · `UseGuards` tanıyor. Fixture ile ölçüldü
(beklentiler **önceden** yazıldı, üçü de tuttu):

| varyant | beklenen | **ÖLÇÜLEN** |
|---|---|---|
| `v1` çıplak `@SelfScoped()` | `FILTRESIZ=3` | **`3` · EXIT=0** ⛔ **SESSİZ** |
| `v2` guard biçimi | `exit 2` | **`EXIT=2`** — guard'ın kendi `DUR`'u çalışıyor |
| `v3` **poz.kontrol** `@Roles(ADMIN)` | `FILTRESIZ=2` | **`2`** ✅ harness ayırt edici |

> **`v1`'in sessizliği, dekoratör + guard'ın AYNI TURDA inme zorunluluğunu kanıtladı** —
> ve o zorunluluk kabul kriterine **yazılmazsa bir sonraki dekoratör aynı sessizliğe
> düşer**.

### Ve `ADIM 3`'ün hikâyesi

> *"`61`'le başlayan hikâye sıfırla bitiyor"* — **düzeltilmiş hâli: sıfır, ÜÇ SAYACIN
> sıfırıdır.**

---

## Z29 · Ratchet'ler kendi BAŞARILARINI hata sayıyordu — `(b)` ile düzeltilir

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Tetikleyen:** `SELF` turu, `FILTRESIZ`'in ilk sıfırı

### Kusurun ANATOMİSİ — iki iddia, tek sinyal

```bash
route-scope.sh:343     if [ ! -s "$BASE_KEYS" ]  →  "SETUP HATASI" · exit 2
scope-ratchet.sh:128   DÖRT kovaya (A1·A2·B·C) aynı kontrol · exit 2
```

**İki farklı önerme tek sinyalde birleştirilmiş:**

```
"ayrıştırma çalıştı"  →  MEKANİZMA SAĞLIĞI
"F sayısı > 0"         →  ÖLÇÜM SONUCU
```

> **İkincisini birincinin KANITI yapmak, ancak sonuç HİÇ SIFIR OLAMAYACAKSA doğru
> kalır — ve ratchet'in bütün amacı o sonucu sıfıra indirmekti.**
>
> ⇒ **Kontrol, ratchet'in BAŞARISINI yapısal olarak "hata" diye tanımlamıştı.**

⚠️ Dal bugüne kadar **hiç koşmadı**, o yüzden kimse görmedi. `§`'nin *"bir kuralın doğru
olduğunu kırmızıya dönmemesinden çıkarma — o kuralın reddedeceği girdi ona ULAŞIYOR
mu?"* sınıfının kitabına uygun vakası; **cevabı hayırdı**.

📌 Ve `scope-ratchet` daha keskin: **`A1` tam olarak sıfıra indirilmeye çalışılan liste**
(kapsam eksiği kovası). `ADIM 3` başardığı gün guard onu **hata** sayacaktı.

### Karar — `(b)`, üç şartla

**1 · Ayrıştırma sağlığı KENDİ sinyalini alır** — *"başlık biçimi görüldü mü"*,
`F` sayısından **bağımsız**.

> **Boş-ama-geçerli ile bozuk-baseline'ı ayıran şey İÇERİK BİÇİMİDİR, satır sayısı
> değil.**

**2 · İki-girdi-iki-çıktı kanıtı zorunlu**, ve **sıfır SESSİZ geçilmez**:

```
gerçekten bozuk (başlıksız/çorba)  →  exit 2
boş-ama-geçerli                    →  exit 0  +  "ratchet TAMAMLANDI" ÇIKTISI
```

> **Sıfır bir BAŞARI OLAYIDIR ve görünür olmalı** — `B4`'ün ön koşulu **tam o satırı
> okuyacak**.

**3 · Düzeltme SINIFA uygulanır, vakaya değil.** Envanter ölçüldü: `! -s` deseni **iki**
guard'da (`route-scope` tek liste · `scope-ratchet` dört kova). ⚠️ Ajan bunu **genişletmekle**
yükümlü — sayı-tabanlı baseline'lar aynı sınıfın **farklı biçimini** taşıyabilir.

📌 **`B3b`'nin kalan-`@Roles` ratchet'i doğduğu gün SIFIR-GÜVENLİ doğsun** — bu düzeltme
onun **ön koşulu**.

### `(a)` reddedildi, ama YARISI `(2)`'de yaşıyor

Sentinel (`# ratchet: COMPLETE`) **reddedildi**: bir **biçim alanı** üçüncü bir sözleşme
olurdu. Ama kendini-belgeleme ihtiyacı **gerçekti** — çözümü **script çıktısına açık bir
"tamamlandı" satırı** koymak.

> **Biçim alanı üçüncü bir sözleşme olur; çıktı satırı olmaz.**

### Kovaların YORUMU farklı, kontrol AYNI

```
A1 · A2 · FILTRESIZ   sıfıra inmesi HEDEF       →  "TAMAMLANDI" anlamlı
B · C                 sınıflandırma kovaları    →  boşalması BEKLENMEZ, ama
                                                   "bozuk" da demek DEĞİL
```

Kontrol **tek biçimde** (biçim sağlığı); **çıktı metni** kovaya göre farklılaşabilir.

---

## Z30 · `B3a` karar paketi — DOKUZ HÜKÜM, eksen değişikliği ve istisnalar

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Ölçüm:** `docs/process/B3A_ESLEME_TABLOSU.md`

---

### H1 · ⛔ UNION GENİŞLEMELERİ REDDEDİLİR — **yön ters çevrilir**

> **Harita ROTALARDAN türetilir, rotalar HARİTADAN değil.**

`Faz A`'nın union kararı (`capabilities.ts:111`, **2026-08-17**) `Z18 §4`'ten (**2026-08-21**)
**önceydi**; `Z18` onu **fiilen geçersiz kıldı**, harita güncellenmedi.

> ⇒ **`26` rota *"genişleyecek"* değil — HARİTA YANLIŞ.**

**Ve iki genişleme satırı yalnız `Z18`'e değil, KAYITLI KARARLARA da çarpıyor** — ikisi de
ölçüldü:

```
FINANCE → Plan CRUD          K-2.6.4 (L2_03:408): "FİNANS — Eşik üstü onay/bildirim,
                             transfer, mutabakat, içe aktarma"
                             ⛔ PLAN YAZIMI YOK. DELETE /plans/:id dahil olması TEK BAŞINA yeter.

PLANNER → upload·validate    K-2.6.14 (L2_03:511-518) — YÜRÜRLÜKTEKİ faz:
        ·process             | Bugün                  | yalnız finans + yönetici |
                             | Eşleştirme geldiğinde  | + planlamacı             |
                             ⛔ Geçici sapma KAYITLI, ve ihlal edilir.
```

**Düzeltme:** `ROLE_CAPABILITIES`, **mevcut `@Roles` gerçeğinin + `K-2.6.4` cümle
testinin FIXPOINT'ine** düzeltilir.

> ### ⛔ FIXPOINT'İN KABUL KRİTERİNE BİR SATIR — faz tablolu kurallar
>
> **Faz tablosu taşıyan kurallar (`K-2.6.14` gibi) YÜRÜRLÜKTEKİ fazıyla türetilir,
> HEDEF fazıyla değil.**
>
> Bu turun bulgusu tam buydu: harita `K-2.6.14`'ün *"eşleştirme geldiğinde + planlamacı"*
> **hedef** satırını okumuş, *"bugün: yalnız finans + yönetici"* **yürürlükteki** satırını
> **okumamıştı**.
>
> ⇒ **Aynı hata fixpoint türetiminde TEKRARLANABİLİR** — ve bu kez `211` rotanın tamamında.
>
> **Pratik:** bir kural bir tabloya işaret ediyorsa, türetim **hangi satırın bugün
> geçerli olduğunu** ayrıca ölçer; kuralın **son** satırı varsayılan **değildir**.

⚠️ **Bir hücrede İKİ MEŞRU KÜME çıkıyorsa (ör. `MODES_WRITE`'ın `AP`/`AF` karışımı)
HÜCRE AYRIŞIR** — küme farkı gerekçeliyse **hücrenin bölünmesi doğrudur**, rotaların
union'a hizalanması **değil**.

---

### H2 · `MODES_SUBMIT` DOĞAR — şık `(ii)`, `24 → 25` hücre

Beş gönderim/geri-çekme rotası **tek küme** (`AP`), ve gerekçesi **union değil ROL
TANIMI**:

```
K-2.6.4 (L2_03:406)  "PLANLAMACI — Plan, taktik, hacim girişi, GÖNDERİM — günlük kullanıcı"
                                                              ^^^^^^^^ kelimesiyle YAZILI
```

`dal 1` (tek küme, **mekanik**). Eksen değişikliği bu kayıtla iner.

📌 **`capabilities.ts:134`'ün iki-ayrımına ÜÇÜNCÜ satır:**

```
onaylar   ≠   görür   ≠   GÖNDERİR
```

---

### H3 · BEŞ BOŞ HÜCRENİN BEŞİ DE SİLİNİR — ve GENEL KURAL doğar

| hücre | gerekçe |
|---|---|
| `SHARED_APPROVE` | `0` rota, gerekçesiz |
| `NOTIFICATION_READ` | rotalar `@SelfScoped`'a geçti — **kalıntı** |
| `USER_READ` | `Z20` kalıntısı |
| `HEALTH_READ` | rota `@Public()` |
| `MODES_MANAGE` | ⛔ **"yol olmadan verilmiş yetki" YAŞAYAMAZ** |

⚠️ İleride bir `MANAGE` rotası doğarsa hücre **kararla geri gelir**.

> ### ⛔ KURAL — hücreler ROTA ENVANTERİNDEN türer
>
> **Arkasında rota olmayan bir hücre haritada DURMAZ.**
>
> 📌 `K-2.3.4`'ün (*"hep boş kolon olmamalı"*) **yetenek hâli**.

---

### H4 · `Z18` ÜÇLEMESİNİN HÜCRE KARŞILIĞI — kilit AÇILIYOR

| Z18 sınıfı | hücre karşılığı | rota |
|---|---|---|
| **modül-READ** | mevcut `MODES_READ` / `SHARED_READ` | **50 göçebilir** |
| **ÖZET** | ⛔ **`SUMMARY_READ` DOĞAR** — çapraz-modül özet yüzeyler | dashboard · settlements/summary sınıfı |
| **READ_OWN** | ⛔ **HÜCRE DEĞİL, İŞARET** — rol-kısıtlı + sahiplik-yüklemli | `my-requests` ailesi |

**modül-READ:** kapsamlı olmaları **hücreyi değiştirmez** — kapsam **ayrı sütunda** kalır.
📌 **Dördüncü-eksen reddi (`Z18`) tam burada iş görüyor.**

**`SUMMARY_READ`'in tanımına KAPSAM-ZORUNLULUĞU yazılır:**

> ⛔ **Kapsamsız bir `SUMMARY_READ` rotası kabul kriterini GEÇEMEZ.**
> `T-253` dersinin **kurallaşması** (*"özet uçlarında kapsam yok"* — canlı bypass'tı).

**`READ_OWN` bir işarettir:** o rotalar **capability + own-yüklemi** taşır.

⚠️ **`14` adayın `(b)`/`(c)` dağılımı TABLODAN TEK TEK** — mini-liste ürün sahibine,
**toptan atama yok**.

---

### H5 · `POST /notifications/:id/read` → `@SelfScoped`'a geçer

Kardeşleriyle **aynı kova**; `5/5` rol kısıtı **zaten kısıt değildi**.

> ### ⛔ VE `Z28` SAYACININ KÖR NOKTASI KURALA BAĞLANIR
>
> **Yüklemi `SELF` olan rota `@SelfScoped` TAŞIR — dekoratör, YÜKLEMİN BEYANIDIR.**
>
> Sayaç **dekoratör-bazlı kalır** ve bu kuralla **doğru okur**.

📌 `B3a` tablosunun **yüklem-`SELF` taraması** bu kuralın **tek-seferlik envanteri**.

---

### H6 · `kpis/grid` ikizi — ÖLÇÜMSÜZ HÜCRE ATANMAZ

`/kpis/grid`'in (planId'siz) **ne döndürdüğü ölçülür**; iki kardeş **ayrışabilir**.
`T-273` disiplini aynen: *"statik olarak özdeş iki yapı davranışsal olarak özdeş
sayılamaz."*

---

### H7 · `Z20` DARALTMASI — bilinçli, KAYITLI istisna

```
GET /users   @Roles(ADMIN, FINANCE)  →  @Roles(ADMIN)      FINANCE DÜŞER
```

*"Göç davranış değiştirmez"* kuralının **`DUR`-kaynaklı, kayıtlı istisnası**.
`K-2.6.4` cümle testi **Finans'a kullanıcı-listesi vermiyor**.

⚠️ Ve `capabilities.ts`'in **kendi kendisiyle çelişen bayat satırları** (`:154`'ün
*"DUR (5)"* notu, `USER_READ` hücresi) **harita-düzeltme dalgasında** temizlenir.

---

### H8 · `UNRESTRICTED` TERFİSİ — şık `(c)`, ve SIRA `3 → 1 → 2`

```
3  FINANCE'ın K-2.6.4 gerekçesi YAZILIR        ← İLK
1  ADMIN + FINANCE'a joker user_scopes satırı  (seed + migration)
2  UNRESTRICTED_ROLES kod dalı KALDIRILIR      ← SON
```

> ### ⛔ EKLEME (`Z35`) — `ADMIN`'in gerekçesi de YAZILIR
>
> `ADMIN`'in **kapsamsızlığı VE her-küme üyeliği** `K-2.6.4`'te **açık cümleye** bağlanır:
> *"tanımlar ve kural yönetimi"* cümlesi bunu **taşıyor mu**, yoksa **genişletilmeli mi**?
>
> **Gerekçe:** `L2_03`'te `YÖNETİCİ` **yalnız bir kez** geçiyor (`:405`) — yani `ADMIN`'in
> her kümede bulunuşu fiilen *"tanım gereği her şeye"* varsayımına yaslanıyor, **ve o
> varsayım `FINANCE` için REDDETTİĞİMİZ KOŞULSUZLUĞUN TA KENDİSİ.**
>
> ⚠️ **Yazılmazsa `ADMIN` sistemdeki SON "koşulsuz sabit" olarak kalır.**

⛔ **AYRILABİLİRLİK ŞARTI AÇIK: `1` inmeden `2` inemez.** `rows.length === 0` →
*"hiçbir şey"* → `ADMIN`/`FINANCE` **fail-closed düşer**. Ara durum **deploy edilemez**.

📌 **`T-272` dersinin TERS yönde uygulaması: burada SIRA YETMEZ, ATOMİKLİK ŞART.**

**`Z18 §3`'ün bayat kümesi `0006-R` deseniyle düzeltilir:**

```
Z18 §3 dedi   "küme AYNI kalır  {ADMIN, FINANCE, READONLY}"
kod bugün     {ADMIN, FINANCE}   — READONLY T-235 ile ÇIKARILMIŞTI (Z18'den ÖNCE)
kayda         "Z18 YAZILDIĞI GÜN DE YANLIŞTI"
```

✅ **Pencere şerhi kabul** — `UNRESTRICTED_ROLES`'un tek okuyucusu `AccessScopeService`,
`@RequireCapability` `RolesGuard` hattında. **Sıfır çağrı bağı → PARALEL yürür.**

---

### H9 · ÇAPRAZ-REPO — bedel düştü, GERÇEK kaldı

`H1` reddedildiği için `canEdit` uyumsuzluğunun **somut bedeli büyük ölçüde düşüyor**
(API genişlemeyecek → **ekran-API makası açılmayacak**).

⚠️ **Ama iki-kopya gerçeği KALIYOR:**

> *"Eylem kapıları tek kaynaktan türemeli"* — **`Faz` sonrası aday** olarak kaydedilir,
> **şimdi iş açılmaz**.

`UserForm.tsx:118`'in **ölü `permissions` gönderimi** → küçük frontend temizliği, kuyruğa,
`Z26`'nın **gönderen-tarafı** referansıyla.

---

## `B3b`'NİN ŞEKLİ — bu dokuz hükümden türüyor

```
B3b-0   HARİTA DÜZELTME DALGASI          kod ama DAVRANIŞSIZ
        fixpoint kümeler (H1) · MODES_SUBMIT (H2) · SUMMARY_READ (H4)
        · beş silme (H3) · bayat yorumlar (H7)
        ⚠️ harita henüz CANLI GUARD'DA DEĞİL — davranış değişmez

B3b-1…n MODÜL DALGALARI                   ratchet'li, tek yön aşağı
```

### ⛔ RATCHET TABANI YENİDEN HESAPLANIR

```
211   OLAMAZ   (104 mekanik göçebilir)
107   ÜST SINIR
gerçek taban   HARİTA DÜZELTMESİ SONRASI ÖLÇÜLÜR      ← H1–H4 kümeleri değiştiriyor
```

📌 Team Lead'in *"`211` olamaz"* düzeltmesinin **ikinci yarısı budur**.

### Cümle borcu — MODÜL MODÜL, toptan değil

`B3a`'nın sınır notu `1`: birebir-`✅` olup **`Z18 §4` cümle şartını karşılamayan**
satırlar (`T3`/`T6`/`T8`) **`B3b` dalgalarında, DOKUNULAN DALGAYLA** cümlelenir.

---

## Z31 · `SUMMARY_READ`'in TANIMI keskinleşti — ve üyeliği TANIM sayar

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Ölçüm:** `B3A_ESLEME_TABLOSU.md` EK

### ⛔ TANIM — üç şart

> **`SUMMARY_READ` = NESNE-BAĞSIZ + ÇOK-İŞLEM-MODÜLLÜ portföy özeti.**
> **Kapsam-zorunluluğu TANIM ŞARTIDIR.**

Üç keskinleştirme, üç karardan türedi:

```
1  KAYIT PARAMETRESİ taşıyan rota SUMMARY_READ OLAMAZ        (H4-1, budget-check)
2  YÜZEY ADRESİ hücre belirlemez, VERİ SINIFI belirler       (H4-2, pending-tasks)
3  REFERANS-VERİ join'i ÇAPRAZ-MODÜL SAYMAZ                  (H4-3, cpl-status)
   → modül sayımı İŞLEM-VERİSİ modülleriyle yapılır
```

⛔ **Üyeliği ürün sahibi saymaz, TANIM sayar.** Sınırda kalan **tek tek** gelir.

---

### H4-1 · `plans/:id/budget-check` → **modül-READ**

Çapraz-modüllük **gerekli ama YETERLİ DEĞİL**. Tek bir kaydın (`:id`) bağlamında yapılan
çapraz-modül okuma, **erişim sorusunu O KAYDIN erişim sorusundan alır**:

> **Planı okuyabilen, planının bütçe kontrolünü de okuyabilir.**

`SUMMARY_READ`'in kapsam-zorunlu sözleşmesi **`T-253` sınıfı için** yazıldı — *tenant'a
yayılan* yüzeyler. **Kayıt-parametreli okumalar o sınıfta değil.**

### H4-2 · `dashboard/pending-tasks` → **modül-READ** (`agreements`)

**`T-255`'in kendi kuralının SİMETRİK uygulaması:** `kpis/grid`'i master-data yolundan
çıkarıp veri sınıfına göre sınıflarken kullandığımız ilke, **ters yönde de bağlar**.

> **Yüzey adresi hücre belirlemez, VERİ SINIFI belirler. `/dashboard` bir URL
> KOZMETİĞİdir.**

📌 Ve `H1` yönü sayesinde karar **geleceğe dayanıklı**: yarın `pending-tasks` plan verisi
de toplarsa, hücresi **ölçülen yeni veri sınıfıyla** `SUMMARY_READ`'e göçer —
**harita rotayı izler.**

### H4-3 · `dashboard/cpl-status` → **modül-READ**

> **Referans-veri join'i çapraz-modül SAYMAZ.**

Hemen her rota ad/kategori çözmek için ana-veri okur; bunlar sayılırsa **her şey
çapraz-modül olur** ve `SUMMARY_READ` **anlamını yitirir**.

### H4-4 · `plans/approval-queue` — KAYDA GEÇER, YENİDEN ADLANDIRILMAZ

*"Ad `OWN` diyor, yüklem `SCOPE`"* bir **bayat-atıf** vakası — ama **route-path tel
protokolüne komşu**; `B3b` içinde ad değişikliği **davranış-koruma kuralını deler**.

📌 **Ve asıl ilginç kısım:** `T-276`'nın `(a)`-yüklemi (*"onay kademesinde ben varım"*)
indiğinde bu rotanın **adı doğru, yüklemi eksik** çıkabilir — yani **ad bayat değil,
YÜKLEMİNİ BEKLEYEN bir rota** olabilir.

**Harita satırına ÇİFT NOT:** bugünkü gerçek (`SCOPE`) + **`T-276` adaylığı**.

### H4-5 · `kpis/grid` ikizleri — AYNI HÜCRE, üç ayrık iş

```
(a) KOVA DÜZELTMESİ    ikisi de C. "Veri sınıfı aynıysa kova aynı —
                       KAPININ VARLIĞI kova belirlemez."
                       (T-273'ün TERSİNİN kural hâli)
                       Z19b'nin kayıtlı sınıflandırmasına ÖLÇÜM REFERANSIYLA işlenir.

(b) ROL KÜMESİ KALIR, GEREKÇESİ DEĞİŞİR
                       5/5 meşru — ama ÇÜRÜYEN plan-verisi gerekçesiyle değil;
                       B1'in KATALOG cümlesiyle yeniden cümlelenir.
                       ⛔ Çürümüş gerekçeyle ayakta kalan DOĞRU SONUÇ, gerekçesiz
                         sonuçtan TEHLİKELİDİR — çünkü kimse yeniden bakmaz.

(c) KAPININ KENDİSİ    veri plan-bağımsızsa :planId kapısı NEYİ koruyor?
                       ⛔ davranış ölçülmedi, İDDİA YAZILMAZ.
                       İki-girdi testiyle küçük ölçüm kalemi → KUYRUĞA, B3b-0'a GİRMEZ.
```

> ### ⛔ MİKRO-KURAL — yorum GEREKÇE taşıyorsa ÇİFT TEMSİLDİR
>
> **Gerekçenin evi HARİTA/KURAL GÖVDESİDİR; yorum ancak oraya İŞARET EDER.**
>
> Vaka: `kpi.controller.ts:70` *"bu uç master-data DEĞİL, PLAN verisi döndürüyor"* ↔
> `kpi.service.ts:94-95` *"it never returns plan content"* — **aynı repo, aynı rota, iki
> zıt cümle**, ve ölçüm servisinkini destekliyor.

---

### ⛔ VE `READ_OWN` MEKANİZMASI `B3b-0`'DA İNŞA EDİLMEZ

`(c) = 0`'ın **zorunlu sonucu**: tanım olarak `Z30`'da **kalır**, ama **mekanizması
kurulmaz**.

> **Sıfır üyeli mekanizma, `H3`'ün ruhuna aykırı ÖLÜ KODdur.**

İlk üyesi doğduğunda (**en güçlü aday: `T-276`'nın yüzeyi**) mekanizma **onunla birlikte
gelir**.

---

## ⚠️ AÇIK — EVREN DAİRESEL SEÇİLMİŞTİ, ve tanım değişince genişledi

`14` aday **kapsam `B` kovasından** türetilmişti — yani *"kapsamı OLANLAR"*. Ama
`SUMMARY_READ`'in üçüncü şartı **kapsam-zorunluluk**.

> ⛔ **Evren, tanımın gerektirdiği ÖZELLİKLE seçilmişti** — o yüzden şart **tanım gereği**
> sağlanıyor ve **ihlal edecek vakalar görünmüyordu**.

**Team Lead ölçtü** — `B` kovasının **dışında**, özet-şekilli ve **nesne-bağsız** rotalar:

```
scope-a1 (kapsam GEREKLİ, UYGULANMIYOR)
  finance-reporting/  budget-utilization · spend-trend · budget-at-risk
                      cash-flow-projection · mechanic-effectiveness
                      plan-performance · spend-composition · variance-analysis   [8]
  agreement-transactions/stats/summary · actuals-first/sales-actuals/summary     [2]
scope-b
  finance-reporting/budget-variance                                              [1]
```

📌 **Kardeş asimetrisi:** `finance-reporting`'in **9** rotasından **8'i `A1`**, **1'i `B`**.
Aynı controller, aynı şekil. Ve `A1` dosyasının kendi yorumu sebebini yazıyor:
*"EKLEME (gerekçeli): finance-reporting (**`T-254` kanıtlı fail-open**)"*.

### Sorulacak

> **Veri sınıfıyla `SUMMARY_READ` olan ama KAPSAMI OLMAYAN bir rota hangi hücreye girer?**

```
(i)  SUMMARY_READ alır  →  tanım şartını İHLAL eder, ve kabul kriteri onu KIRMIZI yapar
                           ⇒ hücre bir KUSUR BİLDİRİCİSİ olur
(ii) modül-READ'de kalır →  kapsam inene kadar; SUMMARY_READ'e GÖÇER
                           ⇒ hücre TEMİZ kalır, kusur A1 ratchet'inde izlenir
```

⚠️ `A1` zaten *"kapsam gerekli, uygulanmıyor"* demek — yani iki mekanizma **aynı şeyi**
iki yerden söylüyor olabilir (`İlke 4`).

---

## Z32 · `SUMMARY_READ` tanımı DÜZELTİLDİ — kapsam bir ŞART değil, bir SÖZLEŞME

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Tetikleyen:** `Z31`'in dairesel-evren bulgusu

### ⛔ İKİ ŞIKKIN ORTAK ÖNCÜLÜ REDDEDİLDİ

`Z31`'in açık sorusu iki şık sunuyordu — ve **ikisi de aynı varsayımı taşıyordu**:
*kapsam durumu hücre atamasına GİRDİ'dir*.

> **HÜCRE İLE KAPSAM AYNI EKSENDE YARIŞMAZ.**

Ve o öncül, **`B2`'de kurulan iki-sütun mimarisini geri sarar** (`Z19b`: *"`B2`'nin yeşili
YALNIZ `@Roles` sütununu kapatır"*).

### Düzeltilmiş tanım

```
ÜYELİK ŞARTI (2)   nesne-bağsız  ∧  çok-işlem-modüllü portföy özeti
SÖZLEŞME (1)       kapsam yükümlülüğü  —  üyeliğin SONUCU, FİLTRESİ DEĞİL
```

> **`SUMMARY_READ` hücresine giren rota, kapsam yükümlülüğünü ALIR.** Taşımıyorsa
> **tanım-dışı değil**, **YÜKÜMLÜLÜK-İHLALİNDE** bir rotadır — ve ihlalin adresi **zaten
> var: `A1` ratchet'i.**

⇒ **`10` rota `SUMMARY_READ`'e GİRER.**

### Neden iki şık da düştü — aynı ilkeden

**`(i)` `SUMMARY_READ` alır + kabul kriterini kırmızı yapar:**

`İlke 4`'ü deler (`A1` zaten *"kapsam gerekli, uygulanmıyor"* diyor; hücrenin kırmızısı
**ikinci bir söyleyiş**). **Ama daha kötüsü:**

> **`B3b`'nin kabulünü, `B3`'ün SAHİBİ OLMADIĞI kusurlara REHİN VERİR** — göç dalgası
> kapsam işini bekler, **bilerek ayırdığımız iki hat yeniden kenetlenir**.

**`(ii)` modül-READ'de kalır:**

> **HARİTAYI YALANCI YAPAR.** *"Modül-READ"* etiketi bu `10` rota için **veri sınıfı
> olarak YANLIŞ** — kusuru başka yerde görünür tutmak için haritaya **yanlış beyan**
> yazmak, `kpis/grid` controller-yorumunun işlediği günahın **kurumsal hâli** olur.

⛔ **Ve asıl tehlikesi: ŞEKİL, RİSKİN SİNYALİDİR.** `T-253`'ün `10` rotası tehlikeli
**çünkü özet-şekilli ve kapsamsız**; onları modül-READ'e dosyalamak **şekli gizler**, ve
*"kimse bakmıyordu"*yu **yapısallaştırır**.

---

### ✅ `T-253` ENDİŞESİNİN GERÇEK CEVABI: `SUMMARY_READ ∧ A1`

**İki mevcut sütunun JOIN'i — yeni mekanizma DEĞİL.**

```
İlke 4 temiz:  tek gerçek İKİ SÜTUNDA, kesişim TÜRETİLMİŞ GÖRÜNÜM
```

**Ve bu liste BUGÜN BİLE ödüyor:** `10`'un içinde `T-253`'ün **sessiz uçları zaten
duruyor** (`plan-performance`, `agreement-transactions/stats/summary`).

⇒ **Kesişim, kapsam-kalanları işinin ÖNCELİK SIRASI oluyor:** rastgele `41` kapsamsız rota
değil, **"özet-şekilli kapsamsız `10`"** önce.

### Kabul kriterinin EVİ netleşti

```
SUMMARY_READ ∧ A1 = 0     ←  KAPSAM HATTININ çıkış ölçütü   (B3'ün DEĞİL)
```

**Sıfırlandığı gün kural KAPIYA TERFİ EDER:**

> **Yeni bir `SUMMARY_READ` rotası KAPSAMSIZ DOĞAMAZ — doğum kontrolü.**

📌 **`T-253`'ün KALICI cevabı, hücrenin bugün kırmızı olması değil — sınıfın YARIN
KAPSAMSIZ DOĞAMAMASI.**

---

### Dairesel-evren bulgusunun MEKANİK karşılığı

> **`B3b-0`'ın brief'ine açıkça yazılır: üyelik türetiminin evreni = TÜM `READ` ROTALARI
> (`223` evreninden), KAPSAM KOVASI FİLTRESİZ.**

Team Lead'in `10`'luk dış-evren taraması **o türetimin ilk girdisi**.

---

## Z33 · `MODES_WRITE`'ın ÜÇÜNCÜ hücresi REDDEDİLDİ — ve adlandırma VERİ SINIFINDAN

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Tetikleyen:** `B3b-0`'ın `H1` `DUR`'u

### Karar — üçüncü hücre YOK

> **Bir hücre ayrı olmayı, AYRI BİR ROL-KÜME SINIFI temsil ediyorsa hak eder.**
> **TEK ROTA SINIF DEĞİL, VAKAdır.**

📌 **Sözlük ölçütünün hücre hâli:** bir olay ayrı tür olmayı *"denetimin cevaplayamayacağı
soru varsa"* hak ediyordu (`Madde 1`); bir hücre de aynı eşiği geçmeli.

⚠️ **Aksi hâlde:** `n=1` hücre kabul edilirse, bir sonraki tuhaf rota da hücresini ister ve
**harita, rotaların AYNASI olmaktan çıkıp KOPYASI olur** — `H3`'ün sildiği enflasyonun
**doğum yönünden** geri gelişi.

**`MODES_SUBMIT` emsali bunu ÇELMEZ** — o **üç** şartla doğdu, ve burada **üçü de yok**:

```
MODES_SUBMIT   n=5  ∧  TEK küme  ∧  katalogda YAZILI cümle ("gönderim", K-2.6.4)
n=1 rotası     n=1  ∧  —         ∧  —
```

### ⛔ AMA İLİŞTİRME YÖNÜ BUGÜN VERİLEMEZ — her iki yön de bir GÜNAH işliyor

```
{A,F}'ye iliştir  →  PLANNER DÜŞER = davranış DARALTMASI
                     ancak Z20 gibi KAYITLI GEREKÇEYLE yapılabilir
{A,P}'ye iliştir  →  o tarafa FINANCE eklenir = H1'in REDDETTİĞİ şekle döner
```

⇒ **Her iki iliştirme de ya bir İSTİSNA KAYDI ya bir UNION üretiyor.** Hakem: **üç
ölçülmemiş soru** (`ÖLÇÜM 1` veri sınıfı + tetiklenme · `ÖLÇÜM 2` `K-2.6.14` testi ·
`ÖLÇÜM 3` `PLANNER` cümlesi).

### 📌 BEYAN ≠ GEREKÇE — ve bu, `B3a` sınır-notu `#1`'in İLK ZORUNLU UYGULAMASI

Rotanın kümeyi **kendi beyanıyla** taşıması (`T9 ✅`) **doğru okuma** — union türetimi
**yok**. Ama `B3a`'nın kendi sınır notu bunu söylüyordu:

> *"Birebir-`✅` satırlar bile cümle şartını HENÜZ KARŞILAMIYOR."*

Bu rota, o notun **ilk zorunlu uygulaması** oldu.

### Geçici durum

Rota **`H1`-`DUR` listesinde kalır** (zaten orada — **yeni blokaj değil**). **Bölünmenin
diğer `17`'si onu BEKLEMEZ:**

> `n=1`'i bekletmek ratchet'i **anlamlı geciktirmez**; `17`'yi bekletmek **geciktirir**.

### ⛔ ADLANDIRMA İLKESİ — hücre adları VERİ SINIFINDAN gelir

```
{A,F} tarafı   →   gerçekleşme/alım YAZIMI
{A,P} tarafı   →   plan/anlaşma YAZIMI
```

> ⛔ **`AF_WRITE` gibi bir KÜME-ADI, kümenin GEREKÇESİNİ ADIN İÇİNE GÖMER — ve küme
> değişince AD YALAN SÖYLER.**

📌 Ve bu adlandırmayla `n=1` sorusu **doğru formuna iner**:

> ***"Bir GERÇEKLEŞME-YAZIM yüzeyinde `PLANNER` ne arıyor?"***

Cevabı `ÖLÇÜM 2` verir — ve cevabı **iliştirmenin TÜRÜNÜ** de belirliyor:

```
K-2.6.14 testi EVET  →  {A,F}'ye iliştirme bir DÜZELTMEdir, İSTİSNA DEĞİL
                        ⇒ rota YANLIŞ DOĞMUŞ (budget_allocations deseninin küçüğü)
K-2.6.14 testi HAYIR →  ÖLÇÜM 3: üç rolün ÜÇÜ DE cümle ister (soru SİMETRİK)
```

---

## Z34 · Ham `grep` HÜKÜM üretmez — kanonik ayrıştırıcı zorunlu

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi

### Ölçülmüş vaka — ve teşhis DEĞİŞTİ

Bir oturumda **üç kez** aynı sınıf hata: `stderr` kapsamayan tarama · satır sonunu aşamayan
desen · **yorum kirliliği**. Üçü de **yanlış-negatif** yönünde, ve **kural yazılıyken**
tekrarladı.

> **Kural yazılıyken üç kez tekrarlıyorsa, bu bir DİSİPLİN açığı değil — bir ARAÇ açığıdır.**

⚠️ **Ama ölçüm teşhisi bir adım öteye taşıdı:** araç **zaten vardı**
(`scripts/guards/find-importers.sh`, `T-212`), ve aynı soruya **doğru cevabı** veriyordu
(`capabilities` → `0` tüketici). **`CLAUDE.md`'nin import kuralı onu ADLANDIRMIYORDU.**

⇒ **Bir ARAÇ-YÖNLENDİRME açığı.**

### Kural

```
ham grep                →  ÖN-TARAMA üretir
"tüketici yok/import yok" HÜKMÜ  →  KANONİK AYRIŞTIRICIDAN gelir
```

📌 **Emsal `route-scope.awk`:** rota sorusunun kanonik ayrıştırıcısı var, ve **ham `grep`'e
kimse düşmüyor**. Aynı şey import/tüketici sorusu için de geçerli olmalıydı — araç vardı,
**kural işaret etmiyordu**.

> **Üçüncü tekrar, kuralın KİŞİYE değil ALETE bağlanma anıdır** — `E6`'nın doğuş
> hikâyesinin birebir aynısı.

---

## Z35 · `n=1` ÇÖZÜLDÜ — `{A,F}`'ye DÜZELTME, ve `K-2.6.14`'e KAPSAM AÇIKLIĞI

**Tarih:** 2026-08-24 · **Karar veren:** ürün sahibi · **Ölçüm:** `B3A_ESLEME_TABLOSU.md` `EK 2`

### 1 · İliştirme: `{A,F}` — ve bu bir DÜZELTMEdir

**Üç ölçüm BAĞIMSIZ yollardan aynı yere çıktı:**

```
YAPISAL     create ≡ batchImport — aynı yazma yolu, DOSYASIZ KAPI
NORMATİF    K-2.6.14: "görev ayrılığı VERİ GİRİŞİNİ değil, FİNANSAL KARARI korur"
            → DEBIT aynı çağrıda (service:238), ara statü YOK
TAKSONOMİK  PLANNER cümlesi YAZILAMIYOR — "hacim girişi" PLAN hacmidir
```

⇒ **Rota YANLIŞ DOĞMUŞ.** `{A,F}` bir **istisna değil, DÜZELTMEdir**.

**Ve *"göç davranış değiştirmez"* kuralının `Z20`'den sonraki İKİNCİ KAYITLI İSTİSNASI
olarak yazılır:** `PLANNER` bu uçtan **düşüyor**, `DUR`-kaynaklı, gerekçesi **üç ölçüm**.

### ⛔ EŞZAMANLILIK ŞARTI — iki repo, TEK kapanış tanımı

> **Bu daraltma `T-277`'nin FRONTEND düzeltmesiyle EŞZAMANLI inmeli.**
>
> API kapanıp ekran *"Manuel Giriş"*i göstermeye devam ederse, kullanıcıya **`403`
> sürpriziyle yaşayan YARIM DÜZELTME** olur.

📌 `§ AYRILABİLİRLİK` kuralının **ters yönü**: orada ara durumun **deploy edilebilir**
olması isteniyordu; burada ara durum **kullanıcıya görünür bir kusur** üretiyor, o yüzden
**ayrılamaz**.

### 2 · `K-2.6.14` KAPSAM AÇIKLIĞI — `L2` düzenlemesi AÇILIR

`Z1` gereği donmuş belgeye kayıtsız düzenleme yasak; **bu kayıt o düzenlemeyi açar.**

**Yazılacak metin (ürün sahibi):**

> **`K-2.6.14` kapsam açıklığı:** *"içe aktarma"* bir **kanal adı değil, SINIF ADIDIR** —
> **defter-etkili gerçekleşme girişi**, kanalından (dosya · toplu API · tekil API · manuel
> form) **bağımsız olarak** bu kuralın konusudur. **Ayırt edici, girişin YOLU değil DEFTER
> ETKİSİDİR.**

📌 **Ve bu formülasyonun değeri: ayırt ediciyi ÖLÇÜLEBİLİR kılıyor.** Adlandırma ölçümü
zaten kanıtladı — `modes/` içinde deftere `DEBIT` yazan **yalnız iki servis**
(`agreement-transaction:238` · `on-invoice:499`), **ikisi de `{A,F}` ailesinde**.

⇒ Gelecekteki bir *"manuel yüzey"* tartışması bir **görüş tartışması olmaz**; **tek
grep'lik bir ÜYELİK TESTİ** olur.

### ⛔ VE BU BİR KURAL-HASTALIĞININ TEDAVİSİ — bu oturumda ÜÇÜNCÜ vaka

```
K-2.6.14              başlık "belge içe aktarma"   ↔  sınıf: DEFTER-ETKİLİ giriş
kpis/grid yorumu      "PLAN verisi döndürüyor"      ↔  sınıf: KATALOG okuma
approval-queue adı    "for current user" (OWN)      ↔  yüklem: SCOPE
```

> **Üçünde de AD, korunması gereken SINIFTAN DAR — ve DAR AD, sınıfın DIŞINDA KALAN ÜYEYİ
> MEŞRU GÖSTERİR.**

### 3 · Yan boşluk: `ADMIN`'in gerekçe-yükü asimetrisi

`L2_03`'te `YÖNETİCİ` **yalnız bir kez** geçiyor (`:405`), yani `ADMIN`'in **her kümede**
bulunuşu `K-2.6.4`'e **dayanmıyor**.

> **Bu bir kural EKSİĞİ değil, bir GEREKÇE-YÜKÜ ASİMETRİSİ:** `ADMIN`'in her kümede
> bulunuşu fiilen *"tanım gereği her şeye"* varsayımına yaslanıyor — **ve o varsayım,
> `UNRESTRICTED` terfisinde `FINANCE` için REDDETTİĞİMİZ KOŞULSUZLUĞUN TA KENDİSİ.**

**Tutarlılık `ADMIN` için de aynı işlemi ister** — `H8`'in gerekçe-yazım adımına **tek
satır**:

```
ADMIN'in kapsamsızlığı ve her-küme üyeliği K-2.6.4'te AÇIK CÜMLEYE bağlanır
  → "tanımlar ve kural yönetimi" cümlesi bunu TAŞIYOR MU, yoksa GENİŞLETİLMELİ Mİ?
  → ürün sahibi kararı
```

⚠️ **Küçük iş, ama yazılmazsa `ADMIN` sistemdeki SON "koşulsuz sabit" olarak kalır.**

### 4 · Kuyruğa — `E6` ailesi için envanter sorusu

> **`CLAUDE.md`'de DESEN anlatan başka kaç kural, MEVCUT BİR ARACI adlandırmadan
> anlatıyor?**

Tek okumalık envanter; **refleks-açığı sınıfını kökten kapatır**. Aciliyeti yok.

### `MODES_WRITE` bölünmesi TAMAM

```
{A,F}  gerçekleşme/alım yazımı    6 üye   (5 + n=1)
{A,P}  plan/anlaşma yazımı        12 üye
```

⇒ **`H1`'in son `DUR`'u KAPANDI. `B3b-1`'in gerçek tabanı artık OKUNABİLİR.**

> ### `F12` EKİ (2026-08-24, `B3b-1 ADIM 0`) — SAYININ STATÜSÜ DÜŞÜRÜLDÜ
>
> **Yukarıdaki `6` ve `12` o günün FOTOĞRAFIDIR; üye listesi ÜRETİCİDEN okunur:**
> `collmind.backend/scripts/analysis/route-cell-map.py`.
>
> Sayı **düzeltilmedi** — `{A,F}` bugün `8` ölçülüyor (sayılmayan ikisi
> `POST /agreement-transactions/batch` · `POST /actuals-first/sales-actuals/upload`,
> **ikisi de `@Roles=ADMIN,FINANCE`**, yani **bölünmenin YÖNÜ doğru**, yalnız
> enumerasyon elle yazılmış ve eksikti).
>
> ⛔ **Sonraki tur hücreyi `6`'ya MUTABIK KILMAYA KALKMAMALI.** Kanonik kaynak
> üreticidir; bu blok bir **karar kaydıdır**, bir üye listesi değil.
>
> **KODA İNİŞ:** bölünme `B3b-1 ADIM 0`'da indi —
> `MODES_ACTUALS_WRITE` (`modes:actuals-write`) · `MODES_PLAN_WRITE` (`modes:plan-write`).
> Ayrıntı ve kabul kriteri: `docs/process/B3B_RATCHET_TABANI.md §3`.
>
> 📌 *Türev-belge kuralının (`CLAUDE.md`) ilk rutin uygulaması.*


---

## Z36 · `SHARED_WRITE` ÜÇE BÖLÜNDÜ — ekseni SAHİPLİK, defter-etkisi DEĞİL

> **Tarih:** 2026-08-26 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Kapsam:** `SHARED_WRITE` (13 rota) + `MASTER_DATA_WRITE`'ın dört hesap-okuma rotası

### 1 · Bölünmeyi üreten eksen ÖLÇÜLDÜ — ve ilk hipotez ÇÜRÜDÜ

`Z35`'in ayırt edicisi **defter etkisiydi**. Bu hücrede **çalışmadı**: defter etkisi
grupların **içinden** geçiyor.

```
split{A,F} yazıyor          createEnvelope{A,F} yazmıyor
reserve{A,P} yazıyor        iki spend-calc{A,P} yazmıyor
```

⇒ Gerçek eksen: **yazılan nesnenin SAHİPLİĞİ.**

> ⚠️ Ve ürün sahibinin kaydı: *"aynı ayırt edici her hücrede geçerli olsaydı
> şüphelenirdim."* Bir ayırt edicinin **evrensel olmaması**, onun ölçülmüş olduğunun
> işaretidir — evrensel görünen ayırt edici genellikle **ölçülmemiş** olandır.

### 2 · Üç sınıf

| sınıf | ne | küme | rota |
|---|---|---|---|
| **A** | yönetişim / kural yazımı | `{ADMIN}` | `1` |
| **B** | zarf yapısı / bütçe sahipliği | `{ADMIN,FINANCE}` | `2` |
| **C** | plan tüketimi / ızgara yazımı | `{ADMIN,PLANNER}` | `2` |

**Adlar (Team Lead tahsisi, `Z35`'in `MODES_*_WRITE` emsali):**

```
SINIF A   SHARED_POLICY_WRITE     'shared:policy-write'
SINIF B   SHARED_ENVELOPE_WRITE   'shared:envelope-write'
SINIF C   SHARED_SPEND_WRITE      'shared:spend-write'
```

Adlar **sınıf-adıdır, küme-adı değil** — `{A,F}` bir kümedir, `envelope` bir sınıftır.
`shared:` öneki korunur ki hücre soyağacı okunabilir kalsın.

### 3 · `SINIF A` — dayanak DÜZELTİLDİ, SoD genellemesi ASKIDA

⚠️ **REVİZE EDİLDİ 2026-08-26 (`F12`; code-reviewer `B1`).** İlk yazımı şöyleydi ve
**iki kusuru vardı**:

> ~~`K-2.6.4a/b`: *"şablonun öznesi olan rol, şablonu düzenleyemez."* … `DISIPLIN.md`'ye
> **sınıf kuralı** olarak geçti.~~

**Kusur 1 — alıntı yok.** `düzenleyemez` `L2_03`'te **sıfır** eşleşme (poz.kontrol:
`onay` **109**). Gerçek metinler: `K-2.6.4a` *"rol … adres defteridir"*, `K-2.6.4b`
*"onaycı jenerik değildir, bütçenin sahibidir"*. Cümle **ürün sahibinin kendi
ifadesiydi**; onu bir kural **alıntısına** çeviren Team Lead'di.

**Kusur 2 — `K-2.6.5c` ile gerilim.** *"Görev ayrılığı **rol** bazlı değil, **kişi**
bazlı işler."* `L2`'deki üç SoD kuralı da kişi+işlem eksenli.

**YÜRÜRLÜKTEKİ DAYANAK** — pozitif ve birebir: `K-2.6.4` rol kataloğu,
`YÖNETİCİ | Tanımlar, kural yönetimi` (`L2_03:405`).

> ⚠️ Ve `L2_03:465`'in şerhi okundu: *"`K-2.6.4`'ün cümlesinden **kapsamsızlık**
> türetilemez — olsa olsa ima edilir."* O şerh **kapsamsızlık** içindir; burada
> türetilen şey kapsamsızlık değil, **bir yazma yetkisinin sahibi**.

**DAVRANIŞ ETKİLENMEDİ:** `SHARED_POLICY_WRITE = {ADMIN}`, göç öncesi `@Roles(ADMIN)`'in
**birebir** hâli. Askıda olan **gerekçe**, küme değil.

### ⛔ HÜKÜM (ürün sahibi, 2026-08-26) — ne tamamlama ne revizyon: **KATMAN KARIŞIKLIĞI**

Askıdaki madde **İPTAL** edildi. `K-2.6.5c` **doğru ve dokunulmaz**.

```
ROL katmanı   "bu TÜRE kim dokunabilir"         → küme cebiri
SoD katmanı   "bu İŞLEMDE bu KİŞİ olabilir mi"  → kimlik karşılaştırması
```

*"Kim gönderdiyse onaylayamaz"* bir **kimlik karşılaştırmasıdır**, küme cebiri değil.
Rol-katmanı formülasyonu, `T-276`'da çözülen katman ayrımının (**hücre = tür ·
yüklem = kademe**) SoD'a **uygulanmamış** hâliydi — ikisini aynı katmana yazmak,
**yüklemi hücreye gömmekle** aynı hata.

> **YÜRÜRLÜKTEKİ KURAL: SoD rol katmanına taşınmaz. Kural-yazma yetkisi bir
> YÖNETİŞİM sorusudur, SoD sorusu değil.**

⚠️ Ve kural **zaten gereksizdi**: `{ADMIN}` `K-2.6.4`'ün *"tanımlar ve kural
yönetimi"* cümlesinden **türer**; görev-ayrılığı argümanı **hiç gerekmez**.

### `ADMIN` *"hem özne hem yazar"* — İHLAL DEĞİL, ama gerçek bir BOŞLUK ADAYI

Rol katmanında `ADMIN`'in iki kümede oluşu **yönetişim cümlesiyle meşru** —
kişi-bazlı SoD **rol üyeliğiyle ihlal edilmez**.

⛔ **Gerçek soru KİŞİ katmanında ve bugün KAYITSIZ:**

> *"Bir kişi şablonu değiştirip sonra o şablon altında onay verebilir mi?"*

`L2`'nin üç SoD kuralı **gönder/onayla** eksenini kapsıyor; **değiştir/onayla**
eksenini **kapsamıyor**.

Bugün karar üretmez (deploy yok, şablon motoru yok) — ama **`Faz 2` onay-motoru
tasarımının girdi listesine** kayıtla girer:

```
1  şablon-değişikliği ↔ o şablon altındaki onay arasında
   KİŞİ-BAZLI kısıt gerekir mi?
2  şablon değişikliği bir DENETİM OLAYI mıdır?   (EK_C sözlük adayı)
```

### 4 · `SINIF B` = `{A,F}` — ve çatışma, çatışma DEĞİLDİ

`K-2.2.9c` ile `K-2.6.4` **çelişmiyor, iş bölümü tarif ediyor**:

```
K-2.2.9c   "finans zarfı büyütür … kararı paranın sahibine taşır"
           ⇒ YAZAN Finans · ONAYLAYAN sahip (CM)
K-2.6.4    CM'nin "zarf yönetimi" cümlesi ONAY + İZLEME tarafında
           zaten karşılanmış (MODES_APPROVE_CATEGORY + zarf görünürlüğü)
```

⇒ **Fiziksel yazım, cümlenin zorunlu sonucu değildir.** `{A,F}` yalnız bugünkü
fail-open zorunluluğu (`AccessScope=0`) değil, **kuralların tutarlı okumasıdır**.

**CM-girişi kapısı açık — ama ÇİFT KOŞULLA** (`Z25` satırı):
`T-266` (kapsam sağlayıcısı) **∧** ürün kararı (`K-2.2.9c` okumasının **revizyonu**).
Sessiz genişleme yasak.

### 5 · Hesap-okuma yedilisi — çıkarma KESİN, varış KÜME-BİREBİRLİĞE bağlı

`W4b` ölçümü: yedi rotanın yazma yüzeyi **`0`**, cascade **yapısal olarak imkânsız**.

| grup | hüküm |
|---|---|
| üç `SHARED` rotası (`context/rates` · `calculate/base-spend` · `calculate/planned-spend`) | → `SHARED_READ` (`5/5→5/5` **birebir**, göçebilir). `W4a` yan-bulgusunun kaydettiği tutarsızlık **kapanır** |
| dört `MASTER_DATA` rotası | WRITE'tan **çıkarma kesin**; varış **küme-birebirliğe** bağlı → aşağı bkz. |

⚠️ **DÜZELTME 2026-08-26 (`F12`; code-reviewer `S7`) — dörtlü TEK PARÇA DEĞİL.**
İlk yazımı *"bu dörtlünün `{A}`-only'si"* diyordu; **ölçüm ikiye ayırdı**:

```
mechanics/applicable          5/5  ┐
mechanics/check-combination   5/5  ┘ MASTER_DATA_READ kümesi de 5/5 → BİREBİR
mechanics/validate-formula    {A}  ┐
kpis/validate-formula         {A}  ┘ birebir DEĞİL → karar-bekler
```

⇒ `Z36`'nın **kendi ölçütü** uygulandığında dörtlünün **yarısı mekanik göçebilir**;
yanlış niteleme `W7`/`W8`'in kapsamını **gereksiz daraltıyordu**.

✅ **KABUL (ürün sahibi, 2026-08-26):** `applicable` + `check-combination` `W7`/`W8`'de
**mekanik göçe açık**. `Z36`'nın formülü (*"çıkarma kesin, varış küme-birebirliğe
bağlı"*) burada **kendi kendini uyguladı**.

⇒ **Karar-bekler kalıntısı İKİYE indi:** `validate-formula` çifti · `plans/:id/budget-check`
(`Z33`).

📌 Ve kalan ikisi için `Z36`'nın açık bıraktığı ihtimal hâlâ geçerli: formül-doğrulama
*"kural-yönetiminin okuma aynası"* ise evi `SINIF A` komşuluğudur, katalog-READ değil.

⛔ **Ayrı `CALC_READ` hücresi AÇILMAZ.** Yedi rota **iki ailede**; tek hücre **aile
eksenini düzleştirir**. Üyelik **yazma-yüzeyi ölçümüyle**, ev **ailesinin okuma tarafı**.

📌 Ve formül-doğrulamanın *"kural-yönetiminin okuma aynası"* olma ihtimali açık — o
zaman evi `SINIF A` komşuluğudur, katalog-READ değil.

### 6 · `K-2.6.6` DÜZELTMESİ — fail-closed bir VERİ-SINIFI kuralı değildir

Bu turda `K-2.6.6` *"kural yoksa reddet"* diye ölçüldü: bir **fail-closed ilkesi**.
Hesap-okuma sınıfını gerekçelendirmek için kullanılamaz.

> ⚠️ Ürün sahibinin kendi kaydı: *"'etiketle değil ölçümle' şartının kendi üstümdeki
> uygulaması — çünkü o etiketi ilk ben önermiştim."* Bir şartı **koyan tarafın kendi
> önerisini o şartla elemesi**, şartın işlediğinin kanıtıdır.

### 7 · Göç tablosu

```
MEKANİK GÖÇEBİLİR (8)   A(1) + B(2) + C(2) + calculate-üçlüsü(3)   hepsi küme-birebir
KAZA/İSTİSNA DALGASI    LTA dörtlüsü · T-289 kaldırması
KARAR-BEKLER KALINTISI  MASTER_DATA dörtlüsü · plans/:id/budget-check (Z33)
```


---

## Z37 · `LTA` hizalaması GERİ ÇEKİLDİ · `K4` üçe ayrıldı · kaza-dalgası ONAYLI

> **Tarih:** 2026-08-26 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### 1 · `LTA` — önceki hüküm AÇIKÇA GERİ ÇEKİLDİ

`Z36` turunda hüküm *"kardeş emsale hizalanır (`{A,P}`), kaza-dalgasında, frontend
ölçümü şartıyla"*ydı. **Ölçüm şartı karşılandı ve hükmü ÇÜRÜTTÜ.**

```
şartın iki dalı        "UI form sunuyorsa … sunmuyorsa …"
ölçümün verdiği        ÜÇÜNCÜ DURUM — form VAR, PLANNER'a AÇIK,
                       ama POST /agreements'e gidiyor
lta-agreements atfı    SIFIR (poz.kontrol: aynı grep spend-calculation'ı buluyor)
```

⇒ *"Kardeş emsal"* bir emsal değil, **LTA'nın canlı yazma yolu** çıktı. Hizalama artık
*"API'yi ekrana yetiştirmek"* değil, **tüketicisiz bir paralel yolu genişletmek**
olurdu — `Z21`-musluğu deseninin **rol hâli**.

> **Ürün sahibinin kaydı:** *"`(a)` benim hükmümdü ama **dayanağı öldü**."*
>
> 📌 Ve geri-alma-maliyeti argümanı kabul edildi: **genişleme tek yönlü kapıdır,
> askı değil.**

**HÜKÜM: `(b)`** — hizalama askıya alınır, önce **meşruiyet ölçümü**.

### 2 · Ve soru ROTADAN BÜYÜK: bu bir **ÇİFT-MODEL** sorusudur

```
agreements(agreementType:LTA)   ↔   lta_agreements + lta_rates
                                     ve W4a/Z36'nın OKUMA rotaları İKİNCİ tabloyu okuyor
```

Yazma yolu sıfır tüketiciliyse **o tablo neyle doluyor?** Cevap *"seed-only"* ise
**`İlke 3` ihlali adayı** (*"verisi düzenlenemeyen kural fiilen koddur"*) ve
`budget_allocations` deseninin **büyüğü**: **yarı-ölü paralel model**.

⇒ Ölçüm turu *"hangi model KANONİK"* sorusunu cevaplar (`K-2.2.3` ailesi: **aynı
kavram, iki çözümleme**). Üç kapı: **kaldırma** · **hizalama+kanonikleştirme** ·
**bilinçli çift-model** (⚠️ çok güçlü gerekçe ister).

### 3 · `K4` — dört istisna ÜÇ PARÇA

| istisna | hüküm |
|---|---|
| `approvals` · `approvals/pending` | **`APPROVAL_QUEUE_READ`** (`'approval-queue:read'`, ad Team Lead tahsisi — **sınıf-adı**). `{A,CM,F,RO}` **birebir**; `PLANNER`'sızlık artık **cümleli**: onaycı yüzeyi |
| `validate-budget/:planId` | ⏸️ **DUR — hüküm ASKIYA ALINDI**, aşağı bkz. ~~taban + `FINANCE`, kayıtlı istisna; eksiklik bir **kaza** (kardeşlerin tamamı `5/5`)~~ |
| `budget-variance` | **`SUMMARY_READ` paketine DEVİR** — `finance-reporting` ailesinin taraması açıkken tek üyeyi ayrı çözmek **yarım muamele** (`İlke 4`) |

### ⏸️ `Z37 §3` REVİZYONU — `validate-budget` hükmü ASKIYA ALINDI (`F12`, 2026-08-26)

**`K4`'ün `DUR` şartı ateşledi ve DOĞRU ateşledi.** Hüküm *"eksiklik bir **kaza**"*
diyordu; `K4` brief'i buna bir kapı koymuştu: *"kayıt çıkarsa **DUR** — kayıtlı bir
fark bir kaza değildir."* **Kayıt çıktı.**

```
git log -L 88,93:spend-calculation.controller.ts   →   d0b8f16  (T-249)
kayıtlı gerekçe:
  "validate-budget/:planId → ADMIN, PLANNER, CM, READONLY (FINANCE YOK)
   (plan.controller'ın kendi :id/budget-check'i, o da FINANCE'ı dışarıda bırakıyor)"
```

⇒ Dışlama **bilinçli, gerekçeli ve emsalli** bir karardı.

#### ⛔ AMA BU BİR ÇÜRÜTME DEĞİL — İKİ ÖNCÜL DE DOĞRU

Team Lead her iki tarafı da ölçtü:

| emsal tanımı | kim seçti | ölçüm |
|---|---|---|
| **modül-kardeşliği** — `spend-calculation`'ın beş `GET`'i | `Z37 §3` | hepsi `5/5` ✅ **doğru** |
| **işlev-kardeşliği** — `plans/:id/budget-check` | `T-249` | `{A,CM,P,RO}` ✅ **bugün de öyle** |

> **İkisi de meşru bir *"kardeş"* tanımıdır.** `T-249` **işlev**-kardeşliğini seçti,
> `Z37 §3` **modül**-kardeşliğini. Hangisinin geçerli olduğu bir **ÜRÜN KARARIDIR**.

⛔ **VE BİR İNCELİK:** `T-249`'un yaslandığı emsal (`plans/:id/budget-check`) **kendisi
karar-bekler** — `Z33`, ve `SUMMARY`/`MODES_READ` paketinin **`5` numaralı kalemi**.
Yani `T-249` **çözülmemiş bir emsale** yaslanmış.

⇒ **Ürün sahibine giden soru:** `validate-budget` hangi kardeşliğe tabi? Cevap
`budget-check`'e bağlıysa **ikisi tek pakette** çözülür — paket zaten ikisini de
taşıyor (`2` = `MODES_READ`, `5` = `budget-check`).

📌 **Bu, `git log -L` kuralının ilk HÜKÜM-DEVİREN vakası.** `-S` ile taransaydı o
commit **görünmezdi**: rota dizgesi ne doğdu ne öldü, yalnız `@Roles` satırı değişti.

### 4 · Dalga sözleşmesine üç güçlendirme

1. **`K6(b)`'nin sonucu sıfırsa da RAPORA YAZILIR** — *"satır yok"* bir **ölçümdür**.
2. **Pinler yön-açık**: `Z20` = `FINANCE→403` (daraltma) · ledger-üçlüsü =
   `PLANNER→200` (genişleme). **İki zıt yönlü istisna aynı dalgada, pinler karışmasın.**
3. **Sabitlik kırılması**: `K6` ucu sildiğinde yeni sabit **gerekçe satırıyla doğar**.
   `211`'in tarihçesi zaten **üç kez** işledi (`238 → 223 → 211`).

### 5 · Ve `K5` DALGADAN ÇIKTI

> **Bir dalganın kapanışı, ürün-sahibi-bekleyen bir kalemle REHİN kalmaz.**

Kaza-dalgası **beş kalemle** kapanır; LTA ölçüm turu **ayrı** akar.


---

## Z38 · `T-289` gerekçesi DÜŞÜRÜLDÜ · `T-293`'ün SORUSU yeniden kuruldu

> **Tarih:** 2026-08-26 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### 0 · Ürün sahibinin kendi payı — ve bir HÜKÜM PRATİĞİ kuralı

> *"`T-289` hükmüm **doğru sonuca yanlış bir öncülle** varmıştı. İddiayı `ÖLÇÜLDÜ`
> sanıyordum, cinsi `VARSAYIM`mış."*

⇒ **Yeni kural — hüküm pratiğine:** *"Kusur-iddialı bir kararın gerekçesinde **iddianın
CİNSİ** açıkça yazılır."* Bu vaka `F12` iziyle **emsal**.

📌 `DISIPLIN`'in *"durağan yüzeyler bir hipotez oluşturur"* maddesinin **karar
tarafındaki** hâli: kural yalnız ölçeni değil, **ölçüme dayanarak hüküm vereni** de
bağlar.

### 1 · `T-289` — KALDIRMA DEVAM, gerekçe DÜŞÜRÜLDÜ

Sonuç ayakta çünkü **taşıyıcı argüman hiç tehdit-modeli değildi**:

```
ÜÇ BAĞIMSIZ KALDIRMA SEBEBİ
  1  K-2.2.4'ün savunması — onay tetikleyicisini ATLAYAN ikinci yol   (yapısal)
  2  paralel yol — kanonik motor CANLI (davranışsal olarak ölçüldü)   (yapısal)
  3  uç KIRIK ve ÖLÜ — her çağrıda 500                               (YENİ, davranışsal)
```

**İkisi de GÜÇLENDİ**, üçüncüsü **eklendi**.

**Üç güncelleme:**

| # | ne |
|---|---|
| **i** | **Tehdit cümlesi DÜŞÜRÜLDÜ**: *"denetimsiz musluk"* → *"yapısal olarak tamamlanamayan **ölü paralel yol**"*. Eski iddia **silinmez** — `VARSAYIM`-düşürme iziyle kalır |
| **ii** | **`K6(a)`'nın pini ŞEKİL DEĞİŞTİRİR**: reprodüklenen şey artık kusur-iddiası değil **KIRIKLIK**. *"Uç `500` veriyor"* ölçümü **pin olur** — ve o da bir *kusur-önce-görüldü* kaydıdır: **kullanıcıya `500` gösteren canlı dialog** |
| **iii** | Kaldırma zinciri **aynen**: `(c)` iki-repo-tek-kapanış (dialog `PLANNER`'a bugün `500` gösteriyor ⇒ kaldırma bir **UX düzeltmesi de**) + `(d)` tek-yol pini |

### 2 · İdempotency zaafı — genelleme

> **Köken imzası taşımayan bir idempotency anahtarı, PROVENANCE sorusunu cevapsız
> bırakır.**

`K6(b)`'de ölçüldü: `reserveBudget`'ın anahtarı **seed'inkiyle birebir aynı** şekilde.
Ayrım `amount`+`description` eşleşmesinden geldi, **anahtardan değil**.

⇒ Kanonik motorun anahtarına **köken segmenti** eklenmesi — küçük bir **`Faz 2`** kalemi.

### 3 · `T-293` — İKİ SEÇENEK DE REDDEDİLDİ: soru YANLIŞ KURULMUŞTU

Sunulan seçenekler *"devir"* ve *"otomatik besleme"*ydi. **İkisi de reddedilir.**

> **Doğru cevap devir değil: BAĞ + EKSİK YÜZEY.**

**Ölçümün kendisi söylüyor** — iki tablo aynı şeyin iki kopyası değil, **iki farklı
katmanın temsili**:

```
agreements              ticari YAŞAM DÖNGÜSÜ    onay · audit · SoD · defter bağı
lta_agreements+lta_rates ORAN ŞARTLARI          kanal×kategori kademe
                                                (agreements'ın temsil EDEMEDİĞİ yapı)
```

| seçenek | neden kapalı |
|---|---|
| **1 · devir** | onay/audit akışını **koparır** — kayıtlı karar ailesinin **ihlali** |
| **2 · otomatik besleme** | **YARIM**: başlık satırını üretir, **oranları üretemez**. Oran verisinin hâlâ **hiçbir giriş yüzeyi yok** |

⛔ **Ve asıl kök neden bu:** **eksik birleşme + EKSİK YÖNETİM YÜZEYİ** —
**mekanik-alanları sınıfının LTA hâli** (`EK_E` ailesi, `🔒` işareti: *"yetenek var,
arayüzü yok"*).

#### HÜKÜM — üç parça

**(a) Mimari çerçeve kayda:**
```
agreements    = YAŞAM DÖNGÜSÜNÜN kanonik yeri
lta_rates     = ORAN ŞARTLARININ kanonik yeri
bağ           AÇIK — agreements-LTA kaydı EBEVEYN, oran kademesi ona BAĞLI doğar
oran girişi   KENDİ YÜZEYİNİ alır
```

**(b) İnşası `Faz 2` GİRİŞ KOŞULUDUR, bugünün kod işi değil.** Motor `Faz 2`'nin
motoru, deploy yok, **ölü KPI bugün kimseyi yanıltmıyor**. `T-293` → `Faz-2` giriş
listesi + **`EK_E` şema-uyum turu** (oran yüzeyi satırı).

**(c) TEK BUGÜNLÜK İŞ — `FEATURE_COMPLETION`'a DÜRÜSTLÜK SATIRI:**

> *"LTA indirim hesabı uçtan uca **ÇALIŞMIYOR** (`T-293`): form kaydediyor, motor
> görmüyor."*

⛔ **Yoksa checklist YALAN SÖYLER.**

### 4 · `Z37` askısı → `T-293`'e bağlandı

LTA dörtlüsünün kaderi **meşruiyet sorusundan çıkıp TASARIM sorusuna döndü**. `T-293`
çerçevesi kurulduğunda o dört uç:

```
ya bağ-mekanizmasının PARÇASI olur
ya oran-yönetim yüzeyinin API'si olur
ya ÖLÜR
```

**Üçü de `T-293` kararının türevi.**

**`Z25` koşul satırı:**
```
sağlayıcı     T-293 mimari kararı (Faz-2 planlama)
tetikleyici   Faz-2 giriş koşulları derlemesi
```

> 📌 **Ve geri çekiliş iyi ki yapıldı:** `(a)` inseydi, **ölü bir yolu genişletmekle
> kalmayıp `T-293`'ün TASARIM UZAYINI da daraltmış** olacaktık.

### 5 · Dalga kapandığında elde kalan tablo

```
karar-bekler = SUMMARY_READ ailesi (+ devredilen budget-variance)
             + MODES_READ
             + validate-formula çifti
             + plans/:id/budget-check
```

**Hepsi TEK ölçüm-kök ailede** (küme-gerekçe taraması) ve `W5`–`W8` ile **paralel**
çözülebilir.


---

## Z39 · `T-302` — SIFIR-ROTA HÜCRELERİ **ÖLÜ** · `H3`'e TETİKLEYİCİ doğdu

> **Tarih:** 2026-08-26 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Hüküm:** *"`ÖLÜ` — `H3` emsaliyle; **rezerv katman** önerisi REDDEDİLİR,
> çünkü **rezervasyonun evi harita değil, KARAR DEFTERİDİR**."*

### 1 · Bu karar ZATEN VERİLMİŞTİ — `H3`

`H3` (`B3b-0`) tam bu sınıftan **beş hücre sildi**, ve silinenlerden biri
`MODES_MANAGE`'di — gerekçesi bugünkü vakanın **birebir tarifi**:

> ⛔ *"yol olmadan verilmiş yetki YAŞAYAMAZ"* · *"ileride bir `MANAGE` rotası
> doğarsa hücre **KARARLA GERİ GELİR**"*

Ve `H3` bir **genel kural** doğurmuştu: *"Arkasında rota olmayan bir hücre haritada
DURMAZ."*

### 2 · ⛔ AMA KURALIN TETİKLEYİCİSİ YOKTU — `CUSTOMER_MANAGE` TAM O YÜZDEN YAŞADI

```
H3'ün taraması    "boş" tanımını B3a ATAMALARINDAN okudu     → CUSTOMER_MANAGE kaçtı
bugünkü ölçüm     @RequireCapability sayımı, yorumsuz         → daha KESKİN
```

> **Bir kural, tetikleyicisi olmadan bir TEMENNİDİR.** `H3` doğruydu ve **uygulanmadı**,
> çünkü *"ne zaman bakılacağı"* yazılı değildi.

### 3 · *"Rezerv katman"* neden REDDEDİLDİ — çürüğü RAPORUN KENDİSİNDE

Team Lead riski ölçmüştü: *"bir gün rota bağlanırsa **sınanmamış union'ı miras
alır**."*

⇒ **Rezerv katman o riski KURUMSALLAŞTIRIR.** Haritada duran her *boş-ama-role-verili*
satır, **hiçbir davranışla sınanmamış bir yetki vaadidir** — ve `G2b`'nin **bayat-üye**
ailesinin doğum yeri.

⚠️ **Ve `USER_MANAGE` *"ailenin niyetini"* göstermez** (Team Lead önerisinin dayanağı
buydu) — **kararlı bir İSTİSNAYI** gösterir:
```
Z20 yazılı kural  +  üretici dalı (route-cell-map:234)  +  ROTASI
⇒ H3-uyumlu TAM biçim
```

📌 **Niyetin adresi karar defteridir:** `H3`'ün *"kararla geri gelir"* cümlesi
**rezervasyon mekanizmasının ta kendisi** — bedava, sınanmamış-union'sız, ve **zaten
üç kez çalıştı**: `MODES_SUBMIT` · `SUMMARY_READ` · `APPROVAL_QUEUE_READ` (hücre doğumu
**hep kararla** oldu).

### 4 · Uygulama — üç parça

| # | ne |
|---|---|
| **1** | `W5` **hemen akar**: yedi rota → `CUSTOMER_WRITE` (`{A,P}` **birebir**, davranış korunur); `CUSTOMER_MANAGE` **düşer** (`F12` izli, sıfır-rota kanıtıyla) |
| **2** | *"Dalgası yok"* üçlüsü **aynı commit'te** düşer: `TENANT_MANAGE` · `SHARED_MANAGE` · `SHARED_WRITE` — sonuncusunun **kilit metni hücreden `T-293`'e TAŞINIR** |
| **3** | **Genel kural — `dalga-sonu H3`** (aşağı) |

> ⚠️ **`SHARED_WRITE` düşünce *"göçecek yer kalmadı"* sorunu YOK:** LTA dörtlüsü
> `T-293` çözülmeden **zaten göçmeyecekti** — doğru hücre, **kararla ve cümlesiyle**
> o gün doğar.

### 5 · ⛔ `DALGA-SONU H3` — `H3`'ün ARADIĞI TETİKLEYİCİ

> **Her dalga kapanışında, o modülün SIFIR-ROTA kalan hücreleri AYNI KAPANIŞ
> COMMIT'İNDE düşer.**

```
dalga BEKLEYEN hücre     kusur DEĞİL — dalgası gelmemiş
dalga SONRASI boş hücre  ⛔ YAŞAYAMAZ
```

⇒ Böylece **sessiz-genişleme sınıfı YAPISAL OLARAK ölür**: hiçbir hücre dalgasından
sonra *boş-ve-role-verili* kalamaz.

⚠️ **Ve zamanlama şart:** düşüş **dalganın kapanışında**, öncesinde **değil** —
*dalga ortasında harita oynamaz*.

📌 **Üretici tarafı zaten hizalı:** `route-cell-map` bu hücreleri **üretemiyor** ⇒
düşüş, **harita ↔ üretici birebirliğini ARTIRIR**. `G5`/`G6` delta-kontrolü kapanış
commit'inin **pini** olur.


---

## Z40 · DAĞITIM PAKETİ — altı karar, tek kayıt

> **Tarih:** 2026-08-26 · **Karar:** ürün sahibi + Fable · **Statü:** yürürlükte
> **Numara/ad tahsisi:** Team Lead.

### 1 · `L0` KATMANI DOĞDU — [`docs/HEDEFLER.md`](../HEDEFLER.md)

Beş `G`: **çekirdek döngü · rakam güveni · çok-müşterili yaşam · karar hızı ·
kanıtlanabilirlik**.

```
01_KONUMLANMA   NE
HEDEFLER.md     NE İÇİN     ← yeni
```

**Faz süzgeci (birebir):**
> *"Çekirdek döngünün bir adımını açıyor ya da kilitlenme/veri-bozulması önlüyor →
> **şimdiki faz**. Yalnız *'bir gün lazım'* → **kanıt gelene kadar ADAY**."*

⛔ **Koruma cümlesi:** ***"Şimdiki faza iş EKLEMEK de süzgeçten geçer."***
📌 Bu cümle olmadan süzgeç **tek yönlü** çalışırdı. Ölçülmüş vaka: kaza-dalgasının
kapsamı *"dalga temiz kapansın"* gerekçesiyle **üç kez** genişledi.

⚠️ **Gövde metinleri Team Lead türetimidir ve öyle işaretlidir** — kanonik metin ürün
sahibinde (`DISIPLIN`: *"atıf vermek, metnini uydurmak değildir"*).

### 2 · YERLEŞİM — `ADIM3_FAZB_PLAN`'a ADAY eki

| kalem | yerleşim |
|---|---|
| çok-rol | **`Faz 3+`** — çekirdek döngüde adım açmıyor, hiçbir akış kilitlenmiyor |
| `EK_E` dağılımı | **kalem kalem süzgeçten** — her `🔒` bir **kablolama**, ve kablolama çoğu zaman adım **açar** |
| `RLS` | **tasarım `Faz 1`** (veri-bozulması, `G3`) · **aktivasyon DEPLOY** (`Z25`: sağlayıcısı yok ⇒ **kilit**) |

⛔ **VE BİR ÖLÇÜM DÜZELTMESİ (Team Lead):** kalem *"şemadaki çok-rol `n:m`"* diye
tarif edilmişti. **`n:m` şemada YOK:**
```
EK_C:389        "birden çok rol … birleşimidir"
users.role      TEK enum · n:m bağ tablosu SIFIR · ManyToMany YOK
```
⇒ Sapma şemanın içinde değil, **`EK_C`'nin cümlesi ile kod arasında** — ve `EK_C`
**donmuş** (`Z1`), yani düzeltmesi bir **karar** ister.

### 3 · KAPSAM EŞİĞİ + TRİYAJ SÜTUNU

```
kabul edilen eşik   SUMMARY ∧ A1 = 0  +  Z32 kapısı
kalan 37            TRİYAJ ZORUNLU — iki durum, üçüncüsü YOK
  MEŞRU   kapsam gerekmiyor VE cümlesi var (Z18 biçiminde)
  BORÇ    kapsam gerekiyor, yok — ve ADRESLİ olmalı
```

**`BORÇ`'un iki bağı:** ilk-deploy **sert eşiği** · `A1` ratchet **artış yasağı**
(*BORÇ listesi büyüyemez*).

⛔ **Paket bu sütun doldurulmadan karara GELMEZ.**

### 4 · `B4` KABUL KRİTERİ — `KİLİTLİ-TENANT PİNİ`

> **`default-deny` altında admin UÇTAN UCA:** kullanıcı yarat → rol ata → **kapsam
> ata** — **CANLI**, mock değil.

`default-deny`'ın klasik kilitlenmesi: *kapı kapanır, admin de kapıda kalır, açacak
kimse kalmaz.* Bu bir **kilitlenme** sınıfı ⇒ süzgeçte **şimdiki faz**.

⛔ Üç adım **ayrı ayrı** yeşil olması **yetmez** — zincir **kesintisiz** olmalı
(`§2.7 #6`). Ve **mock yasak**: `T-301`'de ölçüldü ki bir MSW handler'ı `T-289`'un
**canlı kırıklığını** testlerden **tamamen gizlemişti**.
⇒ **Bir kilitlenme pini mock'la yazılırsa, kilidi mock açar — ürün değil.**

### 5 · `B4`-ÖNCESİ SAVUNMA TURU → [[T-303]]

`EK_E`'nin iki kalemi, **üç durumlu** çıktı (`KIRIYOR` / `KIRMIYOR` / `ÖLÇÜLEMEDİ`).
*"Kırmıyor"* çıkarsa çok-rol kalıntısına **`BİLİNÇLİ-UYUYAN`** kaydı:
> **Davranışa bağlanması YASAK. Bağlanacaksa KARARIYLA.**

📌 `Z39`'un *"rezervasyonun evi karar defteridir"* hükmünün **şema tarafındaki**
kardeşi: uyuyan bir yetenek **kendiliğinden uyanamaz**.

### 6 · `FAZ 2` — SENARYO ZİNCİRİ, ve İSKELET TURU **AÇILMAZ**

```
KALEM  →  SENARYO  →  E2E ZİNCİR-TESTİ
```
`SENARYO-ADAY` kanalı açıldı. **İlk tohum:** *"planlamacı `FU` girer → istediği
`FU`'yu `SKU`'ya kırar → `Σ(SKU) = FU` sistem tarafından korunur."*

⛔ **İskelet turu AÇILMAZ** — gerekçe **ölçülmüş** (`T-293`):
> **Entegrasyon-körlüğünün evi BELGE değil, ZİNCİR-TESTİDİR.**

LTA formu kaydediyor, motor **onu asla görmüyor** — iki uç ayrı ayrı **yeşil**,
arada **bağ yok**. Bir belge turu bunu **bulamazdı**.
⇒ İskelet turu **kalem sayısını** artırır, **bağ sayısını** artırmaz. `Faz 2` **bağ**
eksikliğinden kırılıyor.


---

## Z41 · `B3b-1` KAPANDI — dokuz dalga, `149` göç, **SIFIR davranış sızıntısı**

> **Tarih:** 2026-08-26 · **Statü:** ✅ **DÖNEM KAPANDI**
> Tam bilanço: `docs/process/B3B1_KAPANIS_BILANCOSU.md`

```
dokuz dalga  ·  149 rota göçü  ·  BEKLENMEYEN pin kırmızısı: SIFIR
```

⇒ **Dokuz dalga boyunca tek bir davranış sızıntısı yok.**

> **Ürün sahibinin kaydı:** *"İki hafta önce *'en riskli iş'* diye planladığımız şey,
> **kurduğu disiplinin içinde rutinleşerek** bitti."*

### ⛔ VE KAPANIŞIN KALİTESİ SAYIDA DEĞİL, STATÜDE

```
başlangıç   @Roles 211  ·  hiçbiri gerekçeli değil     BİLİNMEYEN BORÇ
bugün       @Roles  61  ·  HEPSİ gerekçeli             ADRESLİ KARAR LİSTESİ
```

> **Sayı düşüşünden kıymetlisi STATÜ DEĞİŞİMİ.**

Ve kapanış grameri:
> ⛔ *"Bitti"* **değil** — ***"bitti, VE kalan şunlardır, ŞURADADIR."***
> Bu, bu reponun artık **varsayılan kapanış grameridir.**

### Kalan `61`'in tamamı adresli

| hücre | rota | adres |
|---|---|---|
| `MODES_READ` | 34 | paket `#2` |
| `SUMMARY_READ` | 12 | paket `#1` |
| `MODES_APPROVE` | 6 | karar-bekler |
| `SHARED_WRITE` | 4 | `T-293` (`Z39 §4` kayıtlı hayalet) |
| `SHARED_READ` | 2 | paket `#7`/`#8` |
| `MASTER_DATA_WRITE` | 2 | paket `#4` (`Z36 §5`) |
| `USER_MANAGE` | 1 | `T-297` — hüküm **verildi**, uygulama bekliyor |

---

# `Z42` — KARAR-BEKLER PAKETİ ÇÖZÜLDÜ: bir çerçeve, üç blok, iki emsal

**Tarih:** 2026-08-26 · **Karar:** ürün sahibi · **Kayıt:** Team Lead
**Girdi:** `B3_KARAR_BEKLER_PAKETI.md` (arşiv) + karar oturumunda **yeniden ölçülen** sayılar

> ⛔ **Hükümler paketin METNİNE değil, ÖLÇÜLEN SAYILARA verildi.** Paketin iki
> satırı bayattı (`{A,F}`=**5**, 7 değil) ve `capabilities.ts`'in `SUMMARY`
> türetim listesi üreticiyle çelişiyordu (**12**, 13 değil). Bkz. `§0`.

---

## `§0` — `ADIM 0`: beş sapma, oturumdan ÖNCE düzeltildi

Beşinci tarama satırı (`DISIPLIN`: *"KARAR-GİRDİSİ YÜZEYLERİ, KARARINDAN ÖNCE
TARANIR"*) **ilk uygulamasında** dört sapma yakaladı; ölçüm turu bir beşincisini
ekledi. Kanonik yüzeyler (TSV · üretici · `G1–G8`) **tazeydi**; bayatlık
**anlatı** katmanındaydı.

| # | yüzey | sapma |
|---|---|---|
| **1** | `capabilities.ts` `SHARED_POLICY_WRITE` bloğu | **İPTAL EDİLMİŞ** bir kuralı bağlayıcı diye alıntılıyordu |
| 2 | `B3_KARAR_BEKLER_PAKETI §3` | `ledger/envelope/*` çifti bayat ⇒ *"`{A,F}` yedilisi"* bugün **beş** |
| 3 | `capabilities.ts` `SUMMARY` türetim listesi | **13** sayıyordu, kanonik üretici **12** (`budget-variance` çelişkisi) |
| 4 | `capabilities.ts` `SHARED_READ` `DUR` bloğu | aynı blokta *"İKİ istisna"* **ve** *"DÖRT İSTİSNA"* |
| 5 | `BACKLOG.md` | `T-266` elle yazılmış sayım · `T-287` statüsü |

> **Ürün sahibinin hükmü:** *"`#1` öncelikli: benim iptal-edilmiş alıntımın
> kalıntısı, karar oturumunun okuyacağı dosyada iptal edilmiş kuralı **bağlayıcı
> gösteriyor** — `Z31 H4-5` ailesi, **tek dosyada iki zıt cümle**."*

📌 Ve `#1` bu oturumun kendi ihlalinin kalıntısıydı: uydurma alıntı **iptal
edildi**, `DISIPLIN`'e vaka yazıldı, `ROLE_CAPABILITIES` tarafı düzeltildi —
**ama aynı dosyanın hücre-yorumu düzeltilmedi.** *(`DISIPLIN`: "bir kuralı
yazdığın tur, o kuralı en çok ihlal ettiğin turdur" — ve bu kez ihlal
**temizliğin eksik yarısıydı**.)*

---

## `§1` — ⛔ EMSAL 1: **PROVENANCE KAZANIR** (`#5`'in çatışması)

Bu oturuma kadar iki kanıt türü hep **aynı yöne** bakmıştı. `plans/:id/budget-check`
ilk kez **çatıştırdı**:

```
KAYIT      34e04aa  "F9: PLANNER kendi planının budget-check'ine
                      erişemiyordu → düzeltildi (403→200)"
           diff: {ADMIN, MANAGER, READONLY} → +PLANNER
           ⇒ adıyla · kusur numarasıyla · gerekçesiyle = KASIT

DAVRANIŞ   tek tüketici BudgetApprovalModal → PlanApprovalsPage
           ekran kapısı {ADMIN, CM, READONLY} — PLANNER YOK
           kapı cc654c2'de YANLIŞ KARDEŞTEN türetilmiş = ÖLÇÜLMÜŞ KAZA
```

### Hüküm

> **Çatışmada iki sinyalin de DOĞUM BELGESİ okunur; hangisi KARAR hangisi
> KAZAysa, KARAR kazanır. İkisi de kazaysa CÜMLE-TESTİ hakemdir.**
>
> ⇒ `PLANNER` üyeliği **KORUNUR**. Kasıt kazaya yenilmez.

⚠️ **Ve bir kuralın kapsamı daraltıldı:** *"davranışsal ulaşılamazlık ucuz
sinyaldir"* bir **TESPİT** aracıdır, bir **HÜKÜM** aracı değil. Ürün sahibinin
cümlesi: *"tespit aracıydı, hüküm aracı değil."*

📌 **`#9` ile karşıtlığı emsalin kendisini kurar:** `#9`'da **iki sinyal de kaza
yönünde** (kayıt yok ∧ ulaşılamaz) ⇒ `PLANNER` **düşer**. `#5`'te sinyaller
zıt ⇒ **kasıt kazanır**. Aynı kural, iki yönde.

⚠️ Ve `git log -L` kuralının **ikinci hüküm-deviren vakası**: `-S` ile
taransaydı `F9` **görünmezdi** ve bu emsal hiç doğmazdı.

### Ulaşılamazlığın adresi — ve ekran düzeltmesi NE DEĞİL

> **Ürün sahibi:** *"Ekran düzeltmesi `/approvals` sayfasına `P` ekle DEĞİL —
> o **onaycı yüzeyi**, `P`'nin yeri değil. `P`'nin gerçek tüketici yüzeyi
> **gönderim-öncesi kontrol**."*

⇒ `SENARYO-ADAY` kanalına tohum: *"planlamacı göndermeden önce bütçe kontrolünü
görür"* (**Faz-2**). Bir yetki kararı değil, bir **yüzey** kararı.

---

## `§2` — ⛔ ÇERÇEVE HÜKMÜ (üç bloğun hepsini yönetir)

> **GÖÇ BİREBİR YAPILIR — hiçbir normalizasyon göç dalgasına BİNMEZ.**

Küme-evrimi (`RO`/`CM`/`F` eklemeleri, `P` düşüşleri) **hücrenin üstünde**,
**kayıtla**, bir **istisna-dalgası satırı** olarak iner. Tek kaynak:
`capabilities.ts` + `Z`-kaydı — `H3`'ün *"kararla gelir"* ilkesinin **simetriği**.

### Üç şart, her genişlemeye

| şart | içerik |
|---|---|
| **çift bilgi-açılım testi** | eşit-yüklemli alternatif rota **∧** türetilmiş çıktılar |
| **`CM`-genişlemeleri KAPSAM-KOŞULLU** | kapsam zorlaması o rotalara inmeden `CM` **tenant-geneli görür** = açılım ⇒ `Z25` koşul satırı, sağlayıcı: kapsam-borç programı |
| **`RO`-eklemeleri TANIMSAL kayıtla** | İZLEYİCİ *"her şeyi görür"* (`Z18`) — `f3b9f82`'nin **dosya-kapsamı kazası** (`#7`/`#8`) dahil **tek listede** kapanır |

---

## `§3` — BLOK 1 · `SUMMARY_READ` = `{A, CM, F, RO}`

**Karar-destek dörtlüsü.** Cümleler `K-2.6.4`'ten: *yapısal* · *kategori-sahibi
[kapsamlı]* · *tenant-genel-finans* · *tanımsal-izleyici*.

### `PLANNER` portföy-özet yüzeyinden ÇIKAR

İki bağımsız dayanak:
1. **`#9` çift-olumsuz** — kayıt yok **∧** ulaşılamaz *(`#5`'in **tam tersi**:
   iki sinyal de kaza yönünde ⇒ `§1` emsali `P`'yi **düşürür**)*
2. `K-2.6.4`'ün planner cümlesi **özet içermiyor**

### Uygulama — hepsi istisna-satırı, yön-etiketli, repro-pinli

```
4×  {A,CM,F,RO}          BİREBİR göçer
−P ×4                    DARALTMA
+CM ×3                   GENİŞLEME · KAPSAM-KOŞULLU
                         ⇒ T-287/K3'ün üç widget sorusunun cevabı: EVET, AMA KAPSAMLA
stats/summary            KARMA (+CM +RO −P)
```

---

## `§4` — BLOK 2 · `MODES_READ`: yedi küme → **dört ev + evrim satırları**

| küme | n | hüküm |
|---|---|---|
| `5/5` | 10 | **`MODES_READ` tabanı** — birebir (`T-020` kayıtlı) |
| `{A,F,P}` | 12 | **defter-okuma hücresi** birebir (`K2` gerekçeli) · `+RO` **tanımsal** satır · `+CM` **kapsam-koşullu** satır (`K-2.2.9c`: *zarf sahibi kendi zarfının defterini okur*) |
| `{A,F}` | 5 | **içe-aktarma-okuma hücresi** birebir (`Z38`) — 4 şablon + `agreement-batch` |
| `{A,F,P,RO}` | 3 | kendi hücresi, birebir |
| `{A,CM,F,RO}` | 2 | `APPROVAL_QUEUE_READ`, birebir |
| `{A,CM,RO}` | 1 | aynı hücreye **`+F` istisna-satırıyla** — ⛔ **TEK ŞARTLA**, aşağı |
| `{A,CM,P,RO}` | 1 | → `BLOK 3` (`#5`+`#10` işlev-ailesi) |

### ⛔ `plans/pending-approvals` — göçün ÖLÇÜM ŞARTI

`+F` bir **genişlemedir**. Şart:

> **`FINANCE`'ın o uçtaki görünümünün BOŞ KÜME olduğu ÇAĞRILARAK ölçülür.**
> `ADR 0002` okuması bir **DURAĞAN YÜZEYdir** — `T-289` dersi.
> **Ölçüm tutmazsa rota TEK-VAKA kalır.**

### `on-invoice` ↔ `agreement-batch` asimetrisi → **istisna-aday listesi**

Yön **cümle-testiyle** belirlenir: `P`/`RO`'nun satırları **`ledger`'dan
türetebildiği** ölçülürse hizalama **açılımsızdır**.

### `LIST`/`POINT` hipotezi — RESMEN ÇÜRÜDÜ, ve kapanışı kayda

```
altı GENEL LIST↔POINT çiftinin ALTISINDA da küme AYNI     → eksen hiçbir kümeyi BÖLMÜYOR
onay-kuyruğu çiftlerinin ÜÇÜNDE DE ayrışma VAR (+K4 = 4/4) → APPROVAL_QUEUE ailesini İŞARET ETTİ
```

> **Ürün sahibinin kaydı:** *"Çürüyen hipotezin **işaret değeri** — sınama
> disiplininin ödülü."*

📌 Hipotez **doğrulanmaya çalışılmadı, sınandı** — ve sınama şekli (`LIST`↔`POINT`
çifti kurup küme karşılaştırmak) `K4`'ün `approvals` vakasının **birebir
tekrarıydı**. Eksen bir **yüklem** üretmedi; bir **GÖÇ ADAYI** üretti.

---

## `§5` — BLOK 3 · Tekiller

| kalem | hüküm |
|---|---|
| **`#5` + `#10`** | **TEK İŞLEV-AİLESİ HÜCRESİ** `{A,CM,P,RO}` — `budget-check` + `validate-budget` **birebir**. `−F` cümlesi `T-249` kayıtlı: *eşik-üstü onaycının kontrol yüzeyi ayrıdır*. `validate-budget`'ın **sıfır-çağıranı** `EK_E`-uyuyan notuyla |
| **`#4` `validate-formula` çifti** | `{A}` **birebir**, **yönetişim-okuma** — formül doğrulama = kural-yönetiminin **aracı** (`K-2.6.4` *"tanımlar"* cümlesi). ⛔ `MASTER_DATA_READ`-`5/5` seçeneği **REDDEDİLDİ**: *çağıransız yüzeye genişleme*, `İlke-1`'in **tam tersi** |
| **`#7` / `#8`** | `+RO` **tanımsal listesinde** — **iki-repo-tek-kapanış**: ekran kapıları **aynı satırda** güncellenir |
| **`#3` `budget-variance`** | hücresi `Z42 ADIM 0`'da açıldı (SAPMA-3); rota **çağıransız** ⇒ `EK_E` `🔒` |

---

## `§6` — TRİYAJ: yapısal bulgu KABUL, tek düzeltmeyle

### Bulgu kabul edildi

`Z40 §3`'ün `MEŞRU` durumu (*"kapsam gerekmiyor + cümlesi var"*) **`C` kovasının
tanımıdır**, ve triyaj evreninin hiçbiri `C`'de değil ⇒ **`38/38` BORÇ, itirazsız.**

> `İlke-4`: yeni bir sınıflandırma değil, **mevcut bir JOIN**. *(Aksi hâlde aynı
> gerçek iki yerde yaşardı.)*

### Çerçeve sabitlendi — ve bir SAYIM FARKI kaynağıyla kapandı

```
kalan-@Roles çerçevesi   61 ∩ kapsam listesi = 31 → eşik sonrası 21
HÜCRE-GENELİ çerçevesi   20 + 18 + 10        = 48 → eşik sonrası 38   ← YÜRÜRLÜKTE
```

> **Kapsam borcu GÖÇTEN BAĞIMSIZDIR** — göç etmiş bir rota da kapsamsız olabilir.
> Çerçeve `48`'e **sabitlenir**, ve böylece *"görüş alanından çıkma"* sınıfı
> kapanır (`approvals` çifti `A2` borcunu `APPROVAL_QUEUE_READ`'e **taşımıştı**,
> kapatmamıştı).

### Adresleme hükmü — ⛔ `38/38` ADRESSİZDİ

> **TEK ÇATI PROGRAMI.** Sahibi **Team Lead'de task olarak doğar**; eşiği
> `Karar-1`'in kaydı: **ilk-deploy sert eşiği**, dalga-planı **RLS/kapsam
> hattıyla** birlikte.

`SUMMARY ∧ A1 = 10`'un düşmemesi **Faz-1'i bloklamıyor** (`Z32` kapı-terfisi
**tetiklenmedi** — doğru okuma), ama o `10` **borç programının ilk dilimi**
olarak işaretlenir.

📌 Bu, `DISIPLIN`'in *"11 iyileşme birikti çünkü hangi turun işi olduğu yazılı
değildi"* vakasının **kapanışı**: liste vardı, gerekçeler vardı, **sahibi yoktu**.

---

## `§7` — SIRA, ve ⛔ AÇIK KARAR KALMADI

```
ADIM 0            beş sapma                                        ✅ İNDİ
uygulama dalgası  ~40 birebir göç + T-297  (TEK dalga, sabitlik satırıyla)
                  ⇒ kalan @Roles ~61 → ~20
istisna-dalgası   yön-etiketli satırlar
                  ⚠️ kapsam-koşullular Z25'te BEKLER, dalgaya BİNMEZ
B4                ön-koşul sayımı
```

> **Ürün sahibi:** *"Bu oturumla `ADIM 3`'te **açık karar kalmadı** — kalan her
> satır ya **göç** ya **kayıtlı-koşullu satır**."*

**Onay rejimi:** birebir dalga **onaya gelmez** (*"o artık rutin"*);
**istisna-dalgası brief'i onaya gelir.**

---

# `Z43` — `Z42 §3` KISMEN GERİ ÇEKİLDİ; iki uç yeniden dosyalandı

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Girdi:** `B3` istisna-dalgası `Faz-A` (dört ölçüm)

## `§0` — ⛔ GERİ ÇEKİLME (`F12` izi — `Z42 §3` SİLİNMEZ)

`Z42 §3`'ün `−PLANNER` hükmü **iki dayanağa** yaslanıyordu; `Faz-A` **ikisini de**
iki uçta çürüttü:

| dayanak | ölçüm |
|---|---|
| *"`#9` çift-olumsuz"* | `dashboard/summary` **ulaşılabilir** — `/` ve `/dashboard` kapıları `requiredRole` **taşımıyor** *(poz. kontrol: 42 kapı taşıyor)* |
| *"tek tüketici `/finance` ekranı"* | `dashboard/summary`'nin tüketicisi `DashboardPage` — `/finance` **değil** |

⇒ **Hüküm `dashboard/summary` ve `agreement-transactions/stats/summary` için GERİ ÇEKİLDİ.**
Kalan üç uç (`sales-actuals/summary` · `settlements/summary` · `plan-performance`) için
**AYAKTA** — ve o üçünde ölçüm hükmü **doğruladı**.

### ⛔ VE ÜRÜN SAHİBİNİN KENDİ TEŞHİSİ — üçüncü kayıtlı hata sınıfı

> *"**'Tek tüketici' cümlem `plan-performance`'ın ölçümünden `dashboard`'a
> GENELLENMİŞTİ. Genelleme, ölçüm değildir.**"*

```
1  spesifikasyon-"zaten"
2  uydurulmuş-alıntı
3  ÖLÇÜM-GENELLEMESİ        ← bu
```

**Üç geri çekilişin ortak deseni:**

> **Hükmün dayanağı bir ÖLÇÜMSE, hüküm o ölçümün TAZE OLDUĞU EVRENDE yaşar.**

---

## `§1` — HÜKÜM 1: `dashboard/summary` → `PLANNER` **KALIR**

Cümle-testi hakemliğinde **iki taraf eşit çıkmadı**:

| taraf | kanıt |
|---|---|
| `−P` | yalnız **kayıtsız doğum** (`d40ca16`, *"Add Dockerfile and pipeline config"*) |
| `+P` | ⛔ **ÜÇ BAĞIMSIZ TASARIM KANITI**: açık persona dalı (`// planner (default)`, üç kart) · kapsam-çözümlü servis (`resolveScopedCplIds`) · controller'ın kendi cümlesi (*"Planner: scoped to their assigned CPLs"*) |

### ⛔ VE DOĞRU OKUMA: hüküm yanlış değildi, **HÜCRE ÜYELİĞİ** yanlıştı

> **Ürün sahibi:** *"`Z31`/`Z32`'nin `SUMMARY` tanımı **nesne-bağsız ∧ çok-işlem-modüllü**
> idi ve **KAPSAMSIZLIK o tanımın ÖRTÜK PARÇASIYDI**; `dashboard/summary`
> **kapsam-çözümlü** olduğu için tanımın **dışında**."*

```
SUMMARY_READ = {A,CM,F,RO}     KALIR — dört PORTFÖY ucu için doğru
dashboard/summary              YANLIŞ-DOSYALANMIŞ, tek-vaka DEĞİL
                               ⇒ "kapsamlı-özet" sınıfı = MODES_READ tabanının
                                  doğal üyesi · zaten 5/5 taşıyor ⇒ GÖÇ BİREBİR
```

> ⚠️ **Tek-vaka listesi şişmesin: BİREBİR EV VARKEN tek-vaka etiketi TEMBELLİKTİR.**

---

## `§2` — HÜKÜM 2: `stats/summary` → **HÜCRE TRANSFERİ**, ve `Z32`'ye dokunmuyor

Team Lead'in endişesi (*"bu `Z32`'nin üyelik ölçütüne dokunur"*) **ters yöndeydi**:

> **`Z32`'nin ölçütü: "DAVRANIŞ belirler, YOL/AD belirlemez."**
> Bu ucun `SUMMARY_READ`'de durması bir **AD-BENZERLİĞİ DOSYALAMASIYDI**
> (`stats/summary` adı özet çağrıştırıyor); **davranışı** ise `MODES_LEDGER_READ`'in
> **tam profili**: aynı veri-ailesi, aynı sayfa, `{A,F,P}` birebir.
>
> ⇒ **Transfer, `Z32`'nin İHLALİ değil, DÜZELTİCİ UYGULAMASIDIR.**

### Karma satır böylece çözüldü — üç yönden ikisi dağıldı, biri **öldü**

```
−P    ÖLDÜ            P zaten yeni evinin üyesi
+CM   Z25'te BEKLER   kapsam-koşul HÜCRE-BAĞIMSIZDIR
+RO   §4'e KATILDI    yeni evi (ledger-ailesi) zaten o listede (#8)
                      ⇒ AYNI COMMIT'İN (f3b9f82) AYNI BOŞLUĞU, AYNI SATIRDA kapanır
```

---

## `§3` — `Faz-A`'nın diğer iki ölçümü

| | sonuç |
|---|---|
| **`§5` boş-küme** | ✅ **DOĞRULANDI, ÇAĞRILARAK** (`T-289` sınıfına düşmedi). `pending-approvals` → `1` kayıt `['PENDING_APPROVAL']` · `approval-queue` → `2` kayıt, iki statü. Fixture şartı sağlandı (`PENDING_FINANCE_REVIEW ≥ 1`) ⇒ **belirsiz durum imkânsızdı** |
| **`§6` türetilebilirlik** | ✅ **AÇILIM DEĞİL.** `batch`'te olup `findAll`'da olmayan alan: **`[]`**; `findAll` **daha zengin** (`agreement`,`customer` join'li). `PLANNER` `?batchId=` ile **birebir aynı** satırları alıyor |

### `pending-approvals` — **TEK-VAKA**, ve `−F` cümlesi kayda geçer

> **`FINANCE` bu uçtan İŞ GÖREMEZ — işlevsel kazanç SIFIR; ihtiyacı
> `approval-queue` karşılıyor ve `FINANCE` oraya ZATEN erişimli
> (`APPROVAL_QUEUE_READ` = `{A,CM,F,RO}`).**

Dayanak `ADR 0002` + ölçüm: `findPendingApprovals` statüyü **sabit** yazıyor
(`plan.service.ts:401`), `getApprovalQueue` iki statüyü birden.

### ⛔ `§6`'nın gerekçesi: **"yeni bilgi yok" (ÖLÇÜLDÜ)**, "emsal" DEĞİL

Ajanın dürüst sınırı **rapora aynen taşınır**: `on-invoice/batch/:batchId`'nin **kendi
alan kümesi ÖLÇÜLMEDİ**. Dolayısıyla *"kardeşi öyle"* bir **biçimsel tutarlılık**
argümanıdır; hizalamayı meşrulaştıran şey **ölçülen türetilebilirliktir**.

---

## `§4` — `Faz-B`'nin son hâli

```
BİNER   −P ×2   sales-actuals/summary · settlements/summary   (yüzeysiz)
        −P ×1   plan-performance                              (ekran kapısı zaten P'siz)
        +RO     #7 · #8 · stats/summary — iki-repo-tek-kapanış + EKRAN PİNİ
        §6      {A,F} → {A,F,P,RO}   (açılımsız, çift-test iki yarısıyla)
        transfer dashboard/summary → MODES_READ tabanı      (birebir)
        transfer stats/summary     → MODES_LEDGER_READ      (birebir)

KALIR   +CM ×3 + stats/+CM   → Z25 kilidi · T-304 DİLİM-1
        pending-approvals    → TEK-VAKA, −F cümlesi kayıtlı
```

## `§5` — İki şart

1. **`T-295`'e bağlanır:** `dashboard`'un `ProtectedRoute`-kapısızlığı **ve**
   `DashboardPage:95`'in tam-sayfa hata kapısı (*`allSettled` dersinin React-Query'de
   YENİDEN ÜRETİLMİŞ hâli*). ⛔ **Üçlü** o task'ın önceliğini besliyor:
   **giriş ekranı + evrensel fallback + kapısız.**
2. **`§6`'nın ölçüm sınırı** rapora aynen taşınır (bkz. `§3`).

---

# `Z44` — `B4` ÇERÇEVE HÜKMÜ: tek düğme değil, **`A′ → B` sıralı iki adım**

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Statü:** ⏳ **PİN BEKLİYOR**

> ⛔ **BU HÜKÜM BİLEREK PİNDEN ÖNCE VERİLDİ.**
>
> **Ürün sahibi:** *"Hükmün çerçevesini şimdi veriyorum ki **pin neyi doğrulayacağını
> bilsin** — pin, hükmü **doğrular ya da DEVİRİR**; hüküm pini beklemez."*
>
> ⇒ Bu, `DISIPLIN`'in *"reprodüksiyon şartı YÖNSÜZDÜR"* kuralının **hüküm tarafındaki**
> hâli: bir hüküm de bir **iddiadır** ve aynı kapıdan geçer. Hükmü önce yazmak onu
> **çürütülebilir** kılar — sonra yazmak, ölçümü **hükme uydurma** riskini doğururdu.

---

## `§1` — Soru bir SEÇİM sorusu değildi

`ADIM3_KAPANIS_RAPORU §3.1` iki düğmenin **zıt** sonuç verdiğini ölçtü. Ürün sahibinin
hükmü: bu bir **seçim** değil, bir **SIRA ve ÖN-ŞART** sorusudur.

| düğme | tek başına | gerekçe |
|---|---|---|
| **`B`** (`RolesGuard` çıkar) | ⛔ **TARTIŞMASIZ ELENİR** | `@Roles` hâlâ 15 rotada yaşarken çıkarmak = **15 rota herkese açık** — fail-open'ın **kitabi hâli** |
| **`A`** (bugünkü hâliyle) | ⛔ **UYGULANAMAZ** | `SELF_SCOPED`/`IS_PUBLIC` **okunmuyor** (ölçüldü: 74 satırda `0`) ⇒ **`/users/me` KIRILIR** — oturum yenilemenin yolu |

## `§2` — GERÇEK `B4` TANIMI

```
A′  CapabilityGuard default-deny'a döner — ÜÇ ÖN-ŞARTLA:

    1  guard @Public ve @SelfScoped'ı TANIR
       (bugün 0/74 — YAZILACAK İŞ, bir varsayım değil)

    2  kalan-15 İSTİSNA-LİSTELİ: @Roles taşıyan rota default-deny'dan MUAF
       ⛔ MUAFİYET TÜRETİLMİŞ EVRENDEN: elle liste DEĞİL,
          "@Roles taşıyor" YÜKLEMİNİN KENDİSİ
       her satır kalan-15 SÖZLEŞMESİNE bağlı (rapor §2)

    3  kalan-@Roles RATCHET'İ AÇILIR
       artış YASAK · düşüş yalnız SÖZLEŞME-KOŞULU açıldığında
       (15 → 13 → … → 2'yi izler)

B   RolesGuard'ın ÖLÜMÜ — tetiği TARİH değil OLAY:
    kalan-@Roles = 2 (iki KALICI satır) olduğunda ⇒ RolesGuard tek işlevli
    artık-guard'a iner YA DA iki satır kendi mekanizmasına devredilir
    (O GÜNÜN kararı, bugünün değil.)
```

### ⛔ `2`'nin şekli neden **türetilmiş** olmak zorunda

> **Elle liste olsaydı kabul EDİLEMEZDİ:** listeden düşen bir rota **sessizce**
> `default-deny`'a düşer ve **hiçbir e2e görmez**.
> **Türetilmiş evrende bu imkânsız:** bir rota ya `@Roles` taşır ya yetenek —
> **üçüncü hâl `G8` ailesinin kapısına çarpar.**

📌 Bu, `Z43` turunda doğan **evren-kaynağı hiyerarşisinin** (`türetilmiş > taranmış >
yazılmış`) ilk **tasarım** uygulaması: ders bir kapıdan **ürünün yetkilendirmesine**
taşındı.

## `§3` — `capability.guard.ts:14-17` REVİZE EDİLİR — **silinerek değil, DOĞRULANARAK**

Mevcut cümle: *"`RolesGuard`'ın kaldırılması `B4`'ün işidir ve kalan-`@Roles` listesi
**BOŞALMADAN yapılamaz** — bir karar değil, bir **ÖLÇÜM SONUCU**."*

| | hüküm |
|---|---|
| cümle **`B` düğmesi için** | ✅ **HÂLÂ DOĞRU** — `RolesGuard`, `@Roles` boşalmadan ölemez |
| yanlış olan | ⛔ o cümlenin **`B4`'ün TAMAMINI tarif ettiği OKUMASI** |

**Yeni metin iki-adımlı tanımı taşır:**
> *"`default-deny` (`A′`) **istisna-listeyle** iner; `RolesGuard`'ın ölümü (`B`)
> kalan-`@Roles`'un **iki-kalıcıya** inmesine bağlıdır."*

⚠️ **Uygulama ERTELENDİ:** bu dosya şu anda **düğme pininin mutasyon hedefi**.
Paylaşılan ağaçta aynı dosyaya dokunmak turu bozar (`CLAUDE.md`: *"`touches:`
kesişimi gerekli ama yeterli değil — DOĞRULAMA izolasyonu"*). Pin kapanınca yazılır.

## `§4` — ⛔ VE BİR GERÇEK KAYDA GEÇER: `(b)`-beklemesi **SAĞLANAMAZ BİR KOŞULDU**

```
kalan 15  =  13 KOŞULLU  +  2 KALICI
                            ↑ pending-approvals · budget-variance
```

⇒ *"Kalan `@Roles` sıfırlanınca `B4`"* demek, **hiçbir zaman** demekti.
**Sıfır bir TARİH değil, GELMEYECEK BİR OLAYDI.**

> ⛔ **Ve bunu ortaya çıkaran şey bir ölçüm değil, bir YAZIM BİÇİMİYDİ:**
> kalan-15'i *"adres + statü + **AÇILMA KOŞULU**"* — yani ***"kim, ne zaman, neyle
> açar"*** — formatında yazmak.
>
> **Ürün sahibi:** *"`kim-ne zaman-neyle açar` formatının **ilk maaşı** bu oldu."*

📌 `DISIPLIN`'e: **bir listeyi SÖZLEŞME biçiminde yazmak, listenin kendisinin
söylemediği bir şeyi söyletir.** Düz bir *"kalan 15"* listesi *"sıfıra iner"*
varsayımını **hiç sorgulatmazdı**; her satıra bir **açılma koşulu** yazmak, iki
satırın koşulunun **olmadığını** görünür kıldı.

## `§5` — PİNİN ŞEKLİ (üç ölçüm, tek tur)

| # | pin | tür | beklenti |
|---|---|---|---|
| 1 | `A`-ham (mevcut guard → default-deny) | ⛔ **kusur önce görülür** | `/users/me` **`403`** · kalan-15 **`403`** (ADMIN dahil) |
| 2 | `A′`-simülasyonu (SELF/PUBLIC tanıma + `@Roles` muafiyeti) | ✅ **kabul** | `/users/me` **`200`** · kalan-15 **birebir** · **SENTETİK** rota **`403`** |
| 3 | `B`-ham (`RolesGuard` çıkar) | ⛔ **kusur önce görülür** | 15 rota **yetkisiz role açılır** |

⛔ **`2`'nin sentetik rotası ŞARTTIR:** bugün **hiçbir gerçek rota** *"yetenek yok ∧
`@Roles` yok ∧ `@SelfScoped` yok ∧ `@Public` yok"* sınıfında değil ⇒ `default-deny`'ın
**kendisi** hiç koşmaz. `§2.7 #4`'ün tam vakası: **ölçülmek istenen durum mevcut
değil**, o yüzden **üretilir**.

## `§6` — Davranışsal tespit asimetrisi: **kapanmıyor, ÇERÇEVELENİYOR**

```
STATİK      15/15    route-scope "KURULUM HATASI" bloğu, rotaları ADIYLA basar
DAVRANIŞSAL  2/15    13 rotanın 403-yolu e2e'siz
```

> **Ürün sahibinin hükmü:** bu **kabul edilebilir** — çünkü `A′`'nın muafiyet-evreni
> **TÜRETİLMİŞ**. Elle liste olsaydı **kabul edilemezdi**.

⇒ Yani asimetriyi tolere edilebilir kılan şey bir **test sayısı** değil, bir **evren
tasarımı**. *(Kırmızıyı `e2e` değil **guard** verir — ve guard'ın kapsamı kendiliğinden
büyür.)*

---

## `Z44 §7` — PİN SONUCU: **ÇERÇEVE DOĞRULANDI**, ve pinin İKİ İDDİASI ÇÜRÜDÜ

**Tarih:** 2026-08-27 · üç pin koştu, hepsi mutasyon+geri-yükleme (`shasum -a 256 -c`) ile.

### Üç pin — beklenti/ölçüm

| pin | beklenti | ölçülen | |
|---|---|---|---|
| **1 · `A`-ham** | `/users/me` `403` · kalan-15 `403` **ADMIN dahil** | `200 → 403` **dördünde de** | ✅ **`A` UYGULANAMAZ** |
| **2 · `A′`-sim** | `/users/me` `200` · kalan-15 **birebir** · **SENTETİK** rota `403` | `200` · `ADMIN 200`/`PLANNER 403` **birebir** · **sentetik `403`** | ✅ **`A′` ÇALIŞIYOR** |
| **3 · `B`-ham** | 15 rota yetkisiz role **açılır** | `plans/:id/approve` **PLANNER2 → `200`** | ✅ **`(b)` TEK BAŞINA ELENİR** |

> ⛔ **`§5`'in kendi sınırı KAPANDI:** `§3.1` artık **kod okumasından** değil,
> **davranıştan** ölçülü.

### ⛔ VE PİNİN İKİ İDDİASI ÇÜRÜDÜ — ikisi de **ölçümle**

Pin, raporun `§3.2`'sindeki *"statik tespit `15/15`"* cümlesini **yanlış** ilan etti.
Team Lead bağımsız ölçtü — **iddia fazla genellenmişti**:

| pinin iddiası | ölçüm |
|---|---|
| *"`route-scope`'un statik tespiti `B`'yi görmüyor"* | ⛔ **ÇÜRÜDÜ.** `RolesGuard` **`@UseGuards` zincirinden ÇIKARILINCA** → `route-scope` **`exit 2`**, `budget-at-risk` ve `budget-variance`'ı **ADIYLA** basıyor |
| *"ne guard ne e2e bunu yakalardı"* | ⛔ **ÇÜRÜDÜ.** Guard **gövdesi boşaltılınca** `role-journey` **`N5` ve `N11` DÜŞÜYOR** (`2 failed, 84 passed`) |

### ⛔ KÖK NEDEN: **MUTASYON EŞDEĞERLİĞİ, ÜRÜN İÇİN ≠ KAPI İÇİN**

Pin, `B` düğmesini *"`RolesGuard`'ı zincirden çıkar"* yerine *"gövdesini `return true`
yap"* diye uyguladı ve eşdeğerliği **doğru gerekçelendirdi** — ama yalnız **bir eksende**:

```
ÜRÜN için    eşdeğer   ✅   her iki durumda da @Roles kontrolü UYGULANMAZ
KAPI için    DEĞİL     ⛔   route-scope @UseGuards LİSTESİNE bakar, GÖVDEYE değil
```

⇒ Pin, **kapı hakkında** bir sonuç çıkarırken **kapı için eşdeğer olmayan** bir mutasyon
kullandı. Sonuç: **doğru bir gözlemden yanlış bir hüküm.**

### Ama bir GERÇEK bulgu kaldı — ve o kayda değer

```
GERÇEK düğme B (zincirden çıkarma)   →  route-scope exit 2  ✅ statik kapı GÖRÜYOR
GUARD GÖVDESİNİN BOŞALTILMASI        →  route-scope exit 0
                                        npm run guards exit 0
                                        role-journey EXIT=1  ✅ E2E GÖRÜYOR
```

⇒ **İki bozulma yolu, İKİ FARKLI dedektör** — ve **hiçbiri ikisini birden görmüyor.**
Bu bir açık değil, bir **iş bölümüdür**; ama **yazılı olmadığı için** pin onu bir açık
sandı.

📌 Rapor `§3.2`'nin *"kırmızıyı `e2e` değil **guard** verir"* cümlesi **daraltılır**:
*"**yapısal** bozulmayı guard verir, **davranışsal** bozulmayı e2e."*

### Pinin ÜÇÜNCÜ bulgusu — **gerçek ve yeni**

`plans/:id/approve`'da ilk deneme **`403` kaldı**, ama sebep `RolesGuard` değil
`plan.service.ts:1405`'in **self-approval** kontrolüydü (`submittedById === userId`).
Farklı bir onaylayıcıyla `200` çıktı.

⇒ **RBAC'tan bağımsız İKİNCİ bir savunma katmanı** — `§3.2`'nin *"`agreements/:id/*`
`403`'ü servis katmanında"* notunun **plan tarafındaki eşi**. Envantere girer.

⚠️ **Yan bulgu:** `budget-variance` `PLANNER` ile **`500`** verdi —
`finance-reporting.service.ts:1261`, `column envelope.cplid does not exist`. RBAC'la
ilgisiz, **önceden var**, ve guard açılınca **görünür oldu**. `T-306`.

---

## `Z44 §8` — `A′` İNŞA EDİLDİ; ve review **dalganın kendi sırasını** çürüttü

**Tarih:** 2026-08-27 · `B4 A′` dalgası + `code-reviewer`

```
guards 0 · tsc 0 · unit 1151/1151 · e2e 790/790 · T-047 PASS
SABİTLİK  @Roles 15 + CAPABILITY 195 = 210   DEĞİŞMEDİ
```

### Dört kapı doğdu

| kapı | ne tutar |
|---|---|
| `roles-ratchet` | taban `15`, **dip `2`** — sıfır **değil** (`§4` gerekçesi guard yorumunda, iki rota **adıyla**) |
| `alan-guard-ratchet` | taban `2` |
| **`domain-guard-parity`** | ⛔ **ÇİFT-KAYIT**: `route-scope` KAYNAK A ↔ guard KAYNAK B |
| kilitli-tenant pini | **CANLI** zincir, **TEK `it`**, negatif yarı **içinde** |

> **ratchet SAYIYI tutar · çift-kayıt SINIFI tutar.**

### ⛔ REVIEW `B1` — çürüyen şey **bu dalganın kendi sırasıydı**

```
runtime  … → DOMAIN-GUARD → required      (MUAF)
statik   … → CAPABILITY   → ALAN_GUARD    (CAPABILITY kovasında)
```

⇒ **İki taraf ZIT SIRALI** = `İlke-4`: aynı olgunun iki temsili, **farklı cevap**.
Probe: `@RequireCapability(ADMIN_READ)` + tanınan domain-guard taşıyan rota,
**`READONLY` ile bile `true`** dönüyordu.

⚠️ Ve sınıf seviyesine konan bir domain-guard, o dosyadaki **HER** rotayı muaf yapardı
— bu turun `DISIPLIN`'e **yeni yazdığı** kuralın (*"sınıf-seviyesi dekoratör, dosyadaki
HER rotanın sözleşmesini değiştirir"*) **tam olarak ürettiği adım**.

**Düzeltme iki parça, ikisi de gerekliydi:**
1. muafiyet `!required` dalının **içine** alındı ⇒ **YETENEK BAĞLAR**
2. `single-mechanism`'e **dördüncü çift** — ve evren **KAYNAK A'dan geçirildi**,
   üçüncü bir kopya **yazılmadı** *(parity zaten `A↔B` eşitliğini zorluyor)*

**Ölçüm:** `SettlementGuard` sınıf seviyesine konunca `single-mechanism` **`exit 3`**,
rotayı ve çifti **adıyla** basıyor — `route-scope` ise **`exit 0`**, yani körlük
**oradaydı** ve artık **kapalı**. Kalıcı pin **ayırt edici**: eski sıra geri konunca
**tam o tek test** düşüyor.

### 📌 VE `Z44 §2`'NİN BİR CÜMLESİ DARALDI

`§2` şöyle diyordu: *"bir rota ya `@Roles` taşır ya yetenek — **üçüncü hâl `G8`
ailesinin kapısına çarpar**."*

⛔ **`A′` DÖRDÜNCÜ bir muafiyet üreticisi ekledi** (`TANINAN DOMAIN-GUARD`) ve o hâl
**hiçbir kapıya çarpmıyordu**. Cümle bugün **yeniden doğru** — ama **kendiliğinden
değil, dördüncü çift eklendiği için.**

> **Bir kapsama iddiası, kapsamı BÜYÜTEN her turda YENİDEN ölçülür.**

---

# `Z45` — ÜÇ CANLI BULGUYA HÜKÜM; ve `INV-T-004`/`005` AYRIMI

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Girdi:** `ADIM 5` `RLS` ölçümü + `SYSTEM_INVARIANTS` uzlaşısı

## `§0` — İKİ KAYIT

### `git add -A` ihlali — kapandı, ve desen tanıdık

Team Lead'in `50ee412` commit'i uzlaşı turunun **yarım işini** aldı (`git add -A .claude docs`).
Kapanış: **açık düzeltme commit'i**, veri kaybı **ölçülerek dışlandı** (başlıklar tek, çiftlenme yok).

> **Ürün sahibi:** *"Desen tanıdık — **paylaşılan-ağaç kuralını YAZAN tur, ilk ATEŞLEYEN tur oldu.**
> Sayaç işliyor, ömür yine kısa."*

### ⛔ `INV-T-004` / `INV-T-005` AYRIMI — bu turun en değerli KAVRAMSAL işi

```
"boş kapsam = erişim yok"   TEK CÜMLE, İKİ KATMAN
   YETENEK kapsamı   CapabilityGuard (A′)    → INV-T-004  ✅ HOLDS
   SATIR   kapsamı   AccessScopeService R-2  → INV-T-005  🔴 VIOLATED
```

> **Ürün sahibi:** *"Benim **'`A′` onun kod-kanıtı'** notum **`004` için doğruydu, `005` için
> değildi**. Tek-invariant yazılsaydı **KIRMIZI YEŞİLİN ARKASINA SAKLANACAKTI**."*

⛔ **Ve `INV-T-005`'in KÖKÜ adıyla kaydedilir:**
```
SCOPE_ENFORCEMENT_ENABLED = false   (varsayılan KAPALI)
⇒ satır-kapsamı bir FEATURE-FLAG arkasında
⇒ PLANNER için "boş kapsam" diye bir durum YOK — koşulsuz UNRESTRICTED
```
Bu, **`T-304`'ün GERÇEK KAPSAMIDIR.** ⚠️ Canlı `.env` değeri **`VARSAYIM`** olarak
işaretli kalır — `RLS` paketi onu **ölçümle** getirir.

---

## `§1` — `T-308` HÜKÜM: `security_invoker` **ŞİMDİ**, ve **vaka değil SINIF** kapanır

> *"Politikadan önce view — yoksa her politika yazımı **SAHTE-YEŞİL** doğar."*

**Üç şart:**

| # | şart |
|---|---|
| **1** | Düzeltme **tek view'a değil, VIEW-ENVANTERİNE** iner: tüm view'ların `reloptions` taraması; her biri ya **invoker'lı** olur ya **bypass'ı bir KARAR KAYDIYLA** taşır *(ürün sahibi tahmini: hepsi invoker'lı olur — bypass-gerekçesi yazılabilecek view yok)* |
| **2** | ⛔ **KAPI DOĞAR:** *"yeni view `security_invoker`'sız DOĞAMAZ"* — `G8` ailesi, evreni **`pg_views`/`reloptions`'tan TÜRETİLMİŞ**, **`"ölçemedim"` çıktılı** |
| **3** | Pin: iki-tenant probe'un **kalıcılaşması** (zaten var: invoker'sız→**iki**, invoker'lı→**tek**; mutasyonu hazır) |

`app_migrate`-owner + `app_runtime`-`SELECT` düzeni invoker sonrası **doğru** — **dokunulmaz**.

## `§2` — `T-307` HÜKÜM: uygulama-katmanı daraltması **ŞİMDİ**

> ⛔ ***`RLS`'i beklemek KATEGORİK HATA olur.*** Ölçüm söylüyor: `RLS` bu tabloya
> **yazılamaz** (`tenant_id` yok) ⇒ **beklenecek bir şey yok.** Çözümün evi **zaten
> uygulama katmanı**, ve süzgeçten geçiyor (**veri-bozulması önleme** sınıfı).

**Dört parça:**

1. **Okuma/güncelleme uçları kendi-kiracı semantiğine iner** — `GET /tenants` listesi
   **ölür** ya da **tekil kendi-kayda** döner; `GET`/`PATCH /tenants/:id`
   **`id === currentUser.tenantId`** zorlar. *(`SELF` deseninin **kiracı** hâli.)*
2. **`create`/`delete` uçları için `İlke-1` sorusu** — *bir kiracının admin'inin kiracı
   yaratması/silmesi **hiçbir `K`-kaydında YOK**.* ⇒ Bu uçlar ya **ÖLÜR** *(ürün
   sahibinin tercihi: tenant-yaşam-döngüsü **operatör işi, uygulama dışı**; `T-289`
   emsali — **tüketicisi ölçülsün, sıfırsa kaldırma zinciri**)* ya **operatör-yolu
   tasarımına devredilir**. ⛔ **Tüketici ölçümü hangisi olduğunu SÖYLER.**
3. **Pin iki-tenant fixture ile** — *"verinin yokluğu örter"*in kitabi vakası:
   `main.tenants=1` iken **her test yeşil**. ⛔ **Fixture ikinci kiracıyı taşımadan
   hiçbir tenant-izolasyon pini PİN DEĞİLDİR** — ve bu şart **`RLS` paketinin BÜTÜN
   ölçümlerine** de geçer.
4. **Dört `tenant_id`'siz tablonun kalan üçü** paket-envanterinde **adıyla** gelir —
   her biri ya ***"global-meşru"*** cümlesi alır ya **`T-307`'nin kardeşi** çıkar.

## `§3` — `INV-B-009` HÜKÜM: önce TEŞHİS, ama **okuma-düzeltmesi teşhisi BEKLEMEZ**

**Teşhis sorusu:** iki zarfın **defterinden bağımsız yeniden-hesap** —
`allocated − reserved − consumed` **hangi değeri veriyor?**

**Çerçeve hükmü:**
> **KANONİK OLAN DEFTER-TÜRETİMİDİR** (`K-2.2` ailesinin ruhu: **defter gerçeğin
> kaynağı, kolon bir KOPYA**).

| teşhis | sonuç |
|---|---|
| **kolon bayat** | güncelleme-yolu **eksik** — hangi işlem atlamış (muhtemelen `Z24`-öncesi bir yol ya da `CAP`/release dalı). Kolon ya **senkron-mekanizmaya bağlanır** ya **ÖLÜR** *(view zaten hesaplıyorsa kolonun varlığı **`İlke-4` adayı**)* |
| **view yanlış** | **formülü düzeltilir** |

### ⛔ BEKLETİLMEYECEK YARIM

`on-invoice-validation.service.ts:575` — bir **RAG eşiğine** **bayat + sessiz-sıfırlı**
değer giriyor.

> ***"`500` ALARM üretir; YANLIŞ DEĞER KARAR üretir"*** cümlesinin **canlı vakası.**

**Okuma noktası teşhisten BAĞIMSIZ olarak tek kanonik kaynağa döner.** Bugün için
**güvenli ara adım:**
```
İKİ DEĞERİ DE OKU · AYRIŞIYORSA HATA FIRLAT · SESSİZ DEVAM ETME
⇒ AYRIŞMA-ALARMI, YANLIŞ-RAKAMLA-RAG'den İYİDİR
```
Ve `|| 0` + not-found→`0` dalları **`T-291` sınıfıyla birlikte ÖLÜR**.

⛔ **`T-308` migration'ı bu işten ÖNCE iner** — aynı view, **temiz zeminde teşhis**.

## `§4` — SIRA

```
T-308 (view SINIFI + kapı)  →  INV-B-009 (teşhis + düzeltme)  →  T-307 (daraltma)
```
Üçü **kısa zincir**; dosya kesişimi **tek noktada** (view) ve **sıralı** olduğu için sorun değil.
⚠️ **`T-309`'un üç ölü mekanizması `T-307` commit'ine BİNEBİLİR** — aynı modül, **ölü kod
ölür**, ve **dördüncü-yol riski DOĞMADAN** kapanır.

## `§5` — `K1` paketin **EN AĞIR** kalemi, hükmü PAKETLE verilir

`K1`'in kilit tespiti — *denetim-olaylı operatör yolunun **sağlayıcısı yok**: `pgaudit`
yok, `admin_audit_logs` **tenant'sız aktörü kaydedemez*** — paketin **en ağır karar
kalemidir**, ve hükmü **paketle** verilir: **çözümü denetim-çekirdeği tasarımıyla AYNI
MASA.**

---

# `Z46` — ÜÇ HÜKÜM: tenant yaşam-döngüsü · bağlantı deseni · `K1` kilidi AÇILDI

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Girdi:** `Z45` zinciri + `RLS` karar paketi

## `§1` — `T-307` madde-2: yaşam döngüsü **OPERATÖR-YOLUNA**; uçlar ve ekran **ÖLÜR**

### Kavramsal zemin — ölçümün kendisinden

> **`ADMIN` bu üründe KİRACI-İÇİ bir roldür.** Kiracı **yaratmak/silmek** ise tanım gereği
> **PLATFORM-SEVİYESİ** iştir.
>
> ⇒ Kiracı-içi bir yetkinin **kiracı-üstü** bir nesneye dokunması **`T-307`'nin TA
> KENDİSİYDİ.** `create`/`delete`'i `ADMIN`'de tutmak, aynı sınıfın ***"ama biz
> kullanıyoruz"* muafiyetli hâli** olurdu.

⛔ **Canlı tüketici KALDIRMAYI DURDURMAZ, ŞEKLİNİ DEĞİŞTİRİR:**
> Bu ekran fiilen bir **operatör-konsolu** işlevi görüyor — ama **kiracı-admin
> kimliğiyle**. ***Yanlış katmanda doğru iş.***

### Hüküm — dört parça

| # | |
|---|---|
| **a** | `create`/`delete`/`findAll` uçları **+** `TenantForm`/`TenantList` **İKİ-REPO-TEK-KAPANIŞLA ÖLÜR.** Tenant yaratmanın bugünkü **meşru yolu seed/script** — *zaten öyle*: **hiçbir `K`-kaydı self-service onboarding tanımlamıyor**. Ürünleşirse **`Faz-3` kararıyla** gelir (süzgeç) |
| **b** | `GET`/`PATCH` **kendi-kayıt** (tenant **ayarları**) **KALIR** — kiracı-içi **meşru** yüzey |
| **c** | **Sessiz-kaybolma açık kalemi bu hükümle KÖKTEN ölüyor** (`create` ölünce asimetri ölür) — ⛔ **ama ölmeden önce REPRO-PİNE girsin:** bugünkü *"yarat → listede yok → hata yok"* davranışı **BİR KEZ GÖRÜLSÜN** (`T-273`) |
| **d** | **Geçiş kaydı**, sahipsiz kalmasın: *"tenant yaşam-döngüsü = **script + seed**, sahibi **operatör**, adresi **`K1` tasarımı**"* |

## `§2` — BAĞLANTI DESENİ: **`SET LOCAL` KANONİK**, session-`SET` **YASAK**

### Katman 1 — KESİN

```
session-SET  ⛔ YASAK   (fail-open ÖLÇÜLDÜ — tartışma bitti)
```

**Ve politika ŞEKLİ FAIL-CLOSED yazılır:**
```sql
current_setting('app.tenant_id', true) boş/NULL  ⇒  politika HİÇBİR SATIR eşleştirmez
```
> **Bağlamsız sorgu = BOŞ KÜME, *"hepsi"* DEĞİL.** Böylece sarmalayıcıyı unutan bir yol
> **sızdırmaz**, **görünür biçimde boş döner**.
>
> 📌 Bu, guard'ların ***"üç meşru çıktı"*** yasasının **SQL hâlidir.**

### Katman 2 — **ADAY**: taşıyıcı mimari

```
istek-kapsamlı transaction sarmalayıcı  (INTERCEPTOR seviyesi
                                         — 19/411'i ELLE büyütmek DEĞİL)
+ NFR-1.2 MALİYET PROBE'U
```
⛔ **Temsili bir okuma ucunun `tx`'li/`tx`'siz `p95`'i ölçülmeden bu satır KARARA
DÖNMEZ.**

Aktivasyon zaten **deploy-eşiğinde**; `Faz-1`'in çıktısı **bu iki-katmanlı kayıt + probe
sonucu**. Spike küçük — **`RLS` sondasının genişletilmesiyle (iki-kiracılı) AYNI DALGAYA
binebilir.**

## `§3` — `K1`: ⛔ **KİLİT AÇILDI** — sağlayıcı `pgaudit` DEĞİL, **ROL-SEVİYESİ LOG**

Kilidin tespiti **doğruydu**, ama **sağlayıcı sanıldığından UCUZ:**

```
pgaudit        → imaj işi, Faz-3'e kalabilir
ALTER ROLE collmind_operator SET log_statement='all'
               → ROL SEVİYESİNDE BEDAVA denetim-izi (postgres LOG'una,
                 uygulama TABLOSUNA değil)
⇒ admin_audit_logs'un NOT NULL-tenant sorunu BU KARARA GİRMİYOR
  (tenant'sız-aktör kaydı DENETİM-ÇEKİRDEĞİ turunun KENDİ maddesi)
```

### Hüküm

```
operatör = AYRI DB ROLÜ
   NOSUPERUSER  +  BYPASSRLS  +  PAROLALI  +  log_statement='all'

db-query.sh postgres'ten BU ROLE taşınır — ve ÜÇ TÜKETİCİ ADIYLA BİRLİKTE:
   schema-isolation KAPISI · plan-scale e2e · data-analyst ajan talimatı
   (taşınmazsa SESSİZCE postgres'e geri döner — ölçülmüş şart)

postgres SUPERUSER'ı İNSAN-YOLU olmaktan ÇIKAR
```

⛔ **Ve `§1` bu role İLK İŞİ DE VERDİ** (tenant yaşam-döngüsü) ⇒ **`K1` artık soyut bir
güvenlik kalemi değil, SAHİPLİ BİR ROL TANIMI.**

**İnşası denetim-çekirdeğiyle BİRLEŞİK: tek dalga, iki çıktı** (operatör-rolü + denetim-olay
çekirdeği) — dosya kesişimi **zaten aynı bölge**.

## `§4` — SIRA

```
Docker  →  doğrulama-listesi (10 madde)  →  PUSH
        →  T-307-m2 uygulaması (uç + ekran ÖLÜMÜ)
        →  bağlantı-spike + sonda-genişletme      (aynı dalga)
        →  K1 + denetim-çekirdeği                 (tek dalga, iki çıktı)
```

**Paketin kalan hüküm-bekleyenleri** (`K2` tetikleyici cümlesi · `FORCE RLS` · `T-310`
login-yolu) **küçük ve çoğu bu üç hükmün TÜREVİ** — paket güncellenmiş girdiyle döndüğünde
**tek turda** kapanırlar.

⛔ **`INV-B-009`'un kolon-kaderi masada BEKLİYOR:** teşhis *"kolon bayat"* dedi; view doğru
hesaplıyorsa **kolonun ölümü (`İlke-4`) GÜÇLÜ ADAY** — ⛔ **ama o hüküm, AYRIŞMA-ALARMININ
CANLIDA NE SIKLIKTA ÖTTÜĞÜ görülmeden VERİLMEYECEK.** Docker-sonrası ilk `e2e` koşumu **o
veriyi de getirir.**

---

# `Z47` — `INV-B-009` HÜKMÜ: **KOLON ÖLÜR**

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Girdi:** canlı ayrışma ölçümü (4 zarfın 2'si)

## `§1` — ÜÇ GEREKÇE

### 1 · Bu bir *"senkronu BOZULMUŞ kopya"* değil — **HİÇ SENKRON MEKANİZMASI OLMAMIŞ** bir kopya

```
available_amount  YALNIZ create + splitEnvelope'ta yazılıyor
reserve / commit / release           HİÇ DOKUNMUYOR
⇒ doğduğu gün DOĞRUYDU, İLK REZERVDE BAYATLADI
```

> Senkron eklemek (**seçenek-a**), **var olmayan bir mekanizmayı SIFIRDAN inşa etmek**
> demek — ve `İlke-4`'ün **kitabi vakası**: aynı gerçek (`available`) **iki yerde**, biri
> **türetilmiş** biri **yazılmış**, ve **yazılmış olan KANITLANMIŞ BİÇİMDE YALAN SÖYLÜYOR.**

### 2 · Ayrışma ORANI: `4`'te `2` — **rezerv görmüş HER zarf ayrık**

⇒ Senkron *"ara sıra kaçırılan bir yol"* **değil**, **tüm yaşam-döngüsünün eksik** olduğunu
gösteriyor. Ve alarm-ara-adımı canlıda **yarı yarıya** ötecekti — **sürdürülemez**.

### 3 · `K-2.2` ailesinin ruhu **hükmü zaten vermişti**

> **Defter gerçeğin kaynağı; `available` bir TÜREV.**
> **Türev, SORGU ANINDA türetilir** (view zaten yapıyor, doğruluğu **bağımsız
> yeniden-hesapla kanıtlı**) — **kolonda SAKLANMAZ.**

## `§2` — UYGULAMA DİSİPLİNİ, dört satır

| # | |
|---|---|
| **a** | **Tüm okuyucular** view'a/türetime döner. Envanter: `on-invoice-validation:575` **düzeltildi**; **kalan okuyucu taraması DÖRT-YÜZEY usulüyle** — *başka `available_amount` okuyan var mı*, **poz. kontrollü** |
| **b** | Kolon **migration'la düşer** — **`Z24` disiplini**: `run` → `revert` **byte-birebir** → `run`. Finansal tablo ama **satır silinmiyor**, **türetilmiş-kolon** ölüyor ⇒ **ADR 0012 ihlali YOK**; yine de kayda bir cümle: ***"ölen şey VERİ değil, BAYAT TÜREV."*** |
| **c** | Ara-adımın **ayrışma-alarmı kolonla birlikte ÖLÜR** — *görevini yaptı: **teşhis verisini o üretti***. |
| **d** | `INV-B-009` statüsü **`RESOLVED`** — kaynak **teklendi**, ve **TEK-KAYNAK invariant'ı olarak YENİDEN YAZILIR**: ***"`available` hiçbir yerde SAKLANMAZ; her okuma DEFTER-TÜRETİMİDİR."*** |

📌 **`(d)` bir ilktir:** uzlaşı turunun **kalıcı-mekanizma kararının** (*türetilebilir statü
guard çıktısından türer*) **ilk YENİ-DOĞAN uygulaması** — bir invariant, bir **statü satırı**
olarak değil, bir **tek-kaynak kuralı** olarak yazılıyor.

## `§3` — SIRA

```
KOLON-ÖLÜMÜ (küçük, BAĞIMSIZ dalga)  →  T-307-m2  →  bağlantı-spike + sonda  →  K1 + denetim
```
> **`INV-B-009`'u AÇIK BIRAKIP üstüne dalga bindirmek, *"BİLİNEN AYRIŞMA ÜSTÜNDE
> ÇALIŞMAK"* olurdu.** Dosya kesişimi **yok**.

## `§4` — İKİ KAYIT

### `T-273` şartının bu turdaki ödemesi

> *"Altı uçta birden kırmızı — bugüne kadar yalnız **kod okumasıydı**."*
>
> ⇒ **`T-307`'nin tüm hüküm zinciri artık ÖLÇÜLMÜŞ bir kusurun üstünde duruyor,
> OKUNMUŞ bir kusurun değil.**

### ⛔ YABANCI CONTAINER: kural maaşını ödedi — ama **LİSTE MADDESİ OLMALI**

`tpm-backend`, port `5433` — **`TTM` donduruluşundan kalma hayalet**. Bugün yakalandı,
çünkü `CLAUDE.md` uyarısı okundu.

> **Ürün sahibi:** *"`docker ps` kontrolü **doğrulama-listesinin KALICI İLK MADDESİ**
> olsun. Şu an bir `CLAUDE.md` **uyarısı** — **liste maddesi değil**; `e2e`-öncesi
> **MEKANİK kontrol** hâline gelsin, ***"ölçüm ortamı temiz mi"* ailesinin İLK
> SORUSU.***"

📌 Bir uyarı **hatırlanmak** zorundadır; bir **liste maddesi** hatırlanmak zorunda değildir.
*(Bu, `DISIPLIN`'in *"kuralı hatırlamak yerine ARACI çağır"* ilkesinin bu turdaki
uygulaması.)*

---

# `Z48` — `T-307-m2` İNDİ; ve hüküm **BİR `🔒` DOĞURDU**

**Tarih:** 2026-08-27 · `Z46 §1`'in uygulaması · **rota `210 → 207`**

## `§1` — KAPSAM GENİŞLEMESİ: brief **iki** dosya adlandırdı, **on dört** öldü

Ajan genişletti **ve `DUR`'a düşürdü**. İki bağımsız ölçüm genişlemeyi **doğruladı**:

```
/tenants/:id  →  useParams<{id}>   ⇒ KEYFİ bir :id, URL'den
                                   ⇒ PLATFORM-KONSOLU şekli
"kendi ayarlarım" olsaydı :id TAŞIMAZDI — JWT'den türerdi
tek giriş      →  Sidebar linki + üç route tanımı (ikisi de aynı diffte öldü)
'/tenants' string'i src genelinde →  SIFIR
```

⇒ **On dört dosya KAPALI BİR ADAYDI.** Brief'in ikisini adlandırıp on ikisini bırakması
**erişilemez orphan** bırakırdı — genişleme, `§4.2`'nin *"üretim çağrı yolu"* maddesinin
**GEREĞİYDİ**, ihlali değil.

📌 Ve `Z46 §1`'in *"yanlış katmanda doğru iş"* teşhisi **koddan doğrulandı**: yüzeyin
**tamamı** operatör-konsolu şeklindeydi.

## `§2` — ⛔ VE BU HÜKÜM BİR `🔒` DOĞURDU — adresi **`T-313`**

`Z46 §1(b)` beş ucu **meşru yüzey** diye korudu. `T-307-m2` frontend'i **tamamen**
öldürdü. Sonuç:

```
CANLI UÇ      GET/:id · PATCH/:id · :id/activate · :id/suspend · :id/stats
              (beşi de assertSelfTenant kilidinde — ölçüldü)
TÜKETİCİ      SIFIR
```

⇒ **`§1(b)`'nin *"meşru yüzey"* gerekçesi, bugün YÜZEYİ OLMAYAN bir hüküm.**

> ⛔ **`🔒` BİR KABUL DEĞİL, BİR ALARMDIR** — ve ilk yazımında **kapanmış bir task'ın
> PARANTEZİYDİ**. `DISIPLIN`: *"bilinen eksiklik TODO ile değil, **TASK** ile
> kaydedilir"* — **kapanmış bir task'ın anlatı parantezi bir task değildir.**

⇒ **`T-313`** açıldı. Ve `EK_E` **donmuş** olduğu için satır **ancak bir karar
kaydıyla** girer — **bu kayıt odur.**

⚠️ `T-313`'ün ilk şartı hükümden çıkıyor: *"kendi ayarlarım"* ekranı **`:id` TAŞIMAZ**
— aksi hâlde **öldürdüğümüz platform-konsolunu geri getirir**.

## `§3` — ÜÇ KAYIT

### `a` · Bir kusuru **ÖLDÜREN** turda repro artefaktı **DAHA** gereklidir

`(c)`'nin sessiz-kaybolma pini **görüldü** ama **artefaktı saklanmadı**, ve `create`
öldüğü için davranış **artık üretilemez** ⇒ iddia bir daha **hiç doğrulanamaz**.

> **Kalıcı pin yazılamaması MEŞRU; artefaktın saklanmaması bir EKSİKLİKTİR** — ve
> `T-307.md`'ye **açıkça** yazıldı, kanıtlanmış gibi okunmasın diye.

### `b` · Ölü mock, **var olmayan bir sözleşmeyi** modeller

Üç `msw` handler'ı (`GET`/`POST /tenants`, `DELETE /tenants/:id`) rotalar ölünce
**ölü** kaldı. Silindi — çünkü yarın onlara karşı yazılan bir test **üretimde olmayan
bir şeyi YEŞİL doğrular** (`T-301`'in *"silinmiş uca başarı dönen handler"* vakasının
birebir tekrarı olurdu).

### `c` · İki ölçüm hatası, **ikisi de kendiliğinden bildirildi**

| kim | ne |
|---|---|
| dalga ajanı | `git stash`/`stash pop` — `CLAUDE.md`'nin **açıkça yasakladığı** yöntem |
| review ajanı | tırnaksız `--include=*.ts` ⇒ **14 grep'in 14'ü hiç koşmadı**, hepsi `0` bastı (`§2.7 #5`) — **pozitif kontrol yakaladı** |

⛔ **`git stash` ihlali ölçüldü: KAYIP YOK** (düşmüş stash bulundu, çalışan ağaçla
`diff`'lendi, tek fark sonradan koşan prettier). Ama kural bir *"dikkat ederim"* değil:
`git show HEAD:<dosya>` maliyeti **sıfırdı**.

📌 **Ve desen:** bu oturumda `git stash`/`git add -A` sınıfı **iki** ihlal oldu, **ikisi
de kendiliğinden bildirildi** — biri Team Lead'in. ⇒ **Raporlama refleksi çalışıyor,
KAÇINMA refleksi çalışmıyor.** Bu, *"bir kuralın üçüncü ihlali YERLEŞİMİNİN kusurudur"*
maddesinin **bir sonraki adayı**.

---

## `Z48 §4` — STASH DESENİ: ÜÇÜNCÜ İHLALDE **ARAÇ**, ve ŞEKLİ ŞİMDİDEN YAZILI

**Ürün sahibi (2026-08-27):** *"Üçüncü vaka tartışma açmasın diye şeklini şimdiden
koyalım."*

```
BUGÜNKÜ SAYIM   iki vaka  ·  ikisi de BİLDİRİMLİ  ·  kayıp SIFIR
                (1) Team Lead — `git add -A`   (2) dalga ajanı — `git stash/pop`
KURAL           zaten yazılı: "bir kuralın ÜÇÜNCÜ ihlali, kuralın değil
                YERLEŞİMİNİN kusurudur"
```

### Araç adayı — **bugün KURULMAZ**, üçüncüde **tartışmasız** kurulur

> Paylaşılan-ağaç işlemlerinde **`git stash`** ve **`git add -A`**'yı **FİZİKEN
> ENGELLEYEN** bir `pre-commit`/wrapper kontrolü.

**Niçin bugün değil:** iki vakanın **ikisi de kendiliğinden bildirildi** ve **kayıp
sıfır**. Bir aracı iki vakada kurmak, ölçülmüş bir gerekçe olmadan **süreç eklemektir**.

**Niçin üçüncüde kesin:** çünkü desen artık **adlandırılmış**:
> ⛔ **RAPORLAMA refleksi çalışıyor, KAÇINMA refleksi çalışmıyor.**

Ve bu, kardeş vakaların **birebir** şekli: `push` sırası iki kez ters yapıldı → **script**
oldu; mutasyon geri alma üç kez yanlış gitti → **araç** oldu.

📌 **Şeklin şimdiden yazılması bir tasarım değil, bir TAAHHÜTTÜR** — üçüncü vaka
geldiğinde *"gerekli mi"* tartışması **açılmayacak**, çünkü ölçüt **bugün** kondu.

---

# `Z49` — BAĞLANTI-SPIKE + SONDA GENİŞLETMESİ: **ÜÇ ÇIKTI DA GÖRÜLDÜ**

**Tarih:** 2026-08-28 · `Z46 §2`'nin ölçümü · ⚠️ Ajan **oturum limitine takıldı**; iş
**tamamlanmıştı**, Team Lead **doğruladı ve koşturdu**.

## `§1` — SONDA GENİŞLEDİ (ikinci dosya **yazılmadı**)

`test/db-role-rls-sonda.e2e-spec.ts` — **9/9 PASS**, `T-047` **PASS**.

### ⛔ FAIL-CLOSED POLİTİKA ŞEKLİ — üç çıktının **üçü de** ölçüldü

```
ÇIKTI 1/3  bağlam SET EDİLMEDEN      →  0 SATIR        ("hepsi" DEĞİL)
ÇIKTI 2/3  doğru bağlam (SET LOCAL)  →  YALNIZ KENDİ KİRACISI
           A → 'tenant-a-row' · B → 'tenant-b-row'   ⇒ SİMETRİK
ÇIKTI 3/3  YANLIŞ bağlam (3. kiracı) →  0 SATIR
```

⛔ **VE BOŞLUK ANLAMLI:** `2/3` aynı tabloda **tam 1 satır** döndürüyor ⇒ `1/3` ve
`3/3`'ün sıfırı *"veri yok"* değil, **politika çalışıyor** demek. *(`T-273` /
**"boş sonuç FARK DEĞİLDİR"** şartı — karşılandı.)*

**Fixture iki-kiracılı ve GERÇEK:** `main.tenants`'a **iki `INSERT`**, `T-047`
invaryantını bozmadan temizleniyor.

### ⛔ VE DÖRDÜNCÜ BİR ÖLÇÜM — `SET LOCAL` transaction DIŞINDA

> **`set_config(..., true)` transaction dışında çağrılırsa: SESSİZ NO-OP — bağlam
> HİÇ UYGULANMAZ.**

⇒ `Z46 §2`'nin *"oturum seviyesinde ASLA `SET` yapılmamalı"* hükmünün **kardeş
tehlikesi**: `SET LOCAL` de **yanlış yerde** çağrılırsa **sessizce hiçbir şey yapmaz**.
Taşıyıcı mimari bunu **yapısal olarak** imkânsız kılmalı (`queryRunner` sarmalayıcısı),
bir çağrı-disiplinine bırakmamalı.

## `§2` — ⛔ `NFR-1.2` PROBE: **`ADAY` KARARA DÖNEBİLİR**

```
GET /budget/envelopes          N=30    p95 = 8.19 ms   (bugünkü şekil, tx YOK)
findAllEnvelopes SQL           N=100   BARE p95 = 0.66 ms
                                       SET-LOCAL-TX-SARILI p95 = 1.25 ms
                                       ⇒ DELTA = 0.59 ms
```

**Yorum — sayının söylediği:**
```
NFR-1.2 bütçesi      < 500 ms
bugünkü uç p95         8.19 ms      (bütçenin ~%1.6'sı)
tx-sarmalama maliyeti  +0.59 ms     (bütçenin ~%0.12'si)
```

⇒ **`SET LOCAL` + istek-kapsamlı transaction, `NFR-1.2` açısından KARŞILANABİLİR.**
Ölçüm `Z46 §2`'nin *"probe olmadan bu satır KARARA DÖNMEZ"* şartını **karşıladı**;
**hüküm ürün sahibinindir.**

⚠️ **Ve ölçümün sınırı yazılı:** bu bir **tek-kullanıcılı, boş-yük** ölçümü. Eşzamanlı
yük altında bağlantı-havuzu baskısı **ölçülmedi** — `411` çağrı yerinin **tx'e sarılması**
havuz doygunluğunu değiştirebilir, ve o **ayrı bir ölçümdür**.

## `§3` — KAYIT: bir ajan **öldü**, iş **ölmedi**

Spike ajanı `API` oturum limitine takıldı ve **son satırda** kesildi. İş **tamamlanmıştı**;
Team Lead ağacı ölçtü (`tsc 0`, dokuz test **PASS**), fixture'ın **iki-kiracılı** ve pinin
**ayırt edici** olduğunu **bağımsız** doğruladı.

📌 **Ders:** yarım kalmış bir turun ilk sorusu *"nereye kadar geldi"* değil,
***"BIRAKTIĞI ŞEY DERLENİYOR VE ÖLÇÜLEBİLİYOR MU"*** — çünkü ikincisi ölçülebilir,
birincisi bir **anlatıdır**.

---

# `Z50` — TAŞIYICI MİMARİ: `ADAY` → **KARAR**

**Tarih:** 2026-08-28 · **Karar:** ürün sahibi · **Girdi:** `Z49` spike (üç ölçüm)

> ## ⛔ **`SET LOCAL` + İSTEK-KAPSAMLI TRANSACTION SARMALAYICI — KANONİK**

## `§1` — ÜÇ ÖLÇÜMÜN BİLEŞİMİ

| # | ölçüm | sonuç |
|---|---|---|
| **1** | tx-delta **`0.59 ms`** = bütçenin **`%0.12`**'si | ⇒ ***"MALİYET"* SORUSU KAPANDI** — tartışma eşiğinin **altında** |
| **2** | alternatiflerin **ikisi de** ölçülmüş **fail-open / no-op** sınıfında | session-`SET` **commit-sonrası sızıyor** (`Z49` öncesi) · tx-dışı `SET LOCAL` **sessiz no-op** (`Z49`'un **dördüncü** çıktısı) |
| **3** | ⇒ sarmalayıcısız **her** desen bir **ÇAĞRI-DİSİPLİNİNE** yaslanıyor | ve çağrı-disiplini bu repoda **kanıtlanmış biçimde ölçeklenmez** — ***"dikkat ölçeklenmez, kapı ölçeklenir"*** |

## `§2` — KARARIN GÖVDESİ

> **TAŞIYICI, SESSİZ NO-OP'U *YAPISAL OLARAK* İMKÂNSIZ KILAR — ÇAĞRI-DİSİPLİNİNE
> BIRAKMAZ.**

```
bağlam  YALNIZ tx içinde var olabilir
tx      SARMALAYICIDAN doğar
        ⇒ ÜÇÜNCÜ YOL YOK
```

📌 Bu, `Z49 §1`'in **dördüncü ölçümünün** doğrudan sonucudur: `SET LOCAL`'ın **yanlış
yerde** sessizce hiçbir şey yapması, bir **çağrı hatası** değil — **mimarinin izin
verdiği bir şekil**. Karar o şekli **kaldırıyor**.

## `§3` — İKİ ŞERH, KARARIN İÇİNDE

### `a` · EŞZAMANLI-YÜK SINIRI — kayda, ve **ilk-deploy ön-koşuluna**

`Z49`'un probe'u **tek-kullanıcılı, boş-yük** ölçümüdür. **`411` çağrı yerinin tx'e
sarılmasının HAVUZ-DOYGUNLUĞU etkisi ÖLÇÜLMEDİ.**

> ⛔ **Tek-kullanıcı ölçümü onu CEVAPLAYAMAZ ve CEVAPLAMIŞ GİBİ OKUNMAMALIDIR.**

⇒ **İlk-deploy ön-koşul listesine** (`FAZ1_PLAN §0`) ayrı bir satır: **aktivasyon-öncesi
YÜK PROBE'U**.

### `b` · İNŞA BU DALGANIN İŞİ **DEĞİL**

Aktivasyon **deploy-eşiğinde**; sarmalayıcının **inşası** o eşiğin **hazırlık
dalgasında**. **Bugün kararlaşan şey: MİMARİ ŞEKİL + KANIT ZEMİNİ.**

## `§3b` — ⚡ DIŞ TESCİL (`Z53 §2`, 2026-08-28)

Bir dış araştırma raporu **`[dış-girdi, doğrulanmadı]`** bu kararın üç ölçümünü
**bağımsız** doğruladı: session-`SET` sızıntısı · tx-dışı `SET LOCAL` no-op ·
fail-closed boş-küme.

⚠️ **Tescil bir KANIT değil, bir TEYİTTİR** — karar **zaten yerel ölçümle** verilmişti
ve rapor onu **üretmedi**. *(Sıra önemli: *"rapor böyle diyor"* bir gerekçe olsaydı,
`Z53 §1`'in kuralı anlamsızlaşırdı.)*

## `§4` — ⇒ `Faz-1`'in `ADIM-5` ÇIKTISI **TAMAMLANDI**

```
desen           SEÇİLİ      (SET LOCAL + istek-kapsamlı tx)
politika-şekli  YAZILI      (bağlamsız sorgu = BOŞ KÜME, "hepsi" DEĞİL)
sonda           ÜÇ-ÇIKTILI  (+ dördüncü ölçüm: tx-dışı sessiz no-op)
maliyet         ÖLÇÜLÜ      (p95 delta 0.59ms, bütçenin %0.12'si)
```

---

# `Z51` — `K1` DALGASI **DUR**: `Z46 §3`'ün SAĞLAYICI İDDİASI **ÜÇTE BİR** DOĞRU

**Tarih:** 2026-08-28 · **Statü:** ⏳ **ALTI HÜKÜM BEKLER** · Ajan **DUR** dedi, Team Lead **doğruladı**

> `Z46 §3` şöyle demişti: *"sağlayıcı sanıldığından **UCUZ**: `ALTER ROLE ... SET
> log_statement='all'` **rol seviyesinde BEDAVA** denetim-izi verir."*

## `§1` — ⛔ ÖLÇÜM: ÜÇ ALANDAN **BİRİ**

```
log_statement      ctx=superuser           ✅ ROL SEVİYESİNDE — hüküm BURADA DOĞRU
log_connections    ctx=superuser-backend   ❌ "cannot be set after connection start"
log_line_prefix    ctx=sighup   '%m [%p] ' ❌ %u YOK ⇒ AKTÖR GÖRÜNMEZ · KÜME seviyesi
logging_collector  ctx=postmaster  off     ❌ log yalnız docker stdout'unda
```

| alan | statü |
|---|---|
| **ne** (statement) | ✅ rol seviyesinde **bedava** |
| **kim** (aktör) | ❌ **KÜME** seviyesi |
| **kalıcılık** | ❌ **POSTMASTER** seviyesi — `docker rm` ile **iz YOK** |

⛔ **Ve `CLAUDE.md §2.3`:** *"Audit: **immutable**; silinemez."* Bir `docker rm` ile yok
olan `stdout` akışı bu şartı **karşılamaz**.

### Davranışsal pin — iki marker, canlı log

```
LOG: statement: SELECT 'MARKER_APP_RUNTIME_PIN_A1';    ← app_runtime
LOG: statement: SELECT 'MARKER_OPERATOR_PIN_B7';       ← BYPASSRLS'li operatör adayı
⇒ İKİ SATIR BİRBİRİNDEN AYIRT EDİLEMİYOR
```
Onları ayıran **tek şey** enjekte edilen marker metni. Gerçek bir operatör sorgusu,
uygulamanınkinden **ayırt edilemez** ⇒ `§2.7 #6`: **kapsam var, ayırt etme gücü yok.**

> ⇒ **`K1`'in `B` okuması hâlâ geçerli — ama artık DAHA TEHLİKELİ biçimde:** karar
> defteri sağlayıcının **indiğine** inanıyor. Rol bugün kurulursa *"denetim-olaylı"*
> şartı **ilk günden ihlal edilir** ve ihlal **GÖRÜNMEZ** olur.

## `§2` — ⛔ KAYITSIZ CANLI SAPMA: `app_runtime` **zaten** `log_statement=all`

```
pg_roles.rolconfig   app_runtime → {log_statement=all}   ·  app_migrate → (yok)
repo genelinde grep  log_statement → KOD/SCRIPT'te SIFIR
```
⇒ Biri canlıda **elle** `ALTER ROLE` çalıştırmış. İki sonuç:
1. **Canlı DB, kurulum betiğinden ÜRETİLEMEZ** — taze ortamda bu ayar **yok**
2. ⛔ **Ayar YANLIŞ ROLDE:** operatörü **ayırt etmek** için istenmişti; bugün
   **uygulama** rolünde duruyor ⇒ `411` çağrı yerinin tamamı **parametreleriyle**
   loglanıyor

## `§3` — ⛔ ÜÇ TÜKETİCİ DEĞİL, **ALTI** — biri **ÖLÜ**, biri **KARŞI REPODA**

| # | yer | brief'te | statü |
|---|---|---|---|
| 1 | `scripts/db-query.sh` | ✅ | canlı |
| 2 | `guards/schema-isolation.sh:38` | ✅ | canlı — **ve kendi `-U postgres` FALLBACK'i var** |
| 3 | `test/plan-scale-validation.e2e-spec.ts:43` | ✅ | ⛔ **ÖLÜ — yalnız YORUM** (`T-232` ailesi) |
| 4 | `.claude/agents/data-analyst.md:58` | ✅ | canlı |
| **5** | `guards/view-security-invoker.sh` | ❌ | **canlı — bir KAPI** |
| **6** | `guards/dropped-column-absence.sh` | ❌ | **canlı — bir KAPI** |
| **7** | `collmind.frontend/tests/e2e/support/db-cleanup.ts:71` | ❌ | ⛔ **canlı, ÇAPRAZ REPO** |

⛔ **`#7` `Z46 §3`'ün *"sessizce `postgres`'e geri döner"* şartının TAM MEKANİZMASI:**
```ts
user: envOr('DB_USERNAME', 'postgres')   // ← SESSİZ VARSAYILAN
```
`.env`'den satır **silinirse** bu dosya sessizce `'postgres'`e düşer. Ve `#2` aynı
sınıfın ikinci hâli. ⇒ **Sarmalayıcıyı taşımak bu iki dalı KAPATMAZ.**

📌 Ve `#3` bir `T-232` vakası: brief onu *"bir e2e"* diye adlandırmıştı; çalışma
zamanında `postgres`'e **hiç dokunmuyor**. Taşıma listesine konsaydı, bir **yorumu
düzeltmek** *"iş yapıldı"* sayılırdı — oysa asıl iş `#5`/`#6`/`#7`'ydi.

## `§4` — ⛔ PAKETTE OLMAYAN BULGU: `ON DELETE CASCADE`

```sql
admin_audit_logs.tenant_id → main.tenants(id)  ON DELETE CASCADE
```
```
Z46 §1        tenant yaşam-döngüsü (create/DELETE) = OPERATÖRÜN İLK İŞİ
ölçüm         bir tenant silinince onun TÜM denetim geçmişi de SİLİNİR
CLAUDE.md §2.3  "Audit: immutable; SİLİNEMEZ"
```

> ⛔ **OPERATÖR ROLÜNÜN İLK İŞİ, DENETİM İZİNİ YOK EDEN BİR İŞ.**

`Z46 §1(d)` *"sahibi operatör, adresi `K1` tasarımı"* demişti — **adres burası**, ve
tasarım bu çelişkiyi **çözmeden yazılamaz**.

## `§5` — DENETİM ENVANTERİ (taze)

```
yazma ucu        107   (@Post 67 · @Patch 24 · @Delete 16)   POZ.KONTROL @Get=112
denetim üreten    17   logAdminAction, 7 dosyada
                       ⇒ plan yaşam-döngüsü ve auth: SIFIR (ADIM 2 bulgusu HÂLÂ geçerli)
§2.5 sessiz atlama  6 vaka  —  `if (adminId && adminEmail)` , else YOK
denetim ailesi     DÖRT DEĞİL, ÜÇ  (budget_transaction_logs Z24'te öldü)
değişmezlik        app_runtime'da DELETE yok (kolon-GRANT gerçek mekanizma)
                   ama SAHİBE karşı koruma YOK · trigger sayısı 0 (K-2.11.7 açık)
```

⛔ **VE SÖZLÜKSÜZLÜĞÜN BEDELİ CANLI VERİDE:**
```
AGREEMENT (BÜYÜK) · mechanic (küçük) · SalesActualBatch (PascalCase)
⇒ TEK BİR varchar KOLONDA ÜÇ HARF KONVANSİYONU
```
`T-231`'in `budget_*` çiftinde bulduğu ayrışmanın aynısı, bu kez **`admin_audit_logs`'un
kendi içinde**.

### ⚠️ Ve bir sayım DÜRÜSTÇE yapılmadı

`107` ile `ADIM 2`'nin `119`'u **karşılaştırılamadı** — iki sayım **farklı yöntemle**
üretildi (`ADIM 2` kod okuması, bu tur dekoratör sayımı) ve **farkın kaynağı
gösterilemiyor**. `DISIPLIN`: *"bir sayım farkı, kaynağı gösterilmeden yorumlanamaz."*
⇒ **Yorumlanmadı.**

---

# `Z52` — `K1` ALTI HÜKÜM: çelişki çözüldü, `K1a` onaylı, borç **sert** yazıldı

**Tarih:** 2026-08-28 · **Karar:** ürün sahibi · **Girdi:** `Z51` ölçümleri

## `§1` — `#4` **`CASCADE` ÖLÜR → `RESTRICT`**, ve karar `tenant_id`'den BÜYÜK

> **DENETİM İZİ, İZ SÜRDÜĞÜ NESNENİN YAŞAM DÖNGÜSÜNE TABİ OLAMAZ.**

`Z46 §1`'in çelişkisi (*"operatörün ilk işi, denetim izini yok eden iş"*) **tek bir
FK'nin sorunu değil** — bir **tasarım cümlesinin eksikliği**. ⇒ **`ADR 0012`'nin
(finansal kayıt fiziken silinmez) DENETİM-KATMANI KARDEŞİ.**

```
admin_audit_logs.tenant_id  →  ON DELETE RESTRICT
tenant-silme akışı          →  "önce DENETİM-ARŞİVİ, sonra silme" sırasını
                               YAPISAL olarak alır
```
📌 `RESTRICT` bunu **zorlar**: arşivlenmemiş logu olan tenant **silinemez** — ve bu,
**doğru davranışın ta kendisi**.

⛔ **`SET NULL` ELENİR:** aktörsüz/kaynaksız kalan bir log satırı, *"kim-ne yaptı"*nın
**yarısını kaybetmiş** izdir. **İZ BÜTÜNLÜĞÜ `NULL`'LA YAŞAMAZ.**

## `§2` — `#3` **AYNI TABLO** + `tenant_id` NULLABLE

Ayrı platform-tablosu **reddedilir** — `Z15`'in **kendi cümlesiyle**: *"bağımsız
tanımlarsak **beşinci aile** oluruz."*

```
operatör eylemi  →  AYNI TABLO
tenant_id NULL   →  "PLATFORM-SEVİYESİ EYLEM"   ⛔ TANIMLI ANLAMIYLA
```
> ⛔ **`NULL` burada BİLGİ-EKSİKLİĞİ DEĞİL, KATMAN-BİLGİSİDİR** — ve bu ayrım
> **tablonun yorumuna yazılır**.

```
tenant_id    NOT NULL  →  NULLABLE   (katman bilgisi)
admin_id     NOT NULL  →  KALIR ve SIKILAŞIR
admin_email  NOT NULL  →  KALIR ve SIKILAŞIR
```
⇒ **Tenant'sız satırda bile `kim`'siz satır OLAMAZ.**

`§1` ile birlikte tablo hem **platform-eylemini taşıyabilir** hem **yaşam-döngüsü
bağımsızlığını** kazanır.

## `§3` — `#1` BÖLÜNME **ONAYLI**: `K1a` bugün · `K1b` **adresli borç**

`K1a`'nın kazancı **bugün gerçek**: `postgres`-`SUPERUSER`'ın **insan-yolundan
düşmesi** — *en büyük tekil operasyonel risk kaleminin kapanışı*.

### ⛔ VE BORÇ CÜMLESİ **SERT** YAZILIR

> ## **`K1a`'NIN DENETİM-İZİ İDDİASI YOKTUR.**
> **`log_statement` rol-seviyesinde `ne`'yi verir; `kim`'i ve `kalıcılığı` VERMEZ.**
> **O ikisi `K1b`'nin işidir — ve `K1b` KAPANMADAN *"operatör denetim-olaylıdır"*
> cümlesi HİÇBİR BELGEDE KURULAMAZ.**

📌 Ve borcun başına, aynen: ***"`1/3` doğru bir iddia, tamamen yanlış olandan DAHA
TEHLİKELİDİR."***

**`K1b`'nin şekli** kendi **mini-tasarımını** ister: `logging_collector` +
`log_line_prefix`'e `%u` + **volume-kalıcılık** — ya da **uygulama-katmanı çift-yazım**.
`docker-compose`'a dokunur, **ilk-deploy listesiyle kesişir** ⇒ **adresi o liste**.

## `§4` — `#2` KURULUM-YOLU **İSTİSNADIR** — ve istisna **kayıtlı-dar** yazılır

```
"İNSAN-YOLU"  =  etkileşimli sorgu · bakım · veri-erişimi     →  app_operator
BOOTSTRAP     =  rol yaratma · migration-zinciri kurulumu     →  superuser, TANIM GEREĞİ DIŞINDA
```
⛔ **`Z29` istisna disipliniyle:** `_lib.sh`'in superuser kullanımı **yalnız
kurulum-fonksiyonlarında**, **adıyla listeli**.

⛔ **VE ÇAPRAZ-REPO FALLBACK BU HÜKMÜN TAM HEDEFİ:**
```
envOr('DB_USERNAME', 'postgres')   ⇒  VARSAYILAN postgres'E DÜŞEMEZ
ya operatör-rolü VARSAYILAN olur, ya değişken ZORUNLU (fallback'siz, eksikse HATA)
⇒ "sessizce postgres'e geri döner" MEKANİZMASI ÖLÜR
```

## `§5` — `#6` BETİĞE YAZILIR, **DOĞRU ROLE TAŞINARAK**

Kayıtsız sapmanın **iki** kusuru var (**üretilemezlik** + **yanlış-rol**) ve ikisi **tek
hamlede** çözülür:
```
app_runtime'dan  log_statement=all  KALKAR
   (uygulama trafiğini loglamak ne denetim-tasarımının parçasıydı ne performans-masum;
    hüküm gereği denetim K1b'de)
app_operator'ün log_statement=all'ı  KURULUM BETİĞİNDE DOĞAR
```
📌 Böylece ***"canlı ortam betikten üretilebilir"*** kuralının **ilk uygulaması** bu
satır olur — **canlı sapma betiğe KOPYALANMAZ, DOĞRU TASARIMA ÇEVRİLİR.**

## `§6` — `#5` NORMALİZASYON **ŞİMDİ DEĞİL**; konvansiyon **kararı** + eşleme **şimdi**

```
BUGÜN     konvansiyon KARARI (DENETIM_SOZLUGU/Z15 ailesine bağlı; üç-harf
          yaşayacaksa GEREKÇESİYLE)  +  mevcut 39'un sözlüğe EŞLEMESİ (taze ölçüm)
SONRA     39 satırın KADERİ (migrate / tolere / dondur) — o eşlemenin SONUCUNA
          hüküm olarak biner
```
⛔ **Veri-katmanında YARI-NORMALİZE dokunuş bugün `İlke-4` RİSKİ.**
⇒ `K1b` + olay-envanteri dalgasının işi.

## `§7` — SIRA

```
BU DALGA   K1a  +  §1/§2 migration (RESTRICT + nullable-tenant + actor sıkılaştırma)
                +  §5 taşıması  +  §4 fallback-ölümü
SONRA      K1b  +  §6 kaderi  →  DENETİM-ÇEKİRDEĞİ dalgası
                                 (sağlayıcı-borcu + olay-envanteri ile birlikte)
```

---

# `Z53` — DIŞ-GİRDİ KAYDI: `RLS` / denetim-izi araştırma raporu

**Tarih:** 2026-08-28 · **Kaynak:** ürün sahibi (NotebookLM derlemesi)
**Dosya:** `docs/research/Research_report_PostgreSQL_RLS_and_SaaS_Audit_Trails.md`

## `§1` — STATÜ: **KAYNAK-İZSİZ DERLEME**

> ⛔ **BU RAPORDAKİ HİÇBİR SAYISAL/DAVRANIŞSAL İDDİA, YEREL PROBE OLMADAN KARAR
> TAŞIMAZ.**

Sayısal iddialar (ör. *"pgAudit `%15-25` throughput kaybı"*) **atıfsızdır** ve
**`VARSAYIM` rafındadır**.

**Karar-metinlerinde atıf biçimi:** **`[dış-girdi, doğrulanmadı]`**

📌 Bu, `CLAUDE.md §2.1.2`'nin (*"bağlayıcı kaynak bir **GİRDİ**dir, kanıt değil"*)
**dış-kaynak** hâlidir — ve orada `BRD`'ye uygulanan ölçüt, burada bir araştırma
raporuna uygulanıyor. **Bir metnin ikna ediciliği, kanıt değeri değildir.**

## `§2` — TEYİT DEĞERİ: üç yerel ölçümü **BAĞIMSIZ** doğruluyor

| yerel ölçüm | kaydı |
|---|---|
| session-`SET` sızıntısı — **in-process havuzda DAHİ** | paket `B/2` probe `E1` |
| tx-dışı `SET LOCAL` **sessiz no-op** | `Z49 §1` **dördüncü** ölçüm |
| **fail-closed boş-küme** | `Z49 §1` üç çıktı |

⇒ ⛔ **`Z50`'NİN DIŞ TESCİLİ** *(çapraz-referans `Z50`'ye eklendi)*.

⚠️ **Ama tescil bir KANIT değil, bir TEYİTTİR:** karar **zaten yerel ölçümle** verildi
ve bu rapor onu **üretmedi**. Sıra önemli — *"rapor böyle diyor"* bir gerekçe olsaydı,
`§1`'in kuralı anlamsızlaşırdı.

## `§3` — GİRDİ EŞLEMESİ (hükümlerle **birlikte** okunacak yerler)

| rapor | bizim hüküm | okuma |
|---|---|---|
| **`§3`** FORCE RLS | ⏳ **AÇIK** — `K1b` turunda | `app_migrate`=owner / `app_runtime`=DML-only ayrımımız **endüstri deseniyle örtüşüyor**; `FORCE` = **owner-muafiyetine karşı DERİNLİK-SAVUNMASI** |
| **`§2`** mimari tablosu | `K1b` tasarımı | **bugün:** `logging_collector` + `log_line_prefix %u` + **volume-kalıcılık** · **deploy-çağı adayları:** `WORM`/S3, `CDC` (⇒ ilk-deploy listesine satır) · **`Faz-3` aday:** `pgAudit` **dar kapsam** |
| **`§1`** mitigasyon | havuz-doygunluk probe'u (ilk-deploy) | probe'un **ölçüm listesine**: *tx içinde dış-çağrı **yasağı*** · **holding-time** · **timeout** |
| **`§4`** impersonation | `K1a` + `SET LOCAL` | **uyumlu**; **TTL-kimlik/Vault** = **çok-müşteri çağı** adayı |

⛔ **Ve `§2`'nin *"dual-write problemi"* uyarısı, çift-yazım seçilirse bizim
SESSİZ-DÜŞEN-AUDIT-INSERT dersiyle BİRLEŞİK okunur** — yani dışarıdan gelen bir uyarı,
**bizim ölçtüğümüz** bir vakaya bağlanmadan brief'e girmez.

## `§4` — İKİ KAPI ADAYI (`K1b`/denetim-çekirdeği brief'ine)

### `a` · **BYPASSRLS-HİJYEN** kapısı
```
app_runtime'da BYPASSRLS/SUPERUSER  →  YOK
BYPASSRLS taşıyan roller            →  KAYITLI LİSTE (bugün: app_operator, Z51 kaydıyla)
evren  pg_roles'tan TÜRETİLMİŞ  ·  "ölçemedim" çıktılı
```
📌 `Z51 §2`'nin **kayıtsız rolconfig sapması** bu kapının **doğum gerekçesi**: bir rol
ayarı canlıda **elle** değişti ve **hiçbir kapı görmedi**.

### `b` · **YENİ-TABLO-RLS** kapısı
```
tenant_id taşıyan tablo RLS-etkin DEĞİLSE  →  KIRMIZI
statü: AKTİVASYONA KADAR blocked · AÇILMA KOŞULU YAZILI
```
⇒ **`T-308` davranış-pini deseni**: kapı **doğar ama `blocked` durur**, ve açılma
koşulu **kayıtta** — *"sessizce ertelenemez"* kuralının kapı tarafı.

---

# `Z54` — `FORCE RLS`: **(ii) AÇIK** + kayıtlı muafiyet; uygulaması **AKTİVASYON PAKETİNDE**

**Tarih:** 2026-08-28 · **Karar:** ürün sahibi

> ## ⛔ HER TENANT-TABLOSUNDA **`ENABLE` + `FORCE` BİRLİKTE** YAZILIR

`app_migrate`'in operasyonel bypass ihtiyacı (**seed · migration · backfill**) bir
**muafiyet-politikasıyla DEĞİL**, **o işlemlerin kendi doğasıyla** çözülür.

## `§1` — ÖLÇÜLEN ROL-AYRIMI **ZATEN İŞİ YAPIYOR**

```
app_runtime   owner DEĞİL   →  FORCE'suz da POLİTİKAYA TABİ
app_migrate   owner         →  FORCE ONU DA TABİ KILAR
                               ⇒ İSTEDİĞİMİZ DERİNLİK-SAVUNMASI TAM BU
```

Seed/migration'ın **bağlamsız** çalışması gerekiyorsa çözüm **`FORCE`'u kapatmak
değil**, o betiklerin:
- ya **`BYPASSRLS`'li operatör-yoluyla** (`Z51` **kayıtlı istisna**),
- ya **bağlam-set-ederek**

koşmasıdır. ⇒ **Hangisi olduğu AKTİVASYON DALGASININ ÖLÇÜMÜDÜR.**

## `§2` — GEREKÇE HİYERARŞİSİ

| # | |
|---|---|
| **1** | ⛔ **`FORCE`'suz dünyada *"owner'ın sorguları politikadan muaf"* satırı, BİLEŞİMSEL-FAIL-OPEN ailesinin DB'DEKİ UYUYAN ÜYESİ olur** — bir gün biri `app_migrate` kimliğiyle bir **okuma-yolu** açar ve **hiçbir kapı görmez** |
| **2** | **Maliyet bir POLİTİKA satırı değil, bir TEST satırı** — sonda zaten üç-çıktılı; `FORCE` altında **owner-bağlamsız sorgu → boş küme** pini **eklenir** |
| **3** | Dış-girdi `§3` **aynı yönde** — **`[dış-girdi, doğrulanmadı]`**, ama **bizim yerel rol-ölçümümüzle ÇAKIŞIK** |

📌 `(1)` bu kararın **kalbi**: `FORCE`'suz bir dünyada kusur **bugün yok**, ama
**mekanizması var** — ve `DISIPLIN`'in *"bileşimsel fail-open: her parça masum, boşluk
BİLEŞİMDE"* ailesinin **DB tarafı**.

## `§3` — ZAMANLAMA

```
HÜKÜM        bugün kayda girer
UYGULAMA     RLS-AKTİVASYON dalgasının İLK MADDESİ
             (politikalarla AYNI migration ailesi — bugün FORCE'lanacak POLİTİKA YOK)
```

⛔ **VE YENİ-TABLO-RLS KAPISININ SÖZLEŞMESİNE ŞİMDİ YAZILIR:**
> **`tenant_id` taşıyan bir tablo, `ENABLE` + `FORCE` ÇİFTİ OLMADAN DOĞAMAZ.**
*(Kapı **aktivasyona kadar `blocked`**, **koşulu yazılı** — `T-308` deseni.)*

---

# `Z55` — `#5` KONVANSİYON: **SÖZLÜK KAZANIR**; üç-harf **ölür**, ama **veri-dokunmasız**

**Tarih:** 2026-08-28 · **Karar:** ürün sahibi

> ## ⛔ KANONİK AD-UZAYI **`DENETIM_SOZLUGU`**'DUR
> Üç-harf konvansiyonu **TARİHSEL BİÇİM** statüsüne iner.

**Gerekçe:** `Z15`'in *"bağımsız tanımlarsak **beşinci aile** oluruz"* cümlesi
**AD-UZAYI için de geçerli**.

## `§1` — ÜÇ KATMAN, SIRA **SERT**

### `1` · TAZE ENVANTER (`S1–S4` yöntemiyle)
⛔ **`107` ↔ `119` farkı KAYNAK GÖSTERİLEREK kapanmadan HİÇBİR EŞLEME YAZILAMAZ.**

### `2` · EŞLEME TABLOSU
```
her mevcut action_type / entity_type değeri  →  sözlük-adı  +  STATÜ
   birebir  ·  birleşiyor  ·  SÖZLÜKTE-YOK → sözlüğe ADAY SATIR
```
⛔ **SÖZLÜK DE BU TURDA SINANIYOR — tek yönlü itaat DEĞİL.** *(Eşlenemeyen bir değer,
sözlüğün eksikliğini gösterebilir.)*

### `3` · VERİ KATMANINA **DOKUNULMAZ**
```
mevcut satırlar OLDUĞU GİBİ kalır
okuma-katmanı EŞLEME TABLOSUNDAN normalize eder
⛔ UPDATE YAZILMAZ
```
> **`İlke-4` şartı + `ADR 0012` ruhu: DENETİM SATIRI, NORMALİZASYON UĞRUNA BİLE YENİDEN
> YAZILMAZ — İZ, İZDİR.**

## `§2` — EŞLEME TABLOSU **İKİ İŞ BİRDEN** YAPAR

```
GEÇMİŞİN okuma-anahtarı
GEÇİŞİN  ratchet'i        ⇒ YENİ satırda ESKİ-BİÇİM → KIRMIZI
```
Yeni olaylar **doğrudan sözlük-adıyla** doğar.

📌 Bu, `Z53 §4b`'nin *"kapı doğar ama `blocked` durur"* deseninin **kardeşi**: burada
kapı **doğar ve HEMEN çalışır** — çünkü koruduğu şey **gelecek**, geçmiş değil.


---

## `Z56` — `ADIM 6` REVIEW'ÜNDEN ÜÇ KALICI KAYIT

> **Kaynak:** ürün sahibi, 2026-08-28 · `ADIM 6` push'unun onay mesajı
> **Statü:** üçü de **kalıcı** — ikisi `DISIPLIN`'e, biri `FAZ1_PLAN §0`'a indi.

### `§0` · Push hükmü ve **neden bloklamadığı**

`ADIM 6` push edildi (`push-order.sh` `EXIT=0`, üç repo doğrulandı). İki insan-eylemi
(`K1b` pini · `DB_OPERATOR_PASSWORD` `.env`'e taşıma) **push'u bloklamaz** — gerekçe
ürün sahibinin kaydından:

> İkisi de **aktivasyon-değil-beyan** sınıfı: pin geçene kadar hiçbir belge
> *"denetim-olaylı"* **demiyor**.

📌 Ve ürün sahibinin ikinci cümlesi bir **ölçüm** kaydıdır, bir övgü değil:
`Z52 §3`'ün **fiilen işlemesi** — ajanın sahte `PASS` üretmemesi, borç cümlesinin
`01-roles-and-ownership.sql`'de **kendiliğinden** durması — *bu oturumun
**mekanizma-olgunluğunun** sessiz kanıtı.* Yani bir hükmün değeri, **ihlal
edilmediğinde** görülür.

⇒ `K1b` pini **docker-yenileme uygun bir arada** koşulur; **ping'lendiğinde
doğrulanır.**

### `§1` · ORTAM-TANIMI ↔ CANLI-ORTAM AYRIŞMASI — **ilk-deploy ön koşulu**

`B2` (port `5432` ↔ `5434`) ve pinsiz volume **tek sınıftır**, ve adı kondu:

> **"Ortam-tanımı ile canlı-ortam ayrışması, guard'ların göremediği tek yüzeydir."**

Kritik gözlem ürün sahibinin altını çizdiği yerde: **guard'lar `docker exec` kullandığı
için hepsi yeşil kalırdı — kırılan tek şey uygulama olurdu.** İkisi de **bugün
zararsız**, yarın (bir `docker compose up` refleksiyle) **sessiz felaket**.

⇒ Bu, `§ CANLI ORTAM, KURULUM BETİĞİNDEN ÜRETİLEBİLMELİDİR` kuralının **ayna-yarısı**:
**betik de canlıyı tarif etmelidir** — ve ikisi arasındaki **drift'in kapısı yok**.

**Hüküm:** `FAZ1_PLAN §0` madde `4` — *"compose-tanımı ↔ canlı-container eşleşmesi
doğrulanır (port · volume · env)"*. ⚠️ **Sürekli kapı DEĞİL**, deploy-öncesi **tek
seferlik** ölçüm — `[GEREKÇELİ]`: **drift-yüzeyi ancak `compose` kullanımı başlayınca
canlanır.**

### `§2` · `B3`'ün ZAMANLAMA BOYUTU + SELF-TEST'İN SÖZLEŞMESİ

**`a` · Kapı-körlüğü KORELASYONLU olabilir.** `fail-open` taksonomisi bugüne kadar
**yön** ölçüyordu; `B3` bir boyut ekledi:

> **Kör nokta rastgele değil — tehdidin geliş yönüyle AYNI EKSENDE.**
> Evreni daraltan işlem (**bir tablodan yetki çekmek**) = **`RLS`-aktivasyon
> dalgasının yapacağı şeyin ta kendisi.**

`pg_attribute` evrenine geçiş **doğru düzeltmedir** — katalog **yetki filtrelemez**.

**`b` · Üç-meşru-çıktı yasası self-test'lere genişledi.**

> **Bir self-test, kapının DAVRANIŞINI değil SÖZLEŞMESİNİ sınar — sözleşmeye aykırı
> beklenti taşıyan bir self-test, YANLIŞI MÜHÜRLER.**

Vaka: `CASE A` *"boş envanter → `exit 0`"* bekliyordu, yani kapının *"ölçemedim"*ini
*"temiz"*e **yuvarlamasını doğru ilan ediyordu**. Self-test **yeşildi**.

### `§3` · `S3` DESEN OLDU · `S4` STATÜ-DÜRÜSTLÜĞÜ

**`a` · Baseline-artışının reddi ikinci kez aynı biçimde işledi:**

| tur | talep | reddin ürettiği |
|---|---|---|
| `K1a` | `money-float` `114 → 117` | üç `Number(...)` kaldırıldı — biri **gizli sessiz-sıfır** |
| `ADIM 6` | `lint-ratchet` `6 → 8` | `Record<string,any>` → `unknown` · **23 çağrı yeri ölçüldü** · `improved: 6 → 0` · baseline **ayrı commit** |

⇒ **"Artışta kod düzelir" kuralı iki vakada da DAHA DOĞRU KODU üretti.**

**`b` · `S4` — `T-311` ailesine temiz ekleme:**

```
yol var · mekanizma yok     T-311 ailesi
mekanizma var · yol yok     T-314/B        ← ADIM 6
```

⇒ **İkisi de `done` değil, ikisi de ADRESLİ.** *(`T-314/B` → `blocked-unreachable`,
açılma koşulu: **platform rolü `RBAC`'te tanımlandığında**.)*

### `§4` · SIRA — ve **bildirim brief'ine bir ön-hatırlatma**

```
1  BİLDİRİM DİLİMİ    üç olay · in-app · %90-pini  ⇒ K-2.2.7b'nin YÜRÜRLÜK ANI
2  FAZ-1 KAPANIŞ DENETİMİ
     5-halka zincir envanteri (tek sayfa)
     Faz-2 çakıştırma turu (dört-girdili JOIN)
     beş çıkış ölçütünün ÖLÇÜLEREK işaretlenmesi
     Section-10 karantina damgası
     kalan-15 / koşul-satırları tazeliği
```

⛔ **VE BİLDİRİM BRIEF'İ İÇİN ŞİMDİDEN SÖYLENEN TEK ŞART** *(ürün sahibi)*:

> **`%90`-pini DEĞER-pini değil, İLİŞKİ-pini olsun** — *eşik-geçişi olayı*, sabit-sayı
> değil.

📌 `T-296/B2` dersinin **bildirim hali**: bir pin, sabitlediği şeyin **anlamını**
sabitlemelidir — o anlamın bugünkü **sayısal değerini** değil. Eşik konfigürasyondan
gelir (`§2.3`: *"hardcoded threshold YASAK"*); `%90`'ı pinleyen bir test, eşik
değiştiği gün **doğru davranışı kırmızıya** çevirir.

⇒ **`ADIM 6`'nın `Faz-1` payı BİTTİ. Kapanışa iki iş kaldı.**


---

## `Z57` — BİLDİRİM DİLİMİ: İKİ HÜKÜM + BİR **DARALMA-KAYDI**

> **Kaynak:** ürün sahibi, 2026-08-28 · brief: `docs/process/BILDIRIM_DILIMI_BRIEF.md`
> **Statü:** dalga **AÇIK**

### `§1` · `DUR-1` = **(a)** — `budget_policies` **CANLANIR**, ayrım **korunarak**

```
budget_alert_configurations   RENK       (görsel durum)
budget_policies               DAVRANIŞ   (karar-eşiği)
%90-bildirimi bir DAVRANIŞ olayıdır  ⇒  evi DAVRANIŞ tablosudur
```

⛔ **Ve gerekçe *"bugün çakışma yok"*tan DAHA GÜÇLÜ olmalı** — ürün sahibinin kaydı:

> Renk tablosundan okumak, `T-276`'da kapattığımız **katman-karışıklığının**
> (hücre ↔ yüklem) **eşik hâli** olurdu: bugün çakışma yok diye iki katmanı tek
> kaynağa bağlamak, yarın ***"rengi değiştirdim, davranış değişti"*** sürprizini
> üretir.

📌 Yani `DUR-2`'nin çökmesi **(a)**'yı kolaylaştırdı ama **gerekçesini değiştirmedi**:
ayrım `K-2.2.7a`/`K-2.2.8`'in **kendi yapısıdır**, bir çakışma-önlemi değil.
⇒ `İlke 4`'ün (*"aynı olgunun iki temsili ayrışır"*) **tersi** okunmamalı: bunlar
**iki farklı olgu**.

**Ve canlandırmanın kendisi bir yol AÇMIYOR** *(çekincesizliğin ölçümü)*:

> Yazılmış-ama-okunmamış bir kuralı **okunur** kılıyor — `İlke 3`'ün düzeltici
> uygulaması: *"verisi düzenlenemeyen kural fiilen koddur"*un tersi —
> ***"verisi OKUNMAYAN kural HİÇ YOKTUR."***

### ⛔ `§1a` · **ŞART: `T-316` seed düzeltmesi AYNI COMMIT'te**

```
bugün      seed 50/60 · okuyucu 0   ⇒ ZARARSIZ
okuyucu doğduğu an                  ⇒ YANLIŞ-DAVRANIŞ ÜRETECİ
```

> **Örtü kaldırılırken altındaki AYNI COMMIT'te** — kuralın **seed hâli.**

⇒ `budget_policies` `50/60` → **`80/90/100`**, canlandırmayla **tek commit**.

⚠️ **Ve `P1`'in pozitif kontrolü BU VAKAYI hedefler:** *eşik-değiştir → pin-tutar*
testinin **ilk koşumu**, `50/60` dünyasında pinin **ne ölçeceğini** de kayda geçirir.

📌 Bu, ilişki-pininin değer-pinine üstünlüğünün **en somut kanıtı**: bir değer-pini
`50/60`'ı ölçüp **yeşil** derdi; ilişki-pini *"eşik neyse onu"* ölçtüğü için
seed düzeltmesiyle **birlikte doğruyu** ölçer.

### `§2` · `DUR-3` = **(B)** — zamanlayıcı bu dalgada **DOĞMAZ**

Dilim **iki eşik-olayıyla** iner (`%80` · `%90` — ikisi de **istek içinde**).
`7/14`-gün **kendi dalgasında**.

⛔ **Ve gerekçe TERSİNE değil, İLERİ işliyor** *(ürün sahibi düzeltmesi)*:

`2026-08-22`'nin yerleşim gerekçesi (*"zamanlayıcı somut bir iş üstünde
tasarlansın"*) `Z50`'den sonra **zayıflamadı — GÜÇLENDİ**, çünkü `Z50` zamanlayıcıya
**yeni bir tasarım sorusu ekledi**:

```
İSTEKSİZ BAĞLAM   hangi kimlikle?  ·  hangi tenant-döngüsüyle?
                  SET LOCAL'ı KİM sarar?
⇒ K2-turunun "ÖZNESİ YOK" bulgusu artık ÖZNE KAZANIYOR
```

> **Ve o soruların cevabı bir bildirim-dalgasının KENAR-İŞİ olamaz.**

### ⛔ `§2a` · DARALMA-KAYDI — *"çıkarılmadı, ERTELENDİ"*

`2026-08-22` sözleşmesi *"üç olay türü"* diyordu. **İkiye iniyor**, ve
**koşullu-karar disiplinine** göre **adres + tetikleyiciyle** kayda geçiyor:

```
ÜÇÜNCÜ OLAY (7/14-gün)   ÇIKARILMADI — ERTELENDİ
  sağlayıcı    zamanlayıcı-tasarım dalgası
  tetikleyici  O DALGANIN BRIEF'İ
```

📌 **Böylece sözleşme-değişikliği `§2.4`-ihlali olmaktan çıkıp KAYITLI DARALMA
olur.** *(`DISIPLIN`: bir şartın sağlayıcısı yoksa şart bir erteleme değil bir
kilittir — burada **sağlayıcı adlı**, yani gerçekten bir erteleme.)*

### `§3` · ÜÇ NOT — brief'in geri kalanına onay

**`a`** — *"Kullanıcı canlı bir zil görüyor ve o zil hiç çalamaz"* cümlesi
`T-314/B` sınıfının **görünür üyesi** olarak doğru konumlandı; **bu dalganın
gerçek işi zaten bu — zili ÇALAR yapmak.**
⇒ `P4b`'nin gerekçesi (*"dördü de vardı, zincir kopuktu"*) **5-halka envanterinin
BİLDİRİM-HALKASI** olarak **kapanış denetimine** girer.

**`b`** — `DUR-2`'nin **çöküş-dürüstlüğü** `T-321`'i doğru doğurdu.
`%100 BLOCKED`'ın hiç uygulanmamış olması **bildirim işi değil, KONTROL işi**; ve
`SYSTEM_INVARIANTS` satırının **bu dalgada** yazılması (uygulanmamışlık **kayıtlı**
olsun) uzlaşı-mekanizmasının **rutin işleyişi**.
⇒ **`T-321`'in hükmü `Faz-1` kapanış denetimine GİRDİ olarak gelir** —
*"`BLOCKED`-yolu `Faz-1`'de mi `Faz-2`'de mi"*, beş-ölçüt tartışmasının parçası.
⚠️ **Ürün sahibinin ön-eğilimi *(hüküm DEĞİL, denetim günü verilecek)*:**
`%100 BLOCKED` **çekirdek-döngü koruması**; `Faz-1`-artığı olarak **adresli kalır**
ama **inşası kapanışı BLOKLAMAZ**.

**`c`** — `T-316` seed bulgusunun *"pin yeşil geçerdi"* cümlesi `P1`'in
**varlık-gerekçesi** olarak brief'e yazıldı (⇒ `§1a`).

### `§4` · SIRA

```
ŞİMDİ   bildirim dalgası (T-316 ∥ T-317 → T-318 → T-319 · T-321 kayıt)
SONRA   ⛔ FAZ-1'İN SON MADDESİ — kapanış denetimi
        girdilerinin HEPSİ HAZIR:
          5-halka envanteri (BİLDİRİM-HALKASI dahil)
          dört-girdili Faz-2 çakıştırması
          beş ölçütün ÖLÇÜLMÜŞ işaretleri
          T-321 hükmü
          Section-10 karantina damgası
          kalan-15 / koşul-satırları tazeliği
```


---

## `Z58` — `K-2.2.8c` REVİZYONU: **donmuş BRD'nin ÖLÇÜMLE düzeltilen İLK kuralı**

> **Kaynak:** ürün sahibi, 2026-08-28 · ölçüm: `T-316` (`BudgetPolicyService`, canlı katalog)
> **Statü:** `L2_01` `K-2.2.8b` + `K-2.2.8c` **revize edildi** (`F12` izli, `Z1` kayıtlı)

### `§0` · ÖLÇÜM — iddia ve gerçek

```
K-2.2.8c İDDİA   "eşit spesifiklik MÜMKÜN DEĞİLDİR"
ÖLÇÜM            MÜMKÜN
  UNIQUE NULLS NOT DISTINCT(tenant, kanal, kategori) yalnız AYNI tuple'ı engeller
  (kanal=X, kategori=NULL)  ⎫  FARKLI tuple'lar ⇒ İKİSİ DE KURULABİLİR
  (kanal=NULL, kategori=Y)  ⎭
  sorgu (kanal=X + kategori=Y) ⇒ ikisi de spesifiklik=1 ⇒ EŞİT
```

### `§1` · HÜKÜM = **(a)** — kural revize edilir

**`(b)` ELENDİ — öncelik kolonu.** İki gerekçe, ve **ikincisi daha ağır**:
`İlke 1` (ölçülmemiş bir ihtiyaca şema eklemek) — ve daha kötüsü:

> **Eşitliği SESSİZCE ÇÖZÜLÜR kılar** — bugün **açık hata** veren bir belirsizliği,
> yarın **kimsenin fark etmeyeceği** bir tie-break'e çevirir.
> **Belirsizliğin GÖRÜNÜR olması bir kusur değil, `§2.5` disiplininin KAZANCIDIR.**

**`(c)` ELENDİ — "birlikte kurulamaz" kısıtı.** `K-2.2.8b`'nin **harfini** kurtarmak
için `K-2.2.8a`'nın **iki boyutlu tasarım uzayını** daraltır: *"kanal-geneli politika
VE kategori-geneli politika birlikte var olamaz"* demek, **meşru bir konfigürasyon
sınıfını** (kanal-bazlı taban + kategori-bazlı istisna) **kural katmanında yasaklamak**
olur.

> **Kuyruğu kurtarmak için köpeği feda etmek.** *(ürün sahibi)*

**`(a)` KALIR — tek gerçeğe-uyan şık:** kod **zaten doğru davranışı seçmiş** (açık
hata, gizli sıra yok); **kural koda uyar.**

### `§2` · REVİZYON ŞABLONU — üç parça *(ve üçüncüsü olmadan revizyon YARIM)*

```
1  ESKİ CÜMLE ölür, İZİYLE          "eşit spesifiklik mümkün değildir"
                                    → ÖLÇÜLDÜ-yanlış (F12 usulü)
2  YENİ CÜMLE                       eşitlik MÜMKÜNDÜR · sessizce ÇÖZÜLMEZ ·
                                    açık hata · KURULUM-ZAMANI sorumluluğu
3  K-2.2.8b'nin GÜVENCESİ DARALTILIR "DB seviyesinde imkânsız"
                                    → "AYNI TUPLE'ın çift kaydı imkânsız;
                                       kısmi-tuple eşitliği uygulama
                                       seviyesinde açık hatayla yakalanır"
```

### ⛔ `§3` · ÜÇÜNCÜ PARÇA NEDEN ZORUNLU — *"1/3-doğru iddia"nın BRD hâli*

Sapma **yalnız `8c`'de değil, `8b`'nin GÜVENCE-İDDİASINDA da.**

> *"Çakışma **veritabanı seviyesinde imkânsızdır**"* cümlesi, **kapsamadığı bir vakayı
> kapsar gibi okunuyor.**

📌 `Z51`'in *"bir sağlayıcı iddiası ALAN ALAN ölçülür"* (provider `1/3` doğru) dersinin
**BRD tarafındaki hâli**: bir güvence cümlesi **kısmen** doğruysa, okuyucu onu
**tamamen** doğru okur. **İkisini birden düzeltmeyen revizyon YARIM olur.**

### ⛔ `§4` · BİR İLK — **donmuş BRD'nin ÖLÇÜMLE düzeltilen İLK kuralı**

```
2026-08-15  BRD v2 DONDU   (Z1)
o günden beri akış          BRD → kod   (TEK YÖN)
2026-08-28                  KOD → BRD   ← TERS YÖNDEKİ İLK KAYITLI DÜZELTME
```

**Ve tam olması gereken biçimde oldu — dört adım:**

```
1  kod SESSİZCE SAPMADI   §2.5'e uydu, AÇIK HATA fırlattı
2  sapma ÖLÇÜLDÜ          T-316, canlı katalog + pozitif kontrol
3  hüküm KARAR DEFTERİNDEN geçti
4  L2'ye dokunuş          F12 izli · Z1 kayıtlı
```

> **`§2.1.2`'nin *"BRD bir GİRDİdir, kanıt değil"* cümlesi bugüne kadar bir İLKEYDİ —
> artık bir EMSALİ var.**

### `§5` · VE AJANIN **GİZLİ TIE-BREAK YAPMAMASI** AYRICA KAYDA GEÇER

Ajan iki eşit adayla karşılaştı ve **birini seçmedi** — `BUDGET_POLICY_AMBIGUOUS_CODE`
ile **açık hata** fırlattı.

> `§2.5`'in *"iki seçenek arasında rastgele/gizli tie-break yapma"* maddesi
> — *"`if` yazıp `else` bırakmama"nın kardeşi: **belirsizliği sessizce çözme*** —
> **tam da bu an için var.**

📌 Ve sonuç zinciri buna bağlı: ajan sessizce bir tarafı seçseydi **sapma hiç
ölçülmezdi**, `K-2.2.8c` yanlış hâliyle **kalırdı**, ve bir gün iki kısmi politika
tanımlayan tenant **sessizce yanlış eşikle** çalışırdı.
**Bir disiplin kuralının değeri, ONA UYULDUĞU İÇİN ORTAYA ÇIKAN BULGUYLA ölçülür.**

### `§6` · Ek kayıt — `information_schema` refleksi, **vaka sayaca**

Team Lead, `app_runtime`'ın `budget_policies` grant'ını `information_schema.
role_table_grants` ile sorguladı, **0 satır** aldı ve *"grant canlı değil"* diyecekti.
`db-query.sh` `app_operator` ile bağlanıyor; o rol grant'ın tarafı **değil** ⇒ görünüm
**filtreliyor**. `has_table_privilege` → **`t`**. **Ajan doğruydu, ölçüm yanlıştı.**

⛔ Ve bu, **iki dalga önce `new-table-rls.sh`'te kapatılan tuzağın ta kendisi**
(`K1a` review `B3`). Kuralı yazan ve kapıyı düzelten kişi **yine refleksle** o görünüme
uzandı.

> `DISIPLIN`: *"kuralı hatırlamak yerine **ARACI** çağır"* — **bir refleks üretmeyen
> kural, yazılmış olmakla korunmuş olmaz.**


---

## `Z59` — BİLDİRİM ALICI HÜKMÜ: `K-2.2.7c`'nin **BİLDİRİM KATMANINA GENELLENMESİ**

> **Kaynak:** ürün sahibi, 2026-08-28 · bulgu: `T-318` (canlı regresyon, mutasyonla kanıtlı)
> **Statü:** `(1)` + `(2)` **ONAYLI** · `(3)` **REDDEDİLDİ**

### ⛔ `§0` · KARAR ZİNCİRİNİN TEK CÜMLESİ

> **Bu vaka, `K-2.2.7c`'nin (*"aşımda bile süreç durmaz"*) BİLDİRİM KATMANINA
> GENELLENMESİDİR:**
> **Para yolu, hiçbir türev yan-etkinin REHİNİ olamaz — ama hiçbir türev yan-etki de
> SESSİZCE ÖLEMEZ.**

📌 **İki ilkenin kesişimi tam `(2)`'nin şeklini veriyor.** `(3)` (izole et) o kesişimin
**yalnız birinci yarısını** sağlıyordu; `T-318`'in indiği hâl (hard throw) yalnız
**ikinci** yarısını.

### `§1` · BULGU — ölçüm, ve iki maskeleme

```
budget_envelopes.budget_owner_id     4/4 NULL   (POZ.KONTROL: tenant_id 4/4 · name 4/4)
SAĞLAYICI (dört yüzey, poz. kontrollü)
  backend src 1 (OKUMA) · test 0 · frontend src 2 (TİP BEYANI) · seeds 0
  POZ.KONTROL allocatedAmount        30 / 14 / 26 / 7
```

⇒ **Canlı bir para yolu, ÜRÜNDE HİÇBİR YAZICISI OLMAYAN bir alana bağlandı.**

**Patlama yarıçapı** `790/790` → **`788/790`**, ve **mekanizma mutasyonla kanıtlandı**
(tier AÇIK → 2 FAIL · tier KAPALI → 2 PASS, `103/103`).

⚠️ **İkinci maskeleme:** ajan **bir** düşüş raporladı (iki spec dosyası koşmuştu); tam
suite **ikincisini** (`role-journey C9c`, `CANCEL`→release) gösterdi.
⇒ `DISIPLIN`: *"kapsam maskelemesi — desen çalışır, **EVREN eksiktir**."*

### `§2` · `(2)`'NİN HÜKMÜ — **"GÖRÜNÜR FALLBACK" TANIMIYLA**, üç katman

Owner yoksa `WARNING` alıcısı **`FINANCE`'e düşer**, ve görünürlük **üç katmanda**:

```
a  BİLDİRİM GÖVDESİNE   FINANCE'e giden mesaj "bütçe sahibine (TANIMSIZ)
                        yönlendirilemedi" bilgisini TAŞIR
                        ⇒ alıcı, FALLBACK-ALICISI OLDUĞUNU BİLİR
b  LOG'A                yapılandırılmış uyarı (kontrol-ailesi taraması SAYABİLSİN)
c  last_notified_tier   NORMAL İŞLER — fallback tekrar-bastırmayı BOZMAZ
```

⛔ **`(a)` asıl satırdır:** sessiz-fallback'i görünür-fallback yapan şey **log değil,
ÜRÜN YÜZEYİNDE görünürlüktür.** *(Bir log satırı kullanıcıya ulaşmaz; bildirimi okuyan
kişi, adresin kendisi olmadığını **bilmelidir**.)*

📌 **Ve fallback KEYFÎ DEĞİL:** `FINANCE`, `%80` uyarısının **doğal alıcısı**
(`K-2.6.4` tenant-genel-finans).

> **Bu, *"en az yanlış adres"* değil — *"İKİNCİ-DOĞRU adres."***

### `§3` · `(1)`'İN HÜKMÜ — üç parça, ve **`İlke 1` SINIRIYLA**

⛔ **`budgetOwnerId` create/split akışında OPSİYONEL KALIR — ZORUNLU OLMAZ.**

> Zorunlu kılmak, **bugün hiçbir formun taşımadığı** bir alanı bir gecede **her
> zarf-yaratma çağrısının kırılma noktası** yapar — `T-306` dersinin **tersi**:
> **yol açmadan zorunluluk koymak.**

```
a  frontend formuna ALAN GELİR      opsiyonel, kullanıcı-seçer
b  seed'ler DOLDURUR                4/4-NULL ölür; mevcut dört zarf backfill'le
                                    owner kazanır
c  "OWNER'SIZ ZARF" MEŞRU-TANIMLI   ve cevabı (2)'dir
   durum olarak KALIR
```

> **`(1)` *"asla boş olmaz"*ı VAAT ETMİYOR. Vaat edilen: boşluk artık
> TASARLANMIŞ BİR DURUMDUR, kaza değil.**

**Backfill sahibi** *(Team Lead cevabı, `Z59` kaydına)*: **`category.manager@wella.com`**
— zarf kanal+kategori kapsamlı, harcamanın sahibi kategori yöneticisi; **ve `FINANCE`
DEĞİL**, yoksa owner-yolu ile fallback-yolu **aynı alıcıya** düşer ve pin ikisini
**ayırt edemez** (`DISIPLIN`: *fixture, ayırt etmek istediği iki tarafta FARKLI değer
taşımalı*).

### `§4` · ÇERÇEVE DÜZELTMESİ — genelleme geri alınmaz, **SINIRI YAZILIR**

| yol | hüküm |
|---|---|
| **`FINANCE`** | *"boş küme → açık hata"* **DOĞRU KALIR** — tenant'ta `FINANCE` yoksa bu bir **kurulum hatasıdır**, sistem zaten çalışamaz; hata **meşru** |
| **`WARNING`** | **hard-throw ÖLÜR**, `(2)` gelir |

### ⛔ `§4a` · VE BİR AYRIM `DISIPLIN`'E — **üretken-genelleme ≠ doğru-usül**

Ajanın genellemesi **üretkendi**: boşluğu **o görünür kıldı**.
**Ama usül yanlıştı:** brief `WARNING` için bunu istememişti.

> **Kapsam-genişleme teklifi disiplini (ÖLÇ + DUR) burada da geçerliydi — ve
> `throw` YAZMAK yerine `DUR`'a düşmek doğru davranış olurdu.**

📌 Fark önemli, çünkü ikisi **karıştırılabilir**: bir genişletmenin **iyi bir şey
bulması**, onu **yetkili** yapmaz. Bulgu kalır, usül kaydedilir.

### `§5` · İKİ ŞART

**`(i)` `T-322` BU DALGAYA BİNER — aday kalmaz.**
`NotificationRepository.create` dış-transaction `manager`'ını **almıyor**, ve bu
**tam da bu dalganın inşa ettiği yolun üstünde**: tier-bildirimi `RESERVE`/`COMMIT`
tx'inin **içinden** doğuyor ⇒

```
rollback-olan-reserve'den GERİDE KALAN bildirim
  = YANLIŞ-POZİTİF finansal uyarı
  ⇒ "500'DEN SİNSİ" ailesi
```
Bildirim yazımı **tx-manager'a bağlanır**; `T-047`/`SP-E2E` pinleri patlama yarıçapını
zaten ölçüyor.

**`(ii)` İKİ-SUITE-DÜŞÜŞÜNÜN İKİSİ DE KAPANIŞ PİNİNE GİRER** — `split` yolu **ve**
`CANCEL`→`release` yolu. Ajanın tek-suite bulgusu **"kapsam maskelemesi"** olarak
kayıtlı; pin **her iki yolda** yeşili kanıtlar.


---

## `Z60` — **BİR GEREKÇE, DAYANDIĞI ÖLÇÜMÜN TARİHİYLE YAŞAR**

> **Kaynak:** ürün sahibi, 2026-08-28 · bulgular: `Z59` dalgası
> **Statü:** iki bulgu, **tek yasa** — ve `T-323` hükmü (`§0`)

### `§0` · `T-323` HÜKMÜ = **(a)**, tek genişletmesiz

**Zarf yaratabilen bir rol, bütçe sahibi ATAYAMAZ.** Ve bu bir kusur değil:

> Atama, **kullanıcı-listesi görme** yetkisi ister; kullanıcı-listesi
> **`USER_MANAGE`**'in işidir (`Z20`'nin dünyası). *"Zarf yaratmak"* ile
> *"kişi-dizinine erişmek"* **iki ayrı yetki sorusudur**, ve ikisini birleştirmek
> `K-2.6.4a`'nın gerçek cümlesinin ihlali olurdu — *"rol adres defteri değildir"*in
> **tersi:** ***adres-defteri de rol değildir.***

`(b)` (`GET /users/selectable`) **elendi**: ölçülmemiş bir ihtiyaca **yeni rota + yeni
hücre** (`İlke 1` + `Z42` kalemi maliyeti).
⛔ **KOŞUL SATIRI:** *ihtiyaç kanıtı gelirse* — **gerçek bir tenant'ta `FINANCE`
*"owner atayamıyorum"* derse** — o gün **`Z42` usulüyle** açılır.

📌 Ve `Z59 §3c` bunu zaten hazırlamıştı: *"owner'sız zarf **meşru-tanımlı** bir
durumdur"* + `FINANCE`'in **fallback alıcılığı** ⇒ `FINANCE`/`PLANNER`'ın owner
atayamayışı **o hükmün doğal sonucu**.

**Ve UI düzeltmesi hükmün doğru tamamlayıcısıdır:** *"yetkin yok ≠ kimse yok"*
ayrımının **görünür** olması, **boş-açıklamasız-seçici** sınıfını kapattı —
`§2.7`'nin *"verinin yokluğu örter"* maddesinin **UI hâli**.

---

### ⛔ `§1` · YASA — ve bu kayıt onu ADLANDIRMAK için var

> **BİR GEREKÇE, DAYANDIĞI ÖLÇÜMÜN TARİHİYLE YAŞAR — VE O ÖLÇÜMÜ DEĞİŞTİREN TUR,
> GEREKÇENİN OKUYUCUSUDUR.**

İki bulgu bu yasanın **iki yüzü**.

### `§2` · BİRİNCİ YÜZ — **İSTİSNA KALKMADI, İSTİSNANIN ÖNCÜLÜ KALKTI**

`02-runtime-grants.sql` şu gerekçeyi **yazılı** taşıyordu (`T-249`):

```
"INSERT BİLEREK VERİLMEDİ: createNotification'ın hiçbir üretim çağıranı yok"
```

⛔ **Ve `Z59` dalgasının YAPTIĞI ŞEY tam olarak o çağıranı YARATMAKTI.**
Gerekçe **çürüdü**; dalga onu **okumadı**. İlk e2e `permission denied for table
notifications` ile **500** verdi.

📌 Bu, *"istisna kalkınca ona yaslanan kararlar yeniden okunur"* kuralının
**ters-yön vakası**: burada **istisna kalkmadı** — ***istisnanın ÖNCÜLÜ kalktı.***

**⇒ TARAMA ŞARTINA TEK SATIR:**
> **Yeni bir üretim-çağıranı DOĞURAN dalga, o yolun üstündeki tüm
> *"çağıran-yok"*-gerekçeli kararları TARAR.**
> `grep`-sınıfı iş: `T-249|çağıran yok|no caller` — **`GRANT`'lar ·
> guard-muafiyetleri · ölü-kod kayıtları.**

**Ve guard yakalamadı:**
`app-runtime-grants` *"okuyor ama **YAZAMIYOR**"* ayrımını **görmüyor** — kapının
**kendi belgelediği ikinci sınırı**.

> **Bir kapının kör noktası, komşu kapının görev tanımıdır — ta ki YAZILANA KADAR.**
> Yazılana kadar komşu-kapı **e2e** oldu, ve **gördü**.

⇒ **`GRANT`-yön-ayrımı** (`SELECT`/`INSERT`/`UPDATE`/`DELETE` bazında **beklenen
matris**) `T-314`'ün **`GRANT`-drift kalemiyle BİRLEŞİR** — aynı iş, **tek kapı**:

```
beklenen GRANT matrisi   KARAR-KAYITLI
canlı GRANT'lar          katalogdan
fark                     KIRMIZI
```
📌 `Z51` sınıfının (**kayıtsız sapma**) **kalıcı çözümü**.

### `§3` · İKİNCİ YÜZ — **`T-047` EVRENİ, KENDİ BELGELEDİĞİ KÖRLÜĞÜ TEKRARLADI**

```
Z59 dalgası → notifications'a İLK üretim yazıcısı
tam e2e     → 16 satır ARTIK           T-047 invariant: YEŞİL ✅
sebep       → countRows() ELLE YAZILMIŞ 7 tablo sayıyor
```

⛔ **İkinci kez** — ve **ilkini dosyanın KENDİ yorumu kaydediyor**
(`e2e-row-count.js:84-90`, `T-060`): *"`approval_requests` 9.116 satır, `plans` 0 —
invaryantın **bütün bir tabloya kör** olduğunun kanıtı."*

⇒ **`G5` ailesinin** (*"yazılmış evren < taranmış < türetilmiş"*) **invariant hâli.**

⛔ **VE *"NOTIFICATIONS EKLE"* GERÇEKTEN YANLIŞ DÜZELTMEYDİ** *(ürün sahibi)*:

> **Sekizinci tablo, DOKUZUNCUNUN körlüğünü hazırlardı.**

⇒ Evren **katalogdan TÜRETİLİR** (tüm `main.*` tabloları) — **böylece bu sınıf
ÜÇÜNCÜ KEZ DOĞAMAZ.** `T-060` yöntemi (`T-319` acceptance'ında, **reprodüksiyon
şartıyla**): tam bir e2e koşumunun **hemen öncesi ve sonrası** her tablo sayılır;
delta'sı sıfır olmayan **her** tablo raporlanır — **tahmin edilmez, ÖLÇÜLÜR.**

⚠️ Ve türetme **`information_schema`'dan DEĞİL, `pg_catalog`'dan**: bu görünüm
**yetki filtreler** ve o tuzak bu oturumda **iki kez** çarptı (ikincisi Team Lead'e).

### ⛔ `§4` · VE ÜÇÜNCÜ BİR VAKA — **KARAR ÖNCE İNER, UYGULAMA SONRA BAŞLAR**

Team Lead `Z59`'u **yazdı**, task'ları açtı, **iki ajanı başlattı** — ve kaydı
**commit etmedi**. `push-order.sh` *"commit edilmemiş değişiklik"* kapısıyla
**durdu ve yakaladı**.

**Kapının yakalaması tam amaçlanan işleyiştir. Ama vakanın SINIFI kayda değer:**

```
hüküm UYGULANIRKEN karar defterinde COMMIT'Lİ DEĞİLDİ
⇒ ajanlar, ORIGIN'DE VAR OLMAYAN bir hükmün uygulayıcısıydı
⇒ push-order sonunda yakaladı — ama PENCERE BOYUNCA İKİ DALGA o hükümle KOŞTU
```

> *"Karar önce iner, uygulama sonra başlar"* bugüne kadar **örtük** disiplindi.
> **Bu vaka onu AÇIK KURAL yapıyor** — dalga-açma öncesi **tek soru:**
> ***"Hükmün kaydı commit'li mi?"***

📌 Ve bu, `§1`'in yasasının **kendi üstüne katlanmış hâli**: bir gerekçe **ölçümünün
tarihiyle** yaşıyorsa, bir **hüküm** de **kaydının tarihiyle** yaşar.


---

## `Z61` — `T-324`: **ÖLÇEN ŞEYİN EVRENİ, ÖLÇÜLEN ŞEYİN YETKİSİNDEN GENİŞ OLMALI**

> **Kaynak:** ürün sahibi, 2026-08-28 · **Statü:** `(a)` **ONAYLI** · `(b)` **REDDEDİLDİ**

### `§1` · HÜKÜM ve TAM GEREKÇE

> **Sayım bağlantısı bir ÖLÇÜM-HARNESS'IDIR, ürün-yolu DEĞİL.**
> `K-2.6.13`'ün ayrımı (*"`app_runtime` = uygulamanın kimliği"*) **harness'ı
> BAĞLAMAZ** — çünkü harness **uygulama değil, uygulamayı ÖLÇEN şeydir.**
>
> ⛔ **VE ÖLÇEN ŞEYİN EVRENİ, ÖLÇÜLEN ŞEYİN YETKİSİNDEN GENİŞ OLMAK ZORUNDADIR** —
> yoksa **tam bu vaka doğar:** kapı, **uygulamanın GÖREMEDİĞİ yerde doğan artığı
> göremez.**

`app_migrate` ile `count(*)`: **yapı gereği SELECT-only** (yazma yolu yok) ⇒ risk
profili **sıfıra yakın**.

### `§2` · `(b)`'NİN REDDİ — ve cümlesi `DISIPLIN`'e

> **ÖLÇÜM KOLAYLIĞI İÇİN ÜRETİM YETKİSİ GENİŞLETİLMEZ.**

📌 **Sınıf tekrar gelecek:** her yeni kapı *"`app_runtime`'a şu `GRANT`'ı verelim
mi?"* sorusunu doğurabilir. **Cevap hep aynı: hayır — harness KENDİ ROLÜYLE ölçer.**

### `§3` · EK ŞART — *"muhtemelen" BİR HÜKÜM DEĞİLDİR*

*"`app_runtime` `claims`'i okuyamıyor"* bir **not olarak kalamaz** — sınıflandırılır:

```
backend'de bu tabloya bir repository/entity VAR MI?
  VAR + GRANT YOK  →  ⛔ GERÇEK KUSUR (T-306 sınıfı: İLK ÇAĞRIDA PATLAR)
  YOK              →  "port-bekleyen, GRANT portuyla gelir" KAYDI
```

⚠️ Ürün sahibinin ön-görüsü (`claims` ailesi **port-adayı** ⇒ muhtemelen ikinci sınıf)
**bir hüküm değil, bir hipotezdir** — ve on dakikalık bir `grep` iki sınıfı ayırır.

📌 **Kaydın işlevi GELECEĞE dönük:** `claims` portu geldiğinde `GRANT`'ın **o dalganın
checklist'inde** olması **bu kayıtla garanti olur** — `Z60 §2`'nin dersi:
*yeni-çağıran-doğuran dalga, `GRANT`-gerekçelerini tarar.*

### `§4` · `Z60 §1` **YAZILDIĞI GÜN İKİNCİ VAKASINI ÜRETTİ**

```
Z60 §1 yazıldı        "ölçümü değiştiren tur, gerekçenin okuyucusudur"
aynı gün, T-319       evreni değiştirdi · gerekçeyi OKUMADI
aynı dosya            e2e-row-count.js
```

> **Bu, kuralın GEÇ değil TAM ZAMANINDA yazıldığının kanıtıdır.**

### `§5` · MANŞET DÜZELTMESİ — `Z58 §3` disiplininin doğru uygulaması

`e2e-row-count.js` **manşetinde** *"böylece bu sınıf ÜÇÜNCÜ KEZ doğamaz"* diyor,
**12 satır sonra** *"o tablolara yeni bir yazıcı gelirse YİNE kör kalır"* diyordu.

> **Teslim edilmeyen MANŞET, teslim edilen DAR İDDİADAN tehlikelidir — çünkü okuyucu
> MANŞETİ okur.**

### `§6` · `39/48` DOĞRU STATÜDE — *"bitti-VE-kalan-şuradadır"* GRAMERİ

```
ilerleme GERÇEK    elle-liste ÖLDÜ · evren TÜRETİLDİ · reprodüksiyon KARŞILANDI
hüküm YARIM        9 tablo KÖR
yarımlık ADRESLİ   T-324 kapatacak
```
📌 Bu gramerin **kapı ölçeğindeki** hâli.

### `§7` · BİLDİRİM DİLİMİ **TAMAM** — halka satırı kabul edildi

> **"Zil çalıyor. Kanıtı: `P1`–`P4b` + iki-yol pinleri, mutasyon-kanıtlı,
> `P4b` mock'suz."**

**Ve açılış↔kapanış mesafesi kayda değer:**

```
üç hafta önce   canlı zil · SIFIR çağıran · tablo/servis/kanal/UI VARDI, ZİNCİR KOPUKTU
bugün           üç-dünyalı ilişki-pini · tx-güvenli yazım
                görünür fallback · tekrar-bastırma
⇒ K-2.2.7b YÜRÜRLÜKTE
```

### `§8` · SIRA

```
1  T-324 dalgası   rol-dönüşü + 48/48 pini + dokuz-tablo sınıflandırması  (küçük)
2  ⛔ KAPANIŞ DENETİMİ — TEK OTURUM
     beş ölçütün ÖLÇÜLEREK işaretlenmesi
     5-halka envanterinin MÜHÜRLENMESİ  (bildirim halkası dahil)
     dört-girdili Faz-2 çakıştırması
     Section-10 karantina damgası
     kalan-15 / koşul-satırları tazeliği
     T-321 hükmü (beş-ölçüt masasında) · T-324 sonucu
     ⇒ FAZ-1'İN KAPANIŞ BEYANI
```


---

## `Z62` — `FAZ-2` AÇILIŞ PAKETİ: SÜZGEÇ + BEŞ HÜKÜM + ÜÇ-KAYNAKLI EŞLEME

> **Kaynak:** ürün sahibi, 2026-08-28 · brief: `docs/process/FAZ2_PLANLAMA_BRIEF.md`
> **Statü:** `Faz-2` **AÇIK** · `W0` başlatıldı

### ⛔ `§0` · `FAZ-2` SÜZGECİ — **tüm yerleşim kararlarına uygulanır**

```
TEK-TENANT + İLK-MÜŞTERİ-DEĞERİ ÖNCELİKLİDİR.
Ölçek-hazırlığı kalemleri TAKVİMLE değil, OLAY-TETİKLİ KOŞUL SATIRIYLA yaşar
  — sağlayıcı + tetikleyici YAZILI.
```

📌 Bu, `İlke 1`'in (*"spekülatif esneklik"*) **faz ölçeğindeki** hâli — ve
`W2`-kovalarının **`Faz-2`-şart / aday / `Faz-3`** yerleşimi **bu süzgeçle** yapılır.

⚠️ Ve süzgeç bir **erteleme aracı değil**: bir kalem *"koşul satırı"*na düştüğünde
**sağlayıcısı ve tetikleyicisi adlandırılır** — aksi hâlde `DISIPLIN`'in
*"sağlayıcısı yoksa şart bir erteleme değil bir **KİLİTTİR**"* maddesi işler.

### `§1` · BEŞ HÜKÜM

| # | kalem | hüküm | sağlayıcı / tetikleyici |
|---|---|---|---|
| `2a` | `FINANCE` ayrışması | **(c) koşullu** | sağlayıcı: **ikinci-müşteri onboarding** · tetikleyici: **`RLS`-aktivasyon brief'i** ⇒ **`Faz-2` listesinde DEĞİL** |
| `2b` | `T-292` `DEĞİŞTİR`/`ONAYLA` | **(b) tasarım-girdisi** | motor inerken `L2`'ye **`Z`-kayıtla** |
| `2c` | `T-321` `%100 BLOCKED` | **(a) `Faz-2` `W1`** | ⛔ **ŞART:** pin **iki-eksen ayrımı** taşır ↓ |
| `2d` | `+CM` / `T-304` | **(b) alt-küme** | **Dilim-1** = `+CM×3` + `T-306` + davranış-pinleri |
| `2e` | idempotency köken segmenti | **ÖLÇÜM-ÖNCE** + **(b)** | ölçüm *"evet"* derse **(a) açılır** |

#### ⛔ `2c`'nin ŞARTI — pin **iki ekseni AYIRT ETMELİ**

```
BLOCKED   =  yeni-RESERVE GİRİŞ-REDDİ          ← eşik davranışı
K-2.2.7c  =  MEVCUT SÜREÇ DURMAZ               ← hakediş tarafı
```
📌 İkisi karıştırılırsa `%100` kapısı **hakediş akışını durdurur** ve
`K-2.2.7c`'yi (*"borç doğmuştur, bütçe onu geçersiz kılamaz"*) **ihlal eder**.
⇒ Pin **iki girdi, iki çıktı** ile bunu ayırmalı; ayıramıyorsa **yazılmaz**.

#### `2e`'nin ölçümü — hüküm istemeden yapılabilir
> *"İki farklı yükleme yolu **aynı** idempotency anahtarını üretebilir mi?"*
> **`K6b` test vakası** girdi olarak verildi. Ölçüm *"evet"* derse şema kalemi `(a)` açılır.

### `§2` · KPI EVRENİ — **`Section_05 §5.3` KANONİK, GRUPLAR (`42`)**

Başlık *"40 KPIs"* ↔ gruplar `2+4+3+8+11+6+5+3 = 42`.
⇒ **Gruplar kanonik**, çünkü *"bir sayı **listesiyle** anılır ya da **hiç** anılmaz"*.
**Başlık-`40`'ın `F12`'si `W2`'de** yazılır.

### `§3` · SIRALAMA — üç düzeltme **KABUL**

```
W0  KPI TEMİZLİĞİ      6 e2e artığı + üreteç + T-047 teyidi     ← BAŞLADI
W1  SENARYO            yedi spec · AYIRT-EDİCİ ZORUNLU · +T-321 (2c)
W2  ÇİFT DALGA         KPI eşleme  ∥  T-293 + T-291
W3  BASELINE           D3 → D2/D4 → yüzey
W4  <500ms ÖLÇÜM       ⛔ Faz-2-ŞART SETİ TAM İNİNCE
```
⚠️ `W4`'ün koşulu **değişti**: *"eşlemeden sonra"* değil — ***"`Faz-2`-şart seti tam
inince"***. Gerekçe: ölçüm, **inen her KPI'la** değişir; yarım sette ölçmek **iyimser
ve yanıltıcıdır**.

### `§4` · SENARYO FORMATI — `AYIRT-EDİCİ` **zorunlu** + **`DEMO-DEĞERİ` opsiyonel**

`DEMO-DEĞERİ` **yeni bir alan**: bir senaryonun **gösterilebilir** olup olmadığı.
📌 Süzgecin (*"ilk-müşteri değeri"*) senaryo tarafındaki karşılığı.

### ⭐ `§5` · YENİ GİRDİ — `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md`

> ⚠️ **`F12` — REVİZE EDİLDİ (2026-08-30, `Z65 §4`).** Bu bölüm karşılaştırma
> tabanını *"Excel"* diye okutuyordu. **Doğrusu:** taban **BRD-`A1` `52`** (kalem
> LİSTESİ buradan); **Excel = FORMÜL-KANIT KAYNAĞI, evren DEĞİL.**
> *(Aşağıdaki metin **silinmedi** — append-only izi.)*

**`W2` eşlemesi artık ÜÇ-KAYNAKLI:**
```
Excel ~60 kalem (FORMÜLLÜ)  ↔  BRD §5.3  42  ↔  canlı ÜRÜN  24 aktif
                                Excel muhtemelen BRD listesinin ATASI
```

| bölüm | `Faz-2`'deki yeri |
|---|---|
| **`§6` beş soru** | ⛔ **cevaplanmadan eşleme KAPANMAZ** — `NIV` grubunun düşüşü bilinçli miydi · sell-in/sell-out ayrımı · `ROI` paydası `TTS` · *"Excl. BMI"* · mekanik-değerinin `SKU` düzeyi |
| **`§2` tactic tablosu** | **`EK_E` referansı** |
| **`§3` agregasyon işaretleri** | **kabul kriteri** |
| **`§7` üç senaryo tohumu** | **`W1`**'e |
| **`§4` fark tablosu (6 kalem)** | **süzgeçten** geçirilir |
| `T-293`+`T-291` pini | **LTA taban zincirini** ölçer |

⚠️ Ve zamanlayıcı-müşteri listesine **`Ongoing`/`Complete`** eklendi.

📌 **`§6 soru-1` özellikle ağır:** `NIV` grubu Excel'de **var**, `BRD-42`'de **yok** —
ve `NIV` off-invoice hesabının **tabanı**. Cevap *"bilinçli düşüş değil"* ise
**`42` sayısı da eksik** demektir ⇒ evren **üçüncü kez** düzelir.

### `§6` · İLK COMMIT'LERE

```
1  BEYAN DÜZELTME NOTU   33/30 → 24/27   (append-only, mühür BOZULMAZ)
2  BRD 40 → 42 F12       W2'de
```


---

## `Z63` — `T-329`: TAKVİM-AYI NORMALLEŞTİRME + iki `DISIPLIN` kaydı

> **Kaynak:** ürün sahibi, 2026-08-29 · **Statü:** `(c)` **ONAYLI**, üç şartla

### `§1` · HÜKÜM `(c)` — ve gerekçe **ürün tarafından**

> *"Aylık trend"* kavramsal olarak bir **takvim-ayı** sorusudur: kullanıcının sorduğu
> şey ***"Şubat'ta ne harcandı"***tır — *"31 Ocak'tan 28 Şubat'a kayan pencerede ne
> harcandı"* değil.
>
> **`(a)`/`(b)` taşmayı düzeltir ve kayık pencereyi KORUR — teknik-doğru, ÜRÜN-YANLIŞ.**

⭐ **Ve bağımsız bir dış teyit var:** demo-Excel'in `Fund Utilization Report` kova
yapısı **`Jan` / `Feb` / `Mar` kolonları** — **atadan gelen model de takvim-ayı.**
📌 `DISIPLIN`: *"en iyi kontrol, BAĞIMSIZ BİR KAYITLA ÇAKIŞTIRMADIR"* — hüküm bir
sezgiden değil, **iki kaynağın kesişiminden** çıktı.

### `§2` · ÜÇ ŞART

```
i   KOVA TANIMI     etiket = TAKVİM AYI · sınırlar ayın 1'i
                    uç kovalar KISMİ olabilir ve bu MEŞRU
                    (15 Ocak'ta başlayan sorgu → Ocak kovası 15-31'i kapsar,
                     etiketi yine "Ocak") ⇒ BELGEYE TEK CÜMLE
ii  PİN             İLİŞKİ-PİNİ, tarihten BAĞIMSIZ:
                    ay-sonu başlangıçlı DÖRT vaka (28/29/30/31) parametrik
                    + "her ay TAM BİR KEZ"
                    + ⛔ MUTABAKAT SATIRI: "toplam = kovaların toplamı"
iii YERLEŞİM        düzeltme add-months.ts ailesinde DEĞİL, KOVA ÜRETİMİNDE
                    yardımcı GENEL kalır; takvim-ayı normalleştirme
                    RAPORUN semantiğidir
```

⛔ **`(ii)`'nin mutabakat satırı özellikle önemli:** Şubat-kaybı vakasında **toplam da
kayıyordu**. Bir mutabakat pini **birikimli-sapma sınıfını kalıcı olarak** yakalar —
tek tek kova kontrolü yakalamayabilir.

📌 **`(iii)`'ün gerekçesi ileriye dönük:** yarın *"haftalık trend"* gelirse **aynı
yardımcı farklı normalleştirmeyle** kullanılır. Yardımcıya semantik gömmek onu
**tek raporun esiri** yapardı.

### `§3` · İKİ `DISIPLIN` KAYDI

**`a` · ZAMANA BAĞLI KUSURUN TESTİ, KUSURUN UYKUDA OLDUĞU GÜNLERDE YAZILDIYSA YEŞİLDİR**

Ajanın ölçümü: kusur ayın **1–28**'inde doğru, **29–31**'inde yanlış ⇒ sözleşme testi
**ayda ~3 gün uyanık, ~28 gün kör**. `2026-08-29`'da **kod değişmeden** kırmızıya döndü.

> **`"Flaky"` etiketi yapıştırmadan önce sinyalin TAKVİM DESENİNE bakılır.**

⇒ Ve bu, **`T-290` flaky kuyruğu için bir OKUMA ANAHTARI**: oradaki her vaka
*"aralıklı"* diye kayıtlı — **aralığın takvimle mi yükle mi ilişkili olduğu
sorulmamış.**

**`b` · KUSUR-BELGELEME YATIRIMININ İLK ÖLÇÜLEBİLİR GETİRİSİ**

Ajan ikinci, daha sessiz bir kusuru (**okuma yerel `getMonth()` / yazma UTC
`toISOString()`**) yakaladı — ve **tanıdı**, çünkü `excel-serial-date.ts`'in
docstring'i **aynı gün-kaymasını ölçümleriyle** kaydetmişti.

> **Belgelenmiş eski bir kusur, yeni bir kusurun TEŞHİS HIZLANDIRICISI oldu.**

📌 Bu proje üç haftadır kusurları **gerekçeleriyle** belgeliyor; bu, o yatırımın
**ilk ölçülebilir getirisidir**.

### `§4` · SIRALAMA — `W1` önce, `T-329` sonra *(Team Lead `touches` ölçümü)*

```
DOSYA KESİŞİMİ      finance-reporting ∩ budget = ∅ · test/ ikisi de YENİ dosya
                    ⇒ touches disjoint
⛔ ÜÇÜNCÜ ŞART      DOĞRULAMA İZOLASYONU — SAĞLANMIYOR
                    T-325 (e2e tek-çalıştıran kilidi) HENÜZ YOK
                    ikisi de TAM e2e koşuyor · DB PAYLAŞILIYOR
```

⇒ **SIRALI.** `§4`'ün kendi kuralı: *"`touches` kesişimi GEREKLİ ama YETERLİ DEĞİL —
ağaç PAYLAŞILIR."* Burada paylaşılan şey ağaç değil **veritabanı**, ve sonuç aynı.


---

## `Z64` — `W2` ÇİFT DALGA: üç hüküm + **`A0'` keskinleştirmesi**

> **Tarih:** 2026-08-30 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `docs/process/W2_CIFT_DALGA_BRIEF.md` (`A0` · `B0` ölçümleri)

### `§1` · ÜÇ HÜKÜM

| # | hüküm |
|---|---|
| 1 | **`A0'` ÖNCE** — ama sorusu **değiştirildi** *(§2)* |
| 2 | **PARALEL İNİŞ ONAYLI** — `A` analiz+`F12`+rapor (**e2e yok**) ∥ `B` kod dalgası |
| 3 | **MİGRATION `1817000000000`** `DALGA-B`'ye tahsis edildi *(numara-tahsisi Team Lead defteri)* |

### `§2` · ⛔ `A0` YARIM ÖLÇÜMDÜ — **soru "NIV ≡ TO mu?" değil, "CANLI-TO HANGİSİ?"**

Team Lead'in `A0` bulgusu (*"`NIV` kodda `TO` adıyla var"*) **doğruydu ama yarımdı.**
Ürün sahibi migration metnini Excel sözlüğüyle **yan yana** koydu:

```
canlı  PLANNED_TO = GSV − ON_INVOICE_SPEND   ≡ Excel PlannedNIV (GSV − TotalSpendOn)
canlı  BASE_TO    = GSV − LTA_ON             ≡ Excel BaseNIV    (GSV × (1−LTAOnPct))
Excel  PlannedTO  = GSV − PlannedPromoTotalSpend    ← ON+OFF birlikte — BAŞKA KAVRAM
```

⇒ **Canlıdaki `TO`, Excel'in `NIV`'idir.** Excel'in **gerçek `TO`**'su (off-invoice de
düşülmüş net ciro) canlıda **hiç olmayabilir**.

⛔ **Sonuç hükmü:** *"`TO` var ⇒ `Turnover(4)` eşleşti"* **YASAK**. Öyle yazılırsa
`NIV(3)` doğru eşleşir, `Turnover(4)` **yanlış** eşleşir — ve eksik-`18`
**küçülmüş GÖRÜNÜR** ama gerçekte küçülmemiştir.

> ### **BİR AD EŞLEŞMESİ, BİR KAVRAM EŞLEŞMESİ DEĞİLDİR.**
> **İki farklı kavram tek ada sıkıştığında, ad-düzeyi eşleme boşluğu KAPATMAZ — SİLER.**

📌 Bu, `A0`'ın kendi dersinin (*"arama terimi aranan yerin diliyle seçilir"*) **ters
yüzü**: orada **aynı kavram iki ad** taşıyordu, burada **iki kavram tek ad**. İlki
boşluğu **büyük gösterir**, ikincisi **küçük** — ve ikincisi tehlikelidir, çünkü
*"kapandı"* diye kaydedilir.

### `§3` · `A0'` ÇIKTI ŞARTI — **yedi kalem** (`NIV 3` + `Turnover 4`)
```
1  canlı-karşılık   kpis satırı (KOD) ya da "YOK"
2  SEMANTİK KANIT   FORMÜL karşılaştırması — AD karşılaştırması DEĞİL
3  verdict          eşleşen-doğru | eşleşen-sapmalı | YOK
```
⛔ İki kavram tek addaysa → **`AD-BORCU`** olarak kayda girer.
Yeniden-adlandırma hükmü **eşleme-sonrası**, **VERİ-DOKUNMASIZ** ilkeyle
*(bu turda kolon/enum adı değiştirilmez)*.

### `§4` · HÜKÜM 2'NİN EK-SATIRI
`B`'nin migration'ı ∩ `A`'nın `F12` dokunuşları **kesişimsiz** ⇒ tam paralel.
Kesişseydi: `F12`'ler **`B`-sonrası tek commit**. *(Yapısal olarak `∅` — `A` meta-repo
`docs/`'a, `B` submodule `src/`'ye yazıyor.)*

### `§5` · İKİ `DISIPLIN` KAYDI

**1 · `T-332`'nin kapanış cümlesi kural oldu** — fixture kuralının **eksik yarısı**:
*"fixture farkı taşımak GEREKLİ; o farkı OKUYAN assertion olmadan YETERSİZ."*
Ve beş üyeli ailede **iki kopyanın gerekçeli-doğru** çıkması (docstring'ler birbirine
atıflı) → **`§7` sınıfının İLK OLUMLU vakası**.

**2 · Büyük/küçük-harf refleksi — DÖRDÜNCÜ vaka** ⇒ kendi kuralımız işledi
(*"üçüncü ihlal yerleşimin kusurudur"*). Çözüm **kuralı tekrarlamak değil, VARSAYILANI
DEĞİŞTİRMEK**: ilk tarama **her zaman** `rg -i`/`grep -i`; case-duyarlılık ancak
**bilinçli gerekçeyle** kaldırılır.

---

## `Z65` — **FORMÜL-KANON HÜKMÜ**: `1781` bir SAPMA, ve kök-neden **DERLEME-KAYBI**

> **Tarih:** 2026-08-30 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `docs/research/A0_KAVRAM_ESLEME_RAPORU.md` (`DALGA-A`) + Team Lead'in
> birinci-elden doğrulaması (`1780`/`1781` metinleri · canlı `main.kpis` · frontend `:218`/`:561`)

### `§0` · ⭐ KÖK-NEDEN ZİNCİRİ — beş soruyu **tek hikâyeye** bağlar

```
Section_05 DERLEME-KAYBI  →  NIV grubu listeden DÜŞTÜ            (§6-1'de kanıtlandı)
                          →  NIV İHTİYACI KODDA DOĞDU            (off-invoice tabanı için GEREKLİYDİ)
                          →  listede NIV KAVRAMI YOKTU
                          →  ihtiyaç TO'NUN ÜSTÜNE YAMANDI       (1781, "BRD NIV semantiği")
                             ⚠️ BRD'nin "Turnover" dediği yerde
```

⛔ **`1781` KÖTÜ BİR TUR DEĞİLDİ — EKSİK-EVRENLE ÇALIŞAN BİR TURDU.**

> ### **BİR DERLEME-KAYBININ İLK ÖLÇÜLMÜŞ MALİYETİ**
> ```
> 1  bir KAVRAM-YAMALAMA migration'ı        (1781)
> 2  bugünkü ÜÇ-YÜZEY çelişkisi             (DB · grid:218 · grid:561)
> 3  GP/ROI İYİMSERLİĞİ                     (beş kalem NIV tabanlı)
> ```
> **Bir listeden düşen kavram yok olmaz — İHTİYAÇ hâlinde geri gelir ve BAŞKA BİR ADIN
> ÜSTÜNE OTURUR.**

### `§1` · `Q2` — `1781` **SAPMA**'dır, ama düzeltme **"geri-al" DEĞİL: KAVRAM-AYRIŞTIRMA**

Kaynak-zincirin **üçü de** aynı şeyi söylüyor *(Excel formül sözlüğü · KPI-Library · BRD)*:
```
TO   =  GSV − TotalSpend(on+off)      ← iki AYRI kavram
NIV  =  GSV − Spend_On                ← ikisi de MEŞRU, ikisi de GEREKLİ
```

| kalem | hüküm |
|---|---|
| **NIV** | **kendi kodlarıyla DOĞAR** — `BASE_NIV` · `PLANNED_NIV` · `INCR_NIV` *(`1781`'in yazdığı formüller **zaten bunlar**, yalnız **yanlış ada** yazılmış)* |
| **TO** | **gerçek TO semantiğine DÖNER** — `1780`'in formülleri *(Excel'le **birebir** olduğu ölçüldü)* |
| **frontend** | iki kopya **aynı dalgada** backend'e hizalanır |

### `§1a` · ÜÇÜNCÜ-KOPYA SORUSU — **hüküm değil, KAYIT**
> **Frontend formül HESAPLAMAZ; motor SONUCUNU gösterir.**

Grid'in kendi formül-hesabı taşıması **temizlik-listesine SINIF-NOTU** olarak girer.
Bugün bir hüküm verilmiyor — ama sınıf **adlandırıldı**.

### `§1b` · ⛔ ACİLİYET GEREKÇESİ **ÖLÇÜMDE DURUYOR** — `plans = 0`
```
BUGÜN      kavram-ayrıştırma migration'ı BEDELSİZ
           (dokunulacak plan-verisi YOK; yalnız kpi-TANIM tablosu)
İLK GERÇEK MÜŞTERİ PLANI GİRDİĞİ GÜN
           bu iş VERİ-MİGRATION'ına döner
```
> **VERİ-SIFIR PENCERESİ KAPANMADAN İNMELİ.**
> *(`T-273` ailesinin **olumlu** yüzü: `0`-satır bir körlük kaynağıdır — ama bir
> **fırsat penceresi** de olabilir, ve pencerenin kapanış tarihi **yazılabilir**.)*

### `§2` · `Q1` — `AD-BORCU` **BU HÜKÜMLE KAPANIYOR**, *"ertele"* YOK
Dört kalem `Q2`'nin kavram-ayrıştırmasının **içinde** çözülür.
⛔ **Yeniden-adlandırma DEĞİL:** NIV'e **yeni kod**, TO'ya **anlam-iadesi**.
Erteleme gerekçesi olabilecek tek şey **veri-maliyetiydi — sıfır**.

### `§3` · `Q3` — GP TABANI **`TO`**'dur *(gerçek TO: on+off düşülmüş)*
```
Excel-kanonik   GP = Turnover − COGS
iş-mantığı      off-invoice harcama GERÇEK PARADIR
                kârın hesabına girmemesi ROI'yi YAPISAL-İYİMSER yapar
ölçüm           beş GP/ROI kalemi BUGÜN NIV tabanlı
```
`Q2` ayrıştırması inince GP formülleri **`TO`'ya bağlanır**.
⚠️ **RAG renkleri DEĞİŞECEK — bu bir DÜZELTMEDİR, regresyon değil**; pin bunu
**"beklenen-değişim" listesiyle** taşır.

### `§4` · `Q4` — EVREN **`52` (BRD-`A1`)** KALIR · `Z62 §5` tabanına **`F12`**

> **`F12` DÜZELTMESİ** *(eski kayıt silinmez — üstüne yazılır)*:
> `Z62 §5` karşılaştırma tabanını *"Excel"* diye okutuyordu. **Doğrusu:**
> ```
> TABAN          BRD-A1  52   ← kalem LİSTESİ buradan
> Excel          FORMÜL-KANIT KAYNAĞI — EVREN DEĞİL, SEMANTİK REFERANS
> ```
> *(`§6-1` hükmü zaten verilmişti ve ürün sahibi teyitli; çelişki bu `F12` ile kapandı.)*

**Kaynaksız-`8`** (`KPI 21-28`) evrenden **ATILMAZ** — `[KAYNAKTA YOK]` etiketiyle
eşlemede **taşınır**, `YOK`-kova yerleşiminde süzgeç + ürün sahibi görüşüyle karara bağlanır.
⛔ **Kaynaksız bir kalem `Faz-2-ŞART` OLAMAZ**: ya kaynağı bulunur, ya `Faz-3`/elenir.

### `§5` · `Q5` — OFF-INVOICE TABANI **`NIV`**'dir · `LTA_Off` **DÜŞÜLMEZ**
```
Excel + BRD   HEMFİKİR:  CPPOff = NIV × pct   (NIV yalnız on-invoice düşer)
kod           LTA_Off'u DA düşüyor  ⇒ taban KÜÇÜLÜYOR  ⇒ yine ROI-İYİMSER
```
⇒ **`T-291`'in kardeşi. KOD SAPMA.**

### `§6` · ⛔ VE YÖN-DESENİ ARTIK **ÜÇ VAKADA AYNI**

| # | sapma | yön |
|---|---|---|
| 1 | `T-291` dört `\|\| 0` (eksik fiyat ⇒ LTA harcaması küçük) | **ROI İYİMSER** |
| 2 | GP tabanı NIV *(off-invoice kârın payına girmiyor)* | **ROI İYİMSER** |
| 3 | off-invoice tabanından `LTA_Off` düşülmesi | **ROI İYİMSER** |

> ### **SAPMALARIN YÖNÜ RASTGELE DEĞİLSE, SİSTEMATİK BİR İYİMSERLİK-BASINCI VAR DEMEKTİR.**
> KPI-mühürleme işinin (`Faz-2-1i`) **çıkış gerekçesi zaten buydu** — şimdi **ölçülmüş
> üç kanıtı** var.

### `§7` · UYGULAMA SIRASI

```
1  B-DALGASI KOŞUYOR — DOKUNMA
2  T-334  FORMÜL-KANON DÜZELTMESİ   ← Q2+Q3+Q5 TEK PAKET
      B-kapanışı SONRASI kendi dalgasıyla
      (B'nin LTA-taban-pini T-334'ün ZEMİNİNİ de hazırlıyor)
   ⛔ ÜÇÜ AYRI İNERSE ÜÇ MİGRATION TURU — aynı formül-katmanı, TEK tur, TEK pin-seti
3  A1 EŞLEMESİ ŞİMDİ KOŞABİLİR
      eşleme "OLMASI GEREKEN"i (KANON) yazar
      T-334'ün KAPSAMI da eşlemenin SAPMALI-KOVASINDAN doğar
```

### `§8` · ⭐ `K-2.2.8c` EMSALİNİN **İKİNCİ VAKASI** — ve **YÖN TERS**

```
K-2.2.8c   KOD DOĞRU  ·  KURAL YANLIŞ    → donmuş BRD ölçümle düzeltildi
Z65        KURAL DOĞRU ·  KOD EKSİK-EVRENİN ÇOCUĞU → kod kaynağa döndürülür
```

> ### **İKİSİNİN ORTAK YASASI:**
> ### **ÇELİŞKİYİ ÇÖZEN ŞEY OTORİTE DEĞİL — KAYNAK-ZİNCİR + ÖLÇÜM.**

---

## `Z66` — `Q6`–`Q12` HÜKÜMLERİ: ROI paydası **BÖLÜNDÜ**, RAG **iki eksen**

> **Tarih:** 2026-08-30 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `docs/research/A1_KPI_ESLEME.md` · `W2 DALGA-B` review · `B4` DUR kaydı

### `§1` · ⭐ `Q6` — ROI PAYDASI: **DEĞERİ DEĞİL, OKUNAN KALEMİ DEĞİŞTİR**

Dört kaydın çelişkisi **iki ekseni karıştırıyordu**:
```
eksen 1   LTA DAHİL Mİ?
eksen 2   TOTAL mı INCREMENTAL mı?
```

| kalem | hüküm |
|---|---|
| **`TOTAL_PLANNED_SPEND`** | ⛔ **OLDUĞU GİBİ KALIR.** Bütçe rezervasyonu / `plan.totalSpend` onu besliyor ve **bütçe gerçekten TOTAL ister** — zarf **gerçek parayı** rezerve eder, LTA dahil. `ADR 0011`'in bilinçli değişikliği muhtemelen **bu ihtiyaçtandı ve o ihtiyaç için DOĞRU**. |
| **ROI paydası** | **AYRI KALEMDİR.** Bugün yanlış olan şey **ROI'nin BÜTÇE kalemini okuması**. Yeni/ihya edilmiş **`INCR_PROMO_SPEND` sınıfı** bir kaleme bağlanır. |

**Tanım — tek noktadan** (`B4`'ün hazırladığı `src/common/kpi/roi-denominator.ts`),
**varsayılan `Z62 §6-3`:** *yalnız promo-spend · LTA hariç · **incremental***.

> ⇒ **FİNANSAL YAYILIM SIFIR:** bütçe yolu **dokunulmamış**, yalnız ROI'nin
> **OKUMA ADRESİ** değişmiş.

📌 **Excel'in *"incremental-total-incl-LTA-delta"* tanımı** eşlemede **`F12` farkı**
olarak kayda girer — **tenant-konfigür ekseni zaten yazılı**, Excel tanımı yarın bir
tenant'ın **seçeneği** olur. *(Ürün sahibi sözü **güncel otoritedir**.)*

⛔ **`ADR 0011`'e `F12` notu:** *"kalem BÖLÜNDÜ — bütçe `TOTAL` okur, ROI `INCR-PROMO` okur."*

> ### **BİR ÇELİŞKİ, İKİ EKSENİN TEK KALEME SIKIŞMASINDAN DOĞABİLİR.**
> **Çözüm bir DEĞER seçmek değil, KALEMİ BÖLMEKTİR** — `Z65`'in kavram-ayrıştırmasının
> **ikinci vakası**, bu kez bir **okuma adresi** üzerinde.

### `§2` · `Q7` — RAG: **İKİ-EKSEN KADRAN** (Excel kanonik)

RAG'ın sorduğu soru **iki yarımlıdır**: *ciro arttı mı* (`iTO`) × *kâr etti mi* (`iGP`).
```
Red     iTO ≤ 0
Amber   iTO > 0  ∧  iGP ≤ 0
Green   ikisi de > 0
```
⛔ **Tek-eksen eşik bu iki yarıyı TEK SAYIYA EZER** ve **`Amber`'ın anlamını siler** —
*"satış var, kâr yok"*, yani tam da bir **kategori yöneticisinin görmesi gereken** durum.

⇒ Canlı tek-eksense **`eşleşen-sapmalı`** kovasına.
⇒ **Fixture ŞİMDİDEN iki-eksenli kurulur: DÖRT kadran vakası, hücre başına bir.**
⇒ `T-334` pini RAG renk değişimlerini **beklenen-değişim listesiyle** taşır.

### `§3` · `Q8` — KALEM `22` **`T-334`'E GİRER**

> **Paket gerekçesi *"iyimserlik"* DEĞİL, FORMÜL-KANON — ve kanon YÖN-AGNOSTİKTİR.**

Aynı formül katmanında **ikinci bir migration turu açmak maliyetin kendisi**.

⛔ **Ve karşı-örneğin varlığı hikâyeyi BOZMAZ, ölçümü OLGUNLAŞTIRIR:**
`Z65 §6`'nın *"üç vaka tek yön"* kaydına **karşı-örnek satırı** eklenir, ve
*"sistematik iyimserlik"* iddiası **"BASKIN YÖN"** olarak **yumuşar**.

### `§4` · DÖRT KÜÇÜK

| # | hüküm |
|---|---|
| `Q9` UOM | **`İlke 1`: tüketicisiz inşa YOK.** `Faz-2-aday` kovasında; Excel'de kullanıcı-UOM girişi **grid işine bağlı** ⇒ yerleşimi **o iş belirler** |
| `Q10` kaynaksız-8 | adlar ürün sahibine listelenir, birlikte süzülür. Kural hazır: **kaynaksız kalem `Faz-2-ŞART` OLAMAZ** |
| `Q11` `TOTAL_PLANNED_LTA` | **kaynağı varsa evrende KALIR** (LTA görünürlüğü **meşru** rapor kalemi); kaynaksızsa `Q10` süzgecine girer |
| `Q12` `weighted_avg` | **`AD-BORCU` listesine.** Davranış **doğru** — `recomputeRatioFromChildren` ölçümü kanıtladı; **ad** yanıltıcı. ⛔ `T-334`'e **girmez**: ad-borcu paketi **eşleme-sonrası tek dokunuş** |

### `§5` · İKİ KAYIT

#### `5a` · ⛔ `B1`'İN DERSİ KAPI AİLESİNE GENELLENİR — **`G5`'in `money-float` hâli**

```
money-float'un DOSYA LİSTESİ  =  ELLE YAZILMIŞ EVREN
G5 yasası:  yazılmış  <  taranmış  <  türetilmiş
```
⇒ **Kalıcı düzeltme listeye-ekleme DEĞİL, Alan A ÜYELİĞİNİN TÜRETİLMESİDİR.**
`ADR 0007 E10` testi **zaten bir tanımdır** (*"para üreten dosya"*) ⇒ **grep-türetilebilir.**
**`T-334` sonrası küçük task.**

📌 **Ve *"kapıyı açan turun kendi kodu ilk yakalanan oldu"*** — kuralın **yazıldığı gün
kendini doğrulaması**, sistemin **sağlığıdır**, bir utanç değil.

#### `5b` · ⭐ BOŞ `Faz-3` KOVASI — **SÜZGEÇ DİSİPLİNİNİN NEGATİF KANITI**

`A1`'in `YOK` yerleşimi: `Faz-2-ŞART 6` · `aday 5` · **`Faz-3` 0**.

> ### **BİR KOVA, DOLDURULMAK İÇİN VAR DEĞİLDİR.**
> **Bu, o cümlenin İLK ÖLÇÜLMÜŞ VAKASI:** *"ölçek-hazırlığı kalemi ÇIKMADI, UYDURULMADI."*

📌 Bir süzgeç, **her kovasına en az bir kalem koyduğunda** süzgeç olmaktan çıkar;
boş bir kova **süzgecin çalıştığının kanıtıdır**.

### `§6` · SIRA
```
1  B-KAPANIŞ TURU (6 kalem)  →  PUSH
2  T-334   Q6/Q7/Q8 hükümlü · 9+1 kalem · plans=0 PENCERESİ AÇIKKEN
3  A1 çıktısının KOVA-YERLEŞİM SÜZGECİ (Q10 listesiyle birlikte ürün sahibine)
```
**Onaylı task'lar:** `S3` ebeveyn `agreements.status` kapısı · `S4` bağ tekilliği ↔
`TERMINATED`/soft-delete · canlı yoldaki `?? 0` **yeniden kararı** *(`T-027`'nin bilinçli
kararı ⇒ düz düzeltme DEĞİL)* · **çift LTA implementasyonu**.

---

## `Z67` — `Q10`: **KAYNAKSIZ-8 DİYE BİR SINIF YOK** — `"11"` bir BAŞLIK HATASI, ve `"52"` DÜŞER

> **Tarih:** 2026-08-30 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `A1` promptunun tam metni (proje bilgisi) + `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md §1`

### `§1` · BULGU — çapraz kanıtlı

`A1` bulgusu (*"`28–35` sekiz slot adlandırılmamış"*) **doğru okundu ama bir adım eksikti.**

```
PSbM grubu başlığı        "(11)"
PSbM grubu ADLI LİSTESİ     9   CPP-On · CPP-Off · PriceSupport · Vis-MT/PH · Vis-GT
                                Drive/TPR-On · TPR-Lumpsum · WS-On · WS-Off
Excel sözlüğü (§1)          9   ← AYNI DOKUZ, BAĞIMSIZ KAYNAK
```

⇒ **Sekiz boş slot YOK. Başlık `9` yerine `11` diyor.**

### `§2` · ⛔ ÜÇÜNCÜ VAKA — **BAŞLIK SAYILARI BU BELGE AİLESİNDE SİSTEMATİK GÜVENİLMEZ**

```
1  Section_05 §5.3   "40 KPIs" başlığı   ↔  liste 42
2  evren beyanı      "42"                ↔  ölçülen grup listesi
3  PSbM grubu        "(11)"              ↔  adlı liste 9        ← BU TUR
```

> ### **BAŞLIK SAYILARI GÜVENİLMEZ; KALEM ADLARI KANONİKTİR.**

### `§3` · ⛔ VE ZİNCİR YUKARI ÇIKIYOR — **`"52"` DE BİR BAŞLIK TOPLAMIYDI**

```
52 = 2+4+3+3+4+8+11+6+5+3+3      ← ONBİR BAŞLIĞIN TOPLAMI
                    ↑        ↑
                    │        └── "(11)" ölçüldü: gerçekte 9
                    └── LTA "(8)" muhtemelen 7 adlı kalemin üstünde
adlı-kalem ön-sayımı: 49 — ve Excel'in adlı listesiyle BİREBİR ÖRTÜŞÜYOR
```

### `§4` · ⭐ `Q4` HÜKMÜ **ÖLÇÜMLE DÜZELTİLİYOR** — ve düzelten şey **kendi kuralımız**

> **`Z65 §4`'te *"evren 52 (BRD-`A1`)"* denmişti. O `52` de bir YAZILMIŞ EVRENDİ.**
> `G5` yasası (`yazılmış < taranmış < türetilmiş`) **hükmü verenin kendi sayısına** işledi.

```
YENİ HÜKÜM   evren  =  ADLI-KALEM LİSTESİ
             sayısı  LİSTEDEN TÜRETİLİR — HİÇBİR BAŞLIKTAN ALINMAZ
```

📌 **Ve `A0'`/`Z64`'ün deseninin üçüncü yüzü:** orada *"iki kavram tek ad"* boşluğu
**siliyordu**; burada *"bir başlık, listesinden fazla sayıyor"* boşluğu **uyduruyor** —
`8` hayalet kalem, hem de `[KAYNAKTA YOK]` etiketiyle **saygıyla taşınan** hayaletler.

⛔ **Bir etiket, olmayan bir şeyi de KORUYABİLİR.** `[KAYNAKTA YOK]` doğru bir işaretti,
ama işaretlediği şey **bir eksiklik değil, bir sayım hatasıydı**.

### `§5` · `T-340` AÇILDI — ve **`T-334`'ü ETKİLEMEZ**
`T-334`'ün `9+1` kalemi **tamamen adlı-kanonik bölgede** (`TO`/`NIV` ayrıştırma · GP taban ·
off-invoice taban · kalem `22` · ROI payda bölünmesi) — **başlık-hatası bölgesine dokunmuyor.**
⇒ `T-340` **paralel ya da sonra** iner.

### `§6` · İKİ BAĞIMSIZ KAYNAĞIN YAKINSAMASI
> **`A1` promptunun adlı listesi ↔ Excel sözlüğünün adlı listesi — aynı `9`.**
> **İki bağımsız kaynak aynı listeye yakınsıyorsa, bu EVRENİN EN SAĞLAM HÂLİDİR** —
> bir başlığın, hatta iki başlığın hemfikir olmasından **daha güçlü**.

### `§7` · `A1` KOVA-YERLEŞİMİ **ONAYLI**
`Faz-2-ŞART 6`'nın **kimlikleri** `T-334` sonrası **ilk planlama masasına** gelir.
⚠️ `T-334`'ün `9+1`'i ile `ŞART-6`'nın **kesişimi muhtemelen büyük** — **kalan fark,
sonraki dalganın kapsamıdır.** Boş `Faz-3` zaten `Z66 §5b`'de kayıtlı.

---

## `Z68` — `Q7` KADRAN İNİŞİ + `S1`: **RENKSİZLİK ÖLÜR, TANIMLI-YOKLUK DOĞAR**

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `T-334` kapanış raporu + review · `Z66 §2`

### `§1` · `Q7` — **İNİŞ KARARI** (hüküm zaten `Z66 §2`'de verilmişti)
```
Red     iTO ≤ 0
Amber   iTO > 0  ∧  iGP ≤ 0
Green   ikisi de > 0
```
**Migration YOK** — hesaplanan-değer davranışı. ⇒ **`plans=0` penceresi bu iş için gerekmiyor.**

⭐ **İniş ucuz, çünkü PİN ÖNCEDEN DOĞRU KURULDU:** literal `liveRag` sabiti + *"hüküm indiği
gün bilerek kırılır"* şerhi.
> ### **`T-341` DESENİNİN RAG HÂLİ: BUGÜNÜ PİNLE, YARINI İŞARETLE.**
> Bir sapmayı **bugünkü hâliyle** pinlemek, düzeltmeyi **ucuzlatır** — çünkü düzeltme günü
> kırılan test bir **sürpriz değil, bir randevudur**.

### `§1a` · ⛔ TEK ŞART — **`AMBER` İLK KEZ DOĞUYOR**
> **Bugün hiç üretilmeyen bir durum yarın üretilecek.** Tüketicileri (**renk eşlemesi ·
> filtre · rapor**) `AMBER`'ı **tanıyor mu**? Tek grep'lik **ön-ölçüm raporda görünür.**

📌 **Team Lead ön-ölçümü** *(ajan RİGOROUS hâlini yapacak)*: `AMBER` tip birleşimlerinde
(`plans` · `dashboard` · `finance-reporting` · `budget` · `on-invoice`), renk haritalarında
(`PlanPerformanceWidget:67` · `BudgetUtilizationWidget:39`) ve `BudgetAtRiskWidget`'te
**tanınıyor** ⇒ ilk doğuş bilinmeyen-değer yoluna düşmeyecek **gibi görünüyor**.
⚠️ **Ama bir yan bulgu:** `ragAmberThreshold` (`kpi.endpoints.ts:25,53` ·
`kpi.repository.ts:101`) **tek-eksen eşiğinin konfigürasyon alanıdır** — iki-eksen kadranda
**ne olacağı ölçülmeli**: ölü mü kalıyor, yoksa hâlâ bir yerde okunuyor mu?

### `§2` · `S1` — **RENKSİZLİK ÖLÜR, TANIMLI-YOKLUK DOĞAR**

> ### **RAG HESAPLANMAZ, VE BU MEŞRUDUR — AMA MEŞRU-YOKLUK GÖRÜNÜR YAZILIR.**

**Gerekçe:** LTA-only bir plan **bir promosyon değerlendirmesi değildir** —
**incremental ekseni yok**; plan, baseline'ın **sözleşmeli hâli**.
```
RAG'ı ZORLA üretmek   →  ANLAMSIZ SAYI      ⛔ yasaklı sınıf
boş bırakmak          →  SESSİZ BOŞLUK      ⛔ yasaklı sınıf
                         ⇒ DOĞRU ŞEKİL ÜÇÜNCÜ DURUM
```

| yüzey | şekil |
|---|---|
| **UI** | gri/nötr **"Değerlendirme dışı — LTA"** rozeti · tooltip'te **tek cümle gerekçe** |
| **API** | `ragStatus: null` **+** `ragExclusionReason: 'LTA_ONLY'` sınıfı **açık alan** |

⇒ Filtre/rapor tüketicileri **`"Red değil"`** ile **`"değerlendirilmedi"`**yi **ayırt eder.**

📌 **`T-323` UI dersinin RAG hâli:**
```
"yetkin yok"  ≠  "kimse yok"        neyse
"kötü değil"  ≠  "değerlendirilmedi"   o
```

⇒ `T-342` ile **aynı dalgaya biner** — aynı dosya ailesi.

### `§3` · ÜÇ KAYIT

**`3a` · ⭐ `§2.7` AİLESİNİN EN SIKI INVARIANT FORMÜLASYONU:**
> ### **DENETLENEN DİZGE = DEĞERLENDİRİLEN DİZGE.**
Parser vakasının **kalıcı mirası**. Yanına ilk-düzeltmenin dersi:
> **Bir düzeltme, düzelttiği sınıfın yeni bir vakasını üretebilir — ve EN SİNSİ BİÇİMİ,
> DÜRÜST-`null`'UN YERİNE KISMİ-DOĞRU-SAYI KOYMAKTIR.**

**`3b` · ⛔ LATENT-KUSUR ATEŞLENMESİ — `T-273` ailesine YENİ YÜZ, ve bir `W3` RİSK NOTU:**
```
GP tabanı TO'ya döndü → GP'ler NEGATİFE düştü → parser kusuru UYANDI
```
> ### **VERİ-SIFIR DÜNYADA YEŞİL OLAN HER ŞEY, İLK GERÇEK DEĞER-DAĞILIMINDA
> ### YENİDEN SINANMAMIŞ DEMEKTİR.**

⚠️ **`W3` (baseline-import) RİSK NOTU — şimdiden kayda:** baseline-import **ilk kez gerçek
sayı dağılımları** getirecek; **parser/formül katmanı o gün İKİNCİ BİR ATEŞLEME DALGASI
yaşayabilir.** *(`T-341` üstel gösterim kusuru bu dalganın **bilinen** ilk adayıdır.)*

**`3c` · ÜÇ GERİ-ÇEKME, ÜÇÜ DE İZLİ — sistemin sağlık göstergesi ARTIK İSTİKRARLI:**
```
ajan  "conditional pinim AYIRT ETMİYORDU"        → şekli değiştirdi, mutasyonla doğruladı
ajan  "basePromoSpend iddiam YANLIŞTI"           → savundu DEĞİL, SİLDİ
TL    "hangi taraf sapmıştı varsayımım yanlıştı" → FE zaten kanonikti, sapan MOTORDU
```

### `§4` · SIRA
```
1  T-342 (Q7 kadran + S1 tanımlı-yokluk)   ← formül katmanı KAPANIŞI, küçük
2  T-340 (evren türetmesi, doc işi)         → 49-listesi KESİNLEŞİR
3  A1'in ŞART-6 kimlikleriyle PLANLAMA MASASI
     W3-baseline AÇILMADAN ÖNCE: kalan formül işleri + baseline ÖNKOŞULLARI TEK GÖRÜNÜMDE
     beklenti: ŞART-6'nın ÇOĞU T-334/T-342 ile kapanmış çıkar, W3'ün önü TEMİZ
```

---

## `Z69` — DOSYA ADI HÜKMÜ: **AD DEĞİŞİR *VE* `F12` İÇERİDE KALIR**

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### `§1` · HÜKÜM — ikisi arasında **seçim değil, İKİSİ BİRDEN**
```
KPI_EVRENI_52_GRUP_AGACI.md   →   KPI_EVRENI_GRUP_AGACI.md
                                   + içeride F12 izi
```

**Gerekçe — *"engeli okuyan tur"* yasasının AD-UZAYI hâli:**
> ### **BİR DOSYA ADI, İÇERİĞİ OKUNMADAN ÖNCE OKUNAN TEK SATIRDIR.**
> `52`'yi taşıyan bir ad, `F12`'yi **asla göremeyecek** okuyuculara (**dizin listesi · link ·
> atıf**) **düzeltilmemiş sayıyı beyan etmeye devam eder.**

📌 *"Teslim edilmeyen manşet"* vakasının **dosya sistemi kopyası**.

### `§2` · VE `Z67`'NİN KENDİ KURALI ADA DA İŞLER
> `Z67`: *"sayısı **listeden türetilir**, hiçbir **başlıktan** alınmaz."*
> ### **BİR DOSYA ADI DA BİR BAŞLIKTIR.**
⇒ Ad **sayısız** yeniden doğar; sayı **içerikte**, **türetilmiş** ve **`F12` izli** yaşar.

### `§3` · ŞEKİL
```
1  ad sayısız doğar          KPI_EVRENI_GRUP_AGACI.md
2  eski adın atıfları taranır  rg -i  ⇒ ÖLÜ LİNK KALMAZ   (T-307 navigasyon dersi)
3  içeride F12:  "önceki ad ..._52_... idi; 52 BAŞLIK-TOPLAMIYDI, Z67'yle düştü"
```
⇒ Gelecekte evren sayısı **bir daha değişirse** *(ve `T-340`'ın tam-metin okuması `49`'u da
oynatabilir)* **ad bir daha yalan söylemez.**

### `§4` · ÜÇ TEYİT

**`4a` · RANDEVU-PİNİ** — adlandırma yerinde, üç-vakalık desen `DISIPLIN`'e yazıldı.
`T-084`'ün **çözülmüş formu**: `şerh + randevu-pini` ⇒ **belgeleme artık KORUMUYOR, TARİHLİYOR.**

**`4b` · `ragAmberThreshold`** — refleks doğru, sınır doğru (*"kaldırma bu turun işi değil"*).
⛔ **Ve kadran inince alan ölü kalırsa bu, `§2.3`'ün DAYANDIĞI-ALAN DEĞİŞİMİ vakasıdır:**
```
KURAL yaşar        "hardcoded yasak, konfigürasyondan"
NE'nin konfigüre edildiği DEĞİŞİR
⇒ kadranın kendisi bir KONFİGÜRASYON SORUSU doğurur:
   eşikler mi? · kadran SINIRLARI mı? · hiçbiri mi?
```
O soru, **tek-eksen alanının kaderiyle BİRLİKTE TEK TASK'ta** cevaplanır.
**`İlke 3` gözüyle:** *"kadran kuralı konfigüre edilebilir olmalı mı?"* → **ürün sahibine,
ÖLÇÜMDEN SONRA.**

**`4c` · HÜKÜM-GEREKÇE KATMANI** — *"bir hükmün gerekçesi, altındaki mekanizma değişince
taşınmaz, yeniden kurulur"* → `DISIPLIN`'e, **`Z60`'ın yanına katman notuyla** yazıldı.

### `§5` · `W3` BRIEF'İNE ŞİMDİDEN İKİ SATIR
```
1  RİSK NOTU     veri-sıfır dünyada yeşil olan her şey, ilk gerçek değer-dağılımında
                 YENİDEN SINANMAMIŞ demektir (Z68 §3b)
2  T-341         üstel gösterim — ikinci ateşleme dalgasının BİLİNEN İLK ADAYI
```

---

## `Z70` — `AMBER` UYARISI **KADRAN DİLİNE ÇEVRİLİR** · `ragAmberThreshold` **ÖLÜR**

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `T-342` raporu (`A0` tüketici taraması · `A0b` eşik asimetrisi)

### `§1` · `AMBER` SUBMIT UYARISI — **EVET, ama İKİ UYARI AYNI CÜMLE OLMAZ**

```
KADRAN ÖNCESİ   tek uyarı vardı  ÇÜNKÜ  TEK KÖTÜ-DURUM vardı
KADRAN SONRASI  iki farklı kötü-durum   ⇒  UYARI KATMANI DA O AYRIMI KONUŞMALI
```

| durum | uyarı |
|---|---|
| **`RED`** | *"**ciro kaybı**: plan incremental ciro üretmiyor"* — bugünkü uyarının **kadran-doğru** hâli |
| **`AMBER`** | *"**kârsız büyüme**: satış artıyor, kâr negatif — gözden geçirin"* — `AMBER`'ın **var-oluş cümlesinin** uyarıya taşınması |

⛔ **İkisi de `warnings`** (bloklamayan) — **`K-2.2.7c` ailesi: submit DURMAZ, KARAR DESTEĞİ KONUŞUR.**

> ### **GÖRÜNÜR KILINMAK İÇİN DOĞAN BİR DURUM, DOĞDUĞU GÜN UYARI YÜZEYİNDEN DÜŞÜYORDU.**
> Bu düzeltme `AMBER`'ı **tam amaçlandığı yere** koyar.

### `§1a` · ⛔ VE BİR GENELLEME TARAMASI ŞART (`D1` refleksi)

> ⚠️ **`F12` — ÖNCÜL DÜZELTİLDİ (2026-08-31, `Z71 §0`).** Bu bölüm
> ***"`AMBER` İLK KEZ DOĞUYOR"*** diyordu. **YANLIŞ.** Ölçüldü:
> `main.kpis.GP_ROI_PCT` `rag_green=20 · rag_amber=10` ⇒ eski tek-eksen model
> `10 ≤ ROI < 20` aralığında **`AMBER` ÜRETİYORDU.**
> **Doğrusu:** *"**negatif ROI'den** `AMBER` — eşik modelinin **ÜRETEMEYECEĞİ** renk."*
> ⛔ **Ve bedeli:** yanlış öncül, `T-342`'nin **tüm `A0` taramasını** yanlış eksene
> kilitledi — gerçek risk `RED→AMBER` değil **`RED→GREEN`**'di.
> *(Öncülü Team Lead ölçtü, ürün sahibi hüküm-şartı olarak yazdı; ikisi de
> sorgulamadı. Eski metin **silinmedi** — append-only iz.)*
> **`ragStatus === 'RED'` literali BAŞKA NEREDE OKUNUYOR?**

Submit uyarısı **bir tüketiciydi**. Filtreler · raporlar · widget'lar aynı
**kadran-öncesi varsayımı** taşıyor olabilir. *(`BudgetAtRiskWidget` `AMBER`-tanır çıkmıştı —
ama **tam evren ölçülmedi**.)*

> ### **BİR KAVRAMI DOĞURMAK, ONU TÜKETEN YÜZEYLERİ KENDİLİĞİNDEN GÜNCELLEMEZ.**
> ### ⇒ **DOĞURAN DALGA, TÜKETİCİ EVRENİNİ TÜRETİR.**

`rg -i "ragStatus|RAG_STATUS|'RED'"` **kesişimi — `T-342` KAPANIŞININ ŞARTI.**

### `§2` · `ragAmberThreshold` **KALDIRILIR** — `İlke 3` cevabı: **HAYIR**

> `İlke 3` testi: *"bu kural, kullanıcının **düzenlemek isteyeceği** bir kural mı?"*
> Kadran-RAG'ın tanımı **eşik değil, İŞARET tabanlıdır** (`iTO`/`iGP` **sıfır çizgileri**).
> ### **`"SIFIRDAN BÜYÜK"` KONFİGÜRE EDİLECEK BİR DEĞER DEĞİL, KAVRAMIN KENDİSİDİR.**

⛔ **Geri dönüş kapısı adlandırıldı:** `AMBER`'ı eşikle oynatmak *(`iGP < −5000` olursa Amber
sayalım)* **kadranın anlamını GERİ-EŞİĞE çevirir** — **dün öldürdüğümüz tek-eksen dünyasının
GERİ DÖNÜŞ KAPISI.**

| alan | hüküm |
|---|---|
| `ragAmberThreshold` | **ÖLÜR** — tüketicisiz (ölçüldü). Kolon + endpoint alanı + tip beyanı. Emsal `E2`/`tier_roles` — ama **bu kez CANLIYKEN ölüyor**, ölü doğmuş değil |
| `ragGreenThreshold` | **YAŞAR ama `AD-BORCU` alır** — tüketicisi **RAG değil Target ROI** (`plan.service:2892`). `rag` önekiyle yaşaması, `ragAmber`'ın öldüğü dünyada yarın birini **"RAG konfigüre edilebilir"** yanılgısına götürür ⇒ `targetRoiThreshold` sınıfı, **ad-borcu paketine** |

⇒ **`T-343`** açıldı. ⛔ **Spekülatif konfigürasyon inşa edilmez** (`İlke 1`): bir tenant
*"kadran yetmez, eşik isterim"* derse **o gün süzgeçten geçer, olay-tetikli**.

### `§3` · `rag_exclusion_reason` EKSİĞİ — **ÖN HÜKÜM NET**
> ### **`Z68 §2`'NİN ŞARTI YARIM KALAMAZ.**
```
"grid rozeti CANLI, liste + raporlar GRİ"
= T-323'ün ÖLDÜRDÜĞÜ belirsizlik ("değerlendirilmedi ≠ kötü-değil")
  İKİ YÜZEYDE YAŞAMAYA DEVAM EDİYOR
```
⇒ **`T-342` ailesinde kapanır.** ⚠️ **Kolon ŞART DEĞİL** — `JSONB` geçişi yeterliyse
kolonsuz da olur; **ama ÜÇ tüketici yüzeyin ÜÇÜ DE ayrımı göstermeli.**
**Ölçüm hangisinin ucuz olduğunu söylesin.**

### `§4` · İKİ `Z69` YASASININ **İLK CANLI DOĞRULAMASI — AYNI TURDA**

**`4a` · RANDEVU-PİNİ:** kırılma **görüldü**, sıra ters yapılmadı
(`önce exit 0 → kadran indi exit 1 "Expected RED / Received AMBER" → sabitler yenilendi exit 0`).
**Kırılma bir sürpriz değil, bir TESLİM TARİHİYDİ.**

**`4b` · HÜKÜM-GEREKÇE KATMANI:** `S1`'in gerekçesi **tamamen değişti**, hüküm aynı kaldı.
```
T-334'te   HÜCRE 4 renksiz ÇÜNKÜ payda 0 ⇒ ROI null      → renksizlik bir YAN ETKİYDİ
kadranda   iki eksen de DOLU ⇒ kadran RED ÜRETİRDİ
yeni       tetikleyici = INCR_PROMO_SPEND === 0 — AÇIK BİR KAPI (mutasyonla kanıtlandı)
```
⛔ **Ölçülmeseydi hüküm YANLIŞ BİR GEREKÇEYLE yaşayacaktı** — ve kadran onu **sessizce
geçersiz kılmıştı**.

---

## `Z71` — `Q13`: KADRAN **TEK OTORİTE**, ama DÜŞÜK-ROI **SESSİZLEŞMEZ** — `TARGET-ROI` EKSENİNE TAŞINIR

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `T-342` review `B1`/`B2` · geçiş matrisi ölçümü (`GP_ROI_PCT green=20 · amber=10`)

### `§0` · ⛔ ÖNCÜL HATASI — VE PAYLAŞILMIŞ SORUMLULUK
```
YAZILAN (Z68 §1a)   "AMBER İLK KEZ DOĞUYOR"
ÖLÇÜM               GP_ROI_PCT rag_amber = 10   ⇒ eski model AMBER ÜRETİYORDU
DOĞRUSU             "NEGATİF ROI'den AMBER — eşik modelinin ÜRETEMEYECEĞİ renk"
```
⛔ **Bedeli bir yazım hatası değil, bir EKSEN kilitlenmesiydi:** `T-342`'nin tüm `A0`
taraması *"yeni bir rengin tanınmaması"* ekseninde yapıldı; **gerçek risk `RED→GREEN`**'di
ve o eksende **hiç tarama yoktu.**

> ### **YANLIŞ ÖNCÜL, DOĞRU TARAMAYI YANLIŞ EKSENE KİLİTLER.**

📌 Öncülü **Team Lead ölçtü**, **ürün sahibi hüküm-şartı olarak yazdı**, **ikisi de
sorgulamadı**. `Z68 §1a`'ya `F12` iziyle düzeltildi.

### `§1` · HÜKÜM — `(c)`'nin KAPSAMI + `(a)`'nın KORUMASI, `(a)`'nın AD-HATASI OLMADAN

⭐ **Anahtar yine `Q6` yasası:** *bir çelişki, **iki eksenin tek kaleme sıkışmasından** doğar.*
```
ESKİ RAG    YÖN (kazanıyor mu?)  ×  BÜYÜKLÜK (ne kadar?)   TEK RENGE SIKIŞMIŞTI
            "zarar eden plan"  ile  "kârlı ama az kârlı plan"   AYNI RED'i giyiyordu
```
⛔ **Bu da bir BİLGİ KAYBIYDI — sadece ALARM YÖNLÜ olduğu için kimse şikâyet etmiyordu.**

Kadran **yön eksenini** temiz aldı. **Büyüklük ekseni ZATEN SİSTEMDE VAR** ve adı
**Target-ROI** — `ragGreenThreshold`'un **yaşayan tek tüketicisi** (`plan.service:2892`),
ki bu `T-342 A0b` ölçümünde çıkmıştı.

```
RAG (kadran, TEK OTORİTE)   RED   "ciro kaybı"       → submit uyarısı + risk raporu
                            AMBER "kârsız büyüme"    → submit uyarısı + risk raporu
TARGET-ROI (AYRI EKSEN)     GREEN ∧ ROI < hedef      → "hedefin altında" uyarısı
                                                       + risk raporunda AYRI kova/filtre
```

### `§1a` · GEÇİŞ MATRİSİNİN **ÜÇ SATIRI DA** KAPSANIYOR

| dilim | ÖNCE | SONRA | yeni kapsama |
|---|---|---|---|
| `iGP ≤ 0` (ROI ≤ 0) | `RED` | `AMBER` | **Amber uyarısı** (yeni) + risk raporu |
| `0 < ROI < 10` | `RED` | `GREEN` | **below-target uyarısı** + Finance kovası |
| `10 ≤ ROI < 20` | `AMBER` | `GREEN` | **below-target uyarısı** + Finance kovası |

> ### **HİÇBİR DİLİM SESSİZLEŞMİYOR — VE *"YANLIŞ YÖNDE SESLİ GÜVENCE"* ÖLÜYOR.**

⭐ Ekran **`GREEN` + "hedefin altında"** rozetini **birlikte** gösterebilir — bu bir çelişki
değil, **iki eksenin ayrı konuşmasıdır.** Tam `S1` deseninde: **üçüncü durum, tanımlı ve görünür.**

`finance-reporting.service.ts:872` filtresi `['RED','AMBER']` **+ `belowTargetRoi`** olarak
genişler ⇒ **Finance'ın evreni KÜÇÜLMEZ, DAHA DOĞRU ADLANIR.**

### `§2` · `B2` HÜKMÜ — **MİGRATION AYNI DALGAYA**
> ⛔ ***"Faz-1: yalnız grid"* notu tam `T-084` PROBLEMİ olurdu — yarım durumu
> BELGELEYİP KORUMAK.**

Ve `plans=0` penceresi **her e2e sonrası açılıyor** ⇒ kolon **bugün bedelsiz**.
Üç yüzey (`PlanList` · `GrandTotals` · `finance-reporting`) **+ `approval-workflow`** ayrımı
**bu dalgada tanır**. `T-342`'nin kendi kabul ölçütü (*"bir tüketici tanımıyorsa DUR"*)
zaten bunu istiyor.

### `§3` · `T-343` — HÜKÜM DEĞİŞMİYOR, **GEREKÇESİ GÜÇLENİYOR**
| alan | yeni gerekçe |
|---|---|
| `ragAmberThreshold` | **YİNE ÖLÜR** — yeni dünyada *"düşük ROI"* **tek dilim**: hedefin altı. İkinci bir **ara eşik** `İlke 1` spekülatif; bir tenant **merdiven** isterse **olay-tetikli** |
| `ragGreenThreshold` | **YAŞAR ve YENİDEN ADLANIR** → **`targetRoiThreshold`**. ⛔ **Artık AD-BORCU DEĞİL, BU DALGANIN PARÇASI** — çünkü **below-target uyarısının okuduğu kalem TAM O** |

⇒ `T-343` **revize kapsamla** açılır: `amber ölümü` + `green→target yeniden adlandırma` +
`below-target uyarı/kova inşası`. **`Q13`'ün uygulaması ile `T-343` AYNI İŞ ÇIKTI.**

### `§4` · ÜÇ KAYIT
**`4a`** *"Yanlış öncül, doğru taramayı yanlış eksene kilitler."*
**`4b`** *"Beklenen yöne yanılan hata, ters yöne yanılandan tehlikelidir"* — **bu turun hâli:**
**uyarının yerine SESSİZLİK değil, KARŞI YÖNDE GÜVENCE koyar.**
**`4c`** ⭐ **REVIEW'UN `PUSH-EDİLEMEZ`'i KAYDA:** `T-342`'nin kabul ölçütü
(*"tüketici tanımıyorsa DUR"*) **yazıldığı dalgada çalıştı** — **kapı, kapıyı yazan turu
durdurdu.** ***Bu artık bir DESEN.***

---

## `Z72` — `Q14`: **KAPSAM `(a)`, PUSH-BİRİMİ `(b)`** · ve `S9`: **TANIM GENİŞLEDİ**

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### `§1` · `Q14` — **İKİ PUSH, TEK KARAR**
```
1  YEŞİL AĞAÇ ŞİMDİ PUSH EDİLİR      bu dalganın işi bitti; B2/B3 pre-existing ve KAYITLI
2  Q14 DALGASI HEMEN ARDINDAN        (a)'nın TAM kapsamıyla:
     B3 ÖLÜR  +  uyarılar CANLI YÜZEYE bağlanır  +  iki-rota konsolidasyonu (T-058)
```

**Gerekçe iki yönlü — ve ikisi de gerçek:**
```
yeşil ağacı BEKLETMEK    paralel-ajan çakışma yüzeyi (§4: "ağaç PAYLAŞILIR")
B3'ü KUYRUĞA ATMAK       ⛔ B3 PASİF BİR EKSİK DEĞİL, AKTİF BİR YANLIŞ
```
> ### **HESAPLANAMAYAN PLANLARA *"HEDEFİN ALTINDA"* DİYEN, RENK-KÖR, HARDCODE-EŞİKLİ
> ### BİR BANNER **BUGÜN CANLI** — `T-318` emsali sınıf: **CANLI-YANLIŞ ÖNCELİK ALIR.**

⇒ **İkisinin çözümü PUSH'U BÖLMEK:** risk küçülür, yanlış-uyarı **bir dalga içinde** ölür.

### `§1a` · ⛔ PUSH'UN TEK ÖN-ŞARTI — `T-058` NOTUNUN REVİZESİ **AYNI COMMIT'TE**
Bugünkü not (*"submit-for-approval'ın ek doğrulamaları kaybolacak; bu bilinçli"*)
`Z70`/`Z71`'den **ÖNCE** yazıldı ve **`Q13` uyarı katmanını SAYMIYOR.**
Revize edilmeden push, **`T-084`'ün taze bir vakasını üretir**.
✅ İşlendi: *"bu rota `Q13` uyarı katmanını taşıyor; konsolidasyon uyarıları canlı yüzeye
taşımadan bu rota **ölemez**."*

### `§2` · `Q14` DALGASININ ROTA KARARI — **ÖLÇÜMLE GELİR**
İki rota **birbirini deprecated ilan ediyor**. Ölçülecek:
```
1  hangisinin DAVRANIŞI TAM     doğrulamalar · warnings · yetki kapıları
2  FE'nin DÖNÜŞ MALİYETİ hangisinde düşük
```
**Öneri Team Lead'den, hüküm ürün sahibinden.**

⛔ **TEK-DOĞRULUK-KAYNAĞI İLKESİ SABİT:** dalga sonunda **bir** submit yolu, **bir**
below-target implementasyonu kalır — *konfigüre edilebilir · kadran-farkında ·
`null → NOT_EVALUABLE`* olan.

### `§3` · `S9` — **AD DOĞRU, TANIMI BÜYÜDÜ**
`totalAtRisk` artık below-target harcamasını **da** içeriyor. `Z71`'in *"evren küçülmez"*
hükmüyle **tutarlı** — ama **kayıtsız kalamaz**, çünkü bu bir **TANIM GENİŞLEMESİDİR**:
> **`riskPercentage` AYNI ADLA FARKLI BİR SAYI üretiyor.**
> **Finance dünden bugüne aynı grafikte BÜYÜMÜŞ bir "risk" görecek ve SEBEBİNİ BİLMEYECEK.**

**Şart üçlü:**
```
1  beklenen-değişim listesine satır   "at-risk tanımı genişledi: RED + AMBER + below-target"
2  Z-kaydına tek paragraf              (bu bölüm)
3  UI ETİKETİNDE/TOOLTIP'TE TANIM GÖRÜNÜR
     "Risk = zarar + kârsız-büyüme + hedef-altı"     ← Q14 dalgasında
```
⛔ **AD-BORCU DEĞİL** — ad **doğru**, tanımı büyüdü.
> ### **GÖRÜNMEZ BÜYÜYEN BİR TANIM, SESSİZ-SÜRPRİZ SINIFIDIR.**

### `§4` · KAYIT KALİTESİ — üç öz-çürütme + bir gerekçe
```
S1  "bir ölçüm, bir varsayılan değil" iddiam O DALDA YANLIŞTI
S3  "komşuları görüp bunu atlamıştım" — ve sebebi: bu turun doğurduğu LTA_ONLY sınıfı
    satırı YENİ ULAŞILABİLİR kıldı
E1  "bir alanı TAŞIYICI olarak kullanan kod, tüketici aramasında bulunmaz"  → DISIPLIN'e
B1  "kapıyı TEK NOKTAYA koymak sınıfı kapatır — her çağıranın kendi Number()'ını
     yazması F8 ailesi, VE BİR ÇAĞIRAN UNUTTU"
```

---

## `Z73` — `Q15`: ROTA **ADINI KULLANICIDAN**, DAVRANIŞINI **ÜST KÜMEDEN** ALIR

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### `§1` · HÜKÜM
```
/submit                 YAŞAR   — FE'nin çağırdığı, DOĞRU ADLI yüzey
                        KAZANIR — SubmissionResult (validations + warnings)
                                  ⇒ Q13 uyarıları CANLI YÜZEYE İLK KEZ BUGÜN ÇIKAR
/submit-for-approval    ÖLÜR
```

**`(b)`'nin reddi iki satır:** FE değişikliği **+** etiket tersine çevirme = **iki dokunuş
fazla**; ve `submit-for-approval` adı **zaten fazlalık taşıyor** —
> **submit'in NE İÇİN olduğu ROTANIN işi, ADININ değil.**

### `§1a` · ⭐ ÖLÇÜMÜN ASIL BULGUSU
```
                     /submit          /submit-for-approval
yetki                MODES_SUBMIT     MODES_SUBMIT          ← AYNI
version/CAS          ✅               ✅                    ← İKİSİ DE (ilk sanı yanlıştı)
bütçe rezervasyonu   ✅               ✅
ek doğrulamalar      ❌               ✅
warnings             ❌               ✅ altı kalem
FE kullanıyor        ✅               ❌ SIFIR
etiket               "legacy"         "deprecated" + Deprecation header
```
> ### **İKİ ROTA BİRBİRİNİ DEPRECATED İLAN ETMİYOR — BİRİ DİĞERİNİN ÜST KÜMESİ,
> ### VE **YANLIŞ OLANI** ÖLÜME YAZILMIŞ.**

### `§2` · ⭐ `F12`'NİN SINIFI: **ÇÜRÜME DEĞİL, KARŞILANMA**

`ADR 0005 K2`'ye `F12` işlendi *(eski metin **üstü çizili** kaldı)*.

> ### **BU, `Z69 §4c` AİLESİNİN ÜÇÜNCÜ VAKASI — AMA İLK KEZ ÇÜRÜME DEĞİL KARŞILANMA.**
```
ÇÜRÜME       gerekçe YANLIŞLANDI      → hüküm yeniden kurulur, çünkü DAYANAĞI yok
KARŞILANMA   gerekçe YERİNE GETİRİLDİ → hüküm yeniden kurulur, çünkü KOŞULU GERÇEKLEŞTİ
```
`K2` bir **KOŞULLU HÜKÜMDÜ** ve koşulunu **kendi metninde** taşıyordu:
*"ek doğrulama ayrı bir **ürün kararıdır** ve **UI'da karşılığı hazırlanmadan** yapılmamalı."*
İki koşul da bugün **karşılandı**: karar `Q13`/`Z71`, UI karşılığı `Q14` dalgası.

⚠️ Ve `K2`'nin **ikinci** gerekçesi (*"bugün submit edilebilen yarın da edilebilmeli"*)
**korunur ve taşınır** — tüm `Q13` katmanı `warnings`, **bloklamaz** (`K-2.2.7c`).

⛔ **Kayıtta bu ayrım GÖRÜNMELİ: ikisi farklı sınıf.** Bir gerekçenin **yanlışlanması**
hükmü zayıflatır; **karşılanması** hükmü **tamamlar**.

### `§3` · DALGA PAKETİNE **DÖRT ŞART**

| # | şart |
|---|---|
| **1** | **Ölen rotanın KONSOLİDASYON TARAMASI** — `submit-for-approval`'ın **tüm** çağıranları. FE-sıfır **ölçüldü**, ama **`test`/`script`/`doc` evreni de**: ⛔ `E1` dersi **taze** — *taşıyıcı kullanım aramada görünmez*. `rg -i` **TAM EVREN**, ölü-link/ölü-buton kalıntısı dahil (`T-307 m2` usulü) |
| **2** | **`SubmissionResult` geçişi FE tarafında SÖZLEŞME-PİNLİ** — `PlanDetailPage:107`'nin yeni dönüş şeklini **okuduğu** (uyarıların **render edildiği**) bir test. ⛔ Yoksa uyarılar rotaya taşınır **ama ekranda yine ölü doğar**; bu dalganın **var-oluş cümlesi** *"uyarı kullanıcıya **ULAŞIR**"*, **pin de tam onu ölçmeli** |
| **3** | **`B3` ölümü BEKLENEN-DEĞİŞİM LİSTELİ** — hardcode banner'ın bugün **yanlış** gösterdiği planlar (`null`-ROI'liler · `AMBER`/`RED`/`LTA_ONLY`'ler) yarın **banner-sız**. Bu bir **düzeltme** ama **görünür değişim**; ⚠️ Finance gözüyle *"uyarılar azaldı"* okunabilir — **listede adıyla dursun** |
| **4** | **`S9` UI etiketi** — tanım genişlemesi **üç katmanda** görünür: liste + `Z` kaydı + **tooltip** (*"Risk = zarar + kârsız-büyüme + hedef-altı"*) |

### `§4` · DALGA SONRASI
`Q13`–`Q15` zinciri **tamam**, `W2`'nin **tüm artıkları kapalı** ⇒ **PLANLAMA MASASI**:
`ŞART-6 × T-334/T-342 kesişimi` + `W3` önü + **kuyruk triyajı**
(`T-335`…`T-341` · `T-333` · `T-325`).

---

## `Z74` — `S1` KAPANDI: MEKANİK DEĞER **FU-VARSAYILAN + SKU-OVERRIDE**

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `docs/research/TTM_ELIGIBILITY_ENVANTERI.md` (`T-345`) · referans belge `§2`/`§6-5`

### `§1` · HÜKÜM
```
FU-DÜZEYİ VARSAYILAN  +  SKU-DÜZEYİ OVERRIDE
```

| kalem | hüküm |
|---|---|
| **`tactic_values.sku_id`** | **NULLABLE ANLAM KAZANIR**: `NULL` = **FU değeri geçerli** · dolu = **o SKU için EZME** |
| **spend hesabı** | **SATIR düzeyinde ÇÖZÜMLENMİŞ** değeri okur |
| **çözümleme kuralı** | SKU-override varsa **o**, yoksa **FU değeri** — ⛔ **TEK RESOLVER**, `targetRoi` deseni: **kapı tek noktada** |
| **Excel davranışı** | **KORUNUR** — satır farklılaşması **mümkün** |
| **TTM sadeliği** | **VARSAYILAN YOLDA YAŞAR** — planner **tek değer** girer, **gerektiğinde ezer** |

### `§1a` · ⭐ VE `TTM`'İN ÖLÜ KOLONU **DİRİLDİ**
> **`tactic_values.sku_id` kolonu + FK duruyordu, hiç yazılmıyordu.**
> ### **ÖLÜ DOĞMUŞ DEĞİL — ERKEN DOĞMUŞ ÇIKTI.**

📌 `T-345`'in envanteri onu *"ölü kolon"* diye kaydetmişti; hüküm ona **işini verdi**.
⇒ **Bir yapının kullanılmıyor olması, yanlış olduğu anlamına gelmez** — `@deprecated`
ailesinin **olumlu** yüzü: *bir niyet beyanı bir ölçüm değildir*, ve **ölçüm de bir hüküm değildir.**

### `§1b` · `Q16` **ÇÖZÜLDÜ — bu modelle uyumlu**
```
"FU'da mekanik yok"  =  FU değeri DE YOK, override DA yok
⇒ UYARI, BLOK DEĞİL          [hüküm verili]
```
⇒ `T-344`'ün muhafazakâr seçimi (`warnings.push`) **doğrulandı** — değişiklik gerekmiyor.

### `§2` · BU KARAR **ÜÇ İŞİ KİLİTLEDİ**
```
1  W3-BASELINE veri şekli    mekanik değerler FU-ANA + SKU-İSTİSNA olarak taşınır
2  T-346 ELIGIBILITY         grid uygun-tactic kolonlarını FU DÜZEYİNDE açar;
                             SKU satırları OVERRIDE-EDİLEBİLİR hücre gösterir
3  OMURGA SENARYO 5. adım    SC-mech-1 tohumunun KESİNLEŞMİŞ hâli — AYIRT EDİCİ:
                             "FU'ya girilen oran SKU'larda GÖRÜNÜR;
                              bir SKU'da EZİLİR; spend AYRIŞIR"
```
⛔ **Üçüncüsü bir senaryo değil, bir PİN sözleşmesidir** — `T-273` ailesine karşı:
fixture **ezme olan ve olmayan SKU'yu birlikte** taşımalı, ve **spend'in ayrıştığını
OKUYAN** bir assertion olmalı (`T-332`).

---

## `Z75` — `FAZ-2` İKİNCİ YARI: ALTI HÜKÜM · `DALGA 0` ∥ `ŞERİT A'` AÇILDI

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `FAZ2_IKINCI_YARI_PLANLAMA_MASASI.md` · `KUYRUK_TRIYAJI.md` · `FRONTEND_DURUM_ENVANTERI.md`

### `§1` · `K1` — `T-027` **YENİDEN AÇILIR**, ama *"geri alınır"* değil **"YENİDEN KURULUR"**
> ### `Z69 §4c`'NİN DERS KİTABI VAKASI.
```
T-027'nin "bilinçli ?? 0" kararı  →  LTA motorunun BAĞLI OLMADIĞI ve
                                     formül-kanonun ESKİ olduğu bir dünyada verildi
T-293 / T-334                     →  O DÜNYAYI DEĞİŞTİRDİ
⇒ gerekçe MEKANİZMASINI KAYBETTİ
```
⛔ **`T-337`'nin İLK ADIMI HÜKÜM DEĞİL ÖLÇÜM** — çağrı yeri başına:
```
bu `0` ÇÖZÜLMÜŞ DEĞER mi   (LTA yok ⇒ harcama GERÇEKTEN 0)
      SESSİZ VARSAYILAN mı  (veri eksik ⇒ NOT_EVALUABLE olmalı)
```
📌 **Emsal `B1`'in `toFiniteNumber` deseni: ayrım TEK RESOLVER'DA yaşar, ÇAĞIRAN BAŞINA değil.**
⇒ Ölçüm tablosu gelince hüküm verilir. **`DALGA 2`'nin kilidi böyle açılır.**

### `§2` · `K2` — `plan.service:2915`'in `20.0`'ı **ÖLÜR** *(hüküm ZATEN VERİLİ)*
İki tur önce: ***"sessiz-yirmi, sessiz-sıfırın kardeşi."***
⛔ **Ve tekrar sorulmuş olması bir `DALGA 0` VAKASIDIR:**
> ### **VERİLEN HÜKÜMLERİN DE İNDEKSİ SÜRÜKLENİYOR.**
**İniş:** `2a` ailesiyle.

### `§3` · `K3` — `EK_E` **GÜNCELLENİR**; envanter **kanonik olmaz, GİRDİ olur**
> **İkilem yanlış kurulmuştu:** `EK_E` **yaşayan kayıt**, FE envanteri **ölçüm**.

**Yapılacak:**
```
1  EK_E'ye İKİ YENİ EKSEN — 🔒 artık ÜÇ BOYUTLU:  arayüz / ROTA / ROL
   kanıt: /finance — 8 widget CANLI · menü yolu YOK · READONLY GÖREMİYOR
2  bayat sayımın F12'si
3  kaynak satırı: "FE envanteri, 2026-08-30 ölçümü"
```
⚠️ `EK_E` **donmuş** listede ⇒ `Z1` gereği bu **kayıtlı bir değişikliktir** (bu bölüm).

### `§4` · `K4` — `spend-calculation` uçları: **İKİ YOL KURALI**
| küme | hüküm |
|---|---|
| **`K-2.1.8i` taşıyan uç** | **`Faz-2-ŞART`** — dağıtım görünürlüğü **ilk-müşteri-değeri** süzgecinden geçer; planner'ın spend dağılımını görmesi **omurga akışın 6. adımının parçası** ⇒ **KABLOLANIR** |
| **kalan yedi uç** | ⛔ **`T-267` emsali: bir uç ya TÜKETİCİ KAZANIR ya ÖLÜR.** Sekiz uç **süresiz tüketicisiz duramaz** |

**`W3` masasında uç-uç yerleşim:** hangileri **baseline/grid işinin doğal tüketicisini
bekliyor** *(bekler — **koşul satırıyla**)*, hangisi **spekülatif doğmuş** *(ölür)*.

### `§5` · `K5` — ÖLÜ KOD + UYDURMA VERİ: **EVET, ve SIRA KRİTİK**
> ### **TEST ÖNCE ÖLÜR, KOMPONENT BİRLİKTE.**
```
1  ÖLÜM KANITI raporda       üretim çağrısı SIFIR + POZ. KONTROL
2  komponent + testi AYNI DIFF'te ölür
     test kalırsa      → yol "CANLI" görünmeye devam eder
     komponent kalırsa → test onu DİRİLTME BAHANESİ olur
3  dört ölü menü linki (404 üreten) AYNI temizlikte — `D1` emsali:
   ⛔ VAAT KALDIRILIR — rapor/analytics gerçeği geldiğinde LİNKİYLE DOĞAR
```

### `§6` · `K6` — DALGA PLANI **ONAYLI**: `DALGA 0` ∥ `ŞERİT A'` **hemen ve paralel**
```
DALGA 0    kod YAZMIYOR (ölçüm/muhasebe)
           ⛔ ve 65-review limbosunun 62-doğrulanmamışı TAM ÖLÇÜM DALGASI İŞİ —
             "genelleme 3/65'ten kuruldu" DÜRÜSTLÜĞÜ, Dalga-0'ın VARLIK GEREKÇESİ
ŞERİT A'   CANLI-YANLIŞ (T-318 emsali: KIRMIZI-GERÇEK her şeyi önceler)
```
**İki şart:** `A'` dalgaları **izole worktree** · **tam e2e Team Lead'de** *(yazılı)*.

⛔ **VE `DALGA 0`'IN ÇIKTISINA BİR KALICILIK ÖNERİSİ EKLENİR:**
> Sekiz vakalık `BACKLOG` ↔ dosya sürüklenmesi **bir daha ELLE yakalanmasın** —
> ucuz bir **tutarlılık kontrolü** (`status` çapraz-grep, **kapı adayı**) `DALGA 0` **önerir**,
> **kapı-enflasyonu süzgecinden** geçirip karar verilir.

### `§7` · İKİ KAYIT
**`7a` · `spend-validation`'ın dört sabiti** — `A'` **değil BORÇ**, ama ⛔ **yorum kirliliği
HEMEN düzeltilir**: yorumu *"Configurable thresholds"* diyen bir hardcode,
> **yanlış yorum `T-084` KORUMASI ÜRETİR.**
Sabitlerin `§2.3` inşası **`B'` borç dalgasına**, `T-138` ölçümüyle.

**`7b` · `T-240` vakası — `Z60` ailesinin EN TEMİZ YENİ ÜYESİ**
```
ledger_entries  0 → 3 OLMUŞ        kayıt HÂLÂ "0" DİYORDU
```
> ### **VERİYE DAYALI HER ERTELEME, VERİNİN DEĞİŞTİĞİ GÜN YENİDEN ÖLÇÜLÜR.**
*"Örtü kalkar, kayıt kalkmaz"* — erteleme gerekçesinin **zaman ekseni**.

---

## `Z76` — `Q17`/`Q18`/`Q19` + `§2.3`'ün ÖLÇÜMLE KAPANMASI

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte

### `§1` · `Q17` — **ÖNCE `(B)`**, `(A)` onun **ARTIĞINA** göre boyutlanır
```
(B) TÜREV   statü kolonu tek kaynaktan RENDER edilir
            ⇒ M1 senkronsuzluk · M2 append-only okuma · M3 hücredeki `|`
              ÜÇÜ DE VAR OLAMAZ  (render eden kod TEK, kaynak TEK)
(A) TESPİT  KALAN yüzeye göre — muhtemelen yalnız M4 serbest metin + türetilemeyen ANLATI
```
> ### **`(A)`'YI ŞİMDİ YAZMAK, `(B)`'NİN ORTADAN KALDIRACAĞI SINIFLARA KAPI YAZMAK OLUR.**
⇒ **Kapı-enflasyonu süzgecinin kendisi** bu sırayı dayatıyor.

**Sıra:** `(B)` iner → **kalan yüzey ÖLÇÜLÜR** → `(A)` o **dar kapsamla** doğar.
⛔ **`(A)`'nın sözleşmesine ŞİMDİDEN yazılı üç şart:**
```
T-212 deseni     liste-tabanlı ratchet baseline (15 çözülmemiş sürüklemeyle KIRMIZI DOĞMASIN)
T-100 evren      HER ZAMAN tasks/*.md tamamı — ASLA git diff'ten
self-test        yapay sürükleme → exit 1 · geri al → exit 0
```
📌 **Ajanın iki tuzağı ÖNCEDEN sayması tam doğru refleksti.**

### `§2` · `Q18` — **ALTISI ÖLÜR** (`D1`'in GENİŞLETİLMİŞ gerekçesi)
> **`cursor-not-allowed` `404`'ten DÜRÜST ama VAATTEN MASUM DEĞİL.**

Altı kalem **adlarıyla bir rapor kataloğu vaat ediyor**, ve o adlar **`R` katmanı tasarımı
yapılmadan** verilmiş. Dahası:
> ⚠️ **Ürün gösterimi yaklaşırken, altı-tıklanamaz-kalemlik bir menü, demo'da
> *"bitmemişlik"* sinyalinin EN GÖRÜNÜR hâli.**

⇒ Kural aynı: **vaat kaldırılır, gerçek geldiğinde ADIYLA doğar.** `R` katmanı
*(masada zaten **"müşteri değerinin merkezi"** diye kayıtlı)* tasarlandığında menü
**gerçek rapor adlarıyla, çalışan linklerle** doğar.
⛔ **Üst "Raporlar" başlığı da altı çocuğuyla BİRLİKTE gider — BOŞ BAŞLIK BIRAKILMAZ.**

### `§3` · `Q19` — **DIALOG YAŞAR, ROTA ÖLÜR** (`Q15` emsali: **tek-yol ilkesi**)
Kullanıcının **fiilen kullandığı** yol (`CustomersPage` dialog) **ad ve davranışça yeterli**;
`/customers/new` **ikinci doğruluk kaynağı** ve **sürüklenme adayı** *(iki form ⇒ yarın
**iki farklı validasyon**)*.
⛔ **Ölürken KALINTI TARAMASI** (`T-307 m2`): linkler + testler + `rg -i 'customers/new'`.
📌 **`E1` dersi:** *taşıyıcı kullanım aramada görünmez* ⇒ **evren geniş tutulur.**

### `§4` · ⭐ `CLAUDE.md §2.3` — BELİRSİZLİK **ÖLÇÜMLE** KAPANDI
```
ESKİ   "sınır semantiği (>95 mi >=95 mi) ÇÖZÜLMEMİŞTİR … önce sor"
ÖLÇÜM  budget-threshold.service.ts:228-230
       percent >= critical → RED · >= warning → AMBER · else GREEN
```
⇒ **`>=`**. `ŞERİT A'` iki kopya-sapmayı (`critical`'ı `95` yerine **`100`** sanan) düzeltti.
✅ `CLAUDE.md`'ye `F12` işlendi *(eski metin **üstü çizili**)*.
> **Bir belirsizliğin TERCİHLE değil ÖLÇÜMLE kapanması — `§2.4`'ün istediği biçim.**

### `§5` · `reserved_amount` BULGUSU — **beklenen değişim olarak KAYITLI**
```
budget_envelopes kolonları: allocated_amount · consumed_amount   ⛔ reserved_amount YOK
⇒ /budget listesindeki utilization REZERVASYONLARI HİÇ SAYMIYORDU
düzeltme ÖZDEŞLİK: used = allocated − available, ikisi de v_budget_summary'den
```
> ⚠️ **Finance gözü: SAYI BÜYÜDÜ ≠ REGRESYON** — `budget-variance` ile **HİZALANMA**.

### `§6` · TURUN KALICI MİRASI
> ### **`status:` bir niyet beyanı · `@deprecated` bir niyet beyanı · **COMMIT MESAJI DA**
> ### — KOD ve DB **MEKANİZMANIN KENDİSİDİR**.**
`git log --grep` vakasıyla `DISIPLIN`'e girdi.
**İyi ki pozitif kontrol vardı: çalışan zil İKİNCİ KEZ *"yok"* ilan edilecekti.**

---

## `Z77` — `S1`: SUBMIT **DURMAZ**, REZERVASYON **REDDEDER** · `DALGA 2` AÇILDI

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Statü:** yürürlükte
> **Girdi:** `docs/research/K1_SESSIZ_SIFIR_OLCUM_TABLOSU.md`

### `§1` · HÜKÜM — ve bu **yeni bir icat DEĞİL**
> **`T-321`'in iki-eksen ayrımının VERİ-EKSİKLİĞİ hâli.**

| katman | davranış | gerekçe |
|---|---|---|
| **SUBMIT** | **DURMAZ** — `NOT_EVALUABLE` + **görünür uyarı, alan ADIYLA** *("`PLAN_VOL` eksik: 3 SKU'da spend hesaplanamadı")* | `ADR 0005 K2`'nin **korunan gerekçesi** + `Q13` **`warnings` sözleşmesi** |
| **REZERVASYON** | **REDDEDER** — açık hata kodu (`RESERVATION_INPUT_INCOMPLETE` sınıfı) | `§2.5`'in **tanım bölgesi**: para yoluna **sessiz `0` girmez**. Ve **ölçümün kendisi**: `0` rezervasyon **eşiği GEÇ ateşletir** ⇒ **sessiz-düşük rezervasyon, bütçe korumasının TERSİNE çalışır** |

> ### **`NOT_EVALUABLE` BİR ZARFA `0` YAZMAZ — YAZMAYI REDDEDER.**

### `§1a` · ⛔ İKİ RED SINIFI PİNDE **AYRI ADLANIR**
```
GİRDİ-EKSİKLİĞİ reddi   (bu hüküm)          ≠   T-321'in %100-BLOCKED EŞİK reddi
```
İkisi aynı *"RESERVE reddedildi"* yüzeyinden dönerse **ilk okuyucu karıştırır** ⇒
**hata kodu + mesaj ayrımı** taşır.

### `§2` · TEK-RESOLVER **ONAYLI** — ve desen artık **ADLI BİR AİLE**
> **"Bir çağıran unutuldu ⇒ DERLEME HATASI olur, BÜTÇE SAPMASI değil."**

`toFiniteNumber` *(`T-343`)* → `targetRoi` resolver *(`T-344`)* → **`resolveSkuSpendInputs`**:
**desenin üçüncü uygulaması.**
> ### **KAPI TEK NOKTADA, VE TİP ONU ZORLAR.**

`SKUContext` **nesne literaliyle hiçbir yerde inşa edilemez**; `A`/`B` ayrımı
**alan başına SABİT** taşınır.

### `§3` · ÜÇ KAYIT

**`3a` · ÖNCÜL PROPAGASYONU — kural artık İKİ VAKALI**
```
Z68 §1a   "AMBER İLK KEZ DOĞUYOR"    → ürün sahibi HÜKÜM-ŞARTI yaptı
K1        "approval-workflow:1011"   → Team Lead ÜÇ BRIEF'E taşıdı
```
> ### **BİR REVIEW BULGUSU DOĞRULANMADAN BRIEF'E TAŞINDIĞINDA,
> ### PROPAGATÖR ARTIK REVIEW DEĞİL **TAŞIYANDIR**.**

⛔ Ve **üç yanlış-iddialı yorum/test** (`spend-calc:786` · `plan.service:2464` ·
`role-journey.e2e:705/857`) **`T-084` koruması üretmeden BU DALGADA düzeltilir**.

**`3b` · `166/170` KANITI — `A`/`B` AYRIMININ ŞEMA-KANITI**
```
skus.cogs   NULL 166/170        cogs = 0 olan satır:  SIFIR
```
> ### **`0` MEŞRU BİR DEĞER OLSAYDI, VERİDE EN AZ BİR TANE OLURDU.**
⇒ Sessiz-varsayılan tartışmalarının bundan sonraki **ilk ölçümü bu sorgu şeklidir**.

**`3c` · `calculateAllSpendsForFU` — DOKUZUNCU ADAY, `Z75 §4` kuralı işler**
Ya **tüketici kazanır** *(`W3`'ün grid-hesap yolu **doğal aday** — ölmeden önce o soru
cevaplanır)* ya **ölür**. Karar **`W3` tasarımıyla birlikte, KOŞUL SATIRIYLA**.

### `§4` · `DALGA 2` AÇILDI
```
2a  T-027 YENİDEN KURULUŞ   tek-resolver + A/B alan-başına-sabit
                            + canlı DÖRT `B`'nin ölümü + submit/rezervasyon ayrımı
2b  parser                  T-341 + T-102 + T-099
2c  LTA                     T-335 → T-336
izole worktree · tam e2e Team Lead'de
```
⛔ **BEKLENEN-DEĞİŞİM LİSTESİ ŞİMDİDEN BİR SATIR TAŞIYOR:**
> **REZERVASYONLAR ARTACAK** — `planVol`/`unitPrice` eksik planlar bugün **düşük rezerve**.
> Düzeltme **Finance gözünde *"bütçe daha hızlı doluyor"*** okunur. **Adıyla listede.**

---

## `Z78` — `Q20` ÜÇ-SINIF SATIR · `Q21` STATÜ KÜMESİ KAYNAKTAN · `Q22` ÖMÜR-BOYU TEKİLLİK

**Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Dalga:** `2a` kapanışı + `2c` inişi

### `§1` · `Q20` — BOŞ SATIR: **`(c)`**, VE AYRIMI **SATIRIN OLGUSU** YAPAR

```
DOKUNULMAMIŞ  (tüm girdi-alanları NULL — VARSAYILAN DOĞUM HÂLİ)
              = "planlanmadı" → spend-katkısı YOK (0 DEĞİL, KATILMIYOR)
              → rezervasyonu BLOKLAMAZ
KISMİ         (en az bir girdi dolu, gerekli biri eksik: planVol var / BPTT yok)
              = NOT_EVALUABLE → rezervasyon REDDİ, ALAN ADIYLA — `Z77` AYNEN yaşıyor
PLAN düzeyi   dolu-satır-sayısı 0 → submit-uyarısı "boş plan" (BLOKLAMAZ, `Q16` ailesi)
```

> ### **`Z77`'NİN KORUDUĞU TEHLİKE *GİRİLMİŞ-AMA-EKSİK* VERİNİN SESSİZ-`0`'A**
> ### **DÜŞMESİYDİ. NULL-SATIR İSE *GİRİLMEMİŞ* — FARKLI OLGU.**

⛔ **`(b)` REDDEDİLDİ ve reddi AYAKTA:** *dokunulmuş-eksik satır asla `0` sayılmaz.*
Hükmün kendi cümlesi: plan düzeyi **yalnız uyarı katmanıdır**, ayrımı yapan **satırın
olgusudur** — bir plan-bayrağı değil.

**`1a` · EVRENİ ÖLÇÜM SEÇTİ, TERCİH DEĞİL** (Team Lead, 2026-08-31):
```
main.plan_skus              base_volume · planned_volume  → nullable, DEFAULT YOK
                            diğer sayısal kolonlar        → NOT NULL DEFAULT 0 / türetilmiş
main.plan_mechanic_values   plan_sku_id kolonu YOK — UNIQUE(plan_fu_id, mechanic_id)
                            ⇒ SKU-düzeyi GİRİLEN mekanik bugün ŞEMADA YOK
plan.service.ts:558         addSku(planFu.id, sku.id, tenantId, userId)  ⛔ hacim GEÇMİYOR
⇒ HER SKU SATIRI base_volume=NULL, planned_volume=NULL DOĞAR
```
⇒ *"satırın girdi-alanları"* evreni **iki kolondur**. `BPTT`/`COGS` satırın alanı
**değil**, SKU ana-verisinin alanı — planlayıcı onlara satırda dokunmaz.

⚠️ **VE BU EVREN GENİŞLEYEBİLİR:** `Z74`'ün *"FU-varsayılan + SKU-override"* hükmünün
SKU tarafı **henüz şemada yok**. Geldiği gün evren büyür ⇒ **tek bir yerde, adlandırılmış
bir sabit** olarak tutulur. *(`DISIPLIN`: "veriye dayalı her erteleme, verinin değiştiği
gün yeniden ölçülür" — burada erteleyen şey veri değil **şema**, ama şekil aynı.)*

**`1b` · PIN ÜÇLÜSÜ — hüküm üç vakayı SAYIYLA verdi, üçü de TEST oldu:**
```
1  1-dolu + N-boş plan  → submit OLUR, rezervasyon YALNIZ dolu satırı taşır
2  kısmi satır          → REDDEDİLİR, ALAN ADIYLA
3  0-dolu               → UYARI, bloklamaz
```
⛔ Birincide **rezervasyon TUTARI ölçülür** — *"yalnız dolu satırı taşır"* bir **sayıdır**,
bir cümle değil; `1-dolu` ile `2-dolu` **farklı** değer vermezse test ayırt etmiyordur
(`§2.7 #6`).

**Beklenen-değişim:** 19 e2e yeşile döner — **attribution zaten kanıtlıydı** (kapı devre
dışı → `129/129`).

### `§2` · `Q21` — `{APPROVED, ACTIVE}`: KAYNAKTAN, İCAT DEĞİL

```
docs/brd/01_Main_BRD/Section_04…:603
  if (lta && lta.status !== 'ACTIVE' && lta.status !== 'APPROVED')
```
`L2` ve ADR'ler bu noktada **sessiz** — ve sessizlik *"kural yok"* değil,
*"kaynak BRD'dir"* demek (`§2.2`'nin şekli).

**`CLOSED` bilerek DIŞARIDA**, ve açık soru **koşul satırıyla** kayda:
> **`CLOSED` anlaşmanın GEÇMİŞ-DÖNEM OKUMALARI ayrı sorudur (okuma-yolu, planlama-yazımı
> değil) — İLK GERÇEK `CLOSED` VAKASI TETİKLER.**

**`2a` · BEŞİNCİ KOPYA YAZILMADI — ve gerekçe ürün sahibince ONAYLANDI:**
> **"DÖRDÜ AYNI *DEĞERİ* TAŞIYOR, AYNI *SORUYU* SORMUYOR."**

⇒ Birleştirme **YAPILMAZ**: birleştirmek, birini değiştiren kararın diğer üçünü
**sessizce kaydırması** olurdu. Ama hüküm bir **ek** getirdi:
> ### **DÖRT KOPYAYA ÇAPRAZ-REFERANS YORUMU DÜŞÜLÜR —**
> ### **BİRİ DEĞİŞİRSE DİĞER ÜÇÜNÜN *BİLEREK* DEĞİŞMEDİĞİ GÖRÜNÜR OLSUN.**

📌 Bu, `F8` ailesinin (*"aynı sayı dört yerde dört farklı"*) **ikinci panzehiridir** ve
birinciden farklıdır: birincisi *"tek kaynağa indir"*, bu ise *"indirilemeyeni
**görünür** kıl"*. Kopya meşruysa, meşruiyeti **yazılı** olmalıdır.

### `§3` · `Q22` — `(iii)`: "BİR EBEVEYN = BİR BAŞLIK, ÖMÜR BOYU" · İKİ INDEX TEK PAKET

```
alreadyBound   manager.findOne(LTAAgreement, {where:{tenantId, agreementId}})  withDeleted YOK
findByCode     repository.findOne({where:{tenantId, agreementCode}})           withDeleted YOK
DB             UQ_lta_agreements_agreement_id · IDX_lta_agreements_tenant_code
               İKİSİ DE KISMİ DEĞİL ⇒ soft-delete edilmiş satır YERİ İŞGAL EDER
⇒ soft-delete → yeniden bağlanma:  ham QueryFailedError → 500
```
**İniş:** iki ön-kontrole `withDeleted: true` ⇒ **`500 → 409`, doğru mesajla.**
**MIGRATION YOK** — DB tarafı zaten ömür-boyu tekil; değişen tek şey ön-kontrolün onu
**görmesi**.

⛔ **`(c)` YOLU AÇIK KALIR ve TESTLE PİNLENİR:** `terminate → FARKLI ebeveyne yeni
başlık → 201`. `PATCH` mesajı **tam bunu** öneriyor.

**`3a` · `agreementCode` KARDEŞİ AYNI HÜKÜMLE, AYNI DALGADA** — kod da ömür-boyu tekil,
aynı gerekçe. `§7.1`'in birebir şekli: *"kardeş yol etkilenmiyor" iddiası ölçülmeden
yazılamaz* — burada ölçüldü ve **etkileniyordu**.

**`3b` · `T-335` HİZASI, `(ii)`'NİN REDDİ:**
> **YENİDEN MÜZAKERE EDİLEN ORAN, EBEVEYNİN ESKİ ONAYINI MİRAS ALMAZ.**

### `§4` · ÜÇÜNCÜ PROPAGASYON VAKASI — PRATİĞİYLE BİRLİKTE ONAYLANDI

`DISIPLIN` girdisi (`ÖNCÜL PROPAGASYONU — ÜÇ VAKA`) ürün sahibince **onaylandı**, ve
mekanizması da:
> **BİR REVIEW BULGUSU DA BİR İDDİADIR — BRIEF'E GİRDİĞİ AN *TAŞIYANIN* İDDİASI OLUR.**
> **YA ÖLÇ, YA `[REVIEW İDDİASI — DOĞRULANMADI]` DİYE ETİKETLE.**

⇒ Etiketlenmiş iddia **ajanın ilk işi** olur. *(İkinci kopya yazılmadı — kural
`DISIPLIN.md` gövdesinde (*"ÖNCÜL PROPAGASYONU — ÜÇ VAKA, VE İKİSİ AYNI TAŞIYICIDAN"*); bu satır ona atıftır, `§2.1` şekli.)*

### `§5` · ÜÇÜNCÜ EKSENİN DUR MADDESİ **ATEŞLENDİ** — ve ÇALIŞTI

`Z78`'in iki şeridi paylaşılan ağaçta paralel koştu. Brief'lerdeki madde:
> *"Senin OLMAYAN bir dosyada `tsc` hatası görürsen **DÜZELTME — DUR ve bildir.**"*

**Ölçülmüş olay (`Q21`/`Q22` şeridi, 2026-08-31):** tur boyunca **iki kez**
`plan.service.ts:2673/2677` `SpendInputResolution.ctx` derleme hatası gördü — paralel
şeridin **ara durumu**. Şerit **düzeltmedi**, bekledi, yeniden ölçtü; hata kendiliğinden
geçti (diğer şerit adımını tamamladı).

```
T-269 ∥ T-270 (2026-08-23)   yarım iş → diğerinin ÖLÇÜM ARACI bozuldu → tur KAYBEDİLDİ
Z78 iki şerit (2026-08-31)   yarım iş → DUR maddesi → bekle → yeniden ölç → tur KAYBEDİLMEDİ
```

> ### **KURALIN İŞE YARADIĞININ KANITI, İHLALİN OLMAMASI DEĞİL —**
> ### **TEHLİKENİN ATEŞLENİP *DURDURULMASIDIR*.**

📌 Ve dikkat: şerit *"kırmızı gördüm, kendi işim bozuk"* diye **yanlış teşhis koymadı** —
`§2.7`'nin en pahalı şekli olan **"kırmızı, ama kendi kodundan değil"** tam olarak burada
elenmiş oldu. Madde brief'te **yazılı** olduğu için; `T-269`'da şansa kalmıştı.

### `§6` · `Q22`'NİN YAYILMA YARIÇAPI ÖLÇÜLDÜ (`§7.1`) — ŞERİT SORMAMIŞTI

`withDeleted: true` bir **okuma** yolunda da olabilirdi. Team Lead ölçtü:
```
ltaRepository.findByCode çağıranları:  lta-agreement.service.ts:106 · :250
                                       İKİSİ DE TEKİLLİK KONTROLÜ — okuma yolu YOK
```
⇒ yarıçap tam olarak hedeflenen yer. ⚠️ **`findByCode` proje-genelinde bir İSİMDİR**
(20+ repository'de var) — tarama `ltaRepository.` nitelemesiyle yapılmalıdır, yoksa
`DISIPLIN`: *"kapsam maskelemesi — desen çalışır, evren yanlıştır"*.

**Ve `§2`'nin sayısı ŞERİT TARAFINDAN DÜZELTİLDİ:** Team Lead brief'te *"dört kopya"*
demişti; ölçüm **beş yer** dedi (kanonik `IN_FORCE_AGREEMENT_STATES` + **dört** satır-içi).
Yorumlar *"BEŞ yerde"* yazıyor. ⇒ `DISIPLIN`: *"elle yazılmış üye-sayısı"* — **onda on.**

### `§7` · REVIEW KALEMLERİ — BEŞİ KAPANDI, ÜÇÜ TASK'A

`code-reviewer`, `2a`+`2b`+`2c` birleşik diff'inde **bloklayıcı bulmadı**. Kapananlar:

**`7a` · `Q21`'İN YORUMLARI KENDİ ADRESLERİNİ BAYATLATTI** *(🟡-2 — ve sınıfın en
saf örneği)*
```
yorumda yazan            diff ÖNCESİ   diff SONRASI (gerçek)
reversal:17                  17 ✓           30
settlement-close:62          62 ✓           75
off-invoice:134             133 (kaymış)   144
agreement.service:1035     1035 ✓         1045
```
> ### **YORUMLARIN KENDİSİ 10–13 SATIR EKLEDİ VE *KENDİ VERDİKLERİ ADRESLERİ* KAYDIRDI.**

⇒ `Q21`'in **tek teslimatı** bu yorumlardı ve **doğdukları anda yanlıştılar**. Düzeltme:
satır numarası **atıldı**, sembol adı kondu (`#REVIEW…_STATES`, `#validateRow`, `#cancel`)
— **kanonik satır zaten öyle yazılmış ve bayatlamıyordu**, model oradaydı.

⛔ **VE DÜZELTİRKEN AYNI SINIFA DÜŞÜLÜYORDU:** review `#validateOffInvoice` önerdi;
**öyle bir metot YOK** (ölçüm: `validateRow` · `validateBatch`). Ölçülmeden taşınsaydı
**bayat adres HAYALİ adresle** değişirdi — `§4`'ün kuralı (*"bir review bulgusu da bir
iddiadır"*) **yazıldığı turda, yazan tarafından** sınandı ve tuttu.

**`7b` · `calculateAllSpendsForFU` SÖZLEŞMEYİ İHLAL EDİYOR — SAPMA YAZILDI** *(🟡-1)*
```
plan.service (recalc)     kind !== 'UNTOUCHED' && ctx !== null ⇒ ÇAĞIRIR ⇒ taban zinciri KOŞAR
calculateAllSpendsForFU   kind === 'NOT_EVALUABLE' ⇒ continue   ⇒ satırı TAMAMEN ATAR
```
`sku-spend-inputs.ts`'in *"`PLAN_VOL` yok, `BPTT` var ⇒ ctx VAR — taban zinciri koşar"*
sözleşmesi **ihlal**. Marka her iki çağıranı resolver'a zorluyor ama **üç `kind`'ı aynı ele
almaya zorlamıyor** — markanın ölçülmüş **sınırı**.

**Düzeltilmedi, ve bu bir ERTELEME DEĞİL bir RANDEVU:** üretim çağıranı **SIFIR** ⇒ canlı
para etkisi yok; metot `Z77 §3c`'nin **dokuzuncu adayı** (*"ya tüketici kazanır ya ölür,
karar `W3` ile"*). O karar günü ayrışma da kapanır. Sapma **koda yazıldı**.
> **Bir sapmayı YAZMAK onu doğru kılmaz; GÖRÜNÜR kılar** — ve `T-084`'ün dersi tam tersiydi
> (*"bir hatayı belgelemek onu koruma altına alır"*). Fark: orada yorum *"dokunma"* diyordu,
> burada **randevu tarihi** veriyor.

**`7c` · GÜVENLİK BİR BAYRAKTAYDI** *(🟡-3)* — `--runInBand` `package.json` script'indeydi,
`jest-e2e.json`'da **yoktu**. Bayraksız çağıran paralel worker alır ve seed mutasyonu
yarışır ⇒ `"maxWorkers": 1` **konfigürasyona** kondu. `CLAUDE.md`: *"kuralı hatırlamak
yerine ARACI çağır."*

**`7d` · LOG MESAJI KOŞULU SÖYLEMİYORDU** *(🟡-4)* — *"BLOCKS reservation"* diyordu, ama
kapı `locked.kind === 'USABLE'` **dalının içinde**: `NO_SPEND` bir planda hiç koşmuyor.
`Z75 §7a` sınıfı (*"yorum kendi kodunun tersini söylüyor"*), **on satır yukarıdaki kendi
gerekçesiyle** çelişiyordu.

**`7e` · PIN AYIRT ETMİYORDU** *(🟢-2)* — `/ömür boyu tekil/` **her iki** mesajda da var
⇒ ebeveyn-bağını kod-çakışmasından ayırmıyor (`§2.7 #6`). `/yeri tutar/` + constraint adı.

**Task'a giden:** `🟡-5` `incrementalVolume`'ün üç türetimi (`§7.1`) · `🟡-7` `src/common/`
→ `src/modules/` katman yönü · `🟢-1` ölü `SPEND_INPUT_FIELDS` export · `🟢-5` lumpsum
`Number(...) || 0`.

### `§8` · ÇÖZÜLMEMİŞ BİR SAYIM FARKI — VE ÇÖZÜLMEMİŞ OLARAK KAYDA GİRİYOR

```
Team Lead (önceki tur)   "19 e2e kırmızı"
şerit A (ölçtü)          "16 kırmızı — hepsi role-journey.e2e"
fark                     3
olası kaynak             2c ARADA indi, formula-canon + lta-lifecycle e2e'lerine dokundu
doğrulandı mı            ⛔ HAYIR — doğrulamak düzeltmeyi GERİ ALMAK demek
```
`DISIPLIN`: *"bir sayım farkı, farkın KAYNAĞI gösterilmeden yorumlanamaz."* Açıklama
**makul** — ve tam bu yüzden tehlikeli: **ölçülmemiş makul açıklama**, `§4`'ün üç
propagasyon vakasının da doğduğu yer. Bu satır bir **cevap değil, bir borçtur**.

---

## `Z79` — `BL` DOĞDU, `W3` ÖLDÜ: SEKİZ HÜKÜM + OMURGA GÖVDESİ

> **Tarih:** 2026-08-31 · **Karar:** ürün sahibi · **Girdi:** `W3_BASELINE_PLANLAMA_MASASI.md`

### `§1` · `W1` — ADLANDIRMA: **`BL`** (Baseline Hattı) · **`W`-SERİSİ KAPANDI**
```
kanonik    BL          iç adımlar BL-1..n · brief/rapor başlıkları BL
tarihî     "W3"        yalnız Faz-2-brief'inin SIRA REFERANSI olarak yaşar (F12 notuyla)
           B3-RBAC'ın W'leri  TARİHSEL
```
⛔ **VE GENEL KURAL:** bundan sonra **her dalga BENZERSİZ ÖNEK alır**.
> ### **AYNI HARFİN DÖRT İŞİ, BU MASANIN İLK BULGUSU OLACAK KADAR PAHALIYDI.**
`F8` ailesinin (*"aynı sayı dört yerde dört farklı"*) **ad tarafı** — ve ilk kez bir
**adlandırma disiplini** olarak kapatıldı, tek tek düzeltmeyle değil.

### `§2` · `W2` — VERİ ŞEKLİ: **`(a)`** `plan_mechanic_values` + nullable `plan_sku_id`
```
plan_sku_id NULL  = FU değeri geçerli
plan_sku_id dolu  = o SKU için EZME
çözümleme          TEK RESOLVER — SKU satırı varsa O, yoksa FU  (targetRoi deseni)
```
**İki şart, ikisi de bağlayıcı:**
1. ⛔ **UNIQUE kısıtı `K-2.2.8c` dersiyle** (`L2_01:561-569`): kısmi-tuple eşitliği
   **düşünülmüş** olsun — **`NULLS NOT DISTINCT`** + resolver'da **açık öncelik**,
   **gizli tie-break YOK** (`§2.5`).
2. ⛔ Migration **`plans=0` penceresinde** iner. *(Pencere kapanırsa iş bir **veri taşıma**
   işine dönüşür — ve o BAŞKA bir karardır.)* Numara **`1821000000000`** tahsis edildi.

**Reddedilen iki aday, gerekçeleriyle kayda:**
| aday | red gerekçesi |
|---|---|
| `plan_fus.tactics` jsonb | **tipsiz** — `SKUContext` markasıyla kurduğumuz **tip-zorlaması ailesine aykırı** |
| `mechanic_spend_breakdown` | eksen **hazırdı** (`UNIQUE(plan_sku_id, mechanic_id)`) — **ve tuzak buydu** |

> ### ⛔ ÇIKTI TABLOSUNA GİRDİ KOYMAK, BİR SATIRI **HEM KAYNAK HEM SONUÇ** YAPAR.
> **`DISIPLIN`'in *"denetlenen ≠ okunan"* ekseninin VERİ HÂLİ** — ve TL'nin teşhisi
> ürün sahibince *"doğru"* bulundu. Bir eksenin **hazır olması**, o eksenin **doğru yer**
> olduğu anlamına gelmez.

### `§3` · `W3` — IMPORT OLGUSU: **ÜÇLÜ DÖRDE ÇIKMAZ**
> ### **IMPORT BİLİNÇLİ BİR VERİ-GETİRME EYLEMİDİR;**
> ### **GRID'İN *"HENÜZ GİRİLMEDİ"* ARA-DURUMU ORADA YOKTUR.**
```
tam satır                → DOLU olgu
zorunlu alanı eksik satır → SATIR REDDİ, import raporuna SATIR + ALAN adıyla
                            ⛔ plana HİÇ girmez — YARIM SATIR İTHAL EDİLMEZ
```
⇒ `Q20` üçlüsü **değişmeden** kalır, ve `NOT_EVALUABLE` **import yoluyla üretilmez** —
yalnız **grid girişiyle** doğabilir. *(Masanın `1c` sorusu: cevabı bir dördüncü olgu değil,
bir **sınır** çıktı.)*

### `§4` · `W4` — KISMİ KABUL: **EVET**, ve `D4` etkileşimi TEK CÜMLEYLE ÇÖZÜLDÜ
```
satır düzeyi kabul/red + ADLI hata raporu
coverage kapısı  TOPLAM EVREN üzerinden sayılır — REDDEDİLEN SATIR "EKSİK"TİR
```
> ### **YOKSA *"KÖTÜ SATIRLARI ATIP KABUL-EDİLENLERİN %95'İ"* OYUNU DOĞAR.**
> **Kapı tanımı teşviki doğru yöne koyar: `%95`'e ulaşmanın TEK YOLU SATIRLARI DÜZELTMEK.**

📌 Bu, `§2.7`'nin *"kapsam maskelemesi"* ailesinin **metrik tarafı**: paydayı daraltmak,
oranı ölçmeyi bırakıp **oranı üretmek** olur.

### `§5` · `W5` — OMURGA GÖVDESİ (`1-4`), KABUL-ÇERÇEVESİ FORMATINDA
```
SC-O1 PLAN DOĞUMU    ROL Planner · ay+CPL+kategori → plan · detayda kategorinin
                     aktif SKU'ları FU-hiyerarşisiyle
                     AYIRT-EDİCİ: farklı kategori → farklı liste;
                                  boş kategori → GÖRÜNÜR MESAJ
                                  ⛔ BOŞ-AÇIKLAMASIZ GRID YASAK
SC-O2 ELIGIBILITY    kategori×CPL'de tanımlı tactic'ler KOLON olur; tanımsız HİÇ görünmez
                     AYIRT-EDİCİ: aynı kategori İKİ CPL'de FARKLI kolon kümesi;
                                  eligibility-boş → "bu eşleşmede tactic tanımlı değil"
                                  ⛔ catch{return[]} ÖLÜR (T-346)
SC-O3 HACİM GİRİŞİ   SKU'ya adet; dokunulmamış satır BLOKLAMAZ,
                     kısmi satır ALAN ADIYLA reddedilir  [Q20]
                     AYIRT-EDİCİ: 1-dolu + 51-boş plan submit OLUR,
                                  rezervasyon YALNIZ dolu satırı taşır
SC-O4 MEKANİK GİRİŞİ FU'ya oran → SKU'larda GÖRÜNÜR → bir SKU'da EZİLİR  [S1/Z74]
                     AYIRT-EDİCİ: override'lı SKU FARKLI spend üretir;
                                  FU değeri SİLİNİRSE SKU-override YAŞAR MI →
                                  resolver testinde
5-6                  KPI-kanon + submit uyarıları — T-334/Q13 zinciriyle KAPALI;
                     mevcut pinlere ATIFLA bağlanır, YENİDEN YAZILMAZ
```
⇒ Masanın `§6` bulgusu (*"ölçüt var, metni yok"*) **kapandı** — ve gövde bir senaryo değil,
**dört ayırt-edici** taşıyor. `SC-O4`'ün son satırı bir **açık soruyu** da doğuruyor
(FU silinince override yaşar mı) ve adresi **resolver testi**.

### `§6` · `W6` — SIRA: **`T-346` ÖNCE, `BL` SONRA** — sıralı, paralel DEĞİL
```
ürün sırası     omurga adım-3 eligibility → adım-4 öncesi baseline
ASIL gerekçe    DENEYİM: BL kullanıcının İLK GERÇEK VERİSİNİ getirecek
```
> ### **O VERİYİ ELIGIBILITY'SİZ YARIM GRID'E DÖKMEK,**
> ### **İLK-GERÇEK-AN'I BİTMEMİŞ YÜZEYE KURMAK OLUR.**

⛔ **VE `touches:` KURALINI AŞAN BİR HÜKÜM:** grid'e iki dokunuş **farklı bölgelere**
(kolon-türetme ↔ satır-veri); *"`touches:` ölçümü çakışma derse **bile** sıra değişmez,
kesişen dosya ikinci dalgada **rebase edilir**."*
📌 `CLAUDE.md §4`'ün kesişim kuralı **paralelliği** yasaklar, **sırayı** belirlemez —
sırayı **ürün** belirler. Bu ayrım ilk kez adıyla kondu.

### `§7` · `W7` — `calculateAllSpendsForFU`: **ÖLÜM** (dokuzuncu aday)
```
ölçüm       BL'nin ihtiyacı YOK (recalc FU-toplu hesabı zaten yapıyor) · tüketici SIFIR
zamanlama   sözleşme ayrışmasının canlıya çıkma anı BL  ⇒  BL-ÖNCESİ ÖLÜR
kapsam      metot + testleri + üç yanlış-iddialı yorum kalıntısı (2a'da düzelmediyse)
            ⇒ TEK KÜÇÜK TEMİZLİK COMMIT'İ
```
`Z75 §4` kuralı işledi: **tüketici kazanmadı, öldü.** ⇒ `Z78 §7b`'nin *"randevu"*su
**kapandı** — sapma yazılıydı, tarihi geldi.

### `§8` · `W8` — **`8b` ÖNCE**, `8a` `BL` İÇİNDE AMA KARAR TABLOSUYLA

**`8b` (FE'nin 40 sessiz sıfırı) `BL`-öncesi kendi dalgasında iner:**
> `Q20`'nin **görüntü katmanı geri-alımı**, ve *"veri-sıfır yeşili"* riskinin **UI yüzü**.
> `NOT_EVALUABLE` ekranda **`—` / "hesaplanamadı"** olur (`targetRoi` emsali) ⇒ gerçek
> eksik-veri geldiğinde **kullanıcının ilk gördüğü şey DÜRÜST olur.**

**`8a` (altı yazarsız kolon) `BL` dalgasının İÇİNDE, ama önce karar tablosuyla:**
```
altı kolonun HER BİRİ T-270 kuralından geçer: YA YAZAR KAZANIR YA ÖLÜR
okunan ikili (finance-reporting'in spendOf'ları)  →  YAZAR KAZANMAK ZORUNDA
kalan dördün kaderi                                →  ÖLÇÜMLE
```

### `§9` · İKİ EK KAYIT
1. **`§2a` vakası** (*"kendi düzeltme geçmişini taşıyan belge, erken duran okuyucuyu hâlâ
   yanıltır"* — **üçüncü** tekrar, ilk ikisi insan, üçüncüsü ajan) ⇒ `DISIPLIN`'e yazıldı,
   **iki yönlü pratikle** (okuyan: sona kadar bak · yazan: başlığa düzeltme satırı düş).
2. **`T-333` `TZ` ölçümü** dördüncü turdan **kuyruğa değil, `BL` ÖN-KOŞULUNA** bağlanır:
   > *"baseline-import **tarih/dönem** işleyecek; temsil hatası **tam o katmanda**
   > ateşlenir."*
   ⇒ Ölçümü (**çalışma zamanı `TZ` + etiket tüketicileri**) `BL` brief'inin **ilk maddesi**.
   📌 Dört tur *"ölçemedim"* kalmış bir kalem, bir **kuyruk satırı** olarak çözülmedi;
   **bir dalganın ön koşulu** olunca çözülür. `DISIPLIN`: *"bir `improved` satırı bir bilgi
   değil, o turun KAPANMAMIŞ İŞİDİR"* — aynı şeklin ölçüm tarafı.

### `§10` · SIRA
```
8b-FE dalgası  ∥  T-346        →        BL
```

---

## `Z80` — `T-346` HÜKÜM PAKETİ: `S2`–`S6` + `S4` KASKADI

> **Tarih:** 2026-09-02 · **Karar:** ürün sahibi · **Girdi:** TL aday-metinleri (ölçümlü)

### `§1` · `S2` — SAHİP **`mechanics`** `(a)`, ve `tactics` **ÖLMEZ**
```
grid kolonu mechanic'ten türüyor        (ölçüldü: PlanningGridEnhanced :854)
tactics.applicable_*  tüketicisi VAR    (agreement.service.ts:1242)
sorusu FARKLI: "anlaşmada geçerli mi" ≠ "grid'de uygulanabilir mi"
⇒ Q21 DESENİ: aynı DEĞER, farklı SORU — birleştirme YOK, ÇAPRAZ-REFERANS yorumu
```
📌 `Q21`'in deseni **üçüncü kez** iş gördü ve artık bir **refleks**: iki yapı aynı değeri
taşıyorsa önce *"aynı soruyu mu soruyorlar"* diye bakılıyor, birleştirme **varsayılan değil**.

⛔ **ŞART — brief'in İLK SATIRI (`S2` hükmünün ön koşulu):**
> **CTPM'in *"mechanic"*i ↔ Excel `Sayfa5` hangi DÜZEY?**
> ```
> Excel   tactic = KULLANICI-GÖRÜNÜR (9)   ·   mechanic = AİLE (6)
>         CPP-Off% ve Price-Support AYNI AİLEDE (CPPOFF)
> CTPM    6 mechanic — AİLE düzeyindeyse UYGUNLUK YANLIŞ GRANÜLERLİKTE
> ```
> **ÖLÇ, SONRA BAĞLA.** *(Sayı eşleşmesi — `6` ↔ `6` — bir kavram eşleşmesi değildir;
> `Z64`'ün `A0'` keskinleştirmesi.)*

### `§2` · `S3` — `(c)` DÜŞER **+ BOŞSA GÖRÜNÜR MESAJ**, ve `length>0` YENİDEN ADLANDIRILDI
> ### **`length > 0` MUHAFIZI *"FAIL-OPEN"* DEĞİL, TANIMLI-WILDCARD'DIR:**
> ### **"KISIT TANIMLANMAMIŞ = TÜMÜNE UYGUN" — VE ADMİN YÜZEYİNDE *"KISITSIZ"* GÖRÜNÜR.**

⇒ TL aday-metni bunu *"fail-open varsayılan"* diye adlandırmıştı; hüküm **düzeltti**.
Fark ürün-anlamlı: fail-open bir **kaza**dır, tanımlı-wildcard bir **karar** — ve kararın
**görünür bir etiketi** olur.

**Bugünün gerçeği kayda:** `0/6` dolu ⇒ **ilk tohum girilene kadar `SC-O2` ayırt-edicisi
ÜRETİLEMEZ** — `T-273` körlüğü, **adıyla**.
**`catch { return [] }` ÖLÜR:** *"yüklenemedi"* ≠ *"bu eşleşmede tanımlı değil"*.

### `§3` · `S4` — `(a)` FORM/API + TOHUM · CSV **OLAY-TETİKLİ** · ÇÖZÜMLEME KURALI
```
1  CPL tanımı VARSA  → YALNIZ O karar verir
                       CPL listede DEĞİLSE → UYGUN DEĞİL, kanala DÜŞÜLMEZ
                       ⛔ KISIT-DIŞI ≠ KISIT-YOKLUĞU
2  CPL tanımı yoksa  → bağlı KANALIN tanımı
3  ikisi de yoksa    → TANIMLI-WILDCARD (§2)
```
> ### **KURALIN KALBİ `1`'İN NEGATİF YARISIDIR:** *bir CPL listesi VARSA ve o CPL içinde
> ### DEĞİLSE, kanal uygun olsa BİLE uygun değildir.*

**Sözlüğe:** **`CPL` = PLANLAMA BİRİMİ, müşteri DEĞİL** *(bakkallar 1 CPL, Migros 1 CPL)*.
**Taşıyıcı hazır** (`applicable_cpls` + `applicable_channels`); inşa edilen şey
**RESOLVER SIRASI** + `1`'in negatif yarısı. **Tek resolver**; çağıran kademeyi **bilmez
ama SORABİLİR** (tooltip/denetim: *"CPL tanımından mı, kanal tanımından mı"*).

⛔ **PİN DÖRTLÜSÜ:**
```
1  CPL tanımlı ve UYGUN
2  CPL tanımlı, DEĞİL — KANAL UYGUN OLSA BİLE   ← NEGATİF YARI, KURALIN KALBİ
3  CPL yok, kanal tanımlı
4  ikisi de yok → wildcard
```

### `§4` · `S5` — `MechanicCategory` KANONİK `(a)`, ikinci `calcType` alanı **YOK** (`F8`)
`Sayfa5` eşlemesi **referans belgeye tek tablo**:
```
LUMPSUM_SPEND          = Lumpsum
PER_UNIT_SUPPORT       = per-unit rate
ON/OFF_INVOICE_DISCOUNT = %-rate
LONG_TERM_AGREEMENT    = LTA
spending-type          ZATEN ayrı enum
```

### `§5` · `S6` — `BOTH`: AÇIK HATA `(b)` bugün · **VE ÖLÇÜM `BOTH`'U ÖLDÜRÜYOR**

**TL ölçtü (2026-09-02):**
```
main.tactics     OFF_INVOICE 4 · ON_INVOICE 1 · BOTH 0
main.agreements  OFF_INVOICE 5 ·                BOTH 0
```
⇒ **Canlıda `BOTH` taşıyan kayıt YOK.** Hüküm gereği: **`BOTH` enum değeri ÖLÜR**, ve
`(a)`-dağıtım-oranı sorusu **hiç doğmaz**.

⚠️ **VE DAYANAĞI AYIRIYORUM — ikisi aynı ağırlıkta değil:**
```
TAŞIYICI GEREKÇE   Excel KANONUNDA BOTH YOK — her tactic TEK spending-type;
                   "hem on hem off" iş = İKİ TACTIC (Drive/TPR-On% + TPR-Lumpsum emsali)
DESTEKLEYİCİ       bugünkü veride 0 — ama bu TOHUM verisi (5 tactic · 5 agreement),
                   müşteri verisi DEĞİL
```
📌 Ayrım önemli: bir enum değerini **veriye bakarak** öldürmek `DISIPLIN`'in *"veriye dayalı
her erteleme, verinin değiştiği gün yeniden ölçülür"* kuralına takılırdı. **Kanona bakarak**
öldürmek takılmaz — ve gerçek dayanak **kanon**.
`(c)` elendi, gerekçesiyle: **bir tutar iki zarfta olamaz.**

### `§6` · ⭐ ÜÇÜNCÜ KASKAD — ORTAK DESEN ADINI ALDI
```
FU → SKU          Z74     mekanik değeri
kanal → CPL       BU      uygunluk
kategori/kanal → politika  K-2.2.8
```
> ### **ÜÇÜ DE *"VARSAYILAN + İSTİSNA"*, ÜÇÜ DE **TEK RESOLVER**.**

⇒ `DISIPLIN`'e. Bir desenin **üçüncü** vakası artık bir tesadüf değil, bir **mimari**.

### `§7` · SORU LİSTESİ DE SÜRÜKLENEN BİR BELGEDİR
`T-346`'nın beş sorusu bir tur eskiydi ve TL ölçümü şunu gösterdi:
```
2 soru DEĞİŞTİ    S2 "kaç boyutlu" → "HANGİ TABLO SAHİBİ"  (iki sözlük ölçüldü)
                  S4 "nereden yönetilir" → "KİM DOLDURACAK" (yazma yüzeyi ZATEN var)
2 soru KODDA CEVAPLIYDI   S3 (return false ⇒ düşer) · S5 (enum var, 6/6 dolu)
1 soru ÖLÇÜMLE DOĞRULANDI S6 (budget'ta BOTH yok — üç enum karşılaştırıldı)
```
> ### **BİR SORU LİSTESİ, ÖLÇÜMLE TAZELENEN BİR BELGEDİR.**
> **Cevaplanmamış olması, HÂLÂ DOĞRU SORU olduğu anlamına gelmez.**

📌 `Z75 §2`'nin (*"verilen hükümlerin indeksi sürükleniyor"*) **kardeşi**: orada **hüküm →
task** boşluğu, burada **ölçüm → soru** boşluğu. Aynı aile, ters yön.

### `§8` · `8b` VE KAPI
`(b)` — commit **şimdi**; kırmızı kapı ve **üç atıf sayısı** mesaja yazıldı.
**`T-353`: `P1`, teşhis ŞART** — *"flaky/ortam"* **yasaklı**; kapanana dek **FE exit kodu =
`ÖLÇEMEDİM`**. Ön şart: **Team Lead koşumu + ARDIŞIK İKİ KOŞUM TUTARLILIĞI.**
`T-354`: onaylı, **`F8` şartıyla** (yardımcı **genişletilir**, ikinci aile doğmaz).

### `§9` · SIRA
```
T-346 şeridi (hükümlü zemin)  ∥  T-353   →   W7 ölümü   →   BL
```

---

## `Z80 §5` — **REVİZE (`F12` izli, 2026-09-02)**: HÜKÜM **DARALDI, ÖLMEDİ**

> **Karar:** ürün sahibi · **Tetikleyen:** TL'in kendi öncülünü çürüten ölçümü
> ⛔ **Hüküm YENİDEN AÇILMADI** — açılacak bir şey yok. Bu, `Z69 §4c`'nin **mekanizması**:
> *gerekçeler ayrı yazılmıştı; düşen gerekçe düşer, hüküm **kalan dayanakla yeniden kurulur**.*

**`5a` · DÜŞEN GEREKÇE**
> ~~*"zarf karşılığı yok ⇒ sessiz eşleşmeme"*~~ — **YANLIŞTI.**
```
main.budget_envelopes.spend_type   NULLABLE
NULL = UNSPLIT = BİRLEŞİK HAVUZ    (ADR 0004 §5.5 · T-270/Z21 ile pinli
                                    finance-reporting.service.ts:304-312)
canlı                              4/4 zarf TAM OLARAK bu durumda
```
⇒ **`BOTH` bir tactic'in karşılığı VAR**, ve bugün **tüm** zarflar o durumda.

**`5b` · `(b)` DARALIR**
```
BOTH × UNSPLIT zarf   MEŞRU EŞLEŞME — havuz ikisini de alır
BOTH × SPLIT zarf     AÇIK HATA — "hangi zarfa?" cevapsız
```
⛔ **Sessizlik bugün YOK** — **SPLIT zarf doğduğu gün doğar**; hata yolu **o gün için**
inşa edilir. *(`DISIPLIN`: veriye dayalı bir erteleme değil — **bugünkü durumun dürüst
tarifi** + yarının yolu.)*

**`5c` · `BOTH` ENUM'UNUN ÖLÜMÜ **AYAKTA**, TEK DAYANAKLA**
> **Excel KANONU: her tactic TEK spending-type; çift-iş = İKİ TACTIC.**

`UNSPLIT` havuz bununla **uyumlu** — iki tactic'in harcaması **aynı havuza** gider,
`BOTH`'a gerek kalmaz. **Ölçüm şartı duruyor:** canlıda `BOTH` taşıyan kayıt var mı →
**yoksa ölür, varsa İKİ TACTIC'E AYRIŞTIRILIR** (dağıtım değil).

### `5d` · ⭐ MEKANİZMA İŞLEDİ — ve dört basamağı da ayrı ayrı çalıştı
```
1  AJAN SORDU, GENİŞLETMEDİ     "S6'nın hedefi başka dosyada mı?" — yanlış guard kurmadı
2  TL ÖLÇTÜ, KENDİ ÖNCÜLÜNÜ ÇÜRÜTTÜ   "zarf karşılığı yok" TL'in cümlesiydi
3  DAYANAKLAR AYRI YAZILMIŞTI   Z80 §5 "taşıyıcı KANON · destekleyici VERİ" diyordu
4  HÜKÜM ZAMANINDA DARALDI      kod yazılmadan
```
> ### **DÜŞEN GEREKÇENİN HÜKMÜ ÖLDÜRMEMESİ BİR ŞANS DEĞİL — `§3`'ÜN DAYANAKLARI**
> ### **AYRI YAZMA DİSİPLİNİNİN ÜRÜNÜ.** Tek gerekçeyle yazılsaydı hüküm çökerdi.

📌 Ve `§7`'nin (*"soru listesi ölçümle tazelenen belgedir"*) **kardeşi**: bir **hükmün
gerekçesi** de ölçümle tazelenir. Fark: soru **değişir**, gerekçe **düşer** — ve hüküm
kalan dayanakla ayakta kalabiliyorsa **daralır**, yeniden açılmaz.
