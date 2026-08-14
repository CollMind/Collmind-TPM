# 0071 — `Faz 0` durum fotoğrafı

> **Amaç:** Fable'a gidecek `Faz 1` planı brief'inin **girdisi**. Bir özet değil, bir durum
> fotoğrafı.
>
> **Mod:** SALT-OKUNUR. Bu turda yeni ölçüm yapılmadı; kayıtlardan derlendi.
> **`kayıtta yok` ile `yok` ayrı iddialardır** ve bu belgede ayrı yazılır.
>
> **Tarih:** 2026-08-15 · **Derleyen:** Team Lead

---

## 0 · Bu belgenin kendi sınırları (önce okunur)

Bir durum fotoğrafının en tehlikeli tarafı, **eksik bir kadrajın tam görünmesidir.** Üç sınır:

| sınır | ne demek |
|---|---|
| Kaynak = **kayıtlar** | `BACKLOG.md` · `tasks/*.md` · `docs/brd-v2/` · `docs/decisions/` · git log. Koda karşı **yeniden ölçüm yapılmadı.** |
| Bir kayıt **bayatlamış olabilir** | Ve bu belge onu fark edemez. Ölçüm tarihi olanlarda tarih yazıldı. |
| İstenen üç şey kayıtta **bulunamadı** | `T-227` · `❌ Ölçülmüş ihlal` işareti · `RLS 0/43`. Üçü de aşağıda **`kayıtta yok`** olarak işaretli — *"yok"* değil. |

---

## 1 · Ne indi

⚠️ **`indi` ile `kapandı` ayrıdır.** Bir task `Done` olup bulduğu kusuru başkasına
devretmişse, devir aşağıda yazılıdır. Bu ayrım olmadan liste, kapanmamış işi kapanmış
gösterir.

### 1.1 · `B` dalgası — `T-211` **`done`**

| kalem | kanıt |
|---|---|
| `S1`–`S15` · `R1`/`R2a`/`R3` · seed **4.5/5** | `BACKLOG.md` `T-211` satırı |
| Enum pini **mutasyon kanıtlı** | `roleEnumContract.test.ts` (frontend), iki yönlü assert |
| Tek `up`/`down`, çıkarmalar dahil, seed atomik | üç bağlayıcı kısıt, `EK_C`'de kayıtlı |

**Devredilenler — dalga kapandı, kusurları kapanmadı:**

```
EŞİKLİ şablonu yazılamadı        → T-214   (katalog ↔ tenant politikası aynı satırda)
rol ailesi seed'i (5/5 → 4.5/5)  → 0056-K3 kararına bağlı, açık
S11 FK geri çekildi              → EK_C'de gerekçesiyle kayıtlı
```

> 📌 **Seed ölçütü `5/5`'ten `4.5/5`'e revize edildi — gerekçesiyle.** Bu, `CLAUDE.md`'nin
> *"karşılanamayan bir ölçüt revize edilir, uydurma veriyle karşılanmaz"* kuralının vakası.

### 1.2 · `B` dalgasının **kabul listesinin** açığı — `T-219`

`f26d79c` · `8a0b9ea`. Dalga sekiz kabul kriteriyle kapandı; **hiçbiri *"uygulama hâlâ
ayağa kalkıyor mu"* diye sormadı.** Sonuç: **e2e suite'inin TAMAMI** kırıktı
(`17/17` dosya), sebep `database.module.ts`'in okuduğu entity listesinin güncellenmemesi.

> Ve eksikliği **kimse aramadı** — başka bir task'ın yan bulgusu ortaya çıkardı.
> Kural `CLAUDE.md`'ye yazıldı (`788c0f5`): *"bir kabul listesi, değişikliğin
> BOZABİLECEĞİNİ de saymalıdır."*

### 1.3 · Guard altyapısı — `T-212` **kısmen indi, task `todo`**

| indi | kanıt |
|---|---|
| `push-order.sh` + self-test **kapı olarak** çağrılıyor | `9d2e15d` · `ee41a3d` · `ed92bd4` |
| `run-all.sh`: alt-guard'ın **sıfır olmayan** RC'si artık setup hatası | `T-212 S-1` |
| `SKIPPED` bir **exit code** (2), dize değil | aynı tur |
| `docs/brd-v2/guard.sh` dördüncü kontrol: bayat `BACKLOG` linki | `LINK_MARGIN=3`, `0 FP / 127 yakalandı` |

