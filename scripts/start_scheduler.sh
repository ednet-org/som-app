#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
SUPABASE_PROJECT_ID="${SUPABASE_PROJECT_ID:-}"
export SUPABASE_PROJECT_ID

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
APP_BASE_URL="${APP_BASE_URL:-http://localhost:8090}"
SUPABASE_SCHEMA="${SUPABASE_SCHEMA:-som}"

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
    f"-DSUPABASE_SCHEMA={os.environ.get('SUPABASE_SCHEMA', 'som')}",
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
