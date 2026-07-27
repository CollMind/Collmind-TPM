# 0003 — Agreement Bütçe Rezerv Yaşam Döngüsü — T-030

- **Tarih:** 2026-07-27 · **Kaynak:** T-030 architect
- **Karar:** KOŞULLU ONAY (4 bağlayıcı koşul)

## Bağlayıcı koşullar
1. Close'da **tam net rezerv** release edilir (`reserve − consumed` DEĞİL — §3 sayısal kanıt).
2. RELEASE, close'un `QueryRunner` transaction'ının **içinde** yazılmalı → `BudgetRepository`
   metodlarına opsiyonel `EntityManager` parametresi (bugün yok; dışarıda commit ederdi →
   close rollback olsa bile rezerv bırakılmış olurdu).
3. Yeni kod **`budget-reservation.service.ts`**'e yazılır, `budget.service.ts`'e DEĞİL
   (T-029 aynı dosyada çalışıyor — merge çakışması önlemi). `releaseForAgreement`
   deprecate'i T-029 merge'inden SONRA.
4. "Encumbrance relief" (tüketimle rezerv indirimi) bu task'a **alınmaz** → [[T-031]].

## 1. Mevcut durum (kod kanıtlı)
| Yol | Dosya | Bugün |
|---|---|---|
| approve | `agreement.service.ts:438` | `RESERVE`, key `RESERVE\|AGREEMENT\|<id>` (**envelope'suz**) |
| tx ekleme | `agreement-transaction.service.ts:142-166` | yalnız ledger DEBIT; rezerve dokunmaz |
| **close** | `settlement-close.service.ts:100-130` | **budget'a hiç yazmıyor → SIZINTI (F1)** |
| cancel | `agreement.service.ts:544-575` | RELEASE var ama **`capTotalAmount`** ile (drift), tek-envelope varsayımı (F4) |
| reject | `agreement.service.ts:483-518` | budget'a dokunmuyor (bugün sızdırmıyor ama savunmasız — F3) |
| reversal | `reversal.service.ts:52-64` | bilinçli olarak budget'a yazmıyor (**doğru, değişmez**) |

**F2 (ikincil):** Agreement hayattayken zarf hem `RESERVE=cap` hem `consumed` ile yükleniyor →
ACTIVE dönemde `consumed` kadar fazladan blokaj. Muhafazakâr yönde hatalı (aşırı harcamaya
izin vermez) → acil değil, ayrı task.
**F5 (BRD ihlali):** `agreement.service.ts`'te **hiç** `AdminAuditService` çağrısı yok —
approve/reject/cancel loglanmıyor → ayrı task.
**F6:** `budget.service.reverseForTransaction` ölü kod + `sourceId` semantiği karışık.

## 2. Hedef yaşam döngüsü

> ⚠️ **T-029 sonrası view güncellemesi (migration 1789).** `v_budget_summary` artık:
> `reserved = Σ(RESERVE + COMMIT) − ΣRELEASE` (önceden COMMIT hiç sayılmıyordu →
> onaylı planlar bütçeyi düşürmüyordu, ikinci sızıntı). `consumed` değişmedi (ledger).
> **AGREEMENT tarafında COMMIT üretilmiyor** (DB doğrulaması: 0 satır; yalnız RESERVE)
> → bu tasarımın `net = ΣRESERVE − ΣRELEASE` formülü **aynen geçerli**.
> İleride agreement'a COMMIT eklenirse net hesabı `Σ(RESERVE+COMMIT) − ΣRELEASE` olmalı.
> *Semantik not:* COMMIT'in "reserved" altında sayılması isimlendirme açısından zayıf
> (committed ≠ reserved) ama `consumed` ledger-tabanlı tanımlı olduğu için en az invaziv
> seçim; ileride terminoloji netleştirilebilir.

`reserved = Σ(RESERVE+COMMIT) − ΣRELEASE` · `consumed = ΣDEBIT − ΣCREDIT` · `available = allocated − reserved − consumed`

| Geçiş | Hedef | Tutar |
|---|---|---|
| PENDING → APPROVED | RESERVE (değişmez) | `capTotalAmount` |
| tx ekleme | yok (bu turda) | — |
| → **CLOSED** | **RELEASE (YENİ)** | **net rezerv**, envelope başına |
| → CANCELLED | RELEASE (net rezerv ile — cap değil) | net |
| → REJECTED | RELEASE (normalde 0 → no-op) | net |
| reversal | budget'a yazmaz (değişmez) | — |
| tekrar close | net=0 → hiçbir satır | — |

**Tek kural:** terminal state'e girişte net rezerv sıfırlanır; `consumed`'a asla dokunulmaz.

## 3. Sayısal kanıt — neden TAM release
Zarf `allocated=600.000`; agreement cap `20.000`, fiili tüketim (DEBIT) `12.000`.

- **Close öncesi:** `reserved=20.000, consumed=12.000` → `available = 568.000`
- **Ö2 — TAM release (DOĞRU):** `RELEASE 20.000` → `reserved=0` → `available = 600.000 − 0 − 12.000 = 588.000` ✅ = `allocated − gerçek harcama`
- **Ö3 — `reserve − consumed` = 8.000 release (YANLIŞ):** `reserved=12.000` → `available = 600.000 − 12.000 − 12.000 = 576.000` ❌ **12.000 iki kez düşülür**

> "Kullanılmayan kısmı bırak" sezgisi burada matematiksel olarak yanlıştır, çünkü view
> `reserved` ve `consumed`'ı zaten **ayrı ayrı** çıkarıyor.

**Çift-sayım kontrolü:** RELEASE yalnız `budget_transactions` → yalnız `reserved` terimi.
`consumed` yalnız `ledger_entries`'ten. Close ledger'a **hiçbir satır yazmaz** (G1 korunur).

## 4. Reçete
- **Adım 1:** `budget.repository.ts` — `createTransaction`/`findTransactionsBySource`/
  `findTransactionByIdempotencyKey`'e opsiyonel `manager?: EntityManager` (mevcut çağıranlar etkilenmez).
- **Adım 2:** `budget-reservation.service.ts` (YENİ):
  `releaseAgreementReservation(agreementId, tenantId, userId, reason: 'CLOSE'|'CANCEL'|'REJECT', manager?)`
  → POSTED tx'leri envelope'a göre grupla, `net = ΣRESERVE − ΣRELEASE`, `net>0` olan her
  envelope için RELEASE yaz; key `RELEASE|AGREEMENT|<agreementId>|<envelopeId>`
  (**cancel'ın bugünkü key'iyle birebir** → çakışma/çift release yok).
  İdempotency iki katman: net-residual hesabı + unique index. Çakışmada **ConflictException ATMA, no-op dön**.
- **Adım 3:** `settlement-close.service.ts` — status update ile audit arasında,
  `queryRunner.manager` geçerek çağır; audit `newValues`'a `budgetReleases`. Dosya başı yorumu güncelle.
- **Adım 4:** `agreement.service.ts` — `cancel()` bloğunu yeni servise devret (cap-drift + tek-envelope kusurları kapanır); `reject()`'e defansif no-op çağrı.
- **Adım 5:** `settlement-close.service.spec` "no budget write" assertion'ları **niyet değiştirerek**
  güncellenir → "no **ledger** write; tam 1 RELEASE, amount = net reserved".
- **Adım 6:** Backfill migration (§5).

## 5. Kirli veri — migration (script değil)
Gerekçe: staging/prod'da aynı satırlar var; `migration:run` release akışının parçası, versiyonlu.
`agreements` JOIN'i sayesinde `REVERSAL|AGREEMENT|<txId>` satırları (sourceId = tx id) doğal olarak elenir (F6).
`net>0` + unique key + `ON CONFLICT DO NOTHING` → yeniden çalıştırılabilir. `down()`: `description LIKE 'T-030 backfill:%'` sil.
Doğrulama: terminal-state agreement'lar için `Σ net_reserved = 0`.

## 6. Reversal / T-013 / T-019 etkileşimi
- Reversal CREDIT → `consumed` düşer → available otomatik artar; rezerve dokunulmaz (B-1 gerekçesi **hâlâ geçerli**).
- CLOSED iken (`reserved=0`) reversal → `available = allocated − consumed_yeni`; çifte iade yok.
- **T-013 kısıtı:** (A) re-open seçilirse `CLOSED→ACTIVE` rezervi **yeniden kurmak zorunda**;
  RELEASE key'i dolu olduğundan yeni RESERVE key'i `RESERVE|AGREEMENT|<id>|<env>|R<n>` (reopen sayacı) olmalı.
  (B) seçilirse sürtünmesiz.
- **T-019 kısıtı:** bugünkü RESERVE key'i envelope'suz → ikinci zarfa rezervde unique çakışır.
  T-019 key'i `RESERVE|AGREEMENT|<id>|<envelopeId>` yapmalı. T-030 bunu değiştirmez.
  RELEASE key'inde envelopeId zaten var → ileri uyumlu.

## 7. E2E (özet)
BR-E2E-01 close öncesi/sonrası view · 02 kısmi tüketimli close (Ö2 sayıları) · 03 tekrar close → 409 + RELEASE sayısı 1 · 04 cancel (cap drift'te negatife düşmez) · 05 reject no-op · 06 reversal+close · 07 close sonrası reversal · 08 zarf %95'te close → yeni approve geçer (T-012 threshold) · 09 cross-tenant · 10 backfill sonrası Σ net = 0.

## 8. Ayrılan işler
[[T-031]] encumbrance relief (F2) · [[T-032]] agreement lifecycle audit (F5, BRD) ·
[[T-021]]'e F6 (ölü kod) · [[T-019]] RESERVE key'i · [[T-013]] re-open rezerv kurulumu.
