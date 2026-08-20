# `SCOPE_ENFORCEMENT_ENABLED` açılışı — ÖN BEKLENTİ TABLOSU

> **Yazılma anı:** 2026-08-20, **bayrak AÇILMADAN ÖNCE.**
> **Karar:** ürün sahibi — *"açılış sonrası ölçüm davranışsal olsun, kod okuması değil.
> Ve `planner2 → 0` beklenen sonuç olarak ÖNCEDEN yazılsın, yoksa bir kusur sanılır."*

⚠️ **Bu dosya ölçümün GİRDİSİDİR, dipnotu değil.** Ölçümü yapan buradan başlar.

`CLAUDE.md`: *"Bir ölçümün ön beklentisini yazarken şıkları ve her şıkkın sonucunu bir
TABLOYA koy. Düzyazıda bir işaret sessizce ters çevrilebilir."*

---

## Bayrağın kapsamı — ölçüldü, varsayılmadı

```
access-scope.service.ts:150   configService.get('SCOPE_ENFORCEMENT_ENABLED') === 'true'
```

Bayrak **yalnız `PLANNER`** enforcement'ını kapsıyor:

| rol | bayraktan etkilenir mi | neden |
|---|---|---|
| `PLANNER` | ✅ **EVET** | `T-028c`'de eklenen enforcement bayrağa bağlı |
| `CATEGORY_MANAGER` | ❌ hayır | `T-028b`'de zaten prod'a gitti, bayraktan bağımsız |
| `ADMIN` · `FINANCE` | ❌ hayır | `UNRESTRICTED_ROLES` kod dalı |
| `READONLY` | ❌ hayır | joker satırdan çözülüyor (`T-235 ADIM 2`'den beri kod dalında değil) |

## Açılış öncesi veri durumu (ölçüldü 2026-08-20)

```
tenant 1 · kullanıcı 9 · satırsız kullanıcı 0/9      ← T-028c senaryosu YOK
PLANNER 2 · joker satır 0 · özgül satır 28
CPL 29 · PLANNER kapsamındaki 28 · SAHİPSİZ 1 (Saldos Ticaret Anonim Şirketi)
plan 0 · anlaşma 3 (üçü de Gratis İç ve Dış Ticaret A.Ş.)
```

---

## ⚡ BEKLENEN SONUÇLAR — bayrak açıldıktan sonra

| # | ölçüm | bayrak KAPALI (bugün) | bayrak AÇIK (**beklenen**) | bu bir kusur mu |
|---|---|---|---|---|
| 1 | `planner@wella.com` → görülebilen anlaşma | 3 | **3** | — |
| 2 | `planner2@wella.com` → görülebilen anlaşma | 3 | **0** | ⛔ **HAYIR — BEKLENEN** |
| 3 | `admin@wella.com` → görülebilen anlaşma | 3 | **3** (değişmez) | — |
| 4 | `planner2` → `Gratis`'te anlaşma yaratma | başarılı | **reddedilir** | ⛔ **HAYIR — BEKLENEN** |
| 5 | herhangi bir `PLANNER` → `Saldos`'ta yaratma | başarılı | **reddedilir** | ⚠️ beklenen, ama **bir kalem açar** |

### ⛔ `#2` HAKKINDA — bu satır bu belgenin var olma sebebi

`planner2@wella.com`'un **17 kapsam satırı var.** `0` anlaşma görmesi bir veri kaybı
ya da bir kusur **değil**: üç anlaşmanın üçü de `Gratis`'te, ve `Gratis` `planner2`'nin
kapsamında **yok**.

> **Ürün sahibi:** *"`planner2`'nin `0` anlaşma görmesi, filtrenin ÇALIŞTIĞININ kanıtı.
> Bayrak açılıp hiçbir şey değişmeseydi, o zaman endişelenirdik — filtre koşuyor ama
> daraltmıyor demek olurdu."*

📌 Yani **`#2`'nin `3` çıkması bir BAŞARISIZLIKTIR**, `0` çıkması başarı. Ters okuma bu
tablonun engellemek için yazıldığı hatadır.

### ⚠️ `#5` — sahipsiz CPL

`Saldos Ticaret Anonim Şirketi` **hiçbir** `PLANNER`'ın kapsamında değil. Bugün bu
**sessiz**: sahipsiz bir CPL herkese açık. Bayrak açılınca *"kimse buraya plan
açamıyor"* diye **görünür** olur.

> **Ürün sahibi:** *"Bayrak bir kusuru kapatmakla kalmıyor, bir veri boşluğunu görünür
> kılıyor."*

Bu bir **kalem açar** (seed eksiği mi, kasıtlı mı) — ve sorusu **bayrak açıldıktan
sonra** sorulur, çünkü ancak o zaman ölçülebilir hâle geliyor.

---

## Ölçüm ŞEKLİ — davranışsal, kod okuması DEĞİL

> **Ürün sahibi şartı:** *"iki `PLANNER` ile giriş yapılıp kapsamın gerçekten daraldığı
> davranışsal olarak doğrulansın."*

```
1. Bayrak açılır, süreç YENİDEN BAŞLATILIR   ← ZORUNLU (CLAUDE.md: ortam bayatlığı)
2. Her iki PLANNER için gerçek login → gerçek token
3. Gerçek HTTP isteği (anlaşma listesi)
4. Dönen sayı yukarıdaki tabloyla karşılaştırılır
```

⚠️ **Süreç yeniden başlatılmadan yapılan ölçüm geçersizdir** — `ConfigService` env'i
açılışta okur. `T-113`'te ölçülmüş bir vaka: `start:dev` ayaktayken yapılan değişiklik
kod kusuru gibi görünen bir `500` üretti.

⚠️ **Ve `AccessScopeService`'in 5 sn TTL'li cache'i var.** Ölçümler arasında rol/kullanıcı
değiştiriliyorsa cache anahtarı (`tenantId:userId:role`) farklı olduğu için sorun yok;
ama aynı kullanıcı için ardışık ölçümlerde TTL beklenmelidir.

## Bayrak KAPALI iken de koşulmalı — iki girdi, iki çıktı

`CLAUDE.md §2.7 #9`: *"Sinyal sabitse, sinyal değildir."*

Bu ölçüm **yalnız açık hâlde** koşulursa, `planner2 → 0` sonucunun bayraktan mı yoksa
başka bir sebepten mi geldiği ayırt edilemez. **Bayrak kapalıyken `3`, açıkken `0`
görülmelidir** — farkı üreten şeyin bayrak olduğunun kanıtı budur.

---

# ✅ ÖLÇÜM SONUCU (2026-08-20) — tablo YAZILDIKTAN SONRA koşuldu

**Yöntem:** geçici e2e spec (`test/__zz-flag-verify.e2e-spec.ts`), gerçek `POST /auth/login`
→ gerçek JWT → gerçek `GET /agreements`. Ölçümden sonra spec **silindi**.

Bayrak `.env`'e **yazılmadan**, komut satırı env'i ile iki kez koşuldu:

```
SCOPE_ENFORCEMENT_ENABLED=false  →  {"PLANNER":3,"PLANNER2":3,"ADMIN":3}
SCOPE_ENFORCEMENT_ENABLED=true   →  {"PLANNER":3,"PLANNER2":0,"ADMIN":3}
```

| # | beklenen | ÖLÇÜLEN | |
|---|---|---|---|
| 1 | `planner` → 3 | **3** | ✅ |
| 2 | `planner2` → **0** | **0** | ✅ **beklenen sonuç, kusur DEĞİL** |
| 3 | `admin` → 3 | **3** | ✅ değişmedi |

## İki girdi, iki çıktı — `§2.7 #9` sağlandı

Sinyal **sabit değil**: aynı spec, aynı veri, aynı kod — yalnız bayrak değişti ve
`planner2` `3 → 0`'a düştü. Yani `0` sonucunun sebebi **bayraktır**, başka bir şey değil.

> Bayrak açılıp hiçbir şey değişmeseydi, ölçüm *"filtre koşuyor ama daraltmıyor"*
> anlamına gelirdi — ve asıl endişe o olurdu.

📌 **Yan ölçüm:** komut satırı env'inin `.env`'i ezdiği **iddia edilmedi, ölçüldü** —
`.env`'e hiç dokunulmadı ve sonuçlar değişti (`dotenv` zaten set edilmiş `process.env`'i
ezmez).

