# Denetim Sözlüğü — kanonik olay biçimleri

> **Açılış:** 2026-08-20 · **Karar:** `04_KARAR_KAYDI.md` `Z15` · **Yazan:** Team Lead
> **Statü:** `ADIM 6` teslimi, **erken açıldı** — `T-244` bloke kalmasın diye.
> **Kanal:** yalnız Team Lead yazar (`L2` ile aynı gerekçe: tek yazar, tek kanal).

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

### Alanlar

| alan | zorunlu | not |
|---|---|---|
| `eski küme` | ✅ | değişiklikten **önceki** `(cplId, categoryId)` çiftleri |
| `yeni küme` | ✅ | **sonraki** çiftler — `REVOKE_ALL`'da **boş** |
| `kim` | ✅ | **aktör** (`A1`'in kusuru: etkilenen yazılıyordu) |
| `ne zaman` | ✅ | |
| `niyet` | ✅ | `UPDATE` \| `REVOKE_ALL` — çağrının **açık** alanı |
| `gerekçe` | ⚠️ **koşullu** | `REVOKE_ALL`'da **ZORUNLU** · `UPDATE`'te opsiyonel |

📌 **Gerekçenin koşullu zorunluluğu** `K-2.5.15` ailesiyle tutarlı bölünmüştür
(`Z15`): yıkıcı olan eylem gerekçe ister, olağan olan istemez.

### Neden *"eski küme → yeni küme"*

`Z15`'in **replace** kararının doğal sonucu: uç **hedef durumu** alıyor, yani kayıt da
**iki durum** yazar. Ekle/çıkar modelinde kayıt bir **delta** olurdu ve *"bugün bu
kullanıcı neyi görüyor"* sorusu **birikimli okuma** gerektirirdi.

---

## Açık maddeler (sözlük tamamlanmamıştır)

`ADIM 6` bu belgeyi tamamlar. Bugün **yalnız `Madde 1`** yazılı.

⚠️ **Ve `ADIM 2`'nin dört ailesi henüz TAŞINMADI** — taşındığında bu satır kalkar.
