# Ajan Yapısı Sertleştirme — v1

> **Kapsam:** `.claude/agents/*` (9), `.claude/settings.json`, `.claude/backlog/BACKLOG.md`, `README.md`
> **Bağımlılık:** yok — hiçbiri açık bir ürün kararını beklemiyor
> **Kaynak:** 2026-08-03 orkestrasyon incelemesi + CTPM baseline audit
> **Eşlik eden dosya:** revize `CLAUDE.md`

Uygulama sırası aşağıdaki gibidir. Her adım bağımsızdır; yarıda bırakılabilir.

---

## Adım 1 — Ortak ajan bloğu (9 dosyanın hepsine)

Her `.claude/agents/*.md` dosyasında, frontmatter'dan sonraki ilk paragrafın **hemen ardına**
aşağıdaki bloğu ekle. Dokuzunda da birebir aynı metin.

> Neden inline, neden ayrı dosyaya referans değil: bunlar bağlayıcı kurallar. Referans bir
> tool çağrısı gerektirir ve atlanabilir; inline metin her zaman context'tedir.

```markdown
## Bağlayıcı kaynaklar (ZORUNLU)

Öncelik sırası:
1. `docs/decisions/*.md` — **ADR'ler.** Ürün sahibinin kararları. BRD ile çelişirse ADR kazanır.
2. `.cursor/` altındaki **BRD PDF'leri** — asıl kaynak metin.
3. `.cursor/rules.md` — **türetilmiş özet, normatif değil.** BRD'nin LLM özetidir ve kayıplıdır.
   PDF ile çeliştiğinde PDF kazanır. `rules.md`'de bir kavramın geçmemesi "kural yok" demek
   değildir.

Task'a başlamadan önce ilgili ADR'leri tara. `rules.md`'de `actuals`, `agreement`, `claim`,
`settlement`, `ledger`, `reversal`, `invoice`, `recognition`, `tenant` **hiç geçmez** — bu
alanlarda çalışıyorsan normatif kaynağın orası değildir.

## Belirsizlikte DUR (ZORUNLU)

ADR ve BRD bir noktada sessiz veya çok anlamlıysa: **DUR.** Varsayma, "en makul olanı" seçme,
"muhtemelen şöyledir" diye ilerleme. Team Lead'e bildir: belirsizlik nedir, seçenekler neler,
her birinin sonucu ne. **BRD yorumu ürün sahibinin kararıdır, ajanın varsayımı değil.**

## Sessiz sıfır yasağı (ZORUNLU)

Finansal bir yolda eksik/belirsiz/çözülemeyen girdi → **açık hata fırlat.**
Yasak: varsayılan değer · sessizce `0` dönmek · sessizce atlamak · `if` yazıp `else` bırakmamak ·
gizli tie-break. Bu sınıftan bu projede sekiz hata çıktı; kural artık tartışmaya açık değildir.

## Yeni kod yazmadan önce ara (ZORUNLU)

"Bu yeteneğin mevcut bir implementasyonu var mı? Arandı mı, nerede, hangi terimlerle?"
Aynı yetenek bu projede birden çok kez yazıldı (iki submit yolu, iki lumpsum dağıtımı,
iki CSV parser, üç scope implementasyonu). Aranmadan yazılan kod eksiktir.

**Çapraz repo uyarısı:** aynı kavram CTPM ve TTM'de farklı adlanabilir
(ör. `capTotalAmount` ↔ `capAmount`). Grep'in boş dönmesi "yok" demek değildir.
```

---

## Adım 2 — `code-reviewer.md` kontrol listesi

Mevcut "## Kontrol listesi" bölümünü **tamamen** aşağıdakiyle değiştir. İlk üç madde yeni ve
bugüne kadar hiç aranmayan hata sınıflarını hedefler.

```markdown
## Kontrol listesi

**Önce bu üçü — projenin tekrarlayan hata sınıfları:**

- **Erişilebilirlik:** Eklenen/değiştirilen her fonksiyonun **üretim çağrı yolu** var mı?
  (HTTP route / zamanlanmış iş / event). Yalnızca testlerden veya spec dosyalarından çağrılan
  kod → 🔴 **Blocker**. Bu sınıftan sekiz vaka çıktı.
- **Sessiz sıfır:** Eksik/belirsiz girdide varsayılan değer, sessiz `0`, sessiz atlama,
  `else`'siz `if` var mı? → 🔴 **Blocker**.
- **Tekilleştirme:** Bu yetenek zaten var mı? Aranmış mı? İkinci bir doğruluk kaynağı
  yaratılıyor mu? → 🔴 **Blocker** (iki submit yolu, iki dağıtım implementasyonu bu şekilde oluştu).

**Sonra standart kontroller:**

- **Correctness:** mantık hataları, edge case (özellikle KPI null kuralları), hata yönetimi.
- **Finansal aritmetik:** ledger toplamı `SUM(amount)` ile mi yapılıyor? DEBIT−CREDIT
  ayrımı olmadan toplama → 🔴 **Blocker** (reversal'lar harcama sayılır).
  Para değeri `number` olarak mı taşınıyor, karşılaştırma sınırda mı yapılıyor?
- **Determinizm:** finansal bir yolda `ORDER BY` var mı, ve iş anahtarına göre mi?
  Üretilmiş id'ye (`uuid`) göre sıralama → 🔴 **Blocker**.
- **Migration hijyeni:** `pg_constraint`/`pg_indexes`/`pg_class` sorgusu şema-nitelendirilmiş mi?
  (`nspname`/`schemaname` predicate'i yoksa migration sessizce no-op olabilir) → 🔴 **Blocker**.
- **BRD/ADR uyumu:** hesaplama hardcode edilmemiş mi? RBAC sınırları? state machine?
  RAG/threshold config'ten mi? audit log var mı? tenant predicate'i var mı?
- **Pattern tutarlılığı:** NestJS modül/DTO/guard kalıbı, React bileşen/TanStack Query stili.
- **Güvenlik:** secret sızıntısı, input validation, yetki kontrolü.
- **Test:** yeni davranış test edilmiş mi? Lint/type-check geçiyor mu?
```

**Ayrıca frontmatter'da:** `model: sonnet` → `model: opus`

> Gerekçe: `code-reviewer` commit öncesi son kapıdır ve BRD ihlali arar. Backlog'da Team
> Lead'in review'ın kaçırdığını yakaladığı en az iki vaka var (T-019b guard yanlış-pozitifi,
> T-060'ta testler yeşilken exit code 1). Son kapı en güçlü modelde olmalı.
>
> Aynı gerekçe `data-engineer` için de geçerli (geri alınamaz şema değişikliği yazıyor) —
> ama önce `code-reviewer`'ı taşı, etkisini ölç.

---

## Adım 3 — `data-analyst.md` `.env` çelişkisi

Bugün doğrudan bir çelişki var:

| Kaynak | Söylediği |
|---|---|
| `settings.json` deny | `Read(./**/.env)` |
| `data-analyst.md` | *"DB bağlantısı için `collmind.backend/.env` değerlerine göre psql kullan"* |

Ajana, okuması yasaklanmış bir dosyayı okuması söyleniyor. Ayrıca `psql` allow listesinde hiç
yok — belgelenmiş temel yeteneği her seferinde onay istiyor.

**Çözüm:** "## Kurallar" bölümünü değiştir:

```markdown
## Kurallar
- Yalnızca okuma sorguları. INSERT/UPDATE/DELETE/DDL ÇALIŞTIRMA.
- DB'ye şu sarmalayıcıyla eriş — `.env` okuma (deny listesinde):
  `bash scripts/db-query.sh "<SELECT ...>"`
