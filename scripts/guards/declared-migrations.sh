#!/usr/bin/env bash
#
# Guard: declared-migrations (META) — `docs/process/BEYANLI_MIGRATION_RATCHET_BRIEF.md`
#
# NE YAPAR: `collmind.backend/src/database/migrations/*.ts`'te
# `export const REVERSIBILITY = …` / `export const EFFECT = …` ile beyan
# taşıyan HER dosyanın `.claude/backlog/MIGRATION_SEQUENCE.md`'nin
# "BEYANLI MİGRATION'LAR" bölümünde (işaretçiler arası) ADIYLA + DEĞERİYLE
# listeli olduğunu doğrular. Liste TEK KAYNAKTIR (`Z111 §16 §2`).
#
# NEDEN VAR: harness (`migration-verify.sh`) beyanlı bir migration'ı YEŞİL
# geçirir ama beyanı KİMİN NEDEN yazdığını ve beyanların ÇOĞALIP
# ÇOĞALMADIĞINI hiçbir kapı görmüyordu. Bu guard o kapı.
#
# İKİ OKUYUCU RİSKİ (brief `§2`): harness beyanı ts-node DİNAMİK import() ile
# okur (`read-declaration.ts`); bu guard'ın HIZLI yolu satır deseni
# (`^export const (REVERSIBILITY|EFFECT)…`). Aynı sözleşmeye iki mekanizma —
# biri görüp öbürü görmeyebilir (ör. `export { X as REVERSIBILITY }`, ÖLÇÜLDÜ
# bu turda: desen KAÇIRIYOR, ts-node GÖRÜYOR). ⇒ `REVERSIBILITY`/`EFFECT`
# kelimesi geçen HER dosya (desene takılsın takılmasın) read-declaration.ts
# ile AYRICA okunur; iki okuyucu ÇELİŞİRSE KIRMIZI.
#
# TANINAN ALAN ADLARI, DEĞERLER VE SEBEP ZORUNLULUĞU — ÜÇ AYRI KÜME ELLE
# YAZILMAZ, HEPSİ TÜRETİLİR (T-397 — eskiden SEBEP ZORUNLULUĞU kümesi ELLEYDİ,
# bu G5 ihlaliydi):
#   - alan adları (REVERSIBILITY/REVERSIBILITY_REASON/EFFECT/EFFECT_REASON)
#     `read-declaration.ts`'in KENDİ `mod.<ALAN>` referanslarından
#   - tanınan DEĞERLER (IRREVERSIBLE_ADD · NONE_BY_DESIGN · DATA_CONDITIONAL ·
#     DATA_VOLATILE_INSERT) `migration-verify.sh`'ın "tanınmıyor" REDDİNİ
#     yazan İKİ satırından (`[ -n "$DECL_X" ] && [ "$DECL_X" != "…" ]`
#     zinciri) — DOSYA İÇERİĞİNDEN, satır numarasından DEĞİL.
#   - SEBEP ZORUNLULUĞU (hangi DEĞER REASON alanını "sahiplenir") harness'ın
#     KENDİ "sahipsiz REASON" ÖLÇEMEDİM satırlarından (`"$DECL_..._REASON_
#     EXPORTED" -eq 1 ] && [ "$DECL_X" != "…"` zinciri) — bu, harness'ın
#     KENDİSİNİN kullandığı sahiplik kümesidir, guard'ın bir TAHMİNİ/KOPYASI
#     değil. Eskiden guard bunu `IRREVERSIBLE_ADD`/`NONE_BY_DESIGN`/
#     `DATA_VOLATILE_INSERT` diye ELLE yazıyordu — harness'a sebep isteyen
#     yeni bir değer eklendiğinde guard bunu SESSİZCE KAÇIRIRDI (kod tarafı
#     sebep istemez, liste tarafı isterdi — iki taraf ZIT davranırdı).
#   HER türetme TEK bir satırla eşleşmek ZORUNDADIR (`grep -c` ile SAYILIR,
#   `grep -m1` ile ilk eşleşen satır ALINMAZ) — 0 ya da >1 eşleşme
#   türetilemedi SAYILIR (DISIPLIN F12: harness'a aynı metni taşıyan bir
#   YORUM eklenirse ilk eşleşme yanlış satıra hizalanabilir).
#   Türetme başarısızsa (harness şekli değiştiyse ya da eşleşme sayısı ≠1
#   ise) guard KENDİ tanıma/sebep kümesini UYDURMAZ — ÖLÇEMEDİM (exit 2).
#
# T-397 DAR DÜZELTME (`Z111 §38`, 2026-09-14) — birleşme sonrası reviewer bir
# 🔴 iki 🟡 buldu, ÜÇÜ TEK TURDA:
#   🔴-2  LİSTE tarafındaki sebep kontrolü (aşağıda "liste tarafı") hâlâ
#         `!= "DATA_CONDITIONAL"` diye ELLE yazılıydı — yukarıdaki paragrafın
#         "HEPSİ TÜRETİLİR" iddiası KOD tarafı için doğruydu, LİSTE tarafı
#         için DEĞİLDİ. Artık liste tarafı da `reason_required_{rev,eff}_
#         values` kümesine (KOD tarafıyla AYNI türetilmiş küme) bakıyor.
#   🟡-1  anahtar-kelime ön filtresi (`keyword_pattern`) yalnız BİRİNCİL
#         export adlarından (REVERSIBILITY/EFFECT) kuruluyordu; `\b…\b` bir
#         `_REASON` eki taşıyan dosyada asla eşleşmez (`_` kelime karakteri).
#         Yalnız `EFFECT_REASON`/`REVERSIBILITY_REASON` export eden bir
#         dosya bu yüzden hiç OKUNMUYORDU (rc=0 "beyanlı yok" — harness aynı
#         dosyada ÖLÇEMEDİM derdi). Artık `keyword_pattern` TÜM alan adlarını
#         (REASON dahil) kapsıyor; `anchor_pattern` (iki-okuyucu çelişkisi
#         testi için) hâlâ yalnız BİRİNCİL adlardan.
#   🟡-2  `derive_unique_line` yalnız İLK fiziksel satırı okuyordu — harness
#         koşulu `\` ile bölünürse eşleşme SAYISI hâlâ 1 kalıyor (satırın
#         İLK parçası eşleşiyor) ama içerik EKSİK — hiçbir ÖLÇEMEDİM
#         tetiklenmeden küme SESSİZCE dar kalıyordu. Artık eşleşen satır
#         `validate_condition_line` ile biçim doğrulamasından geçiyor
#         (satır sonu `\` yok · `; then` ile bitiyor · `[ … ]` blok sayısı
#         `!=` sayısıyla tutarlı); aksi ÖLÇEMEDİM. Aynı doğrulama
#         `derive_recognized_*` fonksiyonlarında da geçerli — HEPSİ AYNI
#         `derive_unique_line` yardımcısından geçiyor.
#   🔵    harness dosyası OKUNAMAZSA (izin) sebep artık "0 ya da >1 eşleşme"
#         diye YANLIŞ adlanmıyor — `derive_unique_line` bunu ayrı bir rc ile
#         (2: okunamadı, 3: TEK eşleşti ama biçim geçersiz, 1: 0/>1 eşleşme)
#         işaretliyor ve çağıran taraf mesajı SEBEBİNE göre seçiyor.
#
# MODLAR:
#   declared-migrations.sh              --check (varsayılan) — run-all çağırır
#   declared-migrations.sh --report     bulguları + tür-başına SAYIYI bas, HER ZAMAN exit 0 (triyaj)
#   declared-migrations.sh --baseline   taze baseline'ı stdout'a bas (yazma İNCELENEBİLİR bir diff)
#   declared-migrations.sh --self-test  doğum şartı (Z83)
#
# RATCHET (`§9.2`, Z111 §27/§32/§33 KARAR (3)): İKİ AYRI gate var —
#   (a) LİSTE↔KOD EŞİTLİĞİ — aşağıdaki karşılaştırma, HER ZAMAN bağlayıcı.
#   (b) BEYANLI SAYI BASELINE'I — Z111 §33 KARAR (3) ile bir GÖRÜNÜRLÜK
#       notu olmaktan çıktı, bir KAPI oldu: ölçülen tür-başına sayı
#       baseline'dan ARTARSA, AZALIRSA (bayat baseline) ya da baseline'da
#       HİÇ olmayan YENİ bir tür belirirse `--check` KIRMIZI döner (exit 1).
#       (§9.2(b)'nin eski "görünürlük, bloklamaz" cümlesi bu kararla DÜŞTÜ —
#       DISIPLIN F04: bir ratchet'in gözlenen≠beklenen'i bilgi satırı olamaz.)
#       (§9.2(c) hâlâ REDDEDİLDİ: "beyansız sayı artamaz" kuralı YOK, beyan
#       bir istisna mekanizmasıdır — ratchet yalnız BEYANLI sayıdadır.)
# Baseline dosyası KENDİNİ YAZMAZ (`--baseline` ile üretilir, insan
# onayıyla AYRI, gözden geçirilebilir bir commit'te güncellenir).
#
# ÇIKIŞ KODLARI (--check):
#   0  liste↔kod eşit VE ölçülen==baseline (tür başına, baseline VARSA)
#   1  KIRMIZI — liste↔kod ihlali VE/VEYA ratchet ihlali (arttı/azaldı/yeni tür)
#   2  ÖLÇEMEDİM — setup/biçim/çelişki/türetme/okunamama hatası VEYA
#      baseline YOK / BOZUK (sayısal olmayan satır) / OKUNAMAZ (izin) —
#      tarama kolu ve baseline kolu AYNI önceliğe göre birleştirilir (rc,
#      baseline_rc: 2 > 1 > 0)
#      (ÖLÇEMEDİM, KIRMIZI'dan ÖNCELİKLİDİR: doğrulanamayan bir sonucu ne
#      YEŞİL ne KIRMIZI iddia etmek DISIPLIN'in "sessiz sıfır yasağı"nı ihlal eder)
#
# ⛔ sigpipe-hygiene kapısından geçer: `pipefail` + erken-kapanan tüketici
# (`grep -q` / `grep -m<N>` / `head`) boru SAĞINDA YOK. Bu dosyadaki `grep -m1`
# ve `grep -q`/`head` kullanımlarının HİÇBİRİ bir borunun SAĞINDA değildir —
# hepsi DOSYADAN doğrudan okur (üretici yok, SIGPIPE riski yok).
set -uo pipefail

GUARD_NAME="declared-migrations"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
META_ROOT="$(cd "$DIR/../.." && pwd)"
BACKEND_DIR="${DECLARED_MIGRATIONS_BACKEND_DIR:-$META_ROOT/collmind.backend}"
HARNESS_FILE="${DECLARED_MIGRATIONS_HARNESS_FILE:-$BACKEND_DIR/scripts/migration-verify.sh}"
READER_TS="${DECLARED_MIGRATIONS_READER_TS:-$BACKEND_DIR/scripts/verification/read-declaration.ts}"
TS_NODE_BIN="${DECLARED_MIGRATIONS_TS_NODE_BIN:-$BACKEND_DIR/node_modules/.bin/ts-node}"

SCAN_DIR="${DECLARED_MIGRATIONS_SCAN_DIR:-$BACKEND_DIR/src/database/migrations}"
LIST_FILE="${DECLARED_MIGRATIONS_LIST_FILE:-$META_ROOT/.claude/backlog/MIGRATION_SEQUENCE.md}"
BASELINE="${DECLARED_MIGRATIONS_BASELINE:-$DIR/declared-migrations-baseline.txt}"

BEGIN_MARK='<!-- declared-migrations:begin -->'
END_MARK='<!-- declared-migrations:end -->'

# ── TÜRETME — iki liste ELLE yazılmaz ───────────────────────────────────
derive_field_names() { # → stdout: alan adları, satır satır, sıralı-tekil · rc 1: türetilemedi
  [ -f "$READER_TS" ] || return 1
  local out
  out="$(grep -oE 'mod\.[A-Z_]+' "$READER_TS" | sed 's/^mod\.//' | sort -u)"
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

# T-397 🟡-2: eşleşen satırın TEK BAŞINA TAMAMLANMIŞ bir if/elif koşulu
# olduğunu sınar. Harness'taki koşul satırı `\` ile İKİ FİZİKSEL satıra
# bölünürse `grep -E` (satır-satır çalışır) yalnız İLK parçayı eşleştirir —
# eşleşme SAYISI hâlâ 1'dir ama İÇERİK EKSİKTİR (sonraki `!= "…"` koşulları
# ikinci fiziksel satırdadır ve SESSİZCE kaybolur). Bu fonksiyon olmadan
# derive_unique_line "tek eşleşme buldum" der ve küme sessizce dar kalırdı.
# Doğrulama: (a) satır `\` ile BİTMİYOR (devam karakteri yok) · (b) `; then`
# ile BİTİYOR (bu dosyadaki tüm hedef satırlar tek-satırlık if/elif'tir) ·
# (c) `[ … ]` blok sayısı `!=` belirteç sayısıyla TUTARLI (blok = != + 1;
# ilk blok her zaman `-n`/`-eq` gibi bir ön-koşuldur, `!=` taşımaz).
validate_condition_line() { # <satır>  → rc 0: biçim geçerli · rc 1: değil
  local line="$1" n_brackets n_ne
  case "$line" in
    *'\') return 1 ;;
  esac
  case "$line" in
    *'; then') ;;
    *) return 1 ;;
  esac
  n_brackets="$(grep -oE '\[ ' <<< "$line" | wc -l | tr -d ' ')"
  n_ne="$(grep -oE '!= ' <<< "$line" | wc -l | tr -d ' ')"
  case "$n_brackets" in ''|*[!0-9]*) return 1 ;; esac
  case "$n_ne" in ''|*[!0-9]*) return 1 ;; esac
  [ "$n_brackets" -eq $((n_ne + 1)) ] || return 1
  return 0
}

