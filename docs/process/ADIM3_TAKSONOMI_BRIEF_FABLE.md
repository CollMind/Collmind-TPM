# `ADIM 3` taksonomi brief'i — Fable

> **Tarih:** 2026-08-17 · **Yazan:** Team Lead · **Alıcı:** Fable
> **Çıktı:** dört soruya cevap — **plan/karar önerisi, kod değil.**
> **Zamanlama:** `Faz B` başlamadan ÖNCE. İki soru (`1` ve `3`) `Faz B`'nin
> **kapsamını** belirliyor; sonra cevaplanırsa kapsam yeniden açılır.

---

## 0 · İki şart — ihlal edilirse çıktı kullanılamaz

```
1  SAYILARI YENİDEN SAYMA        0072 kanonik. Atıf ver, yeniden türetme.
2  HER İDDİAYI İŞARETLE          ÖLÇÜLDÜ · GEREKÇELİ · VARSAYIM
```

⚠️ **İkinci şart bu projede bir üslup tercihi değil.** Ölçülmemiş bir iddianın
karar ürettiği vakalar defalarca kaydedildi — en pahalısı bir **düzeltmenin**
kaynağa atıf vererek yanlış paydayı koda sabitlemesiydi. Bir sapma *"uygunluk"*
diye etiketlenirse **sorguyu kapatır**: sessiz bir sapma bir gün fark edilir,
kaynağa atıf veren bir sapma **doğrulanmış görünür**.

Pratik: her iddianın yanına etiketi yaz. `GEREKÇELİ` = mantık yürütmesi, ölçüm
değil. `VARSAYIM` = ne ölçüm ne gerekçe — ve **karara dayanak yapılamaz**.

---

## 1 · Girdi belgeleri

```
docs/analysis/0072-adim3-route-yetki-olcumu.md      KANONİK ÖLÇÜM
  §1    77 filtresiz uç: modül × HTTP metodu
  §2    160 kapsanmış ucun rol kümeleri · 15 farklı küme
  §3    modül × işlem sınıfı (tüm 237) · 24 dolu hücre
  §4b   "77 uç korumasız" iddiasının NİTELENMİŞ hâli
  §4c   ⚡ 5/5 rol taşıyan 18 route ve A/B/C sınıf ayrımı   ← YENİ, bu tur eklendi
  §5    ölçümün sınırları — OKUNMADAN §3'e dayanma

docs/brd-v2/03_IS_KURALLARI/L2_03_onay_yetki_uyum.md
docs/brd-v2/04_KARAR_KAYDI.md                       0056-K3 · Z7 · union kaydı
docs/process/FAZ1_PLAN.md                           Adım 3/4 sınırı · Faz A/B ayrımı
collmind.backend/src/common/authorization/capabilities.ts   Faz A çıktısı, 11 taksonomi
                                                             düzeltmesi başlıkta yazılı
```

---

## 2 · Bugünkü durum — üç cümlede

**`Faz A` bitti:** `CAPABILITIES` (24 üye, `modül:islem` şekli) + `ROLE_CAPABILITIES`
yazıldı. `9` bloke hücreden `4`'ü union ile çözüldü, **`5`'i `DUR`**. Tüketici
**yok** — `@RequireCapability` hiçbir route'a uygulanmadı, davranışsal etki **sıfır**
`[ÖLÇÜLDÜ: capabilities.ts üretim tüketicisi 0, pozitif kontrol roles.decorator 28]`.

**`Faz B` bekliyor:** `@RequireCapability` + `159` `@Roles` göçü +
`roles.guard.ts:11-18`'in default-deny'a çevrilmesi. O üç satır **`72` ucu aynı anda**
etkiler.

**Ve `report-only` fazı senin kendi önerindi** (`Faz 1` planı): eşlenmemiş uç loglanır,
engellenmez; envanter fiili trafikte doğrulanır; sonra kapatılır.

---

## 3 · ⚡ Brief'e girmesi gereken üç bağlam — bunlar KAPALI kapılar

### `0056-K3(b)` — yetenekler **kod**, tablo yok

Ürün sahibi kararı (2026-08-16). `capabilities`/`role_capabilities` **tabloları ölü
yapı** ilan edildi (`Z4`, düşürme `T-233`).

> ⛔ **"Tenant başına yetenek" önerilemez** — o şık ölçülerek reddedildi: seed
> gerektirir, tenant-başına özelleştirme **istenmiyor**.

### `K-2.6.6`'nın ölçülmüş hâli — *"77 uç korumasız"* NİTELENDİ

```
77 filtresiz uç
  72  kimlik doğrulanmış, rol kısıtsız     ← asıl sınıf
   3  BİLİNÇLİ açık   (auth/login · auth/refresh · health — @Public())
   2  ALAN guard'lı   (ReversalGuard · SettlementGuard)
```
`[ÖLÇÜLDÜ: 0072 §4b]`

⚠️ **Ve `2`'nin dersi brief'in içinde:** en riskli **görünen** alt küme (onay/iş-akışı
uçları) aslında **korunuyordu**. Ölçüm yapılmadan yazılan bir *"en riskli"* etiketi
yanılmıştı.

⚠️ **Ve o `2` `Faz B` için bir tuzak:** ikisi de `@Roles` **taşımıyor**. Default-deny
çevrildiği an, alan guard'ı olsa bile **kesilirler** — çünkü kesen şey `@Roles`
yokluğu.

### `report-only` senin önerin — yani soru `3`'te **kendi önerini** değerlendireceksin

