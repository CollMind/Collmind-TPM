# `T-128` — `scripts/mutate.sh`: KURALI HATIRLAMAK YERİNE **ARACI ÇAĞIR**
### Şerit: `backend-engineer` · Hüküm: `Z109 §4 KAYIT 4` (ürün sahibi, 2026-09-08)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`
> taşır. **Etiketsiz iddia görürsen DUR ve brief'i İADE ET.**
> ⛔ **Raporunda da etiket kullan, ve ARAÇ NOTLARINI yaz.**

---

## 0 · OKUMA SIRASI (ZORUNLU) — ⛔ her yol `ls` ile doğrulandı 2026-09-08

```
1  docs/process/BRIEF_SABLONU.md                     ← sözleşmen
2  .claude/backlog/tasks/T-128.md                    ← ALTI VAKA + ŞARTNAME (asıl kaynak)
3  CLAUDE.md §2.7                                     → mutasyon disiplini, özellikle
                                                        :341 (#7 git diff) · :407-414 · :466 (üç vaka tablosu)
4  CLAUDE.md §3 "Her ajan için geçerli ölçüm kuralları" → git checkout YASAĞI
5  docs/DISIPLIN.md → "MUTASYONUN İKİ TÜRÜ: VARLIK ve YERLEŞİM"
                      "BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR"
                      "Bir YÖNLENDİRME sessiz olamaz"
6  collmind.backend/scripts/migration-verify.sh       ← ⭐ EMSAL: üç çıktılı araç,
                                                        "yüksek sesle eksik kalmak" deseni
7  scripts/guards/sigpipe-hygiene.sh                  ← ⛔ META KÖKÜNDE. Geçmen gereken kapı.
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | nerede |
|---|---|---|
| `Z109 §4 KAYIT 4` | *"üçüncüde araç"* — **altıncı vakadayız**, araç `DALGA-A`'dan ÖNCE | tamamı |
| `Z83` | kapı doğum kuralı: bilinen-yeşil **ve** bilinen-kırmızı | `§4` |
| `Z109 §4 KAYIT 2` | bir yönlendirme sessiz olamaz · **yüksek sesle eksik kalmak** | `§3.3` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · PROBLEM — tek cümle

> ### Mutasyon kuralı **altı kez ihlal edildi**, ve her seferinde *"kural işe yaradı"*
> ### diye kapandı. **İşe yaraması, ihtiyacı ortadan kaldırmıyor.**

```
[ÖLÇÜLDÜ: .claude/backlog/tasks/T-128.md — altı vaka, tarihleriyle]
  vaka 1  replace(…,1) ilk eşleşme bir YORUMDAYDI          → "self-test kör" YANLIŞ TEŞHİSİ
  vaka 2  hedef metin dosyada İKİ KEZ geçiyordu            → "hiçbir kapı görmüyor"
  vaka 3  perl \Q..\E metakarakter kaçırdı, $2 interpolate → "self-test kör"
  vaka 4  (2026-09-08, TEAM LEAD) girinti 6/8 uyuşmazlığı  → DOSYA HİÇ YAZILMADI
  vaka 5  (2026-09-08, ŞERİT) TS2345                        → derlenmeyen mutasyon
  + git checkout ile geri alma: untracked'da SESSİZ HİÇBİR ŞEY, tracked'da BAŞKASININ İŞİNİ SİLER
