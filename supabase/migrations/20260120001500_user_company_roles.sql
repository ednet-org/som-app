alter table public.users
  add column if not exists last_login_company_id uuid references public.companies(id);

create table if not exists public.user_company_roles (
  user_id uuid not null references public.users(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  roles_json jsonb not null,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  primary key (user_id, company_id)
);

insert into public.user_company_roles (user_id, company_id, roles_json, created_at, updated_at)
select id, company_id, roles_json, created_at, updated_at
from public.users
on conflict (user_id, company_id) do nothing;

update public.users
set last_login_company_id = company_id
where last_login_company_id is null;
