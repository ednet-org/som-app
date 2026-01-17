#!/bin/bash
# Download and process OSM Austria data
# Requires: osmium-tool (brew install osmium-tool)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ETL_DIR="$(dirname "$SCRIPT_DIR")"
RAW_DIR="$ETL_DIR/raw"

# Create directories
mkdir -p "$RAW_DIR"

# Configuration
OSM_URL="https://download.geofabrik.de/europe/austria-latest.osm.pbf"
OSM_PBF="$RAW_DIR/austria-latest.osm.pbf"
OSM_FILTERED="$RAW_DIR/austria-business-pois.osm.pbf"
OSM_GEOJSON="$RAW_DIR/austria-business-pois.geojson"

echo "=== OSM Austria Download Script ==="
echo ""

# Check for osmium
if ! command -v osmium &> /dev/null; then
    echo "ERROR: osmium-tool not found"
    echo "Install with: brew install osmium-tool"
    exit 1
fi

# Download PBF if not exists or older than 1 day
if [ ! -f "$OSM_PBF" ] || [ $(find "$OSM_PBF" -mtime +1 2>/dev/null) ]; then
    echo "Downloading OSM Austria PBF..."
    curl -L -o "$OSM_PBF" "$OSM_URL"
    echo "Download complete: $OSM_PBF"
else
    echo "Using existing PBF file: $OSM_PBF"
fi

# Filter for business POIs
echo ""
echo "Filtering for business POIs..."
echo "This may take several minutes..."

osmium tags-filter "$OSM_PBF" \
    nwr/shop \
    nwr/amenity=restaurant,cafe,bar,fast_food,bank,doctors,dentist,veterinary,fuel,pharmacy \
    nwr/office \
    nwr/craft \
    nwr/tourism=hotel,guest_house,hostel,camp_site \
    nwr/industrial \
    nwr/man_made=works \
    -o "$OSM_FILTERED" \
    --overwrite

echo "Filtered: $OSM_FILTERED"

# Export to GeoJSON
echo ""
echo "Exporting to GeoJSON..."

osmium export "$OSM_FILTERED" \
    -o "$OSM_GEOJSON" \
    --overwrite \
    -f geojson \
    --add-unique-id=type_id

echo "Exported: $OSM_GEOJSON"

# Print statistics
echo ""
echo "=== Statistics ==="
FEATURE_COUNT=$(grep -c '"type":"Feature"' "$OSM_GEOJSON" || echo "0")
echo "Total features: $FEATURE_COUNT"

FILE_SIZE=$(du -h "$OSM_GEOJSON" | cut -f1)
echo "GeoJSON size: $FILE_SIZE"

echo ""
echo "Done! Use this file with the ETL pipeline:"
echo "  dart run bin/run_pipeline.dart -o $OSM_GEOJSON"
