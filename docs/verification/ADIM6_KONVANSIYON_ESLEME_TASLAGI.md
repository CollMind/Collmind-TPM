# `ADIM 6` — Konvansiyon eşleme TASLAĞI (Z55 §1.2) — TEAM LEAD ONAYI BEKLİYOR

> **Tarih:** 2026-08-28 · **Ölçen:** backend-engineer (ADIM 6 dalgası)
> **Statü:** ⏳ **TASLAK** — `docs/process/DENETIM_SOZLUGU.md`'ye bu belgenin İÇERİĞİ
> AKTARILMADI. O dosyanın kendi başlığı: *"Kanal: yalnız Team Lead yazar (L2 ile
> aynı gerekçe: tek yazar, tek kanal)"* — backend-engineer bu kanalın DIŞINDA.
> Bu belge Team Lead'e bir **girdi**, bir **karar** değil.

## `1` — TAZE ENVANTER (S1–S4 yöntemiyle karşılaştırılabilir kaynaktan)

### `1a` DB'deki fiili satırlar (39, `main.admin_audit_logs`, ölçüm: 2026-08-28)

```sql
SELECT action_type, entity_type, count(*) FROM main.admin_audit_logs GROUP BY 1,2 ORDER BY 1,2;
```

| action_type | entity_type | adet |
|---|---|---|
| APPROVE | AGREEMENT | 3 |
| CREATE | mechanic | 3 |
| DELETE | mechanic | 1 |
| SALES_ACTUALS_UPLOAD | SalesActualBatch | 21 |
| SUBMIT | AGREEMENT | 3 |
| UPDATE | mechanic | 8 |

**39 satır, 6 kombinasyon.** Bu, `Z55`'in *"sayı `Z51`'de 39'du, yeniden say"* şartını
karşılar — **39 doğrulandı, TAZE ölçümle.**

### `1b` Kod-seviyesi TAM envanter (17 üretim çağrı noktası, 7 dosya — Z51 §5 ile birebir)

DB'deki 39 satır yalnız BUGÜNE KADAR üretilmiş olanı gösterir; `SALES_ACTUALS_REPLACE`,
`CLOSE`, `REJECT`, `CANCEL`, `REVERSE`, `SCOPE_UPDATE`, `SCOPE_REVOKE_ALL`, `CHANNEL`
CRUD'ı bu DB'de **hiç tetiklenmemiş** (0 satır) ama koddan ÜRETİLEBİLİR — eşleme
tablosu bu yüzden `1a` değil `1b`'yi taban alır (aksi hâlde 8 canlı olay türü sözlük
dışı kalırdı, hiç görülmeden).

