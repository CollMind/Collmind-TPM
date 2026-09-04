# CollMind TPM — Danışman Paketi v1 (TASLAK)

**Amaç:** Bu doküman, CollMind TPM ürününün ticari promosyon yönetimi (TPM) süreçlerini sektörel bir gözle değerlendirmek üzere hazırlanmıştır. Sizden beklediğimiz üç şey: (1) Bölüm 1'deki mevcut akışlarımızın sektör pratiğiyle uyumunu doğrulamanız, (2) Bölüm 2'deki kararlarımızı "biz böyle seçtik — sektör ne yapar?" sorusuyla değerlendirmeniz, (3) Bölüm 3'teki henüz karar vermediğimiz konularda en iyi pratikleri paylaşmanız.

**Okuma sırası önerisi:** Bölüm 0 (2 sayfa, bağlam) → Bölüm 3 (sorular — asıl beklentimiz) → Bölüm 2 (kararlar, soruya göre atlayarak) → Bölüm 1 (akışlar, gerektiğinde). Sözlük (EK) ortak dil içindir.

**Tarih:** Eylül 2026 · **Durum:** taslak — Bölüm 1 akış ölçümleri ve ekran görüntüleri eklendi (2026-09-03, `docs/domain/screenshots/`, 68 görsel, dört rol)

---

## BÖLÜM 0 · ÜRÜN ÖZETİ

### Ne yapıyor?
CollMind TPM, FMCG/kozmetik üreticilerinin perakende müşterileriyle yaptıkları ticari anlaşmaları ve promosyonları **planlamadan hakedişe kadar tek bir akışta** yöneten bir yazılımdır. Müşteri ile anlaşılan indirimler, ürün başına destekler, görünürlük ödemeleri gibi harcamaların (a) planlanması, (b) bütçeyle ilişkilendirilmesi, (c) gerçekleşen satışlara göre hakedişe dönüştürülmesi ve (d) değiştirilemez bir defterde izlenmesi bu yazılımın işidir.

### Temel ilke: Actuals-First (gerçekleşme önce)
Plan bir niyettir; hakediş gerçekleşmeden doğar. Sistem, planlanan tutarı bütçeden *rezerve eder*, ancak ödemeyi hak eden tutarı yalnız gerçekleşen satış verisi belirler. Plan ile gerçekleşme arasındaki fark her zaman görünürdür, asla planla kapatılmaz.

### Tek akış — beş halka
```
1 ANLAŞMA / PLAN   →  2 GERÇEKLEŞME  →  3 EŞLEŞTİRME  →  4 HAKEDİŞ / SETTLEMENT  →  5 DEFTER
   (niyet + bütçe        (satış verisi     (gerçekleşme →     (hak edilen tutar,        (silinmez kayıt:
    rezervasyonu)          yüklenir)         plana bağlanır)     onay, kapanış)             rezerve/tüket/serbest)
```
Halka 1 bugün tamamlanmış durumda; halka 2 ve 4 kısmen; halka 3 (otomatik eşleştirme) tasarım aşamasında. Bölüm 1 her halkanın bugünkü gerçek halini gösterir.

### Kimler kullanıyor?
- **Planner (Satış planlayıcı):** kendi müşteri-planlama-birimi (CPL) için promosyon planı yapar, mekanik/indirim girer, onaya gönderir.
- **Kategori Yöneticisi (CM):** planları kârlılık/ciro açısından değerlendirir, onaylar veya geri gönderir.
- **Finans:** bütçe zarflarını tanımlar, referans verileri (baseline) yükler, hakedişleri kapatır, riskli planları izler.
- **Admin:** ürün/müşteri ana verisi, KPI formülleri, mekanik tanımları.

### Neyi bilerek yapmıyoruz (bugün)?
Forecasting/optimizasyon, what-if simülasyonu, çok-şirketli konsolidasyon, fatura-bazlı otomatik eşleştirme. Bunların bir kısmı Bölüm 3'te soru olarak yer alıyor.

