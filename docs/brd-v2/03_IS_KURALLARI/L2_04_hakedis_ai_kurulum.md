# BRD v2.0 — L2 İş Kuralları (Dördüncü Küme)

> **Yapı denetiminin çıktısı.** `L2_YAPI_DENETIMI.md` ölçtü ki on iki bölümün on ikisi de
> kaynağın gündeminden türemiş — ve konumlanmanın dört iddiasından ikisi hiç karşılık
> bulmuyor.
>
> Bu küme o boşluğu kapatıyor: **hakediş zinciri** (konumlanmanın çekirdeği), **AI sınırı**,
> ve **kurulum modeli.**

- **Sürüm:** taslak, 2026-08-12
- **Ve bir yapı değişikliği:** `2.12 Ölçek` bu katmandan çıkarıldı — işlevsel olmayan
  gereksinim (NFR), iş kuralı değil. Ayrı bir ek olarak yaşar.

**İşaretler:** ✅ uygulanıyor · ⚠️ kısmen · ❌ uygulanmıyor · ⛔ karar bekliyor

---

# 2.13 · Hakediş ve Mutabakat

> **Bu bölüm ürünün çekirdeğidir.** Konumlanma farklılaşmayı analitikte değil muhasebe
> doğruluğunda tanımlıyor, ve bu zincir o iddianın taşıyıcısı.
>
> ⚠️ **Kaynak bu konuda sessiz.** On bir kapsam listesi tarandı — *tanıma*, *hakediş*,
> *tahakkuk*, *mutabakat* hiçbirinde geçmiyor. Yani bu bölümün kuralları bir **yorum değil,
> yeni ürün kararları.**

## 2.13.1 Zincirin şekli

**K-2.13.1** — Hakediş zinciri beş adımdır:

```
Talep üretimi  →  Talep alımı  →  Eşleştirme  →  Mutabakat  →  Kapanış
   (biz)          (karşı taraf)                    (fark)      (dönem/anlaşma)
```

**K-2.13.2** — Her adım defterde iz bırakır. Bir adım atlanabilir ama **izsiz geçilemez.**

> **Ölçülmüş durum** (`0068`, 2026-08-12): birinci ve beşincinin bir yarısı var; ikinci,
> üçüncü, dördüncü yok.
>
> | Adım | Durum |
> |---|---|
> | Talep üretimi | ✅ dört uç, canlı arayüz, RBAC'li |
> | Talep alımı | ⚠️ tek yönlü — bizim kaydımız giriyor, karşı tarafın talebi değil |
> | Eşleştirme | ❌ kullanıcının girdiği bir alan, çıkarım değil |
> | Mutabakat | ❌ yok |
> | Kapanış | ⚠️ anlaşma ✅ (olgun, ama arayüzsüz) · dönem ❌ |

## 2.13.2 Talep nesnesi

**K-2.13.3** — Bir hakediş talebi **kendi kimliği olan bir kayıttır.** Bir anlaşmanın alanı
değildir.

> ❌ Bugün ayrı bir varlık yok; alanlar anlaşma üzerinde ve kod bunu kendi yorumunda
> kaydediyor.

**K-2.13.4** — Bir talep en az şunları taşır:

```
kaynak (biz / karşı taraf) · tutar · dönem · dayandığı anlaşma
durum · üretim/alım zamanı · dayanak belge
```

> ✅ **Karar verildi** (2026-08-12, Oturum 3.2.a). **Tek varlık**, `kaynak` ayrımıyla.

**K-2.13.5** — İç talep (bizim ürettiğimiz) ile dış talep (karşı tarafın gönderdiği) **tek
bir varlıktır.** Ayrım bir alandır: `kaynak: İÇ | DIŞ`.

> Gerekçe (ürün sahibi): mutabakatın çekirdek sorusu *"bizim hesabımıza göre doğan hakediş
> ile karşı tarafın kestiği tutar örtüşüyor mu"* — yani ikisi **aynı ekonomik olayın iki
> taraftaki görünümü.**
>
> Ayrı varlık yapılırsa eşleştirme, iki şemayı normalize eden bir ara katman ister — **ve o
> katman fiilen ortak talep modelidir.** Yani ayrı varlık seçeneği, tek varlığı bir
> dolaylama arkasında yeniden icat eder (`İlke 4`).

**K-2.13.5a** — Tek varlığın pratik kazançları: hakediş grain'i tek yerden tanımlanır,
`K-2.13.12a` tek tabloda denetlenir, raporlama birleştirme gerektirmez, dönem kapanışı tek
küme tarar.

**K-2.13.5b** — Doğrulama **kaynağa koşulludur**, ayrı şema değil:

| Kaynak | Zorunlu |
|---|---|
| `DIŞ` | Dayanak belge referansı |
| `İÇ` | Hesap izi referansı |

**K-2.13.5c** — Yetki de kaynağa koşulludur: içe aktarma yetkisi (`K-2.6.14`) `kaynak = DIŞ`
kaydı **yaratmaya** bağlıdır. Rol denetimi satır tipine bakar, tablo sayısına değil.

**K-2.13.5d** — Durumlar **tek enum**, geçiş tablosu **kaynağa duyarlıdır:**

