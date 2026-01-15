#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

API_BASE_URL="${API_BASE_URL:-http://127.0.0.1:8081}"
OUTBOX_PATH="${OUTBOX_PATH:-api/storage/outbox}"
DEVICE="${DEVICE:-macos}"
export PATH="$ROOT/scripts/stubs:$PATH"

echo "Running integration tests on $DEVICE with API_BASE_URL=$API_BASE_URL"

"$ROOT/scripts/start_supabase.sh"

mkdir -p "$ROOT/api/storage/logs"
"$ROOT/scripts/start_api.sh" > "$ROOT/api/storage/logs/api-test.log" 2>&1 &
API_PID=$!

cleanup() {
  kill "$API_PID" 2>/dev/null || true
}
trap cleanup EXIT

flutter test integration_test/ui_smoke_test.dart -d "$DEVICE" \
  --dart-define=API_BASE_URL="$API_BASE_URL"

flutter test integration_test/app_test.dart -d "$DEVICE" \
  --dart-define=API_BASE_URL="$API_BASE_URL"

flutter test integration_test/api_contract_test.dart -d "$DEVICE" \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=OUTBOX_PATH="$OUTBOX_PATH"
