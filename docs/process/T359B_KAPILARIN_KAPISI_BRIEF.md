# `T-359b` — **KAPILARIN KAPISI**: tek kapı, **META**'da, **kökler TÜRETİLMİŞ**

> **Push'lu HEAD:** meta `a708e16` · be `09378df` · fe `1553640` — ağaç **TEMİZ**
> **Hüküm:** ürün sahibi, 2026-09-05 (iki karar)

## `§0` · ⛔ ÖNCE BİR DÜZELTME — TEAM LEAD'İN ÖLÇÜMÜ YANLIŞTI

Önceki turda *"sınıf üç repoda temizlendi, kalan `0`"* raporlandı. **YANLIŞTI.**
Mekanizma: `n=$(grep -c … || echo 0)` — `grep -c` sıfır bulunca **exit 1** verir, `|| echo 0`
**ikinci bir `0`** ekler, değişken `"0\n0"` olur ve aritmetik sessizce bozulur.
⇒ *"negatif sonuç pozitif kontrolsüz raporlanamaz"* kuralının **ihlaliydi**.

**Gerçek tablo `[YENİDEN ÖLÇÜLDÜ]`** — pipefail'li `54` dosyada, boru **sağında**
erken-kapanan tüketici (`||` ve yorum satırları elenmiş):

```
collmind.frontend/scripts/guards/lint-ratchet-self-test.sh   2   ⛔ ŞEKİL 1, CANLI
collmind.frontend/scripts/guards/money-float.sh              1   ⛔ ŞEKİL 1, CANLI
collmind.backend/scripts/guards/roles-ratchet.sh             2      head -1 | grep -q
collmind.backend/scripts/guards/alan-guard-ratchet.sh        2      head -1 | grep -q
collmind.backend/scripts/guards/route-scope.sh               1      head -1 | grep -q
collmind.backend/scripts/guards/scope-ratchet.sh             1      head -1 | grep -q
collmind.backend/scripts/guards/migration-schema.sh          1      find … | head -1
collmind.backend/scripts/verification/k1b-two-marker-pin.sh  1      docker exec sh -c "… | head -1"
```

> ### **DALGA YALNIZ BACKEND'İ KAPSAMIŞ — FRONTEND'İN ÜÇ ŞEKİL-1 VAKASI CANLI.**
> Ve tam olarak bu yüzden kapı **meta'da** doğuyor: evren tek repo değil.

## `§1` · HÜKÜM 1 — TEK KAPI, **META**'DA, KÖKLER **TÜRETİLMİŞ**

```
YER        meta:  scripts/guards/sigpipe-hygiene.sh
           ⛔ collmind.backend/scripts/guards/'tan TAŞINIR — kopya DEĞİL
           ⛔ backend zincirinden ÇIKARILIR (lib.sh GUARD_NAMES_VALID + run-all.sh)
           ⛔ meta zincirine EKLENİR (meta: scripts/run-all.sh)
EVREN      "pipefail kullanan her .sh" — meta kökünden, submodule'ler görünür
           ⛔ ELLE KÖK LİSTESİ YAZILMAZ  (G5: türetilmiş > yazılmış)
```

**Gerekçe (ürün sahibi):** *"meta kendi zinciri"* = aynı kapının **iki kopyası** (`F8`).
Türetilmiş evren sayesinde **yarın frontend'e yeni bir guard-script'i doğsa**, kapı onu
kök listesine **eklenmeden** görür.

### ⛔ İKİ TUZAK — ÖLÇÜLDÜ, brief'e yazılıyor

```
1  `rg` BU ORTAMDA BİR SHELL FONKSİYONUDUR — script içinde YOKTUR.
   Guard `rg`'ye BAĞLANAMAZ. `find … -name '*.sh' | xargs grep -l 'set -.*o pipefail'`
   ya da eşdeğeri kullanılır.
2  `find` taraması `node_modules` ve `.git`'i AÇIKÇA elemelidir
   (bugün fark üretmiyor — ÖLÇÜLDÜ, 54 = 54 — ama bir bağımlılık yarın .sh getirebilir).
```

**Bugünkü türetilmiş evren `[ÖLÇÜLDÜ]`:** `54` dosya —
`collmind.backend 41 · collmind.frontend 5 · scripts 5 · .claude 2 · docs 1`.
📌 `.claude` ve `docs` altındaki üç dosya, önceki `scripts/`-kısıtlı taramada **YOKTU** —
türetilmiş evrenin yazılmış evrenden **geniş** olduğunun ölçülmüş kanıtı.

## `§2` · HÜKÜM 2 — `head -N` MUAFİYETİ **KALKAR**

> ### **`cmd | head -N` DE AYNI SINIFTIR:** `head` erken kapanınca yazan komut
> ### **SIGPIPE alır; `pipefail` altında `141`. `grep -q`'dan farkı YOK —**
> ### **yalnız YARIŞ OLASILIĞI çıktı boyutuna göre değişir.**

⛔ Bilinen bir sahte-kırmızı kaynağını kapıdan **muaf tutmak**, kapının **kendi kör
noktasını yazmak** olur (`B3` emsali: kör nokta, tehdidin geliş yönüyle **aynı eksende**).

**Sözleşme — kapının başlığına yazılır:**
```
pipefail altında ERKEN KAPANAN HİÇBİR TÜKETİCİ boru SAĞINDA olamaz:
  grep -q · grep -m1 · head · (ve aynı davranışı gösteren her araç)
```