```
DIŞ:  ALINDI    → EŞLEŞTİRİLDİ → KABUL EDİLDİ | REDDEDİLDİ | İTİRAZLI
İÇ:   ÜRETİLDİ  → GÖNDERİLDİ   → KARŞILANDI
```

**K-2.13.5e** — ⚠️ Geçersiz kombinasyonlar (örneğin `İÇ` + `İTİRAZLI`) geçiş tablosunda
**yoktur.** Şemada değil, sözleşmede engellenir ve testle korunur.

**K-2.13.5f** — ⚠️ **Eşleştirme ayrı bir bağ varlığıdır**, talebin bir alanı değil.

```
eşleştirme:  iç talep referansı ↔ dış talep referansı
             fark · karar · karar veren · zaman
```

> İki talebi tek satıra sıkıştırma cazibesi **reddedilir.** `1:1` varsaymak yanlıştır:
> gerçekte bir dış kesinti **birden çok** iç talebe — ya da **hiçbirine** — denk düşebilir.
>
> Tablo tek, ama satırlar **taraf başına ayrı.**

**K-2.13.5g** — ⚠️ Geçiş sırası: iç talep üretimi bugün `agreement_transaction` olarak
çalışıyor. Yeni varlık doğarken **iç talepler yeniden yazılmaz** — üretim ucu, çıktısını yeni
varlığa **da** yazacak şekilde genişler.

> `agreement_transaction` **finansal iz** olarak kalır; yeni varlık **mutabakat nesnesidir.**
> İki kavram karışmamalıdır.

## 2.13.3 Karşı taraf perspektifi

**K-2.13.6** — Dışarıdan gelen bir talep sisteme **kabul edilmeden önce** girer. *"Gelen ama
henüz karşılanmamış"* bir durumdur.

> ❌ **Bugün böyle bir durum yok.** Bir satır ya yazılıyor ya reddediliyor — ve sisteme giren
> şey karşı tarafın talebi değil, bizim kaydettiğimiz fatura satırı. **Akış tek yönlü.**
>
> Bu, konumlanmanın işaret ettiği en büyük açıklık.

**K-2.13.7** — Gelen bir talep durumları:

```
ALINDI → EŞLEŞTİRİLDİ → KABUL EDİLDİ
   ↓           ↓              ↓
REDDEDİLDİ  İTİRAZLI      (kapanışa girer)
```

**K-2.13.8** — Reddedilen veya itirazlı bir talep **silinmez.** Karşı tarafla yürütülen
tartışmanın kaydıdır.

**K-2.13.9** — Bir talebin karşılanmaması bir **iş sonucudur**, bir hata değil. Sistem onu
bir durum olarak taşır.

## 2.13.4 Eşleştirme

**K-2.13.10** — Eşleştirme sistemin işidir, kullanıcının değil. Gelen bir talep, mevcut
anlaşmalar ve gerçekleşen harcamalar üzerinden **çıkarılır.**

> ❌ Bugün eşleştirme bir **girdi alanı**: yükleyen kişi anlaşma kimliğini dosyaya kendisi
> yazıyor. Tek otomatik ilişkilendirme bir tekrar kontrolüdür — idempotency, eşleştirme
> değil.

**K-2.13.11** — Eşleştirme ölçütü (grain) tek bir yerde tanımlıdır ve tüm yollarda aynıdır.

> ✅ **Karar verildi** (2026-08-12, Oturum 3.2.b). Kademeli daralan tek merdiven.

**K-2.13.12** — Eşleştirme **üç kademeli** çalışır:

```
Kademe 1   karşı taraf referansı (anlaşma no / talep no)   → varsa doğrudan
Kademe 2   dönem + müşteri + kategori + kanal              → aday kümesi
Kademe 3   eşleşmeyen                                      → kuyruk
```

**K-2.13.12c** — Kademe 2'nin grain'i **hakediş grain'iyle aynıdır** — iç talepler zaten o
grain'de doğuyor.

> Daha dar bir ölçüt (fatura seviyesi) karşı tarafın vermediği bir kırılımı bekler: ciro
> primi kesintisi çoğunlukla **dönem toplamı** gelir, fatura kırılımı istisnadır.
>
> Daha geniş bir ölçüt (kanalsız) aynı müşterinin iki kanalını karıştırır.
>
> **Üretim grain'i = eşleştirme grain'i** — `İlke 4`'ün veri karşılığı: tek tanım, tek yer.

**K-2.13.12d** — ⚠️ **Otomatik kesinleşme tekillik ister.**

| Aday sayısı | Davranış |
|---|---|
| 1, tolerans içinde | Otomatik eşleşir |
| 1, tolerans dışında | Kuyruğa düşer |
| >1 | **Otomatik seçim yapılmaz** — kuyruğa, adaylarıyla birlikte |

> Gerekçe: **yanlış eşleşme, eşleşmemekten pahalıdır.** Eşleşmeyen talep kuyrukta
> **görünür**; yanlış eşleşen talep dönem kapanışına **gömülür.**
>
> Sistem geniş ölçütle bulur, ama belirsizlikte karar vermez — **karar insanındır**, ve
> `K-2.13.12a` zinciri orada işler.

**K-2.13.12e** — Kademe 1'in referans alanı içe aktarma şablonunda **opsiyoneldir**, ve
hangi karşı tarafın referans verdiği **ölçülür.**

