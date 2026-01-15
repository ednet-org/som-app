#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SUPA_JSON="$(supabase status --output json)"
export DEV_FIXTURES="${DEV_FIXTURES:-true}"
export DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
export SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
export SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
export SUPABASE_STORAGE_BUCKET="${SUPABASE_STORAGE_BUCKET:-som-assets}"

DART_DEFINES="$(SUPA_JSON="$SUPA_JSON" DEV_FIXTURES="$DEV_FIXTURES" \
  DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD" \
  SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL" \
  SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD" \
  SUPABASE_STORAGE_BUCKET="$SUPABASE_STORAGE_BUCKET" \
  python3 - <<'PY'
import json
import os

info = json.loads(os.environ["SUPA_JSON"])
defines = [
    f"-DSUPABASE_URL={info['API_URL']}",
    f"-DSUPABASE_ANON_KEY={info['ANON_KEY']}",
    f"-DSUPABASE_SERVICE_ROLE_KEY={info['SERVICE_ROLE_KEY']}",
    f"-DSUPABASE_JWT_SECRET={info['JWT_SECRET']}",
    f"-DSUPABASE_STORAGE_BUCKET={os.environ['SUPABASE_STORAGE_BUCKET']}",
    f"-DDEV_FIXTURES={os.environ['DEV_FIXTURES']}",
    f"-DDEV_FIXTURES_PASSWORD={os.environ['DEV_FIXTURES_PASSWORD']}",
    f"-DSYSTEM_ADMIN_EMAIL={os.environ['SYSTEM_ADMIN_EMAIL']}",
    f"-DSYSTEM_ADMIN_PASSWORD={os.environ['SYSTEM_ADMIN_PASSWORD']}",
]
print(" ".join(defines))
PY
)"

export PORT="${PORT:-8081}"

cd "$ROOT/api"
if [[ ! -f build/bin/server.dart ]]; then
  dart_frog build
fi

exec dart $DART_DEFINES build/bin/server.dart