- **Her sorguyu şema-nitelendir.** Bu instance hem `main` (CTPM) hem `public` (TTM) şemasını
  barındırır; niteliksiz `FROM migrations` yanlış ürünün geçmişini döndürür.
```

Ve `## Bağlam` içindeki port bilgisini düzelt: **5432 → 5434**, DB `collmind_tpm`, şema `main`.

Yeni dosya `scripts/db-query.sh` (repoya eklenecek, `.env` okumadan çalışır):

```bash
#!/usr/bin/env bash
set -euo pipefail
docker exec -i collmind-tpm-postgres psql -U postgres -d collmind_tpm \
  -v ON_ERROR_STOP=1 -c "$1"
```

> `-c` sözdizimi zorunlu — heredoc bu ortamda takılıyor.

---

## Adım 4 — `qa-engineer.md` bağımsızlığı

Bugün QA, implementasyonu yapan task'ın kabul kriterini okuyor. Kriter yanlışsa QA yanlış şeyi
doğrular. T-050'de tam bu oldu — ajan inisiyatifle yakaladı, yapı gereği değil.

`## Bağlam` bölümüne ekle:

```markdown
## Bağımsız doğrulama (ZORUNLU)

Kabul kriterini **önce ADR/BRD'den kendin türet**, sonra task'ta yazanla karşılaştır.
Uyuşmazlık bir **bulgudur** — task'ın kriterini doğru varsayma, rapor et.
```

Ve `## Öncelikli test edilecek BRD kuralları` listesi bugün tamamen planning-first. Şunları ekle:

```markdown
- Ledger: append-only, reversal = telafi kaydı, idempotency key tekilliği
- Bütçe: RESERVE/COMMIT/RELEASE yaşam döngüsü, terminal state'te net rezerv sıfırlanması
- CAP: sınır davranışı (eşitlikte ne olur), on/off asimetrisi
- Actuals: replace semantiği, tek ACTIVE batch, ledger sızıntısı yokluğu
- Tenant izolasyonu: cross-tenant okuma/yazma negatif testleri
- Determinizm: aynı girdi + aynı sıra → kuruşu kuruşuna aynı sonuç
```

---

## Adım 5 — `settings.json`

### 5.1 `allow` listesinden çıkar

```diff
-      "Bash(git checkout:*)",
-      "Bash(git pull:*)",
```

**Gerekçe:** paralel ajanlar aynı working tree'yi paylaşıyor. Bir ajanın branch değiştirmesi,
diğerinin altından zemini çekmesidir. Submodule kurulumunda daha da tehlikeli. İkisi de artık
onay istesin — sıklığı düşük, riski yüksek.

