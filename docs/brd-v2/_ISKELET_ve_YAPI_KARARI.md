# BRD v2.0 — İskelet

> **Taslak yapı.** İçerik değil, **plan**: hangi bölüm ne anlatacak, nereden beslenecek,
> ve hangi açık karar onu blokluyor.

- **Tarih:** 2026-08-11
- **Girdi:** `URUN_KONUMLANMASI.md` · 45 turluk kaynak okuması · 11 ADR ·
  `SYSTEM_INVARIANTS.md` · `OPEN_DECISIONS.md`

---

## 0 · Neden sıfırdan yazılıyor

Üç seçenek değerlendirildi:

| Seçenek | Neden reddedildi |
|---|---|
| Mevcut paketi kullanmaya devam | Bugün üç yerde üç farklı rol kümesi, dört farklı ölçek sayısı, iki farklı ROI eşiği var. Okuyan hangisinin geçerli olduğunu bilemiyor. |
| Paketin üstüne "errata" katmanı | Dört yerden okumak gerekirdi: paket + errata + ADR'ler + değişiklik notları. Bu, bugünkü sorunun daha büyüğü. |
| **Sıfırdan yaz, kaynak izlenebilir kalsın** | ✅ Seçilen |

**Ama sıfırdan yazmanın bir riski var:** paketin okunmayan kısımları sessizce düşer.

Bu, `0059` envanteriyle kapatıldı — her bölüm ya okundu ya **gerekçeyle** atlandı, ve
gerekçeler yazılı. Yeni belge o envanteri referans alacak.

---

## 1 · Yapı kararı

### Tek belge değil, dört katman

Bugünkü paketin en büyük sorunu **strateji, iş kuralı ve ekran taslağının aynı belgede**
olması. Bir kuralı arayan kişi ürün vizyonunu okumak zorunda kalıyor; bir ekranı arayan
veri modelini.

```
L0  ÜRÜN KONUMLANMASI     ne olmalı · neyi reddediyoruz · ilkeler
L1  YETENEK HARİTASI      ürün ne yapar · faz kapsamı
L2  İŞ KURALLARI          normatif kurallar, sözleşme diliyle
L3  KARAR KAYDI           verilmiş kararlar + gerekçeleri (ADR'ler)
```

**L0** yazıldı (`URUN_KONUMLANMASI.md`, taslak).
**L3** kısmen var (11 ADR) ve `TASARIM_KARARLARI.md` onun okunabilir hâli.
**L1 ve L2 yazılacak.**

### Ekran taslakları belgede değil

Bugünkü pakette 20 ASCII ekran taslağı var ve ölçüldü ki bunların **beşinin karşılığı hiç
yok**, bir kısmının davranışı farklı. Yani taslaklar hem bakım yükü hem yanlış bilgi
kaynağı.

Yeni yapıda ekranlar **ayrı bir tasarım katmanında** yaşar; BRD yalnız *"hangi bilgi
kullanıcıya gösterilmeli"* der, *"nasıl görünmeli"* demez.

### Sayı yerine nitelik