### Mevcut vakalar: **muafiyet DEĞİL, LİSTE-TABANLI RATCHET** (`T-212` deseni)
```
bugünkü kullanımlar ADIYLA baseline'da     scripts/guards/sigpipe-hygiene-baseline.txt
YENİ ekleme YASAK                          (baseline'ı aşan ⇒ KIRMIZI)
düzeltildikçe DÜŞER                        ve baseline ASLA KENDİNİ YAZMAZ
```
⛔ **Baseline commit'i, azalmayı üreten commit'ten SONRA gelir** — ve *"sonrayı kim
yapacak"* yazılıdır: **iyileştiren tur** (`CLAUDE.md §4.2`).

**Düzeltme şekli — iki seçenek, ikisi de TÜM GİRDİYİ TÜKETİR:**
```
sed -n "1,${N}p"      ·      awk 'NR<=N'      ·      ya da değişkene alma
```

⚠️ `k1b-two-marker-pin.sh:62`'deki `head -1` bir **`docker exec … sh -c "…"`** dizesinin
İÇİNDE — yani **konteynerin kabuğunda** koşuyor, dış `pipefail` oraya geçmez.
**Sınıflandır ve gerekçesini yaz;** baseline'a girmeli mi, kapının evreninde mi — **ölç, karar
ver, ve kararı YAZ.** (Emin değilsen **DUR ve raporla**.)

## `§3` · FRONTEND'İN ÜÇ CANLI VAKASI — ŞEKİL 1, MEKANİK
```
collmind.frontend/scripts/guards/lint-ratchet-self-test.sh:59,66
collmind.frontend/scripts/guards/money-float.sh:309
```
`printf '%s\n' "$VAR" | grep -q…` → `grep -q… <<< "$VAR"`.
⚠️ **Frontend'in kendi kapı zinciri var** (`npm run guards`: `money-float` + `lint-ratchet`
self-test'leri). Dönüşümden sonra **FE zinciri koşulur ve yeşil olduğu gösterilir** —
bir self-test'in **davranışı** değişmemeli.

## `§4` · DOĞUM ŞARTI (`Z83`) — kapı YENİDEN doğuyor, şart YENİDEN uygulanır
```
BİLİNEN-YEŞİL    temizlik + baseline sonrası, meta kökünden ⇒ exit 0
BİLİNEN-KIRMIZI  her tüketici türü için AYRI fixture:  grep -q · head · grep -m1
                 ⇒ exit ≠ 0, ihlal dosya:satır ile ADLANDIRILMIŞ
BOŞ EVREN        taranan dosya 0 ⇒ exit 2 (ÖLÇEMEDİM), sessiz yeşil DEĞİL
BASELINE-AŞILDI  baseline'da olmayan yeni bir vaka ⇒ KIRMIZI
BASELINE-DÜŞTÜ   düzeltilmiş bir vaka ⇒ `improved` satırı (bloklamaz, ama KAPANMAMIŞ İŞ)
```

⛔ **Ve runner sözleşmesi:** meta'nın `scripts/run-all.sh`'ının bulguları nasıl saydığını
**OKU** — backend'de bu tam olarak bir kusur üretmişti: guard'ın **özet satırı** runner'ın
`^\[<guard>\]` desenine düşüyordu ⇒ bulgu `0` iken `COUNT=1`, ve gerçek bulgular
**prefikssiz** olduğu için hiç sayılmıyordu (**iki hata ters yönde**). Aynı tuzağa düşme.

## `§5` · PİNLER — sayıyla
```
PİN 1  guard meta'da · backend zincirinden ÇIKTI (lib.sh + run-all.sh) · meta zincirinde
PİN 2  türetilmiş evren: bugünkü dosya sayısı + repo dağılımı (elle liste YOK)
PİN 3  FE üç vaka dönüştü · FE `npm run guards` exit 0
PİN 4  baseline: kaç vaka, hangi dosyalar (adıyla)
PİN 5  doğum şartı beş senaryo (§4) — hepsi ölçülü
PİN 6  meta `bash scripts/run-all.sh` 10 KOŞUM ⇒ 10/10 exit 0
PİN 7  backend `npm run guards` 5 KOŞUM ⇒ 5/5 exit 0 (guard çıkarıldıktan sonra REGRESYON YOK)
```

## `§6` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- Ağaç **TEMİZ ve PUSH'LU** — bu turda `git reset`/`git checkout` ile geri alma **YASAK**,
  `git stash` **YASAK**, `git add -A` **YASAK**, **commit/push YAPMA**.
- Geri alma: **kopyala → uygula → kopyadan geri yükle → `shasum -a 256 -c`**.
- Doğrulamanı **izole `git worktree`'de** yap.
- `.env` **okuma** · canlı DB'ye **yazma** · container'a **dokunma**.
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma, tek
  komut koşma**. Bu repo `Collmind-TPM`.
- Exit kodunu **boruya sokma**: `cmd > /tmp/x.log 2>&1; echo $?`
- ⛔ **`grep -c` SIFIR BULUNCA exit 1 VERİR** — `|| echo 0` ile toplama sokma (`§0`'daki
  hatanın ta kendisi). Sayarken **pozitif kontrol** göster.
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR.**
