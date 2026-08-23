# `SELF` kovası — ölçüm raporu (`architect`, 2026-08-23)

> **Karar ürün sahibinde.** Bu belge ölçüm + öneridir.

## Ölçümün sınırı

```
EVREN         223 rota · 33 dosya · src/**/*.controller.ts
ARAÇ          scripts/guards/route-scope.awk — guard'ın KENDİ ayrıştırıcısı
KİMLİK TOKENİ @CurrentUser | @Req | @Request | req.user | request.user
              ⛔ @TenantId BİLEREK DIŞLANDI — 207/223 rotada var, tenant izolasyonu
                 evrensel, bir SELF yüklemi DEĞİL
YORUM         `//` `*` `/*` ile başlayan eşleşmeler ayıklandı
DAVRANIŞ      canlı HTTP + DB önce/sonra sayımı; fixture'lar kuruldu ve SİLİNDİ
```

⚠️ **`223` ≠ `route-scope-baseline.txt` başlığındaki `235`** — başlık satırı **bayat**,
`F` anahtarları güncel. Bilgi sütunu, karşılaştırma sütunu değil.

⚠️ **Ajanın kendi ölçümü bir kez yanıldı ve KENDİ İÇİNDE TUTARSIZLIKLA yakalandı:**
dekoratör bloğu yalnız **ileri** tarandı → `@Roles`'u `@Get()`'in **üstünde** olan 49 rota
`0 rol` çıktı. `ROLES` kovasında `0 rol` bir **çelişkidir** — blok iki yönlü kurulunca
`PARSE HATASI: 0`.

---

## 1 · `SELF` sınıfı `FILTRESIZ`'den BÜYÜK — `3` değil **`7`**

| # | uç | `@Roles` | yüklem nerede |
|---|---|---|---|
| 1 | `GET /users/me` | **yok** | satır anahtarı |
| 2 | `PATCH /users/me` | **yok** | satır anahtarı |
| 3 | `PATCH /users/me/password` | **yok** | satır anahtarı + `currentPassword` **ispatı** |
| 4 | `POST /auth/logout` | **5/5** | `user.service.ts:1007` |
| 5 | `GET /notifications` | **5/5** | `where { tenantId, recipientId }` |
| 6 | `GET /notifications/unread` | **5/5** | aynı |
| 7 | `GET /approvals/my-requests` | **5/5** | `requestedById = requesterId` |

📌 **Dördü `@Roles(5/5)` taşıyor — ve KODUN KENDİ YORUMLARI bunu itiraf ediyor:**

```
auth.controller.ts:82          "self-action: … rol kısıtı GEREKMEZDİ"
notification.controller.ts:37  "Bir rolü dışarıda bırakmak o rolün KENDİ bildirimlerini
                                görememesi demek olurdu, iş kuralı değil"
