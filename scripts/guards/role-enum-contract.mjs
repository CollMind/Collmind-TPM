#!/usr/bin/env node
// T-356 — çapraz-repo ROL ENUM sözleşmesi, META-REPO'ya taşındı.
//
// Neden burada (ürün sahibi hükmü, 2026-09-02, T-356 yön notu):
// "Sözleşme testinin evi, sözleşmenin İKİ TARAFINI GÖREN yerdir." Bu kontrol
// `collmind.backend` ve `collmind.frontend`'i BİRLİKTE okur — o iki
// submodule'ün ortak atası olan bu meta-repo, "iki submodule'ü birlikte
// okumak"ın bir kaza değil GÖREV TANIMI olduğu tek yerdir.
//
// Önceki ev: `collmind.frontend/tests/contracts/roleEnumContract.test.ts`
// (T-211). Orada `collmind.backend`'in KARDEŞ DİZİN olmasını şart koşuyordu
// — frontend checkout'u tek başına (örn. izole bir git worktree'de, T-269 ∥
// T-270'ten doğan "doğrulamanı izole worktree'de yap" kuralı gereği)
// bulunduğunda bu test gürültülü patlıyordu, ve DISIPLIN'in izolasyon
// kuralını FİİLEN kullanılamaz kılıyordu (T-356). Bu dosya o testin AYNI
// mantığını taşır — kopyalamaz, TAŞIR: frontend süitinde artık bu kontrol
// YOK (kaybolmadı, buraya geldi).
//
// Kanonik kayıt: docs/brd-v2/EK_C_VERI_SOZLUGU.md
//   § "📌 Rol değer kümesi — KANONİK KAYIT"
//
// Üç bağımsız kaynak, DOSYADAN okunur (hiçbiri elle kopyalanmış statik bir
// dizi değil — böyle bir dizi bayatlar ve bayatladığında yeşil kalır,
// bkz. EK_C'nin "F1'in altıncı yüzü" uyarısı):
//   1. canonicalFromDoc — EK_C'nin kanonik kod bloğu
//   2. backendRoles     — user.entity.ts'teki GERÇEK UserRole enum'u (regex)
//   3. frontendRoles    — user.types.ts'teki GERÇEK UserRole enum'u (regex)
//
// Not: frontend tarafı artık `Object.values(UserRole)` ile DEĞİL, kaynak
// metinden regex ile okunuyor — bu script npm/vite/tsc olmadan, salt Node
// ile koşar (meta-repo'da node_modules yok, bu bilinçli: guard'ı çalıştırmak
// için bir submodule'ün bağımlılıklarını kurmak GEREKMEMELİ).
//
// İKİ YÖNLÜ karşılaştırma (EK_C'nin açıkça istediği şekilde): her çift için
// hem "eksik yok" (⊇) hem "fazla yok" (⊆) ayrı ayrı raporlanır.
//
// Çıkış: 0 = temiz · 1 = en az bir uyuşmazlık VEYA bir kaynak okunamadı.
// §2.5 sessiz sıfır yasağı: bir kaynak eksikse (submodule checkout edilmemiş
// vb.) bu SESSİZCE atlanmaz — açık bir hata ile exit 1.

import { readFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const REPO_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const CANONICAL_DOC_PATH = resolve(REPO_ROOT, 'docs/brd-v2/EK_C_VERI_SOZLUGU.md');
const BACKEND_ENTITY_PATH = resolve(
  REPO_ROOT,
  'collmind.backend/src/database/entities/user.entity.ts',
);
const FRONTEND_TYPES_PATH = resolve(
  REPO_ROOT,
  'collmind.frontend/src/types/user.types.ts',
);

let failed = false;

function readOrFail(path, label) {
  try {
    return readFileSync(path, 'utf-8');
  } catch (err) {
    console.error(
      `⛔ role-enum-contract: ${label} okunamadı (${path}).\n` +
        `   Orijinal hata: ${String(err)}`,
    );
    process.exit(1);
  }
}

function extractEnumWireValues(source, enumName, label) {
  const startMarker = `export enum ${enumName} {`;
  const startIdx = source.indexOf(startMarker);
  if (startIdx === -1) {
    console.error(
      `⛔ role-enum-contract: "${startMarker}" ${label} içinde bulunamadı — ` +
        `enum adı ya da bildirim şekli değişmiş olabilir, ayrıştırıcı güncellenmeli.`,
    );
    process.exit(1);
  }
  const bodyStart = startIdx + startMarker.length;
  const bodyEnd = source.indexOf('\n}', bodyStart);
  if (bodyEnd === -1) {
    console.error(
      `⛔ role-enum-contract: "${enumName}" enum bloğunun kapanışı ("\\n}") ${label} içinde bulunamadı.`,
    );
    process.exit(1);
  }
  const body = source.slice(bodyStart, bodyEnd);

  const values = [];
  const pattern = /^\s*[A-Z_][A-Z0-9_]*\s*=\s*'([^']*)'/gm;
  let match;
  while ((match = pattern.exec(body)) !== null) {
    values.push(match[1]);
  }

  if (values.length === 0) {
    console.error(
      `⛔ role-enum-contract: "${enumName}" bloğu ${label} içinde bulundu ama ` +
        `içinden hiç KEY = 'VALUE' çifti çıkarılamadı — desen bayatlamış olabilir.\n` +
        `Blok içeriği:\n${body}`,
    );
    process.exit(1);
  }

  return values;
}

