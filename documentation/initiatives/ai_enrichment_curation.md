# AI Enrichment Provenance + Curation (Providers)

Status: in-progress
Owner: Codex + team
Updated: 2026-01-19

## Goals
- Surface AI-originated taxonomy assignments (branch + categories) in the UI with clear provenance and confidence.
- Allow consultant/system admin to curate assignments end-to-end; after correction, the UI should no longer show AI provenance for that company.
- Provide a reproducible, migration-based seed for AI enrichment output (one-shot enrichment, no runtime OpenAI calls).

## Current State (codebase research)
- Taxonomy mapping tables exist in Supabase:
  - `company_branches` and `company_categories` include `source`, `confidence`, `status`, `created_at`, `updated_at`.
  - Files: `supabase/schema.sql`, migrations `20260118000000_add_taxonomy_mappings.sql` and `20260118001000_add_company_taxonomy_status.sql`.
- Provider list API uses `provider_profiles` for display, but filters by taxonomy when `branchId`/`categoryId` is passed:
  - `api/routes/providers/index.dart` uses `CompanyTaxonomyRepository.listCompanyIdsByBranch/category`.
  - UI reads `ProviderSummary.branchIds`/`pendingBranchIds` (from `provider_profiles`) and does not show taxonomy metadata.
- Taxonomy repository already used on approval/registration:
  - `api/routes/providers/[companyId]/approve.dart` calls `replaceCompanyBranches` with `source: 'approval'`.
  - `api/services/registration_service.dart` uses `source: 'registration'`.
- There is no API to view/update company taxonomy assignments with provenance.
- UI touchpoints:
  - `lib/ui/pages/providers/providers_app_body.dart` (consultant admin list + details)
  - `lib/ui/pages/inquiry/widgets/provider_selection_dialog.dart` (provider selection for inquiries)
  - `lib/ui/pages/branches/branches_app_body.dart` (branch/category management, no company taxonomy)

## Proposed Data/Contract Changes
### Data model (reuse existing columns)
- Use `source` and `confidence` to mark AI origin.
- Convention:
  - AI seeded rows: `source = 'openai'`, `confidence = <0..1>`, `status = 'pending'`.
  - Manual curation: `source = 'manual'`, `confidence = NULL`, `status = 'active'`.
  - Approvals/registration retain existing sources (`approval`, `registration`).

### API additions
- New endpoint for taxonomy per company (consultant/admin only):
  - `GET /providers/{companyId}/taxonomy`
  - `PUT /providers/{companyId}/taxonomy`
- Extend ProviderSummary (list endpoints) with taxonomy assignments:
  - `branchAssignments`: list of {branchId, branchName, source, confidence, status}
  - `categoryAssignments`: list of {categoryId, categoryName, branchId, branchName, source, confidence, status}

### API behavior
- `GET /providers/{companyId}/taxonomy` returns assignments from `company_branches` and `company_categories` joined to branch/category names.
- `PUT /providers/{companyId}/taxonomy` replaces assignments for the company:
  - Deletes existing mappings for that company.
  - Inserts curated branch/categories with `source = 'manual'`, `status = 'active'`, `confidence = NULL`.
  - This removes AI provenance for the company because the AI rows are removed.

## UI/UX changes
### Providers page (consultant admin)
- Add a "Classification" section:
  - Display branch assignments (name + AI badge + confidence).
  - Display category assignments grouped under branch.
  - AI badge shown only when `source == 'openai'` (or source in AI sources set) AND assignment present.
  - Confidence displayed as percentage (e.g., 72%) when available.
- Add "Edit classification" action:
  - Branch multi-select chips.
  - Category multi-select filtered to selected branches.
  - Save calls `PUT /providers/{companyId}/taxonomy`.
  - After save, AI badge disappears because source becomes `manual`.

### Provider selection dialog (inquiries)
- Use taxonomy assignments to display branch/category labels and AI badge where relevant.
- Keep filter behavior consistent with taxonomy (already uses taxonomy for `branchId`/`categoryId`).

## Migration/Seeding
- Deterministic merge of existing enrichment outputs (one row per company):
  - Read all `seed-data/out/enrichment_gpt41/*.jsonl` (exclude merged/full files).
  - For each companyId, select best record by score:
    - primary: `avgCategoryConfidence` (desc)
    - secondary: `branchConfidence` (desc)
    - tertiary: `newCategoryCount` (desc)
    - tie-breaker: `createdAt` (desc), then companyId
  - Output stable JSONL sorted by companyId: `seed-data/out/enrichment_gpt41_merged.jsonl`.
- Generate migration SQL from merged JSONL:
  - `dart run seed-data/etl/bin/generate_enrichment_sql.dart ... --migration`
  - Produces `supabase/migrations/<timestamp>_enrichment_taxonomy.sql`.
- Apply migrations locally with Supabase CLI (db reset or migration up).

## TDD Plan (API + UI)
- API tests:
  - `GET /providers` includes taxonomy assignments in payload.
  - `PUT /providers/{companyId}/taxonomy` replaces assignments and returns updated view.
- UI tests (lightweight):
  - Provider details renders AI badge when source is `openai`.
  - After simulated save (manual source), AI badge not shown.

## Implementation Checklist
- [x] Add new API models + repository methods for taxonomy assignments.
- [x] Add new API routes for taxonomy CRUD.
- [x] Update ProviderSummary JSON to include assignments.
- [x] Update OpenAPI spec, regenerate client.
- [x] Update Flutter UI (providers + selection dialog).
- [x] Add deterministic merge script + migration generation.
- [x] Apply migration and validate local DB.

## Progress Notes
- API: taxonomy list + update endpoints added; ProviderSummary now includes branch/category assignments with provenance.
- UI: providers page shows classification section with AI badges + confidence; edit dialog replaces assignments as manual.
- UI: provider selection dialog shows classification labels and AI badge summary.
- Tests: API tests passed (`api/test/provider_taxonomy_test.dart`, `api/test/providers_pagination_test.dart`); provider selection dialog AI badge test passed (`test/provider_selection_dialog_test.dart`). Provider details UI test still pending.
- Seed/migrations: merged enrichment outputs, generated migration, seeded local DB with `--skip-taxonomy` (batch size 100), applied enrichment migration with `--include-existing`.
- Seeder logging: BatchUpsertResult now prints sample errors to surface failed batches on future runs.

## Notes / Open Questions
- Do we treat all AI rows as `pending`, or can some be `active`? Current plan: `pending`.
- Do we ever keep AI rows after manual curation? Current plan: no; replace with manual rows.
- If desired, add a small audit trail later (curated_by, curated_at).
