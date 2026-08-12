# 0068 — Hakediş (claim) katmanının **CTPM'deki bugünkü durumu** — kod ölçümü

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR — hiçbir dosya değiştirilmedi.
- **Neden:** İki dokümanda *"bu katman yok"* yazıldı ve o bir **çıkarımdı** (ekran
  envanterinden türetildi, koddan değil). İki farklı büyüklükte iddia vardı:
  **(a)** katman tümüyle yok → sıfırdan tasarım · **(b)** üretim var, alım/eşleştirme yok
  → bir arayüz + eşleştirme mantığı. Fark `BRD v2 L1 §1.7`'nin kapsamını belirliyor.

## 0. Ölçüm ortamı (ZORUNLU)

| | değer |
|---|---|
| meta | `Collmind-TPM` @ `35b3b1d`, branch `claude/0058-measurement-config-y6xz2z` |
| **backend** | **`collmind.backend` @ `5743c6e`** — bu oturumda `git submodule update --init` ile **ilk kez checkout edildi** (önceki turlar `0059`–`0067` kod okuyamıyordu) |
| **frontend** | `collmind.frontend` @ `d9bedc5` — checkout edildi |
| kapsam | **CTPM**. TTM ölçülmedi. |
| yöntem | `grep -rn` / `-c` **sayım**; `grep -l` ve `head` **yokluk iddiası için kullanılmadı**; her terim sayımı **örneklenerek** anlamı doğrulandı |
| ⚠️ | Bir ölçüm yanlış dizinde koştu (`reconciliationPeriod`, frontend'de) ve **mutlak yolla tekrarlandı**. Aşağıdaki sayı backend'dendir. |

---

## Özet — beş madde

| # | madde | durum | erişilebilirlik (`§4.2`) |
|---|---|---|---|
| 1 | **Varlık** (claim entity/tablo/migration) | **YOK** | — |
| 2 | **Üretim** (hakediş talebi üreten akış) | **VAR** — başka adla (`agreement_transaction`) | ✅ 4 HTTP rota + canlı UI |
| 3 | **Alım** (dışarıdan gelen talep) | **KISMEN** — tek yönlü | ✅ dosya + manuel giriş yolu var |
| 4 | **Eşleştirme** (talep ↔ anlaşma) | **YOK** — *lookup* var, *matching* yok | — |
| 5 | **Mutabakat & kapanış** | **KISMEN** — anlaşma kapanışı var, **dönem kapanışı yok** | ⚠️ API var, **UI yok** |

> ### Cevap: **(a) yanlış, (b) yaklaşık doğru — ama iki düzeltmeyle.**
> Üretim **var** ve olgun; eksik olan yalnız *"alım/eşleştirme"* değil, **claim nesnesinin
> kendisi** ve **dönem kapanışı**. Ve mevcut kapanış katmanının **kullanıcı yüzeyi yok**.

---

## 1. Varlık — **YOK** (net, üç bağımsız ölçüm)

```
src/database/entities/*.ts                     → 48 dosya, claim|settle|deduct|reconcil adlı YOK
@Entity('...') tablo adı taraması              → claim|settle|deduct|reconcil ile eşleşme YOK
src/database/migrations/                       → 59 dosya; settlement adlı TEK migration:
                                                  1778…-AddSettlementFieldsToAgreements.ts
                                                  (alanlar AGREEMENT üzerinde, ayrı tablo değil)
```

**Ve kod bunu kendisi yazıyor** — iki ayrı yerde:

```
dto/pending-tasks.dto.ts:97   "NOTE: CTPM does not have a separate Claim entity yet
                               — placeholder for future."
dashboard.service.ts:615      "CTPM doesn't have a separate Claim entity yet.
                               'Submitted' = PENDING agreements … mirrors TTM's
                               submitted_claims concept in CTPM's domain."
```

⚠️ **Terim sayımı yanıltıcı olurdu:** `claim` src'de **134 geçiş / 30 dosya**. Örneklendi
(`§2.1.1` disiplini) — üç anlam çıktı ve **hiçbiri bir varlık değil**:

| anlam | örnek |
|---|---|
| **DTO/alan adı** (TTM kavramının aynası) | `PendingManualClaimItemDto`, `SubmittedClaimItemDto` |
| **türetilmiş tutar** | `settlement-summary.service.ts:142` — `const claimAmount = Number(agr.capTotalAmount)` |
| **İngilizce fiil** | `dashboard.service.ts:147` — *"after a comment **claimed** otherwise"* |

Aynısı `deduction` için: **33 geçiş**, örneklendi — **hepsi** *"on-invoice deduction"*
(indirimin ciroyu düşürmesi, NIV semantiği) anlamında; **perakendeci kesintisi değil**.
`chargeback` · `entitle` · `hakedis` → **0**.

---

## 2. Üretim — **VAR**, `agreement_transaction` adıyla ve **yalnız kullanıcı tetiklemesiyle**

Hakediş talebinin CTPM'deki karşılığı bir **agreement transaction** (off-invoice harcama
olayı). Üretim yolları — hepsi canlı ve RBAC'li:

