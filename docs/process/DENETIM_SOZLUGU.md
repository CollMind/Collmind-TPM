# Denetim Sözlüğü — kanonik olay biçimleri

> **Açılış:** 2026-08-20 · **Karar:** `04_KARAR_KAYDI.md` `Z15` · **Yazan:** Team Lead
> **Statü:** `ADIM 6` teslimi, **erken açıldı** — `T-244` bloke kalmasın diye.
> **Kanal:** yalnız Team Lead yazar (`L2` ile aynı gerekçe: tek yazar, tek kanal).
> **Dayanağı:** `L2_02` **`K-2.11.2`** — *"aşağıdaki olay grupları kaydedilir"*.
> Bu belge o kuralı **uygular**, yeni bir kural koymaz: `K-2.11.2` olay **gruplarını**
> zorunlu kılar, sözlük o grupların **alan biçimini** tanımlar.
>
> ⚠️ Bağ **iki yönlüdür** — `K-2.11.2`'nin altında bu belgeye atıf vardır. Tek yönlü
> olsaydı `L2` okuyan biri sözlüğü hiç görmez ve **beşinci aileyi** yazardı; yani
> sözlük, görünmediği için işlevsiz kalırdı. Karar: `04_KARAR_KAYDI.md` `Z16`.

---

## Neden bu belge var

`ADIM 2` ölçüm 2 (`ADIM2_OLCUM_2_4_5.md`) şunu buldu:

```
kanonik sözlük  YOK
bugünkü hâl     DÖRT AYRI AİLE · 39 yazma ucu → 4 sınıf
```

`T-244` (kapsam verme denetimi) bir kayıt biçimine ihtiyaç duyuyor. Onu **bağımsız**
tanımlarsak, sözlük geldiğinde **beşinci aile** oluruz.

> **`Z15`:** *"`T-244` bağımsız bir format değil, **sözlüğün erken açılan ilk
> sayfası**."*

⚠️ **`ADIM 2`'nin dört-aile ölçümü bu sözlüğün TABANIDIR** — yeniden sayılmaz, ve
sözlük tamamlandığında o dört aile **bu belgeye taşınır**, buradan **kopyalanmaz**.

---

## Ortak alanlar — her olay taşır

`K-2.11.4` (*"her kayıt en az şunları taşır"*) bu belgede somutlaşır:

```
kim         aktör kimliği — ⚠️ İŞLEMİ YAPAN, işlemden ETKİLENEN değil
ne zaman    zaman damgası
ne          olay türü (aşağıdaki katalogdan)
neye        hedef kaynak kimliği
```

> ⚠️ *"Kim"*in vurgusu bir **ölçülmüş kusurdan** geliyor (`T-244`/`A1`):
> `createdBy: savedUser.id` — kapsam satırının *"bu erişimi kim verdi"* alanı **yeni
> kullanıcının kendisini** gösteriyordu.

---

## Madde 1 · `SCOPE_CHANGE` — kapsam değişikliği

**Kaynak:** `Z15` · **Sahibi:** [[T-244]] · **Tüketicisi:** [[T-242a]]

### Olay türleri — **iki**, ve ayrım bilinçli

```
SCOPE_UPDATE       kapsam kümesi değişti (hedef küme BOŞ DEĞİL)
SCOPE_REVOKE_ALL   kapsam tümüyle boşaltıldı  ⚠️ AYRI OLAY TÜRÜ
```

> **`Z15`:** *"`REVOKE_ALL` denetim kaydında **ayrı olay türü** olur — biçimin **ilk
> alan gereksinimi** bu ayrımı taşımak."*

**Neden ayrı:** `K-2.6.8a` gereği boş kapsam = **erişim yok**. Yani `REVOKE_ALL` bir
güncelleme değil, bir **erişim kaldırma**. Aynı olay türüne konsaydı denetim
*"kullanıcı neden hiçbir şey göremiyor"* sorusunu **cevaplayamazdı**.

#### ⚡ Yaratma anı — **üçüncü tür AÇILMADI** (`Z16`)

Bir kullanıcı yaratılırken verilen ilk kapsam da **`SCOPE_UPDATE`**'tir; eski küme
**`∅`** yazılır.

| | |
|---|---|
| ayrım ekseni | **"hedef küme boşalıyor mu"** — *"ilk verme mi"* DEĞİL |
| üçüncü tür neden yok | farklı bir eksende bölerdi → [[T-242a]]'nın kayıtlarıyla **karşılaştırılamaz** olurdu |
| asıl test | *"bugün bu kullanıcı neyi görüyor"* **iki durumda da aynı okunur** |
| `İlke 1` | *"bu erişim doğuştan mı geldi"* sorusu **bugün sorulmuyor** — sorulursa `eski küme = ∅` zaten cevaplıyor |

> ⚠️ **Yaratma OLAYININ kendisi bu maddenin konusu değildir** — o `Madde 2`'ye aittir
> ve bugün **açıktır** (aşağıya bakınız). Bu madde yalnız **kapsam verme** olayını
> tanımlar.

### Alanlar

