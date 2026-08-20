# 0074 — `Faz 1` kapsam gözden geçirmesi

> **Ölçen:** Team Lead · **Tarih:** 2026-08-20 · **Mod:** SALT-OKUNUR
> **Neden:** plan `12` kalem diyordu; `T-235`…`T-245` arası **on bir yeni task** doğdu.
> Hepsi gerçek bulgulardan — ama **hepsi `Faz 1` değil.**
> **Karar sonra.** Bu belge ölçüm, öneri değil.

---

## ⛔ 0 · ÖNCE: `Faz 1`'in ÇIKIŞ ÖLÇÜTÜ YAZILI DEĞİL

```
grep -i 'çıkış ölçüt' FAZ1_PLAN.md FAZ1_BRIEF_FABLE.md   →  0 eşleşme
POZİTİF KONTROL: FAZ0_KAPANIS…md:43                       →  "Üç çıkış ölçütü:"
```

**`Faz 0`'ın ölçütü yazılıydı ve ÖLÇÜLEBİLİRDİ:** şema uyumlu · invariant yeşil ·
BRD donduruldu. Üçü de bir komutla sınanabilir.

**`Faz 1`'in ölçütü hiçbir yerde yazılı değil.** Fiilen *"12 kalem bitince"* olarak
işliyor — ve ürün sahibinin tespiti doğru:

> **Kalem sayısı büyüdükçe ölçüt kayıyor.**

📌 Bu, bu oturumun `Z8`–`Z13` dizisinin **plan tarafındaki** hâli: elle tutulan,
denetlenmeyen, ve büyüdükçe sessizce değişen bir ölçü.

⚠️ **Ve `12`'nin kendisi bir alt sınır**, kayıtta yazılı: *"`K-2.4.22c` **iki** ihlal
taşıyor, yani `11` alt sınırdır"* (`FAZ1_BRIEF_FABLE §34`). Yani sayı **başından beri**
kesin değildi.

---

## 1 · `12` kalemin bugünkü hâli

`0071 §6` sınıflandırması (`FAZ1_BRIEF_FABLE:34-52`), ve her kalemin bugünü:

| # | kalem | sınıf | bugün |
|---|---|---|---|
| 1 | `K-2.5.11` | İHLAL | ⛔ açık — ön koşul `S13` ([[T-207]]) |
| 2 | `K-2.5.16b` | İHLAL | ⛔ açık ([[T-205]]) |
| 3 | `K-2.6.6` | İHLAL | ⏳ **kısmen** — `0072`/`0073` ölçtü, `Faz B`'ye bağlı |
| 4 | `K-2.6.9` | İHLAL | ⏳ **kısmen** — mekanizma tekil ve doğru (`T-235`), **bayrak kapalı** |
| 5 | `K-2.6.3` | EKSİK | ⏳ **kısmen** — `Faz A` indi (`CAPABILITIES` + harita), tüketici yok |
| 6 | `K-2.6.12` | EKSİK | ⛔ açık — `ADIM 1` DB rollerini kurdu, **RLS `0/48`** |
| 7 | `K-2.7.2` | EKSİK | ⛔ açık |
| 8 | `K-2.11.5` | EKSİK | ⛔ açık |
| 9 | `K-2.11.7` | EKSİK | ⛔ açık |
| 10-12 | `K-2.8.11` · `K-2.9.5` · `K-2.9.7` | EKSİK · **HUKUK** | ⛔ ayrı kuyruk — muhatap kayıtta yok |

**İnen: `0`. Kısmen: `4`. Açık: `8`** (üçü hukuk kuyruğunda).

---

## 2 · ⚠️ `T-235` BİR kalemdi ve BEŞ task doğurdu — hangisi?

Ürün sahibinin sorusu: **kapsamın baştan eksik ölçülmesi mi, doğal keşif mi?**

```
T-235  kalem 4 (K-2.6.9) — "filtre bir ayarla kapalı"
  ├─ T-237  user_scopes.category_id FK'siz, 115 öksüz      ✅ kapandı
  ├─ T-238  channel_id kullanılmayan kolon                 ✅ kapandı
  ├─ T-240  ledger_entries'in 5 FK'siz kolonu              ⛔ açık
  ├─ T-241  user_scopes'a YAZMA YOLU YOK                   ✅ kapandı
  └─ T-242  kapsam GÜNCELLEME + rol DEĞİŞTİRME yolu yok    ⛔ açık
       └─ T-243  arayüz (T-241'in kırdığı)                 ✅ kapandı
       └─ T-244/245  denetim · tekrarlı çift               ⛔ açık
```

