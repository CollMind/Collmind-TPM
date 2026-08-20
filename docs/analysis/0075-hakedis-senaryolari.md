# 0075 — Hakediş zinciri kullanıcı senaryoları (L2 2.13'e karşı bağımsız sınama seti)

- **Tarih:** 2026-08-21
- **Amaç:** `L2 2.13` (hakediş zinciri, 27 kural) bölümünün davranışsal doğruluğunu
  **bağımsız** senaryolarla sınamak. Senaryolar L2'ye bakılmadan yazıldı; Team Lead
  bunları L2'ye karşı ayrı ayrı ölçecek.
- **Yöntem kısıtı (bilinçli):** `docs/brd-v2/03_IS_KURALLARI/L2_*` dosyaları **okunmadı ve
  grep'lenmedi.** Kurallar verilseydi senaryolar onlara uyacak şekilde yazılır ve hiçbir
  şeyi sınamazdı.

## Girdi kaynakları (yalnız bu üçü)

| # | Kaynak | Ne verdi |
|---|---|---|
| 1 | `docs/brd-v2/01_KONUMLANMA.md` (L0, tamamı) | Ürün duruşu: settlement-first çekirdek, Türkiye ilk pazar, "eksik veri görünür olur" ilkesi, muhasebe sınırı |
| 2 | `docs/brd-v2/02_YETENEK_HARITASI.md` §1.7 "Gerçekleşen ve hakediş" | Zincir anlatımı: Talep üretimi → Talep alımı → Eşleştirme → Mutabakat → Kapanış; tek talep varlığı; üç kademeli eşleştirme; ikili tolerans; FARK kalemi; operasyonel tahakkuk; iki kapanış |
| 3 | `docs/analysis/0070-b-dalgasi-olcum-turu-ttm-kanitiyla.md` §B1 | Gerçek veri şekli: TTM'de 22 actuals CSV, 16'sı kanonik `cpl_code,fu_code,gross_amount,net_amount,discount_amount,volume`; 4'ü eski/ikincil `category,channel_code` biçimi, hacimsiz |

**Verilmeyenler ve gerekçeleri:**

- **Rakip/segment analizi belgesi yok** — Türkiye FMCG ciro primi mutabakatı pratiği ve
  matürite kademeleri için ayrı belge verilmedi; bu kısım yazarın domain bilgisinden
  geliyor ve `GEREKÇELİ` ile işaretli.
- **`wella_actuals_first_scenarios.md` bilinçli olarak kullanılmadı** — o belge SONRAKİ
  turda bu setle karşılaştırılacak (iki bağımsız kaynak aynı çıkmazları buluyorsa güçlü
  sinyal). Bu dosya yazılırken aranmadı, içeriği varsayılmadı.

## İşaretleme sözlüğü

