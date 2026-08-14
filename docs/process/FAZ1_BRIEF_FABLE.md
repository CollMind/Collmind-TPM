# `Faz 1` planlama brief'i — Fable

> **Kanonik girdi:** [`docs/analysis/0071-faz-0-durum-fotografi.md`](../analysis/0071-faz-0-durum-fotografi.md)
> **Tarih:** 2026-08-15 · **Yazan:** Team Lead · **Alıcı:** Fable
> **Çıktı:** `Faz 1` planı — **plan, kod değil.**

---

## 0 · İşin şekli

`Faz 1`, `L1 §1.14`'ün *"atlanmış taban"* dediği şeydir. `L1`'in kendi cümlesi:

> *"Faz 2 yetenekleri inşa edilirken Faz 1 tabanı atlanmış."*
> *"Faz 2'nin eksik yarısı, Faz 1 tabanının üstünde duruyor."*

Yani **`önce taban` bir tercih değil, `Faz 2`'nin de ön koşulu.** Plan bu sıralamayı
tartışmayı değil, **uygulanabilir hâle getirmeyi** hedefler.

---

## 1 · ⚡ İşin gerçek yükü — ve neden tek sayı YANLIŞ

`0071 §6` bir ayrım ölçtü, ve **bu ayrım planın şeklini belirler:**

```
11  ihlal      kod VAR, yanlış     →  DÜZELTİLİR   →  REGRESYON riski
18  eksiklik   kod YOK             →  İNŞA EDİLİR  →  KAPSAM riski
```

İkisi **farklı iş türü ve farklı risk** taşır. Tek bir *"29 kural ihlal ediliyor"*
sayısı planı yanlış boyutlandırır: düzeltme mevcut davranışı kırabilir, inşa ise
bitmeyebilir.

### `Faz 1`'e adreslenen 12 kalem

```
4   İHLAL — yetki/onay (kod var, yanlış)
      K-2.5.11    ön koşul: B dalgası S13
      K-2.5.16b   bir yol gönderen alanını boşaltıyor
      K-2.6.6     tanımlanmamış uç nokta HERKESE AÇIK
      K-2.6.9     müşteri filtresi bir ayarla KAPALI

5   EKSİKLİK — Faz 1 çekirdeği (kod yok)
      K-2.6.3     kullanıcı tek rol taşıyor, yetenekler tanımsız
      K-2.6.12    DB seviyesinde hiçbir politika yok
      K-2.7.2     yönetim modülünde işaret yok (39 yazma ucu)
      K-2.11.5    alan var, HİÇBİR YAZARI yok
      K-2.11.7    kural yazılı, mekanizması yok

3   EKSİKLİK — HUKUKA bağlı, ayrı kuyruk
      K-2.8.11 · K-2.9.5 · K-2.9.7    (saklama/arşiv/anonimleştirme)
```

> ⚠️ **Bu bir bulgu sayısı değil, bir sınıflandırma** — ve `0071 §6` onu `❌` satırlarının
> **metninden** çıkardı. Her kalemin `Faz 1` kapsamına girip girmediği **ürün sahibi onayı**
> ister. Ve `K-2.4.22c` **iki** ihlal taşıyor, yani `11` alt sınırdır.
>
> **Planda bu sayıyı yeniden üretme — `0071`'e atıf ver.**

---

## 2 · ⛔ KISIT: `Faz 1` korumasız koşacak

**Bu bir varsayım değil, ölçülmüş bir kısıttır.** Dört mekanizmanın hiçbiri `Faz 1`
boyunca ayırt etmeyecek:

| mekanizma | hâli | plan için ne demek |
|---|---|---|
| entity listesi **pin testi** | `it.skip` (`T-224` → `T-225`) | yeni tablo listeden düşerse **sessiz** — `B` dalgasında tam olarak bu oldu, **e2e 17/17 kırıldı** |
| **`money-float` ratchet** | kapıda **değil**, 168 bulgu | para kusuru artabilir, kırmızıya dönmez |
| **`lint`** | kapıda **değil**, 108 error | `T-100` (kapsam boşalıyor) + `T-113` (hep kırmızı) — **her iki yönden** işlevsiz |
| **`mode-split` ratchet** | **satır** sayıyor | iki kez içeriği deforme etti, bir kez **meşru bir işi engelledi** |