---

## BÖLÜM 1 · AKIŞ DOĞRULAMASI

> **Ölçüm tarihi:** 2026-09-03 · Aşağıdaki her halka bu tarihte canlı sistemde (Planner/Kategori
> Yöneticisi/Finans rolleriyle bizzat) çalıştırılarak doğrulandı — bir kod okuması değil, gerçek bir
> plan açılıp onaylanarak yapılan bir tatbikattır. Teknik detay, dosya/satır referansları, SQL
> sorguları ve diyagramlar için: `docs/domain/BOLUM1_AKIS_DOGRULAMASI_TASLAK.md`. **Ekran görüntüleri
> henüz eklenemedi** (araç kısıtı) — akışın kendisi ölçüldü, görsel kanıt bir sonraki turda eklenecek.

### 1.1 Plan halkası — Planner'ın günlük akışı (omurga) — ✅ ölçüldü, uçtan uca çalıştı
Kanal + CPL + kategori seçilir, dönem (başlangıç/bitiş) girilir → o kategorinin ürün grupları (FU) ve
SKU'ları listelenir (kategori×CPL kombinasyonuna göre FU listesi **boş da çıkabiliyor** — veriye bağımlı)
→ SKU'larda hacim, FU'larda mekanik/indirim girilir → KPI'lar (ciro, NIV, kâr, ROI, RAG) her değişiklikte
anında yeniden hesaplanır, formüller sabit kod değil ana veriden okunuyor → plan onaya gönderilir; eksik
veri (mekanik girilmemiş, hacim eksik, baseline yok) **uyarı olarak görünür, gönderimi engellemez** →
onaya giden plan, **kategorisi kendi yetki alanında olan** bir Kategori Yöneticisi'nin kuyruğuna düşer →
onay anında sistem ilgili kanal/dönem için uygun bir bütçe zarfı arar ve tutarını gösterir → onaylanınca
bütçe commit edilir.

*Sektör sorusu:* Bu sıra (adet önce, indirim sonra) ve FU-düzeyi giriş + SKU istisnası yaklaşımı sizin
gördüğünüz uygulamalarla uyumlu mu? *(Ek gözlem — cevap beklemiyor, bilginize:* onaylanmış bir planın
yürütmeye girdikten sonra geri alınıp alınamayacağı konusunda bizim iki modülümüz [Plan ve Anlaşma]
bugün birbirinden farklı davranıyor; bu iç tutarlılık sorusu Bölüm 3 Soru 10 ile birlikte ele alınacak.)*

### 1.2 Gerçekleşme halkası — ✅ ölçüldü, kısmen canlı
Üç yükleme yolu var: **fatura-dışı tekil kayıt** ve **fatura-içi (on-invoice) toplu yükleme** gerçekten
çalışıyor ve uçtan uca test edilmiş durumda. **Fatura-dışı toplu dosya yükleme** kodu yazılmış ama
uçtan uca sınanmamış. **Satış hacmi (sales actuals) yükleme** yolu çalışıyor ve veriyi doğru şekilde
kaydediyor, ama bugün **hiçbir hesaplamayı beslemiyor** — yüklenen veri KPI'lara, ROI'ye ya da başka
hiçbir ekrana yansımıyor (izole bir bacak).

*Sektör sorusu:* Gerçekleşen satış hacmi verisi sektörde genelde ROI/uplift hesabını doğrudan besler;
bizde bu veri kanalının tamamen ayrı tutulması bilinçli bir sıralama kararı mı, yoksa sizin
gözlemlediğiniz uygulamalarda bu iki veri kaynağı (fatura-dışı indirim vs. gerçekleşen satış) hiç mi
ayrı yönetilmiyor?

