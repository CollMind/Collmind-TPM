# `B3` Kaza / İstisna Dalgası — KAPANIŞ RAPORU

> **Tarih:** 2026-08-26 · **Statü:** ✅ **KAPANDI**
> **Bilanço okuması:** `KAPATTI` · `DEVRETTİ` · `AÇTI` (ürün sahibi şartı)

---

## 1 · YENİ SABİT — ve tarihçenin dördüncü kaydı

```
165 + 45 = 210      FILTRESIZ 0      G7 commit=210 taze=210 BIREBIR
gerekçe:  POST /budget/reserve silindi (T-289 / Z38 §1) — envanter 211 → 210
```

**Envanter tarihçesi — hep aynı biçimde, gerekçeli ve geri-yürünebilir:**

| geçiş | sebep |
|---|---|
| `238 → 223` | ölü uçların silinmesi |
| `223 → 211` | `Z24`/`T-265` temizliği |
| `211 → 210` | **bu dalga** — `K6`, `T-289`'un ucu |

> 📌 Dizi artık kendi başına bir **denetim aracıdır**: her envanter değişimi
> **gerekçeli, izli, geri-yürünebilir**.

---

## 2 · BİLANÇO — `KAPATTI` · `DEVRETTİ` · `AÇTI`

### ✅ KAPATTI (beş kalem)

| kalem | yön | ne |
|---|---|---|
| `K1` | **DARALTMA** | `Z20` — `GET /users` `{A,FINANCE}` → `{A}`. `Z20` bu commit'le **tamamlandı** |
| `K2` | **GENİŞLEME** | ledger-üçlüsü `{A,F}` → `{A,F,P}`. Kısıt **fiilen bir bypass'tı** — çift ölçümle kanıtlandı |
| `K3` | **DARALTMA** | `T-287` — üç canlı `403`. `/finance` **widget** seviyesinde, diğer ikisi ekran seviyesinde |
| `K4` P1 | **DAVRANIŞ-KORUYUCU** | `approvals` çifti → `APPROVAL_QUEUE_READ`, küme **birebir** |
| `K6` | **SİLME** | `T-289` — kırık ölü paralel yol, iki repo tek kapanış |

### ⏸️ DEVRETTİ (üç kalem — ve bu, dürüst kapanışın yarısı)

| kalem | nereye | neden |
|---|---|---|
| `K4` P2 — `validate-budget` | **ürün sahibine** | `T-249`'un **kayıtlı** dışlaması çıktı ⇒ **emsal çatışması**: modül-kardeşliği (`5/5`) ↔ işlev-kardeşliği (`{A,CM,P,RO}`). **İkisi de ölçüldü, ikisi de doğru** |
| `budget-variance` | **`SUMMARY` paketine** (`#3`) | `İlke 4` — aile taraması açıkken tek üyeyi ayrı çözmek **yarım muamele** |
| `K5` — LTA dörtlüsü | **`T-293`'e** | Hizalamanın dayanağı **öldü**: *"kardeş emsal"* ölçümde **kimlik değiştirdi** |

### 🆕 AÇTI (on task — hepsi **adresli**)

```
T-290  guard self-test ARALIKLI          T-296'da doğdu, iki bağımsız turda görüldü
T-291  lta-calculation SESSİZ SIFIR      "hesap-okuma" diye kutsanan hesabın kendisi
T-292  değiştir/onayla ekseni            Faz 2 onay-motoru girdisi + EK_C sözlük adayı
T-293  LTA form ↔ motor KOPUK            CANLI: kullanıcı kaydediyor, motor GÖRMÜYOR
T-295  ProtectedRoute fail-open          S2'nin route-guard hâli, repo geneli
T-297  GET /users göçünün ÖNÜ AÇILDI     K1 engeli kaldırdı
T-298  ledger dört çıplak @Query         T-296'nın sınıfının ledger'daki hâli
T-299  MODES_READ YEDİ rol kümesi        aile ≠ hücre normalizasyonu
T-300  BR-04 gerçek ilişki-pini olsun    tam-geri-alma mutasyonu onu yakaladı
T-301  MSW envanteri üretimden kopuk     T-289'un canlı kırıklığı testlerde GÖRÜNMÜYORDU
```

---

## 3 · BÜYÜYEN KAPSAM — dürüst liste

Dalga *"canlı `403`'leri kapat"* diye açıldı. **Kapattığı şey ondan geniş**, ve her
genişleme bir **ölçümden** doğdu:

```
K3 açıldı        "üç canlı 403"
K3 kapandı       üç 403                    ⇓ reviewer kapsam-dışı bir 500 buldu
T-294 açıldı     "K3'ün KORUDUĞU widget sunucuda kırık"
T-294 kapandı    bir 500 + bir 400          ⇓ reviewer AYNI DOSYADA iki kardeş buldu
T-296 açıldı     iki 400 daha
T-296 kapandı    ve ENVANTER SIFIRLANDI     ← zincir DOĞAL OLARAK bitti
```