```

⚠️ `Z18 §4`'ün (*"hiçbir hücre-rol çifti union gerekçesiyle yaşayamaz"*) **dört canlı
vakası** — ve gerekçesi *"union böyle dedi"* değil, ***"`SELF` diye bir kova yoktu"***.

**Bağlam:** `215` `ROLES` rotasının **`71`'i** `5/5` taşıyor. Bu dördü onun içinde; kalan
`67`'nin çoğu **master-data okuması**, `SELF` değil.

### Ayrı sınıflar (karışmasın)

```
AKTÖR ATFI     createdBy/updatedBy yazılıyor — DARALTMIYOR              (çoğunluk)
KAPSAM ÇÖZÜMÜ  user.id + role → resolveScope → CPL/kategori filtresi    (16 çağrı yeri)
KİMLİK ama RED self-approval reddi (K-2.5.11) — kimlik YASAKLIYOR       (4 yer)
```

### ✅ İstemci kimliği kontrol edebiliyor mu → **HAYIR**

```
@Query('userId' | @Param('userId' | @Query('recipientId'   →  0 eşleşme
POZ.KONTROL  @Query('  →  72 eşleşme
```

İskeletin *"istemcinin kontrol edemediği"* koşulu **repo genelinde sağlanıyor**.

---

## 2 · `PATCH /users/me` — KOLON LİSTESİ (hüküm değil)

**Sözleşme:** `UpdateUserDto = PartialType(OmitType(CreateUserDto, ['scope'])) + password?`
**Pipe:** `whitelist: true, forbidNonWhitelisted: true`
**Servis:** `user.service.ts:872` **`Object.assign(user, dto); save(user)`** — **toptan**

| # | DTO alanı | entity kolonu | **DB'ye ULAŞTI MI** |
|---|---|---|---|
| 1 | `email` | `email` | ✅ **YAZIYOR** |
| 2 | `password` | **YOK** | ❌ sessiz no-op |
| 3-8 | `fullName` · `firstName` · `lastName` · `phoneNumber` · `department` · `jobTitle` | var | ✅ **YAZIYOR** |
| 9 | **`role`** | `role` | ❌ **SESSİZCE DÜŞÜYOR** (`200`) |
| 10 | **`status`** | `status` | ⛔ **YAZIYOR** |
| 11 | **`mustChangePassword`** | `must_change_password` | ⛔ **YAZIYOR** |
| 12 | `permissions` | **YOK** | ❌ sessiz no-op |

**Reddedilenler (`400`):** `tenantId` · `scope` · `isActive`

### ✅ `DUR` sorusu: rol/kapsam/tenant yazılabiliyor mu → **HAYIR**

```
role      SESSİZCE düşüyor (controller:111 `delete dto.role`)
          + İKİNCİ katman: service:817 non-ADMIN rol değişimi ForbiddenException
scope     400  (OmitType, T-242a)
tenantId  400  (DTO'da yok)
```

**Yetki yükseltme yolu ÖLÇÜLDÜ ve BULUNAMADI** — hipotez çürüdü. ⚠️ Ve bir bulguyu
kapatmasın diye poz.kontrol yapıldı: **`status` aynı yoldan yazılıyor**, yani yol açık,
düşen şey `role`.

### ⚠️ Ama `status` bir KİMLİK KAPISI ve kendi kendine yazılıyor

```
JwtStrategy.validate        her istekte  status !== 'ACTIVE' → 401
POST /users/:id/activate    @Roles(ADMIN)   ← bu kolonun RESMİ ucu
PATCH /users/me             ROLSÜZ          ← ve AYNI kolonu yazıyor
```

**Yönü ölçüldü — FAIL-CLOSED:** kendini `LOCKED` yapmak ✅ çalışıyor · geri `ACTIVE`
yapmak ❌ **imkânsız** (uç zaten `401` verir). Yani **yetki yükseltme değil, kendi
hesabını kilitleme**; geri alması yalnız `ADMIN`'de.

> **Ciddiyeti düşük, SINIFI yüksek:** `ADMIN`-özel bir uca sahip bir kolon, **rolsüz** bir
> uçtan yazılıyor. Yetki modeli kendi içinde çelişkili.

`mustChangePassword` aynı sınıf, **bugün sonuçsuz** — kolon repoda **hiçbir yerde
okunmuyor** (`0` kapı). *"Mekanizma var, yol yok"* ailesinin sessiz üyesi; bir gün
zorlanırsa self-clear onu **doğduğu anda** delik yapar.

### ⚠️ `§2.5` asimetrisi — üç yetki alanı, üç davranış

```
tenantId · scope   →  400  AÇIK RET
role               →  200  SESSİZ DÜŞÜRME
permissions        →  200  SESSİZ NO-OP
```

`T-242a` `scope`'u tam bu gerekçeyle `OmitType`'a almıştı: *"sessiz no-op'u AÇIK bir
hataya çevirir."* `role` ve `permissions` **aynı düzeltmeyi almadı**.

### ⚠️ Denetim boşluğu

```
user.service.ts:150  create      → adminAuditService.logAdminAction  ✅
user.service.ts:682  updateScope → adminAuditService.logAdminAction  ✅
user.service.ts:807  update      → HİÇBİRİ                            ⛔
POZ.KONTROL  aynı grep 2 çağrı yeri buluyor
```

Ölçüldü: `PATCH /users/me` sonrası `updated_by IS NULL`. Ve aynı `update()`
**`PATCH /users/:id`'nin de gövdesi** → **ADMIN'in rol değişimi de iz bırakmıyor**
(`console.warn('EA-001…')` bir denetim kaydı **değildir**). `§2.3` *"her işlem loglanır"*
ile çelişir; `Z20`'nin `USER_MANAGE` hücresini doğrudan ilgilendirir.

---

## 3 · İSKELET — yarısı tuttu, yarısı GENİŞLEMELİ

### ✅ Tutan yarısı

`SELF` bir kova değil, bir **yüklem sınıfı** — ölçüm destekliyor. Kimlik her yerde
`req.user`'dan; `SELF` uçlar bir rol kümesine değil *"kayıt benim mi"* koşuluna bağlı;
`Z18`'in dördüncü-eksen reddi **korunuyor**.

### ⛔ TUTMAYAN yarısı — iskeletin KENDİ `DUR` koşulu ateşledi

> İskelet: *"örtük olarak `PATCH /users/me`'nin **dar alan-listeli** olduğunu varsayıyor."*

**Ölçüm tersini gösterdi.** `PATCH /users/me` **kendi DTO'suna sahip değil** —
`PATCH /users/:id` ile (**`USER_MANAGE` ile**) **AYNI** `UpdateUserDto`'yu paylaşıyor,
ve daraltma tek satırlık `delete dto.role`.

```
YÜKLEM   "kayıt benim mi"     →  PATCH /users/me'de DOĞRU
ALAN     "neyi yazabilirim"   →  BUGÜN TANIMSIZ, USER_MANAGE'den MİRAS
```

> **Bir `SELF` ucunun sözleşmesi İKİ PARÇADIR ve dekoratör yalnız birincisini taşır.**

---

## 4 · ⛔ `B4`'ÜN GİZLİ ÖN KOŞULU — guard dördüncü kovayı TANIMIYOR

`route-scope.awk` yalnız **üç** dekoratör adı tanıyor: `Roles` · `Public` · `UseGuards`
(`:120,130,132,134`).

**Fixture ile ölçüldü** (`ROUTE_SCOPE_SRC_DIR`; gerçek repo **hiç değişmedi**). Beklenen
sonuçlar **ölçümden ÖNCE** yazıldı, üçü de tuttu:

| varyant | mutasyon | beklenen | **ÖLÇÜLEN** |
|---|---|---|---|
| `v1` | `@SelfScoped()` (çıplak dekoratör) | `FILTRESIZ=3` | **`3` · EXIT=0** ⛔ |
| `v2` | `@UseGuards(…, SelfScopedGuard)` | `exit 2` | **`EXIT=2` — *"bilinmeyen guard adı"*** |
| `v3` **poz.kontrol** | `@Roles(ADMIN)` | `FILTRESIZ=2` | **`2` · EXIT=0** ✅ |

```
ŞART        B4 (default-deny) için FILTRESIZ = 0
SAĞLAYICI   route-scope.awk + .sh'ın DÖRDÜNCÜ KOVAYI tanıması
DURUM       ⛔ bugün YOK — ve eklenmezse SELF kararı ön koşulu ÇÖZMEZ
```

> **`SELF` dekoratörünü yazan tur, `route-scope.awk`'a kovayı ve `route-scope.sh`'a
> sayacı AYNI TURDA eklemek zorundadır** — yoksa `FILTRESIZ` düşmez, `B4` açılmaz, **ve
> hiçbir şey kırmızıya dönmez.**

### ⛔ Ve `FILTRESIZ = 0`, `SELF` sınıfının kapandığı anlamına GELMEZ

```
FILTRESIZ kovası    3 uç
GERÇEK SELF sınıfı  7 uç
SAHTE SELF          1 uç   (/approvals/pending → T-276)
YÜKLEMSİZ KARDEŞ    2 uç   (markAsRead ⛔ CANLI AÇIK → T-275 · /approvals/:id)
```

Ratchet **yalnız ilk satırı** ölçüyor. Dört `SELF` ucu `ROLES` kovasında ve guard için
**ayırt edilemez**.

> **`FILTRESIZ = 0` gerekli, YETERLİ DEĞİL.** `B4`'ün kabul kriterine ikinci satır:
> **`@Roles` taşıyan `SELF` uçlarının sayısı da `0`** — bugün **`4`**.

---

## 5 · Ölçüm hijyeni

| ne | geri alma | doğrulama |
|---|---|---|
| `main.users` — `planner2` (12 kolon) | tam satır geri yazıldı | **`md5(satır)` ÖNCE = SONRA** ✅ |
| `main.notifications` — 1 fixture | `DELETE` | `count = 0` ✅ |
| `main.approval_requests` — 1 fixture | `DELETE` | `count = 0` ✅ |

⚠️ **Geri almanın SONUCU ölçüldü, komutu değil — ve iyi ki:** ilk geri alma denemesi
`docker exec` **`-i`'siz** çalıştırıldığı için heredoc stdin'e **hiç ulaşmadı**, `psql`
sessizce hiçbir şey yapmadı, **satır bozuk kaldı**. **Hash kontrolü yakaladı.**

⚠️ Geri alınmayan yan etki: `finance@wella.com`'un `login_count`/`last_login_at`
(login'in doğal yan etkisi, iş verisi değil).

**Süreç:** `npm run start:dev` başlatıldı ve **kapatıldı** — `lsof` boş, `ps` boş.
