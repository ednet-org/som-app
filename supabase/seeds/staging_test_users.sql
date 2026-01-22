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
-- USERS
-- ============================================================================
-- Test users created via Supabase Admin API on 2026-01-22
-- Credentials stored in 1Password vault: som-staging
--
-- Buyer Company (Test Buyer GmbH):
--   - buyer-admin@test.som-staging.at (roles: buyer, admin)
--   - buyer-employee@test.som-staging.at (roles: buyer)
--
-- Provider Company (Test Provider AG):
--   - provider-admin@test.som-staging.at (roles: provider, admin)
--   - provider-employee@test.som-staging.at (roles: provider)
--
-- Hybrid Company (Test Hybrid KG):
--   - hybrid-admin@test.som-staging.at (roles: buyer, provider, admin)
--
-- Platform Admin Company (SOM Platform Admin):
--   - consultant@test.som-staging.at (roles: consultant)
--   - sysadmin@test.som-staging.at (roles: consultant, admin)
--
-- Note: Users are created in both auth.users (Supabase Auth) and som.users table
-- Passwords are stored in 1Password vault: som-staging
