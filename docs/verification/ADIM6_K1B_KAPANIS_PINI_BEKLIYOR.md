# ✅ `K1B` KAPANIŞ PİNİ — **GEÇTİ** (2026-08-28)

> **Bu belge bir BEKLEME belgesiydi. Bekleme bitti.**
> Aşağıdaki özgün metin `F12` gereği **silinmedi** — pinin neden beklediği
> ve nasıl kapandığı kayıtta kalır.

## SONUÇ

```
bash scripts/verification/k1b-two-marker-pin.sh
PIN EXIT=0

  app_runtime@   satırı: 1
  app_operator@  satırı: 4
  ✅ PASS — iki bağlantı, MARKER METNİ OLMADAN, u= alanıyla ayrışıyor
```

### Ön koşullar `[ÖLÇÜLDÜ]` — pin öncesi
```
container   collmind-tpm-postgres   Up (healthy)   0.0.0.0:5434->5432/tcp
volume      collmind-tpm-postgres-data · collmind-tpm-postgres-logs  (İKİSİ DE PİNLİ)
GUC         logging_collector=on · log_line_prefix=%m [%p] %u@%d %a
            log_connections=on · log_statement=all
veri        dört-tablo korunum sayımı 1/9/5/39 (ürün sahibi doğruladı)
```

### ⛔ İKİ ADIMLI KOŞUM — ve birincisi bir BULGU

```
1. tur   bash k1b-two-marker-pin.sh              →  EXIT 2
         "DB_RUNTIME_PASSWORD / DB_OPERATOR_PASSWORD verilmedi — ölçüm yapılamadı"
2. tur   set -a; . ./.env; set +a  +  aynı komut →  EXIT 0
```

📌 **Birinci tur bir başarısızlık değil, sözleşmenin işlemesidir:** script kimlikleri
**ortam değişkeninden** okur, `.env`'den değil. Kimlik yokken **sahte `PASS`
üretmedi** — *"ölçemedim"* dedi (`exit 2`, kapının **üçüncü meşru çıktısı**).

### ⭐ VE PİN, `ADIM 6` REVIEW'ÜNÜN `B1` DÜZELTMESİNİ CANLI DOĞRULADI

```
DÜZELTME ÖNCESİ   grep "u=app_runtime,"     ← VİRGÜLLÜ, prefix'te böyle bir şey YOK
                  ⇒ MATEMATİKSEL OLARAK GEÇEMEZDİ
                  ⇒ ve hata mesajı insanı "%u eksik olabilir" diye YANLIŞ SEBEBE
                    gönderirdi (%u VARDI)
DÜZELTME SONRASI  grep "] app_runtime@"      ← prefix'le hizalı
BUGÜN             EŞLEŞTİ
```

> **Düzeltme olmasaydı bu pencere YANLIŞ SEBEPLE kırmızı verecekti** — ve insan
> eylemi gerektiren bir pencere **ikinci kez** açılmak zorunda kalırdı.

## BUNUNLA KAPANAN BORÇ

`Z52 §3`: *"`K1b` kapanmadan **'operatör denetim-olaylıdır'** cümlesi HİÇBİR BELGEDE
KURULAMAZ."* ⇒ **Artık kurulabilir.** `01-roles-and-ownership.sql`'deki borç cümlesi
`F12` iziyle kapatıldı (üstü çizildi, silinmedi).

**Üç parçanın üçü de ölçüldü:**

| parça | nerede | kanıt |
|---|---|---|
| **NE** | `log_statement=all` (rol seviyesi) | `01-roles-and-ownership.sql` |
| **KİM** | `log_line_prefix` `%u` | pin: `app_runtime@` 1 · `app_operator@` 4 |
| **KALICILIK** | `logging_collector=on` + `-logs` volume | `docker rm` **iz bırakır** |

⛔ **VE BİR SINIR YAZILDI:** üç parçadan **ikisi ortam seviyesindedir**
(`docker-compose.yml`), `01-roles-and-ownership.sql` **değil** — yani taze bir
kurulumda **o dosya tek başına denetim izini SAĞLAMAZ**. Kapısı: ilk-deploy ön koşulu
`4` (**compose-tanımı ↔ canlı-container eşleşmesi**).

---

---

# 📄 ÖZGÜN METİN (bekleme dönemi — `F12`, silinmedi)

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
