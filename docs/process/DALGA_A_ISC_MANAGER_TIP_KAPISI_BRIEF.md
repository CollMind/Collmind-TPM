# `DALGA-A` `İŞ C` — `manager` TİP KAPISI: **İKİ VAKA-YÜZEYİ** + **RATCHET**
### Şerit: `backend-engineer` · Hüküm: `Z108 §2` (hüküm 19) · kapsam kararı ürün sahibi 2026-09-08

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.** Raporunda da etiket kullan,
> ve **ARAÇ NOTLARINI yaz**.

---

## 0 · OKUMA SIRASI — ⛔ her yol `ls` ile doğrulandı 2026-09-08

```
1  docs/process/BRIEF_SABLONU.md
2  docs/brd-v2/04_KARAR_KAYDI.md → Z108 §2 (hüküm 19) · Z107 §1 (P1) · Z83
3  .claude/backlog/tasks/T-322.md   ← notification tx-manager, ROLLBACK-ARTIĞI (ilk vaka)
4  .claude/backlog/tasks/T-387.md   ← 🟡-4 / 🟡-5, bu işin ikinci yarısı
5  collmind.backend/scripts/guards/lint-ratchet.sh          ← RATCHET EMSALİ, oku ve İZLE
6  collmind.backend/scripts/guards/lint-ratchet-baseline.txt ← baseline BİÇİMİ
7  collmind.backend/scripts/guards/run-all.sh                ← yeni guard buraya bağlanır
8  scripts/guards/sigpipe-hygiene.sh   ⛔ META KÖKÜNDE — geçmen gereken kapı
9  collmind.backend/scripts/mutate.sh  ← tsc-kanıtı BUNUNLA verilir, elle DEĞİL
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | nerede |
|---|---|---|
| `Z108 §2` | hüküm 19 — `manager` **zorunlu**, tx-dışı çağıran **açıkça** geçer | `§2` |
| ürün sahibi 2026-09-08 | kapsam: **iki vaka-yüzeyi** + kalan 36 için **RATCHET** | `§2` · `§3` |
| `Z83` | kapı doğum kuralı: bilinen-yeşil **ve** bilinen-kırmızı | `§3.2` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — ve KAPSAMIN NEDEN BU KADAR

```
[ÖLÇÜLDÜ: rg -c "^\s+manager\?:\s*EntityManager,$" src/]   TOPLAM 52 metot · 11 dosya
[ÖLÇÜLDÜ: 45 benzersiz metot adının çağrı yerleri]          ~386 (üç jenerik ad şişiriyor;
                                                             ayıklanınca ~140)
