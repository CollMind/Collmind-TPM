# `T-388` + `T-383 A2` — SEED ANAHTARI · GÖRELİ SEED · TENANT-TZ DÖNEM PENCERESİ
### Şerit: `data-engineer` (seed) ∥ `backend-engineer` (A2) · ⏰ **2026-09-30'dan ÖNCE**

> ## ⛔ BU BRIEF `docs/process/BRIEF_SABLONU.md` ALTINDADIR
> Her iddia `[ÖLÇÜLDÜ: <komut/dosya:satır>]` ya da `[ÖLÇÜLMEDİ — ölçülecek: <nasıl>]`.
> **Etiketsiz iddia görürsen DUR ve iade et.** Raporunda da etiket kullan, **araç
> notlarını yaz**, ve son madde her zaman **"⛔ NE ÖLÇEMEDİN"**.

---

## 0 · OKUMA SIRASI — ⛔ her yol `ls` ile doğrulandı 2026-09-08

```
1  docs/process/BRIEF_SABLONU.md
2  .claude/backlog/tasks/T-388.md      ← seed anahtarı, ŞARTNAME orada
3  .claude/backlog/tasks/T-383.md      ← ⛔ EN ALTTAKİ "EVREN SINIFLANDIRILDI" BLOĞU
4  docs/brd-v2/04_KARAR_KAYDI.md → Z107 §3 · Z108 §1.1 (hüküm 18) · Z109 §3 · Z83
5  docs/DISIPLIN.md → "SEED bir DEMO'dur, FIXTURE bir SÖZLEŞMEDİR"
                      "SEED GÖRELİDİR, FIXTURE SABİTTİR"
                      "npm run guards KAPININ TAMAMI DEĞİLDİR — iki zincir var"
6  collmind.backend/src/common/date/local-today.ts   ← tenantTodayIsoDate ZATEN VAR
7  collmind.backend/scripts/migration-verify.sh · scripts/mutate.sh   ← ARAÇLAR
```

## 0.1 · HÜKÜM-ATIF TABLOSU

| Z-no | madde | nerede |
|---|---|---|
| `Z108 §1.1` | hüküm 18 — demo-seed **göreli**, tutar tablosu **sabit** | `§2` |
| `Z108 §6` | hüküm 23 — **anahtar → göreli seed**, bu SIRAYLA · ⏰ 30 Eylül | `§2` |
| `Z104 §1` | hüküm 11 — *"bugün"* = **tenant saat dilimi** | `§3` |
| `Z83` | kapı doğum kuralı | `§2.3` · `§3.3` |

⛔ **Numarasız hüküm = DUR.**

---

## 1 · ⛔ EVREN **ZATEN SINIFLANDIRILDI** — bu turun ilk işi DEĞİL

Ürün sahibi şartı: *"tur açılmadan evren liste olarak sınıflanır, yoksa tur ortasında
`DUR` doğar."* **Yapıldı** — `T-383`'ün en altındaki blok. Özet:

```
[ÖLÇÜLDÜ: rg -n "new Date\(\)" src/ --glob '!*.spec.ts' → 49 satır]
  A1  TAKVİM ALANI (kimlik/pencere)   3 yer   ⏸ BU TURDA DEĞİL (hüküm 13)
  A2  UTC TABANI                      7 yer   ⭐ BU TURUN İŞİ
  A3  DB OTURUM TZ'si                 4 yer   ⏸ KENDİ TURU (para yolu, ayrı pin)
  B   ANLIK DAMGASI                  ~35 yer  ✅ MEŞRU — takvim alanı OKUNMUYOR
```
⛔ **`ŞERİT 2` "üç yer" demişti; TAM TARAMA DÖRT buldu** (`finance-reporting:1259-1261`).
Bu oturumda evren **dördüncü kez** kaydı. ⇒ **Listeyi devralma, `§4`'te YENİDEN DOĞRULA.**

---

## 2 · İŞ A — SEED ANAHTARI, SONRA GÖRELİ SEED (`data-engineer`)

