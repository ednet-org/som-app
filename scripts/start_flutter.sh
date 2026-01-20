#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Optional hostnames for tenant-style URLs.
"$ROOT/scripts/ensure_hosts.sh"

# Idempotent: Kill existing Flutter process for this project before starting
pkill -f "flutter.*som-app.*run" 2>/dev/null || true

API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8081}"
DEV_QUICK_LOGIN="${DEV_QUICK_LOGIN:-true}"
DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
SUPABASE_URL="${SUPABASE_URL:-}"
SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"
SUPABASE_SCHEMA="${SUPABASE_SCHEMA:-som}"
TARGET="${TARGET:-chrome}"
FLUTTER_WEB_MODE="${FLUTTER_WEB_MODE:-debug}"
START_DEPENDENCIES="${START_DEPENDENCIES:-true}"
START_SUPABASE="${START_SUPABASE:-true}"
START_API="${START_API:-true}"

API_SCHEME="http"
API_HOST="127.0.0.1"
API_PORT="8081"
if command -v python3 >/dev/null 2>&1; then
  read -r API_SCHEME API_HOST API_PORT <<<"$(python3 - <<'PY'
import os
from urllib.parse import urlparse

url = os.environ.get("API_BASE_URL", "http://127.0.0.1:8081")
parsed = urlparse(url)
scheme = parsed.scheme or "http"
host = parsed.hostname or "127.0.0.1"
port = parsed.port or (443 if scheme == "https" else 80)
print(scheme, host, port)
PY
)"
fi

is_local_api_host() {
  case "$API_HOST" in
    127.0.0.1|localhost|::1) return 0 ;;
    *) return 1 ;;
  esac
}

is_api_running() {
  if command -v nc >/dev/null 2>&1; then
    nc -z "$API_HOST" "$API_PORT" >/dev/null 2>&1
    return $?
  fi
  curl -s --max-time 1 "$API_SCHEME://$API_HOST:$API_PORT" >/dev/null 2>&1
}

ensure_supabase() {
  if ! command -v supabase >/dev/null 2>&1; then
    echo "Supabase CLI not found. Skipping supabase start."
    return 0
  fi
  if supabase status --output json >/dev/null 2>&1; then
    return 0
  fi
  echo "Supabase not running. Starting..."
  "$ROOT/scripts/start_supabase.sh"
}

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
  read -r SUPABASE_URL SUPABASE_ANON_KEY <<<"$(SUPA_JSON="$status_json" python3 - <<'PY'
import json
import os

try:
    info = json.loads(os.environ["SUPA_JSON"])
except Exception:
    info = {}
print(info.get("API_URL", ""), info.get("ANON_KEY", ""))
PY
)"
}

ensure_api() {
  if is_api_running; then
    echo "API already running on ${API_HOST}:${API_PORT}"
    return 0
  fi
  mkdir -p "$ROOT/api/storage/logs"
  echo "API not running on ${API_HOST}:${API_PORT}. Starting..."
  PORT="$API_PORT" "$ROOT/scripts/start_api.sh" > "$ROOT/api/storage/logs/api.log" 2>&1 &
  for _ in {1..20}; do
    if is_api_running; then
      echo "API started on ${API_HOST}:${API_PORT}. Logs: api/storage/logs/api.log"
      return 0
    fi
    sleep 0.5
  done
  echo "API did not start within timeout. Check api/storage/logs/api.log"
}

if [[ "$START_DEPENDENCIES" == "true" ]]; then
  if is_local_api_host; then
    if [[ "$START_SUPABASE" == "true" ]]; then
      ensure_supabase
      load_supabase_env
    fi
    if [[ "$START_API" == "true" ]]; then
      ensure_api
    fi
  else
    echo "API_BASE_URL is remote ($API_HOST). Skipping local dependency startup."
  fi
fi

DART_DEFINES=(
  --dart-define=API_BASE_URL="$API_BASE_URL"
  --dart-define=DEV_QUICK_LOGIN="$DEV_QUICK_LOGIN"
  --dart-define=DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD"
  --dart-define=SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD"
  --dart-define=SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL"
)
if [[ -n "${SUPABASE_URL:-}" ]]; then
  DART_DEFINES+=(--dart-define=SUPABASE_URL="$SUPABASE_URL")
fi
if [[ -n "${SUPABASE_ANON_KEY:-}" ]]; then
  DART_DEFINES+=(--dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY")
fi
if [[ -n "${SUPABASE_SCHEMA:-}" ]]; then
  DART_DEFINES+=(--dart-define=SUPABASE_SCHEMA="$SUPABASE_SCHEMA")
fi

if [[ "$TARGET" == "macos" ]]; then
  DEBUG_APP_PATH="$ROOT/build/macos/Build/Products/Debug/som.app"
  if [[ -d "$DEBUG_APP_PATH" ]]; then
    TS="$(date +%Y%m%d-%H%M%S)"
    BACKUP_PATH="$ROOT/build/macos/Build/Products/Debug/som.app.bak.$TS"
    echo "Detected existing macOS app bundle. Moving to $BACKUP_PATH to avoid write-protection issues."
    mv "$DEBUG_APP_PATH" "$BACKUP_PATH" 2>/dev/null || true
  fi
fi

if [[ "$TARGET" == "chrome" || "$TARGET" == "web-server" ]]; then
  WEB_PORT="${WEB_PORT:-8090}"
  if [[ "$FLUTTER_WEB_MODE" == "release" ]]; then
    flutter build web --release \
      "${DART_DEFINES[@]}"
    exec python3 -m http.server "$WEB_PORT" -d build/web
  else
    exec flutter run -d "$TARGET" --web-port "$WEB_PORT" \
      "${DART_DEFINES[@]}"
  fi
else
  exec flutter run -d "$TARGET" \
    "${DART_DEFINES[@]}"
fi