### 1.3 Eşleştirme halkası — ✅ ölçüldü, kısmen var (Bölüm 1 taslağında ilk yazımdan daha ayrıntılı)
**Fatura-dışı** tarafta gerçekten yok: kullanıcı ilgili anlaşmayı dosyada elle işaretliyor, otomatik bir
bağlama yok. **Fatura-içi** tarafta ise gerçek bir otomatik eşleştirme **var** — ama hedefi bir anlaşma
değil, **kanal × dönem × kategori** boyutlarıyla bulunan bir **bütçe zarfı**. Yani "eşleştirme yok" hükmü
yalnız anlaşma-eşleştirmesi için doğru; zarf-eşleştirmesi bugün zaten çalışıyor.

*Sektör sorusu:* Fatura-içi kaydın doğrudan bir bütçe zarfına (anlaşmaya değil) otomatik bağlanması
sektörde tanıdık bir tasarım mı, yoksa çoğu sistem fatura-içi kaydı da doğrudan bir anlaşmaya mı bağlıyor?

### 1.4 Hakediş / settlement / claim halkası — 🟠 yarısı ölçüldü
Anlaşma kapatma (settlement) canlı ve iyi test edilmiş: bütçenin doğru tutarda serbest bırakıldığı
somut örneklerle doğrulandı. **Ayrı bir "claim" (hakediş talebi) süreci ise bugün yalnızca veri modelinde
var, hiçbir ekran veya kural onu üretmiyor/tüketmiyor.** Not: bugün panolarda "Claim" başlıklı bölümler
görülebilir — bunlar gerçekte anlaşma tablosunun farklı bir görünümüdür, ayrı bir hakediş-talebi kaydına
karşılık gelmez; bu isimlendirme netleştirilecek (iç görev olarak kayıtlı, danışman girdisi gerekmiyor).

*Sektör sorusu:* Karşı tarafın (perakendeci) gönderdiği bir dış hakediş talebi — bugün şemamızda bir
kavram olarak var ama işlenmiyor — sektörde genelde nasıl bir kanaldan gelir (e-posta, portal, EDI) ve
bunu ileri bir faza ertelemek makul mü?

### 1.5 Defter halkası — ✅ ölçüldü, çekirdek sağlam / bir isimlendirme netleşecek
Her bütçe hareketi eklemeli bir deftere yazılıyor; silme yok, düzeltme ters kayıtla yapılıyor — bu ilke
canlı sistemde otomatik testlerle korunuyor. Rezervasyon (tahsis edilen tutar) ile gerçek tüketim bugün
**iki farklı iç mekanizmayla** izleniyor; ekranlarda kullanılan "rezerve edildi / tüketildi" sözcükleri
bu iki mekanizmayı birleştiren bir sunum katmanıdır — teknik olarak netleştirilmesi gereken bir
iç isimlendirme konusu (danışman girdisi gerekmiyor, iç görev olarak kayıtlı).

### 1.6 Statü yaşam döngüsü — bizim akış ↔ referans şema — ✅ ölçüldü
Canlı statüler: Taslak → Onay Bekliyor → (Onaylandı | Reddedildi) ve Reddedilenden Taslağa dönüş.
Referans aldığımız demo sistemin şeması: Taslak → Planlandı → Onaya gönderildi → Onaylandı → (otomatik)
Devam ediyor → (otomatik) Tamamlandı; yan çıkışlar: İptal, Eksik, Red. Ölçümde doğrulanan farklar Bölüm
3 Soru 10'dakilere ek olarak: **(a)** onaylanmış bir kaydın geri alınabilirliği plan ve anlaşma
modüllerimizde farklı (biri kapalı kapı, diğeri açık) — bu iç tutarsızlık ayrı ele alınacak; **(b)**
"Finans incelemesine" giden bir planın bugün onu görüntüleyecek bir ekranı yok — bu bir ürün-sorusu değil,
bizim tamamlamamız gereken bir iş (kayıtlı). Detaylı geçiş tablosu: taslak belgede.

---

## BÖLÜM 2 · KARAR VERDİK — DOĞRULATMAK İSTİYORUZ

