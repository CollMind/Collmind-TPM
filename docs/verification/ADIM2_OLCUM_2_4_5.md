# `ADIM 2` · Ölçüm 2 · 4 · 5 — kod okuma turu

> **Ölçen:** `code-reviewer` · **Doğrulayan:** Team Lead (dört iddia bağımsız)
> **Tarih:** 2026-08-15 · **Plan:** `docs/process/FAZ1_PLAN.md §4`
> **Kapsam sınırı:** yalnız `collmind.backend/src` + `collmind.frontend/src|tests`.
> DB içeriği **kapsam dışı** (kalem 1/3). Kod değiştirilmedi.

---

## Kalem 2 · Denetim envanteri

### Sözlük var mı → ❌ **kanonik sözlük YOK, dört ayrı aile var**

| aile | sözlük alanı | tipi |
|---|---|---|
| `admin_audit_logs` | `action_type` + `entity_type` | **`varchar` — enum YOK, CHECK YOK, TS union YOK** |
| `plan_approval_history` | `action` | PG + TS enum, 9 değer |
| `budget_transaction_logs` | `transaction_type` | PG enum, 7 değer, **küçük harf** |
| `budget_transactions` | `tx_type` | PG enum, 8 değer, **BÜYÜK harf** |

🔴 **Son ikisi aynı TypeScript adını taşıyor** → [[T-231]] (Team Lead doğruladı).

### İki soru ayrı ayrı

```
olay üretiliyor mu?      ⚠️ kısmen — 15 üretim çağrı noktası
olayın SÖZLÜĞÜ var mı?   ❌ hayır
```

### `39 yazma ucu` — doğrulandı, ama iki nitelik eklendi

`master-data`'da **39** uç / **11** controller (`0053 §4` ile birebir). Sınıf kırılımı:

| sınıf | adet | üretmeli mi | bugün üretiyor |
|---|---|---|---|
| S1 · durum değiştiren, CollMind sahipli | 21 | ✅ | **4/21** |
| S2 · durum değiştiren, ERP sahipli | 15 | ✅ + `K-2.7.2` kaynak işareti | **3/15** |
| S3 · yan etkisiz sorgu (`POST` ama yazma değil) | 4 | ❌ | 0 — doğru |
| S4 · toplu konfigürasyon (`POST /kpis/seed-defaults`) | 1 | ✅ **yüksek riskli** | **0** |

⚠️ **`L2_02 K-2.7.2`'nin cümlesi iki okumaya açık.** *"39 yazma ucu var ve **beşi** …"* —
düz okunuşu **5 uç**; kaynak (`0053 §4`) **5 controller** diyor, yani **15 uç**. On uçluk
sessiz eksik sayım. ⛔ `L2` **donmuş** — düzeltme karar defterine kayıtla girer.

⚠️ **Ve kümenin sınırı `modules/master-data`.** ERP sahipli veriyi yazan uçların hepsi o
kümede **değil**: `customer.controller.ts` **7 yazma ucu**, denetim olayı **0**. Gerçek
maruziyet **en az 22 uç**.

### İki sessiz sınıf (`§2.5` şekli)

- **Sessiz atlama:** `mechanic.service.ts` ×3 · `channel.service.ts` ×3 →
  `if (adminId && adminEmail) { …log… }`, **`else` yok**. Kimlik gelmezse mutasyon olur,
  denetim satırı **sessizce yazılmaz**. Bugün HTTP'den ulaşılmıyor — ama koruma yazılı
  olmayan bir garantiye yaslanıyor.
- **Sessiz boş değer:** `approval-workflow.service.ts:919-922` → `plan.submittedBy?.id || ''`,
  ve ilişki `plan.repository.ts`'te **yorum satırı** (*"TODO: Uncomment after migration"* —
  migration çoktan var). Canlı `GET /plans/approval-queue` her satırda boş kimlik dönüyor.

### Sözlük kaleminin iş büyüklüğü — ölü/eksik uçlar

`ApprovalHistoryAction`'ın **3 değerinin yazarı yok** · `isHighRiskAction`'ın **7
kuralından 3'ü ulaşılamaz** · **anlaşma oluşturma ve silme denetimsiz** · **plan yaşam
döngüsü `admin_audit_logs`'a hiç yazmıyor** · **erişim grubu (giriş/çıkış/yetki reddi)
sıfır** · `K-2.11.7` (DB değişmezliği) **mekanizma yok** · `K-2.11.6` gerilimi: denetim
satırı **uygulama katmanında `UPDATE` ediliyor**.

