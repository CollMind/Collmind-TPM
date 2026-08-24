# `B3b` RATCHET TABANI — `Z35` sonrası okuma

**Ölçüm tarihi:** 2026-08-24 · **Damga:** `Z35` sonrası (`B3b-0` inmiş, `Z30`'un dokuz
hükmü verilmiş, `T-277` iki repoda kapanmış)

> ⛔ **REVİZE EDİLDİ 2026-08-24 (`EK 3`): taban `75` → `70`.** `75` `B3a`'nın
> hücre sayılarından türetilmişti ve o sayılar **bayattı** (`T-253`/`Z24` beş rota
> sildi). `70` bir **sayım**dır, bir çıkarma değil — kaynak:
> [`B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv`](B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv).
> Eski sayı aşağıda **iziyle** duruyor (`F12` deseni).
>
> ⛔ **YENİDEN REVİZE EDİLDİ 2026-08-24 (onay-akışı sınıf düzeltmesi): `70` → `72`.**
> Ürün sahibi kararı: `POST /plans/:id/review` ve `POST /plans/:id/escalate-to-finance`
> **`MODES_APPROVE`**'a gider, `MODES_WRITE`'a değil — yani **bloke** listesine.
> Sınıflandırıcının `YARGI` istisnası bir **yol deseniydi** (`approve|reject`) ve bu
> ikisini kaçırıyordu; **üye listesine** çevrildi
> (`collmind.backend/scripts/analysis/route-cell-map.py`).
>
> **Teyit ölçümü (kapı, ölçüldü 2026-08-24):** iki rotanın yazdığı **her** kolon
> onay-durumudur (`updateStatusCas` → `status`/`approved*`/`rejected*`/`escalated*`/
> `pendingFinanceReview`); **plan-içerik kolonu `0`**. POZ.KONTROL
> `plan.service.updateSkuVolume`: `baseVolume`/`plannedVolume` **yazar**, `status`'ü
> yalnız **okur** (DRAFT guard) — ayırt edici **ters yönlü**.
>
> ⚠️ **Ve `75`/`70` bir daha elle yazılmaz.** Hücre/kaynak dağılımının kanonik kaynağı
> üreticinin **MUTABAKAT çıktısıdır** (stderr); bu belge yalnız **tabanı** taşır.
>
> ⛔ **BU TABAN BAĞLI, KESİN DEĞİL.** `Z35`'in `MODES_WRITE` bölünmesi **karar olarak var,
> kod olarak yok**. `Z30`'un kaydı yürürlükte: *"gerçek taban HARİTA DÜZELTMESİ SONRASI
> ÖLÇÜLÜR."* Aşağıdaki `72`, haritanın düzeltilmesiyle **değişmeyecek** bir alt sınırdır;
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

## 2 · TABAN — `72`

**Taban bir SAYIMDIR, bir çıkarma değil** — kaynak: üreticinin `MUTABAKAT` çıktısı
(`python3 scripts/analysis/route-cell-map.py`, stderr). Bloke dört hücrenin üye
toplamı:

```
bugün          211  @Roles
B3b-1..n sonra  72  @Roles          ← mekanik turların ulaşabileceği TABAN
72'nin altı         BİR KARAR        ← mekanik tur DEĞİL
```

*(eski okuma — `F12` izi: `75`, `B3a`'nın `80` kilidinden çıkarmayla türetilmişti ve
girdisi bayattı; sonra `70`, onay-akışı sınıf düzeltmesinden önceki sayım.)*

