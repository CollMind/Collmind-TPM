# `ADIM 6` — DENETİM ÇEKİRDEĞİ · BRIEF

**Tarih:** 2026-08-28 · **Hazırlayan:** Team Lead · **Karar:** ürün sahibi
**Girdi:** `Z51` (envanter) · `Z52` (altı hüküm) · `Z53` (dış-girdi) · `K1a` (indi)
**Statü:** ⏳ **ONAY BEKLER**

> ## ⛔ TURUN TÜRÜ
> **Dört bileşen İNŞA + iki hüküm.** `K1a`'nın **sağlayıcı borcunu KAPATIR** — ve o borç
> kapanmadan ***"operatör denetim-olaylıdır"* cümlesi hiçbir belgede kurulamaz**
> (`Z52 §3`, ve bu cümle `03-operator-grants.sql`'in **içinde** yazılı).

---

# BİLEŞEN 1 — `K1b` SAĞLAYICI BORCU

`Z51 §1` ölçtü: **üç alandan BİRİ** karşılanıyor.

| alan | bugün | gereken |
|---|---|---|
| **ne** (statement) | ✅ `log_statement` **rol seviyesinde** | — |
| **kim** (aktör) | ❌ `log_line_prefix = '%m [%p] '` — **`%u` YOK** | `%u` (+ `%d`, `%a`) · `ctx=sighup` ⇒ **küme** seviyesi |
| | ❌ `log_connections = off` · `ctx=superuser-backend` | ⛔ **rol seviyesinde REDDEDİLDİ** (ölçüldü, `EXIT=1`) ⇒ `postgresql.conf` |
| **kalıcılık** | ❌ `logging_collector = off` · `ctx=postmaster` | `on` + log dizini **VOLUME**'a ⇒ **container yeniden yaratma** |

⛔ **`CLAUDE.md §2.3`:** *"Audit: **immutable**; silinemez."* Bir **`docker rm`** ile yok
olan `stdout` akışı bunu **karşılamaz**.

### ⛔ KAPANIŞ PİNİ — İKİ-MARKER AYIRT ETME (bu kez **GEÇMESİ BEKLENEN** hâliyle)

`Z51`'de bu pin **KIRMIZI** idi:
```
LOG: statement: SELECT 'MARKER_APP_RUNTIME_PIN_A1';
LOG: statement: SELECT 'MARKER_OPERATOR_PIN_B7';
⇒ İKİ SATIR BİRBİRİNDEN AYIRT EDİLEMİYOR   (ayıran tek şey: enjekte edilen METİN)
```
**Bu turun kabulü:** aynı pin, **marker metni OLMADAN** koşar ve **`u=app_operator` vs
`u=app_runtime`** ile **ayrışır**.
> ⛔ **Pin geçmeden `K1b` kapanmaz** — ve borç cümlesi `03-operator-grants.sql`'den
> **ancak o zaman** kalkar.

### Kapsam ayrımı (`Z53 §3` girdi eşlemesi)
```
BUGÜN         logging_collector + log_line_prefix %u + volume-kalıcılık
DEPLOY-ÇAĞI   WORM/S3 · CDC          ⇒ ilk-deploy ön-koşul listesine SATIR
FAZ-3 ADAY    pgAudit DAR KAPSAM     [dış-girdi, doğrulanmadı: "%15-25 throughput"]
```
⚠️ **Çift-yazım seçilirse:** raporun *"dual-write problemi"* uyarısı, bizim
**sessiz-düşen-audit-INSERT** dersimizle **BİRLEŞİK** okunur — tek başına bir başlıktır.

---

# BİLEŞEN 2 — `#5` KONVANSİYON KARARI (`Z52 §6`)

**Ölçülen canlı ayrışma:**
```
AGREEMENT (BÜYÜK) · mechanic (küçük) · SalesActualBatch (PascalCase)
⇒ TEK BİR varchar KOLONDA ÜÇ HARF KONVANSİYONU
```

**Bu turda:**
1. **Konvansiyon KARARI** — `DENETIM_SOZLUGU`/`Z15` ailesine bağlı. *(Üç-harf
   yaşayacaksa **gerekçesiyle**.)*
2. ⛔ **Mevcut satırların sözlüğe EŞLEMESİ — TAZE ÖLÇÜMLE** *(sayı `Z51`'de `39`'du;
   **yeniden say**, bayat olabilir)*
3. **Kader** (`migrate` / `tolere` / `dondur`) → **eşlemenin SONUCUNA hüküm olarak biner**

⛔ **Veri-katmanında YARI-NORMALİZE dokunuş bu turda `İlke-4` RİSKİDİR** — eşleme
çıkmadan `UPDATE` yazılmaz.

---

# BİLEŞEN 3 — OLAY ENVANTERİ (**taze sayım ŞART**)

```
Z51 taze     107 yazma ucu  ↔  17 logAdminAction (7 dosyada)
ADIM 2       119 yazma ucu  ↔  15 denetim üreten
⛔ İKİSİ KARŞILAŞTIRILAMADI — farklı yöntem, ve farkın KAYNAĞI gösterilemedi
```

⛔ **Bu tur `ADIM 2`'nin `S1–S4` SINIFLANDIRMASINI YENİDEN UYGULAR** — yarım günlük iş,
ve **karşılaştırılabilir** bir sayı üretmenin **tek yolu**.
*(`DISIPLIN`: bir sayım farkı, kaynağı gösterilmeden **yorumlanamaz**.)*

**Ve bilinen boşluklar doğrulanır:**
- `plan` yaşam-döngüsü ve `auth` → denetim üretimi **SIFIR** (`ADIM 2` bulgusu, `Z51`'de **hâlâ geçerli**)
- `§2.5` **sessiz atlama**: `if (adminId && adminEmail)` — `else` **YOK**, **6 vaka**
- Değişmezlik: `app_runtime`'da `DELETE` **yok** (kolon-GRANT gerçek mekanizma) ama
  **SAHİBE karşı koruma YOK** · `trigger` sayısı **0** ⇒ **`K-2.11.7` AÇIK**

---

# BİLEŞEN 4 — `T-314` KALINTILARI *(bu dalganın parçası)*

| # | kalem |
|---|---|
| `A` | ⛔ **Operatör GRANT drift guard'ı YOK** — `Z51 §2`'nin kayıtsız-sapma vakasının **yeni roldeki tekrarı** |
| `B` | `NULL tenant_id`'nin ne **yazıcısı** ne **okuyucusu** var (`logAdminAction` üç overload'ında `tenantId: string`) ⇒ `Z52 §2`'nin yeteneği **erişilemez** |
| `C` | ⛔ **ARŞİV ADIMI YOK** — `RESTRICT` sıranın **ikinci** yarısını zorluyor, **birincisi hiç yazılmadı** |
| `D` | `schema-isolation.sh` **backend-only ağaçta koşmuyor** (`git worktree` = `T-269`'un tavsiyesi) |

---

# ⛔ EK 1 — İKİ KAPI (`Z53 §4`)

### `a` · **BYPASSRLS-HİJYEN**
```
app_runtime'da BYPASSRLS/SUPERUSER  →  YOK
BYPASSRLS taşıyan rol               →  KAYITLI LİSTE (bugün: app_operator, Z51 kaydıyla)
evren pg_roles'tan TÜRETİLMİŞ  ·  ÜÇ MEŞRU ÇIKTI  ·  MUTASYONLA kanıtlı
```
📌 **Doğum gerekçesi `Z51 §2`:** bir rol ayarı canlıda **elle** değişti ve **hiçbir kapı
görmedi**. Bu kapı tam o boşluğu kapatır.
⚠️ Ve `Bileşen 4/A` ile **kardeş**: biri **rol bayraklarını**, diğeri **GRANT'leri** tutar.

### `b` · **YENİ-TABLO-RLS**
```
tenant_id taşıyan tablo RLS-etkin DEĞİLSE  →  KIRMIZI
statü: AKTİVASYONA KADAR blocked  ·  AÇILMA KOŞULU YAZILI
```
⇒ **`T-308` deseni:** kapı **doğar ama `blocked` durur**. *"Sessizce ertelenemez"*
kuralının kapı tarafı.

---

# ⛔ EK 2 — `FORCE RLS` HÜKMÜ **BU TURDA VERİLİR**

**Girdi hazır:**
```
ölçüm (Z51)   main'de 48/48 tablo sahibi app_migrate · relforcerowsecurity 48/48 = f
              uygulama app_runtime ile bağlanıyor (SAHİP DEĞİL)
              ⇒ izolasyon için FORCE GEREKMİYOR
              ⇒ FORCE AÇILIRSA migration/seed (app_migrate) KIRILIR
dış-girdi     rapor §3: FORCE = OWNER-MUAFİYETİNE KARŞI DERİNLİK-SAVUNMASI
              [dış-girdi, doğrulanmadı]
              ve bizim owner/DML-only ayrımımız endüstri deseniyle ÖRTÜŞÜYOR
```

**İki seçenek:**
| | |
|---|---|
| **(i)** `FORCE` **kapalı** | migration/seed **doğal bypass** · bugünkü şekil · derinlik-savunması **yok** |
| **(ii)** `FORCE` **açık** + `app_migrate`'e **açık muafiyet politikası** | derinlik-savunması **var** · migration yolu **politikayla** açılır ⇒ bir **politika satırı** daha |

⚠️ **Aktivasyon deploy-eşiğinde** — bu hüküm **şekli** belirler, **açmaz**.

---

# ⛔ KABUL
- [ ] `docker ps --filter "label=com.docker.compose.project=tpm"` **birinci madde**
- [ ] ⛔ **İKİ-MARKER PİNİ GEÇİYOR** — marker metni **olmadan**, `u=` alanıyla ayrışıyor
- [ ] Borç cümlesi `03-operator-grants.sql`'den **kalkıyor** *(ve **ancak** pin geçtiyse)*
- [ ] Olay envanteri **`S1–S4` yöntemiyle**, `ADIM 2` ile **karşılaştırılabilir**
- [ ] Konvansiyon eşlemesi **taze**; `UPDATE` **yazılmıyor** (kader ayrı hüküm)
- [ ] İki kapı: **mutasyonla kanıtlı**, `run-all`'a **bağlı**, **self-test'li**, **üç çıktı**
- [ ] `npm run guards` **exit 0** · `tsc` 0 · unit yeşil · **e2e yeşil** · `T-047` **PASS**
- [ ] `logging_collector` açılırsa: **container yeniden yaratma** ve `T-047` etkisi **ölçülür**

# ⛔ ÖLÇÜM DİSİPLİNİ
Exit kodunu **boruya sokma** · ⛔ **`git stash` YASAK** *(iki ihlal; **üçüncüsünde ARAÇ**)* ·
`git checkout` ile geri alma **YASAK** · **`zsh` glob'larını TIRNAKLA** · her **negatif**
bulguya **POZİTİF KONTROL** · **`§7`: yeni kod yazmadan önce ARA** ·
⛔ **canlılık probu ASIL KONTROLÜN yüzeyinde** (`K1a` review `B3` dersi) ·
⛔ **dış-girdi `[dış-girdi, doğrulanmadı]` etiketiyle anılır** (`Z53 §1`).
