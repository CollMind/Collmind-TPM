# `Z109 ADIM 4` — `DISIPLIN` TARAMASI · **TASLAK v2** (revize 2026-09-08)
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

---
---

# ⭐ REVİZE — ÜRÜN SAHİBİNİN DÖRT KARARI UYGULANDI (2026-09-08)

## `R1` · KÖŞE TAŞI **KABUL** — ve etiketi ÖLÇÜLÜR: **TÜREV SAYISI**

Ürün sahibi hükmü: *"vakası yok ama sınıf tanımlıyor"* iddiasının ölçütü **türev-sayısı**:
maddeye atıf yapan başka **kural / kapı / araç / Z-kaydı ≥ 1**.
⛔ **Türevi sıfır olan bir *"köşe taşı"* iddiası → GÜNLÜĞE.**

### Ölçüt sınandı — ve **KESKİN**

```
[ÖLÇÜLDÜ: rg -c "<kavram>" docs/ scripts/ collmind.backend/scripts/]

3788 "BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR"
   "ÖLÇEMEDİM"          docs  80   ·  scripts  21
   "üç meşru çıktı"      docs   5   ·  scripts   1
   "kapının üçüncü"      docs   4   ·  scripts   0
   ⇒ TÜREV ≈ 101 — her guard'ın ve her aracın tasarım ilkesi
   ⇒ KÖŞE TAŞI, ÖLÇÜLEREK. Mekanik proxy'nin "tek vaka" dediği madde, EN ÇOK TÜREVİ OLAN.
```

### ⛔ VE ÖLÇÜT KENDİ YAZARINI DA VURDU

```
"Bir YÖNLENDİRME sessiz olamaz"      türev  0   (yalnız kendi metni)
"Bir DOSYA YOLU da bir iddiadır"     türev  0   (yalnız kendi metni)
   ⇒ İKİSİ DE BUGÜN YAZILDI (Z109 §4 KAYIT 2 ve 3), ve ölçüte göre GÜNLÜĞE GİDER.
```

> ### ⛔ **DOĞRU SONUÇ BU.** İkisi de **tek vakalık** ve **henüz türevi yok**. Yerlerini
> ### **ikinci vaka geldiğinde** hak ederler — ve kuralın kendisi bunu söylüyor:
> ### *"gözlem → İKİNCİ vakada kural → ÜÇÜNCÜde araç."*

📌 Bir tarama ölçütü, **onu yazan turun kendi kurallarını** eliyorsa **çalışıyor** demektir.
Elemiyorsa, ölçüt **kendini korumak** için yazılmıştır.

---

## `R2` · 🔎 TETİKLEYİCİ-SORU **KABUL**

Her kalan maddede **tek satır**, kuralın **başında**:
```
🔎 ne zaman: <durum>
```
⛔ **Ve bir eleme ölçütüdür:** *"tetikleyicisi yazılamayan madde **uygulanamaz** demektir"*
⇒ **günlüğe**. Bu, `R1`'in **davranış** tarafındaki kardeşi: `R1` maddenin **geçmişini**
ölçer (türev), `R2` **geleceğini** (bulunabilirlik).

---

## `R3` · AİLE LİSTESİ — ürün sahibinin beklediği **12**, taslak **doğruluyor ve İKİ EKLİYOR**

| # | aile | bugünkü karşılığı |
|---|---|---|
| 1 | **ölçüm-önce** | `AİLE — ARAMA UZAYI ve NEGATİF KANIT` (kısmen) |
| 2 | **evren** (türetilmiş > taranmış > yazılmış) | `3521` + `4726` + `4478` |
| 3 | **pin-kör-noktası** (altı tür) | `AİLE — GİZLENEN KUSUR SINIFLARI` |
| 4 | **kapı: üç-çıktı / doğum** | `3788` + `Z83` maddeleri + `AİLE — KAPI ve GUARD YAZIMI` |
| 5 | **gerekçe-yaşam-döngüsü** (`Z60`/`Z69`) | `3457` + `4396` + `5009` + **yeni** `7276` |
| 6 | **ad ≠ sınıf / kaynak** | `AİLE — SAYI · LİSTE · KANIT` (kısmen) |
| 7 | **`tanım → yazar → kısıt`** | `Z98 §3` türevleri |
| 8 | **sessiz-varsayılan** (`§2.5`) | `CLAUDE.md §2.5` türevleri + **yeni** `7224` |
| 9 | **paralel-şerit / birleşme** | `4572` + `CLAUDE.md §4` bloğu |
| 10 | **brief-etiket / hüküm-katmanı** | `Z108 §3` + `Z109 §1` + **yeni** `7255` |
| 11 | **seed ↔ fixture** | `7182` + `Z107 §3` |
| 12 | **araç-hatası** (`npx` · glob · `grep -c`) | dağınık — ⛔ **BUGÜN AİLESİ YOK** |

