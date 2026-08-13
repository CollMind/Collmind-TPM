# Team Lead — Biriken İş Listesi

- **Tarih:** 2026-08-12
- **Kaynak:** karar turu (21 karar) + `L2` yazımı + yapı denetimi
- **Not:** hiçbiri henüz task'a dönüşmedi. Sıra ve gruplama önerisidir.

---

## Nasıl okunur

Beş grup, farklı türde iş:

| Grup | Ne | Aciliyet |
|---|---|---|
| **A** Kayıt düzeltmeleri | Yanlış veya bayat kayıtlar | Hemen — yanlış bilgi taşıyor |
| **B** Şema alanları | Deploy öncesi ucuz, sonra pahalı | Bu hafta |
| **C** Ölçümler | Karar veya doğrulama bekliyor | Karar sırasına göre |
| **D** Canlı kusurlar | Bugün kullanıcıyı etkiliyor | P1 |
| **E** Guard'lar | Kararların korunması | Kararla birlikte |

---

# A · Kayıt düzeltmeleri

Bunlar **bugün yanlış bilgi taşıyor.** Küçük ama önce.

## A1 · `ADR 0006` revize edilir → `0006-R`

Eski gerekçe: *"kaynakta lumpsum dağıtımı için açık formül yok."*

**Ölçüm bunu yanlışladı** (`0067`): formül var, planlama modu bölümünde, tabanıyla birlikte —
*"planlanan hacme orantılı"*. O bölüm daha önce ⚪ kovasındaydı.

Ve karar turu tabanı **planlanan hacim** olarak değiştirdi (`K-2.4.17`).

→ ADR yeniden yazılır; eski gerekçe **silinmez**, yanlışlandığı kayıtla durur.

## A2 · `ADR 0002` yeniden onay bekliyor

Dayanağı sonradan **geçersiz ilan edilmiş** bir özet belgeydi. Ve kaynak farklı diyor:
finans yöneticisine **genel ikinci kademe** onay yetkisi veriyor.

⛔ Karar turunda açık bırakıldı (`K-2.5.12`).

→ Ya yeniden onaylanır ya değiştirilir. Bugünkü hâli *"dayanaksız yürürlükte."*

## A3 · Tur 21'in kaydı düzeltilir

İçe aktarma yetkisi kararı *"backend kazandı"* diye kaydedilmişti — bu bir **kural
uygulaması**, gerekçe değil.

Doğrusu (`K-2.6.5a`): eşleştirme katmanı yokken **giriş = karar**, dolayısıyla bugünkü kısıt
bir **telafi kontrolüdür** ve geçicidir.

## A4 · `INV-T-002`'nin kapsamı genişletildi

Yeni tanım: **son gönderen ∪ içeriği son değiştiren** (`K-2.5.11`).

→ `SYSTEM_INVARIANTS`'a işlenir. Ve `A3` grubunun ölçümüyle bağlantılı (`C1`).

## A5 · `INV-L-*` ailesine üç yeni invariant

Karar turundan doğdu:

```
Σ(transfer bacakları) = 0                          K-2.2.9l
Σ(SKU hacimleri) = FU hacmi                        K-2.1.8e
Σ(taktik gerçekleşmeleri) + FARK = dış talep       K-2.13.14j
dönem kapanışında açık tahakkuk = 0                K-2.13.25c
kapsama < %100 iken tam-kapsama paleti yasak       K-2.4.22c
importer ≠ eşleştirme onaylayan                    K-2.13.12a
```

Sonuncusu `INV-T-002`'nin aynası — aynı aileye.

## A6 · `L0` terim çakışması

Konumlanmanın üç kademeli merdiveni *"mod"* kelimesini kullanıyor; `A1` kararı o kelimeyi
öldürdü.

→ `L0`'da **"yetenek kademesi"** olarak yeniden adlandırılır (`K-2.1.12j`).

---

# B · Şema alanları — deploy öncesi ucuz

Altı karar aynı gerekçeyle alan ekletti: **bugün ucuz, sonra göç acısı.** Ve birkaçı için ek
gerekçe var: alan olmazsa karar **yeniden icat edilir.**

