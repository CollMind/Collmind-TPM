# Bildirim Dilimi — Dalga Brief'i

> **Tarih:** 2026-08-28 · **Yazan:** Team Lead · **Statü:** ⛔ **KARAR BEKLER** — üç `DUR` kalemi var
> **Kaynak sözleşme:** `docs/decisions/BILDIRIM_VE_AUTH_ADRESI.md` (ürün sahibi, 2026-08-22)
> **Yürürlük hedefi:** `K-2.2.7b`'nin fiilî yürürlük anı
>
> **İşaretleme:** `[ÖLÇÜLDÜ]` bugün, canlı · `[GEREKÇELİ]` muhakeme · `[VARSAYIM]`

---

## 0 · TL;DR — dalga şekli DEĞİŞTİ, ve sebebi bir ölçüm

Dilim `2026-08-22`'de *"olay üretimi + tek kanal + üç olay türü"* diye tanımlandı.
Ölçüm **tabloyu ve kanalı zaten canlı** buldu — ama **eşik tarafını ölü.**

```
BEKLENEN İŞ      tablo yaz · kanal aç · üç olay üret
GERÇEK İŞ        tablo VAR · kanal CANLI · üretici SIFIR
                 ⛔ ve %90-pininin OKUYACAĞI KONFİGÜRASYON ÖLÜ BİR TABLODA
```

⇒ Dalga bir **inşa** değil, üçte ikisi bir **bağlama** işi — ve bağlanacak uçlardan
biri **bugün yanlış tabloya bakıyor**.

---

## 1 · ÖLÇÜM — bugünkü hâl (hepsi `[ÖLÇÜLDÜ]`, 2026-08-28)

### `1a` · Bildirim yüzeyi — **okuma canlı, yazma yolu SIFIR**

```
main.notifications          tablo VAR (1704067620000)  ·  DB satır: 0
NotificationService         277 satır · createNotification(...) yazıyor
createNotification ÇAĞRANI  0        ← TÜM src'de, CONTROLLER DAHİL
NotificationService enjeksiyonu (modül dışı)  0
controller uçları           GET / · GET /unread · POST /:id/read   (üçü de okuma/işaretleme)
                            T-249 + T-275 güvenlik katmanından geçti · B3 W1'de
                            @RequireCapability(NOTIFICATION_WRITE)'a göçtü
```

⛔ **VE ÜRÜN TARAFI DAHA KESKİN:**

```
collmind.frontend  NotificationCenter  →  Header.tsx:105  MONTE  (her sayfada)
```

> **Kullanıcı bugün canlı bir bildirim zili görüyor — ve o zil HİÇ ÇALAMAZ.**

📌 Bu, `Z56 §3b`'nin **mekanizma var · yol yok** yüzü, ama **en görünür hâli**:
`T-314/B`'de okuyucu da yoktu (hiç kimse fark etmezdi). Burada **okuyucu bir insan**,
ve boş kutu **her sayfada duruyor**.

### `1b` · ⛔ İKİ EŞİK AİLESİ — biri **ölü**, öteki **sapkın**

| tablo | merdiven | runtime okuyucu | canlı değer |
|---|---|---|---|
| `budget_policies` | **DAVRANIŞ** (`warning` · `finance_review` · `finance_review_mode`) | ⛔ **0** — yalnız seed | `50.00 / 60.00 / NOTIFY` |
| `budget_alert_configurations` | **RENK/RAG** (`WARNING_80` · `CRITICAL_95` · `EXCEEDED_100`) | ✅ `BudgetThresholdService` | `80 / 95 / 100` (varsayılan) |

**İki ayrı kusur, ve ikisi de `K-2.2.8`'de yazılı:**

1. ⛔ **`%90`-pininin okuyacağı konfigürasyon ÖLÜ TABLODA.**
   `financeReviewThresholdPct` + `financeReviewMode`'un **runtime tüketicisi yok**
   (`grep`, seed ve entity hariç: **0**). `K-2.2.7b`'nin `notify|approve` anahtarı
   **hiçbir kod tarafından okunmuyor.**
