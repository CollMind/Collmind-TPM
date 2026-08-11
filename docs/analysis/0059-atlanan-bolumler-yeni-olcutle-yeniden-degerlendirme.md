# 0059 — Atlanan BRD bölümleri: **yeni ölçütle** yeniden değerlendirme

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR — ürün kodu, migration, entity değişikliği **yok**. Çıktı bu dokümandır.
- **Ölçüt değişikliği:** `0047 §2`'nin ⚪ kovası **"açık bir task'la kesişiyor mu"** sorusuyla
  kuruldu (denetim hedefi). Bu tur tek soru sorar:

> **Bu bölüm ürünün bir YETENEĞİNİ, KURALINI veya VERİ MODELİNİ tarif ediyor mu?**
> evet → yeni BRD'ye girer · hayır → gerekçe: süreç anlatımı · örnek çıktı · başka bölümün
> tekrarı · gelecek faz

---

## 0. Ölçüm ortamı (ZORUNLU — koşulu ölçümle birlikte yaz)

| | değer |
|---|---|
| meta repo | `CollMind/Collmind-TPM`, branch `claude/0058-measurement-config-y6xz2z`, HEAD `32d132d` |
| submodule'ler | **checkout EDİLMEMİŞ** (`collmind.backend`/`collmind.frontend` boş) — bu tur yalnız `docs/` üzerinde ölçüm yaptı, kod tarafı iddiası **yok** |
| kaynak | `docs/brd/` — 23 dosya, **19.859 satır** (`find … -exec wc -l`) |
| araç | `grep -rn(i/w/c)`, `sed -n`, ve `04_Reviews` için satır-blok karşılaştırıcı (Python `difflib`, blok sınırı = `## X.Y` başlığı, **sabit pencere değil**) |

⚠️ **Sabit pencere kullanılmadı** — `CLAUDE.md`'nin "pencereyi ölçtüğün şeyin doğal sınırına
bağla" kuralı gereği karşılaştırma başlık bloğu sınırında yapıldı; sabit satır penceresi bu
turda sahte fark üretebilirdi.

---

## 1. ⛔ Önce: envanterin KENDİSİ eksikti

`0047 §2`'nin envanteri **yalnız dört klasörü** kovaladı: `01_Main_BRD`, `02_Addendum`,
`03_Candidate_Log`, `04_Reviews`. Paket kökündeki **yedi dosya** (1.870 satır) hiçbir kovaya
konmadı — ne 🔴, ne 🟡, ne ⚪:

```
Sprint_0_Mandatory_Items.md   401   ← YETENEK + KURAL (bkz. §2.1)
Engineering_Pack_Index.md     370
BRD_QUICK_ACCESS_GUIDE.md     316
00_BRD_PACKAGE_INDEX.md       487   (yalnız 186–260 okundu, 0043)
00_START_HERE.md              165
README.md                      91
sprint_0_rules.md              40
```

> **Bir bölüm ⚪ işaretlenmediyse "atlandı" bile denemez — hiç görülmemiştir.** `0047`'nin
> bitiş ölçütü *"her bölüm okundu ya da gerekçeyle atlandı"* idi ve bu yedi dosya için
> **ikisi de olmadı**.

Ve içlerinden biri bu turun **en pahalı bulgusu** oldu.

---

## 2. Kova 1 — **GİRER** (yeni BRD'ye alınmalı, okunmalı)

