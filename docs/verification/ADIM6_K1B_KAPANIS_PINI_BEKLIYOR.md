# `ADIM 6` / `K1b` — kapanış pini **ÖLÇÜLEMEDİ** (sandbox blokajı, insan eylemi gerekli)

**Tarih:** 2026-08-28 · **Ölçen:** backend-engineer · **Statü:** ⛔ **DUR — insan eylemi bekliyor**

## Ne yapıldı, ne YAPILAMADI

✅ **Yapıldı (config, kod, script — hepsi hazır ve gözden geçirilebilir):**
- `collmind.backend/docker-compose.yml` + `docker-compose.local.yml`: postgres
  servisine `logging_collector=on` · `log_line_prefix='%m [%p] %u@%d %a'` ·
  `log_connections=on` · ayrı bir `postgres_logs` volume eklendi.
- `collmind.backend/scripts/verification/k1b-two-marker-pin.sh`: kapanış
  pininin ölçüm scripti (marker METNİ OLMADAN, `u=` alanına göre ayrışma).
- `docker compose config --quiet` → **exit 0** (dosyalar sözdizimsel geçerli).

⛔ **YAPILAMADI:** gerçek `collmind-tpm-postgres` container'ının bu yeni ayarlarla
**yeniden yaratılması**. `logging_collector` bir **postmaster-context**
parametresidir — `docker exec`/SIGHUP ile değişmez, container'ın DURDURULUP
YENİDEN BAŞLATILMASI (ya da yeniden yaratılması) gerekir.

**Bu oturumun sandbox'ı `docker stop`, `docker rm`, `docker rename` gibi
container-mutasyon komutlarını REDDETTİ** (auto-mode classifier — güvenlik
politikası, geçici izin isteğiyle de aşılamadı). Bu, gerçek veritabanı
container'ını (canlı geliştirme DB'si, `tenants`=1 satır, `admin_audit_logs`=39
satır) etkileyen bir işlem olduğu için **insan onayı olmadan zorlanmaması
doğru bir sınırdır** — CLAUDE.md §5 disiplini ("destructive operations...
yalnızca kullanıcı isterse") burada da geçerli.

## Neden risksiz — veri KAYBOLMAZ (ama yine de doğrulanmalı)

Container ismi (`collmind-tpm-postgres`) ve portu (`5434→5432`) **DEĞİŞMEZ**;
veri **named volume**'da yaşıyor (`collmind-tpm-postgres-data`, bu turda
DOKUNULMADI) — container'ı silip aynı volume ile yeniden yaratmak veriyi
SİLMEZ (Docker named volume'lar container'ın yaşam döngüsünden BAĞIMSIZDIR).
Ama bu bir **iddia**dır, kanıt değil — bu yüzden aşağıdaki adımlar ÖNCESİ/SONRASI
bir satır-sayısı karşılaştırması içerir (T-047'nin manuel karşılığı).

⛔ **Ölçülmüş ve DÜZELTİLMİŞ bir tuzak:** bu container BUGÜN `docker-compose.yml`
ile yaratılmamış (muhtemelen elle `docker run`) — gerçek veri volume'unun adı
`collmind-tpm-postgres-data`'dır, compose'un varsayılan ürettiği ad
(`collmindbackend_postgres_data`) DEĞİL. Bu fark PİN'LENMEDEN `docker compose
up -d postgres` çalıştırılsaydı **sessizce boş bir volume'a bağlanırdı** —
`docker-compose.yml`'in `volumes:` bloğuna artık `name: collmind-tpm-postgres-data`
PİNİ eklendi (bu turda), yani aşağıdaki adım 2 artık GÜVENLİ. (Yan not: bu
turun bir `docker compose up -d postgres` deneme-yanılması iki zararsız/boş
volume bıraktı: `collmindbackend_postgres_data`, `collmindbackend_postgres_logs`
— `docker volume rm` ile temizlenebilir, hiçbiri veri taşımıyor.)

## Adımlar (İNSAN tarafından, bu ortamda)

```bash
cd collmind.backend

# 0) ÖNCESİ satır sayıları (T-047 manuel karşılığı — kaybı KANITLAMAK için)
docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm -t -A \
  -c "SELECT 'tenants', count(*) FROM main.tenants
      UNION ALL SELECT 'plans', count(*) FROM main.plans
      UNION ALL SELECT 'admin_audit_logs', count(*) FROM main.admin_audit_logs;"

# 1) Eski container'ı DURDUR ve KALDIR (veri volume'da kalır, SİLİNMEZ)
docker stop collmind-tpm-postgres
docker rm collmind-tpm-postgres

# 2) Yeni ayarlarla YENİDEN YARAT — AYNI volume, AYNI isim/port
docker compose up -d postgres

# 3) SONRASI satır sayıları — 0'daki ile BİREBİR eşleşmeli
docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm -t -A \
  -c "SELECT 'tenants', count(*) FROM main.tenants
      UNION ALL SELECT 'plans', count(*) FROM main.plans
      UNION ALL SELECT 'admin_audit_logs', count(*) FROM main.admin_audit_logs;"

# 4) K1b kapanış pini
DB_RUNTIME_PASSWORD=<.env'deki DB_PASSWORD ya da app_runtime parolası> \
DB_OPERATOR_PASSWORD=<app_operator parolası> \
bash scripts/verification/k1b-two-marker-pin.sh
```

## Pin GEÇERSE (exit 0) sırada olan

1. `scripts/db-roles/01-roles-and-ownership.sql:68-74`'teki *"K1a'NIN
   DENETİM-İZİ İDDİASI YOKTUR"* borç cümlesi **kalkar** — yerine *"K1b
   tamamlandı, `<tarih>`, pin: `k1b-two-marker-pin.sh` PASS"* satırı gelir.
2. `docker-compose.yml`'in K1b bloğundaki *"⚠️ logging_collector açmak
   container'ın YENİDEN YARATILMASINI gerektirir"* notu **kalıcı** kalır
   (gelecekteki bir yeniden-yaratmada aynı adımlar tekrar gerekir).
3. Tam `npm run test:e2e` koşulup **T-047** invaryantının (global-teardown.js)
   yeni container'a karşı da **PASS** verdiği doğrulanmalı — bu turda
   koşulamadı (aynı sandbox kısıtı, container henüz yeniden yaratılmadı).

## Pin KIRMIZI kalırsa (exit 1)

Muhtemel sebep: `log_line_prefix` `docker-compose.yml`'de doğru ama container
ESKİ ayarlarla (adım 1-2 atlanmış) çalışıyor olabilir — `SHOW log_line_prefix;`
ile doğrula. İkinci ihtimal: `psql` bağlantısı `application_name` set etmiyorsa
`%a` boş kalır (zararsız, `%u` yine ayrışmayı sağlar).