| # | action_type (kod) | entity_type (kod) | dosya:satır | DB'de gözlemlenen mi |
|---|---|---|---|---|
| 1 | `CLOSE` | `AGREEMENT` | settlement-close.service.ts:178 | ❌ |
| 2 | `UPDATE` | `AGREEMENT` | agreement.service.ts:536 | ❌ |
| 3 | `SUBMIT` | `AGREEMENT` | agreement.service.ts:651 | ✅ (3) |
| 4 | `APPROVE` | `AGREEMENT` | agreement.service.ts:797 | ✅ (3) |
| 5 | `REJECT` | `AGREEMENT` | agreement.service.ts:918 | ❌ |
| 6 | `CANCEL` | `AGREEMENT` | agreement.service.ts:1099 | ❌ |
| 7 | `SALES_ACTUALS_REPLACE` | `SalesActualBatch` | sales-actuals.service.ts:264 | ❌ |
| 8 | `SALES_ACTUALS_UPLOAD` | `SalesActualBatch` | sales-actuals.service.ts:305 | ✅ (21) |
| 9 | `SCOPE_UPDATE` | `user` | user.service.ts:154 · :683(koşullu) | ❌ (sözlük Madde 1'de zaten TANIMLI) |
| 10 | `SCOPE_REVOKE_ALL` | `user` | user.service.ts:683(koşullu) | ❌ (sözlük Madde 1'de zaten TANIMLI) |
| 11 | `REVERSE` | `AGREEMENT_TRANSACTION` | reversal.service.ts:175 | ❌ |
| 12 | `CREATE` | `mechanic` | mechanic.service.ts:218 | ✅ (3) |
| 13 | `UPDATE` | `mechanic` | mechanic.service.ts:346 | ✅ (8) |
| 14 | `DELETE` | `mechanic` | mechanic.service.ts:375 | ✅ (1) |
| 15 | `CREATE` | `CHANNEL` | channel.service.ts:50 | ❌ |
| 16 | `UPDATE` | `CHANNEL` | channel.service.ts:113 | ❌ |
| 17 | `DELETE` | `CHANNEL` | channel.service.ts:148 | ❌ |

**17 kod-seviyesi çağrı = 17 satır.** `39 DB satırı` bunların yalnız `6`'sının
(3+4+8+12+13+14 numaralı satırlar — ki `9`/`10` zaten sözlükte, hariç tutulmadı)
**tekrarlı** gerçekleşmesidir; kalan **11 olay türü hiç canlı örneği olmadan**
sözlük eşlemesi ister (Z55 §1.2: *"eşlenemeyen bir değer sözlüğün eksikliğini
gösterebilir"* — burada tersi: DB'de HİÇ görülmeyen bir kod-yolu, "sözlüğe aday"
listesinden düşürülemez, çünkü canlı çağrı yolu VAR, yalnız bu dev DB'de
tetiklenmemiş).

## `2` — CASING/KONVANSİYON ANALİZİ (Z51 §5'in ölçtüğü kusur)

```
BÜYÜK HARF (SNAKE)   AGREEMENT · AGREEMENT_TRANSACTION · CHANNEL
küçük harf            mechanic · user
PascalCase             SalesActualBatch
```

Üç ayrı casing konvansiyonu TEK bir `varchar entity_type` kolonunda — `Z51 §5`'in
bulgusu TAZE ölçümle DOĞRULANDI, değişmedi.

## `3` — EŞLEME TABLOSU (STATÜ sütunu — Z55 §1.2)

**Sözlüğün bugünkü hâli** (`docs/process/DENETIM_SOZLUGU.md`) yalnız **`Madde 1`**
(`SCOPE_CHANGE`, `entity_type='user'`) tanımlıyor. Geri kalan **15** kod-seviyesi
(action_type, entity_type) çifti (17 - 2 sözlük-Madde-1-satırı) için **sözlükte
karşılık YOK** — hepsi **ADAY** statüsünde.

| kod (action_type/entity_type) | sözlük karşılığı | STATÜ |
|---|---|---|
| `SCOPE_UPDATE` / `user` | `Madde 1` — birebir | ✅ **birebir** |
| `SCOPE_REVOKE_ALL` / `user` | `Madde 1` — birebir | ✅ **birebir** |
| `CLOSE`/`UPDATE`/`SUBMIT`/`APPROVE`/`REJECT`/`CANCEL` / `AGREEMENT` | yok | 🆕 **SÖZLÜKTE-YOK → ADAY**: önerilen aile adı `AGREEMENT_LIFECYCLE`, `entity_type` kanonik **büyük-harf** korunabilir (zaten çoğunluk — 3/3 casing örneği büyük harf) |
| `REVERSE` / `AGREEMENT_TRANSACTION` | yok | 🆕 **ADAY**: `AGREEMENT_LIFECYCLE` ailesinin mi yoksa AYRI bir `LEDGER_REVERSAL` maddesinin mi parçası olacağı — **Team Lead/ürün sahibi kararı** (REVERSE finansal-tersine-çevirme, CLOSE/SUBMIT/APPROVE durum-geçişi; farklı risk sınıfı, `isHighRiskAction`'da zaten AYRI satırlar) |
| `SALES_ACTUALS_UPLOAD`/`SALES_ACTUALS_REPLACE` / `SalesActualBatch` | yok | 🆕 **ADAY**: `entity_type` bugün **PascalCase** (TypeORM sınıf adı sızıntısı — `SalesActualBatch` sınıf adının BİREBİR kopyası, DB kolonu string). Kanonik ad **büyük-harf-snake** olacaksa (`SALES_ACTUAL_BATCH`) bu bir **KIRILAN** eşleme (birebir değil, dönüştürme ister) |
| `CREATE`/`UPDATE`/`DELETE` / `mechanic` | yok | 🆕 **ADAY**: `entity_type` bugün **küçük harf** — kanonik büyük-harfe çevrilecekse (`MECHANIC`) **KIRILAN** eşleme |
| `CREATE`/`UPDATE`/`DELETE` / `CHANNEL` | yok | 🆕 **ADAY**: zaten büyük harf — **birebir** aday (dönüştürme gerekmez) |

### ⛔ SÖZLÜK DE SINANDI (Z55 §1.2: tek yönlü itaat değil)

`Madde 1`'in kendi alan sözleşmesi (*"hedef = KULLANICI, kapsam satırı DEĞİL"*,
*"niyet kayıtta AYRI alan değil"*) yalnız `SCOPE_CHANGE`'e özgü — CRUD ailesi
(`mechanic`/`CHANNEL`) ve yaşam-döngüsü ailesi (`AGREEMENT`) için **doğrudan
uygulanamaz** (onların `before`/`after` zaten `beforeValues`/`afterValues`
kolonlarında, "eski küme/yeni küme" kavramı yok). **Bu sözlüğün eksikliğinin
kanıtı**: `Madde 1` deseni diğer 15 çift için kalıp olarak YETMİYOR, ayrı
madde(ler) gerekiyor — Z55 §1.2'nin öngördüğü tam senaryo.

## `4` — VERİ KATMANI: DOKUNULMADI (Z55 §1.3 doğrulaması)

```bash
docker exec -i collmind-tpm-postgres psql -U app_operator -d collmind_tpm -t -A \
  -c "SELECT count(*) FROM main.admin_audit_logs;"   # önce: 39
# (bu tur boyunca hiçbir UPDATE/DELETE main.admin_audit_logs'a çalıştırılmadı)
docker exec -i collmind-tpm-postgres psql -U app_operator -d collmind_tpm -t -A \
  -c "SELECT count(*) FROM main.admin_audit_logs;"   # sonra: 39
```
Satır sayısı **39 → 39**, ve `SELECT action_type, entity_type, count(*) GROUP BY 1,2`
çıktısı bu turun başında/sonunda **birebir aynı** (bkz. `§1a`). `UPDATE` YAZILMADI.

## `5` — AÇIK KALAN NOKTA (Team Lead'e)

Yukarıdaki eşleme tablosu **öneri**dir, **hüküm değildir**. Üç açık soru:

1. `AGREEMENT` yaşam-döngüsü olayları (`CLOSE`/`SUBMIT`/`APPROVE`/`REJECT`/`CANCEL`)
   TEK bir Madde mi, yoksa her biri ayrı mı (Madde 1'in `SCOPE_UPDATE`/`SCOPE_
   REVOKE_ALL` ayrımına benzer bir "durum geçişi ayrı olay türüdür" mantığı burada
   da uygulanır mı)?
2. `REVERSE`/`AGREEMENT_TRANSACTION` `AGREEMENT` ailesinin mi parçası, yoksa finansal
   tersine-çevirmenin kendi ailesi mi (`LEDGER_REVERSAL`)?
3. `entity_type` kanonik casing'i **BÜYÜK-HARF-SNAKE** olacaksa `mechanic`→`MECHANIC`
   ve `SalesActualBatch`→`SALES_ACTUAL_BATCH` dönüşümleri KOD DEĞİŞİKLİĞİ ister
   (yalnız yeni satırlar için — `§3 VERİ KATMANINA DOKUNULMAZ`); bu üç kod dosyasının
   (`mechanic.service.ts`, `sales-actuals.service.ts`) literal string'lerinin
   DEĞİŞTİRİLMESİ ayrı bir backend task'tır (bu tur kapsamında YAPILMADI — sözlük
   hükmü olmadan bir ad seçip koda yazmak "ajanın varsayımı" olurdu).

⛔ **Ratchet guard'ı (Z55 §2, "yeni satırda eski-biçim → kırmızı") bu üç sorunun
cevabına bağımlı — cevapsız bir sözlüğe karşı ratchet yazmak, ratchet'in kendi
doğruluğunu Team Lead onayı olmadan varsaymak olurdu. Bu tur BEKLETİLDİ, DUR.**