**Ölçüm: ikisi de — ama farklı oranlarda.**

| doğuş sebebi | task | değerlendirme |
|---|---|---|
| `K-2.6.9`'un kaydı **eksikti** | `T-241` · `T-242` | ⛔ **kapsam eksik ölçülmüştü.** Kural *"filtre kapalı"* diyordu; **filtreyi besleyecek verinin nereden geleceği** hiç sorulmamıştı. Yazma yolu yokken bayrağı açmak zaten imkânsızdı — bu, kalemin **ön koşuluydu**, keşfi değil |
| ölçüm **yeni kusur buldu** | `T-237` · `T-238` · `T-240` | ✅ **doğal keşif.** Kapsam verisine bakılınca FK'siz kolonlar ve `115` öksüz çıktı — `K-2.6.9`'un metninde bunlar yoktu ve **olamazdı** |
| düzeltmenin **yan etkisi** | `T-243` · `T-244` · `T-245` | ✅ **doğal** — `T-241` bir sözleşme değiştirdi, kırdığı ve açtığı şeyler ölçüldü |

> 📌 **Sonuç:** `T-235`'in kendisi doğru bir kalemdi; **`T-241`/`T-242` o kalemin
> yazılmamış ön koşuluydu.** Yani kapsam eksikliği **kalemde** değil, kalemin
> `Faz 1` planına **çevrilmesinde**.

⚠️ Ve bu **tekrarlanabilir bir sorudur**: kalan `8` kalemin kaçının yazılmamış bir ön
koşulu var? **Ölçülmedi.**

---

## 3 · Açık task'lar — dört sütun

⚠️ **Dördüncü sütun** ürün sahibinin eklemesi: *"o bloklama gerçek mi?"*
`T-242` örneği: `ADIM 3`'ü bloklıyordu, ama **`ADIM 3`'ün kendisi `Faz 1` kapsamında
mı** — o ölçülmemişti.

