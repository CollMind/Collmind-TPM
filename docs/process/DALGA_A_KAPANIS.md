# `DALGA-A` — KAPANIŞ BEYANI
### 2026-09-08 · üç şerit · `kapandı · açıldı · kapsanmadı`

> ⛔ Bu belge `Z110`'un girdisidir, `Z110` değildir. Her satır etiketli.

---

## `§1` · ÜÇ SÜTUN

### ✅ KAPANDI

| ne | kanıt |
|---|---|
| **`1833`** `agreements.category_id NOT NULL` — `Z98 §3`'ün son halkası (`tanım → yazar → kısıt`) | `[ÖLÇÜLDÜ: migration-verify.sh → exit 0 · 33s · snapshot0==snapshot2 · snapshot1==snapshot3]` |
| **`T-378`** — `resolveEffectiveCategoryId`'nin FU→GU fallback'i **öldü** | `[ÖLÇÜLDÜ: private, İKİ çağrı yeri, ikisi de findById (relations, select YOK)]` |
| **aynı yeteneğin SQL kardeşi** — `COALESCE` + iki `leftJoin` düştü | `[ÖLÇÜLDÜ: is_nullable='NO' ⇒ COALESCE(a,b)≡a · rg "scopeFu\|scopeGu" → üç satır, hepsi burada]` |
| **`T-383` ŞEKİL 2** — `off/on-invoice` kopya guard'ı tek mekanizmaya indi | `[ÖLÇÜLDÜ: reprodüksiyon — TZ=UTC ↔ Europe/Istanbul, tenant BUGÜNÜ olan fatura YANLIŞLIKLA reddediliyordu]` |
| **`İŞ C`** — `manager` tip kapısı, **iki vaka-yüzeyi bütün** | `[ÖLÇÜLDÜ: budget.repository 0/14 · notification.repository 0/2]` |
| **kalan 36** — `manager-ratchet` doğdu ve `run-all.sh`'a **bağlandı** | `[ÖLÇÜLDÜ: yeşil exit 0 · kırmızı "4 -> 5" · ÖLÇEMEDİM exit 2 · self-test 8/8]` |
| **`T-387 🟡-5`** — `envelopeFound?` zorunlu oldu | aynı hamle, `İŞ C` içinde |

### ⏸ AÇILDI

| ne | neden açık |
|---|---|
| **`T-383` ŞEKİL 1** (`new Date()` + takvim alanı, üç yer) · **ŞEKİL 3** (DB karşılaştırması) | brief'in eylem maddesi yalnız `ŞEKİL 2`'ydi |
| **`T-383` ŞEKİL 3'ün EVRENİ BÜYÜDÜ** — `finance-reporting.service.ts:238 · :513 · :1130` | ⛔ tespit edildi, **SINIFLANMADI** (kaçak mı meşru mu). ⇒ `T-388` ile **aynı küçük tur**, ⏰ 30 Eylül |
| **`T-387 🟡-4`** — `checkEnvelopeAvailability` hâlâ `manager` geçmiyor | `İŞ C` **imza** turuydu; bu bir **davranış** kalemi. 📌 Ama boşluk artık **görünür**: çağıran açıkça `undefined` yazıyor |
| **`T-390`** — `migration-schema` guard'ı düz metni SQL sanıyor | bu turda bir hata mesajını **bozdurdu** (bilgi kaybetti) |
| **`T-128`** — araç sınırı: ölçüm komutu `tsc` iken `ADIM 5` çakışıyor | şerit `--no-compile` ile aştı, **yüksek sesle**; araç bunu kendisi tanımalı |
| **kalan 36 `manager?`** | ⛔ task değil **ratchet** — sınıf büyümez, ödeme dokunuldukça |

### ⛔ KAPSANMADI

```
· resolveEffectiveCategoryId'nin ÇALIŞMA ZAMANI davranışı (yalnız derleme ölçüldü)
· finance-reporting'in üç ŞEKİL-3 örneği KAÇAK mı MEŞRU mu — sınıflanmadı
· lta-agreement.service → repository (ÜÇÜNCÜ taban, DB oturum TZ'si) — T-383'te açık
· 36 metodun kendi yüzeyinde YENİ/EKSİK bir şey olup olmadığı (DUR listesi gereği dokunulmadı)
· "fatura tarihi gelecekte olamaz" TEKİL işlem yolunda koşmuyor — tek mekanizma AMA
  her üretim yüzeyi ona bağlı DEĞİL (code-reviewer 📌; T-383'e not)
```

