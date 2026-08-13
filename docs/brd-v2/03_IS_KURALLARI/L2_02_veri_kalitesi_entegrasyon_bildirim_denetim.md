# BRD v2.0 — L2 İş Kuralları (İkinci Küme)

> **Bölüm 2.7 · 2.8 · 2.10 · 2.11.** Çekirdeğin (2.1–2.4) devamı. Kalan dört bölüm
> (2.5 onay · 2.6 yetki · 2.9 uyum · 2.12 ölçek) açık kararlara bağlı.

- **Sürüm:** taslak, 2026-08-11
- **Kural numaralandırması:** `K-<bölüm>.<sıra>` — çekirdekle aynı uzay.

**İşaretler:** ✅ uygulanıyor · ⚠️ kısmen · ❌ uygulanmıyor · ⛔ karar bekliyor

---

# 2.7 · Veri Kalitesi

## 2.7.1 Veri sahipliği

**K-2.7.1** — Her veri alanının **tek bir sahip sistemi** vardır. Bu ürün, sahibi olmadığı
veriyi okur ve kullanır; **üzerine yazmaz.**

| Veri | Sahip | Bu üründe |
|---|---|---|
| Ürün ağacı, SKU, fiyat, maliyet | ERP | okunur |
| Müşteri listesi, kanal ataması | ERP / CRM | okunur |
| Gerçekleşen satış | ERP / POS | okunur |
| Plan, taktik, anlaşma, bütçe | **bu ürün** | yazılır |
| Hakediş, mutabakat, defter | **bu ürün** | yazılır |

**K-2.7.2** — Bir kaydın hangi sistemden geldiği kaydın kendisinde işaretlidir.

> ❌ Bugün böyle bir işaret yok. Ölçüldü: yönetim modülünde 39 yazma ucu var ve beşi
> kaynağa göre ERP'nin sahibi olduğu veriyi yazıyor. Bugün ihlal oluşmuyor — çünkü ERP
> bağlı değil.

## 2.7.2 Tazelik ve tamlık

**K-2.7.3** — Ana veri için beklenen kalite:

| Ölçüt | Beklenti |
|---|---|
| Tamlık | %100 — zorunlu alanlar dolu |
| Tazelik | ≤ 7 gün |
| Fiyat ve maliyet tazeliği | ≤ 1 gün |

**K-2.7.4** — İşlem verisi için beklenen kalite:

| Ölçüt | Beklenti |
|---|---|
| Tamlık | ≥ %95 |
| Gecikme | T+1 |
| Tutar toleransı | < %2 |

**K-2.7.4a** — ⚠️ **Satış tablosunda `net = brüt − indirim` kısıtı yazılmaz.**

Eşitlik ancak indirim alanı **tam köprü** olsaydı geçerliydi; ölçüm bunu eledi. Bir kısıt ya
doğru veriyi reddeder ya alanı anlamı dışına zorlar.

Yerine bir **akıl sağlığı kontrolü** (`net ≤ brüt`) ve veri sözlüğünde alanın **kaynağıyla
birlikte tanımı.**

> ⛔ Akıl sağlığı kontrolü de ölçüm şartlı: iade negatif satırla temsil ediliyorsa (`C2`:
> kanal açık, `0 CHECK`) o kural da düşer.

**K-2.7.5** — Bu eşikler bir **kabul kapısıdır**, bir temenni değil. Karşılanmadığında ürün
çalışmaya devam eder ama etkilenen göstergeler **açılmaz.**

> ⚠️ **Ölçülmüş durum:** bugünkü veri setinde 170 üründen 4'ünde maliyet var (%2,4).
> `K-2.7.3`'ün beklentisi %100 ve ≤1 gün. Yani kârlılık göstergeleri bugün açılmamalı —
> ve motor bunu doğru yapıyor (`K-2.4.4`), ama raporlama katmanı yapmıyor (`K-2.4.7`).

## 2.7.3 Bayat veriyle çalışma

