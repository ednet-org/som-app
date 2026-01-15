#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/start_supabase.sh"

mkdir -p "$ROOT/api/storage/logs"
"$ROOT/scripts/start_api.sh" > "$ROOT/api/storage/logs/api.log" 2>&1 &
API_PID=$!

echo "API running (PID: $API_PID). Logs: api/storage/logs/api.log"

cleanup() {
  kill "$API_PID" 2>/dev/null || true
}
trap cleanup EXIT

if [[ "${START_FLUTTER:-true}" == "true" ]]; then
  "$ROOT/scripts/start_flutter.sh"
else
  echo "Flutter not started. Set START_FLUTTER=true to launch."
  wait "$API_PID"
fi