[ÖLÇÜLDÜ: T-128 açılış tarihi]  2026-08-10 — bir AY önce, ve kural "ÜÇÜNCÜde araç" diyor
```

⛔ **Ve vaka 4'ün şekli en tehlikelisi:** mutasyon **hiç uygulanmadı**, iki koşum
**mutasyonsuz** koda karşı yeşil çıktı, ve sonuç *"ayırt edicilik kanıtlanamadı"* diye
yazılabilirdi. Yakalayan şey **değiştirilen satırı basmak** oldu.

---

## 2 · ÜRÜN — `collmind.backend/scripts/mutate.sh`

```bash
bash scripts/mutate.sh --file <yol> --line <n> --to '<yeni satır>'  -- <ölçüm komutu...>
bash scripts/mutate.sh --file <yol> --line <n> --delete             -- <ölçüm komutu...>
```

⛔ **ARAYÜZ KARARI SANA AİT** ama iki şart bağlayıcı:
```
1  HEDEFLEME SATIR NUMARASIYLA — metin/glob/regex eşleştirmesi DEĞİL (vaka 1·2·3·4'ün kökü)
2  Araç ÖLÇÜMÜ DE KOŞAR — çünkü sıra bir DİSİPLİNDİR ve elde bırakılırsa atlanır
```

### `2.1` · ⛔ ZORUNLU SIRA — bu sıranın kendisi üründür

```
1  KOPYALA          hedef dosya → geçici kopya, shasum -a 256 KAYDEDİLİR
2  UYGULA           satır numarasıyla; --to (değiştir) ya da --delete (sil)
3  ⛔ BAS            DEĞİŞTİRİLEN SATIRI ekrana bas — ÖNCE ve SONRA
4  DOĞRULA          değişiklik GERÇEKTEN oldu mu (öncesi ≠ sonrası)
                    ⛔ olmadıysa → ÖLÇEMEDİM, ve ASLA "yeşil" DEĞİL
5  DERLE            tsc (ve gerekiyorsa lint) — ⛔ derlenmiyorsa ÖLÇEMEDİM
                    "derlenmeyen bir mutasyon HİÇBİR ŞEY KANITLAMAZ" (vaka 5)
6  ÖLÇ              `--` sonrası verilen komut koşulur, EXIT KODU YAKALANIR
                    ⛔ boruya SOKMA (§2.6) · ⛔ pipefail + grep -q YASAK (T-359)
7  GERİ YÜKLE       KOPYADAN (⛔ git checkout YASAK) + shasum -a 256 -c ile DOĞRULA
                    ⛔ doğrulanamazsa ARAÇ KIRMIZI DÖNER — kirli ağaç sessiz kalamaz
8  RAPORLA          üç değerli sonuç (§3)
```

⛔ **`7` HER DURUMDA KOŞAR** — ölçüm kırmızı verse de, araç çökse de (`trap`).

---

## 3 · ÜÇ DEĞERLİ SONUÇ — ve ikisi kolay karıştırılır

```
MUTASYON YAKALANDI    exit 0   mutasyon uygulandı · derledi · ölçüm KIRMIZI döndü
                               ⇒ testin AYIRT ETME GÜCÜ VAR
MUTASYON HAYATTA      exit 1   mutasyon uygulandı · derledi · ölçüm YEŞİL kaldı
                               ⇒ ⛔ TEST KÖR — ya da mutasyon YANLIŞ YERE düştü
ÖLÇEMEDİM             exit 2   mutasyon UYGULANAMADI · DERLEMEDİ · dosya yok ·
                               geri yükleme DOĞRULANAMADI
```

> ### ⛔ `ÖLÇEMEDİM`, `MUTASYON YAKALANDI`'ya **DÜŞMEZ.** Vaka 4'ün tamamı budur:
> ### uygulanmamış bir mutasyonun yeşili, *"test kör"* diye de *"test sağlam"* diye de
> ### okunabilir — **ikisi de yanlış**, çünkü **hiçbir şey ölçülmedi**.

### `3.1` · ⛔ VE `MUTASYON HAYATTA` BİR TEŞHİS DEĞİL, İKİ HİPOTEZDİR

Araç bunu **basmak zorundadır**:
```
⚠️ MUTASYON HAYATTA. İki açıklama var ve İKİNCİSİ DAHA OLASIDIR:
   (a) test kör
   (b) mutasyon YANLIŞ YERE düştü — ölü kod · yorum · ulaşılmayan dal
   ⇒ ÖNCE (b)'yi ele: bu satır GERÇEKTEN koşuyor mu?
```
`[ÖLÇÜLDÜ: CLAUDE.md §2.7]` — *"beklediğin test kırılmıyorsa ilk hipotez 'mutasyon yanlış
yere düştü' olmalı, 'test kör' değil."*

### `3.2` · YÖNLENDİRME SESSİZ OLAMAZ
Araç **her koşumda** basar: hedef dosya · satır no · öncesi/sonrası satır · koşulan ölçüm
komutu · geri yükleme `shasum` sonucu. `[emsal: migration-verify.sh "KOŞUM KOMUTLARI" bloğu]`

### `3.3` · YÜKSEK SESLE EKSİK KALMAK
Aracın **yapmadığı** şey de basılır (ör. lint koşulmadıysa, ya da bir dil için `tsc`
uygulanamıyorsa). ⛔ Sessizce atlama **yasak**.

---

## 4 · ⛔ DOĞUM ŞARTI (`Z83`) — ARAÇ BUNLARSIZ DOĞMAZ

Aracın kendisi bir kapıdır ⇒ kendi bilinen-yeşili ve bilinen-kırmızısı olmalı.
⛔ **Altı vakanın ALTISI da bir self-test vakası olur** (`T-128` şartnamesi):

```
1  ilk eşleşme YORUMDA           → satır-no hedeflemesi bunu YAPISAL olarak imkânsız kılar
                                    ⇒ self-test: bir yorum satırını hedefle, ARAÇ UYARSIN mı?
2  hedef metin İKİ KEZ geçiyor   → satır-no ile konu dışı; ama --to metni ÜRETİRKEN
                                    yanlışlıkla çoğaltma olmadığını DOĞRULA
3  regex metakarakter            → ⛔ LİTERAL yazma, regex DEĞİL
4  mutasyon HİÇ uygulanmadı      → self-test: değişmeyecek bir --to ver (satır AYNI kalsın)
                                    ⇒ araç ÖLÇEMEDİM dönmeli, "yeşil" DEĞİL
5  mutasyon DERLENMİYOR          → self-test: kasten bozuk TS üret ⇒ ÖLÇEMEDİM
6  geri yükleme başarısız        → self-test: kopyayı sil/boz ⇒ araç KIRMIZI, sessiz DEĞİL

BİLİNEN-YEŞİL   gerçek bir kapıyı kıran gerçek bir mutasyon → "MUTASYON YAKALANDI"
                ⛔ ÖNERİ (emsali var, ölçülmüş): ledger.repository.ts sumByAgreementId
                   yön ayrımını boz → reversal.e2e KIRMIZI olur
                   [ÖLÇÜLDÜ: docs/process/E2E_CORE_TARIFI.md §3]
                   ⚠️ o kanıt TARİHLİ (2026-09-08) — satır no KAYMIŞ olabilir,
                     MEKANİZMA ADIYLA ara, satır numarasıyla değil

BİLİNEN-KIRMIZI ölü koda/yoruma düşen bir mutasyon → "MUTASYON HAYATTA"
                ⇒ ve araç (b) hipotezini BASMALI
```

⛔ **`sigpipe-hygiene` kapısından geçer** (`scripts/guards/sigpipe-hygiene.sh`, META KÖKÜNDE).

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ ÜRÜN KODU     DOKUNMA — self-test dışında, ve self-test kendi FIXTURE'ını kullanır
                 (gerçek bir kaynak dosyayı bilinen-yeşil için mutasyona uğratırsan
                  GERİ YÜKLEMEYİ shasum ile DOĞRULA ve raporda BAS)
⛔ MIGRATION     YAZMA
⛔ docs/brd-v2/**  YAZMA
⛔ E2E           Ağır e2e koşma. Bilinen-yeşil için TEK bir hedefli suite yeter.
                 ⛔ İLK İŞ: test/.e2e-run.lock kontrolü (T-325)
⛔ GERİ ALMA     git checkout YASAK — kopya + shasum -a 256 -c
⛔ COMMIT/PUSH   YOK
⛔ T-267         Aracın bir TÜKETİCİSİ olmalı — en az bir yerde ÇAĞRILDIĞI gösterilir
                 (bu turda: kendi self-test'i + raporda bir gerçek kullanım örneği)
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/scripts/mutate.sh              YENİ
collmind.backend/scripts/mutate.self-test.sh    YENİ (ya da mutate.sh --self-test)
collmind.backend/package.json                   (script satırı — GEREKİYORSA)
```

## 7 · E2E KATMANI
```
Hedefli TEK suite (bilinen-yeşil için). TAM e2e GEREKMİYOR — ürün koduna kalıcı
dokunuş yok. Kapı: tsc 0 · npm run guards 0 (sigpipe-hygiene DAHİL).
```

## 8 · KAPANIŞ ÇIKTISI (bu başlıklarla)

```
1  ARAYÜZ            — nasıl çağrılıyor, hangi kararları sen verdin ve NEDEN
2  ZORUNLU SIRA      — §2.1'in sekiz adımı: hangileri uygulandı
3  ÜÇ DEĞERLİ SONUÇ  — üçünün de ÇIKTISI yapıştırılır
4  ALTI VAKA         — her biri için self-test, ve ÇIKTISI
5  DOĞUM ŞARTI       — bilinen-yeşil · bilinen-kırmızı, çıktılarıyla
6  TÜKETİCİ          — araç NEREDE çağrılıyor (T-267)
7  KAPI              — tsc 0 · guards 0 (sigpipe dahil)
8  ⛔ NE ÖLÇEMEDİN    — "ölçemedim" MEŞRU bir çıktıdır
```

⛔ **Ve bu araç `DALGA-A`'nın müşterisi olacak** (harness gibi). Arayüzü, bir brief'ten
**kopyalanabilir tek satır** olacak kadar basit tut.
