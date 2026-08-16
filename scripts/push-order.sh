#!/usr/bin/env bash
#
# push-order.sh — submodule'ler ÖNCE, meta pointer EN SON (T-212 Kalem 3)
#
# NEDEN VAR
# Team Lead push sırasını İKİ KEZ ters yaptı (meta → submodule). Meta pointer
# submodule'lerin henüz origin'de görünmeyen commit'lerine işaret etti — bir
# başkası (ya da CI) meta'yı checkout ettiğinde submodule pointer'ı ÇÖZÜLEMEZ.
# "Bir daha dikkat ederim" iki kez söylendi, iki kez tutmadı:
# "niyet mekanizmanın yerini tutmaz." Kural artık bir SCRIPT.
#
# SIRA
#   1. Her submodule'ü push et (backend, frontend — bu script'in çağrıldığı
#      sıra bağlayıcıdır, listede ne yazılıysa o sırayla gider)
#   2. Her push'tan SONRA `merge-base --is-ancestor` ile commit'in origin'de
#      GERÇEKTEN GÖRÜLDÜĞÜNÜ doğrula — "push edildi" (komutun exit 0 dönmesi)
#      yetmez, ağ/timeout/partial-push senaryolarında yanıltıcı olabilir.
#   3. Meta pointer'ın işaret ettiği submodule commit'i, az önce doğrulanan
#      commit'le eşleşiyor mu diye sanity-check yap.
#   4. ANCAK SONRA meta'yı push et — ve onu da aynı merge-base doğrulamasından
#      geçir.
#
# Bir adım başarısız/doğrulanamaz olursa script o adımdan İTİBAREN durur ve
# sonraki adıma GEÇMEZ. (S2, T-212 code-review, ölçüldü — bu paragraf daha
# önce "hiçbir şey push edilmez" diyordu ve bu YANLIŞTI: backend adımı
# başarıyla push+doğrulanmışken frontend'de DURULURSA, backend'in push'u
# GERİ ALINMAZ — script idempotent'tir, bir sonraki koşum onu atlayıp kaldığı
# yerden devam eder.) Doğru cümle: engellenen adımdan itibaren hiçbir şey
# push edilmez; ondan ÖNCEKİ adımlar zaten gitmiş olabilir — bu GÜVENLİ
# yöndür, çünkü meta pointer sırada en sonda ve doğrulanmamış bir submodule
# commit'inin üstüne ASLA push edilmez.
#
# ⛔ AÇIK KARAR — Team Lead'e soruldu, bu script'te KONSERVATİF VARSAYILANLA
# uygulandı (CLAUDE.md §2.4 "Belirsizlikte DUR"):
#   Bir submodule'de COMMIT EDİLMEMİŞ değişiklik bulunursa script o
#   adımda DURUR (exit 2) — uyarıp devam etmez, varsayılan davranış bu.
#   Gerekçe: push sırası zaten meta pointer'ın submodule'ün push edilen
#   HALİYLE eşleşmesini garanti etmeye çalışıyor; commit edilmemiş bir
#   değişiklik o garantiyi baştan anlamsız kılar (hangi hâl push edildi,
#   hangi hâl kaldı belirsiz). Bu varsayım DOĞRULANMADI — Team Lead onayı
#   bekliyor. Onaylanmazsa (ör. "yalnız UYAR, devam et" isteniyorsa)
#   `ABORT_ON_DIRTY` bayrağı bunun için hazır: `PUSH_ORDER_ABORT_ON_DIRTY=0`
#   ile gevşetilebilir, varsayılan 1 (dur).
#
# KULLANIM
#   bash scripts/push-order.sh
#
#   push-order-self-test.sh ARTIK AYRICA ELLE ÇALIŞTIRILMASI GEREKMEZ (S-2,
#   T-212, 2026-08-14) — push-order.sh her koşumda GERÇEK işe başlamadan önce
#   onu kendisi çağırır (aşağıdaki "self-test kapısı" bloğuna bkz.). Elle
#   koşmak hâlâ mümkündür (ör. self-test'i tek başına geliştirirken):
#     bash scripts/push-order-self-test.sh   ← push-order.sh'ın kendi doğruluk
#                                               kanıtı (7 senaryo, tamamen
#                                               lokal bare-repo harness, S3+S2)
#
# ÇEVRE DEĞİŞKENLERİ (test edilebilirlik için — push-order-self-test.sh bunları kullanır)
#   PUSH_ORDER_ROOT               varsayılan: bu script'in üst üst dizini
#   PUSH_ORDER_SUBMODULES         varsayılan: "collmind.backend collmind.frontend"
#                                  (SIRA BAĞLAYICI — backend önce, frontend sonra)
#   PUSH_ORDER_REMOTE             varsayılan: origin
#   PUSH_ORDER_ABORT_ON_DIRTY     varsayılan: 1 (yukarıdaki açık karara bkz.)
#                                  yalnız "0"/"1" kabul edilir — başka DEĞER
#                                  KURULUM HATASI (exit 2), bkz. B2 aşağıda
#   PUSH_ORDER_SKIP_META          varsayılan: 0 — "1" ise yalnız
#                                  submodule'leri push eder, meta'ya
#                                  dokunmaz (push-order-self-test.sh'ın meta
#                                  pointer sanity-check'i ayrı test etmesi
#                                  için kullanılabilir; bugünkü self-test
#                                  bunu KULLANMIYOR ama bayrak bunun için var)
#                                  yalnız "0"/"1" kabul edilir, aynı kural
#   PUSH_ORDER_SELFTEST_DONE       varsayılan: 0 — "1" self-test'in KENDİ
#                                  ÖZYİNELEMESİNİ önlemek için push-order-
#                                  self-test.sh'ın iç çağrılarına ÖZELDİR.
#                                  ELLE "1" SET ETME: gerçek bir push'un
#                                  güvenilirlik kanıtını atlamış olursun.
#
# ÇIKIŞ KODLARI
#   0  hepsi push edildi ve origin'de doğrulandı (meta dahil, atlanmadıysa)
#   1  bir push ya da doğrulama BAŞARISIZ oldu — sıra durdu
#   2  KURULUM/GİRDİ hatası: push-order-self-test.sh BAŞARISIZ (S-2 — gerçek
#      push hiç BAŞLAMADI) · commit edilmemiş değişiklik (DUR) · detached
#      HEAD · meta pointer submodule'ün doğrulanan commit'iyle uyuşmuyor
set -uo pipefail

