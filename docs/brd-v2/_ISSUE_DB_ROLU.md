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

### S1 · Rol tanımları — `K-2.6.13a` (iki rol) · `K-2.6.13b` (sahiplik)
- `app_runtime`: `LOGIN`, `NOSUPERUSER`, `NOBYPASSRLS`, `NOCREATEDB`, `NOCREATEROLE`.
  Hiçbir tablonun sahibi değil. Başlangıç GRANT'i **boş** — izinler S3 envanterinden gelir.
- `app_migrate` (`K-2.6.13b`): DDL yetkili, **ve tablo sahibi.** Runtime bağlantı
  dizgesinde **asla** kullanılmaz.

  > ⚠️ **DÜZELTİLDİ (2026-08-15):** taslak burada *"ya da ayrı bir `app_owner`'a — uygulama
  > tercihi"* diyordu. **`K-2.6.13b` o tercihi kapatmış:** *"Tablo sahibi `app_migrate`'tir.
  > Ayrı bir sahip rolü tanımlanmaz."* Gerekçesi de yazılı: sahipliğin koruduğu şey
  > (*sahip politikalara tabi değildir*) `app_runtime` sahip olmadığı için **zaten sağlanıyor**;
  > üçüncü rol ancak kanıtlanmış ihtiyaçla gelir (`İlke 1`).
  >
  > 📌 Bu sapma, issue'nun `b`–`f`'ye atıf vermemesinin **ölçülmüş bedeli**: `L2` kararı
  > vermişti, issue onu açık bir tercih gibi taşıyordu.
- Docker/compose ve `.env` şablonları iki bağlantı dizgesini ayrı taşır.

### S2 · Bağlantı ayrımı
- NestJS runtime bağlantısı → `app_runtime`.
- Migration koşusu (CLI / başlangıç hook'u) → `app_migrate`.
- Seed: hangi rolle koştuğu **açıkça** seçilir ve gerekçelendirilir (öneri: `app_migrate`
  — seed bir kurulum işlemidir, runtime işlemi değil).

### S3 · İzin envanteri — `K-2.6.13f`
Yöntem: rol yaratılır → test ortamında bağlanılır → **tam test suite koşulur** → düşen
her izin kaydedilir → yalnız düşenler `GRANT` edilir → suite yeşilenene kadar yinelenir.

Çıktı: `docs/verification/` altına **izin envanteri** — tablo başına fiilen kullanılan
haklar (`SELECT/INSERT/UPDATE/DELETE`, sequence `USAGE`). Bu envanter RLS politikaları
yazılırken (`K-2.6.12` işi) doğrudan girdidir.

⚠️ Toptan `GRANT ALL` **yasak** — envanterin varlık sebebi asgari kümeyi ölçmek.

### S4 · RLS sonda testi — `K-2.6.13e`
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
- Rol/GRANT komutları migration olarak değil, **idempotent kurulum betiği** olarak yaşar (`K-2.6.13c`)
  (roller küme-yönetimi nesnesidir, şema geçmişi değil) — betik tekrar koşulabilir.
- Yerel geliştirme ergonomisi korunur: tek komutla iki rollü ortam ayağa kalkar
  (compose + betik). NestJS yeniden başlatma gereksinimi (bilinen kısıt) dokümante edilir.

## Acceptance Criteria (hepsi ölçülebilir)

1. **Tam suite `app_runtime` altında yeşil** (`K-2.6.13`) — birim + e2e.
   ⚠️ *"Ayrıcalıklı role dönüş yok"* ibaresi buradan ÇIKARILDI ve `AC#8`'e taşındı:
   **yeşil bir suite o yolu hiç tetiklemez** (aşağıya bkz.).
2. **RLS sonda testi KALICI SUITE'TE** (`K-2.6.13e`) — kırmızı-sonra-yeşil döngüsü:
   kısıtlayıcı politika altında erişim reddi kanıtlanıyor, kaldırılınca dönüyor.

   ⚠️ **Bir kez gösterilmesi YETMEZ.** Test `npm test` / `npm run test:e2e` ile koşan
   kalıcı bir dosyada yaşar ve her koşumda çalışır. Bir defalık bir prosedür olarak
   koşulursa **bir kez koşulur, sonra unutulur** — ve `K-2.6.13`'ü doğuran sessiz-yeşil
   sınıfı geri döner, bu kez korunuyor sanılarak.

   Kanıt: testin dosya yolu + suite koşumunda göründüğü satır.
3. **Negatif yetki testleri:** `app_runtime` ile `CREATE TABLE` → reddedilir;
   `ALTER TABLE` → reddedilir; envanter dışı bir tabloya yazma → reddedilir.
4. **Rol öznitelik doğrulaması (sorgu):** `pg_roles`'ta `app_runtime` için
   `rolsuper = false`, `rolbypassrls = false`; hiçbir iş tablosunun sahibi
   `app_runtime` değil (`pg_tables.tableowner` sorgusu).
5. **İzin envanteri yazıldı** (`K-2.6.13f`) ve `GRANT` seti envanterle birebir —
   envanterde olmayan izin yok (fark sorgusu boş döner).

   ⚠️ **Yol AÇIKÇA:** `docs/verification/DB_ROL_IZIN_ENVANTERI.md` — **meta repoda**
   (`CLAUDE.md §5`: ölçüm/karar belgeleri meta'da yaşar; submodule'lerde yalnız
   *kodun okuduğu* artefaktlar bulunur). Bu envanteri okuyan bir kod yolu yok, yani
   `collmind.backend/docs/` **değil.**
6. **Migration `app_migrate` ile koşuyor** — runtime dizgesiyle migration denemesi
   açık hata verir.
7. **Belge senkronu:** `K-2.6.13a`–`K-2.6.13f` atıfları doğru; E6 guard yeşil (sarkan
   atıf taraması bu dosyayı da kapsıyor — ölçüldü: `grep -rh '\`K-' "$PKG" --include='*.md'`).

8. ⚡ **SESSİZ GERİ DÖNÜŞ YOK — iki bacak, ikisi de zorunlu** (`K-2.6.13d`).

   `AC#1`'in yeşili bunu **kanıtlayamaz**: sessiz geri dönüş bağlantı hatasında ateşlenir,
   ve suite yeşilken o yola hiç girilmez. Kayıtlı sınıf: *"bir doğrulamanın 'çalıştığı'
   sanılması, girdinin ona hiç ULAŞMAMASINDAN gelebilir."*

   ```
   (a) VARLIK    ayrıcalıklı dizge/kimlik runtime kod yolunda SIFIR kez geçiyor
                 — grep, ve POZİTİF KONTROL ile (desenin çalıştığı gösterilir)
   (b) DAVRANIŞ  bağlantı KASTEN bozulur (yanlış parola / çekilmiş GRANT) →
                 uygulama HATA verir, ayrıcalıklı role DÖNMEZ
   ```

   ⚠️ **Biri olmadan diğeri eksik:** `grep` bir yolun *var olmadığını* ölçer ama
   çalışma zamanında türetilen bir dizgeyi göremez; kasten bozma *davranışı* ölçer ama
   tetiklemediği bir dalı göremez. İkisi farklı kör noktaya sahiptir.

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
3. **Sahiplik haritası** (`K-2.6.13b`) — tablo sahibi `app_migrate`; `app_runtime`'ın
   sahip olduğu tek bir nesne bile kalmamalı. ⚠️ `app_owner` **tercih değildir**, kapalıdır.
4. **B Dalgası kesişimi** — B migration'ının `app_migrate` ile koşacağı, B issue'suna
   tek satırlık bağımlılık notu olarak işlenir (iki iş birbirini test eder)