Her karar için: **Seçtiğimiz · Neden · Alternatif · Size sorumuz.**

### K1 · Tek akış: plan → gerçekleşme → eşleştirme → hakediş → defter
**Seçtiğimiz:** Plan bütçeyi rezerve eder; ödemeyi hak eden tutarı yalnız gerçekleşme belirler. Fatura-içi (on-invoice) indirim fatura üzerinde basılıdır — gerçekleşmeyle birlikte ödenmiş sayılır, ayrı hakediş süreci yoktur. Hakediş süreci fatura-dışı (off-invoice) ödemeler içindir: görünürlük, birim destek, lumpsum, dönem-sonu iskontolar.
**Neden:** Plan bir niyettir; ödeme gerçekleşmeden doğar. Plan ile gerçekleşme farkı her zaman görünür kalır.
**Alternatif:** Fatura-dışı ödemenin planlanan tutar üzerinden yapılıp sonradan düzeltilmesi.
**Soru (yalnız fatura-dışı için):** Sektörde fatura-dışı ödemeler "plan tutarı ödenir, sonra düzeltilir" mi, "gerçekleşme gelmeden ödenmez" mi? Hangi ödeme türünde (görünürlük vs dönem-sonu iskonto) hangisi baskın?

### K2 · RAG rengi iki eksenli "yön", hedef-ROI ayrı "büyüklük"
**Seçtiğimiz:** RAG (kırmızı/sarı/yeşil) yalnız iki soruya bakar: satış arttı mı (artan ciro > 0) ve kâr etti mi (artan brüt kâr > 0). Kırmızı: satış artmadı; Sarı: satış arttı ama kâr negatif ("kârsız büyüme"); Yeşil: ikisi de pozitif. "Ne kadar kârlı" sorusu ayrı bir eksende: müşterinin belirlediği hedef-ROI'nin altında kalan planlar yeşil olsa da "hedefin altında" uyarısı alır.
**Neden:** Eski tek-eşikli model "zarar eden plan" ile "az kârlı plan"ı aynı renge boyuyordu; "satıyor ama zarar ediyor" durumu (kategori yöneticisinin en çok görmesi gereken durum) hiç görünmüyordu.
**Alternatif:** ROI aralıklarına göre üç renk (0-10 kırmızı, 10-20 sarı, 20+ yeşil).
**Soru:** Kategori yöneticileri promosyon değerlendirmesinde "yön" ile "büyüklüğü" ayrı mı okur, yoksa tek bir ROI eşiği yeterli mi görülür? Hedef-ROI'yi kim belirler (finans mı, kategori mi)?

### K3 · ROI paydası: yalnız promosyon harcaması (uzun dönem anlaşma harcaması hariç), artan tutar
**Seçtiğimiz:** ROI = artan ciro (veya artan kâr) / artan promosyon harcaması. Uzun dönemli anlaşma (LTA) indirimleri paydaya girmez — bütçe rezervasyonu ise toplam harcamayı (LTA dahil) kullanır; iki kalem ayrıştırıldı.
**Neden:** Tek kalem hem bütçe hem ROI'yi beslerse iki eksen (LTA dahil mi / toplam mı artan mı) tek sayıya sıkışır; ayrıştırdık.
**Alternatif:** Toplam ticari harcama (LTA dahil) paydada.
**Soru:** ROI paydası sektörde nasıl tanımlanır — promosyona özgü artan harcama mı, toplam trade spend mi? Bunu müşteriye göre değiştirilebilir bir ayar yapmak doğru mu?

### K4 · Ciro (Turnover) ile NIV ayrımı; kâr = ciro − maliyet
**Seçtiğimiz:** NIV = brüt satış − fatura-içi indirimler; Ciro = brüt satış − (fatura-içi + fatura-dışı) tüm harcamalar; Brüt kâr = Ciro − ürün maliyeti. Yani fatura-dışı ödemeler (görünürlük, birim destek, lumpsum) kâr hesabına girer.
**Neden:** Bu tanım fatura-dışı harcamayı kârdan düşer; düşülmezse ROI yapısal olarak iyimser çıkar.
**Soru:** Kâr hesabında fatura-dışı ödemelerin düşülmesi sektör standardı mı? NIV'in ayrı bir KPI olarak raporlanması gerekli mi?