> Eşleşme oranı raporu, kiminle *"referans anlaşması"* yapılacağını söyler — bu teknik değil,
> **ticari** bir kaldıraç.

**K-2.13.12a** — ⚠️ **Görev ayrılığı:** bir hakediş belgesini içe aktaran kişi, o belgenin
eşleştirmesini **onaylayamaz.**

> `K-2.5.11`'in ayna görüntüsü. İkisi birlikte bir görev ayrılığı ailesi kuruyor:
>
> ```
> planı gönderen  ≠  onaylayan
> belgeyi sokan   ≠  eşleştirmeyi kapatan
> ```
>
> ✅ Karar verildi (2026-08-12, Oturum 1.5). Bu invariant, içe aktarma yetkisinin
> planlamacıya açılmasının **ön koşuludur** (`K-2.6.14`).

**K-2.13.12b** — Her içe aktarma kaydı **köken bilgisi** taşır: kim, ne zaman, hangi dosya
(içerik özeti dahil).

> Gerekçe: `K-2.13.12a` ancak köken kaydediliyorsa denetlenebilir. Ve şema bugün ucuz —
> deploy öncesi.

**K-2.13.13** — Eşleşmeyen bir talep **kaybolmaz.** Eşleşmeyenler bir kuyrukta toplanır ve
elle çözülür.

**K-2.13.14** — Tolerans **ikili bir eşiktir:** `oran %X` **ve** `mutlak Y` — **küçük olan
bağlar.**

> Gerekçe: tek başına oran, büyük tutarlı bir ciro priminde saçma para affeder
> (`%1 × 5M = 50K`). Tek başına mutlak değer, küçük bir talepte her farkı kuyruğa atar.

**K-2.13.14a** — Eşik **tenant konfigürasyonudur** ve `K-2.2.8a` tablosuna komşudur.

**K-2.13.14b** — Varsayılan **dar başlar:** `%0,5 + 250 TL` mertebesinde, ilk müşteride
kalibre edilir.

> Dar başlamak bilinçli: otomatik kabul edilen bir fark **sessizce gider olur.**
> Genişletmek kolay; geri almak — müşteriye *"artık bunu kabul etmiyoruz"* demek — zordur.

**K-2.13.14c** — Veri kalitesi toleransı (`K-2.7.4`) **devralınmaz.** O bir veri kalite
eşiğidir, bir mutabakat toleransı değil.

**K-2.13.14d** — ⚠️ **Tolerans içi fark yok olmaz, yazılır.**

Otomatik kabul edilen fark, deftere **ayrı bir kalem** olarak düşer.

> `Σ` korunur, ve denetçi *"kabul edilen farkların toplamı"*nı tek sorguyla görür.
>
> Sessizce yutmak, sessiz sıfırın **para hâli** olurdu.

## 2.13.4a Taktik gerçekleşmesi ve atıf

> ✅ **Karar verildi** (2026-08-12, Oturum 3.2.c). Atıf **kanıt merdiveniyle** yapılır;
> orantısal dağıtım reddedildi.

**K-2.13.14e** — ⚠️ **Taktik gerçekleşmesi dış talepten türetilmez, kendi kanıtından
hesaplanır.** Dış talep bir **doğrulamadır**, bir veri kaynağı değil.

> Bu, actuals-first ilkenin doğrudan sonucu. *"Gelen toplamı taktiklere nasıl bölüştürürüz"*
> sorusu yanlış kurulmuş bir sorudur — dış talebi doğruluk kaynağı sayar.

**K-2.13.14f** — Her mekanik bir **kanıt sınıfı** taşır:

| Sınıf | Nasıl hesaplanır | Örnek |
|---|---|---|
| `GÖZLENEN` | Satır satır kayıtta var | Fatura-içi indirim |
| `TÜRETİLEBİLİR` | Oran × gerçekleşen hacim | Birim başı destek |
| `SÖZLEŞMESEL` | Dönem koşulu sağlandıysa tamamı doğar | Götürü raf kirası |

**K-2.13.14g** — Kanıt sınıfı **mekanik tanımının bir alanıdır.** Yeni bir mekanik
eklenirken atıf davranışı **otomatik olarak belli olur.**

> Ve bu, serbest biçimli taktiğin neden reddedildiğinin bir kanıtı daha (`K-2.5.13c`
> ailesi).

**K-2.13.14h** — Sistem her taktik için **bağımsız** bir gerçekleşme üretir. Toplam, dış
talep tutarıyla karşılaştırılır.

### Türetilebilir sınıfın tabanı

> ✅ **Karar verildi** (2026-08-12, Oturum 3.3). Varsayılan **net satış**; taban mekanik
> tanımının açık bir alanı.

**K-2.13.14h1** — Oran bazlı mekanikler **tutara**, birim bazlı mekanikler **hacme**
uygulanır. Ayrım serttir.

**K-2.13.14h2** — ⚠️ Hacim verisi yoksa birim bazlı bir mekanik **tanımlanamaz.** Sessizce
tutara dönüşmez.

**K-2.13.14h3** — Oran bazlı mekaniklerin tabanı bir **alandır:** `taban: BRÜT | NET`.
Varsayılan **NET**.

