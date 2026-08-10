# 0050 — BRD okuma turu **32**: §9.5 Compliance — **hiç dokunulmamış bir boyut**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_09_NFR.md` §9.5 Compliance (265–321) · §9.8 Phase 1 NFR Scope
- **Ölçüm ortamı:** meta `214e86d` · backend `99ee9e6`

---

## 1. 🔴 Yeni boyut: **regülasyon** — ne kodda, ne sözleşmede

`§9.5` üç düzenlemeyi **adıyla** sayıyor (Türkiye):

| Regülasyon | Şart | BRD'nin uygulama notu |
|---|---|---|
| **Vergi Usul** (*Tax Code*) | **7 yıl** finansal kayıt saklama | audit logs, ledger entries retained |
| **KVKK** | kişisel veri işleme için rıza | kayıt akışında onay, **silmede anonimleştirme** |
| **E-Fatura** | elektronik fatura saklama | *"Invoice files archived in **original format** (XML/PDF)"* |

Ve **GDPR** (AB müşterisi olursa): Right to Access · **Right to Erasure** *(anonimleştirilir,
audit izi korunur)* · Data Portability.

**Ölçüm:**

```
kod    : retention|anonymiz|archive|KVKK|GDPR araması → yalnız 2 dosya
         (budget-envelope migration + entity — ilgisiz olabilir, doğrulanmadı)
sözleşme: SYSTEM_INVARIANTS'ta compliance|KVKK|GDPR|retention|INV-C-  → 0
```

> **`SYSTEM_INVARIANTS`'ta uyum ailesi yok** — [[T-168]]'in (`INV-A-*` yok) kardeşi.
> Yedi invariant ailesi var; **ne audit ne compliance**.

---

## 2. 📌 Saklama süreleri — somut ve **Phase 1**

```
| Plans (Draft)            | 90 gün hareketsiz → SİL      | clutter azaltma |
| Plans (Approved/Closed)  | 5 yıl                        | finansal uyum |
| Agreements (All)         | 7 yıl                        | vergi/audit |
| Invoices                 | 7 yıl                        | vergi/audit |
| Ledger Entries           | 7 yıl                        | finansal uyum |
| Baseline Data            | 5 yıl                        | performans analizi |
| Audit Logs               | 7 yıl                        | regülasyon |
```

Ve `§9.8 Phase 1 NFR Commitments`: **`✅ 7-year audit log retention`** — **Phase 1 taahhüdü**.

### ⚠️ Bir gerilim ve uzlaştıran okuma

`§7.7` *"Audit log retention **policies** (auto-archive)"*'ı **Phase 2**'ye erteliyor;
`§9.8` *"7-year audit log **retention**"*'ı **Phase 1**'e koyuyor.

> **Okuma:** *saklama* (7 yıl boyunca silmemek) Phase 1; *otomatik arşivleme politikaları*
> (soğuk depoya taşıma araçları) Phase 2. `§9.5` de bunu destekliyor:
> *"Archived to cold storage after 2 years (**cost optimization**)"* — yani arşivleme bir
> **maliyet** işi, saklama bir **regülasyon** işi.
>
> ⚠️ **Çıkarım.** İki metin çelişmiyor ama açıkça da ayrılmıyor.

⚠️ Ve bugün 7 yıl **kendiliğinden** sağlanıyor: hiçbir şey silinmiyor. Yani şart
**karşılanıyor ama korunmuyor** — bir temizlik işi eklendiği gün sessizce ihlal edilir.
Bu, `INV-L-003`'ün (*"ledger satırı silinemez"*) uyum tarafındaki karşılığı ve **yok**.

---

## 3. 🔴 `§9.5` audit **kapsamı**, `§7.4`'ün 20 olayından **geniş** — ve regülasyona bağlı

```
Coverage:
- All CRUD operations on plans, agreements, budgets
- All approval actions (approve, reject, request changes)
- All budget state changes (reserve, commit, consume)
- All data imports (baseline, invoices)
- All configuration changes (KPIs, policies)
```

> **Ve çerçevesi farklı:** `§7.4` bunu bir **özellik** olarak anlatıyordu; `§9.5` bir
> **uyum şartı** olarak — *"Immutable audit log for **all financial transactions**"*,
> Vergi Usul'e bağlı.

Bizde: `admin_audit_logs`, **admin odaklı**, dev verisinde **dört** `action_type`
([[T-168]]).

> **[[T-168]] güçlendi:** eksik olan yalnız bir invariant ailesi değil — **regülasyon
> dayanağı olan bir kapsam**.

---

## 4. 📌 İki somut kural, ikisi de bizde ölçülmedi

**(a) KVKK / GDPR anonimleştirme:**

> *"Deleted users: **Anonymized** (`user_id` **retained for audit trail**)"*
> *"Right to Erasure: … (anonymized, **audit trail preserved**)"*

Bizde `users` soft-delete var (`deleted_at`); **anonimleştirme yok** (ölçülmedi).
⚠️ Ve kural ikili: *sil* değil, **anonimleştir + audit izini koru**.

**(b) E-Fatura orijinal format saklama:**

> *"Invoice files archived in **original format (XML/PDF)"*

Bizde `sales_actuals.raw_row` **jsonb** var (satır düzeyi), ve `import_batches`'in
`file_hash`'i BRD'de var — **bizde `import_batches` tablosu yok** (`0028 §5`).
**Orijinal dosya saklanmıyor** (ölçülmedi ama tablo yokluğu güçlü sinyal).

---

## 5. Diğer §9 sayıları (kayda geçer, task açmıyor)

`§9.8 Phase 1 NFR Commitments`:

```
✅ page load <2s · KPI calc <500ms · rapor <5s · import <15 dk
✅ 100 tenant · 500 eşzamanlı kullanıcı · 50 (tek tenant)
✅ 17 GB/tenant (5 yıl projeksiyonu)
✅ %99.5 uptime (aylık SLO) · günlük yedek · 15 dk RPO
✅ RBAC (capability-based) · şifreleme · 30 dk oturum zaman aşımı
```

⚠️ **`%99.5`** — `§10.2` Gate 2 **`≥%99`** diyordu. Farklı sayılar, farklı bağlam (SLO vs
kapı); **çelişki ilan etmiyorum**.

⚠️ Ve bunların **hiçbiri ölçülemez**: deploy edilmiş ortam yok ([[T-157]]).

---

## 6. Sonraki tur (🟡 kalan)

1. `§5.4` What-If — [[T-169]]'un en büyük eksiğinin tarifi
2. `§3.1/3.2` · `§6.3/6.5` · `§11.2`+P2/P3 · `§10.3` · Addendum H5.2/5.3