### K5 · Mekanik hesap tabanları
**Seçtiğimiz:** Fatura-içi yüzde mekanikleri (brüt satış − LTA fatura-içi indirimi) üzerinden; fatura-dışı yüzde mekanikleri NIV üzerinden; birim-başı destek (adet × tutar) sell-out hacmi üzerinden; lumpsum doğrudan tutar.
**Neden:** LTA oranı promosyon mekaniklerinin tabanını değiştirir (üst üste indirim zinciri); taban tek yerde tanımlı olmalı.
**Soru:** Fatura-dışı yüzde mekaniklerinin tabanı olarak NIV (yalnız fatura-içi düşülmüş) kullanımı yaygın mı? Birim-başı desteğin sell-in mi sell-out mu hacimle hesaplanması standart?

### K6 · Baseline merkezi referans veridir: Finans/Admin yükler, Planner okur
**Seçtiğimiz:** Baseline (promosyonsuz beklenen hacim) SKU × CPL × ay grain'inde, adet cinsinden, merkezi olarak yüklenir. Planner kendi baseline'ını giremez.
**Neden:** Görev ayrılığı — baseline planın ölçüldüğü referans; planner'ın kendi referansını belirlemesi düşük-baseline/yüksek-uplift manipülasyonuna açık.
**Alternatif:** Planner kendi CPL'i için baseline girer/düzeltir.
**Soru:** Sektörde baseline'ı kim sahiplenir ve nasıl üretilir (geçmiş satış ortalaması, forecast, distribütör verisi)? Planner'ın düzeltme önerisi + finans onayı modeli görülüyor mu?

### K7 · Baseline yokken de planlama yapılabilir
**Seçtiğimiz:** Baseline eksik olan satırlarda artış/ROI/RAG "değerlendirilemedi" olarak görünür (sıfır veya uydurma değer yazılmaz); plan yine de yapılır, onaylanır, bütçe rezerve eder, hakedişe gider. Baseline'ı sıfır olan yeni ürün ise geçerli sıfırdır — tüm hacim artış sayılır.
**Neden:** Baseline verisi olmayan firmalar vardır; ürün baseline'sız da tam çalışmalıdır — yalnız "ne kadar artırdım" sorusu verisiz cevaplanamaz.
**Soru:** Baseline verisi olmayan firmalarda promosyon değerlendirmesi pratikte nasıl yapılıyor? Yeni ürün lansmanında "baseline = 0" kabulü yaygın mı?

### K8 · Baseline kapsama kapısı (%95) bir bilgi göstergesidir, blok değil
**Seçtiğimiz:** Aktif SKU × aktif CPL × 12 ay evreninin %95'inde baseline varsa "yeşil"; altında "kırmızı" ve eksiklerin teşhis listesi. Kırmızı hiçbir işlemi durdurmaz. Yüklemede hatalı satırlar tek tek reddedilir (kısmi kabul), kabul edilenler girer; reddedilen satırlar eksik sayılır.
**Soru:** Kapsama eşiği olarak %95 makul mü? Satır-bazlı kısmi kabul mü, dosya-bazlı tümden kabul/red mi tercih edilir?

### K9 · Mekanik değeri FU düzeyinde girilir, SKU'da ezilebilir
**Seçtiğimiz:** Planner oranı forecasting-unit'e (ürün grubu) girer; tüm SKU'lar bunu alır; gerekirse tek bir SKU'da farklı değer verilir.
**Neden:** Ürün grubu düzeyinde giriş hızlıdır; müzakereler bazen tek SKU'da farklılaşır — ikisi tek modelde.
**Soru:** Pratikte mekanik oranları ürün grubu düzeyinde mi, SKU düzeyinde mi müzakere edilir? SKU istisnası ne sıklıkla gerekir?

