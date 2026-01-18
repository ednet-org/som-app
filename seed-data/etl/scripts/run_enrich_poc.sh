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
SLEEP_MS="${SLEEP_MS:-50}"
OUT_DIR="${OUT_DIR:-$ROOT/seed-data/out/poc}"
TEMPERATURE_DEFAULT="${TEMPERATURE:-0.2}"
PARALLELISM="${PARALLELISM:-1}"
OPENAI_BATCH_SIZE="${OPENAI_BATCH_SIZE:-100}"
OPENAI_TIMEOUT_SECONDS="${OPENAI_TIMEOUT_SECONDS:-60}"
OPENAI_RETRIES="${OPENAI_RETRIES:-2}"
OPENAI_RETRY_DELAY_MS="${OPENAI_RETRY_DELAY_MS:-2000}"
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

for model in "${MODELS[@]}"; do
  safe_name="${model//\//_}"
  out_file="$OUT_DIR/${safe_name}.jsonl"
  log_file="$OUT_DIR/${safe_name}.log"
  temperature="$TEMPERATURE_DEFAULT"
  if [[ "$model" == gpt-5* ]]; then
    temperature="1"
  fi
  : > "$out_file"
  echo "=== $model ===" | tee "$log_file"
  echo "Sample size: $SAMPLE_SIZE | Offset: $OFFSET | Sleep: ${SLEEP_MS}ms | Temp: $temperature" | tee -a "$log_file"

  if ! (cd "$ROOT/seed-data/etl" && dart run bin/enrich_taxonomy.dart \
    --env local \
    --max-companies "$SAMPLE_SIZE" \
    --offset "$OFFSET" \
    --sleep-ms "$SLEEP_MS" \
    --temperature "$temperature" \
    --parallelism "$PARALLELISM" \
    --openai-batch-size "$OPENAI_BATCH_SIZE" \
    --openai-timeout-seconds "$OPENAI_TIMEOUT_SECONDS" \
    --openai-retries "$OPENAI_RETRIES" \
    --openai-retry-delay-ms "$OPENAI_RETRY_DELAY_MS" \
    --model "$model" \
    $(if [[ "$model" == gpt-5* ]]; then echo "--openai-api responses --openai-reasoning-effort minimal"; fi) \
    --output "$out_file" \
    --fail-on-unsupported \
    --dry-run >> "$log_file" 2>&1); then
    echo "FAILED: $model" | tee -a "$log_file"
  else
    echo "DONE: $model" | tee -a "$log_file"
  fi
done
