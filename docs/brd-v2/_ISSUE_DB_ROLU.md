# ISSUE TASLAĞI — Ayrıcalıksız Veritabanı Rolleri (K-2.6.13)

> **Statü:** taslak — ürün sahibi incelemesi bekliyor. `B Dalgası` issue'sundan bağımsız,
> paralel yürür. Tek kesişim bilinçli: B migration'ı `app_migrate` ile koşar — iki iş
> birbirini test eder.
>
> Şablon: `codex_task.yml` alanları.

---

## Goal

Uygulamanın veritabanına **ayrıcalıksız bir runtime rolüyle** bağlanması ve migration
yetkisinin ayrı bir role taşınması:

```
app_runtime   DML · RLS'e TABİ · DDL yok · BYPASSRLS yok · tablo sahibi değil
app_migrate   DDL · yalnız migration koşusunda kullanılır · runtime bağlantısı yok
```

Bu, veritabanı izolasyonunun (`K-2.6.12`, Faz 1) **ön koşuludur** ve ondan önce
yapılmalıdır.

---

## Context

- **Ölçülmüş durum** (`K-2.6.13` gerekçesi): bugün tek giriş rolü var ve **ayrıcalıklı.**
  Ayrıcalıklı bir rol izolasyon politikalarına tabi değildir — politika yazılsa bile
  uygulanmaz, **ve testler yeşil geçer.** Bu issue o sessiz-yeşil sınıfını kapatır.
- İş iki adımdır ve ağırlığı ikincidedir: rolü *yaratmak* kolay; asıl iş **uygulamayı o
  rolle bağlayıp kırılan izinleri tek tek bulmak.** Bugünkü kod, ayrıcalıklı rolün örtük
  izinlerine (tablo sahipliği · sequence erişimi · şema hakları) yaslanıyor olabilir.
- `K-2.6.13a` (rol ayrımı kuralı) ve kabul testi tanımı ürün sahibi tarafından L2'ye
  paralel yazılıyor — bu issue o kurala atıf verir, tekrar etmez.

## Scope

### S1 · Rol tanımları
- `app_runtime`: `LOGIN`, `NOSUPERUSER`, `NOBYPASSRLS`, `NOCREATEDB`, `NOCREATEROLE`.
  Hiçbir tablonun sahibi değil. Başlangıç GRANT'i **boş** — izinler S3 envanterinden gelir.