```
POST /agreement-transactions                     (ADMIN, PLANNER, FINANCE_MANAGER)
POST /agreement-transactions/batch               (ADMIN, FINANCE_MANAGER)
POST /agreement-transactions/upload              (ADMIN, FINANCE_MANAGER)   ← dosya
POST /agreement-transactions/validate-and-import (ADMIN, FINANCE_MANAGER)
```

**UI yolu var:** `OffInvoiceManualEntryModal` → `OffInvoiceTransactionsPage:478` (ölçüldü,
tek çağıran). `0058`'in rota envanterindeki `/off-invoice/transactions` ve
`/off-invoice/upload` ekranları bunlar.

**Tetikleyici: yalnız insan.** Zamanlanmış/olay-güdümlü bir üretim **ölçülmedi** — ve bu
`0065 §2`'nin ölçümüyle tutarlı (`§6.2`'nin 5-dakikalık dosya polling'i, üç gecelik iş:
altyapı yok, [[T-158]]).

📌 **Ve *"hakediş bekleyen"* kavramı zaten var** — bir nesne olarak değil, bir **yokluk
sorgusu** olarak: `fetchPendingManualClaims` = MANUAL taktikli, henüz transaction'ı olmayan
aktif agreement'lar. Dashboard'da üç kova (`pendingManual` · `submitted` · `awaitingInvoice`)
ve `GET /dashboard` üzerinden **erişilebilir**.

---

## 3. Alım — **KISMEN**, ve tek yönlü

**Var olan:** off-invoice fatura dosyasının (CSV/Excel) yüklenmesi — `POST upload` +
`validate-and-import`, şablon indirme uçlarıyla birlikte (`GET template/excel`,
`template/csv`).

**Olmayan:** karşı tarafın **talebi** olarak modellenmiş bir giriş. Yani sisteme giren şey
*"perakendecinin kesinti belgesi"* değil, **bizim kaydettiğimiz fatura satırı**. Fark
davranışsal: bir talebin *"gelen ama henüz kabul edilmemiş"* durumu **yok** — satır ya
doğrulanıp yazılıyor ya reddediliyor (`0060 §2`'nin `AI-001` ölçümü: satır-bazlı ret +
`parseErrors`).

> Yani **(b)**'nin *"alım yok"* kısmı **fazla güçlü**: bir alım yolu var, ama **karşı taraf
> perspektifi** yok.

---

## 4. Eşleştirme — **YOK.** Var olan şey *lookup*, ve eşleştirmeyi **kullanıcı yapıyor**

`off-invoice-validation.service.ts:62`:

```
if (!row.dto.agreementId || row.dto.agreementId.trim() === '')  → satır hatası
… agreement bulunamazsa: "Anlaşma bulunamadı: <id>"
```

Ve parser o değeri dosyadan okuyor — `off-invoice-file-parser.service.ts:218-221`:
`agreement_id` · `agreementId` · `Agreement_ID` · `AgreementId`.

> **Yani anlaşma eşleştirmesi bir GİRDİ ALANI, bir çıkarım değil.** Yükleyen kişi
> hangi anlaşmaya yazılacağını **kendisi** yazıyor; sistem yalnız o kimliğin var olduğunu
> ve satırın kurallara uyduğunu doğruluyor.

**Otomatik eşleştirme araması** (`autoMatch|matchAgreement|findByAgreementCode`): CTPM'de
böyle bir yol **ölçülmedi**. Bulunan 114 satırın hepsi `lta-agreement` modülünde ve
**LTA kodunun tekilliğini** kontrol ediyor (`findByCode` → *"already exists"*), fatura
eşleştirmesi değil.

📌 Var olan tek otomatik ilişkilendirme **duplike kontrolü**:
`off-invoice-validation.service.ts:319` — `agreementId + invoiceNo + invoiceDate` üçlüsü.
Bu bir **idempotency** kontrolü, eşleştirme değil.

---

## 5. Mutabakat ve kapanış — **KISMEN**

### ✅ Anlaşma kapanışı: var ve **olgun**

`POST /actuals-first/settlements/close/:agreementId` → `settlement-close.service.ts`:

