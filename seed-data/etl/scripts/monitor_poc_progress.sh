#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <main_run_dir> <gpt5_run_dir> [log_path]" >&2
  exit 1
fi

MAIN_DIR="$1"
GPT5_DIR="$2"
LOG="${3:-$GPT5_DIR/progress.log}"
INTERVAL="${INTERVAL:-60}"

shopt -s nullglob

while true; do
  {
    echo "==== $(date) ===="
    echo "main: $MAIN_DIR"
    files=("$MAIN_DIR"/*.jsonl)
    if [[ ${#files[@]} -eq 0 ]]; then
      echo "no jsonl files"
    else
      for f in "${files[@]}"; do
        printf "%s: " "$(basename "$f")"
        wc -l < "$f"
      done
    fi
    echo "gpt5: $GPT5_DIR"
    files=("$GPT5_DIR"/*.jsonl)
    if [[ ${#files[@]} -eq 0 ]]; then
      echo "no jsonl files"
    else
      for f in "${files[@]}"; do
        printf "%s: " "$(basename "$f")"
        wc -l < "$f"
      done
    fi
    echo
  } >> "$LOG"
  sleep "$INTERVAL"
done