# T-397 (DISIPLIN F12): TEK satırla eşleşme ZORUNLULUĞU — `grep -c` ile
# SAYILIR, yalnız ilk eşleşen satır (`grep -m1`) ALINMAZ. 0 ya da >1 eşleşme
# → türetilemedi (harness'a aynı metni taşıyan bir yorum eklenirse `-m1`
# ilk eşleşmeyi alır ve bu çoğu zaman o yorumun KENDİSİDİR — yanlış satıra
# sessizce hizalanmak yerine burada ÖLÇEMEDİM'e düşer).
# rc AYRIMI (T-397 🔵): 2 = dosya yok/OKUNAMADI (izin) · 3 = TEK eşleşti ama
# BİÇİMİ geçersiz (T-397 🟡-2, bölünmüş satır olabilir) · 1 = 0 ya da >1
# eşleşme. Üç ayrı sebep ÜÇ ayrı rc — çağıran taraf "okunamadı"yı "0 ya da >1
# eşleşme" ile KARIŞTIRMASIN diye (reviewer 🔵).
derive_unique_line() { # <regex-desen> <dosya>  → stdout: eşleşen TEK satır
  local pattern="$1" file="$2" n line
  [ -f "$file" ] || return 2
  [ -r "$file" ] || return 2
  n="$(grep -cE "$pattern" "$file")"
  case "$n" in ''|*[!0-9]*) return 1 ;; esac
  [ "$n" -eq 1 ] || return 1
  line="$(grep -E "$pattern" "$file")"
  validate_condition_line "$line" || return 3
  printf '%s\n' "$line"
}

derive_recognized_reversibility() { # → stdout: tanınan REVERSIBILITY değerleri, satır satır · rc 1/2/3: derive_unique_line rc'si
  local line rc out
  line="$(derive_unique_line '\[ -n "\$DECL_REVERSIBILITY" \] && \[ "\$DECL_REVERSIBILITY" != "' "$HARNESS_FILE")"
  rc=$?
  [ "$rc" -eq 0 ] || return "$rc"
  out="$(printf '%s\n' "$line" | grep -oE '"\$DECL_REVERSIBILITY" != "[A-Z_]+"' | grep -oE '"[A-Z_]+"$' | tr -d '"')"
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

derive_recognized_effect() { # → stdout: tanınan EFFECT değerleri, satır satır · rc 1/2/3: derive_unique_line rc'si
  local line rc out
  line="$(derive_unique_line '\[ -n "\$DECL_EFFECT" \] && \[ "\$DECL_EFFECT" != "' "$HARNESS_FILE")"
  rc=$?
  [ "$rc" -eq 0 ] || return "$rc"
  out="$(printf '%s\n' "$line" | grep -oE '"\$DECL_EFFECT" != "[A-Z_]+"' | grep -oE '"[A-Z_]+"$' | tr -d '"')"
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

# T-397 kusuru — bu iki fonksiyon YENİ: hangi REVERSIBILITY/EFFECT DEĞERİNİN
# REASON alanını "sahiplendiği" (yani sebep gerektirdiği) artık ELLE
# yazılmıyor, harness'ın KENDİ "sahipsiz REASON" ÖLÇEMEDİM satırından
# (§9.11.2 S-1 / §9.12.1 B-2) türetiliyor.
derive_reason_required_reversibility() { # → stdout: REASON'ı SAHİPLENEN REVERSIBILITY değerleri, satır satır · rc 1/2/3: derive_unique_line rc'si
  local line rc out
  line="$(derive_unique_line '"\$DECL_REASON_EXPORTED" -eq 1 \] && ' "$HARNESS_FILE")"
  rc=$?
  [ "$rc" -eq 0 ] || return "$rc"
  out="$(printf '%s\n' "$line" | grep -oE '"\$DECL_REVERSIBILITY" != "[A-Z_]+"' | grep -oE '"[A-Z_]+"$' | tr -d '"' | sort -u)"
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

derive_reason_required_effect() { # → stdout: REASON'ı SAHİPLENEN EFFECT değerleri, satır satır · rc 1/2/3: derive_unique_line rc'si
  local line rc out
  line="$(derive_unique_line '"\$DECL_EFFECT_REASON_EXPORTED" -eq 1 \] && ' "$HARNESS_FILE")"
  rc=$?
  [ "$rc" -eq 0 ] || return "$rc"
  out="$(printf '%s\n' "$line" | grep -oE '"\$DECL_EFFECT" != "[A-Z_]+"' | grep -oE '"[A-Z_]+"$' | tr -d '"' | sort -u)"
  [ -n "$out" ] || return 1
  printf '%s\n' "$out"
}

value_in_set() { # <değer> <satır-satır küme (çok satırlı string)>  → rc 0: içinde, 1: değil
  local v="$1" set="$2" item
  while IFS= read -r item; do
    [ -z "$item" ] && continue
    [ "$v" = "$item" ] && return 0
  done <<< "$set"
  return 1
}

is_nonblank() { # <string>  → rc 0: en az bir boşluk-dışı karakter var
  case "$1" in
    '') return 1 ;;
    *[![:space:]]*) return 0 ;;
    *) return 1 ;;
  esac
}

json_field() { # <json-tek-satır> <alan adı>  → stdout: değer · rc 0: string, 1: null, 2: ayrıştırılamadı
  local json="$1" field="$2" m
  m="$(printf '%s' "$json" | grep -oE "\"$field\":(null|\"([^\"\\\\]|\\\\.)*\")")"
  if [ -z "$m" ]; then
    return 2
  fi
  m="${m#*:}"
  if [ "$m" = "null" ]; then
    return 1
  fi
  m="${m#\"}"; m="${m%\"}"
  m="${m//\\\"/\"}"
  m="${m//\\\\/\\}"
  printf '%s' "$m"
  return 0
}

candidate_migration_files() { # → stdout: <abs-yol>, satır satır, sıralı
  find "$SCAN_DIR" -maxdepth 1 -type f -name '*.ts' 2>/dev/null | sort
}

counts_by_type() { # <code.declared dosyası>  → "<EXPORT>=<DEĞER> <sayı>" satırları, sıralı
  awk -F'|' '{print $2}' "$1" 2>/dev/null | sort | uniq -c | awk '{printf "%s %s\n", $2, $1}' | sort
}