| # | Bölüm | Satır | Ne tarif ediyor | Tur |
|---|---|---|---|---|
| 1 | **`Sprint_0_Mandatory_Items.md`** (tamamı) | 401 | Import hata semantiği · concurrency kabul ölçütü · **bildirim spesifikasyonu** · **admin kısıtları + Super Admin** | 1 |
| 2 | **`Section_08`** Reporting (tamamı) | 733 | 8 rapor tanımı, metrik formülleri, **uyarı yönlendirme kuralları**, export limitleri, drill-down yolları | 2 |
| 3 | **`Section_02`** §2.1–§2.5 | 663 (8–670) | Platform mimarisi · **mod seçim çerçevesi (karar ağacı)** · mod karşılaştırması · organizasyon desenleri · genişletilebilirlik | 2 |
| 4 | **`Section_09`** §9.1–§9.4, §9.6, §9.7 | ~333 | Yanıt süresi hedefleri · hacim projeksiyonu · **çok kiracılı kapasite + RLS** · uptime/DR · izleme-alarm · **i18n/sayı biçimi**, erişilebilirlik | 1 |
| 5 | **`Section_06`** §6.1, §6.2, §6.6 | ~230 | **Veri domainleri (varlık listesi, GU dahil)** · entegrasyon desenleri · yenileme frekansı + SLA | 1 |
| 6 | **`Section_05`** §5.2 Planning Grid | 258 (233–490) | Grid hiyerarşisi, **dinamik kolon yapısı**, girdi desenleri + dağıtım formülleri, guardrail listesi, **RAG toplama kuralı** | 1 |
| 7 | **`Section_05`** §5.5 başı | 116 (1529–1644) | Submit doğrulama listesi · **onay politikası şeması (JSON)** · `auto_reject_conditions` | ↑ ile aynı tur |
| 8 | **`Section_03`** §3.5 (+§3.7/§3.8) | ~130 | **Tactic/Mechanic veri modeli** (`PERCENT`/`AMOUNT`/`AMOUNT_PER_UNIT`), mod-özel JSONB politika alanları, giriş anında engelleme kuralı | 0.5 |
| 9 | **`Section_01`** §1.6 Success Metrics | ~50 (321–370) | Ölçülebilir hedefler — **NFR-1.2'nin "Measurement Method" tanımı burada** | 0.5 |
| 10 | **`Section_07`** §7.6 Session Management | 13 (533–545) | Oturum zaman aşımı + geçersiz kılma kuralları | ↑ ile aynı tur |

**Toplam: ~2.927 satır · tahmini 8–10 tur.**

### 2.1 ⛔ DUR — bir yeteneği TEK BAŞINA tarif eden bölüm bulundu

`Sprint_0_Mandatory_Items.md`'in dört maddesinden **üçü** paketin başka hiçbir yerinde yok.
Ölçüm (`grep -rni`, tüm `docs/brd/`):

| madde | ölçülen terim | paketin geri kalanında |
|---|---|---|
| **EA-001** — Super Admin rolü | `super.?admin` | **0** — yalnız bu dosyada (2 geçiş). §7.1 **beş rol** sayıyor, altıncısı burada |
| **AI-001** — import commit semantiği | `partial success`, `all-or-nothing`, `error report` | **0** (`01_Main_BRD` + `02_Addendum`) |
| **MC-002** — bildirim spesifikasyonu | `notification` | 18 geçiş var, **hiçbiri spesifikasyon değil** — 18'in tamamı okundu: "SMTP", "notification sent", "@mention notifications" gibi **anma**lar. 6 olay tablosu · e-posta şablonları · escalation (5. gün hatırlatma, 7. gün auto-expire) yalnız burada |
| **EA-001** — görev ayrılığı matrisi | `separation of duties` | §7.1'de **2 satır** ("planner ≠ approver"). "Admin agreement yaratamaz", "onaylanmış agreement silinemez", "ledger append-only" yalnız burada |

⚠️ **AI-001'in maliyeti ölçülebilir:** *"Validation runs on all rows BEFORE any insert →
invalid rows rejected → valid rows committed → hata raporu CSV"*. Bu, `CLAUDE.md §7.1`'de
kayıtlı **T-123 tartışmasının tam konusudur** (*"tek bozuk hücre tüm dosyayı düşürüyor"* →
throw geri alındı → sessiz fallback). O tartışma sırasında **bağlayıcı bir kaynak vardı ve
envanterde değildi.**

`Section_04`'ün batch import bloğu (600–700) doğrulama **kontrollerini** ve bir sonuç
ekranını gösteriyor; **commit semantiğini göstermiyor** — "kaç satır yazılır" sorusunun
cevabı orada yok. Yani bu bir tekrar değil, **tek kaynak**.

