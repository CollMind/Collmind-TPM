# `scan.sh` — ÖLÇÜM İÇİN `mutate.sh`: **desen ⊇ evren?**
### Şerit: `backend-engineer` · Hüküm: `H6` (`ADIM-4` oturumu, ürün sahibi 2026-09-09)

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> Etiketsiz iddia → **DUR ve iade et**. Raporunda da etiket kullan, **araç notlarını yaz**,
> son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

## 0 · OKUMA SIRASI — ⛔ her yol `ls` ile doğrulandı 2026-09-09
```
1  docs/process/BRIEF_SABLONU.md
2  docs/process/Z109_ADIM4_DISIPLIN_TARAMASI_TASLAK.md → `S6` (R7 iki yüz + araç şekli)
3  collmind.backend/scripts/mutate.sh          ⭐ EMSAL — üç/dört değerli sonuç, trap, banner
4  collmind.backend/scripts/guards/manager-ratchet.sh   ← ratchet/self-test deseni
5  scripts/guards/sigpipe-hygiene.sh           ⛔ META KÖKÜNDE — geçmen gereken kapı
6  docs/DISIPLIN.md → "Negatif sonuçlu tarama, POZİTİF KONTROLSÜZ rapor edilemez"
                      "Kapsam maskelemesi — desen çalışır, EVREN eksiktir"
                      "BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR"
```

## 0.1 · HÜKÜM-ATIF
| Z-no | madde | nerede |
|---|---|---|
| `ADIM-4 H6` | `R7 YÜZ-2` (ölçüm) → **araç**; `Z83` ile; `T-128` emsali **tek tur** | tamamı |
| `Z83` | bilinen-yeşil **ve** bilinen-kırmızı | `§3` |

---

## 1 · PROBLEM — tek cümle

> ### Pozitif-kontrol kuralı *"desen **ÇALIŞIYOR** mu"*yu ölçer.
> ### ***"Desen EVRENİ KAPSIYOR mu"*** **ayrı bir sorudur — ve onun kontrolü YOK.**

```
[ÖLÇÜLDÜ: bu oturumun beş vakası]
  grep -rc "…" test/*.ts          ÖZYİNELEMESİZ  ⇒ yedinci kopya görünmedi ("altı kopya")
  "isoToday|isoPlusDays" 5 dosya  YORUMLA eşleşti ⇒ evren 6→3
  rg -l "on-invoice"  16 dosya    GÜRÜLTÜ         ⇒ çapa değil
  finance-reporting "üç yer"      TAM TARAMA DÖRT buldu
  ENV-2026-CAT-%                  Σ 2.000.000/7   ⇒ desensiz 2.300.000/8 (HAIR_CARE)
⇒ BEŞİNDE DE: sayı geldi, DOĞRU GÖRÜNDÜ, ve biri bir HÜKME girdi.
```
⛔ **Asimetri:** düzenlemede `assert` korur; **ölçümde hiçbir şey korumaz.**

---

## 2 · ÜRÜN — `collmind.backend/scripts/scan.sh`

```bash
bash scripts/scan.sh \
  --pattern '<desen>' \
  --scope-cmd '<EVRENİ ÜRETEN komut>' \
  --positive '<deseni YAKALAMASI gereken örnek>' \
  --negative '<deseni KAÇIRMASI gereken örnek>' \
  [--label '<ölçümün adı>']
```

### `2.1` · ⛔ EVREN **TÜRETİLİR**, GLOB VERİLMEZ
```
--scope-cmd 'find src test -name "*.ts" -not -path "*/node_modules/*"'   ✅ TÜRETİLMİŞ
--scope-cmd 'echo src/*.ts'                                              ⛔ REDDEDİLİR
```
⛔ Araç, `--scope-cmd` çıktısındaki **dosya sayısını basar** ve **sıfırsa `ÖLÇEMEDİM`**
döner (sessiz boş-evren YOK — `§2.7 #4`).
⚠️ Ve **`--pattern` içinde bir glob varsa UYARIR**: bir desen bir **dosya listesi**
değildir.

