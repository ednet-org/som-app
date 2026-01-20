#!/usr/bin/env bash
set -euo pipefail

if [[ "${SOM_SKIP_HOSTS_CHECK:-false}" == "true" ]]; then
  exit 0
fi

HOSTS_FILE="/etc/hosts"
REQUIRED_HOSTS=(som.localhost tenant.localhost)
missing=()

for host in "${REQUIRED_HOSTS[@]}"; do
  if ! grep -Eq "\\b${host}\\b" "$HOSTS_FILE" 2>/dev/null; then
    missing+=("$host")
  fi
done

if [[ "${#missing[@]}" -eq 0 ]]; then
  if [[ "${SOM_PING_HOSTS:-true}" == "true" ]] && command -v ping >/dev/null 2>&1; then
    ping -c 1 som.localhost || true
  fi
  exit 0
fi

cat >&2 <<EOF
Missing /etc/hosts entries for: ${missing[*]}

Add them with:
  sudo sh -c 'printf "127.0.0.1 som.localhost tenant.localhost\\n" >> /etc/hosts'
  sudo dscacheutil -flushcache

Then verify:
  ping -c 1 som.localhost
EOF

if [[ "${SOM_REQUIRE_HOSTS:-false}" == "true" ]]; then
  exit 1
fi
