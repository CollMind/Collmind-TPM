# `Faz-1` Kapanış Denetimi — Brief

> **Tarih:** 2026-08-28 · **Yazan:** Team Lead · **Statü:** ⛔ **BİR `DUR` VAR** (`§4`)
> **Tur türü:** **tek oturum**, ölçüm + beyan. Kod turu **değil**.
> **İşaretleme:** `[ÖLÇÜLDÜ]` bugün canlı · `[GEREKÇELİ]` · `[VARSAYIM]`

---

## 0 · ⛔ İLK BULGU: **SKOR TABLOSUNUN KENDİSİ BAYAT**

Denetim, `FAZ1_PLAN §0b`'nin beş ölçütüne karşı yapılacak. **O tablo `2026-08-20`
tarihli ve o günden beri güncellenmedi** — sekiz gün ve **altı `ADIM`** geçti.

| # | tabloda YAZAN | bugün `[ÖLÇÜLDÜ]` |
|---|---|---|
| 1 | ✅ `K-2.6.13` kapandı | ✅ **doğru** |
| 2 | ✅ kapsam filtresi canlı | ✅ **doğru** |
| 3 | ⏳ `ADIM 3` | ⚠️ **BAYAT** — `ADIM 3` **mühürlendi**, `B4`/`A′` **default-deny indi** |
| 4 | 🔶 `T-244` **YARIM** | ⚠️ **BAYAT** — `T-244` `status: done`; ama **alt kalemi** (`sözlük Madde 2`, kullanıcı-yaratma olayı) **hâlâ `⛔ AÇIK`** |
| 5 | ⏳ `ADIM 5` | ⛔ **`RLS` bugün `0/48` tabloda açık** — ve bu **hükümle** böyle |

> ⛔ **Bir denetim, BAYAT BİR SKOR TABLOSUNA karşı yapılamaz.**
> **Denetimin İLK işi, tabloyu ölçümle yeniden doldurmaktır** — `✅`/`⏳` işaretlerini
> okumak değil.

📌 Ve `4`'ün şekli özellikle tehlikeli: task **`done`**, **alt kalemi açık**. Tabloya
bakan *"`T-244` bitti"* der ve **açık kalemi göremez.**

---

## 1 · MERKEZÎ SORU — ve denetimin gerçek konusu bu

```
ÖLÇÜT 5   "RLS uygulanmış"
ÖLÇÜM     main şemasında relrowsecurity = true olan tablo:  0 / 48   [ÖLÇÜLDÜ]
HÜKÜM     Z50/Z54 — aktivasyon İKİNCİ-MÜŞTERİ / DEPLOY eşiğinde
```

⇒ **`Faz-1`, beş ölçütünden biri AÇIKKEN kapanabilir mi?**

Bu bir *"evet/hayır"* değil, bir **gramer** sorusu — ve bu oturumda kurduğumuz gramer
cevabı zaten taşıyor:

> **"Bitti — VE kalan şuradadır."**

Üç okuma mümkün, ve **hangisinin seçildiği YAZILMALI**:

| | okuma | sonucu |
|---|---|---|
| `(A)` | Ölçüt **karşılanmadı** ⇒ `Faz-1` **kapanmaz** | ⛔ Faz, **kendi kontrolümüzde olmayan** bir eşiğe (ikinci müşteri) rehin olur |
| `(B)` | Ölçüt **yeniden yazılır**: *"`RLS` **kararı verilmiş ve inşası ölçülmüş**"* | ⚠️ Ölçütü **karşılayamadığımız için** değiştirmek — `DISIPLIN`: *"karşılanamayan bir ölçüt REVİZE EDİLİR, uydurma veriyle karşılanmaz"* **izin verir**, ama **gerekçe yazılmalı** |
| `(C)` | `Faz-1` **koşullu** kapanır: dört ölçüt ✅, beşinci **adresli-artık** | `T-321` için ürün sahibinin kullandığı **aynı şekil** (*"adresli kalır ama inşası kapanışı bloklamaz"*) |

**Team Lead görüşü: `(C)`** — çünkü `(C)` bu oturumda **zaten iki kez** hüküm oldu
(`T-321` · `T-324`), ve `(B)`'nin riski şu: **ölçütü değiştiren taraf, ölçülen
taraftır.**

⚠️ **Ama bu bir HÜKÜMDÜR ve senin.** Denetim oturumu bu cevap olmadan **beyan
yazamaz** — ölçümleri yapar, tabloyu doldurur, **beyanı bekler.**

---

## 2 · GİRDİ ENVANTERİ — ne hazır `[ÖLÇÜLDÜ]`

