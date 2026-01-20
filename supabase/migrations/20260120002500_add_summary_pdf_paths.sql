alter table public.inquiries
  add column if not exists summary_pdf_path text;

alter table public.offers
  add column if not exists summary_pdf_path text;
