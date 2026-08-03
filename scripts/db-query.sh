#!/usr/bin/env bash
set -euo pipefail
docker exec -i collmind-tpm-postgres psql -U postgres -d collmind_tpm \
  -v ON_ERROR_STOP=1 -c "$1"
