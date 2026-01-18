#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
LOG="${LOG:-$ROOT/seed-data/out/enrich_monitor.log}"
STATE_FILE="${STATE_FILE:-$ROOT/seed-data/out/enrich_state.json}"
CHECK_INTERVAL="${CHECK_INTERVAL:-300}"

log() {
  echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] $*" >> "$LOG"
}

read_state() {
  if [[ ! -f "$STATE_FILE" ]]; then
    echo "{}"
    return
  fi
  cat "$STATE_FILE"
}

while true; do
  STATE_JSON="$(read_state)"
  STATUS="$(python3 - <<PY
import json,sys
try:
  data=json.loads(sys.stdin.read() or "{}")
  print(data.get("status",""))
except Exception:
  print("")
PY
<<EOF
$STATE_JSON
EOF
)"
  OFFSET="$(python3 - <<PY
import json,sys
try:
  data=json.loads(sys.stdin.read() or "{}")
  print(data.get("offset",0))
except Exception:
  print(0)
PY
<<EOF
$STATE_JSON
EOF
)"

  if [[ "$STATUS" == "completed" ]]; then
    log "Enrichment completed."
    exit 0
  fi

  if ! pgrep -f enrich_taxonomy.dart >/dev/null 2>&1; then
    log "Enrichment process missing. Restarting from offset $OFFSET."
    START_OFFSET="$OFFSET" nohup "$ROOT/seed-data/etl/scripts/run_enrich_taxonomy.sh" >/dev/null 2>&1 &
  else
    log "Enrichment running. Offset=$OFFSET."
  fi

  sleep "$CHECK_INTERVAL"
done