⚠️ **Hücre kırılımı bu belgede TEKRARLANMAZ.** Elle yazılmış her üye-sayısı, bir
sonraki rota eklendiğinde yalan söyler — `MODES_WRITE` vakası bunu üç yerde birden
gösterdi (bkz. `§8 A`). Kırılım için üreticiyi koştur.

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
ÖLÇÜM         "Z35'in bölünmesi haritaya uygulandı mı" → 0     (poz.kontrol: MODES_WRITE 15 geçiş)
```

⛔ **VE `Z35`'in ENUMERASYONU HÜCRENİN TAMAMINI KAPSAMIYORDU** (ölçüldü 2026-08-24).
`Z35` `{A,F} 6 + {A,P} 12 = 18` sayıyordu; hücrede **`22`** rota vardı. Fark **dört**:

| rota | `@Roles` | sonuç |
|---|---|---|
| `POST /plans/:id/review` | `ADMIN,CATEGORY_MANAGER,FINANCE` | → **`MODES_APPROVE`** (ürün sahibi kararı; iki native kümenin ikisinde de yok) |
| `POST /plans/:id/escalate-to-finance` | `ADMIN,CATEGORY_MANAGER` | → **`MODES_APPROVE`** (aynı) |
| `POST /agreement-transactions/batch` | `ADMIN,FINANCE` | → `{A,F}` tarafı (mekanik; `T-277` pinleri üstünde) |
| `POST /agreement-transactions/validate-and-import` | `ADMIN,FINANCE` | → `{A,F}` tarafı (aynı) |

📌 **İlk ikisi neden `MODES_WRITE`'a KONULAMAZDI — fail-safe asimetri:** iki native
kümenin **ikisi de `CATEGORY_MANAGER` taşımıyor**. `MODES_WRITE`'a konsalardı `CM`,
`escalate`'in fiilî sahibi iken **sessizce düşerdi**. Bloke listesinde ise rotalar
`@Roles`'ta kalır ve `APPROVE` karar paketi çözülünce göçerler — **davranış korunur**.
Belirsizlikte davranış-koruyan taraf kazanır.

⇒ **`MODES_WRITE` bugün `20` rota**, ve bölünme `{A,F}` + `{A,P}` ile **tam örtüşür**.

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

### ⛔ `ADIM 0`'IN KABUL KRİTERİ — *"pin DOKUNULMADAN harita koda indi"*

*"`B3b-1`'in `ADIM 0`'ı"* ilan etmek **yetmez** — riskin tarifi *"mekanik tur daraltmayı
**sessizce** geri alır"*dı, ve **sessizliği** kıran şey bir ilan değil bir **pin**dir.

```
KOŞULACAK   test/agreement-transaction-role-boundary.e2e-spec.ts
BEKLENEN    PLANNER → 403   ·   FINANCE/ADMIN → 400   (dört pin çifti)
KABUL       harita bölündü  ∧  pin DOSYASINA DOKUNULMADI  ∧  YEŞİL
```

⚠️ **Pin dosyası değiştirilirse kabul DÜŞER** — bir mekanik turun daraltmayı geri
alması ile pini gevşetmesi **aynı sonucu** verir, ve ikincisi daha az görünür.

📌 Pin `T-277` turunda **mutasyonla ayırt ediciliği kanıtlanmıştı**
(`@Roles(ADMIN, PLANNER, FINANCE)` → `(a)` kırmızı, `/batch` yeşil kaldı). Yani bu kriter
**ölçülmüş bir dedektöre** dayanıyor, bir umuda değil.

---

## 4 · RATCHET'İN KÖR NOKTASI — bloke `72`'nin `47`'si KAPSAMSIZ

> ⛔ **BU TABLO DÜZELTİLMEDİ, YENİDEN TÜRETİLDİ** (2026-08-24). Eski hâli `B3a`'nın
> **bayat** hücre sayılarından (`37`/`32`/`11`) türetilmişti ve `41` o girdiden
> çıkmıştı. Aşağıdaki sayılar **bugünkü kovaların** taze birleştirmesidir —
> `75→70` dersinin aynısı: **çıkarma değil sayım**.

**Türetim:** `route-cell-map.py` çıktısı ⋈ `scope-{a1,a2,b,c}` baseline'ları, anahtar
`<dosya>|<YÖNTEM>|<yol>`. **POZ.KONTROL:** birleşen anahtar `211/211`, eşleşmeyen `0`;
kapsam anahtarı toplamı `223` = toplam rota.

| hücre | `A1` | `A2` | `B` (kapsam VAR) | `C` | TOP | **KAPSAMSIZ** |
|---|---|---|---|---|---|---|
| `MODES_READ` | **20** | 0 | 9 | 5 | 34 | **20** |
| `SHARED_READ` | **11** | 6 | 3 | 0 | 20 | **17** |
| `SUMMARY_READ` | **10** | 0 | 2 | 0 | 12 | **10** |
| `MODES_APPROVE` | 0 | 0 | **6** | 0 | 6 | **0** |
| **TOPLAM** | | | | | **72** | **47** |

`MODES_APPROVE`'un tamamı **kapsamlı** — onay yolunda kapsam katmanı çalışıyor, ve bu
**yeni iki üyeyle birlikte** hâlâ doğru (`review`/`escalate` ikisi de `B` kovasında).
Üç `READ` hücresinin **`47`'si kapsamsız**: o hücrelere `5/5` rol yazmak, `47` rotada
*"herkes her şeyi görür"* demektir. `Z19`'un *"katman KISMİ"* hükmü **ölçülü**.

⇒ **`72`'yi düşürmek bir rol atama işi değil, bir KAPSAM işi.** İki ratchet'in anahtarı
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

### A · GÖÇEBİLİR — `139`

```
211 (@Roles)  −  72 (bloke)  =  139
```

**Kümenin sınırı:** `139` bir **çıkarma**dır, bir sayım değil — ama iki ucu da **aynı
üreticiden** gelir (`route-cell-map.py`), yani `§8 A` ile `§8 B` artık **tek taban**
kullanır. *(eski okuma — `F12` izi: `136`, bayat `75` tabanından.)*

Hangi `139` rota olduğu **rota-seviyesinde bilinir**: `EK 3`'ün TSV'sinde bloke dört
hücre dışındaki her satır. Filtre:

```bash
awk -F'\t' '$5!~/^(MODES_READ|SHARED_READ|SUMMARY_READ|MODES_APPROVE)$/' \
    docs/process/B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv
