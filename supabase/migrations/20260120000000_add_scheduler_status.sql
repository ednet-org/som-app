create table if not exists scheduler_status (
  job_name text primary key,
  last_run_at timestamptz,
  last_success_at timestamptz,
  last_error text,
  updated_at timestamptz not null default now()
);
