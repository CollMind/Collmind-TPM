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
