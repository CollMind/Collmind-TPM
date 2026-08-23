# `Faz 2` — AÇIK KARARLAR listesi

> ⛔ **BU BİR ÇIKIŞ ÖLÇÜTÜ DEĞİLDİR.**
> **Ürün sahibi kararı (2026-08-21):** *"`Faz 2` çıkış ölçütü henüz yazılmasın —
> `Faz 1` bitmeden erken, ve bu `9` boşluk onun **girdisi**."*

Bu belge yalnız **girdiyi** tutar. Çıkış ölçütü `Faz 1` kapandıktan sonra, bu liste
karara bağlandıktan sonra yazılır.

---

## ⛔ KAPANIŞ-KOŞULLU KARARLAR — mekanik izleme (`Z25`, 2026-08-23)

> **Kapanış-koşullu her karar, koşulu TETİKLEYEN task'ın *"kapattıkları"* listesine
> girer.** Yoksa koşul karşılanır ve **kimse fark etmez**.

**Vaka:** `Z21` şart `3` — *"`POST /budget-allocations` … e2e akışları zarf yoluna
göçtüğünde kaldırılır."* Göç `T-270`'te oldu, karar **üç tur boyunca** *"bekliyor"*
göründü. Bulan şey bir mekanizma değil, bir ajanın **brief taramasıydı**.

| karar | KOŞUL | TETİKLEYEN | DURUM |
|---|---|---|---|
| `Z21` şart 3 (`POST` musluğu) | e2e zarf yoluna göçtüğünde | `T-270` | ✅ **koşul karşılandı** → `Z24` ile kapandı |
| `Z21` seçenek 2 (`cpl_id` zarfa) | CPL-bazlı bütçe **gerçek müşteri ihtiyacı** olarak kanıtlanırsa | danışman turu / ilk müşteri | ⏳ bekliyor |
| `Z22` paylaşılan-eksen filtresi | kanal/kategori bazlı zarf **talebi** doğarsa | — | ⏳ bekliyor · ⚠️ maliyet **revize**: tüketici tarafı zaten kurulu (`T-272`) |
| `T-235` `T-028c` bayrağı | prod/UAT'de backfill doğrulanana kadar | prod/UAT ortamı | ⛔ **KİLİT** — sağlayıcı bugün YOK |
| `0073` `report-only` envanteri | fiili trafikte doğrulanır | deploy edilmiş ortam | ⛔ **KİLİT** — sağlayıcı bugün YOK |

⚠️ **İki satır `⛔ KİLİT`** — sağlayıcısı **var olmayan** bir ortama adresli. `§`'nin
kuralı: *"sağlayıcısı olmayan şart bir erteleme değil bir kilittir."*

📌 Ve `Z25`'in ayrımı: **kilit** = sağlayıcı yok · **kaçırılan koşul** = sağlayıcı
**vardı, geldi, ve kimse fark etmedi.** İkincisi daha sinsi, çünkü liste *"bekliyor"*
derken doğru görünür.

---

## Nereden geldi

`0075` (hakediş senaryoları, **kör sınav**) `18` boşluk iddia etti. `0076` onları
`L2 2.13`'e karşı ölçtü:

```
18 boşluk iddiası
 →  9  KURAL YOK      gerçek boşluk, L2 de sessiz     ← BU BELGE
 →  3  KISMEN VAR     ilke var, uygulama detayı yok
 →  6  KURAL VAR      0075 kaçırdı ya da yanlış varsaydı
```

⚠️ **Ve `9`'un biri `Faz 1`'e taşındı** — aşağıya bakınız. Bu belgede **sekiz** var.

## ⚠️ İkinci kaynak sınaması YAPILAMADI

