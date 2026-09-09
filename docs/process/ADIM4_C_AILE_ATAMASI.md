# `(C)` AİLE ATAMASI — 218 KURAL, 16 AİLE
### Team Lead tam turu · 2026-09-09 · ⛔ ürün sahibinin GRİ-BÖLGE kararını bekliyor

> Atama **insan yargısıyla** yapıldı — mekanik anahtar-kelime geçişi `125/218` gri
> verdi ve **desenin artığıydı**, gerçek belirsizlik değil. Yöntem kuralı uygulandı:
> ***mekanik tarama ADAY üretir, sınıflandırma İNSAN YARGISIDIR.***

```
F01  ölçüm-önce            37   F09  paralel-şerit           6
F04  kapı-doğum            29   F12  araç-hatası  ⭐YENİ     6
F10  brief-belge-kayıt     26   F06  ad ≠ sınıf              5
F05  gerekçe-yaşam         23   F11  seed ↔ fixture          5
F02  evren                 22   F14  ortam-bayatlık ⭐YENİ    5
F03  pin-kör-noktası       22   F15  düzeltme-disiplini      5
F07  tanım→yazar→kısıt     13   F13  hayatta-kalma ⭐YENİ     3
F08  sessiz-varsayılan     10   F16  port-yolu           ⛔ 1
                                    ─────────────────────────
                                    TOPLAM 218 · GRİ 12
```

## ⛔ BULGU 1 — ÜÇE BÖLME DEĞİL, **DAĞITMA** OLDU

Eski `DÜZELTME · PORT · BAYATLIK` **42 üyeliydi**. `H3` onu üçe bölmemi söyledi.
Okuyunca çıkan sonuç farklı:
```
F15 düzeltme-disiplini   5
F16 port-yolu            1   ⛔ TEK ÜYE
F14 ortam-bayatlık       5
─────────────────────────────
üçünün toplamı          11   ← 42 DEĞİL
```
⇒ Kalan **31 üye ASLINDA başka ailelere aitmiş** (`F01` · `F03` · `F05` · `F07` ·
`F08` · `F10`). Yani o aile bir **aile değil, bir ÇÖP KUTUSUYDU** — ve **1.322**
satırının sebebi de bu.

> ### ⛔ `H3`'ün hükmü *"üçe böl"*dü; ölçüm **"dağıt"** diyor. İkisi aynı şey değil,
> ### ve fark bir hüküm gerektiriyor.

## ⛔ BULGU 2 — `F16 port-yolu` **TEK ÜYELİ**

Bir aile tek üyeliyse **aile değildir**. Üç seçenek:
```
(a) F16 DÜŞER, tek üyesi (#57 'Port ederken bağlam taşınmaz') F05'e girer
(b) F16 KALIR — TTM port'u ileride büyürse yeri hazır olur (İlke 1'e AYKIRI:
    bugün ihtiyacı ÖLÇÜLMEMİŞ bir esneklik)
(c) F16 → F13 hayatta-kalma/taşıma ile BİRLEŞİR (ikisi de 'bir şey taşınırken
    ne kaybolur' sorusu — F13 bugün 3 üyeli)
```
📌 Ölçümüm `(c)`'yi destekliyor: `F13` (**RAPOR < BELGE < KAPI < PİN**, devir-teslim,
içerik/statü) ile `F16` (**davranış taşınır, bağlam taşınmaz**) aynı soruyu soruyor.

## GRİ BÖLGE — **12 madde**, iki aileye düşüyor