# ── ANA TARAMA — hem üretim hem self-test AYNI fonksiyondan geçer ───────
# (ADR 0007 E16 dersi: bir kontrolü sınayan test kendi kopyasını çalıştırmaz)
run_scan_and_compare() { # ← SCAN_DIR/LIST_FILE/HARNESS_FILE/READER_TS/TS_NODE_BIN globalleri okunur
  local WORKDIR
  WORKDIR="$(mktemp -d)"
  # shellcheck disable=SC2064
  trap "rm -rf '$WORKDIR'" RETURN

  : > "$WORKDIR/findings.red"
  : > "$WORKDIR/findings.unmeasured"
  : > "$WORKDIR/code.declared"
  : > "$WORKDIR/code.reasons"
  : > "$WORKDIR/list.declared"
  : > "$WORKDIR/list.keys"

  # -- türetme --------------------------------------------------------
  local field_names rev_values eff_values reason_required_rev_values reason_required_eff_values
  if ! field_names="$(derive_field_names)"; then
    echo "ÖLÇEMEDİM: beyan ALAN ADLARI türetilemedi — $READER_TS'ten 'mod.<ALAN>' deseni bulunamadı" >> "$WORKDIR/findings.unmeasured"
  fi
  # T-397 🔵: derive_*'nin rc'si (2: okunamadı · 3: tek eşleşti ama biçim
  # geçersiz [🟡-2] · 1: 0 ya da >1 eşleşme) SEBEBE göre AYRI mesaj üretir —
  # "okunamadı" ile "0 ya da >1 eşleşme" ARTIK KARIŞTIRILMIYOR.
  local _drc
  rev_values="$(derive_recognized_reversibility)"; _drc=$?
  if [ "$_drc" -ne 0 ]; then
    case "$_drc" in
      2) echo "ÖLÇEMEDİM: tanınan REVERSIBILITY DEĞERLERİ türetilemedi — $HARNESS_FILE OKUNAMADI (yok ya da izin)" >> "$WORKDIR/findings.unmeasured" ;;
      3) echo "ÖLÇEMEDİM: tanınan REVERSIBILITY DEĞERLERİ türetilemedi — $HARNESS_FILE'ta TEK satır eşleşti ama BİÇİMİ geçersiz (satır sonu '\\' ya da '; then' ile bitmiyor, ya da '[ … ]'/'!=' sayacı tutarsız — bölünmüş satır olabilir, T-397 🟡-2)" >> "$WORKDIR/findings.unmeasured" ;;
      *) echo "ÖLÇEMEDİM: tanınan REVERSIBILITY DEĞERLERİ türetilemedi — $HARNESS_FILE'ta beklenen 'tanınmıyor' reddi TEK satırla bulunamadı (0 ya da >1 eşleşme, T-397)" >> "$WORKDIR/findings.unmeasured" ;;
    esac
  fi
  eff_values="$(derive_recognized_effect)"; _drc=$?
  if [ "$_drc" -ne 0 ]; then
    case "$_drc" in
      2) echo "ÖLÇEMEDİM: tanınan EFFECT DEĞERLERİ türetilemedi — $HARNESS_FILE OKUNAMADI (yok ya da izin)" >> "$WORKDIR/findings.unmeasured" ;;
      3) echo "ÖLÇEMEDİM: tanınan EFFECT DEĞERLERİ türetilemedi — $HARNESS_FILE'ta TEK satır eşleşti ama BİÇİMİ geçersiz (satır sonu '\\' ya da '; then' ile bitmiyor, ya da '[ … ]'/'!=' sayacı tutarsız — bölünmüş satır olabilir, T-397 🟡-2)" >> "$WORKDIR/findings.unmeasured" ;;
      *) echo "ÖLÇEMEDİM: tanınan EFFECT DEĞERLERİ türetilemedi — $HARNESS_FILE'ta beklenen 'tanınmıyor' reddi TEK satırla bulunamadı (0 ya da >1 eşleşme, T-397)" >> "$WORKDIR/findings.unmeasured" ;;
    esac
  fi
  reason_required_rev_values="$(derive_reason_required_reversibility)"; _drc=$?
  if [ "$_drc" -ne 0 ]; then
    case "$_drc" in
      2) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (REVERSIBILITY) türetilemedi — $HARNESS_FILE OKUNAMADI (yok ya da izin)" >> "$WORKDIR/findings.unmeasured" ;;
      3) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (REVERSIBILITY) türetilemedi — $HARNESS_FILE'ta TEK satır eşleşti ama BİÇİMİ geçersiz (satır sonu '\\' ya da '; then' ile bitmiyor, ya da '[ … ]'/'!=' sayacı tutarsız — bölünmüş satır olabilir, T-397 🟡-2)" >> "$WORKDIR/findings.unmeasured" ;;
      *) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (REVERSIBILITY) türetilemedi — $HARNESS_FILE'ta beklenen 'sahipsiz REVERSIBILITY_REASON' satırı TEK eşleşmeyle bulunamadı (0 ya da >1, T-397)" >> "$WORKDIR/findings.unmeasured" ;;
    esac
  fi
  reason_required_eff_values="$(derive_reason_required_effect)"; _drc=$?
  if [ "$_drc" -ne 0 ]; then
    case "$_drc" in
      2) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (EFFECT) türetilemedi — $HARNESS_FILE OKUNAMADI (yok ya da izin)" >> "$WORKDIR/findings.unmeasured" ;;
      3) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (EFFECT) türetilemedi — $HARNESS_FILE'ta TEK satır eşleşti ama BİÇİMİ geçersiz (satır sonu '\\' ya da '; then' ile bitmiyor, ya da '[ … ]'/'!=' sayacı tutarsız — bölünmüş satır olabilir, T-397 🟡-2)" >> "$WORKDIR/findings.unmeasured" ;;
      *) echo "ÖLÇEMEDİM: SEBEP ZORUNLULUĞU (EFFECT) türetilemedi — $HARNESS_FILE'ta beklenen 'sahipsiz EFFECT_REASON' satırı TEK eşleşmeyle bulunamadı (0 ya da >1, T-397)" >> "$WORKDIR/findings.unmeasured" ;;
    esac
  fi
  if [ ! -x "$TS_NODE_BIN" ]; then
    echo "ÖLÇEMEDİM: ts-node binary çalıştırılabilir değil/yok: $TS_NODE_BIN" >> "$WORKDIR/findings.unmeasured"
  fi
  if [ ! -f "$READER_TS" ]; then
    echo "ÖLÇEMEDİM: read-declaration.ts yok: $READER_TS" >> "$WORKDIR/findings.unmeasured"
  fi

  local unmeasured_pre
  unmeasured_pre="$(grep -c . "$WORKDIR/findings.unmeasured")"
  if [ "$unmeasured_pre" -gt 0 ]; then
    cat "$WORKDIR/findings.unmeasured"
    # Y-2 (brief §10.2): `--baseline` bu fonksiyonu `> /dev/null` ile çağırır
    # — yukarıdaki `cat`'in stdout'u orada YUTULUR. Erken dönüş SEBEBİ
    # `$OUT_UNMEASURED_FILE`'a da yazılmazsa `--baseline`'ın "ÖLÇEMEDİM
    # madde(ler) var" mesajı SEBEPSİZ kalır (boş dosya basılır).
    cp "$WORKDIR/findings.unmeasured" "$OUT_UNMEASURED_FILE" 2>/dev/null || true
    return 2
  fi

  # -- evren + kod tarafı ----------------------------------------------
  if [ ! -d "$SCAN_DIR" ]; then
    echo "ÖLÇEMEDİM: taranacak dizin yok: $SCAN_DIR" >> "$WORKDIR/findings.unmeasured"
    cat "$WORKDIR/findings.unmeasured"
    cp "$WORKDIR/findings.unmeasured" "$OUT_UNMEASURED_FILE" 2>/dev/null || true
    return 2
  fi

  # B2 (brief §10.1): dizin VAR ama 0 `.ts` dosyası → ÖLÇEMEDİM, YEŞİL DEĞİL.
  # Bu sayım BİLEREK aşağıdaki `candidate_migration_files` (find) ile AYNI
  # aracı kullanmıyor — kendi ürettiği sayıyla kendini doğrulamak totolojik
  # olurdu (DISIPLIN: bir sayının doğrulaması BAŞKA bir araçla yapılır).
  # R-2 (brief §10.2): `-A` ZORUNLU — gizli (`.x.ts`) dosyalar `find -name
  # '*.ts'` tarafından GÖRÜLÜR (dot-glob kısıtı yok); `-A` olmadan bu sayım
  # onları KAÇIRIR ve find≠ls karşılaştırmasını (aşağıda, döngüden sonra)
  # YANLIŞ YERE tetikler.
  local independent_ts_count
  independent_ts_count="$(ls -1A "$SCAN_DIR" 2>/dev/null | grep -c '\.ts$')"
  if [ "$independent_ts_count" -eq 0 ]; then
    echo "ÖLÇEMEDİM: beyan evreni boş (0 .ts dosyası, ls ile bağımsız sayım) — $SCAN_DIR" >> "$WORKDIR/findings.unmeasured"
    cat "$WORKDIR/findings.unmeasured"
    cp "$WORKDIR/findings.unmeasured" "$OUT_UNMEASURED_FILE" 2>/dev/null || true
    return 2
  fi

  local primary_exports primary_alt all_alt anchor_pattern keyword_pattern
  primary_exports="$(printf '%s\n' "$field_names" | grep -vE '_REASON$')"
  if [ -z "$primary_exports" ]; then
    echo "ÖLÇEMEDİM: birincil EXPORT adları (REASON-dışı) türetilemedi — $field_names" >> "$WORKDIR/findings.unmeasured"
    cat "$WORKDIR/findings.unmeasured"
    cp "$WORKDIR/findings.unmeasured" "$OUT_UNMEASURED_FILE" 2>/dev/null || true
    return 2
  fi
  primary_alt="$(printf '%s\n' "$primary_exports" | tr '\n' '|' | sed 's/|$//')"
  # T-397 🟡-1: anchor_pattern (iki-okuyucu çelişkisi testi) yalnız BİRİNCİL
  # adlardan — bu, "desen bir birincil export'u GÖRÜYOR mu" sorusudur ve
  # değişmedi. keyword_pattern (dosyayı ts-node'a GÖNDERİP GÖNDERMEME kararı)
  # artık TÜM alan adlarından (`$field_names`, REASON dahil) kuruluyor —
  # eskiden yalnız `primary_alt`'tan kuruluyordu ve `\b…\b` `_` kelime
  # karakteri yüzünden `EFFECT_REASON`/`REVERSIBILITY_REASON`-YALNIZ bir
  # dosyada ASLA eşleşmiyordu (dosya hiç OKUNMUYORDU — rc=0 "yok").
  all_alt="$(printf '%s\n' "$field_names" | tr '\n' '|' | sed 's/|$//')"
  anchor_pattern="^export const (${primary_alt})[[:space:]]*(:.*)?="
  keyword_pattern="\\b(${all_alt})\\b"

  local scanned=0 f rel anchored keyword decl_json decl_rc
  local ts_rev ts_rev_rc ts_rev_reason ts_rev_reason_rc ts_eff ts_eff_rc ts_eff_reason ts_eff_reason_rc
  local ts_has_rev ts_has_eff
  while IFS= read -r f; do
    scanned=$((scanned + 1))
    rel="${f#"$SCAN_DIR"/}"

    anchored=0
    grep -qE "$anchor_pattern" "$f" && anchored=1
    keyword=0
    grep -qE "$keyword_pattern" "$f" && keyword=1
    [ "$keyword" -eq 0 ] && continue

    decl_json="$("$TS_NODE_BIN" "$READER_TS" "$f" 2>"$WORKDIR/ts.err" </dev/null)"
    decl_rc=$?
    if [ "$decl_rc" -ne 0 ]; then
      echo "ÖLÇEMEDİM: $rel — read-declaration.ts KOŞAMADI (rc=$decl_rc): $(cat "$WORKDIR/ts.err")" >> "$WORKDIR/findings.unmeasured"
      continue
    fi

    # (script `set -e` KULLANMIYOR — `-uo pipefail` yeterli; bu üç satırın
    # sıfır-olmayan çıkışı normal kontrol akışıdır, ekstra set +e/-e GEREKMEZ)
    ts_rev="$(json_field "$decl_json" REVERSIBILITY)"; ts_rev_rc=$?
    ts_rev_reason="$(json_field "$decl_json" REVERSIBILITY_REASON)"; ts_rev_reason_rc=$?
    ts_eff="$(json_field "$decl_json" EFFECT)"; ts_eff_rc=$?
    ts_eff_reason="$(json_field "$decl_json" EFFECT_REASON)"; ts_eff_reason_rc=$?

    if [ "$ts_rev_rc" -eq 2 ] || [ "$ts_eff_rc" -eq 2 ] || [ "$ts_rev_reason_rc" -eq 2 ] || [ "$ts_eff_reason_rc" -eq 2 ]; then
      echo "ÖLÇEMEDİM: $rel — read-declaration.ts çıktısı AYRIŞTIRILAMADI: $decl_json" >> "$WORKDIR/findings.unmeasured"
      continue
    fi

    ts_has_rev=0; [ "$ts_rev_rc" -eq 0 ] && ts_has_rev=1
    ts_has_eff=0; [ "$ts_eff_rc" -eq 0 ] && ts_has_eff=1

    if [ "$anchored" -eq 1 ] && [ "$ts_has_rev" -eq 0 ] && [ "$ts_has_eff" -eq 0 ]; then
      echo "KIRMIZI: $rel — İKİ OKUYUCU ÇELİŞKİSİ: desen 'export const REVERSIBILITY/EFFECT' eşleşti AMA read-declaration.ts hiçbir değer okumadı ($decl_json)" >> "$WORKDIR/findings.red"
    fi
    if [ "$anchored" -eq 0 ] && { [ "$ts_has_rev" -eq 1 ] || [ "$ts_has_eff" -eq 1 ]; }; then
      echo "KIRMIZI: $rel — İKİ OKUYUCU ÇELİŞKİSİ: desen EŞLEŞMEDİ ama read-declaration.ts bir beyan okudu ($decl_json) — hızlı desen bu yazımı GÖRMÜYOR" >> "$WORKDIR/findings.red"
    fi

    if [ "$ts_has_rev" -eq 1 ] && [ "$ts_has_eff" -eq 1 ]; then
      echo "ÖLÇEMEDİM: $rel — beyan ÇELİŞKİLİ: REVERSIBILITY VE EFFECT birlikte export edilmiş ($decl_json)" >> "$WORKDIR/findings.unmeasured"
      continue
    fi

    # T-397 AC3 — SAHİPSİZ REASON: harness'ın "sahipsiz REASON" ÖLÇEMEDİM'i
    # (§9.11.2 S-1 / §9.12.1 B-2) burada da uygulanır. `_reason_rc -eq 0`
    # yalnız REASON alanının STRING olarak export EDİLDİĞİNİ sınar (boş/dolu
    # FARK ETMEZ — harness'taki `_EXPORTED` bayrağının aynısı). Ana alanın
    # (REVERSIBILITY/EFFECT) hiç export edilmemiş olması da "sahipsiz" sayılır:
    # `value_in_set` boş/yok bir değeri hiçbir kümede bulamaz. Harness ile
    # AYNI SIRADA — ana alanların "tanınmıyor" filtresinden ÖNCE (harness'ta
    # da sahipsiz-REASON kontrolü, "tanınmıyor" if/elif zincirinden önce).
    if [ "$ts_rev_reason_rc" -eq 0 ] && ! value_in_set "$ts_rev" "$reason_required_rev_values"; then
      echo "ÖLÇEMEDİM: $rel — REVERSIBILITY_REASON export edilmiş (\"$ts_rev_reason\") ama REVERSIBILITY='$ts_rev' SEBEP GEREKTİREN kümede değil (harness'tan türetilen küme: $(printf '%s' "$reason_required_rev_values" | tr '\n' ' ')) — sebep SAHİPSİZ" >> "$WORKDIR/findings.unmeasured"
    fi
    if [ "$ts_eff_reason_rc" -eq 0 ] && ! value_in_set "$ts_eff" "$reason_required_eff_values"; then
      echo "ÖLÇEMEDİM: $rel — EFFECT_REASON export edilmiş (\"$ts_eff_reason\") ama EFFECT='$ts_eff' SEBEP GEREKTİREN kümede değil (harness'tan türetilen küme: $(printf '%s' "$reason_required_eff_values" | tr '\n' ' ')) — sebep SAHİPSİZ" >> "$WORKDIR/findings.unmeasured"
    fi

    if [ "$ts_has_rev" -eq 0 ] && [ "$ts_has_eff" -eq 0 ]; then
      continue
    fi

    if [ "$ts_has_rev" -eq 1 ]; then
      if ! value_in_set "$ts_rev" "$rev_values"; then
        echo "ÖLÇEMEDİM: $rel — tanınmayan REVERSIBILITY değeri: '$ts_rev' (tanınan: $(printf '%s' "$rev_values" | tr '\n' ' '))" >> "$WORKDIR/findings.unmeasured"
        continue
      fi
      # T-397: literal "= IRREVERSIBLE_ADD" YERİNE harness'tan türetilen
      # SEBEP GEREKTİREN kümeye üyelik sınanır — yeni bir değer harness'a
      # sebep isteyen olarak eklenirse bu satır OTOMATİK devreye girer.
      if value_in_set "$ts_rev" "$reason_required_rev_values" && ! is_nonblank "$ts_rev_reason"; then
        echo "KIRMIZI: $rel — REVERSIBILITY='$ts_rev' SEBEPSİZ (REVERSIBILITY_REASON boş/yalnız-boşluk, sebep gerektiren küme: $(printf '%s' "$reason_required_rev_values" | tr '\n' ' '))" >> "$WORKDIR/findings.red"
        continue
      fi
      echo "$rel|REVERSIBILITY=$ts_rev" >> "$WORKDIR/code.declared"
      echo "$rel|REVERSIBILITY_REASON=$ts_rev_reason" >> "$WORKDIR/code.reasons"
    fi

    if [ "$ts_has_eff" -eq 1 ]; then
      if ! value_in_set "$ts_eff" "$eff_values"; then
        echo "ÖLÇEMEDİM: $rel — tanınmayan EFFECT değeri: '$ts_eff' (tanınan: $(printf '%s' "$eff_values" | tr '\n' ' '))" >> "$WORKDIR/findings.unmeasured"
        continue
      fi
      # T-397: literal "= NONE_BY_DESIGN || = DATA_VOLATILE_INSERT" YERİNE
      # harness'tan türetilen SEBEP GEREKTİREN kümeye üyelik sınanır.
      if value_in_set "$ts_eff" "$reason_required_eff_values" && ! is_nonblank "$ts_eff_reason"; then
        echo "KIRMIZI: $rel — EFFECT='$ts_eff' SEBEPSİZ (EFFECT_REASON boş/yalnız-boşluk, sebep gerektiren küme: $(printf '%s' "$reason_required_eff_values" | tr '\n' ' '))" >> "$WORKDIR/findings.red"
        continue
      fi
      echo "$rel|EFFECT=$ts_eff" >> "$WORKDIR/code.declared"
      echo "$rel|EFFECT_REASON=$ts_eff_reason" >> "$WORKDIR/code.reasons"
    fi
  done < <(candidate_migration_files)

  # R-2 (brief §10.2): döngünün taradığı SAYI (`find -maxdepth 1 -type f
  # -name '*.ts'`) BAĞIMSIZ bir sayımla (`ls -1A` + `.ts` süzgeci, YUKARIDA
  # hesaplanan `independent_ts_count`) karşılaştırılır. Eşit değilse —
  # SCAN_DIR bir symlink olduğu için find'ın gördüğü evren daralmış/genişlemiş
  # olabilir, SCAN_DIR altında yalnız bir ALT DİZİN varsa (`foo.ts/` gibi) `ls`
  # onu `.ts` sanıp sayar ama `find -type f` saymaz, ya da beyanlı bir dosya
  # SYMLINK olduğu için `-type f` onu görmüyor olabilir — HİÇBİRİ sessizce
  # "taranan 0, rc=0" ÜRETMEMELİ (DISIPLIN: "bir toplamın azalması bir sınıfın
  # girmediğinin kanıtı değildir"). Uyuşmazlık ÖLÇEMEDİM'dir, YOK SAYILMAZ.
  if [ "$scanned" -ne "$independent_ts_count" ]; then
    echo "ÖLÇEMEDİM: sayım uyuşmazlığı (find=$scanned ls=$independent_ts_count) — $SCAN_DIR" >> "$WORKDIR/findings.unmeasured"
  fi

  # -- liste tarafı ------------------------------------------------------
  if [ ! -f "$LIST_FILE" ]; then
    echo "ÖLÇEMEDİM: liste dosyası yok: $LIST_FILE" >> "$WORKDIR/findings.unmeasured"
  elif [ ! -r "$LIST_FILE" ]; then
    # R-1 (brief §10.2): `-f` bir dosyanın VARLIĞINI doğrular, OKUNABİLİRLİĞİNİ
    # değil (chmod 000 → `-f` true, `-r` false). Bu ayrım olmadan aşağıdaki
    # `grep -cF` izin hatasıyla BOŞ çıktı üretir ve karşılaştırma sessizce
    # yanlış kola düşer.
    echo "ÖLÇEMEDİM: liste dosyası okunamadı (izin): $LIST_FILE" >> "$WORKDIR/findings.unmeasured"
  else
    local begin_count end_count
    begin_count="$(grep -cF "$BEGIN_MARK" "$LIST_FILE")"
    end_count="$(grep -cF "$END_MARK" "$LIST_FILE")"
    # R-1: `grep -c` çıktısı SAYISAL olarak doğrulanır — boş/sayısal-olmayan
    # bir değer aşağıdaki `-ne 1` karşılaştırmasına `[: integer expression
    # expected` ile sessizce sızabilir (reviewer 🔴-1'in kök nedeni).
    case "$begin_count" in ''|*[!0-9]*) begin_count="" ;; esac
    case "$end_count" in ''|*[!0-9]*) end_count="" ;; esac
    if [ -z "$begin_count" ] || [ -z "$end_count" ]; then
      echo "ÖLÇEMEDİM: liste işaretçi SAYIMI ayrıştırılamadı (grep -c beklenmedik çıktı verdi) — $LIST_FILE" >> "$WORKDIR/findings.unmeasured"
    elif [ "$begin_count" -ne 1 ] || [ "$end_count" -ne 1 ]; then
      echo "ÖLÇEMEDİM: liste işaretçileri EKSİK/BİRDEN FAZLA (begin=$begin_count end=$end_count) — $LIST_FILE" >> "$WORKDIR/findings.unmeasured"
    else
      local begin_line end_line
      begin_line="$(grep -nF "$BEGIN_MARK" "$LIST_FILE" | cut -d: -f1)"
      end_line="$(grep -nF "$END_MARK" "$LIST_FILE" | cut -d: -f1)"
      if [ "$begin_line" -ge "$end_line" ]; then
        echo "ÖLÇEMEDİM: liste işaretçileri TERS SIRADA (begin=$begin_line end=$end_line) — $LIST_FILE" >> "$WORKDIR/findings.unmeasured"
      else
        local body_start body_end
        body_start=$((begin_line + 1))
        body_end=$((end_line - 1))
        if [ "$body_end" -ge "$body_start" ]; then
          local content dosya rest export_pair sebep export_name value
          while IFS= read -r content; do
            [ -z "$content" ] && continue
            case "$content" in
              *'|'*'|'*) ;;
              *)
                echo "ÖLÇEMEDİM: liste satırı BİÇİM DIŞI ('|' ayracı eksik): '$content'" >> "$WORKDIR/findings.unmeasured"
                continue
                ;;
            esac
            dosya="${content%%|*}"
            rest="${content#*|}"
            export_pair="${rest%%|*}"
            sebep="${rest#*|}"
            export_name="${export_pair%%=*}"
            value="${export_pair#*=}"
            if [ "$export_name" != "REVERSIBILITY" ] && [ "$export_name" != "EFFECT" ]; then
              echo "ÖLÇEMEDİM: liste satırı TANINMAYAN EXPORT adı '$export_name': '$content'" >> "$WORKDIR/findings.unmeasured"
              continue
            fi
            # N1 (brief §10.1): aynı dosya|EXPORT ikilisi listede BİRDEN
            # FAZLA satırda geçerse sessizce üst üste binmesin (join'in kaç
            # eşleşme üreteceği belirsizleşir) — ÖLÇEMEDİM.
            echo "$dosya|$export_name" >> "$WORKDIR/list.keys"
            if [ "$export_name" = "REVERSIBILITY" ]; then
              if ! value_in_set "$value" "$rev_values"; then
                echo "ÖLÇEMEDİM: liste satırı tanınmayan REVERSIBILITY değeri '$value': '$content'" >> "$WORKDIR/findings.unmeasured"
                continue
              fi
            else
              if ! value_in_set "$value" "$eff_values"; then
                echo "ÖLÇEMEDİM: liste satırı tanınmayan EFFECT değeri '$value': '$content'" >> "$WORKDIR/findings.unmeasured"
                continue
              fi
            fi
            # T-397 🔴-2: eskiden `[ "$value" != "DATA_CONDITIONAL" ]` diye
            # ELLE yazılıydı — harness'a DATA_CONDITIONAL DIŞINDA sebep
            # İSTEMEYEN yeni bir değer eklenirse (kod tarafı doğru şekilde
            # sebep istemezken) liste tarafı SESSİZCE onu sebep-gerektiren
            # sanırdı (iki taraf ZIT davranırdı). Artık KOD tarafıyla AYNI
            # türetilmiş kümeye (`reason_required_rev_values` /
            # `reason_required_eff_values`) bakılıyor.
            local list_reason_required=1
            if [ "$export_name" = "REVERSIBILITY" ]; then
              value_in_set "$value" "$reason_required_rev_values" && list_reason_required=0
            else
              value_in_set "$value" "$reason_required_eff_values" && list_reason_required=0
            fi
            if [ "$list_reason_required" -eq 0 ]; then
              if [ "$sebep" = "-" ] || ! is_nonblank "$sebep"; then
                echo "KIRMIZI: liste satırı SEBEPSİZ ($export_name=$value): '$content'" >> "$WORKDIR/findings.red"
                continue
              fi
            fi
            echo "$dosya|$export_name=$value" >> "$WORKDIR/list.declared"
          done < <(sed -n "${body_start},${body_end}p" "$LIST_FILE")

          # N1 — yinelenen dosya|EXPORT satırı (sırası önemli değil: sort|uniq -d)
          if [ -s "$WORKDIR/list.keys" ]; then
            local dup_key
            while IFS= read -r dup_key; do
              [ -z "$dup_key" ] && continue
              echo "ÖLÇEMEDİM: yinelenen liste satırı (aynı dosya|EXPORT birden fazla kez): $dup_key" >> "$WORKDIR/findings.unmeasured"
            done < <(sort "$WORKDIR/list.keys" | uniq -d)
          fi
        fi
      fi
    fi
  fi

  # -- liste ↔ kod eşitliği ---------------------------------------------
  awk '{n=index($0,"="); if(n>0){print substr($0,1,n-1)" "substr($0,n+1)}}' "$WORKDIR/code.declared" | sort -k1,1 > "$WORKDIR/code.kv"
  awk '{n=index($0,"="); if(n>0){print substr($0,1,n-1)" "substr($0,n+1)}}' "$WORKDIR/list.declared" | sort -k1,1 > "$WORKDIR/list.kv"

  join -v1 -t' ' -1 1 -2 1 "$WORKDIR/code.kv" "$WORKDIR/list.kv" > "$WORKDIR/only_code.kv"
  join -v2 -t' ' -1 1 -2 1 "$WORKDIR/code.kv" "$WORKDIR/list.kv" > "$WORKDIR/only_list.kv"
  join -t' ' -1 1 -2 1 "$WORKDIR/code.kv" "$WORKDIR/list.kv" > "$WORKDIR/both.kv"

  local key val
  while IFS=' ' read -r key val; do
    [ -z "$key" ] && continue
    echo "KIRMIZI: beyanlı migration listede yok: ${key}=${val} — AYRI, GEREKÇELİ commit ile listeye ekle" >> "$WORKDIR/findings.red"
  done < "$WORKDIR/only_code.kv"

  while IFS=' ' read -r key val; do
    [ -z "$key" ] && continue
    echo "KIRMIZI: bayat liste: ${key}=${val} — beyan kaldırıldıysa listeden de çıkar" >> "$WORKDIR/findings.red"
  done < "$WORKDIR/only_list.kv"

  local val1 val2
  while IFS=' ' read -r key val1 val2; do
    [ -z "$key" ] && continue
    if [ "$val1" != "$val2" ]; then
      echo "KIRMIZI: liste ↔ kod değer uyuşmazlığı: $key — kod=$val1, liste=$val2" >> "$WORKDIR/findings.red"
    fi
  done < "$WORKDIR/both.kv"

  # -- sonuç ---------------------------------------------------------
  cp "$WORKDIR/findings.red" "$OUT_RED_FILE" 2>/dev/null || true
  cp "$WORKDIR/findings.unmeasured" "$OUT_UNMEASURED_FILE" 2>/dev/null || true
  cp "$WORKDIR/code.declared" "$OUT_CODE_DECLARED_FILE" 2>/dev/null || true
  echo "$scanned" > "$OUT_SCANNED_FILE" 2>/dev/null || true

  local red_n unmeasured_n
  red_n="$(grep -c . "$WORKDIR/findings.red")"
  unmeasured_n="$(grep -c . "$WORKDIR/findings.unmeasured")"
  if [ "$unmeasured_n" -gt 0 ]; then
    return 2
  elif [ "$red_n" -gt 0 ]; then
    return 1
  fi
  return 0
}

