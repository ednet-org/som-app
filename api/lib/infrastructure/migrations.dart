const migrations = <String>[
  '''
  CREATE TABLE IF NOT EXISTS schema_version (
    version INTEGER NOT NULL
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS companies (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    address_json TEXT NOT NULL,
    uid_nr TEXT NOT NULL,
    registration_nr TEXT NOT NULL,
    company_size TEXT NOT NULL,
    website_url TEXT,
    status TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    company_id TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    salutation TEXT NOT NULL,
    title TEXT,
    telephone_nr TEXT,
    roles_json TEXT NOT NULL,
    is_active INTEGER NOT NULL,
    email_confirmed INTEGER NOT NULL,
    last_login_role TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(company_id) REFERENCES companies(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS user_tokens (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    type TEXT NOT NULL,
    token_hash TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    created_at TEXT NOT NULL,
    used_at TEXT,
    FOREIGN KEY(user_id) REFERENCES users(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS refresh_tokens (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    token_hash TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    created_at TEXT NOT NULL,
    revoked_at TEXT,
    FOREIGN KEY(user_id) REFERENCES users(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS subscription_plans (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    sort_priority INTEGER NOT NULL,
    is_active INTEGER NOT NULL,
    price_in_subunit INTEGER NOT NULL,
    rules_json TEXT NOT NULL,
    created_at TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS subscriptions (
    id TEXT PRIMARY KEY,
    company_id TEXT NOT NULL,
    plan_id TEXT NOT NULL,
    status TEXT NOT NULL,
    payment_interval TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY(company_id) REFERENCES companies(id),
    FOREIGN KEY(plan_id) REFERENCES subscription_plans(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS provider_profiles (
    company_id TEXT PRIMARY KEY,
    bank_details_json TEXT NOT NULL,
    branches_json TEXT NOT NULL,
    pending_branches_json TEXT NOT NULL,
    subscription_plan_id TEXT NOT NULL,
    payment_interval TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(company_id) REFERENCES companies(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS branches (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS categories (
    id TEXT PRIMARY KEY,
    branch_id TEXT NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY(branch_id) REFERENCES branches(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY,
    company_id TEXT NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY(company_id) REFERENCES companies(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS inquiries (
    id TEXT PRIMARY KEY,
    buyer_company_id TEXT NOT NULL,
    created_by_user_id TEXT NOT NULL,
    status TEXT NOT NULL,
    branch_id TEXT NOT NULL,
    category_id TEXT NOT NULL,
    product_tags_json TEXT NOT NULL,
    deadline TEXT NOT NULL,
    delivery_zips TEXT NOT NULL,
    number_of_providers INTEGER NOT NULL,
    description TEXT,
    pdf_path TEXT,
    provider_criteria_json TEXT NOT NULL,
    contact_json TEXT NOT NULL,
    notified_at TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(buyer_company_id) REFERENCES companies(id),
    FOREIGN KEY(created_by_user_id) REFERENCES users(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS inquiry_assignments (
    id TEXT PRIMARY KEY,
    inquiry_id TEXT NOT NULL,
    provider_company_id TEXT NOT NULL,
    assigned_at TEXT NOT NULL,
    assigned_by_user_id TEXT NOT NULL,
    FOREIGN KEY(inquiry_id) REFERENCES inquiries(id),
    FOREIGN KEY(provider_company_id) REFERENCES companies(id),
    FOREIGN KEY(assigned_by_user_id) REFERENCES users(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS offers (
    id TEXT PRIMARY KEY,
    inquiry_id TEXT NOT NULL,
    provider_company_id TEXT NOT NULL,
    provider_user_id TEXT,
    status TEXT NOT NULL,
    pdf_path TEXT,
    forwarded_at TEXT,
    resolved_at TEXT,
    buyer_decision TEXT,
    provider_decision TEXT,
    created_at TEXT NOT NULL,
    FOREIGN KEY(inquiry_id) REFERENCES inquiries(id),
    FOREIGN KEY(provider_company_id) REFERENCES companies(id),
    FOREIGN KEY(provider_user_id) REFERENCES users(id)
  );
  ''',
  '''
  CREATE TABLE IF NOT EXISTS ads (
    id TEXT PRIMARY KEY,
    company_id TEXT NOT NULL,
    type TEXT NOT NULL,
    status TEXT NOT NULL,
    branch_id TEXT NOT NULL,
    url TEXT NOT NULL,
    image_path TEXT NOT NULL,
    headline TEXT,
    description TEXT,
    start_date TEXT,
    end_date TEXT,
    banner_date TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(company_id) REFERENCES companies(id)
  );
  ''',
];
