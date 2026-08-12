# BRD v2.0 — Yapısal Tamamlama

> `_ISKELET §6`'nın iki açık sınırını kapatıyor: **ekran katmanının yeri** ve **`L1`/`L2`
> sınırının sınanmamışlığı.**
>
> İkisi de yapı kararıdır ve dış değerlendirmeden **önce** kapanmalıdır — yapı yanlışsa
> gelen her geri bildirim o yanlış yapı üzerine kurulur.

- **Tarih:** 2026-08-12

---

# Bölüm A · `L1` / `L2` sınırı

## Sınama nasıl yapıldı

İki ölçüt:

1. **Atıf ölçümü** — `L1`'in her bölümü `L2`'ye atıf veriyor mu, kuralı tekrar mı ediyor?
2. **Örtüşme ölçümü** — aynı konu iki katmanda **farklı derinlikte** mi, yoksa **aynı şeyi
   iki kez mi** söylüyor?

## Ölçüm sonucu

| `L1` bölümü | `L2` atfı |
|---|---|
| 1.6 Göstergeler | 6 |
| 1.4 Bütçe · 1.7 Hakediş | 4 |
| 1.5 Onay | 3 |
| 1.1 · 1.2 · 1.3 · 1.9 | 2 |
| 1.8 · 1.10 · 1.11 · 1.12 · 1.13 | 1 |
| **1.14 Faz kapsamı** | **0** |

**On dört bölümün on üçü atıf veriyor.** Tek istisna `§1.14` — ve **doğru olan o:** faz
kapsamı bir kural değil, bir **durum beyanı.** Karşılığı `L2`'de olmamalı.

## Örtüşen üç konu — ve üçü de meşru

Şüphelenilen yerler tek tek bakıldı:

### Onay — `L1 §1.5` ↔ `L2 2.5`

| Katman | Ne söylüyor |
|---|---|
| `L1` | İki ayrı sistem var; üç şablon; görev ayrılığı istisnasız |
| `L2` | Durum makinesi geçişleri; şablonların satır yapısı; kapsam tanımı (*gönderen ∪ son değiştiren*) |

**Örtüşme değil, derinlik farkı.** `L1` *"görev ayrılığı istisnasızdır"* diyor; `L2` **kimin**
kapsandığını tanımlıyor.

### Bütçe — `L1 §1.4` ↔ `L2 2.2`

`L1` iki merdiveni ve dört kovayı **tanıtıyor**; `L2` eşik çözümlemesini, çakışma kısıtını,
transfer bacaklarının toplamını tanımlıyor.

### Hakediş — `L1 §1.7` ↔ `L2 2.13`

`L1` zinciri ve kanıt sınıflarını anlatıyor; `L2` eşleştirme merdivenini, tolerans eşiğini,
fark kalemini kurala bağlıyor.

## Sınır kuralı — resmileşti

Bu üç örnekten çıkan ölçüt:

> **`L1` bir yeteneğin ne yaptığını ve neden öyle olduğunu anlatır. `L2` o yeteneğin
> sınırlarını, kenar durumlarını ve invariantlarını tanımlar.**
>
> Bir cümle `L1`'de mi `L2`'de mi diye tereddüt edilirse test şudur: **bu cümle olmadan
> yetenek anlaşılamaz mı, yoksa yanlış uygulanır mı?**
>
> Anlaşılamaz → `L1`. Yanlış uygulanır → `L2`.

## Bir düzeltme gerekti

`L1`'in bazı bölümleri `L2` kurallarını **tekrar ediyor**, atıf vermek yerine. Örnek:
`§1.6`'daki *"pay ve payda ayrı toplanır"* cümlesi `K-2.4.19`'un metnidir.

**Karar:** tekrar **kalır**, ama her tekrar bir atıfla işaretlidir.

> Gerekçe: `L1` baştan sona okunuyor. Okuyucuyu her kural için `L2`'ye göndermek okumayı
> kırar. Ama **kaynak tek kalmalı** — atıf, hangisinin kanonik olduğunu söylüyor.
>
> Ve bir kural değiştiğinde `L1`'deki yankısı atıf üzerinden bulunur.

---

# Bölüm B · Ekran katmanı

## Neden BRD'den çıkarıldı

Ölçüm: eski pakette 20 ASCII ekran taslağı vardı ve **beşinin karşılığı hiç yok**, bir
kısmının davranışı farklı.

Yani taslaklar hem **bakım yükü** hem **yanlış bilgi kaynağıydı** — bir okuyucu onları
ürünün tarifi sanıyordu.

## Ama çıkarmak bir boşluk bıraktı

Üç soru cevapsız kaldı:

