alter table subscription_plans add column if not exists max_users integer;
alter table subscription_plans add column if not exists setup_fee_in_subunit integer;
alter table subscription_plans add column if not exists banner_ads_per_month integer;
alter table subscription_plans add column if not exists normal_ads_per_month integer;
alter table subscription_plans add column if not exists free_months integer;
alter table subscription_plans add column if not exists commitment_period_months integer;