> Gerekçe (ürün sahibi) — üç kat:
>
> **Çifte sayım.** `%5` ciro primini brüt üzerinden hesaplarsan, fatura-içi `%5` indirimin
> uygulandığı ciroya **bir kez daha** prim ödersin. Aynı promosyon parası iki mekanikten iki
> kez doğar.
>
> **Karşı tarafla hizalanma.** Ciro primi sözleşmelerinin fiili standardı net fatura
> tutarıdır, ve karşı tarafın kesintisi neredeyse her zaman net üzerinden gelir.
>
> **Eşleştirme verimi.** Brüt tabanlı bir iç talep, net tabanlı dış kesintiyle **her dönem
> fark üretir** ve `K-2.13.12`'nin kuyruğunu şişirir. Bu bir muhasebe zarafeti değil,
> motorun verimi.

**K-2.13.14h4** — Taban **mekanik tanımında** yaşar, plan satırında değil.

> Plan başına taban seçtirmek `İlke 1` ihlali; mekanik başına tanımlamak `İlke 3`'ün kendisi.

**K-2.13.14h5** — ⚠️ Alanın **var olması** gerekli, çünkü gerçek sözleşmelerde brüt tabanlı
oran da yazar (nadir ama var).

> Bunu ifade edemeyen bir sistem, kullanıcıyı **oranı elle bozarak** tabanı taklit etmeye
> iter — `%3` yerine `%3,15` yazmak gibi.
>
> **Hesap doğru görünür, denetim izi yalan söyler.**

**K-2.13.14h6** — `NET` tanımı: `brüt tutar − fatura-içi indirim`. ⛔ **Tanım hangi ALANI
gösteriyor — açık** (ölçüldü 2026-08-13).