`wella_actuals_first_scenarios.md` ile karşılaştırma yapıldı (`0076`'nın sonu) ve
sonuç: **`18` boşluk ne doğrulandı ne çürütüldü.** İki belge **farklı soruyu**
cevaplıyor:

```
wella   BİZ nasıl kaydederiz     ← hakediş zincirinin İLK yarısı
0075    KARŞI TARAF ne gönderir  ← ikinci yarısı
```

📌 Yani bu sekiz boşluk **tek kaynaktan** geliyor, ve bu **yazılı bir sınırdır**.

---

## SEKİZ AÇIK KARAR

| # | boşluk | senaryo | `L2`'nin bugünkü sınırı |
|---|---|---|---|
| **1** | Dış talep tutarının **KDV bileşeni** | `S1` | `K-2.13.4` alan listesi ve `K-2.13.14h6` (NET tanımı) — **vergi hiç geçmiyor** |
| **3** | **Kademe 2 anahtarı boşken** davranış | `S1` | `K-2.13.12` yalnız anahtar listesi verir, boş-anahtar davranışı yok |
| **7** | *"Gerçekleşti ama doğrulanmadı"* ara durumunun **görünürlüğü** | `S2` | `K-2.13.14e` **kavramı** tanımlıyor, arayüz durumu/rozeti hiçbir kuralda yok |
| **10** | **Araştırma süresince defter durumu** | `S3` | `K-2.13.18` yalnız *"mutabakat sonucu deftere yazılır"* — sonuçtan **ÖNCEki** durum tanımsız |
| **15** | Serbest bırakılmış bütçeye **sonradan gelen yükümlülük** | `S5` | `K-2.13.22a` yalnız serbest bırakma kuralını tekrarlıyor |
| **16** | *"İç talep üretilemedi"* **bildirimi** | `S6` | `K-2.13.10` eşleştirmenin çıkarım olduğunu söylüyor; **proaktif uyarı yok** |
| **17** | Boş aday kümesinin **kök neden ayrımı** | `S6` | `K-2.13.13` yalnız *"kaybolmaz, elle çözülür"* |
| **18** | **Kuyruğun yeniden taranması** | `S6` | hiçbir kuralda tetikleyici mekanizma yok |

### ⚠️ Sınıflandırma — hepsi aynı ağırlıkta değil

```
KAVRAM eksik      1 (KDV)                        →  veri modeline dokunur
DAVRANIŞ eksik    3 · 10 · 15 · 18               →  kural yazılır
ARAYÜZ eksik      7 · 16 · 17                    →  EK_E'nin 🔒 sınıfı ("mekanizma var, yol yok")
```

📌 Son üçü `EK_E`'nin **`🔒`** kategorisiyle aynı aile: yetenek var, arayüzü yok. Ve
`CLAUDE.md`'nin uyarısı geçerli — **`🔒` bir kabul değil, bir alarmdır.**

---

## ⚡ DOKUZUNCU BOŞLUK `FAZ 1`'E TAŞINDI — `Boşluk 4`

```
Boşluk 4   Kuyruğun SAHİBİ / SLA / eskalasyon           S1   KURAL YOK
L2 sınırı  K-2.13.13   "kaybolmaz, elle çözülür"
           K-2.13.12a  kimin ONAYLAYAMAYACAĞINI söyler
                       ama kimin SAHİP olduğunu SÖYLEMEZ
```

**Neden `Faz 1`:** `ADIM 3`'ün taksonomisi kuyruğu **bir yetenek hücresine** koyacak —
yani *"kuyruğa kim bakar"* sorusu `Faz 2`'ye ertelenemez, `ADIM 3` onu **zaten
cevaplamak zorunda**.

⚠️ Ve `Z18`'in kuralı burada bağlayıcı: **hiçbir hücre-rol çifti union gerekçesiyle
yaşayamaz.** Kuyruk bir hücreye konurken *"union böyle dedi"* yeterli değil — **sahiplik
bir ürün kararıdır.**

📌 Adres: `docs/process/ADIM3_FAZB_PLAN.md`, `B1`'in girdisi.