```

⚠️ Ve `MODES_WRITE` üyeleri bugün göçerse **yanlış rol taşır** — `§3`.

> ⛔ **ÜYE SAYISI BURAYA YAZILMAZ.** `MODES_WRITE`'ın büyüklüğü bu oturumda **üç yerde
> üç farklı** sayıyla yazılıydı: bu belge `19` · `Z35` enumerasyonu `18` ·
> `capabilities.ts:215` yorumu `18` — ölçülen **`22`** (düzeltme sonrası `20`). Sınıf
> sayı düzeltmesiyle kapanmaz: **liste, sayı değil.** Üye listesi
> `capabilities.ts`'in harita yorumunda ve `EK 3`'ün TSV'sindedir.

### B · KARAR-BEKLER — `72`

**Bu liste hücre-seviyesinde TAM:**

| hücre | rota (ÖLÇÜLEN) | KİMİN KARARI | ne bekliyor |
|---|---|---|---|
| `MODES_APPROVE` | **6** | **ürün sahibi** | rol kümesi — `K-2.5.12` onay yetkisi |
| `MODES_READ` | **34** | **ürün sahibi** | rol kümesi |
| `SHARED_READ` | **20** | **ürün sahibi** | rol kümesi |
| `SUMMARY_READ` | **12** | **ürün sahibi** | rol kümesi (`Z31` tanımı hazır) |
| **TOPLAM** | **72** | | |
| *(çapraz)* | **47** | **KAPSAM HATTI** | kapsamsız `READ`'lerin önceliklendirmesi |

> 📌 **`MODES_APPROVE` `4` → `6`:** `POST /plans/:id/review` ve
> `POST /plans/:id/escalate-to-finance` onay-akışı sınıf düzeltmesiyle buraya taşındı
> (`§3`). İkisi de `B` kovasında — yani `47`'ye **katkı vermiyorlar**.

> ⛔ **İKİ ADRES, TEK PAKETTE KARIŞTIRILMADAN.** `72`'yi açan şey rol kümeleridir
> (**ürün sahibi**); ama `47`'yi **kapsam borcuyla** açar — o borç **kapsam hattının**,
> `B3`'ün değil. İki-sütun ilkesi gereği göçebilirler; ama `SUMMARY_READ ∧ A1` deseninin
> **genişlemiş hâli** burada: özet-şekilli **olmayan** kapsamsız `READ`'ler de artık sayılı.
>
> ⇒ Karar paketi ürün sahibine **iki ayrı adresle** gider: rol kümeleri (ona) ·
> `47`'nin kapsam önceliklendirmesi (kapsam hattına).

*(eski okuma — `F12` izi: `MODES_APPROVE 6 · MODES_READ 37 · SHARED_READ 32 · TOPLAM 75`,
`B3a`'nın bayat sayılarından türetilmişti.)*

> ⛔ **Bu `72` bir mekanik turun konusu DEĞİL.** Dört hücrenin rol kümesi **karar
> bekliyor**, ve `47` kapsamsız rota yüzünden karar *"hangi roller"*den önce *"kapsam
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

## 9 · ✅ KAPANDI (`T-283`, 2026-08-24) — tablo REPODA

> **Bu bölüm bir DEVİR ENGELİNİ anlatıyordu ve engel kalktı.** `EK 3`
> ([`B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv`](B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv), `211` satır)
> ve üreticisi (`collmind.backend/scripts/analysis/route-cell-map.py`) origin'de.
> `B3B1_DEVIR_BRIEF §2`'nin *"repodan yeniden türet"* adımı **uygulandı** ve taban
> bağımsız olarak doğrulandı (2026-08-24, yeni thread).
>
> Aşağıdaki metin `F12` deseniyle **iziyle** duruyor — silinmedi, çünkü *"bu kilit
> neden vardı"*nın cevabı kayıtta kalsın.

### *(iz — kapanmadan önceki hâli)* ⛔ DEVİR ENGELİ — `211` satırlık tablo REPODA YOK

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