| # | önerim | başlık | çekişen aile |
|---|---|---|---|
| 8 | `F01` | `@deprecated` bir NİYET BEYANIDIR, bir ölçüm değil (ZORUNLU | |
| 11 | `F01` | `LEFT JOIN` + `IS NULL` bir YOKLUK testi DEĞİLDİR (ZORUNLU) | |
| 20 | `F03` | YORUM KİRLİLİĞİ iki yönde birden yanıltır (ZORUNLU) | |
| 22 | `F05` | Bir kuralı yazdığın tur, o kuralı en çok ihlal ettiğin tu | |
| 27 | `F02` | HÜCRE KÜMESİ ile ROTA KÜMELERİ BİREBİR DEĞİLSE DALGA DU | |
| 29 | `F10` | Bir SIRA şartı, AYRILABİLİRLİK şartı İÇERMEZ (ZORUNLU) | |
| 54 | `F10` | Testler bir ŞARTNAMEDİR — kod silinse bile (ZORUNLU, ve bir  | |
| 66 | `F07` | Köken imzası taşımayan bir idempotency anahtarı, PROVENANCE | |
| 73 | `F10` | Bir rota-GENİŞLEMESİ ne zaman BİLGİ-AÇILIMI sayılmaz (ZOR | |
| 80 | `F07` | `Yetkiler DB'de mi, kodda mı?` — cevap İKİLİ (ZORUNLU) | |
| 97 | `F07` | Her YETKİ-GENİŞLEMESİ, arkasındaki yüzeyin İLK GERÇEK TR | |
| 104 | `F09` | KAPSAM GENİŞLETME **YETKİSİ YOKTUR** — TEKLİF + ÖLÇÜM  | |

⛔ Bu on ikisi **gerçek belirsizlik** — anahtar-kelime artığı değil, okurken
tereddüt ettiklerim. `H3`: *"iki aileye düşen madde **birleştirme adayıdır**."*

## ⛔ NE ÖLÇMEDİM
```
· türev sayımı YAPILMADI — (A)'nın işi, ve senin hükmünle YALNIZ ≤1 vakalı
  maddelerde gerekiyor. O kümenin BÜYÜKLÜĞÜ henüz ölçülmedi.
· 🔎 tetikleyici YAZILMADI — (B)'nin işi, S3'ün on kuralından başlayacak
· atamanın KENDİSİ bir insan yargısı: ikinci bir okuma FARKLI sonuç verebilir
  ⇒ gri listesi bir ALT SINIRDIR
```

---
---

# ⭐ REVİZE — ÜÇ HÜKÜM UYGULANDI (2026-09-09)

## `H-1` · **DAĞITMA** — ve `H3`'e `F12`
```
~~"DÜZELTME · PORT · BAYATLIK üçe bölünür"~~
⇒ DAĞITILDI: 11 üye üç yeni aileye (F14/F15/F13) · 31 üye AİDİYETLERİNE
```
> ### ⛔ **VE 1.322 SATIRIN GERÇEK SEBEBİ KAYDA:** o aile **büyüdüğü için değil,
> ### AİLE OLMADIĞI İÇİN** büyümüştü.

⇒ **AİLE TANIMI** (ürün sahibi, `H3` revizesi):
```
aile = AYNI TETİKLEYİCİ-SORUNUN sorulduğu maddeler.   ⛔ BOYUT DEĞİL.
```

## `H-2` · `F16` → `F13` **TAŞIMA** (4 üye)
`RAPOR < BELGE < KAPI < PİN` · devir-teslim · içerik/statü · *"davranış taşınır,
bağlam taşınmaz"* — dördü de **tek** soruyu soruyor: ***bir şey taşınırken ne kaybolur?***
⛔ `(b)` (aileyi tek üyeyle yaşatmak) **`İlke 1`** ile reddedildi.

## `H-3` · `F00 META` — **YENİ AİLE**, 7 üye
```
#22  kuralı yazdığın tur en çok ihlal ettiğin turdur
#82  kural yazan tur, kuralın KENDİ ÜSTÜNDEKİ ilk mutasyonunu da koşar
#88  bir kapı ağının KENDİ SAĞLIĞINI ölçmesi
#147 KAPI, KAPIYI YAZAN TURU DURDURUR
#169 ÜÇÜNCÜ İHLAL YERLEŞİM KUSURUDUR
#179 KAPI, HÜKMÜ VEREN TURU DA DURDURUR
#196 KAPANIŞ BEYANI, KAPSAMADIĞINI YAZMADAN VERİLEMEZ
```
🔎 ***"bir kural / kapı / araç yazıyorum — kendime uyguluyor muyum?"***

⛔ **VE İKİ ÜYESİ HENÜZ YAZILMADI** — bu oturumun hükümleri, `DISIPLIN`'de **YOK**:
```
[ÖLÇÜLDÜ: grep -c ... docs/DISIPLIN.md → 0]
  "yargı sorusuna MEKANİK PROXY yazılmaz — tarama ADAY üretir, sınıflandırma İNSAN YARGISI"
  "gözlem → İKİNCİ vakada KURAL → ÜÇÜNCÜde ARAÇ"
⇒ DISIPLIN v2'de YAZILACAK. Aile 9 üyeye çıkar.
```

## NİHAİ DAĞILIM — **16 aile · 218 kural · GRİ 0**
```
F01 ölçüm-önce            36    F09 paralel-şerit            6
F04 kapı-doğum            25    F12 araç-hatası  ⭐YENİ       6
F02 evren                 23    F06 ad ≠ sınıf               5
F10 brief-belge-kayıt     23    F11 seed ↔ fixture           5
F03 pin-kör-noktası       22    F14 ortam-bayatlık ⭐YENİ     5
F05 gerekçe-yaşam         22    F15 düzeltme-disiplini       5
F07 tanım→yazar→kısıt     14    F13 TAŞIMA ⭐YENİ             4
F08 sessiz-varsayılan     10    F00 META ⭐YENİ               7
```
⛔ **GRİ 0** — dokuzu `(B)`'de **tetikleyici-ölçütüyle** çözüldü
(`docs/process/ADIM4_B_TETIKLEYICILER.md`), ve **hiçbiri bölünmedi ya da birleşmedi**:
dokuzu da **tek** tetikleyici taşıyordu. Belirsizlik **konudan** değil, **benim iki
ailede birden görmemden** geliyordu.
