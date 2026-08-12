# BRD v2.0 — Ek E · Yetenek ↔ Arayüz Eşlemesi

> **Ürünün en somut boşluk haritası.** Her yetenek için tek soru: **kullanıcı buna
> erişebiliyor mu?**
>
> Bu, *"kod var mı"* sorusundan farklıdır. Bu kod tabanında dokuz kez ölçüldü ki **mekanizma
> var, yol yok** — ve bir kez tersi: **yol var, yüzey yok.**

- **Sürüm:** taslak, 2026-08-12
- **Ölçüm temeli:** ekran envanteri (2026-08-11, revizyon `d9bedc5`, doğrulandı 2026-08-12)

---

## Dört durum

| İşaret | Anlamı |
|---|---|
| ✅ | Yetenek var, arayüzü var, çalışıyor |
| ⚠️ | Yetenek var, arayüzü var, **kırık** |
| 🔒 | **Yetenek var, arayüzü yok** — yalnız doğrudan çağrıyla erişilebilir |
| ❌ | Yetenek yok |

⚠️ **`🔒` en pahalı durumdur:** iş yapılmış, tamamlanmış, test edilmiş — ve kullanıcıya
ulaşmıyor. Bir `❌` dürüsttür; bir `🔒` israftır.

---

# E.1 · Planlama

| Yetenek | Durum | Not |
|---|---|---|
| Plan listesi ve oluşturma | ✅ | |
| Planlama tablosu (grid) | ✅ | |
| Taktik girişi | ⚠️ | Hesap tarafı çalışıyor, **girilen değer hücreye dönmüyor** |
| FU seviyesinde hacim girişi | ❌ | Bugün SKU seviyesinde |
| Dağıtım görünürlüğü | ❌ | ⚠️ **MVP şartı** (`K-2.1.8i`) |
| Elle düzeltme + kilit göstergesi | ❌ | |
| Tarihsiz SKU işareti | ❌ | |
| Toplam paneli | ✅ | |
| Senaryo analizi | ❌ | Faz 2 |
| Geri al / ileri al | ❌ | Faz 2 |

> **Kırık taktik girişi bir kusur değil, bir yetenek eksiğidir** — karar turu onu MVP şartına
> bağladı. Kullanıcı dağılımı göremeden değeri düzeltemez.

---

# E.2 · Bütçe

| Yetenek | Durum | Not |
|---|---|---|
| Zarf listesi ve tanımlama | ✅ | |
| Kullanım oranları | ✅ | |
| Hareket defteri görünümü | ✅ | |
| Eşik uyarıları | 🔶 | Değerler yanlış merdivenden (`%95` davranışta) |
| Finans inceleme bildirimi (`%90`) | ❌ | |
| Blok davranışı (`%100`) | ❌ | Kodda bir *"yapılacak"* notu var |
| Politika tablosu yönetimi | ❌ | |
| **Transfer** | ❌ | Blok kararının bütünlük tamamlayıcısı |
| Zarf revizyonu | 🔶 | Mekanizma var, akış tanımlı değil |

---

# E.3 · Onay

| Yetenek | Durum | Not |
|---|---|---|
| Bekleyen planlar kuyruğu | ✅ | |
| Bekleyen anlaşmalar kuyruğu | ✅ | |
| Onay / ret | ✅ | |
| Gerekçe girişi | ✅ | |
| Karar anındaki göstergelerin kaydı | ❌ | Alan var, **yazarı yok** |
| Politika şablonu seçimi | ❌ | |
| Devir (yeniden atama) | ❌ | Faz 2 |
| Gecikme bildirimi | ❌ | |

---

# E.4 · Anlaşma

| Yetenek | Durum | Not |
|---|---|---|
| Anlaşma listesi | ✅ | |
| Anlaşma detayı | ⚠️ | **İsimler yerine kimlik numaraları görünüyor** |
| Oluşturma ve düzenleme | ✅ | |
| Tavan takibi | 🔶 | Erken uyarı yok |
| **Anlaşma kapanışı** | 🔒 | ⚠️ **Mekanizma olgun, hiçbir ekrandan çağrılamıyor** |
| Dönem kapanışı | ❌ | |

> `🔒` vakasının en net örneği: eşzamanlılık koruması, iki ayrı çakışma kontrolü, çift-sayma
> koruması, iki uçtan uca test — ve **kullanıcı erişemiyor.**

---

# E.5 · Gerçekleşen ve hakediş

| Yetenek | Durum | Not |
|---|---|---|
| Fatura dosyası yükleme | ✅ | |
| Doğrulama adımı | ✅ | |
| Hata raporu (satır bazında) | 🔶 | Kanal var, tam kullanılmıyor |
| Elle hakediş girişi | ✅ | |
| Hakediş talebi üretimi | ✅ | Dört uç, RBAC'li |
| **Dış talep alımı** | ❌ | Karşı taraf perspektifi yok |
| **Eşleştirme** | ❌ | Kullanıcı anlaşma kimliğini elle yazıyor |
| Eşleşmeyen kuyruğu | ❌ | |
| Mutabakat ekranı | ❌ | |
| Fark çözümleme | ❌ | |
| Tahakkuk görünümü | ❌ | |
| Toplu onay | ❌ | Kaynak tarif ediyor, karşılığı yok |