**Kapanmadı:** ratchet **dosya sayısı** olmalı (satır değil) · `money-float` ratchet'i
kapıya bağlanmalı · `mode-split` yorumu ↔ baseline çelişkisi. Üçü de `T-212`'de.

### 1.4 · `GRİ` ailesi — `T-172` **`done`**, ve kapsam **üç kez büyüdü**

`1217658` · `d65c725`. İki yön düzeltildi (`BELOW_TARGET` çöküşü · `AMBER` çöküşü).

> ⚠️ **Kapsamın üç kez büyümesi bir sinyal olarak okundu** ve task kapatılıp yerine
> **tam enumerasyon** kondu (`T-220`). Sebep kayıtlı: kapsam **literalle** tarandı
> (`|| 'GREEN'`'in altı yazımı) ve **sınıfla** taranmadı; `GrandTotals.tsx`'in
> `null → AMBER`'ı o yüzden görünmedi.

### 1.5 · Decimal transformer'lar — `T-221` **`done`**, üç devirle

`2ee4358` (24 kolon) → `27f3fe0` (iki transformer) → `919da09` (blocker) → `d0917e8`
(kalıcı test) → `daeafb5` (kapsam) → `43d7ce6` (yorumlar).

| kanıt | değer |
|---|---|
| unit | **65/65 suite · 1117 passed / 1 skipped** |
| e2e | **17/17 suite · 270/270**, `T-047` invaryantı PASS |
| `tsc --noEmit` · `guards` · `money-float --ratchet` | üçü de **EXIT 0** |
| korunan üç baseline | `plan.service.ts` 36 · `budget-allocation` 54 · `spend-validation` 10 — **kıpırdamadı** |
| koruma matrisi | dört mutasyon şekli ölçüldü, spec'e yorum olarak yazıldı |

**Devredilenler:**

```
T-228   TÜKETİM sınıfı — `string` bir değer sayı gibi tüketiliyor
T-229   Karar 6 yuvarlaması 37 PARA kolonunu ATLAYACAK      ← düzeltmenin ÜRETTİĞİ kusur
T-230   §2.5 Alan A'da: '|| 0' 59 · '?? 0' 14
T-225   BudgetReservation — pin testi bu yüzden `it.skip`
```

> 📌 `T-229` bu turun en öğretici kaydı: **bir düzeltme, düzelttiği sınıfın yeni bir
> vakasını üretti.** Takma ad kaldırıldı → yuvarlama artık para olmayan kolonlara
> **sızmıyor**; aynı hamle onu **37 para kolonundan atlatıyor.**

### 1.6 · Entity listesi — `T-224` **`review`** (⚠️ `done` DEĞİL)

`3fc5ab3` · `70edd6e`. `entities/index.ts` kaldırıldı, `typeorm.config.ts` kanonik oldu,
pin testi yazıldı — ve **pin ilk koşumunda bir kusur buldu** (`BudgetReservation`, üç
listenin de kaçırdığı `@Entity`). Pin bugün `it.skip`'te ve `T-225`'e bağlı.

---

## 2 · Ne kaldı

⚠️ **`T-227` kayıtta YOK** — `tasks/T-227.md` yok, `BACKLOG.md`'de satırı yok.
`Alan B` tüketim işi **`T-228`** olarak açıldı (`6f9b0ac`). Aşağıda `T-228` yazılıdır.

| task | durum | **NE BLOKLAR** | **NE BLOKLAMAZ** | `Faz 1`'e dokunur mu |
|---|---|---|---|---|
| `T-224` | `review` | pin testi `skip`'te → entity listesi **bugün korumasız** | `Faz 1` şemasını bloklamaz | ⚠️ **dolaylı** — yeni tablo eklendiğinde liste yine sessizce kaçırabilir |
| `T-228` | `todo` | — | hiçbir şeyi bloklamaz, **sayım** işi | ❌ hayır |
| `T-220` | `todo` | — | sayım işi | ❌ hayır |
| `T-222` | `todo` | — | `PlanningGrid.tsx` **ölü kod** | ❌ hayır |
| `T-223` | `blocked-unreachable` | — | `export.ts` sıfır çağıran | ❌ hayır |
| `T-225` | `todo` | **`T-224`'ün pin'ini** | şema/migration bloklamıyor (tablo var, 0 satır) | ⚠️ **evet, dolaylı** — `Faz 1` politika tabloları da aynı listeden geçecek |
| `T-212` | `todo` | ratchet **kapıda değil** → `Faz 1` boyunca koruma yok | bugünkü işi bloklamıyor | ✅ **EVET** — `Faz 1` şema ağırlıklı, guard'sız girmek pahalı |
| `T-113` | `todo` **P1** | lint kapısı **her iki yönden** işlevsiz | bugünkü işi bloklamıyor | ✅ **EVET** — aynı gerekçe |

> **`Faz 1`'e dokunan ikisi `T-212` ve `T-113`** — ve ikisi de aynı sınıf: *"kapı var
> görünüyor, ayırt etmiyor."* `T-225` üçüncü, ama dolaylı.

📌 **`T-113` + `T-100` aynı kapının iki yüzü** (`§2.7 #9`): `npm run lint` kapsamı
commit sonrası **boşalıyor** (hep yeşil), `npm run lint:check` **hep kırmızı**
(108 error / 54 dosya). *Sinyal sabitse, sinyal değildir.*

⚠️ **`T-192` bu ikisiyle ilgili DEĞİL** — kayıtta *"`docs/brd/` kökünde envanterlenmemiş
altı dosya"* işidir (`P1`, `architect`). Lint'le teması yok.

---

## 3 · Açık kararlar

| # | konu | durum (kayıttan) | tipi |
|---|---|---|---|
| `T-209` | `sales_actuals.discount_amount` — ticari harcama mı, satış iskontosu mu | `todo` · `P1` · `architect` | **üretim verisi ister** |
| `T-214` | `approval_policies`: katalog seçeneği ↔ tenant politikası aynı satırda | `todo` · `P2` · `architect` | ⚠️ **`Faz 1` politika işiyle kesişir** |
| `T-225` | `BudgetReservation` ölü mü, unutulmuş bağlantı mı | `todo` · `P1` · `architect` | teknik ölçüm |
| — | **Hukuk paketi** | ⛔ **HİÇ GÖNDERİLMEDİ** | dış girdi, uzun kuyruklu |

### 3.1 · Hukuk paketi — ve kaydın **kendi içinde bir çelişkisi**

`docs/decisions/KARAR_TURU_BES_KONU.md`:

```
:80    "## KT-3 · Hukuk paketi — ÜÇ soru, ve `7 yıl` şüphesi"
:82    "Karar: üç soru tek paket olarak hukuka ŞİMDİ gider; hiçbiri işi bekletmez."
:301   "| — | Hukuk paketi, DÖRT soru | Dış |"
```

> ⚠️ **Aynı belge bir yerde `üç`, bir yerde `dört` diyor.** Bu belge yeni ölçüm yapmadığı
> için hangisinin doğru olduğunu **söyleyemez** — ama paketi göndermeden önce bu
> **çözülmelidir**, yoksa eksik bir soru sorulur ve cevabı aylar sonra aranır.
>
> 📌 Ve bu, `CLAUDE.md`'nin *"bir sayı listesiyle anılır ya da hiç anılmaz"* kuralının
> canlı bir vakası.

**Bağlı kayıtlar:** `T-170` (Vergi Usul · KVKK · e-Fatura hangi kayıtlara) ·
`v2-RAPOR-KISI` (kişi bazlı raporlama KVKK) · `K-2.9.0` **geçici askıda**
(2026-08-12 → hukuki mütalaa) · `L2_03 §665-667` (*"kaynak bir girdidir, bir hukuk
mütalaası değil"*).

> ⚠️ **`K-2.9.0`'ın askısı, `L2`'de `⛔ açık kural = 0` denilirken duruyor.** Yani
> *"dayanaksız yürürlükte madde kalmadı"* ifadesi **askıdaki maddeyi saymıyor.**

**Neden `Faz 1`'e girmeden yola çıkmalı:** karar `hiçbiri işi bekletmez` diyor — yani
paket **bloklamıyor**, ama cevabı `Faz 1` boyunca gelirse saklama/anonimleştirme
tasarımı **yeniden** yapılır. Kuyruk uzun, maliyeti geç ödenir.

---

## 4 · Askıdaki mekanizmalar

> ⚠️ **Bunların hiçbiri `Faz 1`'de koruma sağlamayacak.** Plan bunu bilerek yazılmalı —
> aksi hâlde *"guard'lar var"* varsayımıyla ilerlenir.

| mekanizma | hâli | kayıt | `Faz 1`'de ne demek |
|---|---|---|---|
| **pin testi** (entity listesi) | `it.skip` | `T-224` → `T-225` | yeni tablo listeden düşerse **sessiz**; `B` dalgasında bu tam olarak oldu (e2e 17/17 kırıldı) |
| **`money-float` ratchet** | ⛔ **kapıda değil** | `T-212`, **168 bulgu** | para kusuru **artabilir** ve kırmızıya dönmez |
| **`lint`** | ⛔ **kapıda değil** | `T-113`, **108 error** | iki yönden birden işlevsiz (`T-100` + `lint:check`) |
| **`mode-split` ratchet** | **satır sayısı** tutuyor | `T-212` | üç vakası var: iki kez **içeriği deforme etti** (gerekçe yorumu sildirdi), bir kez **meşru bir işi engelledi** (`T-218`) |

> 📌 `mode-split`'in üçüncü vakası niteliksel olarak farklı: guard **doğru işi durdurdu.**
> Kural `T-212`'de tamamlandı: *"bir guard ekibi kendi standardını ihlal etmeye itiyorsa
> yanlış şeyi ölçüyordur — YA DA DOĞRU İŞİ ENGELLİYORDUR."*

**Bugün ayakta olan kapılar** (denge için — hepsi askıda değil):
`push-order.sh` + self-test · `run-all.sh`'ın RC kontrolü · `docs/brd-v2/guard.sh` dört
kontrol · `typeorm.config.spec.ts`'in **dört pozitif kontrol** testi (asıl pin skip'te) ·
frontend `roleEnumContract.test.ts`.

---

## 5 · `Faz 1` tabanının bugünkü hâli (`L1 §1.14`)

`L1 §1.14`'ün kendi tablosu — **kaynaktan aynen**:

```
                       Kaynak Faz 1'de       Bizde
Planlama modu          ❌ sonraki faz        ✅ var
Gösterge motoru        ❌ sonraki faz        ✅ var
Veritabanı izolasyonu  ✅ Faz 1              ❌ yok
Yetenek tabanlı yetki  ✅ Faz 1              ❌ yok
Konfigürasyon tabloları✅ Faz 1              ❌ yok
Denetim olay sözlüğü   ✅ Faz 1              ❌ eksik
```

> **`L1`'in kendi cümlesi:** *"Faz 2 yetenekleri inşa edilirken Faz 1 tabanı atlanmış."*
> Ve sıralama bir tercih değil: *"Faz 2'nin eksik yarısı, Faz 1 tabanının üstünde
> duruyor."*

### Beş kalem, kayıttaki hâliyle

| kalem | kayıt | durum |
|---|---|---|
| **`K-2.6.13` DB rolleri** | `docs/brd-v2/_ISSUE_DB_ROLU.md` — issue **taslağı hazır** | ⛔ **hiç başlamadı.** Ölçülmüş durum: *"bugün tek giriş rolü var ve **ayrıcalıklı**"*. `K-2.6.13a` ve kabul testi tanımı **ürün sahibinden bekliyor** |
| **RLS** | `L2_03 K-2.6.12`: *"Bugün yalnız uygulama katmanı var. Veritabanı seviyesinde **hiçbir politika tanımlı değil**"* | ⚠️ **`0/43` rakamı KAYITTA YOK.** `0056` şunu kaydediyor: `tenant_id` **taşımayan 4 tablo** var (`tenants` · `migrations` · `typeorm_metadata` · +1), yani şart *"veri tablolarında sağlanıyor"*. Toplam tablo sayısı bu belgede doğrulanmadı |
| **rol modeli** | `L2_03 K-2.6.3`: *"Bugün kullanıcı **tek bir rol** taşıyor ve yetenekler tanımlı değil"* | `B` dalgasında şema indi (`R2a`/`R2b`), RBAC hâlâ `users.role`'dan. Rol ailesi seed'i **yazılamadı** (`0056-K3`'e bağlı) |
| **politika tabloları** | `T-214` | şema indi, **üretim yolu yok** — ve `T-214` katalog/tenant ayrımının olmadığını kaydediyor |
| **denetim olay sözlüğü** | `L1 §1.14`: **`❌ eksik`** | ⚠️ Bu **tek kayıt**. `docs/`'ta *"Denetim olay sözlüğü"* ifadesi yalnız `02_YETENEK_HARITASI.md`'de geçiyor. Ayrı bir task ya da ölçüm **kayıtta yok** |
| **zamanlayıcı** | `L1 §1.14` *"Bu sürümde olmayanlar"*: **`Otomatik zaman aşımı — ölçüm sonrası`** | ⚠️ Yani **bilinçli olarak ertelenmiş**, ve *"ölçüm sonrası"* şartı taşıyor. O ölçümün yapıldığına dair kayıt **yok** |

> **Son iki kalem için cevap: `kayıtta var, ama yalnız bir satır olarak.`** İkisinin de
> arkasında bir task, bir ölçüm ya da bir kabul kriteri **yok**. Bu, *"ölçülmedi"*
> demektir — *"yok"* değil.

### `L1`'in kendi *"Açık kalanlar"* tablosu

```
Rol kümesi                          Karar
Finans yöneticisinin onay hattı     Karar — dayanağı düştü
Saklama sürelerinin bağlayıcılığı   Hukuk
Kişi bazlı raporlama                Hukuk
Veri ayrımı modeli                  Teknik ölçüm
İadenin veri temsili                Teknik ölçüm
```

---

## 6 · Ölçüm — kaç `L2` kuralı bugün ihlal ediliyor

### ⚠️ Önce: istenen işaret **kayıtta yok**

`❌ Ölçülmüş ihlal` diye **kanonik bir işaret yok**. Ölçüm:

```
grep '❌ Ölçülmüş ihlal'  →  0 eşleşme
POZİTİF KONTROL '✅'      →  52 eşleşme      (desen çalışıyor, işaret yok)
```

`L2`'nin lejantı (`❌ uygulanmıyor · ⚠️ kısmen · ⛔ karar bekliyor`) tek bir *"ihlal"*
etiketi tanımlamıyor; `❌` düzyazıyla nitelendiriliyor. **Sayı bu yüzden istenen
işaretten değil, `❌` taşıyan satırların okunmasından çıkarıldı.**

### Liste (sayı değil — `CLAUDE.md`: *"enumerasyonu olmayan bir sayı dayanak yapılamaz"*)

`❌` taşıyan **34** satır. Beşi lejant/konvansiyon (`L2_01:28,46` · `L2_02:16` ·
`L2_03:20` · `L2_04:21`). Kalan **29** kural seviyesinde, ve **iki farklı şey** söylüyor:

**A · Açıkça `ihlal`/`sapma` etiketli — 11**

| kural | dosya:satır | ne |
|---|---|---|
| `K-2.2.6` | `L2_01:493` | özet ikisini `Rezerve` altında topluyor |
| `K-2.2.8` | `L2_01:542` | kod `%95` kullanıyor — renk sınırını **davranışa taşımış** |
| `K-2.4.2` | `L2_01:950` | planlanan brüt kâr **analitik alanda** hesaplanıp para olarak |
| `K-2.4.7` | `L2_01:977` | iki finans rotası `boş` kârlılığı `0`, `boş` rengi … |
| `K-2.4.22c` | `L2_01:1145` | **iki** ölçülmüş ihlal |
| `K-2.4.26` | `L2_01:1173` | doğrulama yazılmış, uç açılmış, **istemci sarmalayıcısı bile** var |
| `K-2.11.2` | `L2_02:292` | kayıt tablosu adıyla/alanıyla **yönetici odaklı** |
| `K-2.5.11` | `L2_03:178` | `C1`, 2026-08-12 — ön koşul `B` dalgası `S13` |
| `K-2.5.16b` | `L2_03:235` | bir yol **gönderen alanını boşaltıyor** |
| `K-2.6.6` | `L2_03:515` | tanımlanmamış uç nokta **herkese açık**, 236 … |
| `K-2.6.9` | `L2_03:577` | filtre bir ayarla **kapalı** — planlamacı tüm müşterileri görüyor |

**B · `❌ Bugün böyle bir şey yok` — 18 (eksiklik, ihlal DEĞİL)**

`K-2.1.5` · `K-2.7.2` · `K-2.8.11` · `K-2.11.5` · `K-2.11.7` · `K-2.6.3` · `K-2.6.12` ·
`K-2.9.5` · `K-2.9.7` · `K-2.13.2` (üç satır) · `K-2.13.3` · `K-2.13.6` · `K-2.13.10` ·
`K-2.13.14k` · `K-2.13.20` · `K-2.13.21`

> ⚠️ **Bu ayrım `Faz 1`'in yükünü doğrudan değiştirir.** Bir **ihlal** düzeltilir (kod var,
> yanlış); bir **eksiklik** inşa edilir (kod yok). İkisini tek sayıda toplamak, planı
> yanlış boyutlandırır.

### Kaçının adresi `Faz 1`'e gidiyor

**`A` grubundan (11 ihlal):**

```
K-2.5.11 · K-2.5.16b · K-2.6.6 · K-2.6.9      → 4   yetki/onay — FAZ 1 tabanı
K-2.2.6 · K-2.2.8 · K-2.4.2 · K-2.4.7
K-2.4.22c · K-2.4.26 · K-2.11.2               → 7   bütçe/gösterge/kayıt — Faz 1 DIŞI
```

**`B` grubundan (18 eksiklik):**

```
K-2.6.3 · K-2.6.12                            → 2   rol modeli + DB politikası — FAZ 1 ÇEKİRDEĞİ
K-2.7.2 · K-2.11.5 · K-2.11.7                 → 3   denetim/işaret — Faz 1'in "olay sözlüğü" kalemi
K-2.9.5 · K-2.9.7 · K-2.8.11                  → 3   saklama/arşiv — HUKUK paketine bağlı
K-2.13.*  (9) · K-2.1.5                       → 10  hakediş + bölge verisi — Faz 1 DIŞI
```

> ### 📌 `Faz 1`'in gerçek yükü
>
> ```
> 4  ihlal      (yetki/onay — kod var, yanlış)      → DÜZELTİLİR
> 5  eksiklik   (rol modeli · DB politikası
>                 · denetim işaretleri)             → İNŞA EDİLİR
> 3  eksiklik   (saklama/arşiv)                     → HUKUKA BAĞLI, ayrı kuyruk
> ───
> 12 kalem — ve üçü bir dış girdi bekliyor
> ```
>
> ⚠️ **Bu bir bulgu sayısı değil, bir sınıflandırma.** Sınıflandırma `❌` satırlarının
> **metninden** yapıldı; her kalemin `Faz 1` kapsamına girip girmediği **ürün sahibi
> onayı** ister. Ve `K-2.4.22c` **iki** ihlal taşıyor — yani `A` grubunun kalem sayısı
> 11'den büyük olabilir.

---

## 7 · Fable'a giden brief için — bu belgeden çıkan üç uyarı

1. **Guard'lar `Faz 1`'i korumayacak.** Dört mekanizmadan biri `skip`'te, ikisi kapıda
   değil, biri yanlış şeyi ölçüyor. `T-212` + `T-113` **`Faz 1`'den önce** ya da **ilk
   kalemi olarak** gelmeli — ikisi de plana dokunuyor.

2. **`Faz 1` tabanının beş kaleminden ikisi kayıtta yalnız bir satır.** Denetim olay
   sözlüğü ve zamanlayıcı için ne task, ne ölçüm, ne kabul kriteri var. Plan bunları
   **ölçülmedi** diye almalı, **yok** diye değil — ikisi farklı iş büyüklüğüdür.

3. **Hukuk paketi kuyruğun başında olmalı ve içeriği önce netleşmeli** — kayıt kendi
   içinde `üç soru` ↔ `dört soru` diye çelişiyor. Eksik gönderilen bir paketin bedeli
   aylar sonra ödenir.

---

## Kaynaklar

`.claude/backlog/BACKLOG.md` · `.claude/backlog/tasks/{T-113,T-205,T-209,T-211,T-212,T-214,T-220,T-222,T-223,T-224,T-225,T-228,T-229,T-230}.md` ·
`docs/brd-v2/02_YETENEK_HARITASI.md §1.14` · `docs/brd-v2/03_IS_KURALLARI/L2_0{1,2,3,4}*.md` ·
`docs/brd-v2/_ISSUE_DB_ROLU.md` · `docs/decisions/KARAR_TURU_BES_KONU.md` ·
`docs/decisions/OPEN_DECISIONS.md` · `docs/analysis/0056-rbac-ve-rls-tasarim-notu.md` ·
git log (meta `e7c4645`..`788c0f5` · backend `43d7ce6`..`1217658`)
