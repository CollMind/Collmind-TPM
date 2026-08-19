# BRD v2.0 — L2 İş Kuralları (Üçüncü Küme)

> ⛔ **BU DOSYAYI YALNIZ TEAM LEAD YAZAR.** `L2` kural metinleri tek kanaldan geçer:
> kural metni Team Lead'e verilir, Team Lead işler. Yerel/paralel oturumlar `L2`'ye
> **dokunmaz** — kod, migration, ölçüm; belge değil.
> Gerekçe ölçüldü (2026-08-13, `F1`'in tekrarı): aynı kural iki oturumda ayrı ayrı
> işlendi ve iki kopya doğdu — `K-2.6.4` bir kopyada beş kurala açıldı, diğerinde
> `⛔ açık` kaldı. **Tek yazar kuralı vardı, tek kanal yoktu.**

> **Bölüm 2.5 · 2.6 · 2.9 · 2.12.** L2'nin son dördü.
>
> ⚠️ Bu dört bölüm diğerlerinden farklı: **ölçüm var, karar yok.** Kaynağın ne dediği
> ölçüldü, bizim ne yaptığımız ölçüldü, ama aradaki farkın nasıl kapanacağı karara
> bağlanmadı. Kararı verilmiş kısımlar yazıldı; açık olanlar `⛔` işaretli ve neyi
> bekledikleri belirtildi.

- **Sürüm:** taslak, 2026-08-11
- **Kural numaralandırması:** `K-<bölüm>.<sıra>` — önceki kümelerle aynı uzay.

**İşaretler:** ✅ uygulanıyor · ⚠️ kısmen · ❌ uygulanmıyor · ⛔ karar bekliyor

---

# 2.5 · Onay Kuralları

## 2.5.1 İki ayrı sistem

**K-2.5.1** — Onay iki bağımsız sistemden geçer ve **karıştırılmamalıdır:**

| Sistem | Neyi sorar |
|---|---|
| **Onay motoru** | Bu varlık (plan / anlaşma) onaydan geçmeli mi, kimden? |
| **Bütçe politikası** | Bu harcama zarf kullanımı nedeniyle ek onay gerektiriyor mu? |

**K-2.5.2** — Bütçe kaynaklı ek onay (`K-2.2.7`, %90 eşiği) bir **bütçe politikasıdır**, onay
motorunun bir kademesi değil.

> Bu ayrım ölçümle bulundu: `%90 Finans onayı` katmanı onay motoru bölümünde aranmış ve
> bulunamamıştı — bütçe politikası bölümünde tanımlı.

## 2.5.2 Durum makinesi

**K-2.5.3** — Bir plan şu durumlarda bulunabilir:

```
TASLAK → ONAY BEKLİYOR → ONAYLANDI
              ↓                ↓
          REDDEDİLDİ      (anlaşmaya dönüşür)
              ↓
          TASLAK (yeniden düzenleme)
```

**K-2.5.4** — `ONAY BEKLİYOR` durumundaki bir plan **doğrudan taslağa dönemez.** Önce
reddedilmeli ya da **gönderen tarafından geri çekilmelidir.**

**K-2.5.4a** — Geri çekme bir **durum geçişidir** ve `GERİ ÇEKİLDİ` durumundan taslağa dönüş
serbesttir.

> Dış denetim (`F3`) bu durumun makinede tanımsız olduğunu ölçtü — kural onu varsayıyordu.

**K-2.5.5** — Reddedilen bir plan düzenlenip yeniden gönderilebilir. Bu döngü sınırsızdır.

**K-2.5.6** — Bir plan onaylandığında bütçe **taahhüdü** aynı işlemde yazılır. Onay
kaydedilip taahhüt yazılmayan bir durum oluşamaz.

> ⚠️ **Kelime ayrımı bağlayıcıdır** (`K-2.2.4`): plan onayı **TAAHHÜT**, anlaşma onayı
> **REZERVE** yazar. Bu bölümde *"rezervasyon"* jenerik olarak kullanılmaz — `K-2.2.6`'nın
> ölçülmüş ihlali (iki kovanın birleştirilmesi) tam olarak bu belirsizlikten doğuyor.

**K-2.5.6a** — Toplu onay bir **kolaylıktır**, ayrı bir mekanizma değil. Her plan
kendi kontrolünden ve kendi işleminden geçer.

⚠️ **İki desen yasaktır:**

```
ön-kontrollü ya-hep-ya-hiç   hepsini önce kontrol et, sonra hepsini yaz
                             → kontrol ile yazım arasında zarf değişebilir
tek-kontrol-çok-yazım        bir kez kontrol et, N plan yaz
                             → K-2.2.9h'in atomikliği delinir
```

**K-2.5.6b** — Kısmi başarı **normaldir ve gösterilir:** hangi planlar onaylandı,
hangileri neden reddedildi.

> Arayüz toplu sonucu tek bir başarı/başarısızlık olarak göstermez — `K-2.2.11a`'nın
> *"teşhis netliği"* ilkesi.

> 📌 Kaynak: karar defteri `Z8` (2026-08-16).

**K-2.5.7** — ⚠️ **Bekleyen bir planın bütçe kaydı yoktur.**

Gönderilmiş ama onaylanmamış bir plan **hiçbir kova yazmaz** (`K-2.2.9i`). Dolayısıyla
`ONAY BEKLİYOR` durumundan çıkışlar (ret, geri çekme, süre dolumu) **iade üretmez** — iade
edilecek bir şey yoktur.

**K-2.5.7a** — İade yalnız **onaylanmış** bir planın geri alınmasında oluşur: taahhüt aynı
işlemde serbest bırakılır.

> **Düzeltme kaydı (2026-08-12, dış denetim `F3`):** bu kural önceki hâlinde *"reddedilen ya
> da geri çekilen planın rezervasyonu iade edilir"* diyordu — ve `K-2.2.9i` ile **sessizce
> çelişiyordu.**
>
> Çelişkinin bedeli görünürdü: `K-2.5.10`'un (zaman aşımı) gerekçelerinden biri *"durum ve
> defter yazan bir iş, tehlikeli"*ydi. Çelişki temizlenince o bacak düşüyor — **bekleyen plan
> bütçe yazmadığı için zaman aşımının finansal riski zaten yok.** Karar değişmiyor; gerekçesi
> sadeleşiyor.

## 2.5.3 Zaman aşımı

**K-2.5.8** — Cevapsız kalan bir onay isteği belirli bir süre sonra **zaman aşımına uğrar** ve
durum değiştirir.

**K-2.5.9** — Zaman aşımı bir **durum geçişidir**, bir bildirim ayrıntısı değil (`K-2.10.7`).

> ✅ **Karar verildi** (2026-08-12, Oturum 2.4). Faz 1'de **bildirim**, otomatik durum
> değişikliği Faz 2.

**K-2.5.10** — Faz 1'de cevapsız kalan bir onay **otomatik durum değiştirmez.** Yalnız
bildirim üretir:

| Gün | Kime | Ne |
|---|---|---|
| 7 | Onaylayıcı + gönderen | Hatırlatma |
| 14 | Yönetici | Yükseltilmiş **bildirim** — aksiyon değil |

> Gerekçe (ürün sahibi): planlar bayram, dönem kapanışı, fuar haftası gibi sebeplerle
> **meşru olarak** 7 günü aşar. Otomatik süre dolumu bu dönemlerde toplu plan ölümü + toplu
> rezervasyon iadesi + toplu yeniden gönderim üretir — çözdüğü sorundan büyük operasyonel
> gürültü.
>
> Gerçek sorun *"onay unutuldu"*dur ve çözümü bildirimdir.
>
> Ve kaynağın kendisi çekimser: `7+14` kuralını bir bildirim maddesinde veriyor ve kendi
> tablosunda *"bu bölüme ait değil"* diye işaretliyor — kanonik bir davranış sözleşmesi
> değil, bir taslak kalıntısı.

**K-2.5.10a** — Bekleme süresi **raporlanabilir bir metriktir.** Faz 2 kararı o ölçümle
verilir: hangi kurulumda gerçekten plan çürüyor?

**K-2.5.10b** — Faz 2'de otomatik zaman aşımı geldiğinde davranış **`SÜRESİ DOLDU`**'dur.
Plan yeniden gönderilebilir.

> Bir bütçe hareketi **oluşmaz** — bekleyen plan zaten kova yazmamıştı (`K-2.5.7`).

**K-2.5.10c** — ⚠️ **Otomatik yükseltme reddedildi.**

> Gerekçe: sessiz eskalasyon, kimsenin vermediği bir onay kararını **zamanlayıcıya**
> verdirir. `K-2.5.11` insan onayını mutlaklaştırdı; bu, o ailenin ihlali olurdu.
>
> Ayrıca yükseltilen kişi bağlamı bilmez — kuyruğu yukarı taşımak onayı hızlandırmaz,
> **kirletir.**

**K-2.5.10d** — Taslağa otomatik dönüş de reddedildi (`K-2.5.4`): gönderilmiş içeriğin
onaysız değişebilir hâle gelmesi demektir.

**K-2.5.10e** — Süreler (7/14) **konfigürasyondur**, görüşlü varsayılan olarak gelir.

> ⚠️ **Şema notu:** `SÜRESİ DOLDU` enum değeri ve durum geçiş tablosundaki yeri **şimdi**
> tanımlanır — davranışı Faz 2'de gelse bile. Geçiş: `SÜRESİ DOLDU → yeniden gönderilebilir
> (içerik değişmeden)`.

## 2.5.3a Zamanlanmış işler

**K-2.5.10f** — Zamanlanmış iş altyapısı **Faz 1'e aittir.** Dört iş onu bekliyor: dosya
kontrolü, gecelik veri yenileme, veri tazelik denetimi, onay gecikme bildirimi.

**K-2.5.10g** — ⚠️ **İlk işler idempotent-okuma sınıfından seçilir.**

| Sınıf | İşler | Neden önce |
|---|---|---|
| Idempotent okuma | Dosya kontrolü · gecelik yenileme | Çift tetikleme, kaçırılan tik, saat dilimi hatası **zararsız** |
| Durum yazan | Onay zaman aşımı | Orta — durum değiştirir, **deftere dokunmaz** |

> **Motoru zararsız işlerle pişir, finansal işi sonra bağla.**

> ⚠️ **Güncelleme (2026-08-12, `F3` yan sonucu):** zaman aşımı önce *"durum ve defter yazan"*
> sınıfına konmuştu. Çelişki temizlenince (bekleyen plan kova yazmıyor) **deftere dokunmadığı**
> ortaya çıktı — risk sınıfı **idempotent durum**'a indi.
>
> Sıralama yine de değişmiyor: idempotent-okuma işleri hâlâ önce. Ama zaman aşımının
> gerekçesi artık *"finansal risk"* değil, yalnız **sıra.**

## 2.5.4 Kim onaylar

> ✅ **Karar verildi** (2026-08-12, Oturum 1.4). İstisna yok, ve kapsam genişletildi.

**K-2.5.11** — **Hiç kimse kendi gönderdiği veya son değiştirdiği bir planı onaylayamaz.**

Kapsam: **son gönderen ∪ içeriği son değiştiren.**

> ⚠️ Kapsam cümlesi bir **bypass'ı kapatıyor.** Kural yalnız *"gönderen"*e baksaydı, planı
> yazan kişi onu bir başkasına gönderttirip kendisi onaylayabilirdi — görev ayrılığı kağıt
> üstünde kalırdı.
>
> Kaynak yalnız *"kendi gönderdiğini onaylayamaz"* diyor ve kapsamı tanımlamıyor. Bu
> genişletme ölçümden değil, denetim mantığından geliyor.

> ❌ **Ölçülmüş ihlal** (`C1`, 2026-08-12) — **ön koşul:** `B` dalgası `S13`
> (`last_modified_by` kolonu) + `T-205` (kimlik alanının boşaltılması).
> Dalga kapandığında bu satır `✅`'ya döner.
>
> Bugünkü davranış: kapsamın yarısı **boş bir kolona bakıyor**, ve gönderen alanı bir yolda
> boşaltılabildiği için dar kontrol de deliniyor.

**K-2.5.11a** — Bu kuralın **istisnası yoktur.**

> Gerekçe (ürün sahibi): görev ayrılığı, finansal kontrol denetiminin çekirdek maddesidir.
> *"Muhasebe doğruluğu"* diye konumlanan bir üründe burada delik olması, konumlanmanın
> kendisiyle çelişir — ve rakiplerin denetim sertifikasını satış argümanı yaptığı yerde bu
> en ucuz uyum kartıdır.
>
> Kaynak dört yerde tekrarlıyor, biri *"sistem engeller"* diyerek. Bu bir tercih değil,
> sözleşme.

**K-2.5.11b** — **Tek kişilik ekip** durumu bir istisnayla değil, bir **kurulum kuralıyla**
çözülür: bir kurulumda **en az iki onay yetkili kullanıcı** bulunmalıdır.

> Bu bir kurulum doğrulamasıdır (`K-2.14.5` ailesi), bir kod istisnası değil. Kural akışı
> durdurmuyor — ikinci bir göz zorunluluğu yaratıyor, ki istenen tam da bu.

**K-2.5.11c** — **Sahipsiz kalan plan** (onaylayıcı ayrılmış veya izinde) bir **devir
mekanizmasıyla** çözülür: plan başka bir yetkiliye yeniden atanır.

Yönetici planın yazarıysa kural aynen işler — kendine atayamaz, üçüncü kişiye atar.

> ⛔ Devir mekanizması Faz 2'ye (onay politikaları) aittir. Faz 1'de nadir vaka elle
> çözülür: başka bir yetkili onaylar.

## 2.5.4a Köken alanları

**K-2.5.16** — ⚠️ **Köken alanları ile yaşam döngüsü alanları aynı kolonda yaşayamaz.**

Gönderen ve değiştiren alanları **köken kayıtlarıdır:** güncellenebilir, ama **asla
boşaltılamaz.** Yaşam döngüsü bilgisi `durum` alanında yaşar, kimlik alanında değil.

> Gerekçe: *"henüz gönderilmedi"* bir **durum** bilgisidir ve zaten `TASLAK` olarak
> şemada var. Kimlik alanını boşaltmak, durum makinesinin işini bir köken kolonuna
> taşımaktır.
>
> `K-2.2.7`'nin renk/davranış ayrımıyla aynı aile: **her bilgi kendi ekseninde.**

**K-2.5.16a** — Yeniden gönderimde gönderen alanı **yeni gönderenle güncellenir.** Önceki
gönderen denetim izinde korunur.

> `K-2.5.11`'in doğru okuması *"bu gönderimi kim yaptı"* değil, **"bu içeriği kim
> gönderdi"**dir.

**K-2.5.16b** — ⚠️ Boşaltılan bir kimlik alanı, `K-2.5.11`'in daralttığı bypass'ı **sıfır
maliyetle** yeniden açar:

```
submittedById = NULL → NULL ≠ onaylayan → kontrol geçer
```

> ❌ **Ölçülmüş ihlal** (`C1`, 2026-08-12): bugün bir yol gönderen alanını boşaltıyor. Ve
> bu, `S13` (`last_modified_by`) inse bile dar kontrolü delmeye devam eder — kural her iki
> senaryoda da aynı: **boşaltma yasak.**
>
> **Ön koşul:** [[T-205]] — **dalga** adresi. `S13`'ten bağımsızdır: `S13` inse bile bu
> satır `T-205` kapanmadan `✅`'ya dönmez.

---

> ✅ **Karar verildi** (2026-08-12). Tek hat: şablon. Devir bir **eylem**, bir hat değil.

**K-2.5.12** — Onay hattını **yalnız atanmış şablon** belirler. İkinci bir yükseltme
mekanizması **yoktur.**

> `approval_policy_id` zaten her isteğe bağlıdır; hattın tek kaynağı odur.
>
> Gerekçe (`İlke 4`): ayrı bir yükseltme mekanizması kendi durum geçişini, kendi bildirimini
> ve kendi iade kuralını edinir. Altı ay sonra *"eşikten gelen finans onayı"* ile *"elle
> gelen finans onayı"* farklı davranır — **ve kimse fark etmez.**

**K-2.5.12a** — Onaycının üç eylemi vardır:

```
ONAYLA · REDDET · FİNANSA DEVRET
```

**K-2.5.12b** — `FİNANSA DEVRET` şablonun **tanımlı bir geçişidir**, ayrı bir hat değil:
şablonda zaten var olan finans kademesini **bu istek için etkinleştirir.**

Devirle gelen istek, eşikle gelen istekle **aynı akışı** izler — tek durum makinesi, tek
iade kuralı, tek bildirim ailesi.

**K-2.5.12c** — Geliş sebebi **kayıtlıdır** (`EŞİK` | `DEVİR`).

> Denetim izi için, ve ileride bir ölçüm için: *"elle devirler ne sıklıkta?"*

**K-2.5.12d** — Devir **gerekçe ister.**

> `K-2.5.15`'in ret kuralıyla simetrik: **devir, onaycının kendi sorumluluğunu yukarı
> taşımasıdır** — izi anlamlı olmalı.

**K-2.5.12e** — Finans, kendisine gelen istekleri onaylar. **Genel ikinci kademe onay yetkisi
bir şablon tercihidir** (`Eşikli` / `Çift kademe`), bir ürün varsayılanı değil.

> Ve ihtiyacın kendisi meşru: eşik altında kalan ama kokusu kötü bir planı finansa göstermek
> — *"bu müşteriyle geçen dönem ihtilaf vardı."*
>
> İnkâr etmek, kullanıcıyı sistem dışı kanala iter: **onay izinin e-posta zincirine kaçması**,
> ürünün varlık gerekçesinde sayılan hastalık.

**K-2.5.12f** — Devir iki hedefe gidebilir ve **tek mekanizmada yaşarlar:**

```
DEVRET → kademe    şablonun üst kademesini etkinleştir    Faz 1
DEVRET → kişi      başka bir onaycıya yönlendir           Faz 2
```

> `K-2.5.13e`'nin `devir izni` alanı ikisini birden taşır. Faz 1'de yalnız kademe devri gelir
> — şablonda kademe zaten tanımlı, maliyeti düşük.

> ✅ **Karar verildi** (2026-08-12, Oturum 2.1). Politika tablosu + üç görüşlü şablon.
> Koşullu kural motoru **yok.**

**K-2.5.13** — Onay politikaları bir **tabloda** yaşar, kodda değil.

**K-2.5.13a** — Tablo **üç görüşlü şablonla** doğar:

| Şablon | Akış | Kime |
|---|---|---|
| **Standart** (varsayılan) | Kategori müdürü onaylar; bütçe eşiği aşımı finansa yükselir ⚠️ | Bugünkü akışın tablolaşmış hâli |
| **Çift kademe** | Her plan kategori müdürü + finans, tutara bakılmaz | Küçük veya temkinli kurulum |
| **Eşikli** | Tutar < X tek onay · ≥ X finans eklenir | Orta ölçeğin en yaygın deseni |

> ⚠️ **Şerh (dış denetim `F10`):** *"finansa yükselir"* yalnız `FINANCE_REVIEW = ONAY`
> modunda bir **onay adımıdır.** Varsayılan `BİLDİRİM` modunda (`K-2.2.7b`) yükselme bir
> bildirimdir, akış durmaz. Faz 1'de yükselecek bir onay kademesi **yoktur.**

**K-2.5.13b** — Şablonlar tablonun **satır kümeleridir**, ayrı kod yolları değil (`İlke 4`).

**K-2.5.13c** — Tenant bir şablon **seçer** ve eşik değerlerini ayarlar. **Kural yazamaz.**

> Gerekçe (ürün sahibi): serbest biçimli bir kural motoru bu segmentte kanıtlanmış aşırı
> mühendisliktir — rakip analizi onu implementasyon partneri zorunluluğu ve *"kaybolma"* ile
> ilişkilendiriyor. `when`/`OR`/`otomatik ret` grameri taşıyan bir motor, ilk müşteride
> kimsenin doldurmayacağı boş bir kural editörü demek.
>
> Kaynak da bunu söylüyor: *"politikalar bilinçli olarak küçük ve görüşlü bir kümeyle
> sınırlıdır."* Yani kaynağın tam modeli bir **hedef**, bir başlangıç değil.

**K-2.5.13d** — Kural yazma yüzeyi ancak **iki-üç gerçek müşteri talebi aynı deseni
gösterirse** açılır.

> Ve açıldığında ilk aday bellidir: **tutar eşiği + rol yönlendirmesi** — otomatik ret değil.
> Üçüncü şablon zaten onun yarısı.

**K-2.5.13e** — ⚠️ **Tablo, Faz 2 alanlarını şimdiden taşır.**

Üç kararın Faz 2'si bu tabloya iniyor:

| Karar | Gereken alan |
|---|---|
| `K-2.2.7b` — `FINANCE_REVIEW` modu | `mode: notify \| approve` |
| `K-2.5.11c` — devir mekanizması | `delegate_allowed` |
| `K-2.13.12a` — eşleştirme onayı | eşleştirme onay rolü |

> Tablo gelmezse üçü de kodda sabitlenir ve `İlke 3` **üç kez** ihlal edilir. Davranış Faz
> 2'de gelse bile kolonlar bugün var olur — deploy öncesi ucuz.

**K-2.5.13f** — `approval_policy_id` alanı ilk şablona **bağlanır.** Boşluğa bakan bir alan
kalmaz.

## 2.5.5 Onay kaydı

**K-2.5.14** — Her onay kararı, **karar anındaki göstergeleri** kaydeder (`K-2.11.5`).

> Gerekçe: göstergeler sonradan yeniden hesaplanır. Kaydedilmezse *"bu plan hangi rakama
> bakılarak onaylandı"* sorusu cevaplanamaz.

**K-2.5.15** — Onay gerekçesi zorunludur ve asgari bir uzunluk taşır.

---

# 2.6 · Yetki Modeli

## 2.6.1 İki katman

**K-2.6.1** — Yetki iki bağımsız katmandan oluşur ve **ikisi de sağlanmalıdır:**

| Katman | Neyi belirler |
|---|---|
| **Yetenek** | Kullanıcı bu **işlemi** yapabilir mi? |
| **Kapsam** | Kullanıcı bu **kaydı** görebilir mi? |

**K-2.6.2** — Bir işlem, kullanıcının yeteneği **ve** kaydın kullanıcının kapsamında olması
durumunda gerçekleşir. Biri eksikse işlem reddedilir.

## 2.6.2 Yetenek katmanı

**K-2.6.3** — Yetkiler **yetenek** olarak tanımlanır (*"plan oluşturabilir"*, *"bütçe
uyarısını aşabilir"*, *"politika tanımlayabilir"*). Roller, yetenek kümeleridir.

> ❌ Bugün kullanıcı **tek bir rol** taşıyor ve yetenekler tanımlı değil. Rol bir varlık
> değil, bir enum değeri.

> ✅ **Karar verildi** (2026-08-12). Beş rol; `Süper Yönetici` girmez.

**K-2.6.4** — Rol kataloğu:

| Rol | Sorumluluk |
|---|---|
| `YÖNETİCİ` | Tanımlar, kural yönetimi |
| `PLANLAMACI` | Plan, taktik, hacim girişi, gönderim — günlük kullanıcı |
| `KATEGORİ MÜDÜRÜ` | **Kategori bütçe sahibi:** onay + zarf yönetimi |
| `FİNANS` | Eşik üstü onay/bildirim, transfer, mutabakat, içe aktarma |
| `İZLEYİCİ` | Salt görüntüleme |

**K-2.6.4a** — ⚠️ **Rol yalnız bir yetenek paketi değildir** — görev ayrılığının ve onay
şablonlarının **adres defteridir.**

> Gerekçe: `K-2.5.13a`'nın şablonları rollere referans veriyor (*"kategori müdürü onaylar,
> finans yükselir"*), ve `K-2.2.7b`'nin bildirimi bir role gidiyor.
>
> Onaycılığı serbest bir yeteneğe çevirmek, şablonu *"onay yeteneği taşıyan herhangi biri"*
> demeye zorlar — ve **paranın sahibi ile onay mekaniği ayrışır.**
>
> **En az rol, en sade sistem demek değildir.** En sade sistem, şablonun bir bakışta
> anlaşıldığı sistemdir (`İlke 1`).

**K-2.6.4b** — Onaycı **jenerik değildir, bütçenin sahibidir.** Kaynağın `Approver` rolü
alınmaz.

> Jenerik bir onaycı rolü, *"kimin onayı"* sorusunu rol atamasına gömer ve `K-2.5.11`'in
> kapsam sorularını bulanıklaştırır.

**K-2.6.4c** — `İZLEYİCİ` bir **izleme yetenekleri setidir**, bir *"salt-okur bayrağı"*
değil.

> *"Salt-okur"* bir sorumluluk adı değil, yazma yeteneklerinin verilmemiş hâlidir. Ve
> `K-2.6.5b`'nin birleşim modelinde **her rolün okuma tabanı zaten var** — onu rol yapmak,
> *"hiçbir şey yapamama"*yı bir pakete çevirmekti.

**K-2.6.4d** — Kullanımdan kalkmış etiketler enum'dan **düşer** — ama önce **sayılır.**

> Çok rollülük (`K-2.6.5`) birleşik rolleri katalogdan siler: bir kullanıcı `FİNANS` +
> `KATEGORİ MÜDÜRÜ` taşıyabiliyorsa, ayrı bir birleşik etikete gerek yok.
>
> ⚠️ **Sıra bağlayıcı:** o etiketleri taşıyan kullanıcı var mı **önce sayılır**, varsa yeni
> role eşlenir, **sonra** etiket ölür. Sayım yapılmadan silme, göç kayıpsızlığını deler.

**K-2.6.4e** — ⛔ **`Süper Yönetici` reddedildi.**

Kaynağı sign-off almamış bir taslak, ve `K-2.6.5f` (*"rol seti kapalı başlar, genişleme
kanıtla"*) meseleyi kapatıyor.

> ⚠️ **Ama arkasındaki ihtiyaç kaydedilir:** talebin gerçek konusu genellikle **tenant-üstü
> operasyon** — kendi destek ve kurulum erişimimiz.
>
> Bu, tenant-içi rol kataloğunun konusu **değildir.** Çok kiracılı bir üründe ayrı bir
> kavramdır (operatör erişimi) ve `K-2.6.12`'nin bir kenar sorusudur: *"personel müşteri
> verisine hangi kapıdan, hangi izle girer?"*
>
> Soru Faz 1'de cevaplanmalı — ama enum'a bir etiket eklemek onun cevabı değil,
> **ertelenmesidir.**

> ✅ **Karar verildi** (2026-08-12, Oturum 2.3). Çok rollülük **evet**, kişiye özel istisna
> **hayır.**

**K-2.6.5** — Bir kullanıcı **birden çok rol** taşıyabilir. Roller bir birleştirme tablosunda
yaşar.

> Gerekçe (ürün sahibi): hedef segment 3-5 kişilik ticari ekipler, ve `K-2.5.11b` en az iki
> onay yetkili kullanıcı istiyor. Tek-rol modelinde küçük müşteri matematiği tutmuyor —
> patron hem finans hem yönetici, ticari müdür hem planlamacı hem onaycı. Bu orta ölçeğin
> **normali**, istisnası değil.
>
> Tek rolle o müşteri ya sahte kullanıcılar açar (denetim kirlenir) ya ürünü bırakır.

**K-2.6.5a** — Rol bir **varlıktır**, bir enum değeri değil.

> Ve `K-2.5.13` politika tablosu rollere referans verecek — enum değerine referans kırılgan.
> Şema bugün ucuz.

**K-2.6.5b** — Etkin yetki = **rollerin birleşimi.** Kesişim, koşullu devreye alma, bağlama
göre rol seçimi **yok.**

> `K-2.2.8c` ile aynı ilke: *"kim neyi yapabilir"* sorusu tek okumadan cevaplanmalı.

**K-2.6.5c** — ⚠️ **Görev ayrılığı rol bazlı değil, kişi bazlı işler.**

`K-2.5.11` (kendi planını onaylayamaz) ve `K-2.13.12a` (belgeyi sokan eşleştirmeyi
onaylayamaz) **kişiye ve işleme** bakar, role değil.

Yani çift rollü bir kişi kendi planını **yine onaylayamaz** — finans rolü olsa bile.

> Bu cümle yazılmazsa çok rollülük görev ayrılığını sessizce delerdi: *"finans rolüm var,
> kendi planımı finans sıfatıyla onayladım."*
>
> **Invariantların öznesi kullanıcıdır, rol değil.**

**K-2.6.5d** — **Kişiye özel yetki istisnası yapılmaz.** Kaynak böyle bir tablo tanımlıyor;
bu **bilinçli bir sapmadır.**

> Üç gerekçe aynı yöne bakıyor: kaynağın kendi çekimserliği (*"idareli kullanın"*), kanıtlanmış
> ihtiyacın olmaması (`İlke 1`), ve görev ayrılığı riski.
>
> Kişi bazlı istisna, *"yetki modeliniz nedir"* sorusuna **"tablo + kişiye özel delikler"**
> cevabı verdirir — muhasebe doğruluğu konumlanmasıyla bağdaşmaz.

**K-2.6.5e** — Yetki eksikliği **rol atamasıyla** çözülür. Desen tekrarlıyorsa yeni bir
görüşlü rol tanımlanır; kişi bazlı bir delik açılmaz.

**K-2.6.5f** — Rol kümesi **kapalı başlar** ve genişleme kanıtla gelir. Yetenek→rol eşlemesi
tablodadır ama tenant'ın kural yazacağı bir yüzey değildir.

> `K-2.5.13c` ile aynı disiplin: seç, ayarla — yazma.

**K-2.6.14** — ✅ **Karar verildi** (2026-08-12, Oturum 1.5). Fatura ve hakediş belgesi içe
aktarma yetkisi **planlamacıda ve finansta** olmalıdır — ama yürürlüğü eşleştirme katmanına
bağlıdır.

| Faz | Yetki | Gerekçe |
|---|---|---|
| **Bugün** | yalnız finans + yönetici | Eşleştirme yok → **giriş = karar** |
| **Eşleştirme geldiğinde** | + planlamacı | Giriş bir hazırlık işlemine döner |

> **Ayrım:** görev ayrılığı **veri girişini** değil, **finansal kararı** korur. Karşı taraf
> belgesini sisteme sokmak bir yakalama işlemidir; finansal sonucu doğuran şey eşleştirme ve
> onaydır.
>
> ⚠️ Ama bugün araya kontrol girmiyor — içe aktarma gerçekleşen veriyi ve defter etkisini
> doğrudan yazıyor. Yani **bugün import bir veri girişi değil, fiilen bir finansal işlem**, ve
> planlamacıya açmak `K-2.5.11`'in kapattığı kapıyı yandan açar.
>
> Bugünkü kısıt kaynaktan **bilinçli bir sapmadır** ve geçicidir — bir **telafi kontrolü.**

> Saha gerekçesi: gerçekleşmeyi kovalayan kişi planlamacıdır. Faturayı finansın yüklemesini
> beklemek, tam da yok edilmek istenen *"paralel tablo takibi"* davranışını geri getirir.

**K-2.6.6** — Yetki kontrolü **kural yoksa reddet** ilkesine göre çalışır.

> ❌ **Ölçülmüş sapma:** bugün tersi — kural tanımlanmamış bir uç nokta herkese açık. 236
> uçtan 77'sinde kural yok, ve biri gerçek bir yazma işlemi.

## 2.6.3 Kapsam katmanı

> ✅ **Karar verildi** (2026-08-12, Oturum 3.6). Kapsam **kanal + müşteri + kategori** —
> kaynaktan bilinçli sapma.

**K-2.6.7** — Yetki kapsamı üç eksende tanımlanır: **kanal · müşteri · kategori.**

> ⚠️ Kaynak kategoriyi bir **ürün** ekseni sayıyor ve yetkiyi organizasyon ekseninde
> (kanal · bölge · satış ekibi) tanımlıyor. Bu **bilinçli bir sapmadır.**
>
> **Gerekçe 1 — yetki ekseni, onay sorumluluğunun eksenini izler.** `K-2.5.13a`'nın birinci
> şablonu *"kategori müdürü onaylar"* diyor. Kategori müdürünün kapsamı kategoriyle
> sınırlanamıyorsa **rolün adıyla kapsamı çelişir.**
>
> Kaynağın eksen listesi bir **organizasyon varsayımıdır**, bir yetki ilkesi değil —
> saha-satış örgütlü büyük ölçek şablonundan geliyor.
>
> **Gerekçe 2 — bölge için tersi kanıt var.** Mekanizma tam kurulu (tablo, yönetim ekranı,
> üç yabancı anahtar), kullanım **sıfır satır.** `İlke 1` kanıtlanmış ihtiyaç arıyor; burada
> **ihtiyaçsızlık ölçülmüş.**

**K-2.6.7a** — Bölge mekanizması **korunur ama kapsam çözümlemesine bağlanmaz.**

Aktivasyonu, saha örgütlü bir müşteri talebine bağlıdır — mekanizma hazır olduğu için
aktivasyon ucuz.

> `K-2.6.5f`'nin (*"rol seti kapalı başlar, genişleme kanıtla"*) eksen karşılığı.

**K-2.6.7b** — Dördüncü bir eksen **eklenmez.** Her kapsam ekseni bir **çarpandır:** kapsam
denetimi, kullanıcı yönetimi ekranı, boş-eksen semantiği ve test matrisi büyür.

**K-2.6.8** — ⚠️ **Yetki kapsamı ile bütçe boyutu ayrı mekanizmalardır.**

`K-2.2.8a` (kanal + kategori) ile buradaki eksenlerin örtüşmesi **tesadüfidir** — iki ayrı
mekanizma aynı sözlüğü kullanıyor.

| Mekanizma | Sorusu |
|---|---|
| Yetki kapsamı | Kim neyi görür ve onaylar? |
| Bütçe boyutu | Hangi zarfa hangi eşik? |

> Tek bir *"boyut motoru"*nda birleştirme cazibesi **reddedilir.** Birleştirilirse her bütçe
> boyutu eklemesi yetki modelini titretir.
>
> `İlke 4` burada **ters yönde** çalışır: bunlar aynı yetenek değil, **ayrı yeteneklerdir** —
> ayrı kalmalılar.

**K-2.6.8a** — **Boş kapsam = erişim yok.** Tüm veriye erişim, açık bir joker atamasıyla
verilir.

> `K-2.2.8d`'nin (zorunlu joker varsayılan) **tersi** asimetri — ve bilinçli: orada varsayılan
> cömert, burada kısıtlı. Çünkü orada bir **eşik**, burada bir **erişim** söz konusu.
>
> Bu cümle yazılmazsa ilk kullanıcı kurulumunda *"neden hiçbir plan göremiyorum"* ya da
> *"neden her şeyi görüyorum"* destek talebine dönüşür.

**K-2.6.9** — Kapsam filtresi **her zaman aktiftir.** Kapatılabilir bir filtre, kapalıyken
tüm veriyi açar.

> ❌ **Ölçülmüş sapma:** filtre bugün bir ayarla kapalı — bir planlamacı tüm müşterilerin
> verisini görüyor.

## 2.6.4 Tek kaynak

**K-2.6.10** — Yetki kararı **tek bir yerde** verilir. Arayüz o karara uyar, kendi kopyasını
tutmaz.

> ⚠️ **Ölçülmüş durum:** yetki bugün beş yerde tanımlı (sunucu kuralları, ekran kapıları,
> sayfa içi kontroller, menü, bir yardımcı). Dördü hizalandı, biri kaldı.
>
> Bu, `K-2.6.3`'ün (yetenek modeli) uygulanmasıyla kökten çözülür — beş kopya birden düşer.

## 2.6.5 Veri izolasyonu

**K-2.6.11** — Her kayıt hangi müşteriye ait olduğunu taşır, ve her sorgu bu ayrımı uygular.

**K-2.6.12** — İzolasyon **iki katmanda** korunur: uygulama katmanı filtresi **ve**
veritabanı seviyesinde zorlama. Biri diğerinin yerine geçmez.

> ❌ Bugün yalnız uygulama katmanı var. Veritabanı seviyesinde hiçbir politika tanımlı değil.
>
> ⚠️ **Ve bu ertelenebilir değil:** hakediş bir finansal işlemdir ve finansal kontrol
> denetimi sektörde bir satın alma kriteridir. İzolasyon *"ikinci müşteri gate'i"* değil,
> **ilk kurumsal satışın ön koşulu.**

**K-2.6.12a** — **Raporlama yolları da kiracı izolasyonuna tabidir.**

> Bir rapor sorgusu ham SQL ya da görünüm kullanıyorsa, uygulama filtresi devrede
> olmayabilir — ve `K-2.6.12`'nin ikinci katmanı (veritabanı seviyesi) henüz yok.

⚠️ **Guard adayı, uyarı statüsünde:** rapor sorgularında kiracı koşulu var mı.

> Kapıya **terfi eder**, kapı doğmaz — yanlış-pozitif oranı ölçülmeden bağlanmaz
> (`mode-split` dersi).

> 📌 Kaynak: karar defteri `Z8` (2026-08-16). ⚠️ Ürün sahibi bu kuralı `L2_02 §2.11`
> (`K-2.11.x`) diye adresledi ve **numara tahsisini Team Lead'e bıraktı**; ölçüldü ki
> `§2.11` **denetim kaydı** bölümüdür, kuralın konusu ise kiracı izolasyonu. Kaynağının
> yanına yazıldı — gerekçe `Z8`'de.

**K-2.6.13** — Veritabanı izolasyonu, **ayrıcalıklı olmayan** bir bağlantı rolü gerektirir.

> Gerekçe: ayrıcalıklı bir rol izolasyon politikalarına tabi değildir. Ölçüldü: bugün tek
> giriş rolü ayrıcalıklı — politika yazılsa bile uygulanmaz, **ve testler yeşil geçer.**
>
> Bu, izolasyonun ön koşuludur ve ondan önce yapılmalıdır.

**K-2.6.13a** — ⚠️ **İki ayrı rol gerekir**, tek rol yetmez:

| Rol | Ne yapar | İzolasyona tabi mi |
|---|---|---|
| `app_runtime` | Veri okuma/yazma — uygulamanın çalışma bağlantısı | ✅ **evet** |
| `app_migrate` | Şema değişikliği ve seed — yalnız göç koşusunda | hayır |

> Gerekçe: göçler şema değiştirme hakkı ister, çalışma zamanı istemez. **Tek bağlantı rolü
> ikisini birden taşırsa ayrıcalıksızlık kâğıt üstünde kalır.**

**K-2.6.13b** — Tablo sahibi **`app_migrate`**'tir. Ayrı bir sahip rolü tanımlanmaz.

> Sahiplik ayrımının koruduğu şey — *sahip, politikalara tabi değildir* — `app_runtime` sahip
> olmadığı için **zaten sağlanıyor.** Üçüncü bir rol, kanıtlanmış ihtiyaç üzerine eklenir
> (`İlke 1`).

**K-2.6.13c** — Roller bir **kurulum betiğinde** tanımlanır, bir göçte değil.

> Roller bir **küme yönetimi nesnesidir**, şema geçmişi değil: aynı roller birden çok
> veritabanında yaşayabilir, göç zinciri ise tek bir şemanın tarihidir.
>
> Ve pratik gerekçe: göç `app_migrate` ile koşuyorsa, rolleri yaratan şey **kendisi olamaz.**

**K-2.6.13d** — ⚠️ **Sessiz geri dönüş yasaktır.**

Bağlantı havuzunda ya da hata yakalama katmanında *"bağlanamadı, ayrıcalıklı dizgeyle
dene"* türünde bir yedek yol bulunamaz.

> Böyle bir yol kalırsa **bütün iş kâğıt üstünde kalır** — ve bunu hiçbir yeşil test
> göstermez. Bu, `K-2.6.13`'ü doğuran sessiz-yeşil sınıfına geri düşmenin tek yoludur.

**K-2.6.13e** — Kabul ölçütü, kuralın doğuş gerekçesinin **tersini** sınar:

```
1  test ortamına kısıtlayıcı bir deneme politikası yaz
2  app_runtime ile eriş
3  erişimin REDDEDİLDİĞİNİ doğrula      ← rol gerçekten tabiyse kırmızı
4  politikayı kaldır, yeşile dön
```

> Rol tabi değilse politika **sessizce delinir** ve test ilk günden yakalar. Bu tek test,
> `K-2.6.12`'nin (veritabanı izolasyonu) tamamının **güven zeminidir.**

**K-2.6.13f** — İşin çıktısı yalnız rol değil, bir **izin envanteridir:** uygulamanın fiilen
hangi yetkileri kullandığı.

> Yöntem: rol yarat → test ortamında bağlan → testleri koştur → **düşen izinlerin listesi =
> gerçek ihtiyaç** → yalnız onları ver.
>
> Envanter saklanır ve `K-2.6.12`'nin politikalarını yazarken **doğrudan girdidir.**

> ### ⚠️ Yöntemin ölçüm evreni — `ADIM 1`'de ölçüldü (2026-08-15, kayıt `Z3`)
>
> Bu kural *"**uygulamanın** fiilen kullandığı"* diyor; yöntem ise *"tam test **suite**
> koşulur"* diyor. **Suite uygulama değildir** — ve fark bir izin FAZLALIĞI olarak çıkar.
>
> Ölçülmüş vaka: `S3` döngüsü `app_runtime`'a `ledger_entries` · `admin_audit_logs` ·
> `agreement_transactions` üzerinde **`DELETE`** verdirdi. Üretimde o tabloları silen yol
> **0**; isteyen **test temizliğiydi**.
>
> ⛔ Ve fazlalık zararsız değildi: `K-2.11.7` korumanın **veritabanı seviyesinde** olmasını
> istiyor. O `DELETE`, `K-2.3.4` / `K-2.11.6` / `INV-L-003`'ün **DB seviyesinde ihlal
> edilebilir** olması demekti.
>
> **Bir sonraki `S3` turu (RLS rolü ya da başka bir ayrıcalıksız rol) aynı fazlalığı
> üretecektir.** Yöntemi uygulayan kişi şunu önceden bilmeli:
>
> ```
> düşen izin  →  hangi yol istedi?
>   ÜRETİM    →  gerçek ihtiyaç, GRANT et
>   TEST      →  temizlik ayrıcalıklı bir bağlantıya taşınır, GRANT EDİLMEZ
> ```

---

# 2.9 · Saklama ve Uyum

> ⚠️ **Bu bölüm bir hukuk sorusu taşıyor.** Aşağıdaki kurallar kaynağın ne istediğini
> yazıyor; hangisinin gerçekten bağlayıcı olduğu ve hangi kayıtlara uygulandığı **hukuki
> görüş bekliyor.** Kaynak bir girdidir, bir hukuk mütalaası değil.

> ⚠️ **Kaynağın rakamı şüpheli** (2026-08-12). Kaynak **7 yıl** yazıyor ve gerekçesini
> *"Tax/audit requirements"* · *"Regulatory requirement"* diye veriyor — ama bilinen yerel
> süreler `VUK`'ta **5 yıl** (tarh zamanaşımına bağlı) ve `TTK`'da ticari defter/belgeler
> için **10 yıl.**
>
> `7` Türk mevzuatının bilinen rakamlarından değil; yabancı şablonların klasik değeridir.
> Yani kaynağın saklama bölümü büyük olasılıkla **yerelleştirilmemiş.**
>
> 📌 **Ölçüldü (2026-08-13) ve şüphe güçlendi:** kaynakta *"Vergi Usul"*, `VUK`, `TTK`,
> *"Tax Procedure"* terimlerinin **hiçbiri geçmiyor** — ne `docs/brd/`'de, ne süperseded
> PDF'lerde. Yani rakam yerel bir mevzuata **atıf bile vermiyor**; yalnız jenerik İngilizce
> bir gerekçe taşıyor (`Section_09_NFR.md`, saklama tablosu).
> **Pozitif kontrol:** aynı korpusta `7 yıl`/`7 year` taraması **6 eşleşme** verdi — tarama
> çalışıyor, terim gerçekten yok.
>
> Danışmana giden sorunun şekli buna göre değişti: *"7 yıl doğru mu"* değil — **"hangi kayıt
> sınıfımız hangi rejime girer?"**

**K-2.9.0** — ⏸️ **GEÇİCİ ASKI** (2026-08-12 → hukuki mütalaa).

Mütalaa gelene dek **hiçbir kayıt silinmez.** `K-2.9.2`'nin 90 gün kuralı **askıdadır** ve
uygulanmaz.

**Statü:** geçici muhafazakâr varsayım — bir varsayılan değil.

**K-2.9.0a** — ⚠️ Bu askı **tek yönlü muhafazakârdır:** vergi ve ticaret hukuku lehine,
kişisel veri mevzuatı aleyhine.

İki düzenleme zıt yönlere çeker:

| | Muhafazakârlık ne demek |
|---|---|
| Vergi / ticaret | **Uzun sakla** |
| Kişisel veri (amaçla sınırlılık) | **Gereğinden uzun tutma** |

> Gerekçe hukuki değil, **geri-alınabilirlik asimetrisi:** erken silme telafisizdir, fazla
> tutma düzeltilebilir.

**K-2.9.0b** — Askı **son kullanma tarihlidir.** Mütalaa geldiğinde revize edilir.

> ⚠️ Askı işareti olmadan bu kural altı ay sonra *"fiili davranışımız"* diye kalıcılaşır —
> `F12` deseninin saklama hâli.

## 2.9.1 Saklama süreleri

**K-2.9.1** — Kayıt türüne göre asgari saklama süreleri:

| Kayıt | Süre |
|---|---|
| Anlaşma · fatura · defter · denetim kaydı | 7 yıl |
| Onaylanmış plan · geçmiş satış verisi | 5 yıl |
| İçe aktarılan dosya arşivi | 90 gün |
| Dışa aktarılan çıktı | 7 gün |

**K-2.9.2** — Taslak planlar hareketsizlik sonrası silinebilir.

> ⛔ Bu bir **silme** kuralıdır ve `K-2.9.3` ile sınırı belirsiz. Bir taslak plan finansal
> kayıt mıdır? Muhtemelen değil, ama yazılı değil.

## 2.9.2 Silinmezlik

**K-2.9.3** — Finansal kayıt **kalıcı olarak silinemez.**

> ⚠️ **Bugün kazara sağlanıyor:** hiçbir şey silinmiyor çünkü silme mekanizması yok.
>
> **Kazara sağlanan bir kural korunmuyor demektir.** Bir temizlik ya da arşivleme işi
> eklendiği gün sessizce ihlal edilir, ve hiçbir test bunu yakalamaz — çünkü ihlali bir kod
> değişikliği değil, bir **veri işlemi** tetikler.

**K-2.9.4** — Arşive taşınmış bir kayıt **silinmiş sayılmaz** ve erişilebilir kalır.

## 2.9.3 Kişisel veri

**K-2.9.5** — Bir kullanıcı silindiğinde kimliği **anonimleştirilir**; denetim izi korunur
(`K-2.11.8`).

> ❌ Anonimleştirme mekanizması ölçülmedi. Bugün kullanıcı silme mantıksal (soft-delete),
> anonimleştirme yapılıp yapılmadığı bilinmiyor.

**K-2.9.6** — ✅ **Karar verildi** (2026-08-12). Planlamacı performansı raporu **süreç
metriği** olarak tanımlanır; kişi kimliği bir kırılım boyutu **değildir.**

Rapor şu soruları cevaplar: planlar ne kadar sürede onaylanıyor · hangi kategoride revizyon
oranı yüksek · hangi aşamada bekleme uzuyor.

> Gerekçe: kişi bazlı performans raporlaması kişisel veri mevzuatında özel dikkat isteyen bir
> **işleme amacı** taşır (*"performans değerlendirmesi"*), ve bir hakediş ürününün çekirdek
> değerine katkısı düşüktür.
>
> Ve sahadaki gerçek kullanım zaten **süreç seviyesindedir** — kişiye değil akışa bakar.

**K-2.9.6a** — Kişi bazlı versiyon **hukuk şartlı ertelendi.** Mütalaa gelirse açılabilir;
gelmezse ürün eksilmez.

## 2.9.4 Belge arşivi

**K-2.9.7** — Fatura ve benzeri belgeler **orijinal biçiminde** arşivlenir.

> ❌ Bugün böyle bir arşiv yok (`K-2.8.11`).

## 2.9.5 Otomasyon

**K-2.9.8** — Saklama sürelerinin **otomatik** uygulanması (arşivleme, temizlik) bir sonraki
faza aittir. Bugün süreler tanımlıdır, otomasyon yoktur.

**K-2.9.9** — Otomasyon eklendiğinde `K-2.9.3` bir **guard** ile korunmalıdır. Bugünkü kazara
sağlanma durumu o güne kadar kabul edilir, ama o gün geldiğinde yeterli değildir.

## 2.9.6 Hukuk paketi — danışmana giden üç soru

> Bunlar **kural değil**, mütalaa talebinin şeklidir. `K-2.9.0` askısı bu paket cevaplanınca
> kalkar. Kanonik takip: `docs/decisions/OPEN_DECISIONS.md` — [[T-170]] ailesi.

```
(a)  K-2.3.1 tanımı ekiyle: "muhasebe defteri olmayan, denetim-izi niteliğindeki
     kayıt VUK/TTK saklama rejimlerinden hangisine girer?"

     + "içe aktarılmış belge kopyaları (dış talep dayanakları) e-belge saklama
       yükümlülüğü doğurur mu, yoksa o yükümlülük ERP'de mi kalır?"

(b)  "Finansal etkisi doğmamış taslak kayıt 'ticari belge' midir?
      KVKK amaçla-sınırlılık gereği silinmesi zorunlu hale gelir mi?"

(c)  "Kişi bazlı performans raporunun şartları nedir?"   ← düşük öncelik
```

**Ve dördüncü kalem:** `7 yıl` rakamının kendisi. Sorunun şekli *"doğrulayın"* değil —
**"kaynağımız bu rakamı veriyor ve yerel bir mevzuata atıf vermiyor; hangi rejim geçerli?"**

> ⚠️ `(c)` düşük önceliklidir çünkü `K-2.9.6` **cevabı beklemeden** kapandı: rapor süreç
> metriği olarak tanımlandı. Mütalaa gelirse kişi bazlı versiyon açılabilir (`K-2.9.6a`);
> gelmezse ürün eksilmez. **Yani bu soru artık hiçbir işi bloklamıyor.**

---

# 2.12 · Ölçek ve Performans → **Ek A**

Bu bölüm L2'den çıkarıldı. Kapasite hedefleri, yanıt süreleri ve telemetri **işlevsel olmayan
gereksinimlerdir**; bir iş kuralı *"ne olmalı"* der, bunlar *"ne kadar hızlı, ne kadar
büyük"* der.

→ `BRD_V2_EK_A_NFR.md` · kurallar `NFR-1`…`NFR-13` olarak yeniden numaralandı.

**Not:** `2.9 Uyum` için aynı soru soruldu ve **cevabı farklı** — saklama süreleri *"veriye ne
olacağını"* söylüyor, yani bir iş kuralıdır. L2'de kalır.

---

# Kaynak haritası

| Bölüm | Bağlayıcı belge | Verilmiş karar | Ölçüm |
|---|---|---|---|
| 2.5 | `§3.4` · `§7.3` · `§7.7` | `ADR 0002-R` (revize) | `0024` · `0039` · `0041` |
| 2.6 | `§7.1` · `§7.2` · `§7.5` · `§2.6` | — | `0039` · `0040` · `0052` · `0056` |
| 2.9 | `§9.5` · `§9.8` · `§6.6` · `§7.7` | — | `0050` · `0062` |
| 2.12 | `§9.1` · `§9.2` · `§2.5` · `H1` | `ADR 0003` | `0043` · `0065` |

**Değişen:**
- `K-2.5.2` bütçe kaynaklı onayı onay motorundan ayırıyor — kaynak ikisini iki ayrı bölümde
  tanımlıyor ama ilişkiyi kurmuyor
- `K-2.6.13` (ayrıcalıksız bağlantı rolü) kaynakta yok; ölçümden doğdu ve izolasyonun ön
  koşulu

**Düşen:** kaynağın parola politikası ayrıntıları (uzunluk, süre, tekrar kullanım) bu
katmana alınmadı — bunlar bir kimlik doğrulama standardına aittir, iş kuralına değil.

**Okunmadı:** `Section_07 §7.6`'nın tamamı okundu (13 satır). `Section_09`'un `§9.5` ve
`§9.6`'sı kısmen.

---

# Açık kalanlar

> ⚠️ **Bu bölüm 2026-08-12'de kaldırıldı.** Açık kural listesi tek bir yerde yaşar:
> `00_PAKET_INDEKSI.md`. Bölüm sonlarında tutulan kopyalar karar turundan sonra **bayat**
> kaldı (dış denetim `F8`) — ve bayat bir durum listesi, olmayan bir listeden kötüdür.

| Kural | Neyi bekliyor | Tür |
|---|---|---|
| `K-2.5.10` | Zaman aşımı süresi ve sonrası | kapsam |
| `K-2.5.12` | Finans yöneticisinin onay yetkisi | **karar** — dayanağı düştü |
| `K-2.5.13` | Onay politikası modeli | kapsam |
| `K-2.6.4` | Rol kümesi | karar |
| `K-2.6.5` | Çok rollülük · yetki istisnası | kapsam |
| `K-2.6.8` | Kapsam ekseni (kategori ↔ bölge) | **domain** |
| `K-2.9.2` | Taslak silme ↔ silinmezlik sınırı | hukuk — ⏸️ `K-2.9.0` askısı altında |
| ~~`K-2.9.6`~~ | ~~Kişi bazlı raporlama~~ | ✅ **kapandı** 2026-08-12 |
| `NFR-3` | Veri ayrımı modeli | **teknik + maliyet** |
| `NFR-4` | Kapasite hedefi | kapsam |

---

# L2 tamamlandı — durum

| Bölüm | Durum |
|---|---|
| 2.1 Veri modeli · 2.2 Bütçe · 2.3 Defter · 2.4 Hesaplama | ✅ yazıldı, 6 kural açık |
| 2.7 Veri kalitesi · 2.8 Entegrasyon · 2.10 Bildirim · 2.11 Denetim | ✅ yazıldı, 2 kural açık |
| 2.5 Onay · 2.6 Yetki · 2.9 Uyum · 2.12 Ölçek | ✅ yazıldı, 10 kural açık |

**Toplam ~120 kural, 18'i açık.**

Açıkların dağılımı: 6 kapsam · 5 karar · 3 domain · 2 hukuk · 2 teknik.

Ve bu, `L1`'in (yetenek haritası) neden en son yazılacağının gerekçesi: yetenek haritası bu
kuralların özeti gibi çalışır, ve on sekiz açık kural onun üç bölümünü doğrudan etkiliyor.