> **Ürünün çekirdeği burada** ve tablonun çoğu `❌`. Bu, `L1 §1.7`'nin somut hâli.

---

# E.6 · Göstergeler

| Yetenek | Durum | Not |
|---|---|---|
| Gösterge yönetimi (27 gösterge) | ✅ | |
| Formül düzenleme | ✅ | |
| Formül doğrulaması | 🔒 | ⚠️ **Uç var, istemci sarmalayıcısı var, çağıran yok** |
| Plan üzerinde gösterge görünümü | ✅ | |
| Renk (RAG) | ⚠️ | Kapsama oranı istemciye ulaşmıyor |
| `GRİ` durumu (kapsama rozeti + eksik listesi) | ❌ | |
| Fiyat simülasyonu | ❌ | Kaynak tarif ediyor |

> Formül doğrulaması ikinci `🔒` vakası — ve daha tehlikelisi: yönetici bugün geçersiz sonuç
> üreten bir formülü kaydedebiliyor.

---

# E.7 · Raporlama

| Rapor | Durum |
|---|---|
| Plan performansı | ❌ menüde var, çalışmıyor |
| Kârlılık dağılımı | ❌ menüde var, çalışmıyor |
| Harcama kırılımı | ❌ menüde var, çalışmıyor |
| Bütçe kullanımı | ❌ menüde var, çalışmıyor |
| Anlaşma durumu | ❌ menüde var, çalışmıyor |
| Planlamacı performansı | ❌ menüde yok |
| Nakit akışı projeksiyonu | ❌ menüde yok |
| Fark analizi | ❌ Faz 2 |
| Finans gösterge paneli | ⚠️ **hata ekranı gösteriyor** |
| Dışa aktarma | ❌ |

> ⚠️ **Beşi menüde görünüyor ve tıklanamıyor** — kullanıcı raporun var olduğunu sanıyor.
> Bu, `❌`'ten kötüdür: yanlış beklenti üretiyor.

---

# E.8 · Yönetim

| Yetenek | Durum |
|---|---|
| Ürün ağacı yönetimi (marka → SKU) | ✅ |
| Müşteri ve kanal yönetimi | ✅ |
| Bölge yönetimi | ✅ *(ekran var, veri yok)* |
| Mekanik ve taktik tanımları | ✅ |
| Kullanıcı yönetimi | 🔶 |
| Rol / yetenek yönetimi | ❌ |
| Kapsam atama | 🔶 filtre **kapalı** |
| Eşik ve politika yönetimi | ❌ |
| Kurulum sihirbazı | ❌ |
| Denetim kaydı görünümü | 🔶 yalnız yönetici işlemleri |

---

# E.9 · Yapay zeka kenarları

| Yetenek | Durum |
|---|---|
| Alım asistanı | ❌ |
| Açıklama katmanı | ❌ |
| Kurulum asistanı | ❌ |

⚠️ Üçü de **izolasyon katmanının arkasında** — bir asistan, onu çağıran kullanıcının
göremediği veriyi göremez (`K-2.4.31`).

---

# Özet

## Sayım

| Durum | Sayı |
|---|---|
| ✅ çalışıyor | 21 |
| 🔶 kısmen | 8 |
| ⚠️ kırık | 5 |
| 🔒 **yüzeysiz** | 2 |
| ❌ yok | 38 |

## İki `🔒` vakası — öncelikli

```
Anlaşma kapanışı      mekanizma olgun, ekran yok
Formül doğrulaması    uç + sarmalayıcı var, çağıran yok
```

> İkisi de **tamamlanmış iş.** Düzeltmesi yeni kod değil, **kablolama.**

## Beş `⚠️` — kullanıcıya görünür

```
Taktik değeri hücreye dönmüyor        → MVP şartı
Anlaşma detayında kimlik numaraları    → basit
Finans paneli hata ekranı              → yazılım hatası
Kapsama oranı ulaşmıyor                → GRİ durumu eksik
Beş rapor menüde, tıklanamıyor         → yanlış beklenti
```

## Boşluğun şekli

`❌` sayısı yüksek ama **dağılımı düzensiz değil:**

- **Hakediş zinciri** — 7 eksik (ürünün çekirdeği)
- **Raporlama** — 9 eksik (karar destek katmanı)
- **Yetki ve politika** — 6 eksik (Faz 1 tabanı)

Üçü `L1 §1.14`'ün faz bulgusunu doğruluyor: **Faz 2 yetenekleri var, Faz 1 tabanı yok** — ve
çekirdek eksik.

---

# Bu ekin bakımı

Her yetenek eklendiğinde ya da bir arayüz tamamlandığında bu tablo **aynı turda** güncellenir.

⚠️ Ve bir kural: **`🔒` işareti bir kabul değil, bir alarmdır.** Bir yetenek `🔒` durumunda
bir turdan fazla kalıyorsa, ya arayüzü yapılmalı ya yeteneğin gerekliliği sorgulanmalıdır.

> Yapılmış ama erişilemeyen iş, yapılmamış işten pahalıdır: bakım maliyeti var, değer üretimi
> yok.
