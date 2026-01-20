#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export PORT="${PORT:-8081}"
API_URL="http://127.0.0.1:${PORT}"
SUPABASE_PROJECT_ID="${SUPABASE_PROJECT_ID:-}"
export SUPABASE_PROJECT_ID

# Idempotent: Check if API is already running
if curl -s "$API_URL" >/dev/null 2>&1; then
  echo "API already running on $API_URL"
  exit 0
fi

ensure_supabase() {
  if ! command -v supabase >/dev/null 2>&1; then
    echo "Supabase CLI not found. Install it or start Supabase manually." >&2
    exit 1
  fi

  local status_raw=""
  local status_json=""
  status_raw="$(supabase_status 2>/dev/null || true)"
  status_json="$(sanitize_supabase_json "$status_raw")"
  if [[ -z "$status_json" ]]; then
    echo "Supabase not running. Starting..."
    supabase_start
    status_raw="$(supabase_status 2>/dev/null || true)"
    status_json="$(sanitize_supabase_json "$status_raw")"
  fi

  echo "$status_json"
}

apply_migrations() {
  if [[ "${SUPABASE_APPLY_MIGRATIONS:-true}" != "true" ]]; then
    return 0
  fi

  echo "Applying Supabase migrations..." >&2
  supabase_migration_up >&2
}

supabase_status() {
  if [[ -n "$SUPABASE_PROJECT_ID" ]]; then
    supabase status --output json --project-id "$SUPABASE_PROJECT_ID"
  else
    supabase status --output json
  fi
}

supabase_start() {
  if [[ -n "$SUPABASE_PROJECT_ID" ]]; then
    supabase start --project-id "$SUPABASE_PROJECT_ID" --exclude vector
  else
    supabase start --exclude vector
  fi
}

supabase_migration_up() {
  if [[ -n "$SUPABASE_PROJECT_ID" ]]; then
    supabase migration up --project-id "$SUPABASE_PROJECT_ID"
  else
    supabase migration up
  fi
}

sanitize_supabase_json() {
  local raw="${1:-}"
  python3 - "$raw" <<'PY'
import sys
raw = sys.argv[1] if len(sys.argv) > 1 else ""
start = raw.find("{")
end = raw.rfind("}")
if start == -1 or end == -1 or end < start:
    print("")
    raise SystemExit(0)
print(raw[start : end + 1])
PY
}

apply_storage_rls() {
  if [[ "${SUPABASE_APPLY_STORAGE_RLS:-true}" != "true" ]]; then
    return 0
  fi

  bash "$ROOT/scripts/apply_storage_rls.sh"
}

SUPA_JSON="$(sanitize_supabase_json "$(ensure_supabase)")"
if [[ -z "$SUPA_JSON" ]]; then
  echo "Failed to parse Supabase status output. Run 'supabase status --output json' to debug." >&2
  exit 1
fi
apply_migrations
apply_storage_rls
export DEV_FIXTURES="${DEV_FIXTURES:-true}"
export DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
export SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
export SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
export SUPABASE_STORAGE_BUCKET="${SUPABASE_STORAGE_BUCKET:-som-assets}"
export SUPABASE_SCHEMA="${SUPABASE_SCHEMA:-som}"
export APP_BASE_URL="${APP_BASE_URL:-http://localhost:8090}"
export EMAIL_PROVIDER="${EMAIL_PROVIDER:-outbox}"
export EMAIL_FROM="${EMAIL_FROM:-no-reply@som.local}"
export EMAIL_FROM_NAME="${EMAIL_FROM_NAME:-SOM}"
export EMAIL_DEFAULT_LOCALE="${EMAIL_DEFAULT_LOCALE:-en}"
export EMAIL_OUTBOX_PATH="${EMAIL_OUTBOX_PATH:-}"
export SMTP_HOST="${SMTP_HOST:-127.0.0.1}"
export SMTP_PORT="${SMTP_PORT:-2500}"
export SMTP_USERNAME="${SMTP_USERNAME:-inbucket}"
export SMTP_PASSWORD="${SMTP_PASSWORD:-inbucket}"
export SMTP_USE_TLS="${SMTP_USE_TLS:-false}"
export SMTP_ALLOW_INSECURE="${SMTP_ALLOW_INSECURE:-true}"
export SENDGRID_API_KEY="${SENDGRID_API_KEY:-}"
export CORS_ALLOWED_ORIGINS="${CORS_ALLOWED_ORIGINS:-http://localhost:8090,http://som.localhost:8090}"
export CORS_ALLOW_CREDENTIALS="${CORS_ALLOW_CREDENTIALS:-false}"
export ENABLE_HSTS="${ENABLE_HSTS:-false}"
export HSTS_MAX_AGE_SECONDS="${HSTS_MAX_AGE_SECONDS:-31536000}"
export CSP="${CSP:-}"
export RATE_LIMIT_LOGIN="${RATE_LIMIT_LOGIN:-0}"
export RATE_LIMIT_RESET="${RATE_LIMIT_RESET:-0}"
export RATE_LIMIT_PDF="${RATE_LIMIT_PDF:-0}"
export RATE_LIMIT_EXPORT="${RATE_LIMIT_EXPORT:-0}"
export DISABLE_NOTIFICATIONS="${DISABLE_NOTIFICATIONS:-true}"

