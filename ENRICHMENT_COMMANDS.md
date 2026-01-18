# SOM taxonomy enrichment — command cheat sheet

All commands are copy‑paste safe and start with `cd /Users/slavisam/projects/som-app`.

## 0) Load .env into shell (required for OPENAI_API_KEY)
```bash
cd /Users/slavisam/projects/som-app
set -a; source /Users/slavisam/projects/som-app/.env; set +a
```

## 1) Start enrichment (full run)
```bash
cd /Users/slavisam/projects/som-app
START_OFFSET=0 BATCH_SIZE=200 SLEEP_MS=100 OPENAI_MODEL=gpt-5-nano TEMPERATURE=1 nohup seed-data/etl/scripts/run_enrich_taxonomy.sh >/dev/null 2>&1 &
```

## 2) Resume from current state offset
```bash
cd /Users/slavisam/projects/som-app
START_OFFSET=$(python3 - <<'PY'
import json
data=json.load(open("seed-data/out/enrich_state.json"))
print(data.get("offset",0))
PY
) BATCH_SIZE=200 SLEEP_MS=100 OPENAI_MODEL=gpt-5-nano TEMPERATURE=1 nohup seed-data/etl/scripts/run_enrich_taxonomy.sh >/dev/null 2>&1 &
```

## 3) Monitor every 5 minutes (auto‑restart if stopped)
```bash
cd /Users/slavisam/projects/som-app
CHECK_INTERVAL=300 nohup seed-data/etl/scripts/monitor_enrich_taxonomy.sh >/dev/null 2>&1 &
```

## 4) Stop enrichment + monitor
```bash
cd /Users/slavisam/projects/som-app
pkill -f enrich_taxonomy.dart || true
pkill -f monitor_enrich_taxonomy.sh || true
```

## 5) View status + logs
```bash
cd /Users/slavisam/projects/som-app
cat seed-data/out/enrich_state.json
```
```bash
cd /Users/slavisam/projects/som-app
tail -f seed-data/out/enrich_taxonomy.log
```
```bash
cd /Users/slavisam/projects/som-app
tail -f seed-data/out/enrich_monitor.log
```

## 6) Check running processes
```bash
cd /Users/slavisam/projects/som-app
pgrep -fl enrich_taxonomy.dart || true
pgrep -fl monitor_enrich_taxonomy.sh || true
```

## 7) Run a small test batch (foreground)
```bash
cd /Users/slavisam/projects/som-app
set -a; source /Users/slavisam/projects/som-app/.env; set +a
cd /Users/slavisam/projects/som-app/seed-data/etl
dart run bin/enrich_taxonomy.dart --env local --max-companies 5 --offset 0 --sleep-ms 0
```

## 8) Run multi‑model PoC (1000 samples/model, dry‑run)
```bash
cd /Users/slavisam/projects/som-app
SAMPLE_SIZE=1000 OFFSET=0 SLEEP_MS=0 PARALLELISM=1 OPENAI_BATCH_SIZE=100 seed-data/etl/scripts/run_enrich_poc.sh
```

## 9) Generate PoC report
```bash
cd /Users/slavisam/projects/som-app
python3 seed-data/etl/scripts/report_enrich_poc.py --sample-size 1000 --out seed-data/out/enrich_poc_report.md
```
