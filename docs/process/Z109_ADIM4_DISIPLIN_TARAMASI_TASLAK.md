# `Z109 ADIM 4` — `DISIPLIN` TARAMASI · **TASLAK**
### Team Lead ölçümü — ⛔ **HÜKÜM ÜRÜN SAHİBİNİN**, tek oturumda

> ## ⛔ BU BİR TASLAKTIR, BİR ÖNERİ DEĞİL
> Aşağıdaki her satır ya `[ÖLÇÜLDÜ]` ya `[ÖLÇÜLMEDİ]`. **Hiçbir madde taşınmadı,
> birleştirilmedi, silinmedi.** Bu belge yalnız **ölçümü** ve **yöntemin sınavını** taşır.

---

## 1 · BUGÜNKÜ HÂL — ölçüldü

```
[ÖLÇÜLDÜ: grep -c "^## " docs/DISIPLIN.md]     135 başlık
[ÖLÇÜLDÜ: aynı çıktıdan, "AİLE —" ile başlayanlar]   6 tanesi AİLE başlığı
                                                ⇒ 129 KURAL
[ÖLÇÜLDÜ: grep -c "^### "]                     158 alt başlık
[ÖLÇÜLDÜ: wc -l]                             7.303 satır
[ÖLÇÜLDÜ: bölüm boyları]   medyan 29 satır · en büyük 1.322 · en küçük 15
```

Altı aile bugün **1.953–3.275** aralığını kaplıyor; `3.275`'ten sonrası **ailesiz**
bir kuyruk — 123 kural, çoğu tek başına.

> ### ⛔ Sorun boyut değil: **BİR KURAL BULUNAMIYORSA YOKTUR.** 7.300 satırlık
> ### ailesiz bir kuyrukta, bir ajanın doğru maddeyi bulması **şansa** kalır.

---

## 2 · ⛔ YÖNTEM SINAVI — MEKANİK SAYIM **ÇÜRÜDÜ**

Ürün sahibinin taslak talebi: her madde için **(a) kaç vaka** — `1` = günlüğe iner,
`≥2` = kalır. Bunu mekanik ölçmeyi denedim.

**Denenen proxy:** bölüm gövdesindeki **farklı tarih** ve **farklı `T-xxx`** sayısı.
```
[ÖLÇÜLDÜ: python3 tarama, tüm 129 kural]
   ≤1 tarih VE ≤1 task içeren madde:  101 / 129
```
Yani mekanik sayım *"kuralların %78'i günlüğe insin"* diyordu.

### `2.1` · ⛔ ALTI MADDELİK ELLE ÖRNEKLEME PROXY'Yİ **ÇÜRÜTTÜ**

`[ÖLÇÜLDÜ: altı maddenin gövdesi elle okundu]` — proxy'nin *"tek vaka"* dediği altı madde:

| satır | başlık | proxy | GERÇEK |
|---|---|---|---|
| 3410 | `RATCHET`in tamamlayıcı yasası — gerileme ∧ donma | 1 vaka | *"ölçülmüş **ORAN**"* taşıyor — **çok vaka**, tarihsiz |
| 3667 | Pozitif kontrolün **dördüncü nesli** | 1 vaka | vaka işaretleyicisi **YOK** — bir **nesil** kaydı, önceki üçüne dayanıyor |
| 3760 | `KAPSAM-BEYANI ≠ KAPSAM-KANITI` | 1 vaka | işaretleyici **YOK** |
| **3788** | **BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR** | **1 vaka** | ⛔ **KÖŞE TAŞI** — *"kapı disiplininin kapanış taşı"*, `ÖLÇEMEDİM`'i doğuran madde |
| 7224 | Bir yönlendirme sessiz olamaz | 1 vaka | gerçekten **tek vaka** ✅ |
| 7276 | Taşıyıcı çürüyünce hüküm **düşer** | 1 vaka | gerçekten **tek vaka** ✅ |

> ### ⛔ ALTIDA DÖRT YANLIŞ. Ve en pahalısı `3788`: mekanik bir tur, **`ÖLÇEMEDİM`'i
> ### doğuran köşe taşını** günlüğe sürgün ederdi.

```
SEBEP   "vaka sayısı" ile "vaka İŞARETLEYİCİSİ sayısı" AYNI ŞEY DEĞİL.
        Bir kural ya vakalarını ANLATMADAN yazılmış (köşe taşları),
        ya vakaları BİR ORAN olarak taşıyor ("dokuzda dokuz"),
        ya da ÖNCEKİ KURALLARIN ÜSTÜNE kurulmuş (nesil kayıtları).
```

📌 `DISIPLIN`'in kendi maddesi bunu zaten söylüyordu:
***"bir sayı bir ENVANTERDİR, bir TEŞHİS DEĞİL"*** — ve bu tur onu **kendi üstünde**
doğruladı.

### `2.2` · ⇒ ÖNERİLEN YÖNTEM (hüküm gerektirir)

