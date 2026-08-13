# 0002-R — Finance Manager'a escalation hattında plan onay yetkisi

> ## ⛔ REVİZE EDİLDİ — `0002-R` (2026-08-13)
>
> **Dayanak düştü.** Bu ADR'nin bağlamı *"BRD'nin sabit RBAC tanımı"* diyordu; o özet belge
> sonradan **geçersiz ilan edildi** (`ADR 0010` — `.cursor/*.pdf` süperseded). Ve kaynağın
> kendisi farklı diyor: finans yöneticisine **genel ikinci kademe** onay yetkisi veriyor.
>
> **Yeni karar** (2026-08-12, `K-2.5.12` ailesi): onay hattını **yalnız atanmış şablon**
> belirler. İkinci bir yükseltme mekanizması **yoktur.** `escalate-to-finance` bir hat değil,
> bir **eylem**: `FİNANSA DEVRET` — şablonda zaten tanımlı finans kademesini bu istek için
> etkinleştirir.
>
> **İçerik üç karara dağıldı ve bir eyleme indi:**
>
> | Eski maddenin taşıdığı | Yeni yeri |
> |---|---|
> | Eşik tetikli finans bildirimi | `K-2.2.7b` |
> | Onay hattının tanımı | `K-2.5.13a` (şablon tablosu) |
> | Finans rolünün sorumluluğu | `K-2.6.4` (rol kataloğu) |
> | Elle yükseltme | **`K-2.5.12b`** — devir bir eylem, hat değil |
>
> ⚠️ **Aşağıdaki metin SİLİNMEDİ ve normatif DEĞİLDİR.** `ADR 0006-R` deseni: bir kararın
> neden verildiği ve neyle yanlışlandığı ikisi birden kayıtta kalır — iki kaydın altı ay
> sonra çelişmesi böyle önlenir.
>
> 📌 Ve bir şey **değişmedi:** `K-2.5.12e` finansın genel ikinci kademe yetkisini bir **şablon
> tercihi** yapıyor (`Eşikli` / `Çift kademe`), bir ürün varsayılanı değil. Yani eski kararın
> *"FM yalnız kendisine gelen isteği onaylar"* sonucu **bugün hâlâ doğru** — ama gerekçesi
> artık bir BRD okuması değil, bir şablon kararı.

---

- **Durum:** ⛔ **REVİZE EDİLDİ → `0002-R`** (eski durum: Kabul edildi)
- **Geçerlilik tarihi:** 2026-07-28
- **Karar veren:** Sertaç Tuzcu (ürün sahibi)
- **İlgili:** T-028 RBAC hizalaması · `docs/analysis/0004-rbac-brd-alignment.md` (R-3)

## Bağlam
BRD'nin sabit RBAC tanımında **Finance Manager = "okuma + bütçe"** olarak geçiyor; onay yetkisi
Category Manager'a verilmiş. Ancak kodda bir **escalation hattı** mevcut:
`POST /plans/:id/escalate-to-finance` → plan `PENDING_FINANCE_REVIEW` durumuna geçiyor.

Bu hat BRD'de tanımlı değil. T-028 RBAC hizalaması sırasında soru netleşti: bu durumdaki planı
kim onaylayacak? Finance Manager mı, yoksa hat Admin'e mi gitmeli?

## Karar
**Finance Manager, YALNIZCA `PENDING_FINANCE_REVIEW` durumundaki planları onaylayabilir.**

- Normal `PENDING_APPROVAL` akışında FM'nin onay yetkisi **YOKTUR** (403) — o hat Category
  Manager'ındır (BRD).
- FM'nin bu yetkisi bütçe sahipliğinden türer: yüksek tutarlı/eşik aşan planlarda finansal
  onay makuldür.
- Bu, BRD'nin **bilinçli ve sınırlı bir genişletmesidir** — sapma veya ihmal değildir.

## Gerekçe
1. FM zaten bütçe zarflarının ve tahsislerin sahibi (`budget`, `budget-allocation`, T-028a
   sonrası FINANCE→FINANCE_MANAGER devri).
2. Escalation hattı ürün gereksinimi olarak kodda mevcut; onaysız bırakmak planı ölü bırakır.
3. Alternatif (Admin-only) operasyonel darboğaz yaratır ve Admin'i gereksizce iş akışına sokar.

## Sonuçlar
- Rol matrisinde (`0004` §5): `plan · approval-queue` → FM: **R (yalnız PENDING_FINANCE_REVIEW)**;
  `plan · approve` → FM yalnız bu statüde.
- **E2E ile korunur:** N11 — FM, `PENDING_APPROVAL` durumundaki planı onaylamaya çalışırsa **403**.
  Ayrı bir pozitif test: FM, `PENDING_FINANCE_REVIEW` planını onaylar → 200.
- BRD dokümanı güncellenirse bu madde oraya taşınmalı.

## Alternatifler
1. **Escalation Admin-only** — reddedildi: operasyonel darboğaz, Admin'i iş akışına sokar.
2. **Escalation hattını kapat** — reddedildi: kodda mevcut ve ürün ihtiyacı; kapatmak işlevsellik kaybı.
