insert into storage.buckets (id, name, public, allowed_mime_types, file_size_limit)
values (
  'som-assets',
  'som-assets',
  false,
  array['application/pdf', 'image/png', 'image/jpeg', 'image/webp'],
  '10MB'
)
on conflict (id) do update
set public = excluded.public,
    allowed_mime_types = excluded.allowed_mime_types,
    file_size_limit = excluded.file_size_limit;
