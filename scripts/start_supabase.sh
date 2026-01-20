#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
SUPABASE_PROJECT_ID="${SUPABASE_PROJECT_ID:-}"
export SUPABASE_PROJECT_ID

ensure_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker CLI not found. Install Rancher Desktop or another Docker-compatible engine, then retry." >&2
    exit 1
  fi

  if docker info >/dev/null 2>&1; then
    return 0
  fi

  if docker context ls --format '{{.Name}}' 2>/dev/null | grep -q '^rancher-desktop$'; then
    docker context use rancher-desktop >/dev/null 2>&1 || true
    if docker info >/dev/null 2>&1; then
      return 0
    fi
  fi
  if docker context ls --format '{{.Name}}' 2>/dev/null | grep -q '^desktop-linux$'; then
    docker context use desktop-linux >/dev/null 2>&1 || true
    if docker info >/dev/null 2>&1; then
      return 0
    fi
  fi

  local rdctl_bin=""
  if command -v rdctl >/dev/null 2>&1; then
    rdctl_bin="$(command -v rdctl)"
  elif [[ -x "/Applications/Rancher Desktop.app/Contents/Resources/resources/darwin/bin/rdctl" ]]; then
    rdctl_bin="/Applications/Rancher Desktop.app/Contents/Resources/resources/darwin/bin/rdctl"
  fi

  if [[ -n "$rdctl_bin" ]]; then
    echo "Docker not running. Starting Rancher Desktop..."
    open -a "Rancher Desktop" >/dev/null 2>&1 || true
    "$rdctl_bin" start --no-modal-dialogs >/dev/null 2>&1 || true
  fi

  for _ in {1..20}; do
    if docker info >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.5
  done

  if ! docker info >/dev/null 2>&1; then
    local context=""
    context="$(docker context show 2>/dev/null || true)"
    echo "Docker daemon not reachable." >&2
    if [[ -n "$context" ]]; then
      echo "Current Docker context: $context" >&2
    fi
    echo "Start Rancher Desktop (moby engine) or another Docker daemon, then retry." >&2
    exit 1
  fi
}

apply_migrations() {
  if [[ "${SUPABASE_APPLY_MIGRATIONS:-true}" != "true" ]]; then
    return 0
  fi

  echo "Applying Supabase migrations..." >&2
  supabase_migration_up >&2
}

apply_storage_rls() {
  if [[ "${SUPABASE_APPLY_STORAGE_RLS:-true}" != "true" ]]; then
    return 0
  fi

  bash "$ROOT/scripts/apply_storage_rls.sh"
}

supabase_start() {
  if [[ -n "$SUPABASE_PROJECT_ID" ]]; then
    supabase start --project-id "$SUPABASE_PROJECT_ID" --exclude vector "$@"
  else
    supabase start --exclude vector "$@"
  fi
}

supabase_migration_up() {
  if [[ -n "$SUPABASE_PROJECT_ID" ]]; then
    supabase migration up --project-id "$SUPABASE_PROJECT_ID"
  else
    supabase migration up
  fi
}

ensure_docker
supabase_start "$@"
apply_migrations
apply_storage_rls
