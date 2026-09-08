# BRIEF ŞABLONU — `Z109 ADIM 1` (ürün sahibi, 2026-09-08)

> ## ⛔ BU ŞABLON BAĞLAYICIDIR
> Bir şerit brief'i bu şablona uymuyorsa, ajan **DUR** ile iade eder.
> Kaynak hüküm: `Z108 §3` (hüküm 20) · `Z109 §1` (hüküm 24).

---

## 0 · NEDEN — tek cümle

> ### Brief'te **İDDİA** ile **ÖLÇÜM** aynı yazı tipinde duruyor, ve bir sonraki el
> ### ikisini **AYIRT EDEMİYOR.**

Bu bir teori değil: bir dalganın **üç blocker'ının üçü de** bu kökten çıktı. Kanonik vaka —
bir brief'e şu yazıldı:

> *"kod turu bunun üstüne yeni kırmızı **eklemedi (ölçüldü)**"*

Kod turu **yalnız beş seçili suite** koşmuştu. `qa` **10 suite / 57 test** ölçüp çürüttü.
Parantez içindeki *"(ölçüldü)"* **yanlıştı** — ve tam o kelime, bir sonraki eli **yeniden
ölçmekten alıkoydu**. Yazan **Team Lead'di**.

---

## 1 · ⛔ ETİKET KURALI — üç etiket, ve dördüncüsü YOK

```
[ÖLÇÜLDÜ: <çalıştırılabilir komut  ya da  dosya:satır>]
[ÖLÇÜLMEDİ — ölçülecek: <NASIL ölçüleceği>]
[REVIEW İDDİASI — DOĞRULANMADI]
```

**Etiketsiz bir iddia = brief BOZUK ⇒ ajan DUR eder ve iade eder.** (`CLAUDE.md §2.4`)

### ⛔ VE `[ÖLÇÜLDÜ]`'NÜN KAYNAĞI BİR **KOMUT**TUR, BİR **RAPOR ADI** DEĞİL

```
❌  [ÖLÇÜLDÜ: T-385 raporu]              ← rapor VAR OLMAYABİLİR. Bir kez OLMADI da.
❌  [ÖLÇÜLDÜ: qa şeridi ölçtü]            ← kim, neyle, hangi kapsamda?
✅  [ÖLÇÜLDÜ: rg -n "isoToday" test/]     ← okuyucu KOŞAR ve GÖRÜR
✅  [ÖLÇÜLDÜ: budget.service.ts:1491]     ← okuyucu AÇAR ve GÖRÜR
```

