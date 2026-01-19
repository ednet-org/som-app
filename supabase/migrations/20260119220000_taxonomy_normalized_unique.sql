-- Ensure normalized_name uniqueness for taxonomy terms.
CREATE UNIQUE INDEX IF NOT EXISTS branches_normalized_name_uq
  ON branches(normalized_name);

CREATE UNIQUE INDEX IF NOT EXISTS categories_branch_normalized_name_uq
  ON categories(branch_id, normalized_name);