- `app_migrate`: DDL yetkili; tablo sahipliği bu role (ya da ayrı bir `app_owner`'a —
  uygulama tercihi, gerekçesiyle PR'da). Runtime bağlantı dizgesinde **asla** kullanılmaz.
- Docker/compose ve `.env` şablonları iki bağlantı dizgesini ayrı taşır.

### S2 · Bağlantı ayrımı
- NestJS runtime bağlantısı → `app_runtime`.
- Migration koşusu (CLI / başlangıç hook'u) → `app_migrate`.
- Seed: hangi rolle koştuğu **açıkça** seçilir ve gerekçelendirilir (öneri: `app_migrate`
  — seed bir kurulum işlemidir, runtime işlemi değil).

### S3 · İzin envanteri (ölçüm çıktısı — saklanır)
Yöntem: rol yaratılır → test ortamında bağlanılır → **tam test suite koşulur** → düşen
her izin kaydedilir → yalnız düşenler `GRANT` edilir → suite yeşilenene kadar yinelenir.

Çıktı: `docs/verification/` altına **izin envanteri** — tablo başına fiilen kullanılan
haklar (`SELECT/INSERT/UPDATE/DELETE`, sequence `USAGE`). Bu envanter RLS politikaları
yazılırken (`K-2.6.12` işi) doğrudan girdidir.

⚠️ Toptan `GRANT ALL` **yasak** — envanterin varlık sebebi asgari kümeyi ölçmek.

### S4 · RLS sonda testi (kabul mekanizması)
Kalıcı bir test: geçici, **bilerek kısıtlayıcı** bir RLS politikası kurar →
`app_runtime` ile erişimin **reddedildiğini** doğrular → politikayı kaldırır → erişimin
döndüğünü doğrular.

> Bu, `K-2.6.13`'ün doğuş hatasının tersini sınar: rol gerçekten RLS'e tabi mi?
> `BYPASSRLS` ya da sahiplik sızıntısı varsa politika sessizce delinir — test onu ilk
> günden yakalar. Kırmızı-sonra-yeşil döngüsü testin kendisidir.

## Constraints

- Şema değişikliği YOK — bu issue tablolara dokunmaz (`B Dalgası`nın alanı).
- RLS politikalarının kendisi kapsam DIŞI (`K-2.6.12`, Faz 1) — yalnız sonda testi için
  geçici politika kurulup kaldırılır.
- `modes/` klasörüne dosya eklenmez (E1 guard).
- AI auto-merge yok; PR açılır ve durulur.

## Implementation Rules

- `docs/process/AI_PROMPT_PREAMBLE.md` uygulanır.
- Rol/GRANT komutları migration olarak değil, **idempotent kurulum betiği** olarak yaşar
  (roller küme-yönetimi nesnesidir, şema geçmişi değil) — betik tekrar koşulabilir.
- Yerel geliştirme ergonomisi korunur: tek komutla iki rollü ortam ayağa kalkar
  (compose + betik). NestJS yeniden başlatma gereksinimi (bilinen kısıt) dokümante edilir.

## Acceptance Criteria (hepsi ölçülebilir)

1. **Tam suite `app_runtime` altında yeşil** — birim + e2e, ayrıcalıklı role dönüş yok.
2. **RLS sonda testi** kırmızı-sonra-yeşil döngüsünü gösteriyor: kısıtlayıcı politika
   altında erişim reddi kanıtlanıyor, kaldırılınca dönüyor.
3. **Negatif yetki testleri:** `app_runtime` ile `CREATE TABLE` → reddedilir;
   `ALTER TABLE` → reddedilir; envanter dışı bir tabloya yazma → reddedilir.
4. **Rol öznitelik doğrulaması (sorgu):** `pg_roles`'ta `app_runtime` için
   `rolsuper = false`, `rolbypassrls = false`; hiçbir iş tablosunun sahibi
   `app_runtime` değil (`pg_tables.tableowner` sorgusu).
5. **İzin envanteri yazıldı** ve `GRANT` seti envanterle birebir — envanterde olmayan
   izin yok (fark sorgusu boş döner).
6. **Migration `app_migrate` ile koşuyor** — runtime dizgesiyle migration denemesi
   açık hata verir.
7. **Belge senkronu:** `K-2.6.13a` atfı doğru; E6 guard yeşil; bu issue'nun testleri
   ratchet listesine `K-2.6.13` kapsaması olarak girer.

## Verification

```
1. kurulum betiği: roller + GRANT (idempotent — iki kez koş, ikincisi no-op)
2. test suite (app_runtime)
3. RLS sonda testi
4. negatif yetki testleri
5. pg_roles / pg_tables doğrulama sorguları + GRANT-envanter fark sorgusu
6. migration koşusu (app_migrate) + runtime-dizgesiyle deneme (hata beklenir)
```

## Docs / Vault Impact

- İzin envanteri → `docs/verification/` (RLS işinin girdisi olarak işaretli)
- `EK_C` sözleşmeler bölümüne bağlantı-rolü notu
- `TEAM_LEAD` durum güncellemesi: `K-2.6.13` ⏳ → ✅
- Ortam kurulum belgesi (`LOCAL_SETUP` ailesi): iki bağlantı dizgesi

## Review Focus

1. **Sessiz geri dönüş yok** — hiçbir kod yolu, hata durumunda ayrıcalıklı role düşmüyor
   (bağlantı havuzu / hata yakalama dahil)
2. **Envanter asgari mi** — `GRANT` seti "suite'i yeşilleten asgari küme" mi, yoksa
   kolaycı genişlik mi
3. **Sahiplik haritası** — `app_migrate`/`app_owner` tercihi ve gerekçesi;
   `app_runtime`'ın sahip olduğu tek bir nesne bile kalmamalı
4. **B Dalgası kesişimi** — B migration'ının `app_migrate` ile koşacağı, B issue'suna
   tek satırlık bağımlılık notu olarak işlenir (iki iş birbirini test eder)
