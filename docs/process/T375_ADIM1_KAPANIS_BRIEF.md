# `T-375` ADIM 1 — **KAPANIŞ TURU** (dört kalem)

> Şerit: `backend-engineer` (yeni el) · Repo: `collmind.backend`
> ⛔ **Önce oku:** `docs/process/T375_ADIM1_KASKAD_BRIEF.md` (EK bölümü dahil) ·
> `docs/brd-v2/03_IS_KURALLARI/L2_01_*.md` → `K-2.2.1` · `K-2.2.3` · `K-2.2.3a` · `K-2.2.3b` ·
> `K-2.2.14` · `K-2.2.16` · `docs/brd-v2/04_KARAR_KAYDI.md` → **`Z102`** ·
> `.claude/backlog/tasks/T-375.md` · `T-378.md` · `CLAUDE.md` · `docs/DISIPLIN.md`

## 0. Bir önceki el nereye bıraktı (ve Team Lead bağımsız DOĞRULADI)

```
tsc 0 · guards 0 · unit 87 suite / 1537 test · T-047 PASS
e2e  12 suite / 74 test KIRMIZI · 52 suite yeşil
```

Yapılanlar: `budget.repository.ts`'te **tek kaskad** (`resolveEnvelopeForChannelStage`);
`category` **TS düzeyinde zorunlu** ⇒ kategori-kör çağrı yerleri **derleyici tarafından**
sayıldı (elle değil — bu projede elle sayı **on bir kez** yanlış çıktı); `CreateAgreementDto
.categoryId` zorunlu + FU↔kategori çapraz doğrulaması; DTO'daki sessiz `'GENERAL'`/`'UNKNOWN'`
varsayımları kaldırıldı (`§2.5`); migration `1829` yazıldı **ama bilinçli olarak DURUYOR**.

⛔ `ADIM 2`'nin (`1827`/`1828` + seed) ve `ADIM 1`'in dosyaları ağaçta **commit edilmemiş**
duruyor. Onlar senin tabanın — **geri alma, üstüne çalış.**

---

## KALEM 1 · `1829` → `NOT NULL` DEĞİL, **DURUMA-KOŞULLU `CHECK`** (Team Lead kararı)

Önceki el doğru DUR etti ama seçeneği bir **ürün** kararı sandı — değil, bir **modelleme**
kararı ve Team Lead'e ait. Karar:

```
NOT NULL   "bir zarf kategorisiz OLAMAZ"        ⇒ geçmiş satırlar retroaktif GEÇERSİZ ⇒ KİLİT
           ve kilit ancak VERİ UYDURARAK açılır — §2.5 bunu yasaklar
CHECK      "kategorisiz bir zarf CANLI OLAMAZ"  ⇒ kaskadın ZATEN uyguladığı invaryantın TA KENDİSİ
```

⭐ İkincisi **daha güçlüdür**: `CLOSED` bir zarfı `ACTIVE`'e geri döndürme yolunu **da** kapatır.
Düz `NOT NULL` bunu **ifade edemez**.

**Şart:**
- `status` terminal (`CLOSED` / `ARCHIVED`) ⇒ muaf; **aksi hâlde `category IS NOT NULL`**.
- ⛔ **`CASE` / `ELSE FALSE` ile yaz, `OR`-zinciriyle DEĞİL.** `Z87` NULL-collapse: `NULL = 'X'`
  → `NULL`, ve Postgres bir `CHECK`'in `NULL` sonucunu **GEÇERLİ SAYAR** (yalnız kesin `FALSE`
  reddeder). O tur bir `CHECK` tam bu yüzden yanlış satırı **kabul etti** — ve bunu yakalayan
  şey **negatif kontroldü**.
- ⛔ Negatif kontrolde **`NULL` girdi vakası ZORUNLU**, ve **`CLOSED → ACTIVE` geçiş denemesi**
  ayrı bir negatif kontrol olarak koşulsun (kısıtın asıl gücü orada).
- Migration **adını içeriğe uydur**; `1829000000000` numarası **aynı kalır**.
- Dosyadaki mevcut gerekçe bloğunu **SİLME** — `F12`: üstüne
  *"revize (2026-09-07, Team Lead kararı): `NOT NULL` → duruma-koşullu `CHECK`, gerekçe …"*.
- `Z100` şablonu bağlayıcı: üç-durum assert · şema-nitelendirme (`main`) · `run→revert→run`
  bayt-birebir.

---

## KALEM 2 · `role-journey` `E2` — **YETENEK PİNSİZ KALMAZ**

Önceki elin yakaladığı çelişki **gerçek ve önemli**: `categoryId` DTO-zorunlu olunca
`AgreementService#resolveEffectiveCategoryId`'nin **FU-zinciri fallback'i** `HTTP` üzerinden
**üretilemez** hâle geldi. O e2e bloğu bir **yeteneği** pinliyordu ve pin **imkânsızlaştı**.

