-- Staging Test Users Seed
-- This seed creates test companies and users for staging environment
-- NOTE: Auth users must be created separately via Supabase Admin API

-- Test Company IDs (UUIDv4)
-- Buyer Company: 11111111-1111-1111-1111-111111111111
-- Provider Company: 22222222-2222-2222-2222-222222222222
-- Both Company: 33333333-3333-3333-3333-333333333333

-- Test User IDs (must match Supabase Auth user IDs created via API)
-- These will be set when creating auth users

-- ============================================================================
-- COMPANIES
-- ============================================================================

-- Buyer Company
INSERT INTO som.companies (
  id, name, type, address_json, uid_nr, registration_nr, company_size,
  website_url, terms_accepted_at, privacy_accepted_at, status, created_at, updated_at
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Test Buyer GmbH',
  'buyer',
  '{"street": "Käuferstraße 1", "city": "Wien", "zip": "1010", "country": "AT"}',
  'ATU12345678',
  'FN 123456a',
  'medium',
  'https://test-buyer.example.com',
  NOW(), NOW(), 'active', NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- Provider Company
INSERT INTO som.companies (
  id, name, type, address_json, uid_nr, registration_nr, company_size,
  website_url, terms_accepted_at, privacy_accepted_at, status, created_at, updated_at
) VALUES (
  '22222222-2222-2222-2222-222222222222',
  'Test Provider AG',
  'provider',
  '{"street": "Anbieterweg 2", "city": "Graz", "zip": "8010", "country": "AT"}',
  'ATU87654321',
  'FN 654321b',
  'large',
  'https://test-provider.example.com',
  NOW(), NOW(), 'active', NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- Both (Buyer + Provider) Company
INSERT INTO som.companies (
  id, name, type, address_json, uid_nr, registration_nr, company_size,
  website_url, terms_accepted_at, privacy_accepted_at, status, created_at, updated_at
) VALUES (
  '33333333-3333-3333-3333-333333333333',
  'Test Hybrid KG',
  'buyer_provider',
  '{"street": "Hybridplatz 3", "city": "Linz", "zip": "4020", "country": "AT"}',
  'ATU11223344',
  'FN 112233c',
  'small',
  'https://test-hybrid.example.com',
  NOW(), NOW(), 'active', NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- PROVIDER PROFILES (for provider and both companies)
-- ============================================================================

-- Provider Company Profile
INSERT INTO som.provider_profiles (
  company_id, bank_details_json, branches_json, pending_branches_json,
  subscription_plan_id, payment_interval, provider_type, status,
  created_at, updated_at
) VALUES (
  '22222222-2222-2222-2222-222222222222',
  '{"iban": "AT123456789012345678", "bic": "TESTBICXXX", "accountOwner": "Test Provider AG"}',
  '[]', '[]',
  '', 'yearly', 'manufacturer', 'active',
  NOW(), NOW()
) ON CONFLICT (company_id) DO NOTHING;

-- Both Company Provider Profile
INSERT INTO som.provider_profiles (
  company_id, bank_details_json, branches_json, pending_branches_json,
  subscription_plan_id, payment_interval, provider_type, status,
  created_at, updated_at
) VALUES (
  '33333333-3333-3333-3333-333333333333',
  '{"iban": "AT987654321098765432", "bic": "HYBRIDBICX", "accountOwner": "Test Hybrid KG"}',
  '[]', '[]',
  '', 'monthly', 'trader', 'active',
  NOW(), NOW()
) ON CONFLICT (company_id) DO NOTHING;

-- ============================================================================
-- PLATFORM COMPANY (for consultants/sysadmins)
-- ============================================================================

INSERT INTO som.companies (
  id, name, type, address_json, uid_nr, registration_nr, company_size,
  website_url, terms_accepted_at, privacy_accepted_at, status, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000001',
  'SOM Platform',
  'platform',
  '{"street": "Platformstraße 1", "city": "Wien", "zip": "1010", "country": "AT"}',
  'ATU-PLATFORM',
  'PLATFORM-001',
  'medium',
  'https://som-staging.at',
  NOW(), NOW(), 'active', NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- USERS
-- ============================================================================
-- Test users created via Supabase Admin API on 2026-01-22
-- Credentials stored in 1Password vault: som-staging
--
-- IMPORTANT: The user IDs below must match the Supabase Auth user IDs
-- After creating auth users via Supabase Admin API, update these IDs accordingly

-- Test User IDs (fixed for reproducibility):
-- buyer-admin: aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
-- buyer-employee: aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaab
-- provider-admin: bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb
-- provider-employee: bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbc
-- hybrid-admin: cccccccc-cccc-cccc-cccc-cccccccccccc
-- consultant: dddddddd-dddd-dddd-dddd-dddddddddddd
-- sysadmin: eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee

-- Buyer Company Users
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '11111111-1111-1111-1111-111111111111',
  'buyer-admin@test.som-staging.at',
  'Buyer', 'Admin', 'Herr', NULL, '+43 1 234 5678',
  '["buyer", "admin"]', true, true, 'buyer', '11111111-1111-1111-1111-111111111111',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaab',
  '11111111-1111-1111-1111-111111111111',
  'buyer-employee@test.som-staging.at',
  'Buyer', 'Employee', 'Frau', NULL, '+43 1 234 5679',
  '["buyer"]', true, true, 'buyer', '11111111-1111-1111-1111-111111111111',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- Provider Company Users
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '22222222-2222-2222-2222-222222222222',
  'provider-admin@test.som-staging.at',
  'Provider', 'Admin', 'Herr', 'Mag.', '+43 316 123 456',
  '["provider", "admin"]', true, true, 'provider', '22222222-2222-2222-2222-222222222222',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbc',
  '22222222-2222-2222-2222-222222222222',
  'provider-employee@test.som-staging.at',
  'Provider', 'Employee', 'Frau', NULL, '+43 316 123 457',
  '["provider"]', true, true, 'provider', '22222222-2222-2222-2222-222222222222',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- Hybrid Company User
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '33333333-3333-3333-3333-333333333333',
  'hybrid-admin@test.som-staging.at',
  'Hybrid', 'Admin', 'Herr', 'Dr.', '+43 732 987 654',
  '["buyer", "provider", "admin"]', true, true, 'buyer', '33333333-3333-3333-3333-333333333333',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- Platform Users (Consultant/Sysadmin)
INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  '00000000-0000-0000-0000-000000000001',
  'consultant@test.som-staging.at',
  'Consultant', 'User', 'Mx', NULL, '+43 1 999 0001',
  '["consultant"]', true, true, 'consultant', '00000000-0000-0000-0000-000000000001',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO som.users (
  id, company_id, email, first_name, last_name, salutation, title, telephone_nr,
  roles_json, is_active, email_confirmed, last_login_role, last_login_company_id,
  created_at, updated_at
) VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  '00000000-0000-0000-0000-000000000001',
  'sysadmin@test.som-staging.at',
  'System', 'Admin', 'Mx', NULL, '+43 1 999 0002',
  '["consultant", "admin"]', true, true, 'consultant', '00000000-0000-0000-0000-000000000001',
  NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- USER COMPANY ROLES (memberships)
-- ============================================================================
-- This table links users to companies with their specific roles

-- Buyer Company Memberships
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '11111111-1111-1111-1111-111111111111',
  '["buyer", "admin"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaab',
  '11111111-1111-1111-1111-111111111111',
  '["buyer"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

-- Provider Company Memberships
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '22222222-2222-2222-2222-222222222222',
  '["provider", "admin"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbc',
  '22222222-2222-2222-2222-222222222222',
  '["provider"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

-- Hybrid Company Memberships
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '33333333-3333-3333-3333-333333333333',
  '["buyer", "provider", "admin"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

-- Platform Company Memberships
INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  '00000000-0000-0000-0000-000000000001',
  '["consultant"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

INSERT INTO som.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  '00000000-0000-0000-0000-000000000001',
  '["consultant", "admin"]',
  NOW(), NOW()
) ON CONFLICT (user_id, company_id) DO NOTHING;

-- ============================================================================
-- NOTES
-- ============================================================================
-- 1. After running this seed, create matching auth.users via Supabase Admin API
--    with the same UUIDs listed above
-- 2. Credentials are stored in 1Password vault: som-staging
-- 3. To use different UUIDs, update both som.users and som.user_company_roles