Bugünkü pakette bayat sayı sorunu ölçüldü: *"8 standart rapor"* (Faz 1'de 7), *"beş rol"*
(başka yerde dört, başka yerde altı), *"10.000 SKU"* (başka yerde 5.000).

Yeni belgede sayı yalnız **normatif** olduğu yerde yazılır (eşik, sınır, kapasite hedefi),
ve tek bir yerde tanımlanır. Anlatı bölümlerinde sayı yerine nitelik.

---

## 2 · L1 — Yetenek Haritası

**Amaç:** ürünün ne yaptığını, hangi sırayla ve hangi fazda yaptığını tek yerde göstermek.

**Uzunluk hedefi:** 15-20 sayfa.

| Bölüm | İçerik | Kaynak | Blokeyen karar |
|---|---|---|---|
| 1.1 Değer zinciri | Plan → onay → anlaşma → gerçekleşen → hakediş → kapanış. Her halkanın girdisi/çıktısı. | `§2.3` · `§4` · `§5` | — |
| 1.2 Ürün ve organizasyon hiyerarşisi | Marka→Kategori→GU→FU→SKU · Kanal→Bölge→Müşteri. İki eksenin ayrı olduğu **açıkça**. | `§3.1` · `§7.1` · `0052` | `0056-K5` (kapsam ekseni) |
| 1.3 Başlangıç noktaları | Planlama zorunlu mu, opsiyonel mi? | `§2.2` · `§2.6` · `0037` | **`0019 #1`** ⛔ |
| 1.4 Bütçe modeli | Zarf boyutları · durum kovaları · eşikler | `§3.3` · `§8.1` · `ADR 0004` | `T-144` (eşik) · `T-150` (kova) |
| 1.5 Onay modeli | Kim neyi onaylar · eşik tetikleri · yükseltme | `§3.4` · `§7.3` · `ADR 0002` | `ADR 0002` yeniden onay · `0056-K2` |
| 1.6 Gösterge modeli | KPI kütüphanesi · toplama · RAG · eksik veri davranışı | `§5.3` · `§8.1` · `ADR 0011` | `T-177` (kısmi kapsama) |
| 1.7 Gerçekleşen ve hakediş | Talep nesnesi · karşı taraf perspektifi · eşleştirme · dönem kapanışı | ⚠️ **kaynak yok** · bugünkü durum ölçüldü (`0068`) | **`D-07` · `D-06` · `0023`** ⛔ |
| 1.8 Raporlama | Sekiz standart rapor · derinlik sınırı | `§8.1–8.6` | — |
| 1.9 Faz kapsamı | Ne şimdi, ne sonra, ne hiç | `§10.1` · `§10.4` + 11 kapsam listesi | **`T-169`** ⛔ |

**Üç bölüm bloklu**, ve üçü de `SORULAR.md`'nin domain sorularına bağlı.

**`1.7` özel durumda:** kaynak bu yeteneği hiç tanımlamamış (11 kapsam listesi tarandı).
Yani o bölüm bir **yorum değil, yeni bir ürün tanımı** olacak.

Ama kapsamı ölçüldü ve tahmin edilenden dar: zincirin **yarısı zaten var** — hakediş talebi
üretimi ve anlaşma kapanışı çalışıyor (ikincisinin kullanıcı yüzeyi yok). Yazılacak olan
dört parça: talep nesnesi, karşı taraf perspektifi, eşleştirme mantığı, dönem kapanışı.

---

## 3 · L2 — İş Kuralları

**Amaç:** normatif kuralları sözleşme diliyle, tek yerde, çelişkisiz vermek.

**Uzunluk hedefi:** 25-35 sayfa. Referans belgesi — baştan sona okunmaz.

| Bölüm | İçerik | Kaynak | Not |
|---|---|---|---|
| 2.1 Veri modeli | Varlıklar, ilişkiler, zorunlu alanlar | `§3.1–3.6` · mevcut şema | Şema ölçülü, kaynakla farklar kayıtlı |
| 2.2 Bütçe kuralları | Rezervasyon · taahhüt · tüketim · iade · eşikler | `§3.3` · `ADR 0004` · `INV-B-*` | |
| 2.3 Defter kuralları | Append-only · ters kayıt · idempotency · kapsam sınırı | `§3.6` · `INV-L-*` | Sınır üç kaynakta doğrulandı |
| 2.4 Hesaplama kuralları | Formül motoru · bağımlılık sırası · eksik veri · yuvarlama | `§5.3` · `ADR 0007/0008/0011` | ⚠️ Kaynak `\|\| 0` diyor, biz `null` — **bilinçli sapma** |
| 2.5 Onay kuralları | Durum makinesi · eşikler · yetki · zaman aşımı | `§3.4` · `§7.3` · `ADR 0002` | `T-158` (zaman aşımı) |
| 2.6 Yetki modeli | Yetenekler · roller · kapsam filtresi | `§7.1–7.3` | `T-165` ⛔ |
| 2.7 Veri kalitesi | Tazelik · tamlık · tolerans eşikleri | `§6.1` | Kabul kapısına çevrilebilir |
| 2.8 Entegrasyon | ERP uçları · içe aktarma semantiği · hata kanalı | `§6.2` · `Sprint_0 AI-001` | `T-126` (commit semantiği) |
| 2.9 Saklama ve uyum | On saklama kuralı · KVKK · e-fatura | `§9.5` · `§9.8` · `§6.6` | `T-170` ⛔ hukuk |
| 2.10 Bildirimler | Dokuz olay · kanallar · alıcılar | `MC-002` + üç dağınık kaynak | Kaynak eksik yazılmış |
| 2.11 Denetim kaydı | Yirmi olay · değişmezlik · kapsam | `§7.4` · `§9.5` | `T-168` |
| 2.12 Ölçeklenebilirlik | Kapasite hedefleri · performans bütçeleri | `§9.1–9.3` | `0064-SCALE` · `0064-TENANT` |

---

## 4 · Kaynak izlenebilirliği

Her bölümün sonunda bir **kaynak haritası** olacak:

```
Kaynak:     paket §X.Y · ADR NNNN · ölçüm 00NN
Değişen:    ne, neden
Düşen:      ne, neden
Okunmadı:   hangi kısım, gerekçesi
```

**Neden ayrı bir katman:** okuyucu belgeyi okur, bir maddenin nereden geldiğini merak
ederse haritaya bakar. İçerik akışı bölünmez, ama iz kaybolmaz.

Ve **okunmamış kısımlar görünür kalır** — `0059` envanterinin kapatmaya çalıştığı boşluk.

---

## 5 · Bloklayan kararlar — yazım sırasını belirliyor

### Güncel durum (2026-08-11)

**L2'nin on iki bölümü de yazıldı.** Yaklaşım değişti: bölümü bloklu bırakmak yerine,
**kararı verilmiş kısımlar yazıldı, açık kurallar `⛔` işaretlendi.**

```
L2   12/12 bölüm yazıldı  ·  ~120 kural  ·  18'i açık
L1   yazılmadı — karar turundan sonra
```

Açıkların dağılımı: 6 kapsam · 5 karar · 3 domain · 2 hukuk · 2 teknik.

**Bu yaklaşım daha iyi çalıştı:** bölümü bloklu bırakmak, hangi kuralın neyi beklediğini
görünmez kılıyordu. Şimdi tek yerde — ve karar turunun gündemi ondan türetildi.

### Kalan sıra

1. ✅ L2 tamamlandı
2. **Karar turu** — 21 karar, üç oturum (`KARAR_TURU_GUNDEM.md`)
3. Kararlar L2'ye işlenir — 18 kural `⛔` işaretini kaybeder
4. **L1 yazılır** — en son

**L1 neden en son:** yetenek haritası L2'nin özeti gibi çalışır, ve 18 açık kural onun üç
bölümünü doğrudan etkiliyor (özellikle başlangıç noktaları ve hakediş).

Bu, sezgiye ters — normalde önce yetenek haritası yazılır. Ama burada **kurallar ölçülmüş,
yetenekler tartışmalı**, ve ölçülmüş olandan başlamak daha az yeniden yazma üretti.

---

## 6 · Bu iskeletin kendi sınırları

1. **Uzunluk hedefleri tahmin.** Bugünkü paket 19.800 satır; hedef ~%60'ı. Ama ölçülmedi —
   ve bu oturumda kapsam tahminleri beş kez düşük çıktı.
2. **L1/L2 ayrımı sınanmadı.** *"Yetenek"* ile *"kural"* arasındaki sınır bazı bölümlerde
   net değil (örneğin onay modeli ikisinde de var).
3. **Ekran katmanının nerede yaşayacağı kararlaştırılmadı.** BRD'den çıkarıldı ama nereye
   gideceği yazılmadı.
4. ✅ **Rakip/segment analizi geldi** (2026-08-11) ve L0 güncellendi. Kaynağın kendi
   ayrımı korundu: doğrulanmış iddialar ile gerekçeli-ama-doğrulanamaz olanlar ayrı.
5. ✅ **`0058` doğrulandı** (2026-08-12): frontend `d9bedc5`, ağaç temiz, pointer senkron,
   ve ölçümden sonra frontend'e hiç commit gitmemiş. Görüntüler bugünkü koda ait.
6. **Müşteri karması bilinmiyor** — ve üç kararı askıda tutuyor: kârlılık modunun ilk günden
   zorunlu olup olmayacağı, artımsallık katmanının zamanlaması, genel amaçlı iş akışı
   motorunun gerekliliği.