2. ⛔ **DAVRANIŞ MERDİVENİNİN HİÇBİR KADEMESİ UYGULANMAMIŞ.**

   ⚠️ **Bu maddeyi ÖNCE YANLIŞ YAZDIM ve ölçüm çürüttü** — kayda geçiyor, çünkü
   yanlış hâli daha *"beklenen"* olandı: `L2_01`'in *"kod `%95` kullanıyor — renk
   sınırını davranışa taşımış"* sapmasının **hâlâ canlı** olduğunu yazmıştım.
   **Ölçüm bunun tersini söyledi:**

   ```
   toStatus / isExceeded ÇAĞRI YERİ        6   ← hepsi sayıldı
   bunlardan DAVRANIŞ üreten (blok/red)    0   ← ALTISI DA UtilizationStatus (RENK) üretiyor
   %100 BLOCKED yolu (tüm src)             0   ← hiçbir yerde bloklama yok
   ```

   ⇒ **Renk merdiveni DOĞRU kullanılıyor** (yalnız renk üretiyor). `L2_01`'in
   *"sapma"* dediği şey **bugün YOK**.

   ⇒ **Ama gerçek boşluk daha büyük:** `K-2.2.7a`'nın üç kademesinden **`%80` uyarı
   dışında hiçbiri uygulanmamış** — `%90 FINANCE_REVIEW` **yok**, `%100 BLOCKED`
   **yok**. Davranış merdiveni bir **tabloda** yaşıyor (`budget_policies`) ve o
   tablonun **okuyucusu yok**.

   📌 `DISIPLIN`: *"çürüten ölçüm, doğrulayan ölçümden değerlidir"* — ve burada
   çürüyen şey **bir çelişki iddiasıydı**; çürümesi `DUR-2`'yi **kaldırdı** (`§2`).

⚠️ **Ve üçüncü bir sapma, seed'de:** `budget_policies` **`50/60`** ile ekili.
`K-2.2.8`'in görüşlü varsayılanı **`80/90/100`**. Yani pin bugün ölü tabloyu okusa
bile **yanlış sayıyı** okurdu.

### `1c` · Olay türleri — **ikisi yok**

```
NotificationType (backend enum ≡ frontend enum, birebir):
  APPROVAL_REQUESTED · APPROVAL_GRANTED · APPROVAL_REJECTED
  BUDGET_ALERT_80    · BUDGET_ALERT_100 · AGREEMENT_EXPIRING

dilimin istediği üç olay:
  eşik-%80 uyarı          → BUDGET_ALERT_80        ✅ VAR
  eşik-%90 finans bildirimi → ⛔ YOK
  onay-hatırlatma (7/14)   → ⛔ YOK  (AGREEMENT_EXPIRING BAŞKA bir olay)
```

⇒ **Enum genişletme = migration.** Tahsis: **`1816000000000`**.

### `1d` · ⛔ ZAMANLAYICI YOK — ve `Z50` ile ÇAKIŞIYOR

```
@nestjs/schedule   package.json'da YOK
@Cron / ScheduleModule   src'de 0
```

`K-2.5.10`'un `7/14` merdiveni **saat işidir** — yani bu dalga bir zamanlayıcının
**doğuşudur.** `BILDIRIM_VE_AUTH_ADRESI` yerleşimi tam bu yüzden seçmişti
(*"zamanlayıcı×kiracı tasarımı somut bir iş üstünde yapılır, soyut değil"*).

⛔ **AMA `Z50` O KARARDAN SONRA GELDİ VE KESİŞİMİ KESKİNLEŞTİRDİ:**

```
Z50   SET LOCAL + İSTEK-KAPSAMLI TX  =  KANONİK
zamanlayıcı  İSTEĞİ YOKTUR
       ⇒ tenant GUC'unu KİM, HANGİ KAPSAMDA kurar?
       ⇒ ve bir zamanlayıcı N kiracı için koşarsa, kapsam N kez mi değişir?
```

📌 Bu `ADIM 5`'in **zamanlayıcı×kiracı** kesişim kalemidir ve **cevabı yazılı değil.**

---