### K10 · Taktik uygunluğu: CPL tanımı → kanal tanımı → kısıtsız
**Seçtiğimiz:** Hangi taktiğin hangi müşteri-planlama-biriminde (CPL) geçerli olduğu ana veride tanımlanır; CPL'de tanım varsa yalnız o geçerli (kanala düşülmez), yoksa kanal tanımı, o da yoksa her yerde geçerli. Uygun olmayan taktik planlama ekranında hiç görünmez.
**Neden:** Planlama birimi müşteri sayısı değildir — küçük bakkallar tek CPL, büyük zincir tek CPL olabilir; kanal-bazlı ilerleyen firmalar için kanal katmanı varsayılan, CPL istisna.
**Soru:** Taktik uygunluğu sektörde müşteri-bazlı mı, kanal-bazlı mı tanımlanır? Uygun olmayanın "görünmemesi" mi, "kilitli görünmesi" mi tercih edilir?

### K11 · Taktik/mekanik modeli: taktikler ana veridir, hesap aileleri sabittir
**Seçtiğimiz:** İki katman. **Mekanik aileleri** sistemin hesap motorudur ve sabittir: fatura-içi yüzde · fatura-dışı yüzde · birim-başı destek · lumpsum · uzun-dönem anlaşma (+ hesap tipi: yüzde-oran / birim-başı / götürü). **Taktikler** ise ana veride tanımlanır — her müşteri kendi taktik setini kurar: ad, bağlı olduğu mekanik ailesi, harcama tipi (fatura-içi *ya da* fatura-dışı — "her ikisi" diye taktik yoktur; hem içi hem dışı olan iş iki ayrı taktiktir), uygunluk (K10). Aşağıdaki dokuz taktik **örnek settir**, sabit liste değil: CPP fatura-içi % · CPP fatura-dışı % · birim-başı fiyat desteği · görünürlük MT/PH · görünürlük GT · drive/TPR fatura-içi % · TPR lumpsum · toptancı TPR fatura-içi % · toptancı TPR fatura-dışı %.
**Neden:** Hesap şekli (yüzde neyin üstünden, lumpsum nasıl) az sayıda ve değişmez; taktik adları ve setleri müşteriden müşteriye değişir.
**Soru:** Bu beş hesap ailesi Türkiye FMCG'de gördüğünüz tüm taktikleri taşıyabiliyor mu — aileye sığmayan bir taktik türü var mı (örn. hedef-bazlı prim, listeleme bedeli, dönem-sonu iskonto)? Örnek set tipik bir başlangıç mı?

### K12 · Bütçe: kategori/kanal bazlı zarflar; %80 / %90 uyarı, %100'de yeni rezervasyon reddi
**Seçtiğimiz:** Bütçe zarfları kategori ve kanal ekseninde; fatura-içi/dışı ayrı zarf veya tek havuz (UNSPLIT) olabilir. %80 ve %90 kullanımda ilgili kişiye bildirim; %100'de yeni rezervasyon reddedilir, mevcut süreçler durmaz.
**Alternatif:** Referans modeldeki mekanik-tipi bazlı fon (CPP fonu, görünürlük fonu ayrı).
**Soru:** Bütçe eksenleri sektörde nasıl kurulur — kategori/kanal mı, mekanik tipi mi, ikisi de mi? %100'de "yeni rezervasyon reddi" mi, "onaylı aşım" mı yaygın?

### K13 · Onaya gönderimde uyarılar bilgilendirir, durdurmaz
**Seçtiğimiz:** Kırmızı RAG, sarı RAG, hedefin altında ROI, mekaniksiz ürün grubu, eksik veri — hepsi gönderimde uyarı olarak görünür; plan yine gönderilir, onaylayan karar verir. Tek istisna: bütçe %100 aşımı (yeni rezervasyon reddi).
**Soru:** Kırmızı RAG'lı planın onaya gidebilmesi kabul edilir mi, yoksa gönderim engellenmeli mi? Bu politika müşteriye göre değişir mi?

