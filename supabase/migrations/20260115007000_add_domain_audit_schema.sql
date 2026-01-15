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

insert into schema_version (id, version)
values (1, 1)
on conflict (id) do update set version = excluded.version;
