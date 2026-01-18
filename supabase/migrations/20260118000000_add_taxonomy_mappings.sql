-- Add taxonomy metadata to branches and categories
ALTER TABLE branches
  ADD COLUMN IF NOT EXISTS external_id TEXT UNIQUE,
  ADD COLUMN IF NOT EXISTS normalized_name TEXT,
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';

ALTER TABLE categories
  ADD COLUMN IF NOT EXISTS external_id TEXT,
  ADD COLUMN IF NOT EXISTS normalized_name TEXT,
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';

UPDATE branches
SET normalized_name = lower(regexp_replace(trim(name), '[\s,]+', ' ', 'g'))
WHERE normalized_name IS NULL;

UPDATE categories
SET normalized_name = lower(regexp_replace(trim(name), '[\s,]+', ' ', 'g'))
WHERE normalized_name IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_branches_normalized_name
  ON branches(normalized_name);

CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_branch_normalized
  ON categories(branch_id, normalized_name);

CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_branch_external_id
  ON categories(branch_id, external_id)
  WHERE external_id IS NOT NULL;

-- Map companies to taxonomy
CREATE TABLE IF NOT EXISTS company_branches (
  company_id uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  branch_id uuid NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  source TEXT NOT NULL,
  confidence NUMERIC,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  PRIMARY KEY (company_id, branch_id)
);

CREATE TABLE IF NOT EXISTS company_categories (
  company_id uuid NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  source TEXT NOT NULL,
  confidence NUMERIC,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,
  PRIMARY KEY (company_id, category_id)
);

CREATE INDEX IF NOT EXISTS idx_company_branches_branch
  ON company_branches(branch_id);

CREATE INDEX IF NOT EXISTS idx_company_categories_category
  ON company_categories(category_id);

CREATE INDEX IF NOT EXISTS idx_company_branches_company
  ON company_branches(company_id);

CREATE INDEX IF NOT EXISTS idx_company_categories_company
  ON company_categories(company_id);
