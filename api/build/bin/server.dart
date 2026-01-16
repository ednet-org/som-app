// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/stats/provider.dart' as stats_provider;
import '../routes/stats/consultant.dart' as stats_consultant;
import '../routes/stats/buyer.dart' as stats_buyer;
import '../routes/roles/index.dart' as roles_index;
import '../routes/roles/[roleId]/index.dart' as roles_$role_id_index;
import '../routes/providers/index.dart' as providers_index;
import '../routes/providers/[companyId]/paymentDetails.dart' as providers_$company_id_payment_details;
import '../routes/providers/[companyId]/index.dart' as providers_$company_id_index;
import '../routes/providers/[companyId]/decline.dart' as providers_$company_id_decline;
import '../routes/providers/[companyId]/approve.dart' as providers_$company_id_approve;
import '../routes/providers/[companyId]/products/index.dart' as providers_$company_id_products_index;
import '../routes/providers/[companyId]/products/[productId]/index.dart' as providers_$company_id_products_$product_id_index;
import '../routes/offers/[offerId]/reject.dart' as offers_$offer_id_reject;
import '../routes/offers/[offerId]/pdf.dart' as offers_$offer_id_pdf;
import '../routes/offers/[offerId]/accept.dart' as offers_$offer_id_accept;
import '../routes/inquiries/index.dart' as inquiries_index;
import '../routes/inquiries/[inquiryId]/pdf.dart' as inquiries_$inquiry_id_pdf;
import '../routes/inquiries/[inquiryId]/index.dart' as inquiries_$inquiry_id_index;
import '../routes/inquiries/[inquiryId]/ignore.dart' as inquiries_$inquiry_id_ignore;
import '../routes/inquiries/[inquiryId]/close.dart' as inquiries_$inquiry_id_close;
import '../routes/inquiries/[inquiryId]/assign.dart' as inquiries_$inquiry_id_assign;
import '../routes/inquiries/[inquiryId]/offers/index.dart' as inquiries_$inquiry_id_offers_index;
import '../routes/dev/auth/token.dart' as dev_auth_token;
import '../routes/consultants/registerCompany.dart' as consultants_register_company;
import '../routes/consultants/index.dart' as consultants_index;
import '../routes/categories/[categoryId]/index.dart' as categories_$category_id_index;
import '../routes/branches/index.dart' as branches_index;
import '../routes/branches/[branchId]/index.dart' as branches_$branch_id_index;
import '../routes/branches/[branchId]/categories.dart' as branches_$branch_id_categories;
import '../routes/billing/index.dart' as billing_index;
import '../routes/billing/[billingId]/index.dart' as billing_$billing_id_index;
import '../routes/auth/switchRole.dart' as auth_switch_role;
import '../routes/auth/resetPassword.dart' as auth_reset_password;
import '../routes/auth/logout.dart' as auth_logout;
import '../routes/auth/login.dart' as auth_login;
import '../routes/auth/forgotPassword.dart' as auth_forgot_password;
import '../routes/auth/confirmEmail.dart' as auth_confirm_email;
import '../routes/auth/changePassword.dart' as auth_change_password;
import '../routes/audit/index.dart' as audit_index;
import '../routes/ads/index.dart' as ads_index;
import '../routes/ads/[adId]/index.dart' as ads_$ad_id_index;
import '../routes/ads/[adId]/image.dart' as ads_$ad_id_image;
import '../routes/ads/[adId]/deactivate.dart' as ads_$ad_id_deactivate;
import '../routes/ads/[adId]/activate.dart' as ads_$ad_id_activate;
import '../routes/Users/loadUserWithCompany.dart' as users_load_user_with_company;
import '../routes/Users/[userId]/unlock.dart' as users_$user_id_unlock;
import '../routes/Subscriptions/upgrade.dart' as subscriptions_upgrade;
import '../routes/Subscriptions/index.dart' as subscriptions_index;
import '../routes/Subscriptions/downgrade.dart' as subscriptions_downgrade;
import '../routes/Subscriptions/current.dart' as subscriptions_current;
import '../routes/Subscriptions/cancel.dart' as subscriptions_cancel;
import '../routes/Subscriptions/plans/[planId]/index.dart' as subscriptions_plans_$plan_id_index;
import '../routes/Subscriptions/cancellations/index.dart' as subscriptions_cancellations_index;
import '../routes/Subscriptions/cancellations/[cancellationId]/index.dart' as subscriptions_cancellations_$cancellation_id_index;
import '../routes/Companies/index.dart' as companies_index;
import '../routes/Companies/[companyId]/registerUser.dart' as companies_$company_id_register_user;
import '../routes/Companies/[companyId]/index.dart' as companies_$company_id_index;
import '../routes/Companies/[companyId]/activate.dart' as companies_$company_id_activate;
import '../routes/Companies/[companyId]/users/index.dart' as companies_$company_id_users_index;
import '../routes/Companies/[companyId]/users/[userId]/update.dart' as companies_$company_id_users_$user_id_update;
import '../routes/Companies/[companyId]/users/[userId]/remove.dart' as companies_$company_id_users_$user_id_remove;
import '../routes/Companies/[companyId]/users/[userId]/index.dart' as companies_$company_id_users_$user_id_index;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/Companies/<companyId>/users/<userId>', (context,companyId,userId,) => buildCompanies$companyIdUsers$userIdHandler(companyId,userId,)(context))
    ..mount('/Companies/<companyId>/users', (context,companyId,) => buildCompanies$companyIdUsersHandler(companyId,)(context))
    ..mount('/Companies/<companyId>', (context,companyId,) => buildCompanies$companyIdHandler(companyId,)(context))
    ..mount('/Companies', (context) => buildCompaniesHandler()(context))
    ..mount('/Subscriptions/cancellations/<cancellationId>', (context,cancellationId,) => buildSubscriptionsCancellations$cancellationIdHandler(cancellationId,)(context))
    ..mount('/Subscriptions/cancellations', (context) => buildSubscriptionsCancellationsHandler()(context))
    ..mount('/Subscriptions/plans/<planId>', (context,planId,) => buildSubscriptionsPlans$planIdHandler(planId,)(context))
    ..mount('/Subscriptions', (context) => buildSubscriptionsHandler()(context))
    ..mount('/Users/<userId>', (context,userId,) => buildUsers$userIdHandler(userId,)(context))
    ..mount('/Users', (context) => buildUsersHandler()(context))
    ..mount('/ads/<adId>', (context,adId,) => buildAds$adIdHandler(adId,)(context))
    ..mount('/ads', (context) => buildAdsHandler()(context))
    ..mount('/audit', (context) => buildAuditHandler()(context))
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/billing/<billingId>', (context,billingId,) => buildBilling$billingIdHandler(billingId,)(context))
    ..mount('/billing', (context) => buildBillingHandler()(context))
    ..mount('/branches/<branchId>', (context,branchId,) => buildBranches$branchIdHandler(branchId,)(context))
    ..mount('/branches', (context) => buildBranchesHandler()(context))
    ..mount('/categories/<categoryId>', (context,categoryId,) => buildCategories$categoryIdHandler(categoryId,)(context))
    ..mount('/consultants', (context) => buildConsultantsHandler()(context))
    ..mount('/dev/auth', (context) => buildDevAuthHandler()(context))
    ..mount('/inquiries/<inquiryId>/offers', (context,inquiryId,) => buildInquiries$inquiryIdOffersHandler(inquiryId,)(context))
    ..mount('/inquiries/<inquiryId>', (context,inquiryId,) => buildInquiries$inquiryIdHandler(inquiryId,)(context))
    ..mount('/inquiries', (context) => buildInquiriesHandler()(context))
    ..mount('/offers/<offerId>', (context,offerId,) => buildOffers$offerIdHandler(offerId,)(context))
    ..mount('/providers/<companyId>/products/<productId>', (context,companyId,productId,) => buildProviders$companyIdProducts$productIdHandler(companyId,productId,)(context))
    ..mount('/providers/<companyId>/products', (context,companyId,) => buildProviders$companyIdProductsHandler(companyId,)(context))
    ..mount('/providers/<companyId>', (context,companyId,) => buildProviders$companyIdHandler(companyId,)(context))
    ..mount('/providers', (context) => buildProvidersHandler()(context))
    ..mount('/roles/<roleId>', (context,roleId,) => buildRoles$roleIdHandler(roleId,)(context))
    ..mount('/roles', (context) => buildRolesHandler()(context))
    ..mount('/stats', (context) => buildStatsHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildCompanies$companyIdUsers$userIdHandler(String companyId,String userId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/update', (context) => companies_$company_id_users_$user_id_update.onRequest(context,companyId,userId,))..all('/remove', (context) => companies_$company_id_users_$user_id_remove.onRequest(context,companyId,userId,))..all('/', (context) => companies_$company_id_users_$user_id_index.onRequest(context,companyId,userId,));
  return pipeline.addHandler(router);
}

Handler buildCompanies$companyIdUsersHandler(String companyId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => companies_$company_id_users_index.onRequest(context,companyId,));
  return pipeline.addHandler(router);
}

