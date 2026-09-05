#!/usr/bin/env bash
#
# Guard: sigpipe-hygiene ([[T-359]] → [[T-359b]] "KAPILARIN KAPISI")
#
# NE YAPAR: `pipefail` taşıyan bir `.sh` dosyasında, boru SAĞINDA erken kapanan
# bir tüketiciyi (`grep -q` · `grep -m<N>` · `head`) YASAKLAR.
#
# NEDEN ([[T-359]] — mekanizma ÖLÇÜLDÜ, adlandırıldı)
#
#   grep -q eşleşince ERKEN ÇIKAR  →  yazan taraf SIGPIPE alır  →  exit 141
#   head -N N satır sonra ERKEN ÇIKAR → yazan taraf SIGPIPE alır → exit 141
#   set -o pipefail                →  141'i PIPELINE'ın kodu yapar
#   sonuç                          →  başarılı bir eşleşme, BAŞARISIZLIK gibi okunur
#
# Canlı vaka: `app-runtime-grants-self-test.sh:314` — standalone 20 koşumda
# 6 kırmızı verdi, hepsi `line 314: printf: write error: Broken pipe`.
# Aralıklı, çünkü YARIŞ: `printf` çoğu zaman `grep -q` çıkmadan bitiriyor —
# ama çıktı büyüdükçe olasılık artıyor.
#
# ⛔ [[T-359b]] HÜKÜM 1 — TAŞINDI: bu guard ESKİDEN
# `collmind.backend/scripts/guards/sigpipe-hygiene.sh` idi, yalnız backend'i
# tarıyordu. Ürün sahibi hükmü: kapı META'ya taşınır (kopya DEĞİL — backend
# zincirinden ÇIKARILDI), evren "pipefail kullanan her .sh" olarak meta
# kökünden TÜRETİLİR — submodule'ler görünür. Gerekçe: `§0` ölçümü, dalganın
# yalnız backend'i kapsadığını, frontend'in ÜÇ CANLI vakasının hiç görülmediğini
# gösterdi (evren tek repo olunca kör nokta doğuyor).
#
# ⛔ [[T-359b]] HÜKÜM 2 — İSTİSNA KALKTI: eski sürüm `head -N <kaynak> |
# grep -q ...` desenini GÜVENLİ sayıp muaf tutuyordu ("head zaten sınırlı
# satır yazar"). Ölçüldü ve YANLIŞ bulundu: `head` erken kapanınca üretici de
# SIGPIPE alır — `grep -q`'dan farkı YOK, yalnız YARIŞ OLASILIĞI çıktı
# boyutuna göre değişir. Bilinen bir sahte-kırmızı kaynağını MUAF TUTMAK,
# kapının KENDİ kör noktasını yazmak olurdu (B3 emsali). Sözleşme artık:
#
#   pipefail altında ERKEN KAPANAN HİÇBİR TÜKETİCİ boru SAĞINDA olamaz:
#     grep -q · grep -m<N> · head · (ve aynı davranışı gösteren her araç)
#
# Eski istisnanın kapsadığı SEKİZ vaka (backend beş dosya + k1b) muafiyet
# DEĞİL, LİSTE-TABANLI RATCHET'e geçti: `sigpipe-hygiene-baseline.txt`.
# Baseline'da ADIYLA duran bir bulgu bloklamaz; YENİ bir bulgu (baseline'da
# olmayan) bloklar. Baseline ASLA KENDİNİ YAZMAZ (`--baseline` ile üretilir,
# insan onayıyla commit edilir).
#
# DOĞUM ŞARTI (Z83): beş senaryo TEK self-test'te — `--self-test` ile
# çağrılır: bilinen-yeşil · bilinen-kırmızı (üç tüketici türü ayrı ayrı) ·
# boş-evren · baseline-aşıldı · baseline-düştü.
#
# ⚠️ KAYNAK BOŞALIRSA FARK BOŞ KALIR (Z95 dersi, T-100'ün aynısı): taranan
# .sh dosya sayısı 0 çıkarsa guard SESSİZCE YEŞİL DEĞİL, exit 2 (ÖLÇEMEDİM)
# verir.
#
# İKİ TUZAK ([[T-359b]] §1, ÖLÇÜLDÜ — brief'te yazılıydı):
#   1. `rg` bu ortamda bir SHELL FONKSİYONUDUR, script içinde YOKTUR — guard
#      ona bağlanamaz. `find ... -name '*.sh'` + `grep -lE` kullanılır.
#   2. `find` taraması `node_modules` ve `.git`'i AÇIKÇA eler (bugün fark
#      üretmiyor — 61 aday .sh'den 54'ü pipefail taşıyor, node_modules/.git
#      içinde .sh yok — ama bir bağımlılık yarın .sh getirebilir).
#
# GUARD_MODE=block   → bulgu varsa exit 1 (varsayılan, düz tarama modunda)
# GUARD_MODE=report  → bulguları bas, exit 0 (runner çağrısı / triyaj)
# exit 2             → KURULUM HATASI / ÖLÇÜM YAPILMADI (boş evren, taranacak
#                       dizin yok, bozuk/eksik --ratchet baseline) — bulgu
#                       DEĞİL, "bu koşumun sonucuna güvenme"
#
# MODLAR:
#   sigpipe-hygiene.sh              düz tarama (GUARD_MODE ile) — bilgi amaçlı
#   sigpipe-hygiene.sh --baseline   taze baseline'ı stdout'a bas (operatör
#                                   yönlendirir; yazma İNCELENEBİLİR bir diff)
#   sigpipe-hygiene.sh --ratchet    KAPI: dokunulan/yeni bir dosyanın bulgu
#                                   sayısı baseline'ı AŞARSA exit 1
#   sigpipe-hygiene.sh --self-test  doğum şartı (Z83), beş senaryo
#
# ENV override (yalnız self-test için):
#   SIGPIPE_HYGIENE_SCAN_DIR       taranacak kökü değiştirir (varsayılan: meta kökü)
#   SIGPIPE_HYGIENE_BASELINE       baseline dosyasını değiştirir
set -uo pipefail

