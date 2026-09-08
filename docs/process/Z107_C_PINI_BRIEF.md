# `Z107 §4` — `(C)` PİNİ: SESSİZ `DRAFT` **ÖLÜR** (üç kalem, aynı tur, **ayrı fixture**)

> Şerit: `backend-engineer` · Repo: `collmind.backend`
> ⛔ Migration numarası **ALMA** — gerekirse **DUR ve iste**.

## 0 · ⛔ HÜKÜM-ATIF KURALI
`Z`-atfı olmayan bir *"hüküm"* cümlesi görürsen ⛔ **DUR** (`Z105 §1`).
```
hüküm 18   (C) pini — sessiz DRAFT ölür        Z107 §4
K-2.2.14   zarf bulunamazsa SESSİZCE GEÇİLMEZ — "tek bir BİLDİRİLMİŞ POLİTİKA,
           TÜM YOLLARDA AYNI"
Z91        bir enum ÜYESİ ekleyen tur, ÜRETİCİSİNİ AYNI TURDA bağlar
```

## 1 · Devraldığın durum (Team Lead bağımsız ölçtü)
```
tsc 0 · guards 0 · unit 87 suite/1547 test · T-047 PASS
e2e  10 suite / 59 test KIRMIZI
     ⛔ bunlar "bilinen" — TEK kök neden Z107 §1 (demo/zarf dönem uyuşmazlığı, LIKE örtüsü)
     ve iki tanesi AD DÜZEYİNDE ölçüldü:
       A13 / A13b  role-journey:1203-1204  `not.toBe(403)` + `toBe(404)`
       → 404 KUSURUN SEMPTOMUYDU, teste SÖZLEŞME olarak donmuş; şimdi 200 geliyor
⇒ SEN bu 59'un ÜSTÜNE yeni kırmızı EKLEMEMELİSİN; raporunda SINIFLA (bilinen 59 · seninki N)
```
Ağaçta `DALGA-B` + `Z107` veri turunun **commit edilmemiş** diff'i — **senin TABANIN**.

## 2 · ÜÇ KALEM — ⛔ ÜÇÜ DE AYNI TUR, AMA **FIXTURE'LARI AYRI**

`K-2.2.14`'ün *"tek bir bildirilmiş politika, **tüm yollarda aynı**"* şartı ancak üçü
**birlikte** inerse sağlanır. ⛔ **Ama fixture'ları ayrı olmalı — biri diğerinin yeşilini
TAŞIMASIN** (`Z107 §1`'in dersi: bir kusur bir yeşili taşıyabilir).

### `2.1` — Bütçesiz dönemde plan gönderimi: sessiz `DRAFT` **ÖLÜR**
Bugün: `HTTP 200` + `success:false` + `status` **`DRAFT`'ta takılı**. Kullanıcı bir **red**
görmüyor, plan **sessizce** ilerlemiyor.
⛔ **Yerine AÇIK cevap:** *"bu dönem/kategori için zarf yok"* — ⛔ ve **hangi dönem, hangi
kategori** olduğu mesajda **adıyla** (`K-2.2.11a` ruhu: *red mesajı hangi kalemin takıldığını
açıkça söyler*).
⛔ **ÖNCE ÖLÇ:** bugünkü yanıtın **gövdesinde** red gerekçesi yüzeye çıkıyor mu? Çıkıyorsa
kusur *"sessizlik"* değil *"yanlış statü kodu"*dur — teşhisi **ölçümle** düzelt, brief'in
cümlesine güvenme.

### `2.2` — `UtilizationStatus`'a *"zarf yok"* ÜYESİ + **ÜRETİCİSİ** (`Z91`)
`src/modules/shared/finance-reporting/dto/budget-utilization.dto.ts:11-15` bugün yalnız
`GREEN`/`AMBER`/`RED` taşıyor.
```
ihlal DEĞİL   0 döndürmek — sayıların yokluğu
İHLAL         GREEN döndürmek — GREEN bir YARGIDIR ("bütçe rahat") ve kaynağı bir YOKLUK
çözüm         İSTİSNA DEĞİL, BİLDİRİLMİŞ BİR DURUM: yeni üye + sayılar null
```
⛔ **Üye ve ÜRETİCİSİ (`!envelope` dalı) AYNI TURDA** (`Z91`).
⛔ **TÜKETİCİ ÖLÇÜMÜ ZORUNLU:** bu enum'u render eden/dallanan **her** yer — `collmind.backend`
**ve** `collmind.frontend` (⛔ frontend'e **DOKUNMA**, **ölç ve raporla**). Yeni bir üye
render edilmezse **sessizce boş** görünür — yani `§2.5`'i bir yerde kapatıp başka yerde açmış
oluruz.
📌 `SP-E2E-10` bu değişiklikle **kırmızıya döner** (`200` bekliyor) — ⛔ o testi **sen
düzeltmiyorsun** (`qa` şeridi), ama raporunda **adıyla** an.

### `2.3` — Trigger fallback'i **KALKAR**
`1831`'in trigger'ındaki `period_from IS NULL → period` fallback'i. `qa` turu onu engelleyen
dört ham `INSERT`'ü zaten düzeltti. ⛔ Kaldır **ve** *"hiçbir çağıran ona dayanmıyor"*u
**kanıtla** (yazan yolların **LİSTESİ** + fallback'siz yeşil kapılar).
⛔ Bu bir **migration** gerektiriyorsa **DUR ve numara iste** — `1831` **push edilmedi**, yani
aynı dosyada revize etmek **mümkün olabilir**; ⛔ ama bunu **ölç** (`git log`/`git status`),
varsayma.

## 3 · ⛔ DUR / KURALLAR
- **Test dosyalarına DOKUNMA** (`qa` şeridi) · **`collmind.frontend`'e DOKUNMA** (ölç, raporla).
- **`DALGA-A`'nın dosyalarına DOKUNMA** (`agreement.*` · `plan.repository` · `common/date/*` ·
  `lta-*`).
- `docs/brd-v2/**` **YAZMA** · yeni task **AÇMA** · `git commit`/`push` **YOK**.
- ⛔ **Migration numarası ALMA** — **DUR ve iste**.
- Reprodüksiyon-önce **yönsüz** · mutasyonda kopya + satır **BAS** + `shasum`
  (⛔ `git checkout` **YASAK**) · ölçüm **borusuz** · ilk komut hayalet-konteyner kontrolü.
- ⛔ Bir *"Team Lead kararı"* yazmadan önce sor: **"bu noktada bir HÜKÜM var mı, nerede yazılı?"**
- ⛔ **Rapor SAYI değil LİSTE**; e2e kırmızısını **bilinen 59 / seninki N** diye **sınıfla**.