Handler buildCompanies$companyIdHandler(String companyId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/registerUser', (context) => companies_$company_id_register_user.onRequest(context,companyId,))..all('/', (context) => companies_$company_id_index.onRequest(context,companyId,))..all('/activate', (context) => companies_$company_id_activate.onRequest(context,companyId,));
  return pipeline.addHandler(router);
}

Handler buildCompaniesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => companies_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildSubscriptionsCancellations$cancellationIdHandler(String cancellationId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => subscriptions_cancellations_$cancellation_id_index.onRequest(context,cancellationId,));
  return pipeline.addHandler(router);
}

Handler buildSubscriptionsCancellationsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => subscriptions_cancellations_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildSubscriptionsPlans$planIdHandler(String planId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => subscriptions_plans_$plan_id_index.onRequest(context,planId,));
  return pipeline.addHandler(router);
}

Handler buildSubscriptionsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/upgrade', (context) => subscriptions_upgrade.onRequest(context,))..all('/', (context) => subscriptions_index.onRequest(context,))..all('/downgrade', (context) => subscriptions_downgrade.onRequest(context,))..all('/current', (context) => subscriptions_current.onRequest(context,))..all('/cancel', (context) => subscriptions_cancel.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildUsers$userIdHandler(String userId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/unlock', (context) => users_$user_id_unlock.onRequest(context,userId,));
  return pipeline.addHandler(router);
}