| task | `Faz 1` kalemi | kusur mu, eksik mi | blokladığı | bloklama GERÇEK mi |
|---|---|---|---|---|
| **T-242** | kalem 4 (`K-2.6.9`) — **ön koşulu** | **EKSİK** (yol yok) ⚠️ *ama içinde bir KUSUR barındırıyordu: `R2`, kapatıldı* | `T-235 ADIM 3` · **bayrak** | ✅ **GERÇEK** — bayrak kalem 4'ün kendisi; `ADIM 3` ise kalem 5 (`K-2.6.3`) |
| **T-244** | ⚠️ **kalem 8/9'a YAKIN** (`K-2.11.5`/`K-2.11.7`) ama **aynısı değil** | `A1` **KUSUR** (yanlış aktör, canlı) · `A7` **EKSİK** | — | ❌ hiçbir şeyi bloklamıyor |
| **T-245** | ⛔ **hiçbiri** | **KUSUR** (`500` · sessiz çift satır) | — | ❌ |
| **T-240** | ⛔ **hiçbiri** | **EKSİK** (yapısal yol; `ledger_entries` bugün **boş**) | — | ❌ |
| **T-234** | ⛔ **hiçbiri** | **EKSİK** (geri bildirim döngüsü yok) ⚠️ *içinde bir ayrışma gizli* | — | ❌ |
| **T-232** | kalem 6 (`K-2.6.12`) — **kenar** | **EKSİK** (ölü ama yanıltıcı) | — | ❌ *ama `K-2.6.13`'ü geri alabilir* |
| **T-220** | ⛔ hiçbiri | **KUSUR** (`null` bir iş yargısına çöküyor) | — | ❌ |
| **T-222** | ⛔ hiçbiri | **EKSİK** (ölü kod) | — | ❌ |
| **T-223** | ⛔ hiçbiri | **EKSİK** (`🔒` sıfır çağıran) | — | ❌ |
| **T-113** | ⛔ hiçbiri — **`ADIM 0` kapısı** | **KUSUR** (grid e2e'leri koşamıyor) | `ADIM 0`'ın kapı çıkışı | ⚠️ **ölçülmedi** — `review`'da, kapandı mı? |

### Üç sınıfa ayrımı

```
FAZ 1        T-242                          kalem 4'ün ön koşulu, bayrağı blokluyor
             T-232                          kalem 6'nın kenarı, K-2.6.13'ü geri alabilir

ERTELENİR    T-240 · T-245 · T-222 · T-223  hiçbir kaleme bağlı değil, hiçbir şeyi
                                            bloklamıyor, bugün canlı kusur DEĞİL
                                            (T-245 hariç — kusur ama bloklamıyor)

BELİRSİZ     T-244  denetim ailesi — kalem 8/9'a YAKIN ama aynısı değil
             T-234  drift; "Faz 1 işi mi, sürekli bakım mı?"
             T-220  canlı bir KUSUR, ama hiçbir kaleme bağlı değil
             T-113  ADIM 0 kapısıydı; bugünkü durumu ölçülmedi
```

---

## 4 · ⚠️ Ölçümün SINIRLARI

- **`ADIM 3`'ün `Faz 1` kapsamında olduğu VARSAYILDI, ölçülmedi.** `FAZ1_PLAN §5`
  onu `Faz 1`'in adımı sayıyor ve kalem 5 (`K-2.6.3`) + kalem 3 (`K-2.6.6`) ile
  eşliyor — ama o eşleme **plan yazarının** kararıydı, `0071 §6`'nın değil.
- **`12` kalemin `Faz 1` kapsamına girip girmediği HÂLÂ ONAYLANMADI.**
  `FAZ1_PLAN §2`: *"`0071 §6` sınıflandırma onayı (12 kalem) — ⛔ açık, bu plan
  **öneri statüsünde**"*. Yani bu tablo **onaylanmamış bir tabana** göre ölçüldü.
- **Kalan `8` kalemin yazılmamış ön koşulları taranmadı** (`§2`'nin sorusu).
- `T-113`'ün bugünkü durumu okunmadı (`review`'da).

---

## 5 · Ürün sahibine giden üç soru

1. **`Faz 1`'in çıkış ölçütü nedir?** Bugün **yazılı değil**, ve fiilen *"kalem
   bitince"* — ölçüt kalem sayısıyla **kayıyor**. `Faz 0`'ınki üç ölçülebilir şarttı.
2. **`BELİRSİZ` dörtlüsü nereye ait?** (`T-244` · `T-234` · `T-220` · `T-113`)
   Ölçüm bir kaleme **bağlayamadı** — ve `CLAUDE.md`'ye göre bu bir **karar
   konusudur**, bir varsayım değil.
3. **`ADIM 3` `Faz 1` kapsamında mı?** Bu ölçümde **varsayıldı**. Değilse `T-242`'nin
   bloklaması yarıya iner (yalnız bayrak kalır).


---

# ✅ 6 · KARARLAR (ürün sahibi, 2026-08-20) — ölçümden SONRA

## 6.1 · Çıkış ölçütü — **`Faz 1` = izolasyonun ön koşulları hazır**

```
1  ayrıcalıksız DB rolleri, sessiz geri dönüş yok       ✅ KAPANDI
2  kapsam filtresi AÇIK ve besleyen yolları var         ⏳ bayrak + T-242a
3  yetenek modeli + default-deny                        ⏳ ADIM 3 (Faz 1 yarısı)
4  denetim kaydı: kim, ne zaman, neye dayanarak         ⏳ T-244
5  RLS uygulanmış                                       ⏳ ADIM 5
```

**Ve ölçütün kendisi:** `K-2.6.12`'nin iki katmanlı izolasyon şartı — tek kanıtla
sınanabilir. → `FAZ1_PLAN §0b`.

> **Beş madde sabittir; kalem sayısı büyüse de ölçüt kaymaz.** `12` kalem **onaylandı**
> ama artık **ölçüt değil, girdi**.

## 6.2 · `BELİRSİZ` dörtlüsü çözüldü

| task | karar | gerekçe |
|---|---|---|
| `T-244` | ⚡ **FAZ 1** | çıkış ölçütünün **4. maddesi**, ve `A1` **bugün canlı bir kusur** |
| `T-234` | ⏸️ **ERTELENİR** | sürekli bakım, izolasyonla ilgisiz. ⚠️ `T-113` ile aynı aile: **baseline bakım borcu** |
| `T-220` | ⏸️ **ERTELENİR** | canlı kusur, ama **izolasyon** kusuru değil — `§2.5` ailesi, `Faz 3` konusu |
| `T-113` | ✅ **ÖLÇÜLDÜ** | aşağıda |

### `T-220`'nin şerhi — *"sessizce ertelenmesin"* — ÖLÇÜLDÜ

Ürün sahibi: *"canlı bir kusur ertelenebilir, ama sessizce değil — `EK_E`'de `⚠️`
olarak duruyor mu?"*

```
EK_E:124  | Renk (RAG) | ⚠️ | Kapsama oranı istemciye ulaşmıyor |
EK_E:125  | GRİ durumu (kapsama rozeti + eksik listesi) | ❌ |
EK_E:224  Kapsama oranı ulaşmıyor → GRİ durumu eksik
```

✅ **Görünür** — ama ⚠️ **birebir aynı değil**: `EK_E` satırları *kullanıcıya görünen
semptomu* (kapsama oranı ulaşmıyor) anlatıyor; `T-220`'nin kapsamı daha geniş
(*"hesaplanamayan bir değer nerede bir iş yargısına çöküyor"* — beş nokta, backend +
frontend). **Semptom kayıtlı, sınıf değil.**

### `T-113` — ölçüldü: **özgün kusur ÇÖZÜLMÜŞ**

```
başlık        "POST /plans/:id/fus 500 dönüyor — grid e2e'leri hiç koşamıyor"
bugün         o uç e2e logunda 6 kez geçiyor, ve kullanan üç suite PASS:
              optimistic-locking · kpi-optimistic-locking · recalc-perf-regression
```

📌 Sebebi zaten kayıtlı: **ölçüm ortamının bayatlığıydı**, kod kusuru değil
(`CLAUDE.md`: *"`start:dev` süreci ayaktayken kaynak düzenlenirse rotalar bozulabilir"*).

⚠️ **Ama task `review`'da ve KONUSU KAYMIŞ:** `BACKLOG` satırı artık `lint-ratchet`
kapısını anlatıyor, başlık hâlâ `500`'ü. Üstüne `A8`'in **baseline bakım borcu**
eklendi. Yani tek bir task **üç ayrı konu** taşıyor — ve bu bir *"kapsam kayması"*
vakası, bir kusur değil.

## 6.3 · `ADIM 3` — **`Faz 1`'de**, ama BÖLÜNMÜŞ

```
yetenek modeli + default-deny        FAZ 1       ← çıkış ölçütü md.3
UNRESTRICTED kod dalı temizliği      ERTELENİR
```

**`Faz 1` yarısının gerekçesi:** `K-2.6.6` — `72` uç bugün **rol kısıtsız**, ve bu bir
**izolasyon kusuru**. ⚠️ **`RLS` onu KAPATMAZ:** `RLS` **satır** seviyesi, bu **rota**
seviyesi.

**Ertelenen yarısı:** `İlke 4` kalemi, ve `K-2.6.8a` **veri tarafında zaten
karşılandı** (`T-235 ADIM 1`).

> 📌 **`§4`'ün birinci sınırı KAPANDI:** `ADIM 3` eşlemesi *"plan yazarının kararıydı"*
> denilmişti — şimdi **çıkış ölçütünün 3. maddesiyle doğrulandı**, varsayım değil.

**Ve sonucu:** `T-242b` (rol değiştirme) `ADIM 3`'ün **ertelenen** yarısına bağlıydı
→ **artık hiçbir şeyi bloklamıyor.** `T-242` bu yüzden **bölündü**:

```
T-242a  kapsam GÜNCELLEME    FAZ 1       bayrağı blokluyor
T-242b  rol DEĞİŞTİRME       ERTELENİR   hiçbir şeyi bloklamıyor
```

## 6.4 · `§4`'ün ikinci sınırı da kapandı

*"`12` kalem hâlâ onaylanmadı — bu tablo onaylanmamış bir tabana göre ölçüldü."*

✅ **Onaylandı** (2026-08-20). Ve daha güçlüsü: **çıkış ölçütü artık o listeden
bağımsız**, yani tablonun tabanı bir daha kaymayacak.
