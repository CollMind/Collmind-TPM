# `ADIM 5` — `RLS` KARAR PAKETİ · BRIEF

**Tarih:** 2026-08-27 · **Karar:** ürün sahibi · **Hazırlayan:** Team Lead
**Girdi:** `ADIM3_KAPANIS_RAPORU.md` (🔒 mühürlü) · `SYSTEM_INVARIANTS` uzlaşı turu (`INV-T` ailesi)

> ## ⛔ TURUN TÜRÜ BAŞTAN SABİT: **ÖLÇÜM + KARAR-PAKETİ TURU — KOD TURU DEĞİL**
>
> Çıktı: ürün sahibine gidecek bir **`RLS` karar paketi**. **Uygulama dalgaları
> (`ADIM 5`'in kendisi) HÜKÜMLERDEN SONRA.**
>
> **Aktivasyon çizgisi değişmedi:** `Faz-1`'in işi **tasarım + politika yazımı +
> kanıt**; **aktivasyon ikinci-müşteri/deploy sert eşiğinde** — `HEDEFLER.md` faz
> süzgeci **aynen geçerli**.

---

## ⛔ HER ÖLÇÜME UYGULANAN ŞART — *"verinin yokluğu örter"*ın `RLS` hâli

```
TEK-TENANT bir DB'de tenant-SIZINTISI GÖRÜNMEZ
⇒ her politika, hiçbir şey yapmasa bile YEŞİL görünür
```

> **Fixture İKİ-TENANT'LI olmalıdır.** Bu, `T-273`'ün `RLS` hâlidir ve paketin
> **her ölçümüne** uygulanır — bir izolasyon iddiası, **iki tenant'ın FARKLI sonuç
> aldığı** gösterilmeden yazılamaz. **Boş sonuç FARK DEĞİLDİR.**

---

# ÜÇ AÇILIŞ KARARI — ürün sahibinin ÇERÇEVESİ, ve turun ölçeceği

## `K1` · OPERATÖR ERİŞİMİ

**Ön-hüküm `[GEREKÇELİ — paket DOĞRULAR]`:**
> **En dar başlangıç:** operatör **uygulama üzerinden değil**, **ayrı bir DB-rolü**
> üzerinden erişir. O rol **RLS-bypass'lı** ama kullanımı **DENETİM-OLAYLI** — her
> bağlantı/sorgu kayıtlı. ⇒ **Denetim çekirdeğinin İLK MÜŞTERİSİ.**
>
> Uygulamaya *"operatör modu"* eklemek **`Faz-3+` adayı** — kanıt gelene kadar
> **aday** (süzgeç).

**Ölçülecek:**
- `app_runtime` / `app_migrate` ayrımının **fiilî** hâli (`K-2.6.13`) — roller var mı, kim hangisiyle bağlanıyor, `BYPASSRLS`/`SUPERUSER` taşıyan var mı
- **Operatör bugün fiilen NE YAPIYOR** — hangi yolla bağlanıyor, hangi sorguları koşuyor
- ⛔ **Tasarım, MEVCUT PRATİĞİ YASAKLAMADAN daraltmalı** — bugünkü işi imkânsız kılan bir politika, uygulanmaz ve **sessizce devre dışı bırakılır**

## `K2` · ZAMANLAYICI × KİRACI BAĞLAMI

**Çerçeve — iki MEŞRU desen:**
```
(i)  job tenant-listesini döner, HER TENANT için bağlam SET EDEREK koşar
(ii) job BYPASSRLS koşar
```
**Ürün sahibi `(i)`'ye yatkın** — *"bypass, izolasyon kanıtını DELER"* — **ama karar
ENVANTERSİZ VERİLMEZ.**

**Ölçülecek:**
- **Job envanteri:** hangi zamanlayıcılar var (`@Cron`, `@Interval`, kuyruk tüketicileri), **hangi tablolara yazıyor/okuyor**, **bugün tenant-filtresi uyguluyorlar mı**
- Her job için: bağlamı **nereden** alıyor (parametre? global? hiç?)
- ⚠️ İki-tenant fixture şartı **burada özellikle kritik**: tek tenant'ta bir job'ın sızıntısı **görünmez**

## `K3` · POLİTİKA ↔ UYGULAMA İŞ BÖLÜMÜ

**Ön-hüküm — NET, ve üç-katman cümlesinin TAMAMLANIŞI:**

> **`RLS` YALNIZ kiracı → satır izolasyonu.**
> **Kapsam (`CPL` × kategori) UYGULAMA KATMANINDA KALIR.**

```
rol   → yetenek     KODDA      (capability haritası · A′ default-deny)
kişi  → kapsam      VERİDE     (user_scopes · uygulama zorlaması)
kiracı→ satır       DB'DE      (RLS)
        ⇒ ÜÇ KATMAN · ÜÇ MEKANİZMA · ÜÇ AYRI KANIT YÜZEYİ
```

**Gerekçe:** kapsamı `RLS`'e gömmek, `CM`-normalizasyonu/joker-satır inceliklerini
**SQL politikalarına** taşır ve **iki katmanın ayrı ratchet'lerini TEK YUMAĞA** çevirir
— **`İlke-4`'ün DB hâli**.

⛔ **Paket bu hükmü ÇÜRÜTECEK bir vaka bulursa MASAYA DÖNER:** *kapsamsız
bırakılamayan bir tablo-sınıfı* var mı?

---

# ÖLÇÜM ENVANTERİ — ⛔ PAKET BUNLARSIZ GELMESİN

| # | ölçüm | not |
|---|---|---|
| 1 | **Tablo envanteri:** `main` şemasında **`tenant_id` TAŞIMAYAN** tablo var mı | ⛔ varsa **her biri KARAR İSTER** |
| 2 | **Bağlantı düzeni:** session-variable deseni **transaction-pooling** ile uyumlu mu | **`pgbouncer` sınıfı risk** — `SET LOCAL` mi `SET` mi, havuz modu ne |
| 3 | **`FORCE ROW LEVEL SECURITY`** | tablo **SAHİBİ** de politikaya tabi mi? |
| 4 | **View'lar** — `T-267`'nin `VIEW`'ı dahil (`v_budget_summary`) | `RLS` view'larda **nasıl davranıyor** (`security_invoker`?) |
| 5 | **Seed / migration'ların `RLS`-altı davranışı** | `app_migrate` **bypass** mı? |
| 6 | **Mevcut CROSS-TENANT sorgu taraması** | ⛔ varsa her biri **ya ÖLÜR ya OPERATÖR-YOLUNA taşınır** |

---

# ⛔ SIRA KURALI

> **`RLS` karar paketi, uzlaşı turunun `INV-T`/yetki-ailesi bölümü BİTMEDEN ürün
> sahibine GELMEZ** — o aile paketin **girdisidir**.

*(`A′` o ailenin yarısını **kod-kanıtıyla** hazırladı: **"boş kapsam = erişim yok"**
artık *yazılacak* değil, **ölçülüp-bağlanacak**.)*

⚠️ Uzlaşının **geri kalanı** (`ledger`/`CAP`/`recognition` statüleri) `RLS`'i
**BLOKLAMAZ**, kendi hızında iner.

# ⛔ DOĞRULAMA İZOLASYONU BEYANI (`T-269 ∥ T-270` usulü)

```
Bu tur SALT OKUNUR. docs/contracts/SYSTEM_INVARIANTS.md'ye YAZMAZ — ORADAN OKUR.
Doğrulama izole bir git worktree'de yapılır; paylaşılan ağaçta --fix / mutasyon /
git checkout çalıştırılmaz.
```