**⛔ TASLAĞIN EKLEDİĞİ İKİ AİLE:**
```
13  HAYATTA KALMA / TAŞIMA     "RAPOR < BELGE < KAPI < PİN" (5035) · devir-teslim (4009)
                                ⇒ bir bilginin NEREDE yaşadığı, bir SINIFTIR
14  ORTAM ve BAYATLIK          hayalet konteyner · bayat süreç · ölçüm ortamı ·
                                "bir ölçümün geçerliliği KOŞULLARINA bağlıdır"
                                ⇒ bugün "DÜZELTME · PORT · BAYATLIK" ailesinin İÇİNDE
                                  ve o aile 1.322 SATIR — en büyüğü, bölünme adayı
```

```
[ÖLÇÜLDÜ: bölüm boyları]  "AİLE — DÜZELTME · PORT · BAYATLIK" = 1.322 satır
                          (ikinci büyük ailenin 2,5 KATI) ⇒ tek aile değil, ÜÇ aile olabilir
[ÖLÇÜLMEDİ — ölçülecek: elle tur]  her maddenin TEK bir aileye düşüp düşmediği.
   ⛔ Ürün sahibi kuralı: iki aileye giren madde ya BÖLÜNÜR ya BİRLEŞTİRME ADAYIDIR.
```

---

## `R4` · `T-128` — **`DALGA-A`'DAN ÖNCE**, ve ŞERİT AÇILDI

```
[ÖLÇÜLDÜ: .claude/backlog/tasks/T-128.md]  altı vaka, ikisi 2026-09-08
brief: docs/process/T128_MUTASYON_ARACI_BRIEF.md   ⇒ şerit KOŞUYOR
şekil: satırı hedefle (satır-no, glob DEĞİL) → uygula → DEĞİŞTİRİLEN SATIRI BAS →
       sayım/tsc → ölç → shasum geri-yükle → ÜÇ DEĞERLİ sonuç
⛔ mutasyon uygulanmadı = ÖLÇEMEDİM, "yeşil" DEĞİL
```

---

## `R5` · ⛔ TAŞIYICI ÖLÇÜMÜ — hüküm 25'in dersi BU ADIMA UYGULANDI

*"Bir kural bulunamıyor"* ölçülmemişti. Gerçek taşıyıcı **iki parçalı** ve ikisi de ölçüldü.

### `(a)` YAZIM MALİYETİ — `git log`, kesin sayı

```
[ÖLÇÜLDÜ: git log --format=%ad --date=short -- docs/DISIPLIN.md + her commit'te wc -l]
  doğuş         2026-08-25   2.319 satır   (CLAUDE.md'den SALT TAŞIMA — yeni yazım DEĞİL)
  bugün         2026-09-08   7.303 satır
  ⇒ 14 günde +4.984 satır · 82 commit

  gün gün:  08-26 +1067 · 08-27 +619 · 08-28 +512 · 08-29 +236 · 08-30 +175 · 08-31 +492
            09-02  +681 · 09-03 +400 · 09-04 +107 · 09-05 +119 · 09-06 +230 · 09-07  +89
            09-08  +257
```
⛔ **VE EĞRİ YASSILIYOR — bu, taşıyıcıyı ZAYIFLATIR:**
```
ilk 7 gün    ≈ +526 satır/gün
son 7 gün    ≈ +183 satır/gün      ⇒ ÜÇTE BİRE düştü
```
> ### Yani *"belge kontrolsüz büyüyor"* iddiası **ölçümle desteklenmiyor**. Büyüme
> ### **yavaşlıyor** — sorun **hacim** değil, **erişilebilirlik** olabilir.