### `2.2` · ÇIKTI — **LİSTE**, SAYI DEĞİL
```
== EVREN ==      <n> dosya  [ÖLÇÜLDÜ: --scope-cmd çıktısı]
== POZİTİF ==    beklenen örnek YAKALANDI / ⛔ YAKALANMADI
== NEGATİF ==    beklenen örnek KAÇIRILDI / ⛔ YANLIŞLIKLA YAKALANDI
== EŞLEŞMELER == dosya:satır  ← HER BİRİ, kesilmeden
== ÖZET ==       <n> eşleşme, <m> dosya   ⛔ bu satır EN SONDA ve LİSTEDEN TÜRETİLMİŞ
```
⛔ **Sayı listeden TÜRETİLİR**, ayrıca sayılmaz — *"bir sayı, eşleşmeleri örneklenmeden
raporlanamaz"* kuralı **yapısal** olarak sağlanır.

### `2.3` · ÜÇ/DÖRT DEĞERLİ SONUÇ (⭐ `mutate.sh` emsali)
```
exit 0   TARAMA GEÇERLİ    pozitif YAKALANDI · negatif KAÇIRILDI · evren boş DEĞİL
exit 1   ⛔ DESEN BOZUK    pozitif kaçtı YA DA negatif yakalandı ⇒ SAYIYA GÜVENME
exit 2   ÖLÇEMEDİM         evren boş · --scope-cmd hata verdi · argüman eksik
exit 3   ⛔ ARAÇ HATASI    (varsa) — ölçüm kanalına sokulmaz
```
> ### ⛔ `exit 1` **"eşleşme yok" DEMEK DEĞİL** — *"bu taramanın SAYISINA GÜVENİLMEZ"*
> ### demektir. İkisi karıştırılırsa araç, kapatmak için doğduğu sınıfı ÜRETİR.

---

## 3 · ⛔ DOĞUM ŞARTI (`Z83`) — ürün sahibinin verdiği vaka
```
BİLİNEN-YEŞİL    doğru desen + türetilmiş evren ⇒ exit 0, LİSTE basılır
BİLİNEN-KIRMIZI  ⛔ ÜRÜN SAHİBİ ŞEKLİ: GLOB'LU bir tarama SENTETİK bir evrende
                 KAÇIRMALI — `test/*.ts` gibi özyinelemesiz bir kapsam, alt dizindeki
                 pozitif kontrolü GÖREMEZ ⇒ araç `exit 1` ("DESEN BOZUK") vermeli
ÖLÇEMEDİM        --scope-cmd boş döner ⇒ exit 2, ve NASIL düzeltileceği basılır
```
⛔ **Self-test** (`scan.self-test.sh`, `manager-ratchet-self-test.sh` deseni): bu üç
durum + `§1`'in **beş gerçek vakası** fixture olarak. ⛔ Gerçek guard'ı fixture'a karşı
koşturur, **mekanizmanın kopyasını yazmaz** (`§2.7 #8`).

---

## 4 · SINIRLAR (⛔ DUR)
```
⛔ ÜRÜN KODU DOKUNMA · migration YAZMA · docs/brd-v2/** YAZMA · yeni task AÇMA
⛔ docs/ altındaki ADIM-4 taslağına DOKUNMA — Team Lead o dosyada ÇALIŞIYOR
⛔ git checkout YASAK — kopya + shasum -a 256 -c
⛔ commit/push YOK
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm"
⛔ KAPI İKİ ZİNCİR: npm run guards (backend) VE cd .. && bash scripts/run-all.sh (META)
  — sigpipe-hygiene META'da; bu bir kez push'u durdurdu. `pipefail` + `grep -q` YASAK.
⛔ T-267: aracın bir TÜKETİCİSİ olmalı (self-test + raporda bir GERÇEK kullanım)
```

## 5 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
collmind.backend/scripts/scan.sh             YENİ
collmind.backend/scripts/scan.self-test.sh   YENİ
collmind.backend/package.json                (script satırı — GEREKİYORSA)
```

## 6 · E2E KATMANI
**YOK** — ürün koduna dokunulmuyor. Kapı: `tsc 0` (değişmemeli) · **iki guard zinciri**.

## 7 · KAPANIŞ ÇIKTISI
```
1  ARAYÜZ           — hangi kararları sen verdin ve NEDEN
2  ÜÇ/DÖRT DEĞER    — üçünün/dördünün de ÇIKTISI
3  DOĞUM ŞARTI      — bilinen-yeşil · GLOB'LU bilinen-kırmızı · ÖLÇEMEDİM
4  BEŞ GERÇEK VAKA  — §1'in beşi self-test'te, her biri ÇIKTISIYLA
5  TÜKETİCİ         — nerede çağrılıyor
6  KAPI             — tsc · İKİ zincir
7  ÜÇ METRİK        — tur süresi · review-tur · DUR
8  ⛔ NE ÖLÇEMEDİN
```