**K-2.7.6** — Kaynak sistem erişilemez olduğunda ürün **son bilinen veriyle çalışmaya devam
eder.**

**K-2.7.7** — Bayat veriyle çalışıldığında bu **kullanıcıya söylenir**, verinin yaşıyla
birlikte.

> Örnek: *"Ürün verisi 2 saat önce güncellendi."*

**K-2.7.8** — Bayat veri **sessizce** kullanılamaz. Uyarı bir tercih değil, kuralın parçası.

## 2.7.4 Veri hazırlık kapısı

**K-2.7.9** — Kârlılık ve artımsallık göstergeleri, besleyen verinin kapsama oranına bağlı
olarak açılır:

| Mod | Ön koşul | Açılan |
|---|---|---|
| Harcama & Mutabakat | — | Bütçe kontrolü, tahakkuk, hakediş, plan-gerçekleşen |
| + Kârlılık | SKU maliyeti | Marj, brüt kâr |
| + Artımsallık | Geçmiş satış hacmi | Lift, kârlılık oranı |

**K-2.7.10** — Bir mod açılmadığında ilgili göstergeler **gizlenir**, hata üretmez.

> ✅ **Karar verildi** (2026-08-12, Oturum 3.9). Otomatik eşik yok; mod **manuel** açılır.

**K-2.7.11** — Bir modun açılması **tenant kararıdır**, bir kapsama eşiği değil.

> Gerekçe: gösterge rengi **plan başına bir güven beyanı**; mod açılması **tenant başına bir
> yetenek kararı.** İkisi farklı sorular.
>
> Mod için tam kapsama beklemek pratik değil — hiçbir müşteride her ürünün maliyeti
> olmayacak. Ama doğru ölçüt de bir oran değil, **kullanıcının niyetidir.**

**K-2.7.11a** — Mod açıldığında `K-2.4.22a`'nın `GRİ` mekanizması dürüstlüğü zaten taşır:
kapsama düşükse ekran **kendisi konuşur.**

> Böylece kaynaksız bir eşik sabiti **iki soruda da doğmaz.**

---

# 2.8 · Entegrasyon

## 2.8.1 ERP arayüzü

**K-2.8.1** — Ürün ERP'den dört tür veri okur:

```
müşteri listesi · müşteri detayı · ürün listesi · ürün detayı (fiyat, maliyet, birim)
```

**K-2.8.2** — Entegrasyon **çekme** modelidir: ürün zamanlanmış olarak sorar, ERP itmez.

**K-2.8.3** — ERP yanıt süresi bütçeleri → **`Ek A`** (`NFR-14`).

> Taşındı (2026-08-12, dış denetim): bu bir işlevsel olmayan gereksinimdir — `2.12`'nin
> taşınma gerekçesi buna da uygulanır.

**K-2.8.4** — ERP bağlı değilse ürün çalışır; ana veri elle yönetilir ve bu durum
işaretlidir.

## 2.8.2 Dosya içe aktarma

**K-2.8.5** — Dosya içe aktarma üç adımlıdır: **yükle → doğrula → onayla.** Doğrulama
sonuçları görülmeden kayıt yazılmaz.

**K-2.8.6** — Doğrulama **satır bazındadır.** Bir satırın geçersizliği diğerlerini
etkilemez.

**K-2.8.7** — Geçerli satırlar yazılır, geçersizler **reddedilir ve raporlanır.** Dosyanın
tümü yalnız **hiçbir satır geçerli değilse** reddedilir.

**K-2.8.8** — Her hata satırı dört bilgi taşır:

```
satır numarası · hata türü · hata mesajı · satırın ham hâli
```

**K-2.8.9** — Satır numarası, **kullanıcının dosyada gördüğü** numaradır. Boş satırlar
atlansa bile numaralandırma kaymaz.

> Gerekçe: *"248. satırda tarih hatalı"* diyen bir mesaj, kullanıcı 248. satıra baktığında
> geçerli bir tarih gösteriyorsa işe yaramaz.