> ⛔ **Bu bir formül sorusu değil, bir alan sorusu.** `sales_actuals` üç tutar taşıyor ve
> ortadakinin ne olduğu yazılı değil:
>
> ```
> gross_amount     brüt satış
> discount_amount  ?   ← satış iskontosu mu, TOPLAM indirim mi
> net_amount       net satış
> ```
>
> Entity `discountAmount`'ı *"satış iskontosu"* diye adlandırıyor ve **bütçeye/ledger'a asla
> yazılmadığını** söylüyor. Öyleyse `brüt − net` ondan **büyük** olabilir — aradaki fark
> başka bir indirim türüdür, ve `NET = brüt − indirim` **yanlış alanı** gösteriyor demektir.
>
> **Ölçüm (pilot verisi, tümü):** `net ≠ brüt − indirim` → **3/3 satır**, en büyük fark
> `25.000`, toplam `63.000` (brütün %5-6'sı, yuvarlama değil).
>
> ⚠️ **%100 sapma bir veri kalitesi sorunu değil, bir MODEL UYUŞMAZLIĞI işaretidir.** Bir
> kısıt yazmadan önce üç alanın ilişkisi tanımlanmalı — yoksa kısıt veriyi değil, yanlış
> modeli sabitler.

> ⛔ **İade davranışı açık.** Öneri: iadeler düşülür (gerçek net ciro) — karşı taraf primi
> iade sonrası bakiye üzerinden keser.
>
> ✅ **Veri temsili artık ÖLÇÜLDÜ** (`C2`, 2026-08-13): iade için **alan yok, tip yok,
> işaret sözleşmesi yok** — ama negatif satır kanalı **açık ve sessiz** (gramer `-?\d+`,
> pozitiflik kontrolü yok, `0 CHECK`, probe kabul etti). Kardeş yollarda (on-invoice ·
> off-invoice) pozitiflik kuralı **var**; `sales-actuals` dışında.
>
> Yani formülü bloklayan şey artık *"ölçülmedi"* değil, **karar**: kanal kapatılacak mı,
> yoksa negatif işaret bir sözleşme mi olacak → [[T-208]].

> ⛔ **İade davranışı açık.** Öneri: iadeler düşülür (gerçek net ciro) — karşı taraf primi
> iade sonrası bakiye üzerinden keser.
>
> Ama iadenin veride nasıl temsil edildiği (negatif satır mı, ayrı alan mı) **ölçülmedi** ve
> formül ondan önce yazılmaz.

**K-2.13.14h7** — ⚠️ `net = brüt − indirim` ilişkisi **veri girişinde doğrulanır**
(`K-2.7` ailesi).

> Üç alan bağımsız geliyorsa tutarsız bir üçlü sessizce hesaba girer — ve taban kararının
> bütün titizliği kirli veriyle boşa düşer.

**K-2.13.14i** — ⚠️ **Açıklanamayan kalıntı hiçbir taktiğe dağıtılmaz.**

Fark, eşleşme kaydında **açık bir kalem** olarak durur (`FARK`), deftere taktiksiz /
anlaşma seviyesinde bir satır olarak düşer, ve raporda görünür.

**K-2.13.14j** — ⚠️ **Invariant:** `Σ(taktik gerçekleşmeleri) + FARK = dış talep tutarı`.

**K-2.13.14k** — Farkın çözümü **insanın işidir** — ya tolerans içinde kapanır
(`K-2.13.14d`), ya bilinçli olarak bir taktiğe yazılır. **Sistem asla tahmin etmez.**

> ❌ **Orantısal dağıtım reddedildi.** Bir `%96` çarpanı üç taktiğe de *"gerçekleşti"*
> damgası vurur, ve o uydurma sayılar üç yere birden akar: zarf kapanışı, gelecek dönem
> planlaması, taktik kârlılığı.
>
> **Hassas görünen çöp üretir** — ve *"hangi taktik işe yaradı"* sorusuna **güvenle yanlış**
> cevap verir. Analitik katmanda bir sessiz tahmindir.

**K-2.13.14l** — ⚠️ **Şema düzeltmesi:** fatura-içi kayıtlara `anlaşma referansı` eklenir.

> Gözlenen kanıtın anlaşmaya bağlanamaması, merdivenin **ilk basamağını kör** bırakıyor.
> Deploy öncesi ucuz; sonra göç acısı.

## 2.13.5 Mutabakat

**K-2.13.15** — Bir talep ile bizim kaydımız arasında fark varsa, fark **kaydedilir ve
sınıflandırılır.**

**K-2.13.16** — Fark sınıfları en az üç tanedir:

| Sınıf | Anlamı |
|---|---|
| Zamanlama | Aynı harcama, farklı dönem |
| Tutar | Aynı harcama, farklı tutar |
| Kapsam | Bizde karşılığı olmayan bir talep |

**K-2.13.17** — Farkın kapanışı bir **karar kaydıdır**: kim, ne zaman, hangi gerekçeyle
kabul etti veya reddetti.

**K-2.13.18** — Mutabakat sonucu deftere yazılır. Kabul edilen bir fark bir düzeltme kaydı
üretir (`K-2.3.5`).

## 2.13.6 Kapanış

**K-2.13.19** — İki kapanış vardır ve **karıştırılmamalıdır:**

| Kapanış | Neyi kapatır |
|---|---|
| Anlaşma kapanışı | Bir anlaşmanın yaşam döngüsü |
| Dönem kapanışı | Bir muhasebe döneminin hareketleri |

**K-2.13.20** — Kapatılmış bir anlaşmaya yeni hakediş yazılamaz.

> ✅ Uygulanıyor ve olgun: eşzamanlılık koruması, iki ayrı çakışma kontrolü, çift-sayma
> koruması, rezervasyon iadesi, iki uçtan uca test.
>
> ❌ **Ama hiçbir ekrandan çağrılamıyor.** Bir anlaşmayı kapatmak bugün yalnız doğrudan
> API çağrısıyla mümkün. Mekanizma tamamlanmış, yüzeyi yok.

**K-2.13.21** — Kapatılmış bir döneme yeni hareket yazılamaz. Dönem yeniden açılabilir; bu
bir yetki gerektirir ve denetim kaydı bırakır.

> ❌ Dönem kapanışı yok.

**K-2.13.22** — Kapanış **geri alınabilir olmalıdır.** Kapatma bir silme değil, bir durum
değişikliğidir.

**K-2.13.22a** — Kapanışta **kalan bakiye serbest bırakılır**, yeni döneme taşınmaz
(`K-2.2.9r`).

> ⚠️ Bu cümle yazılmazsa kapanış kodu fiili bir devir davranışı icat eder. Devir Faz 1 dışı
> (`K-2.2.9q`) ve geldiğinde bu serbest bırakmanın yerini bir politika alır.

## 2.13.7 Tahakkuk

**K-2.13.23** — Uzun dönemli anlaşmalar aylık tahakkuk eder, dönemsel olarak hesaplaşır.

**K-2.13.24** — Tahakkuk **tüketim değildir.** Ayrı bir kova ya da sistemin kapsamı dışıdır.

> Gerekçe: kaynak tüketimi *"fatura kaydedildiğinde"* tanımlıyor. Tahakkuk fatura öncesidir,
> dolayısıyla o kovaya giremez.

> ✅ **Karar verildi** (2026-08-12, Oturum 3.5). **Operasyonel** tahakkuk bizim işimiz;
> muhasebe tahakkuku ERP'nin.

**K-2.13.25** — Sistem **operasyonel tahakkuk** yazar: dönemsel yükümlülüğün birikimi.
**Muhasebe tahakkuku** (yevmiye kaydı) yazmaz.

> Sınır testinin cevabı iki soruyu ayırmakta:
>
> | Soru | Sahibi |
> |---|---|
> | *"Bu ay hangi yükümlülük doğdu, muhasebeye ne yazılmalı?"* | ERP |
> | *"Bu anlaşmadan bugüne ne birikti, dönem sonunda karşı taraf ne kesecek?"* | **Biz** |
>
> İkincisi **mutabakatın kendisidir:** `K-2.13.12` dönem sonunda gelen kesintiyi bir iç
> birikimle karşılaştırıyor — **o birikim operasyonel tahakkuktur.**
>
> Dönemsel kadanslı bir ciro priminde iç talep dönem sonunda bir kerede *doğmaz*; her ay
> satış gerçekleştikçe **birikir.** Bu birikimi tutmayan bir hakediş ürünü, kendi çekirdek
> sorusuna dönem ortasında cevap veremez.
>
> Ve *"ERP'nin işi"* demenin görünmez maliyeti: hedef segmentte ERP'de bu bilinç yok —
> dolayısıyla tahakkuk **tablonun işi** olur, ve gölge dosya geri gelir.

**K-2.13.25a** — `TAHAKKUK` **ayrı bir kovadır**, tüketim değil:

```
TAHSİS → REZERVE → TAHAKKUK → TÜKETİM
```

Tahakkuk, rezervasyonun gerçekleşmeye yaklaşan hâlidir — ama fatura veya talep
kesinleşmeden tüketime dönüşmez.

**K-2.13.25a1** — ⚠️ **Zincir bir dönüşümdür, bir birikim değil.**

Bir tahakkuk yazıldığında karşılık gelen rezervasyon **aynı işlemde azalır:**

```
DOĞUŞTA    REZERVE ↓   TAHAKKUK ↑     Σ etkisi nötr
KAPANIŞTA  TAHAKKUK ↓  TÜKETİM ↑      eşleşen kısım
           TAHAKKUK ↓  (serbest)      fazlası
```

> **Düzeltme (2026-08-12, `F5` yan sonucu):** `K-2.2.5` kullanılabilirlik formülüne tahakkuk
> terimi eklendiğinde bir **çift düşüm riski** doğdu. İki model mümkündü:
>
> | Model | Sonuç |
> |---|---|
> | **Dönüşüm** | Rezervasyon azalır, tahakkuk artar — aynı para bir kez düşer |
> | Bağımsız | İkisi birlikte durur — ⚠️ **aynı para iki kez düşer** |
>
> Dönüşüm seçildi, ve gerekçesi simetridir: kapanıştaki çözülme kuralı (`K-2.13.25b`) zaten
> bir dönüşümdür. Doğuşta da öyle olmalıdır.

**K-2.13.25a1b** — ⚠️ **Tahakkuk zorunlu bir durak değil, koşullu bir aradır.**

```
PERIODIC kadans:   REZERVE → TAHAKKUK → TÜKETİM
SINGLE   kadans:   REZERVE →─────────→ TÜKETİM
```

Tek hesaplaşmalı bir anlaşma **hiç tahakkuk etmez.**

> Bu cümle yazılmazsa uygulama zinciri **harfiyen** okur ve tek hesaplaşmalı anlaşmalara
> **sıfır tutarlı bir geçiş tahakkuku** icat eder — bu oturumda dokuz kez ölçülen *"karar
> yazılmayınca kod bir varsayılan uydurur"* sınıfı.

**K-2.13.25a1c** — ⚠️ **Tahakkuk rezervi aşabilir, ve akış durmaz.**

Bir tahakkuk yazıldığında kalan rezervasyon tüketilir. **Aşan kısım rezervsiz tahakkuk
olarak yazılır** ve `K-2.2.7c` ailesince işaretlenir.

> Gerekçe: satış planı aşarsa — ciro primi tabanı beklenenden hızlı büyürse — aylık tahakkuk
> bir noktada tüketecek rezerv bulamaz. Ve doğru davranış karar ailesinde zaten var:
> **gerçekleşme durmaz, borç doğmuştur.**
>
> İki yanlış alternatif:
>
> | Alternatif | Neden yanlış |
> |---|---|
> | Tahakkuku sessizce kırpmak | **Sessiz kırpma, yanlış katmanda** — kırpma tavanda çalışır (`K-2.2.17`), rezervde değil |
> | Rezervi negatife düşürmek | `Σ` nötrlüğü bozulur, kova anlamını kaybeder |

**K-2.13.25a1d** — Rezervsiz tahakkuk zarf kullanılabilirliğini **ek olarak düşürür**
(`K-2.2.5`). Bu doğru davranıştır — ama **bilinçlidir**, bir yan etki değil.

> Ve `K-2.13.25a2` invariantı bundan etkilenmez: tavan kontrolü ayrı bir katmandır ve kırpma
> orada çalışır.

**K-2.13.25a2** — ⚠️ **Invariant:** bir anlaşma için

```
REZERVE + TAHAKKUK + TÜKETİM ≤ anlaşma tavanı
```

> Üç kova aynı ekonomik yükümlülüğün üç aşamasıdır; toplamları tavanı aşamaz. Ve tavan
> aşımı davranışı `K-2.2.17`'de tanımlıdır — kırpma + açık kalem.

**K-2.13.25b** — Dönem kapanışında tahakkuk **çözülür:** eşleşen kısım tüketime çevrilir,
fazla tahakkuk serbest bırakılır.

**K-2.13.25c** — ⚠️ **Invariant:** dönem kapanışında **açık tahakkuk = 0.**

**K-2.13.25d** — Tahakkuk hesabı, iç talep üretiminin **aynı motorudur** (`İlke 4`).

Aylık tahakkuk = o ayın kanıt merdiveni hesabı (`K-2.13.14f`). **Ayrı bir tahakkuk formülü
yazılmaz** — aynı hesap, ara dönemde tahakkuk üretir, dönem sonunda talep.

> Tek hesap yolu, iki çıktı tipi.

**K-2.13.25e** — Sistem bir **tahakkuk raporu** verir (dönem / anlaşma / zarf kırılımıyla,
dışa aktarılabilir). Muhasebe yevmiye kaydını **o rapordan** atar.

> İleride bir ERP entegrasyonu bu raporu taşır; ama **yevmiye üretimi hiçbir fazda bizim
> işimiz olmaz.**

**K-2.13.25f** — Ürün sınırı cümlesi (`K-2.3.1` ailesi) şöyle netleşir:

> *"Operasyonel tahakkuk tutarız; muhasebe tahakkuku ERP'de oluşur ve girdisi bizim
> raporumuzdur."*

> ⚠️ **Sıralama:** davranış zamanlayıcı katmanına biner (`K-2.5.10f`, aylık iş) ve kanıt
> merdiveni hesabını gerektirir. Doğal yeri **eşleştirme katmanıyla aynı dalga** — ondan
> önce değil.
>
> Şema hazır: `accrual_schedule` (`K-2.1.14`) ve `TAHAKKUK` tipi (`K-2.3.14`).

## 2.13.8 Zincirin bütünlüğü

**K-2.13.26** — Zincirin her adımı **geriye izlenebilir** olmalıdır: bir kapanıştan
mutabakata, oradan eşleştirmeye, oradan talebe ve dayanak belgeye.

**K-2.13.27** — Bir hakediş tutarı, dayandığı hesaplamayla birlikte saklanır. Sonradan
yeniden hesaplama, kaydedilmiş tutarı değiştirmez.

> Gerekçe: hesaplama girdileri (fiyat, maliyet, kur) zamanla değişir. Kaydedilmiş bir
> hakediş, kaydedildiği andaki gerçeği taşır.

---

# 2.4.8 · Deterministik sınır (AI)

> Konumlanma AI konusunda net bir ayrım yapıyor: **analitik AI reddedilir, kenar AI
> benimsenir.** Ve sınırı tek cümlede: *"LLM asla para hesaplamaz."*
>
> Bu bölüm o sınırı kurala çeviriyor. `K-2.4.2`'nin (analitik alan çıktısı para olarak
> kalıcılaştırılamaz) doğal kardeşi.