DART_DEFINES="$(SUPA_JSON="$SUPA_JSON" DEV_FIXTURES="$DEV_FIXTURES" \
  DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD" \
  SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL" \
  SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD" \
  SUPABASE_STORAGE_BUCKET="$SUPABASE_STORAGE_BUCKET" \
  APP_BASE_URL="$APP_BASE_URL" \
  EMAIL_PROVIDER="$EMAIL_PROVIDER" \
  EMAIL_FROM="$EMAIL_FROM" \
  EMAIL_FROM_NAME="$EMAIL_FROM_NAME" \
  EMAIL_DEFAULT_LOCALE="$EMAIL_DEFAULT_LOCALE" \
  EMAIL_OUTBOX_PATH="$EMAIL_OUTBOX_PATH" \
  SMTP_HOST="$SMTP_HOST" \
  SMTP_PORT="$SMTP_PORT" \
  SMTP_USERNAME="$SMTP_USERNAME" \
  SMTP_PASSWORD="$SMTP_PASSWORD" \
  SMTP_USE_TLS="$SMTP_USE_TLS" \
  SMTP_ALLOW_INSECURE="$SMTP_ALLOW_INSECURE" \
  SENDGRID_API_KEY="$SENDGRID_API_KEY" \
  CORS_ALLOWED_ORIGINS="$CORS_ALLOWED_ORIGINS" \
  CORS_ALLOW_CREDENTIALS="$CORS_ALLOW_CREDENTIALS" \
  ENABLE_HSTS="$ENABLE_HSTS" \
  HSTS_MAX_AGE_SECONDS="$HSTS_MAX_AGE_SECONDS" \
  CSP="$CSP" \
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
    f"-DSUPABASE_SCHEMA={os.environ['SUPABASE_SCHEMA']}",
    f"-DDEV_FIXTURES={os.environ['DEV_FIXTURES']}",
    f"-DDEV_FIXTURES_PASSWORD={os.environ['DEV_FIXTURES_PASSWORD']}",
    f"-DSYSTEM_ADMIN_EMAIL={os.environ['SYSTEM_ADMIN_EMAIL']}",
    f"-DSYSTEM_ADMIN_PASSWORD={os.environ['SYSTEM_ADMIN_PASSWORD']}",
    f"-DAPP_BASE_URL={os.environ['APP_BASE_URL']}",
]

def maybe_define(key, value):
    if value:
        defines.append(f"-D{key}={value}")

maybe_define("EMAIL_PROVIDER", os.environ.get("EMAIL_PROVIDER", ""))
maybe_define("EMAIL_FROM", os.environ.get("EMAIL_FROM", ""))
maybe_define("EMAIL_FROM_NAME", os.environ.get("EMAIL_FROM_NAME", ""))
maybe_define("EMAIL_DEFAULT_LOCALE", os.environ.get("EMAIL_DEFAULT_LOCALE", ""))
maybe_define("EMAIL_OUTBOX_PATH", os.environ.get("EMAIL_OUTBOX_PATH", ""))
maybe_define("SMTP_HOST", os.environ.get("SMTP_HOST", ""))
maybe_define("SMTP_PORT", os.environ.get("SMTP_PORT", ""))
maybe_define("SMTP_USERNAME", os.environ.get("SMTP_USERNAME", ""))
maybe_define("SMTP_PASSWORD", os.environ.get("SMTP_PASSWORD", ""))
maybe_define("SMTP_USE_TLS", os.environ.get("SMTP_USE_TLS", ""))
maybe_define("SMTP_ALLOW_INSECURE", os.environ.get("SMTP_ALLOW_INSECURE", ""))
maybe_define("SENDGRID_API_KEY", os.environ.get("SENDGRID_API_KEY", ""))
maybe_define("CORS_ALLOWED_ORIGINS", os.environ.get("CORS_ALLOWED_ORIGINS", ""))
maybe_define("CORS_ALLOW_CREDENTIALS", os.environ.get("CORS_ALLOW_CREDENTIALS", ""))
maybe_define("ENABLE_HSTS", os.environ.get("ENABLE_HSTS", ""))
maybe_define("HSTS_MAX_AGE_SECONDS", os.environ.get("HSTS_MAX_AGE_SECONDS", ""))
maybe_define("CSP", os.environ.get("CSP", ""))
maybe_define("DISABLE_NOTIFICATIONS", os.environ.get("DISABLE_NOTIFICATIONS", ""))

print(" ".join(defines))
PY
)"

cd "$ROOT/api"
BUILD_TARGET="$ROOT/api/build/bin/server.dart"
NEEDS_BUILD=false
if [[ ! -f "$BUILD_TARGET" ]]; then
  NEEDS_BUILD=true
else
  if find "$ROOT/api/lib" "$ROOT/api/routes" -type f -name '*.dart' -newer "$BUILD_TARGET" | grep -q .; then
    NEEDS_BUILD=true
  fi
  if [[ "$ROOT/api/pubspec.yaml" -nt "$BUILD_TARGET" ]]; then
    NEEDS_BUILD=true
  fi
fi

if [[ "$NEEDS_BUILD" == "true" ]]; then
  dart_frog build
fi

echo "Starting API on $API_URL"
exec dart $DART_DEFINES build/bin/server.dart
