# Karar Turu — Beş Konu · Kayıt Bloğu

- **Tarih:** 2026-08-12
- **Karar veren:** ürün sahibi
- **İki blok:** karar defteri (kararlar) · `CLAUDE.md` (yöntem)

> Ayrım bilinçli: **karar defteri neyi seçtiğimizi tutar, `CLAUDE.md` nasıl seçtiğimizi.**
> Bu turda üç ilke bu turun ötesinde geçerli çıktı; onlar kararla birlikte gömülmemeli.

---

# BLOK 1 · Karar defteri

## KT-1 · Kimlik alanı boşaltılamaz

**Soru:** `submittedById` bir yolda `NULL`'a çekiliyor — kusur mu, kasıtlı mı?

**Karar:** ayrım gereksiz. **Kimlik alanı asla boşaltılmaz** — her iki senaryoda da doğru
davranış aynı.

**Gerekçe:** *"henüz gönderilmedi"* bir **durum** bilgisidir ve zaten `TASLAK` olarak
şemada var. Kimlik alanını boşaltmak, durum makinesinin işini bir köken kolonuna taşımaktır.

Ve boşaltılan alan, `C4`'te daraltılan bypass'ı **sıfır maliyetle** yeniden açar:
`NULL ≠ onaylayan → kontrol geçer`.

**Ölçüm yine de istenir** — farklı soruya cevap veriyor: kural *"ne olmalı"*yı çözdü, ölçüm
*"neyi sökeceğiz"*i söyleyecek. Boşaltmayı kaldırmak başka bir varsayımı kırabilir (bir
arayüz *"gönderen"* etiketini `TASLAK` durumda gösteriyorsa artık eski gönderen görünür —
doğru davranış, ama görünür değişiklik).

**Kurallar:** `K-2.5.16` · `K-2.5.16a` · `K-2.5.16b`
**Task:** `T-205` — iki kalem: bağlam ölçümü (kod okuma) + kuralın uygulanması
**Dalga:** `S13` ile aynı — ikisi de `INV-T-002` kapsam tanımının **veri ayakları**

---

## KT-2 · `A2`'nin dağıtım tabanı — ölçüm önce

**Soru:** gerçekleşen satış verisi SKU kırılımı ve hacim taşımıyor, ve bu **kayıtlı bir
tasarım kararı.** `A2` yeniden mi açılsın?

**Karar:** hayır — **önce o kararın sınıfı ölçülür.** `A2` ölçüm sonuçlanana kadar
yürürlükte.

**Gerekçe:** `A2`'yi ölçümsüz sarsmak, `F4`'te yakalanan sınıfın kendisi olur — kaynak,
rakip analizi ve kendi kararımız aynı hizada.

**Ölçüm üç sonuçtan birine gider:**

| Sınıf | Etkisi |
|---|---|
| Kaynak sınırı (ERP vermiyordu) | `A2` ayakta; kolon eklenir, kaynak gelince dolar |
| **Pilot profili kararı** | Karar tenant profiline iner (`İlke 5`); ürün kuralı `A2`'dir |
| Gerçek domain kararı | `A2`'nin tabanı yeniden karara gider — **ancak bu kanıtla** |

⚠️ **Ölçüm sorusu genişledi:** *"gerekçe ne diyor"* + **"ne zaman, hangi müşteri bağlamında,
hangi kısıt altında verildi"** (`git blame` + commit bağlamı).

> İkinci ihtimal en muhtemeli: o entity başlığı muhtemelen pilot döneminde yazıldı.

**İki teknik not:**

**Ara dönem dürüst.** Kolonlar eklense bile geçmiş veri yoktur; `A2`'nin merdiveni bunu
karşılıyor (tarih yok → eşit pay + bayrak). Yani kural **ölü değil, bekleyen** kod — aciliyet
düşük.