> ### 📌 Bunun `Faz 1` için anlamı somut
>
> `RLS` ve rol modeli işleri **şema ağırlıklıdır** — yani tam olarak pin testinin ve
> ratchet'lerin koruyacağı sınıf. O işler bugün **ayırt etmeyen kapıların gözetiminde**
> yazılacak.
>
> **Plan `T-212` ve `T-113`'ü ya `Faz 1`'den önce, ya ilk kalemi olarak konumlandırmalı** —
> ve eğer konumlandırmıyorsa, **neden konumlandırmadığını yazmalı.**

---

## 3 · Beş kalemin bugünkü hâli (`L1 §1.14`)

| kalem | kayıt | plan için not |
|---|---|---|
| **`K-2.6.13` DB rolleri** | `_ISSUE_DB_ROLU.md` — issue **taslağı hazır**, hiç başlamadı. Ölçülmüş: *"tek giriş rolü var ve **ayrıcalıklı**"* | ⚠️ `K-2.6.13a` ve **kabul testi tanımı ürün sahibinden bekliyor** — plan bunu bir **bağımlılık** olarak göstermeli |
| **RLS** | `K-2.6.12`: *"DB seviyesinde **hiçbir** politika tanımlı değil"* · `0056`: `tenant_id` **taşımayan 4 tablo** (`tenants`·`migrations`·`typeorm_metadata`+1) | ⛔ **Toplam tablo sayısı kayıtta YOK.** Bir *"`0/N` tablo"* ifadesi kullanma — `N` ölçülmemiştir |
| **rol modeli** | `K-2.6.3`: tek rol, yetenek yok. `B` dalgasında şema indi (`R2a`/`R2b`), RBAC hâlâ `users.role`'dan | rol ailesi seed'i **yazılamadı** — `0056-K3` kararına bağlı, **açık** |
| **politika tabloları** | şema indi, **üretim yolu yok** | `T-214` ile kesişiyor: katalog seçeneği ↔ tenant politikası **aynı satırda**, ayrım yok |
| **denetim olay sözlüğü** | `L1 §1.14`: **`❌ eksik`** — ve bu **tek kayıt** | ⚠️ arkasında task/ölçüm/kabul kriteri **yok** → **ölçülmedi**, *"yok"* değil |
| **zamanlayıcı** | `L1`: *"Otomatik zaman aşımı — **ölçüm sonrası**"* | ⚠️ bilinçli ertelenmiş, ve o ölçümün yapıldığına dair kayıt **yok** |

> **Son ikisi için plan bir ölçüm adımı içermeli** — doğrudan bir inşa kalemi değil.
> İş büyüklüğü bilinmiyor, ve bilinmediğini bilmek planın parçası.

---

## 4 · Açık kararlar — plan bunları BEKLETMEMELİ, ama SAYMALI

| konu | durum | `Faz 1`'e etkisi |
|---|---|---|
| **Hukuk paketi** (`KT-3`, **dört soru**) | ⛔ **hiç gönderilmedi** | 3 `Faz 1` kalemini (saklama/arşiv/anonimleştirme) besliyor. **Uzun kuyruklu** — cevabı `Faz 1` içinde gelirse tasarım yeniden yapılır |
| `T-214` katalog/seçim modeli | `todo` · `P2` | ⚠️ **politika tabloları kalemiyle doğrudan kesişiyor** |
| `T-225` `BudgetReservation` | `todo` · `P1` | pin testini bloklıyor → dolaylı olarak `Faz 1` şema güvenliğini |
| `T-209` `discount_amount` | `todo` · `P1` | **üretim verisi ister** — `Faz 1` dışı, ama kuyruğa girmeli |

> 📌 `K-2.9.0` **`⏸️ GEÇİCİ ASKI`** taşıyor ve `L2`'nin *"açık kural = 0"* çıktısı onu
> **saymıyor** — farklı işaret, farklı desen. Eşik doğru (askı **dayanaklı**), ama
> `0`'ı *"hiçbir şey beklemiyor"* diye okuma. (`T-212` dördüncü kalem.)

