-- Staging User Sync
-- This seed syncs existing Supabase Auth users to som.users and som.user_company_roles
-- Run AFTER auth users have been created via Supabase Admin API

-- ============================================================================
-- SYNC AUTH USERS TO SOM.USERS
-- ============================================================================
-- This creates som.users records for auth users that don't have one yet

-- Provider Admin (provider-admin@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '22222222-2222-2222-2222-222222222222', -- Provider Company
  au.email,
  'Provider', 'Admin', 'Herr', NULL, '+43 316 123 456',
  '["provider", "admin"]', true, true, 'provider', '22222222-2222-2222-2222-222222222222',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'provider-admin@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Provider Employee (provider-employee@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '22222222-2222-2222-2222-222222222222', -- Provider Company
  au.email,
  'Provider', 'Employee', 'Frau', NULL, '+43 316 123 457',
  '["provider"]', true, true, 'provider', '22222222-2222-2222-2222-222222222222',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'provider-employee@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Buyer Admin (buyer-admin@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '11111111-1111-1111-1111-111111111111', -- Buyer Company
  au.email,
  'Buyer', 'Admin', 'Herr', NULL, '+43 1 234 5678',
  '["buyer", "admin"]', true, true, 'buyer', '11111111-1111-1111-1111-111111111111',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'buyer-admin@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Buyer Employee (buyer-employee@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '11111111-1111-1111-1111-111111111111', -- Buyer Company
  au.email,
  'Buyer', 'Employee', 'Frau', NULL, '+43 1 234 5679',
  '["buyer"]', true, true, 'buyer', '11111111-1111-1111-1111-111111111111',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'buyer-employee@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Hybrid Admin (hybrid-admin@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '33333333-3333-3333-3333-333333333333', -- Hybrid Company
  au.email,
  'Hybrid', 'Admin', 'Herr', 'Dr.', '+43 732 987 654',
  '["buyer", "provider", "admin"]', true, true, 'buyer', '33333333-3333-3333-3333-333333333333',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'hybrid-admin@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Consultant (consultant@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '00000000-0000-0000-0000-000000000001', -- Platform Company
  au.email,
  'Consultant', 'User', 'Mx', NULL, '+43 1 999 0001',
  '["consultant"]', true, true, 'consultant', '00000000-0000-0000-0000-000000000001',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'consultant@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- Sysadmin (sysadmin@test.som-staging.at)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
)
SELECT
  au.id,
  '00000000-0000-0000-0000-000000000001', -- Platform Company
  au.email,
  'System', 'Admin', 'Mx', NULL, '+43 1 999 0002',
  '["consultant", "admin"]', true, true, 'consultant', '00000000-0000-0000-0000-000000000001',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'sysadmin@test.som-staging.at'
  AND NOT EXISTS (SELECT 1 FROM som.users su WHERE su.id = au.id)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- SYNC USER COMPANY ROLES
-- ============================================================================
-- Create user_company_roles entries for all users

-- Provider Admin
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '22222222-2222-2222-2222-222222222222',
  '["provider", "admin"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'provider-admin@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Provider Employee
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '22222222-2222-2222-2222-222222222222',
  '["provider"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'provider-employee@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Buyer Admin
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '11111111-1111-1111-1111-111111111111',
  '["buyer", "admin"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'buyer-admin@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Buyer Employee
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '11111111-1111-1111-1111-111111111111',
  '["buyer"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'buyer-employee@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Hybrid Admin
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '33333333-3333-3333-3333-333333333333',
  '["buyer", "provider", "admin"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'hybrid-admin@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Consultant
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '00000000-0000-0000-0000-000000000001',
  '["consultant"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'consultant@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- Sysadmin
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
SELECT
  au.id,
  '00000000-0000-0000-0000-000000000001',
  '["consultant", "admin"]',
  NOW(), NOW()
FROM auth.users au
WHERE au.email = 'sysadmin@test.som-staging.at'
ON CONFLICT (user_id, company_id) DO NOTHING;

-- ============================================================================
-- VERIFICATION QUERY
-- ============================================================================
-- Run this to verify the sync worked:
-- SELECT u.email, u.roles_json, ucr.roles_json as company_roles
-- FROM som.users u
-- LEFT JOIN som.user_company_roles ucr ON u.id = ucr.user_id
-- WHERE u.email LIKE '%@test.som-staging.at';