function extractCanonicalRolesFromDoc(source) {
  const headingMarker = 'Rol değer kümesi — KANONİK KAYIT';
  const headingIdx = source.indexOf(headingMarker);
  if (headingIdx === -1) {
    console.error(
      `⛔ role-enum-contract: EK_C'de "${headingMarker}" başlığı bulunamadı — ` +
        `kayıt yeniden adlandırılmış/taşınmış olabilir, ayrıştırıcı güncellenmeli.`,
    );
    process.exit(1);
  }
  const fenceStart = source.indexOf('```', headingIdx);
  if (fenceStart === -1) {
    console.error(
      "⛔ role-enum-contract: KANONİK KAYIT başlığından sonra kod bloğu (```) bulunamadı.",
    );
    process.exit(1);
  }
  const contentStart = source.indexOf('\n', fenceStart) + 1;
  const fenceEnd = source.indexOf('```', contentStart);
  if (fenceEnd === -1) {
    console.error('⛔ role-enum-contract: kanonik kod bloğu kapanmıyor.');
    process.exit(1);
  }
  const content = source.slice(contentStart, fenceEnd).trim();
  const tokens = content
    .split('·')
    .map((t) => t.trim())
    .filter(Boolean);

  if (tokens.length === 0) {
    console.error(
      `⛔ role-enum-contract: kanonik kod bloğu boş ayrıştırıldı. Ham içerik: ${JSON.stringify(content)}`,
    );
    process.exit(1);
  }

  return tokens;
}

function assertSameSet(actual, expected, label) {
  const actualSet = new Set(actual);
  const expectedSet = new Set(expected);

  const missing = [...expectedSet].filter((v) => !actualSet.has(v)); // ⊇ ihlali
  const extra = [...actualSet].filter((v) => !expectedSet.has(v)); // ⊆ ihlali

  if (missing.length > 0) {
    console.error(`⛔ ${label}: eksik değer(ler) (⊇ ihlali): ${missing.join(', ')}`);
    failed = true;
  }
  if (extra.length > 0) {
    console.error(`⛔ ${label}: fazla değer(ler) (⊆ ihlali): ${extra.join(', ')}`);
    failed = true;
  }
  if (missing.length === 0 && extra.length === 0) {
    console.log(`  ✅ ${label}`);
  }
}

const canonicalFromDoc = extractCanonicalRolesFromDoc(
  readOrFail(CANONICAL_DOC_PATH, 'EK_C_VERI_SOZLUGU.md'),
);
const backendRoles = extractEnumWireValues(
  readOrFail(BACKEND_ENTITY_PATH, 'collmind.backend user.entity.ts'),
  'UserRole',
  'collmind.backend user.entity.ts',
);
const frontendRoles = extractEnumWireValues(
  readOrFail(FRONTEND_TYPES_PATH, 'collmind.frontend user.types.ts'),
  'UserRole',
  'collmind.frontend user.types.ts',
);

console.log('▶ role-enum-contract (T-356 · EK_C § Rol değer kümesi)');

if (canonicalFromDoc.length === 0) {
  console.error('⛔ EK_C kanonik kayıt boş ayrıştırıldı.');
  failed = true;
} else {
  console.log('  ✅ EK_C kanonik kayıt ayrıştırılabiliyor ve boş değil');
}

assertSameSet(backendRoles, canonicalFromDoc, 'backend ↔ EK_C kanonik küme');
// Kabul şartının doğrudan sınadığı çift: backend user.entity.ts'e
// `ADMIN = 'YÖNETİCİ'` mutasyonu uygulandığında bu assertion kırmızıya döner.
assertSameSet(frontendRoles, backendRoles, 'frontend ↔ backend UserRole');
assertSameSet(frontendRoles, canonicalFromDoc, 'frontend ↔ EK_C kanonik küme');

if (failed) {
  console.error('⛔ role-enum-contract — uyuşmazlık bulundu');
  process.exit(1);
}
console.log('✅ role-enum-contract — temiz');
process.exit(0);
