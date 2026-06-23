# 0001 — CollMind-TPM ana ürün, TTM reference/legacy olarak dondurulur

- **Durum:** Kabul edildi (Accepted)
- **Geçerlilik tarihi:** 2026-06-24
- **Karar verenler:** Sertaç Tuzcu (ürün sahibi), Architect review
- **Etkilenen repolar:** `Collmind-TPM` (ana), `TTM` (legacy)

## Bağlam

İki ayrı kod tabanı aynı ürünü (CollMind TPM — FMCG Trade Promotion
Management) hedefliyor:

- **Collmind-TPM (CTPM):** Submodule tabanlı mimari
  (`collmind.backend` NestJS 10 + `collmind.frontend` Vite/React 18).
  Katmanlı/DDD yapı, dual-mode (actuals-first ↔ planning-first),
  izole `kpi-engine` ve `spend-calculation` shared servisleri, tam
  `tenant` modülü ile çok kiracılı izolasyon.
- **TTM:** Monorepo (`apps/api` NestJS + `apps/web` Next.js). 475 commit,
  Wella UAT'ye ulaşmış, düz modül yapısı, Playwright tabanlı 14 e2e
  senaryosu, `reversals`/`settlements` gibi kanıtlanmış finansal akışlar.

İki kod tabanının paralel sürdürülmesi mümkün değil; tek doğruluk kaynağı
ve tek geliştirme hattı gerekiyor.

## Karar

**CollMind-TPM (CTPM) tek ve resmi ana üründür.** Tüm yeni geliştirme,
release ve müşteri teslimatı CTPM üzerinden yürür. Resmi geliştirme hattı
CTPM `staging` branch'idir; release `staging → main` promote ile yapılır.

**TTM dondurulur (frozen / reference-only).** TTM'de yeni feature
geliştirilmez. TTM yalnızca, UAT'de kanıtlanmış akışların CTPM'e
**port'lanması için kaynak referans** olarak korunur.

## Gerekçe

1. **Stratejik niyet:** CTPM kasıtlı olarak jenerik/ana ürün olarak
   tasarlandı; çok kiracılı, müşteriden bağımsız genel TPM platformu hedefi
   CTPM mimarisinde gömülü.
2. **Mimari üstünlük:** Katmanlı/DDD yapı, dual-mode desteği, izole
   `kpi-engine`/`spend-calculation`, BRD'nin "hesaplamalar dinamik
   formül, asla hardcode değil" ilkesine yapısal olarak daha uygun.
3. **Wella verisi bağlayıcı değil:** TTM'in Wella UAT olgunluğu demo/UAT
   bağlamındadır; üretim taahhüdü değildir, dolayısıyla kod tabanı seçimini
   belirlemez.
4. **Açıklar yönetilebilir:** CTPM'in tek ciddi açığı E2E kapsamı ve birkaç
   finansal akış (reversals, settlements). Bunlar TTM'den kontrollü port ile
   kapatılabilir; mimariyi bozmaz.

## Sonuçlar (Consequences)

**Olumlu:**
- Tek geliştirme hattı, tek doğruluk kaynağı; çaba bölünmesi biter.
- BRD-uyumlu, çok kiracılı, dinamik-formül mimarisi korunur.
- TTM'in UAT'de doğrulanmış davranışı port-referansı olarak korunur.

**Olumsuz / maliyet:**
- CTPM'de E2E kapsamı sıfıra yakın; öncelikli yatırım gerektirir.
- `reversals`/`settlements` ve diğer finansal akışlar CTPM'e port edilene
  kadar fonksiyonel boşluk var.
- TTM bilgisi zamanla bayatlayacak; port penceresi sınırlı tutulmalı.

**Aksiyonlar:**
- TTM README'ye FROZEN/REFERENCE-ONLY uyarı bloğu eklenir.
- CTPM CLAUDE.md'ye "Ürün konumu / TTM ilişkisi" notu eklenir.
- TTM'de `freeze/2026-06-24` git tag'i ile port-referans noktası sabitlenir.
- Port-aday akışlar (öncelik: E2E iskeleti, settlements, reversals, invoice
  claims) backlog'a alınır; her port'a e2e zorunlu.

## Değerlendirilen alternatifler

1. **TTM'i ana ürün yapmak — Reddedildi.** UAT olgunluğu çekici ama düz
   monorepo + Next.js, jenerik çok kiracılı ürün ve dinamik-formül hedefine
   CTPM kadar uygun değil; stratejik niyetle çelişir.
2. **İki kod tabanını birleştirmek (merge) — Reddedildi.** Farklı mimari
   paradigmalar (DDD/submodule vs düz monorepo, Vite vs Next.js) birleşmeyi
   yüksek riskli ve düşük getirili kılıyor.
3. **Her ikisini de aktif tutmak — Reddedildi.** Çaba bölünmesi, ikili
   bakım maliyeti ve tutarsızlık riski kabul edilemez.

## İlgili

- BRD tek doğruluk kaynağı: `.cursor/rules.md`
- Branch/release modeli: `CLAUDE.md` §5
- Konsolidasyon backlog'u: `.claude/backlog/epics/E-001.md`
- Port stratejisi prensipleri: bu ADR'nin sonuçları + backlog port task'ları
