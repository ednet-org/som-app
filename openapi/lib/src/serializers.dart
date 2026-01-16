//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/ad.dart';
import 'package:openapi/src/model/ad_activation_request.dart';
import 'package:openapi/src/model/address.dart';
import 'package:openapi/src/model/ads_ad_id_image_post200_response.dart';
import 'package:openapi/src/model/audit_log_entry.dart';
import 'package:openapi/src/model/auth_change_password_post200_response.dart';
import 'package:openapi/src/model/auth_change_password_post_request.dart';
import 'package:openapi/src/model/auth_forgot_password_post_request.dart';
import 'package:openapi/src/model/auth_login_post200_response.dart';
import 'package:openapi/src/model/auth_login_post_request.dart';
import 'package:openapi/src/model/auth_reset_password_post_request.dart';
import 'package:openapi/src/model/auth_switch_role_post200_response.dart';
import 'package:openapi/src/model/auth_switch_role_post_request.dart';
import 'package:openapi/src/model/bank_details.dart';
import 'package:openapi/src/model/billing_billing_id_put_request.dart';
import 'package:openapi/src/model/billing_record.dart';
import 'package:openapi/src/model/branch.dart';
import 'package:openapi/src/model/branches_post_request.dart';
import 'package:openapi/src/model/category.dart';
import 'package:openapi/src/model/company_dto.dart';
import 'package:openapi/src/model/company_registration.dart';
import 'package:openapi/src/model/consultants_register_company_post_request.dart';
import 'package:openapi/src/model/contact_info.dart';
import 'package:openapi/src/model/create_ad200_response.dart';
import 'package:openapi/src/model/create_ad_request.dart';
import 'package:openapi/src/model/create_inquiry_request.dart';
import 'package:openapi/src/model/inquiries_inquiry_id_assign_post_request.dart';
import 'package:openapi/src/model/inquiries_inquiry_id_offers_post200_response.dart';
import 'package:openapi/src/model/inquiries_inquiry_id_offers_post_request1.dart';
import 'package:openapi/src/model/inquiries_inquiry_id_pdf_get200_response.dart';
import 'package:openapi/src/model/inquiries_inquiry_id_pdf_post200_response.dart';
import 'package:openapi/src/model/inquiry.dart';
import 'package:openapi/src/model/offer.dart';
import 'package:openapi/src/model/product.dart';
import 'package:openapi/src/model/product_input.dart';
import 'package:openapi/src/model/provider_criteria.dart';
import 'package:openapi/src/model/provider_profile.dart';
import 'package:openapi/src/model/provider_registration_data.dart';
import 'package:openapi/src/model/provider_summary.dart';
import 'package:openapi/src/model/providers_company_id_approve_post_request.dart';
import 'package:openapi/src/model/providers_company_id_payment_details_put200_response.dart';
import 'package:openapi/src/model/register_company_request.dart';
import 'package:openapi/src/model/role.dart';
import 'package:openapi/src/model/role_input.dart';
import 'package:openapi/src/model/stats_buyer_get200_response.dart';
import 'package:openapi/src/model/stats_provider_get200_response.dart';
import 'package:openapi/src/model/subscription_cancellation.dart';
import 'package:openapi/src/model/subscription_current.dart';
import 'package:openapi/src/model/subscription_current_subscription.dart';
import 'package:openapi/src/model/subscription_plan.dart';
import 'package:openapi/src/model/subscription_plan_input.dart';
import 'package:openapi/src/model/subscription_plan_rules_inner.dart';
import 'package:openapi/src/model/subscriptions_cancel_post_request.dart';
import 'package:openapi/src/model/subscriptions_get200_response.dart';
import 'package:openapi/src/model/subscriptions_upgrade_post_request.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:openapi/src/model/user_registration.dart';
import 'package:openapi/src/model/users_load_user_with_company_get200_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  Ad,
  AdActivationRequest,
  Address,
  AdsAdIdImagePost200Response,
  AuditLogEntry,
  AuthChangePasswordPost200Response,
  AuthChangePasswordPostRequest,
  AuthForgotPasswordPostRequest,
  AuthLoginPost200Response,
  AuthLoginPostRequest,
  AuthResetPasswordPostRequest,
  AuthSwitchRolePost200Response,
  AuthSwitchRolePostRequest,
  BankDetails,
  BillingBillingIdPutRequest,
  BillingRecord,
  Branch,
  BranchesPostRequest,
  Category,
  CompanyDto,
  CompanyRegistration,
  ConsultantsRegisterCompanyPostRequest,
  ContactInfo,
  CreateAd200Response,
  CreateAdRequest,
  CreateInquiryRequest,
  InquiriesInquiryIdAssignPostRequest,
  InquiriesInquiryIdOffersPost200Response,
  InquiriesInquiryIdOffersPostRequest1,
  InquiriesInquiryIdPdfGet200Response,
  InquiriesInquiryIdPdfPost200Response,
  Inquiry,
  Offer,
  Product,
  ProductInput,
  ProviderCriteria,
  ProviderProfile,
  ProviderRegistrationData,
  ProviderSummary,
  ProvidersCompanyIdApprovePostRequest,
  ProvidersCompanyIdPaymentDetailsPut200Response,
  RegisterCompanyRequest,
  Role,
  RoleInput,
  StatsBuyerGet200Response,
  StatsProviderGet200Response,
  SubscriptionCancellation,
  SubscriptionCurrent,
  SubscriptionCurrentSubscription,
  SubscriptionPlan,
  SubscriptionPlanInput,
  SubscriptionPlanRulesInner,
  SubscriptionsCancelPostRequest,
  SubscriptionsGet200Response,
  SubscriptionsUpgradePostRequest,
  UserDto,
  UserRegistration,
  UsersLoadUserWithCompanyGet200Response,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Ad)]),
        () => ListBuilder<Ad>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Inquiry)]),
        () => ListBuilder<Inquiry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ProviderSummary)]),
        () => ListBuilder<ProviderSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Branch)]),
        () => ListBuilder<Branch>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Product)]),
        () => ListBuilder<Product>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Role)]),
        () => ListBuilder<Role>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SubscriptionCancellation)]),
        () => ListBuilder<SubscriptionCancellation>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Offer)]),
        () => ListBuilder<Offer>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(int)]),
        () => MapBuilder<String, int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AuditLogEntry)]),
        () => ListBuilder<AuditLogEntry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CompanyDto)]),
        () => ListBuilder<CompanyDto>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(BillingRecord)]),
        () => ListBuilder<BillingRecord>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserDto)]),
        () => ListBuilder<UserDto>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