## 2 · ⛔ ÜÇ `DUR` KALEMİ — hüküm gerektirir

> `§2.4`: *"ADR ve BRD bir noktada sessiz veya çok anlamlıysa **DUR**."*
> Üçü de *"en makul olanı seçilebilir"* görünüyor — ve **üçü de bir ürün kararı.**

### `DUR-1` · `%90`-pini hangi tabloyu okuyacak?

| şık | ne demek | bedeli |
|---|---|---|
| **(a)** `budget_policies`'i **canlandır** | davranış merdiveni kendi tablosundan okunur · `K-2.2.7a/b` **birebir** · `financeReviewMode` **anlam kazanır** | `BudgetThresholdService`'in yanına **ikinci** bir okuyucu · seed `50/60` → `80/90` düzeltilir · `K-2.2.8a` (kanal×kategori çözümlemesi) bu tabloda **zaten** var |
| **(b)** `budget_alert_configurations`'a **`%90` kademesi ekle** | tek tablo, tek servis | ⛔ **renk merdivenine bir DAVRANIŞ kademesi eklemek** = `K-2.2.8`'in ayırdığı iki merdiveni **kalıcı olarak birleştirmek**. `L2_01`'in *"sapma"* dediği şeyi **kural hâline getirir** |
| **(c)** ertele — pin `%80`'i kullansın | dalga küçülür | ⛔ **dilimin gerekçesi buydu** (`K-2.2.7b`'nin yürürlük anı); erteleme dilimi anlamsızlaştırır |

⚠️ **`(b)` bir kısayol gibi görünüyor ve tam da bu yüzden tehlikeli:** `İlke 4`
(*"aynı olgunun iki temsili zamanla ayrışır"*) burada **tersine** işliyor — iki
**farklı** olgunun tek temsile sıkışması.

**Team Lead görüşü:** **(a)** — ve **çekincesiz**, çünkü `DUR-2` düştü:
`BudgetThresholdService` ile çakışma **yok** (o yalnız renk üretiyor).

### ~~`DUR-2`~~ · ⛔ **KALKTI — ölçüm iddiayı çürüttü** *(ve yerine bir KAYIT geldi)*

`DUR-2` şöyle yazılmıştı: *"`%90` doğru tablodan okunursa sistemde iki merdiven
birden davranış üretir — çelişki."* **Çelişki YOK**, çünkü renk merdiveni
**davranış üretmiyor** (altı çağrı yerinin altısı da renk — `§1b`).

⇒ **`%90`'ı canlandırmak hiçbir şeyle çakışmaz.** Dalga bu kalemden **daralır**.

📌 **KAYIT — dalganın kalemi DEĞİL, ama söylenmeden geçilemez:**
`K-2.2.7a`'nın **`%100 BLOCKED`** kademesinin **hiçbir uygulaması yok** (bloklama
yolu: `0`). Bu bildirim diliminin işi değildir — *bildirim* değil, *kontrol*. Ama
`%90`'ı bağlayan dalga, davranış merdivenine **ilk kez** dokunacak ⇒ boşluk o gün
görünür hâle gelir ve **adressiz kalmamalı.**
⇒ Ayrı task **`T-321`** (`blocked` — hüküm bekler), `SYSTEM_INVARIANTS`'a satır.

### `DUR-3` · Zamanlayıcı: bu dalgada mı doğar?

| şık | |
|---|---|
| **(A)** üç olayın **üçü de** bu dalgada · zamanlayıcı doğar | `7/14` gerçek olur · ⛔ **`Z50` kesişimi CEVAPSIZ** — zamanlayıcının tenant kapsamı tasarlanmalı |
| **(B)** dalga **iki eşik olayıyla** iner (`%80`+`%90`, ikisi de **istek içinde**) · `7/14` ayrı dalga | ⛔ **`Z50` kesişimine hiç girilmez** — iki eşik olayı da bir HTTP isteğinin içinde doğar, kapsam **zaten** kurulu · dilim **üç olay** diyordu ⇒ **sözleşme değişikliği, senin onayın gerekir** |

