create extension if not exists "pgcrypto";

create table if not exists companies (
  id uuid primary key,
  name text not null,
  type text not null,
  address_json jsonb not null,
  uid_nr text not null,
  registration_nr text not null,
  company_size text not null,
  website_url text,
  terms_accepted_at timestamptz,
  privacy_accepted_at timestamptz,
  status text not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table if not exists users (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  email text not null unique,
  first_name text not null,
  last_name text not null,
  salutation text not null,
  title text,
  telephone_nr text,
  roles_json jsonb not null,
  is_active boolean not null default true,
  email_confirmed boolean not null default false,
  last_login_role text,
  last_login_company_id uuid references companies(id),
  failed_login_attempts integer not null default 0,
  last_failed_login_at timestamptz,
  locked_at timestamptz,
  lock_reason text,
  removed_at timestamptz,
  removed_by_user_id uuid,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table if not exists user_company_roles (
  user_id uuid not null references users(id) on delete cascade,
  company_id uuid not null references companies(id) on delete cascade,
  roles_json jsonb not null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  primary key (user_id, company_id)
);

create table if not exists user_tokens (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  type text not null,
  token_hash text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null,
  used_at timestamptz
);

create table if not exists refresh_tokens (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  token_hash text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null,
  revoked_at timestamptz
);

create table if not exists email_events (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  type text not null,
  created_at timestamptz not null
);

create table if not exists roles (
  id uuid primary key,
  name text not null unique,
  description text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table if not exists subscription_plans (
  id uuid primary key,
  name text not null,
  sort_priority integer not null,
  is_active boolean not null,
  price_in_subunit integer not null,
  max_users integer,
  setup_fee_in_subunit integer,
  banner_ads_per_month integer,
  normal_ads_per_month integer,
  free_months integer,
  commitment_period_months integer,
  rules_json jsonb not null,
  created_at timestamptz not null
);

create table if not exists subscriptions (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  plan_id uuid not null references subscription_plans(id),
  status text not null,
  payment_interval text not null,
  start_date timestamptz not null,
  end_date timestamptz not null,
  created_at timestamptz not null
);

create table if not exists billing_records (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  amount_in_subunit integer not null,
  currency text not null,
  status text not null,
  period_start timestamptz not null,
  period_end timestamptz not null,
  created_at timestamptz not null,
  paid_at timestamptz
);

create table if not exists subscription_cancellations (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  requested_by_user_id uuid not null references users(id) on delete cascade,
  reason text,
  status text not null,
  requested_at timestamptz not null,
  effective_end_date timestamptz,
  resolved_at timestamptz
);

create table if not exists provider_profiles (
  company_id uuid primary key references companies(id) on delete cascade,
  bank_details_json jsonb not null,
  branches_json jsonb not null,
  pending_branches_json jsonb not null,
  subscription_plan_id uuid not null,
  payment_interval text not null,
  provider_type text,
  status text not null,
  rejection_reason text,
  rejected_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table if not exists branches (
  id uuid primary key,
  name text not null,
  external_id text unique,
  normalized_name text,
  status text not null default 'active'
);

create table if not exists categories (
  id uuid primary key,
  branch_id uuid not null references branches(id) on delete cascade,
  name text not null,
  external_id text,
  normalized_name text,
  status text not null default 'active'
);

create table if not exists company_branches (
  company_id uuid not null references companies(id) on delete cascade,
  branch_id uuid not null references branches(id) on delete cascade,
  source text not null,
  confidence numeric,
  status text not null default 'active',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  primary key (company_id, branch_id)
);

create table if not exists company_categories (
  company_id uuid not null references companies(id) on delete cascade,
  category_id uuid not null references categories(id) on delete cascade,
  source text not null,
  confidence numeric,
  status text not null default 'active',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  primary key (company_id, category_id)
);

create table if not exists products (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  name text not null,
  created_at timestamptz not null
);

create table if not exists inquiries (
  id uuid primary key,
  buyer_company_id uuid not null references companies(id) on delete cascade,
  created_by_user_id uuid not null references users(id) on delete cascade,
  status text not null,
  branch_id uuid not null,
  category_id uuid not null,
  product_tags_json jsonb not null,
  deadline timestamptz not null,
  delivery_zips text[] not null,
  number_of_providers integer not null,
  description text,
  pdf_path text,
  summary_pdf_path text,
  provider_criteria_json jsonb not null,
  contact_json jsonb not null,
  notified_at timestamptz,
  assigned_at timestamptz,
  closed_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table if not exists inquiry_assignments (
  id text primary key,
  inquiry_id uuid not null references inquiries(id) on delete cascade,
  provider_company_id uuid not null references companies(id) on delete cascade,
  assigned_at timestamptz not null,
  assigned_by_user_id uuid not null references users(id) on delete cascade,
  deadline_reminder_sent_at timestamptz
);

create table if not exists domain_events (
  id uuid primary key,
  type text not null,
  status text not null,
  entity_type text not null,
  entity_id text not null,
  actor_id uuid,
  payload jsonb,
  created_at timestamptz not null
);

create table if not exists audit_log (
  id uuid primary key,
  actor_id uuid,
  action text not null,
  entity_type text not null,
  entity_id text not null,
  metadata jsonb,
  created_at timestamptz not null
);

create table if not exists schema_version (
  id int primary key,
  version int not null,
  applied_at timestamptz not null default now()
);

create table if not exists offers (
  id uuid primary key,
  inquiry_id uuid not null references inquiries(id) on delete cascade,
  provider_company_id uuid not null references companies(id) on delete cascade,
  provider_user_id uuid,
  status text not null,
  pdf_path text,
  summary_pdf_path text,
  forwarded_at timestamptz,
  resolved_at timestamptz,
  buyer_decision text,
  provider_decision text,
  created_at timestamptz not null
);

create table if not exists ads (
  id uuid primary key,
  company_id uuid not null references companies(id) on delete cascade,
  type text not null,
  status text not null,
  branch_id uuid not null,
  url text not null,
  image_path text not null,
  headline text,
  description text,
  start_date timestamptz,
  end_date timestamptz,
  banner_date timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null
);
