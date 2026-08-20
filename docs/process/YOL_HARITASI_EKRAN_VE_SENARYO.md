# Yol haritası — ekran ve senaryo katmanı

- **Açıldı:** 2026-08-13
- **Kapsam:** `Faz 2` ve `Faz 3`'e ait üç karar — bu turda oluştu, hiçbiri yazılı değildi
- **Neden ayrı belge:** aşağıda, `§Yer kararı`

> **Bu bir plan değil, bir karar kaydıdır.** Üç karar burada yazılı olmasaydı, `Faz 2`
> planlanırken **yeniden tartışılacaktı** — ve bu projede bir kararın iki kez verilmesi,
> ikisinin farklı çıkması demektir (`OPEN_DECISIONS §Neden açıldı`).

---

## Yer kararı — neden `FAZ1_PLAN`'ın devamı değil

Üç gerekçe, biri ölçüm:

1. ⛔ **`FAZ1_PLAN` bu dalda YOK** — ölçüldü (2026-08-13): `find . -name '*FAZ1*'` → **0**.
   Yerel oturumda var, buraya gelmedi. Var olmayan bir belgenin devamı yazılamaz.
2. **Adı kapsamını bağlıyor.** `FAZ1_PLAN` tanımı gereği `Faz 1`; buradaki içerik `Faz 2` ve
   `Faz 3`. Bir Faz 1 planına Faz 3 işi yazmak, `F8`'in kapsam hâli.