| İşaret | Anlamı |
|---|---|
| `ÖLÇÜLDÜ` | Üç kaynaktan biri doğrudan söylüyor (kaynak + grep'lenebilir alıntı verildi) |
| `GEREKÇELİ` | Domain deneyiminden; doğrulanamaz ama Türkiye FMCG pratiğinde bilinen davranış |
| `VARSAYIM` | Kaynaklarda yok; senaryonun akması için tahmin edildi — ölçülmüş sayılmaz |
| `⛔ BOŞLUK BULGUSU` | Senaryonun bir adımı, kaynaklarda TANIMSIZ bir mekanizma gerektiriyor. Senaryo o mekanizmaya göre yazılmadı; boşluk görünür bırakıldı |
| `🔇 SESSİZLİK` | Sistemin kullanıcıya **hiçbir şey söylemediği** an — dördüncü sorunun ("sistem ne söyler") cevabının boş kaldığı yer. Ürün boşluğu adayı |

> ⚠️ **Genel not — bugünkü durum ile hedef davranış:** L1 §1.7 durum tablosu zincirin
> alım/eşleştirme/mutabakat/dönem-kapanışı yarısını `❌` işaretliyor ("Talep nesnesi ❌ ·
> Eşleştirme ❌ kullanıcı elle giriyor · Mutabakat ❌ · Dönem kapanışı ❌ · Tahakkuk ❌ şema
> hazır, davranış yok" — `ÖLÇÜLDÜ`, L1 §1.7 "Durum" tablosu). Senaryolar **hedef davranışı**
> sınıyor: L2 2.13'ün bu adımlar için kural yazıp yazmadığı, yazdıysa doğru şeyi yazıp
> yazmadığı ölçülecek.

## Ortak sahne

- **Üretici:** "Aslan Gıda" — orta ölçekli Türk FMCG üreticisi (L0 "referans müşteri
  Türkiye'deki orta ölçekli üreticidir" — `ÖLÇÜLDÜ`, L0 §1-Nerede).
- **Müşteri 1:** "Yıldız Market" — ulusal zincir perakendeci. Ciro primini çeyrek dönem
  toplamı olarak, **satır kırılımı vermeden** keser; kesinti cari hesaptan mahsup edilir ve
  e-fatura ("ciro prim bedeli" faturası) olarak gelir (`GEREKÇELİ` — TR zincir perakende
  pratiği; L0 da "ciro primi mutabakatları, cari hesap/BA-BS mutabakat kültürü, e-belge
  ekosistemi" der — `ÖLÇÜLDÜ`, L0 §1-Nerede).
- **Müşteri 2:** "Ege Dağıtım" — bölgesel distribütör. Birim başı destek (adet × oran)
  hakedişini hacim kırılımlı Excel ile talep eder (`GEREKÇELİ`).
- **Roller:** KAM (Key Account Manager / Satış) · Kategori Müdürü · Finans Müdürü.
  ⚠️ `VARSAYIM`: bu üç rolün üründe ayrı rol olarak var olduğu ve hangi ekranı gördüğü
  verilen üç kaynağın hiçbirinde tanımlı değil. Rol-ekran atamaları senaryolarda akış
  gereği yapıldı; L2 ölçümünde "bu rol bu adımı gerçekten yapabiliyor mu" ayrıca sorulmalı.

---

# Senaryo 1 · Referanssız, kırılımsız, KDV'li dönem-toplamı kesintisi

**Çıkmaz:** Eşleştirmenin birinci kademesi (karşı taraf referansı) çalışmıyor — ve ikinci
kademenin anahtarlarının bir kısmı kesintide hiç yok.

**Olay:** Yıldız Market, 2026 Q2 ciro primini tek satırlık e-fatura ile keser:
*"2026 2. çeyrek ciro prim bedeli — 1.487.250,00 TL (KDV dahil)"*. Faturada anlaşma
numarası yok, kategori/ürün kırılımı yok, dönem yalnız açıklama metninde. Tutar cari
hesaptan mahsup edilmiş — para fiilen gitmiş durumda (`GEREKÇELİ` — TR pratiğinde kesinti
önce olur, mutabakat sonra yapılır).

### Finans Müdürü gözünden

- **GÖRÜR:** e-fatura gelen kutusunda / cari ekstre mutabakatında tek satır kesinti.
  Sistemde değil — belge sisteme kendiliğinden düşmez (`VARSAYIM`: e-fatura entegrasyonu
  yok; L0 kenar AI "hakediş dokümanını yapıya çeviren alım asistanı"ndan bahseder ama bu
  bir hedef, tanımlı bir mekanizma değil — `ÖLÇÜLDÜ`, L0 §5 "dış hakediş dokümanını yapıya
  çeviren alım asistanı").
- **YAPAR:** kesintiyi sisteme **dış talep** olarak elle girer. Talep tek varlıktır, iç/dış
  ayrım bir alandır (`ÖLÇÜLDÜ`, L1 §1.7 "Talep tek varlıktır … ayrım bir alandır").
- **TAKILIR — üç yerde:**
  1. **KDV.** Kesinti KDV dahil 1.487.250 TL; iç taleplerimiz net tutar taşır (oran bazlı
     mekaniklerin tabanı net satıştır — `ÖLÇÜLDÜ`, L1 §1.7 "Oran bazlı mekaniklerin tabanı
     net satıştır"). Dış talebi girerken tutarı KDV'den arındırıp mı girecek, brüt mü?
     ⛔ **BOŞLUK BULGUSU 1:** dış talep tutarının vergi bileşeni (KDV dahil/hariç alanı,
     arındırma sorumluluğu) üç kaynağın hiçbirinde tanımlı değil. Türkiye pratiğinde ciro
     primi faturası KDV'li kesilir (`GEREKÇELİ`) — bu alan tanımsızsa her mutabakat
     %20'lik yapay bir "fark"la başlar ve tolerans mekanizması ilk günden anlamsızlaşır.
  2. **Dönem.** Dönem bilgisi yalnız serbest metinde ("2. çeyrek"). Sistemin dönem alanına
     çeyreği mi, üç ayrı ayı mı girecek? İç taleplerimiz aylık tahakkuk etmişse (dönemsel
     kadanslı anlaşmalar aylık tahakkuk eder — `ÖLÇÜLDÜ`, L1 §1.7 "Tahakkuk") bir çeyreklik
     dış talep üç aylık iç talebe karşı durur. ⛔ **BOŞLUK BULGUSU 2:** dönem
     granülerlik uyuşmazlığı (çeyreklik dış ↔ aylık iç) için eşleştirme davranışı
     tanımsız — kademe 2 "dönem + müşteri + kategori + kanal" der (`ÖLÇÜLDÜ`, L1 §1.7
     "Eşleştirme"), ama "dönem" anahtarının iki tarafta farklı granülerlikte olması halini
     söylemez.
  3. **Kategori.** Kesinti tüm kategorilerin toplamı; kademe 2'nin anahtarlarından
     "kategori" dış talepte **boş**. ⛔ **BOŞLUK BULGUSU 3:** aday kümesi anahtarlarından
     biri dış talepte yokken kademe 2'nin nasıl çalışacağı tanımsız — boş anahtar joker mi
     sayılır (aday kümesi büyür), eşleşme mi engellenir (küme boşalır)? İki yorum zıt
     sonuç verir ve kaynak seçim yapmıyor.
- **SİSTEM NE SÖYLER:** referans yok → kademe 1 atlanır, kademe 2'ye düşer (`ÖLÇÜLDÜ`,
  L1 §1.7 üç kademe sıralaması). Aday kümesi ne çıkarsa çıksın, birden çok adayda sistem
  seçim yapmaz, kuyruğa adaylarıyla düşürür (`ÖLÇÜLDÜ`, L1 §1.7 "Otomatik kesinleşme
  tekillik ister … kuyruğa adaylarıyla birlikte düşer"). 🔇 **SESSİZLİK:** kuyruğa düşen
  talep için sistemin kullanıcıya **neden** kuyruğa düştüğünü söyleyip söylemediği (referans
  yoktu / aday çoktu / anahtar boştu — üç farklı kök neden, üç farklı aksiyon) hiçbir
  kaynakta tanımlı değil. Kök neden söylenmezse kullanıcı her kuyruk kalemini sıfırdan
  araştırır.

### KAM gözünden

- **GÖRÜR:** hiçbir şey — kesintiyi finans girene kadar KAM'ın haberi yok (`GEREKÇELİ` —
  kesinti cariden yapılır, satışın haberi çoğu zaman ekstre mutabakatında olur).
  🔇 **SESSİZLİK:** "senin müşterinden yeni dış talep geldi" bildirimi hiçbir kaynakta yok.
- **YAPAR:** kuyruğu açar (⛔ **BOŞLUK BULGUSU 4:** kuyruğun **sahibi** tanımsız — kuyruk
  kimin ekranı? KAM'ın mı, finansın mı? Kim işlemekle yükümlü, işlenmeyen kalem kaç gün
  sonra kime yükselir? Üç kaynakta kuyruk yalnız bir hedef durak olarak geçiyor, işletim
  kuralı yok).

---

# Senaryo 2 · Üç iç talep, bir dış kesinti — belirsiz eşleşme

**Çıkmaz:** Aday kümesi 3 — otomatik kesinleşme tekillik ister, sistem seçim yapmaz. Sonra?

**Olay:** Q2'de Yıldız Market için üç iç talep üretilmiş: (a) ciro primi Q2 — 1.180.000 TL
(türetilebilir sınıf: oran × gerçekleşen net satış), (b) Haziran insert bedeli — 150.000 TL
(sözleşmesel sınıf: dönem koşulu sağlandıysa tamamı doğar), (c) Q2 raf kirası — 120.000 TL
(sözleşmesel). Kanıt sınıfları `ÖLÇÜLDÜ` (L1 §1.7 "Her mekanik bir kanıt sınıfı taşır"
tablosu). Dış kesinti tek: 1.487.250 TL — üçünün toplamı 1.450.000'e yakın ama eşit değil.

### KAM gözünden

- **GÖRÜR:** kuyrukta bir kalem, yanında üç aday (`ÖLÇÜLDÜ`, L1 §1.7 "kuyruğa adaylarıyla
  birlikte düşer").
- **YAPAR:** Yıldız Market'in kesintisinin fiilen "hepsinin toplamı" olduğunu ilişkiden
  bilir (`GEREKÇELİ` — TR pratiğinde zincirler dönem sonunda tüm kalemleri tek dekontta
  toplar). Bir dış kesintiyi **üç iç talebe birden** bağlamak ister — model buna izin
  verir: "bir dış kesinti birden çok iç talebe — ya da hiçbirine — denk düşebilir"
  (`ÖLÇÜLDÜ`, L1 §1.7 "eşleştirme ayrı bir bağ varlığıdır").
- **TAKILIR:**
  1. ⛔ **BOŞLUK BULGUSU 5:** çoklu bağda **tutar ataması** tanımsız. 1.487.250'nin ne
     kadarı (a)'ya, ne kadarı (b)'ye düşer? İç taleplerin kendi tutarları belli — doğal
     cevap "her iç talep kendi tutarıyla kapanır, kalan 37.250 FARK olur" gibi görünüyor
     ve FARK modeliyle tutarlı (Σ(taktik gerçekleşmeleri) + FARK = dış talep tutarı —
     `ÖLÇÜLDÜ`, L1 §1.7 "Fark" formülü). Ama bu bir çıkarım; kaynak çoklu-bağ tutar
     mekaniğini yazmıyor. Ve dikkat: orantısal dağıtım reddedilmiş (`ÖLÇÜLDÜ`, L1 §1.7
     "Orantısal dağıtım reddedildi") — o ret taktik-gerçekleşme dağıtımı içindi; çoklu
     eşleştirmede aynı ret geçerli mi, ayrı bir kural mı var — L2'de ölçülmeli.
  2. ⛔ **BOŞLUK BULGUSU 6:** kuyruktan **elle kesinleştirme yetkisi** tanımsız. KAM tek
     başına "bu kesinti şu üç talebin karşılığıdır" diyebilir mi, yoksa finans onayı mı
     gerekir? Yanlış eşleşme eşleşmemekten pahalıdır ve dönem kapanışına gömülür
     (`ÖLÇÜLDÜ`, L1 §1.7 "Yanlış eşleşme, eşleşmemekten pahalıdır"). Kaynağın kendi
     mantığı elle kesinleştirmeye bir kontrol (ikinci göz / rol kısıtı) koydurur — ama
     böyle bir kontrol üç kaynakta yazılı değil. `GEREKÇELİ`: finansal kontrol denetimi
     (SOC 1 benzeri) satın alma kriteri sayılıyorsa (L0 §4 — `ÖLÇÜLDÜ`) tek kişilik
     eşleştirme kesinleştirmesi denetim bulgusu olur.
- **SİSTEM NE SÖYLER:** adayları listeler (`ÖLÇÜLDÜ`). 🔇 **SESSİZLİK:** adayların
  toplamı ile kesinti arasındaki farkı (37.250) **kuyruk ekranında** gösterir mi? Fark
  hesabı ancak eşleşme kesinleştikten sonra mı doğar? Kaynak sessiz. KAM'a karar anında
  "üçünü seçersen 37.250 açık kalır" denmezse, KAM en yakın tek adayı seçip kalanları
  kuyrukta bırakma eğilimine girer (`GEREKÇELİ` — kullanıcı en az dirençli yolu seçer) ve
  iki sözleşmesel talep süresiz "eşleşmemiş" kalır.

### Kategori Müdürü gözünden

- **GÖRÜR:** kendi kategorisinin taktiklerini ve plan-gerçekleşen ekranını. Taktik
  gerçekleşmesi dış talepten türetilmez, kanıttan gelir (`ÖLÇÜLDÜ`, L1 §1.7 "Dış talep bir
  doğrulamadır, bir veri kaynağı değil") — yani insert taktiği kesinti kuyrukta beklerken
  de "gerçekleşti" görünebilir.
- **TAKILIR:** taktiğin "gerçekleşti" durumu ile "karşı tarafça doğrulandı" durumu
  arasındaki ayrımı ekranda görüyor mu? ⛔ **BOŞLUK BULGUSU 7:** "kanıttan gerçekleşti ama
  dış taleple henüz doğrulanmadı" ara durumunun kullanıcıya bir durum/rozet olarak
  gösterilmesi tanımsız. Doğrulama kavramı modelde var (K-2.13.14e atfı L1'de görünüyor),
  görünürlüğü yok.

---

# Senaryo 3 · Tolerans dışı fark — KAM ne yapar

**Çıkmaz:** Kaynak yalnız tolerans **içi** farkın kaderini yazıyor. Tolerans **dışı**
farkın süreci tanımsız.

**Olay:** Eşleşme kesinleşti: Ege Dağıtım'ın birim başı destek dönemi. İç talep 412.000 TL
(oran × gerçekleşen hacim — türetilebilir sınıf, `ÖLÇÜLDÜ`), dış talep 468.500 TL. Fark
56.500 TL (%13,7). Tolerans ikili eşiktir — oran ve mutlak, küçük olan bağlar, dar başlar
(`ÖLÇÜLDÜ`, L1 §1.7 "Tolerans ikili bir eşiktir"). Eşik değerleri ne olursa olsun (%13,7
hiçbir makul dar eşiğin içinde değil — `GEREKÇELİ`) fark tolerans dışı.

**Fark sebebi (gerçekçi):** Ege Dağıtım hacmi kendi sevkiyat kayıtlarından saymış; iade ve
fire düşülmemiş. Bizim hacmimiz gerçekleşen net satıştan geliyor (`GEREKÇELİ` — distribütör
mutabakatlarında en sık fark kaynağı sayım tabanı farkıdır; ve brüt taban çifte sayım
üretir, karşı tarafın hesabıyla uyuşmaz uyarısı kaynakta var — `ÖLÇÜLDÜ`, L1 §1.7
"Brüt taban çifte sayım üretir").

### KAM gözünden

- **GÖRÜR:** eşleşmiş ama mutabık olmamış bir talep; 56.500 TL fark.
- **YAPAR (gerçek hayatta):** Ege Dağıtım'ın satış operasyon sorumlusunu arar, hacim
  dökümünü ister, iki listeyi Excel'de yan yana koyar, iade/fire farkını bulur, düzeltilmiş
  tutarda anlaşır (`GEREKÇELİ` — bugünkü fiili süreç; L0 "kullanıcıların %91'i TPM ürününü
  tabloyla tamamlıyor" — `ÖLÇÜLDÜ`, L0 §1).
- **TAKILIR — süreç boşluğu:**
  1. ⛔ **BOŞLUK BULGUSU 8 (bu setin en büyüğü):** tolerans dışı farkın **durum makinesi**
     tanımsız. Tolerans içi fark deftere ayrı kalem yazılır (`ÖLÇÜLDÜ`, L1 §1.7 "Tolerans
     içi fark yok olmaz, deftere ayrı bir kalem olarak yazılır"); açıklanamayan kalıntı
     FARK kalemi olarak durur (`ÖLÇÜLDÜ`). Ama tolerans dışı bir fark bulunduğunda:
     mutabakat "araştırmada" gibi bir ara duruma girer mi? Talep bloke mi olur? FARK kalemi
     hemen mi yazılır, araştırma bitince mi? Kim "bu fark açıklandı, şu kısmı kabul, şu
     kısmı ret" kararını verir? Üç kaynak bu sorulara tek satır ayırmıyor.
  2. KAM araştırma sonunda farkın 49.000 TL'sinin iade tabanından geldiğini buluyor —
     **kısmi kabul** yapmak istiyor: 49.000 haklı değil (bizim hesap doğru), 7.500 belirsiz.
     ⛔ **BOŞLUK BULGUSU 9:** kısmi kabul/ret mekanizması tanımsız. FARK modeli tutarı
     taşıyabilir ama "farkın 49.000'i şu sebeple reddedildi, 7.500'ü açık" ayrımını tek
     FARK kalemi taşıyamaz — sebep/sınıflandırma alanı (fiyat farkı / hacim farkı / taban
     farkı / belirsiz) hiçbir kaynakta yok. `GEREKÇELİ`: mutabakat pratiğinde fark
     SEBEPLERİ raporun kendisidir; sebepsiz FARK toplamı yalnız "tutmuyor" der, "neden
     tutmuyor"u KAM'ın kafasında bırakır.
- **SİSTEM NE SÖYLER:** 🔇 **SESSİZLİK:** tolerans dışına düşen fark için sistemin KAM'a ne
  söylediği tanımsız. Asgari beklenti (`GEREKÇELİ`): hangi eşiğin bağladığı (oran mı mutlak
  mı), farkın yönü (karşı taraf FAZLA mı kesmiş), ve iç talebin kanıt dökümü (hangi hacim,
  hangi oran, hangi taban). Üçü de yazılı değil. L0'ın kenar AI vaadi ("bu rakam neden
  böyle sorusuna denetim izinden cevap veren açıklama katmanı" — `ÖLÇÜLDÜ`, L0 §5) tam bu
  boşluğa işaret ediyor — ama vaat, tanım değil.

### Finans Müdürü gözünden

- **GÖRÜR:** defterde ne? Araştırma sürerken FARK kalemi yazılmadıysa defter 412.000 mü
  468.500 mü gösteriyor? ⛔ **BOŞLUK BULGUSU 10:** araştırma süresince defter durumu
  tanımsız — ve bu finans için "tutar askıda" demek. Ay kapanışı araştırmayı beklemez
  (`GEREKÇELİ`).
- **TAKILIR:** FARK kalemi yazıldığında hangi bütçeden düşer? Açıklanamayan kalıntı hiçbir
  taktiğe dağıtılmaz (`ÖLÇÜLDÜ`) — taktiğe gitmiyorsa zarf/bütçe ataması nereye?
  ⛔ **BOŞLUK BULGUSU 11:** FARK kaleminin bütçe atfı (hangi zarf, hangi kategori, kimin
  P&L'i) tanımsız. Kategori Müdürü açısından da kritik: FARK kendi kategorisine yazılırsa
  ROI'si sebepsiz bozulur, yazılmazsa fark kimsenin sorumluluğunda değildir — iki uç da
  davranış üretir ve kaynak seçim yapmıyor.

---

# Senaryo 4 · Karşı taraf itiraz etti

**Çıkmaz:** Mutabakat tek turlu değil — karşı taraf cevap verir. Kaynaklarda karşı taraf
perspektifi `❌` ve itiraz diye bir kavram hiç yok.

**Olay:** Senaryo 3'ün devamı. KAM, Ege Dağıtım'a 49.000 TL'lik kısmı reddettiğimizi
bildirir (e-posta + ekli hacim dökümü — sistem dışı, `GEREKÇELİ`). Ege Dağıtım **itiraz
eder**: kendi sözleşme okumasına göre iade düşülmez, sevk edilen hacim esastır; revize
talep göndermez, mevcut talebinde ısrar eder. Bu arada parayı zaten almış durumda —
distribütör hakedişi cari hesabından mahsup etmiş (`GEREKÇELİ` — TR pratiğinde kesinti
fiilen önce gerçekleşir; itiraz kaybedilirse iade dekontu/mahsup düzeltmesi yapılır).

### KAM gözünden

- **GÖRÜR:** sistemde hâlâ aynı görüntü — "fark: 56.500". İtirazın kendisi sistemde temsil
  edilemiyor.
- **YAPAR:** yazışmayı e-postada yürütür, sözleşme maddesini hukuka sorar, belki ticari
  jestle 25.000'de anlaşır (`GEREKÇELİ` — mutabakat müzakereyle biter, hesapla değil).
- **TAKILIR:** ⛔ **BOŞLUK BULGUSU 12:** itiraz/müzakere yaşam döngüsü hiçbir kaynakta yok.
  Somut olarak tanımsız olanlar: (a) dış talebin bir "itiraz edildi / müzakerede /
  anlaşıldı" durumu, (b) karşı taraf yazışmasının/kanıtının talebe iliştirilmesi, (c)
  **anlaşılan tutarın** kaydı — 25.000'de anlaşıldıysa bu ne iç talebin ne dış talebin
  tutarı; üçüncü bir "mutabık tutar" kavramı gerekir ve kaynaklarda yok, (d) dış talebin
  **revizyonu** — karşı taraf revize dekont gönderirse eski talep silinir mi, sürümlenir
  mi? L1 durum tablosu "Karşı taraf perspektifi ❌" diyor (`ÖLÇÜLDÜ`) — yani boşluk
  biliniyor; L2'nin buna kural yazıp yazmadığı bu senaryonun ana ölçüm sorusu.
- **SİSTEM NE SÖYLER:** 🔇 **SESSİZLİK — tam.** İtiraz süreci boyunca sistemin söyleyecek
  hiçbir şeyi yok, çünkü süreci gören hiçbir varlığı yok. Sonuç (`GEREKÇELİ`): mutabakatın
  asıl zor yarısı — müzakere — Excel'e ve e-postaya kaçar, ve L0'ın "kapalı döngü tek
  üründe" iddiası (`ÖLÇÜLDÜ`, L0 §5) tam bu noktada kırılır.

### Finans Müdürü gözünden

- **GÖRÜR:** cari hesapta 468.500 kesilmiş; defterimiz (hangi tutarı taşıyorsa onu)
  gösteriyor. İtiraz kazanılırsa 43.500'ün iadesi/mahsubu gelecek — bu bir **alacak
  beklentisi** ve sistemde temsili yok.
- **TAKILIR:** ⛔ **BOŞLUK BULGUSU 13:** itiraz sonucu doğan düzeltme hareketi (karşı
  taraftan iade dekontu / ters kayıt) için bir talep türü ya da negatif talep kavramı
  tanımsız. Muhasebe kaydı ERP'de oluşur, biz denetim düzeyinde izlenebilirlik veririz
  (`ÖLÇÜLDÜ`, L0 §2.1) — ama izlenebilirlik tam da "hangi kesinti hangi itirazla hangi
  iadeye bağlandı" zinciridir; zincirin son halkası modelde yok.

### Kategori Müdürü gözünden

- **GÖRÜR:** taktiğinin gerçekleşmesi kanıttan 412.000 (`ÖLÇÜLDÜ` — gerçekleşme dış
  talepten türetilmez). İtiraz süreci onun gerçekleşme rakamını değiştirmez — model burada
  doğru ayrışıyor (`GEREKÇELİ` değerlendirme: bu, kanıt-temelli modelin güçlü yanı).
- **TAKILIR:** ama dönem raporunda "bu taktiğin karşı tarafla mutabakatı açık" bilgisini
  görmüyorsa, kapanmış sandığı bir dönem aylar sonra düzeltme yer (Senaryo 5'e bağlanır).

---

# Senaryo 5 · Dönem kapandı — sonra belge geldi

**Çıkmaz:** Kapanışta kalan bakiye serbest bırakılır ve yeni döneme taşınmaz. Peki
kapanıştan SONRA gelen kesinti neye çarpar?

**Olay:** Aslan Gıda Q2 dönem kapanışını 15 Temmuz'da yapar (dönem kapanışı bugün `❌` —
`ÖLÇÜLDÜ`, L1 §1.7 durum tablosu; senaryo hedef davranışı sınıyor). Kapanışta kalan bakiye
serbest bırakılır, yeni döneme taşınmaz (`ÖLÇÜLDÜ`, L1 §1.7 "Kapanışta kalan bakiye
serbest bırakılır, yeni döneme taşınmaz" — K-2.2.9r atfı). Finans, tahakkuk raporunu
ERP'ye vermiş, muhasebe yevmiye kaydını o rapordan atmış (`ÖLÇÜLDÜ`, L1 §1.7 "Sistem bir
tahakkuk raporu verir; yevmiye kaydını muhasebe o rapordan atar" — K-2.13.25e atfı).

**28 Ağustos'ta** Yıldız Market, Haziran ayına ait 150.000 TL'lik insert bedelini keser.
Gecikme normaldir — TR'de aktivite kesintileri 30–90 gün gecikebilir (`GEREKÇELİ` — zincir
perakende muhasebe döngüsü; bu yüzden "geç belge" bir istisna değil, **beklenen akıştır**).

### Finans Müdürü gözünden

- **GÖRÜR:** Ağustos cari ekstresinde Haziran dönemli bir kesinti.
- **YAPAR:** dış talep olarak girer. Dönem alanına Haziran yazar — dönem kapalı.
- **TAKILIR — zincirleme:**
  1. ⛔ **BOŞLUK BULGUSU 14:** kapalı döneme dış talep girişinin davranışı tanımsız.
     Seçenekler zıt sonuçlu: (a) giriş engellenir → belge sisteme hiç giremez, mutabakat
     dışarıda yapılır — settlement-first ürün için ölümcül; (b) girilir ama eşleşemez →
     kuyruğa düşer ve sonsuza dek orada kalır; (c) dönem yeniden açılır → yeniden açma
     yetkisi/izi tanımsız; (d) cari döneme yazılır → dönem bütünlüğü bozulur. Kaynak iki
     kapanışı ayırır (anlaşma ↔ dönem — `ÖLÇÜLDÜ`, L1 §1.7 "İki kapanış vardır ve
     karıştırılmaz") ama kapanış-sonrası olay akışını yazmaz.
  2. **Bütçe çarpışması.** Q2 bütçe bakiyesi kapanışta serbest bırakıldı (`ÖLÇÜLDÜ`) —
     ve muhtemelen Q3 planlarına konu oldu. Geç kesinti şimdi hangi bütçeden düşer?
     ⛔ **BOŞLUK BULGUSU 15:** serbest bırakılmış bütçeye sonradan gelen yükümlülüğün
     kaynağı tanımsız. `GEREKÇELİ`: serbest bırakma kuralı geç-belge gerçeğiyle birlikte
     okununca "erken kapatan, geç gelen belgenin bütçesini kaybeder" sonucu doğar — bu ya
     bilinçli bir tasarım kararıdır (kapanışı geciktir sinyali verir) ya da gözden kaçmış
     bir çelişkidir; L2 hangisi olduğunu söylemeli.
  3. **Tahakkuk uyuşmazlığı.** Haziran tahakkuk raporunda bu insert bedeli var mıydı?
     Varsa (sözleşmesel sınıf — koşul sağlandıysa tamamı doğar, `ÖLÇÜLDÜ`) muhasebe zaten
     karşılık ayırdı ve geç kesinti tahakkuku kapatır — iyi akış. Yoksa muhasebe Ağustos'ta
     Haziran gideri yer. 🔇 **SESSİZLİK:** sistemin "geç gelen dış talep ↔ verilmiş tahakkuk
     raporu" karşılaştırmasını yapıp finansa "bu kalem Haziran tahakkukunda VARDI/YOKTU"
     demesi hiçbir kaynakta tanımlı değil — oysa operasyonel tahakkukun ("karşı taraf dönem
     sonunda ne kesecek?" sorusunun sahibi biziz — `ÖLÇÜLDÜ`, L1 §1.7 tahakkuk tablosu) tek
     sınanma anı tam burasıdır: tahakkuk isabet raporu.

### KAM gözünden

- **GÖRÜR:** kapalı sandığı Q2'den yeni bir kalem. Yıldız Market'le Q2 mutabakatını
  "bitti" diye raporlamıştı.
- **TAKILIR:** "dönemi kapattık ama karşı tarafın 90 günü var" gerçeğiyle sistemin dönem
  kapanışı kavramı çelişiyor. `GEREKÇELİ` beklenti: kapanışın "karşı taraf penceresi
  kapanmadan dönem kapatılamaz" ya da "kapanış + geç-belge istisna akışı" şeklinde
  tanımlanması gerekir; ikisi de kaynaklarda yok.

---

# Senaryo 6 (ek) · İç talep hiç doğmadı — hacimsiz veri, boş aday kümesi

**Çıkmaz:** Eşleştirmenin sınadığı şey iki tarafın varlığı — ama zincirin başı (talep
üretimi) veri eksikliğinden hiç çalışmamışsa, dış talep "hiçbirine denk düşmeyen" sınıfa
düşer ve kök neden eşleştirmede değil, iki adım geridedir.

**Olay:** Ege Dağıtım'la birim başı destek anlaşması var (türetilebilir sınıf: oran ×
gerçekleşen hacim — `ÖLÇÜLDÜ`). Temmuz gerçekleşen satış verisi sisteme **eski/ikincil
biçimde** yüklenmiş: `category,channel_code` başlıklı, **hacimsiz** CSV — bu biçim gerçek
ve ölçülmüş: TTM'deki 22 actuals CSV'sinin 4'ü tam bu şekilde, kanonik biçim ise
`cpl_code,fu_code,gross_amount,net_amount,discount_amount,volume` (`ÖLÇÜLDÜ`,
0070 §B1 sayım tablosu). Hacim yoksa oran × hacim hesaplanamaz → iç talep doğmaz.
Eksik veri akışı durdurmaz, görünür olur; hesaplanamayan `null` döner, sıfır değil
(`ÖLÇÜLDÜ`, L0 İlke 2).

**15 Ağustos'ta** Ege Dağıtım 87.400 TL'lik destek hakedişini, hacim kırılımlı düzgün bir
Excel'le talep eder (`GEREKÇELİ` — distribütörler kırılımı verir; kırılımsız olan zincir
perakendedir).

### Kategori Müdürü gözünden

- **GÖRÜR:** Temmuz plan-gerçekleşen ekranında destek taktiği `null`/gri (`ÖLÇÜLDÜ`, L0
  İlke 2 — "renk verilmez, yeşil verilmez; ve sebebi kullanıcıya söylenir").
- **TAKILIR:** "sebebi söylenir" ilkesi burada iki katmanlı: gösterge için söyleniyor
  (ilke motor katmanında doğru uygulanıyor — `ÖLÇÜLDÜ`, L0 İlke 2 uygulaması notu). Ama
  ⛔ **BOŞLUK BULGUSU 16:** "bu veri eksikliği yüzünden İÇ TALEP ÜRETİLEMEDİ" uyarısı —
  yani eksikliğin gösterge katmanından **hakediş zinciri katmanına** taşınması — hiçbir
  kaynakta tanımlı değil. Gösterge grisi pasif bir bilgidir; üretilemeyen talep ise
  gelecekteki bir mutabakat kazasıdır ve proaktif uyarı ister.

### Finans Müdürü / KAM gözünden

- **GÖRÜR (FM):** dış talebi girer. Kademe 1: referans yok (Ege Dağıtım anlaşma numarasını
  yazmış olabilir — o zaman kademe 1 çalışır ama hedef İÇ TALEP yine yok). Kademe 2: aday
  kümesi **boş** — çünkü eşleşecek iç talep hiç doğmadı. Kuyruğa düşer (`ÖLÇÜLDÜ`, L1
  §1.7 — "eşleşmeyen → kuyruk"; ve "bir dış kesinti … hiçbirine denk düşmeyebilir").
- **TAKILIR:** kuyruk kalemi "aday yok" diyor. Ama **neden** aday yok? İki çok farklı kök
  neden aynı görüntüyü verir: (a) karşı taraf haksız/mükerrer talep gönderdi — ret
  adayı; (b) bizim veri eksiğimiz iç talebi üretmedi — bizim hatamız, talep büyük olasılıkla
  haklı. ⛔ **BOŞLUK BULGUSU 17:** kuyruğun bu iki durumu ayırt etmesi (ör. "bu
  müşteri+dönem+mekanik için anlaşma VAR ama iç talep üretilemedi — kök neden: hacim verisi
  eksik") tanımsız. 🔇 **SESSİZLİK:** sistem burada tamamen sessiz kalırsa, KAM haklı bir
  distribütör talebini "kayıtlarımızda yok" diye reddeder — ilişki maliyeti gerçek paradan
  büyük olabilir (`GEREKÇELİ`).
- **Devamı:** hacim verisi düzeltilip yüklendiğinde iç talep doğar. Kuyruktaki dış talep
  **otomatik yeniden eşleştirilir mi**, yoksa kuyruk tek geçişlik mi? ⛔ **BOŞLUK
  BULGUSU 18:** yeniden eşleştirme tetikleyicisi (yeni iç talep doğduğunda kuyruğun
  yeniden taranması) tanımsız.

---

# Boşluk bulguları — toplu tablo

Ölçüm turu için tek bakışta: her satır, L2 2.13'te karşılığı aranacak bir sorudur.

| # | Boşluk | Senaryo | Sınıf |
|---|---|---|---|
| 1 | Dış talep tutarının KDV bileşeni (dahil/hariç alanı, arındırma sorumluluğu) | S1 | veri modeli |
| 2 | Dönem granülerlik uyuşmazlığı (çeyreklik dış ↔ aylık iç) eşleştirme davranışı | S1 | eşleştirme |
| 3 | Kademe 2 anahtarı dış talepte boşken davranış (joker mi, engel mi) | S1 | eşleştirme |
| 4 | Kuyruğun sahibi, işleme yükümlülüğü, yaşlanma/eskalasyon | S1 | süreç/rol |
| 5 | Çoklu bağda (1 dış → N iç) tutar ataması | S2 | eşleştirme |
| 6 | Elle kesinleştirme yetkisi / ikinci göz kontrolü | S2 | süreç/rol |
| 7 | "Gerçekleşti ama doğrulanmadı" ara durumunun görünürlüğü | S2 | görünürlük |
| 8 | Tolerans DIŞI farkın durum makinesi (araştırma, blok, karar sahibi) | S3 | mutabakat |
| 9 | Kısmi kabul/ret + fark sebep sınıflandırması | S3 | mutabakat |
| 10 | Araştırma süresince defter durumu | S3 | defter |
| 11 | FARK kaleminin bütçe/zarf/P&L atfı | S3 | defter/bütçe |
| 12 | İtiraz/müzakere yaşam döngüsü; "mutabık tutar" kavramı; dış talep revizyonu | S4 | mutabakat |
| 13 | İtiraz sonucu düzeltme hareketi (iade dekontu / ters kayıt) temsili | S4 | veri modeli |
| 14 | Kapalı döneme dış talep girişi davranışı (engel/kuyruk/yeniden açma/cari dönem) | S5 | kapanış |
| 15 | Serbest bırakılmış bütçeye sonradan gelen yükümlülüğün kaynağı | S5 | kapanış/bütçe |
| 16 | Veri eksikliğinin "iç talep üretilemedi" olarak zincir katmanına taşınması | S6 | görünürlük |
| 17 | Boş aday kümesinin kök neden ayrımı (haksız talep ↔ bizim veri eksiğimiz) | S6 | eşleştirme |
| 18 | Yeni iç talep doğduğunda kuyruğun yeniden taranması | S6 | eşleştirme |

**Sessizlik noktaları (🔇) ayrıca:** kuyruğa düşme kök nedeni (S1) · KAM'a yeni-dış-talep
bildirimi (S1) · kuyruk ekranında aday-toplamı/kesinti farkı (S2) · tolerans dışı farkta
açıklayıcı mesaj (S3) · itiraz süreci boyunca tam sessizlik (S4) · tahakkuk isabet
karşılaştırması (S5) · boş aday kümesinde kök neden (S6).

> Not: 18 boşluğun bir kısmı L2 2.13'te pekâlâ tanımlı olabilir — bu setin işi "yok" demek
> değil, **L2'ye sorulacak soruları L2'yi okumadan üretmek**ti. Tanımlı çıkan her boşluk
> setin başarısıdır (kural sınandı ve bulundu); tanımsız çıkan her boşluk ürün boşluğudur.