**K-2.8.10** — Aynı dosyanın ikinci kez yüklenmesi **çift kayıt üretmez.** Tekrarlar
atlanır ve uyarı olarak raporlanır.

**K-2.8.11** — İçe aktarılan dosya **orijinal biçiminde saklanır.**

> ❌ Bugün böyle bir arşiv yok.

## 2.8.3 Sayı ve tarih biçimleri

**K-2.8.12** — İçe aktarma, yerel sayı biçimlerini tanır. Türkçe biçim (`1.234,56`) ve
İngilizce biçim (`1,234.56`) ikisi de kabul edilir.

**K-2.8.13** — **Belirsiz biçim tahmin edilmez, reddedilir.**

Bir ayraç, ondalık mı binlik mi olduğu belirlenemiyorsa (örneğin `1.234`) satır hata
üretir.

> Gerekçe: yanlış bir tahmin, doğru görünen yanlış bir değerdir. Ölçüldü: bu üründe
> tahmin eden bir ayrıştırıcı `1.000,00`'ı `1` olarak okuyordu.

**K-2.8.14** — Tarihlerde de aynı kural geçerlidir: `YYYY-AA-GG` ve `GG.AA.YYYY` kabul
edilir; eğik çizgili belirsiz biçimler (`3/4/26`) **reddedilir.**

> Gerekçe: `3/4/26` bir kullanıcı için 3 Nisan, diğeri için 4 Mart. Ölçüldü: tahmin eden
> bir ayrıştırıcı Türk kullanıcının tarihini bir ay kaydırıyordu.

**K-2.8.15** — Elektronik tablo dosyalarında hücre değerleri **ham biçimde** okunur,
görüntülenen metin olarak değil.

> Gerekçe: görüntü biçimi hücrenin sunumuna bağlıdır ve bilgi kaybettirir. Ölçüldü:
> görüntü metni okunduğunda `1.000` biçimli bir tamsayı reddediliyor, `GG.AA.YYYY` biçimli
> bir tarih ise ayrıştırıcıya ham seri sayı olarak ulaşıyordu.

## 2.8.4 Dışa aktarma

**K-2.8.16** — Rapor çıktıları üç biçimde alınabilir; her biçim için bir boyut sınırı
vardır.

**K-2.8.17** — Büyük çıktılar arka planda üretilir; hazır olduğunda kullanıcıya bildirilir.

**K-2.8.18** — Her çıktı dosyası **kendi bağlamını taşır**: uygulanan filtreler, üreten
kullanıcı, verinin tazelik zamanı.

**K-2.8.19** — Üretilen dosyalar sınırlı süre saklanır (7 gün). Bu, finansal kayıt saklama
kuralından (`2.9`) **ayrı** bir kuraldır ve onunla karıştırılmamalıdır.

## 2.8.5 Tablo köprüsü

**K-2.8.20** — Elektronik tabloya kopyala-yapıştır **birinci sınıf bir özelliktir**, bir
kaçış yolu değil.

> Gerekçe: sektörde kullanıcıların büyük çoğunluğu TPM ürününü tabloyla tamamlıyor.
> Bunu engellemek yerine yolunu açmak, geçişi kolaylaştırır.

---

# 2.10 · Bildirimler

## 2.10.1 Kapsam

**K-2.10.1** — Kullanıcıya bildirim gerektiren olaylar:

| Olay | Alıcı |
|---|---|
| Onay bekliyor | Onaylayacak kişi |
| Onaylandı / reddedildi | Gönderen |
| Onay gecikti (7 gün) | Onaylayıcı + gönderen |
| Onay hâlâ gecikiyor (14 gün) | Yönetici — bildirim, aksiyon değil |
| Bütçe uyarı eşiği aşıldı (%80) | Bütçe sahibi |
| Bütçe finans inceleme eşiği aşıldı (%90) | Finans |
| Bütçe blok eşiği aşıldı (%100) | Bütçe sahibi + finans |
| Anlaşma süresi doluyor | Anlaşma sahibi |
| Anlaşma tavanına yaklaşıldı (%90) | Anlaşma sahibi |
| İçe aktarma tamamlandı | Yükleyen |
| İçe aktarma başarısız | Yükleyen |
| Dışa aktarma hazır | İsteyen |
| Veri yenileme başarısız | Veri sorumlusu |

