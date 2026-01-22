# Enrichment Taxonomy Seed Data

This directory contains the full enrichment taxonomy seed data that was generated for existing company data.

## Files

| File | Description | Lines |
|------|-------------|-------|
| `enrichment_taxonomy_full.sql` | Complete seed including company_branches mappings | 118,176 |

## Structure

The full seed file contains:

1. **Branches** (lines 3-8330) - Industry branch reference data
   - ~500 unique branches with German/English names
   - Includes normalized names for search

2. **Categories** (lines 8331-24625) - Category reference data
   - Categories linked to branches
   - Normalized names for search

3. **Company-Branch Mappings** (lines 24626-118176) - **Requires existing companies**
   - Maps companies to their industry branches
   - Generated via OpenAI enrichment process
   - Contains confidence scores and status

## Usage

### Fresh Database (No Companies)

The migration `supabase/migrations/20260119214621_enrichment_taxonomy.sql` contains only:
- Branches (reference data)
- Categories (reference data)

This is safe to run on any database.

### Seeding Company Mappings

After importing company data, run the company_branches portion:

```bash
# Extract only company_branches INSERT statements
sed -n '24626,$p' enrichment_taxonomy_full.sql > company_branches_seed.sql

# Run against database (requires companies to exist first)
psql $DATABASE_URL -f company_branches_seed.sql
```

Or use the Supabase SQL Editor to run the company_branches portion manually.

## Regenerating Enrichment Data

The enrichment data was generated using OpenAI to classify companies into industry branches. To regenerate:

1. Export companies from database
2. Run enrichment pipeline (see `seed-data/etl/`)
3. Generate new seed SQL

## Notes

- Company-branch mappings reference `company_id` - companies must exist first
- The `ON CONFLICT DO NOTHING` clause allows safe re-runs
- Confidence scores range from 0.6 to 0.99 based on AI classification certainty