### `(b)` UYGULANMAMA ORANI — *"N'inci kez"* işaretleyicileri

Ürün sahibinin önerdiği anahtar-kelime proxy'si (`yazılıydı|yine ihlal|…`) **dağınık** çıktı
(farklı ifadeler, alakasız eşleşmeler). Daha sıkı bir ölçüt kullanıldı: bir kaydın
**kendi itirafı** — *"üçüncü vaka"*, *"ikinci kez"*, *"yedinci vaka"*.

```
[ÖLÇÜLDÜ: rg -o -i "(ikinci|üçüncü|…|on ikinci) (kez|vaka|vakası|üye|nesli)"
          docs/brd-v2/04_KARAR_KAYDI.md docs/DISIPLIN.md]
  04_KARAR_KAYDI.md   30 satır
  DISIPLIN.md         16 satır
  ⇒ ≈42 TEKRAR işaretleyicisi (kez/vaka) + 4 aile-büyümesi (üye/nesil)

  dağılım:  üçüncü vaka 18 · ikinci kez 7 · üçüncü kez 6 · ikinci vaka 4 ·
            dördüncü vaka 4 · dördüncü kez 1 · yedinci vaka 1 · onuncu vaka 1
  + ORAN kayıtları:  "dokuzda dokuz" 15 · "on birinci elle" 3
```

> ### ⇒ **TAŞIYICI `(b)`'DİR VE ÖLÇÜLDÜ:** kurallar **var** ve **uygulanmıyor** —
> ### belgenin kendisi bunu **42 yerde itiraf ediyor**.

⛔ **Ve `(a)` ile `(b)` ZIT YÖNE İŞARET EDİYOR:**
```
(a) büyüme YAVAŞLIYOR      ⇒ "hacim sorunu" iddiası ZAYIF
(b) tekrar 42 KEZ İTİRAF   ⇒ "bulunamıyor/uygulanmıyor" iddiası GÜÇLÜ
⇒ TARAMANIN AMACI KISALTMAK DEĞİL, BULUNABİLİR KILMAK.
   Panzehir: R2 (tetikleyici-soru) + R3 (aile) — R1 (günlük) yalnız YAN ÜRÜN.
```

📌 **Bu, hükmü değiştirir:** *"`DISIPLIN`'i yarıya indir"* bir hedef **değil**; bir **sonuç**
olabilir. Hedef **tetikleyici + aile**tir.

---

## `R6` · ⛔ NE ÖLÇEMEDİM (revize)

```
· 129 kuralın tamamı hâlâ okunmadı — R1 ölçütü ÜÇ maddede sınandı (3788 + iki yeni),
  129'a UYGULANMADI. Tam tur bir OTURUM işi.
· R3'ün 14 ailesi ADAY — her maddenin TEK aileye düştüğü ÖLÇÜLMEDİ
· (b)'nin 42 işaretleyicisi TEKİLLEŞTİRİLMEDİ — aynı vaka iki yerde anılmış olabilir
  ⛔ "bir sayı, eşleşmeleri ÖRNEKLENMEDEN raporlanamaz" — sekiz tanesi örneklendi
     (§7.1 sekizde-beş · satırı-bas üçüncü kez · üç meşru çıktı · dokuzda dokuz …),
     kalan ~34 ÖRNEKLENMEDİ
· "araç-hatası" ailesinin (12) bugün BİR AİLESİ YOK — maddeleri dağınık, sayılmadı
```

---

## `R7` · ⛔ `T-128`'İN KARDEŞİ: **DÜZENLEME** DE AYNI TUZAĞA DÜŞÜYOR (2026-09-08)

`T-128` (mutasyon aracı) `2026-08-10`'da açıldı, `2026-09-08`'de indi, ve **altı vakanın
dördünün kökü metin eşleştirmesiydi**. `scripts/mutate.sh` bunu **mutasyonlar** için
kapattı — hedefleme satır numarasına indi.

⛔ **Ama `DALGA-A` review düzeltmeleri sırasında AYNI SINIF, DÜZENLEMELERDE tekrarladı:**

