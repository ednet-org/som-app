-- Isolate SOM domain data into a dedicated schema.
create schema if not exists som;

-- Move core domain tables from public to som (idempotent).
alter table if exists public.companies set schema som;
alter table if exists public.users set schema som;
alter table if exists public.user_tokens set schema som;
alter table if exists public.refresh_tokens set schema som;
alter table if exists public.subscription_plans set schema som;
alter table if exists public.subscriptions set schema som;
alter table if exists public.billing_records set schema som;
alter table if exists public.subscription_cancellations set schema som;
alter table if exists public.provider_profiles set schema som;
alter table if exists public.branches set schema som;
alter table if exists public.categories set schema som;
alter table if exists public.products set schema som;
alter table if exists public.inquiries set schema som;
alter table if exists public.inquiry_assignments set schema som;
alter table if exists public.offers set schema som;
alter table if exists public.ads set schema som;
alter table if exists public.email_events set schema som;
alter table if exists public.roles set schema som;
alter table if exists public.domain_events set schema som;
alter table if exists public.audit_log set schema som;
alter table if exists public.schema_version set schema som;
alter table if exists public.scheduler_status set schema som;
alter table if exists public.user_company_roles set schema som;
alter table if exists public.company_branches set schema som;
alter table if exists public.company_categories set schema som;

-- Ensure API roles can access the schema (RLS still enforced on tables).
grant usage on schema som to anon, authenticated, service_role;
grant all on all tables in schema som to anon, authenticated, service_role;
grant all on all sequences in schema som to anon, authenticated, service_role;

alter default privileges in schema som
  grant all on tables to anon, authenticated, service_role;
alter default privileges in schema som
  grant all on sequences to anon, authenticated, service_role;

-- Update helper functions to reference the SOM schema explicitly.
create or replace function public.som_has_role(role text)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from som.user_company_roles ucr
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
    from som.user_company_roles ucr
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
    from som.user_company_roles mine
    join som.user_company_roles theirs
      on theirs.company_id = mine.company_id
    where mine.user_id = auth.uid()
      and theirs.user_id = target_user_id
  );
$$;
