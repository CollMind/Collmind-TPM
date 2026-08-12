# BRD v2.0 — Ek A · İşlevsel Olmayan Gereksinimler

> **Bu ek L2'den ayrıldı.** Kapasite hedefleri, yanıt süreleri ve telemetri işlevsel olmayan
> gereksinimlerdir: bir iş kuralı *"ne olmalı"* der, bunlar *"ne kadar hızlı, ne kadar
> büyük"* der.
>
> Karışması, iş kuralı arayan birinin performans hedefleri okumasına yol açıyordu — ve L2
> bir referans belgesi.

- **Sürüm:** taslak, 2026-08-12
- **Numaralandırma:** `NFR-<sıra>` (eski `K-2.12.*` karşılıkları belirtildi)

---

## A.1 · Kiracılık modeli

**NFR-1** — Ürün **çok kiracılıdır.** Veri modeli, izolasyon ve konfigürasyon katmanı buna
göre tasarlanır. *(eski `K-2.12.1`)*

**NFR-2** — İlk müşterinin tek başına çalışacak olması bir **konuşlandırma gerçeğidir**,
mimari bir kısıt değil. *(eski `K-2.12.2`)*

**NFR-3** — Veri ayrımı modeli: ⛔ **açık karar.** *(eski `K-2.12.3`)*

> Kaynak *"paylaşımlı veritabanı + kiracı kimliği + satır seviyesi izolasyon"* diyor, ama
> bunu bir yerde Faz 1 hedefi, başka yerde *"bugün tek kiracılı"* olarak yazıyor.
>
> Alternatifler ölçülmedi: kiracı başına şema, kiracı başına veritabanı. Üçünün **bugünkü**
> maliyeti aynı (tek müşteri), **geçiş** maliyeti çok farklı.

---

## A.2 · Kapasite hedefi

> ✅ **Karar verildi** (2026-08-12, Oturum 2.5). Hedef **Yıl-1 projeksiyonudur**, kapasite
> tavanı değil.

**NFR-4** — Performans hedefi: **5.000 SKU katalog · 10 eşzamanlı onay.**

> Gerekçe (ürün sahibi): test hedefi, **kanıtlanacak iddiaya** göre seçilir. Kanıtlanması
> gereken iddia tavan değil — konumlanma *"haftalarla kurulum, tablodan basit"* diyor ve
> tipik kullanım 40-50 satır tarafında.
>
> `10.000` SKU testi, satılmayan bir vaadi doğrulamak için altyapı, veri üretimi ve test
> bakımı maliyeti öder. Güvenli değil, **alakasız-pahalı.**
>
> `5.000` doğru türde güvence veriyor: projeksiyonun üstünde, tipik kullanımın ~100 katı.

**NFR-5** — ⚠️ **Kapasite tavanı iddiası belgelerden çıkarıldı.**

`"10.000+ SKU ile test edildi"` ifadesi **koşulmuş bir test olmadan kullanılamaz.** Bugün
hiçbir performans testi yok — o cümle yazılırsa yanlış olur.

> Tavan merak ediliyorsa Faz 2'de tek seferlik bir yük koşusu yapılır ve **sonucu neyse o**
> yazılır.

**NFR-6** — Eşzamanlılık ölçütü **onaylı kaynak** üzerinden sabitlendi: 10 eşzamanlı onay.

> İki farklı ölçüt vardı ve fark **ölçüm türünden** geliyordu (onaylı belge vs onaysız
> taslak). Onaylı olan alındı.
>
> Ve gerekçesi yapısal: rezervasyon/defter yarışı — `K-2.2.9h`'in *"atomik olmalı"* dediği
> nokta — **yalnız onay anında** var. Taslak eşzamanlılığı bir doğruluk testi değil, bir
> kullanım rahatlığı ölçüsü.

**NFR-7** — Hedefler kaynağın kendi ifadesiyle **gösterge niteliğindedir, sözleşmesel
değildir.** İlk müşteri verisiyle revize edilir.

