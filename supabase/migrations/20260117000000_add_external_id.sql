-- Migration: Add external_id column for ETL traceability
-- This enables idempotent seeding by tracking original ETL IDs

-- Add external_id column to companies table
ALTER TABLE companies
ADD COLUMN IF NOT EXISTS external_id TEXT UNIQUE;

-- Create index for fast lookups during upsert
CREATE INDEX IF NOT EXISTS idx_companies_external_id
ON companies(external_id);

-- Add comment explaining the column purpose
COMMENT ON COLUMN companies.external_id IS 'Original ETL entity ID for traceability and idempotent seeding';

-- Update type column to support seeded companies
-- Existing values: 'registered' (user-created)
-- New value: 'seeded' (ETL import)
COMMENT ON COLUMN companies.type IS 'Company type: registered (user-created) or seeded (ETL import)';