### K14 · Görev ayrılığı ve roller
**Seçtiğimiz:** Onaylayan ≠ gönderen; baseline yükleyen (Finans/Admin) ≠ planlayan; KPI formülünü yalnız Admin tanımlar; roller ve yetkiler sabit (müşteri tarafından değiştirilemez), "kim ne yapabilir" tablosu görünür.
**Soru:** Bu rol seti (Planner / CM / Finans / Admin) tipik TPM organizasyonunu karşılıyor mu? Eksik rol var mı (örn. Key Account Manager, Trade Marketing)?

### K15 · Plan statü yaşam döngüsü
**Seçtiğimiz:** Taslak → Onay bekliyor → Onaylandı / Reddedildi / Geri gönderildi; her aşamada iptal. Referans şemadaki "Planlandı" ara-durumu, otomatik "Devam ediyor / Tamamlandı" geçişleri, "Eksik = kapanış" ve kilit süresi bizde yok (Bölüm 3, Soru 10).

### K16 · Defter silinmez; düzeltme ters kayıtla
**Seçtiğimiz:** Bütçe ve hakediş hareketleri eklemeli defter; hiçbir kayıt silinmez veya değiştirilmez; hata düzeltme = ters kayıt + yeni kayıt. Taslak plan silinebilir (henüz finansal iz yok).
**Soru:** Sektörde hakediş düzeltmeleri (iade, fiyat farkı, geç gelen veri) ters kayıtla mı, mevcut kaydın revizyonuyla mı yönetilir?

---

## BÖLÜM 3 · KARAR VERMEDİK — SEKTÖREL YAKLAŞIM İSTİYORUZ

### Soru 1-3 · İADELER
**Bağlam:** Bugün sistemde iade süreci tanımlı değil. FMCG'de iadeler hem satış hacmini hem hakedişi etkiler.
- **S1.** İadeler gerçekleşme verisine nasıl gelmeli — satıştan düşülmüş *net* rakam olarak mı, ayrı iade satırları (negatif hacim) olarak mı? Hangisi hakediş hesabı ve denetim için tercih edilir?
- **S2.** Promosyon dönemi kapandıktan sonra gelen iade önceki dönemin hakedişini düzeltir mi (geriye dönük düzeltme), yoksa "kapanan kapandı" mı? Düzeltme yapılıyorsa hangi süre penceresinde?
- **S3.** Kapanmış/ödenmiş bir hakedişe iade geldiğinde pratikte ne oluyor — ters hakediş (credit note), sonraki dönemden mahsup, yoksa göz ardı?

### Soru 4 · Sell-in / sell-out ve IMS
KPI'ların hangileri sell-in (üreticiden müşteriye), hangileri sell-out (müşteriden tüketiciye / IMS) hacimle hesaplanmalı? Referans modelde brüt satış sell-in, kâr hesabındaki maliyet sell-out hacmiyle çalışıyordu. Sell-out verisi olmayan müşterilerde ne yapılır?

### Soru 5 · Eşleştirme granülerliği
Gerçekleşme verisini plana/anlaşmaya bağlarken varsayılanımız **FU × CPL × Ay**. Sektörde baskın grain nedir — fatura-bazlı, SKU × müşteri × hafta, FU × CPL × ay? Bunun müşteriye göre değiştirilebilir olması gerekli mi, yoksa tek bir standart yeterli mi?

### Soru 6 · Mekanik-tipi bazlı fon yönetimi
Referans modelde bütçe, mekanik tipine göre fonlara ayrılıyordu (CPP fonu, görünürlük fonu). Bizde kategori/kanal zarfları var. Mekanik-bazlı fon ekseni sektörde beklenti mi, yoksa raporlama boyutu olması yeterli mi?

