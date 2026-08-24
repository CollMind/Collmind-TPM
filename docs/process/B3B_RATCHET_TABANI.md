# `B3b` RATCHET TABANI — `Z35` sonrası okuma

**Ölçüm tarihi:** 2026-08-24 · **Damga:** `Z35` sonrası (`B3b-0` inmiş, `Z30`'un dokuz
hükmü verilmiş, `T-277` iki repoda kapanmış)

> ⛔ **BU TABAN BAĞLI, KESİN DEĞİL.** `Z35`'in `MODES_WRITE` bölünmesi **karar olarak var,
> kod olarak yok**. `Z30`'un kaydı yürürlükte: *"gerçek taban HARİTA DÜZELTMESİ SONRASI
> ÖLÇÜLÜR."* Aşağıdaki `75`, haritanın düzeltilmesiyle **değişmeyecek** bir alt sınırdır;
> ama `B3b-1`'in **hangi rotayı hangi rolle** göçüreceği düzeltmeden **önce** bilinemez.

---

## 1 · ÖLÇÜLENLER

### `@Roles` taşıyan rota — `211`

**İki bağımsız ölçüm, pozitif kontrollü:**

| yol | sonuç |
|---|---|
| `route-scope.sh --list` (kanonik ayrıştırıcı, 5. sütun) | **211** · toplam rota `223` |
| `grep '@Roles(' --include='*.controller.ts'` + yorum ayıklama | **211** |
| **POZ.KONTROL** — ayıklanan yorum satırı | **4** (filtre iş yapıyor) |

⚠️ Pozitif kontrol burada zorunluydu: bu oturumda **dört kez** bir tarama yorum satırına
düştü. Ayıklama olmadan sayı `215` çıkardı.

### Dört kova — `route-scope.sh`

```
FILTRESIZ (ratchet'in konusu)                    0     ← SIFIRDA, Z29 sonrası sağlıklı
PUBLIC (bilinçli açık)                           3
SELF (kimlik-yüklemli, filtresiz DEĞİL)          7     ← Z26/Z28
ALAN_GUARD (guard içinde rol zorluyor)           2
ROLES                                          211
                                          ─────────
TOPLAM                                         223
```

### Hücre durumu — `capabilities.ts`

```
hücre 21 · atanmış 17 · BLOKE 4
   ⛔ MODES_APPROVE      ⛔ MODES_READ
   ⛔ SHARED_READ        ⛔ SUMMARY_READ
```

---

## 2 · TABAN — `75`

**İki türetim, bağımsız yollardan, aynı sayı:**

| türetim | hesap |
|---|---|
| `B3a`'nın `80` kilidinden | `MODES_READ 37 + SHARED_READ 32 + MODES_APPROVE 11 = 80` · `Z35` beşini `MODES_SUBMIT`'e taşıdı → **`80 − 5 = 75`** |
| bugünkü hücre ölçümünden | `MODES_APPROVE 6 + (MODES_READ ∪ SHARED_READ ∪ SUMMARY_READ) 69` = **`75`** |

```
bugün          211  @Roles
B3b-1..n sonra  75  @Roles          ← mekanik turların ulaşabileceği TABAN
75'in altı          BİR KARAR        ← mekanik tur DEĞİL
```

📌 **`B3a`'nın `107`'si artık geçerli değil.** `107 = 80 kilit + 26 karar + 1 Z20`;
`Z30`'un dokuz hükmü `26`'yı, `Z20` `1`'i, `Z35` kilidin `5`'ini çözdü. Kalan **yalnız
kilit**.

### `SUMMARY_READ` tabanı DÜŞÜRMEDİ — ve bu doğru

> **`SUMMARY_READ`'i yaratmak `13` rotayı DOĞRU SINIFLADI, AÇMADI.**

Bloke rota sayısı değişmedi; **hangi hücrede** bloke oldukları değişti. `READ` üçlemesinin
rol kümeleri hâlâ `DUR`'da, ve yeni bir `READ`-ailesi hücresi onlardan **önce** çözülemez.

---

## 3 · ⛔ ÖN KOŞUL — `Z35`'in bölünmesi KODA İNMEDİ

```
KARAR (Z35)   MODES_WRITE bölünür:  {A,F} gerçekleşme-yazımı  ·  {A,P} plan/anlaşma-yazımı
KOD           MODES_WRITE = {ADMIN, PLANNER, FINANCE}          ← BÖLÜNMEMİŞ
ÖLÇÜM         "Z35'in bölünmesi haritaya uygulandı mı" → 0
```