> ### 📌 **VE SEBEBİ BİR ÖLÇÜMDÜR:** `T-385`'te *"altı kopya"* diye bir sayı yazıldı ve
> ### **yanlıştı**. Sebep sayı değil, **komuttu**:
> ```
> grep -rc "…" test/*.ts    ⛔ `test/*.ts` ÖZYİNELEMESİZ; `-r` bir dosya glob'uyla İŞLEVSİZ
>                              ⇒ test/helpers/ HİÇ TARANMADI ⇒ yedinci kopya görünmedi
> ```
> **Komut etikette yazılı olsaydı, okuyucu ARAÇ HATASINI SAYIYA BAKMADAN GÖRÜRDÜ.**
> Bir sayı denetlenemez; bir **komut** denetlenebilir.

---

## 2 · ⛔ HAZIR TARAMA DESENLERİ — kopyala, uydurma

### `2.1` · DİZİN ver, GLOB değil
```bash
rg -n -i 'desen' src/ test/          # ✅ özyinelemeli, dizin
grep -rn 'desen' src/ test/          # ✅ aynısı, rg yoksa
grep -rc 'desen' test/*.ts           # ⛔ YASAK — glob ÖZYİNELEMESİZ, `-r` İŞLEVSİZ
```
⚠️ Ve *"bulunamadı"* bir sonuç değildir — `DISIPLIN`: **negatif tarama, POZİTİF KONTROLSÜZ
rapor edilemez.** Deseninin **bulacağını bildiğin** bir şeyle önce sınadığını yaz.

### `2.2` · ⛔ `npx` YASAK — sahte saat SESSİZCE düşer
```bash
faketime -f "2026-10-01 12:00:00" node node_modules/.bin/jest --config ./test/jest-e2e.json …   # ✅
faketime -f "2026-10-01 12:00:00" npx jest …                                                     # ⛔ YASAK
```
```
[ÖLÇÜLDÜ: faketime … node -e 'new Date()']  → 2026-10-01T09:00:00Z   ✅ sahte saat geçerli
[ÖLÇÜLDÜ: faketime … npx  node -e 'new Date()'] → 2026-09-08T08:13Z  ⛔ SESSİZCE düştü
```
`npx` yeni bir node çözer ve `libfaketime`'ın `DYLD` enjeksiyonunu kaybeder.
⛔ **Ve aracın canlı olduğunu HER koşumda BAS** — rengin kendisi kanıt değil, **rengin sebebi**.
⚠️ `faketime` **DB'yi sahtelemez** (Postgres ayrı container, gerçek saat).

### `2.3` · ⛔ Exit kodunu BORUYA sokma, ve `grep -q` ile birleştirme
```bash
cmd > /tmp/x.log 2>&1; echo $?       # ✅ ölçmek istediğinin kodu
cmd | grep "Tests:"; echo $?          # ⛔ grep'in kodu (CLAUDE.md §2.6)
set -o pipefail; cmd | grep -q 'x'    # ⛔ YASAK — `grep -q` ilk eşleşmede kapanır,
                                      #    yazan taraf SIGPIPE alır, pipefail onu HATA sayar
                                      #    ⇒ BAŞARILI bir ölçüm KIRMIZI görünür (T-359)
```

### `2.4` · ⛔ BİR DOSYA YOLU DA BİR İDDİADIR — VE BAYATLAR
```
[ÖLÇÜLDÜ: ls -l scripts/guards/sigpipe-hygiene.sh]
```
📌 Ölçülmüş vaka (`Z109 ADIM 3`, 2026-09-08): bir brief'in okuma listesinde
`collmind.backend/scripts/guards/sigpipe-hygiene.sh` yazıyordu ve **o yol yoktu** —
dosya `T-359b` ile meta köküne taşınmıştı. Şerit ölçtü, bildirdi, brief `F12` ile düzeldi.
⛔ **Okuma listesindeki her yol, brief yazılırken `ls` ile doğrulanır.**

### `2.5` · Ölçüm ortamı — **ilk komut**
```bash
docker ps --filter "label=com.docker.compose.project=tpm"    # hayalet proje → DURDUR
```

---

## 3 · ⛔ ZORUNLU BÖLÜMLER — biri eksikse brief BOZUK

### `3.1` · HÜKÜM-ATIF TABLOSU
```
| Z-no    | madde  | bu brief'te nerede |
|---------|--------|--------------------|
| Z108 §2 | hüküm 19 | §4 İŞ 2          |
```
⛔ **Numarasız bir hüküm = DUR.** Gerekçe (`Z105 §1`): bir hüküm belgeye geçmediği için bir
dalga onu **kaybetti** ve yerine bir *"Team Lead kararı"* doğdu.
**Atıfsız hüküm, kaybolmuş hükmün habercisidir.**

### `3.2` · `touches` — **ÖLÇÜLMÜŞ**
Tahmin edilen değil, dokunulacağı **bilinen** dosyalar; ve şerit bitince **gerçekleşenle
güncellenir**. ⛔ Bir `touches` listesi de bir **listedir** — evreni tanımlamaz.

### `3.3` · E2E KATMANI — hangisi, KİM koşar
```
core   npm run e2e:core   ~2 dk    şerit koşar    ⛔ PUSH YETKİSİ VERMEZ
full   npm run e2e:full   ~15 dk   TEAM LEAD koşar (dalga-sonu birleşme + push-order)
```
⛔ Brief'te **hangisinin beklendiği yazılır**. Yazılmazsa şerit `full` varsayar (güvenli taraf).

### `3.4` · ÖNCE EVREN, SONRA LİSTE
Bir tarama isteniyorsa: **şekiller önce ADLANDIRILIR**, sonra her şekil **ayrı** taranır.
⛔ *"Bir liste vermek, EVRENİ tanımlamak değildir."*
📌 Ölçülmüş bedel: bir evren **üç turda üç kez** daraldı (`6 → 3 → 1`) ve üçünü de düzelten
şey daha iyi bir grep değil, bir **REPRODÜKSİYON** oldu.

### `3.5` · SINIRLAR (`⛔ DUR` maddeleri)
En az şunlar: migration yazma yetkisi · `docs/brd-v2/**` yazma yasağı · doğrulama izolasyonu
(`git worktree`) · `git checkout` yasağı (kopya + `shasum -a 256 -c`) · commit/push yetkisi.

### `3.6` · KAPANIŞ ÇIKTISI — başlıklarıyla
Son madde **her zaman** şudur:
```
⛔ NE ÖLÇEMEDİN — "ölçemedim" MEŞRU bir çıktıdır (kapının üçüncü hâli)
```

---

## 4 · ⛔ REPRODÜKSİYON — **YÖNSÜZ**

```
bir DÜZELTME iddiası   → önce KUSURU GÖR
bir KUSUR   iddiası    → önce KUSURU GÖR
```
İkisi **aynı kapıdan** geçer. *"Kusur var"* demek, *"kusur yok"* demek kadar bir **iddiadır**
— ve bu projede *"ilk gerçek satırda `500` verecek"* denen bir kusur **hiç görülmedi**.

**`Z83` doğum kuralı** her kapı/pin için: **bilinen-YEŞİL ve bilinen-KIRMIZI**, ikisi de
üretilmeden doğmaz.

---

## 5 · RAPOR — şerit de ETİKET kullanır

⛔ Brief'in sana uyguladığı kural **raporunda da geçerlidir**. Her satır ya
`[ÖLÇÜLDÜ: <komut>]` ya `[ÖLÇÜLMEDİ]` taşır.
⚠️ Ve **araç notlarını yaz** — bir sonraki el (Team Lead dahil) bağımsız ölçüm yapacak, ve
senin düştüğün tuzağa **yeniden düşmemesi** buna bağlı.
📌 Ölçülmüş vaka: bir şerit `npx`/`DYLD` tuzağını ölçtü ve raporuna yazdı; Team Lead raporu
**okumadan** bağımsız ölçüm yaptı ve **aynı tuzağa düştü**.
> ### **Bağımsız ölçüm, raporun ARAÇ NOTLARINI okuduktan sonra yapılır.
> ### Bağımsızlık, "OKUMADAN" demek değildir.**

---

## 6 · İSKELET — kopyalanacak hâli

```markdown
# <T-xxx> — <BAŞLIK: kusurun ADI, görevin değil>
### Şerit: <agent> · Hüküm: <Z-no §x> (ürün sahibi hükmü <n>, <tarih>)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia etiketli. Etiketsiz iddia görürsen **DUR ve brief'i İADE ET.**

## 0 · OKUMA SIRASI            (bu sırayla, ZORUNLU)
## 0.1 · HÜKÜM-ATIF TABLOSU    (Z-no · madde · brief-satırı — numarasız hüküm = DUR)
## 1 · PROBLEM — tek cümle     (+ nasıl doğdu, etiketli)
## 2 · EVREN                   (şekiller ADLANDIRILIR, sonra taranır)
## 3 · İŞ                      (her iş bir hükme atıflı)
## 4 · KAPANIŞIN KANITI        (Z83: bilinen-kırmızı VE bilinen-yeşil)
## 5 · SINIRLAR (⛔ DUR)
## 6 · touches                 (ölçülmüş; şerit bitince günceller)
## 7 · E2E KATMANI             (core mu full mu · kim koşar)
## 8 · KAPANIŞ ÇIKTISI         (son madde: ⛔ NE ÖLÇEMEDİN)
```

---

## 7 · BU ŞABLONUN KENDİSİ NE ÖLÇÜLDÜ

```
[ÖLÇÜLDÜ: Z107 · Z108 §6.1]  bir dalganın ÜÇ blocker'ı, kökü: etiketsiz iddia
[ÖLÇÜLDÜ: T-385 F12 #1/#2]   bir evren ÜÇ turda daraldı — 6 → 3 → 1
[ÖLÇÜLDÜ: Z108 §6.1 KAYIT 2] npx/DYLD tuzağı, ve bağımsız ölçümün onu DEVRALMASI
[ÖLÇÜLMEDİ — ölçülecek: Z110] bu şablon TUR SÜRESİNİ / REVIEW TURUNU / DUR SAYISINI
                              düşürüyor mu — taban bu hafta, karşılaştırma DALGA-A'da
```

⛔ **Son satır bilerek `[ÖLÇÜLMEDİ]`.** Bu şablon bir **hipotezdir**; işe yarayıp
yaramadığı `DALGA-A`'da ölçülecek. Bir süreç kuralı da bir **iddiadır**.
