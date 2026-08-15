# Hukuk paketi — gönderime hazır metin

> **Karar kaydı:** `docs/decisions/KARAR_TURU_BES_KONU.md` `KT-3`
> **Durum:** ⛔ **GÖNDERİLMEDİ** — muhatap belirsiz (aşağıya bkz.)
> **Hazırlayan:** Team Lead · **Tarih:** 2026-08-15
> **Karar:** dört soru **tek paket** olarak gider; **hiçbiri işi bekletmez.**

---

## ⛔ ÖNCE: bu paket neden hâlâ gönderilmedi

**Muhatap kayıtta yok.** `KARAR_TURU_BES_KONU.md` paketin **içeriğine** karar veriyor,
**kime gideceğine** karar vermiyor. Aranan kayıtlarda bir hukuk müşaviri, danışman firma
ya da iletişim adresi **bulunamadı**.

> ⚠️ **`kayıtta yok` ≠ `yok`.** Muhatap belirlenmiş ama yazılmamış olabilir.

**Gönderim, ürün sahibinin işlemidir** — ve iki nedenle:

1. Muhatap bilinmiyor.
2. Dışa dönük bir gönderim, ürün sahibinin açık onayı olmadan yapılmaz.

`Adım 0`'ın kendi `DUR` koşulu bunu zaten öngörüyor: *"hukuk paketinin muhatabı
belirsizse DUR."*

**Çıkış ölçütü** (ürün sahibi tarafından karşılanacak): *"paket gönderildi, ve kime/ne
zaman kayıtlı."* Gönderildiğinde bu dosyanın başına **muhatap + tarih** yazılmalı.

---

## Bağlam — muhataba verilecek çerçeve

> CollMind TPM, hızlı tüketim ürünleri sektöründe **ticari promosyon yönetimi** yazılımıdır.
> Sistem, üretici firmalar ile perakende zincirleri arasındaki promosyon anlaşmalarını,
> bunlara bağlı bütçeleri ve gerçekleşen harcamaları takip eder.
>
> **Sistem bir muhasebe defteri değildir.** Muhasebe kaydı müşterinin kendi ERP sisteminde
> tutulur; bizim tuttuğumuz kayıtlar **planlama, onay ve denetim izi** niteliğindedir.
>
> Aşağıdaki dört soru, **hangi kayıtlarımızın hangi saklama rejimine tabi olduğunu**
> belirlemek içindir. Bugün — mütalaa gelene dek — **hiçbir kayıt silinmemektedir**
> (aşağıdaki `⏸️` notuna bkz.).

---

## `(a)` · Denetim-izi niteliğindeki kayıtların saklama rejimi

**Soru:**

> Muhasebe defteri **olmayan**, ancak bir ticari işlemin onay ve değişiklik geçmişini
> tutan **denetim-izi** niteliğindeki kayıtlar — kim, ne zaman, hangi tutarı onayladı —
> Vergi Usul Kanunu ve Türk Ticaret Kanunu'nun saklama rejimlerinden **hangisine** girer?
> Yoksa ikisinin de kapsamı dışında mıdır?

**Ek soru:**

> Sisteme **içe aktarılan belge kopyaları** (müşteriden gelen fatura/mutabakat dosyaları,
> asılları ERP'de ve muhasebede duruyor) bizim tarafımızda bir **e-belge saklama
> yükümlülüğü** doğurur mu — yoksa yükümlülük yalnız asıl kaydın tutulduğu ERP'de mi
> kalır?

**Neden soruyoruz:** kayıtlarımızın saklama süresi bu cevaba bağlı, ve bugün **hiçbir
kayıt silinmiyor** — yani cevap gelene dek muhafazakâr tarafta duruyoruz.

---

## `(b)` · Finansal etkisi doğmamış taslak kayıt

**Soru:**

> Kullanıcı tarafından oluşturulmuş, ancak **onaylanmamış ve hiçbir finansal etkisi
> doğmamış** taslak kayıtlar (bir promosyon planı taslağı gibi) hukuken **"ticari belge"**
> sayılır mı?
>
> Sayılmıyorsa, **KVKK'nın amaçla sınırlılık ilkesi** gereği bu taslakların belirli bir
> süre sonra **silinmesi zorunlu** hâle gelir mi?

**Neden soruyoruz:** iki düzenleme **zıt yönlere** çekiyor. Ticari/vergisel saklama daha
uzun tutmayı, kişisel veri mevzuatı daha kısa tutmayı gerektirebilir. Taslak kayıtlar
kullanıcı adı taşıdığı için ikisinin kesişiminde.

---

## `(c)` · Kişi bazlı performans raporlaması ⚠️ düşük öncelik

**Soru:**

> Çalışanların iş performansına ilişkin (bir planın onaya kaç günde gittiği, kaç
> revizyon aldığı gibi) **kişi bazlı** raporlama hangi şartlarda yapılabilir? Açık rıza,
> meşru menfaat ve aydınlatma yükümlülüğü açısından sınırlar nedir?

**Neden düşük öncelik:** ürün bu özelliği **süreç metriği** olarak yeniden tanımladı;
kişi kimliği bugün bir kırılım boyutu **değil**. Cevap gelirse kişi bazlı sürüm açılır,
**gelmezse ürün eksilmez.**

---

## `(d)` · `7 yıl` rakamının doğrulanması

**Soru:**

> Elimizdeki kaynak belge saklama süresi olarak **`7 yıl`** veriyor. Bildiğimiz kadarıyla
> Vergi Usul Kanunu'nda tarh zamanaşımına bağlı olarak **5 yıl**, Türk Ticaret
> Kanunu'nda ticari defter ve belgeler için **10 yıl** geçerli. `7` hangi düzenlemeden
> geliyor olabilir — yoksa yerelleştirilmemiş bir şablon değeri midir?

**Neden pakete dahil:** bu bir doğrulama sorusudur ve **`(a)`'nın çerçevesini belirler**.
Hangi kayıt sınıfının hangi rejime girdiği bilinmeden `(a)`'nın askısının ne zaman
kalkacağı da bilinemez.

> ⚠️ **Kayıt notu:** bu madde `KT-3`'te önce bir **şüphe** olarak yazıldı, bir **soru**
> olarak değil — ve bu yüzden paketin sayımına girmedi (`:80` *"üç soru"*, `:301`
> *"dört soru"*). Ürün sahibi 2026-08-15'te çözdü: **dört.** Ders kayıtlı: *bir şüphe
> olarak yazılan şey, bir soru olarak sayılmaz — ve gönderilecek pakete girmez.*

---

## Bugünkü davranışımız (muhatabın bilmesi gereken)

```
⏸️  K-2.9.0        saklama bölümü GEÇİCİ ASKIDA (2026-08-12 → mütalaa)
⏸️  K-2.9.2        90 gün silme kuralı ASKIDA — hiçbir kayıt silinmiyor
```

**Gerekçe hukuki değil, geri-alınabilirlik asimetrisi:** erken silme telafisizdir, fazla
tutma düzeltilebilir.

⚠️ Ve askı **işaretli** tutuluyor — yoksa altı ay sonra *"fiili davranışımız"* diye
kalıcılaşır.

---

## Gönderim sonrası — bu dosyaya yazılacak

```
Muhatap        : ____________________
Gönderim tarihi: ____________________
Kanal          : ____________________
Beklenen dönüş : ____________________
```

Ve gönderildiğinde `KARAR_TURU_BES_KONU.md` `KT-3`'e bir satır düşülmeli — **paketin
durumu kararın yanında yaşamalı**, ayrı bir dosyada değil.