> **Ürün sahibi durma noktası koydu:** *"meşru bir zincir ama **sınırsız değil**."*
> Ve sınır **tahmin edilmedi, ölçüldü**: `13 @Query = 10 DTO'lu + 2 çıplak + 1 yorum`
> ⇒ `T-296` sınıfın **tamamını** kapattı.

**Kapanış tanımı da bu turda düzeltildi:**
```
⛔ değil:  "finance-reporting'in bilinen-kırık envanteri sıfır"   ← BİTMEYEN taahhüt
✅ öyle :  "K3'ün dokunduğu yüzeyde bilinen-kırık SIFIR + kalanı ADRESLİ"
```

---

## 4 · KALKAN-İSTİSNA YENİDEN-OKUMA TARAMASI — dört yüzey

`DISIPLIN`: *"bir istisna kalktığında, ona yaslanan kararlar **yeniden okunur**."*

**Bu dalgada kalkan istisnalar:** `Z20` (`K1`) · ledger kısıtı (`K2`) · `T-289` ucu
(`K6`) · `approvals` çifti (`K4`).

**Tarama sonucu — dört yüzeyde, işaretlilik kontrolüyle:**

| terim | kod | docs | backlog | işaretsiz bayat |
|---|---|---|---|---|
| `budget/reserve` | 4 | 5 | 3 | **0** |
| `dört istisna` | 2 | 2 | 0 | **0** |
| `ledger/envelope` | 3 | 4 | 1 | **0** |

📌 **Sayı bir envanterdir, bir teşhis değil** — kalan atıflar tek tek okundu: hepsi ya
`F12` **silinme kaydı**, ya **tarihsel ölçüm** (`ÖNCE` durumu), ya **canlı** rota.

⚠️ **Ve bu tarama iki turda EKSİK yapıldı** — ikisinde de **belge** yüzeyi atlandı:
```
K6c/d   ben taradım      4 satır (üçü kodda)  →  reviewer 7 daha buldu, BEŞİ BELGEDE
K4      ajan "dört yüzey" dedi                →  reviewer İKİ yüzeyin taranmadığını ölçtü
```
⛔ **En tehlikelisi:** `B3_KAZA_DALGASI_BRIEF` **askıya alınmış bir hükmü yürürlükteymiş
gibi** taşıyordu. Bir sonraki turun girdisi olarak okunsaydı onu **uygulardı** —
`Z21`-musluğunun birebir tekrarı.

---

## 5 · KALAN-ADRESLİ ENVANTER

```
SUMMARY / MODES_READ paketi   ON kalem, tek architect turu, tek karar dönüşü
  1-2  SUMMARY_READ · MODES_READ hücreleri
  3    budget-variance          (K4 devri)
  4    validate-formula çifti   (Z36 §5)
  5    plans/:id/budget-check   (Z33)
  6-9  T-287'nin dört karar-bekleri
  10   validate-budget          (K4 P2 devri — YENİ)

W5-W8 mekanik akış             customer 17 · modes 25 · master-data 45+19
                               + applicable/check-combination (Z36 §5 kabul)

açık task                      T-286 · T-290 · T-291 · T-292 · T-293
                               T-295 · T-297 · T-298 · T-299 · T-300 · T-301
```

### İki YENİ karar aracı — paket bunlarla geliyor

**1 · Küme-farkı gerekçe taraması** (`git log -L`, `-S` DEĞİL)
> `-S` içeriği arar; **yalnız `@Roles` satırını değiştiren** bir commit'i **görmez**.
> `K4`'te bu fark **bir hükmü devirdi**.

**2 · Enumerasyon ekseni** (`K4` `S1`)
```
LİSTELEME (kuyruğu taramak)  ↔  TEKİL OKUMA (bilinen kaydı açmak)
```
> `GET /approvals` `{A,CM,F,RO}` ama `GET /approvals/:id` **`5/5`** — `PLANNER` her
> kaydı **id ile okuyabiliyor**. Ayırt edici *"onaycı yüzeyi"* **değil**, enumerasyon.
> `MODES_READ`'in yedi kümesinde aynı eksen **muhtemelen tekrar çıkar**.

---

## 6 · Kapılar (kapanış anı)

```
tsc 0 · unit 1144 · e2e 591/591 (42 suite) · T-047 PASS · guards 0
G1 · G2 · G2b (BEŞ tablo) · G3 · G4 · G5 · G6 · G7 — hepsi temiz
FILTRESIZ 0 · single-mechanism 0 · lint-ratchet 0 · money-float 0 · scope-ratchet 0
```