GUARD_NAME="sigpipe-hygiene"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SCAN_DIR="$(cd "$DIR/../.." && pwd)"
DEFAULT_BASELINE="$DIR/sigpipe-hygiene-baseline.txt"

# ── ÜRETİCİ | <erken-kapanan tüketici> TESPİTİ ──────────────────────────
#
# `apply_sigpipe_check`: hem üretim taraması HEM self-test AYNI fonksiyondan
# geçer (ADR 0007 E16 dersi — bir kontrolü sınayan test kendi kopyasını
# çalıştırmaz).
#
# 1) dosya gerçekten `pipefail` mi taşıyor (yorum satırı DEĞİL)?
# 2) taşıyorsa: `[^|]| *(grep -[a-zA-Z]*q|grep -m ?[0-9]|head)` deseni var mı
#    (`||` mantıksal OR hariç tutuluyor — tek `|` karakteri arıyoruz, önünde
#    başka bir `|` yok)?
# `strip_noise`: YORUM satırlarını ve HEREDOC GÖVDELERİNİ (`<< 'EOF' ... EOF`)
# eler — bunlar ÇALIŞAN kod değil, çoğu zaman TAM DA bu deseni ANLATAN metin
# (bkz. CLAUDE.md "YORUM KİRLİLİĞİ iki yönde birden yanıltır"). Heredoc
# gövdesi elenmezse bu guard'ın KENDİ self-test fixture'ları (aşağıda) kendi
# taramasında YANLIŞ POZİTİF üretir — [[T-359]] turunda ÖLÇÜLDÜ.
strip_noise() { # <dosya>  → satır_no:içerik  (yorum/heredoc-gövdesi HARİÇ)
  awk '
    BEGIN { in_heredoc = 0; delim = "" }
    {
      line = $0
      if (in_heredoc) {
        t = line
        gsub(/^\t+/, "", t)
        if (t == delim) { in_heredoc = 0 }
        next
      }
      if (match(line, /<<-?[ \t]*['"'"'"]?[A-Za-z_][A-Za-z0-9_]*['"'"'"]?/)) {
        seg = substr(line, RSTART, RLENGTH)
        d = seg
        gsub(/<<-?[ \t]*/, "", d)
        gsub(/['"'"'"]/, "", d)
        delim = d
        in_heredoc = 1
        next
      }
      t2 = line
      gsub(/^[ \t]*/, "", t2)
      if (t2 ~ /^#/) next
      print NR ":" line
    }
  ' "$file"
}

# pipefail'e bağlı olmayan bir yardımcı: dosya gerçekten (yorum/heredoc DIŞI)
# `pipefail` taşıyor mu? Boş-evren SAYIMI ve tarama AYNI kaynaktan geçsin diye
# apply_sigpipe_check'ten AYRIŞTIRILDI.
file_has_pipefail() { # <dosya>  → $?: 0 taşıyor, 1 taşımıyor
  local file="$1" noise
  noise="$(strip_noise "$file")"
  grep -qE '\bpipefail\b' <<< "$noise"
}

apply_sigpipe_check() { # <dosya> [<görünen-ad — bulgu satırında basılır>]
  local file="$1" display="${2:-$1}" noise
  noise="$(strip_noise "$file")"
  # yorum-satırı-DIŞI VE heredoc-gövdesi-DIŞI pipefail bildirimi var mı
  # (KENDİ kodumuz da bu guard'ın sınadığı kurala uyar — herestring, boru DEĞİL)
  if ! grep -qE '\bpipefail\b' <<< "$noise"; then
    return 0
  fi
  local entry lineno content
  while IFS= read -r entry; do
    [ -z "$entry" ] && continue
    lineno="${entry%%:*}"
    content="${entry#*:}"
    # `[^|]| *(grep -[a-zA-Z]*q|grep -m ?[0-9]|head)`: TEK boru (`||` mantıksal
    # OR hariç), sağında `grep -q...`, `grep -m<N>...` ya da `head...` var mı.
    # ⛔ [[T-359b]] Hüküm 2: `head -N <kaynak> | grep -q` ÖNCEDEN muaf tutulan
    # "head-güvenli-üretici" istisnası KALKTI — üretici tarafı ARTIK sınanmıyor,
    # yalnız SAĞ taraf (tüketici) sınanıyor.
    if ! grep -qE '[^|]\| *(grep +-[a-zA-Z0-9]*q|grep +-m ?[0-9]|head\b)' <<< "$content"; then
      continue
    fi
    # ⛔ BULGU SATIRI `[<guard>]` ile PREFİKSLENİR — bulguyu ayırt eden budur.
    printf '[%s] %s:%s: %s\n' "$GUARD_NAME" "$display" "$lineno" "$(printf '%s' "$content" | sed -e 's/^[[:space:]]*//')"
  done <<< "$noise"
}

SCAN_DIR="${SIGPIPE_HYGIENE_SCAN_DIR:-$DEFAULT_SCAN_DIR}"
BASELINE="${SIGPIPE_HYGIENE_BASELINE:-$DEFAULT_BASELINE}"
GUARD_MODE="${GUARD_MODE:-block}"

# ⛔ EVREN elle yazılmış bir kök listesi DEĞİL — `find` ile TÜRETİLİR (G5:
# türetilmiş > yazılmış). `node_modules` ve `.git` AÇIKÇA elenir (bugün fark
# üretmiyor, ölçüldü — ama bir bağımlılık yarın .sh getirebilir).
candidate_files() { # <scan-dir>  → satır satır .sh yolu, sıralı
  find "$1" -type f -name '*.sh' \
    -not -path '*/node_modules/*' \
    -not -path '*/.git/*' \
    2>/dev/null | sort
}

run_scan() { # <scan-dir>  →  stdout: ihlaller (SCAN_DIR'e göre relatif dosya:satır: içerik)
  local scan_dir="$1" f rel
  scan_dir="$(cd "$scan_dir" && pwd)"
  while IFS= read -r f; do
    rel="${f#"$scan_dir"/}"
    apply_sigpipe_check "$f" "$rel"
  done < <(candidate_files "$scan_dir")
}

pipefail_file_count() { # <scan-dir>  → stdout: pipefail taşıyan dosya sayısı
  local scan_dir="$1" f n=0
  while IFS= read -r f; do
    file_has_pipefail "$f" && n=$((n + 1))
  done < <(candidate_files "$scan_dir")
  echo "$n"
}

# ── RATCHET — T-212 deseni (money-float ailesiyle AYNI): baseline ASLA
# KENDİNİ YAZMAZ, `--baseline` ile üretilir, insan onayıyla commit edilir. ──
counts_by_file() { # <ham-bulgu-akışı>  → "<dosya> <sayı>" satırları, sıralı
  printf '%s\n' "$1" | grep -E "^\[$GUARD_NAME\] " \
    | sed -E "s/^\[$GUARD_NAME\] //; s/:[0-9]+:.*$//" \
    | sort | uniq -c | awk '{printf "%s %s\n", $2, $1}' | sort
}

case "${1:-}" in
  --baseline)
    if [ ! -d "$SCAN_DIR" ]; then
      echo "!! [$GUARD_NAME] SETUP HATASI: taranacak dizin yok: $SCAN_DIR" >&2
      exit 2
    fi
    RAW="$(run_scan "$SCAN_DIR")"
    echo "# sigpipe-hygiene baseline — [[T-359b]] ratchet referansı"
    echo "# date:    $(date +%Y-%m-%d)"
    echo "# commit:  $(git -C "$SCAN_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    echo "# guard:   sigpipe-hygiene v2 (meta, head+grep-m1+grep-q)"
    echo "# total:   $(printf '%s\n' "$RAW" | grep -c "^\[$GUARD_NAME\] " || true) bulgu, $(counts_by_file "$RAW" | wc -l | tr -d ' ') dosyada"
    echo "# format:  <dosya> <sayı>   (meta köküne göre relatif yol, sıralı)"
    counts_by_file "$RAW"
    exit 0
    ;;
  --ratchet)
    if [ ! -d "$SCAN_DIR" ]; then
      echo "!! [$GUARD_NAME] SETUP HATASI: taranacak dizin yok: $SCAN_DIR" >&2
      exit 2
    fi
    if [ ! -f "$BASELINE" ]; then
      echo "!! [$GUARD_NAME] no baseline at $BASELINE — run --baseline first" >&2
      exit 2
    fi
    RAW="$(run_scan "$SCAN_DIR")"
    CUR="$(counts_by_file "$RAW")"
    RC=0
    IMPROVED_COUNT=0
    while read -r bfile bcount; do
      case "$bfile" in ''|\#*) continue ;; esac
      case "$bcount" in
        ''|*[!0-9]*)
          echo "!! [$GUARD_NAME] SETUP FAILURE: malformed baseline line for $bfile (count: '$bcount')" >&2
          exit 2
          ;;
      esac
      local_now="$(printf '%s\n' "$CUR" | awk -v f="$bfile" '$1==f {print $2}')"
      abs_path="$SCAN_DIR/$bfile"
      if [ ! -e "$abs_path" ]; then
        echo "-- [$GUARD_NAME] GONE: $bfile (baseline $bcount) — deleted or renamed; drop the line in the same commit"
        continue
      fi
      local_now="${local_now:-0}"
      if [ "$local_now" -gt "$bcount" ]; then
        echo "[$GUARD_NAME] $bfile"
        echo "  RATCHET VIOLATION: $bcount -> $local_now bulgu"
        RC=1
      elif [ "$local_now" -lt "$bcount" ]; then
        echo "-- [$GUARD_NAME] improved: $bfile $bcount -> $local_now (baseline'ı --baseline ile YENİDEN ÜRET, ayrı commit'te)"
        IMPROVED_COUNT=$((IMPROVED_COUNT + 1))
      fi
    done < "$BASELINE"

    while read -r cfile ccount; do
      [ -n "$cfile" ] || continue
      if ! grep -qE "^${cfile} " "$BASELINE"; then
        echo "[$GUARD_NAME] $cfile"
        echo "  BASELINE-AŞILDI: baseline'da olmayan YENİ bir vaka, $ccount bulgu (pipefail altında grep -q/grep -m<N>/head boru sağında olamaz)"
        RC=1
      fi
    done <<< "$CUR"

    # ⛔ [[T-359b]] §4 BİLE BİLE FARKLI: money-float'ta "improved" bir GATE'e
    # dönüşür (baseline güncellenmezse RC=1). Burada BİLİNÇLİ olarak DEĞİL —
    # brief'in Doğum Şartı tablosu açık: "BASELINE-DÜŞTÜ ⇒ improved satırı
    # (bloklamaz, ama KAPANMAMIŞ İŞ)". Bilgi amaçlı satır basılır, RC
    # ETKİLENMEZ; kapanmamış işi izlemek CLAUDE.md §4.2'nin "iyileştiren tur"
    # kuralına bırakılır.
    if [ "$IMPROVED_COUNT" -gt 0 ]; then
      echo "-- [$GUARD_NAME] KAPANMAMIŞ İŞ: $IMPROVED_COUNT dosya baseline'dan İYİLEŞTİ ama baseline düşürülmedi (bloklamıyor)."
    fi

    exit "$RC"
    ;;
