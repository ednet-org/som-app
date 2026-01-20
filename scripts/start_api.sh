#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export PORT="${PORT:-8081}"
API_URL="http://127.0.0.1:${PORT}"

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

  local status_json=""
  if status_json="$(supabase status --output json 2>/dev/null)"; then
    if ! python3 - "$status_json" <<'PY' >/dev/null 2>&1; then
import json, sys
data = json.loads(sys.argv[1])
services = data.get("services", {})
stopped = [name for name, info in services.items() if info.get("status") != "running"]
sys.exit(1 if stopped else 0)
PY
      echo "Supabase not healthy. Starting..."
      supabase start
      status_json="$(supabase status --output json)"
    fi
  else
    echo "Supabase not running. Starting..."
    supabase start
    status_json="$(supabase status --output json)"
  fi

  echo "$status_json"
}

SUPA_JSON="$(ensure_supabase)"
export DEV_FIXTURES="${DEV_FIXTURES:-true}"
export DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
export SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
export SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
export SUPABASE_STORAGE_BUCKET="${SUPABASE_STORAGE_BUCKET:-som-assets}"
export APP_BASE_URL="${APP_BASE_URL:-http://localhost:8090}"
export EMAIL_PROVIDER="${EMAIL_PROVIDER:-smtp}"
export EMAIL_FROM="${EMAIL_FROM:-no-reply@som.local}"
export EMAIL_FROM_NAME="${EMAIL_FROM_NAME:-SOM}"
export EMAIL_DEFAULT_LOCALE="${EMAIL_DEFAULT_LOCALE:-en}"
export EMAIL_OUTBOX_PATH="${EMAIL_OUTBOX_PATH:-}"
export SMTP_HOST="${SMTP_HOST:-inbucket}"
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