| girdi | durum |
|---|---|
| **Beş ölçüt** | `FAZ1_PLAN §0b` — **var**, ama bayat (`§0`) |
| **Bildirim halkası** | ✅ **HAZIR** — halka satırı ürün sahibince kabul edildi (`Z61 §7`) |
| **`T-321` hükmü** | ⏳ **beş-ölçüt masasında** — ön-eğilim kayıtlı, **hüküm denetim günü** |
| **`T-324` sonucu** | ⏳ **dalga koşuyor** (rol dönüşü + `48/48` + dokuz-tablo sınıflandırması) |
| **`Section-10` damgası** | ⚠️ kaynak `docs/analysis/0045` (`Section_10: ~230/567 = %41` okundu) — **damga METNİ yok**, yazılacak |
| **kalan-15 / koşul satırları** | `Z25` koşul satırı + `default-deny` muafiyet listesi — **tazelik ölçülecek** |
| **Dört-girdili `Faz-2` çakıştırması** | ⛔ **dört girdinin ADI yazılı değil** (`§4`) |
| **5-halka zincir envanteri** | ⛔ **TANIMSIZ** (`§4`) |
| Açık task | **187** — denetimin işi bunları kapatmak **değil**, ölçütle ilgisini kesmek |

---

## 3 · DENETİM OTURUMUNUN ÜRETECEĞİ ŞEYLER

```
1  BEŞ ÖLÇÜT — ölçümle yeniden doldurulmuş tablo (✅/⏳ okunmaz, ÖLÇÜLÜR)
2  5-HALKA ZİNCİR ENVANTERİ — tek sayfa, MÜHÜRLÜ
3  DÖRT-GİRDİLİ FAZ-2 ÇAKIŞTIRMASI
4  SECTION-10 KARANTİNA DAMGASI
5  KALAN-15 / KOŞUL SATIRLARI TAZELİK ÖLÇÜMÜ
6  ⇒ FAZ-1 KAPANIŞ BEYANI  (§1'in hükmüne bağlı)
```

⚠️ **Ve her biri için aynı şart:** bir maddenin *"tamam"* yazılması, **o maddenin
ölçümünün gösterilmesiyle** olur. `Z58`'in dersi: **teslim edilmeyen manşet, teslim
edilen dar iddiadan tehlikelidir.**

---

## 4 · ✅ TERİMLER TANIMLANDI *(ürün sahibi, 2026-08-28)*

### `4a` · **`5-HALKA` = ÇEKİRDEK DÖNGÜNÜN BEŞ ADIMI** — ölçütlerle ilgisi YOK

⛔ **Team Lead okuması YANLIŞTI** (*"beş ölçüt × zincir"*) ve ürün sahibi düzeltti:

```
anlaşma/plan → gerçekleşme → eşleştirme → settlement/claim → defter
```

Bu, ***"süreçler net mi"*** sorusuna verilen **envanter tablosunun MÜHÜRLENMİŞ hâli.**
Her halka için **üç sütun**:

| ne KANITLI | ne BEYAN | bilinen BOŞLUKLAR |
|---|---|---|
| hangi test/pin **tutuyor** | kod-okuması / varsayım | **adresli** olmalı |

**Bilinen boşluk adayları (ürün sahibinin verdiği):** `T-293` · `T-291` ·
on-invoice-veri-yokluğu · e2e'siz onay-uçları.

⛔ **VE İKİ ŞEY BU TABLOYA GİRMEZ — ikisi de YATAY katman, çekirdek-döngü adımı değil:**

| | nereye ait |
|---|---|
| **bildirim** | **beş-ölçüt tablosunda** yaşar: *"`K-2.2.7b` yürürlükte: zil çalıyor, kanıtı `P1`–`P4b`"* |
| **`RLS`** | **ölçüt-5'in konusu** (izolasyon) |

### `4b` · **DÖRT GİRDİ** — liste ürün sahibinden, aynen

```
1  SECTION-10'un Faz-2 İÇERİK LİSTESİ  — ADAY-YETENEK ENVANTERİ statüsüyle
     KPI motoru · planning grid · baseline · ROI-onay
     ⛔ çerçeve/takvim/gate-metrikleri DEĞİL — YALNIZ yetenek listesi
2  FAZ2_ACIK_KARARLAR DEVİR LİSTESİ
     Finance-ayrışması · T-292 · T-293 giriş-koşulu · T-304/+CM ·
     idempotency-köken-segmenti · T-321 hükmü (ne çıkarsa)
3  KOD GERÇEKLİĞİ — BRD'nin "Faz-2" dediklerinden hangileri FİİLEN İNŞA EDİLMİŞ
     plan/volume/tactic yüzeyi · MODES_PLAN_WRITE'ın 12 rotası
     📌 K7-K12 revizyonu deseni: "ERTELENDİ SANILAN, YAPILMIŞ"
4  MOD-BİRLEŞMESİ EKSENİ
     her kalem "hangi modda" DEĞİL, "TEK AKIŞIN NERESİNE" sorusuyla yerleşir
```

