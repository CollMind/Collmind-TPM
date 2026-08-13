# BRD v2.0 — Paket İndeksi

- **Sürüm:** taslak, 2026-08-12
- **Durum:** taslak — `L0` onay bekliyor, `L1`/`L2`/`L3` yazıldı

## Durum sayımı — tek kanonik yer

> ⚠️ Bu blok **script ile sayılır**, elle yazılmaz. Paketin başka hiçbir yerinde durum
> sayısı tutulmaz (dış denetim `F8`: sayı dört yerde dört farklıydı).

**Ölçüm: 2026-08-13** (son güncelleme: `K-2.9.0` ailesi — saklama askısı — ve `K-2.9.6`
kapandı)

| | |
|---|---|
| `L2` kural tanımı | **359** |
| Açık (⛔) kural | **2** — `K-2.5.12` onay hattı · `K-2.6.4` rol kümesi<br>⏸️ Ayrıca `K-2.9.0`: saklama bölümü **askıda** (hukuki mütalaa) — açık değil, **dondurulmuş** |
| Bölüm dağılımı | veri/bütçe/defter/hesap **145** · veri kalitesi/entegrasyon/bildirim/denetim **48** · onay/yetki/uyum **78** · hakediş/AI/kurulum **88** |
| Açık karar (kural dışı) | **3** — `ADR 0002` · veri ayrımı modeli · iade temsili |

**Sayım ve doğrulama:**

```bash
bash guard.sh .
```

`guard.sh` üç kontrol yapar ve sayıyı **indeksle karşılaştırır** — bu blok bayatlarsa
kırmızı verir:

| Kontrol | Neyi yakalar |
|---|---|
| Kural sayımı | `F8` — elle tutulan sayının bayatlaması |
| Kimlik tekilliği | `F2` — aynı numaranın iki kurala verilmesi |
| Sarkan atıf | Var olmayan bir kurala referans |

> ⚠️ **İlk koşuşunda iki gerçek ihlal yakaladı:** sayı uyuşmazlığı ve **dokuz sarkan atıf**
> — `2.12` `Ek A`'ya taşınırken atıflar eski numarada kalmıştı. Elle bulunamazdı.

> ⚠️ **Ve bir kalibrasyon notu:** paket boyunca `~120`, `~145`, `~160` sayıları yazılmıştı.
> Gerçek sayı **351** — iki katından fazla. Elle tutulan her sayı bayatlar; bu oturumda
> beşinci kez ölçüldü.
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
| `03_IS_KURALLARI/L2_*` | L2 | Geliştirici · analist | **Referans** — bir kural aranır |
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
| `L2_01_veri_butce_defter_hesaplama` | 2.1 veri modeli · 2.2 bütçe · 2.3 defter · 2.4 hesaplama |
| `L2_02_veri_kalitesi_entegrasyon_bildirim_denetim` | 2.7 · 2.8 · 2.10 · 2.11 |
| `L2_03_onay_yetki_uyum` | 2.5 onay · 2.6 yetki · 2.9 uyum |
| `L2_04_hakedis_ai_kurulum` | 2.13 hakediş · 2.4.8 AI sınırı · 2.14 kurulum |

> `2.12 Ölçek` bu katmandan **çıkarıldı** — işlevsel olmayan gereksinim, iş kuralı değil.
> `EK_A_NFR.md`'de `NFR-*` olarak yaşıyor.

---

## Okuma sırası önerisi

**Ürünü ilk kez tanıyan:** `URUN_OZETI` → **`02_YETENEK_HARITASI`**

**Bir kararı sorgulayan:** **`04_KARAR_KAYDI`** → ilgili `L2` kuralı

**Kod yazan:** `03_IS_KURALLARI/L2_*` — ilgili bölüm

**Ürün yönü tartışan:** **`01_KONUMLANMA`**

> ⚠️ Bu blok 2026-08-12'de düzeltildi: üç dosya adı **bayattı** (`01_YETENEK`, `03_KARAR_KAYDI`,
> `00_KONUMLANMA`) ve o adlarda dosya **yok**. `guard.sh` yakalayamadı — üç kontrolü de kural
> kimliğine bakıyor, **dosya adı atıflarına bakmıyor**. Dördüncü kontrol adayı.

---

## Açık kalanlar

Beş madde. **Kanonik liste burada değil** — `04_KARAR_KAYDI.md §Hâlâ açık`'ta.

| nerede | işlevi |
|---|---|
| `04_KARAR_KAYDI.md §Hâlâ açık` | **kanonik** — konu + neyi beklediği |
| `docs/decisions/OPEN_DECISIONS.md` | **indeks** — her madde `v2-*` ID'siyle, neyi blokladığı ve türü (karar · hukuk · teknik ölçüm) |

> ⚠️ Bu bölüm bilerek **kopya taşımıyor**. Üç yerde üç liste `F8` üretir: biri güncellenir,
> ikisi bayatlar, ve okuyan hangisinin geçerli olduğunu bilemez. Sayı bile yazılmadı —
> *"beş"* dışında bir ayrıntı istiyorsan kanonik listeye git.

---

## Kapsam dışı — bilerek

**Faz 2'ye bırakıldı:** devir · onay politikası kural yazımı · otomatik zaman aşımı · senaryo
analizi · bölge ekseni · yapay zeka kenarları.

**Hiçbir faza girmiyor:** muhasebe tahakkuku (ERP'nin işi) · kişiye özel yetki istisnası ·
karma çalışma biçimi · serbest biçimli kural motoru · orantısal atıf · kapsama eşiği.

> **Reddedilmiş bir seçenek, unutulmuş bir seçenekten iyidir.**

---

## Bu paketin sınırları

1. **`L0` bir taslaktır** ve onaylanmadı. Onaylandığında **`ADR 0013`** olarak karar
   defterine girer.
   ⚠️ `ADR 0012` **dolu** — `0012-finansal-kayitlar-fiziksel-silinemez.md` (2026-08-12).
   Numara ölçülerek düzeltildi.
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
