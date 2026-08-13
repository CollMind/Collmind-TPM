# BRD v2.0 — L2 İş Kuralları (Çekirdek)

> **Bölüm 2.1–2.4.** L2'nin on iki bölümünden dördü — en çok ölçülmüş, en az tartışmalı
> olanlar. Kalan sekiz bölüm açık kararlara bağlı (`BRD_V2_ISKELET.md §5`).

- **Sürüm:** taslak, 2026-08-11
- **Nasıl okunur:** referans belgesi. Baştan sona okunmaz; bir kural aranır.
- **Kural numaralandırması:** `K-<bölüm>.<sıra>`. Diğer belgeler numarayı referans verir,
  kuralı tekrar yazmaz.

---

## Bu katmanın kuralları

1. Bir kural **bir kez** yazılır. Başka belgeler numarasını referans verir.
2. Her kuralın bir **kaynağı** vardır: bağlayıcı belge, verilmiş bir karar, ya da ölçüm.
3. Bir kural henüz verilememişse **`AÇIK`** olarak işaretlenir ve neyi beklediği yazılır.
   Sessizce atlanmaz.
4. **Ölçülmüş sapmalar** kurala not olarak eklenir. Bir kuralın bugün ihlal edildiğini
   bilmek, kuralı yazmamaktan iyidir.