### 2.2 ⛔ DUR — `§7.6` de tek kaynak

`grep -rniE "session|timeout|idle"` (tüm `01_Main_BRD` + `02_Addendum` + `03_Candidate_Log`):
30 dakikalık idle timeout §9.4 ve §9.8'de **tekrarlanıyor**. Ama

- **8 saatlik mutlak zaman aşımı**
- **eşzamanlı oturuma izin** (çoklu cihaz)
- **parola değişiminde / rol değişiminde tüm oturumların geçersiz kılınması**

yalnız `§7.6`'da. 13 satır, ve üçü de güvenlik kuralı. **Yeni BRD'den sessizce düşerse kimse
fark etmez** — ölçütün tarif ettiği durumun tam örneği.

### 2.3 Girer kovasındaki üç "yan kazanç"

Bunlar bu turun konusu değildi ama okunurken ölçüldü, kayda geçiyor:

1. **`Section_08` §8.1 Report 2, RAG sınırları:** *"🟢 Green <80%, 🟡 Amber 80-95%, 🔴 Red
   >95%"* + alarm yönlendirmesi (*95% → **block new submissions***, *100% → CFO*).
   `CLAUDE.md §2.3`'ün **çözülmemiş** ilan ettiği sınır semantiği (`>95` mi `>=95` mi) için
   bir kaynak cümlesi. **Karar değil, girdi** (§2.1.2) — ama bugüne kadar okunmamıştı.
2. **`Section_06` §6.1 Domain 3:** *"RAG Thresholds — Managed By: **Finance Admin** —
   Manual (annually)"*. Yani eşiklerin konfigüre edilebilir olması bir tasarım tercihi değil,
   **kaynakta yazılı**; `T-108`'in gerekçesini güçlendirir.
3. **`Section_01` §1.6:** *"KPI Calculation Speed | <500ms | **Time from input change → UI
   update**"*. `ADR 0003`'ün dayandığı "Measurement Method" sütununun **yeri burası** —
   `Section_09` §9.1'in aynı satırı bu sütunu **taşımıyor** (onun sütunları P95/Max).
   ⚪ işaretli bir bölüm, yürürlükteki bir ADR'nin kaynağını tutuyordu.

---

## 3. Kova 2 — **GİRMEZ** (gerekçe + içerik nerede)

> §2.1.1 gereği her satırda **hangi belgeye, hangi terimle** bakıldığı yazılıdır.