```

⛔ **Team Lead önce *"dar, imza-only bir dokunuş"* dedi — ÖLÇÜLMEMİŞ bir cümleydi ve
ölçümle ÇÜRÜDÜ.** Hükmün **gerekçesi** sağlam kaldı (*"yarım tip kapısı, boşluk tam
vakanın doğduğu yerde"*), **maliyet beyanı** düştü.

⇒ Ürün sahibi kapsamı **ölçüme göre** yeniden çizdi:

```
BU TUR — İKİ VAKA-YÜZEYİ, BÜTÜN OLUR
  budget.repository.ts       14 metot   [ÖLÇÜLDÜ]  Z107 P1'in DOĞDUĞU yüzey
                             64 çağrı yeri (spec dahil) [ÖLÇÜLDÜ]
  notification.repository.ts  2 metot   [ÖLÇÜLDÜ]  T-322'nin DOĞDUĞU yüzey
                                        (.create ve .update — T-322 tam .create'ti)

KALAN — TASK DEĞİL, RATCHET
  52 − 14 − 2 = 36   [ÖLÇÜLDÜ: aritmetik, üç sayı da komutla geldi]
```

> ### ⛔ **`(A)` (52'nin hepsi) ÖLÇÜLEN MALİYETİYLE REDDEDİLDİ.** Kusur-yüzeyi dışındaki
> ### 36 için *"bir çağıran unutur"* riski **ratchet'le durur**: sınıf **büyümez**,
> ### ödeme **kademeli**, ve ~140 çağrı yerini tek dalgada açmak **gerekmez**.

---

## 2 · İŞ 1 — İKİ YÜZEY BÜTÜN OLUR

```
manager?: EntityManager          →   manager: EntityManager | undefined
```
⛔ **Çağıran AÇIKÇA yazmak ZORUNDA:**
```
tx İÇİNDE   →  o transaction'ın manager'ı
tx DIŞINDA  →  this.dataSource.manager   ya da   undefined
               ⛔ HANGİSİ olduğu YAZILI — sessiz-default DEĞİL (§2.5)
```
⚠️ **`undefined` ile `dataSource.manager` aynı şey DEĞİLDİR** — hangisini seçtiğini
metodun bugünkü davranışına bakarak belirle ve **davranışı DEĞİŞTİRME**. Bu tur
**imza** turudur; gövde semantiği **aynı kalır**.

⛔ **`envelopeFound?: boolean`** (`budget-availability-message.ts`) **AYNI HAMLE** —
`T-387 🟡-5` onu bu işin ikinci üyesi olarak adlandırıyor. `budget.repository` turuna
dahildir.

### `2.1` · ⛔ KANIT: `tsc` KIRMIZI — VE `mutate.sh` İLE
```bash
bash scripts/mutate.sh --file <bir ÇAĞIRAN> --line <n> --to '<parametreyi SİLEN satır>' \
  -- npx tsc --noEmit -p tsconfig.json
```
⇒ **`MUTASYON YAKALANDI` (exit 0)** beklenir: parametre silinince `tsc` **kırmızı**.
⛔ **Elle mutasyon YASAK** — araç var, araç çağrılır. Ve mutasyonu **her iki yüzeyde**
birer kez göster (budget + notification).

---

## 3 · İŞ 2 — `scripts/guards/manager-ratchet.sh`

```
KURAL   "manager?: EntityManager" sayısı 36'DAN ARTAMAZ
AZALMA  beklenen ve iyidir → baseline düşer, ⛔ AYRI ve SONRAKİ commit'te (§4.2)
```

### `3.1` · ŞEKİL — ⛔ EMSALİ İZLE, YENİDEN İCAT ETME
`scripts/guards/lint-ratchet.sh` + `lint-ratchet-baseline.txt` **oku ve aynı deseni kur**:
baseline dosyası · `--ratchet` (kapı) · `--baseline` (yeni referans üretir) · `--report`.
⛔ `scripts/guards/run-all.sh`'a bağla — **bağlanmayan bir guard, guard değildir** (`T-267`).

⚠️ **Sayım DOSYA BAZINDA tutulur, yalnız bir TOPLAM değil.** Gerekçe ölçülmüş
(`lint-ratchet` emsali): tek bir toplam, bir dosyada azalıp başkasında artınca **kör
kalır** — *"bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir."*

### `3.2` · ⛔ DOĞUM ŞARTI (`Z83`)
```
BİLİNEN-YEŞİL    bugünkü ağaç (iki yüzey düzeltildikten SONRA) → 36 → exit 0
BİLİNEN-KIRMIZI  SENTETİK 37.: bir dosyaya geçici bir `manager?: EntityManager,`
                 ekle → guard KIRMIZI vermeli, ve HANGİ DOSYADA arttığını BASMALI
                 ⛔ sentetik satır COMMIT EDİLMEZ (geri alma: kopya + shasum -a 256 -c)
ÖLÇEMEDİM        baseline dosyası yok/bozuksa → exit 2, ve NASIL üretileceği basılır
```
⛔ `sigpipe-hygiene` kapısından geçer: **`pipefail` + `grep -q` YASAK** (`T-359`).
⛔ Exit kodunu **boruya sokma** (`§2.6`).

---

## 4 · SINIRLAR (⛔ DUR)

```
⛔ GÖVDE DEĞİŞMEZ — bu bir İMZA turudur. Bir davranış değişikliği gerekiyorsa DUR ve bildir.
⛔ budget.* YASAĞI BU TUR İÇİN KALKTI (ürün sahibi, 2026-09-08) — gerekçe: DALGA-B
   PUSH'LU, paralel-dosya koruması artık gereksiz. ⛔ Ama YALNIZ imza; iş mantığına dokunma.
⛔ KALAN 36 METODA DOKUNMA — onlar ratchet'in konusu. Dokunursan ratchet tabanı kayar
   ve bu turun ayırt ediciliği kaybolur.
⛔ MIGRATION YAZMA · docs/brd-v2/** YAZMA · yeni task AÇMA
⛔ git checkout YASAK — kopya + shasum -a 256 -c
⛔ commit/push YOK · belirsizlikte DUR
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" + test/.e2e-run.lock
```

## 5 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
src/modules/shared/budget/budget.repository.ts            14 imza + çağıranları
src/modules/notification/notification.repository.ts        2 imza + çağıranları
src/modules/shared/budget/budget-availability-message.ts   envelopeFound
scripts/guards/manager-ratchet.sh                          YENİ
scripts/guards/manager-ratchet-baseline.txt                YENİ
scripts/guards/run-all.sh                                  bağlama
```

## 6 · E2E KATMANI
`npm run test:e2e` **tam** — imza değişikliği geniş bir çağıran yüzeyine dokunuyor.
Kapı: `tsc 0 · guards 0 (yeni ratchet DAHİL) · unit · e2e · [T-047 invariant] PASS`.

## 7 · KAPANIŞ ÇIKTISI

```
1  İKİ YÜZEY        — hangi metotlar, hangi çağıranlar; her çağıranda `undefined` mı
                      `dataSource.manager` mı SEÇİLDİ ve NEDEN (SAYI DEĞİL LİSTE)
2  tsc-KANITI       — mutate.sh çıktısı, HER İKİ yüzeyde birer vaka
3  RATCHET          — şekli, run-all bağlantısı, baseline biçimi
4  DOĞUM ŞARTI      — bilinen-yeşil (36) · bilinen-kırmızı (sentetik 37.) · ÖLÇEMEDİM,
                      ÜÇÜNÜN DE ÇIKTISI yapıştırılır
5  KAPI             — tsc · guards (ratchet dahil) · unit · e2e · T-047
6  ÜÇ METRİK        — tur süresi (duvar saati) · review-tur · DUR sayısı
7  ⛔ NE ÖLÇEMEDİN   — "ölçemedim" MEŞRU bir çıktıdır
```