```
[ÖLÇÜLDÜ: bu turun kendi düzenlemeleri, 2026-09-08]
  1  agreement.repository.ts   COALESCE bloğu    girinti 6 vs varsayılan 8   → assert düştü
  2  off-invoice .spec.ts      assertion çapası  girinti 4 vs varsayılan 6   → assert düştü
  3  on-invoice .spec.ts       test çapası       fazladan boş satır          → assert düştü
  4  on-invoice .spec.ts       provider bağlama  İKİ describe, yanlışı bağlandı → tsc kırmızı
  5  Z109 ADIM3 brief          §4 bloğu          girinti                     → assert düştü
```

⇒ **BEŞ vaka, hepsi AYNI turda, hepsi `assert` sayesinde SESSİZ KALMADI.**

> ### ⛔ Fark can alıcı: mutasyonlarda yanlış eşleşme **sahte bir ölçüm** üretiyordu;
> ### düzenlemelerde `assert` **dosyayı hiç yazmıyor** ⇒ zarar yok, ama **tur uzuyor**.

📌 Yani bu, `T-128`'in **maliyet** kardeşi: tehlike değil **sürtünme**. Ve `Z109`'un
ölçtüğü şey tam olarak **tur süresiydi**.

### ⇒ `ADIM 4` OTURUMUNA GİRDİ — *"terfi etmiş"* sınıfında, İKİNCİ ÜYE
```
kural    "mutasyonu satır numarasıyla hedefle"        → ARAÇ İNDİ (mutate.sh)
kardeşi  "DÜZENLEMEYİ de satır numarasıyla hedefle"   → ⛔ ARAÇ YOK, kural bile YOK
```
⛔ **[ÖLÇÜLMEDİ — ölçülecek: oturumda]** bu bir **araç** mı hak ediyor (bir `edit.sh`),
bir **kural** mı (*"çok satırlı bir bloğu metinle eşleştirme — satır indeksi kullan"*),
yoksa yalnızca bir **günlük kaydı** mı. ⚠️ Ölçüt `R1`'in kendisi: **türev sayısı** —
ve bugün türevi **sıfır**, çünkü kural henüz **yok**.


---

## `R7` GENİŞLEDİ — **TEK MADDE, İKİ YÜZ** (2026-09-08, `T-388` turu)

`R7` şöyle yazılmıştı: *"mutasyonda kapanan sınıf, DÜZENLEMEDE açık"* — beş vaka.
Aynı turda **ikinci yüzü** ölçüldü ve **aynı kökten**:

```
YÜZ 1 · DÜZENLEME — metin eşleştirmesi tutmuyor (assert düşer, dosya YAZILMAZ)
  girinti 6/8 · girinti 4/6 · fazladan boş satır · iki describe'dan yanlışı · brief §4
  ⇒ ZARAR YOK (assert korur) ama TUR UZAR

YÜZ 2 · ÖLÇÜM — dar desen YANLIŞ SAYI verir (ve hiçbir şey uyarmaz)
  grep -rc "…" test/*.ts            → ÖZYİNELEMESİZ  ⇒ yedinci kopya görünmedi
  rg -l "on-invoice|onInvoice"       → 16 dosya       ⇒ GÜRÜLTÜ, çapa değil
  "isoToday|isoPlusDays" beş dosya   → YORUMLA eşleşti ⇒ evren 6→3
  finance-reporting "üç yer"         → tam tarama DÖRT buldu
  ENV-2026-CAT-%                     → Σ 2.000.000/7  ⇒ HAIR_CARE'in CAT- öneki YOK
                                        desensiz: Σ 2.300.000/8 ✅
  ⇒ ZARAR VAR: yanlış sayı bir HÜKME girer (hüküm 25 tam böyle düştü)
```

> ### ⛔ Kök tek: **bir desen yazdığımda, onun EVRENİ KAPSADIĞINI ayrıca ölçmüyorum.**
> ### Ve iki yüz arasında bir **asimetri** var: düzenlemede `assert` beni korur,
> ### ölçümde **hiçbir şey korumaz** — sayı gelir, doğru görünür, ve kayda geçer.

