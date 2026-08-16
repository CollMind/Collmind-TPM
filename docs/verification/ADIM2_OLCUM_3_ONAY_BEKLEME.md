# `ADIM 2` · Ölçüm 3 — onay bekleme dağılımı ⛔ **BUGÜNKÜ VERİYLE YAPILAMAZ**

> **Ölçüldü:** 2026-08-16 · **Ölçen:** Team Lead · **Kaynak:** canlı dev DB, şema `main`
> **Plan kalemi:** `docs/process/FAZ1_PLAN.md §4.3`
> **Sonuç:** ölçüm **yapılamadı** — ve bu, *"yapıldı"* diye kapatılmadı.

## İstenen

`B4` (onay zaman aşımı) `04_KARAR_KAYDI.md`'de **"ölçüm sonrası"** şartıyla ertelenmişti.
Plan `§4.3` o şartın kendisini bir kaleme çevirdi: **onay bekleme dağılımı.**

## Ölçüm

```
customers              93        plans                    0
skus                  170        plan_approval_history     0
users                   9        approval_requests         0
agreements              3        plan ile ilgili audit     0
budget_envelopes        4        admin_audit_logs         29
```

⚠️ **`0` sonucunun sebebi ölçüldü** (`§7.1`: *"bir sıfırın en az iki açıklaması vardır"*):

| açıklama | sonuç |
|---|---|
| DB tümüyle boş | ❌ **elendi** — ana veri dolu (93 müşteri · 170 SKU · 3 anlaşma) |
| planlama akışı kalıcı olarak hiç işletilmedi | ✅ **doğru** — ve `plan` ile ilgili denetim kaydı da **0** |

📌 e2e suite planları yaratıp temizliyor; `T-047` invaryantı suite öncesi/sonrası satır
sayılarının **birebir aynı** olmasını garantiliyor. Yani test verisi **kalıcı iz bırakmıyor** —
bu bir kusur değil, tasarım.

## Sonuç — ve neden *"yapıldı"* yazılmadı

> **Örneklem yetersiz değil — SIFIR.** Bir dağılım hesaplanamaz; medyan da, yüzdelik de,
> "tipik bekleme" de tanımsız.

`CLAUDE.md`: ***"karşılanamayan bir ölçüt revize edilir — gerekçesiyle. Ölçütü korumak için
veri uydurmak, ölçütün koruduğu şeyi yok eder."***

Bu kalem tam o baskıyı taşıyordu: `Adım 2`'yi kapatmak için bir sayı üretmek mümkündü
(ör. e2e koşumundan geçici satırlar okumak, ya da seed verisinden sentetik bir dağılım
türetmek). **Üretilmedi.** İkisi de gerçek kullanıcı davranışını değil, **test kurgusunu**
ölçerdi.

## `B4`'ün şartı için sonuç

⛔ **`B4`'ün *"ölçüm sonrası"* şartı bugün KARŞILANAMAZ**, ve bu bir gecikme değil bir
**yapısal** durum: şart **üretim verisi** gerektiriyor, ve `CLAUDE.md §1` bugün deploy
edilmiş bir ortam olmadığını kaydediyor.

### ✅ KARAR — `(a)`, ürün sahibi (2026-08-16)

```
ŞART:  ilk müşteri tenant'ında N = 20 tamamlanmış onay biriktiğinde ölç
N:     BUGÜN yazıldı — o gün değil
```

**`(b)` reddedildi, gerekçesiyle:** şartı kaldırmak bir bilgiyi **kalıcı olarak atar.**
Dağılım gerçekten kararı besliyor — `B4`'ün kendi gerekçesi *"planlar meşru olarak
gecikir"*di ve **o iddia hâlâ ölçülmemiş.** Zaman aşımı bir politika kararı olabilir, ama
*"hangi politika"* sorusunun cevabı dağılımdan geliyor: **`7/14` mi doğru, `14/30` mu?**

> ### ⚠️ `N` neden BUGÜN yazıldı
>
> **O gün geldiğinde eldeki veriye bakıp bir sayı seçmek, ölçümü sonuca uydurmaktır.**
>
> Bu, `CLAUDE.md`'nin *"beklenen sayı ÖNCEDEN yazılır"* kuralının bir dağılıma
> uygulanmış hâli — orada gerekçe *"kontrolü koşup çıkan sayıya bakmak, sonucu gördükten
> sonra 'evet bu makul' demeye açıktır"*. Aynı açık burada da var, ve daha büyük: bir
> eşik seçimi doğrudan bir **politikaya** dönüşüyor.

**`N = 20` bir TAHMİNDİR** (`§2.4` gereği böyle işaretlendi): küçük ama bir **medyan**
verir, ve ilk tenant'ta birkaç ayda ulaşılır. Daha iyi gerekçeli bir sayı gelirse
**değiştirilir** — ama o gün değil, **şimdi**.

⚠️ **Üçüncü bir yol YOK:** şart olduğu gibi bırakılırsa `B4` **kalıcı olarak** askıda kalır
ve kimse fark etmez — çünkü *"ölçüm bekliyor"* meşru görünür.

⚠️ **Üçüncü bir yol yok:** şart olduğu gibi bırakılırsa `B4` **kalıcı olarak** askıda kalır
ve kimse bunu fark etmez — çünkü *"ölçüm bekliyor"* meşru görünür.

## Ölçümün sınırı

- **Tek veritabanı** (dev). Başka bir ortamda plan verisi olabilir — ama `CLAUDE.md §1`
  böyle bir ortam olmadığını kaydediyor.
- Ölçüm **tam suite koşumundan sonra** yapıldı; `T-047` invaryantı gereği bu, koşum
  öncesiyle aynı durumdur.
