# `DISIPLIN.md` — CollMind çalışma disiplini kuralları

> # ⛔ BU DOSYANIN TEK CÜMLELİK SAVUNMASI
>
> ## **Mekanizma çalıştı, refleksim çalışmadı — bu yüzden kapılar var.**
>
> *(Ürün sahibi, 2026-08-26: "bu iki haftanın tek cümlelik savunması".)*
>
> Bu satır bir özdeyiş değil, bir **ölçüm özetidir**. Tek bir turda üç kez aynı
> sınıfa düşüldü ve **üçü de yakalandı** — hiçbiri dikkatle değil, **bir kapıyla**:
>
> | ne | kim yakaladı |
> |---|---|
> | bir tarama yanlış sütun değeri aradı ve **sıfır satır işledi** (*"ihlal = 0"*) | taramanın **kendi pozitif kontrolü** |
> | bir düzeltme, düzelttiği sınıfın **yeni bir vakasını** üretti | `code-reviewer` |
> | bir kapının girdisi **aranandan dar** bir evrendi | **kapının kendi kırmızısı** |
>
> ⇒ Buradaki hiçbir kural *"daha dikkatli ol"* demez. Hepsi bir **ölçüme**, bir
> **kapıya** ya da bir **karşı-vakaya** bağlanır — çünkü dikkat ölçeklenmez,
> kapı ölçeklenir.


> ## ⛔ BAĞLAYICI — `CLAUDE.md` ile AYNI DERECEDE
>
> Bu dosya `CLAUDE.md`'den **salt taşımayla** doğdu (2026-08-25). Taşınan
> `(ZORUNLU)` kurallar **bağlayıcılıklarını KORUR** — `CLAUDE.md §2.1`'in kaynak
> tablosunda `3.5` sırasında kayıtlıdır. Hiçbir kural metni değiştirilmedi;
> başlıklar **birebir**. Bayat bulunanlar düzeltilmedi — ayrı tura bırakıldı.
>
> **Giriş noktası:** `CLAUDE.md`'nin ilgili bölümlerindeki
> *"↓ Disiplin gövdesine taşındı"* indeks blokları.

> ## ⛔ ATIF BİÇİMİ
>
> **Kanonik atıf yüzeyi BACKTICKLİ BAŞLIK METNİDİR**, çapa değil:
> `DISIPLIN.md` → *"Bir KAPI, ölçümün BAŞARISINI hata sayamaz"*.
>
> ⚠️ `#çapa` bir **kolaylıktır, sözleşme değil** — çapa şemaları araca göre
> değişir (GitHub ≠ Bitbucket ≠ bu repoda üretilen), ve ölçüldü (2026-08-25):
> `63` çapanın `20`'si `github-slugger` ile ayrışıyor. Başlık metni **her üçünde
> de** bulunur.
>
> **ÇIPLAK `§N` BU DOSYAYI ADRESLEMEZ.** Çıplak `§N` bu repoda bugün belirsiz —
> hem `CLAUDE.md`'yi hem **BRD** bölümlerini gösteriyor. `CLAUDE.md`'nin numaralı
> iskeleti (`§0`–`§7`, `§2.1`–`§2.7`, `§4.1`, `§4.2`) **çekirdekte kaldı**, çünkü
> numara bir **atıf arayüzüdür**.

---

## AİLE — ARAMA UZAYI ve NEGATİF KANIT

### Ve yokluk iddiası için üçüncü soru: HANGİ BÖLÜM (ZORUNLU)

*"Hangi belge"* ([[T-142]]) ve *"hangi PDF"* (yukarısı) yetmedi. Üçüncüsü **bölüm
seviyesinde** ve bu oturumda **üç kez** aynı hataya yol açtı:

| iddia | nereden üretildi | neyle çürüdü |
|---|---|---|
| *"`TRANSFER` BRD'de yok"* | `Section_04` | **§4.10** |
| *"`ADJUST` BRD'de yok"* | `Section_04` | **§3.3** (çekirdek) |
| *"`accrual`/`settlement`/`reconciliation` hiç düşünülmemiş"* | `Section_04`'ün kapsam listeleri | **§3.6** (`spend_type` değeri!) |

Sebep yapısal: **mod bölümleri (`Section_04`/`Section_05`) türetilmiştir ve yalnız o modun
kullandığı şeyi anlatır.** Çekirdek tanımlar `Section_03`'tedir. Bir modun *"kapsam dışı"*
listesi, çekirdekte tanımlı bir kavramı **saymaz** — o kavram zaten o modun konusu değildir.

> **Bir kavramın yokluğunu iddia etmeden önce, o kavramın HANGİ BÖLÜMDE tanımlanacağını sor.**
> Şema/enum/tablo → `Section_03`. Mod davranışı → `04`/`05`. Kavram tanımı → `12`.
> Faz kapsamı → `10`/`11`. Aramayı **tüm pakete** yay (`grep -rin` `docs/brd/`), tek bölüme
> değil.

### Negatif sonuçlu tarama, POZİTİF KONTROLSÜZ rapor edilemez (ZORUNLU)

**`0 bulgu` çıktısı hiçbir zaman kendini yanlış olarak göstermez.** Onu yakalayan tek şey,
desenin gerçekten eşleştiğini kanıtlayan ayrı bir ölçümdür.

Ölçülmüş çift vaka (2026-08-11, `decimal` taraması) — **aynı turda iki kez**:

| # | desen | pozitif kontrol | gerçek |
|---|---|---|---|
| 1 | `@Column({…})` tek satır varsayıldı | **0 eşleşme** | dekoratör çok satırlı |
| 2 | `type: 'numeric'` arandı | **0 eşleşme** | entity'ler `'decimal'` yazıyor |
| 3 | `type: 'decimal'` | **89 eşleşme** ✅ | **71 kusur** |

İlk iki tur *"0 bulgu, temiz"* diye raporlanacaktı. **Kural olsaydı raporlanamazlardı** — ve
üçüncü tur zaten gerçekleşti.

> **Bir taramanın sonucu negatifse (`0`, *"yok"*, *"hiçbiri"*), yanında pozitif kontrolü
> olmadan yazılamaz.**

**İki şart:**

1. **Beklenen sayı ÖNCEDEN yazılır.** Kontrolü koşup çıkan sayıya bakmak, sonucu gördükten
   sonra *"evet bu makul"* demeye açıktır. `decimal` taramasında beklenen *"en az bir avuç"*
   idi ve **89** çıktı — makul. Beklenen yazılmasaydı **3** çıksa da makul görünürdü.
2. **Kapsam yalnız negatif sonuçlar.** Pozitif bulgu **kendi kendini doğrular** — 71 vaka
   bulduysan desen çalışıyor demektir.

⚠️ Kuralı tüm taramalara genişletme: her aramaya ek iş binerse **uygulanmaz** hâle gelir.
Ve **uygulanmayan bir kural, olmayan kuraldan kötüdür** — çünkü uyulduğu sanılır.

**Ve bir kör noktanın maliyeti zamanla artar.**

Bir guard'ın kör noktası, koruduğu kusuru **saklar.** Guard yeşil verdiği sürece kimse
elle bakmaz — ve kör nokta ne kadar uzun yaşarsa, arkasında o kadar çok kusur birikir.

> Ölçüldü (2026-08-13): `guard.sh`'ın iki kontrolü bir ortamda sessizce çalışmıyordu. İki
> tur sonra düzeltildiğinde ilk koşuşta **dört hayalet dosya** çıktı — eski bir paketin
> kalıntıları, arşiv açılırken silinmemiş ve o iki tur boyunca **guard tarafından
> saklanmış.**
>
> Pratik sonuç: bir guard düzeltildiğinde, kör kaldığı süre boyunca **birikmiş kusur
> aranmalıdır** — ilk yeşil, o birikimin temizlendiğinin kanıtı değildir.

⚠️ **Ve arama guard'ın KAPSAMIYLA sınırlı kalmamalı** — kör nokta çoğu zaman kapsamın
kendisindedir. Aynı turda ölçüldü: `guard.sh`'ın tekillik kontrolü yalnız `03_IS_KURALLARI`
altına bakıyordu, yani o dört hayalet dosya **düzeltilmiş guard'a da görünmezdi** (`333`
tanım taşıyorlar ve hepsi kapsamın dışında). Kusuru bulan şey guard değil, guard'ın
kapsamına yöneltilen **ayrı bir soru** oldu.

> Bir guard düzeltildiğinde iki soru sorulur: *"kör kaldığı sürede ne birikti"* **ve**
> *"bu guard onu şimdi görebilir mi?"* İkincisinin cevabı çoğu zaman **hayır**'dır.

### Kapsam maskelemesi — desen çalışır, EVREN eksiktir (ZORUNLU)

`§2.7`'nin doğrulama-maskeleme ailesi *"ölçüm yanlış"* vakalarını topluyor. Bu **farklı bir
sınıf**: ölçüm doğru, desen çalışıyor, ve sonuç yine yanlış — çünkü **sayılan küme eksik**.

Bugün **iki kez** oldu, ve ikisi de sayınca değişti:

| iddia | neyden çıkarıldı | gerçek |
|---|---|---|
| *"İki aile, kesişmiyorlar"* | **iki** tablo | üçüncü tablo (`budget_transactions`) zarf atfını **taşıyor** |
| *"Backfill imkânsız"* | **bir** yol | **dört** yol vardı; ikincisi kapalıydı ve sebebi kusurdan büyüktü |

> **Pozitif kontrol bunları yakalamaz** — desen çalışıyordu, evren eksikti.

**Kural: bir küme hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI aynı cümlede
yazılır.**

- ❌ *"İki aile kesişmiyor"*
- ✅ *"İki tablo ölçüldü, üçüncüsü sayılmadı"* — yazılabilir, ve sonraki okuyucu farkı görür

İkincisi bir sonuç değil, **ölçümün sınırı**. Sınırı yazmak sonucu zayıflatmaz; **yanlış
genellemeyi** engeller.

### Bir TANIMIN evreni, tanımın ŞARTIYLA seçilemez (ZORUNLU)

> **Bir tanımın üyeliğini ararken, aday evreni tanımın KENDİ ŞARTIYLA seçilmişse, şart
> TANIM GEREĞİ sağlanır ve İHLAL EDEN VAKALAR GÖRÜNMEZ.**

Ölçülmüş vaka (2026-08-24, `Z31`): `SUMMARY_READ` hücresinin üç şartından biri
**kapsam-zorunluluk**. Aday listesi ise **kapsam `B` kovasından** türetilmişti — yani
*"kapsamı OLANLAR"*.

```
evren        "kapsamı olan rotalar"        ← kapsam B kovası
şart         "kapsam zorunludur"
sonuç        14/14 şartı sağlıyor          ← ve bu bir ÖLÇÜM DEĞİL, bir TOTOLOJİ
```

Evrenin dışında ölçüldü: **`10` özet-şekilli, nesne-bağsız rota `A1`'de** (kapsam gerekli,
**uygulanmıyor**) — yani tanımın **ihlal eden** vakaları, ve **tam da aranması gereken
küme**.

📌 `§ KAPSAM MASKELEMESİ`'nin (*"desen çalışır, EVREN eksiktir"*) **kardeşi**: orada evren
tesadüfen eksikti; burada **tanımın kendisiyle** seçilmiş, yani eksiklik **yapısal**.

**Pratik — bir üyelik ararken sor:**

```
1  Aday evrenini NE seçti?
2  O seçici, tanımın şartlarından biriyle ÇAKIŞIYOR mu?
   → çakışıyorsa sonuç bir ölçüm değil, bir TOTOLOJİ
3  Şartı İHLAL EDEN bir vaka bu evrende görünebilir mi?
   → görünemiyorsa evren YANLIŞ
```

### Arama terimi, ARANAN YERİN DİLİYLE seçilir (ZORUNLU)

Aynı kavramın iki yüzeyde iki adı olabilir:

| kavram | entity dili (TypeORM) | katalog dili (PostgreSQL) |
|---|---|---|
| ondalık sayı | **`decimal`** | **`numeric`** |
| zarf referansı | `budgetEnvelopeId` | `budget_envelope_id` |
| pasiflik | `isActive` / `deleted_at` | — |

`decimal` vakası bunun bedelini ölçtü: katalog dilinde arandı, entity dosyalarında **0**
eşleşti.

> **İki dilli bir kavram ararken her iki token da aranır, ve hangisinin hangi yüzeyde
> geçtiği tarama notuna yazılır.**

⚠️ Ve bu **guard yazarken de** geçerli: `confdeltype` guard'ı **katalog** dilinde,
`decimal` guard'ı **entity** dilinde yazılır. Yanlış dildeki bir guard sessizce hiçbir şey
ölçmez.

### Bir VARLIĞIN yokluğunu sorarken, TANIMININ yaşadığı yüzeyde ara (ZORUNLU)

> **Dosya adı bir tanım değildir.** Bir şeyin var olup olmadığını sorarken, onu **tanımlayan
> şeyi** ara — dosya adını değil.

Ölçülmüş vaka (2026-08-16, `T-233`): *"`Capability` entity dosyası var mı"* sorusu şöyle
ölçüldü ve **`0`** çıktı:

```bash
ls src/database/entities/ | grep -ci 'capabilit'     # → 0   DOSYA ADI sayar
```

Gerçek:

```
role.entity.ts:36   @Entity({ name: 'capabilities' })       export class Capability
role.entity.ts:49   @Entity({ name: 'role_capabilities' })  export class RoleCapability
ALL_ENTITIES'te     4 atıf
```

İkisi de **başka bir dosyanın içinde** tanımlıydı. Doğru soru *"`@Entity` sınıfı var mı"*dı,
ve doğru arama `grep -rn '@Entity' src/database/entities/`.

