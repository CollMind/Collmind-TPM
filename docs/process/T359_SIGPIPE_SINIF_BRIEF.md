# `T-359` — **SINIF olarak yeniden**: `pipefail` + `| grep -q` ⇒ SIGPIPE ⇒ SAHTE KIRMIZI

> **HEAD:** be `9a74733` (commit'li, **push'suz**) · meta `bcaaecb`
> **Hüküm:** ürün sahibi, 2026-09-04 — *"aralıklı sahte-kırmızı veren zincirle
> 'kapılar yeşil' beyanı verilemez"*

## `§0` · MEKANİZMA — ölçüldü, adlandırıldı

```
grep -q eşleşince ERKEN ÇIKAR  →  yazan taraf SIGPIPE alır  →  exit 141
set -o pipefail                →  141'i PIPELINE'ın kodu yapar
sonuç                          →  başarılı bir eşleşme, BAŞARISIZLIK gibi okunur
```

**Nedensellik `[ÖLÇÜLDÜ]`:**
```
set -uo pipefail;  printf "%s\n" "$(yes satir | head -300000)" | grep -q "^satir$"  →  141   (5/5)
                   (pipefail YOK)                                                   →  0     (3/3)
```

**Canlı vaka `[ÖLÇÜLDÜ]`:** `app-runtime-grants-self-test.sh`, `detector_alive()`:
```sh
printf '%s\n' "$(run "$GRANTS_COMPLETE" report)" | grep -q "^\[app-runtime-grants\] table:$1\$"
```
12 koşum → **4 KIRMIZI** (case 13/15, *"YAN ETKİ"*), her seferinde farklı case/tablo.
Aralıklı, çünkü **YARIŞ**: çıktı küçükken `printf` çoğu zaman `grep` çıkmadan bitiriyor.

> ### **SİNYAL SABİTSE SİNYAL DEĞİLDİR — VE RASTGELEYSE DE DEĞİLDİR.**

## `§1` · EVREN `[ÖLÇÜLDÜ]`

```
pipefail ∧ '| grep -q' taşıyan guard dosyası :  23
  ŞEKİL 1   printf/echo "$VAR" | grep -q       :  86   ← MEKANİK
  ŞEKİL 2   <komut> | grep -q                  : 102   ← DİKKAT
```
⚠️ Sayılar **kaba tarama**; ilk işin evreni **kesinleştirmek** (bir eşleşme iki şekle de
girebilir, yorum satırları sayılmış olabilir). **Kesin sayıyı sen ölç ve raporla.**

## `§2` · İŞ 1 — ŞEKİL 1 (mekanik)

```sh
printf '%s\n' "$VAR" | grep -q PATTERN     →     grep -q PATTERN <<< "$VAR"
```
Herestring bash tarafından **geçici dosyaya** yazılır ⇒ boru yok ⇒ SIGPIPE yok.
⚠️ `printf '%s\n'` ile `<<<` **aynı** sonu-satırsonu semantiğini verir; yine de
**davranışın değişmediğini** birkaç guard'da fiilen koşarak doğrula.

## `§3` · İŞ 2 — ŞEKİL 2 (mekanik DEĞİL)

```sh
if cmd | grep -q PAT; then …        →      out="$(cmd)" || rc=$?
                                           grep -q PAT <<< "$out"
```
⛔ **İki tuzak, ikisi de yazılı:**
1. **Exit kodu kaybolmasın.** `out=$(cmd)` içinde `cmd`'in kodu `$?`'a düşer; `set -e`
   altında `|| rc=$?` deseni gerekir. Bir guard'ın *"komut başarısız oldu"* dalı varsa
   **korunmalı** — yoksa `ÖLÇEMEDİM` dalı sessizce yeşile döner.
2. **Bazıları GÜVENLİ ve dokunulmamalı.** `head -1 file | grep -q '^#'` — `head` zaten tek
   satır yazar, SIGPIPE riski yok; gereksiz değişiklik **regresyon riskidir**.
   ⇒ **Her şekil-2 vakasını sınıflandır:** *dönüştürüldü* · *güvenli, dokunulmadı (gerekçe)*.

⚠️ `grep -qxF … "$FILE"` gibi **borusuz** kullanımlar bu sınıfa **girmez** — dokunma.

## `§4` · İŞ 3 — KAPILARIN KAPISI

Yeni bir guard: `scripts/guards/sigpipe-hygiene.sh`
```
tarar     scripts/ altındaki .sh dosyaları
kural     bir dosya `pipefail` taşıyorsa, '<üretici> | grep -q' deseni İÇERMEZ
çıktı     ihlal ADIYLA (dosya:satır)
istisna   §3'te "güvenli" diye sınıflanan desenler — ALLOWLIST DEĞİL, DESEN bazlı
          (ör. `head -N` üreticisi). Allowlist yazacaksan gerekçesi satır satır yazılır.
```
⛔ **Doğum şartı (`Z83`) — bu guard da BİLİNEN-YEŞİL ve BİLİNEN-KIRMIZI ile doğar:**
- bilinen-yeşil: temizlikten sonra `scripts/` genelinde **exit 0**
- bilinen-kırmızı: bir fixture'a `pipefail` + `printf | grep -q` koy ⇒ **kırmızı, adıyla**
- ⚠️ **Kaynak boşalırsa fark boş kalır** (`Z95` dersi): taranan dosya sayısı **0** çıkarsa
  guard **sessizce yeşil DEĞİL**, **exit 2 (ÖLÇEMEDİM)** vermeli.

## `§5` · PİNLER — sayıyla
```
PİN 1  ŞEKİL 1 dönüştürülen sayısı                    (ve kalan 0)
PİN 2  ŞEKİL 2: dönüştürülen / güvenli-bırakılan       (ikinci grubun gerekçesi)
PİN 3  app-runtime-grants-self-test 20 KOŞUM ⇒ 20/20 YEŞİL
       (bugünkü taban: 12 koşumda 4 KIRMIZI — düzeltmeden ÖNCE ve SONRA ölç)
PİN 4  npm run guards  20 KOŞUM  ⇒  20/20 exit 0
PİN 5  sigpipe-hygiene: bilinen-yeşil + bilinen-kırmızı + boş-evren ⇒ exit 2
PİN 6  hiçbir guard'ın DAVRANIŞI değişmedi — her guard'ın kendi self-test'i yeşil
```
⛔ **`PİN 3`/`PİN 4` bu turun taşıyıcı kanıtıdır.** Tek koşum yeterli **değildir** —
kusur zaten aralıklıydı. **Düzeltmeden önceki tabanı da ölç** (yönsüz reprodüksiyon).

## `§6` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- ⛔ **Ağaçta commit EDİLMİŞ ama PUSH EDİLMEMİŞ iş var** (`T-362`). `git reset`/`git checkout`
  ile geri alma **YASAK**; `git stash` **YASAK**; `git add -A` **YASAK**; **commit/push YAPMA**.
- Geri alma: **kopyala → uygula → kopyadan geri yükle → `shasum -a 256 -c`**.
- Doğrulamanı **izole `git worktree`'de** yap.
- `.env` **okuma**. **Canlı DB'ye YAZMA.** Container'a **dokunma**.
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma,
  tek komut koşma**. Bu repo `Collmind-TPM`.
- Exit kodunu **boruya sokma**: `cmd > /tmp/x.log 2>&1; echo $?`
- **Tam e2e'yi KOŞMA** (kilit Team Lead'de).
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR** — ya adlandırılmış bir mekanizma
  ya `ölçemedim`. (Bu turun konusu tam olarak budur: *"flaky"* denen şeyin adı **SIGPIPE**'tı.)