# scan+compare çıktıları için kalıcı (self-test tarafından da okunacak) dosyalar
OUT_RED_FILE=""
OUT_UNMEASURED_FILE=""
OUT_CODE_DECLARED_FILE=""
OUT_SCANNED_FILE=""

do_check_or_report() { # <mode: check|report>
  local mode="$1" out_dir
  out_dir="$(mktemp -d)"
  OUT_RED_FILE="$out_dir/red.txt"; : > "$OUT_RED_FILE"
  OUT_UNMEASURED_FILE="$out_dir/unmeasured.txt"; : > "$OUT_UNMEASURED_FILE"
  OUT_CODE_DECLARED_FILE="$out_dir/code.declared.txt"; : > "$OUT_CODE_DECLARED_FILE"
  OUT_SCANNED_FILE="$out_dir/scanned.txt"; echo 0 > "$OUT_SCANNED_FILE"

  run_scan_and_compare
  local rc=$?

  local scanned red_n unmeasured_n
  scanned="$(cat "$OUT_SCANNED_FILE")"
  red_n="$(grep -c . "$OUT_RED_FILE")"
  unmeasured_n="$(grep -c . "$OUT_UNMEASURED_FILE")"

  echo "-- [$GUARD_NAME] taranan .ts: $scanned"
  if [ "$unmeasured_n" -gt 0 ]; then
    echo "-- [$GUARD_NAME] ÖLÇEMEDİM ($unmeasured_n):"
    sed 's/^/   /' "$OUT_UNMEASURED_FILE"
  fi
  if [ "$red_n" -gt 0 ]; then
    echo "-- [$GUARD_NAME] KIRMIZI ($red_n):"
    sed 's/^/   /' "$OUT_RED_FILE"
  fi

  local declared_n
  declared_n="$(grep -c . "$OUT_CODE_DECLARED_FILE")"
  # N4 (brief §10.1/§10.2): ÖLÇEMEDİM yolunda "beyanlı migration: yok"
  # BASILMAZ — declared_n==0 hem "gerçekten yok" hem de "hiç tarayamadık"
  # anlamına gelebilir. ⛔ `unmeasured_n` (dosya sayımı) DEĞİL `rc` KULLANILIR:
  # `rc` erken-dönüş yollarının HEPSİNİ (SCAN_DIR yok, R-2 sayım uyuşmazlığı,
  # B2 boş evren, birincil export türetme hatası, liste/baseline okunamadı)
  # tek bir önceliğe indirger — `unmeasured_n` de artık Y-2 düzeltmesinden
  # sonra bu yollarda dolu geliyor, ama `rc` gene de TEK gerçek kaynaktır:
  # bir gelecekteki erken-dönüş `$OUT_UNMEASURED_FILE`'a yazmayı unutursa
  # `rc` yine de doğru kalır.
  if [ "$rc" -eq 2 ]; then
    : # ÖLÇEMEDİM — üstteki (varsa) ÖLÇEMEDİM satırı yeterli, "yok"/"beyanlı" satırı basılmaz
  elif [ "$declared_n" -eq 0 ]; then
    echo "-- [$GUARD_NAME] beyanlı migration: yok"
  else
    echo "-- [$GUARD_NAME] beyanlı migration ($declared_n), tür başına:"
    counts_by_type "$OUT_CODE_DECLARED_FILE" | sed 's/^/   /'
  fi
  if [ "$rc" -ne 2 ]; then
    echo "-- [$GUARD_NAME] beyansız migration sayısı: BİLGİ amaçlı, ratchet YOK (§9.2 (c) reddedildi — beyan bir istisna mekanizmasıdır) — beyanlı: $declared_n / taranan: $scanned"
  fi

  # -- baseline RATCHET (yalnız --check; KARAR Z111 §33 — bir KAPIDIR,
  #    §9.2(b)'nin "görünürlük, bloklamaz" cümlesinin ÜSTÜNE YAZAR) ------
  # Aynı sebeple `rc` kullanılır, `unmeasured_n` değil: erken-dönüş
  # ÖLÇEMEDİM'i baseline karşılaştırmasına HİÇ girmemeli (code.declared
  # o yollarda anlamlı/tam değil).
  local baseline_rc=0
  if [ "$mode" = "check" ] && [ "$rc" -ne 2 ]; then
    if [ ! -f "$BASELINE" ]; then
      # B4: baseline YOK → ÖLÇEMEDİM (money-float.sh :281 / sigpipe-hygiene.sh :221 emsali)
      echo "-- [$GUARD_NAME] ÖLÇEMEDİM: baseline yok ($BASELINE) — önce --baseline çalıştır"
      baseline_rc=2
    elif [ ! -r "$BASELINE" ]; then
      # R-1 (brief §10.2): `-f` VARLIĞI doğrular, OKUNABİLİRLİĞİ değil.
      # `-r` olmadan `done < "$BASELINE"` chmod 000'da SESSİZCE hiçbir satır
      # okumadan biter (redirection hatası stderr'e gider, döngü gövdesi hiç
      # çalışmaz) ve `baseline_rc` 0'da KALIR — sessiz YEŞİL.
      echo "-- [$GUARD_NAME] ÖLÇEMEDİM: baseline okunamadı (izin): $BASELINE"
      baseline_rc=2
    else
      local cur btype bcount ccount ctype
      cur="$(counts_by_type "$OUT_CODE_DECLARED_FILE")"
      while IFS=' ' read -r btype bcount; do
        case "$btype" in ''|\#*) continue ;; esac
        # B3: sayısal olmayan/biçim dışı baseline satırı → ÖLÇEMEDİM (SETUP
        # FAILURE), sessizce atlanmaz / bash'e "integer expression expected"
        # bırakılmaz (money-float.sh :306 / sigpipe-hygiene.sh :233 emsali).
        case "$bcount" in
          ''|*[!0-9]*)
            echo "-- [$GUARD_NAME] ÖLÇEMEDİM: baseline satırı bozuk (sayısal olmayan sayı): '$btype $bcount'"
            baseline_rc=2
            continue
            ;;
        esac
        ccount="$(printf '%s\n' "$cur" | awk -v t="$btype" '$1==t{print $2}')"
        ccount="${ccount:-0}"
        if [ "$ccount" -gt "$bcount" ]; then
          echo "-- [$GUARD_NAME] KIRMIZI: beyanlı migration sayısı ARTTI: $btype $bcount -> $ccount — liste satırı + baseline güncellemesi AYRI gerekçeli commit (--baseline)"
          [ "$baseline_rc" -lt 1 ] && baseline_rc=1
        elif [ "$ccount" -lt "$bcount" ]; then
          echo "-- [$GUARD_NAME] KIRMIZI: bayat baseline: $btype $bcount -> $ccount — beyan kaldırıldı; baseline'ı --baseline ile düşür, AYRI commit"
          [ "$baseline_rc" -lt 1 ] && baseline_rc=1
        fi
      done < "$BASELINE"
      while IFS=' ' read -r ctype ccount; do
        [ -n "$ctype" ] || continue
        if ! grep -qE "^${ctype} " "$BASELINE"; then
          echo "-- [$GUARD_NAME] KIRMIZI: YENİ tür beyan: $ctype $ccount (baseline'da yok — --baseline ile YENİDEN ÜRET)"
          [ "$baseline_rc" -lt 1 ] && baseline_rc=1
        fi
      done <<< "$cur"
    fi
  fi

  rm -rf "$out_dir"

  if [ "$mode" = "report" ]; then
    return 0
  fi
  # ÖLÇEMEDİM(2) > KIRMIZI(1) > YEŞİL(0) — hem tarama kolu (rc) hem baseline
  # kolu (baseline_rc) aynı önceliğe göre birleştirilir.
  if [ "$rc" -eq 2 ] || [ "$baseline_rc" -eq 2 ]; then
    return 2
  fi
  if [ "$rc" -eq 1 ] || [ "$baseline_rc" -eq 1 ]; then
    return 1
  fi
  return 0
}

