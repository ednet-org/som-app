-- Privileged storage RLS setup for local/CI runs.
-- This script must run as postgres or another role that owns storage.objects.
alter table storage.objects enable row level security;

drop policy if exists "storage_read_authenticated" on storage.objects;
create policy "storage_read_authenticated"
on storage.objects
for select
using (auth.role() in ('authenticated', 'service_role'));

drop policy if exists "storage_write_service" on storage.objects;
create policy "storage_write_service"
on storage.objects
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');
