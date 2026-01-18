#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT/seed-data/out/poc}"
CHECK_INTERVAL="${CHECK_INTERVAL:-60}"

OUT_DIR="$(cd "$OUT_DIR" && pwd)"
RUN_META="$OUT_DIR/poc_run.json"
LOG_FILE="$OUT_DIR/poc_monitor.log"

log() {
  echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] $*" >> "$LOG_FILE"
}

if [[ ! -f "$RUN_META" ]]; then
  echo "Missing $RUN_META" >&2
  exit 1
fi

models_json=$(python3 - <<PY
import json
print(json.dumps(json.load(open("$RUN_META"))["models"]))
PY
)
sample_size=$(python3 - <<PY
import json
print(json.load(open("$RUN_META"))["sample_size"])
PY
)

while true; do
  for model in $(python3 - <<PY
import json
for m in json.loads('''$models_json'''):
    print(m)
PY
); do
    safe_name="${model//\//_}"
    out_file="$OUT_DIR/${safe_name}.jsonl"
    log_file="$OUT_DIR/${safe_name}.log"
    count=0
    if [[ -f "$out_file" ]]; then
      count=$(wc -l < "$out_file" | tr -d ' ')
    fi

    if pgrep -f "model $model" >/dev/null 2>&1; then
      log "running $model count=$count"
      continue
    fi

    if [[ "$count" -ge "$sample_size" ]]; then
      log "completed $model count=$count"
      continue
    fi

    log "restarting $model count=$count"
    temperature="0.2"
    if [[ "$model" == gpt-5* ]]; then
      temperature="1"
    fi
    (
      cd "$ROOT/seed-data/etl"
      dart run bin/enrich_taxonomy.dart \
        --env local \
        --max-companies "$sample_size" \
        --offset 0 \
        --sleep-ms 0 \
        --temperature "$temperature" \
        --parallelism 1 \
        --openai-batch-size 100 \
        --openai-timeout-seconds 60 \
        --openai-retries 2 \
        --openai-retry-delay-ms 2000 \
        --model "$model" \
        --output "$out_file" \
        --fail-on-unsupported \
        --dry-run >> "$log_file" 2>&1
    ) &
  done

  sleep "$CHECK_INTERVAL"
done
