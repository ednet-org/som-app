# SOM taxonomy enrichment commands (offline + reproducible)

## 1) Export companies to enrich (material providers, one-time)
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl
set -a && source /Users/slavisam/projects/som-app/.env && set +a

dart run bin/export_enrichment_companies.dart \
  local \
  ../seed/taxonomy/enrichment_companies.json \
  ../seed/taxonomy/enrichment_companies.csv
```

## 2) Taxonomy reference data (branches + categories)
Already in repo as:
- `seed-data/seed/taxonomy/branches.json`
- `seed-data/seed/taxonomy/categories.json`

## 3) Partition companies into 10 files
```bash
cd /Users/slavisam/projects/som-app
python3 - <<'PY'
import json, math
from pathlib import Path
src = Path('seed-data/seed/taxonomy/enrichment_companies.json')
out_dir = Path('seed-data/seed/taxonomy/partitions')
out_dir.mkdir(parents=True, exist_ok=True)
rows = json.loads(src.read_text())
ids = []
for r in rows:
    if isinstance(r, str):
        cid = r.strip()
    elif isinstance(r, dict):
        cid = str(r.get('companyId', '')).strip()
    else:
        cid = ''
    if cid:
        ids.append(cid)
parts = 10
size = math.ceil(len(ids) / parts)
for i in range(parts):
    chunk = ids[i*size:(i+1)*size]
    if not chunk:
        break
    out = out_dir / f'companies_part_{i+1:02d}.json'
    out.write_text(json.dumps(chunk, indent=2))
    print(out, len(chunk))
PY
```

## 4) Run enrichment in 10 parallel jobs (gpt-4.1, offline)
```bash
cd /Users/slavisam/projects/som-app
set -a && source /Users/slavisam/projects/som-app/.env && set +a

OUT_DIR=/Users/slavisam/projects/som-app/seed-data/out/enrichment_gpt41
mkdir -p "$OUT_DIR"
: > "$OUT_DIR/pids.txt"

for part in /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/partitions/companies_part_*.json; do
  name=$(basename "$part" .json)
  out="$OUT_DIR/gpt-4.1_${name}.jsonl"
  log="$OUT_DIR/gpt-4.1_${name}.log"
  : > "$out"
  echo "=== $name ===" | tee "$log"
  nohup bash -lc "cd /Users/slavisam/projects/som-app/seed-data/etl && dart run bin/enrich_taxonomy.dart \
    --env local \
    --model gpt-4.1 \
    --temperature 0.0 \
    --companies-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/enrichment_companies.json \
    --company-ids-file '$part' \
    --branches-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/branches.json \
    --categories-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/categories.json \
    --skip-mappings \
    --max-companies 999999 \
    --openai-batch-size 1000 \
    --openai-timeout-seconds 60 \
    --openai-retries 2 \
    --openai-retry-delay-ms 2000 \
    --output '$out' \
    --fail-on-unsupported" >> "$log" 2>&1 &
  echo $! >> "$OUT_DIR/pids.txt"
  disown
  sleep 0.2
done
```

Optional: omit branch list (smaller payload, free-form branches)
```
  --omit-branches
```

## 5) Merge outputs + generate SQL seed
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl
set -a && source /Users/slavisam/projects/som-app/.env && set +a

OUT_DIR=/Users/slavisam/projects/som-app/seed-data/out/enrichment_gpt41
MERGED_OUT="$OUT_DIR/enrichment_gpt41_merged.jsonl"
SQL_OUT=/Users/slavisam/projects/som-app/seed-data/seed/taxonomy/enrichment_seed.sql

dart run bin/merge_enrichment_jsonl.dart \
  --input-dir "$OUT_DIR" \
  --output "$MERGED_OUT"

## 5a) Optional: one-time taxonomy cleanup (branches + categories)
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl

# Export current taxonomy (from local DB with enrichment applied)
dart run bin/export_taxonomy_data.dart \
  local \
  ../out/taxonomy/branches.json \
  ../out/taxonomy/categories.json

# Run LLM-assisted cleanup
dart run bin/cleanup_taxonomy.dart \
  --branches-file ../out/taxonomy/branches.json \
  --categories-file ../out/taxonomy/categories.json \
  --input-jsonl "$MERGED_OUT"

# Use cleaned outputs for migration generation
MERGED_OUT="$OUT_DIR/enrichment_gpt41_merged_clean.jsonl"
```

dart run bin/generate_enrichment_sql.dart \
  "$MERGED_OUT" \
  --branches-file /Users/slavisam/projects/som-app/seed-data/out/taxonomy/branches_clean.json \
  --categories-file /Users/slavisam/projects/som-app/seed-data/out/taxonomy/categories_clean.json \
  --output "$SQL_OUT"
```

If you skip cleanup, use the original seed files instead:
```
  --branches-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/branches.json \
  --categories-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/categories.json \
```

Optional: write directly as a migration (recommended for reproducible deploys)
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl

dart run bin/generate_enrichment_sql.dart \
  "/Users/slavisam/projects/som-app/seed-data/out/enrichment_gpt41/enrichment_gpt41_merged.jsonl" \
  --branches-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/branches.json \
  --categories-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/categories.json \
  --include-existing \
  --migration
```

## 6) Apply migration locally (requires companies)
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl
dart run bin/seed_database.dart --env local --batch-size 100 --skip-taxonomy

cd /Users/slavisam/projects/som-app
supabase migration up
```

## 6a) Optional: dump curated taxonomy data (after migration)
```bash
cd /Users/slavisam/projects/som-app
# Set DB_URL from `supabase status --output json`
export DB_URL="postgresql://postgres:postgres@127.0.0.1:<port>/postgres"

pg_dump "$DB_URL" \
  --data-only \
  --column-inserts \
  --table branches \
  --table categories \
  --table company_branches \
  --table company_categories \
  > supabase/seed/curated_taxonomy.sql
```

## 7) Apply SQL seed in production
```bash
cd /Users/slavisam/projects/som-app
# Apply in target environment using supabase/psql tooling
```
