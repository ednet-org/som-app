//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/address_dto.dart';
import 'package:openapi/src/model/authenticate_dto.dart';
import 'package:openapi/src/model/authenticate_result_dto.dart';
import 'package:openapi/src/model/bank_details_dto.dart';
import 'package:openapi/src/model/company_dto.dart';
import 'package:openapi/src/model/company_size.dart';
import 'package:openapi/src/model/company_type.dart';
import 'package:openapi/src/model/create_company_dto.dart';
import 'package:openapi/src/model/create_provider_dto.dart';
import 'package:openapi/src/model/forgot_password_dto.dart';
import 'package:openapi/src/model/payment_interval.dart';
import 'package:openapi/src/model/register_company_dto.dart';
import 'package:openapi/src/model/reset_password_dto.dart';
import 'package:openapi/src/model/restriction_type.dart';
import 'package:openapi/src/model/roles.dart';
import 'package:openapi/src/model/subscription_plan_dto.dart';
import 'package:openapi/src/model/subscription_rule_dto.dart';
import 'package:openapi/src/model/subscriptions_response.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:openapi/src/model/user_with_company_dto.dart';

part 'serializers.g.dart';

@SerializersFor([
  AddressDto,
  AuthenticateDto,
  AuthenticateResultDto,
  BankDetailsDto,
  CompanyDto,
  CompanySize,
  CompanyType,
  CreateCompanyDto,
  CreateProviderDto,
  ForgotPasswordDto,
  PaymentInterval,
  RegisterCompanyDto,
  ResetPasswordDto,
  RestrictionType,
  Roles,
  SubscriptionPlanDto,
  SubscriptionRuleDto,
  SubscriptionsResponse,
  UserDto,
  UserWithCompanyDto,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CompanyDto)]),
        () => ListBuilder<CompanyDto>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserDto)]),
        () => ListBuilder<UserDto>(),
      )
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
