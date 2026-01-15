create table if not exists roles (
  id uuid primary key,
  name text not null unique,
  description text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);
