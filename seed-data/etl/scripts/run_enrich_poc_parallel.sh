#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

ENV_FILE="${ENV_FILE:-$ROOT/.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "OPENAI_API_KEY missing in $ENV_FILE" >&2
  exit 1
fi

SAMPLE_SIZE="${SAMPLE_SIZE:-1000}"
OFFSET="${OFFSET:-0}"
SLEEP_MS="${SLEEP_MS:-0}"
PARALLELISM="${PARALLELISM:-1}"
OPENAI_BATCH_SIZE="${OPENAI_BATCH_SIZE:-100}"
OPENAI_TIMEOUT_SECONDS="${OPENAI_TIMEOUT_SECONDS:-60}"
OPENAI_RETRIES="${OPENAI_RETRIES:-2}"
OPENAI_RETRY_DELAY_MS="${OPENAI_RETRY_DELAY_MS:-2000}"
OUT_DIR="${OUT_DIR:-$ROOT/seed-data/out/poc}"

MODELS=(
  "gpt-5-nano"
  "gpt-5-mini"
  "gpt-4.1-nano"
  "gpt-4.1-mini"
  "gpt-4o-mini"
  "gpt-4.1"
  "gpt-4o"
)

if [[ -n "${MODELS_CSV:-}" ]]; then
  IFS=',' read -r -a MODELS <<< "$MODELS_CSV"
fi

mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

RUN_META="$OUT_DIR/poc_run.json"
python3 - <<PY
import json
meta = {
  "sample_size": int("$SAMPLE_SIZE"),
  "offset": int("$OFFSET"),
  "sleep_ms": int("$SLEEP_MS"),
  "parallelism": int("$PARALLELISM"),
  "openai_batch_size": int("$OPENAI_BATCH_SIZE"),
  "openai_timeout_seconds": int("$OPENAI_TIMEOUT_SECONDS"),
  "openai_retries": int("$OPENAI_RETRIES"),
  "openai_retry_delay_ms": int("$OPENAI_RETRY_DELAY_MS"),
  "models": ${MODELS[@]+"["}"${MODELS[@]}"${MODELS[@]+"]"},
}
with open("$RUN_META","w") as f:
  json.dump(meta,f)
PY

for model in "${MODELS[@]}"; do
  safe_name="${model//\//_}"
  out_file="$OUT_DIR/${safe_name}.jsonl"
  log_file="$OUT_DIR/${safe_name}.log"
  temperature="0.2"
  if [[ "$model" == gpt-5* ]]; then
    temperature="1"
  fi
  : > "$out_file"
  {
    echo "=== $model ==="
    echo "Sample size: $SAMPLE_SIZE | Offset: $OFFSET | Sleep: ${SLEEP_MS}ms | Temp: $temperature"
  } | tee "$log_file"

  cmd="cd \"$ROOT/seed-data/etl\" && \
dart run bin/enrich_taxonomy.dart \
  --env local \
  --max-companies \"$SAMPLE_SIZE\" \
  --offset \"$OFFSET\" \
  --sleep-ms \"$SLEEP_MS\" \
  --temperature \"$temperature\" \
  --parallelism \"$PARALLELISM\" \
  --openai-batch-size \"$OPENAI_BATCH_SIZE\" \
  --openai-timeout-seconds \"$OPENAI_TIMEOUT_SECONDS\" \
  --openai-retries \"$OPENAI_RETRIES\" \
  --openai-retry-delay-ms \"$OPENAI_RETRY_DELAY_MS\" \
  --model \"$model\" \
  $(if [[ \"$model\" == gpt-5* ]]; then echo \"--openai-api responses --openai-reasoning-effort minimal\"; fi) \
  --output \"$out_file\" \
  --fail-on-unsupported"

  nohup bash -lc "$cmd" >> "$log_file" 2>&1 &
  echo "$!" >> "$OUT_DIR/poc_pids.txt"
done

echo "Started ${#MODELS[@]} model jobs in parallel. Logs in $OUT_DIR."