⛔ **Yeteneği pinsiz bırakma.** Pini `agreement.service.spec.ts`'e taşı — fonksiyona
**doğrudan**, elde kurulmuş bir `Agreement` entity'siyle. **Üç dalın ÜÇÜ de:**
```
categoryId DOLU                      → o kazanır
categoryId boş + FU zinciri çözülür  → türetilen kategori
ikisi de yok                         → null + fail-closed uyarısı (log)
```
`role-journey`'deki eski bloğa **dokunma**; yerine bir yorum bırak:
*"bu bloğun pinlediği yetenek `<yeni spec>:<satır>`'a taşındı (`T-375` ADIM 1) — `HTTP` yolu
`K-2.2.3b` ile kapandı."*

📌 Ve bunu bir **task'a** bağla değil, **not** düş: `1830` (`NOT NULL`) indikten sonra bu
fallback **ulaşılamaz** hâle gelir ⇒ *"mekanizma var, yol yok"* sınıfının yeni üyesi olur.
`T-378` bunu zaten taşıyor — **yeni task açma**, oraya atıf ver.

---

## KALEM 3 · `T-028e` `JSDoc`'u — `F12`, ÇÜNKÜ OLDUĞU GİBİ DURURSA BİR KARARI **KORUR**

`agreement.service.ts:337` bugün şunu diyor:

> *"**DO NOT backfill** `agreements.category_id` from this — a copied value goes **stale** the
> moment the FU's category assignment changes upstream."*

Ve migration `1828` **tam olarak onu yaptı**. Çakışma gerçek ve `T-378`'de kayıtlı.

**Hüküm kazanır — ama gerekçesi DÜZELTİLEREK:** `K-2.2.3b` kategoriyi FU'dan **türetmiyor**;
ikisini **bağımsız iki olgu** yapıp **çapraz-doğruluyor**. Anlaşmanın kategorisi bir **ticari
kapsam beyanı**, FU'nunki bir **ürün sınıflandırması**; beyanın katalogla sınanması saklamayı
meşru kılan şeydir. Yani `INV-B-009`'un **istisnası değil, KAPSAMI DIŞI**.

⛔ `F12` uygula: eski cümle **silinmez**, üstü çizilir, altına
*"süperseded — `Z102 §4` / `K-2.2.3b`, 2026-09-07; gerekçe: **beyan ≠ kopya**; kalan
bayatlama riski `T-378`"*.

Gerekçe: olduğu gibi bırakılırsa **artık geçerli olmayan bir kararı koruma altına alır** —
`T-084` sınıfı (*"bir hatayı belgelemek onu koruma altına alır"*), ve bu satır kendini
*"Product decision (DB-verified)"* diye etiketlediği için **özellikle güçlü** bir koruma.

---

## KALEM 4 · KALAN e2e — SINIFINI **BİTİR**, ÖTEKİNİ **LİSTELE**

Team Lead'in kendi ölçtüğü on iki suite:
```
budget-block-threshold · budget-envelope-split · budget-tier-notification
budget-variance · empty-scope-contract · formula-canon-turnover-niv-and-rag-quadrant
on-invoice-ledger-invariants · on-invoice-split-envelope · optimistic-locking
plan-escalate-to-finance · plan-review-decision · role-journey
```

- **Senin sınıfın** = zorunlu hâle gelen alanları geçirmeyen **fixture**'lar ⇒ **BİTİR**.
  Mekanik olabilir, ama *"dosya sayısı fazla"* bir bitirme gerekçesi **değildir**.
- **`R2`/`R3` sınıfı** = eski modeli **ANLAMCA** pinleyen testler (`budget-variance`'ın
  *"seed envelope categoryId=NULL"* varsayımı · `role-journey`'nin eski CM ataması) ⇒
  **DOKUNMA**, `qa` şeridine gidecek. Her birini **dosya + neden** olarak listele.
- ⛔ **`on-invoice-ledger-invariants`'i "araştırılmadı" BIRAKMA.** *"2 `POSTED` bekleniyordu,
  1 geldi"* bir fixture uyuşmazlığı **da** olabilir, kaskadın **gerçek bir davranış
  değişikliği** de — ve ikincisi `INV-R-001/002`'ye dokunur, yani bir **finansal
  invaryanttır**. Hangisi olduğunu **ÖLÇ**. Ölçemezsen `ÖLÇEMEDİM` de (kapının üçüncü meşru
  çıktısı), ama **atlama**.

---

## ⛔ DUR / KURALLAR

- Reprodüksiyon-önce, **yönsüz**: *"kusur var"* demek *"kusur yok"* demek kadar bir iddiadır.
- Mutasyon: **kopyala → uygula → değiştirilen satırı `sed -n '<n>p'` ile BAS → ölç → kopyadan
  geri yükle → `shasum -a 256 -c`**. ⛔ `git checkout` ile geri alma **YASAK**.
- Mutasyon kırmızısı bir **assertion** olmalı — derleme hatası **başarısız bir deneydir**.
- Ölçüm **borusuz**: `cmd > log 2>&1; echo $?`.
- İlk komut: `docker ps --filter "label=com.docker.compose.project=tpm"` → **boş**.
- ⛔ `docs/brd-v2/**` **YAZMA** (yalnız Team Lead). `1826`/`1827`/`1828` **inmiş** — dokunma.
  `1830` **sonraki turun** — kullanma.
- ⛔ `git commit` / `git push` **YAPMA**.
- Belirsizlikte **DUR** — önceki el bunu iki kez yaptı ve ikisinde de haklıydı.
- ⛔ **Rapor: SAYI değil, LİSTE.**