esac

# ── SELF-TEST ────────────────────────────────────────────────────────────
self_test() {
  local tmp fail=0
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  # 1) bilinen-yeşil: pipefail var, ama yasak desen YOK (herestring + basit boru)
  mkdir -p "$tmp/green"
  cat > "$tmp/green/clean.sh" << 'EOF'
#!/usr/bin/env bash
set -uo pipefail
count="$(printf '%s\n' "$VAR" | wc -l)"
grep -q "pattern" <<< "$VAR"
EOF
  local green_out green_rc
  green_out="$(SIGPIPE_HYGIENE_SCAN_DIR="$tmp/green" GUARD_MODE=report bash "$DIR/$GUARD_NAME.sh" 2>&1)"
  green_rc=$?
  if [ "$green_rc" -ne 0 ]; then
    echo "!! self-test FAIL [bilinen-yeşil]: exit 0 bekleniyordu, $green_rc bulundu" >&2
    printf '%s\n' "$green_out" >&2
    fail=1
  elif grep -q "clean.sh" <<< "$green_out"; then
    echo "!! self-test FAIL [bilinen-yeşil]: temiz dosya YANLIŞ POZİTİF verdi" >&2
    printf '%s\n' "$green_out" >&2
    fail=1
  else
    echo "-- [bilinen-yeşil] pipefail + güvenli desenler (herestring, wc -l) → bulgu YOK"
  fi

  # 2) bilinen-kırmızı: ÜÇ tüketici türü, AYRI fixture — grep -q · head · grep -m1
  mkdir -p "$tmp/red"
  cat > "$tmp/red/grepq.sh" << 'EOF'
#!/usr/bin/env bash
set -uo pipefail
detector_alive() {
  printf '%s\n' "$(run report)" | grep -q "^ALIVE$"
}
EOF
  cat > "$tmp/red/headn.sh" << 'EOF'
#!/usr/bin/env bash
set -uo pipefail
LATEST="$(ls -t "$LOG_DIR"/*.log | head -1)"
EOF
  cat > "$tmp/red/grepm1.sh" << 'EOF'
#!/usr/bin/env bash
set -uo pipefail
FIRST="$(run report | grep -m1 "^HIT")"
EOF
  local red_out red_rc
  red_out="$(SIGPIPE_HYGIENE_SCAN_DIR="$tmp/red" GUARD_MODE=report bash "$DIR/$GUARD_NAME.sh" 2>&1)"
  red_rc=$?
  if [ "$red_rc" -ne 0 ]; then
    echo "!! self-test FAIL [bilinen-kırmızı]: report modunda exit 0 bekleniyordu (bulgu VAR ama block değil), $red_rc bulundu" >&2
    fail=1
  fi
  local ok=1
  grep -q "grepq.sh:4" <<< "$red_out" || ok=0
  grep -q "headn.sh:3" <<< "$red_out" || ok=0
  grep -q "grepm1.sh:3" <<< "$red_out" || ok=0
  if [ "$ok" -ne 1 ]; then
    echo "!! self-test FAIL [bilinen-kırmızı]: üç tüketici türünden en az biri dosya:satır ile ADLANDIRILMADI" >&2
    printf '%s\n' "$red_out" >&2
    fail=1
  else
    echo "-- [bilinen-kırmızı] üç tüketici türü (grep -q, head, grep -m1) → bulgu VAR, dosya:satır ile adlandırıldı"
  fi
  local red_block_rc
  SIGPIPE_HYGIENE_SCAN_DIR="$tmp/red" GUARD_MODE=block bash "$DIR/$GUARD_NAME.sh" > /dev/null 2>&1
  red_block_rc=$?
  if [ "$red_block_rc" -ne 1 ]; then
    echo "!! self-test FAIL [bilinen-kırmızı/block]: GUARD_MODE=block exit 1 bekleniyordu, $red_block_rc bulundu" >&2
    fail=1
  else
    echo "-- [bilinen-kırmızı/block] GUARD_MODE=block → exit 1 (doğru)"
  fi

  # 3) boş-evren: taranacak .sh dosyası YOK → exit 2 (ÖLÇEMEDİM)
  mkdir -p "$tmp/empty"
  local empty_rc
  SIGPIPE_HYGIENE_SCAN_DIR="$tmp/empty" GUARD_MODE=block bash "$DIR/$GUARD_NAME.sh" > /tmp/sigpipe_empty_out.$$ 2>&1
  empty_rc=$?
  if [ "$empty_rc" -ne 2 ]; then
    echo "!! self-test FAIL [boş-evren]: exit 2 (ÖLÇEMEDİM) bekleniyordu, $empty_rc bulundu — boş evren SESSİZCE YEŞİL kaldı" >&2
    fail=1
  else
    echo "-- [boş-evren] taranan dosya sayısı 0 → exit 2 (ÖLÇEMEDİM, sessiz yeşil DEĞİL)"
  fi
  rm -f /tmp/sigpipe_empty_out.$$

  # 4) baseline-aşıldı: baseline'da OLMAYAN yeni bir vaka → --ratchet exit 1
  mkdir -p "$tmp/ratchet_new"
  cp "$tmp/red/grepq.sh" "$tmp/ratchet_new/grepq.sh"
  : > "$tmp/ratchet_new_baseline.txt"
  local rnew_out rnew_rc
  rnew_out="$(SIGPIPE_HYGIENE_SCAN_DIR="$tmp/ratchet_new" SIGPIPE_HYGIENE_BASELINE="$tmp/ratchet_new_baseline.txt" bash "$DIR/$GUARD_NAME.sh" --ratchet 2>&1)"
  rnew_rc=$?
  if [ "$rnew_rc" -ne 1 ] || ! grep -q "BASELINE-AŞILDI" <<< "$rnew_out"; then
    echo "!! self-test FAIL [baseline-aşıldı]: exit 1 + 'BASELINE-AŞILDI' bekleniyordu, exit=$rnew_rc" >&2
    printf '%s\n' "$rnew_out" >&2
    fail=1
  else
    echo "-- [baseline-aşıldı] baseline'da olmayan yeni bulgu → --ratchet exit 1, BASELINE-AŞILDI ile adlandırıldı"
  fi

  # 5) baseline-düştü: baseline SAYISI bugünkünden BÜYÜK (düzeltilmiş) → improved, exit 0 (bloklamaz)
  mkdir -p "$tmp/ratchet_fixed"
  cat > "$tmp/ratchet_fixed/clean.sh" << 'EOF'
#!/usr/bin/env bash
set -uo pipefail
grep -q "pattern" <<< "$VAR"
EOF
  printf 'clean.sh 1\n' > "$tmp/ratchet_fixed_baseline.txt"
  local rfix_out rfix_rc
  rfix_out="$(cd "$tmp/ratchet_fixed" && SIGPIPE_HYGIENE_SCAN_DIR="$tmp/ratchet_fixed" SIGPIPE_HYGIENE_BASELINE="$tmp/ratchet_fixed_baseline.txt" bash "$DIR/$GUARD_NAME.sh" --ratchet 2>&1)"
  rfix_rc=$?
  if [ "$rfix_rc" -ne 0 ] || ! grep -q "improved: clean.sh 1 -> 0" <<< "$rfix_out"; then
    echo "!! self-test FAIL [baseline-düştü]: exit 0 + 'improved: clean.sh 1 -> 0' bekleniyordu, exit=$rfix_rc" >&2
    printf '%s\n' "$rfix_out" >&2
    fail=1
  else
    echo "-- [baseline-düştü] düzeltilmiş vaka → improved satırı, exit 0 (bloklamaz, KAPANMAMIŞ İŞ olarak işaretli)"
  fi

  if [ "$fail" -eq 0 ]; then
    echo "-- $GUARD_NAME self-test: 5 senaryo tutuyor (bilinen-yeşil, bilinen-kırmızı×3, boş-evren, baseline-aşıldı, baseline-düştü)"
    return 0
  fi
  echo "⛔ $GUARD_NAME self-test DÜŞTÜ"
  return 1
}

