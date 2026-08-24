# `Faz 2` — AÇIK KARARLAR listesi

> ⛔ **BU BİR ÇIKIŞ ÖLÇÜTÜ DEĞİLDİR.**
> **Ürün sahibi kararı (2026-08-21):** *"`Faz 2` çıkış ölçütü henüz yazılmasın —
> `Faz 1` bitmeden erken, ve bu `9` boşluk onun **girdisi**."*

Bu belge yalnız **girdiyi** tutar. Çıkış ölçütü `Faz 1` kapandıktan sonra, bu liste
karara bağlandıktan sonra yazılır.

---

## ⛔ KAPANIŞ-KOŞULLU KARARLAR — mekanik izleme (`Z25`, 2026-08-23)

> **Kapanış-koşullu her karar, koşulu TETİKLEYEN task'ın *"kapattıkları"* listesine
> girer.** Yoksa koşul karşılanır ve **kimse fark etmez**.

**Vaka:** `Z21` şart `3` — *"`POST /budget-allocations` … e2e akışları zarf yoluna
göçtüğünde kaldırılır."* Göç `T-270`'te oldu, karar **üç tur boyunca** *"bekliyor"*
göründü. Bulan şey bir mekanizma değil, bir ajanın **brief taramasıydı**.

| karar | KOŞUL | TETİKLEYEN | DURUM |
|---|---|---|---|
| `Z21` şart 3 (`POST` musluğu) | e2e zarf yoluna göçtüğünde | `T-270` | ✅ **koşul karşılandı** → `Z24` ile kapandı |
| `Z21` seçenek 2 (`cpl_id` zarfa) | CPL-bazlı bütçe **gerçek müşteri ihtiyacı** olarak kanıtlanırsa | danışman turu / ilk müşteri | ⏳ bekliyor |
| `Z22` paylaşılan-eksen filtresi | kanal/kategori bazlı zarf **talebi** doğarsa | — | ⏳ bekliyor · ⚠️ maliyet **revize**: tüketici tarafı zaten kurulu (`T-272`) |
| **`Z32` `SUMMARY_READ ∧ A1 = 0`** | özet-şekilli kapsamsız `10` rota **kapsam alınca** | **kapsam-kalanları hattı** (`B3`'ün DEĞİL) | ⏳ **KOŞUL** — ✅ **ilk kayıt 2026-08-24: `10`** (ölçüldü, `B3b-0` sonrası). Sıfırlandığı gün kural **KAPIYA TERFİ EDER**: *"yeni bir `SUMMARY_READ` rotası kapsamsız DOĞAMAZ"* |
| **`FINANCE` kapsam ayrışması** (aday karar) | `H8` terfisi (`UNRESTRICTED` → joker-satır modeli) **origin'e indiğinde** | `H8` | ⏳ **KOŞUL** — `H8`'den ÖNCE **temsil edilemez**. Ayrıntı: [§ FINANCE kapsam ayrışması](#-aday-karar--finance-kapsam-ayrışması-2026-08-24) |
| `Z27` `/approvals/pending` yüklemi | `approval_levels` **dolduğunda** → yüklem şablon-çözümlemeli hâline göç eder | şablon motoru (`Faz 2`) | ⏳ **KOŞUL** — aktif izlenir |
| `T-235` `T-028c` bayrağı | prod/UAT'de backfill doğrulanana kadar | prod/UAT ortamı | ⛔ **KİLİT** — sağlayıcı bugün YOK |
| `0073` `report-only` envanteri | fiili trafikte doğrulanır | deploy edilmiş ortam | ⛔ **KİLİT** — sağlayıcı bugün YOK |
| **`SYSTEM_INVARIANTS` uzlaşı turu** | tüm `Status:` satırlarının bugünkü gerçekle çakıştırılması · yetki/kapsam invariant ailesinin eklenmesi (boş kapsam=erişim yok · `SUMMARY_READ` kapsamsız doğamaz · negatif-kullanılabilirlik) · `INV-C` ↔ ilk-deploy ön koşulları çapraz referansı · `§12` Adoption koşullarının yeniden değerlendirilmesi | **`ADIM 5` (RLS) planlamasının açılışı** | ⏳ **KOŞUL** — ✅ karantina damgası indi (2026-08-24, `F12`: içerik değişmedi). Belge uzlaşı turu kapanana kadar **yalnız envanter değeri** taşır; **statü okuması için kullanılmaz** |

⚠️ **İki satır `⛔ KİLİT`** — sağlayıcısı **var olmayan** bir ortama adresli. `§`'nin
kuralı: *"sağlayıcısı olmayan şart bir erteleme değil bir kilittir."*

📌 Ve `Z25`'in ayrımı: **kilit** = sağlayıcı yok · **kaçırılan koşul** = sağlayıcı
**vardı, geldi, ve kimse fark etmedi.** İkincisi daha sinsi, çünkü liste *"bekliyor"*
derken doğru görünür.

### ⛔ VE AYRIM İKİ FARKLI BAKIM REJİMİ DEMEK (ürün sahibi, 2026-08-23)

Bu tablonun `DURUM` kolonu bir etiket değil, bir **bakım talimatıdır**:

| rejim | ne zaman | nasıl bakılır |
|---|---|---|
| **⛔ KİLİT** — *pasif bekler* | sağlayıcı **yok** | sağlayıcı **doğduğu gün** liste bir kerede taranır. Arada bakım **gerekmez** |
| **⏳ KOŞUL** — *aktif izlenir* | sağlayıcı **var, tetiklenmeyi bekliyor** | tetikleyen task **kapanışta bu listeyi günceller** (`Z25`) |

> **Beş satır kendi bakım talimatını taşıyor** — `F8`'in *"bayat durum"* sınıfına karşı
> **yapısal bağışıklık**.

📌 Fark neden önemli: bir **kilit**, sağlayıcısı olmadığı için *"bekliyor"* demek
**doğrudur**. Bir **koşul** için aynı cümle, tetikleyici geldiyse **yalandır** — ve
ikisi tabloda aynı görünür. Rejim yazılmadan, `Z25`'in vakası (`Z21` şart 3, üç tur
sessiz bekledi) **tekrarlanabilir**.

---

## ⏳ ADAY KARAR — `FINANCE` kapsam ayrışması (2026-08-24)

**Kaynak:** ürün sahibi saha senaryosu — *"X,Y kategorilerinden bir `FINANCE` sorumluyken
`Z`'den başkası sorumlu olabilir."*
**Statü:** **aday karar**, verilmiş karar DEĞİL — `04_KARAR_KAYDI`'na girmez.
**Tetik:** `H8` terfisi origin'e indiğinde **görüşülebilir** olur; öncesinde temsil edilemez.

### Bugünkü durum — ÖLÇÜLDÜ 2026-08-24

```
user-scope.entity.ts:26   WILDCARD_SCOPE_ROLES = { ADMIN, FINANCE, READONLY }
user.service.ts:240       if (WILDCARD_SCOPE_ROLES.has(dto.role)) → gönderilen kapsam YOK SAYILIR
create-user.dto.ts:116    "ADMIN/FINANCE/READONLY için yok sayılır — otomatik joker"
```

⇒ **`FINANCE` için temsil yolu YOK.** Kapsam gönderilse bile sessizce düşer — bu bir
eksiklik değil, `T-241`'in **bilinçli** tasarımı. Planner/CM için çift-tabanlı kapsam
(`cplId`, `categoryId`) tam destekli.

### Karar açılırsa — ÜÇ ZİNCİRLEME KALEM (kapsam budur; daha azı YARIMDIR)

| # | kalem | dokunduğu |
|---|---|---|
| **1** | `K-2.6.4` revizyonu — *"Finans tenant-geneli"* cümlesi **kategori-bölünebilir** hâle gelir | `L2` değişikliği, **kayıtla** (`Z1` donma rejimi) |
| **2** | **Onay + bildirim yüklemi** — eşik-üstü `FINANCE` kademesi ve `%90` bildirimi *"kapsamı KESİŞEN `FINANCE` kullanıcıları"*na iner | `T-276` (a)-yüklemi altyapıyı kuruyor · `K-2.5.12` şablon modeli · `PLAN_BUTCE_NETLESTIRME` bildirim pini — **aynı yüklemi alır** |
| **3** | **Import/mutabakat ayrımı** — `{A,F}` **tür-düzeyi** yetki BÖLÜNMEZ; **satır-düzeyi** görünürlük kapsama iner | `Z35`/`K-2.6.14` — açıkça yazılır |

⚠️ **Üçüncüsü `Z35`'i korur:** `K-2.6.14`'ün ayırt edicisi *"defter etkisi"*dir, kapsam
değil. Kapsam **kimin göreceğini** daraltır, **kimin yazabileceğini** değil — ikisi
karıştırılırsa `Z35`'in daraltması kapsam katmanına devredilmiş olur ve **tür-düzeyi
kapı gevşer**.

### Uygulama maliyeti (karar SONRASI) — düşük

```
WILDCARD_SCOPE_ROLES'tan FINANCE çıkar  +  yaratma akışına çift kabulü
model tabanı HAZIR (cplId/categoryId satır modeli zaten çalışıyor)
```

### ⇒ İLİŞTİRİLEN ÖLÇÜM — `CM` normalizasyonu (istendi, YAPILDI 2026-08-24)

> *"`CM` normalizasyonunun (`buildScope`) içeriği, CM-ayrışması fiilen kullanılmadan önce
> ölçülür — tek bakışlık iş."*

**`access-scope.service.ts:212-220` — çalışan kod (yorum değil):**

```ts
const pairs = rows.map((r) => {
  if (role === UserRole.CATEGORY_MANAGER) {
    return { cplId: null, categoryId: r.categoryId ?? null };   // ← cplId DÜŞÜRÜLÜYOR
  }
  return { cplId: r.cplId ?? null, categoryId: r.categoryId ?? null };  // PLANNER: R-1, düzleştirme YOK
});
```

**İki şekil var, ve `FINANCE` hangisini alacağı BİR KARARDIR:**

| şekil | davranış | senaryoya uygunluk |
|---|---|---|
| **`CM` şekli** | yalnız `categoryId`; `cplId` **satırda dolu olsa bile null'lanır** | ✅ *"X,Y kategorilerinden sorumlu"* — kanal-bağımsız |
| **`PLANNER` şekli** | satır-bazlı `(cpl, category)` çifti, düzleştirme yok (`R-1`) | kanal × kategori gerekiyorsa |

⛔ **Ve `CM` şeklinin sessiz bir yan etkisi var:** `cplId` **bilgi kaybıyla** düşürülüyor.
Bir `FINANCE` kullanıcısına `(cpl, category)` satırı verilirse `CM` dalı `cpl`'i **sessizce
atar**. Bu davranış `FINANCE`'a **miras alınmamalı**, *seçilmeli* — ve seçim yazılmalı.

📌 Ayrıca `hasUnrestrictedRow` dalı (`:205`) **`H8`'in joker-satır modelidir** — yani tetik
ile mekanizma **aynı fonksiyonda**. `H8` indiğinde bu kalemin temsil yolu kendiliğinden
açılır.

---

## Nereden geldi

`0075` (hakediş senaryoları, **kör sınav**) `18` boşluk iddia etti. `0076` onları
`L2 2.13`'e karşı ölçtü:

```
18 boşluk iddiası
 →  9  KURAL YOK      gerçek boşluk, L2 de sessiz     ← BU BELGE
 →  3  KISMEN VAR     ilke var, uygulama detayı yok
 →  6  KURAL VAR      0075 kaçırdı ya da yanlış varsaydı
```

⚠️ **Ve `9`'un biri `Faz 1`'e taşındı** — aşağıya bakınız. Bu belgede **sekiz** var.

## ⚠️ İkinci kaynak sınaması YAPILAMADI

`wella_actuals_first_scenarios.md` ile karşılaştırma yapıldı (`0076`'nın sonu) ve
sonuç: **`18` boşluk ne doğrulandı ne çürütüldü.** İki belge **farklı soruyu**
cevaplıyor:

```
wella   BİZ nasıl kaydederiz     ← hakediş zincirinin İLK yarısı
0075    KARŞI TARAF ne gönderir  ← ikinci yarısı
```

📌 Yani bu sekiz boşluk **tek kaynaktan** geliyor, ve bu **yazılı bir sınırdır**.

---

## SEKİZ AÇIK KARAR

| # | boşluk | senaryo | `L2`'nin bugünkü sınırı |
|---|---|---|---|
| **1** | Dış talep tutarının **KDV bileşeni** | `S1` | `K-2.13.4` alan listesi ve `K-2.13.14h6` (NET tanımı) — **vergi hiç geçmiyor** |
| **3** | **Kademe 2 anahtarı boşken** davranış | `S1` | `K-2.13.12` yalnız anahtar listesi verir, boş-anahtar davranışı yok |
| **7** | *"Gerçekleşti ama doğrulanmadı"* ara durumunun **görünürlüğü** | `S2` | `K-2.13.14e` **kavramı** tanımlıyor, arayüz durumu/rozeti hiçbir kuralda yok |
| **10** | **Araştırma süresince defter durumu** | `S3` | `K-2.13.18` yalnız *"mutabakat sonucu deftere yazılır"* — sonuçtan **ÖNCEki** durum tanımsız |
| **15** | Serbest bırakılmış bütçeye **sonradan gelen yükümlülük** | `S5` | `K-2.13.22a` yalnız serbest bırakma kuralını tekrarlıyor |
| **16** | *"İç talep üretilemedi"* **bildirimi** | `S6` | `K-2.13.10` eşleştirmenin çıkarım olduğunu söylüyor; **proaktif uyarı yok** |
| **17** | Boş aday kümesinin **kök neden ayrımı** | `S6` | `K-2.13.13` yalnız *"kaybolmaz, elle çözülür"* |
| **18** | **Kuyruğun yeniden taranması** | `S6` | hiçbir kuralda tetikleyici mekanizma yok |

### ⚠️ Sınıflandırma — hepsi aynı ağırlıkta değil

```
KAVRAM eksik      1 (KDV)                        →  veri modeline dokunur
DAVRANIŞ eksik    3 · 10 · 15 · 18               →  kural yazılır
ARAYÜZ eksik      7 · 16 · 17                    →  EK_E'nin 🔒 sınıfı ("mekanizma var, yol yok")
```

📌 Son üçü `EK_E`'nin **`🔒`** kategorisiyle aynı aile: yetenek var, arayüzü yok. Ve
`CLAUDE.md`'nin uyarısı geçerli — **`🔒` bir kabul değil, bir alarmdır.**

---

## ⚡ DOKUZUNCU BOŞLUK `FAZ 1`'E TAŞINDI — `Boşluk 4`

```
Boşluk 4   Kuyruğun SAHİBİ / SLA / eskalasyon           S1   KURAL YOK
L2 sınırı  K-2.13.13   "kaybolmaz, elle çözülür"
           K-2.13.12a  kimin ONAYLAYAMAYACAĞINI söyler
                       ama kimin SAHİP olduğunu SÖYLEMEZ
```

**Neden `Faz 1`:** `ADIM 3`'ün taksonomisi kuyruğu **bir yetenek hücresine** koyacak —
yani *"kuyruğa kim bakar"* sorusu `Faz 2`'ye ertelenemez, `ADIM 3` onu **zaten
cevaplamak zorunda**.

⚠️ Ve `Z18`'in kuralı burada bağlayıcı: **hiçbir hücre-rol çifti union gerekçesiyle
yaşayamaz.** Kuyruk bir hücreye konurken *"union böyle dedi"* yeterli değil — **sahiplik
bir ürün kararıdır.**

📌 Adres: `docs/process/ADIM3_FAZB_PLAN.md`, `B1`'in girdisi.
