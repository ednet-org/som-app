#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

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
APP_BASE_URL="${APP_BASE_URL:-http://localhost:8090}"

DART_DEFINES="$(SUPA_JSON="$SUPA_JSON" APP_BASE_URL="$APP_BASE_URL" \
  EMAIL_PROVIDER="${EMAIL_PROVIDER:-}" \
  EMAIL_FROM="${EMAIL_FROM:-}" \
  EMAIL_FROM_NAME="${EMAIL_FROM_NAME:-}" \
  EMAIL_DEFAULT_LOCALE="${EMAIL_DEFAULT_LOCALE:-}" \
  EMAIL_OUTBOX_PATH="${EMAIL_OUTBOX_PATH:-}" \
  SMTP_HOST="${SMTP_HOST:-}" \
  SMTP_PORT="${SMTP_PORT:-}" \
  SMTP_USERNAME="${SMTP_USERNAME:-}" \
  SMTP_PASSWORD="${SMTP_PASSWORD:-}" \
  SMTP_USE_TLS="${SMTP_USE_TLS:-}" \
  SMTP_ALLOW_INSECURE="${SMTP_ALLOW_INSECURE:-}" \
  SENDGRID_API_KEY="${SENDGRID_API_KEY:-}" \
  SCHEDULER_INTERVAL_MINUTES="${SCHEDULER_INTERVAL_MINUTES:-}" \
  SCHEDULER_RUN_ONCE="${SCHEDULER_RUN_ONCE:-}" \
  python3 - <<'PY'
import json
import os

info = json.loads(os.environ["SUPA_JSON"])
defines = [
    f"-DSUPABASE_URL={info['API_URL']}",
    f"-DSUPABASE_ANON_KEY={info['ANON_KEY']}",
    f"-DSUPABASE_SERVICE_ROLE_KEY={info['SERVICE_ROLE_KEY']}",
    f"-DSUPABASE_JWT_SECRET={info['JWT_SECRET']}",
    f"-DSUPABASE_STORAGE_BUCKET={os.environ.get('SUPABASE_STORAGE_BUCKET', 'som-assets')}",
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
maybe_define("SCHEDULER_INTERVAL_MINUTES", os.environ.get("SCHEDULER_INTERVAL_MINUTES", ""))
maybe_define("SCHEDULER_RUN_ONCE", os.environ.get("SCHEDULER_RUN_ONCE", ""))

print(" ".join(defines))
PY
)"

cd "$ROOT/api"
echo "Starting scheduler worker..."
exec dart $DART_DEFINES bin/scheduler.dart
