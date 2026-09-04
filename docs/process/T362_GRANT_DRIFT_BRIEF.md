# `T-362` — GRANT-drift kapısı: **TEK kapı, ÜÇ kaynak**

> **Okunan HEAD:** meta `bcaaecb` · be `d849173` · fe `1553640` (üçü de **push'lu**)
> **Hüküm:** ürün sahibi, 2026-09-03 (`Z93 §3`) — şık **(a)**

## `§0` · NEDEN — ölçülmüş vaka

```
02-runtime-grants.sql:724  GRANT SELECT, INSERT ON …batch_rows TO app_runtime;   BEYAN VAR
canlı DB                   app_runtime → SIFIR ayrıcalık                          UYGULANMAMIŞ
app-runtime-grants         0 bulgu                                                YEŞİL
psql çağrı sayısı          0                                                      ⛔ SEBEP
SET ROLE app_runtime; SELECT …  →  permission denied                              NEDENSELLİK
```
⇒ `tsc` + unit + **tüm guard zinciri yeşil** iken `POST /…/upload` **her çağrıda `500`**.
Guard **`T-249`'u yakalamak için doğmuştu** ve **tam o sınıfın vakasını kaçırdı**.

> ### **İKİ KAYNAK DA KODDU. HİÇBİRİ KOŞAN SİSTEM DEĞİLDİ.**
> ### **HÜKÜM VEREN YER NERESİYSE, KAPININ EVRENİ ORASIDIR — `GRANT`'İ **DB** VERİR.**

## `§1` · ŞEKİL — **MEVCUT GUARD GENİŞLETİLİR**

```
kaynak A   kod-ihtiyacı   entity/repository ifade kümesi        (BUGÜN VAR)
kaynak B   SQL-beyanı     02-runtime-grants.sql                 (BUGÜN VAR)
kaynak C   CANLI DB       information_schema.role_table_grants  ← EKSİK OLAN
kontrol    ÜÇ YÖNLÜ uyum · uyumsuzluk ADIYLA kırmızı
DB yoksa   ÖLÇEMEDİM (exit 2) — SESSİZ YEŞİL DEĞİL
```

⛔ **İKİNCİ BİR GUARD AÇILMAZ.** Ürün sahibi `(b)`'yi reddetti: *aynı sınıfı ölçen iki kapı
**evreni böler** — "ihlal hangisinde?" sorusu doğar.*
⛔ **`(c)` reddi:** sınırı yazmakla yetinmek — `T-084`: **belgelemek KORUR**; üçüncü sınır
**yazılı olsaydı da vaka geçerdi**. **Sınırlar dokümanda değil, ÖLÇÜMDE kapanır.**

## `§2` · YÖNLER — her biri AYRI ADLA kırmızı

```
A \ C   kod ihtiyaç duyuyor, DB'de YOK          ⇒ BUGÜNÜN VAKASI (upload 500)
B \ C   beyan var, DB'de YOK                    ⇒ "betik uygulanmamış"
C \ B   DB'de var, beyanda YOK                  ⇒ KAYIT-DIŞI hak (Z51 ihlali)
A \ B   kod ihtiyaç duyuyor, beyanda YOK        ⇒ BUGÜN VAR (mevcut kontrol)
```

⛔ **`B \ A` (beyan var, kod ihtiyaç duymuyor = fazla yetki) BİR KARAR NOKTASIDIR.**
En-az-yetki açısından kırmızı olmalı **görünür**, ama bugün kaç satır olduğunu **bilmiyoruz**.
**ÖNCE SAY.** Sıfırsa kapıya ekle. Sıfır değilse **DUR ve raporla** — kırmızı doğan bir kapı
ölür (`Z83`), ve bu bir **ürün kararıdır**, senin değil.

## `§3` · ⛔ DOĞUM ŞARTI (`Z83`) — BİLİNEN-YEŞİL **VE** BİLİNEN-KIRMIZI

> **Temiz doğan bir kapı bir başarı değil, bir ŞÜPHE SEBEBİDİR.**

İlk koşumda **ikisi de** gösterilecek:
```
BİLİNEN-YEŞİL   bugünkü ağaç + bugünkü DB  ⇒  exit 0
BİLİNEN-KIRMIZI her yön için AYRI bir fixture ⇒ exit ≠ 0, ve ADIYLA
```
⚠️ **`02-runtime-grants.sql`'i ya da canlı DB'yi MUTASYONA UĞRATMA.** Kırmızı kanıtı
**fixture** ile üretilir (mevcut guard'ın self-test'inde bir fixture matrisi **zaten var** —
`§7`: *yeni kod yazmadan önce ara*; onu **genişlet**, yenisini yazma).

⚠️ Ve `ÖLÇEMEDİM` dalının da bir vakası olmalı: **DB'ye ulaşılamadığında exit 2** —
`0` DEĞİL. Mevcut guard'larda emsali var: `view-security-invoker` · `app-operator-grants` ·
`bypassrls-hygiene` (üçünün de self-test'inde `DB-ulaşılamaz → exit 2` vakası **yazılı**).

## `§4` · ⛔ ÖNCE ARA — `§7`

Canlı DB'yi sorgulayan **üç guard zaten var**: `app-operator-grants.sh` ·
`bypassrls-hygiene.sh` · `view-security-invoker.sh`. Bağlantı kurulumu, `ÖLÇEMEDİM` dalı,
şema-nitelendirme ve self-test şekli **oralarda çözülmüş**.
**Yeni bir bağlantı deseni YAZMA — mevcudu kullan.** Hangisini kullandığını ve neden
uygun olduğunu **yaz**.

## `§5` · ŞEMA-NİTELENDİRME (ZORUNLU)
Aynı PostgreSQL instance'ı **başka bir ürünün `public` şemasını** da barındırıyor.
Her katalog sorgusu `table_schema = 'main'` (ya da `nspname`/`schemaname`) predicate'i
taşır. Şemasız bir sorgu **yanlış ürünün** yetkilerini okuyabilir.

## `§6` · PİNLER — raporda sayı ile
```
PİN 1  bugünkü ağaç + bugünkü DB  ⇒  exit 0                 (BİLİNEN-YEŞİL)
PİN 2  A\C fixture                ⇒  exit ≠ 0, ad basılı
PİN 3  B\C fixture                ⇒  exit ≠ 0, ad basılı
PİN 4  C\B fixture                ⇒  exit ≠ 0, ad basılı
PİN 5  DB ulaşılamaz              ⇒  exit 2   ("ÖLÇEMEDİM", yeşil DEĞİL)
PİN 6  B\A bugün KAÇ satır         ⇒  SAY; sıfır değilse DUR
PİN 7  mevcut A\B kontrolü        ⇒  BOZULMADI (regresyon)
```
⚠️ **Reprodüksiyon şartı yönsüzdür:** bir fixture'ın kırmızı vereceğini **yazmadan önce
GÖR**. Görülmezse hipotez elenir ve **bu da bir sonuçtur**.

## `§7` · ORTAK YASA
- **İLK MADDE:** `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**
- ⛔ **CANLI DB'YE YAZMA.** `GRANT`/`REVOKE`/`DDL`/`SET ROLE` ile kalıcı değişiklik **YOK**.
  Guard **SALT-OKUNUR** olmalı. `npm run db:roles:grants` **koşma**.
- ⛔ Container'a **dokunma** (`docker stop/rm/rename` **yasak**) — canlı geliştirme DB'si.
- Doğrulamanı **izole `git worktree`'de** yap. `git stash` YASAK · `git checkout` ile geri
  alma YASAK (kopyala → uygula → kopyadan geri yükle → `shasum -a 256 -c`) · `git add -A`
  YASAK · `.env` **okuma** · **commit/push YAPMA**.
- `/Users/sertact/Documents/CollMind/Code/TTM` ve `.../Code/TPM` — **tek bayt yazma, tek
  komut koşma**. (Adları benziyor; bu repo `Collmind-TPM`.)
- Exit kodunu **boruya sokma**: `cmd > /tmp/x.log 2>&1; echo $?`
- **`ölçemedim` meşru bir çıktıdır. `flaky` DEĞİLDİR.**
- Kapılar: `bash scripts/gate.sh be npm run guards` · `... be npx tsc --noEmit`.
  **Tam e2e'yi KOŞMA** (kilit Team Lead'de).
