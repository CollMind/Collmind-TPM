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

## 4 · ⛔ İKİ TERİM KULLANILIYOR, İKİSİ DE TANIMSIZ — `§2.4` `DUR`

### `4a` · **`5-halka zincir envanteri`**

Karar defterinde **dört kez** anılıyor (`Z57 §4`, `Z59 §3a`, `Z61 §8`, `T-319`), ve
**hiçbir yerde tanımlı değil.** En yakın kullanım `ADIM3_KAPANIS_RAPORU §3.4`:

```
"zincir" = TEK bir `it` içinde, MOCK'SUZ, canlı HTTP:
  admin POST /users (rol+kapsam) → login → kapsam içi 201 → kapsam DIŞI 403
⛔ ÜÇÜ DE AYRI `it` + nonexistent UUID ⇒ GUARD'ı kanıtlar, ZİNCİRİ kanıtlamaz (§2.7 #6)
```

**Team Lead okuması `[VARSAYIM]`:** *"5 halka" = **beş çıkış ölçütünün her biri için
bir canlı zincir**;* bildirim halkası bunlardan **biri** (ürün sahibi *"bildirim
halkası dahil"* dedi).

⚠️ **Ama bu bir varsayım ve `§2.4` varsaymayı yasaklıyor.** İki okuma **materyal
olarak farklı iş** üretir:
- **beş ölçüt × zincir** ⇒ `RLS` halkası **bugün yazılamaz** (`RLS` yok)
- **beş ayrı yetenek zinciri** ⇒ liste **senin belirleyeceğin** bir küme

### `4b` · **`dört-girdili Faz-2 çakıştırması`**

*"Dört girdi"* deniyor ama **dördünün adı hiçbir yerde yazılı değil.**
📌 Ve bu, `DISIPLIN`'in *"bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz"* kuralının
**tam vakası** — sayı üç kez tekrarlandı, liste **bir kez bile** yazılmadı.

---

## 5 · SENDEN BEKLENEN — üç kalem

```
1  §1 HÜKMÜ    Faz-1, ölçüt-5 açıkken kapanır mı?   TL görüşü: (C) koşullu kapanış
2  §4a         "5-halka" NEYİN beş halkası?         TL okuması: beş ölçüt × canlı zincir
3  §4b         dört girdi HANGİLERİ?                 TL'de okuma YOK — liste senden
```

⛔ **`2` ve `3` olmadan denetim başlayamaz** — yanlış okuma, **yanlış envanter**
üretir ve envanter **mühürlenecek** bir belgedir.

⚠️ `1` ise denetimin **sonunda** gerekir: ölçümler onsuz yapılabilir, **beyan
yapılamaz.**