---

## `§2` · ÜÇ METRİK — `Z110`'un tabanı

```
                    ŞERİT 1      ŞERİT 2      İŞ C        TOPLAM
tur süresi          ~15 dk       ~34 dk       ~25-30 dk   ⚠️ İŞ C'ninki TAHMİN (şerit
                                                            başlangıcı loglanmadı)
review-tur          2 (kendi)    0            0           1 dış tur: 6 bulgu, 5 kapandı
DUR                 1            1            0           2
```

⛔ **İki `DUR` da HAKLIYDI ve ikisi de BRIEF'İN eksiğini gösterdi:**
```
ŞERİT 1  §5'in cevabı bir DERLEME HATASI olarak geldi — brief bunu öngörmemişti
ŞERİT 2  BRIEF KENDİ İÇİNDE ÇELİŞTİ (§0.3 B ↔ §6) — Team Lead hatası
```

---

## `§3` · BU DALGANIN DERSLERİ — üçü de Team Lead'in

```
1  SEMBOLÜN evrenini ölçtüm, YETENEĞİN evrenini değil
   resolveEffectiveCategoryId'nin iki çağıranı doğruydu; aynı yeteneğin SQL
   implementasyonu (COALESCE) sayılmadı. ⇒ "başka hangi ŞEKİLDE" sorusunun SEMBOL hâli.

2  §2.7 #6'yı KAPATMAK için yazdığım satır §2.7 #6'YDI
   `toHaveBeenCalledWith(tenantId)` — ÇAĞRILDIĞI ≠ SONUCUNUN AKTIĞI.
   mutate.sh çürüttü ("MUTASYON HAYATTA"), ölçüm ARGÜMANA taşındı.

3  KANIT RENGİN KENDİSİ DEĞİL, RENGİN SEBEBİDİR — ve ihlal eden bendim
   ratchet'in bilinen-kırmızısı DOĞRU ÇIKTI ama YANLIŞ SEBEPLE (36→35 azalma,
   36→37 artış değil). Araç "YAKALANDI" dedi ve haklıydı; ölçtüğüm şey yanlıştı.
```

> ### Üçünde de **kural yerindeydi**. Eksik olan onları **kendi işime uygulamak**tı —
> ### ve üçünü de **başka bir el** yakaladı: review · araç · yine araç.

---

## `§4` · `Z109`'UN YATIRIMI — İDDİA DEĞİL, İKİ ÖLÇÜM

```
[ÖLÇÜLDÜ]  migration-verify.sh  →  1830'un BAYAT NUMARA olduğunu ŞERİT AÇILMADAN gösterdi
                                   (HEAD 1832 kalır ⇒ run→revert→run imkânsız)
[ÖLÇÜLDÜ]  mutate.sh            →  yanlış assertion'ımı ÇÜRÜTTÜ; bu dalgada BEŞ KEZ koşuldu
[ÖLÇÜLDÜ]  BRIEF_SABLONU        →  üç şeridin ÜÇÜ de etiketli raporladı ve
                                   "NE ÖLÇEMEDİN" başlığını DOLDURDU
```
⛔ Ve `hüküm 25`'in dersi **zamanında** uygulandı: *"dar, imza-only dokunuş"* cümlesi
**şerit açılmadan** ölçüldü ve çürütüldü (52 metot / ~140 çağrı) ⇒ kapsam yeniden çizildi.

## `§5` · KAPI
```
tsc 0 · lint 0 · guards 0 (manager-ratchet DAHİL: temiz)
unit 88 suite / 1551 test · e2e 64 suite / 887 test · [T-047 invariant] PASS
migration-verify.sh 1833 → exit 0
⛔ hepsi TEAM LEAD'in KENDİ koşumu — İŞ C şeridi eşzamanlı iki `npm test` çalıştırdığını
  AÇIKÇA bildirdi, sonucu DEVRALINMADI.
```