| alan | zorunlu | not |
|---|---|---|
| `eski küme` | ✅ | değişiklikten **önceki** `(cplId, categoryId)` çiftleri |
| `yeni küme` | ✅ | **sonraki** çiftler — `REVOKE_ALL`'da **boş** |
| `kim` | ✅ | **aktör** (`A1`'in kusuru: etkilenen yazılıyordu) |
| `ne zaman` | ✅ | |
| `niyet` | ✅ | `UPDATE` \| `REVOKE_ALL` — çağrının **açık** alanı. ⚠️ **Kayıtta `ne` alanına düşer** — aşağıya bakınız |
| `gerekçe` | ⚠️ **koşullu** | `REVOKE_ALL`'da **ZORUNLU** · `UPDATE`'te opsiyonel |

📌 **Gerekçenin koşullu zorunluluğu** `K-2.5.15` ailesiyle tutarlı bölünmüştür
(`Z15`): yıkıcı olan eylem gerekçe ister, olağan olan istemez.

### ⚠️ `niyet` kayıtta AYRI bir alan DEĞİL — `ne`'ye düşer (`Z17`)

```
UÇ'ta      intent: UPDATE | REVOKE_ALL      ← girdi alanı, ZORUNLU
KAYITTA    ne = SCOPE_UPDATE | SCOPE_REVOKE_ALL   ← tek alan, aynı bilgi
```

`Z15`'in `intent` kararı **ucun girdi alanıydı**: boş bir dizinin *"temizle"* mi
*"hata"* mı olduğunu ayırmak için. **Kayıt tarafında ikinci bir kolona ihtiyaç yok** —
iki tür zaten iki değer.

> **`İlke 1`:** ayrı bir `niyet` kolonu yaratmada **her zaman sabit `UPDATE`** olurdu,
> yani hiçbir bilgi taşımazdı.
>
> Ve *"çağıran ne demek istedi ↔ sistem ne kaydetti"* sapması **oluşamaz**: doğrulama
> katmanı `boş küme ∧ intent ≠ REVOKE_ALL → ret` kuralıyla onu zaten reddediyor.

📌 **[[T-242a]] aynı tek alanı yazar.**

### ⚠️ `hedef` = KULLANICI, kapsam satırı değil (`Z17`)

```
entity_type = 'user'          entity_id = <kullanıcının id'si>
```

Olay, **kullanıcının kapsamının değişmesidir** — bir kapsam satırının değil. `replace`
semantiği bunu zaten söylüyor: hedef bir **küme**, ve kümenin sahibi **kullanıcı**.

**Kapsam kümesi `eski küme`/`yeni küme` alanlarında yaşar** — `hedef`in taşımasına
gerek yok.

> ❌ **Ölçülmüş kusur (`T-244` review, `m1`):** ilk uygulama `entity_type='user_scope'`
> + `entity_id=<kullanıcı id>` yazıyordu. Repodaki **16 üreticinin 16'sında** `entity_id`,
> `entity_type`'ın adlandırdığı tablonun id'sidir — bu tek istisnaydı, ve sonucu ölçüldü:
> `JOIN user_scopes ON id = entity_id` **her zaman 0 satır** döner.
>
> ⚠️ `Z15` bu biçimi *"sözlüğün ilk maddesi"* ilan ettiği için düzeltilmeseydi
> [[T-242a]] istisnayı **miras alır**, ve sözlük **yanlış bir deseni kanonikleştirirdi**.

### Neden *"eski küme → yeni küme"*

`Z15`'in **replace** kararının doğal sonucu: uç **hedef durumu** alıyor, yani kayıt da
**iki durum** yazar. Ekle/çıkar modelinde kayıt bir **delta** olurdu ve *"bugün bu
kullanıcı neyi görüyor"* sorusu **birikimli okuma** gerektirirdi.

---

## Açık maddeler (sözlük tamamlanmamıştır)

`ADIM 6` bu belgeyi tamamlar. Bugün **yalnız `Madde 1`** yazılı.

### `Madde 2` · Kullanıcı yaşam döngüsü — ⛔ **AÇIK**

**Kapsamı:** kullanıcı yaratıldı · rolü değişti · pasifleştirildi · silindi.

```
ŞART        kullanıcı yaratma olayı denetim kaydına girsin
SAĞLAYICI   bu madde
DURUM       ⛔ bugün YOK → ADIM 6'da, ADIM 2 ölçümünden SONRA yazılır
```

⚠️ **Bu bir kilittir, bir erteleme değil** — ve sessiz kalmıyor: [[T-244]]'ün `A7`
bulgusu *"kullanıcı yaratma **ve** kapsam verme loglanmıyor"* diyordu. `T-244`
**yalnız kapsam verme** yarısını kapatıyor; yaratma yarısının adresi **burasıdır**.
Yani `CLAUDE.md §2.3`'ün *"her işlem loglanır"* ihlali **sürüyor ve biliniyor.**

> **Neden bu turda yazılmadı:** `T-244`'ün dar kapsamı *"başka olay türü
> tanımlanmaz"* şartını taşıyor, ve o şartın gerekçesi `ADIM 2`'nin **dört aile**
> ölçümü. Erken tanımlamak, `Z15`'in engellemek için yazıldığı hatanın kendisi
> olurdu. Karar: `Z16`.

⚠️ **Ve `ADIM 2`'nin dört ailesi henüz TAŞINMADI** — taşındığında bu satır kalkar.
