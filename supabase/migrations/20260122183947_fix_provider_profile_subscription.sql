-- Fix: Ensure provider profile and subscription exist for test provider company

-- Ensure provider profile exists and is active
INSERT INTO som.provider_profiles (
  company_id, bank_details_json, branches_json, pending_branches_json,
  subscription_plan_id, payment_interval, provider_type, status,
  created_at, updated_at
) VALUES (
  '22222222-2222-2222-2222-222222222222',
  '{"iban": "AT123456789012345678", "bic": "TESTBICXXX", "accountOwner": "Test Provider AG"}',
  '[]', '[]',
  (SELECT id FROM som.subscription_plans LIMIT 1),
  'yearly', 'manufacturer', 'active',
  NOW(), NOW()
) ON CONFLICT (company_id) DO UPDATE SET 
  status = 'active',
  subscription_plan_id = COALESCE(
    som.provider_profiles.subscription_plan_id,
    (SELECT id FROM som.subscription_plans LIMIT 1)
  ),
  updated_at = NOW();

-- Ensure subscription exists and is active
INSERT INTO som.subscriptions (
  id, company_id, plan_id, status, payment_interval, start_date, end_date, created_at
)
SELECT
  gen_random_uuid(),
  '22222222-2222-2222-2222-222222222222',
  (SELECT id FROM som.subscription_plans LIMIT 1),
  'active',
  'yearly',
  NOW(),
  NOW() + INTERVAL '1 year',
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM som.subscriptions WHERE company_id = '22222222-2222-2222-2222-222222222222'
);

-- Update existing subscription if it exists
UPDATE som.subscriptions 
SET status = 'active', end_date = NOW() + INTERVAL '1 year'
WHERE company_id = '22222222-2222-2222-2222-222222222222';

-- Also fix hybrid company (33333333-3333-3333-3333-333333333333)
INSERT INTO som.provider_profiles (
  company_id, bank_details_json, branches_json, pending_branches_json,
  subscription_plan_id, payment_interval, provider_type, status,
  created_at, updated_at
) VALUES (
  '33333333-3333-3333-3333-333333333333',
  '{"iban": "AT987654321098765432", "bic": "HYBRIDBICX", "accountOwner": "Test Hybrid KG"}',
  '[]', '[]',
  (SELECT id FROM som.subscription_plans LIMIT 1),
  'monthly', 'trader', 'active',
  NOW(), NOW()
) ON CONFLICT (company_id) DO UPDATE SET 
  status = 'active',
  updated_at = NOW();

INSERT INTO som.subscriptions (
  id, company_id, plan_id, status, payment_interval, start_date, end_date, created_at
)
SELECT
  gen_random_uuid(),
  '33333333-3333-3333-3333-333333333333',
  (SELECT id FROM som.subscription_plans LIMIT 1),
  'active',
  'monthly',
  NOW(),
  NOW() + INTERVAL '1 year',
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM som.subscriptions WHERE company_id = '33333333-3333-3333-3333-333333333333'
);

UPDATE som.subscriptions 
SET status = 'active', end_date = NOW() + INTERVAL '1 year'
WHERE company_id = '33333333-3333-3333-3333-333333333333';
