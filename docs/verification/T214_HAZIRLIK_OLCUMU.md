# `T-214` hazırlığı — `approval_policies`: katalog seçeneği ↔ tenant politikası

> **Ölçen:** Team Lead · **Tarih:** 2026-08-16 · **Kaynak:** canlı dev DB + kod
> **Amaç:** kararı ürün sahibine **ölçülmüş** olarak sunmak (`0056-K3` biçimi)
> **Bağlayıcı kaynak:** `L2_03` `K-2.5.13` · `K-2.5.13a`

---

## 1 · `approval_policies` bugün ne taşıyor

```
id · tenant_id(NOT NULL) · created_at · updated_at · deleted_at · created_by · updated_by
template(enum, NOT NULL) · amount_threshold(numeric, NULL) · delegate_allowed(bool, NOT NULL)
tier_roles(jsonb, NULL)
```

**Satır: 2** — ve ikisi de tek tenant'a ait:

| `template` | `amount_threshold` | `delegate_allowed` | `tier_roles` |
|---|---|---|---|
| `STANDARD` | `NULL` | `false` | `NULL` |
| `TWO_TIER` | `NULL` | `false` | `NULL` |

> ⚠️ **Politika alanlarının hepsi boş.** Yani bu iki satır bir *"politika"* değil, bir
> **şablon işareti** taşıyor — ve `tenant_id NOT NULL` olduğu için **zaten seçilmiş**
> sayılıyorlar.

## 2 · Seçim yolu — ⛔ **YOK**

```
ApprovalPolicy'yi import eden ÜRETİM dosyası     0
POZİTİF KONTROL  ApprovalRequest import eden    12
```

**Tabloyu okuyan hiçbir kod yolu yok.** Bir plan hangi politikayı alıyor sorusunun bugünkü
cevabı: **hiçbirini** — onay akışı `users.role` üzerinden koşuyor.

📌 `T-223`/`T-233`'ün sınıfı: **yapı var, yol yok.** Ama burada bir fark var ve karar için
önemlidir → **§4**.

## 3 · Katalog izi — enum'da VAR, veride YOK

```
main.approval_policy_template_enum   STANDARD · TWO_TIER · THRESHOLD
seed (approval-policy.seed.ts)       STANDARD · TWO_TIER          ← THRESHOLD YOK
entity                               ApprovalPolicyTemplate, üç değer
```

⚠️ **`THRESHOLD` (`EŞİKLİ`) enum'da tanımlı ama hiçbir satırı yok** — ve bu bilinçli:
`B` dalgasında şekli yazılamadı, `T-214`'e devredildi. `K-2.5.13a` onu şöyle tanımlıyor:

> *"**Eşikli** — Tutar `< X` tek onay · `≥ X` finans eklenir"*

Yani `EŞİKLİ`'nin **bir parametresi var** (`X` = `amount_threshold`), diğer iki şablonun
yok. **Ayrımın gerekip gerekmediği tam burada görünüyor.**

---

## 4 · Kararın çerçevesi

`K-2.5.13`: *"Onay politikaları bir **tabloda** yaşar, kodda değil."*
`K-2.5.13a`: tablo **üç görüşlü şablonla** doğar.

**Soru:** *"katalog seçeneği"* (hangi şablonlar VAR) ile *"tenant politikası"* (bu tenant
hangisini SEÇTİ, ve parametresi ne) **iki ayrı kavram mı**, yoksa bir mi?

Bugünkü şema **birleştiriyor**: `tenant_id NOT NULL` → bir satır **zaten** bir seçim.
Katalog *"hangi şablonlar mümkün"* bilgisi yalnız **enum'da** yaşıyor.

| yol | sonuç |
|---|---|
| **(a) Bugünkü şema doğru — ayrım GEREKMİYOR** | Katalog = enum, seçim = satır. `EŞİKLİ` bir satır olarak eklenir, `amount_threshold` dolar. ✅ Şema değişmez, seed tamamlanır. ⚠️ Ama *"bu tenant hangi şablonları görebilir"* sorusu **sorulamaz** — hepsi ya da hiçbiri |
| **(b) İki kavram ayrılsın** | `policy_templates` (katalog, tenant'sız) + `approval_policies` (tenant'ın seçimi + parametre). ⚠️ Yeni tablo + migration. Ve `0056-K3(b)`'nin dersi burada da geçerli: **katalog kodda da yaşayabilir** — enum zaten öyle |
| **(c) Şimdilik `EŞİKLİ`'yi ekle, ayrımı ertele** | ⚠️ `T-233`'ün vakası: erteleme kararı **görünmez** kılar. Ve bugün **hiç tüketici yok**, yani ayrımı yapmanın en ucuz anı **şimdi** |

---

## 5 · Karar için üç ölçülmüş girdi

**1 · Bugün hiç tüketici yok — yani şema değişikliğinin göç riski SIFIR.**
`0 import` (pozitif kontrol `12`). Bir okuyucu olsaydı `(b)` pahalı olurdu; bugün değil.
**Bu, ayrımı yapmanın (ya da yapmamaya karar vermenin) EN UCUZ anı.**

**2 · `0056-K3(b)`'nin dersi doğrudan uygulanabilir.** Orada *"yetenek kodda mı, tabloda
mı"* soruldu ve **kod** seçildi — çünkü tenant başına özelleştirme istenmiyordu. Burada
aynı soru: **katalog** kodda mı (enum, bugünkü hâl) tabloda mı? Fark şu ki `EŞİKLİ`'nin
**parametresi** (`X`) tenant başına değişir — yani **seçim** mutlaka veri, ama **katalog**
olması gerekmez.

**3 · `tier_roles` (jsonb) bugün `NULL` ve hiç yazılmıyor.** `ÇİFT_KADEME`'nin kimleri
kapsadığı bir alan olarak duruyor ama boş. Karar bu alanı da kapsamalı — yoksa `T-233`'ün
sınıfına düşer.

---

## 6 · ⚠️ Bir sınır — bu karar `Adım 3`'ün TAMAMINI bloklamıyor

```
T-214 blokluyor        approval_policies'in şekli  →  ADIM 3'ün politika yarısı
T-214 BLOKLAMIYOR      K-2.6.3 (yetenek modeli)    →  0056-K3(b) ile kararlaştırıldı
```

> **`T-214` uzun sürerse yetenek modeli önce gidebilir.** İkisi aynı adımda ama farklı
> bağımlılıkta — ve bu ayrım yazılmazsa `Adım 3` tümüyle beklemeye alınır.