### `2.1` · KUSUR — ölçüldü
```
[ÖLÇÜLDÜ: src/database/seeds/budget-envelope.seed.ts:188-193]
  const code = `ENV-2026-${spec.categoryCode}`;          ⛔ DÖNEM TAŞIMIYOR
  const existing = await repo.findOne({ where: { code, tenantId } });
  if (existing) { created.push(existing); continue; }    ⛔ ve SESSİZ
```
> ### ⇒ Hüküm 18'in **göreli seed**'i, anahtar değişmeden **SESSİZCE ETKİSİZ** kalır:
> ### `existing` bulunur, satır **hiç güncellenmez**, ve **atlandığı söylenmez**.

### `2.2` · İKİ DÜZELTME **BİRLİKTE** (hüküm 23 — ayrılamaz)
```
1  ANAHTAR DÖNEME ÖZGÜ     `ENV-${period_from}-${cat}`  ya da  (code, period_from) BİLEŞİK
   ⛔ ÖNCE EVREN: `code` alanının KAÇ REFERANSI var — e2e · migration · seed · üretim.
     SAYI DEĞİL LİSTE. Bir kod bir KİMLİKTİR (hüküm 13) — biçim değişikliği GEÇMİŞİ
     etkiler mi, ÖLÇ. Özellikle `1832`'nin taşıdığı satırlar.
2  `continue` KONUŞUR      ⛔ atlanan her satır SEBEBİYLE yazılır (`§2.5`)
   ⇒ "seed-sözleşme-kapısı" adaylığının ÜÇÜNCÜ üyesi
```

### `2.3` · SONRA GÖRELİ SEED (hüküm 18) — ⛔ **ANAHTAR İNMEDEN UYGULANMAZ**
```
demo-seed tenant-BUGÜNE göre "içinde bulunulan çeyreği" üretir     → demo HEP CANLI
⛔ ürün-sahibi imzalı TUTAR TABLOSU SABİT — Σ 2.300.000, DOKUNULMAZ
[ÖLÇÜLDÜ: local-today.ts:84]  tenantTodayIsoDate(timezone, now?) ZATEN VAR — YENİ YARDIMCI AÇMA
```
⛔ **`Z83` doğum şartı:** dönemi değişmiş bir seed **yeniden koşulur** → satır
**güncellenmeli** (ya da açıkça *"atlandı, çünkü …"* basmalı). **Düzeltme öncesi aynı
koşum SESSİZCE hiçbir şey yapmalı** — bilinen-kırmızı budur.

### `2.4` · MIGRATION GEREKİRSE
⛔ **DUR** → Team Lead → numara tahsisi. Yazarsan doğrulaman **elle değil araçla**:
`bash scripts/migration-verify.sh <sınıf|dosya>`.
⚠️ `K4` fixture'ı **sen yazarsın**; yoksa araç o kısıt için **`ÖLÇEMEDİM`** basar.

---

## 3 · İŞ B — `T-383 A2`: TENANT-TZ DÖNEM PENCERESİ (`backend-engineer`)

### `3.1` · YEDİ YER, **TEK SINIF, TEK DÜZELTME**
```
finance-reporting.service.ts   :236-239 · :511-514 · :1128-1131 · :1259-1261
dashboard.service.ts           :399 · :439
budget.service.ts              :1954
```
⛔ **NEDEN KAÇAK — mekanizma ölçüldü:** İstanbul UTC'den **ileride**. Ayın son
saatlerinde tenant **yeni aya girmiştir**, UTC hâlâ **eski ayı** söyler ⇒
`toPeriodMonthUtc(now)` / `toISOString().slice(0,7)` bir **AY ÖNCEYİ** döndürür.
Finansal bir pencerede bu, **yanlış dönemi raporlamaktır**.