**K-2.4.28** — Para hesabı **deterministik motorda** yapılır. Bir dil modeli veya olasılıksal
bileşen, kalıcılaşacak bir para değeri **üretemez.**

**K-2.4.29** — AI bileşenleri **öneri** üretir. Bir öneri, açık insan onayı olmadan
kalıcılaşmaz.

> Bu, mevcut çalışma disiplinimizin aynısıdır: AI hiçbir şeyi otomatik birleştirmez.

**K-2.4.30** — Bir AI bileşeni denetim izini **okuyabilir, yazamaz.** Açıklama üretmek bir
okuma işlemidir.

**K-2.4.31** — AI bileşenleri izolasyon ve yetki katmanının **üstünde** çalışır. Bir asistan,
onu çağıran kullanıcının göremediği veriyi göremez.

> Sıralama bağlayıcıdır: **önce izolasyon, sonra asistan.** Bir AI özelliği, izolasyon
> katmanı yokken devreye alınamaz.

**K-2.4.32** — Bir AI çıktısının kaynağı işaretlidir. Kullanıcı, bir değerin insan tarafından
mı girildiğini yoksa önerilip onaylandığını mı ayırt edebilmelidir.

**K-2.4.33** — Üç kenar tanımlıdır ve dışına çıkılmaz:

