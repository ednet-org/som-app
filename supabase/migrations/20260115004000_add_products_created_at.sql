alter table products add column if not exists created_at timestamptz not null default now();
