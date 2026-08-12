# Dış Denetim Adayları — Kayıt

> Bağımsız bir inceleme 18 dosyayı okudu ve 18 bulgu çıkardı. **Her bulgu bir adaydı**;
> uygulanması ayrı bir karardı.
>
> Bu dosya hangi bulgunun ne olduğunu kaydeder — kabul, ret, ertelendi, ya da ölçüm
> bekliyor.

- **İnceleme tarihi:** 2026-08-12
- **Karar tarihi:** 2026-08-12
- **Dayanak türü:** her bulguda kaynağın kendi işaretlemesi korundu
  (*ölçülmüş* / *metinden okunmuş* / *gerekçeli-doğrulanamaz*)

---

## Özet

| Durum | Sayı |
|---|---|
| ✅ Uygulandı | 12 |
| 🔬 Ölçüm bekliyor | 4 |
| 📋 Domain kararı olarak kuyruğa | 1 |
| ⏸️ Ertelendi | 1 |
| ❌ Reddedildi (kısmi kabul) | 1 |

> **Güncelleme (2026-08-12):** `F12` ertelemeden **uygulanana** geçti (kapsamı yumuşatılmış
> hâlde), ve bu turda **bir yeni ölçüm doğdu** (`Ö4`).

**Üçü bağımsız olarak doğrulandı** (`F2`, `F5`, `F7`) — iddia kabul edilmeden önce ölçüldü.

---

# ✅ Uygulananlar

## F1 · Paketteki `L0`, denetlenen `L0` değildi

**Dayanak:** metinden okunmuş — kesin.

Pakete eski bir konumlanma sürümü konmuştu; ürün sahibinin altı revizyonu (AI duruşu, ilk
pazar, sadelik ölçütü, statü mekanizması, güncel istatistikler) **pakette yoktu.**

Ve sonucu ciddiydi: `L2`'nin iki bölümü (`2.4.8` AI sınırı, `2.14` kurulum) **pakette
bulunmayan bir belgeye** dayanıyordu.

**Yapıldı:** `v2` pakete alındı; sonraki turların hakediş ölçümü ve terim düzeltmesi
(*"yetenek kademesi"*) ona işlendi.

> ⚠️ **Bu bulgu bir süreç kusurunu gösteriyor:** iki sürüm paralel yaşadı ve hangisinin
> kanonik olduğu yazılı değildi. Aynı sınıf bu oturumda kodda sekiz kez ölçülmüştü.

## F2 · `K-2.6.5a` iki farklı kurala verilmişti

**Dayanak:** ölçülmüş — bağımsız olarak doğrulandı (satır 273 ve 312).

*"Bir kural bir kez yazılır"* ilkesinin ihlali — ve **sessiz geçersiz kılmanın en tehlikeli
formu**, çünkü atıf çözümlemesi okuyana göre değişiyordu.

**Yapıldı:** içe aktarma kararı `K-2.6.14` oldu; üç atıf düzeltildi, kalan çakışma **0**.

## F3 · Bekleyen planın rezervasyonu — iki kural ailesi çelişiyordu

**Dayanak:** metinden okunmuş — kesin çelişki.

`K-2.2.9i` *"bekleyen plan rezervasyon yazmaz"* diyordu; `K-2.5.7` *"reddedilen planın
rezervasyonu iade edilir"* diyordu. İkisi de aynı durumdan çıkış.

**Yapıldı:** `K-2.5.7` yeniden yazıldı — bekleyen planın **bütçe kaydı yoktur**, iade yalnız
onaylanmış bir planın geri alınmasında oluşur. `GERİ ÇEKİLDİ` durumu makineye eklendi.

⚠️ **Ve bir yan sonuç:** `B4`'ün (zaman aşımı) gerekçelerinden biri *"durum ve defter yazan
bir iş, tehlikeli"*ydi. Çelişki temizlenince o bacak düştü — **bekleyen plan bütçe yazmadığı
için finansal risk zaten yoktu.** Karar değişmedi, gerekçesi sadeleşti.

## F4 · Sapma envanteri eksik ve yanlış sınıflıydı

**Dayanak:** metinden okunmuş — kesin.

*"Beş bilinçli sapma"* sayılmıştı. Ama `A9` bir sapma değil **kaynağa dönüştü**, `A3.c` ise
kaynağın sessiz olduğu bir alanda **yeni karardı.** Ve listede olmayan üç sapma vardı.

**Yapıldı:** tek bir **kaynak ilişkisi tablosu** yazıldı, dört türle: sapma · kaynağa dönüş ·
kaynak sessiz · ekleme. On iki madde sınıflandırıldı.

> ⚠️ Bu, **`ADR 0006` deseninin kendi kayıtlarımızdaki tekrarı:** bir sınıflandırma
> ölçülmeden yazıldı.

## F5 · Defter taksonomisi tüketimi ve tahakkuku taşıyamıyordu

**Dayanak:** ölçülmüş — bağımsız olarak doğrulandı.

