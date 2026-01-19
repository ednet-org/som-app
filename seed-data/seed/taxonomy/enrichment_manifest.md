# SOM taxonomy enrichment manifest

- Selected model: gpt-4.1 (best semantic coverage vs gpt-4o in PoC)
- PoC run: seed-data/out/poc/run_20260118_150306
- PoC report: seed-data/out/enrich_poc_report.md
- Company list (material providers):
  - JSON: seed-data/seed/taxonomy/enrichment_companies.json
  - CSV: seed-data/seed/taxonomy/enrichment_companies.csv

## Next steps

1) Run enrichment with gpt-4.1 for all companies in the JSON list.
2) Generate SQL seed from the output JSONL.
3) Apply seed in production (no OpenAI calls).