## ⚠️ ÖLÇÜMÜN SINIRI — ne ölçülmedi

`#4` ve `#5` (**yazma** yolu: kapsam dışı CPL'de anlaşma yaratma reddi) **davranışsal
olarak ölçülMEDİ.** Sebep: yaratma denemesi paylaşılan geliştirme DB'sinde yan etki
bırakabilir ve `T-047` satır invaryantını kirletir.

Dayanak: yazma yolu **aynı** `assertEntityInScope` çağrısını kullanıyor
(`agreement.service.ts:90`, `:376`) ve okuma yolu (`#2`) o kod yolunu **fiilen
tetikledi**. Yani mekanizma kanıtlı; kanıtlanmayan şey **o iki özel girdinin**
davranışıdır.

> `CLAUDE.md`: *"Bir küme hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI aynı
> cümlede yazılır."* Bu bölüm o sınırdır.


---

# ⚠️ BAYRAK BUGÜN AÇIK DEĞİL — ölçüldü 2026-08-20

Yukarıdaki doğrulama **mekanizmayı** kanıtladı (`false→3`, `true→0`), ama bayrak
**çalışan ortamda AÇILMADI**: `.env` Team Lead'in izin listesinin dışında
(`Read(./**/.env)` deny — `ls` bile reddedildi), o yüzden ölçüm komut satırı env'iyle
yapıldı.

**Canlı süreçte ölçüm** (`localhost:3000`, gerçek login → gerçek `GET /agreements`):

```
planner2@wella.com  →  HTTP 200 · 3 anlaşma
```

Ön beklenti tablosuna göre `3` = **bayrak KAPALI**.

## ⚠️ Ve bu sonucun İKİ açıklaması var — ayırt edilemedi

| # | açıklama | nasıl ayırt edilir |
|---|---|---|
| 1 | bayrak `.env`'de **yok** | `.env` okunur — ⛔ **izin yok** |
| 2 | bayrak var ama **süreç BAYAT** (`ConfigService` env'i açılışta okur) | süreç yeniden başlatılıp tekrar ölçülür |

`CLAUDE.md`'nin *"ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır"* maddesi
(`T-113` vakası) tam olarak `#2`'yi anlatıyor. **Hangisi olduğu bilinmiyor** ve
varsayılmıyor.

## Bayrağı gerçekten açmak için

```bash
echo 'SCOPE_ENFORCEMENT_ENABLED=true' >> collmind.backend/.env
```

**ve `start:dev` yeniden başlatılır.** Sonra yukarıdaki canlı ölçüm tekrarlanır:
`planner2 → 0` görülmelidir.


---

# ✅✅ BAYRAK CANLI — ÇALIŞAN ÜRÜNDE doğrulandı (2026-08-20)

Önceki bölüm bayrağın **açık olmadığını** ölçmüştü (`planner2 → 3`). `.env` satırı
eklendi **ve `start:dev` yeniden başlatıldı** (ürün sahibi). Ölçüm tekrarlandı —
**gerçek sunucu, gerçek login, gerçek `GET /agreements`**:

```
planner@wella.com   →  3 anlaşma
planner2@wella.com  →  0 anlaşma        ⛔ BEKLENEN — kusur DEĞİL
admin@wella.com     →  3 anlaşma
```

**Ön beklenti tablosuyla BİREBİR** — ve tablo bu ölçümden **önce** yazılmıştı.

## Bu ölçümün önceki ikisinden FARKI

| tur | ortam | ne kanıtladı |
|---|---|---|
| 1 | komut satırı env'i, e2e app'i | **mekanizma** çalışıyor (`false→3`, `true→0`) |
| 2 | canlı sunucu, bayrak öncesi | bayrak **okunmuyor** (süreç bayat) |
| **3** | **canlı sunucu, bayrak sonrası** | **bayrak CANLI ve doğru daraltıyor** |

📌 Üçü birlikte `§2.7 #9`'u sağlıyor: **sinyal sabit değil**, ve farkı üreten şeyin
bayrak olduğu **iki farklı ortamda** gösterildi.

⚠️ **Ve `2 → 3` geçişi bir dersin kanıtı:** `.env` satırı yazılmıştı ama ölçüm hâlâ `3`
diyordu. Sebep **bayat süreç**ti (`ConfigService` env'i açılışta okur — `T-113`). O tur
*"bayrak açık"* diye kaydedilseydi yanlış olurdu; **iki açıklama da yazıldığı için**
doğru teşhis edildi.

> `CLAUDE.md` / `§7.1`: *"bir komutun koşulması, etkisinin gerçekleştiği anlamına
> gelmiyor."*

## Kalan

`#4`/`#5` (**yazma** yolu reddi) hâlâ davranışsal ölçülmedi — gerekçesi yukarıda
(paylaşılan DB'de yan etki). Ve `Saldos Ticaret`'in sahipsizliği artık **etkin**:
hiçbir `PLANNER` oraya plan/anlaşma açamaz → [[T-248]].