```
1  MEKANİK TUR    129 kuralı boy · tarih · task · Z-atıf ile listeler      ⇒ GİRDİ
2  ELLE TUR       her ADAY okunur — "kaç vaka" gövdeden ÇIKARILIR          ⇒ TEŞHİS
3  ⛔ ÜÇ SINIF, İKİ DEĞİL:
     KÖŞE TAŞI    vakası yok ama bir SINIFI TANIMLIYOR        → KALIR, dokunulmaz
     ÇOK VAKA     ≥2 (ya da bir ORAN)                         → KALIR, aileye girer
     TEK VAKA     1, ve bir sınıf tanımlamıyor                → GÜNLÜĞE (F12 ile)
```
⛔ **`KÖŞE TAŞI` sınıfı taslak talebinde YOKTU** — ve `3788` onsuz düşerdi.

---

## 3 · TETİKLEYİCİ-SORU SATIRI — şekil önerisi

Her kuralın başına **tek satır**: *bu kural ne zaman akla gelmeli?*

```
🔎 <soru>   →  ajan bu soruyu SORDUĞUNDA bu maddeyi bulur
```
Örnekler (mevcut kurallardan **türetildi**, uydurulmadı):
```
🔎 "bir sayı yazacağım — nereden geldi?"        → bir SAYI, eşleşmeleri örneklenmeden…
🔎 "kırmızı gördüm — kendi kodumdan mı?"        → bir ajan koşarken ağaç HAREKET HÂLİNDE
🔎 "bu testi neden yeşil sanıyorum?"            → §2.7 ailesi
🔎 "takvim ilerlerse bu test rengini değiştirir mi?"  → SEED göreli / FIXTURE sabit
🔎 "bu yönlendirme çıktıda görünüyor mu?"       → bir YÖNLENDİRME sessiz olamaz
```
⛔ **Bu, bir başlık DEĞİL bir ARAMA YÜZEYİDİR:** ajan kuralın **adını** bilmez,
**durumu** bilir.

---

## 4 · ÜRÜN — iki dosya

```
docs/DISIPLIN.md              KÖŞE TAŞI + ÇOK VAKA · aileye girer · tetikleyici-sorulu
docs/process/GOZLEM_GUNLUGU.md  TEK VAKA · ⛔ F12 ile TAŞINIR, SİLİNMEZ
```
⛔ **Taşıma bir SİLME DEĞİLDİR:** `DISIPLIN`'de başlık ve tek satırlık özet **kalır**,
gövde günlüğe iner ve **karşılıklı atıf** kurulur. Bir sonraki el *"bu kural kalktı mı"*
diye sormaz — **nereye gittiğini görür**.

---

## 5 · BUNDAN SONRAKİ KURAL (ürün sahibi, `Z109`)

```
gözlem  →  İKİNCİ vakada KURAL  →  ÜÇÜNCÜde ARAÇ
```

⛔ **Ve bu turda "terfi etmiş" bir madde ölçüldü:**
```
"mutasyonu uygula → DEĞİŞTİRİLEN SATIRI BAS → sonra ölç"
  vaka 1  replace(…,1) ilk eşleşme bir YORUMDAYDI
  vaka 2  hedef metin dosyada İKİ KEZ geçiyordu
  vaka 3  perl \Q..\E metakarakter kaçırdı ama $2'yi interpolate etti
  vaka 4  (BU TUR) girinti 6/8 uyuşmazlığı — assert düştü, dosya HİÇ yazılmadı
  vaka 5  (BU TUR, ŞERİT) TS2345 — derlenmeyen mutasyon
⇒ BEŞ vaka. Kural var, ARAÇ YOK. [[T-128]] bunu bir script'e indirmeyi öneriyordu.
```
> ### ⇒ **Üçüncü vakada araç gelmeliydi; beşinci vakadayız.**

---

## 6 · ⛔ ÜRÜN SAHİBİNE — KARAR BEKLEYEN DÖRT NOKTA

```
1  ÜÇÜNCÜ SINIF (KÖŞE TAŞI) kabul mü?   ⛔ yoksa 3788 gibi maddeler düşer
2  TETİKLEYİCİ-SORU şekli onaylanır mı?  (🔎 tek satır, kuralın BAŞINDA)
3  AİLE SAYISI: bugün 6 aile + 123 ailesiz kuyruk. Kuyruk kaç aileye bölünsün —
   yoksa "aile" kavramı YENİ AİLELER doğurup aynı bulunamama sorununu üretir mi?
   [ÖLÇÜLMEDİ — ölçülecek: mevcut 6 ailenin kaç maddeyi GERÇEKTEN kapsadığı]
4  T-128 (mutasyon aracı) beşinci vakada — AÇILSIN MI, ve DALGA-A'dan önce mi sonra mı?
```

## 7 · ⛔ NE ÖLÇEMEDİM

```
· 129 kuralın TAMAMI okunmadı — ALTI madde örneklendi (proxy'yi çürütmeye YETTİ,
  sınıflandırmaya YETMEZ). Tam elle tur bir OTURUM işidir.
· Ailelerin gerçek kapsaması ölçülmedi (madde 6.3)
· "Bir kural bulunamıyor" iddiası ÖLÇÜLMEDİ — bugüne kadar kaç kez bir ajanın
  bir kuralı KAÇIRDIĞI sayılmadı. ⛔ Bu, taramanın TAŞIYICI GEREKÇESİDİR ve
  ölçülmemiştir. [ÖLÇÜLMEDİ — ölçülecek: NASIL?]
  ⇒ hüküm 25 tam da bu sebeple düştü; aynı hatayı bu adımda YAPMAYALIM.
```