5. **`❌` ve `⚠️` işaretleri bir adres taşır:** hangi iş bu satırı kapatacak.

   ```
   ön koşulu BİLİNEN karar    → dalga veya issue referansı
   ön koşulu ÖLÇÜLECEK karar  → ölçüm referansı
   ```

   > Beşinci bir statü (*"karar verildi, ön koşulu yok"*) **reddedildi:** bir bağımlılık
   > statüsü, doğası gereği **başka bir işin tamamlanmasıyla bayatlar** — ve onu güncellemek
   > kimsenin görevi olmaz. Adres ise kendi kapanış mekanizmasını taşır.

   ⚠️ **Standart bugün geriye dönük uygulanmadı.** Ölçüldü (2026-08-13): `L2`'de
   **altı** *"Ölçülmüş ihlal"* notu var (`L2_01` 4 · `L2_03` 2); adresi olan **üç**
   (`K-2.5.11` · `K-2.5.16b` · ve ölçüm adresiyle `K-2.1.8a`). **Adressiz kalan dördü
   `L2_01`'de:** zarf ayrımı · planlanan brüt kârın para olarak kaydı · boş kârlılığın
   `0`/`yeşil` gösterimi · formül doğrulamasının çağrılmaması (`EK_E`'nin `🔒` vakası).
   Onlara adres yazmak, ait oldukları işi **ölçmeyi** gerektirir — uydurulmaz.

**İşaretler:** ✅ uygulanıyor · ⚠️ kısmen · ❌ uygulanmıyor · ⛔ karar bekliyor

---

# 2.1 · Veri Modeli

## 2.1.1 Ürün hiyerarşisi

**K-2.1.1** — Ürünler beş seviyeli bir hiyerarşide tanımlanır:

```
Marka → Kategori → Ürün Grubu → Tahmin Birimi (FU) → SKU
```

Her seviye bir üstüne tekil olarak bağlıdır. SKU en alt seviyedir ve fiziksel ürünü temsil
eder.

**K-2.1.2** — **Kategori ürün ekseninin parçasıdır, organizasyon ekseninin değil.**

Bu ayrım normatiftir ve kaynak onu iki kez "kritik" etiketiyle vurgular. Kategori bir ürün
sınıflandırmasıdır; bir satış ekibi veya sorumluluk alanı değildir.

> ⚠️ **Ölçülmüş sapma:** kullanıcı yetki kapsamı bugün kategori üzerinden tanımlanıyor
> (`K-2.6.x`, ⛔). Bu, iki ekseni karıştırıyor.

## 2.1.2 Organizasyon hiyerarşisi

**K-2.1.3** — Müşteriler ve satış organizasyonu üç eksende tanımlanır:

```
Kanal → Bölge → Müşteri (CPL)
```

**K-2.1.4** — Bir müşteri **tam olarak bir** kanala bağlıdır. Bu kısıt veritabanı seviyesinde
zorunludur.

> ✅ Uygulanıyor: `cpls.channel_id NOT NULL`, tekil yabancı anahtar.

**K-2.1.5** — Bölge, organizasyon ekseninin parçasıdır ve yetki kapsamında kullanılabilir.

> ❌ Bugün: bölge tablosu ve yönetim ekranı mevcut, ama **hiç veri yok** (sıfır satır) ve
> yetki kapsamında kullanılmıyor.

## 2.1.3 Plan yapısı

**K-2.1.6** — Bir plan üç seviyeli bir yapıdır:

```
Plan → Plan-FU → Plan-SKU
```

> ✅ **Karar verildi** (2026-08-12, Oturum 3.1). Giriş FU'da, SKU katmanı türetilmiş.

**K-2.1.7** — **Taktik değerleri Tahmin Birimi (FU) seviyesinde girilir.** SKU seviyesinde
taktik girişi yoktur.

**K-2.1.8** — **Hacim de FU seviyesinde girilir.** SKU hacimleri türetilir.

> Kaynağın iç çelişkisinde **çekirdek bölüm kazanır** (*"FU seviyesi, SKU opsiyonel detay"*).
> Planlama modu metni, zaten Faz 1 dışı ilan edilmiş bir modun kalıntısı.
>
> Ve asıl gerekçe kendi ölçümümüz: **taktik tarafında FU-giriş → SKU-uygulama modeli zaten
> çalışıyor** (%10, her SKU'ya kendi cirosu üzerinden iniyor). Hacim, taktiğin kanıtlanmış
> desenine hizalanıyor.
>
> Sektör kanıtı da aynı yerde: SKU seviyesinde zorunlu giriş bir **adopsiyon düşmanıdır.**

### Dağıtım kuralı

**K-2.1.8a** — Dağıtım tabanı **geçmiş hacim payıdır:** son 12 ayın aynı dönemi; yoksa son
dört dönemin toplamı.

> **Ciro payı değil** — hacim dağıtılıyor, fiyat farkları payı bozar.

> ⚠️ **Uygulama ölçüm şartlı** (`T-206`, 2026-08-12). Kural **karar olarak ayaktadır**;
> uygulanabilirliği bir ölçüme bağlı.
>
> Ölçülen: gerçekleşen satış verisi SKU kırılımı ve hacim taşımıyor — **ve bu kayıtlı bir
> tasarım kararı.** `T-206` o kararın sınıfını ölçecek:
>
> | Sonuç | Etkisi |
> |---|---|
> | Kaynak sınırı | Kural ayakta; kolon eklenir, kaynak gelince dolar |
> | Pilot profili kararı | Karar tenant profiline iner (`İlke 5`); ürün kuralı bu |
> | Gerçek domain kararı | `A2`'nin tabanı yeniden karara gider |
>
> Adres bir dalga değil, bir **ölçümdür** — çünkü dalga kaleminin kendisi o ölçüme bağlı.

**K-2.1.8a1** — ⚠️ **Fatura-içi kayıtlar dağıtım tabanı olarak kullanılamaz.**

O veri yalnız fatura-içi mekaniğe giren ürünleri kapsar. Kısmi kapsama, dağıtım payında
**sistematik yanlılık** üretir — `K-2.4.22`'nin *"eksik dilim rastgele değildir"*
argümanının aynısı.

> Ölçüldü (`F16`): gerçekleşen satış verisi SKU kırılımı taşımıyor, ama fatura-içi
> kayıtlar taşıyor. Bu, *"veri zaten var"* kestirmesine davet eder — ve o kestirme
> yanlıştır.

**K-2.1.8b** — Geçmişi olmayan bir SKU **sıfır pay alır** ve *"tarihsiz"* olarak işaretlenir.

> ⚠️ Eşit pay vermek cazip ama yanlıştır: **yeni ürünün lansman hacmi tarihsel bir türetme
> değil, ticari bir karardır.** Kullanıcının bilinçli girmesi gereken tek hücre tam da budur.
>
> Sessizce uydurulan eşit pay, sessiz sıfırın kardeşidir — bir **sessiz tahmin.** Ve daha
> tehlikelidir: sıfır fark edilir, makul görünen bir sayı edilmez.

**K-2.1.8c** — Bir FU'nun **hiç geçmişi yoksa** (tümüyle yeni hat) eşit pay verilir ve **tüm
satırlar** işaretlenir.

> Burada eşitlik dürüst bir *"bilmiyorum"*dur — bir tahmin değil.

**K-2.1.8d** — Her hücre **elle düzeltilebilir.** Düzeltilen hücre kilitlenir; kalan miktar
kalan SKU'lara payla yeniden dağıtılır.

**K-2.1.8e** — ⚠️ **Invariant:** `Σ(SKU hacimleri) = FU hacmi`, her an. Testle korunur.

**K-2.1.8f** — Dağıtım kuralı **tek ve görüşlüdür.** Tenant seçeneği değildir (`İlke 1`).

### SKU katmanının şekli

**K-2.1.8g** — **Giriş grain'i ile hesap grain'i farklıdır.**

| Katman | Grain |
|---|---|
| Giriş | FU |
| Hesap | SKU (kâr marjı SKU maliyetine, taktik SKU cirosuna iner) |
| Hakediş | dönem + müşteri + kategori + kanal — FU'ya bile bakmaz |

**K-2.1.8h** — SKU satırları **payı sıfırdan büyük olanlar için** türetilir. Bugünkü *"FU
eklendi → tüm aktif SKU'lar satır oldu"* davranışı **kaldırılır.**

> `Ek A`'nın işaret ettiği performans darboğazı (5.000 SKU × zorunlu satır) bu değişiklikle
> kendiliğinden sönümlenir — ve `NFR-8`'in birinci test senaryosu bunu doğrulamak için.

**K-2.1.8i** — ⚠️ **Miras görünürlüğü bu kararın parçasıdır**, ayrı bir kusur değil.

Kullanıcı FU'ya girdiği değerin **nereye nasıl indiğini** görmelidir: FU değeri → pay → SKU
değeri, bayraklarıyla birlikte.

> Gerekçe: grup giriş modeli ancak miras görünürse güven verir. Kullanıcı %10'un dağılımını
> göremeden düzeltemez; göremezse tabloya döner.
>
> Bu bir MVP şartıdır.

**K-2.1.9** — FU seviyesinde girilen bir taktik, SKU'lara **değer olarak kopyalanmaz.** Her
SKU'nun kendi cirosuna uygulanır ve sonuç o SKU'ya düşen **harcama tutarı** olarak yazılır.

> Yani miras "kopyalama" değil "uygulama"dır.

## 2.1.4 Mekanik tanımı

**K-2.1.10** — Bir mekanik, bir taktik türünün nasıl hesaplanacağını tanımlar. Her mekanik
iki ayırıcı taşır:

| Alan | Değerler | Anlamı |
|---|---|---|
| `input_type` | `percentage` · `currency` | Girilen değerin birimi |
| `mechanic_type` | `PERCENT` · `AMOUNT` · `AMOUNT_PER_UNIT` | Hesaplama semantiği |

**K-2.1.11** — Girilen değer, semantiğine göre **ayrı kolonlarda** saklanır. Tek bir kolon
birden çok ölçek taşıyamaz.

**K-2.1.11a** — ⚠️ **Girilen değerin tek bir temsili vardır ve o FU seviyesindedir**
(`K-2.1.7`). SKU seviyesinde yalnız **hesaplanan** harcama tutulur.

> Düzeltme (2026-08-12, dış denetim `F11`): bugünkü şema *"girilen"* kolonlarını **SKU
> seviyesinde** taşıyor — eski modelin kalıntısı. Aynı girdinin iki temsili `İlke 4`'ün veri
> hâlidir ve zamanla ayrışır.
>
> Geçiş: kolonlar FU seviyesine taşınır, SKU'da yalnız hesaplanan değer kalır.

```
oran        →  entered_rate_pct        (0–100, dört ondalık)
birim tutar →  entered_unit_amount     (dört ondalık — birim fiyat ölçeği)
toplam tutar→  entered_total_amount    (iki ondalık — para ölçeği)
```

Veritabanı kısıtı: üç kolondan **en fazla biri** dolu olabilir.

> ✅ Uygulanıyor. "En fazla bir" seçildi, "tam olarak bir" değil — değer girilmemiş satır
> meşrudur ve `= 1` kısıtı çağıranı sıfır uydurmaya zorlardı.

**K-2.1.12** — `AMOUNT_PER_UNIT` bir **birim fiyattır**, bir para tutarı değil. Kuruş
yuvarlama kuralı ona uygulanmaz; dört ondalık hassasiyet meşrudur.

## 2.1.6 Ölçü birimi

> ✅ **Karar verildi** (2026-08-12, Oturum 3.7). Tek kanonik birim; çevrim yalnız sınırda.

**K-2.1.12a** — Sistemde **tek bir hacim birimi** vardır: **adet.** Her hacim değeri, tanım
gereği adettir.

> Gerekçe (ürün sahibi): çok birim bir **iletişim** sorunudur, bir hesap sorunu değil.
> Karşı taraf koliyle faturalar, kullanıcı adetle düşünür — ama bu gerçeğin yaşayacağı yer
> sistemin **kenarıdır.**
>
> Çekirdekte iki birim yaşatmak, her hesap noktasına (dağıtım, taban, eşleştirme, tavan) bir
> *"hangi birimde?"* sorusu enjekte eder. O soruların **biri** unutulduğunda on iki kat hata
> sessizce doğar.
>
> Tek kanonik birim, hata sınıfını nokta nokta savunmak yerine **sınıfça yok eder.**
>
> Ve bu, para tarafındaki kararın simetriğidir: tek kanonik temsil, çevrim kenarda.

**K-2.1.12b** — ⚠️ **Çekirdek tablolarda birim alanı yoktur** — plan satırı, hacim dağıtımı,
gerçekleşen satış, talep. Hiçbirinde.

> **En iyi doğrulama, doğrulanacak alanın olmamasıdır.** Alan yoksa yanlış değer girilemez.

**K-2.1.12c** — SKU tanımında iki alan bulunur:

```
satış birimi     bilgi amaçlı — "koli"
çevrim çarpanı   koli → adet, varsayılan 1
```

**K-2.1.12d** — Çevrim **yalnız içe aktarma sınırında** yapılır. Ham değer, çarpan ve sonuç
içe aktarma kaydında **birlikte saklanır.**

> *"12 koli geldi, ×12, 144 adet yazıldı"* denetlenebilir kalır — `K-2.13.12b`'nin köken
> kaydıyla aynı aile.

**K-2.1.12e** — Çarpanı `1`'den farklı olan bir SKU'da çarpansız bir hacim içe aktarımı
**uyarı üretir** (`K-2.7` ailesi).

**K-2.1.12f** — Kullanıcıya **adet** gösterilir. Koli gösterimi ileride bir **görüntü
tercihi** olarak eklenebilir; görüntü katmanı davranışa **sızmaz.**

> `K-2.2.7`'nin renk/davranış ayrımının birim karşılığı.

> ⚠️ **Bugünkü ölü alan bu haliyle kalamaz.** SKU'daki serbest `birim` alanı ya kanonik
> modelin parçası olur (`K-2.1.12c`) ya silinir — uyuyan kusur bugün kapanır.
>
> Deploy öncesi ucuzluk penceresi açık; ilk koli-faturalı müşteri geldiğinde şema pahalı
> olur.

## 2.1.6a Çalışma biçimi — kaldırıldı

> ✅ **Karar verildi** (2026-08-12, Oturum 3.10). **Mod, bir davranış belirleyici olarak
> ölür.**

**K-2.1.12g** — ⚠️ Sistemde **iki çalışma biçimi yoktur.** Her plan aynı akıştan geçer;
*"mod farkı"* dediğimiz şey **geçmiş verinin var olup olmaması**dır — ve o bir **veri
durumu**, bir rejim değil.

> Gerekçe (ürün sahibi): bu oturumun beş kararı modun taşıdığı **her davranışı gerçek
> sahibine dağıttı:**
>
> | Davranış | Yeni sahibi |
> |---|---|
> | Hesaplaşma kadansı | Taktik tipi (`K-2.1.13`) |
> | Baseline yokluğu | Dağıtım bayrağı (`K-2.1.8b`) |
> | Talep yaşam döngüsü | Kaynak alanı (`K-2.13.5`) |
> | Tahakkuk | Kadans (`K-2.13.25`) |
> | Birim | Çekirdek teklik (`K-2.1.12a`) |
>
> Geriye kalan rejimin belirlediği **hiçbir finansal davranış yok.** Davranış belirlemeyen
> bir rejim için üç katmanlı bir çözümleyici kurmak, **cevabı olmayan bir soruya motor
> yazmaktır** (`İlke 1`).

**K-2.1.12h** — Kaynağın **kapsam politikası + öncelik + karma biçim** modeli **reddedilir.**

> `HYBRID` özellikle: kullanıcıya *"hangi biçimde çalışmak istersin"* diye sormak, **ürünün
> veremediği bir kararı kullanıcıya devretmektir.** Ve iki kullanıcı aynı kurulumda farklı
> seçerse verilerin nasıl buluşacağı tanımsız.
>
> Kaynağın kendi çekimserliği (*"mümkün olduğunca deterministik ol"*) aynı yöne bakıyor.

**K-2.1.12i** — Geriye tek bir şey kalır: **görünürlük bayrağı.** Planlama giriş yüzeyleri
açık mı, değil mi.

Kapalıysa tahmin giriş ekranları görünmez; **plan yine vardır** ve gerçekleşme ağırlıklı
yaşar. Bayrağın açılması **hiçbir hesabı değiştirmez.**

> `K-2.2.7`'nin renk/davranış ayrımının mimari karşılığı: **bayrak yüzeyi açar, davranışı
> asla.**

**K-2.1.12j** — ⚠️ **Terim çakışması giderilir.** Konumlanmanın üç kademeli veri olgunluğu
merdiveni (`K-2.7.9`) bir **yetenek kademesidir**, bir çalışma biçimi değil. *"Mod"*
kelimesi bu belgede artık hiçbir şeyi adlandırmaz.

**K-2.1.12k** — Bir ilke resmileşir:

> **Hesaplaşma her koşulda gerçekleşen veriye dayanır.** Bir çalışma biçimi hesaplaşmaya
> hiçbir zaman dokunamazdı; artık dokunacak bir biçim de yok.

Bu, ürünün değişmez zeminidir — bir mod adı değil.

> ⚠️ **Geçiş — kod tarafı ayrı bir iştir.** Bugünkü klasör bölmesi bu kararla
> **meşruiyetini kaybeder ama varlığını değil.**
>
> Sıra: (1) bölme **ölü ilan edilir**, (2) yeni kod bölmeye **asla eklenmez** — bir guard'la
> korunur, (3) birleştirme **ölçülmüş ayrı işlerle**, dokunulan yerden başlayarak.
>
> **Tek seferlik büyük birleştirme yok** — `İlke 4` ihlali olarak kaydedilen sekiz vakanın
> kaynağı büyük olasılıkla bu bölme, ve o evde dikkatli yürünür.

## 2.1.7 Anlaşma yapısı

> ✅ **Karar verildi** (2026-08-12, Oturum 1.3). Süre bir sınıflandırıcı olmaktan çıkarıldı.

**K-2.1.13** — Bir anlaşmanın hesaplaşma davranışını **hesaplaşma kadansı** belirler, süresi
değil.

```
settlement_cadence:  SINGLE | PERIODIC     ← davranışı bu belirler
accrual_schedule:    NONE | MONTHLY        ← PERIODIC ise
max_duration_days:   30 (varsayılan)       ← yalnız doğrulama kuralı
```

| Kadans | Hesaplaşma |
|---|---|
| `SINGLE` | Dönem sonunda tek hesaplaşma |
| `PERIODIC` | Tahakkuk eder, dönemsel hesaplaşır |

**K-2.1.14** — Kadans **mekanikte yaşar**, anlaşmada değil. Her mekanik görüşlü bir
varsayılanla gelir (ciro primi → dönemsel; aktivite → tek) ve tenant politikasında
değişebilir.

**K-2.1.14a** — ⚠️ **Anlaşma seviyesi davranış türetilir:** bir anlaşmanın **herhangi bir
mekaniği** dönemsel kadanslıysa, anlaşma **dönemsel hesaplaşır.**

> Düzeltme (2026-08-12, dış denetim `F6`): kural kadansı hem anlaşma hem mekanik alanı gibi
> okunabiliyordu, ve karışık kadanslı bir anlaşmanın davranışı **tanımsızdı** — üç taktikli
> bir anlaşma bu senaryonun kendisi.
>
> Türetme kuralı muhafazakâr: dönemsel bir yükümlülük varsa anlaşma dönem sonuna kadar
> beklemeden birikmeye başlar.

**K-2.1.15** — ⚠️ **`STA`/`LTA` etiketi davranış kaynağı değildir.** Rapor ve filtre için
türetilmiş bir görünüm olarak kalabilir, ama davranışın tek yolu `settlement_cadence`'tır.

> Gerekçe (ürün sahibi): süre bir **proxy**, gerçek eksen hesaplaşma kadansı. Yıllık ciro
> primi aylık tahakkuk ister çünkü **dönemsel yükümlülük biriktirir** — uzun olduğu için
> değil. Üç aylık bir raf aktivitesi tek hesaplaşmayla kapanabilir.

**K-2.1.16** — `max_duration_days` **sınıflandırmaz, doğrular.** *"Bu tip 30 günü aşamaz"* bir
doğrulama mesajıdır; aşmak isteyen kullanıcı tipi veya kadansı **bilinçli olarak** değiştirir.

> Gerekçe: süre-türetimi bir **uçurum etkisi** üretir — 30 gün tek hesaplaşma, 31 gün aylık
> tahakkuk. Bir anlaşmayı bir hafta uzatan kişi, farkında olmadan finansal rejimi değiştirir
> ve fark dönem kapanışında çıkar.
>
> **Uçurum yerine kapı:** davranış değişikliği bilinçli bir seçim olmalı, bir yan etki değil.

**K-2.1.17** — Süre sınırı **konfigürasyondur.** Varsayılan 30 gün.

> Kaynakla uyumlu, ve aylık fatura/mutabakat ritmiyle örtüşüyor. Değiştirilebilirlik yeter;
> değeri oynatmak için sebep yok.

> ⚠️ **Sıralama notu:** tahakkuk mekanizması henüz yok (`SORULAR A6`). Bu kararın bugünkü
> maliyeti **yalnız şemadır** — `settlement_cadence` alanı şimdi eklenir, davranışı tahakkuk
> işiyle birlikte gelir.
>
> Alanın şimdi var olması önemli: `A6` kapanırken süreden türetme **yeniden icat
> edilmesin.** Ve deploy öncesi olduğumuz için şema değişikliği bugün ucuz.

**K-2.1.18** — Her anlaşma bir **harcama tavanı** (CAP) taşır. Tavan pozitif bir değer taşır
ya da yoktur; **sıfır yazılamaz.**

> Gerekçe: bir tavanda sıfır "hiçbir şeye izin verme" ile "sınırsız" arasında belirsizdir.
> Sıfır tavanın ifade ettiği şey ("bu mekanik kullanılamaz") için ayrı bir işaret vardır.

---

# 2.2 · Bütçe Kuralları

## 2.2.1 Zarf modeli

**K-2.2.1** — Bütçe, **zarflara** bölünür. Bir zarf üç boyutla tanımlanır:

```
Kanal × Kategori × Dönem
```

**K-2.2.2** — Bir zarf isteğe bağlı olarak **harcama tipine** göre bölünebilir
(fatura-içi / fatura-dışı). Bölünmemiş bir zarf her iki tipe de hizmet eder.

**K-2.2.3** — Zarf çözümlemesi **tüm yollarda aynı boyut kümesini** kullanır. Farklı bir yol
farklı bir boyut kümesiyle zarf arayamaz.

> Gerekçe: iki farklı çözümleme, aynı harcamanın iki farklı zarfa düşmesine yol açar ve fark
> sessizdir.

## 2.2.2 Durum kovaları

**K-2.2.4** — Bir zarfın bütçesi **beş** kovaya dağılır:

| Kova | Ne zaman dolar |
|---|---|
| `Ayrılan` | Zarf tanımlandığında |
| `Rezerve` | Bir **anlaşma** onaylandığında |
| `Taahhüt` | Bir **plan** onaylandığında |
| `Tahakkuk` | Dönemsel yükümlülük biriktikçe |
| `Tüketilen` | Gerçekleşen fatura kaydedildiğinde |

**K-2.2.5** — Kullanılabilir bütçe:

```
Kullanılabilir = Ayrılan − Rezerve − Taahhüt − Tahakkuk − Tüketilen
```

> ⚠️ **`Tahakkuk` terimi 2026-08-12'de eklendi** (dış denetim `F5`). Tahakkuk
> kullanılabilirliği **düşürür** — dönemsel bir yükümlülük birikmiştir ve o para artık
> serbest değildir.
>
> Ve dönem kapanışında çözülür: eşleşen kısım `TÜKETİM`'e döner, fazlası `İADE` ile serbest
> kalır (`K-2.13.25b`). Kapanışta **açık tahakkuk = 0** (`K-2.13.25c`).
>
> ⚠️ **Çift düşüm olmaz:** tahakkuk yazıldığında karşılık gelen rezervasyon **aynı işlemde
> azalır** (`K-2.13.25a1`). Kovalar bir **dönüşüm zinciridir**, bağımsız birikimler değil.

**K-2.2.6** — `Rezerve` ve `Taahhüt` **ayrı kovalardır** ve birleştirilemez.

> ❌ **Ölçülmüş ihlal:** bugünkü özet görünümü ikisini `Rezerve` altında topluyor. Toplam
> doğru çıkıyor ama ayrım kayboluyor — "bu zarfın ne kadarı plandan, ne kadarı anlaşmadan"
> sorusu cevaplanamıyor. Ve plan taahhütleri, kaynağın "planlama modunda kullanılmaz" dediği
> bir kovada raporlanıyor.

## 2.2.3 Eşikler

> ✅ **Karar verildi** (2026-08-12, Oturum 1.1). İki merdiven ayrıldı; `%90` kademesi iki
> fazda geliyor.

**K-2.2.7** — Zarf kullanımı **iki ayrı merdiven** taşır ve ikisi karıştırılmaz:

| Merdiven | Değerler | Amacı |
|---|---|---|
| **Davranış** | %80 · %90 · %100 | Kontrol — ne olur |
| **Renk (RAG)** | <80 · 80–95 · >95 | İletişim — nasıl görünür |

**K-2.2.7a** — Davranış merdiveni:

| Eşik | Kademe | Davranış |
|---|---|---|
| %80 | `WARNING` | Uyarı gösterilir, işlem devam eder |
| %90 | `FINANCE_REVIEW` | Faz 1: finans bildirimi + planda bayrak · Faz 2: politikaya göre onay |
| %100 | `BLOCKED` | İşlem bloklanır |

**K-2.2.7b** — `FINANCE_REVIEW` kademesinin davranışı **konfigürasyondur:** `notify` veya
`approve`. **Varsayılan `notify`.**

> Gerekçe (ürün sahibi): dönem ortasında %90'da durduran bir onay kapısı, en yoğun haftada
> sürtünme üretir ve ya atlanır ya nefret edilir. Finansın %90'da istediği çoğunlukla onay
> yetkisi değil, **haberdar olmak** — harcamayı %100'e dayanmadan görmek.
>
> Kapı mimaride var, sürtünmesi kanıtlanmış ihtiyaca kadar kapalı. Blocking sürümü isteyen
> kurumsal müşteri açar.

**K-2.2.7c** — ⚠️ **Eşikler yalnız PLAN ve TAAHHÜT tarafına uygulanır.**

Gerçekleşen bir hakediş hiçbir bütçe eşiğine takılmaz — **borç doğmuştur**, bütçe onu
geçersiz kılamaz. Aşım kaydedilir, işaretlenir ve raporlanır; süreç durmaz.

> Gerekçe: bütçe bir **planlama** aracıdır, bir **muhasebe** kısıtı değil. Bir hakediş
> ödenmeyecekse bu bir ticari karardır, bir sistem bloğu değil.
>
> Bu ayrım `K-2.3.15` (kayıtsız kalamaz) ile birlikte okunur ama ondan ileridir: yalnız
> kayıt değil, **akış** da durmaz.

**K-2.2.8** — Her iki merdiven de **konfigürasyondur**, kod sabiti değil. Değerler görüşlü
varsayılan olarak gelir (`80/90/100` ve `80/95`) ve ilk müşteride dokunulmaz.

> ❌ **Ölçülmüş sapma:** kod `%95` kullanıyor (renk sınırını davranışa taşımış) · `%90`
> kademesinin karşılığı yok · yazma yolu yok. Üçü de bu kararla kapandı.

> ✅ **Karar verildi** (2026-08-12, Oturum 2.2). Politika tablosu **iki boyutlu**, çakışmasız.

**K-2.2.8a** — Eşikler bir **tabloda** yaşar ve **iki boyutta** farklılaşabilir: **kanal** ve
**kategori.**

> Dönem boyutu **alınmaz** — dönemsel eşik farklılaştırma gerçek bir desen değil, spekülatif
> esneklik (`İlke 1`).
>
> Gerekçe (ürün sahibi): kanal bazlı farklılaşma istisnai değil, ticari yapının kendisi —
> zincir müşterilerde bütçe disiplini sıkı, distribütörde tolerans yüksek.

**K-2.2.8b** — Çakışma **veritabanı seviyesinde imkânsızdır:** `UNIQUE(tenant, kanal,
kategori)`, boş değer joker.

**K-2.2.8c** — Çözümleme tek kurallıdır: **en spesifik kayıt kazanır.** Eşit spesifiklik
mümkün değildir.

> ⚠️ **Öncelik kolonu yoktur** ve bilinçli olarak eklenmez.
>
> Gerekçe: *"çakışmada düşük öncelik kazanır"* kuralı, kullanıcının bir zarfa hangi eşiğin
> uygulandığını **tüm satırları zihinsel sıralamadan** bilememesi demektir. Bu, tabloya
> kaçışı üreten *"sistem neden bu rakamı üretti"* opaklığının ta kendisi.
>
> En-spesifik-kazanır + tekillik kısıtı ile **açıklanabilirlik bedava gelir:** cevap her
> zaman tek bir satırdan okunur.

**K-2.2.8d** — Her tenant'ta bir **joker satır zorunludur** (kanal ve kategori boş) ve
görüşlü varsayılanlarla doğar.

Boyutlu satır bir **istisnadır**, kural değil. Arayüz bunu *"varsayılan + istisna listesi"*
olarak gösterir, bir matris olarak değil.

**K-2.2.8e** — Eşik değişikliği bir **denetim olayı** üretir: kim, ne zaman, eski ve yeni
değer.

> Gerekçe: bir eşik değişikliği **finansal davranış değişikliğidir** — `%100` bloğunu
> hatırla. Seed-only'den yazılabilire geçişin gerçek maliyeti uç nokta değil, bu iz.

**K-2.2.8f** — Eşik değişikliği **ileriye dönük** yürürlüğe girer. Mevcut rezervasyonlar
yeniden değerlendirilmez; yeni değer bir sonraki kontrol anından itibaren geçerlidir.

> Bu cümle yazılmazsa *"eşiği düşürdüm, sistem neden eski planı bloklamadı"* tartışması
> kapıda.

**K-2.2.9** — `FINANCE_REVIEW` bir **bütçe politikasıdır**, bir onay motoru kademesi değil.
İkisi ayrı sistemlerdir (`K-2.5.1`).

**K-2.2.9a** — `FINANCE_REVIEW` eşiği aşıldığında bir bildirim üretilir (`K-2.10.1`).

## 2.2.4 Blok kademesi

> ✅ **Karar verildi** (2026-08-12, Oturum 1.2).

**K-2.2.9b** — `%100` bloğu Faz 1'de **istisnasızdır.** Bir override yolu açılmaz.

> Gerekçe (ürün sahibi): override bir onay-akışı özelliğidir. Politika tablosu olmadan
> yapılan override **yönetişimsiz bir arka kapıdır** — kim, hangi limite kadar, hangi izle?
> Bu soruların cevabı politika tablosunda yaşamalı, ve o tablo henüz yok.

**K-2.2.9c** — Aşımın meşru çözümü **zarf revizyonudur**, override değil.

Aşım gerekiyorsa finans zarfı büyütür. Bu denetlenebilir, kararı paranın sahibine taşır, ve
mekanizması zaten var (`ALLOCATE`).

> **Blok istisnasızdır, ama zarf değiştirilebilir.** Kaçış yolu kodsuz mevcut.

**K-2.2.9d** — `budget.override` yeteneği katalogda tanımlı kalır, **bağlanmaz.** Faz 2'de
`FINANCE_REVIEW = approve` modunun uzantısı olarak devreye girer.

**K-2.2.9e** — ⚠️ **Faz 2 override'ının şekli bugünden bağlıdır:** bir override, rezervasyonun
tahsisi sessizce aşması olarak uygulanamaz. **Açık bir defter olayı yazar** — yetkilendirilmiş
tolerans veya ek tahsis.

> Gerekçe: aksi hâlde bir istisna, bütçe invariantını sessizce gevşetir ve denetim izi
> oluşmaz. Bu, bu üründe sekiz kez ölçülmüş bir hata sınıfıdır.

## 2.2.5 Blok kontrolünün yeri

**K-2.2.9f** — Eşik kontrolü **iki noktada** yapılır:

| Nokta | Rolü |
|---|---|
| Plan gönderimi | **Erken uyarı** — kullanıcıyı gereksiz onay döngüsünden korur |
| Plan/anlaşma onayı | **Otoriter kapı** — rezervasyon burada yazılır |

**K-2.2.9g** — İki nokta **aynı kullanılabilirlik fonksiyonunu** çağırır. İki ayrı hesaplama
yolu yazılamaz.

> Gerekçe: aynı işi yapan iki kod yolu zamanla ayrışır ve fark sessizce yanlış sonuç üretir —
> bu üründe sekiz kez ölçüldü (`İlke 4`).

**K-2.2.9h** — Otorite **onay anındadır.** Kontrol, defter yazımıyla **atomik** olmalıdır;
eşzamanlı iki onay bir yarış üretir ve asıl koruma veritabanı seviyesindedir (`K-2.2.15`).

**K-2.2.9i** — Gönderimde yer varken onaya kadar zarf dolmuşsa plan **onayda reddedilir.** Bu
doğru davranıştır; sebep kullanıcıya açıkça gösterilir.

> ⚠️ **Bilinçli sınır:** gönderilmiş ama onaylanmamış planlar rezervasyon yazmadığı için
> gönderim kontrolü *"o anki duruma göre kesin"*dir — onayda yeşil garanti etmez.
>
> Bu kabul edilen bir durumdur, bir kusur değil. Bekleyen planları da sayan bir ön-rezervasyon
> modeli Faz 1 için gereksiz karmaşıklıktır.

## 2.2.6 Bütçe transferi

> ✅ **Karar verildi** (2026-08-12, Oturum 2.6). `TRANSFER` Faz 1'e girer; devir Faz 1 dışı.

**K-2.2.9j** — Bütçe kalemleri arasında **transfer** yapılabilir ve bu, `K-2.2.9c`'nin resmi
mekanizmasıdır.

> Gerekçe (ürün sahibi): FMCG'de toplam bütçe **sabittir** — yıl ortasında havadan tahsis
> gelmez, para bir yerden gelir.
>
> Transfer olmadan kaçış yolu pratikte şu olur: bir zarfa elle tahsis + başka bir zarfa elle
> negatif düzeltme — **birbirine bağlanmamış iki işlem.** Tahsislerin kaynağını gösterme
> bütünlüğü sessizce kırılır.
>
> Yani transfer bir özellik değil, `K-2.2.9c`'nin **bütünlük tamamlayıcısı.**

**K-2.2.9k** — Transfer **tek işlemde iki bacak** yazar: kaynaktan düşüm, hedefe ekleme.
İkisi ortak bir transfer kimliği taşır.

**K-2.2.9l** — ⚠️ **Invariant:** her transferde `Σ(bacaklar) = 0`.

**K-2.2.9m** — Transfer, kaynak zarfın **kullanılabilir** tutarını aşamaz.

> Gerekçe: aksi hâlde transfer, dolu bir zarfı sonradan aşırı taahhütlü hâle getirir —
> `K-2.2.9f`'nin bloğunu **arkadan dolanan** bir delik açılır.
>
> Kontrol, iki eşik noktasıyla **aynı kullanılabilirlik fonksiyonundan** geçer (`K-2.2.9g`).

**K-2.2.9n** — Transfer bir zarfı eşik üstüne çıkarabilir. Bu **engellenmez**, ama sonuç
eşikleri tetiklerse `K-2.2.7a` bildirimleri **aynen ateşlenir.**

> Sessiz eşik atlama olmaz.

**K-2.2.9o** — Transfer yetkisi **finans rolündedir** (ve yöneticide). *"Kim"* sorusunun
cevabı bir roldür, bir tablo satırı değil.

**K-2.2.9p** — Transfer için **politika kuralı yazılmaz:** kalemler arası kısıt yok, limit
yok, aynı kurulum içinde serbest.

> Gerekçe: hiçbir müşteri henüz bir transfer kısıtı istemedi (`İlke 1`). Finansın kendi
> parasını taşımasına ürün limit koymaz — kontrol, **izin kendisidir.**
>
> Gerçek bir desen çıkarsa `K-2.2.8a` tablosuna komşu olur.

**K-2.2.9q** — **Devir** (kullanılmayan bütçenin sonraki döneme aktarılması) Faz 1 dışıdır.

> Kaynak da onu açıkça Faz 1 dışı sayıyor.

**K-2.2.9r** — ⚠️ Ama dönem kapanışı **kalan bakiyeye ne olduğunu** açıkça söylemelidir:
kalan **serbest bırakılır**, yeni döneme taşınmaz.

> Bu cümle yazılmazsa kapanış kodu **fiili bir devir davranışı icat eder** — ve o varsayılan
> sonradan *"karar buymuş"* diye okunur.
>
> Devir geldiğinde bu serbest bırakmanın yerini bir politika alır.

## 2.2.7 Rezervasyon kuralları

**K-2.2.10** — Bir plan veya anlaşma onaylandığında bütçeden **atomik** olarak rezerve
edilir: ya tamamı ya hiçbiri. Yarım rezerve edilmiş bir durum oluşamaz.

**K-2.2.11** — Bir **rezervasyon isteği** birden çok harcama tipi içeriyorsa ve **herhangi
biri** tavanı aşıyorsa, istek **tümüyle** reddedilir.

> ⚠️ Bu kural yalnız rezervasyona uygulanır — gerçekleşen hakediş kaydına değil
> (`K-2.2.7c`).

> ✅ **Doğrulandı** (2026-08-12, Oturum 3.4). Atomik red **korunur.**
>
> Simetri kararı netleştiriyor: **rezervasyon bir taahhüt, gerçekleşme bir olgu.** Taahhüt
> tarafı sert (`K-2.2.9b` ailesi), gerçekleşme tarafı akar (`K-2.2.17`).
>
> Kısmi kabul, kullanıcının gönderdiğinden **farklı bir planın** sessizce onaylanması
> demektir — `K-2.5.11`'in *"onaylanan = gönderilen"* bütünlüğünü deler.
>
> Çözüm kullanıcının elinde: planı böl, ya da `K-2.2.9j` ile zarfı düzelt.

**K-2.2.11a** — Red mesajı **hangi kalemin** takıldığını açıkça söyler.

> Sürtünmenin panzehiri kısmilik değil, **teşhis netliğidir.**

> ⚠️ **Bilinçli kabul edilmiş bedel:** fatura-dışı bütçesi bol bir plan, fatura-içi aşımı
> yüzünden bloklanabilir.
>
> Bekliyor: `SORULAR A5`.

**K-2.2.12** — Yalnız tek bir harcama tipi kullanan bir plan, diğer tipin doluluğundan
etkilenmez.

**K-2.2.13** — Harcama tipi belirsiz bir istek, bölünmüş bir zarfa rezerve **edilemez** —
açık hata verilir. Varsayılan tip atanmaz.

**K-2.2.14** — Zarf bulunamadığında işlem **sessizce geçmez.** Tek bir bildirilmiş politikaya
göre davranır ve o politika tüm yollarda aynıdır.

**K-2.2.15** — Bütçe rezervasyonu **kötümser kilitleme** ile korunur. Eşzamanlı iki istek
aynı zarfı aşırı kullanamaz.

> ✅ Uygulanıyor. Kaynak bunu zorunlu kılıyor ve bağımsız olarak aynı karara varılmıştı.

## 2.2.8 Anlaşma tavanı

**K-2.2.16** — Bir anlaşmaya karşı yapılan harcama, anlaşmanın tavanını **aşamaz.**

> ✅ **Karar verildi** (2026-08-12, Oturum 3.4). Tavan aşımı `K-2.2.7c` ailesindendir.

**K-2.2.17** — Tavan aşıldığında **gerçekleşme durdurulmaz.** Hakediş tavana **kırpılır**, ve
tavan üstü tutar **açık bir kalem** olarak yazılır.

> Gerekçe (ürün sahibi): aşımı üreten şey bir **hesap**, bir talep değil (`K-2.13.14e`).
> Satış gerçekleşti, oran uygulandı, sonuç tavanı aştı — bu noktada *"reddet"* veya
> *"atla"* seçenekleri **gerçeği inkâr eder.** Borç ekonomik olarak doğmuştur; defterin
> görevi onu doğru kaydetmektir.

**K-2.2.17a** — Kırpılan kısım **yok olmaz.** `TAVAN AŞIMI` kalemi olarak deftere düşer ve
`Σ` korunur (`K-2.13.14j` deseni).

> Üç eski seçeneğin çelişkisi böyle çözülür: *"kırp"* **defter** tarafında doğru,
> *"kabul et + işaretle"* **iş akışı** tarafında doğru — ikisi aynı modelin iki katmanı.

**K-2.2.17b** — ⚠️ **Finans onayı ödemenin kapısıdır, kaydın değil.**

| Karar | Sonuç |
|---|---|
| `ONAYLA` | Aşım tutarı hakedişe eklenir — fiilen bir **tavan revizyonu**, denetim izli |
| `REDDET` | Kalem kapanır, karşı tarafla **mutabakat konusu** olur |

> `K-2.2.9c`'nin (*"aşımın çözümü zarf revizyonudur"*) anlaşma karşılığı.

**K-2.2.17c** — Onay ekranı gelene kadar Faz 1 davranışı: kalem **kuyrukta bekler**
(`K-2.13.12` kuyruğunun komşusu).

> Ekran eksikliği **karar kaybettirmez**, yalnız çözümü el işine bırakır.

**K-2.2.17d** — Anlaşma tavanına **erken uyarı** eklenir: `%90`'da bildirim, engelsiz.

> Ayrı bir merdiven değil, `K-2.10.1` ailesine bir olay.
>
> Gerekçe: **aşım anında öğrenilen tavan, kötü tavandır.** Erken bildirim kuyruğu küçültür.

**K-2.2.18** — Tavan hesabı ve harcama raporlaması **aynı kaynaktan** türer, ve o kaynak
defterdir.

---

# 2.3 · Defter Kuralları

## 2.3.1 Kapsam sınırı

**K-2.3.1** — Defter, ticari harcamanın **denetim düzeyinde izlenebilirlik** kaydıdır. Genel
muhasebe defteri değildir; muhasebe kaydı, borç takibi ve ödeme işlemleri bu ürünün kapsamı
dışındadır.

> Kaynak bu sınırı üç ayrı yerde çiziyor ve üçü aynı şeyi söylüyor.

## 2.3.2 Değişmezlik

**K-2.3.2** — Bir defter kaydı yazıldıktan sonra **tutarı, yönü, zarf bağlantısı ve dönemi
değiştirilemez.**

**K-2.3.3** — Var olan bir kayıtta izin verilen tek değişiklik, `ters çevrildi` işaretinin
`false`'tan `true`'ya alınmasıdır.

**K-2.3.4** — **Hiçbir defter kaydı silinemez** — ne kalıcı ne mantıksal.

> ⚠️ Bugünkü şemada bir "silinme tarihi" kolonu var ve invariant onun **her zaman boş**
> olmasını gerektiriyor. Kaynağın şemasında böyle bir kolon yok.
>
> Bir kuralın "bu kolon hep boş olmalı" demek zorunda kalması, kolonun hiç olmaması
> gerektiğinin işaretidir. Öneri: kolon kaldırılsın.

## 2.3.3 Düzeltme

**K-2.3.5** — Bir kayıt düzeltilecekse **ters kayıt** yazılır: yeni bir satır, zıt yönde, eşit
mutlak tutarda, orijinali işaret ederek.

**K-2.3.6** — Bir kayıt **en fazla bir kez** ters çevrilebilir. Bu kısıt veritabanı seviyesinde
zorunludur.

**K-2.3.7** — Düzeltme **negatif tutarla değil**, zıt yönle yapılır. Tutar her zaman pozitiftir.

> ⚠️ Kaynak bir örnekte negatif tutar kullanıyor ve başka bir yerinde "tutar ≥ 0" kısıtı
> tanımlıyor — kendi içinde çelişiyor. Uzlaştıran tasarım ikincisidir.

## 2.3.4 Tekrarsızlık

**K-2.3.8** — Bir işlem anahtarı taşıyorsa, o anahtar tenant içinde **tekildir** ve tekillik
veritabanı seviyesinde zorunludur.

**K-2.3.9** — Bazı işlem türleri meşru olarak anahtarsızdır (zarf tahsisi, elle düzeltme).
Anahtar kısıtı yalnız anahtar taşıyan satırlara uygulanır.

**K-2.3.10** — Her anahtar, kayıtlı bir biçime uyar. Biçim tek yerde tanımlıdır.

> ⚠️ Kaynak bugün altı farklı anahtar biçimi tarif ediyor ve ikisi aynı kavramın iki yazımı.
> Yeni belgede tek biçim seçilecek.

## 2.3.5 Hesaplama

**K-2.3.11** — Tüketilen harcama `Σ borç − Σ alacak` olarak hesaplanır. Düz bir toplam
kullanılamaz.

> Gerekçe: düz toplam, ters kayıtları harcama gibi sayar ve tüketimi iki katına çıkarır.

**K-2.3.12** — Fatura-içi bir harcama kaydı, her zaman fatura-içi tipli bir zarfa atfedilir.

## 2.3.6 İşlem tipleri

> ⚠️ **Düzeltme (2026-08-12, dış denetim `F5`):** taksonomi tüketimi ve tahakkuku
> taşıyamıyordu — `TÜKETİM` hiçbir tipe eşlenmemişti (ama `D.1` her oku bir defter kaydı
> sayıyor), ve `TAHAKKUK` **yanlış eksende** duruyordu.

**K-2.3.13** — Defter **sekiz** işlem tipi tanır:

| Tip | Ne yazar |
|---|---|
| `TAHSİS` | Zarfa bütçe konur |
| `REZERVE` | Anlaşma onaylanır |
| `TAAHHÜT` | Plan onaylanır |
| `TAHAKKUK` | Dönemsel yükümlülük birikir (`K-2.13.25a`) |
| `TÜKETİM` | Gerçekleşen kesinleşir |
| `İADE` | Rezerve/taahhüt/fazla tahakkuk serbest bırakılır |
| `TRANSFER` | Zarflar arası aktarım — iki bacak, `Σ = 0` |
| `DÜZELTME` | Ters kayıt ve açık kalemler |

**K-2.3.13a** — `DÜZELTME` tipi bir **alt tür** taşır, ve alt tür dört değer alır:

| Alt tür | Ne | Kaynak kural |
|---|---|---|
| `TERS_KAYIT` | Bir kaydın ters çevrilmesi | `K-2.3.5` |
| `FARK` | Açıklanamayan kalıntı | `K-2.13.14i` |
| `TAVAN_AŞIMI` | Tavana kırpılan tutar | `K-2.2.17a` |
| `TOLERANS_FARKI` | Otomatik kabul edilen sapma | `K-2.13.14d` |

**K-2.3.13b** — ⚠️ **Eşleme çift yönlü zorunludur:**

```
DÜZELTME  ⇔  alt tür dolu
```

Alt türsüz bir `DÜZELTME` de, alt türlü bir `REZERVE` de **reddedilir.** Veritabanı
seviyesinde korunur.

> Tek yönlü bir kısıt (*"`DÜZELTME` alt tür taşımalı"*) yeterli değildir: alt tür kolonu
> başka tiplere sızarsa raporlama sessizce yanlış toplar.

**K-2.3.13c** — Alt tür **ayrı bir kolondur**, işlem tipi enum'una eklenmez.

> Gerekçe: dördü de aynı aritmetiğe girer (`K-2.3.11`, `Σ borç − Σ alacak`). Enum'u bölmek
> hesabı değiştirmez ama her tüketiciyi dört yeni değeri ele almaya zorlar.
>
> Alt tür yalnız **raporlama** için ayırt edici: denetçi *"kabul edilen farkların toplamı"*nı
> tek sorguyla görür.

**K-2.3.13d** — Bu kural yürürlüğe girdiğinde **mevcut ters kayıtlar** alt türle işaretlenir.

> ⚠️ Yoksa kural **doğduğu gün** mevcut veriyle ihlal ediliyor olur — bir kuralın kendi
> geçmişini ihlal etmesi, bu oturumda ölçülmüş bir sınıf.

> Üç açık kalem türü **yok olmaz, yazılır** — sessiz yutma, sessiz sıfırın para hâli olurdu.

**K-2.3.14** — Harcama tipi **üç** değer alır:

```
FATURA-İÇİ · FATURA-DIŞI · DÜZELTME
```

> ⚠️ `TAHAKKUK` bu listeden **çıkarıldı** — bir işlem tipidir, bir harcama tipi değil. İki
> eksen karışıyordu: harcama tipi *"para nereye gitti"*, işlem tipi *"kovada ne oldu"* der.

## 2.3.7 Kayıt bütünlüğü

**K-2.3.15** — Gerçekleşen hiçbir ekonomik olay, bir bütçe sınırı yüzünden **kayıtsız
kalamaz.** Bütçe kısıtı bir kaydın yazılmasını engelleyemez; en fazla onu işaretler.

**K-2.3.16** — Onaylanmış her işlemin defterde **tam olarak bir** karşılığı vardır. Bir işlem
kaydedilip defter kaydı oluşmazsa bu bir kusurdur, bir durum değil.

## 2.3.8 Hakediş zinciri

**K-2.3.17** — Hakediş zincirinin defter kuralları `2.13`'te tanımlıdır.

> Bu bölüm geçici olarak burada yazılmıştı; yapı denetimi (`L2_YAPI_DENETIMI.md`) hakedişin
> konumlanmanın **çekirdeği** olduğunu ve bir alt başlıkta anlatılamayacağını ölçtü.
> `2.13 · Hakediş ve Mutabakat` olarak kendi bölümüne taşındı.

---

# 2.4 · Hesaplama Kuralları

## 2.4.1 İki alan

**K-2.4.1** — Sistem hesaplama açısından iki alana ayrılır:

| Alan | Kapsam | Aritmetik |
|---|---|---|
| **Para** | Bütçe, defter, anlaşma, harcama hesabı, hakediş | **Tam** — yuvarlama hatası kabul edilmez |
| **Analitik** | Kârlılık oranları, yüzdeler, renk göstergeleri, raporlar | Kayan nokta kabul edilebilir |

**K-2.4.2** — **Bağlayıcı sınır:** analitik alanın çıktısı **para olarak kalıcılaştırılamaz**
ve bir para eşiğiyle karşılaştırılamaz. Para alanına dönüş için değer yeniden üretilmelidir.

> ❌ **Ölçülmüş ihlal:** planlanan brüt kâr analitik alanda hesaplanıp para olarak
> kaydediliyor.

**K-2.4.3** — Renk göstergeleri (RAG) bir para hareketini **bloklayan** kapıya
dönüştürülemez. Dönüştürülmek istenirse karar değeri para alanında yeniden üretilir.

## 2.4.2 Eksik veri

**K-2.4.4** — Bir hesaplamanın bağımlılığı eksikse sonuç **`boş`** döner, sıfır değil.

**K-2.4.5** — Sıfıra bölme, tanımsız veya sonsuz sonuç: hepsi `boş` döner.

> ⚠️ **Bilinçli kaynak sapması.** Kaynağın motor sözde-kodu eksik bağımlılığa `0` atıyor.
> Bu, maliyeti olmayan bir ürünü "maliyetsiz kâr" gibi hesaplar ve kârlılığı şişirir.
> Bugünkü veriyle (170 üründen 166'sında maliyet yok) bu, planların neredeyse tamamını
> yanlış yeşil gösterirdi.
>
> Kaynak kendi içinde de tutarsız: kenar durum bölümü `boş` diyor. Bizim davranışımız o
> bölümle uyumlu.

**K-2.4.6** — Koruma **motorda** uygulanır, her formülde değil.

> Gerekçe: formül yazarının disiplinine bağlı bir koruma unutulabilir. Kaynak korumayı her
> formüle koyuyor ve kendi sözde-kodunda üç kez unutuyor.

**K-2.4.7** — `boş` bir gösterge, tüketim tarafında sıfıra çevrilemez.

> ❌ **Ölçülmüş ihlal:** iki finans raporlama rotası `boş` kârlılığı `0` olarak, `boş` rengi
> `yeşil` olarak gösteriyor. "Bilmiyorum" cevabı "sorun yok" olarak görünüyor.

## 2.4.3 Girilen değer semantiği

**K-2.4.8** — Planlamacının girdiği bir değerde **boş bırakmak ile sıfır yazmak arasında anlam
farkı yoktur.** İkisi de sıfır harcama üretir.

> Gerekçe: %0 indirim ile indirim yok ekonomik olarak aynıdır.

**K-2.4.9** — Bu kural **yalnız girilen değerler** içindir. Hesaplanan göstergeler ve
konfigürasyon ayarları farklı eksenlerdir ve zıt kararlar taşırlar (`K-2.1.18`, `K-2.4.4`).

**K-2.4.10** — Doğrulama sınırları için ise ayrım korunur: bir mekanik için değer
girilmemişse alt/üst sınır doğrulaması **atlanır**, sıfır olarak doğrulanmaz.

## 2.4.4 Yuvarlama ve dağıtım

**K-2.4.11** — Para değerleri iki ondalığa yuvarlanır, mod **sıfırdan uzağa**.

> Gerekçe: negatif tutarlarda simetrik davranır (`|round(x)| = round(|x|)`), ve ticari
> mutabakatta beklenen budur.

**K-2.4.12** — Yuvarlama **yalnızca kalıcılaştırma anında** yapılır. Ara hesaplarda
yuvarlanmaz.

**K-2.4.13** — Bir tutar parçalara bölünürken **en büyük artık** yöntemi kullanılır: her paya
kuruşa yuvarlanmış tam pay verilir, kalan artık kesirli kısmı en büyük olanlara birer kuruş
dağıtılır.

**K-2.4.14** — Eşitlik durumunda sıralama bir **iş anahtarına** göre yapılır. Üretilmiş bir
kimliğe (UUID) göre sıralama yasaktır.

> Gerekçe: üretilmiş kimlik rastgeledir; aynı girdi farklı sonuç verir.

**K-2.4.15** — Dağıtımda toplam korunur: `Σ(paylar) = toplam`, her zaman.

## 2.4.5 Götürü harcama dağıtımı

> ✅ **Karar verildi** (2026-08-12, Oturum 3.8). Taban **planlanan hacim**; dağıtım bir
> **rapor hesabıdır**, deftere yazılmaz.

**K-2.4.16** — ⚠️ **Dağıtım hangi katmanda yaşar:**

| Katman | Davranış |
|---|---|
| Hakediş / mutabakat | Götürü kalem **anlaşma seviyesinde** kalır, dağıtılmaz (`K-2.13.14f`) |
| Kârlılık raporu | **Görüntüleme anında** dağıtılır, planlanan hacim payıyla |

**Dağıtım deftere yazılmaz.** Bir rapor hesabıdır.

> Üç kazanç: hakediş grain'i kirlenmez · plan revize edildiğinde dağıtım kendiliğinden
> güncel kalır (malzemeleşmiş bir pay bayatlamaz) · pay fonksiyonu `K-2.1.8a` ile **ortaktır**
> (`İlke 4` — ikinci bir dağıtım kodu yazılmaz).

**K-2.4.17** — Dağıtım tabanı **planlanan hacimdir.**

> Gerekçe (ürün sahibi): `K-2.1.8d` sonrası planlanan hacim **iki kaynağın birleşimidir** —
> türetilmiş paylar (geçmişten) + insan kararları (yeni ürün lansmanı). Yani geçmiş hacimden
> **daha zengin** bir taban: geçmişin bilgisini zaten içeriyor, üstüne ticari niyeti ekliyor.
>
> Ve soru şuna indirgeniyor: raf kirasının bir kısmı bir lansmana ödeniyorsa, yeni ürünün
> kârlılığı o maliyeti görmeli mi? **Evet** — görmezse lansman *"bedava"* görünür, ilk gerçek
> dönemde kârlılık çöker ve kimse nedenini anlamaz.
>
> Geçmiş hacim tabanı **iki yönlü bozulma** üretir: yeni ürün pay almaz, ve lansman maliyeti
> **eski ürünlerin sırtına biner** — onların kârlılığı da haksız kötüleşir.

**K-2.4.17a** — ⚠️ Dönem kapanışında **taban donar:** kapanış anındaki plan payı kalıcılaşır.

> Kapanmış bir dönemin raporu geriye dönük oynamaz.

**K-2.4.17b** — Planı olmayan ama satış yapmış bir SKU (`planlanan = 0`, `gerçekleşen > 0`)
götürüden **pay almaz** — götürü, planlanan aktivitenin bedelidir.

Rapora bir dipnot düşülür: *"dağıtım tabanı dışında N ürün."*

**K-2.4.17c** — Bir FU'nun **tüm planı sıfırsa** dağıtım yapılamaz. Götürü FU seviyesinde
raporlanır ve *"dağıtılamadı"* olarak işaretlenir.

> **Sessiz eşit pay asla** (`K-2.1.8b` ailesi).

> ⚠️ **`ADR 0006` revize edilir.** Eski gerekçe (*"kaynakta açık formül yok"*) ölçümle
> **yanlışlandı** — formül vardı, atlanan bir bölümdeydi ve tabanı planlanan hacim.

## 2.4.6 Gösterge hesabı

**K-2.4.18** — Kârlılık oranı:

```
Kârlılık = Artımsal Brüt Kâr ÷ Toplam Planlanan Harcama × 100
```

> Payda **toplam planlanan harcamadır**, artımsal harcama değil. Ürünün dört ayrı eşiği
> (yeşil sınırı, otomatik ret, finans onayı, faz kapısı) bu paydaya göre kalibre edilmiştir;
> payda küçültülürse dördü de gevşer.

**K-2.4.19** — Oran göstergeleri üst seviyelere **pay ve payda ayrı toplanarak** taşınır:

```
Üst seviye oran = Σ(pay) ÷ Σ(payda)
```

Alt seviye oranların ortalaması **alınmaz.**

> Kaynak da bunu hem kelimeyle ("harcamaya göre ağırlıklı") hem kendi örnek aritmetiğiyle
> doğruluyor.

**K-2.4.20** — Toplama, **tüm bağımlılıkların çözüldüğü kesişim** üzerinden yapılır. Bir alt
öğenin bir bağımlılığı eksikse, o öğe hem paydan hem paydadan düşer.

> Gerekçe: pay 4 öğeden, payda 170 öğeden toplanırsa oran anlamsızdır — ölçülen bir vakada
> gerçek değerin 1/42'sini üretmişti.

**K-2.4.21** — Toplanan her gösterge bir **kapsama oranı** taşır: değer kaç alt öğeden türedi.

> ✅ **Karar verildi** (2026-08-12, Oturum 3.9). Eşik yok; `GRİ` dördüncü bir durum.

**K-2.4.22** — Renk **yalnız tam kapsamada** verilir. **Kapsama eşiği tanımlanmaz.**

> Gerekçe (ürün sahibi) — üç kat:
>
> **Kısmi kapsama, kısmi doğruluk değildir — bilinmeyen yönde yanlılıktır.** Maliyeti
> girilmemiş ürünler rastgele değildir: tipik olarak yeni ürünler (lansman, düşük marjlı
> dönem) ya da ithal/karma kalemlerdir. Eksik dilim **sistematik olarak farklı marj** taşır,
> ve `%80`'lik bir kesişim değeri yönü bilinmeyen şekilde iyimser ya da kötümserdir.
>
> Böyle bir sayıya yeşil vermek, **eksikliği renkle örtmektir** (`İlke 2`).
>
> **Eşik kaynaksız bir sabit olurdu.** `%80` neden 80? Hiçbir ölçüm, hiçbir kaynak. Ve
> konfigüre edilebilir yapmak sorunu çözmez, **taşır**: tenant yöneticisi o sayıyı neye göre
> seçecek? Anlamlandırılamayan bir düğme kurulum yüküdür.
>
> **Bugünkü katılık bir hata değil, dürüst teşhistir.** Sistem *"kârlılığa renk verecek
> durumda değilim"* diyor — ki değil. Eşikle yumuşatmak, ürünün en değerli davranışını
> sulandırır.
>
> **Renk bir güven beyanıdır, ve güven beyanı kısmi olamaz** (`K-2.2.7` ailesi).

**K-2.4.22a** — ⚠️ **`GRİ` dördüncü bir birinci-sınıf durumdur**, bir boşluk değil:

| Durum | Ne zaman | Ne gösterilir |
|---|---|---|
| Yeşil / Sarı / Kırmızı | Tam kapsama | Değer + renk |
| **Gri** — *"hesaplanamadı"* | Kısmi veya sıfır kapsama | **Değer + kapsama rozeti + eksik listesi** |

**K-2.4.22b** — `GRİ` durumda değer **gösterilir** (kesişimden), yanında kapsama oranı
(`4/170` gibi) durur, ve eksik olan öğeler görülebilir.

> Kullanıcı kararı verir — ama sistemin sunduğu **dürüst zeminde.**

**K-2.4.22c** — ⚠️ **Invariant:** kapsama tam değilken renk **asla** tam-kapsama paletini
alamaz. Testle korunur.

> ❌ **İki ölçülmüş ihlal, bu tanımın ihlalidir:**
> - Kapsama oranı istemciye ulaşmıyor → `GRİ` durumu rozetsiz kalıyor
> - Finans raporlama yolunda *"renk yok"* sessizce **yeşile** dönüşüyor
>
> İkincisi **en tehlikeli türden**, çünkü tam da güven beyanını sahteleştiriyor. Düzeltme
> önceliğinde ilk sırada.

## 2.4.7 Formül motoru

**K-2.4.23** — Göstergeler **konfigürasyonda tanımlı formüllerle** hesaplanır, kodda gömülü
değil.

> ⚠️ Bugün gösterge formülleri veritabanında; ama plan grid'inin türettiği bazı değerler ve
> tüm eşikler kodda.

**K-2.4.24** — Formül değerlendirmesi **sunucuda** yapılır.

> Kaynak bir maddesinde tarayıcıda çalıştırmayı öneriyor. Ama aynı kaynağın birincil güvenlik
> çözümü sunucu tarafı bir sandbox'tır, performans ölçüm modeli sunucu turunu varsayar, ve
> ilgili madde bir sonraki faza ertelenmiştir. Üç kanıt aynı yöne.

**K-2.4.25** — Formül metni değerlendirilmeden önce **karakter beyaz listesinden** geçer.
Değişkenler değerleriyle değiştirildikten sonra ifadede yalnız rakam ve aritmetik operatör
kalır.

**K-2.4.26** — Formül **kaydedilirken** doğrulanır: sözdizimi kontrolü ve örnek veriyle deneme
çalıştırma.

> ❌ **Ölçülmüş ihlal:** doğrulama yazılmış, uç noktası açılmış, istemci sarmalayıcısı bile
> yazılmış — **hiçbiri çağrılmıyor.** Yönetici bugün geçersiz sonuç üreten bir formülü
> kaydedebilir.

**K-2.4.27** — Hesaplama sırası, formüller arası bağımlılığa göre belirlenir.

> ⚠️ Bugün sıra elle atanmış bir tamsayıya göre. Sıra bağımlılıkla çelişirse hiçbir şey
> yakalamaz — kaynakta da aynı durum.

---

# Kaynak haritası

| Bölüm | Bağlayıcı belge | Verilmiş karar | Ölçüm |
|---|---|---|---|
| 2.1 | `§3.1` · `§3.5` · `§5.2` · `§7.1` | `ADR 0009` | `0052` · `0057` · `0067` |
| 2.2 | `§3.3` · `§8.1` · `§10.1` | `ADR 0004` · `ADR 0005` | `0049` · `0053` · `0061` |
| 2.3 | `§3.6` · `§6.4` | `ADR 0004` | `0023` · `0038` · `0058` |
| 2.4 | `§5.3` · `§5.2` · `§8.1` · `H5` | `ADR 0007` · `0008` · `0011` | `0031` · `0032` · `0051` · `0061` |

**Değişen:** hesaplama motorunun eksik veri davranışı (`K-2.4.4`) kaynağın sözde-kodundan
bilinçli olarak ayrılıyor; gerekçesi kuralın yanında.

**Düşen:** kaynağın ekran taslakları bu katmana alınmadı — L2 bilgiyi tanımlar, sunumu değil.

**Okunmadı:** `Section_03`'ün ~%70'i, `Section_05`'in ~%73'ü. Okunmayan kısımlar `0054` ve
`0059` envanterlerinde gerekçeleriyle listeli; ikisi de bu bölümlerin kritik bloklarının
okunduğunu kaydediyor.

---

# Açık kalanlar

> ⚠️ **Bu bölüm 2026-08-12'de kaldırıldı.** Açık kural listesi tek bir yerde yaşar:
> `00_PAKET_INDEKSI.md`. Bölüm sonlarında tutulan kopyalar karar turundan sonra **bayat**
> kaldı (dış denetim `F8`) — ve bayat bir durum listesi, olmayan bir listeden kötüdür.

| Kural | Neyi bekliyor |
|---|---|
| `K-2.1.8` | Hacim seviyesi — kaynak kendi içinde çelişiyor |
| `K-2.2.8` | Eşik değeri ve şekli |
| `K-2.2.17` | Tavan aşımı davranışı |
| `K-2.3.14` | Tahakkuk mekanizması |
| `K-2.4.17` | Götürü dağıtım tabanı |
| `K-2.4.22` | Kısmi kapsama eşiği |

Altısı da `SORULAR.md`'nin domain sorularına bağlı ve karara bağlanmadan yazılamaz.