if [ "${1:-}" = "--self-test" ]; then
  self_test
  exit $?
fi

# ── ÜRETİM TARAMASI ──────────────────────────────────────────────────────
if [ ! -d "$SCAN_DIR" ]; then
  echo "!! [$GUARD_NAME] SETUP HATASI: taranacak dizin yok: $SCAN_DIR — ÖLÇÜM YAPILMADI" >&2
  exit 2
fi

FILE_COUNT="$(candidate_files "$SCAN_DIR" | grep -c . || true)"
if [ "$FILE_COUNT" -eq 0 ]; then
  echo "!! [$GUARD_NAME] SETUP HATASI: taranan .sh dosya sayısı 0 (kaynak: $SCAN_DIR) — evren boş, ÖLÇÜM YAPILMADI (sessiz yeşil DEĞİL)" >&2
  exit 2
fi
PIPEFAIL_COUNT="$(pipefail_file_count "$SCAN_DIR")"

FINDINGS="$(run_scan "$SCAN_DIR")"
FINDING_COUNT=0
if [ -n "$FINDINGS" ]; then
  FINDING_COUNT="$(printf '%s\n' "$FINDINGS" | grep -c . || true)"
fi

# ⛔ ÖZET SATIRI `[<guard>]` PREFİKSİ TAŞIYAMAZ (backend zincirinden taşınan
# ders, Z83: "kırmızı doğan kapı ölür"). `--` ile başlar.
echo "-- [$GUARD_NAME] taranan .sh: $FILE_COUNT · pipefail taşıyan: $PIPEFAIL_COUNT · bulgu: $FINDING_COUNT"
if [ "$FINDING_COUNT" -gt 0 ]; then
  printf '%s\n' "$FINDINGS"
fi

if [ "$FINDING_COUNT" -gt 0 ] && [ "$GUARD_MODE" = "block" ]; then
  exit 1
fi
exit 0