### Soru 7 · BMI (Brand Marketing Investment)
Referans modelde artan harcama "BMI hariç" tanımlanmıştı. TPM'de marka pazarlama yatırımı kapsam dışı mı tutulur, yoksa ROI'ye dahil edilmesi beklenir mi?

### Soru 8 · Promosyon kilit süresi (locking lead time)
Referans şemada onaylı promosyon, başlangıca belirli gün kala kilitleniyor (değiştirilemez/iptal edilemez). Bu pratik yaygın mı? Tipik süre nedir ve kilit sonrası değişiklik nasıl yönetilir?

### Soru 9 · What-if simülasyonu
Referans modelde "gerçekçi / agresif / muhafazakâr" üç simülasyon vardı. Planner'lar bunu gerçekten kullanır mı? Kullanılıyorsa hangi parametreler (hacim artışı, mekanik oranı) simüle edilir?

### Soru 10 · Statü yaşam döngüsü farkları
Referans şemadaki şu unsurlar bizde yok: (a) "Planlandı" ara-durumu (hazır ama gönderilmedi), (b) tarih tetikli otomatik "Devam ediyor / Tamamlandı" geçişleri, (c) "Eksik" statüsünün akışı sonlandırması. Bunlardan hangileri operasyonel olarak gerekli?

### Soru 11 · Raporlama — kim neye bakar?
Raporlama katmanımızı gerçek veri modelimize göre yeniden tasarlıyoruz. Sizin gözlemlerinizle: Planner, Kategori Yöneticisi, Finans ve üst yönetim günlük/haftalık/aylık hangi raporlara gerçekten bakar? "Olsa iyi olur" ile "olmazsa kullanmam" ayrımı bizim için kritik.

### Soru 12 · Baseline üretim yöntemi
Baseline'ı yükleme mekanizmasını kurduk; nasıl *hesaplandığı* müşteriye bırakıldı. Sektörde baseline geçmiş N ayın ortalaması mı, mevsimsellik düzeltmeli mi, forecast'ten mi türer? Sistemin baseline hesaplaması beklenir mi, yoksa yükleme yeterli mi?

---

## EK · SÖZLÜK
- **CPL (Customer Planning Level):** Müşteri planlama birimi — müşteri değil, planlama grain'i. Bakkallar tek CPL, büyük zincir tek CPL olabilir.
- **FU (Forecasting Unit):** Ürün grubu / tahmin birimi; SKU'ların üstündeki hiyerarşi seviyesi.
- **SKU:** Stok birimi — tekil ürün.
- **STA / LTA:** Kısa dönem anlaşma (promosyon) / uzun dönem anlaşma (yıllık koşullar).
- **On-invoice / Off-invoice:** Fatura üzerinde düşülen indirim / fatura sonrası ödenen destek (görünürlük, birim destek, lumpsum).
- **Taktik / Mekanik:** Taktik kullanıcı-görünür promosyon türü (örn. "CPP fatura-içi %"); mekanik onun hesap ailesi ve tipi (yüzde / birim-başı / lumpsum).
- **Baseline:** Promosyonsuz beklenen hacim (adet); artış (uplift) ve ROI'nin referansı.
- **NIV (Net Invoice Value):** Brüt satış − fatura-içi indirimler. **Ciro (Turnover):** Brüt satış − tüm ticari harcamalar. **Brüt kâr:** Ciro − ürün maliyeti.
- **RAG:** Kırmızı/Sarı/Yeşil promosyon değerlendirmesi (yön: satış arttı mı × kâr etti mi).
- **Hakediş / Settlement / Claim:** Gerçekleşmeye göre müşterinin hak ettiği ödeme; kapanış ve talep kaydı.
- **Bütçe zarfı:** Kategori/kanal bazlı bütçe havuzu; rezerve / tüket / serbest bırak hareketleriyle izlenir.
- **Actuals-First:** Hakedişin planla değil gerçekleşmeyle belirlendiği ilke.