# --- self-test kapısı (S-2, T-212 2026-08-14) -------------------------------
# NEDEN VAR: push-order-self-test.sh yazıldıktan sonra onu ÇAĞIRAN hiçbir yol
# yoktu — dört atıf vardı (bu başlık dahil), dördü de yorum. "Test edilebilirlik
# için" env değişkenleri tanımlayan bir başlık, onları kullanan bir self-test
# koşulmadıkça bir iddiadan ibarettir (CLAUDE.md: "doğrulama bir kapıdır;
# durdurmuyorsa doğrulama değildir"). Bu blok o kapıyı kurar: GERÇEK bir push
# başlamadan önce push-order-self-test.sh'ın 6 (+bu değişiklikle 7) senaryosu
# YEŞİL olmalı; değilse script'in kendisine güvenilmiyor demektir ve gerçek
# origin'e karşı hiçbir adım atılmaz.
#
# NEDEN BURASI (push-order.sh'ın kendi başı) VE BAŞKA YER DEĞİL: /release ya
# da CLAUDE.md §5'in bir insan adımı olması aynı hatayı tekrarlardı — "niyet
# mekanizmanın yerini tutmaz" (bu script'in kendisi zaten bu derse karşı
# yazıldı). §5 push-order.sh'ı YALNIZCA push sırası için ZORUNLU kılıyor,
# /release'e özel değil — yani gate /release'e bağlanırsa sıradan bir
# push-order.sh koşumu (release dışı) yine korumasız kalırdı.
#
# MALİYET (ölçüldü — aşağıya bkz): altı/yedi senaryo TAMAMEN LOKAL bare-repo
# harness'i kurup yıkıyor, ağa hiç dokunmuyor. Gerçek bir push zaten ağ G/Ç'si
# içerdiğinden (fetch+push, en az iki round-trip), bu ek yerel maliyet
# göreli olarak küçük.
#
# ÖZYİNELEME KORUMASI: push-order-self-test.sh'ın senaryoları bu script'i
# (gerçek push-order.sh'ı) İZOLE bir bare-repo harness'ine karşı ÇAĞIRIR. O iç
# çağrı KENDİ self-test'ini de tetiklerse (bu blok koşulsuz çalışsaydı) her
# senaryo kendi içinde 7 senaryo daha başlatır — sonsuz özyineleme.
# PUSH_ORDER_SELFTEST_DONE bunu keser: yalnız push-order-self-test.sh'ın
# `run_case` fonksiyonu bunu KENDİ başlattığı iç çağrılar için "1" set eder
# (bkz. push-order-self-test.sh). Elle "1" set etmek gerçek bir push'un
# doğrulamasını ATLAR — bu yüzden dışarıdan hiçbir zaman set edilmemeli ve
# varsayılan HER ZAMAN self-test'i ÇALIŞTIR'dır.
if [ "${PUSH_ORDER_SELFTEST_DONE:-0}" != "1" ]; then
  _selftest_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  _selftest_script="$_selftest_dir/push-order-self-test.sh"
  if [ -f "$_selftest_script" ]; then
    # ⚠️ ÇAĞIRANIN ORTAMI SELF-TEST'E SIZMAMALI (2026-08-16, ölçüldü).
    #    Vaka: `PUSH_ORDER_ABORT_ON_DIRTY=0` ile çağrıldığında değişken
    #    self-test'e devrolduğu için "kirli ağaçta DURMALI" vakası düştü ve
    #    kapı GERÇEK push'u reddetti (exit 2). Yani BELGELENMİŞ KAÇIŞ YOLU
    #    kullanılamaz durumdaydı — yön güvenliydi (yanlış kırmızı), ama
    #    kaçış yolu işlevsizdi.
    #    Self-test kendi senaryolarını KENDİ set ettiği değişkenlerle kurar;
    #    dışarıdan gelen her PUSH_ORDER_* onun kurulumunu bozar.
    if ! env -u PUSH_ORDER_ABORT_ON_DIRTY \
             -u PUSH_ORDER_SKIP_META \
             -u PUSH_ORDER_SUBMODULES \
             -u PUSH_ORDER_REMOTE \
             -u PUSH_ORDER_ROOT \
             PUSH_ORDER_SELFTEST_DONE=1 bash "$_selftest_script" >&2; then
      echo "!! push-order-self-test.sh BAŞARISIZ — push-order.sh'a güvenilmiyor," >&2
      echo "!! GERÇEK push YAPILMADI (exit 2). Detay yukarıda." >&2
      exit 2
    fi
  else
    echo "!! push-order-self-test.sh bulunamadı ($_selftest_script) — güvenilirlik kanıtlanamıyor, DUR (exit 2)" >&2
    exit 2
  fi
