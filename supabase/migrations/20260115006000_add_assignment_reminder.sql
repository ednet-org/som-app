alter table if exists inquiry_assignments
  add column if not exists deadline_reminder_sent_at timestamptz;