| Kenar | Ne yapar | Ne yapmaz |
|---|---|---|
| Alım asistanı | Dış hakediş belgesini yapıya çevirir | Tutarı hesaplamaz, eşleştirmeyi karara bağlamaz |
| Açıklama katmanı | *"Bu rakam neden böyle"* sorusunu denetim izinden cevaplar | Rakamı yeniden hesaplamaz |
| Kurulum asistanı | Mevcut veriden konfigürasyon önerir | Konfigürasyonu yürürlüğe koymaz |

---

# 2.14 · Kurulum ve Varsayılanlar

> Konumlanma kurulum modelini bir **konumlanma aracı** ilan ediyor: *"ön-konfigüre bir
> başlangıç paketi bir özellik değil."*
>
> Ve bir ölçüt öneriyor: boş bir kurulumdan ilk onaylanmış plana **≤ 1 iş günü.**

## 2.14.1 Başlangıç paketi

**K-2.14.1** — Yeni bir kurulum **boş doğmaz.** Aşağıdakiler hazır gelir:

```
mekanik kütüphanesi · gösterge tanımları · onay şablonları
rapor seti · varsayılan eşikler · rol tanımları
```

**K-2.14.2** — Başlangıç paketi bir **örnek** değil, çalışan bir varsayılandır. Müşteri onu
değiştirmeden kullanabilmelidir.

**K-2.14.3** — Paket içeriği ürünle birlikte sürümlenir. Bir müşterinin paketi güncellenirse
bu bir **konfigürasyon değişikliğidir** ve denetim kaydı bırakır.

## 2.14.2 Zorunlu konfigürasyon

**K-2.14.4** — Kurulumda atlanamayan adımlar **açıkça listelidir** ve her biri bir gerekçe
taşır.

**K-2.14.5** — Bir adımın zorunlu olması için tek geçerli gerekçe: **varsayılanı olamaz.**

> Örnek: ürün ağacı ve müşteri listesi zorunludur — müşteriye özgüdür, varsayılanı olamaz.
> Eşikler zorunlu değildir — bir varsayılanı vardır.

**K-2.14.6** — Zorunlu adım sayısı bir **ölçüttür** ve azaltılması bir hedeftir.

## 2.14.3 Varsayılan sorgulaması

**K-2.14.7** — Her yeni konfigürasyon alanı şu testten geçer: **"bunun bir varsayılanı
olabilir mi?"**

