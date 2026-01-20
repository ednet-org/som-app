#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/ensure_hosts.sh"

API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8081}"
OUTBOX_PATH="${OUTBOX_PATH:-api/storage/outbox}"
DEVICE="${DEVICE:-macos}"
SUPABASE_URL="${SUPABASE_URL:-}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"
SUPABASE_SCHEMA="${SUPABASE_SCHEMA:-som}"
DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
BUYER_ADMIN_EMAIL="${BUYER_ADMIN_EMAIL:-buyer-admin@som.local}"
CONSULTANT_ADMIN_EMAIL="${CONSULTANT_ADMIN_EMAIL:-consultant-admin@som.local}"
PROVIDER_ADMIN_EMAIL="${PROVIDER_ADMIN_EMAIL:-provider-admin@som.local}"
SUPABASE_APPLY_STORAGE_RLS_STRICT="${SUPABASE_APPLY_STORAGE_RLS_STRICT:-true}"
export PATH="$ROOT/scripts/stubs:$PATH"
export SUPABASE_APPLY_STORAGE_RLS_STRICT

echo "Running integration tests on $DEVICE with API_BASE_URL=$API_BASE_URL"

"$ROOT/scripts/start_supabase.sh"

load_supabase_env() {
  if [[ -n "$SUPABASE_URL" && -n "$SUPABASE_ANON_KEY" ]]; then
    return 0
  fi
  if ! command -v supabase >/dev/null 2>&1; then
    return 0
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    return 0
  fi
  local status_json
  status_json="$(supabase status --output json 2>/dev/null || true)"
  if [[ -z "$status_json" ]]; then
    return 0
  fi
  read -r SUPABASE_URL SUPABASE_ANON_KEY <<<"$(STATUS_RAW="$status_json" python3 - <<'PY'
import json
import os

raw = os.environ.get("STATUS_RAW", "")
start = raw.find("{")
end = raw.rfind("}")
if start == -1 or end == -1:
    print("", "")
    raise SystemExit(0)

payload = raw[start : end + 1]
try:
    info = json.loads(payload)
except Exception:
    info = {}
print(info.get("API_URL", ""), info.get("ANON_KEY", ""))
PY
)"
}

load_supabase_env

mkdir -p "$ROOT/api/storage/logs"
"$ROOT/scripts/start_api.sh" > "$ROOT/api/storage/logs/api-test.log" 2>&1 &
API_PID=$!

cleanup() {
  kill "$API_PID" 2>/dev/null || true
}
trap cleanup EXIT

DART_DEFINES=(
  --dart-define=API_BASE_URL="$API_BASE_URL"
  --dart-define=OUTBOX_PATH="$OUTBOX_PATH"
  --dart-define=DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD"
  --dart-define=SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL"
  --dart-define=SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD"
  --dart-define=BUYER_ADMIN_EMAIL="$BUYER_ADMIN_EMAIL"
  --dart-define=CONSULTANT_ADMIN_EMAIL="$CONSULTANT_ADMIN_EMAIL"
  --dart-define=PROVIDER_ADMIN_EMAIL="$PROVIDER_ADMIN_EMAIL"
  --dart-define=SUPABASE_SCHEMA="$SUPABASE_SCHEMA"
)
if [[ -n "${SUPABASE_URL:-}" ]]; then
  DART_DEFINES+=(--dart-define=SUPABASE_URL="$SUPABASE_URL")
fi
if [[ -n "${SUPABASE_ANON_KEY:-}" ]]; then
  DART_DEFINES+=(--dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY")
fi

flutter test integration_test/ui_smoke_test.dart -d "$DEVICE" \
  "${DART_DEFINES[@]}"

flutter test integration_test/app_test.dart -d "$DEVICE" \
  "${DART_DEFINES[@]}"

flutter test integration_test/api_contract_test.dart -d "$DEVICE" \
  "${DART_DEFINES[@]}"
