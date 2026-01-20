create or replace function public.som_has_role(role text)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_company_roles ucr
    where ucr.user_id = auth.uid()
      and (ucr.roles_json ? role)
  );
$$;

create or replace function public.som_is_company_member(company_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_company_roles ucr
    where ucr.user_id = auth.uid()
      and ucr.company_id = company_id
  );
$$;

create or replace function public.som_share_company(target_user_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_company_roles mine
    join public.user_company_roles theirs
      on theirs.company_id = mine.company_id
    where mine.user_id = auth.uid()
      and theirs.user_id = target_user_id
  );
$$;

alter table public.user_company_roles enable row level security;
alter table public.companies enable row level security;
alter table public.users enable row level security;
alter table public.inquiries enable row level security;
alter table public.offers enable row level security;
alter table public.ads enable row level security;

drop policy if exists "user_company_roles_read" on public.user_company_roles;
create policy "user_company_roles_read"
on public.user_company_roles
for select
using (public.som_has_role('consultant') or user_id = auth.uid());

drop policy if exists "user_company_roles_write_service" on public.user_company_roles;
create policy "user_company_roles_write_service"
on public.user_company_roles
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

drop policy if exists "companies_read" on public.companies;
create policy "companies_read"
on public.companies
for select
using (public.som_has_role('consultant') or public.som_is_company_member(id));

drop policy if exists "companies_write_service" on public.companies;
create policy "companies_write_service"
on public.companies
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

drop policy if exists "users_read" on public.users;
create policy "users_read"
on public.users
for select
using (
  public.som_has_role('consultant')
  or id = auth.uid()
  or public.som_share_company(id)
);

drop policy if exists "users_write_service" on public.users;
create policy "users_write_service"
on public.users
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

drop policy if exists "inquiries_read" on public.inquiries;
create policy "inquiries_read"
on public.inquiries
for select
using (
  public.som_has_role('consultant')
  or public.som_is_company_member(buyer_company_id)
  or exists (
    select 1
    from public.inquiry_assignments ia
    join public.user_company_roles ucr
      on ucr.company_id = ia.provider_company_id
    where ia.inquiry_id = inquiries.id
      and ucr.user_id = auth.uid()
  )
);

drop policy if exists "inquiries_write_service" on public.inquiries;
create policy "inquiries_write_service"
on public.inquiries
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

drop policy if exists "offers_read" on public.offers;
create policy "offers_read"
on public.offers
for select
using (
  public.som_has_role('consultant')
  or public.som_is_company_member(provider_company_id)
  or exists (
    select 1
    from public.inquiries i
    where i.id = offers.inquiry_id
      and public.som_is_company_member(i.buyer_company_id)
  )
);

drop policy if exists "offers_write_service" on public.offers;
create policy "offers_write_service"
on public.offers
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

drop policy if exists "ads_read" on public.ads;
create policy "ads_read"
on public.ads
for select
using (
  public.som_has_role('consultant')
  or public.som_is_company_member(company_id)
);

drop policy if exists "ads_write_service" on public.ads;
create policy "ads_write_service"
on public.ads
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

do $$
begin
  execute 'alter table storage.objects enable row level security';
  execute 'drop policy if exists "storage_read_authenticated" on storage.objects';
  execute $policy$create policy "storage_read_authenticated"
    on storage.objects
    for select
    using (auth.role() in ('authenticated', 'service_role'))$policy$;
  execute 'drop policy if exists "storage_write_service" on storage.objects';
  execute $policy$create policy "storage_write_service"
    on storage.objects
    for all
    using (auth.role() = 'service_role')
    with check (auth.role() = 'service_role')$policy$;
exception
  when undefined_table then
    raise notice 'Skipping storage.objects RLS policies: storage schema not available.';
  when insufficient_privilege then
    raise notice 'Skipping storage.objects RLS policies: insufficient privileges for %.', current_user;
end $$;
