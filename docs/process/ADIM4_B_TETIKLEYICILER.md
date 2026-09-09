# `(B)` — 🔎 TETİKLEYİCİ-SORULAR
### Team Lead · 2026-09-09 · `S3`'ün onu + gri-9'un çözümü

> **Ölçüt (ürün sahibi, `H3` revizesi):** *"aile = **aynı tetikleyici-sorunun**
> sorulduğu maddeler — boyut değil."* ⇒ Gri bir madde iki aileye düşüyorsa,
> **iki tetikleyici taşıyordur**: ya **BÖLÜNÜR**, ya biri diğerinin **sonucuysa**
> **BİRLEŞİR**.

## `B1` · GRİ-9 ÇÖZÜLDÜ — tetikleyici hangi aileyi seçtiyse o

| # | 🔎 ne zaman | ⇒ aile | gerekçe |
|---|---|---|---|
| 8 | *"bir işaretleyici gördüm (`@deprecated`/`TODO`) — bu bir ölçüm mü?"* | **F01** | soru **ölçüm-önce**dir; `ad` yönü (F06) ikincil — işaretleyici doğru adlandırılmış, **dayanağı** yok |
| 11 | *"bir yokluk iddia edeceğim — sorgum onu gerçekten ölçüyor mu?"* | **F02** | soru **evren/negatif kanıt**; `LEFT JOIN` bir **arama şekli** — F01 değil |
| 20 | *"bu yorumu okuyup karar vereceğim"* | **F10** | soru **belge/kayıt güvenilirliği**; kusuru **örtmesi** (F03) sonucu, sebebi değil |
| 27 | *"iki küme birebir mi — dalgayı açayım mı?"* | **F02** | soru **kapsam/evren eşleşmesi**; `DUR` (F09) onun **sonucu** |
| 29 | *"şartlar sıralı — ayrı ayrı inebilirler mi?"* | **F05** | soru **gerekçe/şart yapısı**; kayıt (F10) değil |
| 66 | *"bir idempotency anahtarı yazıyorum"* | **F07** | soru `tanım → yazar → kısıt` zincirinin **anahtar** halkası; provenance (F01) sonucu |
| 73 | *"bir rotayı genişletiyorum — bu bilgi mi açıyor?"* | **F07** | soru **yetki/sözleşme** yüzeyi; kayıt (F10) ikincil |
| 80 | *"bir yetki nerede yaşıyor — DB mi kod mu?"* | **F07** | aynı zincir; ⛔ ve **cevabın İKİLİ olması** onu F07 yapar |
| 97 | *"bir yetkiyi genişletiyorum"* | **F07** | soru **yetki yüzeyi**; *"ilk gerçek trafik"* (F03 pin) sonucu |

⛔ **Dokuzunun HİÇBİRİ bölünmedi ya da birleşmedi** — dokuzu da **tek** tetikleyici
taşıyordu; belirsizlik **konudan** değil, **benim iki ailede birden görmemden** geliyordu.
📌 ⇒ Tetikleyici-ölçütü **çalışıyor**: aynı listeyi ikinci kez okumak yerine, **soruyu**
sordum ve dokuzu da tek geçişte ayrıldı.

## `B2` · `S3`'ÜN ON KURALI — 🔎, ve `Z110`'un ölçeceği yer

| # | kural | ihlal | 🔎 ne zaman |
|---|---|---|---|
| 1 | SAYI YAZMA, **LİSTE** YAZ | **10** | *"bir sayı yazacağım"* |
| 2 | elle yazılmış üye-sayısı | **9** | *"bir üye/eleman sayısı yazacağım"* |
| 3 | `§7.1` kardeş yol sayımı | **8** | *"bir davranışı düzeltiyorum"* |
| 4 | mutasyon hedefleme (satırı **BAS**) | **6** | *"mutasyon uygulayacağım"* ⇒ `mutate.sh` |
| 5 | liste ≠ evren | **5** | *"bir desen yazdım ve bir sayı aldım"* ⇒ `scan.sh` |
| 6 | case-insensitive refleksi | **4** | *"ilk taramamı yapıyorum"* |
| 7 | `Z87` NULL-collapse | **3** | *"bir `CHECK` yazıyorum"* |
| 8 | başlık sayıları | **3** | *"bir başlıkta sayı göreceğim/yazacağım"* |
| 9 | `Z69 §4c` taşıyıcı çürümesi | **3** | *"bir hükmün gerekçesi çürüdü"* |
| 10 | **F00** kural kendi yazarına | **3+** | *"bir kural/kapı/araç yazıyorum — kendime uyguluyor muyum?"* |

> ### ⛔ `1` ve `2` **BİRLEŞTİ** (`H5`): aynı kuralın **anlatı** ve **belge/kod** yüzü.
> ### Ve **19 vakayla bir ARAÇ hak ettiler** — `scan.sh`'ın çıktısı **LİSTE** olduğu
> ### için *"sayı, `scan.sh` çıktısından TÜRER"* pratiği artık **araca bağlı**.

## `B3` · ⛔ TETİKLEYİCİ **DURUM DİLİNDE**, AD DİLİNDE DEĞİL
```
✅  🔎 "bir sayı yazacağım"                 ← ajan bu DURUMDA olduğunu bilir
⛔  🔎 "SAYI YAZMA kuralı"                  ← ajan kuralın ADINI bilmez
```
Ajan kuralın **adını** bilmez, **durumu** bilir. Tetikleyici bir **başlık** değil,
bir **arama yüzeyidir**.

## `B4` · ⛔ NE ÖLÇMEDİM
```
· kalan 209 maddenin 🔎'ları YAZILMADI — (A)-küçük'ün işi
· 'tetikleyicisi yazılamayan madde' henüz HİÇ ÇIKMADI (R2'nin eleme yüzü
  bu turda TETİKLENMEDİ) ⇒ eleme gücü ÖLÇÜLMEMİŞ bir varsayım olarak duruyor
· S3'ün ihlal sayıları İTİRAF-bazlı ⇒ ALT SINIR (S8'de yazılıydı, hâlâ geçerli)
```
