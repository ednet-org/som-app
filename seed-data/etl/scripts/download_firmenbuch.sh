#!/bin/bash
# Download Firmenbuch HVD (High Value Dataset) from data.gv.at
# Note: The actual download URL may change - check data.gv.at for current links

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ETL_DIR="$(dirname "$SCRIPT_DIR")"
RAW_DIR="$ETL_DIR/raw"

# Create directories
mkdir -p "$RAW_DIR"

# Configuration
FIRMENBUCH_CATALOG_URL="https://data.gv.at/katalog/dataset/justiz-gv-at-firmenbuch"
FIRMENBUCH_JSON="$RAW_DIR/firmenbuch.json"

echo "=== Firmenbuch HVD Download Script ==="
echo ""
echo "IMPORTANT: The Firmenbuch High Value Dataset requires checking the"
echo "current download URLs on data.gv.at as they may change."
echo ""
echo "Catalog page: $FIRMENBUCH_CATALOG_URL"
echo ""

# Check if jq is available for parsing
if ! command -v jq &> /dev/null; then
    echo "Note: Install jq for automatic parsing (brew install jq)"
fi

# Try to fetch catalog metadata
echo "Fetching catalog metadata..."
CATALOG_JSON=$(curl -sL "https://data.gv.at/katalog/api/3/action/package_show?id=justiz-gv-at-firmenbuch" 2>/dev/null || true)

if [ -n "$CATALOG_JSON" ] && command -v jq &> /dev/null; then
    echo "Parsing available resources..."
    echo ""
    echo "Available downloads:"
    echo "$CATALOG_JSON" | jq -r '.result.resources[] | "  - \(.name): \(.url)"' 2>/dev/null || echo "  (Unable to parse)"
    echo ""

    # Try to find JSON resource
    JSON_URL=$(echo "$CATALOG_JSON" | jq -r '.result.resources[] | select(.format | ascii_downcase | contains("json")) | .url' 2>/dev/null | head -1 || true)

    if [ -n "$JSON_URL" ] && [ "$JSON_URL" != "null" ]; then
        echo "Found JSON resource: $JSON_URL"
        echo ""
        read -p "Download this file? [y/N] " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Downloading..."
            curl -L -o "$FIRMENBUCH_JSON" "$JSON_URL"
            echo "Downloaded: $FIRMENBUCH_JSON"

            # Print sample
            if command -v jq &> /dev/null; then
                echo ""
                echo "Sample record:"
                jq '.[0] // .data[0] // .records[0] // "Unable to parse structure"' "$FIRMENBUCH_JSON" 2>/dev/null | head -20
            fi
        fi
    else
        echo "No JSON resource found automatically."
        echo "Please check the catalog page and download manually:"
        echo "  $FIRMENBUCH_CATALOG_URL"
    fi
else
    echo "Unable to fetch catalog automatically."
    echo ""
    echo "Please visit the catalog page to find the download link:"
    echo "  $FIRMENBUCH_CATALOG_URL"
    echo ""
    echo "Once downloaded, place the file at:"
    echo "  $FIRMENBUCH_JSON"
fi

echo ""
echo "=== Manual Download Instructions ==="
echo ""
echo "1. Visit: $FIRMENBUCH_CATALOG_URL"
echo "2. Look for HVD (High Value Dataset) export"
echo "3. Download JSON or XML format"
echo "4. Save to: $RAW_DIR/"
echo ""
echo "Then run the ETL pipeline:"
echo "  dart run bin/run_pipeline.dart -f $FIRMENBUCH_JSON"
echo ""
echo "Or for XML:"
echo "  dart run bin/run_pipeline.dart --firmenbuch-xml $RAW_DIR/firmenbuch.xml"