## A.2.1 Ne test edilir

**NFR-8** — ⚠️ **SKU sayısı tek başına anlamsız bir ölçüttür.** Performans riski SKU
sayısında değil, **SKU'ya çarpan işlemlerde.**

Test senaryosu üç işlemi hedefler:

| # | Senaryo | Neyi ölçer |
|---|---|---|
| 1 | Plan açılış ve kaydetme | 5.000 SKU'lu katalogda, bugünkü `FU → tüm SKU zorunlu genişletme` davranışıyla **satır patlaması** |
| 2 | Hesaplaşma koşusu | 5.000 SKU × dönem kapanışı — defter yazım hacmi |
| 3 | Eşzamanlı rezervasyon | 10 kullanıcı, aynı zarf — yarış ve atomiklik |

> Birincisi muhtemelen **ilk darboğaz.** `K-2.1.7` ailesinde o davranış *"düzeltilecek bir
> sapma"* olarak işaretli — ama bugün gerçek, ve test onu ölçmeli.

---

## A.3 · Yanıt süreleri

**NFR-9** — Hesaplama yanıt süresi hedefi **uçtan uca** ölçülür: kullanıcının değer
girmesinden güncellenmiş göstergeleri görmesine kadar. *(eski `K-2.12.6`)*

> Tek bir formülün değerlendirme süresi değil. Kaynak ölçüm yöntemini açıkça yazıyor.

**NFR-10** — Hedefler **yüzdelik dilimlerle** tanımlanır, tek bir ortalama ile değil.
*(eski `K-2.12.7`)*

> ⚠️ **Ölçülmüş durum:** bugün hedef karşılanmıyor — elli SKU'luk bir planda tek hesaplama
> hedefin biraz üzerinde, eşzamanlı iki işlemde iki katı.
>
> Bu bir alarm değil: ürün henüz yayında değil, ve hedefler gösterge niteliğinde.

---

## A.4 · Ölçüm altyapısı

**NFR-11** — Performans uyumu **ölçülmeden iddia edilemez.** Telemetri, uyum iddiasının ön
koşuludur. *(eski `K-2.12.9`)*

**NFR-12** — ⚠️ **Asgari ölçüm çengeli, hedeflerle aynı anda gelir:**

```
yavaş sorgu kaydı
üç kritik uç noktanın süre metriği
```

> **Hedef, ölçülemiyorsa süstür.** Telemetri sıfırken performans hedefi koymak yarım iştir.

**NFR-13** — Faz geçiş ölçütlerinin bir kısmı bugün **yapısal olarak ölçülemez** — çünkü
gerektirdikleri ortam (yayın ortamı, sürekli entegrasyon hattı) yok. *(eski `K-2.12.10`)*

> Bu bir *"ölçüt karşılanmadı"* sorunu değil, bir **ortam** sorunu. Çözümü bir görev
> listesinde değil, konuşlandırma kararında.

---

# Açık kalanlar

| Kural | Neyi bekliyor | Tür |
|---|---|---|
| `NFR-3` | Veri ayrımı modeli | teknik + maliyet ölçümü |

---

# Kaynak haritası

| Bölüm | Kaynak | Karar |
|---|---|---|
| A.1 | `§9.2` · `§2.5` | ⛔ açık |
| A.2 | `§9.2` · `§2.5` · `§1.3` · `H2` · `MC-001` | ✅ Oturum 2.5 |
| A.3 | `§9.1` · `H1` | `ADR 0003` |
| A.4 | `§9.1` · `H1` · `§10.2` | — |

**Değişen:** kapasite hedefi üç aday arasından seçildi ve tavan iddiası belgelerden
çıkarıldı. Eşzamanlılık ölçütü iki adaydan onaylı olana sabitlendi.

**Not:** `A.2.1` (ne test edilir) kaynakta yok — ölçüm hedefinin **SKU sayısı değil işlem
sayısı** olduğu bu turda tespit edildi.
