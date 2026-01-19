#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ensure_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker CLI not found. Install Rancher Desktop or another Docker-compatible engine, then retry." >&2
    exit 1
  fi

  if docker info >/dev/null 2>&1; then
    return 0
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

ensure_docker
supabase start --exclude vector "$@"