### ⇒ `ADIM 4` OTURUMUNA: **TERFİ KESİN**, ve `R1` ölçütüyle
```
[ÖLÇÜLDÜ]  YÜZ 1: 5 vaka  ·  YÜZ 2: 5 vaka  ⇒ TOPLAM 10, hepsi TEK OTURUMDA
[ÖLÇÜLMEDİ — ölçülecek: oturumda]  türev sayısı (R1 ölçütü) — bugün SIFIR,
   çünkü kural HENÜZ YOK. On vaka bir kuralı hak eder mi, yoksa doğrudan ARAÇ mı?
```
📌 Ve *"üçüncüde araç"* kuralına göre **çoktan geçilmiş**: `YÜZ 2` için aday bir
**pratik** var ve ucuz — *"bir sayı raporlamadan önce deseni GENİŞLET ve fark var mı bak"*
(`ENV-2026-CAT-%` → `ENV-2026-%` farkı **tam olarak** bunu gösterirdi).

---
---

# ⭐ OTURUM TASLAĞI — KARAR İÇİN HAZIR (2026-09-09)

> Ürün sahibi tek oturumda karar verecek. Aşağıdaki her satır etiketli, ve
> **ölçüm** ile **öneri** ayrı yazıldı.

---

## `S1` · ⛔ ÖNCE BİR DÜZELTME: **`42` İKİ FARKLI ŞEYİ KARIŞTIRIYORDU**

```
[ÖLÇÜLDÜ]  toplam işaretleyici                                    42
[ÖLÇÜLDÜ]  bunun "üçüncüde ARAÇ" POLİTİKA beyanı olanı             2   ← ihlal DEĞİL
           ⇒ GERÇEK tekrar itirafı                                40
```

### Ve daha önemli bir ayrım — **ben de karıştırdım**
```
TÜREV   maddeye KAÇ YERDEN ATIF var        → R1 ölçütü      → madde KALIR mı?
TEKRAR  madde KAÇ KEZ İHLAL edildi          → (b) metriği    → TETİKLEYİCİ nereye?
```
⛔ İkisi **aynı komutla ölçülmez**, ve ilk taramamda ikisini **aynı sayı** sandım.
📌 Bu, `R7 YÜZ 2`'nin **canlı bir tekrarı** — taslağı yazarken bile.

---

## `S2` · `R1` — TÜREV SAYISI, **129 KURALA UYGULANDI**

```
[ÖLÇÜLDÜ: rg -c -i "<kavram>" docs/brd-v2/04_KARAR_KAYDI.md docs/DISIPLIN.md]
   §7.1 · kardeş yol sayımı              40   ⭐ KÖŞE TAŞI
   Z87  · NULL-collapse                  19   ⭐ KÖŞE TAŞI
   "liste ≠ evren"                        8   ⭐ KÖŞE TAŞI
   Z69 §4c · taşıyıcı çürümesi            6   ⭐ KÖŞE TAŞI
   "satırı BAS"                           5   ⭐ KÖŞE TAŞI
   "dokuzda dokuz"                        3      KALIR
   başlık sayıları                        2      KALIR
   case-insensitive refleksi              2      KALIR
   "bir yönlendirme sessiz olamaz"        0   ⇒ GÜNLÜĞE   (bugün yazıldı)
   "bir dosya yolu da bir iddiadır"       0   ⇒ GÜNLÜĞE   (bugün yazıldı)
```
> ### ⛔ Ölçüt **çalışıyor**: en çok türevi olan madde, mekanik proxy'nin *"tek vaka"*
> ### dediğiydi. Ve **bu turda yazdığım iki kuralı eliyor** — doğru sonuç.

⛔ **[ÖLÇÜLMEDİ — oturumda]** Kalan ~120 kural için türev sayımı **tek tek**
yapılmadı; **on kural** örneklendi. Tam tur oturumun işi.

---

## `S3` · `(b)` TEKRAR — **EN ÇOK İHLAL EDİLEN ON KURAL**

⛔ Bunlar **atıf değil, İTİRAF** — kaydın kendi *"N'inci kez"* cümlesinden okundu.