```
Bir ekranın hangi bilgiyi göstermesi gerektiği nerede yazılı?
Bir yetenek "arayüzü yok" diye eksik sayılıyorsa, o arayüz nerede tanımlı?
Tasarımcı neye bakarak çizecek?
```

Ve karar turu bu boşluğu **büyüttü:** üç karar doğrudan arayüz gereksinimi üretti.

| Karar | Arayüz gereksinimi |
|---|---|
| `A2` | Dağıtım görünürlüğü — **MVP şartı** (`K-2.1.8i`) |
| `A10` | `GRİ` dördüncü durum — değer + kapsama rozeti + eksik listesi |
| `A5` | Tavan aşımı kuyruğu ve finans onay ekranı |

Bunlar bir *"tasarım tercihi"* değil — **kuralın parçası.**

## Karar: üç ayrı yere dağılır

Tek bir *"ekran belgesi"* yazılmaz. Üç farklı soru var ve üç farklı yere aittir:

### 1 · Bilgi gereksinimi → `L2`'de kalır

Bir ekranın **hangi bilgiyi göstermek zorunda olduğu** bir iş kuralıdır.

```
K-2.1.8i   dağıtım görünür olmalı
K-2.4.22a  GRİ durumda değer + kapsama + eksik listesi gösterilir
K-2.7.7    bayat veri yaşıyla birlikte söylenir
K-2.2.11a  red mesajı hangi kalemin takıldığını söyler
```

**Bunlar zaten `L2`'de** ve orada kalır. Ölçüt: *"bu bilgi gösterilmezse kullanıcı yanlış
karar verir mi?"* — evet ise kural.

### 2 · Yetenek ↔ ekran eşlemesi → `L1`'de bir tablo

`L1`'in her bölümü bir **durum tablosu** taşıyor. Ona bir sütun eklenir: **arayüzü var mı?**

Bugün bu bilgi dağınık: `§1.7` *"anlaşma kapanışının arayüzü yok"* diyor, `§1.10` *"beş rapor
menüde var, çalışmıyor"* diyor — ama sistematik değil.

> Bu, ürünün en somut boşluk haritasıdır: **mekanizma var, yüzey yok** vakalarının listesi.

### 3 · Görsel tasarım → BRD dışı

Yerleşim, bileşen seçimi, renk paleti, etkileşim detayı — bunlar bir **tasarım katmanına**
aittir ve BRD'de yaşamaz.

⛔ **O katmanın nerede yaşayacağı bu belgenin kapsamı dışında** — ama bir gereksinim olarak
kaydedilir: bugün böyle bir katman **yok**, ve dağıtım görünürlüğü gibi MVP şartları
tasarlanmadan yazılamaz.

## Eski taslaklar ne olur

**Silinmez, referans olarak kalır** — ama statüsü değişir:

> Eski paketin ekran taslakları **ürünün tarifi değil, bir tasarım girdisidir.** Beşinin
> karşılığı hiç yok ve bir kısmının davranışı farklı; bir çelişki durumunda `L2` kuralı
> kazanır.

---

# Bölüm C · Kalan yapısal boşluklar

Bu belge ikisini kapattı. Üç tanesi duruyor ve **hepsi içerik eksiği**, yapı eksiği değil:

| Boşluk | Ne gerekiyor | Nerede yaşar |
|---|---|---|
| **Veri sözlüğü** | Tablo · kolon · tip · kısıt | `EK_C` — `L2`'nin eki |
| **Akış diyagramları** | Onay durum makinesi · hakediş zinciri · bütçe kovaları | `L1`'e görsel |
| **Ekran envanteri** | Yetenek ↔ arayüz eşlemesi | `L1` durum tablolarına sütun |

Üçü de yazım işidir; karar gerektirmezler.

⚠️ **Ve bir uyarı:** veri sözlüğü `L2`'nin eki olmalı, **ayrı bir katman değil.** Ayrı
katman olursa şema kararları kurallardan kopar — ve bu oturumda kopmuş kaynak/uygulama
çiftlerinin ne ürettiğini yeterince gördük.

---

# Özet

| Soru | Cevap |
|---|---|
| `L1`/`L2` sınırı sağlam mı? | ✅ Sınandı. Ölçüt resmileşti: *anlaşılamaz → L1, yanlış uygulanır → L2* |
| `L1` kural tekrar ediyor mu? | Evet, ve **kalır** — ama her tekrar atıflı |
| Ekran katmanı nerede? | Üçe bölünür: bilgi gereksinimi `L2`'de · eşleme `L1`'de · görsel tasarım BRD dışı |
| Eski taslaklar? | Referans kalır, statüsü *"tasarım girdisi"* |
| Kalan boşluklar? | Üç içerik eksiği — veri sözlüğü, diyagramlar, ekran envanteri |
