-- Add status columns to company taxonomy mappings for pending approvals
ALTER TABLE company_branches
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';

ALTER TABLE company_categories
  ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';

CREATE INDEX IF NOT EXISTS idx_company_branches_status
  ON company_branches(status);

CREATE INDEX IF NOT EXISTS idx_company_categories_status
  ON company_categories(status);

CREATE INDEX IF NOT EXISTS idx_company_branches_branch_status
  ON company_branches(branch_id, status);

CREATE INDEX IF NOT EXISTS idx_company_categories_category_status
  ON company_categories(category_id, status);