**Fatura-içi kayıtlar taban olamaz.** SKU taşıyor, ve *"veri zaten var"* kestirmesine davet
ediyor. Ama yalnız fatura-içi mekaniğe giren ürünleri kapsıyor — **kısmi kapsama, dağıtım
payında sistematik yanlılık** üretir (`K-2.4.22`'nin aynı argümanı).

**Kural:** `K-2.1.8a1`
**Task:** `T-206`
**Ve `B` dalgası etkisi:** `F16` kaleminin kendisi bu ölçüme bağlı — kolon eklemek bir
**karar geri alışıdır** ve `F12` deseniyle kaydedilir. `T-206` `B` dalgası onayının ön
koşuluna terfi etti.

---

## KT-3 · Hukuk paketi — **dört** soru

**Karar:** dört soru **tek paket** olarak hukuka gider; **hiçbiri işi bekletmez.**

> ### ⚠️ Bu başlık `üç` diyordu — bayattı, ve `0071` derlemesi yakaladı (2026-08-15)
>
> Belgenin kendi içinde iki farklı sayı vardı:
>
> ```
> :80  / :82   "üç soru"     ← ilk yazım
> :301         "dört soru"   ← özet tablosu
> ```
>
> **Doğrusu `dört`** (ürün sahibi, 2026-08-15). Dördüncüsü aşağıdaki `7 yıl`
> doğrulamasıdır ve *"üç"* ilk yazımdan kalmıştır — `7 yıl` bulgusu **sonradan
> eklendi**, ve bir **soru** olarak değil bir **şüphe** olarak yazıldığı için
> sayıma girmedi.
>
> ⚠️ **Ama pakete girmesi ZORUNLU: `(a)`'nın çerçevesini o belirliyor.** Hangi
> kayıt sınıfının hangi rejime girdiği bilinmeden `(a)`'nın askısı ne zaman
> kalkacağı da bilinemez.
>
> 📌 **Ders:** bir şüphe olarak yazılan şey, bir soru olarak sayılmaz — ve
> gönderilecek pakete girmez. Eksik gönderilen bir sorunun cevabı **aylar sonra**
> aranır. `CLAUDE.md`: *"bir sayı listesiyle anılır ya da hiç anılmaz."*

### ⚠️ Ve bir bulgu: kaynağın `7 yıl`ı muhtemelen yanlış

Kaynak *"Vergi Usul"* diyerek `7 yıl` yazıyor. Ama bilinen yerel süreler `VUK`'ta **5 yıl**
(tarh zamanaşımına bağlı), `TTK`'da ticari defter/belgeler için **10 yıl.**

`7` Türk mevzuatının bilinen rakamlarından değil — **yerelleştirilmemiş bir şablonun** klasik
değeri.

> *(gerekçeli, doğrulanamaz — hukukçu teyidi şart)*

**Sorunun şekli değişti:** *"7 yıl doğru mu"* değil — **"hangi kayıt sınıfımız hangi rejime
girer?"**

### `(a)` / `(b)` — geçici askı

Mütalaa gelene dek **hiçbir kayıt silinmez**; `K-2.9.2`'nin 90 gün kuralı **askıda.**

⚠️ **Tek yönlü muhafazakârlık:** vergi/ticaret lehine, kişisel veri aleyhine. İki düzenleme
zıt yönlere çeker.

**Gerekçe hukuki değil, geri-alınabilirlik asimetrisi:** erken silme telafisizdir, fazla
tutma düzeltilebilir.

**Ve askı işareti şart** — yoksa altı ay sonra *"fiili davranışımız"* diye kalıcılaşır
(`F12` deseninin saklama hâli).

### `(c)` — hukuku beklemeden bloktan çıkarıldı

Planlamacı performansı raporu **süreç metriği** olarak yeniden tanımlandı; kişi kimliği bir
kırılım boyutu **değildir.**

> Sahadaki gerçek kullanım zaten süreç seviyesinde — *"planlar ne kadar sürede onaylanıyor,
> hangi kategoride revizyon oranı yüksek."* Kişiye değil akışa bakar.
>
> Kişi bazlı versiyon hukuk şartlı ertelendi: gelirse açılır, **gelmezse ürün eksilmez.**

### Danışmana giden paket

```
(a)  K-2.3.1 tanımı ekiyle: muhasebe defteri OLMAYAN, denetim-izi niteliğindeki
     kayıt VUK/TTK rejimlerinden hangisine girer?
     + içe aktarılmış belge kopyaları e-belge saklama yükümlülüğü doğurur mu,
       yoksa o yükümlülük ERP'de mi kalır?

(b)  Finansal etkisi doğmamış taslak kayıt "ticari belge" midir?
     KVKK amaçla-sınırlılık gereği silinmesi zorunlu hale gelir mi?

(c)  Kişi bazlı performans raporunun şartları nedir?        ← düşük öncelik

+    "7 yıl" rakamının doğrulanması
```

**Kurallar:** `K-2.9.0` · `K-2.9.0a` · `K-2.9.0b` · `K-2.9.6` (değişti) · `K-2.9.6a`

---

## KT-4 · Beşinci statü reddedildi — adres standardı

**Soru:** `L2`'ye *"karar verildi, ön koşulu yok"* statüsü eklensin mi?

**Karar:** ❌ **hayır.** Bunun yerine `❌`/`⚠️` işaretleri bir **adres** taşır.

**Gerekçe:** bir bağımlılık statüsü **doğası gereği başka bir işin tamamlanmasıyla bayatlar**
— ve onu güncellemek kimsenin görevi olmaz. Bu, `F8`'in matematiksel garantisi olurdu.

Mevcut dört statü **olgu** bildiriyor; beşincisi bir **bağımlılık** bildirirdi. Ve
bağımlılıklar statik işaretlerle değil, **çözülme mekanizmasıyla** izlenir.

> `EK_E`'nin `🔒`'ü istisna gibi görünüyor ama değil: o tablo her sprint sonunda sayılan
> **canlı bir envanter** — bakımı sürecin parçası. `L2` kural gövdesinin öyle bir ritmi yok.

**Standart — tek kalıp, iki adres türü:**

```
ön koşulu BİLİNEN karar     → dalga / issue referansı
ön koşulu ÖLÇÜLECEK karar   → ölçüm referansı
```

**Uygulama:**

| Vaka | Adres | Neden |
|---|---|---|
| `C4` (görev ayrılığı) | `B` dalgası `S13` + `T-205` | Ön koşul biliniyor |
| `A2` (dağıtım tabanı) | `T-206` ölçümü | Dalga kaleminin **kendisi** ölçüme bağlı |

⚠️ `A2`'ye dalga adresi yazmak, ölçümün sonucunu **önceden yargılamak** olurdu.

**Üç kazanç:** okuyucu *"bu çalışıyor"* sanamaz ve ne zaman çalışacağını görür · `B` dalgası
`kabul-8`'e ek (*"kapattığı işaretleri `✅`'ya çevirir"*) ile güncelleme **PR'ın işi** olur ·
`E6`'ya dördüncü kontrol adayı doğar: **bayat adres.**

**Kural:** `L2` giriş bölümü, madde 5

---

## KT-5 · Klasör bölmesi — ratchet, faz değil

**Karar:** `E1` guard'ı **bugün**; birleştirme hiçbir fazın kalemi olmaz.

### `E1` bugün — çünkü tutarlılık borcu

İki issue taslağının kısıtlar bölümünde *"`modes/` klasörüne dosya eklenmez (E1 guard)"*
yazılı. **O satır bugün bir niyet; guard yazılınca kural olur.**

Ve `B` dalgası PR'ları bölmenin komşu dosyalarına dokunacak — **yeni kodun sızması en
muhtemel an, guard'ın en değerli anı.**

### `C5` ölçümü üçüncü bir seçeneği açabilir

*"Birleştirme hangi faza"* sorusu, birleştirmenin **gerekli olduğunu varsayıyor.**

```
Fark küçük + canlı      → dokunulan-yerden birleştirme (A1 planı aynen)
Fark büyük + canlı      → her adım ayrı ölçülmüş issue
Fark her neyse + ÖLÜ    → birleştirme değil SİLME — ve silme daha ucuz
```

⚠️ Üçüncüsü ciddi bir olasılık: Planning-First zaten Faz 1 dışı ilan edilmişti.

> **Ölü kodu birleştirmek, kimsenin kullanmadığı davranışı canlı yola taşımaktır** —
> `İlke 4`'ü çözerken `İlke 1`'i ihlal etmek.

**`C5`'in sorusu genişledi:** statik fark **+ çağrı izi** (*"hangi yollar runtime'da fiilen
çağrılıyor"*).

### Birleştirme = üç mekanizma, sıfır takvim

**1 · Ratchet.** `E1` guard'a ikinci sayaç: bölmedeki dosya/satır sayısı her koşuda ölçülür,
baseline'a karşı **tek yön — aşağı.**

> Her sprint sonunda `EK_E` sayımının yanına bir metrik daha: *"bölme: 41 dosya → 33."*
> Başlamama riski böyle ölür: **ilerlemeyen sayı, ilerlemeyen işin kanıtı olarak her hafta
> yüzüne bakar.**

**2 · Fırsatçı kural.** Her issue şablonuna: *"dokunulan dosya bölmedeyse, bu PR onu bölmeden
çıkarır ya da çıkaramama gerekçesini yazar."*

**3 · Bitiş çizgisi.** Faz 2 çıkış ölçütü: *"Faz 2 kapanamaz — hakediş yolundaki bölme
kalıntısı sıfırlanmadan."* Kalan (hakediş dışı) kalıntı aynı mekanizmayla Faz 3'e devreder.

> Böylece birleştirme ne bir fazın gecikebilen kalemi, ne sahipsiz bir *"ayrı iş"* — **her
> PR'ın kenar yükümlülüğü + her sprintin metriği + bir fazın kapanış şartı.**

---

# BLOK 2 · `CLAUDE.md` — yöntem ilkeleri

> Bu dördü **bu turun ötesinde** geçerli. Karar defterine gömülürlerse, bir kararla birlikte
> gömülmüş olurlar.

## §x.1 · Köken ile yaşam döngüsü ayrı eksenlerdir

**Köken alanları** (kim yaptı) ile **yaşam döngüsü alanları** (hangi durumda) aynı kolonda
yaşayamaz.

Bir kimlik alanını *"henüz olmadı"* anlamında boşaltmak, durum makinesinin işini köken
kolonuna taşımaktır — ve genellikle bir güvenlik kontrolünü sessizce deler.

> Doğuşu: `submittedById` bir yolda `NULL`'a çekiliyordu, ve `NULL ≠ onaylayan` olduğu için
> görev ayrılığı kontrolü **her zaman geçiyordu.**

**Aile:** renk/davranış ayrımı · giriş grain'i ↔ hesap grain'i · harcama tipi ↔ işlem tipi.
Hepsi aynı ilkenin farklı yüzü: **her bilgi kendi ekseninde.**

## §x.2 · Bağımlılık bir statü değil, bir adrestir

Bir işaret *"başka bir iş bitince değişecek"* anlamı taşıyorsa, o bir **statü olamaz** —
çünkü doğası gereği bayatlar ve güncellemek kimsenin görevi olmaz.

Bunun yerine işaret bir **adres** taşır: hangi iş bu satırı kapatacak. Adres kendi kapanış
mekanizmasını da getirir — o işin kabul kriterine *"kapattığı işaretleri çevirir"* eklenir.

**İki adres türü:**
```
ön koşulu BİLİNEN    → iş / dalga referansı
ön koşulu ÖLÇÜLECEK  → ölçüm referansı
```

⚠️ İkincisi önemli: ön koşulu ölçülecek bir maddeye iş adresi yazmak, **ölçümün sonucunu
önceden yargılamaktır.**

## §x.3 · Davranış kuralları takvimle değil, ölçümle zorlanır

*"Şu fazda yapacağız"* diye planlanan bir temizlik işi, o fazın sıkışan kalemi olur.

Bir davranış kuralı (*"dokunulan yerden düzelt"*) üç mekanizmayla zorlanır:

```
ratchet          sayı tek yönde hareket eder, ilerlememe görünür olur
fırsatçı kural   her PR'ın kenar yükümlülüğü + gerekçeli sapma hakkı
bitiş çizgisi    bir fazın çıkış ölçütü, kalemi değil
```

> **İlerlemeyen bir sayı, ilerlemeyen işin kanıtı olarak her hafta yüzüne bakar.**

## §x.4 · Mütalaanın kalitesi sorunun kalitesidir

Dış girdi (hukuk, danışman, uzman) alırken **sorunun şeklini kontrol et.**

Kaynağın verdiği çerçeveyi taşıyan bir soru, kaynağın hatasını da taşır: *"7 yıl doğru mu"*
diye sormak, `7`'nin bir aday olduğunu varsayar. Doğrusu: *"hangi kayıt sınıfımız hangi
rejime girer?"*

**Aile:** danışman turunun `ALTERNATİF` zorunluluğu · *"kaynak bir girdidir, kanıt değil"* ·
`F4`'ün sınıflandırma tablosu.

---

# Bu turda doğan işler — özet

| # | İş | Tür |
|---|---|---|
| `T-205` | Kimlik alanı boşaltma yolu — bağlam + düzeltme | Task |
| `T-206` | Tasarım kararının sınıfı — `git blame` + bağlam | Ölçüm |
| `C5+` | Bölme farkı **+ çağrı izi** | Ölçüm |
| `E1` | `modes/` guard'ı + ratchet sayacı | **Bugün** |
| `E6+` | Bayat adres kontrolü | Guard adayı |
| — | Hukuk paketi, dört soru | Dış |
| `S13` | `last_modified_by` + gönderen değişmezliği | `B` dalgası |

**Ve iki belge güncellemesi:** `B` dalgası `kabul-8` (*"kapattığı işaretleri çevirir"*) ·
issue şablonu (*"bölmedeki dosyaya dokunduysan çıkar ya da gerekçe yaz"*).