Ölçek: backend'de toplam **119** yazma ucu, **15**'i denetim üretiyor.

---

## Kalem 4 · `T-205` — `submittedById`'yi boşaltan yol

**Tek yol:** `POST /plans/:id/return-to-draft` → `PlanService.returnToDraft` →
`updateStatusCas(REJECTED → DRAFT)`, `plan.service.ts:1870-1875`.

**Neden:** kodun kendi gerekçesi *"`T-033`: bunlar geçerli-durum alanları, geçmiş
`plan_approval_history`'de duruyor"*. `K-2.5.16` tam bu muhakemeyi reddediyor — alan bir
**köken** alanıdır.

**Kaç yol → LİSTE:** bir yol, **iki alan**. `rejectedById` de aynı blokta (→ [[T-205]]
kapsam sorusu). Ham SQL'de `= NULL` **0** — ve bu negatifin **pozitif kontrolü var**
(aynı token'lar korpusta 40+ kez).

**Okuma yolları — altısı da etkilenmiyor**, ve **frontend tüketicisi SIFIR** (pozitif
kontrol: `PENDING_APPROVAL` aynı korpusta 4 dosyada). Yani `T-205`'in beklediği görünür
UI sürprizi **gerçekleşmiyor**.

⚠️ **Aciliyet bir kod yolu değil, bir VERİ DURUMU** — ayrıntı `T-205`'te.

---

## Kalem 5 · `K-2.6.9` filtresi — `A7`'nin üç ekseni

Tek uygulama noktası: `access-scope.service.ts` (`UserScope`'un tek üretim tüketicisi,
16 çağrı noktası).

| eksen | durum | kanıt |
|---|---|---|
| **kanal** | 🔴 **UYGULANMIYOR** | `access-scope.service.ts`'te `channelId` → **0**. POZİTİF KONTROL: `cplId` 20 · `categoryId` 22. Kolon **var** (`user-scope.entity.ts`), motor **okumuyor** |
| **müşteri (CPL)** | 🟡 kod var, **hiçbir rolde etkin değil** | `PLANNER` bayrağa bağlı; `CATEGORY_MANAGER` için `cplId` **açıkça `null`'a normalize** ediliyor; diğer üç rol `UNRESTRICTED` |
| **kategori** | 🟡 yalnız `CATEGORY_MANAGER`'da aktif | `PLANNER` bayrağa bağlı |

**Bayrak ölçüldü:** `SCOPE_ENFORCEMENT_ENABLED` **hiçbir** `.env`/`compose`/deploy
dosyasında set edilmemiş (POZİTİF KONTROL: kodda **5** dosyada okunuyor) → `=== 'true'`
daima **false**. Karar `0056-K6` olarak açık.

`K-2.6.8a` (boş kapsam = erişim yok) ✅ **uyguluyor** — `1=0` predicate'i.

### ⚡ `[VARSAYIM]` çözüldü: cevap **"ayar mı, inşa mı"** değil — **İKİSİ**

```
kategori        AYAR    bayrak + backfill doğrulaması
müşteri (CPL)   AYAR    aynı bayrak + CM normalizasyonu ayrı KARAR
kanal           İNŞA    ScopePair'e üçüncü boyut, üç fonksiyonda, yönetim ucu, test matrisi
```

Plan `§6`'nın *"ayarı aç ya da kapsam çözümlemesini kur"* ikilemi **tekil bir cevap
varsayıyordu**; ölçüm eksen bazında ayrışıyor.

---

## ⛔ Ürün sahibine taşınan üç nokta

1. **`K-2.7.2`'nin *"beşi"*** — 5 uç mu, 5 controller (=15 uç) mü? `L2` **donmuş**;
   düzeltme karar defterine kayıtla girer.
2. **`CATEGORY_MANAGER`'ın CPL ekseni bilerek düşürülüyor** (`access-scope.service.ts`,
   gerekçe kod yorumunda: *"BRD: kategori sahibi, kanaldan bağımsız"*). `A7`/`K-2.6.7`
   bu istisnayı **anmıyor** — sapma mı, kapsanmayan ayrıntı mı?
3. **`T-205` kapsamı** `submittedById` literaliyle tanımlı; `rejectedById` aynı blokta.
   `K-2.5.16` sınıf olarak ikisini de kapsıyor.