### `3.2` · ŞEKİL
```
varsayılan pencere  →  tenantTodayIsoDate(timezone)  tabanlı
⛔ tenant TZ'si NEREDEN gelir — her çağrı yerinde ÖLÇ (tenantId var mı, repo erişimi var mı)
⛔ N+1 UYARISI: DALGA-A'da tam bu sınıf yaşandı (MAX_ROWS=5000 → 5000 SELECT).
  Bir döngü içindeyse TZ'yi BİR KEZ çöz ve geçir; parametre ZORUNLU olsun (hüküm 19).
```
⛔ **`toPeriodMonthUtc` ÖLDÜRÜLMEZ** — başka meşru çağıranı olabilir. **ÖLÇ**, sonra karar.

### `3.3` · ⛔ AYIRT EDİCİLİK — `mutate.sh` ile, `§2.7 #6`
`DALGA-A`'nın dersi: `expect(...).toHaveBeenCalledWith(tenantId)` **AYIRT ETMEZ** —
`getTimezone`'un **çağrıldığını** kanıtlar, **sonucunun aktığını** değil.
```
⇒ Ölçüm ARGÜMANDA yapılır (yardımcıya geçen tz), ya da DAVRANIŞTA (ay sınırı vakası).
⇒ KANIT: bash scripts/mutate.sh --file <yol> --line <n> --to '<tz yerine sabit>' -- <ölçüm>
  ⛔ "MUTASYON YAKALANDI" (exit 0) GÖRÜLMEDEN test ayırt ediyor SAYILMAZ.
```

---

## 4 · ⛔ İLK İŞ — EVRENİ **YENİDEN DOĞRULA**, DEVRALMA
```
rg -n "new Date\(\)" src/ --glob '!*.spec.ts'
```
`T-383`'ün `A`/`B` listesiyle **karşılaştır**. Fark bulursan **DUR ve bildir** —
o liste bu oturumda **dört kez** kaydı.

---

## 5 · SINIRLAR (⛔ DUR)

```
⛔ İKİ ŞERİT AYRI DOSYALAR — seed (data-engineer) ∥ A2 (backend-engineer). Kesişirse DUR.
⛔ TUTAR TABLOSU DOKUNULMAZ — Σ 2.300.000, ürün sahibi imzalı
⛔ A1 (kalıcı kimlikler) ve A3 (LTA/DB oturum TZ'si) BU TURUN İŞİ DEĞİL — dokunma
⛔ migration YAZMA → DUR, numara Team Lead'den
⛔ docs/brd-v2/** YAZMA · yeni task AÇMA
⛔ git checkout YASAK — kopya + shasum -a 256 -c
⛔ commit/push YOK
⛔ İLK KOMUT: docker ps --filter "label=com.docker.compose.project=tpm" + test/.e2e-run.lock
⛔ KAPI İKİ ZİNCİR: `npm run guards` (backend) VE `bash scripts/run-all.sh` (META)
  — sigpipe-hygiene META'da; birini koşmak KAPININ TAMAMI DEĞİLDİR (2026-09-08 ölçümü)
```

## 6 · `touches` (ölçülmüş — bitince GÜNCELLE)
```
İŞ A  src/database/seeds/budget-envelope.seed.ts · agreement.seed.ts
İŞ B  src/modules/shared/finance-reporting/finance-reporting.service.ts
      src/modules/shared/dashboard/dashboard.service.ts
      src/modules/shared/budget/budget.service.ts
```

## 7 · KAPANIŞ ÇIKTISI
```
1  EVREN YENİDEN DOĞRULAMASI  — T-383'ün listesiyle FARK var mı
2  İŞ A                        — anahtar + konuşan `continue`; `code` referans LİSTESİ
3  GÖRELİ SEED                 — Z83: düzeltme ÖNCESİ sessizce hiçbir şey yapmalı
4  İŞ B                        — yedi yer, her birinde tz NEREDEN geldi (LİSTE)
5  AYIRT EDİCİLİK              — mutate.sh çıktısı, "MUTASYON YAKALANDI"
6  KAPI                        — İKİ ZİNCİR + unit + e2e + T-047 (+ harness, migration varsa)
7  ÜÇ METRİK                   — tur süresi · review-tur · DUR
8  ⛔ NE ÖLÇEMEDİN
```
