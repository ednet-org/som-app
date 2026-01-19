-- Ensure category external_id uniqueness supports ON CONFLICT upserts
DROP INDEX IF EXISTS idx_categories_branch_external_id;

CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_branch_external_id
  ON categories(branch_id, external_id);
