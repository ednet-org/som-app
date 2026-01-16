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