### ⛔ `4c` · `VARSAYIM` BORCU **KAPANDI — KAYIT VAR** `[ÖLÇÜLDÜ]`

Ürün sahibi: *"mod-birleşmesi kararının `Z`/`K` numarası repodan bulunup `JOIN`'in
başlığına yazılır — **bulunamazsa** bu denetim onu `Z`-kaydına döker."*

**Bulundu. Yeni kayıt GEREKMİYOR:**

```
04_KARAR_KAYDI.md · BÖLÜM A · A1 — "Çalışma biçimi ayrımı"
KARAR  ❌ "Mod, bir DAVRANIŞ BELİRLEYİCİ olarak ÖLDÜ."
       Kapsam politikası · öncelik eşleşmesi · karma biçim REDDEDİLDİ.
       Geriye yalnız bir GÖRÜNÜRLÜK BAYRAĞI kalır.
```

📌 Ve karar turunun **kendi bulgusunda** `A1` özel olarak anılıyor:
> *"`A1` özellikle: mod kendi kararıyla değil, **davranışları teker teker
> sahiplerine dağıtıldığı için** öldü."*

⇒ **`JOIN`'in başlığı: `A1`.** *(Arama ilk terim kümesiyle — `mod-birleşme`/`tek akış` —
**sıfır** döndü; ikinci küme `mod ayrımı` bulguyu verdi. `DISIPLIN`: *"arama terimi,
aranan yerin diliyle seçilir"* — ve karar defteri buna **`mod ayrımı`** diyor.)*

---

## 5 · ⚡ `§1` HÜKMÜ: **KOŞULSUZ KAPANIŞ** — `(C)` DEĞİL *(ürün sahibi)*

⛔ **Team Lead'in `(C)` önerisi de YANLIŞ ÇERÇEVEYDİ.**

> **Ölçüt-5 AÇIK DEĞİL** — tanımı **kayıtla daraltıldı** ve **o tanım KARŞILANDI.**

```
ÖLÇÜT-5'İN YÜRÜRLÜKTEKİ TANIMI (süzgeç kararıyla revize):
  "Çok-tenant izolasyonu: TASARIM + POLİTİKA-ŞEKLİ + KANIT-ALTYAPISI Faz-1'de;
   AKTİVASYON ikinci-müşteri/deploy SERT EŞİĞİNDE."
```

**Ve tanımın her parçası ölçülü** *(denetim bunları DOĞRULAYACAK)*:
üç açılış-kararı hükümlü (`Z45`/`Z46`/`Z50`) · politika-şekli yazılı (fail-closed
boş-küme) · sonda **üç-çıktılı + iki-kiracılı** · desen **kanonik** (`SET LOCAL` + tx,
`NFR`-ölçümlü) · `FORCE`-hükmü kayıtlı (`Z54`) · `T-307`/`T-308` **canlı kusurları
kapalı**.

> **`Faz-1`, `RLS`'i ERTELEYEREK kapanmıyor — `RLS`'in FAZ-1 PAYINI TAMAMLAYARAK
> kapanıyor.** Aktivasyon **bir sonraki fazın değil, bir EŞİĞİN** işi; ve eşik listesi
> (**ilk-deploy ön koşulları**) **kapanış beyanının EKİDİR.**

⛔ **Ve dil önemli** *(ürün sahibi)*: *"Koşullu-kapanış dili, **üç haftalık işin kendi
kaydına haksızlık** olur."*

```
BEYAN NET YAZILIR:
  "Faz-1 TAM kapandı; aktivasyon-eşiği listesi EKTEDİR,
   sahibi ve tetikleyicisi YAZILIDIR."
```

⚠️ **Denetimin işi bu tanımın BEŞ ÖLÇÜTTE DE tutup tutmadığını ÖLÇMEK** — tutmuyorsa
o gün konuşulur. *(Ön-veri tuttuğunu söylüyor.)*

---

## 6 · TURUN ÇIKTISI — altı kalem

```
1  5-HALKA MÜHÜRLÜ SAYFA        (üç sütun × beş halka)
2  BEŞ-ÖLÇÜT İŞARETLİ TABLO     (ÖLÇÜLEREK — bayat tablo okunmaz, §0)
3  FAZ-2 ÇAKIŞTIRMA JOIN'İ      (dört girdi, başlığı A1)
4  SECTION-10 KARANTİNA DAMGASI
5  KALAN-15 / KOŞUL SATIRLARI TAZELİĞİ
6  ⇒ FAZ-1 KAPANIŞ BEYANI       + aktivasyon-eşiği listesi EKİ
```

## 7 · SIRAYA ALINAN
`T-325` — e2e için **tek-çalıştıran kilidi** (`flock` sınıfı, harness'a). Aday statüsü
**doğru**; kapanışı **bloklamaz**, denetim sonrası kuyruğa.