| # | kural | kaç | son vaka |
|---|---|---|---|
| 1 | **`SAYI YAZMA, LİSTE YAZ`** | **10** | `DISIPLIN:6860` — *"ve yazanlar İKİMİZDİK"* |
| 2 | **elle yazılmış üye-sayısı** (`dokuzda dokuz`) | **9** | `DISIPLIN` — oran olarak kayıtlı |
| 3 | **`§7.1` kardeş yol sayımı** | **8** | `Z107 §11` — *"sekizde BEŞİ Team Lead'in"* |
| 4 | **mutasyon hedefleme** (`satırı bas`) | **6** | `T-128` — araç indi, iki vaka daha aynı gün |
| 5 | **`liste ≠ evren`** | **5** | `T-388` — `6→3→1` · `6→7` · `3→4` · `ENV-%` |
| 6 | **case-insensitive refleksi** | **4** | `DISIPLIN:6413` |
| 7 | **`Z87` NULL-collapse** | **3** | `Z109 ADIM 3` — harness'ın bilinen-kırmızısı |
| 8 | **başlık sayıları** | **3** | `DISIPLIN:6675` — *"sistematik güvenilmez"* |
| 9 | **`Z69 §4c` taşıyıcı çürümesi** | **3** | `Z109 §2` — hüküm 25 düştü |
| 10 | **kural yazıldıktan sonra ihlal** (meta) | **3+** | `Z109 §4 KAYIT 1` — *"hüküm vereni de bağlar"* |

> ### ⛔ **`1` ve `2` aynı ailenin iki yüzü:** *"sayı yazma"* ile *"elle yazılmış üye
> ### sayısı"* — biri **anlatıda**, biri **kodda/belgede**. Toplam **19 vaka**, ve
> ### ikisi de hâlâ bir **araca** bağlanmadı.

⇒ **Tetikleyici-soru ilk buraya yazılır** (`R2`), ve `Z110`'un ölçeceği şey:
*sonraki iki haftada bu on kuralın tekrar-oranı düşüyor mu?*

---

## `S4` · `R3` — **14 AİLE**, ve büyük olanın **ÜÇE** bölünmesi

```
[ÖLÇÜLDÜ]  "AİLE — DÜZELTME · PORT · BAYATLIK" = 1.322 satır (ikinci büyüğün 2,5 KATI)
```
| # | aile | not |
|---|---|---|
| 1 | ölçüm-önce | mevcut |
| 2 | **evren** (türetilmiş > taranmış > yazılmış) | ⭐ `S3`'ün 3 ve 5'i burada |
| 3 | pin-kör-noktası (altı tür) | mevcut |
| 4 | kapı: üç-çıktı / doğum (`Z83`) | mevcut |
| 5 | gerekçe-yaşam-döngüsü (`Z60`/`Z69`) | ⭐ `S3`'ün 9'u |
| 6 | ad ≠ sınıf / kaynak | mevcut |
| 7 | `tanım → yazar → kısıt` | mevcut |
| 8 | sessiz-varsayılan (`§2.5`) | mevcut |
| 9 | paralel-şerit / birleşme | mevcut |
| 10 | brief-etiket / hüküm-katmanı | mevcut |
| 11 | seed ↔ fixture | mevcut |
| 12 | **araç-hatası** (`npx` · glob · `grep -c` · `cwd` · `rg -ril` · `SIGPIPE`) | ⛔ **BUGÜN AİLESİ YOK — KURULUR** |
| 13 | **hayatta kalma / taşıma** (`RAPOR < BELGE < KAPI < PİN`) | ⭐ taslağın eklediği |
| 14 | **ortam ve bayatlık** | ⭐ taslağın eklediği |
| **↓** | **`DÜZELTME · PORT · BAYATLIK` ÜÇE BÖLÜNÜR** | **düzeltme-disiplini** / **port-yolu** / **ortam-bayatlığı** (→ 14) |

⛔ **Her madde TEK aile.** İki aileye düşen madde **birleştirme adayıdır**.
⛔ **[ÖLÇÜLMEDİ — oturumda]** her maddenin tek aileye düştüğü.

---

## `S5` · `R2` — TETİKLEYİCİ-SORU ŞEKLİ

