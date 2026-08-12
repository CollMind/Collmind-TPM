# 0060 — BRD okuma turu **37**: `Sprint_0_Mandatory_Items.md` (tamamı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR — kod/migration/entity değişikliği yok.
- **Kaynak:** `docs/brd/Sprint_0_Mandatory_Items.md` (1–401, **tamamı**)
- **Neden bu dosya önce:** `0059 §2.1` — dört maddesinden üçü pakette **tek kaynak**, ve
  `AI-001` doğrudan [[T-123]]'ün karar konusu.
- **Ölçüm ortamı:** meta `e5d28c6`, branch `claude/0058-measurement-config-y6xz2z`.
  ⚠️ **Submodule'ler checkout edilmemiş** — bu turda **hiçbir ürün-tarafı iddiası yok**.

---

## 1. ⚠️ Önce belgenin STATÜSÜ — çünkü içeriği nasıl kullanacağımızı belirliyor

Belge kendi çerçevesini iki yerde çiziyor:

> *"These items are **operational details** … They do **NOT require BRD changes** — they
> belong in the **Engineering Pack**."* (satır 23)
>
> *"**Deliverable:** Engineering Pack (**to be created**)"* (son satırlar)

Ve dört maddenin her biri *"**Define in Engineering Pack:**"* diye başlayıp bir
` ```markdown ` bloğu açıyor. Yani gövdeler **hedef spesifikasyonun taslağı**, imzalanmış
metin değil — checklist'te dört ayrı **sign-off kutusu** boş duruyor (Engineering Lead,
Product Owner, Security Lead, QA Lead).

**Ölçüm:** Engineering Pack **repoda yok**.

```
find . -iname "*engineering*pack*"  ->  ./docs/brd/Engineering_Pack_Index.md   (yalnız INDEX)
```

`Engineering_Pack_Index.md` paketin ne **içereceğini** anlatıyor; içeriğin kendisi hiçbir
yerde yok.

> ### Sonuç: bu dört spesifikasyon, **taşınacakları yer hiç yaratılmadığı için** kaynak
> belgenin içinde kalmış.
>
> Bu, `0059`'un *"tek kaynak"* bulgusunun **sebebi**: madde tekrar edilmiyor çünkü tekrar
> edileceği belge açılmamış.

**Nasıl kullanılır (`§2.1.2`):** bunlar **girdidir, kanıt değil** — ve normal BRD
maddelerinden bir kademe daha zayıf, çünkü kendi süreçlerine göre **onaylanmamış**. Bir
kararı bunlara dayandırırken *"Sprint-0 taslağı, imzalanmamış"* diye yazılmalı.

---

## 2. 🔴 `AI-001` ↔ [[T-123]] — kararın **üçüncü seçeneği** kaynakta yazılı

### 2.1 T-123 neye karar vermişti

Kayıt (`T-123`, *"Bir katılık konuldu ve BİLEREK geri alındı"*): `off-invoice.getFiscalPeriod`
§2.5 gereği `throw` ediyordu; **satır-bazlı hata kanalı olmadığı için** throw mapper'ı geçip
**tüm dosyayı** satır numarasız reddediyordu. Ürün sahibi kararı: geri al, gerekçeyi koda
yaz, kanal task'ına ([[T-126]]) atıf ver.

> *"Katılığı, teslimi olmayan bir yere ekleme."*

### 2.2 `AI-001` ne diyor

```
1. Validation runs on all rows BEFORE any insert
2. Invalid rows are rejected (logged with reason)
3. Valid rows are committed to database
4. User receives: success count · error report (CSV) · re-import option
```

Hata raporu kolonları: `row_number` · `error_type` · `error_message` · `original_row_data`.
Kenar durumlar: boş dosya → hata · **tüm satırlar geçersiz → hata** · duplike → *"skip with
warning"*.

### 2.3 Karşılaştırma

| seçenek | davranış | kaynakta karşılığı |
|---|---|---|
| A — throw | tek bozuk satır **tüm dosyayı** düşürür | ❌ `AI-001` bunu yalnız *"all rows invalid"* için öngörüyor |
| B — sessiz fallback (bugünkü) | satır kabul edilir, dönem **başka bir kaynaktan** türetilir, kullanıcı hiçbir şey görmez | ❌ `AI-001`'de yok — *"rejected (logged with reason)"* diyor |
| **C — satır-bazlı ret + rapor** | bozuk satır reddedilir + sebebi raporlanır, **sağlam satırlar yazılır** | ✅ **`AI-001` tam olarak bu** |

> ### T-123'ün **teşhisi** doğrulanıyor, **kalıcı durumu** doğrulanmıyor.
>
> Geri alma gerekçesi (*"kanal yok"*) kaynakla **uyumlu**: `AI-001` de A'yı tek bozuk satır
> için öngörmüyor. Ama kaynağın çözümü B değil **C**; ve C'nin tasarımı — kolon adlarına
> kadar — [[T-126]] için **hazır** duruyor.

⚠️ **Ve fark maddi:** B'de dönem `agreement.periodMonth`'a düşüyor; çok dönemli bir
anlaşmada bu **başka bir zarf** demek (`CLAUDE.md §7.1`, ölçülmüş). C'de o satır **yazılmaz**
ve kullanıcı **hangi satır, neden** görür.

**Önerilen (kullanıcı onayına):**
- [[T-126]]'ya `AI-001` atfı + kolon şeması eklensin — hedef tasarım tartışılmadan hazır.
- `off-invoice` fallback'inin kod yorumuna kaynak atfı: *"AI-001 satır-bazlı ret diyor;
  kanal ([[T-126]]) gelene kadar fallback — Sprint-0 taslağı, imzalanmamış."*

---

## 3. `MC-001` — mekanizma **tekrar**, kabul ölçütleri **yeni**, ve kaynak kendi içinde uzlaşmamış

`0059`'da bu madde için tek-kaynak iddiası **yapılmamıştı** — doğruydu. Ölçüm:

| içerik | `Addendum H2`'de | `MC-001`'de |
|---|---|---|
| `SERIALIZABLE` + `SELECT … FOR UPDATE` | ✅ (244–258) | ✅ (tekrar) |
| retry + backoff | ✅ | ✅ (3 deneme) |
| **per-envelope kapsam** (*"farklı zarflar paralel, çekişme yok"*) | ❌ | ✅ **yeni** |
| **lock contention <%2**, P95 lock bekleme **<500ms**, timeout **5sn** | ❌ | ✅ **yeni** |

⚠️ **Ve iki belge aynı garanti için iki farklı "minimum" test tanımlıyor:**

| | H2 | MC-001 |
|---|---|---|
| kullanıcı | **10** | **5** |
| istek | 1.500 TL | 2.500 TL |
| bütçe | 10.000 TL | 10.000 TL |
| beklenen | 6 onay / 4 ret | 4 onay / 1 ret |

İkisi de doğru olabilir (biri load, biri smoke) ama **hiçbiri diğerine atıf yapmıyor** —
`MC-001`'in kendi bölümü *"Load Test (Phase 1.1): 10 / 20 / 50 kullanıcı"* diyor, yani
10-kullanıcılı H2 testini **Phase 1.1'e** koyuyor, H2 ise onu **Phase 1 kabul ölçütü**
sayıyor. Kayda geçiyor; karar ürün sahibinin ([[T-154]] bağlamı).

---

## 4. `MC-002` — bildirim spesifikasyonu (paketin tek yeri)

**6 olay:** Approval Requested/Granted/Rejected · Budget Alert 80% · Budget Alert 100% ·
Agreement Expiring (bitişten **5 gün önce**). Her biri için alıcı, kanal (Email / Email+In-App)
ve öncelik tanımlı.

**Şablonlar:** iki e-posta gövdesi değişken adlarıyla (`{agreement_name}`, `{consumption_pct}`…).
**In-app:** zil ikonu, okunmamış rozeti, 30 günlük liste, **WebSocket** ile gerçek zamanlı
toast (5 sn).

**Escalation — iki ayrı merdiven:**

| onay istekleri | bütçe uyarıları |
|---|---|
| 5. gün: approver'a hatırlatma | %80: bütçe sahibi |
| **7. gün: auto-expire** + requester'a bildirim | %95: + Finance Director |
| | %100: + Product Owner |

⚠️ İki bağlantı:
1. **7 günlük auto-expire** bir **state machine geçişidir**, bildirim ayrıntısı değil —
   `CANDIDATE-004` (approval edge cases) ile aynı konu. Belgenin kendi *"Integration"*
   tablosu da bunu söylüyor: *"Add to CANDIDATE-004 → MC-002 escalation"*. Yani kaynak,
   maddenin **yanlış belgede** olduğunu biliyor.
2. Eşikler (`80/95/100`) `CLAUDE.md §2.3` ve `Section_08 §8.1` ile **hizalı**; yeni olan
   **alıcı listesi**.

---

## 5. `EA-001` — admin kısıtları ve **altıncı rol**

**Super Admin** (`super.?admin`: tüm pakette **2 geçiş, ikisi de burada**):
- *"User role changes: **Requires Super Admin** (separate from Admin)"*
- *"User role escalations → Approval from Super Admin"*

`Section_07 §7.1` **beş rol** sayıyor. Yani bu madde ya bir **altıncı rol** ekliyor, ya da
§7.1'in Admin'ini ikiye bölüyor — **belge bunu söylemiyor**. `§2.4` gereği DUR: yorum ürün
sahibinin.

**Admin yasakları** (özet): kendi yarattığı agreement'ı onaylayamaz · onay akışını
atlayamaz · **kendi rol iznini değiştiremez** · onaylanmış agreement'ı ve tüketilmiş bütçe
hareketini silemez · **ledger'a dokunamaz (append-only)** · audit log silemez ·
**agreement yaratamaz** (Planner rolü gerekir) · bütçe commit edemez (Finance gerekir).

**Yüksek riskli aksiyonlarda alarm:** rol izni değişimi → güvenlik ekibi · **>10 toplu
kullanıcı pasifleştirme** → Product Owner · zarf silme → Finance Director.

**Hesap verebilirlik:** aylık admin log incelemesi · **>100.000 TL zarf değişikliğinde
gerekçe zorunlu**.

⚠️ Bunların `Section_07 §7.1`'deki *"separation of duties (planner ≠ approver)"* iki
satırıyla ilişkisi **kurulmamış**. İkisi çelişmiyor; ama biri iki cümle, diğeri bir matris.

---

## 6. Ne ölçülmedi (ZORUNLU)

- **Ürün tarafı hiç ölçülmedi.** Submodule'ler bu container'da yok. Bu dokümanda *"üründe
  var / yok"* diyen **tek bir cümle bile yoktur** — dördü de yalnız **kaynak** ölçümüdür.
  (`§7.1`'in *"mekanizma var, yol yok"* sınıfı burada **sorulmadı**, cevaplanmadı.)
- **`Engineering_Pack_Index.md` (370 satır) okunmadı** — yalnız pack'in var olmadığı
  ölçüldü. `0059` onu ⚪ (navigasyon) saymıştı; bu tur o kararı değiştirmiyor ama artık
  bir sorusu var: *pack hiç yaratılmadıysa index neyi indeksliyor?*
- `AI-001`'in *"duplike → skip with warning"* maddesi ile `Section_04`'ün **file hash /
  idempotency** mekanizması (600–700) arasındaki ilişki **karşılaştırılmadı**.

---

## 7. Bu turdan çıkan aday task'lar (açılmadı — onay bekliyor)

| # | konu | dayanak |
|---|---|---|
| 1 | [[T-126]]'ya `AI-001` hedef tasarımını (satır-bazlı ret + CSV rapor şeması) ekle | §2 |
| 2 | `off-invoice` fallback yorumuna kaynak atfı + statü notu | §2.3 |
| 3 | **Super Admin**: altıncı rol mü, Admin'in bölünmesi mi — ürün sahibi kararı | §5 |
| 4 | `MC-002` auto-expire (7 gün) `CANDIDATE-004`/state machine kapsamına taşınsın | §4 |
| 5 | `MC-001` ↔ `H2` concurrency kabul testi uzlaştırılsın (5 mi 10 mu, hangi faz) | §3 |
| 6 | Bildirim + admin kısıtlarının ürün tarafı **ölçülsün** (submodule'lü bir oturumda) | §6 |