> ⚠️ **Kaynak bu listeyi eksik veriyor.** Bildirim spesifikasyonu altı olay sayıyor; paketin
> diğer bölümleri üç olay daha tarif ediyor ve sonuncusunun alıcısı spesifikasyonun rol
> kümesinde bile yok. Yukarıdaki liste dört kaynağın birleşimidir.

## 2.10.2 Kanallar

**K-2.10.2** — Bildirim iki kanaldan gider: **uygulama içi** ve **e-posta.** Kanal seçimi
olayın türüne göre yapılır, kullanıcı tercihine göre değil.

**K-2.10.3** — Aksiyon gerektiren bildirimler (onay bekliyor, zaman aşımı) her iki kanaldan
gider. Bilgilendirme amaçlı olanlar yalnız uygulama içi.

## 2.10.3 Yükseltme

**K-2.10.4** — Yükseltme merdiveni ve süreleri `K-2.5.10`'da tanımlıdır. Bu bölüm yalnız
**kanal ve alıcıyı** belirler.

> Kopya kaldırıldı (2026-08-12, dış denetim): merdiven iki yerde tanımlıydı ve buradaki
> **bayat** kalmıştı.

## 2.10.4 Bildirim ≠ durum değişikliği

**K-2.10.6** — Bir bildirim, bir durum değişikliğinin **sonucudur**, sebebi değil. Bildirim
gönderilememesi durum değişikliğini geri almaz.

**K-2.10.7** — Zaman aşımı bir **durum geçişidir**, bir bildirim ayrıntısı değil. Kurallar
`2.5`'te (onay) tanımlanır.

> Kaynağın bildirim spesifikasyonu 7 günlük otomatik zaman aşımını bir bildirim maddesi
> olarak yazıyor ve kendi tablosunda bunun yanlış yerde olduğunu kaydediyor.

---

# 2.11 · Denetim Kaydı

## 2.11.1 Kapsam

**K-2.11.1** — Denetim kaydı, sistemde yapılan **her anlamlı işlemin** kim tarafından, ne
zaman ve neye dayanarak yapıldığını tutar.

**K-2.11.2** — Kapsam, yönetici işlemleriyle sınırlı değildir. Aşağıdaki olay grupları
kaydedilir:

| Grup | Örnekler |
|---|---|
| Plan yaşam döngüsü | oluşturuldu · gönderildi · onaylandı · reddedildi · geri çekildi · silindi |
| Bütçe | zarf oluşturuldu · rezerve edildi · iade edildi · eşik aşıldı |
| Anlaşma | oluşturuldu · onaylandı · değiştirildi · kapandı |
| Veri | içe aktarıldı · dışa aktarıldı · yenilendi |
| Erişim | giriş · çıkış · yetki reddi |
| Konfigürasyon | eşik değişti · politika değişti · formül değişti · rol değişti |

> ❌ **Ölçülmüş sapma:** bugünkü kayıt tablosu adıyla ve alanıyla **yönetici odaklı**
> (`admin_audit_logs`, `admin_id`). Dev verisinde dört işlem türü görülüyor, ve tür için
> bir tanımlı küme yok.

**K-2.11.3** — Denetim kaydı bir özellik değil, bir **uyum gereksinimidir.** Kapsamı
regülasyonun gerektirdiği kadardır, ürün tercihi kadar değil.

## 2.11.2 İçerik

**K-2.11.4** — Her kayıt en az şunları taşır:

