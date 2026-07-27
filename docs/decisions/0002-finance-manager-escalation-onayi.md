# 0002 — Finance Manager'a escalation hattında plan onay yetkisi

- **Durum:** Kabul edildi (Accepted)
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