### 5.2 `Bash(node:*)` daralt

```diff
-      "Bash(node:*)",
+      "Bash(node --version)",
+      "Bash(node -e:*)",
```

**Gerekçe:** `architect`, `planner`, `code-reviewer`, `data-analyst` dördü de `tools: Read,
Grep, Glob, Bash` — yani Edit/Write yok, iyi. Ama `Bash(node:*)` otomatik onaylı olduğu sürece
bu ajanlar keyfi script çalıştırıp dosya yazabilir. Read-only garantisi prompt seviyesinde
kalıyor, izin seviyesinde değil.

*(Alternatif: node'u tamamen çıkar. Dört read-only ajanın hiçbirinin node'a ihtiyacı yok.)*

### 5.3 `allow` listesine ekle

```diff
+      "Bash(bash scripts/db-query.sh:*)",
+      "Bash(git merge-base:*)",
+      "Bash(git show:*)",
+      "Bash(git ls-files:*)",
```

---

## Adım 6 — Task şablonu (`BACKLOG.md`)

Şablona iki alan ve bir checklist ekle:

```markdown
touches:            # ZORUNLU — dokunulacak dosya/modül listesi
  - collmind.backend/src/modules/...
migration_seq:      # migration yazılacaksa MIGRATION_SEQUENCE.md'den tahsis edilen numara

## Done tanımı (hepsi işaretlenmeden `done` yazılmaz)
- [ ] Testler yeşil (unit + ilgili e2e)
- [ ] code-reviewer onayı
- [ ] Üretim çağrı yolu var (yoksa → `blocked-unreachable`)
- [ ] Bağlayıcı koşullar guard'a bağlandı (test/lint/DB constraint/CI) veya "tavsiye"ye düşürüldü
- [ ] `touches:` gerçekte dokunulan dosyalarla güncel
- [ ] Migration varsa catalogue guard'ları şema-nitelendirilmiş
```

Yeni status değeri: **`blocked-unreachable`** — kod yazıldı, testleri geçiyor, ama üretimden
çağrılmıyor. `done` değildir.

Yeni dosya `.claude/backlog/MIGRATION_SEQUENCE.md`:

```markdown
# Migration numara tahsisi

Ajan kendi numarasını SEÇMEZ. Team Lead buradan tahsis eder ve satırı işaretler.
Sebep: T-030/T-028'de 1790 iki kez alındı (elle yakalandı).

| Numara | Task | Durum |
|---|---|---|
| 1795000000000 | AddSpendTypeToBudgetDimensions | kullanıldı |
| 1796000000000 | — | boşta |
| 1797000000000 | — | boşta |
```

---

## Adım 7 — `README.md` düzeltmeleri

1. **Frontend branch:** `collmind.frontend/  # git submodule — React/Vite (branch: main)`
   → `(branch: staging)`. `CLAUDE.md` §5 tüm geliştirmenin `staging`'de olduğunu söylüyor;
   README yeni ekip üyesine yasaklı branch'i gösteriyor.
2. **Ekip tablosuna** `code-reviewer` satırına "(opus)" notu ekle, model dağılımı görünür olsun.

---

## Uygulama kontrol listesi

- [ ] Adım 1 — ortak blok 9 ajan dosyasına eklendi
- [ ] Adım 2 — `code-reviewer` checklist'i değişti, model `opus`
- [ ] Adım 3 — `data-analyst` `.env` çelişkisi çözüldü, `scripts/db-query.sh` eklendi, port 5434
- [ ] Adım 4 — `qa-engineer` bağımsız doğrulama + finansal test listesi
- [ ] Adım 5 — `settings.json`: checkout/pull çıktı, node daraltıldı, db-query eklendi
- [ ] Adım 6 — task şablonu + `blocked-unreachable` + `MIGRATION_SEQUENCE.md`
- [ ] Adım 7 — README frontend branch düzeltmesi
- [ ] `CLAUDE.md` revize sürümle değiştirildi

---

## Bilinçli olarak yapılmayanlar

**Yeni ajan eklenmedi.** "Wiring/integration ajanı" cazip görünüyor çünkü sekiz kez tekrarlanan
hata sınıfının sahibi yok. Ama dokuz ajan zaten delegasyon yükünün üst sınırında; onuncu, Team
Lead'in her görevde bir karar daha vermesi demek. **Erişilebilirlik bir rol değil, bir kapı** —
Done tanımına ve `code-reviewer` checklist'ine koyuldu.

**`rules.md` silinmedi.** Bugün tek makine-okunur domain kaynağı o. Yerine geçecek katman
(`SYSTEM_INVARIANTS.md` + ID'li kural seti) hazır olmadan silmek, ajanları kaynaksız bırakır.
Bunun yerine statüsü düşürüldü ve bilinen kayıpları işaretlendi.

**Otomatik guard'lar (lint/CI) bu turda yok.** Onlar Tur 2. Bu tur yalnızca talimat katmanı —
hiçbiri kod değişikliği gerektirmiyor, hepsi bugün uygulanabilir.
