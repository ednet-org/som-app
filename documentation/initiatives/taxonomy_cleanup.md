# Taxonomy Cleanup (Branches + Categories)

Status: in-progress
Owner: Codex + team
Updated: 2026-01-19

## Goal
One-time cleanup of taxonomy terms (branches + categories) to remove semantic duplicates,
normalize IDs, and preserve all company relationships. The cleaned dataset becomes the
source of truth for initial seeding and the enrichment migration.

## Scope
- Branches + categories only.
- Preserve all company relationships by remapping foreign keys.
- Use local LLM for semantic duplicate detection (Ollama `qwen2.5:14b`).
- Produce cleaned enrichment JSONL + updated branch/category datasets.

## Normalization Strategy
- Use `normalizeTaxonomyName` (diacritics folded, punctuation removed, `und` -> `and`).
- For name-based branches, external_id becomes the normalized name (no `name:` prefix).
- For name-based categories, external_id becomes `name:<branchExternalId>:<normalizedCategory>`.
- Base taxonomy entries (status `active`) keep their IDs; pending entries are recomputed.

## One-Time Cleanup Pipeline
1) Export current taxonomy from local DB:
   - `dart run seed-data/etl/bin/export_taxonomy_data.dart local ../out/taxonomy/branches.json ../out/taxonomy/categories.json`
2) Run cleanup (LLM-assisted):
   - `dart run seed-data/etl/bin/cleanup_taxonomy.dart --branches-file ../out/taxonomy/branches.json --categories-file ../out/taxonomy/categories.json --input-jsonl ../out/enrichment_gpt41_merged.jsonl`
   - Outputs:
     - `seed-data/out/taxonomy/branches_clean.json`
     - `seed-data/out/taxonomy/categories_clean.json`
     - `seed-data/out/enrichment_gpt41_merged_clean.jsonl`
     - `seed-data/out/taxonomy/merge_plan.json`
3) Regenerate enrichment migration with cleaned data:
   - `dart run seed-data/etl/bin/generate_enrichment_sql.dart ../out/enrichment_gpt41_merged_clean.jsonl --branches-file ../out/taxonomy/branches_clean.json --categories-file ../out/taxonomy/categories_clean.json --migration --include-existing`
4) Reinitialize local DB (companies/providers first, taxonomy later):
   - `supabase db reset --version 20260118002000 --no-seed`
   - `cd seed-data/etl && dart run bin/seed_database.dart --env local --batch-size 100`
   - `psql "$DB_URL" -c "TRUNCATE TABLE company_categories, company_branches, categories, branches RESTART IDENTITY CASCADE;"`
   - `supabase migration up`

## Notes
- Added migration `20260118002000_fix_categories_external_id_unique.sql` to make
  `ON CONFLICT (branch_id, external_id)` valid for category upserts.
- `merge_plan.json` contains old->new ID mappings for branches and categories.
- AI provenance remains in `company_branches` and `company_categories` via `source=openai`.
- After cleanup, add unique indexes on `branches.normalized_name` and `categories(branch_id, normalized_name)`.