⚠️ **Sonucu sessiz olurdu:** o ölçüme dayanarak yalnız `DROP TABLE` yazılsaydı, bir sonraki
`migration:generate` iki tabloyu **gerekçesiz geri getirirdi** (`T-101`'in vakası). Yakalayan
`data-engineer` oldu — ölçümü yapan değil.

📌 **Sınıf:** *"yanlış yüzeyin dilinde arama"* — `decimal`↔`numeric` ve göreli-yol/barrel
tuzağının kardeşi. **Desen çalıştı, EVREN yanlıştı.**

**Pratik — soruyu tanımlayıcıya çevir:**

| soru | ❌ yanlış yüzey | ✅ doğru yüzey |
|---|---|---|
| bu entity var mı | dosya adı | `@Entity` dekoratörü |
| bu servis var mı | dosya adı | `@Injectable()` + sınıf adı |
| bu rota var mı | controller dosya adı | `@Get`/`@Post` + yol dizesi |
| bu kolon var mı | entity dosyası | **katalog** (`information_schema`) |

⚠️ **Araç henüz yazılmadı ve bu bilinçli:** `find-importers.sh` **iki** ölçülmüş vakadan
sonra doğdu. Bunun bugün **bir** vakası var. *"İki vaka bir desendir"* — ikincisi gelirse
araç yazılır, gelmezse kural yeter. Henüz desen olmayan bir şeye araç yazmak `İlke 1`'in
ihlalidir.

### ENJEKSİYON kullanım değildir — ailenin üçüncü yüzü (ZORUNLU)

> **Bir bağımlılığın enjekte edilmesi, KULLANILDIĞI anlamına gelmez.**
> **Tanım yüzeyi constructor'dır; kullanım yüzeyi ÇAĞRIDIR.**

Ölçülmüş vaka (2026-08-20, `T-249`): *"hangi modüller `mechanic_spend_breakdown`
okuyor"* sorusu `InjectRepository(MechanicSpendBreakdown)` ile arandı ve **üç dosya**
çıktı. Sonuç bir kapsam kararına ve bir alt-ajan brief'ine girdi:
*"`/finance-reporting` · 7+ rota · 3 servis okuyor."*

**Yanlıştı.** Kullanımı ölçünce:

```
finance-reporting.service.ts     1 atıf  = yalnız constructor   → ÖLÜ
spend-calculation.service.ts     1 atıf  = yalnız constructor   → ÖLÜ
spend-distribution.service.ts    6 atıf  = gerçek çağrılar      → /spend-calculation/*
```

Gerçek rota ailesi **`/finance-reporting` değil `/spend-calculation`**'dı — ve brief'in
`@Roles` ölçüm talimatı bu yüzden **yanlış controller'ı** işaret ediyordu. Alt-ajan
düzeltti; ölçümü yapan yakalayamadı.

📌 **Aile:** `T-079` (*"alan kullanılıyor"* → sıfır çağıran) ve `decimal`↔`numeric`
(*yanlış yüzeyin dili*) ile aynı sınıf. Fark şu ki burada iki yüzey **aynı dosyada**
yaşıyor, o yüzden ayrımı görmek daha zor.

**Pratik — ayrımı sayıyla yap:**

```bash
grep -c 'fooRepository' <dosya>           # 1 ise: YALNIZ constructor → ölü
grep -n 'this\.fooRepository\.' <dosya>   # çağrı yüzeyi — asıl soru bu
```

⚠️ Ve bir **kapsam kararı** ya da **brief** bu sayıya dayanıyorsa, `§4.1` gereği
enjeksiyon değil **çağrı** referansı verilir: ❌ *"3 servis okuyor"* ·
✅ *"`spend-distribution.service.ts:206` `this.mechanicSpendBreakdownRepository.find`"*.

### ⚠️ VE SIKLIK — bu kural bir REFLEKS üretmiyor, bir KONTROL üretiyor

Kural yazıldıktan sonra **aynı oturumda üç kez daha ihlal edildi, ve üçünde de ihlal eden
kuralı yazan taraftı**:

| # | iddia | gerçek | yakalayan |
|---|---|---|---|
| 1 | *"`/finance-reporting` · 3 servis okuyor"* | ikisi **yalnız constructor** → ölü | alt-ajan |
| 2 | *"`BudgetAllocationService`'i finance-reporting kullanıyor"* (bir **task dosyasına** yazıldı) | enjeksiyon `1` · **çağrı `0`** | `architect` |
| 3 | *"`Capability` entity yok"* (dosya adı sayıldı) | `role.entity.ts` içinde **iki sınıf** | `data-engineer` |

📌 **Üçü de kendi turunda yakalandı** — yani kural işliyor. Ama **hiçbirini yazan
yakalamadı**: kural bir *"yazarken hatırlanan refleks"* değil, bir *"sonradan uygulanan
kontrol"* üretiyor.

> **Bu yeterli olabilir — ama o zaman kontrolün KOŞTUĞUNDAN emin olmak gerekir.**
> Review'ın koşmadığı bir turda bu sınıf **sessizce geçer**, ve `#2`'de olduğu gibi bir
> **task dosyasına** yerleşip sonraki turun girdisi olur.

**Pratik:** bir sayıyı bir **brief**'e ya da **task dosyasına** yazarken — yani başka birinin
girdisi olacaksa — enjeksiyon/çağrı ayrımını **o anda** ölç. Kod yorumunda yanılmak yanlış
bilgi üretir; **bir brief'te yanılmak yanlış İŞ üretir.**

### ⛔ VE DÖRDÜNCÜ VAKA KURALI GENİŞLETTİ — soru TABLO'ysa, terim de TABLO olmalı

Yukarıdaki üç vaka *"enjekte edildi ama çağrılmadı"* idi. Dördüncüsü **ters yönde** yanıldı
ve bir bulguyu **kapattı**:

```
soru      "budget_allocations tablosunu kim okuyor?"
arananan  budgetAllocationService     →  enjeksiyon 1 · ÇAĞRI 0   →  "tüketici yok"  ❌
gerçek    budgetAllocationRepository  →  :160 this.budgetAllocationRepository.find(...)
          ve o çağrı getBudgetUtilization'ın içinde → CANLI DASHBOARD
POZ.KONTROL  this.*Repository. → 7 eşleşme (desen çalışıyordu)
```

**Ölçüm doğruydu, SORU yanlıştı.** `budgetAllocationService` hakkındaki cümle bugün de
doğru; ama sorulan şey **servis** değil **tablo**ydı, ve bir tabloya **birden çok DI adı**
üzerinden erişilebilir (servis · repository · `dataSource.getRepository` · `relations`
string'i · ham SQL).

📌 **Sınıf:** `decimal`↔`numeric`'in **DI tarafındaki** hâli — *"yanlış yüzeyin dilinde
arama"*. Ve `§7.1`'in en pahalı yönü: bu ölçüm bir bulguyu **çürütüyordu**, yani yanılması
gerçek bir kusuru **kapatıyordu** (canlı bir dashboard ₺1.6M zarf bütçesi dururken
`₺0 · GREEN · status:"ok"` basıyordu).

**Pratik — soruyu terime çevirirken sor: *neyin* tüketicisini arıyorum?**

| soru | ❌ dar terim | ✅ doğru terim |
|---|---|---|
| bu **servisi** kim çağırıyor | — | `this.fooService.` |
| bu **tabloyu** kim okuyor | bir servis adı | **entity adı** + `Repository` + `getRepository` + `relations: [` + ham SQL |
| bu **kolonu** kim yazıyor | entity dosyası | her yazma yolu (`§`: seed · migration · servis · uç · fixture) |

> ### ⛔ VE KURAL BUDUR — ürün sahibi düzeltmesi (2026-08-23)
>
> **DI-çağrı taraması YALNIZ servis-tüketimini kanıtlar; TABLO-tüketimi DÖRT YÜZEYDE
> aranır:**
>
> ```
> 1  DI çağrıları        this.fooService.        this.fooRepository.
> 2  repository erişimi  dataSource.getRepository(Foo)  ·  manager.find(Foo)
> 3  ham SQL             query('… FROM foo …')  ·  createQueryBuilder('foo')
> 4  view'lar            v_foo_summary — bir view'ı okuyan, TABLOYU okuyor
> 5  ORM CASCADE         @OneToMany(..., { cascade: true })  +  .save(parent)
> ```
>
> **Negatif bir bulgunun geçerliliği ARAMA UZAYININ TANIMINA bağlıdır.** Uzay yazılmadan
> *"tüketici yok"* denemez.

⚠️ Ve dördüncü yüzey en sessizidir: `relations: ['planOverrides']` bir string'dir, bir
sınıf atfı değil — `T-269`'da `app-runtime-grants` guard'ı tam bu yüzden **`EXIT=0`
verirken canlı bir `500` duruyordu.

⚠️ **Ve BEŞİNCİ yüzey grep'e hiç görünmez** — ölçüldü (2026-08-23, `T-271`):

```
@OneToMany('LTARate', 'ltaAgreement', { cascade: true })
rates!: any[];
        ↓
.save(agreement)   →  agreement alanları DEĞİŞMESE BİLE lta_rates'e UPDATE dener
```

Bir DI-çağrı taraması *"`lta_rates` UPDATE gerekmiyor"* dedi ve **çürütüldü** — kanıt
grep değil, **canlı sorgu logu** oldu. Cascade bir **yazma yolu üretir** ve o yol
hiçbir dosyada bir çağrı olarak görünmez.

> **Bir tablonun YAZMA yüzeyini ararken `{ cascade: true }` taşıyan her ebeveyn ilişkiyi
> say** — ve şüphedeysen **sorgu logunu** oku, grep'i değil.

> ### ⛔ ŞERH — aynı dekoratör, aynı davranış DEĞİLDİR (ZORUNLU)
>
> **Statik olarak ÖZDEŞ iki yapı, davranışsal olarak özdeş sayılamaz.**
> **Yüzey taraması SINIFI bulur; davranışı FIXTURE söyler.**
>
> Ölçülmüş vaka (2026-08-23, `T-273`): **aynı dosyada, aynı metin**:
>
> ```
> @OneToMany('LTARate',         'ltaAgreement', { cascade: true })   → ATEŞLİYOR
> @OneToMany('LTAPlanOverride', 'ltaAgreement', { cascade: true })   → SIFIR SQL
> ```
>
> Fark **dekoratörde değil, JOIN GRAFİĞİNDE**: `LTAPlanOverride`'ın iç ilişkileri
> (`plan` · `ltaRate` · `ltaAgreement`) `findById`'de **join edilmiyor** → `undefined`
> kalıyorlar → TypeORM'un diff motoru o alanı **hiç karşılaştırmıyor**.
>
> ⚠️ Ve bu, bir taramaya dayanarak yazılan **kusur iddiasını** çürüttü — kaldırma kararı
> **ayakta kaldı** çünkü gerekçesi **sınıf temelliydi**, tek bir vakaya değil.
>
> 📌 Pratik: bir yüzey taraması *"burada da var"* dediğinde, o **bir aday**dır — bir
> bulgu değil. Bulguya dönüşmesi için **davranışın ölçülmesi** gerekir.

Kaç yüzeyin tarandığı **aynı cümlede yazılır** (`§ KAPSAM MASKELEMESİ`: *"bir küme
hakkında sonuç yazılıyorsa, kümenin NASIL SINIRLANDIĞI aynı cümlede yazılır"*).

### `@deprecated` bir NİYET BEYANIDIR, bir ölçüm değil (ZORUNLU)

> **Bir kopya *"ölü"* diye işaretlendiğinde ölçüm DURUR.**
> **Ama `@deprecated` bir niyet beyanıdır, bir ölçüm değil — ve CANLI bir rota
> `@deprecated` olabilir.**

`İlke 4` (*"aynı yetenek iki kez yazıldı"*) bir **tekrar** maliyeti sayar: iki yerde
bakım, iki yerde düzeltme. Bu vaka o maliyetin **ağırlaşmış hâlini** ölçtü — çünkü iki
kopyadan yalnız biri kapsamı uyguluyordu.

Ölçülmüş vaka (2026-08-22, `T-253`): `GET /users/dashboard-summary`, `@deprecated` ve
yorumu *"`/dashboard/summary`'ye geçin"* diyor. `B1` taksonomisinde
**`SINIF B · ÖLÜ İKİZ`** diye sınıflandırılmış ve *"bir yetenek sorusu DEĞİL, bir
`İlke 4` kalıntısı"* yazılmıştı. Ölçülünce:

```
planner  (11 CPL)  →  {"managedBudget":1600000,...}
planner2 (17 CPL)  →  BİREBİR AYNI          ← CANLI kapsam bypass'ı
getDashboardSummary(tenantId)  ·  0 AccessScopeService atıf
kanonik kardeş: dashboard.service.ts:82 resolveScopedCplIds — DOĞRU kapsıyor
```

Ve ikinci bir kusur daha taşıyordu: `budgetUsage` division-by-zero'da `0` dönüyordu
(`§2.5` + `§2.3`: *"division-by-zero → null"*) — kanonik kardeş `null` +
`'unavailable'` veriyor. **Testi o ihlali PİNLİYORDU**, ve `code-reviewer` okumasaydı
uç silinirken ihlal de sessizce kaybolacaktı.

📌 **`T-222`'nin (*"iki grid, biri karanlıkta"*) ağırlaşmış hâli.** Orada bir kopya
görülmüyordu; burada kopya **etiketlenmişti**, ve etiket ölçümü durdurdu.

**Pratik — bir kopyayı sınıflandırırken:**

```
❌  "@deprecated, ölü ikiz"        →  bir NİYET okunuyor
✅  "rota tablosunda MI?"          →  koşan sunucunun Mapped satırı
✅  "çağıranı var mı?"             →  grep, POZİTİF KONTROLLÜ
✅  "iki kopya AYNI mı davranıyor?"→  davranışsal, iki farklı girdiyle
```

⚠️ Ve iki kopya **eşit değildir**: hangisinin kanonik olduğunu ölçmeden *"ikisi de aynı
şeyi yapıyor"* yazma. Bu vakada ikisi aynı şeyi yapmıyordu — **biri güvenliydi, diğeri
değildi**, ve silinecek olan tam da güvensiz olandı.

### ⚠️ VE SIKLIK BİR DESEN — `500` bu kod tabanında YAYGIN BİR ÖRTÜ

Dört vaka, **hepsi `T-249`/`T-256` turlarında**, ve dördünde de örten şey **aynı**:

| içteki kusur | örten | düzeltince ne oldu |
|---|---|---|
| `markAsRead` kullanıcı körlüğü | `500` (izin yok) | delik **ERİŞİLEBİLİR** oldu |
| `plan_sku_id` FK ihlali | `500` (izin yok) | kusur **GÖRÜNÜR** oldu |
| self-approval kontrolü hiç ateşlemiyor | `500` (obje→`uuid`) | **kazara güvenliydi** — düzeltince koruma **gerçekten** çalıştı |
| genel onay ucu domain akışını atlıyor | `500` (obje→`uuid`) | **atomiklik ihlali** erişilebilir oldu |

> **Bir `500`, bir kusurun YOKLUĞU değil — çoğu zaman İKİNCİ bir kusurdur, ve
> birincisini saklar.**

📌 **Pratik sonuç:** `500` veren bir ucu düzeltirken, o `500`'ün **arkasında ne
olduğunu** sor. Uç *"çalışmıyor"* değil — **hiç ölçülmemiş** demektir, ve arkasındaki
kod yolu **hiçbir zaman koşmamıştır**.

⚠️ Ve bu, `CLAUDE.md`'nin *"bir doğrulamanın çalıştığı sanılması, girdinin ona hiç
ULAŞMAMASINDAN gelebilir"* maddesinin **rota tarafındaki** hâli: `500` veren bir uçtaki
hiçbir kural, doğru olduğu **bilinerek** orada durmuyor.

### Bir SAYI, eşleşmeleri ÖRNEKLENMEDEN raporlanamaz (ZORUNLU)

`§7.1` *"bir terim sayısına dayanarak karar veriyorsan en az bir geçişi bağlamıyla oku"*
diyor. Bu **bir tavsiyeydi ve tutmadı** — aynı oturumda **üç kez** ihlal edildi:

| # | sayılan | sanılan | gerçek |
|---|---|---|---|
| 1 | `grep -owci capability` → 15 | CBAC tartışılıyor | iş anlamında *"yetenek"* — başka kavram |
| 2 | `grep -w S1/S2/R1` → 17/31/17 | dalga kalemleri | başka bir raporun **bulgu** ve **risk** numaraları |
| 3 | `grep -r FiscalPeriod` → 6 dosya | entity tüketicisi var | **`getFiscalPeriod`** adlı bir parser metodu |

Üçü de kendi turunda yakalandı — ama **üç kez tekrarlaması, tavsiyenin yetmediğini gösterir.**
Ve üçüncüsü en pahalıya mal olacaktı: bir `code-reviewer` bulgusunu (*"tüketici 0"*)
çürütmek üzereydi, yani **doğru bir blocker'ı yanlış yere gömecekti.**

> **Bir eşleşme sayısı, en az bir eşleşme bağlamıyla okunmadan raporlanamaz** — ne bir
> karara dayanak yapılabilir, ne bir bulguyu çürütmek için kullanılabilir.

**İki şart:**

1. **Sayıyla birlikte bir örnek yaz.** `"6 dosya"` değil, `"6 dosya — ör.
   `sales-actuals.service.ts:81` `resolveFiscalPeriod`"`. Örneği yazmak, ona bakmayı zorlar.
2. **Bir sayı bir bulguyu ÇÜRÜTÜYORSA, örnek zorunludur.** Doğrulayan bir sayı yanılırsa
   fazladan iş üretir; **çürüten** bir sayı yanılırsa **gerçek bir kusuru kapatır.**

### Bir SAYIM FARKI, farkın KAYNAĞI gösterilmeden yorumlanamaz (ZORUNLU)

> **Bir sayım farkı, farkın KAYNAĞI gösterilmeden yorumlanamaz.**
> **"Her şey reddediliyor" ile "yanlış sebeple reddediliyor" AYNI SAYIYI verir.**

`§`'nin *"bir sayı, eşleşmeleri örneklenmeden raporlanamaz"* kuralı **eşleşme
sayıları** içindi. Bu, **hata/sonuç sayıları** için ve daha sinsi: orada sayı bir
kümeyi anlatıyordu, burada bir **yargıyı**.

Ölçülmüş vaka (2026-08-19, `T-241` `B1` blocker'ı): bir `code-reviewer` bulgusunu
**doğrulamak** için DTO doğrulaması ölçüldü. Team Lead'in fixture'ı `fullName: 'X'`
taşıyordu ve `MinLength`'i ihlal ediyordu — yani **her vakaya sabit `+1` hata**
ekliyordu:

```
okunan                          gerçek
FAIL(1)  scope:[{}]             1 hata = fullName        → scope hatası YOK
FAIL(2)  POZ.KONTROL scope YOK  2 hata = fullName·scope  → scope hatası VAR
```

İlk okuma **"her şey reddediliyor, review yanlış"** idi. Ve pozitif kontroller de
`FAIL` döndüğü için **çalışıyor göründüler** — kayma onları da kaydırmıştı.

⚠️ **Bedeli:** o okuma raporlansaydı **gerçek bir blocker gömülecekti**, ve gerekçesi
*"ben ölçtüm, review yanılıyor"* olacaktı. Yani hata **çürüten** yöndeydi — `§7.1`'in
*"çürüten bir sayı yanılırsa gerçek bir kusuru kapatır"* maddesinin tam vakası.

**Pratik:** bir sayım farkını yorumlamadan önce **farkın kaynağını bas** — hangi
alan, hangi kural, hangi satır. `errs.length` değil `errs.map(e => e.property)`.
Ve **sabit bir kayma her vakayı aynı yönde bozar**, yani pozitif kontrol onu
yakalamaz: kontrol de kayar.

### `LEFT JOIN` + `IS NULL` bir YOKLUK testi DEĞİLDİR (ZORUNLU)

> **`LEFT JOIN` ile `IS NULL`, iki farklı durumu aynı sonuca çevirir:**
> **"eşleşme yok" ve "değerin kendisi `NULL`". Ayrım açıkça yazılmalı.**

`sol.fk IS NULL` yazdığında sorduğun şey *"öksüz mü"* değildir. `LEFT JOIN` eşleşme
bulamadığında sağ tarafın **her kolonu** `NULL` olur — ve sol taraftaki `fk` zaten `NULL`
ise de sonuç aynıdır. İki anlam, tek çıktı.

**Ölçülmüş çift vaka (2026-08-17, `user_scopes` — aynı gün, aynı tuzak, iki kez):**

| # | yazılan | sanılan | gerçek |
|---|---|---|---|
| 1 | `FILTER (WHERE us.cpl_id IS NULL AND us.category_id IS NULL)` | *"joker satırı var"* | **satırı olmayan** kullanıcı da sayılıyordu → gerçek joker `0` |
| 2 | `FILTER (WHERE c.id IS NULL)` | *"öksüz satır"* | `category_id`'si **`NULL`** olan satırlar da sayılıyordu → `PLANNER`'lar `17`/`11` öksüz göründü, gerçek `0` |

**Doğru şekil — iki koşul, ikisi de açık:**

```sql
-- ÖKSÜZ = sol taraftaki değer DOLU, ama karşılığı YOK
WHERE sol.fk_id IS NOT NULL       -- ← BU SATIR unutuluyor
  AND sag.id     IS NULL

-- SATIRI YOK = join'in kendisi eşleşmedi
WHERE sag_satir.id IS NULL        -- birincil anahtarına bak, kolonuna değil
```

⚠️ **Ve ikisi de `beklenen yöne` yanıldı** — biri *"joker var"*, diğeri *"öksüz çok"*
beklentisini besliyordu. Yani bir önceki maddeyle aynı aile: **makul göründükleri için
sorgulanmıyorlardı.**

Pratik: `LEFT JOIN`'de bir yokluk sayarken, **sol taraftaki değerin dolu olduğunu ayrıca
şart koş** — ve sonucu sıfır çıkarsa `§`'nin pozitif kontrol kuralı geçerli.

### "Sekiz vaka" gibi bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz (ZORUNLU)

`docs/analysis/0070 §B3` ölçtü: repoda *"sekiz kez ölçüldü"* dört yerde yazıyor ve
**hiçbirinde liste yok**. Üstelik **en az dört farklı "sekiz"** dolaşıyor:

| hangi sekiz | listesi var mı |
|---|---|
| `İlke 4` (aynı yeteneğin tekrarı) | ❌ |
| *"mekanizma var, yol yok"* (`T-033`…`T-062`) | ✅ **listeli** |
| karar kayıtlarındaki çakışma | ❌ |
| doğrulama maskeleme ailesi | ❌ |

Ve sayıyı **kullanmaya** kalkınca çöktü: *"sekiz ihlalin kaynağı şu bölme"* varsayımı
sınandı, ve `CLAUDE.md §7`'nin **adıyla saydığı dördünde** üçü bölmedeydi, biri
(`lumpsum` dağıtımı, `shared/spend-calculation/`) **değildi**.

> **Enumerasyonu olmayan bir sayı, bir sonuca dayanak yapılamaz.**
> *"Kaçı bundan doğdu"* sorusu, liste ölçülene kadar bir **tahmindir**.

**Kural:** bu tür bir sayı yazılırken ya **listesi de yazılır** (ya da listeye atıf
verilir), ya da sayı **hiç anılmaz** — yerine niteliksel ifade kullanılır
(*"tekrar eden bir sınıf"*).

⚠️ `guard.sh`'ın öğrettiği dersin belge tarafı: **elle tutulan bir sayı bayatlar.** Fark
şu ki bir guard bayatladığında kırmızıya döner; bir belgedeki sayı **hiçbir zaman**
dönmez.

## AİLE — KAPI ve GUARD YAZIMI

### Yazma ile commit arasına bir DOĞRULAMA koy (ZORUNLU)

Bir dosyayı yazan adım ile onu commit'leyen adım arasında **hiçbir kontrol yoksa**, sessizce
başarısız olan bir düzenleme **tutarsız bir commit** üretir — ve o commit'in ömrü, onu okuyan
bir sonraki kişiye kadar sürer.

Ölçülmüş vaka (2026-08-11, `ADR 0012`): iki `str.replace` içeren bir python bloğu
**ikincisindeki tırnak hatasıyla** tümüyle düştü (`SyntaxError`), ama shell zinciri devam
etti ve `git commit` çalıştı. Sonuç: ADR'nin bir bölümü güncel, uygulama sırası **eski**
metni taşıyor — ve commit mesajı ikisinin de güncellendiğini söylüyor.

> **Bir script'in çalıştığını çıktısından değil, ÜRETTİĞİ DOSYADAN doğrula.**
> `python3 - <<'PY' … PY` bloğu bir `SyntaxError` verdiğinde `&&` zinciri kopmaz, çünkü
> hata **python'un içinde** değil, **parse aşamasındadır** ve exit kodu bir sonraki
> komutu engellemez.

Pratik: commit'ten **önce** değiştirdiğin şeyi `grep` ile geri oku. Bu, `§2.7`'nin
*"mutasyonu dosya içeriğinden doğrula"* kuralının yazma tarafındaki hâli.

- ❌ `python3 … ; git add -A && git commit`
- ✅ `python3 … ; grep -q '<yeni metin>' <dosya> && git add -A && git commit`

⚠️ **Ve bu özellikle ADR/sözleşme dosyalarında önemli:** kodda tutarsızlık bir sonraki test
koşumunda kırmızıya döner; bir **karar belgesinde** hiçbir zaman dönmez.

### Doğrulama bir KAPIDIR — durdurmuyorsa doğrulama değildir (ZORUNLU)

> **Doğrulama, çıkışı akışı durduran bir kapıdır; durdurmuyorsa doğrulama değildir.**

Bir kontrolün **basılması** ile **bağlayıcı olması** ayrı şeylerdir. Basılan bir sayı
okunmayı bekler; bir kapı beklemez. Ve okunmayan bir kontrol, olmayan kontrolden **kötüdür**
— çünkü yapıldığı sanılır.

Bu, `§2.7` ailesinin dışında **ayrı bir sınıf**: orada ölçüm yanlıştı ya da yanlış şeyi
ölçüyordu; burada **ölçüm doğru ve kimse ona bakmıyor.**

Aynı gün **iki** vakası ölçüldü:

| vaka | kontrol ne yaptı | neden kapı değildi |
|---|---|---|
| Team Lead'in commit'i | bayat atıf sayısını **bastı** (`1`, beklenen `0`) | çıktıydı, koşul değil — `git commit` yine koştu |
| `run-all.sh` (backend) | alt guard'ın `RC`'sini **yakaladı** | yalnız `2`'ye karşı sınandı; `RC=1` yutuldu → **runner exit 0** |

İkincisi daha pahalıydı: gerçek repoda çöken bir guard *"0 bulgu"* diye raporlanıyor ve
`npm run guards` **yeşil** veriyordu. Ampirik kanıt (mutasyon: guard yalnız gerçek repoda
çöksün, fixture'da değil) — `self-test EXIT=0` · `guard EXIT=1` · **`runner EXIT=0`**.

⚠️ **Ve savunmayı başka bir kontrole devretmek yetmez.** O runner'ın kendi yorumu bu sınıfa
karşı yazılmıştı ve *"self-test yakalar"* diyordu. Yakalayamadı: self-test guard'ları
**fixture env değişkeniyle** çağırıyor, runner **çıplak** — ikisi farklı girdi kümesini
ölçüyor. Bir kontrolün başka bir kontrolü kapsadığı **ölçülmeden** varsayılamaz.

**Pratik:**

- ❌ `echo "$n bayat atıf"; git commit …`
- ✅ `[ "$n" -eq 0 ] && git commit … || echo "⛔ commit YAPILMADI"`
- ❌ `RC=$?` … `if [ "$RC" -eq 2 ]` (tek bir değere karşı)
- ✅ `if [ "$RC" -ne 0 ]` — **meşru çıkış kodlarını önce ÖLÇ**, sonra kalanını fatal yap

Ve bir kapı yazdıktan sonra `§2.7 #9`'u uygula: **iki farklı girdide iki farklı çıktı**
verdiğini göster. Temiz halde yeşil olması, kirlide kırmızı olduğunun kanıtı değildir.

### Bir KAPI, ölçümün BAŞARISINI hata sayamaz (ZORUNLU)

> **Bir kontrol İKİ İDDİAYI tek sinyalde birleştiriyorsa, ikisinden biri bir gün
> diğerini YALANLAR.**
> **"Mekanizma sağlıklı mı" ile "ölçüm sonucu ne" AYRI önermelerdir.**

Ölçülmüş vaka (2026-08-24, `Z29`): iki ratchet guard'ı boş bir baseline'ı **her zaman**
setup hatası sayıyordu:

```bash
route-scope.sh:343     if [ ! -s "$BASE_KEYS" ]  →  "SETUP HATASI" · exit 2
scope-ratchet.sh:128   DÖRT kovaya (A1·A2·B·C) aynı kontrol
```

Niyet doğruydu — **bozuk bir baseline** yakalamak. Ama kanıt olarak **satır sayısı**
seçilmişti:

```
"ayrıştırma çalıştı"  →  MEKANİZMA SAĞLIĞI
"satır sayısı > 0"     →  ÖLÇÜM SONUCU
```

⇒ **Kontrol, ratchet'in BAŞARISINI yapısal olarak "hata" diye tanımlamıştı.** Ve
`scope-ratchet`'te daha keskin: `A1` **tam olarak sıfıra indirilmeye çalışılan listeydi**.

⚠️ **Dal hiç koşmamıştı** — `§`'nin *"bir kuralın doğru olduğunu kırmızıya dönmemesinden
çıkarma; o kuralın reddedeceği girdi ona ULAŞIYOR mu?"* sınıfı. Ulaşmıyordu, ve doğru
olduğu **bilinmiyordu**.

**Pratik — bir kapı yazarken sor:**

```
1  Bu kontrolün reddettiği durum, projenin HEDEFİ olabilir mi?
   → olabiliyorsa, kontrol yanlış şeyi ölçüyor
2  Sağlık kanıtı BİÇİMDEN mi geliyor, SAYIDAN mı?
   → sayıdan geliyorsa, sayının meşru sıfırı bir gün gelir
3  Sıfır bir BAŞARI OLAYI mı? → öyleyse GÖRÜNÜR olmalı, sessiz geçilmemeli
```

📌 Ve çözüm bir **biçim alanı eklemek değil**: bir sentinel (`# ratchet: COMPLETE`)
üçüncü bir sözleşme olur ve bayatlar. **Çıktı satırı** aynı işi yapar ve bayatlamaz.

> ### ⛔ VE BU SINIFIN ZAMANLAMASI ONU EN PAHALI YAPAR (ZORUNLU)
>
> **Başarı anında patlayan bir hata, en pahalı hata sınıfıdır — çünkü kimse BAŞARI
> GÜNÜNDE guard'dan şüphelenmez.**
>
> Aynı kusurun iki vakası, **iki farklı zamanlamayla**:
>
> ```
> route-scope.sh     kusur BUGÜN göründü      — FILTRESIZ ilk kez sıfırlandı
> scope-ratchet.sh   kusur GELECEĞE KURULMUŞ  — A1 sıfırlandığı gün, yani
>                                               ADIM 3'ün BİTİŞ GÜNÜNDE patlayacaktı
> ```
>
> İkincisi bulunmasaydı, `ADIM 3`'ün tamamlandığı gün guard **`exit 2`** verecekti ve
> teşhis çok daha zor olurdu: *"her şey bitti, neden kırmızı?"*
>
> 📌 **Bu, tek-vakalık yamanın neden yetmediğinin en iyi savunması.** İki-vakalık envanter
> (`§`: *"sınıfla düzelt, ilk vakayla değil"*) bir **tuzağı zamanından önce** boşalttı.
>
> ⚠️ Ve üç sorunun **birincisi kova kova farklı cevap verir**: `A1`/`A2`/`FILTRESIZ` için
> sıfır **hedeftir**; `B`/`C` için **beklenmez ama "bozuk" da demek değildir**. Kontrol
> tek biçimde olur, **çıktı metni** ayrışır.

### Yan etkisi olan bir aracı İZOLE hedefte sına (ZORUNLU)

> **Yan etkisi olan bir aracı sınamak, o yan etkiyi ÜRETMEYİ gerektirir — sınav izole bir
> hedefte yapılır, gerçek olanda değil.**

Ölçülmüş vaka (2026-08-14): `push-order.sh`'ın kirli-ağaç kaçışı (`ABORT_ON_DIRTY=0`)
**gerçek `origin`'e karşı** koşturuldu. Meta'da push edilmemiş bir commit vardı ve script
onu **push etti** — yani doğrulama, ölçtüğü durumu değiştirdi ve **dışa dönük** bir işlem
üretti.

⚠️ Ve doğru yol zaten oradaydı: aracı **yazan** ajan onu izole bir bare-repo harness'ında
sınamıştı (altı senaryo, gerçek uzağa dokunmadan). Doğrulayan taraf kestirmeden gitti.

**Pratik:** bir aracın yan etkisi ağ, dosya sistemi ya da bir uzak durum ise, sınavın hedefi
**tek kullanımlık** olmalı — bare repo, geçici dizin, tek kullanımlık DB. Ve zaten böyle bir
harness varsa, doğrulama **onu kullanır**; ikinci bir yol açmaz.

📌 Bu `§2.7`'nin en net vakası: **kanıt kurulumu ölçtüğün durumu değiştirdi.** Ama bir
farkla — buradaki değişiklik geri alınamaz (bir push geri alınmaz, ancak üstüne yazılır).

### DÖRDÜNCÜ SORU — kontrolün girdisi, kontrol ettiği şeyden mi türüyor? (ZORUNLU)

> **Bir doğrulama, doğruladığı şeyden türetiliyorsa doğrulama değildir.**
> **Guard yazarken sor: *bu kontrol HANGİ GİRDİDE kırmızıya döner?*
> Cevap yazılamıyorsa kontrol bir TOTOLOJİDİR.**

`§ BİR KAPI, ÖLÇÜMÜN BAŞARISINI HATA SAYAMAZ` (`Z29`) üç soru soruyor. Bu **dördüncüsü**,
ve `§ BİR TANIMIN EVRENİ, TANIMIN ŞARTIYLA SEÇİLEMEZ` kuralının **guard tarafındaki** hâli
— orada bir *aday evreni* tanımın şartıyla seçiliyordu; burada bir *kontrolün girdisi*
kontrol ettiği şeyden türüyor.

Ölçülmüş vaka (2026-08-24, ürün sahibi şartı olarak istendi ve **elenmesi memnuniyetle
kaydedildi**): `route-cell-map.py`'a *"kategori toplamları == satır sayısı"* iç-mutabakatı
istendi. Yazıldı, sonra mutasyonla sınandı:

```
MUT-B   çıktıya sahte bir satır eklendi
sonuç   212 = 212 = 212      ← kapı ATEŞLEMEDİ
sebep   Counter SATIRLARIN KENDİSİNDEN türetiliyor; eşitlik TANIM GEREĞİ sağlanıyor
```

📌 **Ve ayrım kalıcı:** o tutarsızlık **belgedeydi**, çıktıda değil — **bir script belgenin
aritmetiğini denetleyemez.** Script'in işi, belgeyi **sayı yazmak zorunda bırakmamaktır**.
Yani çözüm bir kontrol değil, bir **tek-üretici kuralıdır**; yapısal olarak yapar,
denetleyerek değil.

⚠️ **Bir totoloji, olmayan kapıdan KÖTÜDÜR** — yeşil olduğu için **çalıştığı sanılır**.
Yerine konan kontroller **kırılabilir** olmalı, ve **kırıldıkları gösterilmeli**.

### DOSYA SINIRI, STATE SIFIRLAMA NOKTASIDIR (ZORUNLU — guard yazımı)

> **Satır-tabanlı her ayrıştırıcıda (awk/sed/streaming parser) dosya sınırı bir
> SIFIRLAMA noktasıdır — ve unutulan her bayrak SONRAKİ dosyaya sızar.**

Ölçülmüş vaka (2026-08-25, `Dalga-M` `S1`): `route-scope.awk`'a class-seviyesi
`@Roles` takibi eklendi, ama bayrak `FNR==1` blokunda sıfırlanmadı — bir
controller'ın class `@Roles`'ü **sonraki dosyanın TÜM rotalarına** sızardı.

⚠️ **Ve yön dikkate değer: bu kapıyı yanlış-YEŞİL değil yanlış-KIRMIZI yapardı** —
sızan bayrak **temiz bir rotayı kirli gösterir**. Bir kapının iki yönde de
bozulabileceğinin hatırlatıcısı.

**Pratik:** bir ayrıştırıcıya yeni bir durum bayrağı eklerken, onu `ctrl_base` gibi
**aynı yaşam döngüsüne sahip** mevcut bir değişkenin yanına koy — ve **sıfırlamasını
o değişkenin sıfırlandığı her yere** ekle. Sonra **iki dosyalı bir fixture** ile
sınadığını göster (tek dosyalı fixture sızıntıyı **göremez**).


## AİLE — GİZLENEN KUSUR SINIFLARI

### Bir kusur, BAŞKA bir kusur tarafından örtülebilir (ZORUNLU)

> **Bir kusur, başka bir kusur tarafından örtülebilir — ve dıştaki düzeltilince
> içteki ORTAYA ÇIKAR.**
> **Yani bir düzeltme turu, kapattığından fazlasını AÇABİLİR; ve fark yazılmazsa
> "düzelttik" denilen tur bir deliği açmış olur.**

`§2.7`'nin *"doğrulama maskeleme"* ailesi **ölçümün** kusuru gizlemesini konu alıyor.
Bu farklı: gizleyen şey **ürünün kendi ikinci kusurudur**, ve ölçüm doğrudur.

**İki ölçülmüş vaka (2026-08-20, `T-249`), ve YÖNLERİ ZIT:**

| # | içteki kusur | örten şey | düzeltme ne yapıyor |
|---|---|---|---|
| 1 | `markAsRead` **kullanıcıyı hiç almıyor** — bir UUID bilen herkes başkasının kaydını işaretleyebilir | `app_runtime`'ın izni yok → rota **`500`** | `GRANT` **deliği ERİŞİLEBİLİR kılıyor** |
| 2 | `plan_sku_id` **katalog id'siyle** dolduruluyor → FK ihlali | aynı `permission denied` **daha önce** ateşliyor | `GRANT` **kusuru GÖRÜNÜR kılıyor** |

Birincisi **kazara güvenli** (`INV-C-*`): koruma bir tasarım değil, bir arıza.
İkincisi **kazara sessiz**: kusur duruyordu, kimse ona varamıyordu.

⚠️ **Ve ikisi aynı `GRANT`'ten doğuyor** — yani tek bir düzeltme, bir deliği açıyor
**ve** bir kusuru gösteriyor. Bunlar farklı sonuçlardır ve **ayrı ayrı** yazılmalıdır.

**Pratik — bir kusuru düzeltmeden önce sor:**

```
1. Bu kusur ŞU ANDA başka bir şeyi ÖRTÜYOR mu?
   → örtüyorsa: düzeltme onu ortaya çıkarır. TASK aç, aynı turda değilse bile.
2. Bu kusurun VARLIĞI şu anda bir korumaya mı dönüşmüş?
   → dönüşmüşse: düzeltme o korumayı KALDIRIR. Yerine gerçek koruma konmalı.
```

📌 `T-249`'da ikisi de yazıldı — task dosyasında, `FAZ1_PLAN §5`'te ve bir sonraki
adımın önceliğinde. **Yazılmasaydı, "üç kırık ucu düzelttik" cümlesi doğru olur ve
eksik kalırdı.**

### YORUM KİRLİLİĞİ iki yönde birden yanıltır (ZORUNLU)

> **Bir dekoratörü/çağrıyı ararken yorum satırları hem VAR OLANI GİZLER hem
> OLMAYANI GÖSTERİR — ve iki yön de aynı taramadan çıkar.**

Aynı kaynaktan **zıt yönlerde** iki ölçülmüş vaka:

| yön | vaka | sonuç |
|---|---|---|
| **olmayanı gösterdi** | `@Roles(` bir **yorumda** geçiyordu | `plans/:id/reject` *"filtresiz"* sanıldı — **değildi** |
| **olmayanı gösterdi** | `T-249`'un açıklama yorumları `@Roles` içeriyordu | *"sınıf seviyesi `@Roles` var"* sanıldı — **yoktu** (2026-08-21) |

⚠️ **İkincisini yapan Team Lead'di, ve birincisi `CLAUDE.md`'de zaten yazılıydı.**
Kural biliniyordu; **refleks** yoktu.

📌 Ve tehlikesi yöne göre değişir:

```
olmayanı göstermek   →  var olmayan bir kusur için İŞ ÜRETİR  (fazla ölçüm)
var olanı gizlemek   →  gerçek bir kusuru KAÇIRIR             (eksik ölçüm)
```

**Pratik — bir dekoratör/çağrı ararken:**

- Eşleşmeyi **bağlamıyla oku** (`§7.1`: *"bir sayı, eşleşmeleri örneklenmeden
  raporlanamaz"*). Bir satırın `//` ya da `*` ile başlaması ilk kontrol.
- Sayım yapan bir **araç** yazıyorsan yorumları **ayıkla** — ve ayıkladığını
  **fixture ile sına**, çünkü ayıklamanın kendisi sessizce bozulabilir.
- Ve bir iddiayı **çürütürken** ekstra dikkat: yorumdan gelen bir eşleşme, gerçek
  bir bulguyu *"zaten korunuyor"* diye kapatabilir.

### Kod yorumunda "ulaşılamaz" yazmadan önce ölç (ZORUNLU)

**"İmkânsız" · "gelemez" · "ulaşılamaz" · "bu duruma düşmez" — bu ifadeler normatiftir.** Bir
sonraki okuyucuya kontrolü atlama izni verirler, ve yanlışlarsa koruma **kalıcı olarak** kalkar.

T-097: `DecimalTransformer`'a *"not reachable from the database today"* yazıldı. Ölçüm
yapılmıştı ama eksikti — `numeric(15,2)` **NaN'ı saklar** ve `NaN` metni olarak döndürür;
yalnız `Infinity` reddedilir. İddia yanlıştı ve tam da yazma ucunun korumasız kalmasını
meşrulaştırıyordu.

Bu, §7.1'in T-084 vakasıyla aynı: *"must not be fixed to match"* yorumu bir kusuru koruma
altına almıştı. **Bir hatayı belgelemek onu koruma altına alır** — ve yorum, testten farklı
olarak, hiçbir zaman kırmızıya dönmez.

- ❌ "bu değer DB'den gelemez" · "buraya `null` düşmez" · "çağıran hep sayı gönderir"
- ✅ "ölçüldü <tarih>: `numeric(15,2)` NaN'ı kabul ediyor — kanıt: `insert ... values ('NaN')`
  → `INSERT 0 1`" · ya da iddiadan tamamen vazgeç ve korumayı yine de yaz

**Ve kural yalnız "yok" iddialarına değil, "var" iddialarına da uygular — bu ekleme bir
karşı-örnekten geldi.** T-098, bu kural CLAUDE.md'ye T-097'den sonra eklenmişken, bir sonraki
task'ta aynı sınıfı tekrarladı:

| task | koda yazılan | gerçek |
|---|---|---|
| T-097 | *"not reachable from the database today"* | `numeric(15,2)` NaN'ı **saklıyor** |
| T-098 | *"context, **which the logger prints**"* | Nest `Error.toString()` basıyor — ne context ne stack |

İkisi de **"başka bir yerde" hakkında** bir iddiaydı ve ikisi de **o başka yerde ölçülmedi**.
İkincisi daha pahalıydı: değer mesajdan çıkarıldı, hiçbir yere konmadı, ve "orada duruyor"
denildi — sızıntı kapanırken **teşhis de silindi**.

> **Bir yorum başka bir bileşenin davranışı hakkında iddiada bulunuyorsa, o bileşen
> KOŞTURULARAK ölçülmeli. "Ulaşılamaz" kadar "hâlâ erişilebilir" de bir iddiadır.**

**Ve ihlalin maliyeti nerede olduğuna bağlı — yedinci vaka bunu gösterdi.**

| ihlal nerede | maliyeti |
|---|---|
| bir **yorumda** | yanlış bilgi; sonraki okuyucu yanılır |
| bir **kapsam kararında** | **kapatılmamış kusur**; iş hiç yapılmaz |

Altı vaka yorumdaydı ve "yanıltıcı ama zararsız" diye birikti. Yedincisi (T-106) bir kapsam
gerekçesiydi: *"tarayıcı `type="number"` alanında `1.234,56` yazılmasına izin vermiyor"* —
ölçülmedi, ve beş para girdisi düzeltmenin dışında bırakıldı. Ölçüm sonradan yapıldığında
gerçek şu çıktı: kullanıcı `250.000` yazınca **250** kaydediliyordu.

> **Bir kapsam kararı ölçülmemiş bir iddiaya dayanıyorsa, o karar bir tahmindir — ve
> tahminin bedeli kodda değil, yapılmayan işte birikir.**

⚠️ Ve o vakanın kendisi kalıcı bir tuzak: `type="number"` **programatik atamayı** temizler
(`el.value = "1.234,56"` → `""`), **klavye girişini temizlemez** (`250.000` → `250.000`,
`badInput=false`). İki farklı işlem, zıt davranış; iddia birinden diğerine genellendiği için
yanlıştı.

Pratik test: yorumundaki fiilin öznesi **senin dosyan değilse** (logger basar, DB reddeder,
çağıran gönderir), o cümle bir ölçüm gerektirir.

**Ve kural tek başına yetmedi — beş vaka sonra ek şart kondu.** Kural yazıldıktan sonra bile
aynı hata iki task daha tekrarlandı (*"logger prints"*, *"satır-bazlı kanal yok"*). Sebep:
kural neyi arayacağını söylüyor ama **yazarken** hatırlanmıyor; `code-reviewer` yakalıyor,
yazar yakalamıyor.

> **Yorumda başka bir bileşen hakkında bir cümle yazıyorsan, ölçüm referansını da yaz.**

- ❌ "`importCustomers` satır hatası toplamıyor"
- ✅ "`importCustomers` satır hatası topluyor (`customer.service.ts:365`) — kanal var"

Atıf iki iş yapar: iddiayı **sonraki okuyucu için doğrulanabilir** kılar, ve **yazarken
ölçmeye zorlar** — çünkü satır numarasını yazmak için oraya bakmak gerekir. Kural bir refleks
üretemedi; atıf şartı üretiyor.

### Bir kuralı yazdığın tur, o kuralı en çok ihlal ettiğin turdur (ZORUNLU)

Bu dosyaya yeni bir kural eklenen turlarda, **aynı turun diff'i o kuralı ihlal ederken
yakalandı** — ve her seferinde yakalayan `code-reviewer` oldu, yazar değil. Kural doğruydu;
eksik olan **refleks**ti.

| kural eklendi | aynı turdaki ihlal |
|---|---|
| "başka bileşen hakkındaki iddiayı ölç" | *"logger prints"* — ölçülmedi |
| "atıfa grep'lenebilir token yaz" | seed'e yazılan satır atfı aynı turda bayatladı |
| "dokümanda sayı yazma" | ADR E17'ye `47/18` yazıldı, iki satır aşağıdaki karar onu bayatlattı |
| "§7.1: kusur sınıfını aynı dosyada ara" | B1 düzeltildi, **aynı fonksiyondaki iki kardeş dal** taranmadı |
| **SoD: "tabi olduğu kuralı yazamaz"** (`Z36`) | gerekçesi *"`ADMIN` şablonun ÖZNESİ DEĞİL"* diyordu — `ADMIN` onay rotalarının **beşinde**. Kural, **yazıldığı cümlede** ihlal edildi |
| **"örtü kaldırılırken altındaki AYNI COMMIT'te kapanır"** (`T-294`) | `T-296` örtüyü kaldırdı (`400` → DTO) ve altından `forecast_vs_actual`'ın **sessiz sıfırı** çıktı — kuralın tarif ettiği şeyin **birebir kendisi** |

Sebep basit ve mazeret değil: kural yazmak dikkati **kuralın metnine** çeker, koda değil.

> ### ⚠️ VE SAYACIN KENDİSİ ARTIK BİR ARGÜMAN (ürün sahibi, 2026-08-26)
>
> Beş vaka bir *"dikkat kayması"* değil, bir **oran**. Ve beşincisi en keskini:
> ihlal koda değil, **kuralın kendi gerekçe cümlesine** düştü — yani *"kendi diff'ine
> uygula"* adımı, **diff'ten önce metne** uygulanmalıymış.
>
> ⇒ **Bir kural yazarken, önce onu KURALIN KENDİ GEREKÇESİNE uygula.** Gerekçe
> cümlesi kuralın ilk tüketicisidir; orada tutmuyorsa kural değil, **temenni**dir.

> ### ✅ VE ALTINCI VAKA SAYACIN AMACINA ULAŞTIĞI ANDIR (2026-08-26)
>
> Altıncısı öncekilerden **bir farkla** ayrılıyor:
>
> ```
> 1-5. vaka   ihlal PUSH'A KADAR yaşadı, sonra kaydedildi
> 6.   vaka   kural + review çifti onu COMMIT İÇİNDE ÖLDÜRDÜ
> ```
>
> `T-296` örtüyü kaldırdı, altından sessiz sıfır çıktı, **ve aynı dalgada
> yakalandı**. Yani:
>
> > **Kör nokta YAPISAL — ama artık MEKANİZMALI.**
>
> 📌 Sayaç bir suçlama listesi değil, bir **kalibrasyon aracıdır**: kaç vakada
> ihlalin **ne kadar yaşadığını** ölçer. Ömür kısalıyorsa mekanizma çalışıyordur.
> Ve bu turda ömür **sıfır commit** oldu.

> ### ⇒ VE YEDİNCİ VAKA SAYACIN ÖLÇTÜĞÜ ŞEYİN EVRİLDİĞİNİ GÖSTERDİ
>
> ```
> erken vakalar (1-5)   KURAL İHLALİ      kural doğru, diff onu çiğniyor
> son ikisi     (6-7)   YÜZEY EKSİKLİĞİ   kural doğru, UYGULAMA YÜZEYİ dar
> ```
>
> `7`: *"istisna kalkınca yeniden-okuma"* kuralı **doğru uygulandı** — ama tarama
> **koda daraldı**. Kaçan yedi atfın **beşi belgedeydi**.
>
> ⇒ Bu, **arama uzayı** kuralının (*"negatif bir bulgunun geçerliliği ARAMA UZAYINA
> bağlıdır"*) **karar-atıf** tarafıdır. Ve kritik olgu: **karar-atıflarının baskın
> yüzeyi BELGEDİR, kod değil** — çıplak-`§` ölçümü bunu sayıyla göstermişti
> (**~1130 belge-atfı**).

### `İstisna kalkınca yeniden-okuma`nın TARAMA YÜZEYİ — DÖRT, varsayılan olarak

```
1  kod          (yorumlar, gerekçe blokları, guard dosyaları)
2  docs/        (analiz, karar, süreç, eşleme tabloları)
3  backlog      (task dosyaları VE indeks)
4  karar-girdisi paketleri   ← EN PAHALISI: ürün sahibi bunlara BAKARAK karar verir
```

⛔ **Dördü birden, varsayılan olarak.** `4`'ü atlamak, çürütülmüş bir iddiayı
**karar masasında** bırakır.

### ⇒ VE KABUL BİÇİMİ: *"tarandı"* beyanı YÜZEY-BAŞINA POZİTİF KONTROLSÜZ KABUL EDİLMEZ

**İki tur üst üste eksik yapıldı, ikisinde de aynı yüzey atlandı:**
```
K6c/d   "taradım"        4 satır (üçü kodda)  →  7 satır daha vardı, BEŞİ BELGEDE
K4      "dört yüzey"     iki yüzey            →  hiç taranmamıştı (poz.kontrolle ölçüldü)
```

⇒ Bir *"tarandı"* beyanı **yüzey-başına** kanıt ister: o yüzeyde aynı aracın
**bilinen bir eşleşmeyi bulduğu** gösterilir. Aksi hâlde beyan, **aracın o yüzeye hiç
uğramamasıyla** aynı çıktıyı verir.

> ### **BEYAN UCUZLADIKÇA KANIT BİÇİMİ AĞIRLAŞMALIDIR.**

Ve *"sıfır"*un doğru raporlanma biçimi bir **sayı** değil, **okunmuş bir listedir**:

```
⛔  "işaretsiz bayat: 0"                      ← bir SAYI, teşhis değil
✅  "kalan atıflar tek tek okundu: hepsi ya
     F12 silinme kaydı, ya tarihsel ölçüm,
     ya CANLI rota"                           ← okunmuş bir LİSTE
```

📌 Ölçülmüş vaka (2026-08-26, kaza-dalgası kapanış raporu): kaba filtre **üç**
*"işaretsiz"* satır işaretledi; okunduğunda **üçü de meşru** çıktı (ikisi tarihsel
kayıt, biri canlı rota). **Filtre bir ön eleme, hüküm bir okuma.**


> **Bir kural eklediğin turda, o kuralı KENDİ diff'ine uygula — ayrı bir adım olarak.**
> "Bu kuralı ihlal eden bir şey bu diff'te var mı?" sorusu, kuralı yazdıktan sonra sorulmalı
> ve cevabı bir **ölçüm** olmalı.

Bu, `code-reviewer`'ın yerini almaz — yukarıdaki vakaların **hepsinde** o yakaladı ve
yakalamaya devam edecek. Ama
yazarın kendi turunda sormadığı soruyu review'a havale etmek, o adımı **zorunlu** kılar; ve
review'ın koşmadığı bir turda kural sessizce ihlal edilmiş olarak kalır.

**Ama satır numarası da bir sayıdır — yanına grep'lenebilir bir dayanak yaz.**

T-113'te bir atıf **aynı tur içinde** bayatladı: seed'e `spec.ts:74,:77,:84-85` yazıldı, ben aynı
dosyanın başlığındaki yorumu düzenledim, Prettier yeniden biçimlendirdi ve assertion'lar 99, 102,
109-110'a kaydı. Atıf hâlâ oradaydı ve artık yanlış yeri gösteriyordu — kimse kod değiştirmemişti.

Bu, "dokümanda sayı yazma" kuralının atıflara uygulanmış hâli. İkisi çelişmez, birleşir:

- ❌ `05-grid-column-alignment.spec.ts:74` (tek başına numara — biçimlendirme bile kırar)
- ✅ `05-grid-column-alignment.spec.ts`, `toContainText('₺100')` assertion'ı — istersen numarayı
  da ekle, ama **bulunmayı sağlayan token olsun**

Yani: **numara yazarken ölçmeye zorlar, token bulmayı sürdürür.** İkisini birlikte yaz.

### BİLEŞİMSEL FAIL-OPEN — her parça masum, boşluk BİLEŞİMDE (ZORUNLU)

> **Her adımı yerel olarak DOĞRU olan bir dizi, bileşiminde AÇIK üretebilir.**
> **Hiçbir bileşen "hatalı" davranmaz; boşluk yalnız BİRLİKTE bakınca görünür.**

Ölçülmüş vaka (2026-08-25, `Dalga-M` `S2`) — üç masum adım:

```
1  @RequireCapability eklendi        ✅ doğru iş
2  @Roles kaldırıldı                 ✅ doğru iş (rota başına tek mekanizma)
3  @UseGuards'a CapabilityGuard      ⛔ UNUTULDU  ← tek eksik
─────────────────────────────────────────────────────────────
   CapabilityGuard  hiç koşmaz    → yetenek metadata'sı YOK SAYILIR
   RolesGuard       requiredRoles yok → `return true`
   ⇒ rota HER kimliği doğrulanmış kullanıcıya AÇIK
```

⚠️ **Ve iki guard da kendi açısından DOĞRU davranıyor.** `RolesGuard`'ın
*"`@Roles` yoksa geç"* dalı yıllardır doğru; `CapabilityGuard`'ın *"yetenek yoksa
geç"* dalı bilinçli. Kusur **hiçbirinde değil, aralarında.**

**Aile:** `T-273` (cascade — grep'e görünmeyen yazma yolu) · `T-254` (boş kapsam →
`[]`) aynı sınıftan. `S2`'nin farkı: **henüz hiç yaşanmadan** yakalandı — `W1`'de
gerçekleşecekti, review onu bir **kapıya** çevirdi.

### Bir doğrulamanın "çalıştığı" sanılması, girdinin ona hiç ULAŞMAMASINDAN gelebilir (ZORUNLU)

"Mekanizma var, ona giden yol yok" sınıfının **doğrulama tarafındaki** hâli — ve daha sinsi,
çünkü burada mekanizma yalnız ölü değil, **sağlıklı görünüyor.**

T-107 adım 2'de ölçüldü: `off-invoice`'un *"Amount değeri pozitif olmalıdır"* kuralı yıllardır
kodda duruyor. Ama `raw: true` öncesinde gerçek bir `0`, `||` alias zinciri tarafından **zaten
düşürülüyordu** — yani kurala hiç `0` ulaşmıyordu. Kural hiç ateşlemedi, hiç kırmızıya
dönmedi, ve tam bu yüzden **hiç sorgulanmadı**.

`pickCell` sıfırları oraya vardırınca kural **ilk kez gerçekten tetiklenecek**. Yanlışsa,
bugüne kadar görünmeyen bir ret üretmeye başlayacak ([[T-124]]).

> **Bir kuralın doğru olduğunu, kırmızıya dönmemesinden çıkarma.** Önce sor: o kuralın
> reddedeceği girdi ona **ulaşıyor mu**? Ulaşmıyorsa kural test edilmemiştir — ne doğru
> olduğu bilinir, ne yanlış.

Pratik: bir doğrulama kuralı bulduğunda, onu **kasten tetikle**. Tetiklenemiyorsa kuralın
kendisinden önce **yolunu** araştır. Ve bir girdi yolunu genişleten her değişiklik (bir bayrak,
bir parser, bir tip gevşemesi) uykudaki kuralları **uyandırır** — o değişikliğin kapsamına
"hangi kurallar ilk kez ateşleyecek?" sorusu dahildir.

> **KAPSAM, kusurun SINIFIYLA tanımlanır — bulunduğu ilk vakanın YAZIMIYLA değil.**

Ölçülmüş vaka (2026-08-14, gri→yeşil sızıntısı): kusur `ragStatus: plan.ragStatus || 'GREEN'`
olarak bulundu. Kapsam **altı şekilde** tarandı — `|| 'GREEN'` · `?? 'GREEN'` ·
`|| RagStatus.*` · düz varsayılan · `= 'GREEN'` · frontend — ve *"tam olarak iki nokta,
`T-093` deseni tekrarlamadı"* diye raporlandı.

**Altı şeklin hepsi bir `GREEN` VARSAYILANININ yazımıydı.** Kusur sınıfı ise daha geniş:
**"rengin yokluğu bir renge çöküyor."** Bir tur sonra `frontend-engineer` buldu:

```
GrandTotals.tsx:25   if (!ragStatus || ragStatus === 'AMBER') → '• RİSKLİ'
```

Aynı sınıf, **ters yön** — `null` bir güvence yerine bir **iş yargısına** çöküyor. O
literalin dışında, o sınıfın içinde.

> Altı şekli aramak, aramanın **derinliğini** artırdı ve **evrenini** hiç sorgulamadı.
> Bir literalin altı yazımı hâlâ bir literaldir.

**Pratik:** kapsam taramasına başlamadan önce kusuru **sınıf olarak bir cümlede yaz**, ve
şekilleri o cümleden türet — bulduğun koddan değil. *"`|| 'GREEN'` nerede"* dar bir soru;
*"renk yokluğu nerede bir renge dönüşüyor"* doğru soru, ve `AMBER`'i de, `return null`'ı da,
Excel'e yazılan ham değeri de kapsar.

> **Bir kusur sınıfı bulduğun dosyada, aynı sınıfın diğer örneklerini ara.
> Kusurlar dosya bazlı kümelenir.**

> **Bir kalıbı ararken her iki ucunu ara: neye yazıldığını VE neyin okunduğunu.**
> Tek uçtan arama kalıbın yarısını görünmez bırakır.

**Ve bir import taraması, göreli yolun HER yazımını kapsamalıdır (ZORUNLU).**

```
'./x'  ·  '../x'  ·  '../../x'  ·  alias'lar
```

Hepsi **aynı hedefi** gösterir, ve tek yazım aranırsa tüketici sayısı **sistematik olarak
DÜŞÜK** çıkar. Bu, kapsam kuralının (*sınıfla ara, literalle değil*) **yol tarafındaki**
hâli.

> **Doğru desen: DİZİN ADIYLA ara, göreli önekle değil.**

> ### ⛔ VE BU DESEN BİR ARACA BAĞLIDIR — HAM GREP HÜKÜM ÜRETMEZ (ZORUNLU)
>
> ```bash
> bash scripts/guards/find-importers.sh <dizin-adı> [arama-kökü ...]
> ```
>
> **`"tüketici yok"` / `"import yok"` HÜKMÜ KANONİK AYRIŞTIRICIDAN gelir.**
> **Ham `grep` yalnız bir ÖN-TARAMA üretir.**
>
> Araç üç şeyi birden yapar ve **ham `grep` üçünü de kaçırır**:
> göreli yolun **her yazımını** kapsar (`./x` · `../x` · `../../x` · barrel `…/index`) ·
> `import … from '…'` **şeklini** şart koşar, yani **yorumdaki bir yol atfı EŞLEŞMEZ** ·
> **tam listeyi** basar (`§7.1`: *"bir sayı, eşleşmeleri örneklenmeden raporlanamaz"* —
> liste **zaten örnektir**).
>
> ⚠️ **Ölçülmüş vaka (2026-08-24):** Team Lead *"`capabilities.ts`'in tüketicisi var mı"*
> sorusunu ham `grep` ile sordu, bir **JSDoc satırına** düştü ve *"import ediyor"* sandı.
> Araç aynı soruya **`0` tüketici** diyor — ve ayrımı bir **fixture'lı self-test** ile
> kanıtlıyor.
>
> 📌 **Ve bu bir DİSİPLİN açığı değil, bir ARAÇ-YÖNLENDİRME açığıydı:** araç **zaten
> vardı**, kural onu **adlandırmıyordu**. Aynı sınıf bir oturumda **üç kez** tekrarladı
> (`stderr` kapsamayan tarama · satır sonunu aşamayan desen · yorum kirliliği) ve
> **üçü de yanlış-negatif** yönündeydi.
>
> > **Üçüncü tekrar, kuralın KİŞİYE değil ALETE bağlanma anıdır** — `route-scope.awk`'ın
> > doğuş hikâyesinin aynısı: rota sorusunun kanonik ayrıştırıcısı var, ve **ham `grep`'e
> > kimse düşmüyor.**

Ölçülmüş vaka (2026-08-14, iki farklı turda): `entities/index.ts`'in tüketicisi arandı.

| tur | desen | bulunan | gerçek |
|---|---|---|---|
| 1 | `from './entities'` | **1** | — |
| 2 | `entities'` (dizin adı) | **3** | `database.module` `'./entities'` · `typeorm.config` `'../database/entities'` · `master-data.module` `'../../database/entities'` |

Birinci ölçüm bir **kaldırma kararının** girdisiydi: *"tek tüketici, kaldırması dar"* —
oysa tüketicilerden biri **kanonik olacak dosyanın kendisiydi**.

📌 `decimal` (entity dili) ↔ `numeric` (katalog dili) tuzağının kardeşi: **aynı kavram, iki
yazım.** Orada iki farklı yüzeyin sözlüğü ayrışıyordu; burada **aynı yüzeyin** kendi
içindeki göreli konum.

**Ve iki uç da yetmeyebilir — kapsamı DOSYA TİPİYLE değil, YAZAN HER YOLLA tanımla
(ZORUNLU).**

T-163'te bir değer **üç** yerde tanımlıydı ve üçü de **sırayla**, her biri bir öncekinin
düzeltmesinden **sonra** bulundu:

| # | yer | nasıl bulundu |
|---|---|---|
| 1 | `migration` | task'ın kendisi |
| 2 | `seeds/kpi.seed.ts` (CLI, idempotent upsert) | `data-engineer` |
| 3 | **`kpi.service.ts` `seedDefaults()`** | `code-reviewer` |

Üçüncüsü diğer ikisinden **tür olarak** farklıydı: bir seed dosyası değil, **canlı bir HTTP
rotası** (`@Roles(ADMIN)`), ve upsert alan kümesi değeri **üzerine yazıyordu**. Düzeltilmiş
bir tenant'ta tek bir admin çağrısı ADR'yi **sessizce geri alırdı**.

> **Arama sorusu *"bu dosya tipinde başka var mı"* değil, *"bu değeri YAZAN başka hangi yol
> var"* olmalı** — seed · migration · servis varsayılanı · test fixture'ı · e2e seed ·
> HTTP ucu · frontend sabiti. Tür listesi hafızadan değil, **kalıbın kendisiyle** taranır.

**Ve bir taramanın PENCERESİ girdi sınırına bağlanmalı, sabit bir uzunluğa değil (ZORUNLU).**

Aynı turda Team Lead iki listeyi karşılaştırırken sabit **1400 karakterlik** pencere
kullandı; bir girdinin penceresi bir sonrakine taştı ve **sahte bir fark** üretti. Sınır
"bir sonraki girdinin başlangıcı" yapılınca fark **sıfır** çıktı.

Bu, `migration-schema.sh`'ın `±10 satır` penceresiyle **aynı sınıf** — orada da sabit
pencere maskeleme üretmişti ve çözüm blok sınırı olmuştu. Fark yön: orada **kusur
gizleniyordu**, burada **olmayan kusur üretildi**.

> **Sabit pencere iki yönde birden yanılır.** Pencereyi ölçtüğün şeyin doğal sınırına bağla.

T-091 bunun kanıtı: transformer'lı **hedef** alanları arandı (10 aday, 4 bozuk), transformer'sız
**kaynak** alanların biriktirilmesi aranmadı — `finance-reporting`'deki aynı kusur (iki canlı
GET rotası) o yüzden ağa takılmadı.

> **Kelime sınırlı sayım da bir gürültü ölçüsü olabilir. Yüksek sayı bir okuma gerekçesi
> değil; örnekleyip ANLAMI doğrula.**

Alt-string sayımının yanıltıcılığı bilinen bir tuzaktı (`\bRAG\b` = 0 iken `grep -c RAG` = 8;
`average`/`storage`/`leverage` içindeydi). Kelime sınırı onu kapatır — **ama anlamı
kapatmaz.**

Ölçüldü (BRD envanter turu): `Section_01`'de `grep -owci capability` → **15**. Sayıya bakarak
*"CBAC burada tartışılıyor"* denip bölüm okuma listesine alınacaktı. Örneklendi:

> *"a next-generation **solution** designed to address the diverse operational needs"* ·
> *"the platform **recognizes** that maturity is not binary"*

**İş anlamında "yetenek" — CBAC'ın `capability`'si değil.** Aynı kelime, farklı kavram.

> Sorun **yazımda değil, anlamda**. Kelime sınırı yazımı çözer; anlamı yalnız **örnekleme**
> çözer. Bir terim sayısına dayanarak karar veriyorsan (oku/atla, var/yok), **en az bir
> geçişi bağlamıyla oku.**

**Ve kelime sınırı gürültüyü keserken TÜREV BİÇİMLERİ de keser (ZORUNLU).**

TTM ölçümünde yaşandı: `grep -ow 'settlement'` → **16**, ve `apps/api/src/settlements/`
**modülünün kendisi bu sayının dışındaydı** — `-w` çoğulu eşleştirmez.

Sayı makul göründüğü için uyarı vermedi. (Aynı turdaki diğer hata — `grep -c | wc -l`'in
beş terim için de `501` vermesi — **anormal** olduğu için hemen yakalandı; bu ise
**normal göründüğü için** neredeyse geçiyordu.)

> **Kelime sınırı bir gürültü filtresidir, bir kapsam garantisi değil.** Çoğullar, ekli
> hâller ve bileşikler (`settlements`, `claiming`, `recognition` ↔ `recognized`) ayrıca
> aranmalı — ya da gövde ile ara ve gürültüyü **örnekleyerek** ele.

- ❌ `grep -owc 'settlement'` tek başına → modül adını kaçırır
- ✅ gövde (`grep -oi 'settlement'`) + örnekleme, ya da her iki ölçümü de yaz

> **Bir ölçüm beklediğin sonucu verdiğinde, o sonucun BAŞKA bir açıklaması olup olmadığını sor.
> Özellikle sıfır, boş ve yokluk sonuçlarında — onların her zaman en az iki açıklaması vardır.**

T-095 bunun kanıtı: *"`budget_transaction_logs` 0 satır → `NOT NULL` bedelsiz"* ölçüldü. **Sayı
doğruydu, çıkarım yanlıştı.** Tablo boştu çünkü **hiç yazılamıyordu** — `created_by` iki kez
map'lenmiş, her INSERT `42701` veriyor, dört bütçe rotası 500 dönüyor. "Neden 0?" sorulmadı.

Diğer ölçüm hataları yanlış cevap verir ya da hiçbir şey ölçmez; bu **doğru sayıyı verip yanlış
sonuç çıkarttırır** — ve o yüzden en zor fark edilenidir.

> **Ve simetriği: bir satırın VARLIĞININ da en az iki açıklaması vardır.**

§7.1'in "neden 0?" maddesi yokluk için yazılmıştı. T-107 adım 2'de tersi yaşandı: bir alt-ajan
`main.customers`'da 63 satır `E2E-PW-UPLOAD-*` bulup **"pre-existing sızıntı"** diye raporladı,
ve Team Lead neredeyse bir task açıyordu. Ölçüm başka bir şey söyledi:

```
canlı: 0   ·   soft_silinmis: 63          ← hepsinde deleted_at dolu
DELETE /customers/:id -> customerRepository.softRemove(customer)
```

Temizlik **çalışmıştı**. Kalanlar öksüz değil, ürünün tasarladığı **mezar taşları**.

> **"Neden 0?" kadar "neden var?" da sorulmalı.** Bir satırın varlığı sızıntı da olabilir,
> tasarım da; sayı ikisini ayırt etmez.

⚠️ Ve bu, bu oturumdaki ölçüm hatalarının ilk **fazla ölçüm** vakasıydı — öncekilerin hepsi
eksik ölçümdü (bir kusur görülmedi). Yön farkı önemli: eksik ölçüm bir kusuru kaçırır, fazla
ölçüm **olmayan bir kusur için iş üretir** ve gerçek kusurların önüne geçer.

### "Güvenlik" gerekçeleri en az sorgulananlardır (ZORUNLU)

İki kez ölçülüp çürütüldü:

| gerekçe | gerçek |
|---|---|
| *"`defval: false` prototype pollution'ı önlemek için"* | `defval`'ın ilgisi yok — SheetJS `__proto__` başlığını kendi işliyor (`__proto___NaN`); **iki değerde de** kirlenme yok |

Bu gerekçe bir bayrağa dokunmayı **engelliyordu** — ve o bayrak iki uyuyan kusuru perdeliyordu.

> **`security`, `safety`, `pollution`, `injection`, `sanitize` geçen bir gerekçe gördüğünde,
> ölçülmüş mü diye sor.** Bu kelimeler tartışmayı kapatır; kapattıkları için de en az
> doğrulananlardır.

> **Ve değer bir yerel değişkenden geçebilir. Doğrudan kalıbı aramak yetmez.**

T-093'te bu bir kademe daha derinleşti: `+= <entity alanı>` araması 9 nokta buldu, üç noktayı
kaçırdı — çünkü orada değer önce bir yerele alınıyordu:

```ts
const spend = pmv.calculatedSpend || 0;   // string
totalSpend += spend;                       // desenin eşleşmediği biriktirme
```

Review 3 nokta demişti, tarama 12 buldu. Aradaki fark aramanın şeklinden geliyordu, kusurun
yaygınlığından değil.

`spend-validation.service.ts` bunun kanıtı: sıfır testi vardı ve **dört** kusur sınıfı taşıyordu
(string min/max karşılaştırması, `Number.isInteger(string)`, `v !== 0` tip uyuşmazlığı, ve iki
ayrı akümülatörde string birleştirme). T-089 birini düzeltirken ikinci akümülatörü kaçırdı —
kapsam sınırı makuldü (`validateCombinations` vs `checkBudgetAvailability` ayrı fonksiyonlar),
ama **dosyayı taramak** onu ilk turda bulurdu.

Test edilmeyen dosya kusur biriktirir; ve biriktirdiği kusurlar birbirine benzer.



## AİLE — ŞART · SINIR · KAYIT

### KARAR VERİLDİ ≠ KARAR KODA İNDİ (ZORUNLU)

> **Rol-küme kararı veren her `Z`-kaydı, HARİTAYA İNİŞ task'ını TETİKLEYİCİSİYLE
> taşır.** Karar defterinde bir hüküm, koda inmedikçe **yürürlükte değildir** —
> ve arada geçen her tur onu **yürürlükte sanar**.

`Z25`'in koşul rejimi (`KOŞUL · TETİKLEYEN · DURUM`) **karar defteri için de**
geçerli; türev-belge kuralının **harita** hâli.

**Üç ölçülmüş vaka (2026-08-24/25):**

| kayıt | karar | koda iniş |
|---|---|---|
| `Z35` `MODES_WRITE` bölünmesi | 2026-08-24 | **`B3b-1 ADIM 0`** — bir tur sonra |
| `Z30 H8` `UNRESTRICTED` terfisi | kayıtlı | `B1` kapısı **eksik** çıktı (`code-reviewer`) |
| `SHARED_READ` kısmi kararı | 2026-08-25 | **`W4a ADIM 0`** — göç DURDU, harita boştu |

⚠️ Üçüncüsünün bedeli ölçüldü: karar *"16 rota açılır"* diyordu,
`ROLE_CAPABILITIES`'te hücre **hiçbir rolde** değildi. Göç yapılsaydı 16 rota
**hiçbir rol tarafından alınmaz**, `403` verirdi — **tam kilitlenme**.

**Pratik:** hüküm yazılırken üçüncü satır:
```
KARAR       hücre X = {roller}
HARİTA      ROLE_CAPABILITIES'e YAZILDI MI?        ← BU SATIR
TETİKLEYİCİ hangi tur yazacak
```

### HÜCRE KÜMESİ ile ROTA KÜMELERİ BİREBİR DEĞİLSE DALGA DUR'A DÜŞER (ZORUNLU)

> **Mekanik göç, `hücre verir` sütununun sessizce kazanmasına izin veremez.**

`Faz A` haritasının **`union` kararlarından türeyen HER hücre**, göç anında ya
**genişleme** ya **daraltma** üretiyor — ölçülmüş genelleme:

```
MODES_WRITE    → H1 reddetti, Z35 BÖLDÜ
SHARED_WRITE   → 13/13 rotada davranış değişir (3'ünde DARALTMA)
kalan READ hücreleri → muhtemelen aynı
```

**Kural:** bir dalga başlamadan **rota-düzeyi** karşılaştırma yapılır:

```
her rota için:   mevcut @Roles  ==  hücrenin verdiği küme  ?
                 EVET → göçebilir
                 HAYIR → DUR, mekanik devam YASAK
```

📌 Bu **zaten fiilî davranış** (`W3`'te `GET /users`, `W4`'te `SHARED_WRITE`
böyle durdu) — ama **yazılı kural** olarak durur ki sekiz dalganın hiçbirinde
*"hücre verir"* sütunu **sessizce kazanmasın**.

⚠️ Ve fark **yönsüz**: genişleme de daraltma da `DUR` sebebidir. Daraltma
ayrıca `Z20` sınıfındandır — **istisna dalgasının işi**, mekanik dalganın değil.

### İÇERİK TAŞINIR, STATÜ ÇEVREDEN GELİR (ZORUNLU — belge taşıma)

> **Bir belge taşıması İÇERİĞİ taşır; STATÜ içeriğin İÇİNDE değil ÇEVRESİNDE
> yaşar — ve taşınmazsa SESSİZCE DÜŞER.**
> **Taşıma, statü beyanını da taşımak ZORUNDADIR.**

Ölçülmüş vaka (2026-08-25, `CLAUDE.md` bölmesi): `63` `(ZORUNLU)` kural
`docs/DISIPLIN.md`'ye taşındı. Üç kayıpsızlık ölçütü de **geçti** — içerik
(satır çoklu-kümesi: kayıp `0`) · yapı (başlık: kayıp `0`) · atıf (`63/63`
çözülüyor). Ve yine de:

```
CLAUDE.md:6   "Bu dosya tüm oturumlarda yüklenir. Talimatlar ZORUNLUDUR."
              → 3169 satırın 950'sini kapsıyor
§2.1 kaynak tablosu  →  DISIPLIN.md YOK
§0 oturum başı        →  DISIPLIN.md'den söz etmiyor
```

⇒ `63` bağlayıcı kural, onları **bağlayıcı kılan cümlenin** kapsamından çıktı —
çünkü o cümle kuralların **içinde değil, çevresinde** yaşıyordu.

📌 **Sınıf:** *"mekanizma var, ona giden üretim yolu yok"* — bu reponun sekiz
vakalık ailesi, belge tarafında.

### ⇒ DÖRDÜNCÜ ÖLÇÜT: SOĞUK BAŞLANGIÇ

Bir belge taşımasının kayıpsızlık ölçütleri **dörttür**:

```
1 İÇERİK   satır çoklu-kümesi — kaybolan içerik satırı 0
2 YAPI     başlık listesi birebir; yeni başlıklar YALNIZ yapısal
3 ATIF     her atıf hedefine varıyor          ← SICAK başlangıç testi
4 STATÜ    "soğuk başlayan bir ajan bu belgenin BAĞLAYICI olduğunu bilir mi?"
```

⚠️ **`3` ile `4` farklı okuyucuyu simüle eder ve biri diğerini KAPSAMAZ.**
Atıf-çözünürlüğü, belgeyi **zaten arayan** bir okuyucuyu varsayar; statü sorusu
**hiç duymamış** olanı. `CLAUDE.md` bölmesinde `1-3` geçti, `4` düştü — ve
`4`'ü soran bir ölçüt olmasaydı `63` kural **sessizce tavsiyeye** dönerdi.

**Pratik — taşıma turunun kabul satırı:**

```
STATÜ BEYANI  hedef belgenin bağlayıcılığı NEREDE yazılı        (kaynak tablosu?)
GİRİŞ NOKTASI hiç duymamış bir okuyucu oraya NASIL varır        (indeks? §0?)
```

### Bir SIRA şartı, AYRILABİLİRLİK şartı İÇERMEZ (ZORUNLU)

> **Bir sıra şartı (*"önce A, sonra B"*) bir ayrılabilirlik şartı İÇERMEZ.**
> **Deploy edilebilir bir ara durum isteniyorsa, A'nın AYRI BİR MEKANİZMAYA dayanması
> ayrıca şart koşulmalıdır.**

Ölçülmüş vaka (2026-08-23, `T-270`): ürün sahibi `A1`'i (*boş küme → `unavailable`*)
`A2`'den (*zarf modeline taşıma*) **önce** istedi, ve gerekçesi **fail-safe**'ti:

> *"`A1` önce inerse, `A2`'nin büyük taşıması sırasında dashboard asla `GREEN+0`
> gösteremez — taşıma yarıda kalsa bile **yalan söylemeyen bir ara durum** bırakır."*

Ajan **sırayı korudu** (önce yazdı, doğruladı). Ama kod tek fonksiyonda iç içe geçti:

```
hasData = envelopes.length > 0      ← A1'in MEKANİZMASI, A2'nin VERİ KAYNAĞIYLA tanımlı
```

Yani *"`A1` tek başına"* diye bir durum **hiç var olmadı**. Zorlama bir commit bölmesi,
**hiç yaşamamış ve hiç test edilmemiş** bir ara durumu commit tarihine **sahte kanıt**
olarak yazardı.

📌 **İstenen özellik elde edilmedi, ve bu bir başarı değil bir sağlayıcı yokluğudur** —
bugünkü maliyeti sıfır, çünkü deploy edilmiş ortam yok (`§1`). Ortam doğduğunda şart
yeniden anlam kazanır.

**Pratik — brief'e üç satır, ikisi yetmez:**

```
SIRA            A önce, B sonra
AYRILABİLİRLİK  A'nın mekanizması B'den BAĞIMSIZ olmalı     ← BU EKSİKTİ
KANIT           A tek başına derlenir ve testleri geçer
```

> ### ⛔ VE KURAL İKİ YÖNLÜDÜR — HAKEMİ TEK: ara durum KİME görünüyor (ZORUNLU)
>
> ```
> MAKİNEYE görünen ara durum      →  AYRILABİLİRLİK ister
>   (T-270: "A2 yarıda kalırsa dashboard yalan söylemesin" — deploy-edilebilirlik)
>
> KULLANICIYA görünen ara durum   →  AYRILAMAZLIK ister
>   (T-277: API kapanıp ekran açık kalırsa 403 SÜRPRİZİ — yarım düzeltme)
> ```
>
> **Aynı kural iki yönde zıt şey istiyor, ve ayrımı YALNIZCA ara durumun kime göründüğü
> belirliyor.**
>
> 📌 Ve `T-277` bir üçüncü satır ekliyor: **iki repoya dokunan bir düzeltmede SIRA da bir
> karardır** — `UI kapalı + API açık` savunulabilir bir ara durumdur (kullanıcı yolu
> kapalı, derinlik eksik); `API kapalı + UI açık` **tam olarak engellemek istenen şeydir**.
>
> ⚠️ **Deploy edilmiş ortam yokken bile sıra kayda geçer** — bugün teorik olan, ortam
> doğduğu gün şablon olur.

### Bir DUR listesi, değişikliğin geçtiği HER SINIRI saymalıdır (ZORUNLU)

> **Bir `DUR` koşulu listesi, değişikliğin geçtiği HER sınırı saymalıdır.**
> **Şema · API · tel protokolü · dosya biçimi — her sınır bir sözleşmedir, ve tek repoda
> ölçülen bir kapı, sınırın öbür tarafını görmez.**

Ölçülmüş vaka (2026-08-13, `B` dalgası `R2a`): rol enum'unun **değerleri** Türkçeye taşındı
(`ADMIN = 'YÖNETİCİ'`). Enum **key**'leri korunduğu için backend derlendi, testler geçti,
altı guard yeşil verdi. Ama değer bir **tel protokolüdür**:

```
backend   UserRole.ADMIN = 'YÖNETİCİ'
frontend  UserRole.ADMIN = 'ADMIN'            ← dokunulmadı

hasRole(): 'YÖNETİCİ' === 'ADMIN'          → false   (admin bypass'ı gitti)
           requiredRoles.includes(...)      → false   (her rol kapılı rota reddedildi)
```

**Ve hiçbir kapı görmedi:** backend `tsc` 0 · backend testleri 0 (frontend'i bilmez) ·
`guards` 0 · **frontend `type-check` 0** — çünkü `user.role as UserRole` cast'i tipi
susturuyor. Kırılma yalnız **çalışan üründe** ortaya çıkar.

⚠️ **Ve delegasyon tarafındaki ders daha keskin:** alt-ajan hatalı davranmadı. Brief'in
`DUR` listesinde *"çapraz-repo sözleşme kırılması"* **yoktu**, ve kapsam
*"ölü referans temizliği ayrı PR"* diye yazılmıştı — oysa asıl tehlike **silinen**
etiketler değil, **yeniden adlandırılan** etiketlerdi.

> Bir kapsamı *"temizlik"* diye adlandırmak, onu **ertelenebilir** ilan eder. Yeniden
> adlandırma bir temizlik değil, bir **sözleşme değişikliğidir**.

**Pratik — bir değişikliği delege etmeden önce sınırları say:**

| sınır | soru |
|---|---|
| şema | başka bir migration/entity bu tanıma yaslanıyor mu |
| **tel protokolü** | bu **değer** JWT/API/URL üzerinden geçiyor mu — öbür uçta kim karşılaştırıyor |
| dosya biçimi | bir içe/dışa aktarma bu biçimi okuyor/yazıyor mu |
| başka repo | aynı kavramın **ikinci bir tanımı** var mı (`grep` ile, hafızadan değil) |
| **serileştirme** | yanıtın **şekli** değişiyor mu — bir alan **düşüyor** mu? ⚠️ Bir alanın düşmesi bir **regresyon** da olabilir, bir **kusurun kapanması** da; ikisi aynı kırmızıyı verir |

Ve **görüntü ↔ tel ayrımını koru:** bir iş belgesinin Türkçe adlandırması (`K-2.6.4`'ün rol
kataloğu) bir **şema tanımı değildir**. `L2`'nin her yerinde kavramlar Türkçe yazılı
(`TAHAKKUK`, `GÖZLENEN`) ve **hiçbiri enum değeri olsun diye yazılmadı**. Bu, `K-2.2.7`'nin
renk/davranış ayrımının aynısı: **görüntü katmanı davranışa sızmaz.**

### Bir kuralın FAZ TABLOSU varsa, YÜRÜRLÜKTEKİ satır okunur (ZORUNLU)

> **Bir kural bir faz/geçiş tablosuna işaret ediyorsa, türetim HANGİ SATIRIN BUGÜN
> GEÇERLİ olduğunu ayrıca ölçer — kuralın SON satırı varsayılan DEĞİLDİR.**

Ölçülmüş vaka (2026-08-24, `Z30 H1`): `ROLE_CAPABILITIES` haritası `PLANNER`'a içe
aktarma yetkisi vermişti. Kaynak `K-2.6.14`, ve kuralın **faz tablosu** var:

```
| Bugün                  | yalnız finans + yönetici |   ← YÜRÜRLÜKTEKİ
| Eşleştirme geldiğinde  | + planlamacı             |   ← HEDEF
```

Harita **hedef** satırı okumuş, **yürürlükteki** satırı okumamıştı. Yani kural doğru
alıntılanmış, **yanlış zamandan** alıntılanmıştı.

⚠️ **Ve tehlikesi ölçekte:** aynı hata bir **türetim algoritmasına** girerse (`fixpoint`,
toplu göç) tek bir rotada değil, **tamamında** tekrarlanır.

📌 Bu, `§`'nin *"bir ölçümün geçerliliği KOŞULLARINA bağlıdır"* kuralının **kaynak
tarafındaki** hâli: orada ölçümün koşulu yazılmıyordu, burada **kaynağın** koşulu
okunmuyor.

**Pratik:** bir `L2` kuralını bir karara dayanak yaparken sor — *"bu kuralın bir faz/geçiş
tablosu var mı, ve bugün hangi satırdayız?"* Cevap bir **tarih** ya da bir **sağlayıcı**
ise, `§ ŞARTIN SAĞLAYICISI` kuralı da devreye girer.

### Karşılanamayan bir ÖLÇÜT revize edilir — uydurma veriyle karşılanmaz (ZORUNLU)

> **Bir kabul ölçütü karşılanamıyorsa iki sonuç doğar: iş kilitlenir ya da ölçüt uydurma
> veriyle karşılanır. İkincisi sessizdir.**
>
> **Karşılanamayan bir ölçüt revize edilir — gerekçesiyle. Ölçütü korumak için veri
> uydurmak, ölçütün koruduğu şeyi yok eder.**

Ölçülmüş vaka (2026-08-14, `B` dalgası): `Done` şartı *"seed **5/5**"*di. Beşincisi (rol
ailesi) **yazılamıyordu** — `capabilities`'in içeriği açık bir karara bağlı (`0056-K3`).
Şart olduğu gibi bırakılsaydı iki yol vardı: dalga **hiç kapanmaz**, ya da kapanmak için
**uydurma yetenek satırları** yazılırdı. Şart `4.5/5`'e revize edildi, **gerekçesi ve
adresi yazılarak**.

⚠️ Bu `§2.5`'in **tersinden gelen** hâli. `§2.5` *"boşluğu uydurma"* der ve failin
tembelliğini varsayar; burada fail **dikkatlidir** ve tam da **ölçütü karşılamak için**
uydurur. Yani baskı kuraldan değil, **kuralın ölçüsünden** gelir.

**Pratik:** bir ölçüt karşılanamıyorsa sor — *"karşılanamıyor mu, yoksa henüz mü?"*
Birincisi ölçütün yanlış olduğunu, ikincisi bir **adres** gerektiğini gösterir. İkisinde de
cevap ölçütü **yazılı olarak** değiştirmektir; sessizce yaklaşmak ya da veriyle doldurmak
değil.

### Bir şartın SAĞLAYICISI yoksa, şart bir erteleme değil bir KİLİTTİR (ZORUNLU)

> **Bir şartın sağlayıcısı yoksa, şart bir erteleme değil bir kilittir — ve kilit
> görünmez.**

Yukarıdaki kural *"karşılanamayan bir ölçüt"*ü konu alıyor ve failin **ölçütü zorlamasını**
bekliyor. Bu **daha sessiz** bir vaka: ölçüt zorlanmıyor, **kimse ona bakmıyor**. Çünkü
*"ölçüm bekliyor"* meşru görünür — ve *"bu şart karşılanabilir mi?"* sorusu hiç sorulmaz.

**Üç ölçülmüş vaka, ve üçü aynı şekil:**

| kalem | şart | sağlayıcı |
|---|---|---|
| `B4` (onay bekleme dağılımı) | *"ölçüm sonrası"* | örneklem **0** — yetersiz değil, **yok** |
| `report-only` (`0073` Soru 3) | *"envanter fiili trafikte doğrulanır"* | deploy edilmiş ortam **yok** → fiili trafik yok |
| `T-028c` bayrağı (`T-235`) | *"prod/UAT'de backfill doğrulanana kadar"* | prod/UAT **yok** |

Üçü de **doğru yazılmış**, üçü de **var olmayan bir ortama adresli.** Sonuncusu
`2026-07-28`'den beri kilitli ve kimse fark etmedi — üstelik `K-2.6.9` sapmayı
*"ölçülmüş sapma"* diye **kaydetmişti**; kayıtta olmayan şey **kapanamama sebebiydi.**

⚠️ **Ve bir kayıt, kilidi gizleyebilir:** *"ölçülmüş sapma"* etiketi sorunun
**bilindiğini** söyler, **kapanabileceğini** değil. Bilinen bir sapma, adresi olmayan
bir sapmadan daha az sorgulanır.

**Pratik — bir şart yazarken üçüncü bir satır ekle:**

```
ŞART        prod/UAT'de backfill doğrulanana kadar
SAĞLAYICI   prod/UAT ortamı            ← BU SATIR
DURUM       ⛔ bugün YOK → bu bir kilit, bir erteleme değil
```

Sağlayıcı bugün yoksa şart **kilit** diye işaretlenir ve bir **task'a** bağlanır
(`§7.1`: *"bilinen eksiklik TODO ile değil, TASK ile kaydedilir"*). Sağlayıcının ne
zaman doğacağı bilinmiyorsa, şart **var olan bir ölçüye** revize edilir.

### Bir KABUL LİSTESİ, değişikliğin BOZABİLECEĞİNİ de saymalıdır (ZORUNLU)

> **Bir kabul listesi, değişikliğin BOZABİLECEĞİ her yeteneği saymalıdır — yalnız
> EKLEDİĞİ her yeteneği değil.**

Ölçülmüş vaka (2026-08-14, `B` dalgası): dalga `kabul-1`…`kabul-8a` ile kapandı. Şema
değişti, iş kuralları ihlal-üretilerek sınandı, migration iki ortamda geri alınıp yeniden
uygulandı, çapraz-repo enum sözleşmesi pinlendi. **Ama "uygulama hâlâ ayağa kalkıyor mu"
hiçbir kriterde yoktu** — ve iki e2e dosyası bootstrap'ta çöküyordu
(`Entity metadata for ApprovalRequest#approvalPolicy was not found`).

⚠️ **Ve eksikliği kimse aramadı — başka bir task'ın YAN BULGUSU ortaya çıkardı.** Yani
liste kendi boşluğunu göstermedi; boşluk tesadüfen görüldü.

📌 Bu, aynı dalganın **ikinci** aynı-şekilli eksikliğidir: `DUR` koşulları arasında da
*"çapraz-repo sözleşme kırılması"* yoktu (rol enum'unun değerleri değişti, dört kapı yeşil
kaldı, her rol kapılı rota kapandı). **İki eksiklik, tek şekil: liste EKLEMEYİ sayıyor,
BOZMAYI saymıyor.**

**Pratik — kabul listesi yazarken iki sütun:**

| ne EKLENDİ | ne BOZULABİLİR |
|---|---|
| yeni tablo/kolon/kural | uygulama ayağa kalkıyor mu (bootstrap · e2e) |
| yeni enum değeri | o değeri **karşılaştıran** her uç (tel protokolü, öbür repo) |
| kaldırılan kolon | onu **okuyan** her yol (DTO · view · export · rapor) |
| yeni kısıt | o kısıtın **reddedeceği** meşru veri var mı |

Ve sor: *"bu değişiklik dünden beri çalışan neyi durdurabilir?"* — cevabı bir **kabul
satırı** olmalı, bir umut değil.

### Bilinen eksiklik TODO ile değil, TASK ile kaydedilir (ZORUNLU)

**Bir yorum kodu okuyanı bilgilendirir; bir task işi yapılacaklar listesine sokar.** İkisi
farklı işlevdir ve **birincisi ikincisinin yerini tutmaz.**

T-101'de bulundu: `budget-threshold.service.ts`, `invalidateCache` üzerinde
*"TODO: BudgetAlertConfiguration güncelleyen admin endpoint eklenirse buna bağlanmalı"*
diyordu. Yani **eşiklerin üretimde konfigüre edilemediği biliniyordu** — yazılmıştı, ve
kimse task açmadığı için hiç yapılmadı. §2.3'ün ihlali o TODO'nun içinde bekliyordu.

Sebep basit: **TODO okunmak için beklemek zorundadır.** Kimse o dosyayı açmazsa hiç görünmez.
Task listeye girer, sprint planında karşına çıkar, backlog taramasında sayılır.

Ve §7.1'in kardeşi: **yorum hiçbir zaman kırmızıya dönmez** — burada kusur tarafında değil,
**eksiklik** tarafında.

> Bir eksikliği fark ettin ve şimdi yapmayacaksın → **task aç.** Yoruma yazmak, onu
> unutmanın düzenli görünen hâlidir.

### Bir Z-KAYDINI kapatan tur, TÜREV BELGELERİ de yazar (ZORUNLU)

> **Bir `Z`-kaydını kapatan tur, kaydın *"etkilenen türev belgeler"* satırını yazar —
> `[belge: güncellendi | etkilenmedi]`.**
> **Statü taşıyan bir belgeyi hiçbir turun yükümlülüğü yapmamak, onu bayatlamaya
> mahkûm etmektir.**

Bu, `§4.2`'nin *"`improved` satırını KİM düşürecek"* dersinin **belge tarafıdır**: orada
`11` iyileşme birikmişti çünkü kural *"sonra gelir"* diyordu ama **hangi turun işi olduğu
yazılı değildi**. Aynı boşluk statü belgelerinde daha sessizdir — bir ratchet bayatlayınca
kırmızıya döner, bir **statü satırı hiçbir zaman dönmez**.

Ölçülmüş vaka (2026-08-24): `docs/contracts/SYSTEM_INVARIANTS.md`'nin `Status:` satırları
`2026-08-10` fotoğrafıydı; aradaki `Z21`/`Z24`/`K-2.2.3`/`ADR 0012` kararlarının **hiçbiri**
işlenmemişti. Kararlar doğru verilmişti, kayıtlar doğru yazılmıştı — **türev belge kimsenin
işi değildi.**

**Pratik — kapanış satırına üçüncü alan:**

```
KAPATTIKLARI       Z21-3 koşulu karşılandı
TÜREV BELGELER     SYSTEM_INVARIANTS.md: güncellendi
                   EK_E: etkilenmedi                    ← "etkilenmedi" de BİR CEVAPTIR
```

⚠️ *"Etkilenmedi"* yazmak bir formalite değil, bir **ölçüm beyanıdır** — boş bırakmak ise
sorunun sorulmadığını gösterir, ve bu ikisi bir sonraki okuyucu için **aynı görünmemelidir**.


## AİLE — SAYI · LİSTE · KANIT

### MEKANİK olarak türetilmiş bir değer, GEREKÇE değildir (ZORUNLU)

> **`union` asla bir gerekçe değildir.**
> **Bir kümeyi mekanik olarak hesaplamak, o kümenin DOĞRU olduğunu göstermez —
> yalnız nasıl elde edildiğini gösterir.**

Ölçülmüş vaka (2026-08-21, `Z18`): `ADIM 3`'ün üç `READ` hücresinde yetenek→rol
union'ı **`5` rolün `5`'ine** çöktü. *"Union böyle diyor, ve okuma zaten zararsız"*
kabul edilebilirdi — kapsam katmanı altta daraltıyor.

**Reddedildi, ve gerekçesi bugünkü erişim değil EMSAL:**

> **Ürün sahibi:** *"Çöküşün gerçek maliyeti bugünkü erişim değil, o emsal. **'Union'la
> 5/5 olsun, zararsız' kabul edilirse, aynı tembellik `WRITE`/`MANAGE` hücrelerinde
> tekrarlar.**"*

📌 **Kabul edilen şey bir KÜME değil, bir YÖNTEMdir:** *"union ne diyorsa o."* O yöntem
`READ`'de görece zararsız, `WRITE`'da değil — ve yöntem bir kez kabul edilince
uygulandığı yeri sormaz.

**Genel biçim — `union` yalnız bir örnek:**

| mekanik değer | *"gerekçe"* diye kullanılışı | neden değil |
|---|---|---|
| `union` / birleşim | *"kümeler birleşti, sonuç bu"* | hangi elemanın **neden** girdiğini söylemez |
| ortalama / medyan | *"eşik buradan çıktı"* | dağılımın kuyruğunu saklar |
| `max` / `min` | *"en katısını aldık"* | neden **o** boyutun bağlayıcı olduğunu söylemez |
| baseline | *"öncekinden az"* | **sınıf kırılımını** vermez |

⚠️ Sonuncusu bu dosyada zaten ayrı bir kural: *"bir TOPLAMIN azalması, bir SINIFIN
girmediğinin kanıtı değildir."* Aynı ailenin üyesi.

**Pratik:** mekanik bir değer bir karara dayanak yapılıyorsa, **her elemanı için ayrı
bir cümle** yazılabilmeli. Yazılamıyorsa değer bir **girdi**dir, karar değil.

- Yetersiz: *"`SHARED_READ` = 5 rol, union'dan"*
- Yeterli: *"`SHARED_READ` = 5 rol; `READONLY` şu route yüzünden, ve o route bu hücrede
  **olmamalı** — taksonomi düzeltilir"*

### Bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir (ZORUNLU)

> **Bir toplamın azalması, bir sınıfın girmediğinin kanıtı değildir.**

`mode-split` guard'ı bunu şöyle yazıyor: *"sayı-baseline 'biri düştü, biri girdi' gerilemesini
görmez."* O ders bir **guard tasarımı** için yazılmıştı. Aynı körlük bir **savunmanın içinde**
tekrarlandı — ve orada guard yoktu, yalnız bir cümle vardı.

Ölçülmüş vaka (2026-08-13, `B` dalgası): `migration:generate` boş çıkmadı. Savunma:
*"repo çapında önceden var olan drift; taban 1174 satırdı, benimkinden sonra **658** — yani
**azaldı**."* Sayılar doğruydu. Ama toplam düşerken **yeni bir sınıf girmişti**:

```
düşürülen CHECK kısıtı        14  →  12'si YENİ (bu dalganın indirdiği iş kuralları)
düşürülen bileşik FK           9  →  9'u da YENİ, ve up()'ta geri eklenmiyor
NULLS NOT DISTINCT             2  →  0   (joker tekilliği sessizce düz UNIQUE'e düşüyor)
```

Yani *"azaldı"* doğruydu **ve** *"yeni sapma yok"* yanlıştı. İkisi aynı ölçümden çıkarılamaz.

**Kural:** bir toplamı taban olarak kullanan her savunma, **sınıf kırılımını** da vermek
zorundadır. *"Öncekinden az"* bir güvence değildir; güvence **"şu sınıflardan hiçbiri yeni
değil"**dir, ve o cümle ancak sınıflar sayıldıktan sonra yazılabilir.

### Bir yazma işleminin DÖNÜŞ DEĞERİ, yazdığının kanıtı değildir (ZORUNLU)

> **Bir yazma işleminin dönüş değeri, yazdığının kanıtı değildir — DELTAYI ölç.**

Ölçülmüş vaka (2026-08-14, `B` dalgası seed'leri): üç seed dosyası
`result.identifiers.length` ile *"N inserted"* basıyordu. `.orIgnore()` ile yazılan bir
`INSERT`'te o alan **girdi** satırlarını sayar, gerçekte yazılanı değil. Ölçüm: ikinci
koşumda `identifiers.length = 3`, `raw.length = 0`, **DB deltası 0** — log *"3 inserted"*
diyordu ve **hiçbir satır girmemişti**.

Bu, `§7.1`'in *"rapor bir teslimat kanıtı değildir"* ailesinin üyesi, ama farklı bir
failden: burada **makine** yanlış rapor veriyor, bir ajan ya da insan değil. Ve o yüzden
daha az sorgulanır — bir sayının kaynağı bir kütüphane çağrısıysa doğru sanılır.

**Pratik:** bir yazmanın sonucunu `RETURNING`'den (`raw`) ya da **önce/sonra sayımından**
al. Ve `.orIgnore()` / `ON CONFLICT DO NOTHING` / `upsert` kullanan her yolda bu soruyu
**ayrıca** sor — o kalıplar tam olarak "yazmadım" ile "yazdım"ı aynı dönüş değerinde
birleştirir.

### Boş gelen bir çıktı, BEKLENEN içerikle doldurulamaz (ZORUNLU)

> **Bir raporun beklenen ŞEKLİNİ bilmek, onun İÇERİĞİNİ bilmek değildir.**
>
> **Boş gelen bir çıktı, beklenen içerikle doldurulamaz — en makul tahmin bile
> ölçülmemiş bir iddiadır, ve bir sonraki turda ölçülmüş sayılır.**

Ölçülmüş vaka (2026-08-14, `T-221`): bir ajan takıldı ve **hiçbir rapor üretmedi**. Rapor
boş geldi, ve okuyan tarafta beklenen içerikle **dolduruldu** — *"22 kolon · hepsi
`Alan A` · `MoneyDecimalTransformer` şablonu · `BudgetReservation` 3 kolon"*. Ölçüm:

| atfedilen | gerçek |
|---|---|
| 22 kolon düzeltildi | diff **44** transformer satırı ekliyor, 56 → 1 |
| `BudgetReservation` 3 kolon | **1** (`reserved_amount`, entity ve katalog aynı fikirde) |
| `MoneyDecimalTransformer` | repoda **böyle bir sınıf yok** |
| `T-225`'e not düşüldü | not **ulaşmadı**, entity'ye dokunulmamış |

⚠️ **Ve mekanizması öğretici:** boşluk **tembellikten** doldurulmadı — **brief'i yazan
taraf cevabın şeklini biliyordu.** Bilmek ile ölçmek arasındaki fark tam burada.

📌 Bu `§2.5`'in en saf hâli: **boşluğu makul bir içerikle doldurmak.** Ve `§2.4`'ün ters
yönü: orada *"varsayma, sor"* deniyor; burada varsayım **bir onaya** dönüşüyordu — kabul
edilseydi `22 kolon` bir sonraki turda *"ölçüldü"* diye taşınacaktı.

**Pratik:** bir çıktı boş, kesik ya da eksik geldiğinde tek meşru cevap **"göremiyorum,
paylaş"**tır. Beklenen şekli yazmak bir hatırlatma olabilir — ama **sonuç olarak
kaydedilemez.**

### ⇒ VE ÖLÇÜM TARAFINDA AYNI ŞEKİL: eşitlik, VARLIĞIN kanıtı değildir (ZORUNLU)

> **Eşitlik-tabanlı her doğrulama, girdilerin BOŞ OLMADIĞINI önce AYRICA kanıtlar.**

Aynı turda, ikinci katmanda **aynı şekil**:

```
1  iki çıktı üretildi          ✅ doğru niyet
2  diff ile karşılaştırıldı    ✅ doğru araç
3  çıktıların DOLU olduğu      ⛔ SORULMADI  ← tek eksik
─────────────────────────────────────────────
   iki BOŞ dosyanın diff'i → rc=0 → "EKLEME-ONLY doğrulandı"
```

İki kez oldu (`$F` tırnaksız · `xargs -a` BSD'de yok) ve ikisinde de *"doğrulandı"*
denecekti. Üçüncüde poz.kontrol **`diff`'ten ÖNCE** kondu: `223/223` satır teyit
edildikten **sonra** fark ölçüldü.

**Pratik — sıra bağlayıcı:**

```
❌  diff <(a) <(b) && echo "aynı"
✅  [ "$(wc -l < a)" -eq N ] && [ "$(wc -l < b)" -eq N ] && diff a b
```

📌 `§2.7`'nin *"kanıt kurulumu ölçtüğün durumu değiştirmesin"* ailesine komşu ama
farklı: orada kurulum durumu **değiştiriyordu**, burada kurulum durumu **hiç
üretmedi** ve eşitlik testi bunu **başarı** diye okudu.

### KANIT RENGİN KENDİSİ DEĞİL, RENGİN SEBEBİDİR (ZORUNLU)

> **Yeşil ayırt etmeyebilir — ve KIRMIZI da doğru şeyi ayırt etmiyor olabilir.**
> **Bir mutasyon kırmızı ürettiğinde sor: bu kırmızı, ölçmek istediğim DAVRANIŞTAN mı
> geliyor, yoksa başka bir şeyden mi?**

`§2.7` ailesinin tamamı *"yeşil ama hiçbir şey kanıtlamıyor"* vakalarını topluyor. Bu onun
**simetriği**, ve aynı oturumda iki farklı biçimde ölçüldü:

| vaka | kırmızı geldi | ama sebebi |
|---|---|---|
| `T-121` | mutasyon `TS2488` verdi | **derleme hatası** — testler hiç koşmadı |
| `N1` (2026-08-24) | mutasyon testi kırdı | **`toHaveBeenCalledWith` argüman kontrolü** — davranışsal fark değil |

İkincisi öğretici: `code-reviewer` *"fixture iki tarafta aynı değeri taşıyor, test ayırt
etmiyor"* dedi. Doğruydu. Ama `qa-engineer` mutasyonu koşturunca test **kırmızıya döndü** —
çünkü sorgunun `where` argümanını ayrıca assert ediyordu. Yani **tespit doğru, sonuç
yanlıştı**: test kör değildi, ama **davranışsal olarak** ayırt etmiyordu.

⚠️ **Ve fark bir gün önemli olur:** argüman kontrolü, üretim kodu aynı davranışı **başka
bir şekille** elde ettiği gün (ör. filtreyi `where` yerine `find` sonrası uygulamak)
kırmızıya döner ve **yanlış alarm** verir; ya da tersine, `where` doğru görünürken davranış
bozuksa **sessiz kalır**.

**Pratik — mutasyon kırmızısını kabul ederken:**

```
1  Testler GERÇEKTEN koştu mu?          (derleme/çalıştırma hatası DEĞİL)
2  Kırmızı bir ASSERTION'dan mı geliyor? (hangi assertion — bas)
3  O assertion DAVRANIŞI mı ölçüyor, ÇAĞRI ŞEKLİNİ mi?
```

📌 Ve `qa-engineer`'ın bunu **kendiliğinden yazması** doğru refleks: *"bugünkü test de
aslında yakalıyordu, ama reviewer'ın işaret ettiği kusur gerçekti."* Bir düzeltmeyi
savunmak ile bir teşhisi düzeltmek ayrı işlerdir.

### EN İYİ KONTROL, BAĞIMSIZ BİR KAYITLA ÇAKIŞTIRMADIR (ZORUNLU)

> **İki bağımsız yolun aynı sayıya çıkması, tek bir yolun doğru görünmesinden
> KATBEKAT güçlü bir kanıttır** — çünkü ikisinin **aynı yönde** yanılması için ortak bir
> sebep gerekir, ve çoğu zaman yoktur.

Kanonik vaka (2026-08-24, onay-akışı sınıf düzeltmesi): `review` ve `escalate-to-finance`
rotaları **davranış sınıflamasıyla** `MODES_APPROVE`'a taşındı (kolon-sınıfı ölçümü:
yazdıkları her kolon onay-durumu, plan-içerik `0`). Karar verildikten **sonra** ikinci,
tümüyle bağımsız bir yol ölçüldü:

```
MODES_APPROVE 6  +  MODES_SUBMIT 5  =  11  =  B3a'nın ÜÇ TUR ÖNCEKİ kaydı
```

`EK 3 §3`'ün **açıklanamayan `−2`**'si tam olarak bu iki rotaydı — ve **karar verilirken
bu hesap bilinmiyordu.** Yani sınıflandırma, öngörmediği bir muhasebe açığını kapattı.

**Pratik — bir sınıflandırma/atama kararı verirken sor:**

```
Bu kararın DOĞRU olması, BAŞKA hangi sayının tutmasını gerektirir?
  → o sayıyı AYRICA ölç, ve kararı verdikten SONRA ölç (önce ölçmek hipoteze çeker)
```

⚠️ Ve çakıştırma bir **tanım** değil bir **kontrol** olmalı: `§ DÖRDÜNCÜ SORU` gereği,
ikinci yol birincisinden türetiliyorsa çakışma **kaçınılmazdır** ve hiçbir şey kanıtlamaz.
`ADIM 0`'ın `G5` kapısı bu yüzden üyeliği **alt-modülden** (davranış) alıp `@Roles` ile
çakıştırır — üyeliği `@Roles`'tan alsaydı kontrol totoloji olurdu.

### Elle yazılmış üye-sayısı: ölçülmüş oran DOKUZDA DOKUZ (ZORUNLU)

*"Elle yazılmış sayı bayatlar"* bu dosyada bir **ilke** olarak duruyordu. 2026-08-24'te
**oran ölçüldü** — `capabilities.ts`'in harita yorumlarındaki dokuz `(N route)` başlığı:

```
7 / 9   bugünkü ölçümle BAYAT      (ör. MODES_READ 37↔34 · SHARED_READ 36↔20)
2 / 9   VAR OLMAYAN hücreye atıf   (USER_READ Z20'de silindi · SHARED_APPROVE 0 rota)
─────
9 / 9   kusurlu
```

> **Yani *"bir gün bayatlar"* değil — *"bugün zaten bayat"*.** Bir üye-sayısı yazmak,
> gelecekteki bir riski değil **bugünkü bir kusuru** kaydetmektir.

Kayıt niteliğindeki bloklar `F12` gereği **düzeltilmez, damgalanır**; yeni yorumlar sayı
**yazmaz**, üye listesine ya da üreticiye **atıf verir**.

### Dokümanda sayı yazma — niteliksel ayırt edici yaz (ZORUNLU)

Üç ayrı vakada bir yoruma/rapora yazılmış sayı yanlış çıktı ("34 e2e gövdesi" → 38; "eleven
e2e cases" → 13; aynı ifadenin ikizi 12'yi kastediyordu). **Üçü de yanlış değildi — üçü farklı
şey sayıyordu**, ve hepsi bir sonraki test eklendiğinde bayatlayacaktı.

Bu, kalibrasyon bulgusunun kardeşidir: **ölçülmemiş sayılar düşük çıkar, ölçülmüş sayılar
bayatlar.** İkisinin ortak dersi aynı: dokümanda ve kod yorumunda **sayı yerine niteliksel
ayırt ediciyi** yaz.

- ❌ "on bir e2e testi bunu kapsıyor" · "34 gövdenin hiçbirinde yok"
- ✅ "her biri mekanikleri **tek istekte** gönderiyor — ayırt edici olan şekil" · "**hiçbiri**"

Sayı bakım gerektiren bir olgudur; şekil ve "hiçbiri/hepsi" gerektirmez.


### Beklenen YÖNE yanılan bir hata, ters yöne yanılandan TEHLİKELİDİR (ZORUNLU)

> **Beklenen yöne yanılan bir ölçüm hatası, ters yöne yanılandan tehlikelidir — çünkü
> sonuç makul görünür ve sorgulanmaz.**
>
> **Pratik sonucu: bir hipotezi DOĞRULAYAN ölçüm, ÇÜRÜTEN ölçümden daha fazla
> doğrulama ister.**

Yukarıdaki madde *"neden 0?"* / *"neden var?"* ile **sonucun** iki açıklaması olduğunu
söylüyor. Bu, **hatanın yönü** hakkında: aynı büyüklükteki iki hata eşit tehlikeli
değildir.

Ölçülmüş vaka — tek turda **üç** ölçüm hatası, ve yakalanma sebepleri farklı:

| hata | yönü | nasıl yakalandı |
|---|---|---|
| iç içe spread sabiti çözülemedi → `sales-actuals`'ın **4 rotası düştü** | **beklenen yöne** — sonuç hipotezi *doğrular* göründü | ⚠️ **neredeyse geçiyordu**; ayrı bir soru sorulunca çıktı |
| yorumdaki `@Roles(` kazandı → `plans/:id/reject` *"filtresiz"* | tuhaf — kardeşi kapalıyken bu açıktı | **kendi içinde tutarsızdı**, bakıldı |
| `audit-log` e2e'de *"3 geçiş"* | tuhaf — `0` bekleniyordu | **pozitif kontrol alarm verdi**, bakıldı (üçü de **yorum**du) |

**İkisi tuhaf olduğu için yakalandı. Biri makul göründüğü için neredeyse geçiyordu** —
ve o biri, düşen dört rota, tam da **hipotezi çürüten kanıttı**. Raporlansaydı hipotez
*"ölçüldü ve doğrulandı"* diye kaydedilecekti.

**Pratik — asimetrik doğrulama:**

- Ölçüm hipotezini **çürütüyorsa**: sonuç zaten dikkat çeker, olağan doğrulama yeter.
- Ölçüm hipotezini **doğruluyorsa**: bir **ikinci ölçüm** yap — farklı desen, farklı
  yüzey ya da farklı araç. *"Beklediğimi buldum"* bir bitiş değil, bir **tetikleyicidir**.
- Ve tuhaflığı bir gürültü sayma: **tutarsız görünen bir sonuç, en ucuz kusur
  dedektörüdür.** Bu turda iki kusuru o yakaladı, hiçbir guard yakalamadı.


## AİLE — DÜZELTME · PORT · BAYATLIK

### Test dosyası TASK NUMARASI değil SÖZLEŞME ADI taşır (ZORUNLU)

> **Task numaraları kapanır; sözleşmeler yaşar.**
> **Bir dosya adı bir ATIFTIR — içerik başka yere taşındıysa atıf yanlış yeri gösterir.**

Ölçülmüş vaka (2026-08-23): `t254-empty-scope-budget-utilization.e2e-spec.ts` `T-270`
turunda **tümüyle yeniden yazıldı** (`Z21`, zarf modeli). Ad hâlâ `t254`, içerik
`T-270/Z21` — **sarkan atfın dosya-sistemi hâli**, `E6`'nın yakaladığı sınıfın kod
tarafı.

```
❌  t254-empty-scope-budget-utilization.e2e-spec.ts
✅  empty-scope-contract.e2e-spec.ts        (task atfı DOSYA BAŞLIĞI YORUMUNDA)
```

⚠️ Ve *"git tarihçesi için eski ad kalsın"* **tutmaz** — `git mv` tarihçeyi korur.

### Bir AD, koruduğu SINIFTAN dar olabilir (ZORUNLU)

> **Bir kuralın/yorumun/rotanın ADI bir KANALI ya da MEKANİZMAYI adlandırıyor, gövdesi
> bir SINIFI koruyorsa — DAR AD, sınıfın DIŞINDA KALAN ÜYEYİ MEŞRU GÖSTERİR.**

Bir oturumda **üç ölçülmüş vaka** (2026-08-24):

| ad ne diyor | gövde neyi koruyor | dar adın maliyeti |
|---|---|---|
| `K-2.6.14` başlığı: *"belge içe aktarma"* | **defter-etkili giriş** (gerekçe: *"görev ayrılığı veri girişini değil finansal kararı korur"*) | **manuel form** kuralın dışında sanıldı — ve `PLANNER`'a açık kaldı |
| `kpi.controller.ts:70`: *"PLAN verisi döndürüyor"* | **katalog okuma** (`kpi.service.ts:94`: *"never returns plan content"*) | `5/5` rol kümesi **çürümüş bir gerekçeyle** ayakta kaldı |
| `GET /plans/approval-queue` adı: *"for current user"* | **kapsam** yüklemi, sahiplik değil | rota `READ_OWN` sanılabilirdi |

**Pratik:**

```
1  Bu adın işaret ettiği şey bir KANAL/MEKANİZMA mı, yoksa bir SINIF mı?
2  Gövde hangisini koruyor?
3  İkisi ayrışıyorsa → ADI DEĞİL, AYIRT EDİCİYİ yaz — ve ayırt edici ÖLÇÜLEBİLİR olsun
```

📌 **Ölçülebilirlik şart:** `K-2.6.14`'ün açıklığı *"defter etkisi"* diyor, ve o **tek
grep'lik bir üyelik testine** iniyor (`modes/` içinde `ledgerService.` çağıran servisler:
**iki**). Ayırt edici ölçülemezse, açıklık bir **görüş** olur ve bir sonraki tartışmayı
çözmez.

⚠️ Ve bu, `§ SESSİZ SAPMA`'nın kardeşi: orada bir **sapma** kaynağa atıf vererek
doğrulanmış görünüyordu; burada bir **üye**, adın darlığı sayesinde **kapsam dışı**
görünüyor.

### Bir DÜZELTME, düzelttiği SINIFIN yeni bir vakasını üretebilir (ZORUNLU)

> **Bir düzeltme, düzelttiği sınıfın yeni bir vakasını üretebilir — ve düzeltme turunun
> kabul kriteri onu kapsamalıdır.**

Ölçülmüş vaka (2026-08-14, `INV-N-004`): `null` ROI'nin `BELOW_TARGET`'a çökmesi
düzeltildi — backend'e dördüncü bir durum eklendi (`NOT_COMPUTABLE`). Ama tüketici
`PlanAnalysis.tsx` yalnız `BELOW_TARGET`/`ON_TARGET` kontrol ediyor ve `else` dalı
**yeşil "Hedef Üstü"** basıyor:

```
düzeltmeden ÖNCE   null → kırmızı "Hedef Altı"     (yanlış)
düzeltmeden SONRA  null → yeşil  "Hedef Üstü"      (DAHA yanlış)
```

Yani düzeltme, düzelttiği sınıfın (*"hesaplanamayan bir değer bir iş yargısına
çöküyor"*) **yeni bir vakasını üretti** — ve **ters yönde, daha kötü**: yanlış bir kırmızı
yanlış bir yeşile döndü.

📌 Mekanizma: **taşıyıcıya yeni bir değer eklemek, onu OKUMAYAN her tüketicide sessiz bir
sapma doğurur.** `else` dalları yeni enum değerini kendi varsayılanına yutar.

**Pratik — düzeltme turunun kabul kriterine bir satır:**

> *"Bu düzeltme, düzelttiği sınıfın yeni bir vakasını üretiyor mu?"*

> ### ✅ VE BU SORU BİR AJAN TARAFINDAN, DÜZELTME TURUNDA YAKALANDI (2026-08-24)
>
> Sınıfın bugüne kadarki vakaları **sonraki turda** bulunmuştu. Bu ilki değil ama ilk
> **kendi turunda** yakalanan:
>
> ```
> düzeltme   migration 1812'nin sayımına `deleted_at IS NULL` eklendi (evren uyuşmazlığı)
> YENİ VAKA  soft-silinmiş joker satır UQ anahtarını HÂLÂ işgal ediyor (UQ partial DEĞİL)
>            → migration sessizce INSERT deneyip ham 23505 alırdı
> yapılan    ayrı bir kova: teşhis edilebilir İPTAL, ham hata DEĞİL
> ```
>
> 📌 Ve genel ders: **bir filtre eklemek, filtrelenen şeyin BAŞKA BİR YERDE hâlâ etkili
> olup olmadığını sordurmalı.** `deleted_at`'i *okuma* tarafında filtrelemek, o satırın
> *tekillik* tarafındaki etkisini kaldırmaz.

> ### ⛔ VE HAM BİR HATA, HAM BİR `23505`'TEN FARKSIZDIR (ZORUNLU)
>
> **Bir reddin gövdesi SEBEP ve ADRES taşımalıdır** — *"neden reddedildi"* ve *"ne zaman
> açılacak / kimin işi"*. Sebepsiz bir `409`, sebepsiz bir `23505` kadar teşhis edilemez;
> ikisi de çağıranı **kaynağa bakmaya** zorlar.
>
> Ölçülmüş çift vaka (2026-08-24): migration `1812` soft-silinmiş satır vakasında ham
> `23505` yerine **adlandırılmış İPTAL** verdi · `K-2.6.4g` kapısı `409` gövdesinde
> **şekil adlarını ve `T-242b`'yi** yazıyor.
>
> ⚠️ Ve bu bir üslup meselesi değil: adres taşımayan bir ret, **kapalı bir yeteneği bir
> arıza gibi** gösterir — ve bir sonraki tur onu *"düzeltmeye"* kalkar.

Ve özellikle bir **enum/durum genişletmesi** yapıyorsan: o değeri **karşılaştıran** her ucu
say (`§7.1`), ve `else`/`default` dallarının onu ne yaptığına bak. Yeni değer bir `else`'e
düşüyorsa, düzeltme oraya bir kusur taşımıştır.

### Bir DÜZELTME de bir iddiadır (ZORUNLU)

**Düzeltmenin doğru hedefe gittiği, düzeltmenin gerekliliği kadar ölçülmelidir.**

Bir kusur bulunduğunda dikkat *"kusur gerçek mi"*ye gider ve orada durur. Ama düzeltme
**ikinci bir iddiadır**: *"doğrusu şudur."* O iddia ayrıca ölçülmezse, gerçek bir kusur
gerçek bir sapmayla değiştirilir — ve sonuç **bir düzeltme kılığında** kaydedilir.

Bu oturumda **üç kez** oldu:

| # | düzeltme | gerçek |
|---|---|---|
| 1 | *"fırlatma kapısı %80"* (tek kaynaktan genelleme) | %95 kapı, %80 **mitigation** |
| 2 | *"auto-reject Phase 1'de geçersiz"* | `§7.7`: **Phase 1'de geçerli** |
| 3 | **`migration 1780`: *"DOĞRU (BRD): INCR_GP / INCR_SPEND"*** | dört kaynak **`TOTAL_PLANNED_SPEND`** diyor |

İlk ikisi bizim yorumumuzdaydı ve bir sonraki turda düzeldi. **Üçüncüsü koda girdi ve
kalıcı** — üstelik doğru payda **aynı migration tarafından** veritabanına eklenmişti,
birkaç satır ötede.

> ⚠️ **Ve düzeltme daha tehlikelidir, çünkü "iş bitti" hissi aramayı durdurur.** İkinci
> vakada *"düzelttim"* duygusu üçüncü kaynağa bakmayı engelledi; doğru cevap dördüncü
> belgedeydi.

**Ve §7.1 ile birleşince:** bir sapma *"uygunluk"* diye etiketlenirse (`DOĞRU (BRD)`)
**sorguyu kapatır.** Sessiz bir sapma bir gün fark edilir; kaynağa atıf veren bir sapma
**doğrulanmış görünür.** Atıf boşsa — kaynak okunmamışsa — o etiket kusuru korur.

- ❌ *"BRD kanonik formüle güncelledi"* (kaynak okunmadan)
- ✅ *"`Section_05 §5.3` ve Glossary `GP ROI` maddesi `TOTAL_PLANNED_SPEND` diyor —
  ölçüldü <tarih>"*

### Bir düzeltmenin iki ekseni vardır: HEDEFİ ve YÖNÜ (ZORUNLU)

```
Bir düzeltmenin iki ekseni vardır: hedefi ve yönü.
Hedef hatası görünür  (yanlış dosya, yanlış numara).
Yön hatası görünmez   — doğru yere dokunur, yalnız işareti terstir.
Ve yön hatası bir ölçümden ÖNCE yazılırsa, ölçümü kendi yönüne çeker.
```

Yukarıdaki üç vaka **hedef** hatasıydı: yanlış eşik, yanlış faz, yanlış payda. Hepsi
görünür, çünkü doğru değerle yan yana konunca ayrışırlar.

**Yön hatası ayrışmaz.** Ölçülmüş vaka (2026-08-13, `0069`'un `discount_amount` notu): üç
şıklı bir ayrım iki şıkka indirildi, etiketler **takas edildi**, ve *"kural `(a)`'yı
reddediyor"* yazıldı — oysa kural `(a)`'yı **kabul ediyordu**. Cümle doğru alana
dokunuyordu, doğru kuralı anıyordu, doğru task'a bağlıydı; yalnız **işareti** tersti, ve o
yüzden okuyan hiçbir yerde tökezlemiyordu.

⚠️ **Ve bedeli bir yanlış bilgi değil, bozulmuş bir ölçümdür.** O not `T-209`'un ön
beklentisiydi. Ters yazılmış bir ön beklenti, ölçümü **kendi yönüne çeker**: ajan
hipotezi sınamak yerine **doğrulamaya** çalışır, ve sonuç *"ölçüldü"* etiketiyle kaydolur.

> Bu, `§2.7`'nin *"kanıt kurulumu ölçtüğün durumu değiştirmesin"* ailesinin **planlama
> tarafındaki** hâli. Orada kurulum ölçümü bozuyordu; burada **beklentinin metni** bozuyor.

**Pratik:**

- Bir düzeltme yazdıktan sonra sor: *"hedefi mi düzelttim, yoksa yönünü de mi
  çevirdim?"* — ve **yönü ayrıca oku.** Reddediliyor mu kabul mü, artıyor mu azalıyor mu,
  eleniyor mu ayakta mı.
- **Bir ölçümün ön beklentisini yazarken şıkları ve her şıkkın sonucunu bir TABLOYA koy.**
  Düzyazıda bir işaret sessizce ters çevrilebilir; iki sütunlu bir tabloda ters çevirmek
  **görünür** olur.
- Ve o tabloyu **ölçümün girdisi** yap, bir dipnot değil: *"ölçümü yapan ajan bu tablodan
  başlasın."* Uyarı okunmazsa yoktur.

### Ölçüm ortamının bayatlığı da bir maskeleme sınıfıdır (ZORUNLU)

**`start:dev` süreci ayaktayken kaynak düzenlenirse rotalar bozulabilir ve hata kod kusuru gibi
görünür.** E2E'den önce backend süreci yeniden başlatılmalı.

T-113'te ölçüldü: `POST /plans/:id/fus` **500** dönüyordu. Aynı commit, aynı DB, aynı istek
gövdesi — süreç yeniden başlatılınca **201**. Yani ölçülen şey koddaki bir kusur değil, ölçüm
ortamının bayatlığıydı; ve bir saat, olmayan bir kusuru aramakla geçebilirdi.

Bu, §2.7 ailesinin bir üyesi ama tersinden: orada kanıt kurulumu **kusuru gizliyordu**, burada
**olmayan bir kusur üretiyor**. İkisinin ortak kuralı aynı:

> **Bir hata gördüğünde, önce onu üreten ortamın taze olduğunu doğrula. Yeniden başlat, tekrar
> ölç — ancak ondan sonra kodu suçla.**

### BAYAT SÜREÇ BİRİKİR — ve ölçümü ARALIKLI bozar (ZORUNLU)

`§`'nin *"ölçüm ortamının bayatlığı"* kuralı **tek** bir bayat süreci konu alıyor. Bu, o
kuralın **birikim** hâli ve daha sinsi:

Ölçülmüş vaka (2026-08-23, `Z24` turu): aynı DB'ye bağlı **üç** `nest start` süreci
bulundu — başlangıç saatleri `3:06PM` · `3:20PM` · `8:30PM`, yani **beş saatlik** bir
aralığa yayılmış. Bir e2e koşumunda `T-047` invaryantı **düştü** (`plans 4→0`,
`planSkus 159→0`), sonraki **iki** koşumda **geçti**.

```
tek bayat süreç   →  rotalar eski, hata KOD KUSURU gibi görünür     (bilinen kural)
BİRİKMİŞ süreçler →  aynı DB'ye yazan çoklu yazar, sonuç ARALIKLI   ← bu vaka
```

⚠️ **Ve teşhis tuzağı `§`'nin flaky maddesiyle aynı yerde:** *"ortam yavaş"* ve *"test
kırılgan"* açıklamaları hazır bekliyor. Üçüncüsü — **birden çok süreç aynı fixture'a
yazıyor** — daha az akla gelir çünkü **görünmez**: `docker ps` göstermez, `git status`
göstermez, testin çıktısı göstermez.

**Pratik — bir e2e invaryantı aralıklı düşerse ÖNCE bunu ölç:**

```bash
ps aux | grep -E 'nest start|node dist/main' | grep -v grep
lsof -nP -iTCP:3000 -sTCP:LISTEN
```

⛔ **Ve bir dev sunucusu başlatan her tur, onu KAPATMAKTAN sorumludur** — ya da
başlattığını **raporlar**. Bu oturumda üç süreç birikti ve hiçbirinin sahibi belli
değildi.

📌 `§1`'in *"yabancı container"* uyarısıyla **aynı aile, farklı yüzey**: orada başka bir
ürünün container'ı `docker ps`'te ayırt edilemiyordu; burada **kendi ürünümüzün** bayat
süreçleri hiçbir listede görünmüyor.

### Testler bir ŞARTNAMEDİR — kod silinse bile (ZORUNLU, ve bir kurtarmayla ölçüldü)

Testlerin bilinen getirisi regresyonu yakalamaktır. T-126'da **ikinci bir getirisi** ölçüldü:
`git checkout` commit edilmemiş bir dosyanın işini sildiğinde, o iş **yeniden inşa edilebildi**
— çünkü spec dosyaları, tüketici servisi ve ikiz modül ayakta kalmıştı.

Ve envanteri **`tsc` çıkardı**: beş tip hatası, kaybın tam listesiydi. ([[T-116]]'nın —
`type-check`'in `tests/`'i kapsaması — ikinci somut getirisi; birincisi kör bir testi bulmaktı.)

> **Kod silinebilir; spec duruyorsa yeniden yazılabilir.** Bu, testleri koddan **önce** ya da
> **ayrı** commit'lemenin ölçülmüş bir gerekçesidir.

⚠️ Tersi de doğru: spec'i olmayan bir dosya kaybolduğunda geriye **hiçbir şartname** kalmaz —
yalnız hatırlanan niyet.

### Bir şema kararını geri alırken entity metadata'sını da geri al (ZORUNLU)

`migration:generate` **entity metadata'sını veritabanına karşı** diff'ler. Entity'de kalan bir
kısıt, bir sonraki generate'te **gerekçesiz bir migration olarak** geri gelir.

T-101: kısmi UNIQUE taslağı kapsam dışı olduğu için migration'dan çıkarıldı ama **entity'de
kaldı**. Migration'ın başlığı "bu index'e dokunmuyor" derken entity onun yerine geçtiğini ilan
ediyordu. Ölçüm (düzeltmeden önce/sonra `migration:generate` çıktısı):

```
önce:  CREATE UNIQUE INDEX "IDX_b753f…" … WHERE deleted_at IS NULL AND is_active = true
sonra: (böyle bir satır yok)
```

Yani bir başka task'a **devredilmiş** karar, bir sonraki generate'te yazarsız olarak inecekti.

⚠️ Bu, `pg_constraint`/`pg_indexes` sorusunun **farklı** bir sorusu. O ikisi doğru sorulmuştu.
Sorulmayan soru **entity ↔ DB eşitliği**ydi, ve bu repoda o soruyu soran tek araç
`migration:generate`'dir.

Ayrıca: `@Index`'e **adını yaz.** Adsız bırakılırsa TypeORM hash türetir ve gerçek index'i
yeniden adlandırmayı önerir — ona atıf yapan her migration'ın adını öksüz bırakarak.

### Fixture, ayırt etmek istediği iki tarafta FARKLI değer taşımalı (ZORUNLU)

**Bir testin fixture'ı, test edilen ayrımın iki tarafında aynı değeri taşıyorsa, test o ayrımı
ölçemez.** Yeşildir ve hiçbir şey söylemez.

T-101: `returns config-driven thresholds when rows exist` testi `{80, 95, 100}` konfigüre edip
`{80, 95, 100}` bekliyordu — ve `DEFAULT_THRESHOLDS` **tam olarak o**. Konfigürasyonu tümüyle
yok sayan bir servis o testi geçerdi.

Ve asıl ders burada: **turun konusu olan kamuflaj** — seed değerlerinin varsayılanla birebir
aynı olması — **config yolunu kanıtlamak için yazılmış testin içinde duruyordu.** Test kusuru
sabitlemiyordu; kusurla **aynı körlüğü paylaşıyordu**.

Bu, §2.7'nin "yanlış şekilli test" ailesinin yeni bir yüzü: orada testin *şekli* ayırt
edemiyordu, burada *verisi*.

### Port ederken: davranış taşınır, onu DOĞRU KILAN BAĞLAM taşınmaz (ZORUNLU)

**Kopyalanan bir satır, kaynağında güvenli olduğu için hedefinde de güvenli değildir.**

T-111'de ölçüldü. Backend'in `money-float.sh`'i domain listesi bulunamazsa `SKIPPED` yazıp
**exit 0** döner — ve bu **güvenlidir**, çünkü `run-all.sh` o işareti grep'leyip bir setup
hatasına çevirir. Frontend portu `exit 0`'ı aldı, hatta yorumun *"SKIPPED is not a pass"*
cümlesini de aldı — ama o cümleyi doğru kılan `run-all.sh`'i almadı.

Sonuç: bir dosyayı silmek ya da yeniden adlandırmak kapıyı **kalıcı ve sessiz** yeşile
çeviriyordu. Aynı kod, farklı bağlamda **zıt anlam**.

> **Bir davranışı port ederken sor: bunu kaynağında doğru kılan şey bu satır mı, yoksa
> onun etrafındaki bir şey mi? İkincisi ise ya onu da port et, ya davranışı değiştir.**

Bu, ikizlerde atıf şartı koymamızın (`numeric-text.ts` ↔ `numberUtils.ts`) aynı gerekçesidir:
kopyanın kendisi doğruluğunu taşımaz, **bağı taşır**.

⚠️ Ve port edilmeyeni **kaydet**: T-111'in "WHAT DID NOT PORT" listesi üç madde sayıyordu ve
`run-all.sh` o listede **yoktu** — yani eksiklik yalnız yapılmamış değil, **bilinmiyor**du da.

**Ama liste yazmak yetmez: listenin TAM olduğu ölçülmeli.** Kopyalanmayanın listesi de bir
enumerasyondur, ve §7.1'in tablosundaki vakaların **çoğu** bir enumerasyonun eksik çıkmasıdır —
her seferinde tüketici göründüğü için. Sonuncusu bu kuralın kendi vakasıydı
(`run-all.sh`, "port edilmeyenler" listesinde yoktu).

> **Bir enumerasyona dayanan her karar, enumerasyonun kendisi ölçülene kadar bir tahmindir.**

Pratik: "şunlar port edilmedi" derken kaynağı **tara**, hafızadan sayma. Kaynakta hangi
dosyalar/mekanizmalar var, hedefte hangileri yok — farkı **komutla** üret.

### Bir ÖLÇÜMÜN geçerliliği de koşullarına bağlıdır — koşulu ölçümle birlikte yaz (ZORUNLU)

Yukarıdaki kural koda yazılan **iddialar** için düşünülmüştü. T-107 adım 2 onu bir adım
genişletti: aynı şey **ölçüm sonuçları** için de geçerli.

Vaka: T-121'de ölçüldü ve commit mesajına, task'a, kod yorumuna yazıldı —

> *"Gerçek `FALSE` hücresi ile boş hücre kusursuz ayrılıyor: `raw:false` gerçek boolean'ı
> `"FALSE"` string'ine çevirir, sentinel boolean'dır."*

**Doğruydu.** İki tur sonra T-107 adım 2 `raw: false` → `raw: true` yaptı ve ölçüm **o anda
geçersizleşti**: gerçek `FALSE` artık boolean geliyor, sentinel'den ayırt edilemiyor, ve
`stripBlankCellSentinel` onu sessizce `undefined` yapıyor.

Ölçüm yanlış değildi. **Koşulu yazılmamıştı.**

> **Bir ölçümü kaydederken hangi koşul altında yapıldığını da kaydet.** Bir bayrak, bir mod,
> bir ortam değişkeni, bir kütüphane seçeneği değiştiğinde o ölçüm otomatik olarak geçersizdir
> — ve koşul yazılıysa, o bayrağı değiştiren kişi onu görür.

- ❌ "gerçek FALSE hücresi ayırt ediliyor — ölçüldü"
- ✅ "**`raw: false` altında** gerçek FALSE hücresi ayırt ediliyor — ölçüldü; `raw: true`'da bu
  ayrım kaybolur"

Pratik test: ölçümünü bir cümlede yazarken **"hangi ayarla?"** diye sor. Cevap varsa cümleye
girer. Cevap yoksa ölçüm muhtemelen eksiktir.

⚠️ Ve bu, testin işini yapmasını engellemez — **tersine, testin değeri budur.** Aynı turda o
ayrımı pinleyen bir test yazılmıştı ("bir guard'ı yok" bulgusu üzerine); bayrak değişince
**tek kırmızı o oldu**. Yorum bayatlar, test bayatlamaz — ama test yalnız yazıldıysa vardır.

Bir sözleşmenin (transformer, guard, invariant) geçerliliği **çağıranın bugünkü şekline bağlı
olamaz.** "Bugün ulaşılamaz" bir kapsam gerekçesi olabilir, ama asla bir **koruma kaldırma**
gerekçesi değildir.

### Bir CACHE İNVALİDASYONU yazıldığında çağıranı AYNI TURDA bağlanır (ZORUNLU)

> **Bir cache invalidasyonu yazıldığında çağıranı aynı turda bağlanır.**
> **Bağlanmazsa o mekanizma "var ama yol yok" ailesinin sessiz bir üyesidir — ve
> sessizliği FAIL-OPEN yöndedir: eski değer okunmaya devam eder.**

`T-052/T-062` ailesi *"mekanizma var, üretim yolu yok"* diyor ve sekiz vakası sayılı.
Cache invalidasyonu o ailenin **özel bir sınıfı**, ve iki farkı var:

| | genel aile | cache invalidasyonu |
|---|---|---|
| çağıransız hâli | özellik **çalışmaz** — görünür | özellik **eski veriyle çalışır** — görünmez |
| yönü | değişken | **fail-open** (eski, daha geniş yetki okunur) |

**İki ölçülmüş vaka — ve ikincisi kuralı doğurdu:**

| # | mekanizma | çağıran | sonucu |
|---|---|---|---|
| 1 | `kpi.service` `clearCache` (`T-039`) | **0 üretim çağıranı** | eski KPI konfigürasyonu okunmaya devam ediyordu |
| 2 | `access-scope.service` `clearCache` (`T-242a`, 2026-08-20) | **0 üretim çağıranı** | `REVOKE_ALL`'dan sonra **5 sn boyunca kaldırılmış kapsamda işlem yapılabiliyor** |

⚠️ **İkincisinin yönü can alıcı:** bir **erişim kaldırma** ucu yazıldı, ve kaldırma
5 sn gecikiyor. Sözlüğün kendi ifadesiyle `REVOKE_ALL` *"bir güncelleme değil, bir
erişim kaldırma"* — **bir erişim kaldırma gecikemez.**

📌 Ve TTL'in kısalığı bir savunma değil: *"5 sn küçük"* argümanı, kusurun **yönünü**
değil **büyüklüğünü** tartışıyor. Fail-open bir gecikme, süresi ne olursa olsun bir
yetki penceresi açar.

**Pratik:** bir `clearCache`/`invalidate`/`evict` yazdığında ya da bulduğunda, **aynı
turda** iki soruyu cevapla:

```
1. Bu cache'in içeriğini DEĞİŞTİREN her yazma yolu hangisi?   ← say, hafızadan değil
2. Her biri invalidasyonu çağırıyor mu?                        ← grep çıktısıyla
```

Cevap *"hayır"*sa, çağırmak bu turun işidir — ayrı bir task değil. Çünkü invalidasyonu
yazan tur, onu **çağırmanın gerektiğini bilen tek turdur**.

### `new Date(kullanıcıGirdisi)` — beş sessiz hata biçimi, hepsi ölçüldü (ZORUNLU)

`parseFloat` için söylediğimizin tarih karşılığı: **hata vermez, yanlış yapar.** T-107/T-121/
T-123 boyunca beş ayrı biçim ölçüldü ve **beşi de sessiz**:

| girdi | `new Date` ne yapıyor |
|---|---|
| `"3/4/26"` | sessizce **ABD** sırası — Türk kullanıcının 3 Nisan'ı **4 Mart** oluyor (bir AY) |
| `"15/1/26"` | `Invalid` → çağıran sessizce `undefined` döndürüyordu |
| `"46037"` | **yıl 46036** — `Invalid` değil |
| `"2026-01-15"` ↔ `"1/15/26"` | biri **UTC**, diğeri **yerel** gece yarısı olarak ayrıştırılıyor |
| `"2026-02-30"` | sessizce **Mart'a taşıyor** (rollover) |

Dördüncüsü kurumsal olarak en sinsi: aynı fonksiyon, girdi biçimine göre **farklı takvim** —
bu yüzden hiçbir biçimlendirici ikisini birden düzeltemez.

> **`new Date()` bir kullanıcı girdisi için hiçbir zaman doğru araç değildir.** Tarih-yalnız
> değer bir **takvim günüdür**, `Date` ise bir **an**; ikisini aynı tipte temsil etmek saat
> dilimi belirsizliğini yapısal olarak davet eder.
>
> Katı bir gramerden geçir (`src/common/date/date-text.ts`), kanonik `YYYY-MM-DD` **string**
> taşı, `Date` kurma.

### Sessiz VARSAYILAN ile sessiz FALLBACK aynı şey değildir (ZORUNLU — §2.5'in sınırı)

§2.5 *bilgi uydurmayı* yasaklıyor. Başka bir **kaynağa** düşmek farklı bir şeydir:

| | ne yapıyor | statü |
|---|---|---|
| sessiz **varsayılan** | bilgi **uyduruyor** — `?? 0`, `catch { return 0 }` | **YASAK** |
| sessiz **fallback** | başka bir **kaynak** kullanıyor — `agreement.periodMonth`, `invoiceDate`'ten türetilen dönem | iyileştirilmeli, ama **uydurma değil** |

> **Katılığı, teslimi olmayan bir yere ekleme.** Ve geri alıyorsan **neden**ini koda yaz —
> yoksa altı ay sonra biri *"burada neden katılık yok?"* diye sorar ve cevabı bulamaz.

### ⚠️ AMA fallback'in meşruiyeti dar: birincil kaynak GERÇEKTEN okunamıyor olmalı

Bu kural bir kez fazla geniş uygulandı ve **sessiz yanlış değer** üretti. T-123'te
`off-invoice.getFiscalPeriod`'un throw'u geri alındı; gerekçe *"tek bozuk hücre tüm dosyayı
düşürüyor"*du ve **tek bir girdi şekli** (`"çöp"`) ölçülüp genellenmişti.

Review başka şekilleri ölçtü — **önceden doğru okunanları**:

| hücre | geri almadan önce | geri almadan sonra |
|---|---|---|
| `2026/01` · `2026-1` | `2026-01` ✓ | **`undefined`** → fallback |
| `2026-01-15 00:00:00` · ISO datetime | `2026-01` ✓ | **`undefined`** → fallback |
| `2026/01/15` · `01/15/2026` · `Jan 2026` | `2026-01` ✓ | **`undefined`** → fallback |

Bunlar çöp değildi. Yedisi de sessizce `agreement.periodMonth`'a düşüyordu — çok dönemli bir
anlaşmada **başka bir ay**, yani `findEnvelopeByDimensions` **başka bir zarfı** buluyor ve
bütçe yanlış zarftan iniyor. Kullanıcı hiçbir hata görmüyor.

> **Fallback, birincil kaynak YOKSA meşrudur. Birincil kaynak VARKEN ona düşmek ikamedir —
> ve ikame sessiz olamaz.**
>
> ⚠️ *"Gramerimiz tanımıyor"* okunamamak **değildir**. Değer oradaydı ve okunabiliyordu;
> onu başka bir kaynakla sessizce değiştirmek, `?? 0` kadar bilgi kaybıdır — yalnız daha az
> görünür.

Ve kararın kendisi bir ölçüm hatasından doğdu: **bir girdi şekli ölçülüp genellendi.** Bir
kapsam kararı vermeden önce, o kararın etkilediği girdi kümesini **tara** — tek örnek bir
kümeyi temsil etmez.

### Assert taşıyan migration ÜÇ durumu ayırt etmeli (ZORUNLU)

Tek seferlik veri düzeltmesi içeren bir migration, `rowcount`'u iki değere indirirse
**yalnız bir ortamda çalışabilir** hâle gelir.

Ölçülmüş vaka (2026-08-11, `1802000000000`): brief *"silinen satır 1231 değilse başarısız
olur"* diyordu. İkili yazılsaydı migration **taze/prod bir DB'de kalıcı olarak tıkanırdı**
— orada silinecek **0** satır var, 1231 değil, ve `migrations` tablosuna asla
giremeyeceği için hata **her deploy'da** tekrarlanırdı.

| durum | davranış |
|---|---|
| **beklenen** (ör. 1231 satır mevcut) | işlemi yap + assert |
| **zaten uygulanmış / taze** (0 satır) | **no-op**, sessizce geç |
| **beklenmeyen** (ara bir sayı) | **İPTAL** — küme değişmiş, sessizce geçme |

> **İkiliye indirmek, migration'ı yalnız bugünkü veritabanında çalışabilir kılar.**

⚠️ Ve dalların **en az ikisi ampirik doğrulanmalı** (`run` → `revert` → `run` döngüsü);
yazılmış bir dal, çalıştığı anlamına gelmez.

### ⛔ İPTAL — SoD ROL katmanına taşınmaz (ürün sahibi hükmü, 2026-08-26)

> **Bu başlık bir kural değil, bir İPTAL KAYDIDIR.** `2026-08-26`'da buraya
> *"bir rolün tabi olduğu kuralı yazma yetkisi, o rolün kümesine giremez"*
> diye **bağlayıcı bir sınıf kuralı** yazıldı. **İPTAL EDİLDİ.** Kayıt duruyor
> çünkü *"bu neden yazılmıştı ve neden düştü"* sorusunun cevabı kaybolmasın.

**Teşhis: ne tamamlama ne revizyon — KATMAN KARIŞIKLIĞI.**

`K-2.6.5c` **doğru ve dokunulmaz**: SoD bu sistemde **kişi + işlem** katmanında yaşar.
`L2`'nin üç SoD kuralı da o eksende — *"kim gönderdiyse onaylayamaz"* bir **kimlik
karşılaştırmasıdır**, küme cebiri değil.

```
ROL  katmanı   "bu TÜRE kim dokunabilir"        → küme cebiri
SoD  katmanı   "bu İŞLEMDE bu KİŞİ olabilir mi" → kimlik karşılaştırması
```

📌 Ve bu, `T-276`'da çözülen katman ayrımının (**hücre = tür · yüklem = kademe**)
SoD'a **uygulanmamış** hâliydi: ikisini aynı katmana yazmak, **yüklemi hücreye
gömmekle** aynı hata.

> ### ⇒ YÜRÜRLÜKTEKİ KURAL
> **SoD rol katmanına taşınmaz. Kural-yazma yetkisi bir YÖNETİŞİM sorusudur,
> SoD sorusu değil.**

⚠️ **Ve kural zaten gereksizdi:** `SHARED_POLICY_WRITE = {ADMIN}`'in gerekçesi SoD'a
**muhtaç değil** — `K-2.6.4`'ün gerçek cümlesi (*"tanımlar ve kural yönetimi"*)
yönetişim gerekçesi olarak **yeter**. Küme o cümleden türer; görev-ayrılığı argümanı
**hiç gerekmez**. Bir kural, kendisi olmadan da doğru olan bir sonucu gerekçelendirmek
için yazılmıştı.

#### Nasıl buraya gelindi — zincir İKİ HALKALIYDI

| halka | kim | ne |
|---|---|---|
| 1 | karar paketi | cümleyi `K-2.6.4a/b`'nin **içeriği gibi** sundu |
| 2 | onaylayan taraf | okuyup **ölçmeden** *"`DISIPLIN`'e tek satır"* diyerek **bağlayıcı kural statüsüne terfi** ettirdi |
| 3 | Team Lead | terfiyi **alıntıya** çevirdi ve dört yere yazdı |

**Atıf-ölçüm adımı ikinci halkada atlandı** — ve ürün sahibinin kendi kaydı:
*"bir alıntıyı kurala çevirmeden önce kaynağını yeniden okumak, Team Lead'e
uyguladığım disiplinin ta kendisiydi ve onu kendi çıktıma uygulamadım."*

⇒ **Bir statü terfisi (öneri → bağlayıcı kural), atıfın YENİDEN ÖLÇÜLDÜĞÜ andır.**
Terfi eden taraf kimse ölçüm de ondadır.

### Bağlayıcı kaynağa ATIF vermek, METNİNİ uydurmak değildir (ZORUNLU)

`§2.1.2` bir kaynağın **bağlayıcı** olduğunu söyler. Bu, ona **atıf verme** hakkıdır —
**metnini yazma** hakkı değil.

```
✅  "K-2.6.4 rol kataloğu: YÖNETİCİ | Tanımlar, kural yönetimi"   ← okundu, satırı var
⛔  "K-2.6.4a/b: 'şablonun öznesi olan rol, şablonu düzenleyemez'" ← O CÜMLE YOK
```

⛔ **Bir kural numarasının yanına TIRNAK koymadan önce o satırı AÇ.** Numaralar
hatırlanır, cümleler hatırlanmaz — ve hatırlanan cümle, **hatırlayanın** cümlesidir.

📌 Ölçülmüş vaka (2026-08-26, `Z36`): `düzenleyemez` `L2_03`'te **sıfır** eşleşme;
poz.kontrol `onay` **109**. Cümle ürün sahibinin **kendi ifadesiydi**; dört yere
`L2`'nin metni olarak yazıldı ve biri **bağlayıcı** bir belgeydi.

### Hiçbir şeyi ELEMEYEN bir vaka, kural gerekçesi olamaz (ZORUNLU)

**Pozitif-kontrol ilkesinin GEREKÇE tarafı.**

Bir kuralı *"şu vakada işe yaradı"* diye gerekçelendirirken sor: **o vakada kural
olmasaydı sonuç değişir miydi?** Değişmiyorsa vaka kuralı **kanıtlamıyor**, yalnız
**onunla uyumlu**.

📌 Ölçülmüş vaka (2026-08-26): SoD kuralı *"`FINANCE` politikayı yazamaz"* diye
gerekçelendirildi. Ama küme zaten `@Roles(ADMIN)` idi — `FINANCE` **hiç içeride
değildi**. SoD **elemedi**; **zaten yoktu**.

⚠️ Ve bu, `§2.7 #6`'nın (*"kapsam var, ayırt etme gücü yok"*) **gerekçe tarafındaki**
kardeşi: bir test yeşil olduğu için ayırt etmez, bir gerekçe **tutarlı** olduğu için
kanıtlamaz.


### DURAĞAN yüzeyler bir HİPOTEZ oluşturur, bir BULGU değil (ZORUNLU)

**`§7.1`'in ölçüm tarafındaki kardeşi — ve `T-289` ile ölçülmüş en pahalı vakası.**

`T-289` **dört yüzeyde** ölçülerek yazıldı ve **dördü de DOĞRUYDU**:

```
ekranda requiredRole YOK        ✅ doğru   (poz.kontrol: 40 rotada var)
agreementId SERBEST METİN       ✅ doğru   (useState('') + .trim())
servis anlaşmayı DOĞRULAMIYOR   ✅ doğru
AccessScope atfı SIFIR          ✅ doğru   (poz.kontrol: 7 serviste var)
```

**Sonuç yine de YANLIŞTI.** Repro-pin ucu çağırdı: `500`, her seferinde —
`reserveBudget`, `findEnvelopeWithLock`'ı **transaction'sız** çağırıyor ve
`setLock('pessimistic_write')` bunu **her zaman** reddediyor. Uç, iddia edilen satırı
**hiç üretemiyor**.

> ⛔ **DÖRT DOĞRU DURAĞAN OLGU, YANLIŞ BİR DAVRANIŞSAL SONUCA BİLEŞTİ.**

📌 **Yüzey SAYISI durağanı davranışsala çevirmez.** Dördü de *"kod ne diyor"*du;
hiçbiri *"çağırınca ne oluyor"* değildi. Beşincisi, altıncısı da eklenseydi sonuç
değişmezdi — çünkü eksik olan **sayı değil, CİNS**.

⚠️ Ve bu, `BİLEŞİMSEL FAIL-OPEN`'ın **aynadaki görüntüsü**: orada her parça masumdu,
boşluk bileşimdeydi. Burada her parça **doğruydu**, **hata** bileşimdeydi.

> **Pratik:** durağan yüzeylerden kurulan bir kusur iddiası `VARSAYIM` etiketiyle
> yazılır, `ÖLÇÜLDÜ` ile değil — ve **`ÖLÇÜLDÜ`ye ancak çağrılınca terfi eder.**

> ### ⛔ VE KURAL, ÖLÇENİ DEĞİL HÜKÜM VERENİ DE BAĞLAR (ZORUNLU)
>
> Ürün sahibinin kendi kaydı (2026-08-26): *"`T-289` hükmüm **doğru sonuca yanlış bir
> öncülle** varmıştı. İddiayı `ÖLÇÜLDÜ` sanıyordum, cinsi `VARSAYIM`mış."*
>
> ⇒ **Kusur-iddialı bir kararın gerekçesinde İDDİANIN CİNSİ açıkça yazılır.**
>
> Bir hüküm, dayandığı iddianın **cinsini** devralır: `VARSAYIM`'a dayanan bir karar
> `VARSAYIM`'dır — sonucu doğru çıksa bile. `T-289` bunu gösterdi: **sonuç ayakta
> kaldı** (üç bağımsız sebep), ama **ayakta tutan şey hükmün gerekçesi değildi**.
>
> 📌 `F12` iziyle **emsal**: gerekçe düşürüldü, eski iddia silinmedi.

### ⛔ VE REPRODÜKSİYON ŞARTININ İKİNCİ VAKASI — sayaç artık iki

`§2.7`'nin *"reprodüksiyon şartı YÖNSÜZDÜR"* maddesi `T-273` ile yazılmıştı. `T-289`
**ikinci** vakadır ve bir şeyi keskinleştirir:

| | `T-273` | `T-289` |
|---|---|---|
| iddia | *"ilk gerçek satırda `500` verecek"* | *"uydurma id ile `POSTED` satır üretilebilir"* |
| ölçüm | `500` **hiç görülmedi** | `500` **her zaman** görüldü |
| iddiayı yazan | ölçmemişti | **dört yüzeyde ölçmüştü** |

📌 İkincisi daha öğretici: **ölçüm eksikliği değil, ölçümün YANLIŞ CİNSTEN olması.**
Ve iki vakada da yakalayan şey aynı: **kusuru önce GÖRME şartı.**


### Köken imzası taşımayan bir idempotency anahtarı, PROVENANCE'ı cevapsız bırakır (ZORUNLU)

Bir idempotency anahtarı **tekrarı** engellemek için yazılır. Ama aynı zamanda bir
satırın **nereden geldiğinin** tek kalıcı izidir — ve bu ikinci iş çoğu zaman
düşünülmez.

📌 Ölçülmüş vaka (2026-08-26, `K6(b)`): `reserveBudget` ile **seed** aynı şekli
üretiyor —
```
RESERVE|AGREEMENT|{agreementId}|{envelopeId}     ← İKİSİ DE
```
Bir denetim turu *"bu satırlar hangi yoldan doğdu?"* diye sorduğunda **anahtar cevap
veremedi**; ayrım `amount` + `description` eşleşmesinden geldi — yani **tesadüfen**,
çünkü seed'in tutarı sabitti.

⚠️ Ve tesadüf olmasaydı soru **cevapsız kalırdı**: iki yol aynı tutarı yazsaydı
provenance **kaybolmuştu**.

> **Bir yazma yolunun anahtarına KÖKEN SEGMENTİ koy.** Tekrarı engellemek için
> gerekmez; **hesap sorulabilirlik** için gerekir.


### Bir pin, ÜRETİMİN OKUDUĞU kaynağı ölçmüyorsa pin değildir (ZORUNLU)

**`T-289`'un dersiyle SİMETRİK.** Orada **iddia** yanlış cinstendi (durağan yüzey,
çağrı değil); burada **kanıt** yanlış kaynaktan.

```
T-289    iddia   yanlış CİNS      durağan yüzeyler ≠ çağrı
K3/B1    kanıt   yanlış KAYNAK    testin beslediği ≠ üretimin okuduğu
```

📌 Ölçülmüş vaka (2026-08-26, `K3` `B1`) — üç halka, üçü de masum görünüyor:

```
üretim   FinanceDashboard   rolü useMe()'den okur
test     rolü YALNIZ redux'a koyar
mock     MSW /users/me      KOŞULSUZ 'ADMIN' döner
sonuç    canSeeRestrictedWidgets HER ROL için true
```

**Mutasyon kanıtı:** kapatılmak istenen rol izinli listeye **geri eklendiğinde** — yani
testin önlemek için var olduğu **tam regresyon** — suite **yeşil** kaldı.

> **Bir pin yazmadan önce sor: ÜRETİM bu değeri NEREDEN okuyor?** Cevap testin
> beslediği yer değilse, pin **hiçbir şey ölçmüyor** — ve **yeşil olduğu için**
> ölçtüğü sanılıyor.

⚠️ Ve `§2.7 #6`'dan farkı: orada test **doğru kaynağı** ölçüyor ama **ayırt edemiyor**;
burada test **yanlış kaynağı** ölçüyor. İkisi de yeşil, ikisi de boş.

#### ⛔ VE İKİNCİ YARISI: doğru desen REPODA VARKEN yanlışını yazmak

Aynı turda, **kardeş test dosyasında**, doğru şekil **zaten duruyordu**
(`vi.mock` ile `useMe`'yi role göre döndürmek). **Aynı tur, iki şekil.**

📌 Bu, `S-3`/`T-111` **port-dersi ailesinin test hâli**:

> **Doğru desen repoda varken yanlışını yazmak, desenin ADRESLENMEMİŞ olmasındandır.**

Bir desen *"var"* olması yetmez — **bulunabilir** olmalı. Adreslenmemiş bir desen,
her yazarın **yeniden icat ettiği** bir desendir, ve icatların yarısı yanlış çıkar.

**Pratik:** bir tur içinde aynı problemi ikinci kez çözüyorsan, birincisinin **adını**
ara. Bulamıyorsan **sorun sende değil, adreslenmede** — ve o adres bir yoruma, bir
yardımcıya ya da bu dosyaya yazılır.


### Bir DÖNÜŞÜM boru hattı, YOKLUĞU bir DEĞERE çevirebilir (ZORUNLU)

**`§2.5`'in en sinsi akrabası** — çünkü burada sessiz varsayılanı **sen yazmıyorsun**,
çerçeve **senin varsayılanını devre dışı bırakıyor**.

```
JS varsayılanı  f(m = 12)   YALNIZ argüman `undefined` iken devreye girer
NestJS          ValidationPipe({ transform: true })
                çıplak @Query('x') x: number   →   Number(value)
                parametre YOKSA                →   Number(undefined) = NaN
                                                   ← undefined DEĞİL, bir DEĞER
⇒ varsayılan HİÇ ÇALIŞMAZ
```

📌 Ölçülmüş vaka (2026-08-26, `T-294`):
```
node: f(undefined) → 12      (varsayılan girer)
      f(NaN)       → NaN     (girmez — NaN bir DEĞERDİR)
      setMonth(NaN) → Invalid Date → toISOString() → RangeError → 500
```
Uç **herkes için** kırıktı ve sebebi *"parametreyi göndermemek"*ti — yani **en masum
kullanım**.

⚠️ **Ve iki kusur AYNI KÖKTEN çıktı:** aynı çıplak bildirim hem whitelist çakışmasını
(`400`) hem `NaN`'ı üretiyordu. İlk okuma *"üçüncü bağımsız bir kusur olabilir"*
demişti; **ölçüm hipotezi çürüttü.**

> ### ⇒ VE BU, `T-289` DERSİNİN ÇERÇEVE-SEVİYESİ İKİZİDİR
>
> ```
> T-289   durağan yüzey  dört doğru olgu       ↔  çağrı  yanlış sonuç
> T-294   durağan yüzey  `= 12` GÖRÜNÜR ve DOĞRU görünür  ↔  çağrı  NaN
> ```
>
> **En sinsi olması buradan gelir:** kod okunduğunda varsayılan **görünür** ve
> **doğru görünür**. Kusur ancak **çağrılınca** vardır. Bir kod incelemesi bunu
> yakalayamaz — çünkü yakalanacak şey **kodda değil, boru hattında**.

> **Pratik:** bir çerçeve değeri dönüştürüyorsa, **yokluğun** nereye düştüğünü ölç.
> `undefined` mi kalıyor, `NaN` mı, `""` mi, `0` mı? Dil-seviyesi varsayılanların
> **hepsi** yalnız `undefined`'a duyarlıdır.
>
> ⇒ **Varsayılanı dönüşümün İÇİNDE tanımla** (DTO alanı + doğrulayıcı), imza
> parametresinde değil.

### ⛔ VE BİR ÖRTÜ KALDIRILIRKEN ALTINDAKİ AYNI COMMIT'TE KAPANIR (ZORUNLU)

`§2.7`'nin *"bir kusur, başka bir kusur tarafından örtülebilir"* maddesinin **düzeltme
tarafı**.

`T-294`'te en akla yatkın düzeltme — *"whitelist'e alanı ekle"* — `400`'ü kaldırırdı
**ve altındaki sessiz yanlış değeri AÇARDI**. Yani doğru görünen tek satırlık bir
düzeltme, görünür bir hatayı **sessiz** bir hataya çevirirdi.

> **Bir örtüyü kaldırmadan önce altında ne olduğunu ÖLÇ — ve ikisini AYNI commit'te
> kapat.** Ayrı commit'ler arasındaki pencerede ürün, öncekinden **daha kötü** olur.

⇒ **VE BU, AYRILABİLİRLİK AİLESİNİN ÜYESİDİR** — hakemi *"kusur KİME görünür?"*:

| vaka | ayrılırsa ne olur |
|---|---|
| `T-277` | uç ve onu çağıran ekran ayrı inerse, kullanıcı **çalışmayan bir düğme** görür |
| `T-270` | düzeltme ve ölçümü ayrı inerse, **yanlış sayı** canlı ekranda kalır |
| `T-294` | örtü ve alt-kusur ayrı inerse, **görünür** bir hata **sessiz** bir hataya döner |

> **Bir `SIRA` şartı ayrılabilirlik şartı İÇERMEZ** — ama tersi de doğru: bazı
> düzeltmeler **ayrılamaz**, ve ayrılamazlığın ölçütü *"aradaki pencerede kullanıcı
> ne görür?"*tur. Cevap *"öncekinden kötüsünü"* ise **tek commit**.


### Bir DÜZELTME PİNİ yalnız STATÜ değil, DEĞER doğrular (ZORUNLU)

**`KANIT RENGİN SEBEBİDİR` kuralının YEŞİL tarafı.** O kural kırmızının **sebebini**
sorar; bu, yeşilin **içeriğini**.

```
200  +  yanlış tarih     →  pin YEŞİL, ürün BOZUK
500                      →  pin KIRMIZI, ürün bozuk
```

> **`200` dönen yanlış bir değer, `500`'den SİNSİDİR** — çünkü `500` bir **alarm**
> üretir, yanlış değer **bir KARAR** üretir.

⛔ **Ve bu üründe asimetri KESKİN:** finansal bir sistemde **sessiz sıfırın maliyeti
kırık ekrandan HER ZAMAN büyüktür.**

```
kırık ekran      kullanıcı DURUR, sorar, bekler          → maliyet: ZAMAN
sessiz sıfır     kullanıcı İLERLER, plan yapar, onaylar  → maliyet: YANLIŞ KARAR
```

📌 Ölçülmüş vaka (2026-08-26, `T-296` `B1`): `forecast_vs_actual` `200` dönüp
**planlanan bütçeyi `0`** gösteriyordu. Bir `500` olsaydı kimse ona dayanarak
plan yapmazdı.

📌 Ölçülmüş vaka (2026-08-26, `T-294`): `months=12` düzeltmesi `200` veriyordu ve pin
yeşildi. `code-reviewer` **yetinmedi** ve `endDate`'i ölçtü — `2027` çıktı, `2085`
değil. Yani `2085` hipotezi **orada** çürüdü; statüye bakan bir pin bunu **hiç
söylemezdi**.

⚠️ Ve mutasyon tarafında da aynı: `@Type` kaldırıldığında pin kırmızıya döndü çünkü
**tarih değeri** kırıldı — statü kontrolü olsaydı `400` de bir *"beklenen"* sayılıp
geçilebilirdi.

> **Pratik:** bir düzeltme pini yazarken sor — *"bu test, doğru statüyle YANLIŞ DEĞER
> dönen bir üretimi kırmızıya çevirir mi?"* Cevap hayırsa pin **yarımdır**.


### PİN KÖR-NOKTA AİLESİ — dört tür, hepsi ÖLÇÜLDÜ (ZORUNLU)

Bir pin yeşilse **dört ayrı sebeple** hiçbir şey ölçmüyor olabilir. Dördü de bu
projede **mutasyonla** yakalandı:

| # | tür | ne oluyor | vaka |
|---|---|---|---|
| 1 | **kaynak-yanlış** | test, üretimin okuduğu yerden **başka** bir yeri besliyor | `K3` `B1` — rol redux'ta, bileşen `useMe()`'den okuyor |
| 2 | **cins-yanlış** | iddia **durağan**, kanıt **davranışsal** olmalıydı | `T-289` — dört doğru yüzey, yanlış sonuç |
| 3 | **negatif-yarı-yok** | hücre `5/5`; reddedilen rol **yok**, ayrım **imkânsız** | `W4a` — dekoratör kalksa da pin yeşil |
| 4 | **echo** | test, servisin **girdiyi geri yazdığı** alanı okuyor | `T-296` `B2` — `granularity` echo'su |
| 5 | **hedef-yanlış** | pin, koruduğu iddiayla **hiç kesişmeyen** bir yüzeyi ölçüyor | `K6c/d` `BR-04` — uç **tamamen geri geldi**, pin **yeşil kaldı** |

### ⛔ `5` EN SİNSİSİDİR — ve AYIRT EDİCİ TESTİ AİLEYE STANDART

`BR-04` *"fabrikasyon `agreementId` sınıfı artık yapısal olarak imkânsız"* diyordu.
Ölçüm: dört satırın dördü de değişiklikten **önce** doğmuştu ⇒ **iddia silmeden önce
de doğruydu**. Pin, koruduğu değişiklikle **kesişmiyordu**.

> ### **TAM-GERİ-ALMA MUTASYONU** (ZORUNLU — her davranış-sınıfı turunda)
> **"Bu pin, koruduğu değişiklik TAMAMEN GERİ ALINDIĞINDA kırmızıya döner mi?"**

### ⇒ VE BEKLENTİ TABLOSU — soru *"kırmızı mı"* değil, ***"HANGİ KATMANDA kırmızı"***

⚠️ **Kural ilk yazımında `kaldırma turları` için kurulmuştu; `W5` onu bir GÖÇ turuna
uygulayınca EKSİĞİ çıktı** (ürün sahibi düzeltmesi, 2026-08-26):

| tur sınıfı | tam-geri-almada **kırmızı beklenen** |
|---|---|
| davranış-**DEĞİŞTİREN** | **davranış pini** — `BR-04` dersi: pin **hedefle kesişmeli** |
| davranış-**KORUYUCU** | **statik kapı** (`G7` / `FILTRESIZ` / `G8`) — pin **yeşil kalır ve bu DOĞRUDUR** |

📌 Ölçülmüş vaka (`W5`): `17` rota tamamen `@Roles`'a döndürüldü, pin **yeşil kaldı**
— çünkü göç davranış-koruyucuydu ve **hiçbir HTTP cevabı değişmiyordu**. Kırmızıya
dönen şey **doğru dedektördü**: `G7`, drift satırlarını **isim isim** basarak.

> **"Pin yeşil kaldı" tek başına NE BAŞARI NE KUSURDUR.** Turun **sınıfı**,
> mutasyonun **hangi katmanda** kırmızı üreteceğini söyler — ve **kabul kriteri o
> katmanı ADLANDIRMALIDIR.**

⇒ `W2` review'ının **tamamlayıcılık tablosunun** (*pin ↔ statik kapı, hiçbiri tek
başına yetmez*) genellemesi: ikisi **farklı sınıflarda farklı roller** oynar.

```
satır-mutasyonu       bir satırı bozar        →  pin DUYARLILIĞINI ölçer
tam-geri-alma         değişikliği GERİ ALIR   →  pin-HEDEF KESİŞİMİNİ ölçer
```

Tam-geri-alma **daha güçlüdür**: satır-mutasyonu *"pin bir şey görüyor mu"* diye
sorar, tam-geri-alma *"pin **DOĞRU ŞEYİ** görüyor mu"* diye.

📌 Ölçülmüş vaka (2026-08-26): `code-reviewer` uç + servis + DTO'yu **tamamen geri
yükledi**. `BR-01/02/03` kırmızıya döndü, **`BR-04` yeşil kaldı** — ve tek başına
bırakılsaydı `K6(d)` *"pinli"* sayılacaktı.

⇒ **Bir kaldırma turunun pin kabulü, tam-geri-alma mutasyonunu İÇERİR.**

⚠️ Ve bir ad kuralı: **bir pinin ADI, ölçmediği şeyi VAAT EDEMEZ.** `BR-04`'ün başlığı
*"yapısal olarak imkânsız"* diyordu; **bütünlük gözlemi**ne indirildi.

> **`4` için tek cümle: girdinin echo'su bir DEĞER değil, bir TEL-PROTOKOL kanıtıdır.**
> *"Parametre ulaştı"* der; *"parametre işe yaradı"* **demez**.

⛔ **VE `3` İÇİN BİR İFADE SINIRI** (ürün sahibi, 2026-08-26): bu kuralın
*"geçersiz olduğu"* bir yer **yoktur** — yalnız **tetiklenmediği** yerler vardır.

```
hücre 5/5           →  negatif yarı YOK   →  kural TETİKLENİR, pin kör
hücre {A} / {A,F,P} →  negatif yarı VAR   →  kural TETİKLENMEZ, pin ayırt eder
```

📌 *"Burada geçerli değil"* diye yazılan bir cümle, **altı ay sonra** *"`5/5`
körlüğü çözüldü"* diye okunur. Doğru ifade: **"burada tetiklenmiyor, çünkü negatif
yarı mevcut"** — yani **uygulanamaz alanının dışındayız**, kural düşmedi.

⚠️ Bu, `DISIPLIN`'in kendi metnine uygulanan bir **kapsam disiplinidir**: bir kuralın
**uygulanmadığı** vaka, o kuralın **çürüdüğü** vaka değildir.

### ⇒ VE ÇÖZÜMÜN BİÇİMİ: DEĞER-pini değil, İLİŞKİ-pini (ZORUNLU)

```
DEĞER-pini    expect(dataPoints.length).toBe(90)        ← fixture'a KİLİTLENİR
İLİŞKİ-pini   expect(daily).toBeGreaterThan(weekly)     ← fixture'dan BAĞIMSIZ
```

Bir sayı-pini fixture değiştiği gün **çürür** ve *"testi güncelle"* diye kapatılır —
yani ilk baskıda **teslim olur**. Bir ilişki-pini **mekanizmayı** ölçer: `granularity`
veriyi kovalamayı bıraktığı gün kırılır, fixture büyüdüğü gün **kırılmaz**.

📌 Ölçülmüş vaka (2026-08-26): `daily > weekly > monthly` ve *"iki `comparisonType`
FARKLI `planned` üretir"* — ikisi de **sabit sayı yazmadan** ayırt ediyor.

⚠️ **Ve ilişki-pini de bir fixture şartı taşıyabilir:** aynı turda ölçüldü ki
**varsayılan tarih aralığı** üç granülaritede de **tek** nokta veriyor (`1/1/1`) —
ayrım fixture'ın değil, **aralığın yokluğundan** kayboluyordu. İlişki ölçen bir pin,
ilişkinin **görünür olduğu** girdiyi de kurmalıdır.


### Bir rota-GENİŞLEMESİ ne zaman BİLGİ-AÇILIMI sayılmaz (ZORUNLU — çift ölçüm)

Bir role yeni bir rota açmak, ona **yeni bilgi** vermek anlamına gelmeyebilir. Ama bu
bir **iddiadır** ve **iki bağımsız ölçüm** ister — biri yetmez.

> **rota-genişlemesi bilgi-açılımı SAYILMAZ ⟺**
> **(1)** genişleyen rol, **aynı bilgiyi** eşit yüklemli **başka bir rotadan** zaten
> alabiliyor **∧**
> **(2)** türetilmiş çıktılar (toplamlar, özetler, sayımlar) **ham erişimden
> türetilebilir**

⛔ **`(1)` TEK BAŞINA YETMEZ.** *"Aynı satırlar"* bir cevaptır ama **eksik** bir
cevaptır: bir uç, ham satırlardan **çıkarılamayan** bir toplam ya da özet üretiyorsa,
o uç **yeni bilgi** verir — satırlar aynı olsa bile.

📌 Ölçülmüş vaka (2026-08-26, `K2` ledger-üçlüsü) — **ikisi de yapıldı**:

| ölçüm | ne | sonuç |
|---|---|---|
| **(1) satır-eşitliği** | `GET /ledger/envelope/X` ↔ `GET /ledger?budgetEnvelopeId=X` | `json` **eşit** · tenant yüklemi aynı · alan kümesi aynı · sayfalama **hiçbirinde yok** |
| **(2) türetilebilirlik** | `/consumed` = `sumByEnvelopeId` | ham satırlardan `DEBIT − CREDIT` = **birebir** aynı |

⇒ Kısıt **fiilen bir bypass'tı**; genişleme `Z18`'in *"yazılı cümle"* şartını
tetikleyen sınıfta **değil**.

⚠️ **Ve gerekçe hiyerarşisi doğru yazılmalı:** hüküm *"bypass'tı, dolayısıyla bilgi
açılımı değil"*dir — **iki ölçüme yaslanır**. İleride benzer bir hizalamada yalnız
birincisi yapılırsa **hüküm yarım kalır**.

### `Kayıt taraması`nın KANONİK komutu `git log -L`'dir (ZORUNLU)

```
git log -S '<dizge>'          ← İÇERİĞİ arar: dizgenin doğuşunu/ölümünü bulur
git log -L <aralık>:<dosya>   ← SATIRIN TARİHİNİ izler
```

⛔ **`-S` bir `@Roles` satırını DEĞİŞTİREN commit'i GÖRMEZ** — çünkü aradığı dizge
(rota yolu) o commit'te ne doğuyor ne ölüyor.

📌 Ölçülmüş vaka (2026-08-26, `K2`): ajan `-S 'envelope/:envelopeId'` ile taradı ve
*"kayıt yok"* dedi. Sonuç **doğruydu** ama **yöntem dardı**: `-L` ile bakıldığında
kümeye dokunan **dört** commit çıktı (üçü salt yeniden adlandırma), ve asıl soru —
*"hiçbir commit `PLANNER`'ı ÇIKARMIŞ mı?"* — ancak `-L` ile cevaplanabildi.

> **Bir `DUR` şartı bir komutla yazılıysa, o komut şartı GERÇEKTEN ölçmelidir.**
> Sonucun doğru çıkması yöntemi doğrulamaz.

### ⛔ BİR İSTİSNA KALKTIĞINDA, ONA YASLANAN KARARLAR YENİDEN OKUNUR (ZORUNLU)

**Üç vaka, üç ayrı tur — desen artık adlı.**

| vaka | boşa düşen gerekçe |
|---|---|
| `Z21`-POST | *"e2e göçünce koşul karşılandı"* — **kimse dönüp bakmadı** |
| `Z37`-LTA | *"kardeş emsal"* — emsal ölçümde **kimlik değiştirdi** |
| `T-297` `W3`-`GET /users` | *"göçürmek `FINANCE`'ı düşürürdü"* — `K1` `FINANCE`'ı **zaten düşürdü** |

**Ortak kök:** *koşullu kararlar, koşulun **ölçüm adresiyle** yaşamalı.*

Bu, `OPEN_DECISIONS` mekanizmasına *"koşul gerçekleşince iş açılır"* diye önerilmişti.
`T-297` kuralın **ters yönde de** gerektiğini gösterdi:

```
ileri yön   koşul GERÇEKLEŞİNCE   →  bekleyen iş AÇILIR
geri yön    istisna KALKINCA      →  istisnaya YASLANAN kararlar YENİDEN OKUNUR
```

⇒ **Pratik:** bir istisnayı kaldıran ya da değiştiren her tur, o istisnaya **atıf
veren** karar/brief/yorum satırlarını **tarar**. Tek `grep` sınıfı iş — ve `E6`'nın
**karar-katmanı** hâli.


### Bir rotanın ÖLÜMÜ, komşularının UNION-GEREKÇESİNİ de öldürebilir (ZORUNLU)

*"İstisna kalkınca yeniden-okuma"* kuralının **küme-cebiri** hâli.

📌 Ölçülmüş vaka (2026-08-26, `K6c/d`): silinen `POST /budget/reserve`, kalıntı
`SHARED_WRITE` union'ındaki **`PLANNER`'ın TEK KAYNAĞIYDI**.

```
ÖNCE   5 rota:  budget/reserve {ADMIN,PLANNER} + LTA×4 {ADMIN}   → union {ADMIN,PLANNER}
SONRA  4 rota:  LTA×4 {ADMIN}                                     → union {ADMIN}
```

⇒ Bir rota silmek yalnız **envanteri** değil, komşularının **küme yapısını** değiştirdi.
Ve ilk düzeltme **sayıyı** (`5→4`) düzeltip **değeri** bıraktı.

> **Bir rota öldüğünde sor: bu rota, bir kümede TEK KAYNAK mıydı?** Öyleyse o kümeye
> yaslanan her gerekçe **yeniden okunur** — sayısı da, **değeri de**.

⚠️ Aynı etki `MODES_READ` kararında da çıkabilir (`T-299`: yedi ayrı rol kümesi).


### İMKÂNSIZLIK KONTROLÜ — tuhaflık-dedektörü ailesinin EN UCUZ üyesi (ZORUNLU)

Bir ölçüm çıktısına bakarken sor: **bu değer MÜMKÜN MÜ?** Kapsam, tanım ya da fizik
gereği olamayacak bir sayı, **ölçümün kendisinin bozuk olduğunun** en hızlı işaretidir.

📌 Ölçülmüş vaka (2026-08-26, `T-302`): bir yetenek envanteri `CUSTOMER_READ = 0 rota`
gösterdi. **İmkânsız** — o hücre `5/5` ve modülün on `GET`'i ona bağlanacak. Sayıyı
şüpheli kılan şey **bağlamı** değil, **imkânsızlığı**ydı; ölçüm yorum satırlarını da
sayıyordu.

```
⛔ "bu sayı düşük görünüyor"      ← sezgi, tartışılır
✅ "bu sayı OLAMAZ"               ← kapsam ihlali, TARTIŞILMAZ
```

> **Bir hipotezi çürütmek için argüman gerekir; bir ÖLÇÜMÜ çürütmek için tek bir
> imkânsız değer yeter.**

⚠️ Ve ucuzluğu buradan: imkânsızlık kontrolü **alan bilgisi istemez, karşılaştırma
istemez, taban istemez** — yalnız *"bu değerin alabileceği aralık ne?"* sorusunu.

### ⇒ VE BİR SAYIM FARKI, KAYNAĞI GÖSTERİLMEDEN YORUMLANAMAZ — ek vaka

Aynı turda: elle sayım **`48`**, kanonik araç **`45`**. Fark **açıklandı**:
`15` satır **yorum içinde** `@RequireCapability` geçiriyordu, üçü de
`(CAPABILITIES.X)` biçiminde ve regex'e takıldı.

⇒ Fark **açıklanınca** sayı `45`'e oturdu ve envanter güvenilir oldu. Açıklanmasaydı
`3`'lük bir sapma **sessizce** taşınacaktı — ve bu envanter **bir kararın girdisiydi**.

> **Bir yorum, kodun sayımını ŞİŞİRİR — asla azaltmaz.** Bu yön bilgisi bir sayım
> farkını teşhis ederken **ilk bakılacak yerdir**.


### İSTİSNA LİSTELERİ DE BİRER KAPIDIR — ve kapının kendisi kadar disiplin ister (ZORUNLU)

**`Z29` ailesinin istisna-listesi maddesi.**

Bir kapıya *"bunlar hariç"* listesi eklemek, kapıyı **zayıflatmanın en kolay yolu**dur
— ve fark edilmesi en zor olanı, çünkü liste **kapının içinde** yaşar ve **yeşil**
görünür.

> ⛔ **Bir istisna listesindeki HER GİRİŞ bir KARAR KAYDI adlandırmak ZORUNDADIR.**
> Kayıtsız bir giriş **hâlâ ihlaldir** — yoksa liste bir **"sustur" düğmesine** döner.

📌 Ölçülmüş vaka (2026-08-26, `G8`): hayalet-hedef yönü `SHARED_WRITE`'ı yakaladı
(hücre düştü, rotaları henüz göçmedi). Kayıtlı istisna olarak karşılandı **ama
şartıyla**: `'SHARED_WRITE': 'Z39 §4 / T-293'` — giriş **kararını adıyla söylüyor**.

### ⇒ VE BİR İSTİSNA GİRİŞİ **TAŞIYICI OLDUĞU ÖLÇÜLEREK** YAZILIR (ZORUNLU)

> **"Bu giriş kaldırılırsa kapı BUGÜN kırmızıya döner mi?"**
> Cevap **hayırsa giriş GEREKSİZDİR** — ve gereksiz bir giriş **görünmez zarardır**:
> bugün hiçbir şeyi susturmaz, **yarın susturur**, ve kimse fark etmez.

⛔ **Ölçülmüş vaka — ve kuralın YAZILDIĞI TURDA (2026-08-26):** `G8`'in `BEKLEYEN`
listesi **dokuz** üyeyle yazıldı; ölçüldüğünde **sekizi taşıyıcı değildi** — o hücreler
**zaten üretiliyordu**, yani `olu` kontrolüne **hiç düşmüyorlardı**.

```
yazılan     9 üye  ("W6/W7/W8 bekliyor" sezgisiyle)
taşıyıcı    1 üye  (MASTER_DATA_MANAGE — bildirilen ama HİÇ üretilmiyor)
```

Liste **bire indirildi** ve kalan üye **mutasyonla kanıtlandı**: çıkarıldığında kapı
`exit 2` verip hücreyi **adıyla** söylüyor.

⚠️ **Ve mutasyonun ilk denemesi bir KURULUM HATASIYDI**: girişi bir yorumla
değiştirmek `BEKLEYEN`'i **boş dict**'e çevirdi (`{}` Python'da set değil dict) ⇒
`TypeError`, `exit 1`. *Derlenmeyen mutasyon kanıt değildir* — sözdizimi korunarak
tekrarlandı.

⚠️ Aynı disiplin `BEKLEYEN` listesine de uygulandı: kalan üye **gerekçesiyle**
bekliyor, ve **dalga kapanışında satırı düşer** — *"hangi turun işi"* sorusu cevapsız
kalmıyor (`DISIPLIN`: *"11 iyileşme birikti çünkü hangi turun işi olduğu yazılı
değildi"*).

### ⇒ VE İKİ-YÖNLÜ BİREBİRLİK KAPILARININ DEĞERİ — ölçülmüş

`G8` iki yön taşıyor; ikincisi (**hayalet hedef**) tasarımda *"simetri olsun"* diye
vardı ve **ilk koşumda gerçek bir bulgu verdi**.

```
tek yönlü yazılsaydı (yalnız "bildirilen ∖ üretilen")  →  hayalet sınıfı GÖRÜNMEZ kalırdı
```

> **Bir birebirlik iddiası İKİ YÖNLÜDÜR.** `A ⊆ B` ile `B ⊆ A` **ayrı kusurları**
> yakalar, ve yalnız birini yazmak diğerini **yapısal olarak** kör bırakır.

### `Yetkiler DB'de mi, kodda mı?` — cevap İKİLİ (ZORUNLU)

İki ayrı katman, iki ayrı ev — ve **çelişmezler**:

```
rol → YETENEK      KOD    capabilities.ts · kapılarla denetlenir (G5/G6/G8)
                          `0056-K3(b)`: "yetenekler KOD, veri DEĞİL"
                          (main.capabilities tabloları migration'la DÜŞÜRÜLDÜ)

kişi → KAPSAM      VERİ   user_scopes · `H8`: "kapsamsızlık bir KAYITTIR"
```

📌 Bu cümle **açık durmalı**, çünkü altı ay sonra *"yetkiler DB'de mi kodda mı?"*
sorusunun cevabı **tek kelime değil**: **rol→yetenek kodda, kişi→kapsam veride.**


### ⛔ GÖSTERİP GEÇEN KAPI — kapı kör-nokta ailesinin EN SİNSİ üyesi (ZORUNLU)

Bir kapının **susması** kötüdür. **Kusuru gösterip geçmesi** daha kötüdür.

> **Bir kapının çıktısı EXIT KODUNA bağlanmamışsa, kapı YOKTUR.**
> **Göstermek görmemekten TEHLİKELİDİR — çünkü GÖRÜLMÜŞ SAYILIR.**

📌 Ölçülmüş vaka (2026-08-26, `W6` `B1`): `Z35`'in yasakladığı tam şey yapıldı
(`PLANNER`'a `MODES_ACTUALS_WRITE`) ve `G5` şunu **ekrana bastı**:

```
G5 EXPECT[MODES_ACTUALS_WRITE] = ['ADMIN', 'FINANCE', 'PLANNER']
G5 Z35 bolunmesi   uye=0  @Roles uyusmazligi=0
→ exit 0
```

İhlal **çıktının içinde**, ve kapı **geçiyor**. Bir denetçi bu bloğa bakıp *"`G5`
kontrol ediyor"* der — **kontrol etmiyor, yazdırıyor**.

⚠️ **Log satırı denetim DEĞİLDİR.** Bir değeri basmak, onu **karşılaştırmak** değildir.

### ⇒ VE KAPI YAŞAM-DÖNGÜSÜNÜN KANONİK ZİNCİRİ (`G5 → G5b`)

Bu vaka bir kapının **nasıl öldüğünü ve nasıl yeniden doğduğunu** uçtan uca gösterdi:

```
1  kapı DARALTILDI          gerekçe MEŞRU (Z29: göçün BAŞARISINI hata sayıyordu)
2  evreni BOŞALDI           §2.7 #9 — "sinyal sabitse sinyal değildir"
3  "devir kanıtı" yazıldı   boşluğu ANLATAN bir metin
4  kanıtın iki dalı         YAPISAL OLARAK ERİŞİLEMEZ çıktı
                            ⇒ #9'a verilen cevap #4'ün (kanıt kurulumu ölçülen
                              durumu üretir) YENİ BİR VAKASI oldu
5  ve asıl kusur            kapı ihlali GÖSTERİP GEÇİYORDU
```

**Yeniden doğuş biçimi — `dördüncü soru` disiplini:**
```
referans   DONDURULMUŞ karar kaydından   ← kod kendi kendini doğrulamıyor
evren      KAYNAK KOD, rota değil        ← boşalamaz
kanıt      İKİ YÖNLÜ mutasyon            ← hem ihlal hem referans bozulması
```

> **Bir kapıyı daraltırken sor: daralttıktan sonra bu kapı HÂLÂ KIRMIZI VEREBİLİR Mİ?**
> Cevap *"evren boşalırsa hayır"* ise, daraltma bir **düzeltme değil bir devirdir** —
> ve devir **ölçülür**, anlatılmaz.

### Kural yazan tur, kuralın KENDİ ÜSTÜNDEKİ ilk mutasyonunu da koşar (ZORUNLU)

*"Kuralı yazdığın tur"* sayacı bir **tur-sınıfı** doğurdu:

> **Bir kural yazıldığı turda, o kural KENDİ ÇIKTISINA uygulanır — ve uygulama bir
> METİN değil bir MUTASYONDUR.**

📌 Ölçülmüş vaka (2026-08-26): *"istisna listeleri de birer kapıdır"* kuralı yazıldı,
**aynı turda** `G8`'in `BEKLEYEN` listesi ölçüldü — **dokuz üyeden sekizi taşıyıcı
değildi**. Liste **bire** indirildi ve kalan üye **mutasyonla** kanıtlandı.

```
kural yazıldı        →  kendi listesine uygulandı  →  9 üyeden 8'i düştü
                     →  kalan üye MUTASYONLA sınandı (çıkarılınca exit 2)
```

⚠️ Ve mutasyonun **ilk** denemesi bir **kurulum hatasıydı** (`BEKLEYEN`'i boş dict'e
çevirdi ⇒ `TypeError`) — *derlenmeyen mutasyon kanıt değildir*, sözdizimi korunarak
tekrarlandı.


### ⚠️ TIRNAKSIZ `$F` TUZAĞI TEKRARLADI — ve bu kez SAHTE YEŞİL ÜRETTİ (ZORUNLU)

Bu tuzak `ADIM 0` turunda iki kez kaydedilmişti (*"iki false-green `diff`"*). **Üçüncü
vaka (2026-08-26, `W7`) yeni bir şekil gösterdi.**

```bash
FILES=$(... çok satırlı liste ...)
cp $FILES /tmp/       # ← tırnaksız, ve komut TEK DOSYA ADI sanıyor
for f in $FILES; ...  # ← aynı hata
```

**Sonuç:** hiçbir dosya kopyalanmadı, hiçbir dosya geri alınmadı — ve ölçüm
**değişmemiş ağaç** üzerinde koştu:

```
pin        YEŞİL   ✅ (doğru görünüyor)
statik kapı YEŞİL   ⛔ oysa KIRMIZI olmalıydı
okuma      "tam-geri-alma yapıldı, statik kapı da görmüyor"  ← SAHTE
```

⛔ **Ve bu okuma bir kapıyı KÖR ilan ederdi** — yani düzeltme turu başlatırdı, tıpkı
`§2.7`'de kayıtlı *"çalışan bir self-test'i kör sanmak"* vakaları gibi.

> **Bir mutasyonun UYGULANDIĞINI, mutasyonu KURAN komutun başarısından değil,
> HEDEFİN İÇERİĞİNDEN doğrula.**

**Pratik — çok satırlı dosya listesi için tek güvenli şekil:**
```bash
... > /tmp/liste.txt
while read -r f; do <işlem> "$f"; done < /tmp/liste.txt
```
Ve **pozitif kontrol zorunlu**: işlemden sonra hedefte **beklenen değişikliği say**
(`kalan @RequireCapability: 0` · `@Roles satırı: 45`) — sayı beklenmedikse **ölçüm
değil, kurulum** hatalıdır.

📌 Ve `ADIM 0` vakalarıyla farkı: orada tuzak **boş çıktı** üretiyordu (iki boş dosya
`diff` → `rc=0`); burada **hiç çalışmayan bir mutasyon** üretti. İkisi de **yeşil**,
ikisi de **yalan**.


### *"ZATEN"* BİR ÖLÇÜM EMRİDİR, MUAFİYET DEĞİL (ZORUNLU)

Bir turda *"bu **zaten** ölçülmüştü / **zaten** öyle / **zaten** kapsanıyor"* cümlesi
geçiyorsa, o cümle bir **kısayol değil, bir DURAK**tır: *"zaten"*in **hangi turda,
hangi kapsamda, hangi araçla** ölçüldüğü sorulur.

**Üç ölçülmüş vaka — üçü de farklı özneden:**

| vaka | *"zaten"* neydi | gerçek |
|---|---|---|
| spesifikasyon | *"bu şart zaten yazılı"* | şartın **sağlayıcısı yoktu** ⇒ erteleme değil **kilit** (`Z25`) |
| `G8` `BEKLEYEN` | *"bu dokuz hücre zaten bekliyor"* | **sekizi taşıyıcı değildi** — `olu` kontrolüne **hiç düşmüyorlardı** |
| `W7` tam-geri-alma | *"`W2`'de zaten ölçülmüştü"* | `W2` **kendi** değişikliğini ölçtü; arada **dört dalga + iki kapı revizyonu** var |

> **Başka bir turun ölçümü, BU turun kanıtı değildir.**

📌 Üçüncüsü **bayat-devir ailesinin kabul-kriteri hâli**: bir ölçümün **konusu** o
turun **kendi diff'idir**; konusu değişince ölçüm **devredilemez**.

### Bir MUTASYON da bir ÖLÇÜMDÜR — etkisi kanıtlanmamış mutasyon hiçbir şeyin kanıtı değildir (ZORUNLU)

Ve bu tuzağın **en tehlikeli** üyesi, çünkü **yönü ters**:

```
önceki iki vaka   SAHTE YEŞİL     boş girdi → "doğrulama geçti" sanılır
W7 vakası         SAHTE TEŞHİS    hiç çalışmayan mutasyon
                                  → "kapı görmüyor" okuması
                                  → ÇALIŞAN kapı KÖR ilan edilir
                                  → ve muhtemel sonraki adım kapıyı "TAMİR" etmek:
                                    SAĞLAM MEKANİZMAYA MÜDAHALE
```

⛔ Sahte yeşil bir **eksik yakalama**dır; sahte teşhis bir **yanlış müdahale**
üretir. İkincisi geri alması **daha pahalıdır**.

### ⇒ VE POZİTİF KONTROLÜN ÜÇÜNCÜ NESLİ

```
1. nesil   GİRDİ VAR MI            "aynı grep bilinen bir eşleşmeyi buluyor mu"
2. nesil   ARAÇ ÇALIŞIYOR MU       "filtre/desen gerçekten filtreliyor mu"
3. nesil   MÜDAHALE GERÇEKLEŞTİ Mİ "mutasyon HEDEFİN İÇERİĞİNDE görünüyor mu"
```

📌 `W7`'de üçüncü nesil kullanıldı ve tuzağı **o yakaladı**:
`kalan @RequireCapability: 0` · `@Roles satırı: 45` — beklenen sayılar tutmasaydı
**ölçüm değil, kurulum** hatalı sayılacaktı.

### KÖR-NOKTA TÜRLERİ MUTASYON TÜRÜNE GÖRE AYRIŞIR (ZORUNLU — bir daraltma)

`W4a`'nın *"`5/5` hücrede pin kördür"* cümlesi **fazla kabaydı**. `W7` ölçtü:

| mutasyon türü | `5/5` hücrede pin |
|---|---|
| **dekoratör DÜŞMESİ** (`@RequireCapability` kalkar) | **KÖR** — beş rol de hâlâ `403` almıyor |
| **ÜYELİK DARALTMASI** (bir rol hücreden çıkar) | **GÖRÜYOR** — pin'in pozitif yarısı **rol-granüler** (`it.each`) |

> **Bir kör-nokta iddiası, HANGİ MUTASYONA karşı kör olduğunu söylemelidir.**
> *"Pin kördür"* eksik bir cümledir; *"pin **şu** mutasyona karşı kördür"* tam.

### ⇒ VE PİN, HANGİ KAPIYA YASLANDIĞINI DA SÖYLER

*"Pinin ne ölçmediği başlığa yazılır"* kuralının **bağımlılık yönü**:

```
pin  →  yetenek ÜYELİĞİNİ tutar        (global ⇒ örnekleme yeter)
G6   →  rota→hücre ATAMASINI tutar     (45 rotanın HEPSİNDE)
⇒ örnekleme yeterlidir AMA G6'ya KOŞULLU; G6 daralırsa altı controller
  SESSİZCE korumasız kalır
```

📌 Ölçüldü: örneklenmemiş bir controller'da hücre kaydırması → pin **yeşil**,
`G6` rotayı **adıyla** yakaladı.

### TEK-ÜRETİCİ İLKESİNİN SON İSTİSNASI KAPANDI

Bir artefaktın **bir kısmı** üretilip **bir kısmı elle** yazılıyorsa, elle yazılan
kısım **her yeniden üretimde kaybolur** — ve kaybı gören kapı **yoksa** sessizce
tekrarlar.

📌 Vaka (`W7`): TSV'nin dört `#` satırının dördü de elle ekleniyordu; üçü
hatırlandı, **sütun başlığı unutuldu**. Ve `G7` `#` satırlarını **filtrelediği için
bunu yapısal olarak göremiyordu**.

> **Artefakt KENDİNİ TARİF ETMELİDİR.** Başlık üreticiye taşındı ⇒ elle-hatırlama
> sınıfı kapandı.


### ⛔ KARAR-GİRDİSİ YÜZEYLERİ, KARARINDAN **ÖNCE** TARANIR (ZORUNLU — beşinci satır)

`İstisna kalkınca yeniden-okuma` kuralının tarama yüzeyi **dörttü** (kod · `docs/` ·
backlog · karar-girdisi paketleri). **Beşinci satır bir ZAMANLAMA şartıdır:**

> **Bir karar oturumundan ÖNCE, o kararın okunacağı yüzeyler TAZE olmalıdır.**

**Dört vaka, ve ortak özellikleri ZAMANLAMA:**

| vaka | bayat cümle **nerede** duruyordu |
|---|---|
| `B3_KARAR_BEKLER_PAKETI` | ürün sahibinin **karar girdisi** |
| `BACKLOG.md` | **her oturum** context'e enjekte edilen yüzey |
| kaza-dalgası brief'i | **bir sonraki turun** girdisi |
| `capabilities.ts` (`W8` `S2`) | **karar oturumunun okuyacağı** kanonik dosya |

📌 **Dördünün ortak özelliği:** bayat cümle hep **bir sonraki kararın girdi
yüzeyinde** duruyordu. Yani zarar *"bir belge eskidi"* değil — **karar yanlış veriyle
verilecekti.**

⇒ **Pratik:** paket masaya gelmeden **tek geçişlik bir ön-doğrulama**: paketin
dayandığı **sayılar ve cümleler** kendi içinde güncel mi? Bu, *"`Z35`-sonrası
damgası"* deseninin **paket hâli**.

### Bir kapı ağının KENDİ SAĞLIĞINI ölçmesi (ZORUNLU — `G5`'in dersi PROAKTİF)

`G5`'in ölüm-diriliş zinciri bir ders bıraktı: **bir kapının evreni boşalabilir**, ve
boşaldığında kapı *"temiz"* ile *"ölçecek bir şey yok"*u **aynı çıktıyla** raporlar.

⇒ **O ders bir sonraki kapıda PROAKTİF ölçüldü.** `W8`'de `G8`'in `BEKLEYEN` listesi
**boşaldı** (`MASTER_DATA_MANAGE` düştü). Soru **sorulmadan** ölçüldü:

```
mutasyon   sıfır-rota bir hücre EKLE
sonuç      G8 exit 2, hücreyi ADIYLA söylüyor
⇒          liste BOŞALDI, kapı BOŞALMADI
```

> **Bir kapı ağı olgunlaştığında, kendi kör noktalarını da ÖLÇER** — ve bu ölçüm bir
> **arıza raporundan** değil, bir **önceki kapının dersinden** doğar.

📌 `§2.7 #9`'un *"tetiklenmedi"* ile *"geçersiz"* ayrımı burada da geçerli: kapı
boşalmadığı **ölçülerek** söylendi, varsayılarak değil.

---

## İki kanıt ÇATIŞTIĞINDA: **PROVENANCE KAZANIR** (ZORUNLU)

Bu gövde iki kanıt türünü uzun süre **birbirini destekler** hâlde ölçtü: bir kaydın
yokluğu ve bir yolun davranışsal ulaşılamazlığı. İkisi hep **aynı yöne** baktı, ve o
yüzden hangisinin hakem olduğu hiç sorulmadı.

**Ölçülmüş vaka (2026-08-26, `Z42 §1` — `plans/:id/budget-check`):** ilk kez **zıt**
yöne baktılar.

```
KAYIT      34e04aa  "F9: PLANNER kendi planının budget-check'ine
                      erişemiyordu → düzeltildi (403→200)"
           diff: {ADMIN, MANAGER, READONLY} → +PLANNER
           ⇒ ADIYLA · KUSUR NUMARASIYLA · GEREKÇESİYLE      =  KASIT

DAVRANIŞ   tek tüketici → ekran kapısı {ADMIN, CM, READONLY}
           PLANNER YOK · kapı cc654c2'de YANLIŞ KARDEŞTEN türetilmiş
           ⇒ ÖLÇÜLMÜŞ                                        =  KAZA
```

### Hüküm

> **Çatışmada iki sinyalin de DOĞUM BELGESİ okunur.**
> **Hangisi KARAR, hangisi KAZAysa — KARAR kazanır.**
> **İkisi de kazaysa CÜMLE-TESTİ hakemdir.**

### ⛔ Ve bir kuralın KAPSAMI daraldı — TESPİT aracı ≠ HÜKÜM aracı

*"Davranışsal ulaşılamazlık kayıt aramaktan ucuzdur"* bir **tespit** kuralıdır: nereye
bakılacağını söyler. **Hüküm** kuralı değildir: neyin doğru olduğunu söylemez.

> **Ucuz bir sinyal, tarama sırasını belirler — karar sırasını değil.**

Bu ayrım olmadan kural şunu üretirdi: *"bugün UI'dan ulaşılamıyor ⇒ üyelik kazadır"* —
ve o cümle, **kaydı bulunan** bir kararı, **kaydı bulunan** bir kazanın lehine silerdi.

### Kuralın İKİ YÖNDE de çalıştığı ölçüldü

| vaka | kayıt | davranış | hüküm |
|---|---|---|---|
| `#9` `plan-performance` `PLANNER` | ⛔ yok | ⛔ ulaşılamaz | **düşer** — iki sinyal de kaza yönünde |
| `#5` `budget-check` `PLANNER` | ✅ `F9` | ⛔ ulaşılamaz | **korunur** — kasıt kazaya yenilmez |

📌 Aynı kural, zıt iki sonuç. Bir hüküm kuralının **ayırt etme gücü** budur: her iki
girdide **aynı** cevabı veren bir kural, kural değil bir **varsayılandır**.

### ⚠️ Ve bu emsal `git log -L` kuralına İKİNCİ hüküm-deviren vakasını yazdı

`F9` kaydı bir `@Roles` satırının **tarihindedir**, metninde değil. `-S` ile taransaydı
**görünmezdi** — ve o hâlde `#5` de `#9` gibi *"kayıt yok"* diye sınıflanır, `PLANNER`
düşer, ve **bu emsal hiç doğmazdı.**

> **Bir tarama yönteminin seçimi, bir hükmün sonucunu değiştirebilir.** Yöntemi
> ölçümle birlikte yaz.

### Ve ulaşılamazlığın kendisi kaybolmaz — ADRESLENİR

Kasıt kazandığında kaza **affedilmez**, bir **yüzey sorusuna** dönüşür. `#5`'te ürün
sahibinin hükmü: düzeltme *"onaycı sayfasına `PLANNER` ekle"* **değildi** — o yüzey
`PLANNER`'ın yeri değil; gerçek tüketici yüzeyi **gönderim-öncesi kontrol**.

> **Bir yetki kararını doğrulamak, onu YANLIŞ YÜZEYE bağlamayı meşrulaştırmaz.**

---

## Bir kapının EVRENİ, koruduğu şeyle BİRLİKTE BÜYÜMÜYORSA kapı küçülür (ZORUNLU)

Bu gövde `G5`'in **ölüm-diriliş** zincirini kaydetti: kapının evreni (`@Roles` rotaları)
**boşaldı**, kapı kör kaldı, ve yerine `G5b` bağımsız bir **dondurulmuş referansla**
kuruldu. O kayıt şöyle bitiyordu: *"evren asla boşalmaz (kaynak kod, rota değil)."*

**O cümle doğruydu — ve YETMİYORDU.** Evren **boşalmadı**; **DONDU**.

**Ölçülmüş vaka (2026-08-26, `W9` review BLOCKER 1):**

```
G5b'nin evreni     iki hücre   (Z35'in bölünmesi)
W9 açtı            BEŞ yeni hücre
tabloya girdi      SIFIR
⇒ kapı bu beş hücrenin ROL KÜMESİNİ hiç görmüyordu
```

Ve **mutasyonla kanıtlandı** — `ROLE_CAPABILITIES[READONLY] += MODES_LEDGER_READ`,
yani dalganın **tek yasağının** ihlali:

```
npm run guards      exit 0        npm test   exit 0        guard çıktısı FARK YOK
POZ. KONTROL: aynı genişleme MODES_ACTUALS_WRITE'a → exit 1, kapı ADIYLA söylüyor
```

⇒ Mekanizma **vardı ve çalışıyordu**. Eksik olan **kapsamıydı**.

### ⛔ VE "BEŞ SATIR EKLE" DÜZELTMESİ, KUSURU YENİDEN ÜRETİR

Review'un önerdiği minimal düzeltme (*"`Z42_HUKUM`, aynı desen, beş satır"*) **bugünü**
kapatırdı. Ama evren yine **elle** bakılan bir liste kalırdı ⇒ **bir sonraki dalga aynı
deliği yeniden açardı.**

> **Bir listenin bayatlaması bir BAKIM sorunuysa, çözüm bakım değildir — çözüm,
> listenin EKSİKLİĞİNİ ölçen ikinci bir kapıdır.**

Uygulanan şekil (`G5c`), ve bu repoda **kanıtlanmış bir desendir** (`G8`'in
`bildirilen ↔ üretilen` çiftinin aynısı):

```
G5b   tablodaki her hücrenin kümesi  ==  canlı harita        → sessiz genişlemeyi yakalar
G5c   göçmüş rota taşıyan her hücre  ∈   tablo               → EVRENİN DONMASINI yakalar
```

`G5c` mutasyonla sınandı: bir hücre tablodan **düşürüldü** → `exit 2`, hücreyi **adıyla**
söyledi. Geri yükleme `shasum -a 256 -c` ile doğrulandı, `git checkout` **kullanılmadı**.

### 📌 Ve bir kural, kendi karşı-vakasıyla birlikte okunur

Bu gövdeye bir gün önce *"bir kapı ağı olgunlaştığında kendi kör noktalarını da
ÖLÇER"* yazılmıştı — `G8`'in `BEKLEYEN` listesi boşaldığında sorunun **sorulmadan**
ölçülmesi örnek gösterilerek.

**Aynı turda `G5b`'nin evreni sessizce dondu ve kimse sormadı.**

> **Bir kapı ağının olgunluğu, bir HUY değil bir ÖLÇÜMDÜR** — ve bir kapıda
> yapılması, komşu kapıda yapıldığı anlamına gelmez. *(`§7.1`'in "kardeş yol
> etkilenmiyor iddiası ölçülmeden yazılamaz" kuralının, KAPILAR üzerindeki hâli.)*

### ⚠️ VE KAPIYI KURARKEN KAPININ GİRDİSİ DE ÖLÇÜLÜR

`G5c` ilk yazımında `EXPECT`'i evren sandı ve **23 hücreyi `BOS`** gösterdi — çünkü
`EXPECT` yalnız iki `Z35` hücresini taşıyor. Kapı **kırmızı verdi**, sebep okundu,
girdi canlı haritaya bağlandı.

> **Kapının kırmızısı bir sonuç değil, bir GİRDİDİR.** Rengi kabul etmeden **sebebini**
> oku — bu kez sebep, kapının kendi **kapsam maskelemesiydi**.

---

## RATCHET AİLESİNİN TAMAMLAYICI YASASI — gerileme ∧ donma (ZORUNLU)

`Z29` bu repoya **ratchet** ailesini kurdu: `money-float` · `lint-ratchet` ·
`scope-ratchet` · `route-scope`. Hepsi tek bir şeyi ölçer — **mevcudun
gerilememesi**.

`G5b`/`G5c` vakası (2026-08-26) ailenin **eksik yarısını** adlandırdı:

```
RATCHET          mevcut üyelerin GERİLEMESİNİ tutar
TAMLIK KAPISI    EVRENİN DONMASINI tutar
                 ⇒ ikisi birlikte TAM, tek başına hiçbiri değil
```

**Ürün sahibinin formülasyonu:**

> **"Çözüm bakım değil, listenin EKSİKLİĞİNİ ölçen ikinci kapıdır."**

### Neden tek başına ratchet yetmez — ölçülmüş

Bir ratchet **listesindekileri** korur. Listeye **girmeyen** bir üye için ratchet
**yeşildir ve doğru şeyi söylüyordur**: *"listemdekiler gerilemedi."* Yanlış olan
cevabı değil, **sorusudur**.

| kapı | listedeki üye bozulursa | listeye YENİ üye girmezse |
|---|---|---|
| ratchet | ⛔ kırmızı | ✅ **yeşil** — ve kör |
| tamlık kapısı | — | ⛔ kırmızı |

📌 Bu, `§2.7 #9`'un (*"kapının kapsamı kendini boşaltıyor"*) **kardeşidir** ama
zıt mekanizma: orada kapsam **boşaldı**, burada kapsam **büyümedi**. İkisi de
*"hep yeşil"* üretir — ve `§2.7`'nin kuralı geçerlidir: **sinyal sabitse, sinyal
değildir.**

### Pratik — bir ratchet ya da baseline yazarken İKİ soru

```
1  listemdeki bir üye bozulursa görür müyüm?          ← ratchet'in kendisi
2  listeme girmesi gereken bir üye girmezse görür müyüm?  ← TAMLIK KAPISI
```

İkincisinin cevabı *"elle bakarım"* ise, kapı **yoktur** — çünkü elle bakmanın
unutulduğu tur, tam da kapının gerektiği turdur. Bu repoda ölçülmüş oran:
elle yazılmış üye-sayısı **dokuzda dokuz** bayatladı.

---

## Bir HÜKÜM, dayandığı ÖLÇÜMÜN TAZE OLDUĞU EVRENDE yaşar (ZORUNLU)

Bu gövde uzun süre ölçümlerin bayatlamasını kaydetti. `Z43` (2026-08-27) bir üst
katmanı adlandırdı: **hükümler de bayatlar** — ve bayatlamalarının yolu, dayandıkları
ölçümün çürümesidir.

**Ürün sahibinin formülasyonu:**

> **Hükmün dayanağı bir ÖLÇÜMSE, hüküm o ölçümün TAZE OLDUĞU EVRENDE yaşar.**

### ⛔ VE ÇÜRÜTEN ŞEY BİR GENELLEMEYDİ

`Z42 §3` `−PLANNER` hükmünü iki dayanağa yasladı; biri şuydu: *"tek tüketici `/finance`
ekranı"*. Ölçüm (`Faz-A`) gösterdi ki o cümle **`plan-performance` için ölçülmüştü** ve
**`dashboard/summary`'ye GENELLENMİŞTİ** — ikincisinin tüketicisi `DashboardPage`.

> **Ürün sahibinin kaydı: *"GENELLEME, ÖLÇÜM DEĞİLDİR."***

```
ölçülen      plan-performance  →  tek tüketici /finance      ✅ doğru
genellenen   "bu ailenin tüketicisi /finance"                ⛔ ölçülmedi
hüküm        −PLANNER ×4                                     ⇒ ikisinde YANLIŞ
```

📌 `§7.1`'in *"kardeş yol etkilenmiyor iddiası ÖLÇÜLMEDEN yazılamaz"* kuralının
**hüküm katmanındaki** hâli: orada bir düzeltmenin kardeşleri, burada bir **hükmün
kapsamı** ölçülmeden genişletildi.

### Ölçülmüş hata sınıfları — üçü de aynı şekle sahip

| # | sınıf | ne oldu |
|---|---|---|
| 1 | **spesifikasyon-"zaten"** | bir muafiyet, ölçüm yerine geçti |
| 2 | **uydurulmuş-alıntı** | var olmayan bir kural metni bağlayıcı diye yazıldı |
| 3 | **ölçüm-genellemesi** | bir ölçüm, ölçülmediği vakalara taşındı |

> **Ortak şekil: BİR ÖLÇÜMÜN YERİNE BAŞKA BİR ŞEY KONDU** — bir muafiyet, bir alıntı,
> bir genelleme. Üçünde de sonuç *"dayanağı var görünen"* bir hükümdü.

### ⛔ VE GERİ ÇEKİLME BİR USÜLDÜR — hüküm SİLİNMEZ

`F12` deseni: eski kayıt **durur**, üstüne *"geri çekildi (tarih, gerekçe, çürüten
ölçüm)"* yazılır. `Z43 §0`'da uygulandı ve **kısmî**dir: hüküm beş ucun **üçünde
AYAKTA**, ikisinde geri çekildi.

> **Bir hükmün geri çekilmesi, onu üreten muhakemenin tamamını çürütmez.**
> **Geri çekilme, ölçümün çürüttüğü KADARDIR** — ve o sınır **yazılır**.

### ⚠️ Ve geri çekilme çoğu zaman *"hüküm yanlıştı"* DEĞİLDİR

`Z43 §1`'in ölçülmüş sonucu: *"hüküm yanlış değildi, **HÜCRE ÜYELİĞİ** yanlıştı."*
`dashboard/summary` `SUMMARY_READ`'de duruyordu, ama `SUMMARY`'nin tanımı
**nesne-bağsız ∧ çok-işlem-modüllü** idi ve **kapsamsızlık o tanımın ÖRTÜK PARÇASIYDI**
— bu uç ise **kapsam-çözümlü**.

> **Bir hüküm yanlış görünüyorsa, önce GİRDİSİNİN doğru dosyalandığını ölç.**
> Yanlış kutudaki bir üye, doğru kuralı **yanlış gösterir**.

📌 Ve bir tembellik kapısı: `Z43 §1`, *"birebir ev varken **tek-vaka etiketi
TEMBELLİKTİR**"* der. **Tek-vaka bir sınıf değil, bir ARTIKTIR** — ve artık listesi,
doğru evi aramamanın maliyetiyle şişer.

---

## BİR KAPININ EVREN-KAYNAĞI: **türetilmiş > taranmış > yazılmış** (ZORUNLU)

Bu repo üç kapıda, üç ayrı evren-kaynağı denedi ve **doğrusu üçüncüde bulundu**. Sıralama
bir tercih değil, **ölçülmüş bir hiyerarşidir**.

| # | evren-kaynağı | kapı | nasıl bozuldu |
|---|---|---|---|
| 3 | **YAZILMIŞ** — elle tutulan liste | `G5b` (ilk hâli) · `G2b` (ilk hâli) | **DONDU.** Yeni üye eklendi, listeye **girmedi** ⇒ kapı onu hiç görmedi |
| 2 | **TARANMIŞ** — bir desenle toplanan | `G2b` (ikinci hâli: `globals()` + `*_ROUTES` + `isinstance(set)`) | **KAÇTI.** Desenin **dışına** çıkan üye (farklı **tip**, farklı **ad**) sessizce düştü — ve **çalışmaya devam etti** |
| 1 | ⛔ **TÜRETİLMİŞ** — hüküm veren yerin **kaynağından** | `G2b` (bugünkü: `cell_for`'un kaynağı) · `G5c` (göçmüş rotalardan) | *(bugüne kadar bozulmadı — ve iki mutasyon ekseninde sınandı)* |

### ⛔ TEK YASA

> **HÜKÜM VEREN YER NERESİYSE, KAPININ EVRENİ ORASIDIR.**

Bu cümle iki dersin **birleşimidir**:
- `G5b`: *"referans **dondurulmuş kayıttan** gelir"* — kapının **BEKLENTİSİ** bağımsız olmalı
- `G5c`: *"evren **canlı haritadan** türer"* — kapının **KAPSAMI** kendiliğinden büyümeli

⇒ İkisi bir arada: **beklenti dondurulur, evren türetilir.** Biri elle tutulursa kapı
ya **yanlış şeyi** ölçer ya **hiç ölçmez**.

### Neden **taranmış** yetmez — ve neden bu en tehlikelisi

Yazılmış bir liste **görünür biçimde** eksiktir: kimse eklemediyse listede yoktur, ve
bir gün birisi bakıp fark eder. **Taranmış** bir evren ise *"otomatik"* görünür — ve
tam da bu yüzden kimse **kapsamını** sorgulamaz.

Ölçülmüş vaka (2026-08-27): `globals()` taraması iki eksende kaçtı (**tip**: `set`→`list`
· **ad**: `_ROUTES`→`_OVERRIDES`), ve her iki mutasyonda da tablo **hükmü vermeye devam
etti**. `if not G2B_TABLOLAR` boş-evren kapısı **ateşlemedi**, çünkü o ancak **hepsi**
yok olursa çalışır.

> **Bir taramanın en tehlikeli yanı, otomatik GÖRÜNMESİDİR.**

### Ve zincirin kendisi bir kayıt: **üç halka**

```
1  BEN buldum      Faz-B yeni tablo ekledi, elle yazılan listeye eklemedi
2  BEN düzelttim   globals() taraması — ve yorumuma "bir tur UNUTAMAZ" yazdım
3  REVIEW çürüttü  iki kaçış yolu, mutasyonla; ve düzeltmenin KENDİ yorumu
                   ihlal ettiği kuralı anıyordu
```

📌 Üç halkanın dersi: **bir düzeltmenin iddiası da bir iddiadır** ve aynı kapıdan
geçmelidir. *"Bir tur unutamaz"* cümlesi bir **ölçüm değil, bir umuttu** — ve o umut
`(2)`'de yazıldığı için `(3)`'e kadar kimse ölçmedi.

---

## Bir listeyi **SÖZLEŞME** biçiminde yazmak, listenin söylemediğini söyletir (ZORUNLU)

Bu gövde çoğu kuralı bir **ölçümden** çıkardı. Bu kural bir **yazım biçiminden** çıktı —
ve ortaya çıkardığı şey bir ölçümün bulamayacağı türdendi.

**Ölçülmüş vaka (2026-08-27, `Z44 §4`):** `B3b-1`'in kalan `15` `@Roles` rotası aylardır
bir **liste** olarak taşınıyordu, ve o listenin üstünde yazılı olmayan bir varsayım
duruyordu: *"bu sayı sıfıra iner, sonra `B4` gelir."*

Liste **düz** yazıldığı sürece varsayım **hiç sorgulanmadı**. Ürün sahibi kapanış
raporu için formatı değiştirdi:

```
DÜZ LİSTE       rota · hücre · @Roles kümesi
SÖZLEŞME        rota · ADRES · STATÜ · ⛔ AÇILMA KOŞULU
                            ↑ "KİM, NE ZAMAN, NEYLE AÇAR"
```

Format değişince **iki satırın açılma koşulu OLMADIĞI** görüldü:

```
15  =  13 KOŞULLU (Faz-2 · T-293 · T-304-D1)  +  2 KALICI (kayıtlı, gerekçeli, koşulsuz)
```

⇒ *"Sıfırlanınca `B4`"* demek, **hiçbir zaman** demekti. **Sıfır bir TARİH değil,
GELMEYECEK BİR OLAYDI** — ve bunu bir ölçüm değil, **bir sütun** ortaya çıkardı.

> **Ürün sahibinin kaydı: *"`kim-ne zaman-neyle açar` formatının İLK MAAŞI bu oldu."***

### Kuralın kendisi

> **Bir borç/kalan/istisna listesi yazarken her satıra bir AÇILMA KOŞULU sütunu koy.**
> **Koşulu YAZILAMAYAN satır, bir bekleme değil bir KALICILIKTIR — ve bunu ancak
> sütun görünür kılar.**

📌 Bu, `T-304`'ün *"borç listesi düz liste değil, **kilidi açtığı karar sayısına** göre
sıralı listedir"* kriteriyle **aynı ailedendir**: ikisi de bir listeye **ikinci bir
eksen** ekler, ve ikisinde de ikinci eksen **listenin kendisinin söylemediğini** söyler.

⚠️ Ve ailenin üçüncü üyesi `EK_E`'nin `🔒` ayrımıdır: *"yetenek yok"* (`❌`) ile
*"yetenek var, **yolu yok**"* (`🔒`) aynı listede **farklı sütun** ister — ve `🔒`
**bir kabul değil, bir alarmdır**.

> **Ortak şekil: BİR LİSTENİN BİLGİSİ, SATIRLARINDA DEĞİL SÜTUNLARINDADIR.**

---

## MUTASYON EŞDEĞERLİĞİ: **ÜRÜN için eşdeğer ≠ KAPI için eşdeğer** (ZORUNLU)

Bu gövde mutasyonun **mekanizmaya indiğini** doğrulamayı defalarca yazdı. `Z44 §7`
(2026-08-27) bir üst soruyu adlandırdı: **mutasyon, hakkında sonuç çıkardığın şey için
DOĞRU MUTASYON MU?**

**Ölçülmüş vaka.** Bir pin, *"`RolesGuard`'ı zincirden çıkar"* düğmesini uygulamak yerine
**gövdesini `return true` yaptı** ve eşdeğerliği **doğru gerekçelendirdi**:

```
ÜRÜN için    ✅ EŞDEĞER   her iki durumda da @Roles kontrolü UYGULANMAZ
KAPI için    ⛔ DEĞİL     route-scope @UseGuards LİSTESİNE bakar, GÖVDEYE değil
```

Sonra o mutasyondan **kapı hakkında** bir sonuç çıkardı: *"statik tespit `15/15` iddiası
yanlış."* Bağımsız ölçüm iddiayı **çürüttü**: gerçek düğme (zincirden çıkarma) uygulanınca
kapı **`exit 2`** verdi ve rotaları **adıyla** bastı.

> ⛔ **Bir mutasyonun eşdeğerliği, SORULAN SORUYA GÖRE ölçülür.**
> **Ürün davranışı için eşdeğer olan bir mutasyon, ÖLÇÜM ALTYAPISI için eşdeğer
> olmayabilir — ve o mutasyondan altyapı hakkında çıkarılan sonuç KAPSAM DIŞIDIR.**

### Pratik — mutasyon seçerken ikinci soru

```
1  mutasyon MEKANİZMAYA indi mi?        ← eski kural
2  mutasyon, HAKKINDA SONUÇ ÇIKARDIĞIM
   ŞEYİN gördüğü eksende mi?            ← BU
```

📌 Ve aynı pin ikinci bir aşırı-genelleme yaptı: *"ne guard ne e2e bunu yakalardı."*
Ölçüm: gövde boşaltılınca `role-journey`'in **iki testi düşüyor**. ⇒ *"Hiçbir şey
görmüyor"* iddiası, **bakılmayan yerin** iddiasıdır.

### ⛔ VE ORTAYA ÇIKAN GERÇEK: iki bozulma yolu, İKİ FARKLI dedektör

```
YAPISAL bozulma   guard zincirden çıkar   →  STATİK KAPI görür  (e2e görmez)
DAVRANIŞSAL       guard gövdesi bozulur   →  E2E görür          (statik kapı görmez)
```

**Bu bir açık değil, bir İŞ BÖLÜMÜDÜR** — ama **yazılı olmadığı için** pin onu bir açık
sandı. ⇒ Bir dedektör ağının **kim neyi görür** tablosu, ağın kendisi kadar önemlidir;
yazılmazsa her tur onu **yeniden keşfeder ve yanlış okur**.

> **Bir kapının kör noktası, KOMŞU kapının görev tanımıdır — ta ki yazılana kadar.**

---

## POZİTİF KONTROLÜN DÖRDÜNCÜ NESLİ: **müdahale DOĞRU EKSENDE mi?** (ZORUNLU)

Bu gövde pozitif kontrolü üç nesilde kaydetti. `Z44 §7` (2026-08-27) dördüncüyü ekledi
ve aile artık **tam**:

```
1  GİRDİ VAR MI            aradığım şeyin bulunabileceği veri/rota mevcut mu
2  ARAÇ ÇALIŞIYOR MU       aynı tarama BAŞKA bir şeyi buluyor mu
3  MÜDAHALE GERÇEKLEŞTİ Mİ mutasyon MEKANİZMAYA indi mi (satırı BAS)
4  MÜDAHALE DOĞRU EKSENDE Mİ  ⛔ mutasyon, HAKKINDA SONUÇ ÇIKARDIĞIM ŞEYİN
                              GÖRDÜĞÜ eksende mi
```

`4`'ün doğuş vakası: bir pin, `RolesGuard`'ı *"zincirden çıkar"* yerine *"gövdesini
`return true` yap"* diye mutasyona uğrattı. `1`, `2`, `3` **sağlanmıştı**. Ama sonuç
**statik kapı hakkında** çıkarıldı ve statik kapı **gövdeye bakmıyor** — `@UseGuards`
**listesine** bakıyor. ⇒ `1-3` yeşil, **hüküm yanlış**.

### ⛔ VE BU TURUN ASIL SAĞLIK GÖSTERGESİ

Pin **çerçeveyi doğrularken kendi iki iddiası çürüdü.**

> **Doğrulayan şeyin kendisi de doğrulanıyor.**

📌 Bir doğrulama turunun *"her şey tuttu"* ile bitmesi, turun **iyi** gittiği anlamına
gelmez — turun **kendi iddialarının ölçülmediği** anlamına da gelebilir. Bu turda
üç pinin üçü de beklentiyi tutturdu **ve** pinin iki yan-iddiası çürüdü; ikisi birden
doğru olabilir, çünkü **farklı şeylerin iddialarıdır**.

---

## Her YETKİ-GENİŞLEMESİ, arkasındaki yüzeyin İLK GERÇEK TRAFİĞİDİR (ZORUNLU)

**Ölçülmüş vaka (2026-08-27, `T-306`):** `finance-reporting/budget-variance`,
`PLANNER` guard'dan geçirildiği anda **`500`** verdi —
`column envelope.cplid does not exist`. Kusur **önceden vardı**, RBAC'la **ilgisizdi**,
ve bugüne kadar **hiç görünmemişti**.

```
örten şey     BİR KUSUR DEĞİL — ÇALIŞAN BİR YETKİ KONTROLÜ
PLANNER       403 alıyordu ⇒ iş katmanına HİÇ ULAŞMIYORDU
```

> **Bir role bir uç açmak, o ucun O ROL İÇİN İLK KEZ KOŞMASI demektir.**

### ⇒ Genişleme pinleri `403 → 200`'ü ölçmekle BİTMEZ

> ⛔ **`200`'ün İÇERİĞİ de ölçülür.**

Bu, `T-296`/`B2` dersinin (*"bir uç `200` dönüyor diye çalışıyor değildir"*) **yetki**
hâlidir. Bir genişleme pini yalnız statü kodunu okuyorsa, **açtığı yolun ilk adımında
patlayan** bir kusuru **yeşil** raporlar.

📌 Ve sıra kuralı: ***"ÖRTÜ KALDIRILIRKEN ALTINDAKİ AYNI COMMIT'TE."*** Bir genişleme,
arkasındaki yüzeyin bilinen kusurlarıyla **aynı pakette** iner — yoksa yeni rolün
göreceği **ilk şey** bir `500` olur.

---

## SINIF-SEVİYESİ dekoratör, dosyadaki HER rotanın sözleşmesini değiştirir (ZORUNLU)

**Ölçülmüş vaka (2026-08-27, `B4 A′` dalgası):** `settlements/close/:agreementId`
erişimi **yalnız** `SettlementGuard` ile denetleniyordu ve hiçbir yetki dekoratörü
taşımıyordu. `default-deny`'a geçişte **kırıldı** — sebebi kendi satırında değil, **iki
dosya-seviyesi adımda**:

```
1  summary rotası SUMMARY_READ'e göçtü        (Z43 §4 — meşru, ölçülmüş)
2  ⇒ SINIF seviyesine CapabilityGuard eklendi (şart, o göç için)
3  close ⟶ İSTEMEDEN kapsama girdi           (kendi satırı hiç değişmeden)
```

⇒ **Bir rotanın sözleşmesi, o rotaya hiç dokunulmadan değişebilir.**

### ⛔ VE BU, `BİLEŞİMSEL FAIL-OPEN`'IN AYNA VAKASIDIR

| | mekanizma | sonuç |
|---|---|---|
| `S2` (bileşimsel fail-open) | **üç masum adım** | rota **AÇILIYOR** |
| `A′` `DUR`'u | **iki masum adım** | rota **KAPANIYOR** |

Her iki vakada da **hiçbir adım tek başına hatalı değil**, ve **hiçbiri o rotayı
hedeflemiyor**. İkisinin ortak yasası:

> **ROTA-SEVİYESİ NİYET, SINIF-SEVİYESİ ARAÇLA TAŞINAMAZ.**

📌 Pratik: sınıf seviyesine bir guard/dekoratör eklerken **o dosyadaki TÜM rotaları
say** — özellikle **hiçbir yetki metadata'sı taşımayanları**, çünkü onlar yeni aracın
**varsayılan dalına** düşerler. Ve varsayılan dal, aracın **fail-open mu fail-closed mu**
olduğuna göre **zıt** sonuç verir.

---

## KAPSAM-BEYANI ≠ KAPSAM-KANITI (ZORUNLU)

`ADIM3_KAPANIS_RAPORU §3.1` şunu **doğru** ölçüp **doğru** yazmıştı:
*"düğme `A`'nın gerçek kapsamı `15` değil, **`22`**"* — `15` `ROLES` + `6` `SELF` +
**`1` `settlement/close`**.

Sonra `Z44 §7`'nin pin `2`'si `A′`'yi doğruladı — ama **yalnız `15`'i ve `SELF`'i**
pinledi. **22.'nci hiç çağrılmadı.** İnşa turunda **15 e2e testi** düştü.

> **Ürün sahibinin cümlesi: *"SAYI DOĞRUYDU, PİN DARDI."***
>
> ⛔ **`22` YAZMAK, `22`'yi PİNLEMEK DEĞİLDİR.**

📌 Bu, `§2.7 #6`'nın (*"kapsam var, ayırt etme gücü yok"*) **bir üst katmanı**: orada
**test** dardı, burada **pin listesinin kendisi** dardı — ve dar olduğu, **kapsamı
doğru sayan bir belgenin yanında** duruyordu.

### Pratik

Bir kapsam sayısı yazdığın anda, o sayının **her sınıfından en az bir örnek** pin
listesine girer. *(`22` = üç sınıf ⇒ **üç** pin; `15`+`SELF` iki sınıftır, üçüncüsü
**yazılıydı ve atlandı**.)*

⚠️ Ve kendini kandırma biçimi ince: pin listesi *"kalan-15 birebir"* diyordu ve **`15`'i
gerçekten** ölçüyordu. **Eksik olan sayı değil, SINIFTI.**

---

## BİR KAPININ ÜÇ MEŞRU ÇIKTISI VARDIR (ZORUNLU — kapı disiplininin kapanış taşı)

```
yeşil  ·  kırmızı  ·  "ÖLÇEMEDİM"
```

> ⛔ **SESSİZ-YEŞİL BUNLARIN HİÇBİRİ DEĞİLDİR.**
> **BİR KAPI, ÖLÇEMEYECEĞİ DURUMDA YEŞİL DEĞİL, *SETUP HATASI* RAPORLAR.**

Bu kural bu gövdedeki **dört ayrı vakayı** tek yasada toplar — hepsi `ADIM 3` boyunca,
**aynı kapı ailesinde**, ve her biri bir öncekinin **düzeltmesinden** doğdu:

| # | bozulma | kapı | ne oldu |
|---|---|---|---|
| 1 | **BOŞALAN** evren | `G5` | `@Roles` rotaları tükendi ⇒ kapı **hiçbir girdide** kırmızı veremez |
| 2 | **DONAN** evren | `G5b` | iki hücrede dondu ⇒ yeni hücreler **görünmez** |
| 3 | **KAÇIŞ-YOLLU** evren | `G2b` | tip/ad ekseninden düşen tablo — *"otomatik"* görünür, **değil** |
| 4 | **ÖLÇEMEYEN** kapı | `domain-guard-parity` | env set edilince KAYNAK A'nın **etkin** değeri literalden farklı ⇒ çakıştırma **anlamsız** |

`1–3`'ün her biri **yeşil** veriyordu ve **hiçbir şey ölçmüyordu**. `4` bunun **bilinçli
çözümüdür**: kapı, ölçemeyeceğini **anladığı** yerde **`exit 2`** verir.

### Neden `"ölçemedim"` ayrı bir çıktı olmak zorunda

`yeşil` = *"ölçtüm, temiz"*. `"ölçemedim"` = *"ölçmedim"*. **İkisini aynı çıktıya
sıkıştırmak, kapının tüm değerini yok eder** — çünkü okuyucu farkı **göremez**, ve
`§2.7`'nin kuralı devreye girer: **sinyal sabitse, sinyal değildir.**

📌 Ve pratik testi: bir kapı yazarken sor — ***"bu kapı hangi durumda ölçemez, ve o
durumda NE basar?"*** Cevap *"yine yeşil"* ise kapı **henüz bitmemiştir**.

⇒ **`ADIM 3`'ün denetim-altyapısı mirası bu yasayla devredilir.** `RLS` ve denetim
adımlarının kapıları **bu standarda** yazılır.

---

## BİR UYARI HATIRLANMAK ZORUNDADIR; BİR LİSTE MADDESİ DEĞİLDİR (ZORUNLU)

**Ölçülmüş vaka (2026-08-27, `Z47 §4`):** `docker ps`'te yabancı bir `collmind-tpm-backend`
container'ı (imaj `tpm-backend`, port `5433`, `TTM` donduruluşundan kalma) doğrulama
turunun **tam başında** çıktı. Yakalandı — çünkü `CLAUDE.md`'deki **uyarı okundu**.

Ama uyarı **2026-08-21'de yazılmıştı** ve o gün *"davranışsal ölçümleri bozdu"* diye
kaydedilmişti. Yani **aynı tuzak, aynı repoda, ikinci kez** — ve ikisinde de yakalanma
sebebi **bir kapı değil, bir hatırlama** oldu.

> **Ürün sahibinin hükmü:** *"`docker ps` kontrolü **doğrulama-listesinin KALICI İLK
> MADDESİ** olsun. Şu an bir uyarı — **liste maddesi değil**."*

### Kuralın kendisi

> **Bir uyarı, okuyucunun onu HATIRLAMASINA bağlıdır. Bir liste maddesi değildir.**
> **Aynı tuzağa İKİNCİ kez düşüldüğünde, uyarı bir MADDEYE terfi eder.**

📌 Bu, `DISIPLIN`'in *"kuralı hatırlamak yerine **ARACI ÇAĞIR**"* ilkesinin **belge
tarafıdır** — ve `T-128`'in (*"mutasyon geri almayı bir script'e indir"*) kardeşidir:
orada bir **refleks** bir **araca**, burada bir **uyarı** bir **maddeye** çevrildi.

### ⚠️ Ve terfinin ölçütü **sıklık değil, TEKRAR**

Bir uyarı ne kadar iyi yazılmış olursa olsun, **ikinci kez ihlal edildiğinde** artık
metnin kalitesi tartışılmaz — **yerleşimi** tartışılır. *(Bu repoda ölçülmüş kardeş
vakalar: `push-order` elle iki kez ters yapıldı ⇒ **script** oldu; mutasyon geri alma üç
kez yanlış gitti ⇒ **araç** oldu.)*

> **Bir kuralın üçüncü ihlali, kuralın değil YERLEŞİMİNİN kusurudur.**

---

## `VERİNİN YOKLUĞU ÖRTER`in ALT-TÜRÜ: **KULLANIMIN yokluğu, SÖZLEŞME KIRIĞINI örter** (ZORUNLU)

Bu gövde *"verinin yokluğu örter"*i uzun uzun kaydetti: bir yol **koşmuyorsa** kusuru
görünmez. `Z47` review 🟡-2 **bir alt-türünü** ölçtü — ve mekanizması farklı.

**Ölçülmüş vaka (2026-08-27):** `Z47` `available_amount` kolonunu düşürdü;
`POST /budget/envelopes` **ham entity** döndürüyordu ⇒ alan JSON'dan **sessizce
kayboldu**. Frontend tipi (`budget.types.ts`) onu `availableAmount: number` diye
**VAAT EDİYOR**.

```
KIRIK CANLI   sunucu sözleşmeyi bozdu, istemci tipi hâlâ vaat ediyor
ÇÖKMÜYOR      çünkü useCreateBudgetEnvelope YALNIZ invalidateQueries yapıyor
              — dönen GÖVDEYİ RENDER ETMİYOR
⇒ örten şey VERİNİN yokluğu değil, KULLANIMIN yokluğu
```

> **Bir sözleşme kırığı, kırılan alanın O YOLDA KULLANILMAMASIYLA örtülebilir.**
> **Ve kullanım bir gün eklenir — kırık o gün, ilgisiz bir commit'te ortaya çıkar.**

### ⇒ Bunun kanıtı: **TEL-PROTOKOL pinleri RENDER'DAN BAĞIMSIZ olmalı**

Bir uç sözleşmesini *"ekran çalışıyor mu"* diye ölçmek, tam da bu vakada **yeşil** verir.
Ölçüm **yanıtın kendisine** bakmalı: alanlar **var mı**, tipleri **doğru mu** — bileşenin
onları **kullanıp kullanmadığından bağımsız**.

📌 Bu, `§2.7 #4`'ün (*"kanıt kurulumu ölçtüğü durumu değiştirmesin"*) kardeşi ama zıt
yönlü: orada **kurulum** ölçülecek durumu **yok ediyordu**; burada **kullanımın
yokluğu** bozukluğu **görünmez** kılıyor.

⚠️ Ve pratik tarama sorusu: bir sunucu sözleşmesini değiştirirken *"kim render ediyor"*
değil, ***"kim TİPLİYOR"*** diye sor — çünkü tip **vaat**, render yalnızca **bugünkü
kullanım**.

---

## `ÖLÇÜLMEDİ` BİR DURAK DEĞİL, **GEREKÇELİ BİR DURAKTIR** (ZORUNLU)

Bir statünün değeri aynı kalırken **gerekçesi** değişebilir — ve o an, kaydın
**yenilenmesi gereken** andır.

**Ölçülmüş vaka (2026-08-27, `Z47` review 🟡-4):** `INV-B-008` (*"hiçbir zarf negatif
kullanılabilirliğe düşemez"*) **`ÖLÇÜLMEDİ`** idi ve öyle **kaldı**. Ama **sebebi
tamamen değişti**:

```
ESKİDEN   "kullanılabilir HANGİ KOLON?" bilinmiyordu        →  D-18'e bağlıydı
BUGÜN     D-18 çözüldü (kolon öldü, taşıyıcı TEKLENDİ)
          ama CHECK bir VIEW'a YAZILAMAZ                     →  YENİ bir soru
```

> **Ürün sahibinin formülasyonu:**
> ***"Blokaj kalkınca statü *'çözüldü'* OLMAZ — GEREKÇESİ DEĞİŞİR, ve onu yazmak
> türev-belge kuralının ASIL İŞİDİR."***

### Kural

> **`ÖLÇÜLMEDİ` bir DURAK değil, GEREKÇELİ bir duraktır.**
> **Gerekçe değiştiğinde, durağın ADI aynı kalsa bile KAYDI YENİLENİR.**

⛔ Aksi hâlde bir okuyucu **eski gerekçeyi** okur ve **çözülmüş bir blokajı** arar —
`§2.7`'nin *"bayat cümle bir sonraki kararın GİRDİ yüzeyinde"* sınıfının **en sinsi
biçimi**, çünkü **statü doğru** görünür.

### ⇒ Ve doğru dosyalama da kuralın parçası

Yeni soru (*"uygulama-katmanı mı, trigger mı"*) `D-18`'in **DEVAMI değil, KARDEŞİdir** —
ayrı bir teknik soru, ayrı bir sahiple. **Bir kararın çözülmesi, ondan doğan yeni soruyu
o kararın altına gömmez.**

📌 Bu, uzlaşı turunun **kalıcı mekanizmasının** (*"bir `Z`-kaydını kapatan tur, türev
belgeleri de yazar"*) **ilk rutin sınavıydı** — ve sınavın öğrettiği: türev belgeyi
güncellemek *"statüyü değiştirmek"* değil, **gerekçeyi tazelemek** olabilir.

---

## KAPSAM GENİŞLETME **YETKİSİ YOKTUR** — TEKLİF + ÖLÇÜM + `DUR` VARDIR (ZORUNLU)

**Ölçülmüş vaka (2026-08-27, `T-307-m2`):** brief **iki** dosya adlandırdı; ajan **on
dört** sildi. Ve **doğru davrandı** — ama *"doğru"*nun tanımı **mekanizma değil, ölçüm**:

```
✅ genişletti  ∧  DUR'a düşürdü  ∧  ONAY istedi
⇒ ve onayı MEŞRU kılan şey ajanın TAKDİRİ değil, İKİ ÖLÇÜM:
     '/tenants' string'i  src genelinde  →  SIFIR
     silinen 14 dosyanın hayatta kalan referansı  →  SIFIR (poz. kontrollü)
```

> **KAPSAM GENİŞLETME YETKİSİ YOKTUR.**
> **KAPSAM-GENİŞLEME TEKLİFİ + ÖLÇÜM + `DUR` VARDIR.**

⚠️ Ve ölçümün **şekli** şarttır: *"bence gerekliydi"* bir teklif değildir; *"şu tarama şu
sonucu verdi, poz. kontrolü şudur"* bir tekliftir. **Brief'in dışına çıkmanın bedeli bir
ÖLÇÜMDÜR** — ve o ölçüm olmadan genişleme, kapsamın **sessizce** büyümesidir.

📌 Karşı-örnek aynı turda: brief'in adlandırdığı ikisini silip on ikisini bırakmak
**erişilemez orphan** bırakırdı ⇒ **daraltmak da bir kusurdur.** Doğru cevap ne *"brief'e
harfiyen uy"* ne *"gerekeni yap"* — **ölç, teklif et, DUR.**

---

## KAPANMIŞ BİR TASK'IN ANLATI PARANTEZİ, BİR TASK DEĞİLDİR (ZORUNLU)

`DISIPLIN` zaten der: *"bilinen eksiklik TODO ile değil, **TASK** ile kaydedilir."*
`Z48 §2` bunun **daha sinsi** bir ihlalini ölçtü.

**Vaka:** `T-307-m2` beş canlı ucu **tüketicisiz** bıraktı (`EK_E` `🔒`). Bu, `T-307.md`'de
**kayıtlıydı** — ama:

```
konum   "✅ TAMAMLANDI" bloğunun İÇİNDE
biçim   bir PARANTEZ:  "(🔒 — ileride bir ayarlar ekranı için altyapı)"
statü   task: done
```

⇒ **Kayıt VARDI ve ALARM ÖTMÜYORDU.** Kapanmış bir task'a kimse geri dönmez; içindeki
açık kalem, **kapanışın rengini alır**.

> **Bir eksiklik, KENDİ statüsünü taşıyan bir kayıtta yaşamalıdır.**
> **`done` bir belgenin içindeki `todo`, `done`dur.**

📌 Ve `🔒`'nin kendisi bunu zaten söylüyordu: **`🔒` bir kabul değil, bir ALARMDIR** —
ama bir alarm **kapalı bir odada** çalıyorsa, çalmıyordur.

---

## KUSURU **ÖLDÜREN** TURDA REPRO ARTEFAKTI **DAHA** GEREKLİDİR (ZORUNLU)

**Ölçülmüş vaka (2026-08-27, `Z48 §3a`):** `T-307-m2` sessiz-kaybolmayı **gördü**
(`POST → 201` · `GET → 200` · id **listede yok, hata da yok**) — sonra `create`'i
**öldürdü**. Pin geçiciydi, dosyası silindi, **ham çıktı saklanmadı**.

```
kusur ÖLDÜ  ⇒  davranış ARTIK ÜRETİLEMEZ  ⇒  iddia bir daha HİÇ doğrulanamaz
```

> **Kalıcı pin yazılamaması MEŞRUDUR; ARTEFAKTIN saklanmaması bir EKSİKLİKTİR.**
> **Ve tam da bu yüzden: bir kusuru ÖLDÜREN turda repro artefaktı, ÖLDÜRMEYEN
> turdakinden DAHA gereklidir — İKİNCİ BİR ŞANS YOKTUR.**

### ⇒ Ve iki iddia AYNI TURDA farklı statü taşıyabilir

Aynı task'ta:
```
altı-uçlu kırmızı (assertSelfTenant devre dışı)  →  ÖLÇÜLDÜ, artefaktı kayıtlı
create-repro'su                                  →  BEYAN, artefaktı yok
```
İkisi **ayrı statü** taşır ve `T-307.md`'de **öyle yazılıdır** — *"kanıtlanmış gibi
okunmasın"* şerhiyle. **Dürüstlüğün doğru biçimi, iddiaları TEK BİR RENGE boyamamaktır.**

---

## DEVİR-TESLİM YASASI ÜÇ ÖLÇEKTE ÇALIŞIR: **oturum · thread · AJAN** (ZORUNLU)

Bu gövde devir-teslimi iki ölçekte kaydetti: **oturum** (bayat süreç birikir) ve
**thread** (bağlam sıkıştırması). `Z49 §3` üçüncüyü ekledi: **AJAN ÖLÜMÜ**.

**Vaka (2026-08-28):** bir spike ajanı `API` oturum limitine takıldı ve **son satırda**
kesildi. Bıraktığı iş **tamdı** — ama bunu bilmenin **tek yolu ölçmekti**.

> ⛔ **Yarım kalmış bir turun İLK SORUSU *"nereye kadar geldi"* DEĞİL:**
> ### ***"BIRAKTIĞI ŞEY DERLENİYOR VE ÖLÇÜLEBİLİYOR MU?"***

📌 Çünkü **ikincisi ölçülebilir, birincisi bir ANLATIDIR** — ve yarım kalmış bir turun
kendi anlatısı **en güvenilmez** kaynaktır (son mesajı çoğu zaman *"şimdi şunu
yapacağım"*dır, yapılmış olanı değil).

**Uygulanan sıra:**
```
1  git status        →  neye dokunulmuş
2  tsc / derleme     →  BIRAKTIĞI ŞEY GEÇERLİ Mİ
3  ilgili testi KOŞ  →  ve İDDİASINI bağımsız doğrula
4  ancak sonra       →  "tamamlandı mı" sorusu
```

⇒ **Aynı yasa üç ölçekte:** bir oturum, bir thread, bir ajan — **hangisi ölürse ölsün,
devralan taraf ANLATIYA değil ÖLÇÜME bakar.**

---

## BİR SAĞLAYICI İDDİASI, **ALAN ALAN** ÖLÇÜLÜR (ZORUNLU)

**Ölçülmüş vaka (2026-08-28, `Z51`):** bir hüküm *"sağlayıcı sanıldığından **UCUZ** —
`ALTER ROLE ... SET log_statement='all'` **rol seviyesinde BEDAVA** denetim-izi verir"*
dedi. Ölçüm: **üç alandan BİRİ**.

```
ne (statement)   ✅ rol seviyesinde bedava      ← iddia BURADA doğru
kim (aktör)      ❌ KÜME seviyesi (log_line_prefix'te %u yok)
kalıcılık        ❌ POSTMASTER seviyesi (docker rm ⇒ iz YOK)
```

> **Bir sağlayıcı *"var"* ya da *"yok"* değildir — bir ALAN KÜMESİ sağlar.**
> **İddia, GEREKEN her alan için AYRI ölçülür.**

⛔ Ve tehlikenin biçimi: `1/3` doğru bir iddia, **tamamen yanlış** bir iddiadan
**DAHA TEHLİKELİDİR** — çünkü ölçülebilir bir doğruluk payı taşır ve karar defterine
*"çözüldü"* diye geçer. Rol bugün kurulsaydı, *"denetim-olaylı"* şartı **ilk günden**
ihlal edilirdi ve ihlal **görünmez** olurdu.

📌 Pratik: bir sağlayıcı iddiasını yazarken **gereken alanları önce say** — burada
`DENETIM_SOZLUGU`'nun *"ortak alanlar"*ı bunu zaten söylüyordu ve **ilk zorunlu alanı
`kim`**'di. **İddia, kendi sözlüğüne bakmadan yazılmıştı.**

---

## CANLI ORTAM, KURULUM BETİĞİNDEN **ÜRETİLEBİLMELİDİR** (ZORUNLU)

**Ölçülmüş vaka (2026-08-28, `Z51 §2`):**
```
pg_roles.rolconfig    app_runtime → {log_statement=all}
repo genelinde grep   log_statement → KOD/SCRIPT'te SIFIR
```
⇒ Biri canlıda **elle** `ALTER ROLE` çalıştırmış. Ayar **hiçbir dosyadan türemiyor**.

> **Canlı ortamın, kurulum betiğinin ÜRETEMEYECEĞİ bir durumu varsa, o ortam bir
> ÖLÇÜM TABANI DEĞİLDİR.**

İki ayrı zarar, ve ikincisi daha sinsi:
1. Betik taze bir ortamda koşarsa **bu ayar gelmez** ⇒ *"aynı kurulum"* sanılan iki
   ortam **farklı** davranır
2. ⛔ **Ayar YANLIŞ ROLDEYDİ** — operatörü ayırt etmek için istenen bir ayar,
   **uygulama** rolünde duruyordu; yani sapma yalnız *"kayıtsız"* değil, **ters
   yönde işliyor**du

📌 `§2.7 #10`'un (*"kanıt kurulumunun kendisi güvenilmez"*) **ortam** tarafı: burada
güvenilmez olan bir komut değil, **ölçümün üstünde durduğu zemin**.

**Pratik:** bir rol/şema kararı ölçerken **`rolconfig`/`reloptions`/`pg_settings`'i
repoyla ÇAKIŞTIR** — canlıda olup dosyada olmayan her satır **bir sapmadır**, ve
sapmanın **yönü** ayrıca ölçülür.

---

## DIŞ GİRDİ BİR **GİRDİDİR**, TESCİL BİR **KANIT DEĞİLDİR** (ZORUNLU)

`CLAUDE.md §2.1.2` şunu der: *"bağlayıcı kaynak bir **GİRDİ**dir, kanıt değil"* — ve o
kural `BRD` için yazılmıştı. `Z53` (2026-08-28) onu **dış kaynağa** taşıdı.

**Vaka:** bir araştırma raporu (kaynak-izsiz derleme), yerel olarak **ölçtüğümüz** üç
davranışı **bağımsız doğruladı**. Karar (`Z50`) **zaten verilmişti**.

```
✅ TEYİT     rapor, YEREL ÖLÇÜMÜN sonucunu doğruluyor
⛔ KANIT     rapor, kararı ÜRETMİYOR — ve üretseydi, karar ÖLÇÜLMEMİŞ olurdu
```

> **Bir dış kaynağın SAYISAL ya da DAVRANIŞSAL iddiası, YEREL PROBE olmadan KARAR
> TAŞIMAZ.** **Atıf biçimi: `[dış-girdi, doğrulanmadı]`.**

### ⛔ VE SIRA, İDDİANIN KENDİSİNDEN ÖNEMLİDİR

Aynı cümle iki farklı yerde durabilir ve **iki farklı şey** olur:
```
ÖNCE ölçtük, SONRA rapor doğruladı   →  TEYİT   (kararın değeri ölçümde)
ÖNCE rapor dedi, SONRA uyduk         →  KANIT SANILAN BİR ALINTI
```
📌 İkincisi bu repoda **adı konmuş** bir hata sınıfıdır: **uydurulmuş-alıntı** vakası,
bir **kural metnine** yaslanmıştı; bu, aynı şeyin **dış kaynak** hâli olurdu.

### Pratik — dış girdi bir brief'e nasıl girer

Bir dış uyarı, **bizim ölçtüğümüz bir vakaya bağlanmadan** brief'e girmez.
*(Örnek: raporun *"dual-write problemi"* uyarısı, ancak bizim **sessiz-düşen-audit-INSERT**
dersimizle **birleşik** okunduğunda bir girdi olur — tek başına bir **başlık**tır.)*

⇒ **Dış girdi SORU üretir, CEVAP üretmez.**

---

## BİR `should-fix`'i ERTELEMEK, ONU BİR SONRAKİ DALGANIN **KÖR NOKTASI** YAPABİLİR (ZORUNLU)

**Ölçülmüş vaka (2026-08-28, `K1a`):** `Z47` review'u `view-security-invoker.sh`'ta bir
**ölü dal** buldu — `$DB_QUERY` **hesaplanıyor, kontrol ediliyor, HİÇ ÇAĞRILMIYOR**;
her iki dal da `docker exec ... -U postgres` koşuyordu. **`S4` / `should-fix`** diye
kaydedildi ve **bırakıldı**.

Bir dalga sonra `K1a` **tam o yolu taşımaya** kalktı:
```
plan     "db-query.sh sarmalayıcısını app_operator'e taşı"
gerçek   guard sarmalayıcıyı HİÇ ÇAĞIRMIYORDU
⇒ TAŞINACAK SANILAN YOL, TAŞINMIYORDU
```

> ⛔ **Bir *"ölü dal"* etiketi, o dalı TAŞIMAYA KALKAN ilk turda *"TAŞINMAYAN YOL"*a
> dönüşür.**

### ⇒ `should-fix` TRİYAJINA TEK SORU

```
"Bu kalem, PLANLANAN BİR SONRAKİ DALGANIN DOKUNACAĞI YÜZEYDE Mİ?"
   evet  →  should-fix DEĞİL — O DALGANIN ÖN-ŞARTI
   hayır →  should-fix
```

📌 Ve ayrım **kalemin ağırlığında değil, KONUMUNDA**: aynı ölü dal, dokunulmayacak bir
dosyada gerçekten bir `should-fix`'tir. **Erteleme bir öncelik kararıdır; ama önceliği
belirleyen şey KALEM değil, SONRAKİ DALGANIN YÜZEYİDİR.**

⚠️ **Özellikle ertelenen şey BİR YOLUN CANLILIĞI hakkındaysa** — *"bu dal ölü"*,
*"bu değişken kullanılmıyor"*, *"bu fallback'e hiç düşülmüyor"* — çünkü bir sonraki tur
o yolu **canlı sanarak** planlar.

---

## CANLILIK PROBU, **ASIL KONTROLÜN YÜZEYİNDE** KOŞMALIDIR (ZORUNLU)

**Ölçülmüş vaka (2026-08-28, `K1a` review `B3`):** `dropped-column-absence.sh`'ın
canlılık probu `information_schema.schemata`, asıl kontrolü
`information_schema.columns` kullanıyordu.

```
schemata  YETKİ FİLTRELEMEZ  →  USAGE'ı olan HER role 1 satır
columns   YETKİ FİLTRELER    →  GRANT'i olmayan role 0 satır

ÖLÇÜLDÜ   app_runtime → schemata 1 · main.claims columns 0
          POZ.KONTROL postgres → aynı sorgu 18
GUARD     sıfır-GRANT rolüyle → EXIT=0 "✅ hepsi düşük"   ⛔ FAIL-OPEN
```

⇒ Kapı ***"ölçemedim"* ile *"temiz"*i AYNI ÇIKTIYA** sıkıştırıyordu — `§2.7`: **sinyal
sabitse, sinyal değildir**.

> **Prob, asıl kontrolün ÖLÇTÜĞÜ ŞEYİ ölçmelidir — *"bağlantı var mı"*yı değil.**
> **Farklı yüzeydeki bir prob, kapının ÜÇ MEŞRU ÇIKTISINI İKİYE İNDİRİR.**

📌 Bu, **kaynak-yanlış pin** türünün **kapı-içi** hâlidir: pin ailesinde *"mutasyon
yanlış yere düştü"* neyse, burada *"prob yanlış yüzeyde koştu"* odur.

**Pratik:** bir kapı yazarken sor — ***"probun başarısı, asıl kontrolün koşabileceğini
GERÇEKTEN kanıtlıyor mu?"*** İkisi farklı bir yetki/kapsam yüzeyindeyse, cevap **hayır**.

---

## BİR HÜKMÜN *"GERİ-ALMA CAZİBESİ"* ÖNCEDEN ADLANDIRILIR (ZORUNLU)

**Ölçülmüş vaka (2026-08-28, `Z52 §1` → `T-314 C`):** `admin_audit_logs.tenant_id`
`CASCADE`→`RESTRICT` oldu; hüküm *"önce arşiv, sonra silme"* sırasını **yapısal** kılmak
istedi. Ama **arşiv adımı hiç yazılmadı** (tarama: sıfır).

Bugün etkisi **yok** — silme yolu da yok. Ama borç **adresli** yazıldı, ve gerekçesiyle:

> ⛔ **Yolu açan tur `RESTRICT` DUVARINA ÇARPAR — ve EN KOLAY ÇIKIŞ `RESTRICT`'i GERİ
> ALMAKTIR.** Yani hükmü **sessizce çürütmek**.

### Kural

> **Bir hüküm bir ENGEL kuruyorsa, o engelin GERİ-ALMA CAZİBESİ hükümle AYNI YERDE
> adlandırılır.**

📌 Çünkü engele çarpan tur, **hükmün gerekçesini okumaz — engeli okur**. Ve bir engel,
**niçin var olduğu yanında yazmıyorsa**, bir **kusur gibi** görünür.

⚠️ Ve bu, `DISIPLIN`'in *"`ÖLÇÜLMEDİ` bir GEREKÇELİ duraktır"* kuralının **kısıt**
tarafıdır: bir statü gerekçesiz kalırsa **yanlış okunur**; bir **kısıt** gerekçesiz
kalırsa **kaldırılır**.