| Bölüm | Satır | Gerekçe | Bu içerik başka nerede var |
|---|---|---|---|
| **`04_Reviews/BRD_Consolidated…`** | 5.249 | **başka bölümün tekrarı** | Section 1/3/5/6/10/11'in kendisi — **bugün blok-blok ölçüldü**, bkz. §4 |
| **`04_Reviews/Opus_Review_Prompt.md`** | 122 | **süreç anlatımı** | Review talimatı; ürün içeriği sıfır. Tarandı: `H1`–`H5`, `sandbox`, `topological`, `race condition` → 0047'de **hepsi 0** |
| **`Section_01`** §1.1/1.2/1.4/1.5/1.7 + Next Steps | ~370 | **başka bölümün tekrarı** (vizyon/değer) | §1.3'ün mod tanımları → `Section_02` §2.1/§2.3 + `Section_04`/`Section_05`; §1.4 farklılaştırıcı tablosu → `§2.3` karşılaştırma tablosu; §1.7 risk tablosu → `Section_11` §11.3/§11.5. §1.5 tümüyle niteliksel değer anlatısı (*"Typical Improvement Range"* — ölçüm değil, pazarlama aralığı) |
| **`Section_05`** §5.6 Use Case Scenarios | ~140 | **örnek çıktı** | İçindeki tek kural — *Base=0 → iVol=Planned, Uplift%=NULL, ROI hesaplanır* — `§5.3 Edge Case Handling` (1355–1377) içinde **birebir** duruyor (`IF(BASE_VOL = 0, NULL, …)`); okundu, karşılaştırıldı |
| **`Section_10`** Phase 1.1 / Phase 3 / Phase 4+ | ~190 | **gelecek faz** | Faz sınırı kararları `§10.1 Phase 1`/`Phase 2` (okundu, 0045/0046) + her bölümün kendi *"Phase 1 Scope"* alt başlığı |
| **`Section_10`** §10.5 Resource Planning | ~35 | **süreç anlatımı** | FTE/rol planı — ürün yeteneği değil. Hiçbir yerde tekrarı yok, **gerekmiyor** |
| **`Section_10`** §10.6 Success Metrics | ~30 | **başka bölümün tekrarı** | `Section_01` §1.6 (aynı hedef ailesi) + `§10.2` Gate kriterleri |
| **`Section_11`** §11.4 Change Management | ~32 | **süreç anlatımı** | R11/R12 organizasyonel risk; ürün kuralı içermiyor |
| **`Section_11`** §11.5 Risk Summary Matrix | ~19 | **başka bölümün tekrarı** | R1–R12'nin **tamamı** `§11.1`–`§11.3`'te tanımlı (okundu, 0035/0054); matris yalnız özet |
| **`Section_11`** §11.6 Critical Success Factors | ~22 | **süreç anlatımı** | "başarılı olur / başarısız olur" listesi; ölçütleri §1.6 ve §10.2'de |
| **`03_Candidate_Log`** CANDIDATE-007 | ~72 | **gelecek faz** | Kendi metni *"Reason for Deferral … not contractually binding"* diyor. SLA tabloları `Section_09 §9.1` + Addendum `H1` ile örtüşüyor |
| **`03_Candidate_Log`** ARCHIVED + Governance + Review Schedule | ~110 | **süreç anlatımı** | Aday yönetimi ritmi; ürün içeriği yok |
| **`00_START_HERE` · `00_BRD_PACKAGE_INDEX` · `README` · `BRD_QUICK_ACCESS_GUIDE` · `Engineering_Pack_Index`** | 1.429 | **süreç anlatımı** (navigasyon) | Dosya yolları, rol bazlı okuma rehberi, paket künyesi. ⚠️ `BRD_QUICK_ACCESS_GUIDE` yolları **`/mnt/user-data/outputs/…`** gösteriyor — üretildiği oturumun dizini, bu repoda geçersiz |
| **`sprint_0_rules.md`** | 40 | **süreç anlatımı** (tarihsel) | Sprint 0 kilidi: *"No baseline, no planned volume, **No SKU-level data**"* — bugünkü ürünle **çelişir** (Planning-First SKU seviyesindedir). Tarihsel bir kısıt beyanı; normatif değil |

---

## 4. `04_Reviews` kopya iddiası — **bugün doğrulandı**

Görev, iddia doğrulanamazsa DUR diyordu. Doğrulandı; yöntem ve sonuç:

**Yöntem:** her `## X.Y` başlığı bir blok sınırı; blok gövdeleri boş satırlar atılıp
`difflib.SequenceMatcher` ile karşılaştırıldı. Sabit pencere **kullanılmadı**.

**Sonuç: 41 bloğun 36'sı birebir aynı (`IDENTICAL`).** Farklı çıkan beşi:

| blok | ratio | fark ne |
|---|---|---|
| `3.8` | 0.850 | yalnız **birleştirme ayracı** + bir sonraki bölümün `Introduction`'ı |
| `5.7` | 0.979 | aynı |
| `6.7` | 0.906 | aynı |
| `10.6` | 0.885 | aynı |
| `11.x` | — | fark yok |

Yani beş farkın **hiçbiri içerik farkı değil**: dosyaları arka arkaya ekleyen script'in
bıraktığı `-e` + `═══` ayraç satırları, ve benim blok bölücümün bir sonraki bölümün
`Introduction`'ını önceki bloğa iliştirmesi. O `Introduction` metinleri de Main BRD'de
**aynen** duruyor.

**Tek özgün içerik**, dosyanın 1–42. satırındaki künye: *"155 pages, 43,869 words, 12
sections · Document Version 1.0 Final · January 7, 2026"*. Bir **yetenek/kural/veri modeli
değil** — paket metadata'sı.