Handler buildUsersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/loadUserWithCompany', (context) => users_load_user_with_company.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildAds$adIdHandler(String adId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => ads_$ad_id_index.onRequest(context,adId,))..all('/image', (context) => ads_$ad_id_image.onRequest(context,adId,))..all('/deactivate', (context) => ads_$ad_id_deactivate.onRequest(context,adId,))..all('/activate', (context) => ads_$ad_id_activate.onRequest(context,adId,));
  return pipeline.addHandler(router);
}

Handler buildAdsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => ads_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildAuditHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => audit_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/switchRole', (context) => auth_switch_role.onRequest(context,))..all('/resetPassword', (context) => auth_reset_password.onRequest(context,))..all('/logout', (context) => auth_logout.onRequest(context,))..all('/login', (context) => auth_login.onRequest(context,))..all('/forgotPassword', (context) => auth_forgot_password.onRequest(context,))..all('/confirmEmail', (context) => auth_confirm_email.onRequest(context,))..all('/changePassword', (context) => auth_change_password.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildBilling$billingIdHandler(String billingId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => billing_$billing_id_index.onRequest(context,billingId,));
  return pipeline.addHandler(router);
}

Handler buildBillingHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => billing_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildBranches$branchIdHandler(String branchId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => branches_$branch_id_index.onRequest(context,branchId,))..all('/categories', (context) => branches_$branch_id_categories.onRequest(context,branchId,));
  return pipeline.addHandler(router);
}

Handler buildBranchesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => branches_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildCategories$categoryIdHandler(String categoryId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => categories_$category_id_index.onRequest(context,categoryId,));
  return pipeline.addHandler(router);
}

Handler buildConsultantsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/registerCompany', (context) => consultants_register_company.onRequest(context,))..all('/', (context) => consultants_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildDevAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/token', (context) => dev_auth_token.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildInquiries$inquiryIdOffersHandler(String inquiryId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => inquiries_$inquiry_id_offers_index.onRequest(context,inquiryId,));
  return pipeline.addHandler(router);
}

Handler buildInquiries$inquiryIdHandler(String inquiryId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/pdf', (context) => inquiries_$inquiry_id_pdf.onRequest(context,inquiryId,))..all('/', (context) => inquiries_$inquiry_id_index.onRequest(context,inquiryId,))..all('/ignore', (context) => inquiries_$inquiry_id_ignore.onRequest(context,inquiryId,))..all('/close', (context) => inquiries_$inquiry_id_close.onRequest(context,inquiryId,))..all('/assign', (context) => inquiries_$inquiry_id_assign.onRequest(context,inquiryId,));
  return pipeline.addHandler(router);
}

Handler buildInquiriesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => inquiries_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildOffers$offerIdHandler(String offerId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/reject', (context) => offers_$offer_id_reject.onRequest(context,offerId,))..all('/pdf', (context) => offers_$offer_id_pdf.onRequest(context,offerId,))..all('/accept', (context) => offers_$offer_id_accept.onRequest(context,offerId,));
  return pipeline.addHandler(router);
}

Handler buildProviders$companyIdProducts$productIdHandler(String companyId,String productId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => providers_$company_id_products_$product_id_index.onRequest(context,companyId,productId,));
  return pipeline.addHandler(router);
}

Handler buildProviders$companyIdProductsHandler(String companyId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => providers_$company_id_products_index.onRequest(context,companyId,));
  return pipeline.addHandler(router);
}

Handler buildProviders$companyIdHandler(String companyId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/paymentDetails', (context) => providers_$company_id_payment_details.onRequest(context,companyId,))..all('/', (context) => providers_$company_id_index.onRequest(context,companyId,))..all('/decline', (context) => providers_$company_id_decline.onRequest(context,companyId,))..all('/approve', (context) => providers_$company_id_approve.onRequest(context,companyId,));
  return pipeline.addHandler(router);
}

Handler buildProvidersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => providers_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildRoles$roleIdHandler(String roleId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => roles_$role_id_index.onRequest(context,roleId,));
  return pipeline.addHandler(router);
}

Handler buildRolesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => roles_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildStatsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/provider', (context) => stats_provider.onRequest(context,))..all('/consultant', (context) => stats_consultant.onRequest(context,))..all('/buyer', (context) => stats_buyer.onRequest(context,));
  return pipeline.addHandler(router);
}

