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
SQL_OUT=/Users/slavisam/projects/som-app/seed-data/seed/taxonomy/enrichment_seed.sql

cat "$OUT_DIR"/gpt-4.1_companies_part_*.jsonl > "$OUT_DIR"/gpt-4.1_full.jsonl

dart run bin/generate_enrichment_sql.dart \
  "$OUT_DIR/gpt-4.1_full.jsonl" \
  --branches-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/branches.json \
  --categories-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/categories.json \
  --output "$SQL_OUT"
```

Optional: write directly as a migration (recommended for reproducible deploys)
```bash
cd /Users/slavisam/projects/som-app/seed-data/etl

dart run bin/generate_enrichment_sql.dart \
  "/Users/slavisam/projects/som-app/seed-data/out/enrichment_gpt41/gpt-4.1_full.jsonl" \
  --branches-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/branches.json \
  --categories-file /Users/slavisam/projects/som-app/seed-data/seed/taxonomy/categories.json \
  --migration
```

## 6) Apply SQL seed in production
```bash
cd /Users/slavisam/projects/som-app
# Apply in target environment using supabase/psql tooling
```