Altı işlem tipinde `TÜKETİM` yoktu — ama `D.1` *"her ok bir defter kaydıdır"* diyor ve tüketim
oku çiziyor. Ve `TAHAKKUK` **yanlış eksende** duruyordu (harcama tipi enum'unda).

**Yapıldı:** işlem tipi **sekize** çıktı (`TAHAKKUK`, `TÜKETİM` eklendi), `TAHAKKUK` harcama
tipinden çıkarıldı, üç açık kalem türü `DÜZELTME` alt türü olarak tanımlandı, ve `K-2.2.5`
kullanılabilirlik formülüne **tahakkuk terimi eklendi.**

## F6 · Kadans taşıyıcısı belirsizdi

**Dayanak:** metinden okunmuş — kesin.

`settlement_cadence` hem anlaşma hem mekanik alanı gibi okunabiliyordu, ve **karışık kadanslı
bir anlaşmanın davranışı tanımsızdı.**

**Yapıldı:** kadans **mekanikte yaşar**; anlaşma davranışı türetilir — *"herhangi bir mekaniği
dönemsel ise anlaşma dönemsel hesaplaşır."*

## F7 · *"Rezervasyon"* kelimesi iki bölümde iki anlamda

**Dayanak:** ölçülmüş — bağımsız olarak doğrulandı.

`2.5` jenerik kullanıyordu, `2.2` spesifik: plan onayı **TAAHHÜT**, anlaşma onayı **REZERVE**.

> Ve bu, `K-2.2.6`'nın *"ölçülmüş ihlal"* dediği kova karışıklığının **belge içindeki
> tohumuydu.**

**Yapıldı:** `2.5` yeniden kelimelendirildi, ayrım bağlayıcı olarak yazıldı.

## F8 · Bayat durum metaverisi

**Dayanak:** metinden okunmuş — kesin.

Açık kural sayısı dört yerde dört farklıydı; bölüm sonu listeleri karar turundan sonra bayat
kalmıştı.

**Yapıldı:** tek kanonik durum bloğu `00_PAKET_INDEKSI`'ne taşındı ve **script ile
sayılıyor.**

> ⚠️ **Ve sayım bir sürpriz verdi:** paket boyunca `~120`/`~145`/`~160` yazılmıştı; gerçek
> sayı **337.** İki katından fazla — ve bu, elle tutulan sayıların bayatlaması sınıfının bu
> oturumdaki beşinci vakası.

## F9 · İndeks dosya adlarıyla çelişiyordu

**Yapıldı:** `L2` dosyaları `L2_01`…`L2_04` önekine alındı, indeks düzeltildi.

## F10 · *"Standart"* şablonun yükselme ifadesi belirsizdi

**Yapıldı:** şerh eklendi — yükselme yalnız `FINANCE_REVIEW = ONAY` modunda bir onay adımı;
varsayılan modda bir bildirim.

## F11 · Girilen değerin iki temsili

**Dayanak:** metinden okunmuş — kesin.

Giriş FU'da, ama *"girilen"* kolonları **SKU seviyesinde** duruyordu — eski modelin kalıntısı,
ve `İlke 4`'ün veri hâli.

**Yapıldı:** `K-2.1.11a` eklendi — tek temsil FU'da, SKU'da yalnız hesaplanan değer.

## Ek: fazlalık düzeltmeleri

`K-2.8.3` (ERP yanıt süreleri) → `Ek A` · `K-2.10.4/5` yükseltme merdiveni kopyası kaldırıldı,
`K-2.5.10`'a atıf verdi.

---

# 🔬 Ölçüm bekleyenler

## F14 · Planın organizasyon bağlantısı şemada görünmüyor

`planlar` tablosunda müşteri/kanal alanı yok — ama taahhüt, zarfı (kanal × kategori × dönem)
çözmek zorunda.

**Ölçüm:** gerçek şemada bu bağ nerede? Yoksa zarf çözümlemesi tanımsız.

## F16 · `TÜRETİLEBİLİR` sınıf bugünkü veriyle hesaplanamaz

`sales_actuals.hacim` yok — ve `A2`'nin dağıtım tabanı da **SKU kırılımlı** satış verisi
istiyor.

**Ölçüm:** gerçek şemada SKU kırılımı var mı, hacim var mı? İkisi de yoksa hem birim bazlı
mekanikler hem dağıtım kuralı bugün beslenemez.

> Bu, mevcut `C2`/`C3` ölçümlerinin komşusu — aynı sorguda yapılabilir.

## F13 · Para birimi ve KDV sessiz

**Dayanak:** FMCG deneyimi — gerekçeli, doğrulanamaz.

Tek para varsayımı hiçbir kuralda yok. Ve KDV: dış kesinti belgeleri fiiliyatta KDV'li gelir
— **eşleştirme toleransını doğrudan etkiler.**

**Ölçüm önce:** mevcut veride tutarlar KDV dahil mi hariç mi?

---

# 📋 Domain kararı olarak kuyruğa

## F15 · Eşleştirme grain'i dış talebin gerçek şekliyle çelişiyor olabilir

**Dayanak:** gerekçeli, doğrulanamaz — ilk gerçek kesinti dosyasıyla sınanır.

`K-2.13.12c` gerekçesi *"kesinti çoğunlukla dönem toplamı gelir"* diyor, ama Kademe 2 grain'i
**kategori** içeriyor. Perakendecinin belgesi bizim kategori hiyerarşimizi bilmez.

**Bulgu değerli ve `A3.b`'yi revize ediyor.**

⚠️ **Ama önerilen çözüm tekillik kuralını zayıflatıyor:** *"kategorisiz talepte aday =
müşterinin tüm kategorileri"* dersek, tipik vakada aday sayısı > 1 olur ve `K-2.13.12d` gereği
**her şey yine kuyruğa düşer** — yalnız farklı sebeple.

**Karar:** bir domain sorusu olarak kuyruğa alınır, ve **gerçek bir kesinti dosyasıyla**
ölçülmeden cevaplanmaz.

---

# ⏸️ Ertelenenler

## F12 · Dönem bir varlık değil

Doğru bulgu — `donemler` tablosu yok, ve dönem kapanışı kapatılacak bir kayıt gerektiriyor.

~~**Ertelendi:** dönem kapanışı Faz 2'de; varlık o dalgada tanımlanır. Bugün eklemek,
kullanımı olmayan bir tablo üretir.~~

> 🔄 **Erteleme geri alındı** (2026-08-12, ürün sahibi kararı).
>
> **Gerekçe:** dönem zaten **üç yerde referans** — zarf boyutu, hakediş grain'i, kapanış
> konusu. Bugün muhtemelen bir metin ya da enum alanı, ve bu bir **modelleme boşluğu.**
> Ve şema penceresi açık.
>
> **Kapsam yumuşatıldı:** tablo + backfill + **nullable** yabancı anahtar bu dalgada;
> `NOT NULL` bir sonraki dalgada, ön koşulu bir ölçüm (*"boş referans kaldı mı"*) —
> `K-2.6.13` deseni.
>
> ⚠️ Eski karar **silinmedi**, yanlışlandığı iziyle duruyor (`ADR 0006-R` deseni). İki
> kaydın altı ay sonra çelişmesi bu şekilde önlenir.

## F17 · `A9`'un revizyon gerekçesi var olmayan bir akışa dayanıyor

Durum makinesi `ONAYLANDI`'dan revizyon geçişi tanımlamıyor.

**Ertelendi:** plan revizyon akışı ayrı bir kapsam sorusudur. `A9`'un gerekçesinden o cümle
şimdilik **zayıflamış olarak** duruyor — silinmedi, çünkü kararın diğer bacakları ayakta.

---

# ❌ Reddedilen

## Fazlalık ekseni · `K-2.5.15` (zorunlu onay gerekçesi) kaldırılsın

**Öneri:** gerekçe rette zorunlu, onayda opsiyonel olsun — çünkü zorunlu gerekçe pratikte
*"ok."* metinleri üretir.

**Ret gerekçesi:** bulgu haklı ama çözüm eksik. Asgari uzunluk sabiti gerçekten kaynaksız ve
**o kaldırılmalı** — ama gerekçe alanının kendisi görev ayrılığı zincirinin parçası. `C4`
kararında ölçüldü ki bypass **daraltıldı, kapanmadı**, ve telafisi denetim izidir.

**Kısmi kabul:** asgari uzunluk kısıtı düşer, gerekçe zorunlu kalır.

---

# 🔬 Bu turda doğan yeni ölçümler

> Dış denetimin bulgusu değil — **bulguları işlerken doğdular.** Ayrı işaretleniyorlar
> çünkü kaynakları farklı: `F`'ler dışarıdan geldi, `Ö`'ler kendi kararlarımızın yan
> çıktısı.

## Ö4 · Dönem alanlarının biçim tutarlılığı

**Doğuşu:** `F12`'nin kapsamı yumuşatılırken soruldu — *"zarf.dönem ile satış.dönem aynı
biçimde mi?"*

**Sınıfı:** ⚠️ **bloklamayan ama şekillendiren.** Yabancı anahtar zorunluluğunu değil
(o zaten ertelendi), **backfill planının şeklini** değiştiriyor:

```
biçimler tutarlı    → tek jenerik backfill
biçimler ayrışık    → tablo başına eşleme kuralı
```

**Ölçüm paketine:** `C1`–`C3` + `F13`/`F14`/`F16` ile aynı oturum. Hepsi tek sorgu sınıfı.

---

# Yöntem notu

Bu incelemenin en değerli üç bulgusu (`F1`, `F2`, `F4`) **bizim kendi ilkelerimizin
ihlalleriydi** — ve üçü de bu oturumda kodda defalarca ölçtüğümüz sınıflardan:

```
F1   iki sürüm paralel yaşadı, kanonik olan yazılı değildi
F2   bir kimlik iki şeye verildi
F4   bir sınıflandırma ölçülmeden yazıldı
```

> **Kendi ölçüm disiplinimizi kendi belgelerimize uygulamamıştık.** Dış bakış onu buldu, ve
> bu bir yöntem dersi: bir kurala uymak ile o kuralın kendi çıktına uygulandığını
> **doğrulamak** ayrı işlerdir.