```
kim · ne zaman · hangi kayıt · hangi işlem · önceki değer · yeni değer · sonuç
```

**K-2.11.5** — Bir onay kaydı, **neye dayanarak** onaylandığını da taşır: onay anındaki
göstergeler ve eşikler.

> Gerekçe: göstergeler sonradan yeniden hesaplanabilir. Onay anındaki değer kaydedilmezse
> *"bu plan hangi rakama bakılarak onaylandı"* sorusu cevaplanamaz.
>
> ❌ Bugün bunun için bir alan var ama **hiçbir yazarı yok.**

## 2.11.3 Değişmezlik

**K-2.11.6** — Denetim kaydı **değiştirilemez ve silinemez.**

**K-2.11.7** — Bu, uygulama katmanında değil **veritabanı seviyesinde** korunur.

> ❌ Bugün böyle bir koruma ölçülmedi. Kural yazılı, mekanizması yok.

**K-2.11.8** — Bir kullanıcı silindiğinde kimliği anonimleştirilir; **ona atıf veren
denetim kaydı yaşamaya devam eder.**

## 2.11.4 Saklama

**K-2.11.9** — Denetim kaydı, finansal kayıtla aynı süre saklanır.

**K-2.11.10** — Belirli bir yaştan sonra arşive taşınabilir; arşivlenmiş kayıt **silinmiş
sayılmaz** ve erişilebilir kalır.

> ⚠️ Otomatik arşivleme bir sonraki faza ait. Bugün süreler tanımlı, otomasyon yok — ve
> hiçbir şey silinmediği için kural kazara sağlanıyor.
>
> **Kazara sağlanan bir kural korunmuyor demektir:** bir temizlik işi eklendiği gün sessizce
> ihlal edilir, ve hiçbir test bunu yakalamaz.

---

# Kaynak haritası

| Bölüm | Bağlayıcı belge | Ölçüm |
|---|---|---|
| 2.7 | `§6.1` · `§9.3` · `§6.6` | `0062` · `0057` |
| 2.8 | `§6.2` · `§6.4` · `§8.4` · `Sprint_0 AI-001` | `0015` · `0060` · `0062` |
| 2.10 | `Sprint_0 MC-002` · `§6.2` · `§6.6` · `§8.4` | `0060` · `0062` |
| 2.11 | `§7.4` · `§9.5` · `§9.8` | `0042` · `0050` |

**Değişen:**
- `K-2.10.1`'in olay listesi dört kaynağın **birleşimi** — tek bir kaynak eksik yazılmış
- `K-2.10.7` zaman aşımını bildirim bölümünden çıkarıp onay bölümüne veriyor; kaynağın
  kendi tablosu da bunu işaret ediyor
- `K-2.8.13/14` belirsiz biçimleri reddediyor; kaynak bu konuda sessiz, karar ölçüme dayalı

**Düşen:** kaynağın bildirim şablonları (metin içerikleri) bu katmana alınmadı — L2 hangi
olayın bildirileceğini tanımlar, metnini değil.

**Okunmadı:** `Section_06`'nın §6.3 ve §6.5'i; `0059` envanterinde gerekçesiyle listeli.

---

# Açık kalanlar

> ⚠️ **Bu bölüm 2026-08-12'de kaldırıldı.** Açık kural listesi tek bir yerde yaşar:
> `00_PAKET_INDEKSI.md`. Bölüm sonlarında tutulan kopyalar karar turundan sonra **bayat**
> kaldı (dış denetim `F8`) — ve bayat bir durum listesi, olmayan bir listeden kötüdür.

| Kural | Neyi bekliyor |
|---|---|
| `K-2.7.11` | Mod açılma eşiği — müşteri karması ölçümü |
| `K-2.5.10e` | Yükseltme merdiveni ve süreleri |

Ve dört bölüm hâlâ yazılmadı: **2.5 onay · 2.6 yetki · 2.9 uyum · 2.12 ölçek** — dördü de
açık karara bağlı.
