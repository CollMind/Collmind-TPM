#!/usr/bin/env bash
#
# K1a (Z52 §3/§4) — insan-yolu DB erişimi. `app_operator` (NOSUPERUSER,
# BYPASSRLS) ile bağlanır; `postgres` superuser'ının YERİNE geçer
# (`scripts/db-roles-setup.sh` rolü kurar, `scripts/db-roles-operator-
# grants.sh` GRANT'lerini uygular — local `trust` auth ile unix soketi
# üzerinden şifresiz bağlanır, aynı `01-roles-and-ownership.sql`'in
# app_migrate/app_runtime için kullandığı mekanizma).
set -euo pipefail
docker exec -i collmind-tpm-postgres psql -U app_operator -d collmind_tpm \
  -v ON_ERROR_STOP=1 -c "$1"
