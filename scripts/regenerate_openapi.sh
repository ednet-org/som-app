#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v openapi-generator-cli >/dev/null 2>&1; then
  echo "openapi-generator-cli not found. Install with: npm i -g @openapitools/openapi-generator-cli" >&2
  exit 1
fi

echo "Generating OpenAPI spec..."
python3 "$repo_root/scripts/generate_openapi_spec.py"

echo "Regenerating Dart OpenAPI client..."
openapi-generator-cli generate \
  -i "$repo_root/openapi/openapi.json" \
  -g dart-dio \
  -o "$repo_root/openapi"

echo "Running build_runner for OpenAPI package..."
pushd "$repo_root/openapi" >/dev/null
dart run build_runner build
popd >/dev/null

echo "OpenAPI regeneration complete."