- Olabiliyorsa → varsayılan tanımlanır, alan opsiyonel olur
- Olamıyorsa → gerekçesi `2.14.2`'ye yazılır

**K-2.14.8** — Bir alan, *"ileride gerekebilir"* gerekçesiyle konfigüre edilebilir yapılmaz.
Ayarlanabilirlik **kanıtlanmış ihtiyaç** üzerine eklenir.

> Bu, konumlanmanın *"konfigürasyon platformu değiliz"* reddinin kural hâli.

## 2.14.4 Veri yükleme

**K-2.14.9** — İlk veri yüklemesi ürünün **kendi araçlarıyla** yapılabilir. Harici bir
komut, veritabanı erişimi veya danışman müdahalesi gerektirmez.

**K-2.14.10** — Eksik veriyle kurulum tamamlanabilir. Eksiklik ilgili modu kapatır
(`K-2.7.9`), kurulumu engellemez.

## 2.14.5 Kurulum ölçütü

**K-2.14.11** — Kurulum başarısı **ölçülür:** boş bir kurulumdan ilk onaylanmış plana geçen
süre.

**Hedef:** ≤ 1 iş günü (veri yüklemesi dahil, kullanıcı eğitimi hariç).

> ⚠️ Hedef değeri doğrulanmadı — ilk gerçek kurulumda ölçülecek. Tutmazsa **hedef revize
> edilir, ölçüt değil.**

**K-2.14.12** — Bu ölçüt her sürümde yeniden ölçülür. Artan bir kurulum süresi bir
gerilemedir.

---

# Yapı değişikliği · `2.12 Ölçek` L2'den çıkarıldı

**Gerekçe:** kapasite hedefleri, yanıt süreleri ve telemetri **işlevsel olmayan
gereksinimlerdir.** Bir iş kuralı *"ne olmalı"* der; bunlar *"ne kadar hızlı, ne kadar
büyük"* der.

Karışması, iş kuralı arayan birinin performans hedefleri okumasına yol açıyor — ve L2 bir
referans belgesi.

**Yeni yeri:** `BRD v2 · Ek A — İşlevsel Olmayan Gereksinimler.`

İçeriği değişmiyor; `NFR-1`–`NFR-13` numaralarını koruyarak taşınır ve `NFR-*` olarak
yeniden numaralandırılır.

**Not:** `2.9 Uyum` için aynı soru soruldu ve **cevabı farklı** — saklama süreleri *"veriye ne
olacağını"* söylüyor, yani bir iş kuralıdır. L2'de kalır.

---

# Kaynak haritası

| Bölüm | Kaynak | Not |
|---|---|---|
| 2.13 | ⚠️ **kaynak yok** — 11 kapsam listesi tarandı | Ölçüm: `0068` · TTM modeli referans olabilir |
| 2.4.8 | ⚠️ **kaynak yok** | Konumlanma §2.5 · §4 |
| 2.14 | ⚠️ **kaynak yok** | Konumlanma §5 · rakip analizi |

**Üçünün de kaynağı yok** — ve bu tesadüf değil. Yapı denetimi tam olarak bunu ölçtü:
kaynağın gündeminde olmayan hiçbir şey L2'de bir bölüm bulamamıştı.

**Değişen:** `2.3.8` (hakediş zinciri, geçici olarak defter bölümünde) `2.13`'e taşındı.
`2.3` yalnız defter mekaniğini anlatıyor.

---

# Açık kalanlar

> ⚠️ **Bu bölüm 2026-08-12'de kaldırıldı.** Açık kural listesi tek bir yerde yaşar:
> `00_PAKET_INDEKSI.md`. Bölüm sonlarında tutulan kopyalar karar turundan sonra **bayat**
> kaldı (dış denetim `F8`) — ve bayat bir durum listesi, olmayan bir listeden kötüdür.

| Kural | Neyi bekliyor | Tür |
|---|---|---|
| `K-2.13.5` | İç ve dış talep aynı varlık mı | **domain** |
| `K-2.13.12` | Eşleştirme ölçütü | **domain** |
| `K-2.13.14` | Tolerans sınırı | kapsam |
| `K-2.13.25` | Tahakkuk sistemin işi mi | **domain** |

Dördü de `SORULAR A3`/`A6`'ya bağlı — ve `A3`'ün cevabı bu bölümün yarısını belirliyor.

---

# L2 · güncel durum

| Bölüm | Durum |
|---|---|
| 2.1 · 2.2 · 2.3 · 2.4 | ✅ 6 kural açık |
| 2.5 · 2.6 · 2.9 | ✅ 8 kural açık |
| 2.7 · 2.8 · 2.10 · 2.11 | ✅ 2 kural açık |
| **2.13 Hakediş · 2.4.8 AI · 2.14 Kurulum** | ✅ 4 kural açık |
| ~~2.12 Ölçek~~ | → Ek A (NFR) |

**14 bölüm, ~145 kural, 20'si açık.**

Ve konumlanmanın dört iddiası artık **dördü de** karşılık buluyor:

| İddia | Karşılık |
|---|---|
| 1 · Hakediş çekirdek | `2.13` — kendi bölümü, 27 kural |
| 2 · Veri olgunluğu | `2.7.4` + `K-2.14.10` |
| 3 · Kurulum modeli | `2.14` — kendi bölümü |
| 4 · AI sınırı | `2.4.8` — altı kural |
