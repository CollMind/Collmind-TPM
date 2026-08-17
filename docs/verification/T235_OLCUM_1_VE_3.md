# `T-235` ölçüm 1 + 3 — `UNRESTRICTED_ROLES` ↔ `K-2.6.8a` · `buildScope()` gerçekten daraltıyor mu

> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **Kaynak:** kod + **canlı dev DB**
> **`DUR` koşulu (ürün sahibi):** *"`CATEGORY_MANAGER` için de daraltmıyorsa, kapsam
> filtresi hiç çalışmıyor — ve o `Adım 4`'ten büyük."*

---

## 1 · Kalem 3 (DAVRANIŞSAL) — `DUR` koşulu **TETİKLENMEDİ**: `buildScope()` daraltıyor

`CATEGORY_MANAGER` için mantık doğru ve **veri de daraltıyor**:

```
gerçek joker satırı (cpl_id NULL VE category_id NULL)   →  5 rolün HİÇBİRİNDE yok  (0)
CM başına ETKİN kategori kapsamı                        →  1 · 2 · 2   (toplam 8 kategoriden)
PLANNER satırları                                       →  28, HEPSİNDE cpl_id DOLU
```

> ⚠️ İlk sorgum **yanlış** çıkmıştı: `LEFT JOIN`'de scope satırı **olmayan** kullanıcı da
> `cpl_id IS NULL AND category_id IS NULL` koşulunu sağlıyor ve *"joker satır var"* gibi
> görünüyordu. `us.id IS NOT NULL` eklenince gerçek joker **`0`** çıktı. Sonuç makul
> göründüğü için neredeyse geçiyordu.

**Sonuç:** `DUR` koşulu tetiklenmedi. Ve bayrak açılırsa `PLANNER` de gerçekten daralır
(28 satırın hepsi `cpl_id` taşıyor, joker yok).

---

## 2 · ⛔ AMA daraltma DOĞRU VERİYLE yapılmıyor — `115 / 148` satır ÖKSÜZ

```
main.user_scopes                    148 satır
  category_id NULL                   28    PLANNER — "her kategori", meşru
  category_id ÖKSÜZ                 115    ← main.categories'te KARŞILIĞI YOK
  category_id GEÇERLİ                 5
```

**Kök neden ölçüldü — eksik bir yabancı anahtar:**

```
FK_user_scopes_cpl      cpl_id     → main.cpls(id)     ON DELETE CASCADE
FK_user_scopes_tenant   tenant_id  → main.tenants(id)  ON DELETE CASCADE
FK_user_scopes_user     user_id    → main.users(id)    ON DELETE CASCADE
                        category_id → ⛔ FK YOK
```

Aynı tabloda üç FK var, **dördüncüsü yok** — ve yokluğu doğuran migration'da:
`1779000000000-CreateUserScopes.ts` `(user_id, cpl_id, category_id)` için bir **UNIQUE
index** yazıyor ama `category_id` için **FK yazmıyor**.

⚠️ **Ve entity ile katalog AYRIŞMIŞ:** `user-scope.entity.ts:41-43` ilişkiyi **tanımlıyor**

```ts
@ManyToOne(() => Category, { nullable: true })
@JoinColumn({ name: 'category_id' })
category?: Category;
```

TypeORM bir ilişki olduğunu sanıyor, PostgreSQL **zorlamıyor**. `cpl_id`'de `CASCADE`
olduğu için orada öksüz **imkânsız**; `category_id`'de **birikiyor**.

**Birikim tarihli:** `2026-07-27` (5) · `07-28` (5) · `07-29` (70) · `08-13` (35) —
kategorileri **sert silen** koşumların (seed/e2e) arkasında bıraktığı kalıntı.

### Bunun davranışsal sonucu — ve yönü TEHLİKELİ

Öksüz bir `category_id` taşıyan pair hiçbir satırla eşleşmez. `R-2` fail-closed olduğu
için sonuç **erişim kaybı**dır, erişim sızıntısı değil:

```
CM'nin 48 scope satırı  →  46'sı öksüz  →  etkin kapsam 2 kategori
```