fi

ROOT="${PUSH_ORDER_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SUBMODULES="${PUSH_ORDER_SUBMODULES:-collmind.backend collmind.frontend}"
REMOTE="${PUSH_ORDER_REMOTE:-origin}"
ABORT_ON_DIRTY="${PUSH_ORDER_ABORT_ON_DIRTY:-1}"
SKIP_META="${PUSH_ORDER_SKIP_META:-0}"

# B2 (T-212 code-review, ölçüldü): `[ "$X" -eq 1 ]` bir tamsayı bekler.
# `PUSH_ORDER_ABORT_ON_DIRTY=true` yazan biri "makul bir yazım" kullanıyor —
# `-eq` bunu sessizce reddeder (bash `[: true: integer expression expected`
# STDERR'e düşer), `set -uo pipefail`'DE `-e` YOK, yani test komutu başarısız
# (1) döner ve if/else zincirinde "false" sayılır — kirli ağaçta push AKAR.
# Tek iz stderr'deki bash gürültüsü. Aynı sınıf SKIP_META için de var
# (`PUSH_ORDER_SKIP_META=yes` meta'yı SESSİZCE push eder).
# Düzeltme: yalnız "0" ve "1" kabul edilir; başka HER DEĞER kurulum hatasıdır
# (gevşetme değil) — §2.5 "sessiz sıfır yasağı"nın ikili-bayrak karşılığı.
require_bool_flag() { # <env-adı> <değer>
  case "$2" in
    0|1) ;;
    *)
      echo "!! $1='$2' geçersiz — yalnız 0 ya da 1 kabul edilir (KURULUM HATASI, exit 2)" >&2
      exit 2
      ;;
  esac
}
require_bool_flag PUSH_ORDER_ABORT_ON_DIRTY "$ABORT_ON_DIRTY"
require_bool_flag PUSH_ORDER_SKIP_META "$SKIP_META"