Bu bilinçli. Bir öneriyi yazan, onun **hangi girdiyle değersizleştiğini** en iyi bilir.

---

## 4 · Dört soru

### Soru 1 · Taksonomi ekseni — **kapsam nereye ait?**

`modül × işlem` ekseni `24` dolu hücre verdi `[ÖLÇÜLDÜ: 0072 §3]`. Ama `§4c`'nin
`A`/`C` ayrımı **bu eksende görünmüyor**:

```
A  aktör kapsamı SERVİS katmanında     11 route   @CurrentUser → resolveScopeForFilter
C  kapsam YOK, özet DEĞİL               6 route   yalnız tenantId
```

İkisi `@Roles` yüzeyinden **birebir aynı** (`5/5` rol). Ayrım yalnız servise bakınca
çıkıyor `[ÖLÇÜLDÜ: 0072 §4c]`.

**Soru:** bir yetenek **kapsamı taşımalı mı** (`modes:read:own` ↔ `modes:read:all`),
yoksa kapsam **ayrı bir katman mı** (`K-2.6.9`, satır seviyesi)?

⚠️ **Ve gerilim adıyla konsun:** ikisi birden yaşarsa **`İlke 4`** — iki mekanizma
aynı soruyu cevaplar. Bu projede o ihlalin sekiz vakası kayıtlı, ve hepsi *"her ikisi
de makul görünüyordu"* diye doğdu.

📌 Cevapta beklenen: **bir tercih ve reddedilenin gerekçesi.** *"Duruma göre"*
kullanılamaz — `Faz B` bir eksen seçmek zorunda.

### Soru 2 · `READ` çöküşü — hücre mi yanlış, route mu?

Üç hücrede (`MODES_READ` · `SHARED_READ` · `USER_READ`) union **`5/5`**. Sebep
ölçüldü: o hücrelerde **zaten `5/5` taşıyan** route var — union onları yalnız
**görünür** kıldı `[ÖLÇÜLDÜ: 0072 §4c]`.

Ürün sahibinin ilk okuması *"o geniş route'lar ayrı bir yetenek: kendi verisi/özet"*
idi. **Ölçüm şartı kondu ve şart tutmadı** — üçü aynı sınıfta değil (`A`/`B`/`C`).
Özellikle `sales-actuals` `READ_ROLES` bir **özet değil**: `batches/:batchId/rows`
satır düzeyinde satış verisi, kapsam filtresi yok `[ÖLÇÜLDÜ: 0072 §4c]`.

**Soru:** bu üç hücre nasıl çözülür — ve `B` sınıfının (`user/dashboard-summary`,
`@deprecated` ikiz) bir **yetenek sorusu olmadığı** kabul ediliyor mu?

### Soru 3 · `Faz B` sırası — eksik harita `report-only`'yi değersizleştirir mi?

`18` route bugün göçemiyor (`5` bloke hücre + `A`/`C` ayrımı çözülmemiş). `report-only`
o hâlde **eksik haritayla** koşar.

**Soru:** bu `report-only`'nin **değerini düşürür mü**, yoksa tam tersine —
eşlenmemiş uçları görmek zaten onun **işi** mi?

⚠️ Ayırt edici soru şu olabilir: *"report-only çıktısında `beklenmedik` ile
`henüz eşlenmemiş` **ayırt edilebiliyor mu?**"* Ayırt edilemiyorsa çıktı gürültüye
düşer — ve `Faz A`'nın union kaydı tam bu yüzden tutuldu.

### Soru 4 · Dışarıdan bakış — bu ölçekte ne **genelde** yanlış gider?

```
24 yetenek  ·  5 rol  ·  237 route  ·  160 @Roles'lu  ·  15 farklı rol kümesi
```
`[ÖLÇÜLDÜ: 0072 §2, §3]`

Bu **bizim** kusurlarımız değil, **bu ölçekteki RBAC→CBAC geçişlerinin** bilinen
tuzakları. Kendi geçmişimizi tekrar anlatma — dışarıdan bakış istiyoruz.

---

## 5 · `DUR` koşulları

Aşağıdakilerden biri çıkarsa **dur ve bildir**, tahminle ilerleme:

- Bir soru **`0072`'de olmayan bir ölçüm** gerektiriyorsa → ölçümü **isteme listesine**
  yaz, kendin türetme (şart 1).
- Bir cevap **`0056-K3(b)`'yi** ya da **`Z7`'yi** geri alıyorsa → o bir karar defteri
  kaydı gerektirir, brief cevabı değil.
- Bir cevap **`BRD v2.0` paketine** dokunmayı gerektiriyorsa → paket **donuk**
  (`Z1`); önce karar defterine kayıt.
- Bir öneri **migration** ya da **şema** gerektiriyorsa → `0056-K3(b)` ile çelişip
  çelişmediğini **açıkça** yaz.

---

## 6 · Çıktı şekli

`docs/analysis/00NN-adim3-taksonomi-cevabi.md` — dört başlık, her başlıkta:

```
CEVAP        bir tercih (birden çok değil)
GEREKÇE      ve etiketi: ÖLÇÜLDÜ · GEREKÇELİ · VARSAYIM
REDDEDİLEN   ve NEDEN — bu projede reddedilenin gerekçesi kayda geçer
FAZ B'YE     bu cevap kapsamı nasıl değiştiriyor
```

⚠️ **Sayı yazma, liste yaz.** Bir sayı bayatlar ve hiçbir zaman kırmızıya dönmez;
niteliksel bir ayırt edici (*"hiçbiri"*, *"tek istekte gönderiyor"*) bakım
gerektirmez.
