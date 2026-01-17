#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Idempotent: Kill existing Flutter process for this project before starting
pkill -f "flutter.*som-app.*run" 2>/dev/null || true

API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8081}"
DEV_QUICK_LOGIN="${DEV_QUICK_LOGIN:-true}"
DEV_FIXTURES_PASSWORD="${DEV_FIXTURES_PASSWORD:-DevPass123!}"
SYSTEM_ADMIN_PASSWORD="${SYSTEM_ADMIN_PASSWORD:-ChangeMe123!}"
SYSTEM_ADMIN_EMAIL="${SYSTEM_ADMIN_EMAIL:-system-admin@som.local}"
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
    fi
    if [[ "$START_API" == "true" ]]; then
      ensure_api
    fi
  else
    echo "API_BASE_URL is remote ($API_HOST). Skipping local dependency startup."
  fi
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
      --dart-define=API_BASE_URL="$API_BASE_URL" \
      --dart-define=DEV_QUICK_LOGIN="$DEV_QUICK_LOGIN" \
      --dart-define=DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD" \
      --dart-define=SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD" \
      --dart-define=SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL"
    exec python3 -m http.server "$WEB_PORT" -d build/web
  else
    exec flutter run -d "$TARGET" --web-port "$WEB_PORT" \
      --dart-define=API_BASE_URL="$API_BASE_URL" \
      --dart-define=DEV_QUICK_LOGIN="$DEV_QUICK_LOGIN" \
      --dart-define=DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD" \
      --dart-define=SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD" \
      --dart-define=SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL"
  fi
else
  exec flutter run -d "$TARGET" \
    --dart-define=API_BASE_URL="$API_BASE_URL" \
    --dart-define=DEV_QUICK_LOGIN="$DEV_QUICK_LOGIN" \
    --dart-define=DEV_FIXTURES_PASSWORD="$DEV_FIXTURES_PASSWORD" \
    --dart-define=SYSTEM_ADMIN_PASSWORD="$SYSTEM_ADMIN_PASSWORD" \
    --dart-define=SYSTEM_ADMIN_EMAIL="$SYSTEM_ADMIN_EMAIL"
fi