# push_and_verify <etiket> <yol>
# Döner: 0 = push edildi (ya da zaten güncel) VE origin'de doğrulandı
#        1 = push ya da doğrulama başarısız
#        2 = kurulum/girdi hatası (dirty ağaç, detached HEAD)
push_and_verify() {
  local label="$1" path="$2"

  if [ ! -d "$path/.git" ] && [ ! -f "$path/.git" ]; then
    echo "!! [$label] ($path) bir git deposu değil — DUR" >&2
    return 2
  fi

  # -uall: untracked dosyalar da sayılır. "push edildi" iddiası, çalışma
  # ağacının commit edilmiş hâliyle eşleştiği varsayımına dayanır; dirty bir
  # ağaçta bu varsayım baştan çürük.
  #
  # S1 (T-212 code-review, ölçüldü): --ignore-submodules=dirty ŞART. Onsuz,
  # meta'nın kendi dirty kontrolü nested submodule'lerin (collmind.frontend
  # vb.) commit edilmemiş değişikliklerini de "M collmind.frontend" olarak
  # meta'nın status'üne SIZDIRIYOR — bu da PUSH_ORDER_SUBMODULES ile kapsamı
  # backend'e daraltmayı işe yaramaz kılıyor (frontend zaten kapsam dışı
  # bırakılmışken meta yine de onun kirliliğinden dolayı DURuyordu). Submodule
  # kirliliği zaten döngüde HER SUBMODULE için AYRI ölçülüyor; meta'da ikinci
  # kez (ve dolaylı, dosya-düzeyi ayrımı olmadan) ölçülmesi yalnız kilitliyor.
  local ignore_sm=""
  [ "$label" = "meta" ] && ignore_sm="--ignore-submodules=dirty"
  local dirty
  dirty="$(git -C "$path" status --porcelain -uall $ignore_sm)"
  if [ -n "$dirty" ]; then
    echo "!! [$label] commit edilmemiş değişiklik var:" >&2
    printf '%s\n' "$dirty" | sed 's/^/     /' >&2
    if [ "$ABORT_ON_DIRTY" -eq 1 ]; then
      echo "!! [$label] DUR (varsayılan davranış — üstteki 'AÇIK KARAR' notuna bkz, Team Lead onayı bekliyor)" >&2
      return 2
    else
      echo "-- [$label] UYARILDI, PUSH_ORDER_ABORT_ON_DIRTY=0 ile devam ediliyor (riskli)" >&2
    fi
  fi

  local branch
  branch="$(git -C "$path" branch --show-current)"
  if [ -z "$branch" ]; then
    echo "!! [$label] detached HEAD — hangi branch push edilecek belirsiz, DUR" >&2
    return 2
  fi

  local local_sha
  local_sha="$(git -C "$path" rev-parse HEAD)"

  if ! git -C "$path" fetch "$REMOTE" "$branch" >/dev/null 2>&1; then
    echo "!! [$label] fetch $REMOTE/$branch başarısız" >&2
    return 1
  fi
  local remote_sha
  remote_sha="$(git -C "$path" rev-parse "$REMOTE/$branch" 2>/dev/null || echo '')"

  if [ "$remote_sha" = "$local_sha" ]; then
    echo "-- [$label] zaten güncel: $REMOTE/$branch == ${local_sha:0:12}, push ATLANIYOR"
  else
    echo "-- [$label] push ediliyor: ${local_sha:0:12} -> $REMOTE/$branch"
    if ! git -C "$path" push "$REMOTE" "HEAD:$branch"; then
      echo "!! [$label] push BAŞARISIZ" >&2
      return 1
    fi
  fi

  # "push edildi" (komut exit 0) yetmez — origin'de GÖRÜLDÜĞÜNÜ ayrıca ölç.
  git -C "$path" fetch "$REMOTE" "$branch" >/dev/null 2>&1
  if ! git -C "$path" merge-base --is-ancestor "$local_sha" "$REMOTE/$branch" 2>/dev/null; then
    echo "!! [$label] push edildi ama ${local_sha:0:12} $REMOTE/$branch'te GÖRÜLMÜYOR — doğrulama başarısız" >&2
    return 1
  fi
  echo "-- [$label] doğrulandı: ${local_sha:0:12} $REMOTE/$branch'te görülüyor"
  return 0
}

