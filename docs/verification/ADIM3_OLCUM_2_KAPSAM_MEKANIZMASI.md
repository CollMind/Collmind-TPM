# `ADIM 3` ölçüm 2 — `resolveScopeForFilter` ↔ `K-2.6.7`'nin üç ekseni

> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **Kaynak:** kod + `L2_03 §2.6.3`
> **İsteme listesi:** `0073 §5/2` · **Amaç:** `İlke 4` gerilimini çözmek

---

## 0 · Sorulan soru ve ön beklenti tablosu

Ürün sahibinin ön beklentisi (ölçümden **önce** yazıldı):

| şık | sonuç |
|---|---|
| **aynı mekanizma** | gerilim yok — `A` sınıfı `Adım 4`'e temiz devreder |
| **ayrı mekanizma** | **iki mekanizma zaten yaşıyor** → bulgu, `Adım 3`'ten büyük |

**Çıkan sonuç şıklardan hiçbiri değil** — ve üçüncüsü ikisinden de ağır.

---

## 1 · CEVAP — **AYNI MEKANİZMA.** `İlke 4` gerilimi YOK

`resolveScopeForFilter` bir mekanizma değil, **iki satırlık bir sarmalayıcı**:

```ts
// plan.service.ts:410
private async resolveScopeForFilter(tenantId, actor?) {
  if (!actor) return undefined;
  return this.accessScope.resolveScope(tenantId, actor.userId, actor.role);
}
```

Gerçek mekanizma **`AccessScopeService`** (`src/modules/shared/access-scope/`), ve
kendi başlığında amacı yazılı: *"Tek çıkış noktası: scope mantığı elle **üçüncü kez**
yazılmayacak."*

**Ve tekilleştirme yapılmış** — `T-028d` ad-hoc kopyaları taşımış:

```
resolveCplScope  bugün yalnız  dashboard.module.ts yorumunda + migration 1779 yorumunda
                 yani ÜRETİM KODUNDA SIFIR

AccessScopeService tüketicileri  plan.repository · agreement.repository ·
                                 approval-workflow · dashboard · settlement-summary ·
                                 finance-reporting.budget-variance
```

📌 **Eksenler de örtüşüyor.** `ScopePair = { cplId, categoryId }`; `cpls` tablosu
`channel_id`'yi **NOT NULL** taşıyor (`cpl.entity.ts:27`) — yani `cplId` hem **müşteri**
hem **kanal**'ı belirliyor, `categoryId` üçüncü ekseni veriyor. `K-2.6.7`'nin
*kanal · müşteri · kategori* üçlüsü **karşılanıyor**.

> ⚠️ Bir nitelik: kanal **türetilmiş** bir eksen. *"X kanalındaki tüm müşteriler"*
> diye bir kapsam **yazılamaz** — müşteriler tek tek sayılır. `K-2.6.7b`
> (*"dördüncü bir eksen eklenmez"*) bunu yasaklamıyor; kanal zaten üçün içinde.
> Ama bir kapsam **ataması** yaparken bu fark ergonomiye biner. `[GEREKÇELİ]`

---

## 2 · ⛔ ASIL BULGU — mekanizma doğru, ve **beş rolün dördünde KAPALI**

`AccessScopeService.resolveScope` (`access-scope.service.ts`) ölçüldü:

```
UNRESTRICTED_ROLES = { ADMIN, FINANCE, READONLY }      → kod sabiti, koşulsuz
PLANNER  &&  !scopeEnforcementEnabled                  → UNRESTRICTED
CATEGORY_MANAGER                                        → buildScope(rows)   ← TEK gerçek daraltma
```

**Ve bayrak hiçbir yerde tanımlı değil:**

```
SCOPE_ENFORCEMENT_ENABLED  .env            0 anahtar
                           .env.example    yok
                           docker-compose  yok
                           varsayılan      'true' değilse false   (access-scope.service.ts:118)
```

> **Bugün `5` rolün `1`'i kapsam filtresine tabi.**

### Bunun `0072 §4c`'ye etkisi — `A` sınıfının gerekçesi zayıflıyor