| # | Alan | Karar | Gerekçe |
|---|---|---|---|
| B1 | `settlement_cadence` · `accrual_schedule` | `K-2.1.13` | Süreden türetme yeniden icat edilmesin |
| B2 | İçe aktarma köken bilgisi (kim, ne zaman, dosya özeti) | `K-2.13.12b` | Görev ayrılığı ancak kökenle denetlenebilir |
| B3 | Onay politikası tablosu + Faz 2 alanları (`mode`, `delegate_allowed`) | `K-2.5.13e` | Üç kararın Faz 2'si aynı tabloya iniyor |
| B4 | `SÜRESİ DOLDU` durumu + geçiş tablosundaki yeri | `K-2.5.10e` | Davranış Faz 2'de, enum bugün |
| B5 | Fatura-içi kayıtlara **anlaşma referansı** | `K-2.13.14l` | Kanıt merdiveninin ilk basamağı kör |
| B6 | SKU: `satış birimi` + `çevrim çarpanı`; çekirdek tablolardan birim alanı **çıkar** | `K-2.1.12c` | Uyuyan 12 kat hata bugün kapanır |
| B7 | Bütçe politikası tablosu: `UNIQUE(tenant, kanal, kategori)`, öncelik kolonu **yok** | `K-2.2.8b` | Açıklanabilirlik yapıya gömülü |
| B8 | Roller varlık olur (`roles` + `user_roles`) | `K-2.6.5a` | Politika tablosu role referans verecek |
| B9 | Talep varlığı: `kaynak: İÇ \| DIŞ` + eşleştirme bağ varlığı | `K-2.13.5` | — |

⚠️ **`B6` özel:** bu yalnız ekleme değil, **çıkarma** da içeriyor. Çekirdek tablolarda birim
alanının olmaması kararın kendisidir — *"en iyi doğrulama, doğrulanacak alanın olmamasıdır."*

---

# C · Ölçümler

## C1 · `INV-T-002` bugün nereye bakıyor?

Kontrol yalnız `submittedBy`'a bakıyorsa **bir bypass açık**: planı yazan kişi onu bir
başkasına gönderttirip kendisi onaylayabilir.

→ Ölç, ve `A4`'ün genişletilmiş kapsamına göre düzelt.

## C2 · İade veride nasıl temsil ediliyor?

`K-2.13.14h6` net satış tanımını verdi ama **iade davranışı açık** — ve formül ondan önce
yazılamaz.

`sales_actuals`'ta iade negatif satır mı, ayrı alan mı? **Tek sorgu.**

## C3 · `net = brüt − indirim` tutarlı mı?

Üç alan bağımsız geliyorsa tutarsız bir üçlü sessizce hesaba girer — ve taban kararının
bütün titizliği kirli veriyle boşa düşer (`K-2.13.14h7`).

→ Mevcut veride ölç, ve bir doğrulama kuralı ekle.

## C4 · Veri ayrımı modeli — geçiş maliyeti

⛔ `NFR-3` açık: paylaşımlı tablo / şema başına / veritabanı başına.

Üçünün **bugünkü** maliyeti aynı (tek müşteri), **geçiş** maliyeti çok farklı — ve
ölçülmedi.

## C5 · Klasör bölmesinin kapsamı

`A1` kararı bölmeyi **ölü ilan etti** ama birleştirme ayrı bir iş.

→ Ölç: iki `modes/` dizininde gerçekten farklı olan ne, ortak olan ne? Ve `İlke 4` ihlali
olarak kaydedilen sekiz vakanın kaçı bu bölmeden doğdu?

**Big-bang birleştirme yok** — ölçüm sıralamayı belirler.

---

# D · Canlı kusurlar

Bugün kullanıcıyı etkiliyor, ve üçü karar turuyla **öncelik kazandı.**

## D1 · Finans yolunda `GRİ → YEŞİL` sızıntısı ⚠️ **en öncelikli**

*"Renk yok"* değeri raporlama yolunda sessizce **yeşile** dönüşüyor.

> Bu, **en tehlikeli türden** bir kusur: tam da güven beyanını sahteleştiriyor
> (`K-2.4.22c`).

## D2 · Kapsama oranı istemciye ulaşmıyor

`GRİ` durumu rozetsiz kalıyor — ve `K-2.4.22a` onu birinci sınıf bir durum ilan etti.

## D3 · Taktik değeri ekrana dönmüyor

`K-2.1.8i` bunu **bir MVP şartı** yaptı: miras görünmezse kullanıcı güvenmez.

