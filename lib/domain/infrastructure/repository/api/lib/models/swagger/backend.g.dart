// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Backend _$$_BackendFromJson(Map<String, dynamic> json) => _$_Backend(
      openapi: json['openapi'] as String,
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      paths: Paths.fromJson(json['paths'] as Map<String, dynamic>),
      components:
          Components.fromJson(json['components'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_BackendToJson(_$_Backend instance) =>
    <String, dynamic>{
      'openapi': instance.openapi,
      'info': instance.info,
      'paths': instance.paths,
      'components': instance.components,
    };

_$_Components _$$_ComponentsFromJson(Map<String, dynamic> json) =>
    _$_Components(
      schemas: Schemas.fromJson(json['schemas'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ComponentsToJson(_$_Components instance) =>
    <String, dynamic>{
      'schemas': instance.schemas,
    };

_$_Schemas _$$_SchemasFromJson(Map<String, dynamic> json) => _$_Schemas(
      addressDto:
          AddressDto.fromJson(json['addressDto'] as Map<String, dynamic>),
      authenticateDto: AuthenticateDto.fromJson(
          json['authenticateDto'] as Map<String, dynamic>),
      bankDetailsDto: BankDetailsDto.fromJson(
          json['bankDetailsDto'] as Map<String, dynamic>),
      companySize:
          CompanySize.fromJson(json['companySize'] as Map<String, dynamic>),
      companyType:
          CompanySize.fromJson(json['companyType'] as Map<String, dynamic>),
      createCompanyDto: CreateCompanyDto.fromJson(
          json['createCompanyDto'] as Map<String, dynamic>),
      createProviderDto: CreateProviderDto.fromJson(
          json['createProviderDto'] as Map<String, dynamic>),
      forgotPasswordDto: ForgotPasswordDto.fromJson(
          json['forgotPasswordDto'] as Map<String, dynamic>),
      paymentInterval:
          CompanySize.fromJson(json['paymentInterval'] as Map<String, dynamic>),
      registerCompanyDto: RegisterCompanyDto.fromJson(
          json['registerCompanyDto'] as Map<String, dynamic>),
      resetPasswordDto: ResetPasswordDto.fromJson(
          json['resetPasswordDto'] as Map<String, dynamic>),
      roles: CompanySize.fromJson(json['roles'] as Map<String, dynamic>),
      userDto: UserDto.fromJson(json['userDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_SchemasToJson(_$_Schemas instance) =>
    <String, dynamic>{
      'addressDto': instance.addressDto,
      'authenticateDto': instance.authenticateDto,
      'bankDetailsDto': instance.bankDetailsDto,
      'companySize': instance.companySize,
      'companyType': instance.companyType,
      'createCompanyDto': instance.createCompanyDto,
      'createProviderDto': instance.createProviderDto,
      'forgotPasswordDto': instance.forgotPasswordDto,
      'paymentInterval': instance.paymentInterval,
      'registerCompanyDto': instance.registerCompanyDto,
      'resetPasswordDto': instance.resetPasswordDto,
      'roles': instance.roles,
      'userDto': instance.userDto,
    };

_$_AddressDto _$$_AddressDtoFromJson(Map<String, dynamic> json) =>
    _$_AddressDto(
      type: json['type'] as String,
      properties: AddressDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_AddressDtoToJson(_$_AddressDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_AddressDtoProperties _$$_AddressDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_AddressDtoProperties(
      country: City.fromJson(json['country'] as Map<String, dynamic>),
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      street: City.fromJson(json['street'] as Map<String, dynamic>),
      number: City.fromJson(json['number'] as Map<String, dynamic>),
      zip: City.fromJson(json['zip'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AddressDtoPropertiesToJson(
        _$_AddressDtoProperties instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'street': instance.street,
      'number': instance.number,
      'zip': instance.zip,
    };

_$_City _$$_CityFromJson(Map<String, dynamic> json) => _$_City(
      type: $enumDecode(_$TypeEnumMap, json['type']),
      nullable: json['nullable'] as bool,
    );

Map<String, dynamic> _$$_CityToJson(_$_City instance) => <String, dynamic>{
      'type': _$TypeEnumMap[instance.type],
      'nullable': instance.nullable,
    };

const _$TypeEnumMap = {
  Type.STRING: 'STRING',
};

_$_AuthenticateDto _$$_AuthenticateDtoFromJson(Map<String, dynamic> json) =>
    _$_AuthenticateDto(
      type: json['type'] as String,
      properties: AuthenticateDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_AuthenticateDtoToJson(_$_AuthenticateDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_AuthenticateDtoProperties _$$_AuthenticateDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_AuthenticateDtoProperties(
      email: City.fromJson(json['email'] as Map<String, dynamic>),
      password: City.fromJson(json['password'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthenticateDtoPropertiesToJson(
        _$_AuthenticateDtoProperties instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

_$_BankDetailsDto _$$_BankDetailsDtoFromJson(Map<String, dynamic> json) =>
    _$_BankDetailsDto(
      type: json['type'] as String,
      properties: BankDetailsDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_BankDetailsDtoToJson(_$_BankDetailsDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_BankDetailsDtoProperties _$$_BankDetailsDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_BankDetailsDtoProperties(
      iban: City.fromJson(json['iban'] as Map<String, dynamic>),
      bic: City.fromJson(json['bic'] as Map<String, dynamic>),
      accountOwner: City.fromJson(json['accountOwner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_BankDetailsDtoPropertiesToJson(
        _$_BankDetailsDtoProperties instance) =>
    <String, dynamic>{
      'iban': instance.iban,
      'bic': instance.bic,
      'accountOwner': instance.accountOwner,
    };

_$_CompanySize _$$_CompanySizeFromJson(Map<String, dynamic> json) =>
    _$_CompanySize(
      companySizeEnum: (json['companySizeEnum'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      type: json['type'] as String,
      format: json['format'] as String,
    );

Map<String, dynamic> _$$_CompanySizeToJson(_$_CompanySize instance) =>
    <String, dynamic>{
      'companySizeEnum': instance.companySizeEnum,
      'type': instance.type,
      'format': instance.format,
    };

_$_CreateCompanyDto _$$_CreateCompanyDtoFromJson(Map<String, dynamic> json) =>
    _$_CreateCompanyDto(
      type: json['type'] as String,
      properties: CreateCompanyDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_CreateCompanyDtoToJson(_$_CreateCompanyDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_CreateCompanyDtoProperties _$$_CreateCompanyDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_CreateCompanyDtoProperties(
      name: City.fromJson(json['name'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      uidNr: City.fromJson(json['uidNr'] as Map<String, dynamic>),
      registrationNr:
          City.fromJson(json['registrationNr'] as Map<String, dynamic>),
      companySize:
          Address.fromJson(json['companySize'] as Map<String, dynamic>),
      type: Address.fromJson(json['type'] as Map<String, dynamic>),
      websiteUrl: City.fromJson(json['websiteUrl'] as Map<String, dynamic>),
      providerData:
          Address.fromJson(json['providerData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CreateCompanyDtoPropertiesToJson(
        _$_CreateCompanyDtoProperties instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'uidNr': instance.uidNr,
      'registrationNr': instance.registrationNr,
      'companySize': instance.companySize,
      'type': instance.type,
      'websiteUrl': instance.websiteUrl,
      'providerData': instance.providerData,
    };

_$_Address _$$_AddressFromJson(Map<String, dynamic> json) => _$_Address(
      ref: json['ref'] as String,
    );

Map<String, dynamic> _$$_AddressToJson(_$_Address instance) =>
    <String, dynamic>{
      'ref': instance.ref,
    };

_$_CreateProviderDto _$$_CreateProviderDtoFromJson(Map<String, dynamic> json) =>
    _$_CreateProviderDto(
      type: json['type'] as String,
      properties: CreateProviderDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_CreateProviderDtoToJson(
        _$_CreateProviderDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_CreateProviderDtoProperties _$$_CreateProviderDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_CreateProviderDtoProperties(
      bankDetails:
          Address.fromJson(json['bankDetails'] as Map<String, dynamic>),
      branchIds: BranchIds.fromJson(json['branchIds'] as Map<String, dynamic>),
      paymentInterval:
          Address.fromJson(json['paymentInterval'] as Map<String, dynamic>),
      subscriptionPlanId: SubscriptionPlanId.fromJson(
          json['subscriptionPlanId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CreateProviderDtoPropertiesToJson(
        _$_CreateProviderDtoProperties instance) =>
    <String, dynamic>{
      'bankDetails': instance.bankDetails,
      'branchIds': instance.branchIds,
      'paymentInterval': instance.paymentInterval,
      'subscriptionPlanId': instance.subscriptionPlanId,
    };

_$_BranchIds _$$_BranchIdsFromJson(Map<String, dynamic> json) => _$_BranchIds(
      type: json['type'] as String,
      items: SubscriptionPlanId.fromJson(json['items'] as Map<String, dynamic>),
      nullable: json['nullable'] as bool,
    );

Map<String, dynamic> _$$_BranchIdsToJson(_$_BranchIds instance) =>
    <String, dynamic>{
      'type': instance.type,
      'items': instance.items,
      'nullable': instance.nullable,
    };

_$_SubscriptionPlanId _$$_SubscriptionPlanIdFromJson(
        Map<String, dynamic> json) =>
    _$_SubscriptionPlanId(
      type: $enumDecode(_$TypeEnumMap, json['type']),
      format: json['format'] as String,
    );

Map<String, dynamic> _$$_SubscriptionPlanIdToJson(
        _$_SubscriptionPlanId instance) =>
    <String, dynamic>{
      'type': _$TypeEnumMap[instance.type],
      'format': instance.format,
    };

_$_ForgotPasswordDto _$$_ForgotPasswordDtoFromJson(Map<String, dynamic> json) =>
    _$_ForgotPasswordDto(
      type: json['type'] as String,
      properties: ForgotPasswordDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_ForgotPasswordDtoToJson(
        _$_ForgotPasswordDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_ForgotPasswordDtoProperties _$$_ForgotPasswordDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_ForgotPasswordDtoProperties(
      email: City.fromJson(json['email'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ForgotPasswordDtoPropertiesToJson(
        _$_ForgotPasswordDtoProperties instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

_$_RegisterCompanyDto _$$_RegisterCompanyDtoFromJson(
        Map<String, dynamic> json) =>
    _$_RegisterCompanyDto(
      type: json['type'] as String,
      properties: RegisterCompanyDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_RegisterCompanyDtoToJson(
        _$_RegisterCompanyDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_RegisterCompanyDtoProperties _$$_RegisterCompanyDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_RegisterCompanyDtoProperties(
      company: Address.fromJson(json['company'] as Map<String, dynamic>),
      users: Users.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RegisterCompanyDtoPropertiesToJson(
        _$_RegisterCompanyDtoProperties instance) =>
    <String, dynamic>{
      'company': instance.company,
      'users': instance.users,
    };

_$_Users _$$_UsersFromJson(Map<String, dynamic> json) => _$_Users(
      type: json['type'] as String,
      items: Address.fromJson(json['items'] as Map<String, dynamic>),
      nullable: json['nullable'] as bool,
    );

Map<String, dynamic> _$$_UsersToJson(_$_Users instance) => <String, dynamic>{
      'type': instance.type,
      'items': instance.items,
      'nullable': instance.nullable,
    };

_$_ResetPasswordDto _$$_ResetPasswordDtoFromJson(Map<String, dynamic> json) =>
    _$_ResetPasswordDto(
      required:
          (json['required'] as List<dynamic>).map((e) => e as String).toList(),
      type: json['type'] as String,
      properties: ResetPasswordDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_ResetPasswordDtoToJson(_$_ResetPasswordDto instance) =>
    <String, dynamic>{
      'required': instance.required,
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_ResetPasswordDtoProperties _$$_ResetPasswordDtoPropertiesFromJson(
        Map<String, dynamic> json) =>
    _$_ResetPasswordDtoProperties(
      password: Password.fromJson(json['password'] as Map<String, dynamic>),
      confirmPassword: ConfirmPassword.fromJson(
          json['confirmPassword'] as Map<String, dynamic>),
      email: City.fromJson(json['email'] as Map<String, dynamic>),
      token: City.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ResetPasswordDtoPropertiesToJson(
        _$_ResetPasswordDtoProperties instance) =>
    <String, dynamic>{
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'email': instance.email,
      'token': instance.token,
    };

_$_ConfirmPassword _$$_ConfirmPasswordFromJson(Map<String, dynamic> json) =>
    _$_ConfirmPassword(
      maxLength: json['maxLength'] as int,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      nullable: json['nullable'] as bool,
    );

Map<String, dynamic> _$$_ConfirmPasswordToJson(_$_ConfirmPassword instance) =>
    <String, dynamic>{
      'maxLength': instance.maxLength,
      'type': _$TypeEnumMap[instance.type],
      'nullable': instance.nullable,
    };

_$_Password _$$_PasswordFromJson(Map<String, dynamic> json) => _$_Password(
      maxLength: json['maxLength'] as int,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      format: json['format'] as String,
    );

Map<String, dynamic> _$$_PasswordToJson(_$_Password instance) =>
    <String, dynamic>{
      'maxLength': instance.maxLength,
      'type': _$TypeEnumMap[instance.type],
      'format': instance.format,
    };

_$_UserDto _$$_UserDtoFromJson(Map<String, dynamic> json) => _$_UserDto(
      type: json['type'] as String,
      properties: UserDtoProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      additionalProperties: json['additionalProperties'] as bool,
    );

Map<String, dynamic> _$$_UserDtoToJson(_$_UserDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'additionalProperties': instance.additionalProperties,
    };

_$_UserDtoProperties _$$_UserDtoPropertiesFromJson(Map<String, dynamic> json) =>
    _$_UserDtoProperties(
      email: City.fromJson(json['email'] as Map<String, dynamic>),
      firstName: City.fromJson(json['firstName'] as Map<String, dynamic>),
      lastName: City.fromJson(json['lastName'] as Map<String, dynamic>),
      salutation: City.fromJson(json['salutation'] as Map<String, dynamic>),
      roles: Users.fromJson(json['roles'] as Map<String, dynamic>),
      telephoneNr: City.fromJson(json['telephoneNr'] as Map<String, dynamic>),
      title: City.fromJson(json['title'] as Map<String, dynamic>),
      companyId: CompanyId.fromJson(json['companyId'] as Map<String, dynamic>),
      id: SubscriptionPlanId.fromJson(json['id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserDtoPropertiesToJson(
        _$_UserDtoProperties instance) =>
    <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'salutation': instance.salutation,
      'roles': instance.roles,
      'telephoneNr': instance.telephoneNr,
      'title': instance.title,
      'companyId': instance.companyId,
      'id': instance.id,
    };

_$_CompanyId _$$_CompanyIdFromJson(Map<String, dynamic> json) => _$_CompanyId(
      type: $enumDecode(_$TypeEnumMap, json['type']),
      format: json['format'] as String,
      nullable: json['nullable'] as bool,
    );

Map<String, dynamic> _$$_CompanyIdToJson(_$_CompanyId instance) =>
    <String, dynamic>{
      'type': _$TypeEnumMap[instance.type],
      'format': instance.format,
      'nullable': instance.nullable,
    };

_$_Info _$$_InfoFromJson(Map<String, dynamic> json) => _$_Info(
      title: json['title'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$$_InfoToJson(_$_Info instance) => <String, dynamic>{
      'title': instance.title,
      'version': instance.version,
    };

_$_Paths _$$_PathsFromJson(Map<String, dynamic> json) => _$_Paths(
      authForgotPassword: CompaniesCompanyIdRegisterUser.fromJson(
          json['authForgotPassword'] as Map<String, dynamic>),
      authConfirmEmail: AuthConfirmEmail.fromJson(
          json['authConfirmEmail'] as Map<String, dynamic>),
      authResetPassword: CompaniesCompanyIdRegisterUser.fromJson(
          json['authResetPassword'] as Map<String, dynamic>),
      authLogin: CompaniesCompanyIdRegisterUser.fromJson(
          json['authLogin'] as Map<String, dynamic>),
      companiesRegister: CompaniesRegister.fromJson(
          json['companiesRegister'] as Map<String, dynamic>),
      companiesCompanyIdUsers: CompaniesCompanyIdUsers.fromJson(
          json['companiesCompanyIdUsers'] as Map<String, dynamic>),
      companiesCompanyIdUsersUserId: CompaniesCompanyIdUsersUserId.fromJson(
          json['companiesCompanyIdUsersUserId'] as Map<String, dynamic>),
      companiesCompanyIdRegisterUser: CompaniesCompanyIdRegisterUser.fromJson(
          json['companiesCompanyIdRegisterUser'] as Map<String, dynamic>),
      companiesCompanyIdUsersUserIdUpdate:
          CompaniesCompanyIdUsersUserIdUpdate.fromJson(
              json['companiesCompanyIdUsersUserIdUpdate']
                  as Map<String, dynamic>),
      companies: Companies.fromJson(json['companies'] as Map<String, dynamic>),
      companiesCompanyId: CompaniesCompanyId.fromJson(
          json['companiesCompanyId'] as Map<String, dynamic>),
      subscriptions:
          Companies.fromJson(json['subscriptions'] as Map<String, dynamic>),
      usersLoadUserWithCompany: CompaniesCompanyId.fromJson(
          json['usersLoadUserWithCompany'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PathsToJson(_$_Paths instance) => <String, dynamic>{
      'authForgotPassword': instance.authForgotPassword,
      'authConfirmEmail': instance.authConfirmEmail,
      'authResetPassword': instance.authResetPassword,
      'authLogin': instance.authLogin,
      'companiesRegister': instance.companiesRegister,
      'companiesCompanyIdUsers': instance.companiesCompanyIdUsers,
      'companiesCompanyIdUsersUserId': instance.companiesCompanyIdUsersUserId,
      'companiesCompanyIdRegisterUser': instance.companiesCompanyIdRegisterUser,
      'companiesCompanyIdUsersUserIdUpdate':
          instance.companiesCompanyIdUsersUserIdUpdate,
      'companies': instance.companies,
      'companiesCompanyId': instance.companiesCompanyId,
      'subscriptions': instance.subscriptions,
      'usersLoadUserWithCompany': instance.usersLoadUserWithCompany,
    };

_$_AuthConfirmEmail _$$_AuthConfirmEmailFromJson(Map<String, dynamic> json) =>
    _$_AuthConfirmEmail(
      authConfirmEmailGet: AuthConfirmEmailGet.fromJson(
          json['authConfirmEmailGet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthConfirmEmailToJson(_$_AuthConfirmEmail instance) =>
    <String, dynamic>{
      'authConfirmEmailGet': instance.authConfirmEmailGet,
    };

_$_AuthConfirmEmailGet _$$_AuthConfirmEmailGetFromJson(
        Map<String, dynamic> json) =>
    _$_AuthConfirmEmailGet(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => PostParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthConfirmEmailGetToJson(
        _$_AuthConfirmEmailGet instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'parameters': instance.parameters,
      'responses': instance.responses,
    };

_$_PostParameter _$$_PostParameterFromJson(Map<String, dynamic> json) =>
    _$_PostParameter(
      name: json['name'] as String,
      parameterIn: json['parameterIn'] as String,
      required: json['required'] as bool,
      schema: Schema.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PostParameterToJson(_$_PostParameter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'parameterIn': instance.parameterIn,
      'required': instance.required,
      'schema': instance.schema,
    };

_$_Schema _$$_SchemaFromJson(Map<String, dynamic> json) => _$_Schema(
      type: $enumDecode(_$TypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$_SchemaToJson(_$_Schema instance) => <String, dynamic>{
      'type': _$TypeEnumMap[instance.type],
    };

_$_Responses _$$_ResponsesFromJson(Map<String, dynamic> json) => _$_Responses(
      the200: The200.fromJson(json['the200'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ResponsesToJson(_$_Responses instance) =>
    <String, dynamic>{
      'the200': instance.the200,
    };

_$_The200 _$$_The200FromJson(Map<String, dynamic> json) => _$_The200(
      description: $enumDecode(_$DescriptionEnumMap, json['description']),
    );

Map<String, dynamic> _$$_The200ToJson(_$_The200 instance) => <String, dynamic>{
      'description': _$DescriptionEnumMap[instance.description],
    };

const _$DescriptionEnumMap = {
  Description.SUCCESS: 'SUCCESS',
};

_$_CompaniesCompanyIdRegisterUser _$$_CompaniesCompanyIdRegisterUserFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesCompanyIdRegisterUser(
      post: GetClass.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesCompanyIdRegisterUserToJson(
        _$_CompaniesCompanyIdRegisterUser instance) =>
    <String, dynamic>{
      'post': instance.post,
    };

_$_GetClass _$$_GetClassFromJson(Map<String, dynamic> json) => _$_GetClass(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => PostParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestBody:
          GetRequestBody.fromJson(json['requestBody'] as Map<String, dynamic>),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GetClassToJson(_$_GetClass instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'parameters': instance.parameters,
      'requestBody': instance.requestBody,
      'responses': instance.responses,
    };

_$_GetRequestBody _$$_GetRequestBodyFromJson(Map<String, dynamic> json) =>
    _$_GetRequestBody(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GetRequestBodyToJson(_$_GetRequestBody instance) =>
    <String, dynamic>{
      'content': instance.content,
    };

_$_Content _$$_ContentFromJson(Map<String, dynamic> json) => _$_Content(
      contentApplicationJson:
          Json.fromJson(json['contentApplicationJson'] as Map<String, dynamic>),
      textJson: Json.fromJson(json['textJson'] as Map<String, dynamic>),
      applicationJson:
          Json.fromJson(json['applicationJson'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ContentToJson(_$_Content instance) =>
    <String, dynamic>{
      'contentApplicationJson': instance.contentApplicationJson,
      'textJson': instance.textJson,
      'applicationJson': instance.applicationJson,
    };

_$_Json _$$_JsonFromJson(Map<String, dynamic> json) => _$_Json(
      schema: Address.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_JsonToJson(_$_Json instance) => <String, dynamic>{
      'schema': instance.schema,
    };

_$_Companies _$$_CompaniesFromJson(Map<String, dynamic> json) => _$_Companies(
      companiesGet:
          CompaniesGet.fromJson(json['companiesGet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesToJson(_$_Companies instance) =>
    <String, dynamic>{
      'companiesGet': instance.companiesGet,
    };

_$_CompaniesGet _$$_CompaniesGetFromJson(Map<String, dynamic> json) =>
    _$_CompaniesGet(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesGetToJson(_$_CompaniesGet instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'responses': instance.responses,
    };

_$_CompaniesCompanyId _$$_CompaniesCompanyIdFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesCompanyId(
      companiesCompanyIdGet: CompaniesCompanyIdGet.fromJson(
          json['companiesCompanyIdGet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesCompanyIdToJson(
        _$_CompaniesCompanyId instance) =>
    <String, dynamic>{
      'companiesCompanyIdGet': instance.companiesCompanyIdGet,
    };

_$_CompaniesCompanyIdGet _$$_CompaniesCompanyIdGetFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesCompanyIdGet(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => DeleteParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesCompanyIdGetToJson(
        _$_CompaniesCompanyIdGet instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'parameters': instance.parameters,
      'responses': instance.responses,
    };

_$_DeleteParameter _$$_DeleteParameterFromJson(Map<String, dynamic> json) =>
    _$_DeleteParameter(
      name: json['name'] as String,
      parameterIn: json['parameterIn'] as String,
      required: json['required'] as bool,
      schema:
          SubscriptionPlanId.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DeleteParameterToJson(_$_DeleteParameter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'parameterIn': instance.parameterIn,
      'required': instance.required,
      'schema': instance.schema,
    };

_$_CompaniesCompanyIdUsers _$$_CompaniesCompanyIdUsersFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesCompanyIdUsers(
      companiesCompanyIdUsersGet: GetClass.fromJson(
          json['companiesCompanyIdUsersGet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesCompanyIdUsersToJson(
        _$_CompaniesCompanyIdUsers instance) =>
    <String, dynamic>{
      'companiesCompanyIdUsersGet': instance.companiesCompanyIdUsersGet,
    };

_$_CompaniesCompanyIdUsersUserId _$$_CompaniesCompanyIdUsersUserIdFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesCompanyIdUsersUserId(
      companiesCompanyIdUsersUserIdGet: Delete.fromJson(
          json['companiesCompanyIdUsersUserIdGet'] as Map<String, dynamic>),
      delete: Delete.fromJson(json['delete'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesCompanyIdUsersUserIdToJson(
        _$_CompaniesCompanyIdUsersUserId instance) =>
    <String, dynamic>{
      'companiesCompanyIdUsersUserIdGet':
          instance.companiesCompanyIdUsersUserIdGet,
      'delete': instance.delete,
    };

_$_Delete _$$_DeleteFromJson(Map<String, dynamic> json) => _$_Delete(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => DeleteParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
      requestBody:
          GetRequestBody.fromJson(json['requestBody'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DeleteToJson(_$_Delete instance) => <String, dynamic>{
      'tags': instance.tags,
      'parameters': instance.parameters,
      'responses': instance.responses,
      'requestBody': instance.requestBody,
    };

_$_CompaniesCompanyIdUsersUserIdUpdate
    _$$_CompaniesCompanyIdUsersUserIdUpdateFromJson(
            Map<String, dynamic> json) =>
        _$_CompaniesCompanyIdUsersUserIdUpdate(
          put: Delete.fromJson(json['put'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$_CompaniesCompanyIdUsersUserIdUpdateToJson(
        _$_CompaniesCompanyIdUsersUserIdUpdate instance) =>
    <String, dynamic>{
      'put': instance.put,
    };

_$_CompaniesRegister _$$_CompaniesRegisterFromJson(Map<String, dynamic> json) =>
    _$_CompaniesRegister(
      post:
          CompaniesRegisterPost.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesRegisterToJson(
        _$_CompaniesRegister instance) =>
    <String, dynamic>{
      'post': instance.post,
    };

_$_CompaniesRegisterPost _$$_CompaniesRegisterPostFromJson(
        Map<String, dynamic> json) =>
    _$_CompaniesRegisterPost(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      requestBody: PurpleRequestBody.fromJson(
          json['requestBody'] as Map<String, dynamic>),
      responses: Responses.fromJson(json['responses'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CompaniesRegisterPostToJson(
        _$_CompaniesRegisterPost instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'requestBody': instance.requestBody,
      'responses': instance.responses,
    };

_$_PurpleRequestBody _$$_PurpleRequestBodyFromJson(Map<String, dynamic> json) =>
    _$_PurpleRequestBody(
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      required: json['required'] as bool,
    );

Map<String, dynamic> _$$_PurpleRequestBodyToJson(
        _$_PurpleRequestBody instance) =>
    <String, dynamic>{
      'content': instance.content,
      'required': instance.required,
    };