```
🔎 ne zaman: <durum>
```
`S3`'ün **on kuralına önce** yazılır. Örnekler (mevcut metinlerden **türetildi**):
```
🔎 "bir sayı yazacağım"                        → SAYI YAZMA, LİSTE YAZ         (10 vaka)
🔎 "bir üye sayısı yazacağım"                  → elle yazılmış üye-sayısı       (9)
🔎 "bir davranışı düzeltiyorum"                → §7.1 kardeş yol sayımı         (8)
🔎 "mutasyon uygulayacağım"                    → satırı BAS  (⇒ mutate.sh)      (6)
🔎 "bir desen yazdım, sayı aldım"              → liste ≠ evren  (⇒ scan.sh?)    (5)
🔎 "bir CHECK yazıyorum"                       → Z87 NULL-collapse              (3)
🔎 "bir hükmün gerekçesi çürüdü"               → taşıyıcı DÜŞER, daralmaz       (3)
```
⛔ **Tetikleyicisi yazılamayan madde UYGULANAMAZ demektir** ⇒ günlüğe (`R2`'nin eleme yüzü).

---

## `S6` · `R7` — **İKİ YÜZ**, ve önerilen araç

```
YÜZ 1  DÜZENLEME   metin eşleştirmesi tutmaz   5 vaka   assert korur → TUR UZAR
YÜZ 2  ÖLÇÜM       dar desen yanlış SAYI verir 5 vaka   ⛔ HİÇBİR ŞEY KORUMAZ
```
> ### ⛔ Pozitif-kontrol kuralı *"desen ÇALIŞIYOR mu"*yu ölçer.
> ### ***"Desen EVRENİ KAPSIYOR mu"*** **ayrı bir sorudur ve onun kontrolü YOK.**

`T-385`'in `6→3→1`'i · *"altı kopya"* · `test/*.ts` glob'u · *"sembol ≠ yetenek"* ·
`ENV-2026-CAT-%` — **hepsi bu ikinci sorunun boşluğu.**

### ⇒ ARAÇ ADAYI: `scripts/scan.sh` (ürün sahibi şekli)
```
GİRDİ    desen
       + EVREN (dizin listesi — TÜRETİLMİŞ, glob DEĞİL)
       + POZİTİF kontrol beklentisi (deseni YAKALAMASI gereken bir örnek)
       + NEGATİF kontrol            (deseni KAÇIRMASI gereken bir örnek)
ÇIKTI    LİSTE (sayı DEĞİL)  +  "desen ⊇ evren?" kanıtı
SONUÇ    ⇒ glob'lu-özyinelemesiz taramalar YAPISAL OLARAK İMKÂNSIZ olur
```
📌 `mutate.sh`'ın **mutasyon** için yaptığını, `scan.sh` **ölçüm** için yapar.
⛔ `Z83` bu araca da uygulanır: bilinen-yeşil **ve** bilinen-kırmızı.

---

## `S7` · ÜRÜN — iki dosya, ve **taşıma bir SİLME DEĞİLDİR**
```
docs/DISIPLIN.md               KÖŞE TAŞI + ÇOK VAKA · aileye girer · 🔎 tetikleyicili
docs/process/GOZLEM_GUNLUGU.md TEK VAKA · ⛔ F12 ile TAŞINIR, SİLİNMEZ
```
⛔ `DISIPLIN`'de **başlık + tek satırlık özet KALIR**, gövde günlüğe iner, **karşılıklı
atıf** kurulur. Ve **ikinci vakada GERİ TERFİ EDER** (`F12`).

---

## `S8` · ⛔ NE ÖLÇEMEDİM (oturuma girdi)
```
· 129 kuralın TAMAMINA türev sayımı — ON kural örneklendi
· her maddenin TEK aileye düştüğü — ölçülmedi
· S3'ün on kuralı, "N'inci kez" İTİRAFI OLANLARDAN çıkarıldı; itiraf YAZMAYAN
  bir kural daha çok ihlal edilmiş olabilir ⇒ ⛔ bu liste bir ALT SINIRDIR
· "bir kural bulunamıyor" iddiası HÂLÂ ölçülmedi — (a) yazım hızı ÜÇTE BİRE düştü,
  (b) 40 tekrar itirafı GÜÇLÜ ⇒ amaç KISALTMAK değil BULUNABİLİR KILMAK
```