→ Artık bir kusur değil, bir yetenek gereksinimi.

## D4 · Anlaşma kapanışının arayüzü yok

Mekanizma olgun (eşzamanlılık, çift-sayma koruması, iki e2e) ama **hiçbir ekrandan
çağrılamıyor.**

## D5 · Beş rapor menüde var, hiçbiri çalışmıyor

`L1 §1.10` bunu *"karar destek katmanı konumlanmanın gerektirdiği seviyenin çok altında"*
diye kaydetti.

---

# E · Guard'lar

Kararların **korunması** — kural değil mekanizma.

## E1 · Klasör bölmesine yeni kod eklenemez ✅ **YAZILDI 2026-08-13**

`A1` kararının ikinci maddesi. Bir guard, `modes/` altına yeni dosya eklenmesini engeller.

`collmind.backend/scripts/guards/mode-split.sh` + `mode-split-baseline.txt`,
`run-all.sh` zincirine bağlı (`lib.sh` guard listesi). Uçtan uca ölçüldü: bölmeye dosya
kondu → runner **exit 1**; silindi → **exit 0**.

**Bugünkü sayı — ilerlemenin metriği** (her sprint sonunda `EK_E` sayımının yanına):

```
bölme: 101 dosya · 28.224 satır · 6 dış referans dosyası (16 import satırı)
```

⚠️ Baseline **liste** tutuyor, sayı değil — sayı-baseline *"biri düştü, biri girdi"*
gerilemesini görmez.

⚠️ **Bu iş bölmeyi ölçer ve DONDURUR — çözmez.** Birleştirme (ya da silme) `C5`'e bağlı,
ve `C5` üç sonuçtan birine gidiyor: *fark küçük + canlı* → dokunulan-yerden birleştirme ·
*fark büyük + canlı* → her adım ayrı issue · *fark her neyse + ÖLÜ* → **silme, ve silme
daha ucuz.** Guard üçünde de aynı işi yapıyor.

📌 **Kapsam dizin adıyla değil ölçümle tanımlandı:** `modes` adlı dizin tüm repoda **1**;
bölme dışında `*actuals-first*`/`*planning-first*` kardeş dizin **0**. Yani `DUR` koşulu
(*kapsam beklenenden geniş*) **tetiklenmedi** — ama referans yüzeyi ağacın dışına taşıyor
(`app.module.ts` · seed · `master-data`/`kpi`), ve baseline onu ayrı satır türüyle tutuyor.

## E2 · Kapsama < %100 iken tam-kapsama paleti yasak

`K-2.4.22c` — testle korunur.

## E3 · Geçersiz durum geçişleri

`İÇ` + `İTİRAZLI` gibi kombinasyonlar geçiş tablosunda yok; **şemada değil sözleşmede**
engellenir (`K-2.13.5e`).

## E4 · Denetim kaydı değişmezliği

`K-2.11.7` veritabanı seviyesinde koruma istiyor — bugün ölçülmedi bile.

## E5 · Eşik değişikliği denetim olayı üretir

`K-2.2.8e` — ve gerekçesi: bir eşik değişikliği **finansal davranış değişikliğidir.**

---

# Sıra önerisi

```
1.  A grubu           kayıt düzeltmeleri — küçük, ve yanlış bilgi taşıyorlar
2.  C1 · C2 · C3      ölçümler — ikisi bir kuralı blokluyor
3.  B grubu           şema — deploy penceresi açıkken
4.  D1 · D2           güven beyanını sahteleştiren iki kusur
5.  E2 · E5           yeni kararların guard'ları
6.  C5                klasör ölçümü — birleştirme planının girdisi
```

`D3`, `D4`, `D5` ve kalan `E` maddeleri ilgili yeteneklerin inşasıyla birlikte.

---

# Kapsam dışı — bilerek

**Faz 2'ye bırakılanlar:** devir · onay politikası kural yazımı · otomatik zaman aşımı ·
senaryo analizi · bölge ekseni · yapay zeka kenarları.

**Hiçbir faza girmeyenler:** muhasebe tahakkuku (ERP'nin işi) · kişiye özel yetki istisnası ·
`HYBRID` çalışma biçimi · serbest biçimli kural motoru.

> Bu ikinci liste değerlidir: **reddedilmiş bir seçenek, unutulmuş bir seçenekten iyidir.**
