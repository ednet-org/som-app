alter table users add column if not exists removed_at timestamptz;
alter table users add column if not exists removed_by_user_id uuid;