- `FOR UPDATE` kilidi
- `status === CLOSED` → **409 `ALREADY_SETTLED`**
- `APPROVED/ACTIVE` değilse → **409 `NOT_SETTLEABLE_STATE`**
- `status = CLOSED`, `closedAt`, `closedBy` (entity'de **var**: `agreement.entity.ts:195,198`)
- **T-030:** kalan bütçe rezervi (net `RESERVE − RELEASE`) **tam release** ediliyor
- Yorumda açık sınır: *"Buraya ledger/budget yazmak consumed'ı **çift sayardı**"*

**Test kapsaması:** `test/settlement.e2e-spec.ts` + `test/settlement-budget-release.e2e-spec.ts`
(ayrıca `reversal`, `role-journey`, `optimistic-locking` e2e'lerinde geçiyor).

### ✅ Mutabakat özeti: var

`GET /actuals-first/settlements/summary` → `settlement-summary.service.ts`:
`claimAmount = agreement.capTotalAmount` · `remainingAmount = claim − invoiced`
(**`claimAmount === 0` → `null`**, division-by-zero guard).

### ❌ Dönem kapanışı: **yok**

```
closePeriod|period.?close|lockPeriod|periodLock|month.?end|fiscal.?close
  → src'de 1 geçiş, o da finance-reporting.service.ts:842 'endDate.setMonth(...)' (alakasız)
```

Yani **dönemi kilitleyen / kapatan bir akış ölçülmedi.** Fiscal period bir **etiket**
(`YYYY-MM`, bütçe düşümü için) — bir **durum** değil.

### ⚠️ `reconciliationPeriod`: alan var, **sıfır tüketici**

```
backend src'de 2 geçiş (spec hariç):
  create-agreement.dto.ts:127   (girdi alanı, WEEKLY|MONTHLY|QUARTERLY|YEARLY)
  agreement.entity.ts:152-157   (kolon: reconciliation_period)
→ okuyan hiçbir servis/sorgu YOK
```

`CLAUDE.md §7.1`'in **T-079 sınıfı**: *"alan kullanılıyor" sanılan, sıfır çağıranı olan
alan.* Mutabakat periyodu **kaydediliyor ve hiçbir şeyi tetiklemiyor**.

---

## 6. ⚠️ Erişilebilirlik bulgusu: settlement katmanının **kullanıcı yüzeyi yok**

`§4.2`'nin *"üretim çağrı yolu var mı"* sorusu iki katmanda farklı cevap veriyor:

| katman | HTTP rota | e2e | **frontend** |
|---|---|---|---|
| agreement-transaction (üretim/alım) | 14 rota | ✅ | ✅ `/off-invoice/*` ekranları |
| **settlement (özet + kapanış)** | **2 rota** | ✅ **2 e2e** | ❌ **hiç** |

**Ölçüm:** `settlements` kelimesi frontend `src/` içinde **0 geçiş**;
`src/api/endpoints/` altındaki 17 dosyanın hiçbiri settlement değil; `0058`'in 39 rotalık
envanterinde settlement/claim yok.

> Bu, oturumun *"mekanizma var, yol yok"* sınıfının bir **varyantı**: burada üretim yolu
> **var** (HTTP + RBAC + e2e), eksik olan **kullanıcı yüzeyi**. Bir anlaşmayı kapatmak
> bugün yalnız API çağrısıyla mümkün.

---

## 7. `BRD v2 L1 §1.7` için sonuç

| iddia | ölçüm |
|---|---|
| **(a)** katman tümüyle yok | ❌ **yanlış** — üretim, alım, kapanış ve mutabakat özeti çalışıyor |
| **(b)** üretim var, alım/eşleştirme yok | 🟡 **yaklaşık** — alım **var ama tek yönlü**; eşleştirme gerçekten **yok** |

**Kapsam, ölçülen hâliyle:**

1. **Claim nesnesi** — sıfırdan (bugün agreement + transaction ikilisiyle temsil ediliyor)
2. **Karşı taraf perspektifi** — *"gelen talep"* durumu ve onun yaşam döngüsü
3. **Eşleştirme mantığı** — bugün `agreement_id` bir **girdi alanı**; çıkarım yok
4. **Dönem kapanışı** — hiç yok (anlaşma kapanışı var ve **örnek alınabilir**: kilit,
   guard'lar, rezerv release'i, çift-sayma koruması)
5. **Settlement UI** — mevcut iki uç için bile yüzey yok

---

## 8. Bu ölçümün sınırları (ZORUNLU)

- **TTM ölçülmedi.** Port kaynağı olarak neyin hazır olduğu bu belgede **yok** (`0055`
  o işi kısmen yapmıştı).
- **Çalışma zamanı ölçülmedi** — hiçbir rota çağrılmadı, DB'ye bakılmadı. Tüm sonuçlar
  **statik** (kod + test dosyaları).
- `notification` modülü (3 rota) hakediş akışına bağlı mı — **aranmadı**.
- `approval` modülünün (7 rota) transaction/settlement üzerindeki rolü **ölçülmedi**.
- `settlement.guard.ts`'in ne kısıtladığı **okunmadı**.
- Frontend'de `claim` kelimesinin geçtiği dokuz dosyanın **tamamı** okunmadı; yalnız
  `settlements` çağrısının yokluğu sayımla ölçüldü.
