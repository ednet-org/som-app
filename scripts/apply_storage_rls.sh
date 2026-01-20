#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SQL_FILE="$ROOT/supabase/privileged/storage_rls.sql"
if [[ ! -f "$SQL_FILE" ]]; then
  echo "Storage RLS SQL not found at $SQL_FILE" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker CLI not found. Cannot apply privileged storage RLS." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon not reachable. Cannot apply privileged storage RLS." >&2
  exit 1
fi

container=""
if [[ -n "${SUPABASE_DB_CONTAINER:-}" ]]; then
  container="$SUPABASE_DB_CONTAINER"
elif [[ -n "${SUPABASE_PROJECT_ID:-}" ]]; then
  container="supabase_db_${SUPABASE_PROJECT_ID}"
else
  if command -v rg >/dev/null 2>&1; then
    container="$(docker ps --format '{{.Names}}' | rg '^supabase_db_' | head -n 1 || true)"
  else
    container="$(docker ps --format '{{.Names}}' | grep -E '^supabase_db_' | head -n 1 || true)"
  fi
fi

if [[ -z "$container" ]]; then
  message="Supabase DB container not found. Set SUPABASE_PROJECT_ID or SUPABASE_DB_CONTAINER."
  if [[ "${SUPABASE_APPLY_STORAGE_RLS_STRICT:-false}" == "true" ]]; then
    echo "$message" >&2
    exit 1
  fi
  echo "$message Skipping." >&2
  exit 0
fi

echo "Applying privileged storage RLS via $container..." >&2
attempts=5
for attempt in $(seq 1 "$attempts"); do
  if docker exec -i "$container" psql -U postgres -d postgres -v ON_ERROR_STOP=1 < "$SQL_FILE"; then
    exit 0
  fi
  if [[ "$attempt" -lt "$attempts" ]]; then
    sleep 1
  fi
done

if [[ "${SUPABASE_APPLY_STORAGE_RLS_STRICT:-false}" == "true" ]]; then
  echo "Failed to apply storage RLS after $attempts attempts." >&2
  exit 1
fi
echo "Failed to apply storage RLS after $attempts attempts (non-strict). Continuing." >&2
exit 0
