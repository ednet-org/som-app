create table if not exists email_events (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  type text not null,
  created_at timestamptz not null
);
