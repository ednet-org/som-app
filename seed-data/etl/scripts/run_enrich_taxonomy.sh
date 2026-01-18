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

START_OFFSET="${START_OFFSET:-0}"
BATCH_SIZE="${BATCH_SIZE:-200}"
SLEEP_MS="${SLEEP_MS:-100}"
TEMPERATURE="${TEMPERATURE:-0.2}"
OPENAI_MODEL="${OPENAI_MODEL:-gpt-5-nano}"
OPENAI_BATCH_SIZE="${OPENAI_BATCH_SIZE:-100}"
OPENAI_TIMEOUT_SECONDS="${OPENAI_TIMEOUT_SECONDS:-60}"
OPENAI_RETRIES="${OPENAI_RETRIES:-2}"
OPENAI_RETRY_DELAY_MS="${OPENAI_RETRY_DELAY_MS:-2000}"
LOG="${LOG:-$ROOT/seed-data/out/enrich_taxonomy.log}"
STATE_FILE="${STATE_FILE:-$ROOT/seed-data/out/enrich_state.json}"

STATUS_JSON="$(supabase status --output json 2>/dev/null | awk 'BEGIN{s=0} /^\{/ {s=1} {if (s) print} /^\}$/ {exit}')"
DB_URL="$(STATUS_JSON="$STATUS_JSON" python3 - <<'PY'
import json, os, sys
raw = os.environ.get("STATUS_JSON", "")
if not raw:
    sys.exit("Failed to read Supabase status JSON")
print(json.loads(raw)["DB_URL"])
PY
)"
TOTAL="$(psql "$DB_URL" -Atc "select count(*) from provider_profiles where provider_type is not null and lower(provider_type) <> 'dienstleister';")"

: > "$LOG"

write_state() {
  STATUS="$1"
  OFFSET="$2"
  python3 - <<PY
import json, datetime
state = {
  "status": "$STATUS",
  "offset": int("$OFFSET"),
  "total": int("$TOTAL"),
  "batch_size": int("$BATCH_SIZE"),
  "sleep_ms": int("$SLEEP_MS"),
  "updated_at": datetime.datetime.utcnow().isoformat() + "Z",
}
with open("$STATE_FILE", "w") as f:
  json.dump(state, f)
PY
}

write_state "running" "$START_OFFSET"
echo "Starting enrichment for $TOTAL providers (batch=$BATCH_SIZE) from offset $START_OFFSET" >> "$LOG"

cd "$ROOT/seed-data/etl"

for ((offset=START_OFFSET; offset<TOTAL; offset+=BATCH_SIZE)); do
  echo "Batch offset=$offset" >> "$LOG"
  write_state "running" "$offset"
  if dart run bin/enrich_taxonomy.dart \
    --env local \
    --max-companies "$BATCH_SIZE" \
    --offset "$offset" \
    --model "$OPENAI_MODEL" \
    --temperature "$TEMPERATURE" \
    --openai-batch-size "$OPENAI_BATCH_SIZE" \
    --openai-timeout-seconds "$OPENAI_TIMEOUT_SECONDS" \
    --openai-retries "$OPENAI_RETRIES" \
    --openai-retry-delay-ms "$OPENAI_RETRY_DELAY_MS" \
    --sleep-ms "$SLEEP_MS" >> "$LOG" 2>&1; then
    write_state "running" "$((offset + BATCH_SIZE))"
  else
    write_state "failed" "$offset"
    echo "Batch offset=$offset failed" >> "$LOG"
    exit 1
  fi
done

write_state "completed" "$TOTAL"
echo "Enrichment completed." >> "$LOG"
