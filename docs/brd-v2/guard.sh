#!/usr/bin/env bash
# BRD v2 · belge guard'ı — E6
#
# Üç kontrol:
#   1. Kural sayımı            (F8: elle tutulan sayı bayatlar)
#   2. Kimlik tekilliği        (F2: aynı numara iki kurala verilmişti)
#   3. Sarkan atıf             (var olmayan bir K-numarasına referans)
#
# CLAUDE.md §2.7'nin belge hâli: bir kurala uymak ile o kuralın kendi çıktına
# uygulandığını doğrulamak ayrı işlerdir.
#
# KONTROL ADAYLARI — henüz yazılmadı, ve bugün elle tutuluyor demektir.
# (Sıra numarası yok: 00_PAKET_INDEKSI'nin "dördüncü kontrol adayı" cümlesi
#  dosya adı atıflarını, 2026-08-13 turu bayat adresi "dördüncü" diye
#  adlandırdı. Numara değil, liste kanonik.)
#
#   a) Dosya adı atıfları  — üç kontrol de K-numarasına bakıyor; bayat bir
#      dosya adı (`01_YETENEK`) yakalanmadı
#   b) Açık (⛔) sayısı     — sayılıyor ve BASILIYOR, ama indeksle
#      KARŞILAŞTIRILMIYOR. Yalnız toplam karşılaştırılıyor.
#   c) Bölüm dağılımı      — aynı: basılıyor, karşılaştırılmıyor. İndeksin
#      dağılım satırı bir kez bayat yakalandı (89 ↔ 88)
#   d) Bayat adres         — kapanmış bir dalgaya/task'a referans veren ❌
#      (L2 §Bu katmanın kuralları md.5: her ❌ bir adres taşır)
#
# Kullanım:  ./guard.sh [paket_dizini]
# Çıkış:     0 temiz · 1 ihlal

set -uo pipefail
PKG="${1:-.}"
RULES_DIR="$PKG/03_IS_KURALLARI"
FAIL=0

if [ ! -d "$RULES_DIR" ]; then
  echo "HATA: $RULES_DIR bulunamadı" >&2
  exit 2
fi

echo "BRD v2 · belge guard'ı"
echo "======================"
echo

# ---------------------------------------------------------------- 1 · sayım
echo "1 · Kural sayımı"

TOTAL=$(grep -h '^\*\*K-' "$RULES_DIR"/*.md | wc -l | tr -d ' ')
OPEN=$(grep -h '⛔ \*\*açık' "$RULES_DIR"/*.md | wc -l | tr -d ' ')

echo "   tanım : $TOTAL"
echo "   açık  : $OPEN"
echo
echo "   bölüm başına:"
for f in "$RULES_DIR"/*.md; do
  printf "     %-52s %s\n" "$(basename "$f")" "$(grep -c '^\*\*K-' "$f")"
done
echo

# İndeksteki sayı ile karşılaştır — F8 sınıfı
IDX="$PKG/00_PAKET_INDEKSI.md"
if [ -f "$IDX" ]; then
  IDX_COUNT=$(grep -oP '\| `L2` kural tanımı \| \*\*\K[0-9]+' "$IDX" 2>/dev/null || echo "")
  if [ -n "$IDX_COUNT" ] && [ "$IDX_COUNT" != "$TOTAL" ]; then
    echo "   ⛔ İHLAL: indeks $IDX_COUNT diyor, gerçek $TOTAL"
    echo "      (F8 sınıfı — elle tutulan sayı bayatladı)"
    FAIL=1
  elif [ -n "$IDX_COUNT" ]; then
    echo "   ✅ indeks sayımıyla uyumlu"
  fi
fi
echo

# ------------------------------------------------------- 2 · kimlik tekilliği
echo "2 · Kimlik tekilliği"

DUPES=$(grep -h '^\*\*K-' "$RULES_DIR"/*.md \
        | grep -oP '^\*\*\K[K][-0-9.a-z]*(?=\*\*)' \
        | sort | uniq -d)

if [ -n "$DUPES" ]; then
  echo "   ⛔ İHLAL: aynı numara birden çok kurala verilmiş"
  echo "$DUPES" | while read -r id; do
    echo "      $id"
    grep -Hn "^\*\*$id\*\*" "$RULES_DIR"/*.md | sed 's/^/        /'
  done
  echo
  echo "      Bu, sessiz geçersiz kılmanın en tehlikeli formudur:"
  echo "      atıf çözümlemesi okuyana göre değişir. (F2)"
  FAIL=1
else
  echo "   ✅ çakışma yok"
fi
echo

# ----------------------------------------------------------- 3 · sarkan atıf
echo "3 · Sarkan atıf"

DEFINED=$(mktemp)
REFERENCED=$(mktemp)
trap 'rm -f "$DEFINED" "$REFERENCED"' EXIT

grep -h '^\*\*K-' "$RULES_DIR"/*.md \
  | grep -oP '^\*\*\K[K][-0-9.a-z]*(?=\*\*)' \
  | sort -u > "$DEFINED"

# tüm pakette geçen `K-...` atıfları
#   "eski K-x" biçimindeki TARİHSEL notlar atıf sayılmaz — bir kuralın taşındığını
#   kaydeden bir izdir, ona yapılan bir referans değil.
grep -rhoP '(?<!eski )`\KK-[0-9]+\.[0-9]+\.[0-9]+[a-z0-9]*(?=`)' "$PKG" --include='*.md' \
  | sort -u > "$REFERENCED"

DANGLING=$(comm -13 "$DEFINED" "$REFERENCED")

if [ -n "$DANGLING" ]; then
  echo "   ⛔ İHLAL: var olmayan kurala atıf"
  echo "$DANGLING" | while read -r id; do
    [ -z "$id" ] && continue
    echo "      $id  ←"
    grep -rln "\`$id\`" "$PKG" --include='*.md' | sed 's/^/        /'
  done
  FAIL=1
else
  echo "   ✅ sarkan atıf yok"
fi
echo

# ---------------------------------------------------------------------- özet
echo "======================"
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Temiz — $TOTAL kural, $OPEN açık"
else
  echo "⛔ İhlal var — yukarıya bak"
fi

exit "$FAIL"