> **`04_Reviews` ⚪ kalır.** Yeni ölçüt altında da girmez: yeni BRD'ye giren şey kopyanın
> kaynağıdır, kopyanın kendisi değil. Ve `0047`'nin *"ikinci nüsha olarak doğrulama
> değeri"* notu geçerliliğini korur (T-163'te dördüncü tanık olmuştu).

---

## 5. Ölçüm yükü ve DUR bildirimleri

| DUR koşulu | durum |
|---|---|
| ⚪ bölümlerden biri bir yeteneği **tek başına** tarif ediyor | ⛔ **EVET, iki tane** — `Sprint_0_Mandatory_Items` (§2.1) ve `Section_07 §7.6` (§2.2) |
| toplam okuma yükü **10 turu** aşıyor | ⚠️ **sınırda** — tahmin **8–10 tur** (~2.927 satır). Aşmıyor, ama `0047`'nin bu bölümler için verdiği tahmin **0 tur**du |
| `04_Reviews` kopya iddiası bugün doğrulanamıyor | ✅ **doğrulandı** (§4) — DUR yok |

### Ölçüt değişikliğinin bilançosu

| | `0047` (task kesişimi) | bu tur (yeni BRD) |
|---|---|---|
| ⚪ toplam | ~8.150 satır | — |
| bunun `04_Reviews`'ı | 5.371 | **hâlâ girmez** (kopya, ölçüldü) |
| ⚪'dan **girer**'e taşınan | — | ~1.170 satır (`Section_08` 733 · `§5.2` 258 · `§5.5` 116 · `§7.6` 13 · `§1.6` 50) |
| **hiç kovalanmamış**tan girer'e | — | ~1.757 satır (`Sprint_0` 401 · `Section_02` 663 · `Section_09` 333 · `Section_06` 230 · `Section_03 §3.5` 130) |

> **Ölçüt değişikliği kovanın %14'ünü çevirdi; envanterin eksikliği ise onun kadar daha
> iş çıkardı.** İkincisi ölçüt değişikliğinden bağımsızdı — `0047` günü de eksikti.

---

## 6. Sıralama önerisi (okuma turları)

1. **`Sprint_0_Mandatory_Items`** — tek kaynak olan üç kural burada; en yüksek kayıp riski
2. **`Section_08`** (2 tur) — beş raporun ürün karşılığı `/finance` ve Sidebar'da bugün
   kırık/devre dışı (`0058` §6 D1, §3) — yeni BRD'nin bu bölümü yeniden yazması gerekecek
3. **`Section_02` §2.1–2.5** (2 tur) — mod seçim çerçevesi, `§2.6` ile birleşince mod
   çözümünün tamamı
4. **`Section_05` §5.2 + §5.5 + `Section_03` §3.5 + `§7.6` + `§1.6`** (1–1.5 tur) — grid,
   onay politikası, tactic modeli
5. **`Section_06` §6.1/6.2/6.6** (1 tur)
6. **`Section_09` §9.1–9.4/9.6/9.7** (1 tur)

---

## 7. Bu turun sınırları (ZORUNLU — ne ölçülmedi)

- **Kod tarafı hiç ölçülmedi.** Submodule'ler bu container'da checkout edilmemiş; "bu kural
  üründe var mı" sorusu bu dokümanda **hiçbir yerde** cevaplanmıyor.
- **Girer kovasındaki bölümler okundu değil, ÖRNEKLENDİ.** Her biri için yeterli gövde
  okundu ki ölçüt sorusu cevaplanabilsin; bulgular (§2.3) o örneklemeden çıktı. Tam okuma
  hâlâ 8–10 turluk iştir.
- **`Section_04` ve `Section_12` bu turun konusu değildi** (ikisi de 0020/0021/0019'da
  okunmuştu); yeni BRD'ye gireceklerine dair bir soru zaten yoktu.
- **`Section_03`'ün turu 4 (0022) kapsamı belirsiz** — o doküman satır aralığı yazmamış.
  §3.5/§3.7/§3.8'i girer kovasına koydum; §3.5 okunmuş olabilir, **bilinmiyor**.
