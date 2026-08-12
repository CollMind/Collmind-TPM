# BRD v2.0 — Paket İndeksi

- **Sürüm:** taslak, 2026-08-12
- **Durum:** L0 taslak · L1/L2/L3 yazıldı · 6 kural açık
- **Yeri:** `docs/brd-v2/`

---

## Bu paket neyi değiştiriyor

Önceki BRD paketi (`docs/brd/`, ~19.800 satır) **kaynak olarak kalır** ama artık **birincil
belge değildir.**

Sebep ölçüldü: o pakette üç yerde üç farklı rol kümesi, dört farklı ölçek sayısı, iki farklı
kârlılık eşiği var — ve okuyan hangisinin geçerli olduğunu bilemiyor.

Bu paket **sıfırdan yazıldı**, ama kaynak izlenebilir kaldı: her bölüm bir kaynak haritası
taşır (*ne geldi, ne değişti, ne düştü, ne okunmadı*).

---

## Dosyalar

| Dosya | Katman | Kime | Nasıl okunur |
|---|---|---|---|
| `01_KONUMLANMA.md` | L0 | Herkes | Baştan sona — diğer her şeyin ölçütü |
| `02_YETENEK_HARITASI.md` | L1 | Herkes | Baştan sona — ürün ne yapar, bugün ne var |
| `03_IS_KURALLARI/` | L2 | Geliştirici · analist | **Referans** — bir kural aranır |
| `04_KARAR_KAYDI.md` | L3 | Herkes | Referans — *"bu neden böyle"* |
| `EK_A_NFR.md` | — | Teknik | İşlevsel olmayan gereksinimler |
| `EK_B_TASARIM_KARARLARI.md` | L3 | Danışman | 11 ADR, domain dilinde |
| `EK_C_VERI_SOZLUGU.md` | L2 eki | Geliştirici | Tablo · alan · tip · kısıt |
| `EK_D_AKIS_DIYAGRAMLARI.md` | L1 eki | Herkes | Durum makineleri, akışlar |
| `EK_E_YETENEK_ARAYUZ_ESLEMESI.md` | L1 eki | Ürün · geliştirici | **Boşluk haritası** |
| `URUN_OZETI.md` | — | Dışarıya | 5 sayfa, teknik terim yok |

⚠️ **`EK_C` bir ek, ayrı katman değil.** Ayrı katman olsaydı şema kararları kurallardan
koparadı — her tablo dayandığı kurala atıf verir.

⚠️ **`EK_E` ürünün en somut boşluk haritasıdır.** Ve iki durum ayrı işaretlenir: `❌` yetenek
yok · `🔒` **yetenek var, arayüzü yok.** İkincisi daha pahalıdır — yapılmış ama erişilemeyen
iş.

**Alt çizgiyle başlayanlar** süreç belgeleridir, ürün belgesi değil: `_ISKELET`
(yapı kararı), `_YAPI_DENETIMI` (yapının konumlanmaya karşı denetimi).

---

## Kural numaralandırması

`L2`'deki her kural `K-<bölüm>.<sıra>` biçiminde numaralı ve **bir kez** yazılı.

```
K-2.2.7c   bütçe eşikleri hakedişi durduramaz
K-2.4.22   renk yalnız tam kapsamada
K-2.13.5   talep tek varlıktır
```

Diğer belgeler ve kod yorumları bu numaraya **atıf verir**, kuralı tekrar etmez.

## L2 bölüm dağılımı

| Dosya | Bölümler |
|---|---|
| `01_veri_butce_defter_hesaplama` | 2.1 veri modeli · 2.2 bütçe · 2.3 defter · 2.4 hesaplama |
| `02_veri_kalitesi_entegrasyon_bildirim_denetim` | 2.7 · 2.8 · 2.10 · 2.11 |
| `03_onay_yetki_uyum` | 2.5 onay · 2.6 yetki · 2.9 uyum |
| `04_hakedis_ai_kurulum` | 2.13 hakediş · 2.4.8 AI sınırı · 2.14 kurulum |

> `2.12 Ölçek` bu katmandan **çıkarıldı** — işlevsel olmayan gereksinim, iş kuralı değil.
> `EK_A_NFR.md`'de `NFR-*` olarak yaşıyor.

---

## Okuma sırası önerisi

**Ürünü ilk kez tanıyan:** `URUN_OZETI` → `01_YETENEK_HARITASI`

**Bir kararı sorgulayan:** `03_KARAR_KAYDI` → ilgili `L2` kuralı

**Kod yazan:** `03_IS_KURALLARI` — ilgili bölüm

**Ürün yönü tartışan:** `00_KONUMLANMA`

---

## Açık kalanlar

Altı madde, ve türleri farklı:

| Konu | Bekliyor |
|---|---|
| Rol kümesi | Karar — kaynak üç farklı küme veriyor |
| Finans yöneticisinin onay hattı | Karar — `ADR 0002`'nin dayanağı düştü |
| Saklama sürelerinin bağlayıcılığı | **Hukuk** |
| Kişi bazlı performans raporlaması | **Hukuk** |
| Veri ayrımı modeli | Teknik ölçüm — geçiş maliyetleri |
| İadenin veri temsili | Teknik ölçüm — tek sorgu |

`OPEN_DECISIONS.md` bunları indeksler.

---

## Kapsam dışı — bilerek

**Faz 2'ye bırakıldı:** devir · onay politikası kural yazımı · otomatik zaman aşımı · senaryo
analizi · bölge ekseni · yapay zeka kenarları.

**Hiçbir faza girmiyor:** muhasebe tahakkuku (ERP'nin işi) · kişiye özel yetki istisnası ·
karma çalışma biçimi · serbest biçimli kural motoru · orantısal atıf · kapsama eşiği.

> **Reddedilmiş bir seçenek, unutulmuş bir seçenekten iyidir.**

---

## Bu paketin sınırları

1. **`L0` bir taslaktır** ve onaylanmadı. Onaylandığında `ADR 0012` olarak karar defterine
   girer.
2. **Uzunluk hedefleri tahmindir.** Ölçülmedi — ve bu kod tabanında kapsam tahminleri beş kez
   düşük çıktı.
3. ✅ **`L1`/`L2` sınırı sınandı** (`_YAPISAL_TAMAMLAMA.md`). Ölçüt resmileşti:
   *anlaşılamaz → L1, yanlış uygulanır → L2*.
4. ✅ **Ekran katmanının yeri kararlaştırıldı** — üçe bölündü: bilgi gereksinimi `L2`'de,
   yetenek↔arayüz eşlemesi `EK_E`'de, görsel tasarım BRD dışı.
   ⛔ Ama o tasarım katmanı **bugün yok** ve nerede yaşayacağı ayrı bir karardır.
5. **Müşteri karması bilinmiyor** — ve üç kararı askıda tutuyor: kârlılık kademesinin ilk
   günden zorunlu olup olmayacağı, artımsallık katmanının zamanlaması, genel amaçlı iş akışı
   motorunun gerekliliği.