# ── SELF-TEST ────────────────────────────────────────────────────────────
self_test() {
  local fail=0

  # 0) bilinen-yeşil: GERÇEK zincir + GERÇEK liste — salt-okunur, hiçbir
  #    dosya değişmez.
  #    S5 (brief §10.1, DISIPLIN F03): bu senaryo bugünkü İÇERİĞİ ("beyanlı
  #    migration: yok") ŞART KOŞMAZ — koşarsa ilk gerçek beyanlı migration
  #    doğduğunda (declared_n>0 ama liste↔kod hâlâ tutarlı) bu self-test'i,
  #    dolayısıyla run-all'u, YANLIŞ YERE kırmızıya döndürürdü. Şart koşulan
  #    şey HÜKÜMDÜR: rc==0 + "taranan .ts:" satırı basıldı + liste↔kod
  #    uyuşmazlığını gösteren hiçbir KIRMIZI ibare yok.
  local real_out real_rc
  real_out="$(bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  real_rc=$?
  if [ "$real_rc" -ne 0 ]; then
    echo "!! self-test FAIL [bilinen-yeşil/gerçek]: exit 0 bekleniyordu, $real_rc bulundu" >&2
    printf '%s\n' "$real_out" >&2
    fail=1
  elif ! grep -q "taranan \.ts: " <<< "$real_out"; then
    echo "!! self-test FAIL [bilinen-yeşil/gerçek]: 'taranan .ts:' satırı basılmadı" >&2
    printf '%s\n' "$real_out" >&2
    fail=1
  elif grep -qE "listede yok|bayat liste|değer uyuşmazlığı|SEBEPSİZ|ÇELİŞKİSİ" <<< "$real_out"; then
    echo "!! self-test FAIL [bilinen-yeşil/gerçek]: rc=0 ama liste↔kod uyuşmazlığı ibaresi bulundu" >&2
    printf '%s\n' "$real_out" >&2
    fail=1
  else
    echo "-- [bilinen-yeşil/gerçek] gerçek zincir + gerçek liste → exit 0, liste↔kod tutarlı (bugünkü İÇERİK sabitlenmedi — DISIPLIN F03)"
  fi

  local tmp
  tmp="$(mktemp -d)"

  # -- fixture yardımcıları ------------------------------------------------
  write_list() { # <dosya> <gövde-satırları...>
    local out="$1"; shift
    {
      echo "## BEYANLI MİGRATION'LAR (fixture)"
      echo "$BEGIN_MARK"
      for l in "$@"; do echo "$l"; done
      echo "$END_MARK"
    } > "$out"
  }

  # 1) KOL: kodda var, listede yok — hüküm: brief §3.1 "kodda VAR, listede YOK" → KIRMIZI
  mkdir -p "$tmp/s1/migrations"
  cat > "$tmp/s1/migrations/Sample1111111111001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'geri alınamaz — self-test fixture';
export class Sample1111111111001 {}
EOF
  write_list "$tmp/s1/list.md"
  local s1_out s1_rc
  s1_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s1/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s1/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s1_rc=$?
  if [ "$s1_rc" -ne 1 ] || ! grep -q "beyanlı migration listede yok" <<< "$s1_out"; then
    echo "!! self-test FAIL [kodda-var-listede-yok]: exit 1 + 'beyanlı migration listede yok' bekleniyordu, exit=$s1_rc" >&2
    printf '%s\n' "$s1_out" >&2
    fail=1
  else
    echo "-- [kodda-var-listede-yok] KIRMIZI, dosya adıyla adlandırıldı"
  fi

  # 2) KOL: listede var, kodda yok — hüküm: brief §3.1 "listede VAR, kodda YOK" → KIRMIZI "bayat liste"
  # B2 (brief §10.1): evren BOŞ olmasın diye beyansız (sıradan) bir .ts
  # eklendi — yoksa bu fixture artık "dizin var, 0 .ts" (B2) yoluna düşer.
  mkdir -p "$tmp/s2/migrations"
  cat > "$tmp/s2/migrations/PlainNoDeclaration2222.ts" << 'EOF'
export class PlainNoDeclaration2222 {}
EOF
  write_list "$tmp/s2/list.md" "GhostMigration2222222222.ts|REVERSIBILITY=IRREVERSIBLE_ADD|hayalet sebep"
  local s2_out s2_rc
  s2_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s2/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s2/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s2_rc=$?
  if [ "$s2_rc" -ne 1 ] || ! grep -q "bayat liste" <<< "$s2_out"; then
    echo "!! self-test FAIL [listede-var-kodda-yok]: exit 1 + 'bayat liste' bekleniyordu, exit=$s2_rc" >&2
    printf '%s\n' "$s2_out" >&2
    fail=1
  else
    echo "-- [listede-var-kodda-yok] KIRMIZI 'bayat liste', dosya adıyla adlandırıldı"
  fi

  # 3) KOL: değer uyuşmazlığı — hüküm: brief §3.1 "değer farklı" → KIRMIZI
  mkdir -p "$tmp/s3/migrations"
  cat > "$tmp/s3/migrations/Sample3333333333003.ts" << 'EOF'
export const EFFECT = 'NONE_BY_DESIGN';
export const EFFECT_REASON = 'assert-only — self-test fixture';
export class Sample3333333333003 {}
EOF
  write_list "$tmp/s3/list.md" "Sample3333333333003.ts|EFFECT=DATA_CONDITIONAL|-"
  local s3_out s3_rc
  s3_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s3/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s3/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s3_rc=$?
  if [ "$s3_rc" -ne 1 ] || ! grep -q "değer uyuşmazlığı" <<< "$s3_out"; then
    echo "!! self-test FAIL [değer-uyuşmazlığı]: exit 1 + 'değer uyuşmazlığı' bekleniyordu, exit=$s3_rc" >&2
    printf '%s\n' "$s3_out" >&2
    fail=1
  else
    echo "-- [değer-uyuşmazlığı] KIRMIZI, liste ↔ kod farkı adlandırıldı"
  fi

  # 4) KOL: sebepsiz (üç değer, AYRI fixture — sigpipe-hygiene emsali) — hüküm:
  # Z111 §19 B-2 ("beyan bir iddiadır, sebepsiz iddia yok") + §24 K1/K2
  mkdir -p "$tmp/s4/migrations"
  cat > "$tmp/s4/migrations/Sample4444444444001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = '   ';
export class Sample4444444444001 {}
EOF
  cat > "$tmp/s4/migrations/Sample4444444444002.ts" << 'EOF'
export const EFFECT = 'NONE_BY_DESIGN';
export class Sample4444444444002 {}
EOF
  cat > "$tmp/s4/migrations/Sample4444444444003.ts" << 'EOF'
export const EFFECT = 'DATA_VOLATILE_INSERT';
export const EFFECT_REASON = '';
export class Sample4444444444003 {}
EOF
  write_list "$tmp/s4/list.md"
  local s4_out s4_rc
  s4_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s4/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s4/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s4_rc=$?
  local s4_ok=1
  grep -q "Sample4444444444001.*SEBEPSİZ" <<< "$s4_out" || s4_ok=0
  grep -q "Sample4444444444002.*SEBEPSİZ" <<< "$s4_out" || s4_ok=0
  grep -q "Sample4444444444003.*SEBEPSİZ" <<< "$s4_out" || s4_ok=0
  if [ "$s4_rc" -ne 1 ] || [ "$s4_ok" -ne 1 ]; then
    echo "!! self-test FAIL [sebepsiz×3]: exit 1 + üç dosyanın da SEBEPSİZ ile adlandırılması bekleniyordu, exit=$s4_rc" >&2
    printf '%s\n' "$s4_out" >&2
    fail=1
  else
    echo "-- [sebepsiz×3] IRREVERSIBLE_ADD (yalnız-boşluk) · NONE_BY_DESIGN (export yok) · DATA_VOLATILE_INSERT (boş) → üçü de KIRMIZI"
  fi

  # 5) KOL: iki okuyucu çelişkisi — desen KAÇIRIR, ts-node GÖRÜR — hüküm: brief
  # §2 "İKİ OKUYUCU RİSKİ" (DISIPLIN F06: bir kanıt adı iki mekanizmada)
  mkdir -p "$tmp/s5/migrations"
  cat > "$tmp/s5/migrations/Sample5555555555001.ts" << 'EOF'
const _REV = 'IRREVERSIBLE_ADD';
const _REV_REASON = 'alt-yazım — self-test fixture';
export { _REV as REVERSIBILITY, _REV_REASON as REVERSIBILITY_REASON };
export class Sample5555555555001 {}
EOF
  write_list "$tmp/s5/list.md"
  local s5_out s5_rc
  s5_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s5/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s5/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s5_rc=$?
  if [ "$s5_rc" -ne 1 ] || ! grep -q "İKİ OKUYUCU ÇELİŞKİSİ" <<< "$s5_out"; then
    echo "!! self-test FAIL [iki-okuyucu-çelişkisi]: exit 1 + 'İKİ OKUYUCU ÇELİŞKİSİ' bekleniyordu, exit=$s5_rc" >&2
    printf '%s\n' "$s5_out" >&2
    fail=1
  else
    echo "-- [iki-okuyucu-çelişkisi] 'export { X as REVERSIBILITY }' — desen KAÇIRDI, ts-node GÖRDÜ → KIRMIZI"
  fi

  # 5a) ÖLÇEMEDİM: SAHİPSİZ REASON — T-397 AC3, harness §9.11.2 S-1 / §9.12.1
  # B-2'nin guard tarafı. İki alt-vaka: (i) tanınan ama SEBEP GEREKTİRMEYEN
  # bir EFFECT değeriyle REASON export edilmiş, (ii) ana alan (EFFECT) HİÇ
  # export edilmemişken REASON'ı yalnız başına export edilmiş — VE (T-397
  # reviewer 🟡-1 düzeltmesi) bu dosya BAŞKA HİÇBİR ana alan (REVERSIBILITY
  # DAHİL) TAŞIMAZ. Eskiden (ii) fixture'ı AYRICA REVERSIBILITY de taşıyordu
  # (§2.7 #6 "yanlış şekil"): `keyword_pattern` o zaman zaten REVERSIBILITY
  # literaliyle eşleşip dosyayı okutuyordu, yani bu senaryo 🟡-1'i (yalnız
  # `_REASON` taşıyan dosyanın hiç OKUNMAMASI) hiçbir zaman GERÇEKTEN
  # sınamıyordu — dolaylı olarak "geçiyordu".
  mkdir -p "$tmp/s5a/migrations"
  cat > "$tmp/s5a/migrations/Sample5a00000000001.ts" << 'EOF'
export const EFFECT = 'DATA_CONDITIONAL';
export const EFFECT_REASON = 'yanlış yapıştırılmış sebep — self-test fixture';
export class Sample5a00000000001 {}
EOF
  cat > "$tmp/s5a/migrations/Sample5a00000000002.ts" << 'EOF'
export const EFFECT_REASON = 'sahipsiz — ana alan yok, başka anahtar kelime yok';
export class Sample5a00000000002 {}
EOF
  write_list "$tmp/s5a/list.md"
  local s5a_out s5a_rc s5a_ok=1
  s5a_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s5a/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s5a/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s5a_rc=$?
  grep -q "Sample5a00000000001.*sebep SAHİPSİZ" <<< "$s5a_out" || s5a_ok=0
  grep -q "Sample5a00000000002.*sebep SAHİPSİZ" <<< "$s5a_out" || s5a_ok=0
  if [ "$s5a_rc" -ne 2 ] || [ "$s5a_ok" -ne 1 ]; then
    echo "!! self-test FAIL [sahipsiz-reason]: exit 2 + iki dosyanın da 'sebep SAHİPSİZ' ile adlandırılması bekleniyordu, exit=$s5a_rc" >&2
    printf '%s\n' "$s5a_out" >&2
    fail=1
  else
    echo "-- [sahipsiz-reason] DATA_CONDITIONAL+EFFECT_REASON · yalnız-REASON(ana alan HİÇ YOK, T-397 🟡-1) → ikisi de ÖLÇEMEDİM 'sebep SAHİPSİZ' (T-397 AC3)"
  fi

  # 5b) BİLİNEN-KIRMIZI: harness'a sebep isteyen YENİ bir değer eklendiğinde
  # (ör. EFFECT='DATA_NEW_KIND') kod tarafı bunu OTOMATİK sebep-gerektiren
  # sayar — eski (elle yazılmış) hâlde bu SESSİZCE yeşil kalırdı (T-397 kusuru).
  # Sentetik/izole bir harness FİXTURE'I kullanılır — gerçek
  # migration-verify.sh'a dokunulmaz (paralel T-395 şeridiyle çakışma YOK).
  mkdir -p "$tmp/s5b"
  cat > "$tmp/s5b/harness.sh" << 'HARNESSEOF'
#!/usr/bin/env bash
# T-397 self-test fixture — gerçek migration-verify.sh'ın İLGİLİ dört
# satırının İZOLE bir kopyası, + YENİ bir sebep-gerektiren değer (DATA_NEW_KIND).
if [ -n "$DECL_EFFECT" ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_CONDITIONAL" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ] && [ "$DECL_EFFECT" != "DATA_NEW_KIND" ]; then
  : # tanınmıyor
fi
if [ -n "$DECL_REVERSIBILITY" ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # tanınmıyor
fi
if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ] && [ "$DECL_EFFECT" != "DATA_NEW_KIND" ]; then
  : # sahipsiz EFFECT_REASON
fi
if [ "$DECL_REASON_EXPORTED" -eq 1 ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # sahipsiz REVERSIBILITY_REASON
fi
HARNESSEOF
  mkdir -p "$tmp/s5b/migrations"
  cat > "$tmp/s5b/migrations/Sample5b00000000001.ts" << 'EOF'
export const EFFECT = 'DATA_NEW_KIND';
export class Sample5b00000000001 {}
EOF
  write_list "$tmp/s5b/list.md"
  local s5b_out s5b_rc
  s5b_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s5b/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s5b/list.md" DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/s5b/harness.sh" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s5b_rc=$?
  if [ "$s5b_rc" -ne 1 ] || ! grep -q "EFFECT='DATA_NEW_KIND' SEBEPSİZ" <<< "$s5b_out"; then
    echo "!! self-test FAIL [bilinen-kirmizi/yeni-sebep-degeri]: exit 1 + 'DATA_NEW_KIND' SEBEPSİZ bekleniyordu, exit=$s5b_rc" >&2
    printf '%s\n' "$s5b_out" >&2
    fail=1
  else
    echo "-- [bilinen-kirmizi/yeni-sebep-degeri] harness'a sebep isteyen YENİ değer (DATA_NEW_KIND) eklendi → kod tarafı OTOMATİK KIRMIZI verdi (eski elle-liste sessiz yeşil verirdi, T-397)"
  fi

  # 5c) türetme eşleşmesi 2 — harness'a AYNI metni taşıyan bir YORUM
  # eklenirse (DISIPLIN F12) türetme ÖLÇEMEDİM olur, YANLIŞ satıra hizalanmaz.
  mkdir -p "$tmp/s5c"
  cat > "$tmp/s5c/harness.sh" << 'HARNESSEOF'
#!/usr/bin/env bash
# Yorum: bir önceki turda BUNU yazmıştık — if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
if [ -n "$DECL_EFFECT" ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_CONDITIONAL" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # tanınmıyor
fi
if [ -n "$DECL_REVERSIBILITY" ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # tanınmıyor
fi
if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # sahipsiz EFFECT_REASON — GERÇEK satır
fi
if [ "$DECL_REASON_EXPORTED" -eq 1 ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # sahipsiz REVERSIBILITY_REASON
fi
HARNESSEOF
  mkdir -p "$tmp/s5c/migrations"
  cat > "$tmp/s5c/migrations/Sample5c00000000001.ts" << 'EOF'
export const EFFECT = 'NONE_BY_DESIGN';
export const EFFECT_REASON = 'assert-only — self-test fixture';
export class Sample5c00000000001 {}
EOF
  write_list "$tmp/s5c/list.md"
  local s5c_out s5c_rc
  s5c_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s5c/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s5c/list.md" DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/s5c/harness.sh" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s5c_rc=$?
  if [ "$s5c_rc" -ne 2 ] || ! grep -q "SEBEP ZORUNLULUĞU (EFFECT) türetilemedi" <<< "$s5c_out"; then
    echo "!! self-test FAIL [turetme-eslesme-2]: exit 2 + 'SEBEP ZORUNLULUĞU (EFFECT) türetilemedi' bekleniyordu, exit=$s5c_rc" >&2
    printf '%s\n' "$s5c_out" >&2
    fail=1
  else
    echo "-- [turetme-eslesme-2] harness'ta aynı metni taşıyan bir YORUM eklendi → eşleşme sayısı 2, türetilemedi → ÖLÇEMEDİM (DISIPLIN F12, ilk eşleşmeye SESSİZCE hizalanmadı)"
  fi

  # K-a) BİLİNEN-KIRMIZI → DÜZELDİ: T-397 🔴-2 (Z111 §38). Harness'a
  # DATA_CONDITIONAL DIŞINDA sebep-İSTEMEYEN yeni bir EFFECT değeri
  # (DATA_FREE_KIND) eklenir. Eski (ELLE `!= "DATA_CONDITIONAL"`) liste
  # kontrolü bu değeri SESSİZCE sebep-gerektiren SANIRDI (liste satırı sebep
  # "-" olunca KIRMIZI verirdi) — kod tarafı aynı değeri doğru şekilde
  # sebep-gerektirmez sayıyordu, iki taraf ZIT davranırdı. Artık liste tarafı
  # da KOD tarafıyla AYNI türetilmiş kümeye bakıyor → exit 0.
  mkdir -p "$tmp/ska"
  cat > "$tmp/ska/harness.sh" << 'HARNESSEOF'
#!/usr/bin/env bash
# T-397 K-a fixture — DATA_FREE_KIND: DATA_CONDITIONAL gibi SEBEP İSTEMEYEN
# YENİ bir EFFECT değeri (eski elle-yazılmış liste kontrolü bunu SESSİZCE
# sebep-gerektiren SANIRDI).
if [ -n "$DECL_EFFECT" ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_CONDITIONAL" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ] && [ "$DECL_EFFECT" != "DATA_FREE_KIND" ]; then
  : # tanınmıyor
fi
if [ -n "$DECL_REVERSIBILITY" ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # tanınmıyor
fi
if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # sahipsiz EFFECT_REASON — DATA_CONDITIONAL VE DATA_FREE_KIND SEBEP İSTEMEZ
fi
if [ "$DECL_REASON_EXPORTED" -eq 1 ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # sahipsiz REVERSIBILITY_REASON
fi
HARNESSEOF
  mkdir -p "$tmp/ska/migrations"
  cat > "$tmp/ska/migrations/SampleKa0000000001.ts" << 'EOF'
export const EFFECT = 'DATA_FREE_KIND';
export class SampleKa0000000001 {}
EOF
  write_list "$tmp/ska/list.md" "SampleKa0000000001.ts|EFFECT=DATA_FREE_KIND|-"
  # baseline İZOLE edilir (s9 emsali) — yoksa GERÇEK repo baseline'ı
  # kullanılır ve "YENİ tür beyan" (KARAR 3) bu senaryoyu KIRMIZIYA çevirir;
  # bu test yalnız LİSTE tarafının SEBEP kuralını sınamalı.
  printf '%s\n' "EFFECT=DATA_FREE_KIND 1" > "$tmp/ska/baseline.txt"
  local ska_out ska_rc
  ska_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/ska/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/ska/list.md" DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/ska/harness.sh" DECLARED_MIGRATIONS_BASELINE="$tmp/ska/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  ska_rc=$?
  if [ "$ska_rc" -ne 0 ] || grep -qE "SEBEPSİZ|listede yok|bayat liste" <<< "$ska_out"; then
    echo "!! self-test FAIL [K-a/liste-sebep-turetilir]: exit 0 (SEBEPSİZ/uyuşmazlık İBARESİ YOK) bekleniyordu, exit=$ska_rc" >&2
    printf '%s\n' "$ska_out" >&2
    fail=1
  else
    echo "-- [K-a/liste-sebep-turetilir] DATA_FREE_KIND (sebep İSTEMEYEN yeni değer), liste sebebi '-' → exit 0 (eski ELLE '!= DATA_CONDITIONAL' kontrolü KIRMIZI verirdi, T-397 🔴-2)"
  fi

  # K-c) T-397 🟡-2: harness'taki sahipsiz-REASON (EFFECT) koşulu `\` ile İKİ
  # FİZİKSEL satıra BÖLÜNMÜŞ — derive_unique_line eski hâlde yalnız İLK
  # parçayı görür, eşleşme SAYISI 1 kalır (SESSİZCE), küme EKSİK olur ama
  # HİÇBİR ÖLÇEMEDİM tetiklenmez. validate_condition_line artık satırın TEK
  # BAŞINA TAMAMLANMIŞ olduğunu (satır sonu `\` YOK, `; then` ile bitiyor)
  # sınıyor → ÖLÇEMEDİM.
  mkdir -p "$tmp/skc"
  cat > "$tmp/skc/harness.sh" << 'HARNESSEOF'
#!/usr/bin/env bash
if [ -n "$DECL_EFFECT" ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_CONDITIONAL" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # tanınmıyor
fi
if [ -n "$DECL_REVERSIBILITY" ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # tanınmıyor
fi
if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && \
   [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # sahipsiz EFFECT_REASON — T-397 🟡-2 fixture: KOŞUL BÖLÜNMÜŞ (\)
fi
if [ "$DECL_REASON_EXPORTED" -eq 1 ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # sahipsiz REVERSIBILITY_REASON
fi
HARNESSEOF
  mkdir -p "$tmp/skc/migrations"
  cat > "$tmp/skc/migrations/PlainNoDeclarationKc01.ts" << 'EOF'
export class PlainNoDeclarationKc01 {}
EOF
  write_list "$tmp/skc/list.md"
  local skc_out skc_rc
  skc_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/skc/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/skc/list.md" DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/skc/harness.sh" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  skc_rc=$?
  if [ "$skc_rc" -ne 2 ] || ! grep -q "SEBEP ZORUNLULUĞU (EFFECT) türetilemedi" <<< "$skc_out" || ! grep -q "bölünmüş satır olabilir" <<< "$skc_out"; then
    echo "!! self-test FAIL [K-c/bolunmus-satir]: exit 2 + bölünmüş-satır teşhisi bekleniyordu, exit=$skc_rc" >&2
    printf '%s\n' "$skc_out" >&2
    fail=1
  else
    echo "-- [K-c/bolunmus-satir] harness'taki sahipsiz-REASON koşulu '\\' ile BÖLÜNDÜ → derive_unique_line/validate_condition_line ÖLÇEMEDİM (T-397 🟡-2, sessiz eksik küme YOK)"
  fi

  # K-d) T-397 🔵: harness dosyası OKUNAMAZ (chmod 000). Eski hâlde bu sebep
  # "0 ya da >1 eşleşme" diye YANLIŞ adlanıyordu (reviewer ÖLÇTÜ) — artık
  # derive_unique_line ayrı bir rc (2) ile "OKUNAMADI" der.
  mkdir -p "$tmp/skd/migrations"
  cat > "$tmp/skd/migrations/PlainNoDeclarationKd01.ts" << 'EOF'
export class PlainNoDeclarationKd01 {}
EOF
  write_list "$tmp/skd/list.md"
  cat > "$tmp/skd/harness.sh" << 'HARNESSEOF'
#!/usr/bin/env bash
if [ -n "$DECL_EFFECT" ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_CONDITIONAL" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # tanınmıyor
fi
if [ -n "$DECL_REVERSIBILITY" ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # tanınmıyor
fi
if [ "$DECL_EFFECT_REASON_EXPORTED" -eq 1 ] && [ "$DECL_EFFECT" != "NONE_BY_DESIGN" ] && [ "$DECL_EFFECT" != "DATA_VOLATILE_INSERT" ]; then
  : # sahipsiz EFFECT_REASON
fi
if [ "$DECL_REASON_EXPORTED" -eq 1 ] && [ "$DECL_REVERSIBILITY" != "IRREVERSIBLE_ADD" ]; then
  : # sahipsiz REVERSIBILITY_REASON
fi
HARNESSEOF
  chmod 000 "$tmp/skd/harness.sh"
  local skd_out skd_rc
  skd_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/skd/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/skd/list.md" DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/skd/harness.sh" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  skd_rc=$?
  chmod 644 "$tmp/skd/harness.sh"
  if [ "$skd_rc" -ne 2 ] || ! grep -q "OKUNAMADI" <<< "$skd_out" || grep -q "0 ya da >1 eşleşme" <<< "$skd_out"; then
    echo "!! self-test FAIL [K-d/harness-okunamaz]: exit 2 + 'OKUNAMADI' ('0 ya da >1 eşleşme' İLE KARIŞTIRILMAMIŞ) bekleniyordu, exit=$skd_rc" >&2
    printf '%s\n' "$skd_out" >&2
    fail=1
  else
    echo "-- [K-d/harness-okunamaz] harness chmod 000 → sebep 'OKUNAMADI' olarak adlandırıldı, '0 ya da >1 eşleşme' İLE KARIŞTIRILMADI (T-397 🔵)"
  fi

  # 6) ÖLÇEMEDİM: dizin yok (Y-3/reviewer 🟡-3: eski ad "boş-evren" sınadığı
  # şeyle uyuşmuyordu — SCAN_DIR hiç YOK, "boş" değil; 0-.ts durumu 6b'de.
  # Hüküm: brief §3.1 "işaretçi yok / … / evren boş (migrations dizini yok
  # ya da 0 .ts)" → ÖLÇEMEDİM.
  mkdir -p "$tmp/s6/migrations_empty"
  write_list "$tmp/s6/list.md"
  local s6_rc
  DECLARED_MIGRATIONS_SCAN_DIR="$tmp/nonexistent-dir-$$" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s6/list.md" bash "$DIR/$GUARD_NAME.sh" --check > /dev/null 2>&1 </dev/null
  s6_rc=$?
  if [ "$s6_rc" -ne 2 ]; then
    echo "!! self-test FAIL [dizin-yok]: exit 2 bekleniyordu (dizin yok), $s6_rc bulundu" >&2
    fail=1
  else
    echo "-- [dizin-yok] taranacak dizin yok → exit 2 (ÖLÇEMEDİM, sessiz yeşil DEĞİL) — §3.1"
  fi

  # 6b) ÖLÇEMEDİM (B2, brief §10.1): dizin VAR ama 0 .ts — boş liste ile
  # birleşince eskiden liste↔kod eşitliği "boş==boş" diyip YEŞİL dönerdi.
  # brief §3.1 bunu ÖLÇEMEDİM ilan ediyor: evrenin gerçekten taranıp
  # taranmadığı bilinmiyor.
  mkdir -p "$tmp/s6b/migrations_zero_ts"
  : > "$tmp/s6b/migrations_zero_ts/.gitkeep"
  write_list "$tmp/s6b/list.md"
  local s6b_out s6b_rc
  s6b_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s6b/migrations_zero_ts" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s6b/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s6b_rc=$?
  if [ "$s6b_rc" -ne 2 ] || ! grep -q "beyan evreni boş" <<< "$s6b_out"; then
    echo "!! self-test FAIL [B2/boş-evren-0-ts]: exit 2 + 'beyan evreni boş' bekleniyordu, exit=$s6b_rc" >&2
    printf '%s\n' "$s6b_out" >&2
    fail=1
  else
    echo "-- [B2/boş-evren-0-ts] dizin var, 0 .ts, liste de boş → exit 2 (ÖLÇEMEDİM, 'boş==boş → YEŞİL' DEĞİL)"
  fi

  # 7) ÖLÇEMEDİM: işaretçi eksik / birden fazla / ters sıra / biçim dışı satır —
  # hüküm: brief §3.1 "işaretçi yok / birden fazla / sırası ters · liste satırı
  # biçim dışı" → ÖLÇEMEDİM
  # B2 (brief §10.1): evren BOŞ olmasın diye beyansız bir .ts eklendi — yoksa
  # bu fixture "dizin var, 0 .ts" (B2) yoluna düşer ve işaretçi/biçim
  # bulgusunu HİÇ ÖLÇMEDEN erken exit 2 verir (doğru rc, YANLIŞ sebep).
  mkdir -p "$tmp/s7/migrations"
  cat > "$tmp/s7/migrations/PlainNoDeclaration7777.ts" << 'EOF'
export class PlainNoDeclaration7777 {}
EOF
  echo "işaretçisiz dosya" > "$tmp/s7/list_no_markers.md"
  local s7a_rc
  DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s7/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s7/list_no_markers.md" bash "$DIR/$GUARD_NAME.sh" --check > /dev/null 2>&1 </dev/null
  s7a_rc=$?
  {
    echo "$BEGIN_MARK"
    echo "biçim dışı satır (ayraç yok)"
    echo "$END_MARK"
  } > "$tmp/s7/list_bad_format.md"
  local s7b_out s7b_rc
  s7b_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s7/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s7/list_bad_format.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s7b_rc=$?
  if [ "$s7a_rc" -ne 2 ] || [ "$s7b_rc" -ne 2 ] || ! grep -q "BİÇİM DIŞI" <<< "$s7b_out"; then
    echo "!! self-test FAIL [işaretçi/biçim]: exit 2 bekleniyordu (işaretçisiz=$s7a_rc, biçim-dışı=$s7b_rc)" >&2
    printf '%s\n' "$s7b_out" >&2
    fail=1
  else
    echo "-- [işaretçi/biçim] işaretçisiz dosya · biçim dışı liste satırı → ikisi de exit 2 (ÖLÇEMEDİM)"
  fi

  # 8) ÖLÇEMEDİM: tanınmayan değer + REVERSIBILITY ∧ EFFECT birlikte — hüküm:
  # §9.1 "tanınmayan değer = harness'ta ÖLÇEMEDİM — guard da ÖLÇEMEDİM" ·
  # "REVERSIBILITY ∧ EFFECT birlikte = … beyan çelişkili"
  mkdir -p "$tmp/s8/migrations"
  cat > "$tmp/s8/migrations/Sample8888888888001.ts" << 'EOF'
export const EFFECT = 'BOZUK_DEGER';
export class Sample8888888888001 {}
EOF
  cat > "$tmp/s8/migrations/Sample8888888888002.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'çelişkili fixture';
export const EFFECT = 'NONE_BY_DESIGN';
export const EFFECT_REASON = 'çelişkili fixture';
export class Sample8888888888002 {}
EOF
  write_list "$tmp/s8/list.md"
  local s8_out s8_rc
  s8_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s8/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s8/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s8_rc=$?
  local s8_ok=1
  grep -q "tanınmayan EFFECT değeri" <<< "$s8_out" || s8_ok=0
  grep -q "beyan ÇELİŞKİLİ" <<< "$s8_out" || s8_ok=0
  if [ "$s8_rc" -ne 2 ] || [ "$s8_ok" -ne 1 ]; then
    echo "!! self-test FAIL [tanınmayan-değer+çelişkili-beyan]: exit 2 bekleniyordu, exit=$s8_rc" >&2
    printf '%s\n' "$s8_out" >&2
    fail=1
  else
    echo "-- [tanınmayan-değer+çelişkili-beyan] BOZUK_DEGER · REVERSIBILITY∧EFFECT birlikte → ikisi de ÖLÇEMEDİM"
  fi

  # 9) YEŞİL: DATA_CONDITIONAL, sebep alanı "-" — hüküm: §9.1 tablosu
  # "EFFECT=DATA_CONDITIONAL … sebep alanı YOK — stdout MIGRATION_AFFECTED_ROWS"
  mkdir -p "$tmp/s9/migrations"
  cat > "$tmp/s9/migrations/Sample9999999999001.ts" << 'EOF'
export const EFFECT = 'DATA_CONDITIONAL';
export class Sample9999999999001 {}
EOF
  write_list "$tmp/s9/list.md" "Sample9999999999001.ts|EFFECT=DATA_CONDITIONAL|-"
  # baseline İZOLE edilir ve tam da bu senaryonun ürettiği sayıyla eşit
  # yazılır — yoksa (env verilmezse) varsayılan GERÇEK repo baseline'ı
  # kullanılır ve "YENİ tür beyan" (KARAR 3) bu YEŞİL senaryoyu KIRMIZIYA
  # çevirir; bu test yalnız TARAMA tarafını (sebep alanı kuralı) sınamalı.
  printf '%s\n' "EFFECT=DATA_CONDITIONAL 1" > "$tmp/s9/baseline.txt"
  local s9_out s9_rc
  s9_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s9/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s9/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s9/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  s9_rc=$?
  if [ "$s9_rc" -ne 0 ]; then
    echo "!! self-test FAIL [data-conditional-yeşil]: exit 0 bekleniyordu, $s9_rc bulundu" >&2
    printf '%s\n' "$s9_out" >&2
    fail=1
  else
    echo "-- [data-conditional-yeşil] EFFECT=DATA_CONDITIONAL, liste sebebi '-' → sebep alanı YOK kuralı, exit 0"
  fi

  # 10) baseline — ilk koşum sayıyı yazar, --check KENDİSİ YAZMAZ
  #     B4 (brief §10.1, Z111 §33 KARAR (3)): baseline YOK iken --check artık
  #     bir BİLGİ satırı DEĞİL, ÖLÇEMEDİM (exit 2) — money-float.sh :281 /
  #     sigpipe-hygiene.sh :221 emsali. Bu S5'in vaka 2'sidir: eski self-test
  #     rc'ye HİÇ bakmıyordu, yalnız metne bakıyordu.
  mkdir -p "$tmp/s10/migrations"
  cat > "$tmp/s10/migrations/Sample1010101010001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'baseline fixture';
export class Sample1010101010001 {}
EOF
  write_list "$tmp/s10/list.md" "Sample1010101010001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|baseline fixture"
  local base_out check_before_rc check_before_out
  check_before_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  check_before_rc=$?
  if [ "$check_before_rc" -ne 2 ] || ! grep -q "ÖLÇEMEDİM: baseline yok" <<< "$check_before_out"; then
    echo "!! self-test FAIL [B4/baseline-yok]: exit 2 + 'ÖLÇEMEDİM: baseline yok' bekleniyordu, exit=$check_before_rc" >&2
    printf '%s\n' "$check_before_out" >&2
    fail=1
  else
    echo "-- [B4/baseline-yok] --check baseline yokken ÖLÇEMEDİM (exit 2) — artık BLOKLAR, bilgi satırı değil"
  fi
  base_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --baseline </dev/null)"
  local baseline_written=0
  [ ! -f "$tmp/s10/baseline.txt" ] && baseline_written=1
  printf '%s\n' "$base_out" > "$tmp/s10/baseline.txt"
  if [ "$baseline_written" -ne 1 ] || ! grep -q "REVERSIBILITY=IRREVERSIBLE_ADD 1" "$tmp/s10/baseline.txt"; then
    echo "!! self-test FAIL [baseline-ilk-ölçüm]: --baseline dosyayı YAZMAMALI (yalnız stdout), sayı 1 olmalı" >&2
    printf '%s\n' "$base_out" >&2
    fail=1
  else
    echo "-- [baseline-ilk-ölçüm] --baseline stdout'a REVERSIBILITY=IRREVERSIBLE_ADD 1 bastı, dosyaya KENDİSİ YAZMADI"
  fi

  # KARAR (3), Z111 §33: baseline'a EŞİT → exit 0
  local eq_out eq_rc
  eq_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  eq_rc=$?
  if [ "$eq_rc" -ne 0 ]; then
    echo "!! self-test FAIL [baseline-eşit]: exit 0 bekleniyordu, exit=$eq_rc" >&2
    printf '%s\n' "$eq_out" >&2
    fail=1
  else
    echo "-- [baseline-eşit] ölçülen == baseline (tür başına) → exit 0"
  fi

  # ARTTI → KIRMIZI (KARAR (3) — eskiden bloklamayan bir bilgi satırıydı)
  cat > "$tmp/s10/migrations/Sample1010101010002.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'ikinci baseline fixture';
export class Sample1010101010002 {}
EOF
  write_list "$tmp/s10/list.md" \
    "Sample1010101010001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|baseline fixture" \
    "Sample1010101010002.ts|REVERSIBILITY=IRREVERSIBLE_ADD|ikinci baseline fixture"
  local incr_out incr_rc before_sha after_sha
  before_sha="$(shasum -a 256 "$tmp/s10/baseline.txt" | awk '{print $1}')"
  incr_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  incr_rc=$?
  if [ "$incr_rc" -ne 1 ] || ! grep -q "KIRMIZI: beyanlı migration sayısı ARTTI: REVERSIBILITY=IRREVERSIBLE_ADD 1 -> 2" <<< "$incr_out"; then
    echo "!! self-test FAIL [baseline-artış]: exit 1 (KARAR (3): ARTTI artık KIRMIZI) + 'ARTTI: ... 1 -> 2' bekleniyordu, exit=$incr_rc" >&2
    printf '%s\n' "$incr_out" >&2
    fail=1
  else
    echo "-- [baseline-artış] baseline karşısında ARTTI → exit 1 KIRMIZI (§9.2(b)'nin ESKİ 'bloklamaz' cümlesi düştü)"
  fi
  after_sha="$(shasum -a 256 "$tmp/s10/baseline.txt" | awk '{print $1}')"
  if [ "$before_sha" != "$after_sha" ]; then
    echo "!! self-test FAIL [baseline-check-kendini-yazmaz]: --check baseline dosyasını DEĞİŞTİRDİ (sha farklı)" >&2
    fail=1
  else
    echo "-- [baseline-check-kendini-yazmaz] --check koşumu baseline dosyasının shasum'unu DEĞİŞTİRMEDİ"
  fi

  # AZALDI → KIRMIZI "bayat baseline" (KARAR (3))
  # baseline şu an 2 (Sample...001 + ...002); listeden/koddan 002'yi çıkarıp 1'e düşür.
  rm -f "$tmp/s10/migrations/Sample1010101010002.ts"
  write_list "$tmp/s10/list.md" "Sample1010101010001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|baseline fixture"
  cat > "$tmp/s10/baseline.txt" << 'EOF'
# fixture baseline — AZALDI senaryosu
REVERSIBILITY=IRREVERSIBLE_ADD 2
EOF
  local decr_out decr_rc
  decr_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  decr_rc=$?
  if [ "$decr_rc" -ne 1 ] || ! grep -q "KIRMIZI: bayat baseline: REVERSIBILITY=IRREVERSIBLE_ADD 2 -> 1" <<< "$decr_out"; then
    echo "!! self-test FAIL [baseline-azaldı]: exit 1 + 'bayat baseline: ... 2 -> 1' bekleniyordu, exit=$decr_rc" >&2
    printf '%s\n' "$decr_out" >&2
    fail=1
  else
    echo "-- [baseline-azaldı] ölçülen < baseline → exit 1 KIRMIZI 'bayat baseline' (--baseline ile AYRI commit'te düşürülmeli)"
  fi

  # YENİ tür → KIRMIZI (baseline'da hiç olmayan bir EXPORT=DEĞER türü)
  mkdir -p "$tmp/s10b/migrations"
  cat > "$tmp/s10b/migrations/Sample10b0000000001.ts" << 'EOF'
export const EFFECT = 'NONE_BY_DESIGN';
export const EFFECT_REASON = 'yeni tür fixture';
export class Sample10b0000000001 {}
EOF
  write_list "$tmp/s10b/list.md" "Sample10b0000000001.ts|EFFECT=NONE_BY_DESIGN|yeni tür fixture"
  cat > "$tmp/s10b/baseline.txt" << 'EOF'
# fixture baseline — bu türü HİÇ İÇERMİYOR
REVERSIBILITY=IRREVERSIBLE_ADD 1
EOF
  local newtype_out newtype_rc
  newtype_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10b/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10b/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10b/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  newtype_rc=$?
  if [ "$newtype_rc" -ne 1 ] || ! grep -q "KIRMIZI: YENİ tür beyan: EFFECT=NONE_BY_DESIGN 1" <<< "$newtype_out"; then
    echo "!! self-test FAIL [baseline-yeni-tür]: exit 1 + 'YENİ tür beyan' bekleniyordu, exit=$newtype_rc" >&2
    printf '%s\n' "$newtype_out" >&2
    fail=1
  else
    echo "-- [baseline-yeni-tür] baseline'da olmayan tür → exit 1 KIRMIZI 'YENİ tür beyan'"
  fi

  # B3: bozuk baseline satırı (sayısal olmayan sayı) → ÖLÇEMEDİM
  mkdir -p "$tmp/s10c/migrations"
  cat > "$tmp/s10c/migrations/Sample10c0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'bozuk baseline fixture';
export class Sample10c0000000001 {}
EOF
  write_list "$tmp/s10c/list.md" "Sample10c0000000001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|bozuk baseline fixture"
  cat > "$tmp/s10c/baseline.txt" << 'EOF'
REVERSIBILITY=IRREVERSIBLE_ADD abc
EOF
  local badbase_out badbase_rc
  badbase_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10c/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10c/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/s10c/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  badbase_rc=$?
  if [ "$badbase_rc" -ne 2 ] || ! grep -q "ÖLÇEMEDİM: baseline satırı bozuk" <<< "$badbase_out"; then
    echo "!! self-test FAIL [B3/baseline-bozuk]: exit 2 + 'baseline satırı bozuk' bekleniyordu, exit=$badbase_rc" >&2
    printf '%s\n' "$badbase_out" >&2
    fail=1
  else
    echo "-- [B3/baseline-bozuk] sayısal olmayan baseline sayısı → exit 2 ÖLÇEMEDİM (money-float :306 / sigpipe :233 emsali)"
  fi

  # B1: --baseline modu KIRMIZI (sebepsiz) bir taramada YAZMAZ, exit 1
  mkdir -p "$tmp/s10d/migrations"
  cat > "$tmp/s10d/migrations/Sample10d0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = '   ';
export class Sample10d0000000001 {}
EOF
  write_list "$tmp/s10d/list.md"
  local b1red_out b1red_rc
  b1red_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10d/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10d/list.md" bash "$DIR/$GUARD_NAME.sh" --baseline 2>&1 </dev/null)"
  b1red_rc=$?
  if [ "$b1red_rc" -ne 1 ] || grep -q "^# declared-migrations baseline" <<< "$b1red_out"; then
    echo "!! self-test FAIL [B1/baseline-kirmizi]: exit 1 + baseline İÇERİĞİ ÜRETİLMEMELİ, exit=$b1red_rc" >&2
    printf '%s\n' "$b1red_out" >&2
    fail=1
  else
    echo "-- [B1/baseline-kirmizi] KIRMIZI (sebepsiz) tarama → --baseline exit 1, baseline üretmedi"
  fi

  # B1: --baseline modu SCAN_DIR yokken (rc=2 erken dönüş) YAZMAZ, exit 2
  local b1um_out b1um_rc
  b1um_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/nonexistent-dir-baseline-$$" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10d/list.md" bash "$DIR/$GUARD_NAME.sh" --baseline 2>&1 </dev/null)"
  b1um_rc=$?
  if [ "$b1um_rc" -ne 2 ] || grep -q "^# declared-migrations baseline" <<< "$b1um_out"; then
    echo "!! self-test FAIL [B1/baseline-olcemedim]: exit 2 + baseline İÇERİĞİ ÜRETİLMEMELİ, exit=$b1um_rc" >&2
    printf '%s\n' "$b1um_out" >&2
    fail=1
  else
    echo "-- [B1/baseline-olcemedim] SCAN_DIR yok (erken 'return 2') → --baseline exit 2, baseline üretmedi (rc OKUNDU, dosya sayımı DEĞİL)"
  fi

  # N1: yinelenen liste satırı (aynı dosya|EXPORT birden fazla kez)
  mkdir -p "$tmp/s10e/migrations"
  cat > "$tmp/s10e/migrations/Sample10e0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'yinelenen satır fixture';
export class Sample10e0000000001 {}
EOF
  write_list "$tmp/s10e/list.md" \
    "Sample10e0000000001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|yinelenen satır fixture" \
    "Sample10e0000000001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|yinelenen satır fixture (ikinci kez)"
  local dup_out dup_rc
  dup_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s10e/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s10e/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  dup_rc=$?
  if [ "$dup_rc" -ne 2 ] || ! grep -q "yinelenen liste satırı" <<< "$dup_out"; then
    echo "!! self-test FAIL [N1/yinelenen-liste-satırı]: exit 2 + 'yinelenen liste satırı' bekleniyordu, exit=$dup_rc" >&2
    printf '%s\n' "$dup_out" >&2
    fail=1
  else
    echo "-- [N1/yinelenen-liste-satırı] aynı dosya|EXPORT iki kez → exit 2 ÖLÇEMEDİM"
  fi

  # 11) türetme başarısız — bozuk harness dosyası — hüküm: guard başlığı
  # "türetme başarısızsa … guard KENDİ tanıma kümesini UYDURMAZ — ÖLÇEMEDİM"
  mkdir -p "$tmp/s11"
  echo "# harness fixture — 'tanınmıyor' reddi YOK" > "$tmp/s11/broken-harness.sh"
  echo "export const EFFECT = 'placeholder'" > "$tmp/s11/broken-reader.ts"
  mkdir -p "$tmp/s11/migrations"
  # B2 tutarlılığı (brief §10.1): evren boş kalmasın — derive() bu senaryoda
  # zaten SCAN_DIR kontrolünden ÖNCE ÖLÇEMEDİM ile dönüyor, ama fixture'ın
  # hangi kontrolden geçtiği belirsiz kalmasın diye burada da gerçek dosya var.
  cat > "$tmp/s11/migrations/PlainNoDeclaration1111.ts" << 'EOF'
export class PlainNoDeclaration1111 {}
EOF
  write_list "$tmp/s11/list.md"
  local s11_rc
  DECLARED_MIGRATIONS_SCAN_DIR="$tmp/s11/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/s11/list.md" \
    DECLARED_MIGRATIONS_HARNESS_FILE="$tmp/s11/broken-harness.sh" \
    bash "$DIR/$GUARD_NAME.sh" --check > "$tmp/s11/out.txt" 2>&1 </dev/null
  s11_rc=$?
  if [ "$s11_rc" -ne 2 ] || ! grep -q "türetilemedi" "$tmp/s11/out.txt"; then
    echo "!! self-test FAIL [türetme-başarısız]: exit 2 + 'türetilemedi' bekleniyordu, exit=$s11_rc" >&2
    cat "$tmp/s11/out.txt" >&2
    fail=1
  else
    echo "-- [türetme-başarısız] harness'ta 'tanınmıyor' reddi YOK → tanınan değer kümesi türetilemedi, exit 2 (kendi kümesini UYDURMADI)"
  fi

  # R-1a (brief §10.2): liste dosyası OKUNAMAZ (chmod 000) — hüküm: R-1
  # "[ -r ] değilse guard ÖLÇEMEDİM 'okunamadı: <yol>'"
  mkdir -p "$tmp/sr1a/migrations"
  cat > "$tmp/sr1a/migrations/SampleR1a0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'okunamaz liste fixture';
export class SampleR1a0000000001 {}
EOF
  write_list "$tmp/sr1a/list.md"
  chmod 000 "$tmp/sr1a/list.md"
  local r1a_out r1a_rc
  r1a_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/sr1a/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/sr1a/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  r1a_rc=$?
  chmod 644 "$tmp/sr1a/list.md"
  if [ "$r1a_rc" -ne 2 ] || ! grep -q "liste dosyası okunamadı" <<< "$r1a_out"; then
    echo "!! self-test FAIL [R-1/liste-okunamaz]: exit 2 + 'liste dosyası okunamadı' bekleniyordu, exit=$r1a_rc" >&2
    printf '%s\n' "$r1a_out" >&2
    fail=1
  else
    echo "-- [R-1/liste-okunamaz] liste chmod 000 → exit 2 ÖLÇEMEDİM 'okunamadı' (sessiz -f/-r karışması DEĞİL)"
  fi

  # R-1b (brief §10.2): baseline dosyası OKUNAMAZ (chmod 000)
  mkdir -p "$tmp/sr1b/migrations"
  cat > "$tmp/sr1b/migrations/SampleR1b0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'okunamaz baseline fixture';
export class SampleR1b0000000001 {}
EOF
  write_list "$tmp/sr1b/list.md" "SampleR1b0000000001.ts|REVERSIBILITY=IRREVERSIBLE_ADD|okunamaz baseline fixture"
  printf '%s\n' "REVERSIBILITY=IRREVERSIBLE_ADD 1" > "$tmp/sr1b/baseline.txt"
  chmod 000 "$tmp/sr1b/baseline.txt"
  local r1b_out r1b_rc
  r1b_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/sr1b/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/sr1b/list.md" DECLARED_MIGRATIONS_BASELINE="$tmp/sr1b/baseline.txt" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  r1b_rc=$?
  chmod 644 "$tmp/sr1b/baseline.txt"
  if [ "$r1b_rc" -ne 2 ] || ! grep -q "baseline okunamadı" <<< "$r1b_out"; then
    echo "!! self-test FAIL [R-1/baseline-okunamaz]: exit 2 + 'baseline okunamadı' bekleniyordu, exit=$r1b_rc" >&2
    printf '%s\n' "$r1b_out" >&2
    fail=1
  else
    echo "-- [R-1/baseline-okunamaz] baseline chmod 000 → exit 2 ÖLÇEMEDİM 'okunamadı' (sessiz baseline_rc=0 DEĞİL)"
  fi

  # R-2a (brief §10.2): SCAN_DIR GERÇEK migrations dizinine SYMLINK — asla
  # "taranan 0, rc=0" (hüküm: R-2 "hepsi ya eşit sayım ya ÖLÇEMEDİM")
  mkdir -p "$tmp/sr2a"
  ln -s "$BACKEND_DIR/src/database/migrations" "$tmp/sr2a/migrations_link"
  local r2a_out r2a_rc r2a_scanned
  r2a_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/sr2a/migrations_link" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  r2a_rc=$?
  r2a_scanned="$(grep -oE 'taranan \.ts: [0-9]+' <<< "$r2a_out" | grep -oE '[0-9]+')"
  if [ "$r2a_rc" -eq 0 ] && [ "${r2a_scanned:-0}" -eq 0 ]; then
    echo "!! self-test FAIL [R-2/symlink-dizin]: 'taranan 0, rc=0' GÖRÜLDÜ — bu YASAK kombinasyon" >&2
    printf '%s\n' "$r2a_out" >&2
    fail=1
  else
    echo "-- [R-2/symlink-dizin] SCAN_DIR gerçek migrations'a symlink → rc=$r2a_rc taranan=${r2a_scanned:-?} (0+rc=0 DEĞİL)"
  fi

  # R-2b: SCAN_DIR altında YALNIZ bir alt dizin var (adı '.ts' ile bitiyor) —
  # `ls` bunu '.ts' sanır, `find -type f` saymaz → sayım uyuşmazlığı
  mkdir -p "$tmp/sr2b/migrations/sub.ts"
  write_list "$tmp/sr2b/list.md"
  local r2b_out r2b_rc
  r2b_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/sr2b/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/sr2b/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  r2b_rc=$?
  if [ "$r2b_rc" -ne 2 ]; then
    echo "!! self-test FAIL [R-2/yalnız-alt-dizin]: exit 2 bekleniyordu, exit=$r2b_rc" >&2
    printf '%s\n' "$r2b_out" >&2
    fail=1
  else
    echo "-- [R-2/yalnız-alt-dizin] 'sub.ts/' tek içerik → find=0 ls=1 uyuşmazlığı → exit 2 ÖLÇEMEDİM"
  fi

  # R-2c: beyanlı dosyanın KENDİSİ symlink — `-type f` symlink'i GÖRMEZ,
  # `ls -1A` görür → uyuşmazlık (brief: "yakalanır ya da exit 2")
  mkdir -p "$tmp/sr2c/real" "$tmp/sr2c/migrations"
  cat > "$tmp/sr2c/real/RealDeclC0000000001.ts" << 'EOF'
export const REVERSIBILITY = 'IRREVERSIBLE_ADD';
export const REVERSIBILITY_REASON = 'symlink dosya fixture';
export class RealDeclC0000000001 {}
EOF
  ln -s "../real/RealDeclC0000000001.ts" "$tmp/sr2c/migrations/RealDeclC0000000001.ts"
  write_list "$tmp/sr2c/list.md"
  local r2c_out r2c_rc
  r2c_out="$(DECLARED_MIGRATIONS_SCAN_DIR="$tmp/sr2c/migrations" DECLARED_MIGRATIONS_LIST_FILE="$tmp/sr2c/list.md" bash "$DIR/$GUARD_NAME.sh" --check 2>&1 </dev/null)"
  r2c_rc=$?
  if [ "$r2c_rc" -ne 2 ]; then
    echo "!! self-test FAIL [R-2/symlink-dosya]: exit 2 bekleniyordu (yakalanmadıysa), exit=$r2c_rc" >&2
    printf '%s\n' "$r2c_out" >&2
    fail=1
  else
    echo "-- [R-2/symlink-dosya] beyanlı dosya symlink → find≠ls uyuşmazlığı → exit 2 ÖLÇEMEDİM (beyan SESSİZCE KAÇIRILMADI)"
  fi

  rm -rf "$tmp"

  if [ "$fail" -eq 0 ]; then
    echo "-- $GUARD_NAME self-test: senaryolar tutuyor (bilinen-yeşil/gerçek [S5], kodda-var, listede-var, değer-farkı, sebepsiz×3, sahipsiz-reason [T-397 AC3/🟡-1], bilinen-kirmizi/yeni-sebep-degeri [T-397], turetme-eslesme-2 [T-397/F12], K-a/liste-sebep-turetilir [T-397 🔴-2], K-c/bolunmus-satir [T-397 🟡-2], K-d/harness-okunamaz [T-397 🔵], iki-okuyucu, dizin-yok, boş-evren/0-ts [B2], işaretçi/biçim, tanınmayan-değer+çelişki, data-conditional-yeşil, baseline-yok [B4], baseline-ilk-ölçüm, baseline-eşit, baseline-artış [KARAR3], baseline-azaldı [KARAR3], baseline-yeni-tür [KARAR3], baseline-bozuk [B3], baseline-kırmızı+ölçemedim [B1], yinelenen-liste-satırı [N1], türetme-başarısız, liste-okunamaz [R-1a], baseline-okunamaz [R-1b], symlink-dizin [R-2a], yalnız-alt-dizin [R-2b], symlink-dosya [R-2c])"
    return 0
  fi
  echo "⛔ $GUARD_NAME self-test DÜŞTÜ" >&2
  return 1
}

# ── GİRİŞ NOKTASI ───────────────────────────────────────────────────────
case "${1:-}" in
  --self-test)
    self_test
    exit $?
    ;;
  --report)
    do_check_or_report report
    exit 0
    ;;
  --baseline)
    out_dir="$(mktemp -d)"
    OUT_RED_FILE="$out_dir/red.txt"; : > "$OUT_RED_FILE"
    OUT_UNMEASURED_FILE="$out_dir/unmeasured.txt"; : > "$OUT_UNMEASURED_FILE"
    OUT_CODE_DECLARED_FILE="$out_dir/code.declared.txt"; : > "$OUT_CODE_DECLARED_FILE"
    OUT_SCANNED_FILE="$out_dir/scanned.txt"; echo 0 > "$OUT_SCANNED_FILE"
    run_scan_and_compare > /dev/null
    rc=$?
    # B1 (brief §10.1, DISIPLIN F12 onuncu üye — üçüncü vaka): `rc` OKUNUR,
    # yalnız dosya sayımına bakılmaz. Eski hâl yalnız
    # `$OUT_UNMEASURED_FILE`'a bakıyordu; bazı erken-dönüş yolları (SCAN_DIR
    # yok, birincil export türetilemedi, B2 boş evren) bu dosyaya HİÇ
    # yazmadan doğrudan `return 2` yapıyordu — o durumda `unmeasured_n=0`
    # görünüp GEÇERLİ görünen boş bir baseline üretilirdi. `rc` bu yolların
    # HEPSİNİ kapsar.
    if [ "$rc" -eq 2 ]; then
      echo "!! [$GUARD_NAME] --baseline: ÖLÇEMEDİM madde(ler) var, baseline üretilemez:" >&2
      cat "$OUT_UNMEASURED_FILE" >&2
      rm -rf "$out_dir"
      exit 2
    fi
    if [ "$rc" -eq 1 ]; then
      echo "!! [$GUARD_NAME] --baseline: KIRMIZI bulgu(lar) var, baseline üretilemez:" >&2
      cat "$OUT_RED_FILE" >&2
      rm -rf "$out_dir"
      exit 1
    fi
    scanned="$(cat "$OUT_SCANNED_FILE")"
    declared_n="$(grep -c . "$OUT_CODE_DECLARED_FILE")"
    echo "# declared-migrations baseline — BEYANLI_MIGRATION_RATCHET_BRIEF.md §9.2 ratchet referansı"
    echo "# date:    $(date +%Y-%m-%d)"
    echo "# commit:  $(git -C "$META_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    echo "# guard:   declared-migrations v1 (meta)"
    echo "# total:   $declared_n beyanlı migration, $scanned dosya taranan"
    echo "# format:  <EXPORT>=<DEĞER> <sayı>"
    counts_by_type "$OUT_CODE_DECLARED_FILE"
    rm -rf "$out_dir"
    exit 0
    ;;
  --check|"")
    do_check_or_report check
    exit $?
    ;;
  *)
    echo "kullanım: $0 [--check|--report|--baseline|--self-test]" >&2
    exit 2
    ;;
esac