---

## 5 · ⛔ DUR koşulları

Aşağıdakilerden biriyle karşılaşırsan **plan üretmeyi kes ve bildir:**

1. Bir kalemin `Faz 1` kapsamına girip girmediği **kaynaklardan çıkarılamıyorsa** —
   `0071 §6`'nın sınıflandırması bir **öneridir**, ürün sahibi onayı ister.
2. Bir sayıya ihtiyacın var ve **kayıtta yoksa.** *"Makul bir tahmin"* yazma;
   **`ölçülmedi`** yaz. (`RLS 0/43` bu oturumda tam olarak böyle uyduruldu.)
3. Bir plan kalemi **`L2` metnini değiştirmeyi** gerektiriyorsa — `L2`'yi **yalnız Team
   Lead** yazar, ve **tek kanaldan**.
4. Bir kalem **migration** gerektiriyorsa — numarayı **sen seçme**,
   `.claude/backlog/MIGRATION_SEQUENCE.md`'den Team Lead tahsis eder.
5. Plan bir **sınır** geçiyorsa, o sınırı **say**: şema · API · **tel protokolü** ·
   dosya biçimi · **öbür repo**. `B` dalgasında rol enum'unun **değerleri** değişti,
   dört kapı yeşil kaldı, **her rol kapılı rota kapandı** — çünkü değer bir tel
   protokolüdür.

---

## 6 · Ölçüm hijyeni (bu oturumda her biri en az bir kez ısırdı)

- **Sayı değil liste.** Enumerasyonu olmayan bir sayı bir karara dayanak yapılamaz.
- **`kayıtta yok` ≠ `yok`.** İkisi farklı iddia, farklı iş büyüklüğü.
- **Bir sayıyı örneksiz raporlama.** Bir sayı bir bulguyu **çürütüyorsa** örnek zorunlu.
- **Negatif sonuç pozitif kontrolsüz yazılmaz.** `0 bulgu` kendini hiçbir zaman yanlış
  olarak göstermez.
- **Bir kabul listesi, değişikliğin BOZABİLECEĞİNİ de saymalı** — yalnız eklediğini değil.
- **Bir düzeltme, düzelttiği sınıfın yeni bir vakasını üretebilir.** `T-229` bunun
  canlı örneği ve bu turda doğdu.

---

## 7 · Beklenen çıktının şekli

```
Faz 1 planı
  · kalemler       — 0071 §6'nın 12 kalemine ATIF vererek, yeniden sayarak DEĞİL
  · sıralama       — bağımlılıklarıyla (K-2.6.13 → RLS → rol modeli → politika)
  · ön koşullar    — hangi kalem hangi AÇIK KARARI bekliyor
  · guard kalemi   — T-212/T-113 nerede duruyor, ve durmuyor'sa NEDEN
  · ölçüm adımları — denetim sözlüğü ve zamanlayıcı için (iş büyüklüğü bilinmiyor)
  · kapsam DIŞI    — ve her biri için bir cümle gerekçe
```

⚠️ **Plan bir tahmin içeriyorsa, tahmin olduğunu yazsın.** Bu depoda bir tahminin
*"ölçüldü"* diye taşınması **altı kez** oldu; her seferinde bir sonraki tur onu
gerçek sandı.

---

## Kaynaklar

`docs/analysis/0071-faz-0-durum-fotografi.md` (**kanonik**) ·
`docs/brd-v2/02_YETENEK_HARITASI.md §1.14` · `docs/brd-v2/03_IS_KURALLARI/L2_*` ·
`docs/brd-v2/_ISSUE_DB_ROLU.md` · `docs/decisions/KARAR_TURU_BES_KONU.md` `KT-3` ·
`docs/decisions/OPEN_DECISIONS.md` · `docs/analysis/0056-rbac-ve-rls-tasarim-notu.md` ·
`.claude/backlog/tasks/{T-113,T-209,T-212,T-214,T-224,T-225}.md` · `CLAUDE.md`
