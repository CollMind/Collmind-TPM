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