> **Bir kategori silinip yeniden yaratıldığında (yeni `id`), o kategorinin müdürü onu
> SESSİZCE kaybeder** — hata yok, log yok, yalnız boş liste. `K-2.6.8a`'nın uyardığı
> *"neden hiçbir plan göremiyorum"* destek talebi, tam olarak bu.

---

## 3 · Kalem 1 — `UNRESTRICTED_ROLES` ↔ `K-2.6.8a`: **mekanizma TERS**

`K-2.6.8a` (`L2_03:554`):

> *"**Boş kapsam = erişim yok.** Tüm veriye erişim, **açık bir joker atamasıyla** verilir."*

Kod (`access-scope.service.ts`):

```ts
const UNRESTRICTED_ROLES = new Set([ADMIN, FINANCE, READONLY]);   // koşulsuz
if (UNRESTRICTED_ROLES.has(role)) return { kind: 'UNRESTRICTED' };
```

Ve **ölçüm**: bu üç rolün scope satırı **sıfır**.

```
                    scope satırı    K-2.6.8a ne der    kod ne yapar
ADMIN                    0          erişim YOK          TAM ERİŞİM
FINANCE                  0          erişim YOK          TAM ERİŞİM
READONLY                 0          erişim YOK          TAM ERİŞİM
```

> **Kural, sıfır satırı `erişim yok` diye tanımlıyor; kod aynı sıfırı `tam erişim` diye
> okuyor.** Sonuç yanlış olmayabilir — ama **mekanizma kuralın tersi**, ve `K-2.6.8a`'nın
> istediği şey (*"açık bir joker ataması"*) hiçbir yerde yok.

### Üç rolün üçü aynı ağırlıkta DEĞİL — ve `L2` yalnız birini destekliyor

| rol | `K-2.6.4` sorumluluğu | koşulsuz `UNRESTRICTED` savunulabilir mi |
|---|---|---|
| `YÖNETİCİ` | *"Tanımlar, kural yönetimi"* | **evet, muhtemelen** — tanım sahibi tüm tanımları görmeli `[GEREKÇELİ]` |
| `FİNANS` | *"Eşik üstü onay/bildirim, transfer, mutabakat, içe aktarma"* | **belki** — mutabakat ve transfer tenant geneli işler `[GEREKÇELİ]` |
| `İZLEYİCİ` | *"Salt görüntüleme"* | ⛔ **en zayıfı** — `K-2.6.4c`: *"`İZLEYİCİ` bir **izleme yetenekleri setidir**, bir 'salt-okur bayrağı' DEĞİL."* Kapsamı hiçbir yerde *"her şey"* diye yazılmamış |

📌 **Ve asimetri `L2`'de zaten işaretli:** `K-2.6.8a`'nın kendi notu *"`K-2.2.8d`'nin
tersi asimetri — ve bilinçli: orada varsayılan cömert, burada kısıtlı."* Kod bu bilinçli
kısıtlılığı **üç rol için** cömertliğe çeviriyor.

---

## 4 · `T-235`'e sonuç

| kalem | durum |
|---|---|
| 1 · `UNRESTRICTED_ROLES` ↔ `K-2.6.8a` | ⛔ **mekanizma ters** — `İZLEYİCİ` için `L2` desteği **yok**; ürün sahibi kararı gerekiyor |
| 3 · `buildScope()` daraltıyor mu | ✅ **daraltıyor** — `DUR` tetiklenmedi. **Ama veri `115/148` öksüz** → yeni kalem |

### Yeni kalem — `T-237` (bu ölçümün ürünü)

`user_scopes.category_id`'nin **FK'si yok**, entity ilişkiyi tanımlıyor, `115` öksüz
satır birikmiş, ve etkisi **sessiz erişim kaybı**. `cpl_id`'de aynı sorun **imkânsız**
(FK + `CASCADE`) — yani düzeltmenin şekli aynı tabloda **zaten yazılı**.

⚠️ Ve `T-234` ile kesişebilir (`1390` satırlık `migration:generate` drift'i): eksik bir
FK tam olarak generate'in üreteceği şeydir. **Ölçülmedi** — `T-234` koşulduğunda bu FK'nin
drift içinde olup olmadığına bakılmalı.