`0073` şöyle diyordu: *"`A` (servis kapsamlı): genişliği meşru — `@Roles` kaba kapı,
**gerçek daraltma serviste**."*

Ölçüm: o daraltma bugün **`CATEGORY_MANAGER` dışında hiçbir rol için** olmuyor.

```
                     @Roles yüzeyi      servis daraltması BUGÜN
A sınıfı (11 route)      5/5             yalnız CATEGORY_MANAGER
C sınıfı ( 6 route)      5/5             YOK
```

Yani `A` ile `C`, **dört rol için davranışsal olarak aynı**. Sınıf ayrımı yanlış değil —
mekanizma gerçekten farklı — ama *"`A`'nın genişliği meşru"* gerekçesi bugünkü
davranışa değil, **bayrak açıldığındaki** davranışa dayanıyor. `[ÖLÇÜLDÜ]`

---

## 3 · Ve bayrak bir unutma DEĞİL — kapanış şartının SAĞLAYICISI yok

`T-028c` (`done`, 2026-07-28) bilinçli karar: *"Planner scope enforcement — flag'li
(varsayılan kapalı)"*. Gerekçe `access-scope.service.ts` başlığında yazılı:

> *"PLANNER scope enforcement'ı açıldığı anda scope satırı olmayan HER PLANNER 'her
> şeyi kaybeder' (fail-closed, `R-2`) — **prod/UAT'de backfill migration'ı
> doğrulanana kadar** bu YIKICI olur."*

⚠️ **Ve şartın sağlayıcısı bugün yok:** *"prod/UAT'de doğrulanana kadar"* — CTPM
**yalnız lokal geliştirme ortamında koşuyor, deploy edilmiş staging/production yok**
(`CLAUDE.md §1`, 2026-08-03 denetimi).

> Yani şart karşılanamıyor değil — **karşılayacak ortam yok.** Bayrak
> `2026-07-28`'den beri kapalı ve kendiliğinden açılamaz.

📌 **Bu, `0073`'ün `report-only` çürütmesiyle AYNI ŞEKİL** — ve bu, ikinci vakası:

```
report-only     "envanter fiili trafikte doğrulanır"        → fiili trafik YOK
T-028c bayrağı  "prod/UAT'de backfill doğrulanana kadar"    → prod/UAT YOK
```

**İki kalem de doğru yazılmış, ikisi de var olmayan bir ortama adresli.** Bir şart
karşılanamıyorsa iki sonuç doğar: iş kilitlenir, ya da şart uydurma veriyle
karşılanır — birincisi oldu, ve **sessizce**.

⚠️ Ve `K-2.6.9` bunu zaten *"ölçülmüş sapma"* diye kaydetmişti: *"filtre bugün bir
ayarla kapalı — bir planlamacı tüm müşterilerin verisini görüyor."* **Sapma
biliniyordu; adresi ve kapanamama sebebi bilinmiyordu.** Bu belge onu veriyor.

---

## 4 · `Adım 3` / `Adım 4` sınırına etkisi

| soru | cevap |
|---|---|
| `İlke 4` gerilimi var mı | **YOK** — tek servis, kopyalar `T-028d`'de taşınmış `[ÖLÇÜLDÜ]` |
| `A` sınıfı `Adım 4`'e temiz devreder mi | **Evet** — ama *"daraltma serviste"* gerekçesi bugün `1/5` rol için geçerli `[ÖLÇÜLDÜ]` |
| `Faz B`'nin kapsamı değişir mi | **Hayır** — yetenek katmanı ile kapsam katmanı ayrı kalıyor (`0073` Soru 1) `[GEREKÇELİ]` |
| Yeni bir kalem doğuyor mu | **Evet** → [[T-235]]: bayrağın kapanış şartı var olmayan bir ortama adresli |

📌 Ve `0073 §5/2` bu ölçümle **kapandı**. Kalan üç ölçüm: `§5/1` (dar-kümeli `READ`
sınıfı) · `§5/3` (onay görme tarafı) · `§5/4` (e2e route kapsamı).