echo "=== push-order: $SUBMODULES (sırayla), sonra meta ==="
echo

for sm in $SUBMODULES; do
  echo "--- $sm ---"
  push_and_verify "$sm" "$ROOT/$sm"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    echo
    echo "!! push sırası DURDU: $sm adımında (exit $rc) — meta pointer PUSH EDİLMEDİ" >&2
    exit "$rc"
  fi

  # Sanity: meta'nın ŞU AN commit edilmiş HEAD'inin işaret ettiği submodule
  # pointer'ı, az önce origin'de doğrulanan commit'le eşleşiyor mu? Eşleşmezse
  # meta zaten yanlış (ya da eski) bir pointer taşıyor demektir — onu push
  # etmek origin'i submodule ile TUTARSIZ bırakır.
  meta_pointer_sha="$(git -C "$ROOT" rev-parse "HEAD:$sm" 2>/dev/null || echo '')"
  local_sha="$(git -C "$ROOT/$sm" rev-parse HEAD)"
  if [ -z "$meta_pointer_sha" ]; then
    echo "!! [$sm] meta HEAD'inde bu yol için bir gitlink bulunamadı (.gitmodules kontrol et)" >&2
    exit 2
  fi
  if [ "$meta_pointer_sha" != "$local_sha" ]; then
    echo "!! [$sm] meta'nın HEAD'i bu submodule için ${meta_pointer_sha:0:12} işaret ediyor," >&2
    echo "!! ama submodule'ün şu anki (doğrulanan) commit'i ${local_sha:0:12} — UYUŞMUYOR." >&2
    echo "!! meta commit'i muhtemelen submodule pointer bump'ından ÖNCE alınmış. DUR." >&2
    exit 2
  fi
  echo "-- [$sm] meta pointer eşleşiyor: ${local_sha:0:12}"
  echo
done

if [ "$SKIP_META" -eq 1 ]; then
  echo "-- [meta] PUSH_ORDER_SKIP_META=1 — meta push atlandı (yalnız submodule'ler doğrulandı)"
  exit 0
fi

echo "--- meta (pointer en son) ---"
push_and_verify "meta" "$ROOT"
exit $?