**Neden böyle:** `B3b-0` **saf düzeltme turuydu** ve `MODES_WRITE`'a bilerek dokunmadı
(`H1` `DUR`'u); `Z35` o `DUR`'u **sonradan** çözdü. Yani bu bir kusur değil, **sıranın
doğal sonucu** — ama `B3b-1` başlamadan **kapanmalı**.

⚠️ **Kapanmazsa ne olur:** `MODES_WRITE`'a düşen rotalar göçer ve **`AFP` taşır** — yani
`Z35`'in *"`PLANNER` bu uçtan düşüyor"* hükmü göçün içinde **sessizce geri alınır**.
`T-277` ile inen daraltma, bir mekanik tur tarafından **ezilir**.

> 📌 `§ BİR DÜZELTME, DÜZELTTİĞİ SINIFIN YENİ BİR VAKASINI ÜRETEBİLİR` — burada üreten
> şey düzeltme değil, **düzeltmeden sonraki mekanik tur**.

**`B3b-1`'in ilk adımı:** haritayı `Z35`'e göre böl, sonra taban **yeniden okunmadan** göç
başlamaz.

---

## 4 · RATCHET'İN KÖR NOKTASI — bloke `75`'in `41`'i KAPSAMSIZ

| hücre | `A1` | `A2` | `B` (kapsam VAR) | `C` |
|---|---|---|---|---|
| `MODES_READ` (37) | **22** | 0 | 10 | 5 |
| `SHARED_READ` (32) | **19** | 9 | 4 | 0 |
| `MODES_APPROVE` (11→6) | 0 | 0 | **11** | 0 |

`MODES_APPROVE`'un tamamı **kapsamlı** — onay yolunda kapsam katmanı çalışıyor. İki `READ`
hücresinin **`41`'i kapsamsız**: o hücrelere `5/5` rol yazmak, `41` rotada *"herkes her
şeyi görür"* demektir. `Z19`'un *"katman KISMİ"* hükmü **ölçülü**.

⇒ **`75`'i düşürmek bir rol atama işi değil, bir KAPSAM işi.** İki ratchet'in anahtarı
aynı (`<dosya>|<YÖNTEM>|<yol>`, `223/223` eşleşti) — yani iki liste **birbirine
bağlanabilir**, ve bağlanmalı.

---

## 5 · `Z32` — ÇIKIŞ ÖLÇÜTÜ, İLK KAYIT AYAKTA

```
SUMMARY_READ ∧ A1 = 0            bugün 10       (ölçüldü 2026-08-24, B3b-0 sonrası)
```

Sıfırlandığı gün kural **kapıya terfi eder**: *"yeni bir `SUMMARY_READ` rotası kapsamsız
DOĞAMAZ"* — doğum kontrolü. Bu ölçüt **kapsam hattının**, `B3`'ün değil.

---

## 6 · ⛔ RATCHET'İN KENDİSİ HAKKINDA — `Z29`'un dersi geçerli

`FILTRESIZ` bugün **`0`**, ve bu bir **başarıdır**, bir setup hatası değil. `Z29` iki
guard'da tam bu tuzağı boşalttı (*"bir kapı, ölçümün BAŞARISINI hata sayamaz"*).

**`B3b` ratchet'i doğarken aynı soru sorulur:**

```
1  Bu kontrolün reddettiği durum, projenin HEDEFİ olabilir mi?   → 75, sonra 0
2  Sağlık kanıtı BİÇİMDEN mi geliyor, SAYIDAN mı?                → BİÇİM
3  Sıfır bir BAŞARI OLAYI mı?                                    → EVET, görünür olmalı
```

⚠️ Ve `§ BİR RATCHET, TAŞIDIĞINI ANLAMAZ`: taban bir **liste**dir, bir sayı değil.
`211 → 75` yolunda *"biri düştü, biri girdi"* gerilemesini yalnız liste görür.

---

## 7 · SONRAKİ TURUN GİRDİSİ

```
ÖNCE      Z35'in MODES_WRITE bölünmesini haritaya uygula        ← B3b-1 adım 0
SONRA     tabanı YENİDEN OKU (bu belge güncellenir)
ANCAK     ondan sonra rota göçü
AYRI HAT  SUMMARY_READ ∧ A1 = 10 → 0   (kapsam hattı, B3'ün DEĞİL)
KARAR     dört bloke hücrenin rol kümeleri — mekanik tur DEĞİL
```

---

## 8 · ÜÇ LİSTE — ve ⛔ GRANÜLERLİK SINIRI

`B3B1_DEVIR_BRIEF.md §1` bu belgeden **üç liste + modül dağılımı** istiyor. Aşağıdakiler
**hücre seviyesinde** ölçüldü; **rota seviyesinde ölçülmedi** ve bugün ölçülemez — sebebi
`§9`.

### A · GÖÇEBİLİR — `136`

```
211 (@Roles)  −  75 (bloke)  =  136
```

**Kümenin sınırı:** `136` bir **çıkarma**dır, bir sayım değil. Hangi `136` rota olduğu
hücre-seviyesinde bilinir (atanmış `17` hücrenin rotaları), **rota-seviyesinde
listelenmemiştir**.

⚠️ Ve `19`'u (`MODES_WRITE`) bugün göçerse **yanlış rol taşır** — `§3`.

### B · KARAR-BEKLER — `75`

**Bu liste hücre-seviyesinde TAM:**

| hücre | rota | kapsam durumu |
|---|---|---|
| `MODES_APPROVE` | **6** | `6/6` kapsamlı (`B`) — onay yolunda katman çalışıyor |
| `MODES_READ` | 37 → | `22` kapsamsız (`A1`) · `10` `B` · `5` `C` |
| `SHARED_READ` | 32 → | `19` `A1` · `9` `A2` · `4` `B` |
| `SUMMARY_READ` | *(13'ü iki `READ` hücresinden geldi)* | `10`'u `A1` — `Z32`'nin izlediği |
| **TOPLAM** | **75** | **`41`'i kapsamsız** |

> ⛔ **Bu `75` bir mekanik turun konusu DEĞİL.** Dört hücrenin rol kümesi **karar
> bekliyor**, ve `41` kapsamsız rota yüzünden karar *"hangi roller"*den önce *"kapsam
> nerede"* sorusuna bağlı.

### C · İSTİSNA-KAYITLI — `2`

*"Göç davranış değiştirmez"* kuralının **kayıtlı** istisnaları:

| # | kayıt | ne değişti | gerekçe |
|---|---|---|---|
| 1 | `Z20` | `USER_READ` ikiye ayrıldı (`USER_MANAGE` + `SELF`) | `K-2.6.4` |
| 2 | `Z35` | `POST /agreement-transactions`'tan **`PLANNER` düştü** | üç bağımsız ölçüm · `K-2.6.14` |

📌 İkisi de **`DUR`-kaynaklı** ve gerekçesi yazılı. Üçüncü bir istisna, aynı yükü taşımadan
eklenemez.

### Modül dağılımı — `@Roles` rota, DİZİN bazlı

```
modes 68 · master-data 64 · shared 42 · customer 17
user 9 · tenant 8 · admin 2 · notification 1              = 211 ✓
```

⚠️ **Bu dağılım hücre dağılımı DEĞİL.** Pozitif kontrol tam burada düştü:
`SHARED_READ 32 + SHARED_WRITE 7 = 39` ↔ `shared` dizini **`42`**. Aile, dizinden
**türetilemiyor**.

---

## 9 · ⛔ DEVİR ENGELİ — `211` satırlık tablo REPODA YOK (`T-283`)

`B3B1_DEVIR_BRIEF.md §2` sonraki thread'e *"üç listeyi repo'dan yeniden türet, dosyayla
karşılaştır"* diyor ve *"bu adım atlanamaz"* ekliyor.

**Ölçüldü (2026-08-24) — adım bugün UYGULANAMAZ:**

| girdi | mekanik mi |
|---|---|
| rota → `@Roles` | ✅ `route-scope.awk` |
| hücre → rol | ✅ `capabilities.ts` |
| **rota → HÜCRE** | ⛔ **YOK** — `B3A_ESLEME_TABLOSU.md:307`: *"ajanın raporundadır"* |

⇒ `T-283` açıldı. **`B3b-1` başlamadan önce kapanır** — yoksa devrin ilk adımı bir
**kilit**tir, ve brief'in kendi uyardığı *"devir bayatlığı"*nın **üçüncü** vakası olur.

📌 `§ BİR ŞARTIN SAĞLAYICISI YOKSA, ŞART BİR ERTELEME DEĞİL BİR KİLİTTİR` — farkı: bu
sağlayıcı **üretilebilir**, yalnız üretilmemiş. Kilit **bugün açılabilir**.