**Team Lead görüşü:** **(B)**. Gerekçe: `Z50` kesişimi bir **tasarım kararıdır**,
ve onu bir bildirim dalgasının **içine** sıkıştırmak `§2.4`'ün yasakladığı şeydir.
`7/14` kendi dalgasında, `ADIM 5` zamanlayıcı kalemiyle **birlikte** iner.

⚠️ **Ve bu, dilimin `2026-08-22` gerekçesini TERSİNE çevirir** (*"zamanlayıcı somut
bir iş üstünde tasarlansın"*) — bu yüzden **hüküm senin.**

---

## 3 · KABUL PİNLERİ — dört pin, ve **hiçbiri değer-pini değil**

### `P1` · `%90` — **İLİŞKİ-PİNİ** *(ürün sahibi şartı, `Z56 §4`)*

```
YANLIŞ   zarf %90'ı geçer → bildirim düşer          ← DEĞER-pini
DOĞRU    zarf KONFİGÜRE EDİLMİŞ finance_review eşiğini GEÇER → bildirim düşer
         eşiğin BİR ALTINDA  → düşmez
         ⇒ test eşiği KONFİGÜRASYONDAN OKUR, sabit yazmaz
         ⇒ pozitif kontrol: eşik DEĞİŞTİRİLİR, pin YİNE tutar
```

📌 `§2.3`: *"hardcoded threshold YASAK"*. `%90`'ı pinleyen bir test, eşik değiştiği
gün **doğru davranışı kırmızıya çevirir** — ve o gün kimse testin yanlış olduğunu
düşünmez, **kodun** yanlış olduğunu düşünür.

### `P2` · OLAY ↔ EŞİK AYRIŞMASI — **üç olayın üçünde aynı desen**

Her olay için pin **iki girdi, iki çıktı** şeklindedir ve eşiği **konfigürasyondan**
alır. Aynı desen `%80`'de ve (geldiğinde) `7/14`'te tekrar eder — yani `P1` bir
vaka değil, **bir şablon**.

### `P3` · TEKRAR-BASTIRMA — *"olay bir GEÇİŞTİR, durum değil"*

```
zarf %89 → %91   ⇒ BİR bildirim
zarf %91 → %92   ⇒ SIFIR bildirim      ← eşik zaten geçilmişti
zarf %91 → %88 → %91  ⇒ İKİNCİ bildirim  ← geçiş YENİDEN oldu
```

⛔ **Gerekçe ürün sahibinin kaydından:** aynı eşik-geçişi her yenilemede yeni bildirim
doğurursa **ilk gerçek kullanıcı bildirim-yorgunluğuyla özelliği kapatır** —
`K-2.2.7b`'nin amacı **karar-desteği**, gürültü değil.

⚠️ **Tasarım sonucu:** bir *"son bilinen kademe"* durumu **saklanmalıdır** (zarf
başına). Bu bir şema kalemidir ⇒ `1816`'nın kapsamına girer.
📌 Ve `§2.5`: kademe **okunamıyorsa** bildirim üretilmez **değil** — açık hata.

### `P4` · ⛔ SESSİZ-DÜŞME YASAĞI + **BİLDİRİM-YOLU-CANLILIĞI PİNİ**

> **Bildirim, doğası gereği "yokluğu fark edilmeyen" bir üründür — kullanıcı gelmeyen
> bildirimi bilemez; o yüzden kanıt yükü TAMAMEN BİZİM TARAFTA.**
> *(ürün sahibi, 2026-08-28)*

```
P4a  bildirim-yazımı BAŞARISIZSA görünür olur    ← audit-INSERT dersinin bildirim hali
     (yutulan exception YOK · status=FAILED bir SONUÇTUR, bir SESSİZLİK değil)
P4b  BİLDİRİM-YOLU-CANLILIĞI: üretici→tablo→okuma ucu zincirinin UCTAN UCA
     koştuğu ölçülür — "createNotification çağrıldı" DEĞİL, "GET /notifications
     o satırı DÖNDÜRÜYOR"
```

📌 `P4b`'nin gerekçesi bugünün ölçümünde duruyor: **tablo, servis, kanal ve UI'ın
dördü de vardı ve zincir kopuktu** — her parça tek tek *"var"* diye raporlanabilirdi.
`DISIPLIN`: *"bileşimsel fail-open — her parça masum, boşluk BİLEŞİMDE."*
⇒ `P4b` **kabulün parçasıdır**, bir ek değil.

---

## 4 · DALGA PLANI *(`DUR-1`=(a) · `DUR-3`=(B) VARSAYIMIYLA)*

| # | task | assignee | iş |
|---|---|---|---|
| `T-316` | `budget_policies` **canlanır** | `backend-engineer` | `BudgetPolicyService` — `K-2.2.8a/b/c` çözümlemesi (en spesifik kazanır) · seed `50/60` → `80/90` · ⚠️ **`§7`: `BudgetThresholdService` ile BİRLEŞMEZ, yanına gelir** — iki **farklı** merdiven, `K-2.2.7a` onları bilerek ayırıyor |
| `T-317` | enum + tekrar-bastırma şeması | `data-engineer` | `1816000000000` — `BUDGET_FINANCE_REVIEW` türü + zarf-başına *"son kademe"* · ⛔ **üç durum ayrımı zorunlu** (`1805`+ deseni) |
| `T-318` | olay üretimi (`%80` + `%90`) | `backend-engineer` | zarf tüketimi değiştiğinde **geçiş** ölçülür → `createNotification` · ⛔ **`FINANCE` alıcı çözümlemesi** · `§2.5`: eşik okunamazsa **açık hata** |
| `T-319` | dört pin | `qa-engineer` | `P1`–`P4` · ⛔ **`P4b` uçtan uca**, mock'suz e2e |
| `T-321` | `%100 BLOCKED` boşluğu | — | ⛔ **kod DEĞİL** — `blocked`, hüküm bekler; `SYSTEM_INVARIANTS` satırı bu dalgada yazılır |

**`touches:` kesişimi:** `T-316` ∥ `T-317` **disjoint** ⇒ paralel.
`T-318` ikisine de bağlı ⇒ **sıralı**. `T-319` en sonda. `T-321` kod içermez.
⚠️ **Ve `§ touches KESİŞİMİ YETMEZ`:** paralel çalışacaklara brief'te *"doğrulamanı
izole `git worktree`'de yap"* satırı **yazılı** gider.

---

## 5 · BİLİNÇLİ DIŞARIDA — ve **gerekçeleri**

| ne | gerekçe |
|---|---|
| e-posta kanalı | `2026-08-22` kararı — deploy'suz ortamda test edilemez |
| bildirim tercihleri | `K-2.10.2` kapıyı zaten kapatıyor |
| `K-2.10` tam olay listesi | üç türle başlamak sözlüğün *"ayrı tür ölçütü"*nü canlı test eder |
| **`7/14` hatırlatma** | ⛔ **YENİ** — `DUR-3 (B)`; `Z50` kesişimi cevaplanmadan zamanlayıcı doğmaz |
| **`%100 BLOCKED` kademesi** | ⛔ **YENİ** — bildirim değil **kontrol**; `T-321`, hüküm bekler |

---

## 6 · SENDEN BEKLENEN

```
DUR-1   %90 hangi tablodan okunur?          TL görüşü: (a) budget_policies canlanır
DUR-2   ⛔ KALKTI — ölçüm çürüttü (çelişki yok; dalga BU KALEMDEN DARALDI)
DUR-3   zamanlayıcı bu dalgada mı doğar?    TL görüşü: (B) HAYIR — dilim İKİ olayla iner
                                            ⚠️ bu bir SÖZLEŞME DEĞİŞİKLİĞİDİR
```

⛔ **Ve dördüncü bir şey, hüküm değil ama kayıt:** `budget_policies` seed'i `50/60`
ile ekili ve `K-2.2.8` `80/90/100` diyor. Bu **`DUR` değil** — sapma tek yönlü ve
kural yazılı ⇒ `T-316` düzeltir. Ama **söylenmeden geçilmemeli**, çünkü `%90`-pini
bugünkü seed'le koşsaydı `%60`'ı ölçer ve **yeşil geçerdi.**
