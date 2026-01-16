#!/usr/bin/env bash
set -euo pipefail

echo "Stopping SOM services..."

# Stop Flutter
if pkill -f "flutter.*run" 2>/dev/null; then
  echo "  Stopped Flutter"
else
  echo "  Flutter not running"
fi

# Stop API
if pkill -f "dart.*server.dart" 2>/dev/null; then
  echo "  Stopped API"
else
  echo "  API not running"
fi

# Optionally stop Supabase (pass --supabase flag)
if [[ "${1:-}" == "--supabase" ]]; then
  echo "  Stopping Supabase..."
  supabase stop 2>/dev/null || true
  echo "  Stopped Supabase"
fi

echo "Done."