3. **`L1 §1.14` bir ürün belgesidir**, sıralama planı değil. Faz *kapsamını* anlatır (*"bu
   sürümde ne yok"*), *"hangi sırayla yapılır"*ı değil. Sıralama `docs/process/`'in konusu —
   `TEAM_LEAD_IS_LISTESI` orada.

⚠️ **Ve bir sınır:** `Faz 2` / `Faz 3` bugün **plan olarak yok.** Bu belge onları da
yazmıyor — yalnız o planlar yazıldığında **girdi olacak üç kararı** kaydediyor.

---

# 1 · Senaryo katmanı — yeni bir iş türü

```
şimdi     hakediş senaryoları (Fable, Faz 1 paralel)
sonra     senaryolardan EKRAN LİSTESİ türetilir
          ⚠️ bugün hangi ekranların gerektiğini TAHMİN ediyoruz
```

**Karar:** ekran listesi bir tasarım toplantısından değil, **senaryodan** türetilir.

> Gerekçe: bugünkü ekran envanteri bir **tahmindir**, ve tahminin bedeli ölçüldü — bkz. §2'nin
> kanıt tablosu. Bir senaryo *"kullanıcı şu olayı takip ediyor"* der; ekran listesi o cümlenin
> sonucudur, öncülü değil.

Diğer alanlar için de gerekecek, ama **sırası hakedişten sonra:**

```
planlama · bütçe · onay · kurulum
🔒 iki olgun ama ARAYÜZSÜZ yetenek — anlaşma kapanışı · formül doğrulaması
```

📌 O iki `🔒` rastgele seçilmedi: `EK_E`'nin *"yetenek var, arayüzü yok"* sınıfının **koddan
ölçülmüş** iki vakası (`0068 §6` · `0054 §1`). Senaryo yazımı onlarla başlarsa, katmanın
değeri ilk turda görünür — çünkü orada **yapılmış iş** var, yalnız yolu yok.

---

# 2 · Ekran denetimi — `Faz 2`'de başlar, `Faz 3`'te biter

**Denetim, redesign değil.** Ve sorusu `EK_E`'den farklı:

| | sorusu |
|---|---|
| `EK_E` | *"yetenek var mı"* |
| **denetim** | *"AKIŞ çalışıyor mu"* — hangi adım hangi ekranda · kaç ekran değiştiriyor · nerede geri dönmek gerekiyor |

## ⚠️ Hipotez (ölçülmedi, ve öyle işaretli)

> Bugünkü ekranlar **modüle göre** bölünmüş (`plan` · `bütçe` · `anlaşma`), ama bir
> kullanıcının işi **bir olayı takip etmek** — ve o olay üç ekrana yayılıyor olabilir.

Bu bir **hipotezdir**, bulgu değil. Denetimin ilk işi onu ölçmek: bir olayın (ör. bir
taktiğin plandan hakedişe yolculuğu) kaç ekran değiştirdiğini **saymak**.

## Ölçülmüş kanıtlar — ekran katmanının sahiplenilmediği

| kanıt | ne diyor |
|---|---|
| `T-222` | iki grid, biri karanlıkta |
| `T-223` | `export.ts` sıfır çağıran |
| **`EK_E`** | 5 rapor menüde, hiçbiri çalışmıyor — **`❌`'ten KÖTÜ** |
| `T-243` | kapsam seçici tasarımı **ajan tarafından** verildi |

> ⛔ **Atıf sınırı — ölçüldü 2026-08-13:** `T-222` · `T-223` · `T-243` **bu dalda yok**
> (`.claude/backlog/tasks/` en yüksek: `T-209`). Yerel oturumda açılmışlar. Kanıtların
> **kendileri** doğrulanmadı; burada **işaretçi** olarak duruyorlar, doğrulanmış bulgu olarak
> değil. `staging` birleşmesinden sonra bu satır ya doğrulanmalı ya düşürülmeli.
>
> `EK_E` maddesi ise bu dalda **doğrulanabilir** ve doğrulandı — ve üçünden farklı bir sınıf:
> *"menüde var, çalışmıyor"*, `❌`'ten kötüdür çünkü kullanıcıya **bir söz verip tutmaz.**

## ⚠️ Bloklama kuralı

**Ekran denetimi `Faz 2`'yi bloklamamalı.** Senaryolarla başlar, ama tamamlanması `Faz 3`.

> Yoksa hakediş motoru bir **arayüz tartışmasında** bekler — ve o tartışmanın doğal süresi
> motorun süresinden uzundur.

---

# 3 · Tasarım katmanı — ⛔ yeri hâlâ karar bekliyor

`_YAPISAL_TAMAMLAMA` bunu kaydetti ve boşluk **açık kaldı:**

```
hangi bilgi gösterilmeli   L2'de, kural olarak   VAR
yetenek ↔ arayüz           EK_E'de               VAR
görsel tasarım             ⛔ KATMAN YOK
```

Açık sorular:

| soru | bugünkü hâl |
|---|---|
| nerede yaşar | `docs/design/` · ayrı repo · başka — **karar yok** |
| versiyonlanır mı | Claude Design çıktıları — **karar yok** |
| kim sahiplenir | **her PR kendi kararını veriyor** |

> Üçüncüsü bir boşluk değil, bir **durum**: sahipsizlik bugünkü fiilî sahiplik biçimidir, ve
> `T-243`'ün (*tasarımı ajan verdi*) kaynağı odur.

⚠️ Bu üç soru **`Faz 2`'den önce** cevaplanmalı: senaryolardan ekran listesi çıkınca, o
listenin çıktıları **bir yere** yazılacak. Yer kararsızsa çıktılar PR açıklamalarında
dağılır — ve `OPEN_DECISIONS`'ın açılış gerekçesindeki *"kayıt yeri sessizce kaydı"*
vakasının aynısı olur.

---

# Sıra — bağlayıcı

```
Faz 1   güvenlik temeli                              ← ŞU AN
Faz 2   hakediş motoru + senaryolar + yeni ekranlar
Faz 3   planlama düzeltmesi + raporlar + EKRAN DENETİMİ tamamlanır
```

📌 Bu sıra `L1 §1.14`'ün ölçümüyle **tutarlı**: *"Faz 2'nin eksik yarısı, Faz 1 tabanının
üstünde duruyor"* — yani *"önce taban"* bir tercih değil, Faz 2'nin ön koşulu.

---

# Bu belgenin sınırları

1. **`Faz 2` / `Faz 3` planı değildir.** O planlar yazıldığında bu üç karar **girdi** olur.
2. **`T-222`/`T-223`/`T-243` doğrulanmadı** — bu dalda yoklar (yukarıda işaretli).
3. **§2'nin hipotezi ölçülmedi** ve öyle yazıldı: *"üç ekrana yayılıyor olabilir."* Denetimin
   ilk işi onu saymak.
4. `docs/design/` **bugün yok** — bir öneri olarak yazılı, karar değil.
