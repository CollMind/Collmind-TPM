# `ADIM 3` ölçüm 3 + 4 — onay **görme** tarafı · e2e route kapsamı

> **Ölçen:** Team Lead · **Tarih:** 2026-08-17 · **İsteme listesi:** `0073 §5/3`, `§5/4`
> **Araç:** `scratchpad/routes.py` — **yorum-temizlemeli** fixpoint parser (bkz. `§0`)

---

## 0 · ⚠️ ÖNCE: kendi parser'ımda bir kusur bulundu ve düzeltildi

`§5/3`'ü ölçerken **imkânsız bir sonuç** çıktı: `POST /plans/:id/reject` **filtresiz**
göründü, oysa kardeşi `POST /plans/:id/approve` `{ADMIN, CATEGORY_MANAGER}` taşıyordu.
Ham koda bakıldı — `plan.controller.ts:492`'de `@Roles(UserRole.ADMIN,
UserRole.CATEGORY_MANAGER)` **duruyor**.

**Kök neden:** route bloğunda **iki** `@Roles(` eşleşmesi vardı — gerçek dekoratör, ve
bir **yorumun içinde** geçen ikinci bir `@Roles(`. Parser döngüsü `roles`'u her
eşleşmede **üzerine yazıyordu**, yani **son eşleşme kazanıyordu** ve son eşleşme
yorumdaydı → `roles = []` → *"filtresiz"*.

```
BODY 1  'UserRole.ADMIN, UserRole.CATEGORY_MANAGER'     ← gerçek
BODY 2  'BRD "CM plan düzenleyemez"'                    ← YORUM, ve son olduğu için kazandı
```

📌 Bu, `CLAUDE.md`'nin **ilk-eşleşme-yorumda** tuzağının (`replace(…,1)`) **son-eşleşme**
kardeşi. Aynı aile, ters uç.

**Düzeltme:** kaynak **yorumları boşlukla doldurularak** ayrıştırılıyor (konumlar
korunur), ve `@Roles` için **ilk** eşleşme kazanıyor.

### Etkisi ölçüldü — taban BOZULMAMIŞ, ama iki sayı yeniden koşuldu

| ölçüm | kusurlu parser | düzeltilmiş | değişti mi |
|---|---|---|---|
| taban (`toplam / @Roles / filtresiz`) | `237 / 160 / 77` | **`237 / 160 / 77`** | ❌ — `roles=[]` boş küme, `None` değil; `160`'ın içinde sayılmıştı |
| `5/5` rol taşıyan | `18` | **`18`** | ❌ |
| dar-kümeli `GET` | `39` | **`39`** | ❌ |
| **boş `@Roles` kümesi** (kusur işareti) | — | **`0`** | ✅ temiz |
| `READONLY` taşıyan | `31` (fixpoint öncesi) | **`35`** | ⚠️ sayı bayat — **invaryant aynı: `Get` olmayan `0`** |

> **Yanlış çıkan tek çıktı, kusuru ortaya çıkaran çıktıydı.** Ve onu yakalayan şey bir
> guard değil, **sonucun kendi içinde tutarsız olmasıydı** — reject açık, approve kapalı.

---

## 1 · `§5/3` — onay **görme** tarafı: zaten AYRI, ve zaten daha GENİŞ

```
                                        GÖRME                         YAPMA
plan onayı      pending-approvals  {ADMI,CATE,READ}          approve/reject  {ADMI,CATE}
                approval-queue     {ADMI,CATE,FINA,READ}     escalate        {ADMI,CATE}
                approval-history   {5/5}                     submit          {ADMI,PLAN}
agreement       pending-approvals  {ADMI,CATE,FINA,READ}     approve/reject  {ADMI,CATE,FINA}
approvals       pending            {ADMI,CATE,FINA,READ}     approve/reject  {CATE}
dashboard       pending-tasks      {5/5}                     —
```

### CEVAP: `Faz B` `*_APPROVE`'u atlarsa görme tarafı **filtresiz kalmaz**

Görme uçlarının **hepsi `Get`**, yani taksonomide `*_READ` hücrelerine düşüyorlar —
`*_APPROVE`'a **değil**. `MODES_APPROVE`/`SHARED_APPROVE`'un rol kümelerinde
`READONLY` **hiç yok**; görme uçlarının hemen hepsinde **var**. İkisi zaten ayrık.

> **`0073`'ün uyarısı geçerliydi ama sonucu değil:** *"onay ekranı `K-2.6.6`'nın
> filtresiz kümesine düşer"* riski **gerçekleşmiyor** — görme tarafı `*_READ`'e
> düşüyor. ⚠️ **Ama o hücreler `DUR`'da** (`MODES_READ` · `SHARED_READ`), yani görme
> tarafının kaderi **`DUR`'lu hücrelere bağlı** — çözülmemiş, ama kayıp da değil.

### İki anomali — ve ikisi de birer soru, bir sonuç değil

**1 · `POST /approvals/:id/approve` = `{CATEGORY_MANAGER}` — `ADMIN` YOK.**
Tüm onay uçları arasında `ADMIN`'i dışlayan **tek** yer. `K-2.6.4a` bunu meşru
kılabilir: *"rol yalnız bir yetenek paketi değildir — **görev ayrılığının** ve onay
şablonlarının adres defteridir."* Yani `ADMIN`'in dışlanması bir **iş kuralı**
olabilir. **Ölçülmedi** — `L2`'de bu ucun adı geçmiyor.

⚠️ Ve union bunu **doğrudan bozardı**: `SHARED_APPROVE` union'ı `{ADMI,CATE,FINA,PLAN}`
idi — `CATEGORY_MANAGER`'ın tek başına taşıdığı onayı üç role daha açardı. **`DUR`
kararı bu ucu korudu.**

**2 · `plans/pending-approvals` `{ADMI,CATE,READ}` ↔ `plans/approval-queue`
`{ADMI,CATE,FINA,READ}`.** Aynı işin iki görme ucu, **farklı küme** — ve `FINANCE`
yalnız ikincisinde. Oysa `FINANCE` bir **yükseltme hedefi**
(`POST /plans/:id/escalate-to-finance`). Yükseltilen planı `pending-approvals`'ta
göremiyor. **İş kuralı mı, tesadüf mü — ölçülmedi.**

---

## 2 · `§5/4` — e2e route kapsamı: **`72 / 237`**

> Liste, sayı değil (`0073 §5/4`'ün şartı) — modül kırılımı aşağıda; tam liste
> `scratchpad/routes.py` ile yeniden üretilebilir.

```
modul          kapsanan / toplam
modes             42 /  70      ← en iyi
shared            12 /  57
master-data       10 /  64
customer           4 /  17
user               4 /  15
admin              0 /   2
tenant             0 /   8
notification       0 /   3
app (health)       0 /   1
```

**Kapsanmayan: `165` route.**

### Pozitif kontrol — ve bir yanlış alarm

| kontrol | beklenen | çıkan |
|---|---|---|
| `/plans` eşleşiyor mu | evet | **39 geçiş** ✅ |
| `tenants` `0/8` doğru mu | e2e'de geçmemeli | **0 geçiş** ✅ |
| `admin` `0/2` doğru mu | e2e'de geçmemeli | ⚠️ `audit-log` **3 geçiş** |

Üçüncüsü incelendi: **üçü de yorum** (`reversal.e2e-spec.ts:11` *"Audit log immutable…"*
vb.), istek değil. Eşleştirici **doğru**, kontrol yanlış alarm verdi.

> Yani aynı turda **ikinci kez** yorumlar bir ölçümü kirletti — biri parser'da (`§0`),
> biri pozitif kontrolde. İkincisi rapora girmedi çünkü kontrol **incelendi**, sayısına
> bakılıp geçilmedi.

### CEVAP: dinamik telemetrinin alt sınırı **`%30`** — statik guard `%70` taşıyor

`0073` Soru 3'ün yapısı bu ölçümle **doğrulandı ve niceliklendi**:

```
dinamik telemetri   en iyi hâlde 72 route hakkında konuşur      (ve bugün 0 —
                                                                 deploy YOK)
statik guard        165 route hakkında TEK kanıt kaynağı
```

⚠️ **Ve dağılım düz değil:** `tenant` · `admin` · `notification` modülleri **tamamen**
kapsam dışı. Telemetri açılsa bile o modüllerde **hiçbir zaman** sinyal üretmez —
oralarda *"eşlenmemiş uç yok"* demek, ölçümün değil **sessizliğin** sonucu olur.

📌 Bu, `0073`'ün *"trafik yokluğu"* teşhisinin **ikinci katmanı**: trafik olsa bile
**e2e trafiği bu modülleri hiç görmüyor.**

---

## 3 · İsteme listesinin durumu

| # | ölçüm | durum |
|---|---|---|
| 1 | dar-kümeli `READ` sınıfı | ⚠️ **kısmi** — üç küme ölçüldü, sonuç *karışık* (`ADIM3_OLCUM_1`) |
| 2 | `resolveScopeForFilter` ↔ `K-2.6.7` | ✅ **kapandı** — aynı mekanizma, ama `4/5` rolde kapalı → `T-235` |
| 3 | onay **görme** tarafı | ✅ **kapandı** — `*_READ`'e düşüyor, filtresiz kalmıyor; iki anomali açık |
| 4 | e2e route kapsamı | ✅ **kapandı** — `72/237`, üç modül **tamamen** kapsam dışı |
