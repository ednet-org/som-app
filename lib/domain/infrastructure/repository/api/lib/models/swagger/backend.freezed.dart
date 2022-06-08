// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'backend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Backend _$BackendFromJson(Map<String, dynamic> json) {
  return _Backend.fromJson(json);
}

/// @nodoc
mixin _$Backend {
  String get openapi => throw _privateConstructorUsedError;
  Info get info => throw _privateConstructorUsedError;
  Paths get paths => throw _privateConstructorUsedError;
  Components get components => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BackendCopyWith<Backend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendCopyWith<$Res> {
  factory $BackendCopyWith(Backend value, $Res Function(Backend) then) =
      _$BackendCopyWithImpl<$Res>;
  $Res call({String openapi, Info info, Paths paths, Components components});

  $InfoCopyWith<$Res> get info;
  $PathsCopyWith<$Res> get paths;
  $ComponentsCopyWith<$Res> get components;
}

/// @nodoc
class _$BackendCopyWithImpl<$Res> implements $BackendCopyWith<$Res> {
  _$BackendCopyWithImpl(this._value, this._then);

  final Backend _value;
  // ignore: unused_field
  final $Res Function(Backend) _then;

  @override
  $Res call({
    Object? openapi = freezed,
    Object? info = freezed,
    Object? paths = freezed,
    Object? components = freezed,
  }) {
    return _then(_value.copyWith(
      openapi: openapi == freezed
          ? _value.openapi
          : openapi // ignore: cast_nullable_to_non_nullable
              as String,
      info: info == freezed
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as Info,
      paths: paths == freezed
          ? _value.paths
          : paths // ignore: cast_nullable_to_non_nullable
              as Paths,
      components: components == freezed
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as Components,
    ));
  }

  @override
  $InfoCopyWith<$Res> get info {
    return $InfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }

  @override
  $PathsCopyWith<$Res> get paths {
    return $PathsCopyWith<$Res>(_value.paths, (value) {
      return _then(_value.copyWith(paths: value));
    });
  }

  @override
  $ComponentsCopyWith<$Res> get components {
    return $ComponentsCopyWith<$Res>(_value.components, (value) {
      return _then(_value.copyWith(components: value));
    });
  }
}

/// @nodoc
abstract class _$$_BackendCopyWith<$Res> implements $BackendCopyWith<$Res> {
  factory _$$_BackendCopyWith(
          _$_Backend value, $Res Function(_$_Backend) then) =
      __$$_BackendCopyWithImpl<$Res>;
  @override
  $Res call({String openapi, Info info, Paths paths, Components components});

  @override
  $InfoCopyWith<$Res> get info;
  @override
  $PathsCopyWith<$Res> get paths;
  @override
  $ComponentsCopyWith<$Res> get components;
}

/// @nodoc
class __$$_BackendCopyWithImpl<$Res> extends _$BackendCopyWithImpl<$Res>
    implements _$$_BackendCopyWith<$Res> {
  __$$_BackendCopyWithImpl(_$_Backend _value, $Res Function(_$_Backend) _then)
      : super(_value, (v) => _then(v as _$_Backend));

  @override
  _$_Backend get _value => super._value as _$_Backend;

  @override
  $Res call({
    Object? openapi = freezed,
    Object? info = freezed,
    Object? paths = freezed,
    Object? components = freezed,
  }) {
    return _then(_$_Backend(
      openapi: openapi == freezed
          ? _value.openapi
          : openapi // ignore: cast_nullable_to_non_nullable
              as String,
      info: info == freezed
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as Info,
      paths: paths == freezed
          ? _value.paths
          : paths // ignore: cast_nullable_to_non_nullable
              as Paths,
      components: components == freezed
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as Components,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Backend implements _Backend {
  const _$_Backend(
      {required this.openapi,
      required this.info,
      required this.paths,
      required this.components});

  factory _$_Backend.fromJson(Map<String, dynamic> json) =>
      _$$_BackendFromJson(json);

  @override
  final String openapi;
  @override
  final Info info;
  @override
  final Paths paths;
  @override
  final Components components;

  @override
  String toString() {
    return 'Backend(openapi: $openapi, info: $info, paths: $paths, components: $components)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Backend &&
            const DeepCollectionEquality().equals(other.openapi, openapi) &&
            const DeepCollectionEquality().equals(other.info, info) &&
            const DeepCollectionEquality().equals(other.paths, paths) &&
            const DeepCollectionEquality()
                .equals(other.components, components));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(openapi),
      const DeepCollectionEquality().hash(info),
      const DeepCollectionEquality().hash(paths),
      const DeepCollectionEquality().hash(components));

  @JsonKey(ignore: true)
  @override
  _$$_BackendCopyWith<_$_Backend> get copyWith =>
      __$$_BackendCopyWithImpl<_$_Backend>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BackendToJson(this);
  }
}

abstract class _Backend implements Backend {
  const factory _Backend(
      {required final String openapi,
      required final Info info,
      required final Paths paths,
      required final Components components}) = _$_Backend;

  factory _Backend.fromJson(Map<String, dynamic> json) = _$_Backend.fromJson;

  @override
  String get openapi => throw _privateConstructorUsedError;
  @override
  Info get info => throw _privateConstructorUsedError;
  @override
  Paths get paths => throw _privateConstructorUsedError;
  @override
  Components get components => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BackendCopyWith<_$_Backend> get copyWith =>
      throw _privateConstructorUsedError;
}

Components _$ComponentsFromJson(Map<String, dynamic> json) {
  return _Components.fromJson(json);
}

/// @nodoc
mixin _$Components {
  Schemas get schemas => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComponentsCopyWith<Components> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComponentsCopyWith<$Res> {
  factory $ComponentsCopyWith(
          Components value, $Res Function(Components) then) =
      _$ComponentsCopyWithImpl<$Res>;
  $Res call({Schemas schemas});

  $SchemasCopyWith<$Res> get schemas;
}

/// @nodoc
class _$ComponentsCopyWithImpl<$Res> implements $ComponentsCopyWith<$Res> {
  _$ComponentsCopyWithImpl(this._value, this._then);

  final Components _value;
  // ignore: unused_field
  final $Res Function(Components) _then;

  @override
  $Res call({
    Object? schemas = freezed,
  }) {
    return _then(_value.copyWith(
      schemas: schemas == freezed
          ? _value.schemas
          : schemas // ignore: cast_nullable_to_non_nullable
              as Schemas,
    ));
  }

  @override
  $SchemasCopyWith<$Res> get schemas {
    return $SchemasCopyWith<$Res>(_value.schemas, (value) {
      return _then(_value.copyWith(schemas: value));
    });
  }
}

/// @nodoc
abstract class _$$_ComponentsCopyWith<$Res>
    implements $ComponentsCopyWith<$Res> {
  factory _$$_ComponentsCopyWith(
          _$_Components value, $Res Function(_$_Components) then) =
      __$$_ComponentsCopyWithImpl<$Res>;
  @override
  $Res call({Schemas schemas});

  @override
  $SchemasCopyWith<$Res> get schemas;
}

/// @nodoc
class __$$_ComponentsCopyWithImpl<$Res> extends _$ComponentsCopyWithImpl<$Res>
    implements _$$_ComponentsCopyWith<$Res> {
  __$$_ComponentsCopyWithImpl(
      _$_Components _value, $Res Function(_$_Components) _then)
      : super(_value, (v) => _then(v as _$_Components));

  @override
  _$_Components get _value => super._value as _$_Components;

  @override
  $Res call({
    Object? schemas = freezed,
  }) {
    return _then(_$_Components(
      schemas: schemas == freezed
          ? _value.schemas
          : schemas // ignore: cast_nullable_to_non_nullable
              as Schemas,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Components implements _Components {
  const _$_Components({required this.schemas});

  factory _$_Components.fromJson(Map<String, dynamic> json) =>
      _$$_ComponentsFromJson(json);

  @override
  final Schemas schemas;

  @override
  String toString() {
    return 'Components(schemas: $schemas)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Components &&
            const DeepCollectionEquality().equals(other.schemas, schemas));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(schemas));

  @JsonKey(ignore: true)
  @override
  _$$_ComponentsCopyWith<_$_Components> get copyWith =>
      __$$_ComponentsCopyWithImpl<_$_Components>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ComponentsToJson(this);
  }
}

abstract class _Components implements Components {
  const factory _Components({required final Schemas schemas}) = _$_Components;

  factory _Components.fromJson(Map<String, dynamic> json) =
      _$_Components.fromJson;

  @override
  Schemas get schemas => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ComponentsCopyWith<_$_Components> get copyWith =>
      throw _privateConstructorUsedError;
}

Schemas _$SchemasFromJson(Map<String, dynamic> json) {
  return _Schemas.fromJson(json);
}

/// @nodoc
mixin _$Schemas {
  AddressDto get addressDto => throw _privateConstructorUsedError;
  AuthenticateDto get authenticateDto => throw _privateConstructorUsedError;
  BankDetailsDto get bankDetailsDto => throw _privateConstructorUsedError;
  CompanySize get companySize => throw _privateConstructorUsedError;
  CompanySize get companyType => throw _privateConstructorUsedError;
  CreateCompanyDto get createCompanyDto => throw _privateConstructorUsedError;
  CreateProviderDto get createProviderDto => throw _privateConstructorUsedError;
  ForgotPasswordDto get forgotPasswordDto => throw _privateConstructorUsedError;
  CompanySize get paymentInterval => throw _privateConstructorUsedError;
  RegisterCompanyDto get registerCompanyDto =>
      throw _privateConstructorUsedError;
  ResetPasswordDto get resetPasswordDto => throw _privateConstructorUsedError;
  CompanySize get roles => throw _privateConstructorUsedError;
  UserDto get userDto => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchemasCopyWith<Schemas> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemasCopyWith<$Res> {
  factory $SchemasCopyWith(Schemas value, $Res Function(Schemas) then) =
      _$SchemasCopyWithImpl<$Res>;
  $Res call(
      {AddressDto addressDto,
      AuthenticateDto authenticateDto,
      BankDetailsDto bankDetailsDto,
      CompanySize companySize,
      CompanySize companyType,
      CreateCompanyDto createCompanyDto,
      CreateProviderDto createProviderDto,
      ForgotPasswordDto forgotPasswordDto,
      CompanySize paymentInterval,
      RegisterCompanyDto registerCompanyDto,
      ResetPasswordDto resetPasswordDto,
      CompanySize roles,
      UserDto userDto});

  $AddressDtoCopyWith<$Res> get addressDto;
  $AuthenticateDtoCopyWith<$Res> get authenticateDto;
  $BankDetailsDtoCopyWith<$Res> get bankDetailsDto;
  $CompanySizeCopyWith<$Res> get companySize;
  $CompanySizeCopyWith<$Res> get companyType;
  $CreateCompanyDtoCopyWith<$Res> get createCompanyDto;
  $CreateProviderDtoCopyWith<$Res> get createProviderDto;
  $ForgotPasswordDtoCopyWith<$Res> get forgotPasswordDto;
  $CompanySizeCopyWith<$Res> get paymentInterval;
  $RegisterCompanyDtoCopyWith<$Res> get registerCompanyDto;
  $ResetPasswordDtoCopyWith<$Res> get resetPasswordDto;
  $CompanySizeCopyWith<$Res> get roles;
  $UserDtoCopyWith<$Res> get userDto;
}

/// @nodoc
class _$SchemasCopyWithImpl<$Res> implements $SchemasCopyWith<$Res> {
  _$SchemasCopyWithImpl(this._value, this._then);

  final Schemas _value;
  // ignore: unused_field
  final $Res Function(Schemas) _then;

  @override
  $Res call({
    Object? addressDto = freezed,
    Object? authenticateDto = freezed,
    Object? bankDetailsDto = freezed,
    Object? companySize = freezed,
    Object? companyType = freezed,
    Object? createCompanyDto = freezed,
    Object? createProviderDto = freezed,
    Object? forgotPasswordDto = freezed,
    Object? paymentInterval = freezed,
    Object? registerCompanyDto = freezed,
    Object? resetPasswordDto = freezed,
    Object? roles = freezed,
    Object? userDto = freezed,
  }) {
    return _then(_value.copyWith(
      addressDto: addressDto == freezed
          ? _value.addressDto
          : addressDto // ignore: cast_nullable_to_non_nullable
              as AddressDto,
      authenticateDto: authenticateDto == freezed
          ? _value.authenticateDto
          : authenticateDto // ignore: cast_nullable_to_non_nullable
              as AuthenticateDto,
      bankDetailsDto: bankDetailsDto == freezed
          ? _value.bankDetailsDto
          : bankDetailsDto // ignore: cast_nullable_to_non_nullable
              as BankDetailsDto,
      companySize: companySize == freezed
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      companyType: companyType == freezed
          ? _value.companyType
          : companyType // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      createCompanyDto: createCompanyDto == freezed
          ? _value.createCompanyDto
          : createCompanyDto // ignore: cast_nullable_to_non_nullable
              as CreateCompanyDto,
      createProviderDto: createProviderDto == freezed
          ? _value.createProviderDto
          : createProviderDto // ignore: cast_nullable_to_non_nullable
              as CreateProviderDto,
      forgotPasswordDto: forgotPasswordDto == freezed
          ? _value.forgotPasswordDto
          : forgotPasswordDto // ignore: cast_nullable_to_non_nullable
              as ForgotPasswordDto,
      paymentInterval: paymentInterval == freezed
          ? _value.paymentInterval
          : paymentInterval // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      registerCompanyDto: registerCompanyDto == freezed
          ? _value.registerCompanyDto
          : registerCompanyDto // ignore: cast_nullable_to_non_nullable
              as RegisterCompanyDto,
      resetPasswordDto: resetPasswordDto == freezed
          ? _value.resetPasswordDto
          : resetPasswordDto // ignore: cast_nullable_to_non_nullable
              as ResetPasswordDto,
      roles: roles == freezed
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      userDto: userDto == freezed
          ? _value.userDto
          : userDto // ignore: cast_nullable_to_non_nullable
              as UserDto,
    ));
  }

  @override
  $AddressDtoCopyWith<$Res> get addressDto {
    return $AddressDtoCopyWith<$Res>(_value.addressDto, (value) {
      return _then(_value.copyWith(addressDto: value));
    });
  }

  @override
  $AuthenticateDtoCopyWith<$Res> get authenticateDto {
    return $AuthenticateDtoCopyWith<$Res>(_value.authenticateDto, (value) {
      return _then(_value.copyWith(authenticateDto: value));
    });
  }

  @override
  $BankDetailsDtoCopyWith<$Res> get bankDetailsDto {
    return $BankDetailsDtoCopyWith<$Res>(_value.bankDetailsDto, (value) {
      return _then(_value.copyWith(bankDetailsDto: value));
    });
  }

  @override
  $CompanySizeCopyWith<$Res> get companySize {
    return $CompanySizeCopyWith<$Res>(_value.companySize, (value) {
      return _then(_value.copyWith(companySize: value));
    });
  }

  @override
  $CompanySizeCopyWith<$Res> get companyType {
    return $CompanySizeCopyWith<$Res>(_value.companyType, (value) {
      return _then(_value.copyWith(companyType: value));
    });
  }

  @override
  $CreateCompanyDtoCopyWith<$Res> get createCompanyDto {
    return $CreateCompanyDtoCopyWith<$Res>(_value.createCompanyDto, (value) {
      return _then(_value.copyWith(createCompanyDto: value));
    });
  }

  @override
  $CreateProviderDtoCopyWith<$Res> get createProviderDto {
    return $CreateProviderDtoCopyWith<$Res>(_value.createProviderDto, (value) {
      return _then(_value.copyWith(createProviderDto: value));
    });
  }

  @override
  $ForgotPasswordDtoCopyWith<$Res> get forgotPasswordDto {
    return $ForgotPasswordDtoCopyWith<$Res>(_value.forgotPasswordDto, (value) {
      return _then(_value.copyWith(forgotPasswordDto: value));
    });
  }

  @override
  $CompanySizeCopyWith<$Res> get paymentInterval {
    return $CompanySizeCopyWith<$Res>(_value.paymentInterval, (value) {
      return _then(_value.copyWith(paymentInterval: value));
    });
  }

  @override
  $RegisterCompanyDtoCopyWith<$Res> get registerCompanyDto {
    return $RegisterCompanyDtoCopyWith<$Res>(_value.registerCompanyDto,
        (value) {
      return _then(_value.copyWith(registerCompanyDto: value));
    });
  }

  @override
  $ResetPasswordDtoCopyWith<$Res> get resetPasswordDto {
    return $ResetPasswordDtoCopyWith<$Res>(_value.resetPasswordDto, (value) {
      return _then(_value.copyWith(resetPasswordDto: value));
    });
  }

  @override
  $CompanySizeCopyWith<$Res> get roles {
    return $CompanySizeCopyWith<$Res>(_value.roles, (value) {
      return _then(_value.copyWith(roles: value));
    });
  }

  @override
  $UserDtoCopyWith<$Res> get userDto {
    return $UserDtoCopyWith<$Res>(_value.userDto, (value) {
      return _then(_value.copyWith(userDto: value));
    });
  }
}

/// @nodoc
abstract class _$$_SchemasCopyWith<$Res> implements $SchemasCopyWith<$Res> {
  factory _$$_SchemasCopyWith(
          _$_Schemas value, $Res Function(_$_Schemas) then) =
      __$$_SchemasCopyWithImpl<$Res>;
  @override
  $Res call(
      {AddressDto addressDto,
      AuthenticateDto authenticateDto,
      BankDetailsDto bankDetailsDto,
      CompanySize companySize,
      CompanySize companyType,
      CreateCompanyDto createCompanyDto,
      CreateProviderDto createProviderDto,
      ForgotPasswordDto forgotPasswordDto,
      CompanySize paymentInterval,
      RegisterCompanyDto registerCompanyDto,
      ResetPasswordDto resetPasswordDto,
      CompanySize roles,
      UserDto userDto});

  @override
  $AddressDtoCopyWith<$Res> get addressDto;
  @override
  $AuthenticateDtoCopyWith<$Res> get authenticateDto;
  @override
  $BankDetailsDtoCopyWith<$Res> get bankDetailsDto;
  @override
  $CompanySizeCopyWith<$Res> get companySize;
  @override
  $CompanySizeCopyWith<$Res> get companyType;
  @override
  $CreateCompanyDtoCopyWith<$Res> get createCompanyDto;
  @override
  $CreateProviderDtoCopyWith<$Res> get createProviderDto;
  @override
  $ForgotPasswordDtoCopyWith<$Res> get forgotPasswordDto;
  @override
  $CompanySizeCopyWith<$Res> get paymentInterval;
  @override
  $RegisterCompanyDtoCopyWith<$Res> get registerCompanyDto;
  @override
  $ResetPasswordDtoCopyWith<$Res> get resetPasswordDto;
  @override
  $CompanySizeCopyWith<$Res> get roles;
  @override
  $UserDtoCopyWith<$Res> get userDto;
}

/// @nodoc
class __$$_SchemasCopyWithImpl<$Res> extends _$SchemasCopyWithImpl<$Res>
    implements _$$_SchemasCopyWith<$Res> {
  __$$_SchemasCopyWithImpl(_$_Schemas _value, $Res Function(_$_Schemas) _then)
      : super(_value, (v) => _then(v as _$_Schemas));

  @override
  _$_Schemas get _value => super._value as _$_Schemas;

  @override
  $Res call({
    Object? addressDto = freezed,
    Object? authenticateDto = freezed,
    Object? bankDetailsDto = freezed,
    Object? companySize = freezed,
    Object? companyType = freezed,
    Object? createCompanyDto = freezed,
    Object? createProviderDto = freezed,
    Object? forgotPasswordDto = freezed,
    Object? paymentInterval = freezed,
    Object? registerCompanyDto = freezed,
    Object? resetPasswordDto = freezed,
    Object? roles = freezed,
    Object? userDto = freezed,
  }) {
    return _then(_$_Schemas(
      addressDto: addressDto == freezed
          ? _value.addressDto
          : addressDto // ignore: cast_nullable_to_non_nullable
              as AddressDto,
      authenticateDto: authenticateDto == freezed
          ? _value.authenticateDto
          : authenticateDto // ignore: cast_nullable_to_non_nullable
              as AuthenticateDto,
      bankDetailsDto: bankDetailsDto == freezed
          ? _value.bankDetailsDto
          : bankDetailsDto // ignore: cast_nullable_to_non_nullable
              as BankDetailsDto,
      companySize: companySize == freezed
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      companyType: companyType == freezed
          ? _value.companyType
          : companyType // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      createCompanyDto: createCompanyDto == freezed
          ? _value.createCompanyDto
          : createCompanyDto // ignore: cast_nullable_to_non_nullable
              as CreateCompanyDto,
      createProviderDto: createProviderDto == freezed
          ? _value.createProviderDto
          : createProviderDto // ignore: cast_nullable_to_non_nullable
              as CreateProviderDto,
      forgotPasswordDto: forgotPasswordDto == freezed
          ? _value.forgotPasswordDto
          : forgotPasswordDto // ignore: cast_nullable_to_non_nullable
              as ForgotPasswordDto,
      paymentInterval: paymentInterval == freezed
          ? _value.paymentInterval
          : paymentInterval // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      registerCompanyDto: registerCompanyDto == freezed
          ? _value.registerCompanyDto
          : registerCompanyDto // ignore: cast_nullable_to_non_nullable
              as RegisterCompanyDto,
      resetPasswordDto: resetPasswordDto == freezed
          ? _value.resetPasswordDto
          : resetPasswordDto // ignore: cast_nullable_to_non_nullable
              as ResetPasswordDto,
      roles: roles == freezed
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as CompanySize,
      userDto: userDto == freezed
          ? _value.userDto
          : userDto // ignore: cast_nullable_to_non_nullable
              as UserDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Schemas implements _Schemas {
  const _$_Schemas(
      {required this.addressDto,
      required this.authenticateDto,
      required this.bankDetailsDto,
      required this.companySize,
      required this.companyType,
      required this.createCompanyDto,
      required this.createProviderDto,
      required this.forgotPasswordDto,
      required this.paymentInterval,
      required this.registerCompanyDto,
      required this.resetPasswordDto,
      required this.roles,
      required this.userDto});

  factory _$_Schemas.fromJson(Map<String, dynamic> json) =>
      _$$_SchemasFromJson(json);

  @override
  final AddressDto addressDto;
  @override
  final AuthenticateDto authenticateDto;
  @override
  final BankDetailsDto bankDetailsDto;
  @override
  final CompanySize companySize;
  @override
  final CompanySize companyType;
  @override
  final CreateCompanyDto createCompanyDto;
  @override
  final CreateProviderDto createProviderDto;
  @override
  final ForgotPasswordDto forgotPasswordDto;
  @override
  final CompanySize paymentInterval;
  @override
  final RegisterCompanyDto registerCompanyDto;
  @override
  final ResetPasswordDto resetPasswordDto;
  @override
  final CompanySize roles;
  @override
  final UserDto userDto;

  @override
  String toString() {
    return 'Schemas(addressDto: $addressDto, authenticateDto: $authenticateDto, bankDetailsDto: $bankDetailsDto, companySize: $companySize, companyType: $companyType, createCompanyDto: $createCompanyDto, createProviderDto: $createProviderDto, forgotPasswordDto: $forgotPasswordDto, paymentInterval: $paymentInterval, registerCompanyDto: $registerCompanyDto, resetPasswordDto: $resetPasswordDto, roles: $roles, userDto: $userDto)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Schemas &&
            const DeepCollectionEquality()
                .equals(other.addressDto, addressDto) &&
            const DeepCollectionEquality()
                .equals(other.authenticateDto, authenticateDto) &&
            const DeepCollectionEquality()
                .equals(other.bankDetailsDto, bankDetailsDto) &&
            const DeepCollectionEquality()
                .equals(other.companySize, companySize) &&
            const DeepCollectionEquality()
                .equals(other.companyType, companyType) &&
            const DeepCollectionEquality()
                .equals(other.createCompanyDto, createCompanyDto) &&
            const DeepCollectionEquality()
                .equals(other.createProviderDto, createProviderDto) &&
            const DeepCollectionEquality()
                .equals(other.forgotPasswordDto, forgotPasswordDto) &&
            const DeepCollectionEquality()
                .equals(other.paymentInterval, paymentInterval) &&
            const DeepCollectionEquality()
                .equals(other.registerCompanyDto, registerCompanyDto) &&
            const DeepCollectionEquality()
                .equals(other.resetPasswordDto, resetPasswordDto) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            const DeepCollectionEquality().equals(other.userDto, userDto));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(addressDto),
      const DeepCollectionEquality().hash(authenticateDto),
      const DeepCollectionEquality().hash(bankDetailsDto),
      const DeepCollectionEquality().hash(companySize),
      const DeepCollectionEquality().hash(companyType),
      const DeepCollectionEquality().hash(createCompanyDto),
      const DeepCollectionEquality().hash(createProviderDto),
      const DeepCollectionEquality().hash(forgotPasswordDto),
      const DeepCollectionEquality().hash(paymentInterval),
      const DeepCollectionEquality().hash(registerCompanyDto),
      const DeepCollectionEquality().hash(resetPasswordDto),
      const DeepCollectionEquality().hash(roles),
      const DeepCollectionEquality().hash(userDto));

  @JsonKey(ignore: true)
  @override
  _$$_SchemasCopyWith<_$_Schemas> get copyWith =>
      __$$_SchemasCopyWithImpl<_$_Schemas>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SchemasToJson(this);
  }
}

abstract class _Schemas implements Schemas {
  const factory _Schemas(
      {required final AddressDto addressDto,
      required final AuthenticateDto authenticateDto,
      required final BankDetailsDto bankDetailsDto,
      required final CompanySize companySize,
      required final CompanySize companyType,
      required final CreateCompanyDto createCompanyDto,
      required final CreateProviderDto createProviderDto,
      required final ForgotPasswordDto forgotPasswordDto,
      required final CompanySize paymentInterval,
      required final RegisterCompanyDto registerCompanyDto,
      required final ResetPasswordDto resetPasswordDto,
      required final CompanySize roles,
      required final UserDto userDto}) = _$_Schemas;

  factory _Schemas.fromJson(Map<String, dynamic> json) = _$_Schemas.fromJson;

  @override
  AddressDto get addressDto => throw _privateConstructorUsedError;
  @override
  AuthenticateDto get authenticateDto => throw _privateConstructorUsedError;
  @override
  BankDetailsDto get bankDetailsDto => throw _privateConstructorUsedError;
  @override
  CompanySize get companySize => throw _privateConstructorUsedError;
  @override
  CompanySize get companyType => throw _privateConstructorUsedError;
  @override
  CreateCompanyDto get createCompanyDto => throw _privateConstructorUsedError;
  @override
  CreateProviderDto get createProviderDto => throw _privateConstructorUsedError;
  @override
  ForgotPasswordDto get forgotPasswordDto => throw _privateConstructorUsedError;
  @override
  CompanySize get paymentInterval => throw _privateConstructorUsedError;
  @override
  RegisterCompanyDto get registerCompanyDto =>
      throw _privateConstructorUsedError;
  @override
  ResetPasswordDto get resetPasswordDto => throw _privateConstructorUsedError;
  @override
  CompanySize get roles => throw _privateConstructorUsedError;
  @override
  UserDto get userDto => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SchemasCopyWith<_$_Schemas> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) {
  return _AddressDto.fromJson(json);
}

/// @nodoc
mixin _$AddressDto {
  String get type => throw _privateConstructorUsedError;
  AddressDtoProperties get properties => throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressDtoCopyWith<AddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressDtoCopyWith<$Res> {
  factory $AddressDtoCopyWith(
          AddressDto value, $Res Function(AddressDto) then) =
      _$AddressDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      AddressDtoProperties properties,
      bool additionalProperties});

  $AddressDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$AddressDtoCopyWithImpl<$Res> implements $AddressDtoCopyWith<$Res> {
  _$AddressDtoCopyWithImpl(this._value, this._then);

  final AddressDto _value;
  // ignore: unused_field
  final $Res Function(AddressDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as AddressDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $AddressDtoPropertiesCopyWith<$Res> get properties {
    return $AddressDtoPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_AddressDtoCopyWith<$Res>
    implements $AddressDtoCopyWith<$Res> {
  factory _$$_AddressDtoCopyWith(
          _$_AddressDto value, $Res Function(_$_AddressDto) then) =
      __$$_AddressDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      AddressDtoProperties properties,
      bool additionalProperties});

  @override
  $AddressDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_AddressDtoCopyWithImpl<$Res> extends _$AddressDtoCopyWithImpl<$Res>
    implements _$$_AddressDtoCopyWith<$Res> {
  __$$_AddressDtoCopyWithImpl(
      _$_AddressDto _value, $Res Function(_$_AddressDto) _then)
      : super(_value, (v) => _then(v as _$_AddressDto));

  @override
  _$_AddressDto get _value => super._value as _$_AddressDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_AddressDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as AddressDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddressDto implements _AddressDto {
  const _$_AddressDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_AddressDto.fromJson(Map<String, dynamic> json) =>
      _$$_AddressDtoFromJson(json);

  @override
  final String type;
  @override
  final AddressDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'AddressDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddressDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_AddressDtoCopyWith<_$_AddressDto> get copyWith =>
      __$$_AddressDtoCopyWithImpl<_$_AddressDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressDtoToJson(this);
  }
}

abstract class _AddressDto implements AddressDto {
  const factory _AddressDto(
      {required final String type,
      required final AddressDtoProperties properties,
      required final bool additionalProperties}) = _$_AddressDto;

  factory _AddressDto.fromJson(Map<String, dynamic> json) =
      _$_AddressDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  AddressDtoProperties get properties => throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AddressDtoCopyWith<_$_AddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressDtoProperties _$AddressDtoPropertiesFromJson(Map<String, dynamic> json) {
  return _AddressDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$AddressDtoProperties {
  City get country => throw _privateConstructorUsedError;
  City get city => throw _privateConstructorUsedError;
  City get street => throw _privateConstructorUsedError;
  City get number => throw _privateConstructorUsedError;
  City get zip => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressDtoPropertiesCopyWith<AddressDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressDtoPropertiesCopyWith<$Res> {
  factory $AddressDtoPropertiesCopyWith(AddressDtoProperties value,
          $Res Function(AddressDtoProperties) then) =
      _$AddressDtoPropertiesCopyWithImpl<$Res>;
  $Res call({City country, City city, City street, City number, City zip});

  $CityCopyWith<$Res> get country;
  $CityCopyWith<$Res> get city;
  $CityCopyWith<$Res> get street;
  $CityCopyWith<$Res> get number;
  $CityCopyWith<$Res> get zip;
}

/// @nodoc
class _$AddressDtoPropertiesCopyWithImpl<$Res>
    implements $AddressDtoPropertiesCopyWith<$Res> {
  _$AddressDtoPropertiesCopyWithImpl(this._value, this._then);

  final AddressDtoProperties _value;
  // ignore: unused_field
  final $Res Function(AddressDtoProperties) _then;

  @override
  $Res call({
    Object? country = freezed,
    Object? city = freezed,
    Object? street = freezed,
    Object? number = freezed,
    Object? zip = freezed,
  }) {
    return _then(_value.copyWith(
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as City,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City,
      street: street == freezed
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as City,
      number: number == freezed
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as City,
      zip: zip == freezed
          ? _value.zip
          : zip // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }

  @override
  $CityCopyWith<$Res> get country {
    return $CityCopyWith<$Res>(_value.country, (value) {
      return _then(_value.copyWith(country: value));
    });
  }

  @override
  $CityCopyWith<$Res> get city {
    return $CityCopyWith<$Res>(_value.city, (value) {
      return _then(_value.copyWith(city: value));
    });
  }

  @override
  $CityCopyWith<$Res> get street {
    return $CityCopyWith<$Res>(_value.street, (value) {
      return _then(_value.copyWith(street: value));
    });
  }

  @override
  $CityCopyWith<$Res> get number {
    return $CityCopyWith<$Res>(_value.number, (value) {
      return _then(_value.copyWith(number: value));
    });
  }

  @override
  $CityCopyWith<$Res> get zip {
    return $CityCopyWith<$Res>(_value.zip, (value) {
      return _then(_value.copyWith(zip: value));
    });
  }
}

/// @nodoc
abstract class _$$_AddressDtoPropertiesCopyWith<$Res>
    implements $AddressDtoPropertiesCopyWith<$Res> {
  factory _$$_AddressDtoPropertiesCopyWith(_$_AddressDtoProperties value,
          $Res Function(_$_AddressDtoProperties) then) =
      __$$_AddressDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call({City country, City city, City street, City number, City zip});

  @override
  $CityCopyWith<$Res> get country;
  @override
  $CityCopyWith<$Res> get city;
  @override
  $CityCopyWith<$Res> get street;
  @override
  $CityCopyWith<$Res> get number;
  @override
  $CityCopyWith<$Res> get zip;
}

/// @nodoc
class __$$_AddressDtoPropertiesCopyWithImpl<$Res>
    extends _$AddressDtoPropertiesCopyWithImpl<$Res>
    implements _$$_AddressDtoPropertiesCopyWith<$Res> {
  __$$_AddressDtoPropertiesCopyWithImpl(_$_AddressDtoProperties _value,
      $Res Function(_$_AddressDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_AddressDtoProperties));

  @override
  _$_AddressDtoProperties get _value => super._value as _$_AddressDtoProperties;

  @override
  $Res call({
    Object? country = freezed,
    Object? city = freezed,
    Object? street = freezed,
    Object? number = freezed,
    Object? zip = freezed,
  }) {
    return _then(_$_AddressDtoProperties(
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as City,
      city: city == freezed
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City,
      street: street == freezed
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as City,
      number: number == freezed
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as City,
      zip: zip == freezed
          ? _value.zip
          : zip // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddressDtoProperties implements _AddressDtoProperties {
  const _$_AddressDtoProperties(
      {required this.country,
      required this.city,
      required this.street,
      required this.number,
      required this.zip});

  factory _$_AddressDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_AddressDtoPropertiesFromJson(json);

  @override
  final City country;
  @override
  final City city;
  @override
  final City street;
  @override
  final City number;
  @override
  final City zip;

  @override
  String toString() {
    return 'AddressDtoProperties(country: $country, city: $city, street: $street, number: $number, zip: $zip)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddressDtoProperties &&
            const DeepCollectionEquality().equals(other.country, country) &&
            const DeepCollectionEquality().equals(other.city, city) &&
            const DeepCollectionEquality().equals(other.street, street) &&
            const DeepCollectionEquality().equals(other.number, number) &&
            const DeepCollectionEquality().equals(other.zip, zip));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(country),
      const DeepCollectionEquality().hash(city),
      const DeepCollectionEquality().hash(street),
      const DeepCollectionEquality().hash(number),
      const DeepCollectionEquality().hash(zip));

  @JsonKey(ignore: true)
  @override
  _$$_AddressDtoPropertiesCopyWith<_$_AddressDtoProperties> get copyWith =>
      __$$_AddressDtoPropertiesCopyWithImpl<_$_AddressDtoProperties>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressDtoPropertiesToJson(this);
  }
}

abstract class _AddressDtoProperties implements AddressDtoProperties {
  const factory _AddressDtoProperties(
      {required final City country,
      required final City city,
      required final City street,
      required final City number,
      required final City zip}) = _$_AddressDtoProperties;

  factory _AddressDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_AddressDtoProperties.fromJson;

  @override
  City get country => throw _privateConstructorUsedError;
  @override
  City get city => throw _privateConstructorUsedError;
  @override
  City get street => throw _privateConstructorUsedError;
  @override
  City get number => throw _privateConstructorUsedError;
  @override
  City get zip => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AddressDtoPropertiesCopyWith<_$_AddressDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

City _$CityFromJson(Map<String, dynamic> json) {
  return _City.fromJson(json);
}

/// @nodoc
mixin _$City {
  Type get type => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CityCopyWith<City> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityCopyWith<$Res> {
  factory $CityCopyWith(City value, $Res Function(City) then) =
      _$CityCopyWithImpl<$Res>;
  $Res call({Type type, bool nullable});
}

/// @nodoc
class _$CityCopyWithImpl<$Res> implements $CityCopyWith<$Res> {
  _$CityCopyWithImpl(this._value, this._then);

  final City _value;
  // ignore: unused_field
  final $Res Function(City) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_CityCopyWith<$Res> implements $CityCopyWith<$Res> {
  factory _$$_CityCopyWith(_$_City value, $Res Function(_$_City) then) =
      __$$_CityCopyWithImpl<$Res>;
  @override
  $Res call({Type type, bool nullable});
}

/// @nodoc
class __$$_CityCopyWithImpl<$Res> extends _$CityCopyWithImpl<$Res>
    implements _$$_CityCopyWith<$Res> {
  __$$_CityCopyWithImpl(_$_City _value, $Res Function(_$_City) _then)
      : super(_value, (v) => _then(v as _$_City));

  @override
  _$_City get _value => super._value as _$_City;

  @override
  $Res call({
    Object? type = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_$_City(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_City implements _City {
  const _$_City({required this.type, required this.nullable});

  factory _$_City.fromJson(Map<String, dynamic> json) => _$$_CityFromJson(json);

  @override
  final Type type;
  @override
  final bool nullable;

  @override
  String toString() {
    return 'City(type: $type, nullable: $nullable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_City &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.nullable, nullable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(nullable));

  @JsonKey(ignore: true)
  @override
  _$$_CityCopyWith<_$_City> get copyWith =>
      __$$_CityCopyWithImpl<_$_City>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CityToJson(this);
  }
}

abstract class _City implements City {
  const factory _City(
      {required final Type type, required final bool nullable}) = _$_City;

  factory _City.fromJson(Map<String, dynamic> json) = _$_City.fromJson;

  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  bool get nullable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CityCopyWith<_$_City> get copyWith => throw _privateConstructorUsedError;
}

AuthenticateDto _$AuthenticateDtoFromJson(Map<String, dynamic> json) {
  return _AuthenticateDto.fromJson(json);
}

/// @nodoc
mixin _$AuthenticateDto {
  String get type => throw _privateConstructorUsedError;
  AuthenticateDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticateDtoCopyWith<AuthenticateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticateDtoCopyWith<$Res> {
  factory $AuthenticateDtoCopyWith(
          AuthenticateDto value, $Res Function(AuthenticateDto) then) =
      _$AuthenticateDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      AuthenticateDtoProperties properties,
      bool additionalProperties});

  $AuthenticateDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$AuthenticateDtoCopyWithImpl<$Res>
    implements $AuthenticateDtoCopyWith<$Res> {
  _$AuthenticateDtoCopyWithImpl(this._value, this._then);

  final AuthenticateDto _value;
  // ignore: unused_field
  final $Res Function(AuthenticateDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as AuthenticateDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $AuthenticateDtoPropertiesCopyWith<$Res> get properties {
    return $AuthenticateDtoPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_AuthenticateDtoCopyWith<$Res>
    implements $AuthenticateDtoCopyWith<$Res> {
  factory _$$_AuthenticateDtoCopyWith(
          _$_AuthenticateDto value, $Res Function(_$_AuthenticateDto) then) =
      __$$_AuthenticateDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      AuthenticateDtoProperties properties,
      bool additionalProperties});

  @override
  $AuthenticateDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_AuthenticateDtoCopyWithImpl<$Res>
    extends _$AuthenticateDtoCopyWithImpl<$Res>
    implements _$$_AuthenticateDtoCopyWith<$Res> {
  __$$_AuthenticateDtoCopyWithImpl(
      _$_AuthenticateDto _value, $Res Function(_$_AuthenticateDto) _then)
      : super(_value, (v) => _then(v as _$_AuthenticateDto));

  @override
  _$_AuthenticateDto get _value => super._value as _$_AuthenticateDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_AuthenticateDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as AuthenticateDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthenticateDto implements _AuthenticateDto {
  const _$_AuthenticateDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_AuthenticateDto.fromJson(Map<String, dynamic> json) =>
      _$$_AuthenticateDtoFromJson(json);

  @override
  final String type;
  @override
  final AuthenticateDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'AuthenticateDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthenticateDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_AuthenticateDtoCopyWith<_$_AuthenticateDto> get copyWith =>
      __$$_AuthenticateDtoCopyWithImpl<_$_AuthenticateDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthenticateDtoToJson(this);
  }
}

abstract class _AuthenticateDto implements AuthenticateDto {
  const factory _AuthenticateDto(
      {required final String type,
      required final AuthenticateDtoProperties properties,
      required final bool additionalProperties}) = _$_AuthenticateDto;

  factory _AuthenticateDto.fromJson(Map<String, dynamic> json) =
      _$_AuthenticateDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  AuthenticateDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AuthenticateDtoCopyWith<_$_AuthenticateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthenticateDtoProperties _$AuthenticateDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _AuthenticateDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$AuthenticateDtoProperties {
  City get email => throw _privateConstructorUsedError;
  City get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticateDtoPropertiesCopyWith<AuthenticateDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticateDtoPropertiesCopyWith<$Res> {
  factory $AuthenticateDtoPropertiesCopyWith(AuthenticateDtoProperties value,
          $Res Function(AuthenticateDtoProperties) then) =
      _$AuthenticateDtoPropertiesCopyWithImpl<$Res>;
  $Res call({City email, City password});

  $CityCopyWith<$Res> get email;
  $CityCopyWith<$Res> get password;
}

/// @nodoc
class _$AuthenticateDtoPropertiesCopyWithImpl<$Res>
    implements $AuthenticateDtoPropertiesCopyWith<$Res> {
  _$AuthenticateDtoPropertiesCopyWithImpl(this._value, this._then);

  final AuthenticateDtoProperties _value;
  // ignore: unused_field
  final $Res Function(AuthenticateDtoProperties) _then;

  @override
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }

  @override
  $CityCopyWith<$Res> get email {
    return $CityCopyWith<$Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value));
    });
  }

  @override
  $CityCopyWith<$Res> get password {
    return $CityCopyWith<$Res>(_value.password, (value) {
      return _then(_value.copyWith(password: value));
    });
  }
}

/// @nodoc
abstract class _$$_AuthenticateDtoPropertiesCopyWith<$Res>
    implements $AuthenticateDtoPropertiesCopyWith<$Res> {
  factory _$$_AuthenticateDtoPropertiesCopyWith(
          _$_AuthenticateDtoProperties value,
          $Res Function(_$_AuthenticateDtoProperties) then) =
      __$$_AuthenticateDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call({City email, City password});

  @override
  $CityCopyWith<$Res> get email;
  @override
  $CityCopyWith<$Res> get password;
}

/// @nodoc
class __$$_AuthenticateDtoPropertiesCopyWithImpl<$Res>
    extends _$AuthenticateDtoPropertiesCopyWithImpl<$Res>
    implements _$$_AuthenticateDtoPropertiesCopyWith<$Res> {
  __$$_AuthenticateDtoPropertiesCopyWithImpl(
      _$_AuthenticateDtoProperties _value,
      $Res Function(_$_AuthenticateDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_AuthenticateDtoProperties));

  @override
  _$_AuthenticateDtoProperties get _value =>
      super._value as _$_AuthenticateDtoProperties;

  @override
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_$_AuthenticateDtoProperties(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthenticateDtoProperties implements _AuthenticateDtoProperties {
  const _$_AuthenticateDtoProperties(
      {required this.email, required this.password});

  factory _$_AuthenticateDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_AuthenticateDtoPropertiesFromJson(json);

  @override
  final City email;
  @override
  final City password;

  @override
  String toString() {
    return 'AuthenticateDtoProperties(email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthenticateDtoProperties &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$_AuthenticateDtoPropertiesCopyWith<_$_AuthenticateDtoProperties>
      get copyWith => __$$_AuthenticateDtoPropertiesCopyWithImpl<
          _$_AuthenticateDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthenticateDtoPropertiesToJson(this);
  }
}

abstract class _AuthenticateDtoProperties implements AuthenticateDtoProperties {
  const factory _AuthenticateDtoProperties(
      {required final City email,
      required final City password}) = _$_AuthenticateDtoProperties;

  factory _AuthenticateDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_AuthenticateDtoProperties.fromJson;

  @override
  City get email => throw _privateConstructorUsedError;
  @override
  City get password => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AuthenticateDtoPropertiesCopyWith<_$_AuthenticateDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

BankDetailsDto _$BankDetailsDtoFromJson(Map<String, dynamic> json) {
  return _BankDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$BankDetailsDto {
  String get type => throw _privateConstructorUsedError;
  BankDetailsDtoProperties get properties => throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankDetailsDtoCopyWith<BankDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankDetailsDtoCopyWith<$Res> {
  factory $BankDetailsDtoCopyWith(
          BankDetailsDto value, $Res Function(BankDetailsDto) then) =
      _$BankDetailsDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      BankDetailsDtoProperties properties,
      bool additionalProperties});

  $BankDetailsDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$BankDetailsDtoCopyWithImpl<$Res>
    implements $BankDetailsDtoCopyWith<$Res> {
  _$BankDetailsDtoCopyWithImpl(this._value, this._then);

  final BankDetailsDto _value;
  // ignore: unused_field
  final $Res Function(BankDetailsDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as BankDetailsDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $BankDetailsDtoPropertiesCopyWith<$Res> get properties {
    return $BankDetailsDtoPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_BankDetailsDtoCopyWith<$Res>
    implements $BankDetailsDtoCopyWith<$Res> {
  factory _$$_BankDetailsDtoCopyWith(
          _$_BankDetailsDto value, $Res Function(_$_BankDetailsDto) then) =
      __$$_BankDetailsDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      BankDetailsDtoProperties properties,
      bool additionalProperties});

  @override
  $BankDetailsDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_BankDetailsDtoCopyWithImpl<$Res>
    extends _$BankDetailsDtoCopyWithImpl<$Res>
    implements _$$_BankDetailsDtoCopyWith<$Res> {
  __$$_BankDetailsDtoCopyWithImpl(
      _$_BankDetailsDto _value, $Res Function(_$_BankDetailsDto) _then)
      : super(_value, (v) => _then(v as _$_BankDetailsDto));

  @override
  _$_BankDetailsDto get _value => super._value as _$_BankDetailsDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_BankDetailsDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as BankDetailsDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BankDetailsDto implements _BankDetailsDto {
  const _$_BankDetailsDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_BankDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$$_BankDetailsDtoFromJson(json);

  @override
  final String type;
  @override
  final BankDetailsDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'BankDetailsDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BankDetailsDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_BankDetailsDtoCopyWith<_$_BankDetailsDto> get copyWith =>
      __$$_BankDetailsDtoCopyWithImpl<_$_BankDetailsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BankDetailsDtoToJson(this);
  }
}

abstract class _BankDetailsDto implements BankDetailsDto {
  const factory _BankDetailsDto(
      {required final String type,
      required final BankDetailsDtoProperties properties,
      required final bool additionalProperties}) = _$_BankDetailsDto;

  factory _BankDetailsDto.fromJson(Map<String, dynamic> json) =
      _$_BankDetailsDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  BankDetailsDtoProperties get properties => throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BankDetailsDtoCopyWith<_$_BankDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

BankDetailsDtoProperties _$BankDetailsDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _BankDetailsDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$BankDetailsDtoProperties {
  City get iban => throw _privateConstructorUsedError;
  City get bic => throw _privateConstructorUsedError;
  City get accountOwner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankDetailsDtoPropertiesCopyWith<BankDetailsDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankDetailsDtoPropertiesCopyWith<$Res> {
  factory $BankDetailsDtoPropertiesCopyWith(BankDetailsDtoProperties value,
          $Res Function(BankDetailsDtoProperties) then) =
      _$BankDetailsDtoPropertiesCopyWithImpl<$Res>;
  $Res call({City iban, City bic, City accountOwner});

  $CityCopyWith<$Res> get iban;
  $CityCopyWith<$Res> get bic;
  $CityCopyWith<$Res> get accountOwner;
}

/// @nodoc
class _$BankDetailsDtoPropertiesCopyWithImpl<$Res>
    implements $BankDetailsDtoPropertiesCopyWith<$Res> {
  _$BankDetailsDtoPropertiesCopyWithImpl(this._value, this._then);

  final BankDetailsDtoProperties _value;
  // ignore: unused_field
  final $Res Function(BankDetailsDtoProperties) _then;

  @override
  $Res call({
    Object? iban = freezed,
    Object? bic = freezed,
    Object? accountOwner = freezed,
  }) {
    return _then(_value.copyWith(
      iban: iban == freezed
          ? _value.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as City,
      bic: bic == freezed
          ? _value.bic
          : bic // ignore: cast_nullable_to_non_nullable
              as City,
      accountOwner: accountOwner == freezed
          ? _value.accountOwner
          : accountOwner // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }

  @override
  $CityCopyWith<$Res> get iban {
    return $CityCopyWith<$Res>(_value.iban, (value) {
      return _then(_value.copyWith(iban: value));
    });
  }

  @override
  $CityCopyWith<$Res> get bic {
    return $CityCopyWith<$Res>(_value.bic, (value) {
      return _then(_value.copyWith(bic: value));
    });
  }

  @override
  $CityCopyWith<$Res> get accountOwner {
    return $CityCopyWith<$Res>(_value.accountOwner, (value) {
      return _then(_value.copyWith(accountOwner: value));
    });
  }
}

/// @nodoc
abstract class _$$_BankDetailsDtoPropertiesCopyWith<$Res>
    implements $BankDetailsDtoPropertiesCopyWith<$Res> {
  factory _$$_BankDetailsDtoPropertiesCopyWith(
          _$_BankDetailsDtoProperties value,
          $Res Function(_$_BankDetailsDtoProperties) then) =
      __$$_BankDetailsDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call({City iban, City bic, City accountOwner});

  @override
  $CityCopyWith<$Res> get iban;
  @override
  $CityCopyWith<$Res> get bic;
  @override
  $CityCopyWith<$Res> get accountOwner;
}

/// @nodoc
class __$$_BankDetailsDtoPropertiesCopyWithImpl<$Res>
    extends _$BankDetailsDtoPropertiesCopyWithImpl<$Res>
    implements _$$_BankDetailsDtoPropertiesCopyWith<$Res> {
  __$$_BankDetailsDtoPropertiesCopyWithImpl(_$_BankDetailsDtoProperties _value,
      $Res Function(_$_BankDetailsDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_BankDetailsDtoProperties));

  @override
  _$_BankDetailsDtoProperties get _value =>
      super._value as _$_BankDetailsDtoProperties;

  @override
  $Res call({
    Object? iban = freezed,
    Object? bic = freezed,
    Object? accountOwner = freezed,
  }) {
    return _then(_$_BankDetailsDtoProperties(
      iban: iban == freezed
          ? _value.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as City,
      bic: bic == freezed
          ? _value.bic
          : bic // ignore: cast_nullable_to_non_nullable
              as City,
      accountOwner: accountOwner == freezed
          ? _value.accountOwner
          : accountOwner // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BankDetailsDtoProperties implements _BankDetailsDtoProperties {
  const _$_BankDetailsDtoProperties(
      {required this.iban, required this.bic, required this.accountOwner});

  factory _$_BankDetailsDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_BankDetailsDtoPropertiesFromJson(json);

  @override
  final City iban;
  @override
  final City bic;
  @override
  final City accountOwner;

  @override
  String toString() {
    return 'BankDetailsDtoProperties(iban: $iban, bic: $bic, accountOwner: $accountOwner)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BankDetailsDtoProperties &&
            const DeepCollectionEquality().equals(other.iban, iban) &&
            const DeepCollectionEquality().equals(other.bic, bic) &&
            const DeepCollectionEquality()
                .equals(other.accountOwner, accountOwner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(iban),
      const DeepCollectionEquality().hash(bic),
      const DeepCollectionEquality().hash(accountOwner));

  @JsonKey(ignore: true)
  @override
  _$$_BankDetailsDtoPropertiesCopyWith<_$_BankDetailsDtoProperties>
      get copyWith => __$$_BankDetailsDtoPropertiesCopyWithImpl<
          _$_BankDetailsDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BankDetailsDtoPropertiesToJson(this);
  }
}

abstract class _BankDetailsDtoProperties implements BankDetailsDtoProperties {
  const factory _BankDetailsDtoProperties(
      {required final City iban,
      required final City bic,
      required final City accountOwner}) = _$_BankDetailsDtoProperties;

  factory _BankDetailsDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_BankDetailsDtoProperties.fromJson;

  @override
  City get iban => throw _privateConstructorUsedError;
  @override
  City get bic => throw _privateConstructorUsedError;
  @override
  City get accountOwner => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BankDetailsDtoPropertiesCopyWith<_$_BankDetailsDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

CompanySize _$CompanySizeFromJson(Map<String, dynamic> json) {
  return _CompanySize.fromJson(json);
}

/// @nodoc
mixin _$CompanySize {
  List<int> get companySizeEnum => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanySizeCopyWith<CompanySize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySizeCopyWith<$Res> {
  factory $CompanySizeCopyWith(
          CompanySize value, $Res Function(CompanySize) then) =
      _$CompanySizeCopyWithImpl<$Res>;
  $Res call({List<int> companySizeEnum, String type, String format});
}

/// @nodoc
class _$CompanySizeCopyWithImpl<$Res> implements $CompanySizeCopyWith<$Res> {
  _$CompanySizeCopyWithImpl(this._value, this._then);

  final CompanySize _value;
  // ignore: unused_field
  final $Res Function(CompanySize) _then;

  @override
  $Res call({
    Object? companySizeEnum = freezed,
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_value.copyWith(
      companySizeEnum: companySizeEnum == freezed
          ? _value.companySizeEnum
          : companySizeEnum // ignore: cast_nullable_to_non_nullable
              as List<int>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_CompanySizeCopyWith<$Res>
    implements $CompanySizeCopyWith<$Res> {
  factory _$$_CompanySizeCopyWith(
          _$_CompanySize value, $Res Function(_$_CompanySize) then) =
      __$$_CompanySizeCopyWithImpl<$Res>;
  @override
  $Res call({List<int> companySizeEnum, String type, String format});
}

/// @nodoc
class __$$_CompanySizeCopyWithImpl<$Res> extends _$CompanySizeCopyWithImpl<$Res>
    implements _$$_CompanySizeCopyWith<$Res> {
  __$$_CompanySizeCopyWithImpl(
      _$_CompanySize _value, $Res Function(_$_CompanySize) _then)
      : super(_value, (v) => _then(v as _$_CompanySize));

  @override
  _$_CompanySize get _value => super._value as _$_CompanySize;

  @override
  $Res call({
    Object? companySizeEnum = freezed,
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_$_CompanySize(
      companySizeEnum: companySizeEnum == freezed
          ? _value._companySizeEnum
          : companySizeEnum // ignore: cast_nullable_to_non_nullable
              as List<int>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompanySize implements _CompanySize {
  const _$_CompanySize(
      {required final List<int> companySizeEnum,
      required this.type,
      required this.format})
      : _companySizeEnum = companySizeEnum;

  factory _$_CompanySize.fromJson(Map<String, dynamic> json) =>
      _$$_CompanySizeFromJson(json);

  final List<int> _companySizeEnum;
  @override
  List<int> get companySizeEnum {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companySizeEnum);
  }

  @override
  final String type;
  @override
  final String format;

  @override
  String toString() {
    return 'CompanySize(companySizeEnum: $companySizeEnum, type: $type, format: $format)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompanySize &&
            const DeepCollectionEquality()
                .equals(other._companySizeEnum, _companySizeEnum) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.format, format));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_companySizeEnum),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(format));

  @JsonKey(ignore: true)
  @override
  _$$_CompanySizeCopyWith<_$_CompanySize> get copyWith =>
      __$$_CompanySizeCopyWithImpl<_$_CompanySize>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompanySizeToJson(this);
  }
}

abstract class _CompanySize implements CompanySize {
  const factory _CompanySize(
      {required final List<int> companySizeEnum,
      required final String type,
      required final String format}) = _$_CompanySize;

  factory _CompanySize.fromJson(Map<String, dynamic> json) =
      _$_CompanySize.fromJson;

  @override
  List<int> get companySizeEnum => throw _privateConstructorUsedError;
  @override
  String get type => throw _privateConstructorUsedError;
  @override
  String get format => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompanySizeCopyWith<_$_CompanySize> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCompanyDto _$CreateCompanyDtoFromJson(Map<String, dynamic> json) {
  return _CreateCompanyDto.fromJson(json);
}

/// @nodoc
mixin _$CreateCompanyDto {
  String get type => throw _privateConstructorUsedError;
  CreateCompanyDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateCompanyDtoCopyWith<CreateCompanyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCompanyDtoCopyWith<$Res> {
  factory $CreateCompanyDtoCopyWith(
          CreateCompanyDto value, $Res Function(CreateCompanyDto) then) =
      _$CreateCompanyDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      CreateCompanyDtoProperties properties,
      bool additionalProperties});

  $CreateCompanyDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$CreateCompanyDtoCopyWithImpl<$Res>
    implements $CreateCompanyDtoCopyWith<$Res> {
  _$CreateCompanyDtoCopyWithImpl(this._value, this._then);

  final CreateCompanyDto _value;
  // ignore: unused_field
  final $Res Function(CreateCompanyDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as CreateCompanyDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $CreateCompanyDtoPropertiesCopyWith<$Res> get properties {
    return $CreateCompanyDtoPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_CreateCompanyDtoCopyWith<$Res>
    implements $CreateCompanyDtoCopyWith<$Res> {
  factory _$$_CreateCompanyDtoCopyWith(
          _$_CreateCompanyDto value, $Res Function(_$_CreateCompanyDto) then) =
      __$$_CreateCompanyDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      CreateCompanyDtoProperties properties,
      bool additionalProperties});

  @override
  $CreateCompanyDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_CreateCompanyDtoCopyWithImpl<$Res>
    extends _$CreateCompanyDtoCopyWithImpl<$Res>
    implements _$$_CreateCompanyDtoCopyWith<$Res> {
  __$$_CreateCompanyDtoCopyWithImpl(
      _$_CreateCompanyDto _value, $Res Function(_$_CreateCompanyDto) _then)
      : super(_value, (v) => _then(v as _$_CreateCompanyDto));

  @override
  _$_CreateCompanyDto get _value => super._value as _$_CreateCompanyDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_CreateCompanyDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as CreateCompanyDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreateCompanyDto implements _CreateCompanyDto {
  const _$_CreateCompanyDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_CreateCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$$_CreateCompanyDtoFromJson(json);

  @override
  final String type;
  @override
  final CreateCompanyDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'CreateCompanyDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateCompanyDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_CreateCompanyDtoCopyWith<_$_CreateCompanyDto> get copyWith =>
      __$$_CreateCompanyDtoCopyWithImpl<_$_CreateCompanyDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreateCompanyDtoToJson(this);
  }
}

abstract class _CreateCompanyDto implements CreateCompanyDto {
  const factory _CreateCompanyDto(
      {required final String type,
      required final CreateCompanyDtoProperties properties,
      required final bool additionalProperties}) = _$_CreateCompanyDto;

  factory _CreateCompanyDto.fromJson(Map<String, dynamic> json) =
      _$_CreateCompanyDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  CreateCompanyDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CreateCompanyDtoCopyWith<_$_CreateCompanyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCompanyDtoProperties _$CreateCompanyDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _CreateCompanyDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$CreateCompanyDtoProperties {
  City get name => throw _privateConstructorUsedError;
  Address get address => throw _privateConstructorUsedError;
  City get uidNr => throw _privateConstructorUsedError;
  City get registrationNr => throw _privateConstructorUsedError;
  Address get companySize => throw _privateConstructorUsedError;
  Address get type => throw _privateConstructorUsedError;
  City get websiteUrl => throw _privateConstructorUsedError;
  Address get providerData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateCompanyDtoPropertiesCopyWith<CreateCompanyDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCompanyDtoPropertiesCopyWith<$Res> {
  factory $CreateCompanyDtoPropertiesCopyWith(CreateCompanyDtoProperties value,
          $Res Function(CreateCompanyDtoProperties) then) =
      _$CreateCompanyDtoPropertiesCopyWithImpl<$Res>;
  $Res call(
      {City name,
      Address address,
      City uidNr,
      City registrationNr,
      Address companySize,
      Address type,
      City websiteUrl,
      Address providerData});

  $CityCopyWith<$Res> get name;
  $AddressCopyWith<$Res> get address;
  $CityCopyWith<$Res> get uidNr;
  $CityCopyWith<$Res> get registrationNr;
  $AddressCopyWith<$Res> get companySize;
  $AddressCopyWith<$Res> get type;
  $CityCopyWith<$Res> get websiteUrl;
  $AddressCopyWith<$Res> get providerData;
}

/// @nodoc
class _$CreateCompanyDtoPropertiesCopyWithImpl<$Res>
    implements $CreateCompanyDtoPropertiesCopyWith<$Res> {
  _$CreateCompanyDtoPropertiesCopyWithImpl(this._value, this._then);

  final CreateCompanyDtoProperties _value;
  // ignore: unused_field
  final $Res Function(CreateCompanyDtoProperties) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? uidNr = freezed,
    Object? registrationNr = freezed,
    Object? companySize = freezed,
    Object? type = freezed,
    Object? websiteUrl = freezed,
    Object? providerData = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as City,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
      uidNr: uidNr == freezed
          ? _value.uidNr
          : uidNr // ignore: cast_nullable_to_non_nullable
              as City,
      registrationNr: registrationNr == freezed
          ? _value.registrationNr
          : registrationNr // ignore: cast_nullable_to_non_nullable
              as City,
      companySize: companySize == freezed
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as Address,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Address,
      websiteUrl: websiteUrl == freezed
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as City,
      providerData: providerData == freezed
          ? _value.providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }

  @override
  $CityCopyWith<$Res> get name {
    return $CityCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value));
    });
  }

  @override
  $AddressCopyWith<$Res> get address {
    return $AddressCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value));
    });
  }

  @override
  $CityCopyWith<$Res> get uidNr {
    return $CityCopyWith<$Res>(_value.uidNr, (value) {
      return _then(_value.copyWith(uidNr: value));
    });
  }

  @override
  $CityCopyWith<$Res> get registrationNr {
    return $CityCopyWith<$Res>(_value.registrationNr, (value) {
      return _then(_value.copyWith(registrationNr: value));
    });
  }

  @override
  $AddressCopyWith<$Res> get companySize {
    return $AddressCopyWith<$Res>(_value.companySize, (value) {
      return _then(_value.copyWith(companySize: value));
    });
  }

  @override
  $AddressCopyWith<$Res> get type {
    return $AddressCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value));
    });
  }

  @override
  $CityCopyWith<$Res> get websiteUrl {
    return $CityCopyWith<$Res>(_value.websiteUrl, (value) {
      return _then(_value.copyWith(websiteUrl: value));
    });
  }

  @override
  $AddressCopyWith<$Res> get providerData {
    return $AddressCopyWith<$Res>(_value.providerData, (value) {
      return _then(_value.copyWith(providerData: value));
    });
  }
}

/// @nodoc
abstract class _$$_CreateCompanyDtoPropertiesCopyWith<$Res>
    implements $CreateCompanyDtoPropertiesCopyWith<$Res> {
  factory _$$_CreateCompanyDtoPropertiesCopyWith(
          _$_CreateCompanyDtoProperties value,
          $Res Function(_$_CreateCompanyDtoProperties) then) =
      __$$_CreateCompanyDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call(
      {City name,
      Address address,
      City uidNr,
      City registrationNr,
      Address companySize,
      Address type,
      City websiteUrl,
      Address providerData});

  @override
  $CityCopyWith<$Res> get name;
  @override
  $AddressCopyWith<$Res> get address;
  @override
  $CityCopyWith<$Res> get uidNr;
  @override
  $CityCopyWith<$Res> get registrationNr;
  @override
  $AddressCopyWith<$Res> get companySize;
  @override
  $AddressCopyWith<$Res> get type;
  @override
  $CityCopyWith<$Res> get websiteUrl;
  @override
  $AddressCopyWith<$Res> get providerData;
}

/// @nodoc
class __$$_CreateCompanyDtoPropertiesCopyWithImpl<$Res>
    extends _$CreateCompanyDtoPropertiesCopyWithImpl<$Res>
    implements _$$_CreateCompanyDtoPropertiesCopyWith<$Res> {
  __$$_CreateCompanyDtoPropertiesCopyWithImpl(
      _$_CreateCompanyDtoProperties _value,
      $Res Function(_$_CreateCompanyDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_CreateCompanyDtoProperties));

  @override
  _$_CreateCompanyDtoProperties get _value =>
      super._value as _$_CreateCompanyDtoProperties;

  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? uidNr = freezed,
    Object? registrationNr = freezed,
    Object? companySize = freezed,
    Object? type = freezed,
    Object? websiteUrl = freezed,
    Object? providerData = freezed,
  }) {
    return _then(_$_CreateCompanyDtoProperties(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as City,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
      uidNr: uidNr == freezed
          ? _value.uidNr
          : uidNr // ignore: cast_nullable_to_non_nullable
              as City,
      registrationNr: registrationNr == freezed
          ? _value.registrationNr
          : registrationNr // ignore: cast_nullable_to_non_nullable
              as City,
      companySize: companySize == freezed
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as Address,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Address,
      websiteUrl: websiteUrl == freezed
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as City,
      providerData: providerData == freezed
          ? _value.providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreateCompanyDtoProperties implements _CreateCompanyDtoProperties {
  const _$_CreateCompanyDtoProperties(
      {required this.name,
      required this.address,
      required this.uidNr,
      required this.registrationNr,
      required this.companySize,
      required this.type,
      required this.websiteUrl,
      required this.providerData});

  factory _$_CreateCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_CreateCompanyDtoPropertiesFromJson(json);

  @override
  final City name;
  @override
  final Address address;
  @override
  final City uidNr;
  @override
  final City registrationNr;
  @override
  final Address companySize;
  @override
  final Address type;
  @override
  final City websiteUrl;
  @override
  final Address providerData;

  @override
  String toString() {
    return 'CreateCompanyDtoProperties(name: $name, address: $address, uidNr: $uidNr, registrationNr: $registrationNr, companySize: $companySize, type: $type, websiteUrl: $websiteUrl, providerData: $providerData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateCompanyDtoProperties &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.address, address) &&
            const DeepCollectionEquality().equals(other.uidNr, uidNr) &&
            const DeepCollectionEquality()
                .equals(other.registrationNr, registrationNr) &&
            const DeepCollectionEquality()
                .equals(other.companySize, companySize) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.websiteUrl, websiteUrl) &&
            const DeepCollectionEquality()
                .equals(other.providerData, providerData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(address),
      const DeepCollectionEquality().hash(uidNr),
      const DeepCollectionEquality().hash(registrationNr),
      const DeepCollectionEquality().hash(companySize),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(websiteUrl),
      const DeepCollectionEquality().hash(providerData));

  @JsonKey(ignore: true)
  @override
  _$$_CreateCompanyDtoPropertiesCopyWith<_$_CreateCompanyDtoProperties>
      get copyWith => __$$_CreateCompanyDtoPropertiesCopyWithImpl<
          _$_CreateCompanyDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreateCompanyDtoPropertiesToJson(this);
  }
}

abstract class _CreateCompanyDtoProperties
    implements CreateCompanyDtoProperties {
  const factory _CreateCompanyDtoProperties(
      {required final City name,
      required final Address address,
      required final City uidNr,
      required final City registrationNr,
      required final Address companySize,
      required final Address type,
      required final City websiteUrl,
      required final Address providerData}) = _$_CreateCompanyDtoProperties;

  factory _CreateCompanyDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_CreateCompanyDtoProperties.fromJson;

  @override
  City get name => throw _privateConstructorUsedError;
  @override
  Address get address => throw _privateConstructorUsedError;
  @override
  City get uidNr => throw _privateConstructorUsedError;
  @override
  City get registrationNr => throw _privateConstructorUsedError;
  @override
  Address get companySize => throw _privateConstructorUsedError;
  @override
  Address get type => throw _privateConstructorUsedError;
  @override
  City get websiteUrl => throw _privateConstructorUsedError;
  @override
  Address get providerData => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CreateCompanyDtoPropertiesCopyWith<_$_CreateCompanyDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  String get ref => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res>;
  $Res call({String ref});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res> implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  final Address _value;
  // ignore: unused_field
  final $Res Function(Address) _then;

  @override
  $Res call({
    Object? ref = freezed,
  }) {
    return _then(_value.copyWith(
      ref: ref == freezed
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$_AddressCopyWith(
          _$_Address value, $Res Function(_$_Address) then) =
      __$$_AddressCopyWithImpl<$Res>;
  @override
  $Res call({String ref});
}

/// @nodoc
class __$$_AddressCopyWithImpl<$Res> extends _$AddressCopyWithImpl<$Res>
    implements _$$_AddressCopyWith<$Res> {
  __$$_AddressCopyWithImpl(_$_Address _value, $Res Function(_$_Address) _then)
      : super(_value, (v) => _then(v as _$_Address));

  @override
  _$_Address get _value => super._value as _$_Address;

  @override
  $Res call({
    Object? ref = freezed,
  }) {
    return _then(_$_Address(
      ref: ref == freezed
          ? _value.ref
          : ref // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Address implements _Address {
  const _$_Address({required this.ref});

  factory _$_Address.fromJson(Map<String, dynamic> json) =>
      _$$_AddressFromJson(json);

  @override
  final String ref;

  @override
  String toString() {
    return 'Address(ref: $ref)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Address &&
            const DeepCollectionEquality().equals(other.ref, ref));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(ref));

  @JsonKey(ignore: true)
  @override
  _$$_AddressCopyWith<_$_Address> get copyWith =>
      __$$_AddressCopyWithImpl<_$_Address>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressToJson(this);
  }
}

abstract class _Address implements Address {
  const factory _Address({required final String ref}) = _$_Address;

  factory _Address.fromJson(Map<String, dynamic> json) = _$_Address.fromJson;

  @override
  String get ref => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AddressCopyWith<_$_Address> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateProviderDto _$CreateProviderDtoFromJson(Map<String, dynamic> json) {
  return _CreateProviderDto.fromJson(json);
}

/// @nodoc
mixin _$CreateProviderDto {
  String get type => throw _privateConstructorUsedError;
  CreateProviderDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateProviderDtoCopyWith<CreateProviderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProviderDtoCopyWith<$Res> {
  factory $CreateProviderDtoCopyWith(
          CreateProviderDto value, $Res Function(CreateProviderDto) then) =
      _$CreateProviderDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      CreateProviderDtoProperties properties,
      bool additionalProperties});

  $CreateProviderDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$CreateProviderDtoCopyWithImpl<$Res>
    implements $CreateProviderDtoCopyWith<$Res> {
  _$CreateProviderDtoCopyWithImpl(this._value, this._then);

  final CreateProviderDto _value;
  // ignore: unused_field
  final $Res Function(CreateProviderDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as CreateProviderDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $CreateProviderDtoPropertiesCopyWith<$Res> get properties {
    return $CreateProviderDtoPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_CreateProviderDtoCopyWith<$Res>
    implements $CreateProviderDtoCopyWith<$Res> {
  factory _$$_CreateProviderDtoCopyWith(_$_CreateProviderDto value,
          $Res Function(_$_CreateProviderDto) then) =
      __$$_CreateProviderDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      CreateProviderDtoProperties properties,
      bool additionalProperties});

  @override
  $CreateProviderDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_CreateProviderDtoCopyWithImpl<$Res>
    extends _$CreateProviderDtoCopyWithImpl<$Res>
    implements _$$_CreateProviderDtoCopyWith<$Res> {
  __$$_CreateProviderDtoCopyWithImpl(
      _$_CreateProviderDto _value, $Res Function(_$_CreateProviderDto) _then)
      : super(_value, (v) => _then(v as _$_CreateProviderDto));

  @override
  _$_CreateProviderDto get _value => super._value as _$_CreateProviderDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_CreateProviderDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as CreateProviderDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreateProviderDto implements _CreateProviderDto {
  const _$_CreateProviderDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_CreateProviderDto.fromJson(Map<String, dynamic> json) =>
      _$$_CreateProviderDtoFromJson(json);

  @override
  final String type;
  @override
  final CreateProviderDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'CreateProviderDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateProviderDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_CreateProviderDtoCopyWith<_$_CreateProviderDto> get copyWith =>
      __$$_CreateProviderDtoCopyWithImpl<_$_CreateProviderDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreateProviderDtoToJson(this);
  }
}

abstract class _CreateProviderDto implements CreateProviderDto {
  const factory _CreateProviderDto(
      {required final String type,
      required final CreateProviderDtoProperties properties,
      required final bool additionalProperties}) = _$_CreateProviderDto;

  factory _CreateProviderDto.fromJson(Map<String, dynamic> json) =
      _$_CreateProviderDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  CreateProviderDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CreateProviderDtoCopyWith<_$_CreateProviderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateProviderDtoProperties _$CreateProviderDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _CreateProviderDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$CreateProviderDtoProperties {
  Address get bankDetails => throw _privateConstructorUsedError;
  BranchIds get branchIds => throw _privateConstructorUsedError;
  Address get paymentInterval => throw _privateConstructorUsedError;
  SubscriptionPlanId get subscriptionPlanId =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateProviderDtoPropertiesCopyWith<CreateProviderDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProviderDtoPropertiesCopyWith<$Res> {
  factory $CreateProviderDtoPropertiesCopyWith(
          CreateProviderDtoProperties value,
          $Res Function(CreateProviderDtoProperties) then) =
      _$CreateProviderDtoPropertiesCopyWithImpl<$Res>;
  $Res call(
      {Address bankDetails,
      BranchIds branchIds,
      Address paymentInterval,
      SubscriptionPlanId subscriptionPlanId});

  $AddressCopyWith<$Res> get bankDetails;
  $BranchIdsCopyWith<$Res> get branchIds;
  $AddressCopyWith<$Res> get paymentInterval;
  $SubscriptionPlanIdCopyWith<$Res> get subscriptionPlanId;
}

/// @nodoc
class _$CreateProviderDtoPropertiesCopyWithImpl<$Res>
    implements $CreateProviderDtoPropertiesCopyWith<$Res> {
  _$CreateProviderDtoPropertiesCopyWithImpl(this._value, this._then);

  final CreateProviderDtoProperties _value;
  // ignore: unused_field
  final $Res Function(CreateProviderDtoProperties) _then;

  @override
  $Res call({
    Object? bankDetails = freezed,
    Object? branchIds = freezed,
    Object? paymentInterval = freezed,
    Object? subscriptionPlanId = freezed,
  }) {
    return _then(_value.copyWith(
      bankDetails: bankDetails == freezed
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as Address,
      branchIds: branchIds == freezed
          ? _value.branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as BranchIds,
      paymentInterval: paymentInterval == freezed
          ? _value.paymentInterval
          : paymentInterval // ignore: cast_nullable_to_non_nullable
              as Address,
      subscriptionPlanId: subscriptionPlanId == freezed
          ? _value.subscriptionPlanId
          : subscriptionPlanId // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }

  @override
  $AddressCopyWith<$Res> get bankDetails {
    return $AddressCopyWith<$Res>(_value.bankDetails, (value) {
      return _then(_value.copyWith(bankDetails: value));
    });
  }

  @override
  $BranchIdsCopyWith<$Res> get branchIds {
    return $BranchIdsCopyWith<$Res>(_value.branchIds, (value) {
      return _then(_value.copyWith(branchIds: value));
    });
  }

  @override
  $AddressCopyWith<$Res> get paymentInterval {
    return $AddressCopyWith<$Res>(_value.paymentInterval, (value) {
      return _then(_value.copyWith(paymentInterval: value));
    });
  }

  @override
  $SubscriptionPlanIdCopyWith<$Res> get subscriptionPlanId {
    return $SubscriptionPlanIdCopyWith<$Res>(_value.subscriptionPlanId,
        (value) {
      return _then(_value.copyWith(subscriptionPlanId: value));
    });
  }
}

/// @nodoc
abstract class _$$_CreateProviderDtoPropertiesCopyWith<$Res>
    implements $CreateProviderDtoPropertiesCopyWith<$Res> {
  factory _$$_CreateProviderDtoPropertiesCopyWith(
          _$_CreateProviderDtoProperties value,
          $Res Function(_$_CreateProviderDtoProperties) then) =
      __$$_CreateProviderDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call(
      {Address bankDetails,
      BranchIds branchIds,
      Address paymentInterval,
      SubscriptionPlanId subscriptionPlanId});

  @override
  $AddressCopyWith<$Res> get bankDetails;
  @override
  $BranchIdsCopyWith<$Res> get branchIds;
  @override
  $AddressCopyWith<$Res> get paymentInterval;
  @override
  $SubscriptionPlanIdCopyWith<$Res> get subscriptionPlanId;
}

/// @nodoc
class __$$_CreateProviderDtoPropertiesCopyWithImpl<$Res>
    extends _$CreateProviderDtoPropertiesCopyWithImpl<$Res>
    implements _$$_CreateProviderDtoPropertiesCopyWith<$Res> {
  __$$_CreateProviderDtoPropertiesCopyWithImpl(
      _$_CreateProviderDtoProperties _value,
      $Res Function(_$_CreateProviderDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_CreateProviderDtoProperties));

  @override
  _$_CreateProviderDtoProperties get _value =>
      super._value as _$_CreateProviderDtoProperties;

  @override
  $Res call({
    Object? bankDetails = freezed,
    Object? branchIds = freezed,
    Object? paymentInterval = freezed,
    Object? subscriptionPlanId = freezed,
  }) {
    return _then(_$_CreateProviderDtoProperties(
      bankDetails: bankDetails == freezed
          ? _value.bankDetails
          : bankDetails // ignore: cast_nullable_to_non_nullable
              as Address,
      branchIds: branchIds == freezed
          ? _value.branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as BranchIds,
      paymentInterval: paymentInterval == freezed
          ? _value.paymentInterval
          : paymentInterval // ignore: cast_nullable_to_non_nullable
              as Address,
      subscriptionPlanId: subscriptionPlanId == freezed
          ? _value.subscriptionPlanId
          : subscriptionPlanId // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreateProviderDtoProperties implements _CreateProviderDtoProperties {
  const _$_CreateProviderDtoProperties(
      {required this.bankDetails,
      required this.branchIds,
      required this.paymentInterval,
      required this.subscriptionPlanId});

  factory _$_CreateProviderDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_CreateProviderDtoPropertiesFromJson(json);

  @override
  final Address bankDetails;
  @override
  final BranchIds branchIds;
  @override
  final Address paymentInterval;
  @override
  final SubscriptionPlanId subscriptionPlanId;

  @override
  String toString() {
    return 'CreateProviderDtoProperties(bankDetails: $bankDetails, branchIds: $branchIds, paymentInterval: $paymentInterval, subscriptionPlanId: $subscriptionPlanId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreateProviderDtoProperties &&
            const DeepCollectionEquality()
                .equals(other.bankDetails, bankDetails) &&
            const DeepCollectionEquality().equals(other.branchIds, branchIds) &&
            const DeepCollectionEquality()
                .equals(other.paymentInterval, paymentInterval) &&
            const DeepCollectionEquality()
                .equals(other.subscriptionPlanId, subscriptionPlanId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bankDetails),
      const DeepCollectionEquality().hash(branchIds),
      const DeepCollectionEquality().hash(paymentInterval),
      const DeepCollectionEquality().hash(subscriptionPlanId));

  @JsonKey(ignore: true)
  @override
  _$$_CreateProviderDtoPropertiesCopyWith<_$_CreateProviderDtoProperties>
      get copyWith => __$$_CreateProviderDtoPropertiesCopyWithImpl<
          _$_CreateProviderDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreateProviderDtoPropertiesToJson(this);
  }
}

abstract class _CreateProviderDtoProperties
    implements CreateProviderDtoProperties {
  const factory _CreateProviderDtoProperties(
          {required final Address bankDetails,
          required final BranchIds branchIds,
          required final Address paymentInterval,
          required final SubscriptionPlanId subscriptionPlanId}) =
      _$_CreateProviderDtoProperties;

  factory _CreateProviderDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_CreateProviderDtoProperties.fromJson;

  @override
  Address get bankDetails => throw _privateConstructorUsedError;
  @override
  BranchIds get branchIds => throw _privateConstructorUsedError;
  @override
  Address get paymentInterval => throw _privateConstructorUsedError;
  @override
  SubscriptionPlanId get subscriptionPlanId =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CreateProviderDtoPropertiesCopyWith<_$_CreateProviderDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

BranchIds _$BranchIdsFromJson(Map<String, dynamic> json) {
  return _BranchIds.fromJson(json);
}

/// @nodoc
mixin _$BranchIds {
  String get type => throw _privateConstructorUsedError;
  SubscriptionPlanId get items => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BranchIdsCopyWith<BranchIds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchIdsCopyWith<$Res> {
  factory $BranchIdsCopyWith(BranchIds value, $Res Function(BranchIds) then) =
      _$BranchIdsCopyWithImpl<$Res>;
  $Res call({String type, SubscriptionPlanId items, bool nullable});

  $SubscriptionPlanIdCopyWith<$Res> get items;
}

/// @nodoc
class _$BranchIdsCopyWithImpl<$Res> implements $BranchIdsCopyWith<$Res> {
  _$BranchIdsCopyWithImpl(this._value, this._then);

  final BranchIds _value;
  // ignore: unused_field
  final $Res Function(BranchIds) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? items = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $SubscriptionPlanIdCopyWith<$Res> get items {
    return $SubscriptionPlanIdCopyWith<$Res>(_value.items, (value) {
      return _then(_value.copyWith(items: value));
    });
  }
}

/// @nodoc
abstract class _$$_BranchIdsCopyWith<$Res> implements $BranchIdsCopyWith<$Res> {
  factory _$$_BranchIdsCopyWith(
          _$_BranchIds value, $Res Function(_$_BranchIds) then) =
      __$$_BranchIdsCopyWithImpl<$Res>;
  @override
  $Res call({String type, SubscriptionPlanId items, bool nullable});

  @override
  $SubscriptionPlanIdCopyWith<$Res> get items;
}

/// @nodoc
class __$$_BranchIdsCopyWithImpl<$Res> extends _$BranchIdsCopyWithImpl<$Res>
    implements _$$_BranchIdsCopyWith<$Res> {
  __$$_BranchIdsCopyWithImpl(
      _$_BranchIds _value, $Res Function(_$_BranchIds) _then)
      : super(_value, (v) => _then(v as _$_BranchIds));

  @override
  _$_BranchIds get _value => super._value as _$_BranchIds;

  @override
  $Res call({
    Object? type = freezed,
    Object? items = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_$_BranchIds(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BranchIds implements _BranchIds {
  const _$_BranchIds(
      {required this.type, required this.items, required this.nullable});

  factory _$_BranchIds.fromJson(Map<String, dynamic> json) =>
      _$$_BranchIdsFromJson(json);

  @override
  final String type;
  @override
  final SubscriptionPlanId items;
  @override
  final bool nullable;

  @override
  String toString() {
    return 'BranchIds(type: $type, items: $items, nullable: $nullable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BranchIds &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality().equals(other.nullable, nullable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(nullable));

  @JsonKey(ignore: true)
  @override
  _$$_BranchIdsCopyWith<_$_BranchIds> get copyWith =>
      __$$_BranchIdsCopyWithImpl<_$_BranchIds>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BranchIdsToJson(this);
  }
}

abstract class _BranchIds implements BranchIds {
  const factory _BranchIds(
      {required final String type,
      required final SubscriptionPlanId items,
      required final bool nullable}) = _$_BranchIds;

  factory _BranchIds.fromJson(Map<String, dynamic> json) =
      _$_BranchIds.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  SubscriptionPlanId get items => throw _privateConstructorUsedError;
  @override
  bool get nullable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BranchIdsCopyWith<_$_BranchIds> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionPlanId _$SubscriptionPlanIdFromJson(Map<String, dynamic> json) {
  return _SubscriptionPlanId.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionPlanId {
  Type get type => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubscriptionPlanIdCopyWith<SubscriptionPlanId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionPlanIdCopyWith<$Res> {
  factory $SubscriptionPlanIdCopyWith(
          SubscriptionPlanId value, $Res Function(SubscriptionPlanId) then) =
      _$SubscriptionPlanIdCopyWithImpl<$Res>;
  $Res call({Type type, String format});
}

/// @nodoc
class _$SubscriptionPlanIdCopyWithImpl<$Res>
    implements $SubscriptionPlanIdCopyWith<$Res> {
  _$SubscriptionPlanIdCopyWithImpl(this._value, this._then);

  final SubscriptionPlanId _value;
  // ignore: unused_field
  final $Res Function(SubscriptionPlanId) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_SubscriptionPlanIdCopyWith<$Res>
    implements $SubscriptionPlanIdCopyWith<$Res> {
  factory _$$_SubscriptionPlanIdCopyWith(_$_SubscriptionPlanId value,
          $Res Function(_$_SubscriptionPlanId) then) =
      __$$_SubscriptionPlanIdCopyWithImpl<$Res>;
  @override
  $Res call({Type type, String format});
}

/// @nodoc
class __$$_SubscriptionPlanIdCopyWithImpl<$Res>
    extends _$SubscriptionPlanIdCopyWithImpl<$Res>
    implements _$$_SubscriptionPlanIdCopyWith<$Res> {
  __$$_SubscriptionPlanIdCopyWithImpl(
      _$_SubscriptionPlanId _value, $Res Function(_$_SubscriptionPlanId) _then)
      : super(_value, (v) => _then(v as _$_SubscriptionPlanId));

  @override
  _$_SubscriptionPlanId get _value => super._value as _$_SubscriptionPlanId;

  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_$_SubscriptionPlanId(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubscriptionPlanId implements _SubscriptionPlanId {
  const _$_SubscriptionPlanId({required this.type, required this.format});

  factory _$_SubscriptionPlanId.fromJson(Map<String, dynamic> json) =>
      _$$_SubscriptionPlanIdFromJson(json);

  @override
  final Type type;
  @override
  final String format;

  @override
  String toString() {
    return 'SubscriptionPlanId(type: $type, format: $format)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SubscriptionPlanId &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.format, format));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(format));

  @JsonKey(ignore: true)
  @override
  _$$_SubscriptionPlanIdCopyWith<_$_SubscriptionPlanId> get copyWith =>
      __$$_SubscriptionPlanIdCopyWithImpl<_$_SubscriptionPlanId>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SubscriptionPlanIdToJson(this);
  }
}

abstract class _SubscriptionPlanId implements SubscriptionPlanId {
  const factory _SubscriptionPlanId(
      {required final Type type,
      required final String format}) = _$_SubscriptionPlanId;

  factory _SubscriptionPlanId.fromJson(Map<String, dynamic> json) =
      _$_SubscriptionPlanId.fromJson;

  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  String get format => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SubscriptionPlanIdCopyWith<_$_SubscriptionPlanId> get copyWith =>
      throw _privateConstructorUsedError;
}

ForgotPasswordDto _$ForgotPasswordDtoFromJson(Map<String, dynamic> json) {
  return _ForgotPasswordDto.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordDto {
  String get type => throw _privateConstructorUsedError;
  ForgotPasswordDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForgotPasswordDtoCopyWith<ForgotPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordDtoCopyWith<$Res> {
  factory $ForgotPasswordDtoCopyWith(
          ForgotPasswordDto value, $Res Function(ForgotPasswordDto) then) =
      _$ForgotPasswordDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      ForgotPasswordDtoProperties properties,
      bool additionalProperties});

  $ForgotPasswordDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$ForgotPasswordDtoCopyWithImpl<$Res>
    implements $ForgotPasswordDtoCopyWith<$Res> {
  _$ForgotPasswordDtoCopyWithImpl(this._value, this._then);

  final ForgotPasswordDto _value;
  // ignore: unused_field
  final $Res Function(ForgotPasswordDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as ForgotPasswordDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $ForgotPasswordDtoPropertiesCopyWith<$Res> get properties {
    return $ForgotPasswordDtoPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_ForgotPasswordDtoCopyWith<$Res>
    implements $ForgotPasswordDtoCopyWith<$Res> {
  factory _$$_ForgotPasswordDtoCopyWith(_$_ForgotPasswordDto value,
          $Res Function(_$_ForgotPasswordDto) then) =
      __$$_ForgotPasswordDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      ForgotPasswordDtoProperties properties,
      bool additionalProperties});

  @override
  $ForgotPasswordDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_ForgotPasswordDtoCopyWithImpl<$Res>
    extends _$ForgotPasswordDtoCopyWithImpl<$Res>
    implements _$$_ForgotPasswordDtoCopyWith<$Res> {
  __$$_ForgotPasswordDtoCopyWithImpl(
      _$_ForgotPasswordDto _value, $Res Function(_$_ForgotPasswordDto) _then)
      : super(_value, (v) => _then(v as _$_ForgotPasswordDto));

  @override
  _$_ForgotPasswordDto get _value => super._value as _$_ForgotPasswordDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_ForgotPasswordDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as ForgotPasswordDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ForgotPasswordDto implements _ForgotPasswordDto {
  const _$_ForgotPasswordDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$$_ForgotPasswordDtoFromJson(json);

  @override
  final String type;
  @override
  final ForgotPasswordDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'ForgotPasswordDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ForgotPasswordDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_ForgotPasswordDtoCopyWith<_$_ForgotPasswordDto> get copyWith =>
      __$$_ForgotPasswordDtoCopyWithImpl<_$_ForgotPasswordDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ForgotPasswordDtoToJson(this);
  }
}

abstract class _ForgotPasswordDto implements ForgotPasswordDto {
  const factory _ForgotPasswordDto(
      {required final String type,
      required final ForgotPasswordDtoProperties properties,
      required final bool additionalProperties}) = _$_ForgotPasswordDto;

  factory _ForgotPasswordDto.fromJson(Map<String, dynamic> json) =
      _$_ForgotPasswordDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  ForgotPasswordDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ForgotPasswordDtoCopyWith<_$_ForgotPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

ForgotPasswordDtoProperties _$ForgotPasswordDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordDtoProperties {
  City get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForgotPasswordDtoPropertiesCopyWith<ForgotPasswordDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordDtoPropertiesCopyWith<$Res> {
  factory $ForgotPasswordDtoPropertiesCopyWith(
          ForgotPasswordDtoProperties value,
          $Res Function(ForgotPasswordDtoProperties) then) =
      _$ForgotPasswordDtoPropertiesCopyWithImpl<$Res>;
  $Res call({City email});

  $CityCopyWith<$Res> get email;
}

/// @nodoc
class _$ForgotPasswordDtoPropertiesCopyWithImpl<$Res>
    implements $ForgotPasswordDtoPropertiesCopyWith<$Res> {
  _$ForgotPasswordDtoPropertiesCopyWithImpl(this._value, this._then);

  final ForgotPasswordDtoProperties _value;
  // ignore: unused_field
  final $Res Function(ForgotPasswordDtoProperties) _then;

  @override
  $Res call({
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }

  @override
  $CityCopyWith<$Res> get email {
    return $CityCopyWith<$Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value));
    });
  }
}

/// @nodoc
abstract class _$$_ForgotPasswordDtoPropertiesCopyWith<$Res>
    implements $ForgotPasswordDtoPropertiesCopyWith<$Res> {
  factory _$$_ForgotPasswordDtoPropertiesCopyWith(
          _$_ForgotPasswordDtoProperties value,
          $Res Function(_$_ForgotPasswordDtoProperties) then) =
      __$$_ForgotPasswordDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call({City email});

  @override
  $CityCopyWith<$Res> get email;
}

/// @nodoc
class __$$_ForgotPasswordDtoPropertiesCopyWithImpl<$Res>
    extends _$ForgotPasswordDtoPropertiesCopyWithImpl<$Res>
    implements _$$_ForgotPasswordDtoPropertiesCopyWith<$Res> {
  __$$_ForgotPasswordDtoPropertiesCopyWithImpl(
      _$_ForgotPasswordDtoProperties _value,
      $Res Function(_$_ForgotPasswordDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_ForgotPasswordDtoProperties));

  @override
  _$_ForgotPasswordDtoProperties get _value =>
      super._value as _$_ForgotPasswordDtoProperties;

  @override
  $Res call({
    Object? email = freezed,
  }) {
    return _then(_$_ForgotPasswordDtoProperties(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ForgotPasswordDtoProperties implements _ForgotPasswordDtoProperties {
  const _$_ForgotPasswordDtoProperties({required this.email});

  factory _$_ForgotPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_ForgotPasswordDtoPropertiesFromJson(json);

  @override
  final City email;

  @override
  String toString() {
    return 'ForgotPasswordDtoProperties(email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ForgotPasswordDtoProperties &&
            const DeepCollectionEquality().equals(other.email, email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(email));

  @JsonKey(ignore: true)
  @override
  _$$_ForgotPasswordDtoPropertiesCopyWith<_$_ForgotPasswordDtoProperties>
      get copyWith => __$$_ForgotPasswordDtoPropertiesCopyWithImpl<
          _$_ForgotPasswordDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ForgotPasswordDtoPropertiesToJson(this);
  }
}

abstract class _ForgotPasswordDtoProperties
    implements ForgotPasswordDtoProperties {
  const factory _ForgotPasswordDtoProperties({required final City email}) =
      _$_ForgotPasswordDtoProperties;

  factory _ForgotPasswordDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_ForgotPasswordDtoProperties.fromJson;

  @override
  City get email => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ForgotPasswordDtoPropertiesCopyWith<_$_ForgotPasswordDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

RegisterCompanyDto _$RegisterCompanyDtoFromJson(Map<String, dynamic> json) {
  return _RegisterCompanyDto.fromJson(json);
}

/// @nodoc
mixin _$RegisterCompanyDto {
  String get type => throw _privateConstructorUsedError;
  RegisterCompanyDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterCompanyDtoCopyWith<RegisterCompanyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterCompanyDtoCopyWith<$Res> {
  factory $RegisterCompanyDtoCopyWith(
          RegisterCompanyDto value, $Res Function(RegisterCompanyDto) then) =
      _$RegisterCompanyDtoCopyWithImpl<$Res>;
  $Res call(
      {String type,
      RegisterCompanyDtoProperties properties,
      bool additionalProperties});

  $RegisterCompanyDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$RegisterCompanyDtoCopyWithImpl<$Res>
    implements $RegisterCompanyDtoCopyWith<$Res> {
  _$RegisterCompanyDtoCopyWithImpl(this._value, this._then);

  final RegisterCompanyDto _value;
  // ignore: unused_field
  final $Res Function(RegisterCompanyDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as RegisterCompanyDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $RegisterCompanyDtoPropertiesCopyWith<$Res> get properties {
    return $RegisterCompanyDtoPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_RegisterCompanyDtoCopyWith<$Res>
    implements $RegisterCompanyDtoCopyWith<$Res> {
  factory _$$_RegisterCompanyDtoCopyWith(_$_RegisterCompanyDto value,
          $Res Function(_$_RegisterCompanyDto) then) =
      __$$_RegisterCompanyDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      RegisterCompanyDtoProperties properties,
      bool additionalProperties});

  @override
  $RegisterCompanyDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_RegisterCompanyDtoCopyWithImpl<$Res>
    extends _$RegisterCompanyDtoCopyWithImpl<$Res>
    implements _$$_RegisterCompanyDtoCopyWith<$Res> {
  __$$_RegisterCompanyDtoCopyWithImpl(
      _$_RegisterCompanyDto _value, $Res Function(_$_RegisterCompanyDto) _then)
      : super(_value, (v) => _then(v as _$_RegisterCompanyDto));

  @override
  _$_RegisterCompanyDto get _value => super._value as _$_RegisterCompanyDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_RegisterCompanyDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as RegisterCompanyDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RegisterCompanyDto implements _RegisterCompanyDto {
  const _$_RegisterCompanyDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_RegisterCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$$_RegisterCompanyDtoFromJson(json);

  @override
  final String type;
  @override
  final RegisterCompanyDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'RegisterCompanyDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegisterCompanyDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_RegisterCompanyDtoCopyWith<_$_RegisterCompanyDto> get copyWith =>
      __$$_RegisterCompanyDtoCopyWithImpl<_$_RegisterCompanyDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RegisterCompanyDtoToJson(this);
  }
}

abstract class _RegisterCompanyDto implements RegisterCompanyDto {
  const factory _RegisterCompanyDto(
      {required final String type,
      required final RegisterCompanyDtoProperties properties,
      required final bool additionalProperties}) = _$_RegisterCompanyDto;

  factory _RegisterCompanyDto.fromJson(Map<String, dynamic> json) =
      _$_RegisterCompanyDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  RegisterCompanyDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_RegisterCompanyDtoCopyWith<_$_RegisterCompanyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterCompanyDtoProperties _$RegisterCompanyDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _RegisterCompanyDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$RegisterCompanyDtoProperties {
  Address get company => throw _privateConstructorUsedError;
  Users get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterCompanyDtoPropertiesCopyWith<RegisterCompanyDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterCompanyDtoPropertiesCopyWith<$Res> {
  factory $RegisterCompanyDtoPropertiesCopyWith(
          RegisterCompanyDtoProperties value,
          $Res Function(RegisterCompanyDtoProperties) then) =
      _$RegisterCompanyDtoPropertiesCopyWithImpl<$Res>;
  $Res call({Address company, Users users});

  $AddressCopyWith<$Res> get company;
  $UsersCopyWith<$Res> get users;
}

/// @nodoc
class _$RegisterCompanyDtoPropertiesCopyWithImpl<$Res>
    implements $RegisterCompanyDtoPropertiesCopyWith<$Res> {
  _$RegisterCompanyDtoPropertiesCopyWithImpl(this._value, this._then);

  final RegisterCompanyDtoProperties _value;
  // ignore: unused_field
  final $Res Function(RegisterCompanyDtoProperties) _then;

  @override
  $Res call({
    Object? company = freezed,
    Object? users = freezed,
  }) {
    return _then(_value.copyWith(
      company: company == freezed
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Address,
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Users,
    ));
  }

  @override
  $AddressCopyWith<$Res> get company {
    return $AddressCopyWith<$Res>(_value.company, (value) {
      return _then(_value.copyWith(company: value));
    });
  }

  @override
  $UsersCopyWith<$Res> get users {
    return $UsersCopyWith<$Res>(_value.users, (value) {
      return _then(_value.copyWith(users: value));
    });
  }
}

/// @nodoc
abstract class _$$_RegisterCompanyDtoPropertiesCopyWith<$Res>
    implements $RegisterCompanyDtoPropertiesCopyWith<$Res> {
  factory _$$_RegisterCompanyDtoPropertiesCopyWith(
          _$_RegisterCompanyDtoProperties value,
          $Res Function(_$_RegisterCompanyDtoProperties) then) =
      __$$_RegisterCompanyDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call({Address company, Users users});

  @override
  $AddressCopyWith<$Res> get company;
  @override
  $UsersCopyWith<$Res> get users;
}

/// @nodoc
class __$$_RegisterCompanyDtoPropertiesCopyWithImpl<$Res>
    extends _$RegisterCompanyDtoPropertiesCopyWithImpl<$Res>
    implements _$$_RegisterCompanyDtoPropertiesCopyWith<$Res> {
  __$$_RegisterCompanyDtoPropertiesCopyWithImpl(
      _$_RegisterCompanyDtoProperties _value,
      $Res Function(_$_RegisterCompanyDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_RegisterCompanyDtoProperties));

  @override
  _$_RegisterCompanyDtoProperties get _value =>
      super._value as _$_RegisterCompanyDtoProperties;

  @override
  $Res call({
    Object? company = freezed,
    Object? users = freezed,
  }) {
    return _then(_$_RegisterCompanyDtoProperties(
      company: company == freezed
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Address,
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Users,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RegisterCompanyDtoProperties implements _RegisterCompanyDtoProperties {
  const _$_RegisterCompanyDtoProperties(
      {required this.company, required this.users});

  factory _$_RegisterCompanyDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_RegisterCompanyDtoPropertiesFromJson(json);

  @override
  final Address company;
  @override
  final Users users;

  @override
  String toString() {
    return 'RegisterCompanyDtoProperties(company: $company, users: $users)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegisterCompanyDtoProperties &&
            const DeepCollectionEquality().equals(other.company, company) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(company),
      const DeepCollectionEquality().hash(users));

  @JsonKey(ignore: true)
  @override
  _$$_RegisterCompanyDtoPropertiesCopyWith<_$_RegisterCompanyDtoProperties>
      get copyWith => __$$_RegisterCompanyDtoPropertiesCopyWithImpl<
          _$_RegisterCompanyDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RegisterCompanyDtoPropertiesToJson(this);
  }
}

abstract class _RegisterCompanyDtoProperties
    implements RegisterCompanyDtoProperties {
  const factory _RegisterCompanyDtoProperties(
      {required final Address company,
      required final Users users}) = _$_RegisterCompanyDtoProperties;

  factory _RegisterCompanyDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_RegisterCompanyDtoProperties.fromJson;

  @override
  Address get company => throw _privateConstructorUsedError;
  @override
  Users get users => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_RegisterCompanyDtoPropertiesCopyWith<_$_RegisterCompanyDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

Users _$UsersFromJson(Map<String, dynamic> json) {
  return _Users.fromJson(json);
}

/// @nodoc
mixin _$Users {
  String get type => throw _privateConstructorUsedError;
  Address get items => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsersCopyWith<Users> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersCopyWith<$Res> {
  factory $UsersCopyWith(Users value, $Res Function(Users) then) =
      _$UsersCopyWithImpl<$Res>;
  $Res call({String type, Address items, bool nullable});

  $AddressCopyWith<$Res> get items;
}

/// @nodoc
class _$UsersCopyWithImpl<$Res> implements $UsersCopyWith<$Res> {
  _$UsersCopyWithImpl(this._value, this._then);

  final Users _value;
  // ignore: unused_field
  final $Res Function(Users) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? items = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as Address,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $AddressCopyWith<$Res> get items {
    return $AddressCopyWith<$Res>(_value.items, (value) {
      return _then(_value.copyWith(items: value));
    });
  }
}

/// @nodoc
abstract class _$$_UsersCopyWith<$Res> implements $UsersCopyWith<$Res> {
  factory _$$_UsersCopyWith(_$_Users value, $Res Function(_$_Users) then) =
      __$$_UsersCopyWithImpl<$Res>;
  @override
  $Res call({String type, Address items, bool nullable});

  @override
  $AddressCopyWith<$Res> get items;
}

/// @nodoc
class __$$_UsersCopyWithImpl<$Res> extends _$UsersCopyWithImpl<$Res>
    implements _$$_UsersCopyWith<$Res> {
  __$$_UsersCopyWithImpl(_$_Users _value, $Res Function(_$_Users) _then)
      : super(_value, (v) => _then(v as _$_Users));

  @override
  _$_Users get _value => super._value as _$_Users;

  @override
  $Res call({
    Object? type = freezed,
    Object? items = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_$_Users(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as Address,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Users implements _Users {
  const _$_Users(
      {required this.type, required this.items, required this.nullable});

  factory _$_Users.fromJson(Map<String, dynamic> json) =>
      _$$_UsersFromJson(json);

  @override
  final String type;
  @override
  final Address items;
  @override
  final bool nullable;

  @override
  String toString() {
    return 'Users(type: $type, items: $items, nullable: $nullable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Users &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality().equals(other.nullable, nullable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(nullable));

  @JsonKey(ignore: true)
  @override
  _$$_UsersCopyWith<_$_Users> get copyWith =>
      __$$_UsersCopyWithImpl<_$_Users>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UsersToJson(this);
  }
}

abstract class _Users implements Users {
  const factory _Users(
      {required final String type,
      required final Address items,
      required final bool nullable}) = _$_Users;

  factory _Users.fromJson(Map<String, dynamic> json) = _$_Users.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  Address get items => throw _privateConstructorUsedError;
  @override
  bool get nullable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_UsersCopyWith<_$_Users> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPasswordDto _$ResetPasswordDtoFromJson(Map<String, dynamic> json) {
  return _ResetPasswordDto.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordDto {
  List<String> get required => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  ResetPasswordDtoProperties get properties =>
      throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordDtoCopyWith<ResetPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordDtoCopyWith<$Res> {
  factory $ResetPasswordDtoCopyWith(
          ResetPasswordDto value, $Res Function(ResetPasswordDto) then) =
      _$ResetPasswordDtoCopyWithImpl<$Res>;
  $Res call(
      {List<String> required,
      String type,
      ResetPasswordDtoProperties properties,
      bool additionalProperties});

  $ResetPasswordDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$ResetPasswordDtoCopyWithImpl<$Res>
    implements $ResetPasswordDtoCopyWith<$Res> {
  _$ResetPasswordDtoCopyWithImpl(this._value, this._then);

  final ResetPasswordDto _value;
  // ignore: unused_field
  final $Res Function(ResetPasswordDto) _then;

  @override
  $Res call({
    Object? required = freezed,
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as ResetPasswordDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $ResetPasswordDtoPropertiesCopyWith<$Res> get properties {
    return $ResetPasswordDtoPropertiesCopyWith<$Res>(_value.properties,
        (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_ResetPasswordDtoCopyWith<$Res>
    implements $ResetPasswordDtoCopyWith<$Res> {
  factory _$$_ResetPasswordDtoCopyWith(
          _$_ResetPasswordDto value, $Res Function(_$_ResetPasswordDto) then) =
      __$$_ResetPasswordDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> required,
      String type,
      ResetPasswordDtoProperties properties,
      bool additionalProperties});

  @override
  $ResetPasswordDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_ResetPasswordDtoCopyWithImpl<$Res>
    extends _$ResetPasswordDtoCopyWithImpl<$Res>
    implements _$$_ResetPasswordDtoCopyWith<$Res> {
  __$$_ResetPasswordDtoCopyWithImpl(
      _$_ResetPasswordDto _value, $Res Function(_$_ResetPasswordDto) _then)
      : super(_value, (v) => _then(v as _$_ResetPasswordDto));

  @override
  _$_ResetPasswordDto get _value => super._value as _$_ResetPasswordDto;

  @override
  $Res call({
    Object? required = freezed,
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_ResetPasswordDto(
      required: required == freezed
          ? _value._required
          : required // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as ResetPasswordDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ResetPasswordDto implements _ResetPasswordDto {
  const _$_ResetPasswordDto(
      {required final List<String> required,
      required this.type,
      required this.properties,
      required this.additionalProperties})
      : _required = required;

  factory _$_ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$$_ResetPasswordDtoFromJson(json);

  final List<String> _required;
  @override
  List<String> get required {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_required);
  }

  @override
  final String type;
  @override
  final ResetPasswordDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'ResetPasswordDto(required: $required, type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ResetPasswordDto &&
            const DeepCollectionEquality().equals(other._required, _required) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_required),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_ResetPasswordDtoCopyWith<_$_ResetPasswordDto> get copyWith =>
      __$$_ResetPasswordDtoCopyWithImpl<_$_ResetPasswordDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ResetPasswordDtoToJson(this);
  }
}

abstract class _ResetPasswordDto implements ResetPasswordDto {
  const factory _ResetPasswordDto(
      {required final List<String> required,
      required final String type,
      required final ResetPasswordDtoProperties properties,
      required final bool additionalProperties}) = _$_ResetPasswordDto;

  factory _ResetPasswordDto.fromJson(Map<String, dynamic> json) =
      _$_ResetPasswordDto.fromJson;

  @override
  List<String> get required => throw _privateConstructorUsedError;
  @override
  String get type => throw _privateConstructorUsedError;
  @override
  ResetPasswordDtoProperties get properties =>
      throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ResetPasswordDtoCopyWith<_$_ResetPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPasswordDtoProperties _$ResetPasswordDtoPropertiesFromJson(
    Map<String, dynamic> json) {
  return _ResetPasswordDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordDtoProperties {
  Password get password => throw _privateConstructorUsedError;
  ConfirmPassword get confirmPassword => throw _privateConstructorUsedError;
  City get email => throw _privateConstructorUsedError;
  City get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordDtoPropertiesCopyWith<ResetPasswordDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordDtoPropertiesCopyWith<$Res> {
  factory $ResetPasswordDtoPropertiesCopyWith(ResetPasswordDtoProperties value,
          $Res Function(ResetPasswordDtoProperties) then) =
      _$ResetPasswordDtoPropertiesCopyWithImpl<$Res>;
  $Res call(
      {Password password,
      ConfirmPassword confirmPassword,
      City email,
      City token});

  $PasswordCopyWith<$Res> get password;
  $ConfirmPasswordCopyWith<$Res> get confirmPassword;
  $CityCopyWith<$Res> get email;
  $CityCopyWith<$Res> get token;
}

/// @nodoc
class _$ResetPasswordDtoPropertiesCopyWithImpl<$Res>
    implements $ResetPasswordDtoPropertiesCopyWith<$Res> {
  _$ResetPasswordDtoPropertiesCopyWithImpl(this._value, this._then);

  final ResetPasswordDtoProperties _value;
  // ignore: unused_field
  final $Res Function(ResetPasswordDtoProperties) _then;

  @override
  $Res call({
    Object? password = freezed,
    Object? confirmPassword = freezed,
    Object? email = freezed,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
      confirmPassword: confirmPassword == freezed
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as ConfirmPassword,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }

  @override
  $PasswordCopyWith<$Res> get password {
    return $PasswordCopyWith<$Res>(_value.password, (value) {
      return _then(_value.copyWith(password: value));
    });
  }

  @override
  $ConfirmPasswordCopyWith<$Res> get confirmPassword {
    return $ConfirmPasswordCopyWith<$Res>(_value.confirmPassword, (value) {
      return _then(_value.copyWith(confirmPassword: value));
    });
  }

  @override
  $CityCopyWith<$Res> get email {
    return $CityCopyWith<$Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value));
    });
  }

  @override
  $CityCopyWith<$Res> get token {
    return $CityCopyWith<$Res>(_value.token, (value) {
      return _then(_value.copyWith(token: value));
    });
  }
}

/// @nodoc
abstract class _$$_ResetPasswordDtoPropertiesCopyWith<$Res>
    implements $ResetPasswordDtoPropertiesCopyWith<$Res> {
  factory _$$_ResetPasswordDtoPropertiesCopyWith(
          _$_ResetPasswordDtoProperties value,
          $Res Function(_$_ResetPasswordDtoProperties) then) =
      __$$_ResetPasswordDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call(
      {Password password,
      ConfirmPassword confirmPassword,
      City email,
      City token});

  @override
  $PasswordCopyWith<$Res> get password;
  @override
  $ConfirmPasswordCopyWith<$Res> get confirmPassword;
  @override
  $CityCopyWith<$Res> get email;
  @override
  $CityCopyWith<$Res> get token;
}

/// @nodoc
class __$$_ResetPasswordDtoPropertiesCopyWithImpl<$Res>
    extends _$ResetPasswordDtoPropertiesCopyWithImpl<$Res>
    implements _$$_ResetPasswordDtoPropertiesCopyWith<$Res> {
  __$$_ResetPasswordDtoPropertiesCopyWithImpl(
      _$_ResetPasswordDtoProperties _value,
      $Res Function(_$_ResetPasswordDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_ResetPasswordDtoProperties));

  @override
  _$_ResetPasswordDtoProperties get _value =>
      super._value as _$_ResetPasswordDtoProperties;

  @override
  $Res call({
    Object? password = freezed,
    Object? confirmPassword = freezed,
    Object? email = freezed,
    Object? token = freezed,
  }) {
    return _then(_$_ResetPasswordDtoProperties(
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
      confirmPassword: confirmPassword == freezed
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as ConfirmPassword,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as City,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ResetPasswordDtoProperties implements _ResetPasswordDtoProperties {
  const _$_ResetPasswordDtoProperties(
      {required this.password,
      required this.confirmPassword,
      required this.email,
      required this.token});

  factory _$_ResetPasswordDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_ResetPasswordDtoPropertiesFromJson(json);

  @override
  final Password password;
  @override
  final ConfirmPassword confirmPassword;
  @override
  final City email;
  @override
  final City token;

  @override
  String toString() {
    return 'ResetPasswordDtoProperties(password: $password, confirmPassword: $confirmPassword, email: $email, token: $token)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ResetPasswordDtoProperties &&
            const DeepCollectionEquality().equals(other.password, password) &&
            const DeepCollectionEquality()
                .equals(other.confirmPassword, confirmPassword) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.token, token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(password),
      const DeepCollectionEquality().hash(confirmPassword),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(token));

  @JsonKey(ignore: true)
  @override
  _$$_ResetPasswordDtoPropertiesCopyWith<_$_ResetPasswordDtoProperties>
      get copyWith => __$$_ResetPasswordDtoPropertiesCopyWithImpl<
          _$_ResetPasswordDtoProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ResetPasswordDtoPropertiesToJson(this);
  }
}

abstract class _ResetPasswordDtoProperties
    implements ResetPasswordDtoProperties {
  const factory _ResetPasswordDtoProperties(
      {required final Password password,
      required final ConfirmPassword confirmPassword,
      required final City email,
      required final City token}) = _$_ResetPasswordDtoProperties;

  factory _ResetPasswordDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_ResetPasswordDtoProperties.fromJson;

  @override
  Password get password => throw _privateConstructorUsedError;
  @override
  ConfirmPassword get confirmPassword => throw _privateConstructorUsedError;
  @override
  City get email => throw _privateConstructorUsedError;
  @override
  City get token => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ResetPasswordDtoPropertiesCopyWith<_$_ResetPasswordDtoProperties>
      get copyWith => throw _privateConstructorUsedError;
}

ConfirmPassword _$ConfirmPasswordFromJson(Map<String, dynamic> json) {
  return _ConfirmPassword.fromJson(json);
}

/// @nodoc
mixin _$ConfirmPassword {
  int get maxLength => throw _privateConstructorUsedError;
  Type get type => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfirmPasswordCopyWith<ConfirmPassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmPasswordCopyWith<$Res> {
  factory $ConfirmPasswordCopyWith(
          ConfirmPassword value, $Res Function(ConfirmPassword) then) =
      _$ConfirmPasswordCopyWithImpl<$Res>;
  $Res call({int maxLength, Type type, bool nullable});
}

/// @nodoc
class _$ConfirmPasswordCopyWithImpl<$Res>
    implements $ConfirmPasswordCopyWith<$Res> {
  _$ConfirmPasswordCopyWithImpl(this._value, this._then);

  final ConfirmPassword _value;
  // ignore: unused_field
  final $Res Function(ConfirmPassword) _then;

  @override
  $Res call({
    Object? maxLength = freezed,
    Object? type = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_value.copyWith(
      maxLength: maxLength == freezed
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_ConfirmPasswordCopyWith<$Res>
    implements $ConfirmPasswordCopyWith<$Res> {
  factory _$$_ConfirmPasswordCopyWith(
          _$_ConfirmPassword value, $Res Function(_$_ConfirmPassword) then) =
      __$$_ConfirmPasswordCopyWithImpl<$Res>;
  @override
  $Res call({int maxLength, Type type, bool nullable});
}

/// @nodoc
class __$$_ConfirmPasswordCopyWithImpl<$Res>
    extends _$ConfirmPasswordCopyWithImpl<$Res>
    implements _$$_ConfirmPasswordCopyWith<$Res> {
  __$$_ConfirmPasswordCopyWithImpl(
      _$_ConfirmPassword _value, $Res Function(_$_ConfirmPassword) _then)
      : super(_value, (v) => _then(v as _$_ConfirmPassword));

  @override
  _$_ConfirmPassword get _value => super._value as _$_ConfirmPassword;

  @override
  $Res call({
    Object? maxLength = freezed,
    Object? type = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_$_ConfirmPassword(
      maxLength: maxLength == freezed
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfirmPassword implements _ConfirmPassword {
  const _$_ConfirmPassword(
      {required this.maxLength, required this.type, required this.nullable});

  factory _$_ConfirmPassword.fromJson(Map<String, dynamic> json) =>
      _$$_ConfirmPasswordFromJson(json);

  @override
  final int maxLength;
  @override
  final Type type;
  @override
  final bool nullable;

  @override
  String toString() {
    return 'ConfirmPassword(maxLength: $maxLength, type: $type, nullable: $nullable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConfirmPassword &&
            const DeepCollectionEquality().equals(other.maxLength, maxLength) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.nullable, nullable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(maxLength),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(nullable));

  @JsonKey(ignore: true)
  @override
  _$$_ConfirmPasswordCopyWith<_$_ConfirmPassword> get copyWith =>
      __$$_ConfirmPasswordCopyWithImpl<_$_ConfirmPassword>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfirmPasswordToJson(this);
  }
}

abstract class _ConfirmPassword implements ConfirmPassword {
  const factory _ConfirmPassword(
      {required final int maxLength,
      required final Type type,
      required final bool nullable}) = _$_ConfirmPassword;

  factory _ConfirmPassword.fromJson(Map<String, dynamic> json) =
      _$_ConfirmPassword.fromJson;

  @override
  int get maxLength => throw _privateConstructorUsedError;
  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  bool get nullable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ConfirmPasswordCopyWith<_$_ConfirmPassword> get copyWith =>
      throw _privateConstructorUsedError;
}

Password _$PasswordFromJson(Map<String, dynamic> json) {
  return _Password.fromJson(json);
}

/// @nodoc
mixin _$Password {
  int get maxLength => throw _privateConstructorUsedError;
  Type get type => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordCopyWith<Password> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordCopyWith<$Res> {
  factory $PasswordCopyWith(Password value, $Res Function(Password) then) =
      _$PasswordCopyWithImpl<$Res>;
  $Res call({int maxLength, Type type, String format});
}

/// @nodoc
class _$PasswordCopyWithImpl<$Res> implements $PasswordCopyWith<$Res> {
  _$PasswordCopyWithImpl(this._value, this._then);

  final Password _value;
  // ignore: unused_field
  final $Res Function(Password) _then;

  @override
  $Res call({
    Object? maxLength = freezed,
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_value.copyWith(
      maxLength: maxLength == freezed
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_PasswordCopyWith<$Res> implements $PasswordCopyWith<$Res> {
  factory _$$_PasswordCopyWith(
          _$_Password value, $Res Function(_$_Password) then) =
      __$$_PasswordCopyWithImpl<$Res>;
  @override
  $Res call({int maxLength, Type type, String format});
}

/// @nodoc
class __$$_PasswordCopyWithImpl<$Res> extends _$PasswordCopyWithImpl<$Res>
    implements _$$_PasswordCopyWith<$Res> {
  __$$_PasswordCopyWithImpl(
      _$_Password _value, $Res Function(_$_Password) _then)
      : super(_value, (v) => _then(v as _$_Password));

  @override
  _$_Password get _value => super._value as _$_Password;

  @override
  $Res call({
    Object? maxLength = freezed,
    Object? type = freezed,
    Object? format = freezed,
  }) {
    return _then(_$_Password(
      maxLength: maxLength == freezed
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Password implements _Password {
  const _$_Password(
      {required this.maxLength, required this.type, required this.format});

  factory _$_Password.fromJson(Map<String, dynamic> json) =>
      _$$_PasswordFromJson(json);

  @override
  final int maxLength;
  @override
  final Type type;
  @override
  final String format;

  @override
  String toString() {
    return 'Password(maxLength: $maxLength, type: $type, format: $format)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Password &&
            const DeepCollectionEquality().equals(other.maxLength, maxLength) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.format, format));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(maxLength),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(format));

  @JsonKey(ignore: true)
  @override
  _$$_PasswordCopyWith<_$_Password> get copyWith =>
      __$$_PasswordCopyWithImpl<_$_Password>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PasswordToJson(this);
  }
}

abstract class _Password implements Password {
  const factory _Password(
      {required final int maxLength,
      required final Type type,
      required final String format}) = _$_Password;

  factory _Password.fromJson(Map<String, dynamic> json) = _$_Password.fromJson;

  @override
  int get maxLength => throw _privateConstructorUsedError;
  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  String get format => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PasswordCopyWith<_$_Password> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  String get type => throw _privateConstructorUsedError;
  UserDtoProperties get properties => throw _privateConstructorUsedError;
  bool get additionalProperties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res>;
  $Res call(
      {String type, UserDtoProperties properties, bool additionalProperties});

  $UserDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res> implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  final UserDto _value;
  // ignore: unused_field
  final $Res Function(UserDto) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as UserDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $UserDtoPropertiesCopyWith<$Res> get properties {
    return $UserDtoPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value));
    });
  }
}

/// @nodoc
abstract class _$$_UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$_UserDtoCopyWith(
          _$_UserDto value, $Res Function(_$_UserDto) then) =
      __$$_UserDtoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type, UserDtoProperties properties, bool additionalProperties});

  @override
  $UserDtoPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_UserDtoCopyWithImpl<$Res> extends _$UserDtoCopyWithImpl<$Res>
    implements _$$_UserDtoCopyWith<$Res> {
  __$$_UserDtoCopyWithImpl(_$_UserDto _value, $Res Function(_$_UserDto) _then)
      : super(_value, (v) => _then(v as _$_UserDto));

  @override
  _$_UserDto get _value => super._value as _$_UserDto;

  @override
  $Res call({
    Object? type = freezed,
    Object? properties = freezed,
    Object? additionalProperties = freezed,
  }) {
    return _then(_$_UserDto(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: properties == freezed
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as UserDtoProperties,
      additionalProperties: additionalProperties == freezed
          ? _value.additionalProperties
          : additionalProperties // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserDto implements _UserDto {
  const _$_UserDto(
      {required this.type,
      required this.properties,
      required this.additionalProperties});

  factory _$_UserDto.fromJson(Map<String, dynamic> json) =>
      _$$_UserDtoFromJson(json);

  @override
  final String type;
  @override
  final UserDtoProperties properties;
  @override
  final bool additionalProperties;

  @override
  String toString() {
    return 'UserDto(type: $type, properties: $properties, additionalProperties: $additionalProperties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserDto &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.properties, properties) &&
            const DeepCollectionEquality()
                .equals(other.additionalProperties, additionalProperties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(properties),
      const DeepCollectionEquality().hash(additionalProperties));

  @JsonKey(ignore: true)
  @override
  _$$_UserDtoCopyWith<_$_UserDto> get copyWith =>
      __$$_UserDtoCopyWithImpl<_$_UserDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserDtoToJson(this);
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto(
      {required final String type,
      required final UserDtoProperties properties,
      required final bool additionalProperties}) = _$_UserDto;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$_UserDto.fromJson;

  @override
  String get type => throw _privateConstructorUsedError;
  @override
  UserDtoProperties get properties => throw _privateConstructorUsedError;
  @override
  bool get additionalProperties => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_UserDtoCopyWith<_$_UserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDtoProperties _$UserDtoPropertiesFromJson(Map<String, dynamic> json) {
  return _UserDtoProperties.fromJson(json);
}

/// @nodoc
mixin _$UserDtoProperties {
  City get email => throw _privateConstructorUsedError;
  City get firstName => throw _privateConstructorUsedError;
  City get lastName => throw _privateConstructorUsedError;
  City get salutation => throw _privateConstructorUsedError;
  Users get roles => throw _privateConstructorUsedError;
  City get telephoneNr => throw _privateConstructorUsedError;
  City get title => throw _privateConstructorUsedError;
  CompanyId get companyId => throw _privateConstructorUsedError;
  SubscriptionPlanId get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDtoPropertiesCopyWith<UserDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoPropertiesCopyWith<$Res> {
  factory $UserDtoPropertiesCopyWith(
          UserDtoProperties value, $Res Function(UserDtoProperties) then) =
      _$UserDtoPropertiesCopyWithImpl<$Res>;
  $Res call(
      {City email,
      City firstName,
      City lastName,
      City salutation,
      Users roles,
      City telephoneNr,
      City title,
      CompanyId companyId,
      SubscriptionPlanId id});

  $CityCopyWith<$Res> get email;
  $CityCopyWith<$Res> get firstName;
  $CityCopyWith<$Res> get lastName;
  $CityCopyWith<$Res> get salutation;
  $UsersCopyWith<$Res> get roles;
  $CityCopyWith<$Res> get telephoneNr;
  $CityCopyWith<$Res> get title;
  $CompanyIdCopyWith<$Res> get companyId;
  $SubscriptionPlanIdCopyWith<$Res> get id;
}

/// @nodoc
class _$UserDtoPropertiesCopyWithImpl<$Res>
    implements $UserDtoPropertiesCopyWith<$Res> {
  _$UserDtoPropertiesCopyWithImpl(this._value, this._then);

  final UserDtoProperties _value;
  // ignore: unused_field
  final $Res Function(UserDtoProperties) _then;

  @override
  $Res call({
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? salutation = freezed,
    Object? roles = freezed,
    Object? telephoneNr = freezed,
    Object? title = freezed,
    Object? companyId = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as City,
      lastName: lastName == freezed
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as City,
      salutation: salutation == freezed
          ? _value.salutation
          : salutation // ignore: cast_nullable_to_non_nullable
              as City,
      roles: roles == freezed
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as Users,
      telephoneNr: telephoneNr == freezed
          ? _value.telephoneNr
          : telephoneNr // ignore: cast_nullable_to_non_nullable
              as City,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as City,
      companyId: companyId == freezed
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as CompanyId,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }

  @override
  $CityCopyWith<$Res> get email {
    return $CityCopyWith<$Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value));
    });
  }

  @override
  $CityCopyWith<$Res> get firstName {
    return $CityCopyWith<$Res>(_value.firstName, (value) {
      return _then(_value.copyWith(firstName: value));
    });
  }

  @override
  $CityCopyWith<$Res> get lastName {
    return $CityCopyWith<$Res>(_value.lastName, (value) {
      return _then(_value.copyWith(lastName: value));
    });
  }

  @override
  $CityCopyWith<$Res> get salutation {
    return $CityCopyWith<$Res>(_value.salutation, (value) {
      return _then(_value.copyWith(salutation: value));
    });
  }

  @override
  $UsersCopyWith<$Res> get roles {
    return $UsersCopyWith<$Res>(_value.roles, (value) {
      return _then(_value.copyWith(roles: value));
    });
  }

  @override
  $CityCopyWith<$Res> get telephoneNr {
    return $CityCopyWith<$Res>(_value.telephoneNr, (value) {
      return _then(_value.copyWith(telephoneNr: value));
    });
  }

  @override
  $CityCopyWith<$Res> get title {
    return $CityCopyWith<$Res>(_value.title, (value) {
      return _then(_value.copyWith(title: value));
    });
  }

  @override
  $CompanyIdCopyWith<$Res> get companyId {
    return $CompanyIdCopyWith<$Res>(_value.companyId, (value) {
      return _then(_value.copyWith(companyId: value));
    });
  }

  @override
  $SubscriptionPlanIdCopyWith<$Res> get id {
    return $SubscriptionPlanIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value));
    });
  }
}

/// @nodoc
abstract class _$$_UserDtoPropertiesCopyWith<$Res>
    implements $UserDtoPropertiesCopyWith<$Res> {
  factory _$$_UserDtoPropertiesCopyWith(_$_UserDtoProperties value,
          $Res Function(_$_UserDtoProperties) then) =
      __$$_UserDtoPropertiesCopyWithImpl<$Res>;
  @override
  $Res call(
      {City email,
      City firstName,
      City lastName,
      City salutation,
      Users roles,
      City telephoneNr,
      City title,
      CompanyId companyId,
      SubscriptionPlanId id});

  @override
  $CityCopyWith<$Res> get email;
  @override
  $CityCopyWith<$Res> get firstName;
  @override
  $CityCopyWith<$Res> get lastName;
  @override
  $CityCopyWith<$Res> get salutation;
  @override
  $UsersCopyWith<$Res> get roles;
  @override
  $CityCopyWith<$Res> get telephoneNr;
  @override
  $CityCopyWith<$Res> get title;
  @override
  $CompanyIdCopyWith<$Res> get companyId;
  @override
  $SubscriptionPlanIdCopyWith<$Res> get id;
}

/// @nodoc
class __$$_UserDtoPropertiesCopyWithImpl<$Res>
    extends _$UserDtoPropertiesCopyWithImpl<$Res>
    implements _$$_UserDtoPropertiesCopyWith<$Res> {
  __$$_UserDtoPropertiesCopyWithImpl(
      _$_UserDtoProperties _value, $Res Function(_$_UserDtoProperties) _then)
      : super(_value, (v) => _then(v as _$_UserDtoProperties));

  @override
  _$_UserDtoProperties get _value => super._value as _$_UserDtoProperties;

  @override
  $Res call({
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? salutation = freezed,
    Object? roles = freezed,
    Object? telephoneNr = freezed,
    Object? title = freezed,
    Object? companyId = freezed,
    Object? id = freezed,
  }) {
    return _then(_$_UserDtoProperties(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as City,
      firstName: firstName == freezed
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as City,
      lastName: lastName == freezed
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as City,
      salutation: salutation == freezed
          ? _value.salutation
          : salutation // ignore: cast_nullable_to_non_nullable
              as City,
      roles: roles == freezed
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as Users,
      telephoneNr: telephoneNr == freezed
          ? _value.telephoneNr
          : telephoneNr // ignore: cast_nullable_to_non_nullable
              as City,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as City,
      companyId: companyId == freezed
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as CompanyId,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserDtoProperties implements _UserDtoProperties {
  const _$_UserDtoProperties(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.salutation,
      required this.roles,
      required this.telephoneNr,
      required this.title,
      required this.companyId,
      required this.id});

  factory _$_UserDtoProperties.fromJson(Map<String, dynamic> json) =>
      _$$_UserDtoPropertiesFromJson(json);

  @override
  final City email;
  @override
  final City firstName;
  @override
  final City lastName;
  @override
  final City salutation;
  @override
  final Users roles;
  @override
  final City telephoneNr;
  @override
  final City title;
  @override
  final CompanyId companyId;
  @override
  final SubscriptionPlanId id;

  @override
  String toString() {
    return 'UserDtoProperties(email: $email, firstName: $firstName, lastName: $lastName, salutation: $salutation, roles: $roles, telephoneNr: $telephoneNr, title: $title, companyId: $companyId, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserDtoProperties &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.firstName, firstName) &&
            const DeepCollectionEquality().equals(other.lastName, lastName) &&
            const DeepCollectionEquality()
                .equals(other.salutation, salutation) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            const DeepCollectionEquality()
                .equals(other.telephoneNr, telephoneNr) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.companyId, companyId) &&
            const DeepCollectionEquality().equals(other.id, id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(firstName),
      const DeepCollectionEquality().hash(lastName),
      const DeepCollectionEquality().hash(salutation),
      const DeepCollectionEquality().hash(roles),
      const DeepCollectionEquality().hash(telephoneNr),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(companyId),
      const DeepCollectionEquality().hash(id));

  @JsonKey(ignore: true)
  @override
  _$$_UserDtoPropertiesCopyWith<_$_UserDtoProperties> get copyWith =>
      __$$_UserDtoPropertiesCopyWithImpl<_$_UserDtoProperties>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserDtoPropertiesToJson(this);
  }
}

abstract class _UserDtoProperties implements UserDtoProperties {
  const factory _UserDtoProperties(
      {required final City email,
      required final City firstName,
      required final City lastName,
      required final City salutation,
      required final Users roles,
      required final City telephoneNr,
      required final City title,
      required final CompanyId companyId,
      required final SubscriptionPlanId id}) = _$_UserDtoProperties;

  factory _UserDtoProperties.fromJson(Map<String, dynamic> json) =
      _$_UserDtoProperties.fromJson;

  @override
  City get email => throw _privateConstructorUsedError;
  @override
  City get firstName => throw _privateConstructorUsedError;
  @override
  City get lastName => throw _privateConstructorUsedError;
  @override
  City get salutation => throw _privateConstructorUsedError;
  @override
  Users get roles => throw _privateConstructorUsedError;
  @override
  City get telephoneNr => throw _privateConstructorUsedError;
  @override
  City get title => throw _privateConstructorUsedError;
  @override
  CompanyId get companyId => throw _privateConstructorUsedError;
  @override
  SubscriptionPlanId get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_UserDtoPropertiesCopyWith<_$_UserDtoProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyId _$CompanyIdFromJson(Map<String, dynamic> json) {
  return _CompanyId.fromJson(json);
}

/// @nodoc
mixin _$CompanyId {
  Type get type => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  bool get nullable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyIdCopyWith<CompanyId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyIdCopyWith<$Res> {
  factory $CompanyIdCopyWith(CompanyId value, $Res Function(CompanyId) then) =
      _$CompanyIdCopyWithImpl<$Res>;
  $Res call({Type type, String format, bool nullable});
}

/// @nodoc
class _$CompanyIdCopyWithImpl<$Res> implements $CompanyIdCopyWith<$Res> {
  _$CompanyIdCopyWithImpl(this._value, this._then);

  final CompanyId _value;
  // ignore: unused_field
  final $Res Function(CompanyId) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_CompanyIdCopyWith<$Res> implements $CompanyIdCopyWith<$Res> {
  factory _$$_CompanyIdCopyWith(
          _$_CompanyId value, $Res Function(_$_CompanyId) then) =
      __$$_CompanyIdCopyWithImpl<$Res>;
  @override
  $Res call({Type type, String format, bool nullable});
}

/// @nodoc
class __$$_CompanyIdCopyWithImpl<$Res> extends _$CompanyIdCopyWithImpl<$Res>
    implements _$$_CompanyIdCopyWith<$Res> {
  __$$_CompanyIdCopyWithImpl(
      _$_CompanyId _value, $Res Function(_$_CompanyId) _then)
      : super(_value, (v) => _then(v as _$_CompanyId));

  @override
  _$_CompanyId get _value => super._value as _$_CompanyId;

  @override
  $Res call({
    Object? type = freezed,
    Object? format = freezed,
    Object? nullable = freezed,
  }) {
    return _then(_$_CompanyId(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
      format: format == freezed
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      nullable: nullable == freezed
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompanyId implements _CompanyId {
  const _$_CompanyId(
      {required this.type, required this.format, required this.nullable});

  factory _$_CompanyId.fromJson(Map<String, dynamic> json) =>
      _$$_CompanyIdFromJson(json);

  @override
  final Type type;
  @override
  final String format;
  @override
  final bool nullable;

  @override
  String toString() {
    return 'CompanyId(type: $type, format: $format, nullable: $nullable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompanyId &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.format, format) &&
            const DeepCollectionEquality().equals(other.nullable, nullable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(format),
      const DeepCollectionEquality().hash(nullable));

  @JsonKey(ignore: true)
  @override
  _$$_CompanyIdCopyWith<_$_CompanyId> get copyWith =>
      __$$_CompanyIdCopyWithImpl<_$_CompanyId>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompanyIdToJson(this);
  }
}

abstract class _CompanyId implements CompanyId {
  const factory _CompanyId(
      {required final Type type,
      required final String format,
      required final bool nullable}) = _$_CompanyId;

  factory _CompanyId.fromJson(Map<String, dynamic> json) =
      _$_CompanyId.fromJson;

  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  String get format => throw _privateConstructorUsedError;
  @override
  bool get nullable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompanyIdCopyWith<_$_CompanyId> get copyWith =>
      throw _privateConstructorUsedError;
}

Info _$InfoFromJson(Map<String, dynamic> json) {
  return _Info.fromJson(json);
}

/// @nodoc
mixin _$Info {
  String get title => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InfoCopyWith<Info> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoCopyWith<$Res> {
  factory $InfoCopyWith(Info value, $Res Function(Info) then) =
      _$InfoCopyWithImpl<$Res>;
  $Res call({String title, String version});
}

/// @nodoc
class _$InfoCopyWithImpl<$Res> implements $InfoCopyWith<$Res> {
  _$InfoCopyWithImpl(this._value, this._then);

  final Info _value;
  // ignore: unused_field
  final $Res Function(Info) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? version = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_InfoCopyWith<$Res> implements $InfoCopyWith<$Res> {
  factory _$$_InfoCopyWith(_$_Info value, $Res Function(_$_Info) then) =
      __$$_InfoCopyWithImpl<$Res>;
  @override
  $Res call({String title, String version});
}

/// @nodoc
class __$$_InfoCopyWithImpl<$Res> extends _$InfoCopyWithImpl<$Res>
    implements _$$_InfoCopyWith<$Res> {
  __$$_InfoCopyWithImpl(_$_Info _value, $Res Function(_$_Info) _then)
      : super(_value, (v) => _then(v as _$_Info));

  @override
  _$_Info get _value => super._value as _$_Info;

  @override
  $Res call({
    Object? title = freezed,
    Object? version = freezed,
  }) {
    return _then(_$_Info(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      version: version == freezed
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Info implements _Info {
  const _$_Info({required this.title, required this.version});

  factory _$_Info.fromJson(Map<String, dynamic> json) => _$$_InfoFromJson(json);

  @override
  final String title;
  @override
  final String version;

  @override
  String toString() {
    return 'Info(title: $title, version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Info &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.version, version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(version));

  @JsonKey(ignore: true)
  @override
  _$$_InfoCopyWith<_$_Info> get copyWith =>
      __$$_InfoCopyWithImpl<_$_Info>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InfoToJson(this);
  }
}

abstract class _Info implements Info {
  const factory _Info(
      {required final String title, required final String version}) = _$_Info;

  factory _Info.fromJson(Map<String, dynamic> json) = _$_Info.fromJson;

  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get version => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_InfoCopyWith<_$_Info> get copyWith => throw _privateConstructorUsedError;
}

Paths _$PathsFromJson(Map<String, dynamic> json) {
  return _Paths.fromJson(json);
}

/// @nodoc
mixin _$Paths {
  CompaniesCompanyIdRegisterUser get authForgotPassword =>
      throw _privateConstructorUsedError;
  AuthConfirmEmail get authConfirmEmail => throw _privateConstructorUsedError;
  CompaniesCompanyIdRegisterUser get authResetPassword =>
      throw _privateConstructorUsedError;
  CompaniesCompanyIdRegisterUser get authLogin =>
      throw _privateConstructorUsedError;
  CompaniesRegister get companiesRegister => throw _privateConstructorUsedError;
  CompaniesCompanyIdUsers get companiesCompanyIdUsers =>
      throw _privateConstructorUsedError;
  CompaniesCompanyIdUsersUserId get companiesCompanyIdUsersUserId =>
      throw _privateConstructorUsedError;
  CompaniesCompanyIdRegisterUser get companiesCompanyIdRegisterUser =>
      throw _privateConstructorUsedError;
  CompaniesCompanyIdUsersUserIdUpdate get companiesCompanyIdUsersUserIdUpdate =>
      throw _privateConstructorUsedError;
  Companies get companies => throw _privateConstructorUsedError;
  CompaniesCompanyId get companiesCompanyId =>
      throw _privateConstructorUsedError;
  Companies get subscriptions => throw _privateConstructorUsedError;
  CompaniesCompanyId get usersLoadUserWithCompany =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PathsCopyWith<Paths> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathsCopyWith<$Res> {
  factory $PathsCopyWith(Paths value, $Res Function(Paths) then) =
      _$PathsCopyWithImpl<$Res>;
  $Res call(
      {CompaniesCompanyIdRegisterUser authForgotPassword,
      AuthConfirmEmail authConfirmEmail,
      CompaniesCompanyIdRegisterUser authResetPassword,
      CompaniesCompanyIdRegisterUser authLogin,
      CompaniesRegister companiesRegister,
      CompaniesCompanyIdUsers companiesCompanyIdUsers,
      CompaniesCompanyIdUsersUserId companiesCompanyIdUsersUserId,
      CompaniesCompanyIdRegisterUser companiesCompanyIdRegisterUser,
      CompaniesCompanyIdUsersUserIdUpdate companiesCompanyIdUsersUserIdUpdate,
      Companies companies,
      CompaniesCompanyId companiesCompanyId,
      Companies subscriptions,
      CompaniesCompanyId usersLoadUserWithCompany});

  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authForgotPassword;
  $AuthConfirmEmailCopyWith<$Res> get authConfirmEmail;
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authResetPassword;
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authLogin;
  $CompaniesRegisterCopyWith<$Res> get companiesRegister;
  $CompaniesCompanyIdUsersCopyWith<$Res> get companiesCompanyIdUsers;
  $CompaniesCompanyIdUsersUserIdCopyWith<$Res>
      get companiesCompanyIdUsersUserId;
  $CompaniesCompanyIdRegisterUserCopyWith<$Res>
      get companiesCompanyIdRegisterUser;
  $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res>
      get companiesCompanyIdUsersUserIdUpdate;
  $CompaniesCopyWith<$Res> get companies;
  $CompaniesCompanyIdCopyWith<$Res> get companiesCompanyId;
  $CompaniesCopyWith<$Res> get subscriptions;
  $CompaniesCompanyIdCopyWith<$Res> get usersLoadUserWithCompany;
}

/// @nodoc
class _$PathsCopyWithImpl<$Res> implements $PathsCopyWith<$Res> {
  _$PathsCopyWithImpl(this._value, this._then);

  final Paths _value;
  // ignore: unused_field
  final $Res Function(Paths) _then;

  @override
  $Res call({
    Object? authForgotPassword = freezed,
    Object? authConfirmEmail = freezed,
    Object? authResetPassword = freezed,
    Object? authLogin = freezed,
    Object? companiesRegister = freezed,
    Object? companiesCompanyIdUsers = freezed,
    Object? companiesCompanyIdUsersUserId = freezed,
    Object? companiesCompanyIdRegisterUser = freezed,
    Object? companiesCompanyIdUsersUserIdUpdate = freezed,
    Object? companies = freezed,
    Object? companiesCompanyId = freezed,
    Object? subscriptions = freezed,
    Object? usersLoadUserWithCompany = freezed,
  }) {
    return _then(_value.copyWith(
      authForgotPassword: authForgotPassword == freezed
          ? _value.authForgotPassword
          : authForgotPassword // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      authConfirmEmail: authConfirmEmail == freezed
          ? _value.authConfirmEmail
          : authConfirmEmail // ignore: cast_nullable_to_non_nullable
              as AuthConfirmEmail,
      authResetPassword: authResetPassword == freezed
          ? _value.authResetPassword
          : authResetPassword // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      authLogin: authLogin == freezed
          ? _value.authLogin
          : authLogin // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      companiesRegister: companiesRegister == freezed
          ? _value.companiesRegister
          : companiesRegister // ignore: cast_nullable_to_non_nullable
              as CompaniesRegister,
      companiesCompanyIdUsers: companiesCompanyIdUsers == freezed
          ? _value.companiesCompanyIdUsers
          : companiesCompanyIdUsers // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsers,
      companiesCompanyIdUsersUserId: companiesCompanyIdUsersUserId == freezed
          ? _value.companiesCompanyIdUsersUserId
          : companiesCompanyIdUsersUserId // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsersUserId,
      companiesCompanyIdRegisterUser: companiesCompanyIdRegisterUser == freezed
          ? _value.companiesCompanyIdRegisterUser
          : companiesCompanyIdRegisterUser // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      companiesCompanyIdUsersUserIdUpdate: companiesCompanyIdUsersUserIdUpdate ==
              freezed
          ? _value.companiesCompanyIdUsersUserIdUpdate
          : companiesCompanyIdUsersUserIdUpdate // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsersUserIdUpdate,
      companies: companies == freezed
          ? _value.companies
          : companies // ignore: cast_nullable_to_non_nullable
              as Companies,
      companiesCompanyId: companiesCompanyId == freezed
          ? _value.companiesCompanyId
          : companiesCompanyId // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyId,
      subscriptions: subscriptions == freezed
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as Companies,
      usersLoadUserWithCompany: usersLoadUserWithCompany == freezed
          ? _value.usersLoadUserWithCompany
          : usersLoadUserWithCompany // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyId,
    ));
  }

  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authForgotPassword {
    return $CompaniesCompanyIdRegisterUserCopyWith<$Res>(
        _value.authForgotPassword, (value) {
      return _then(_value.copyWith(authForgotPassword: value));
    });
  }

  @override
  $AuthConfirmEmailCopyWith<$Res> get authConfirmEmail {
    return $AuthConfirmEmailCopyWith<$Res>(_value.authConfirmEmail, (value) {
      return _then(_value.copyWith(authConfirmEmail: value));
    });
  }

  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authResetPassword {
    return $CompaniesCompanyIdRegisterUserCopyWith<$Res>(
        _value.authResetPassword, (value) {
      return _then(_value.copyWith(authResetPassword: value));
    });
  }

  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authLogin {
    return $CompaniesCompanyIdRegisterUserCopyWith<$Res>(_value.authLogin,
        (value) {
      return _then(_value.copyWith(authLogin: value));
    });
  }

  @override
  $CompaniesRegisterCopyWith<$Res> get companiesRegister {
    return $CompaniesRegisterCopyWith<$Res>(_value.companiesRegister, (value) {
      return _then(_value.copyWith(companiesRegister: value));
    });
  }

  @override
  $CompaniesCompanyIdUsersCopyWith<$Res> get companiesCompanyIdUsers {
    return $CompaniesCompanyIdUsersCopyWith<$Res>(
        _value.companiesCompanyIdUsers, (value) {
      return _then(_value.copyWith(companiesCompanyIdUsers: value));
    });
  }

  @override
  $CompaniesCompanyIdUsersUserIdCopyWith<$Res>
      get companiesCompanyIdUsersUserId {
    return $CompaniesCompanyIdUsersUserIdCopyWith<$Res>(
        _value.companiesCompanyIdUsersUserId, (value) {
      return _then(_value.copyWith(companiesCompanyIdUsersUserId: value));
    });
  }

  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res>
      get companiesCompanyIdRegisterUser {
    return $CompaniesCompanyIdRegisterUserCopyWith<$Res>(
        _value.companiesCompanyIdRegisterUser, (value) {
      return _then(_value.copyWith(companiesCompanyIdRegisterUser: value));
    });
  }

  @override
  $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res>
      get companiesCompanyIdUsersUserIdUpdate {
    return $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res>(
        _value.companiesCompanyIdUsersUserIdUpdate, (value) {
      return _then(_value.copyWith(companiesCompanyIdUsersUserIdUpdate: value));
    });
  }

  @override
  $CompaniesCopyWith<$Res> get companies {
    return $CompaniesCopyWith<$Res>(_value.companies, (value) {
      return _then(_value.copyWith(companies: value));
    });
  }

  @override
  $CompaniesCompanyIdCopyWith<$Res> get companiesCompanyId {
    return $CompaniesCompanyIdCopyWith<$Res>(_value.companiesCompanyId,
        (value) {
      return _then(_value.copyWith(companiesCompanyId: value));
    });
  }

  @override
  $CompaniesCopyWith<$Res> get subscriptions {
    return $CompaniesCopyWith<$Res>(_value.subscriptions, (value) {
      return _then(_value.copyWith(subscriptions: value));
    });
  }

  @override
  $CompaniesCompanyIdCopyWith<$Res> get usersLoadUserWithCompany {
    return $CompaniesCompanyIdCopyWith<$Res>(_value.usersLoadUserWithCompany,
        (value) {
      return _then(_value.copyWith(usersLoadUserWithCompany: value));
    });
  }
}

/// @nodoc
abstract class _$$_PathsCopyWith<$Res> implements $PathsCopyWith<$Res> {
  factory _$$_PathsCopyWith(_$_Paths value, $Res Function(_$_Paths) then) =
      __$$_PathsCopyWithImpl<$Res>;
  @override
  $Res call(
      {CompaniesCompanyIdRegisterUser authForgotPassword,
      AuthConfirmEmail authConfirmEmail,
      CompaniesCompanyIdRegisterUser authResetPassword,
      CompaniesCompanyIdRegisterUser authLogin,
      CompaniesRegister companiesRegister,
      CompaniesCompanyIdUsers companiesCompanyIdUsers,
      CompaniesCompanyIdUsersUserId companiesCompanyIdUsersUserId,
      CompaniesCompanyIdRegisterUser companiesCompanyIdRegisterUser,
      CompaniesCompanyIdUsersUserIdUpdate companiesCompanyIdUsersUserIdUpdate,
      Companies companies,
      CompaniesCompanyId companiesCompanyId,
      Companies subscriptions,
      CompaniesCompanyId usersLoadUserWithCompany});

  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authForgotPassword;
  @override
  $AuthConfirmEmailCopyWith<$Res> get authConfirmEmail;
  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authResetPassword;
  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res> get authLogin;
  @override
  $CompaniesRegisterCopyWith<$Res> get companiesRegister;
  @override
  $CompaniesCompanyIdUsersCopyWith<$Res> get companiesCompanyIdUsers;
  @override
  $CompaniesCompanyIdUsersUserIdCopyWith<$Res>
      get companiesCompanyIdUsersUserId;
  @override
  $CompaniesCompanyIdRegisterUserCopyWith<$Res>
      get companiesCompanyIdRegisterUser;
  @override
  $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res>
      get companiesCompanyIdUsersUserIdUpdate;
  @override
  $CompaniesCopyWith<$Res> get companies;
  @override
  $CompaniesCompanyIdCopyWith<$Res> get companiesCompanyId;
  @override
  $CompaniesCopyWith<$Res> get subscriptions;
  @override
  $CompaniesCompanyIdCopyWith<$Res> get usersLoadUserWithCompany;
}

/// @nodoc
class __$$_PathsCopyWithImpl<$Res> extends _$PathsCopyWithImpl<$Res>
    implements _$$_PathsCopyWith<$Res> {
  __$$_PathsCopyWithImpl(_$_Paths _value, $Res Function(_$_Paths) _then)
      : super(_value, (v) => _then(v as _$_Paths));

  @override
  _$_Paths get _value => super._value as _$_Paths;

  @override
  $Res call({
    Object? authForgotPassword = freezed,
    Object? authConfirmEmail = freezed,
    Object? authResetPassword = freezed,
    Object? authLogin = freezed,
    Object? companiesRegister = freezed,
    Object? companiesCompanyIdUsers = freezed,
    Object? companiesCompanyIdUsersUserId = freezed,
    Object? companiesCompanyIdRegisterUser = freezed,
    Object? companiesCompanyIdUsersUserIdUpdate = freezed,
    Object? companies = freezed,
    Object? companiesCompanyId = freezed,
    Object? subscriptions = freezed,
    Object? usersLoadUserWithCompany = freezed,
  }) {
    return _then(_$_Paths(
      authForgotPassword: authForgotPassword == freezed
          ? _value.authForgotPassword
          : authForgotPassword // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      authConfirmEmail: authConfirmEmail == freezed
          ? _value.authConfirmEmail
          : authConfirmEmail // ignore: cast_nullable_to_non_nullable
              as AuthConfirmEmail,
      authResetPassword: authResetPassword == freezed
          ? _value.authResetPassword
          : authResetPassword // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      authLogin: authLogin == freezed
          ? _value.authLogin
          : authLogin // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      companiesRegister: companiesRegister == freezed
          ? _value.companiesRegister
          : companiesRegister // ignore: cast_nullable_to_non_nullable
              as CompaniesRegister,
      companiesCompanyIdUsers: companiesCompanyIdUsers == freezed
          ? _value.companiesCompanyIdUsers
          : companiesCompanyIdUsers // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsers,
      companiesCompanyIdUsersUserId: companiesCompanyIdUsersUserId == freezed
          ? _value.companiesCompanyIdUsersUserId
          : companiesCompanyIdUsersUserId // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsersUserId,
      companiesCompanyIdRegisterUser: companiesCompanyIdRegisterUser == freezed
          ? _value.companiesCompanyIdRegisterUser
          : companiesCompanyIdRegisterUser // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdRegisterUser,
      companiesCompanyIdUsersUserIdUpdate: companiesCompanyIdUsersUserIdUpdate ==
              freezed
          ? _value.companiesCompanyIdUsersUserIdUpdate
          : companiesCompanyIdUsersUserIdUpdate // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdUsersUserIdUpdate,
      companies: companies == freezed
          ? _value.companies
          : companies // ignore: cast_nullable_to_non_nullable
              as Companies,
      companiesCompanyId: companiesCompanyId == freezed
          ? _value.companiesCompanyId
          : companiesCompanyId // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyId,
      subscriptions: subscriptions == freezed
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as Companies,
      usersLoadUserWithCompany: usersLoadUserWithCompany == freezed
          ? _value.usersLoadUserWithCompany
          : usersLoadUserWithCompany // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyId,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Paths implements _Paths {
  const _$_Paths(
      {required this.authForgotPassword,
      required this.authConfirmEmail,
      required this.authResetPassword,
      required this.authLogin,
      required this.companiesRegister,
      required this.companiesCompanyIdUsers,
      required this.companiesCompanyIdUsersUserId,
      required this.companiesCompanyIdRegisterUser,
      required this.companiesCompanyIdUsersUserIdUpdate,
      required this.companies,
      required this.companiesCompanyId,
      required this.subscriptions,
      required this.usersLoadUserWithCompany});

  factory _$_Paths.fromJson(Map<String, dynamic> json) =>
      _$$_PathsFromJson(json);

  @override
  final CompaniesCompanyIdRegisterUser authForgotPassword;
  @override
  final AuthConfirmEmail authConfirmEmail;
  @override
  final CompaniesCompanyIdRegisterUser authResetPassword;
  @override
  final CompaniesCompanyIdRegisterUser authLogin;
  @override
  final CompaniesRegister companiesRegister;
  @override
  final CompaniesCompanyIdUsers companiesCompanyIdUsers;
  @override
  final CompaniesCompanyIdUsersUserId companiesCompanyIdUsersUserId;
  @override
  final CompaniesCompanyIdRegisterUser companiesCompanyIdRegisterUser;
  @override
  final CompaniesCompanyIdUsersUserIdUpdate companiesCompanyIdUsersUserIdUpdate;
  @override
  final Companies companies;
  @override
  final CompaniesCompanyId companiesCompanyId;
  @override
  final Companies subscriptions;
  @override
  final CompaniesCompanyId usersLoadUserWithCompany;

  @override
  String toString() {
    return 'Paths(authForgotPassword: $authForgotPassword, authConfirmEmail: $authConfirmEmail, authResetPassword: $authResetPassword, authLogin: $authLogin, companiesRegister: $companiesRegister, companiesCompanyIdUsers: $companiesCompanyIdUsers, companiesCompanyIdUsersUserId: $companiesCompanyIdUsersUserId, companiesCompanyIdRegisterUser: $companiesCompanyIdRegisterUser, companiesCompanyIdUsersUserIdUpdate: $companiesCompanyIdUsersUserIdUpdate, companies: $companies, companiesCompanyId: $companiesCompanyId, subscriptions: $subscriptions, usersLoadUserWithCompany: $usersLoadUserWithCompany)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Paths &&
            const DeepCollectionEquality()
                .equals(other.authForgotPassword, authForgotPassword) &&
            const DeepCollectionEquality()
                .equals(other.authConfirmEmail, authConfirmEmail) &&
            const DeepCollectionEquality()
                .equals(other.authResetPassword, authResetPassword) &&
            const DeepCollectionEquality().equals(other.authLogin, authLogin) &&
            const DeepCollectionEquality()
                .equals(other.companiesRegister, companiesRegister) &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdUsers, companiesCompanyIdUsers) &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdUsersUserId,
                companiesCompanyIdUsersUserId) &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdRegisterUser,
                companiesCompanyIdRegisterUser) &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdUsersUserIdUpdate,
                companiesCompanyIdUsersUserIdUpdate) &&
            const DeepCollectionEquality().equals(other.companies, companies) &&
            const DeepCollectionEquality()
                .equals(other.companiesCompanyId, companiesCompanyId) &&
            const DeepCollectionEquality()
                .equals(other.subscriptions, subscriptions) &&
            const DeepCollectionEquality().equals(
                other.usersLoadUserWithCompany, usersLoadUserWithCompany));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(authForgotPassword),
      const DeepCollectionEquality().hash(authConfirmEmail),
      const DeepCollectionEquality().hash(authResetPassword),
      const DeepCollectionEquality().hash(authLogin),
      const DeepCollectionEquality().hash(companiesRegister),
      const DeepCollectionEquality().hash(companiesCompanyIdUsers),
      const DeepCollectionEquality().hash(companiesCompanyIdUsersUserId),
      const DeepCollectionEquality().hash(companiesCompanyIdRegisterUser),
      const DeepCollectionEquality().hash(companiesCompanyIdUsersUserIdUpdate),
      const DeepCollectionEquality().hash(companies),
      const DeepCollectionEquality().hash(companiesCompanyId),
      const DeepCollectionEquality().hash(subscriptions),
      const DeepCollectionEquality().hash(usersLoadUserWithCompany));

  @JsonKey(ignore: true)
  @override
  _$$_PathsCopyWith<_$_Paths> get copyWith =>
      __$$_PathsCopyWithImpl<_$_Paths>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PathsToJson(this);
  }
}

abstract class _Paths implements Paths {
  const factory _Paths(
      {required final CompaniesCompanyIdRegisterUser authForgotPassword,
      required final AuthConfirmEmail authConfirmEmail,
      required final CompaniesCompanyIdRegisterUser authResetPassword,
      required final CompaniesCompanyIdRegisterUser authLogin,
      required final CompaniesRegister companiesRegister,
      required final CompaniesCompanyIdUsers companiesCompanyIdUsers,
      required final CompaniesCompanyIdUsersUserId
          companiesCompanyIdUsersUserId,
      required final CompaniesCompanyIdRegisterUser
          companiesCompanyIdRegisterUser,
      required final CompaniesCompanyIdUsersUserIdUpdate
          companiesCompanyIdUsersUserIdUpdate,
      required final Companies companies,
      required final CompaniesCompanyId companiesCompanyId,
      required final Companies subscriptions,
      required final CompaniesCompanyId usersLoadUserWithCompany}) = _$_Paths;

  factory _Paths.fromJson(Map<String, dynamic> json) = _$_Paths.fromJson;

  @override
  CompaniesCompanyIdRegisterUser get authForgotPassword =>
      throw _privateConstructorUsedError;
  @override
  AuthConfirmEmail get authConfirmEmail => throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdRegisterUser get authResetPassword =>
      throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdRegisterUser get authLogin =>
      throw _privateConstructorUsedError;
  @override
  CompaniesRegister get companiesRegister => throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdUsers get companiesCompanyIdUsers =>
      throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdUsersUserId get companiesCompanyIdUsersUserId =>
      throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdRegisterUser get companiesCompanyIdRegisterUser =>
      throw _privateConstructorUsedError;
  @override
  CompaniesCompanyIdUsersUserIdUpdate get companiesCompanyIdUsersUserIdUpdate =>
      throw _privateConstructorUsedError;
  @override
  Companies get companies => throw _privateConstructorUsedError;
  @override
  CompaniesCompanyId get companiesCompanyId =>
      throw _privateConstructorUsedError;
  @override
  Companies get subscriptions => throw _privateConstructorUsedError;
  @override
  CompaniesCompanyId get usersLoadUserWithCompany =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PathsCopyWith<_$_Paths> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthConfirmEmail _$AuthConfirmEmailFromJson(Map<String, dynamic> json) {
  return _AuthConfirmEmail.fromJson(json);
}

/// @nodoc
mixin _$AuthConfirmEmail {
  AuthConfirmEmailGet get authConfirmEmailGet =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthConfirmEmailCopyWith<AuthConfirmEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthConfirmEmailCopyWith<$Res> {
  factory $AuthConfirmEmailCopyWith(
          AuthConfirmEmail value, $Res Function(AuthConfirmEmail) then) =
      _$AuthConfirmEmailCopyWithImpl<$Res>;
  $Res call({AuthConfirmEmailGet authConfirmEmailGet});

  $AuthConfirmEmailGetCopyWith<$Res> get authConfirmEmailGet;
}

/// @nodoc
class _$AuthConfirmEmailCopyWithImpl<$Res>
    implements $AuthConfirmEmailCopyWith<$Res> {
  _$AuthConfirmEmailCopyWithImpl(this._value, this._then);

  final AuthConfirmEmail _value;
  // ignore: unused_field
  final $Res Function(AuthConfirmEmail) _then;

  @override
  $Res call({
    Object? authConfirmEmailGet = freezed,
  }) {
    return _then(_value.copyWith(
      authConfirmEmailGet: authConfirmEmailGet == freezed
          ? _value.authConfirmEmailGet
          : authConfirmEmailGet // ignore: cast_nullable_to_non_nullable
              as AuthConfirmEmailGet,
    ));
  }

  @override
  $AuthConfirmEmailGetCopyWith<$Res> get authConfirmEmailGet {
    return $AuthConfirmEmailGetCopyWith<$Res>(_value.authConfirmEmailGet,
        (value) {
      return _then(_value.copyWith(authConfirmEmailGet: value));
    });
  }
}

/// @nodoc
abstract class _$$_AuthConfirmEmailCopyWith<$Res>
    implements $AuthConfirmEmailCopyWith<$Res> {
  factory _$$_AuthConfirmEmailCopyWith(
          _$_AuthConfirmEmail value, $Res Function(_$_AuthConfirmEmail) then) =
      __$$_AuthConfirmEmailCopyWithImpl<$Res>;
  @override
  $Res call({AuthConfirmEmailGet authConfirmEmailGet});

  @override
  $AuthConfirmEmailGetCopyWith<$Res> get authConfirmEmailGet;
}

/// @nodoc
class __$$_AuthConfirmEmailCopyWithImpl<$Res>
    extends _$AuthConfirmEmailCopyWithImpl<$Res>
    implements _$$_AuthConfirmEmailCopyWith<$Res> {
  __$$_AuthConfirmEmailCopyWithImpl(
      _$_AuthConfirmEmail _value, $Res Function(_$_AuthConfirmEmail) _then)
      : super(_value, (v) => _then(v as _$_AuthConfirmEmail));

  @override
  _$_AuthConfirmEmail get _value => super._value as _$_AuthConfirmEmail;

  @override
  $Res call({
    Object? authConfirmEmailGet = freezed,
  }) {
    return _then(_$_AuthConfirmEmail(
      authConfirmEmailGet: authConfirmEmailGet == freezed
          ? _value.authConfirmEmailGet
          : authConfirmEmailGet // ignore: cast_nullable_to_non_nullable
              as AuthConfirmEmailGet,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthConfirmEmail implements _AuthConfirmEmail {
  const _$_AuthConfirmEmail({required this.authConfirmEmailGet});

  factory _$_AuthConfirmEmail.fromJson(Map<String, dynamic> json) =>
      _$$_AuthConfirmEmailFromJson(json);

  @override
  final AuthConfirmEmailGet authConfirmEmailGet;

  @override
  String toString() {
    return 'AuthConfirmEmail(authConfirmEmailGet: $authConfirmEmailGet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthConfirmEmail &&
            const DeepCollectionEquality()
                .equals(other.authConfirmEmailGet, authConfirmEmailGet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(authConfirmEmailGet));

  @JsonKey(ignore: true)
  @override
  _$$_AuthConfirmEmailCopyWith<_$_AuthConfirmEmail> get copyWith =>
      __$$_AuthConfirmEmailCopyWithImpl<_$_AuthConfirmEmail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthConfirmEmailToJson(this);
  }
}

abstract class _AuthConfirmEmail implements AuthConfirmEmail {
  const factory _AuthConfirmEmail(
          {required final AuthConfirmEmailGet authConfirmEmailGet}) =
      _$_AuthConfirmEmail;

  factory _AuthConfirmEmail.fromJson(Map<String, dynamic> json) =
      _$_AuthConfirmEmail.fromJson;

  @override
  AuthConfirmEmailGet get authConfirmEmailGet =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AuthConfirmEmailCopyWith<_$_AuthConfirmEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthConfirmEmailGet _$AuthConfirmEmailGetFromJson(Map<String, dynamic> json) {
  return _AuthConfirmEmailGet.fromJson(json);
}

/// @nodoc
mixin _$AuthConfirmEmailGet {
  List<String> get tags => throw _privateConstructorUsedError;
  List<PostParameter> get parameters => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthConfirmEmailGetCopyWith<AuthConfirmEmailGet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthConfirmEmailGetCopyWith<$Res> {
  factory $AuthConfirmEmailGetCopyWith(
          AuthConfirmEmailGet value, $Res Function(AuthConfirmEmailGet) then) =
      _$AuthConfirmEmailGetCopyWithImpl<$Res>;
  $Res call(
      {List<String> tags, List<PostParameter> parameters, Responses responses});

  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class _$AuthConfirmEmailGetCopyWithImpl<$Res>
    implements $AuthConfirmEmailGetCopyWith<$Res> {
  _$AuthConfirmEmailGetCopyWithImpl(this._value, this._then);

  final AuthConfirmEmailGet _value;
  // ignore: unused_field
  final $Res Function(AuthConfirmEmailGet) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<PostParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }
}

/// @nodoc
abstract class _$$_AuthConfirmEmailGetCopyWith<$Res>
    implements $AuthConfirmEmailGetCopyWith<$Res> {
  factory _$$_AuthConfirmEmailGetCopyWith(_$_AuthConfirmEmailGet value,
          $Res Function(_$_AuthConfirmEmailGet) then) =
      __$$_AuthConfirmEmailGetCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> tags, List<PostParameter> parameters, Responses responses});

  @override
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class __$$_AuthConfirmEmailGetCopyWithImpl<$Res>
    extends _$AuthConfirmEmailGetCopyWithImpl<$Res>
    implements _$$_AuthConfirmEmailGetCopyWith<$Res> {
  __$$_AuthConfirmEmailGetCopyWithImpl(_$_AuthConfirmEmailGet _value,
      $Res Function(_$_AuthConfirmEmailGet) _then)
      : super(_value, (v) => _then(v as _$_AuthConfirmEmailGet));

  @override
  _$_AuthConfirmEmailGet get _value => super._value as _$_AuthConfirmEmailGet;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$_AuthConfirmEmailGet(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<PostParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthConfirmEmailGet implements _AuthConfirmEmailGet {
  const _$_AuthConfirmEmailGet(
      {required final List<String> tags,
      required final List<PostParameter> parameters,
      required this.responses})
      : _tags = tags,
        _parameters = parameters;

  factory _$_AuthConfirmEmailGet.fromJson(Map<String, dynamic> json) =>
      _$$_AuthConfirmEmailGetFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<PostParameter> _parameters;
  @override
  List<PostParameter> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  final Responses responses;

  @override
  String toString() {
    return 'AuthConfirmEmailGet(tags: $tags, parameters: $parameters, responses: $responses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthConfirmEmailGet &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other.responses, responses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(responses));

  @JsonKey(ignore: true)
  @override
  _$$_AuthConfirmEmailGetCopyWith<_$_AuthConfirmEmailGet> get copyWith =>
      __$$_AuthConfirmEmailGetCopyWithImpl<_$_AuthConfirmEmailGet>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthConfirmEmailGetToJson(this);
  }
}

abstract class _AuthConfirmEmailGet implements AuthConfirmEmailGet {
  const factory _AuthConfirmEmailGet(
      {required final List<String> tags,
      required final List<PostParameter> parameters,
      required final Responses responses}) = _$_AuthConfirmEmailGet;

  factory _AuthConfirmEmailGet.fromJson(Map<String, dynamic> json) =
      _$_AuthConfirmEmailGet.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  List<PostParameter> get parameters => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_AuthConfirmEmailGetCopyWith<_$_AuthConfirmEmailGet> get copyWith =>
      throw _privateConstructorUsedError;
}

PostParameter _$PostParameterFromJson(Map<String, dynamic> json) {
  return _PostParameter.fromJson(json);
}

/// @nodoc
mixin _$PostParameter {
  String get name => throw _privateConstructorUsedError;
  String get parameterIn => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  Schema get schema => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostParameterCopyWith<PostParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostParameterCopyWith<$Res> {
  factory $PostParameterCopyWith(
          PostParameter value, $Res Function(PostParameter) then) =
      _$PostParameterCopyWithImpl<$Res>;
  $Res call({String name, String parameterIn, bool required, Schema schema});

  $SchemaCopyWith<$Res> get schema;
}

/// @nodoc
class _$PostParameterCopyWithImpl<$Res>
    implements $PostParameterCopyWith<$Res> {
  _$PostParameterCopyWithImpl(this._value, this._then);

  final PostParameter _value;
  // ignore: unused_field
  final $Res Function(PostParameter) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? parameterIn = freezed,
    Object? required = freezed,
    Object? schema = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameterIn: parameterIn == freezed
          ? _value.parameterIn
          : parameterIn // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Schema,
    ));
  }

  @override
  $SchemaCopyWith<$Res> get schema {
    return $SchemaCopyWith<$Res>(_value.schema, (value) {
      return _then(_value.copyWith(schema: value));
    });
  }
}

/// @nodoc
abstract class _$$_PostParameterCopyWith<$Res>
    implements $PostParameterCopyWith<$Res> {
  factory _$$_PostParameterCopyWith(
          _$_PostParameter value, $Res Function(_$_PostParameter) then) =
      __$$_PostParameterCopyWithImpl<$Res>;
  @override
  $Res call({String name, String parameterIn, bool required, Schema schema});

  @override
  $SchemaCopyWith<$Res> get schema;
}

/// @nodoc
class __$$_PostParameterCopyWithImpl<$Res>
    extends _$PostParameterCopyWithImpl<$Res>
    implements _$$_PostParameterCopyWith<$Res> {
  __$$_PostParameterCopyWithImpl(
      _$_PostParameter _value, $Res Function(_$_PostParameter) _then)
      : super(_value, (v) => _then(v as _$_PostParameter));

  @override
  _$_PostParameter get _value => super._value as _$_PostParameter;

  @override
  $Res call({
    Object? name = freezed,
    Object? parameterIn = freezed,
    Object? required = freezed,
    Object? schema = freezed,
  }) {
    return _then(_$_PostParameter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameterIn: parameterIn == freezed
          ? _value.parameterIn
          : parameterIn // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Schema,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PostParameter implements _PostParameter {
  const _$_PostParameter(
      {required this.name,
      required this.parameterIn,
      required this.required,
      required this.schema});

  factory _$_PostParameter.fromJson(Map<String, dynamic> json) =>
      _$$_PostParameterFromJson(json);

  @override
  final String name;
  @override
  final String parameterIn;
  @override
  final bool required;
  @override
  final Schema schema;

  @override
  String toString() {
    return 'PostParameter(name: $name, parameterIn: $parameterIn, required: $required, schema: $schema)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostParameter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.parameterIn, parameterIn) &&
            const DeepCollectionEquality().equals(other.required, required) &&
            const DeepCollectionEquality().equals(other.schema, schema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(parameterIn),
      const DeepCollectionEquality().hash(required),
      const DeepCollectionEquality().hash(schema));

  @JsonKey(ignore: true)
  @override
  _$$_PostParameterCopyWith<_$_PostParameter> get copyWith =>
      __$$_PostParameterCopyWithImpl<_$_PostParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostParameterToJson(this);
  }
}

abstract class _PostParameter implements PostParameter {
  const factory _PostParameter(
      {required final String name,
      required final String parameterIn,
      required final bool required,
      required final Schema schema}) = _$_PostParameter;

  factory _PostParameter.fromJson(Map<String, dynamic> json) =
      _$_PostParameter.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get parameterIn => throw _privateConstructorUsedError;
  @override
  bool get required => throw _privateConstructorUsedError;
  @override
  Schema get schema => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PostParameterCopyWith<_$_PostParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  return _Schema.fromJson(json);
}

/// @nodoc
mixin _$Schema {
  Type get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchemaCopyWith<Schema> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaCopyWith<$Res> {
  factory $SchemaCopyWith(Schema value, $Res Function(Schema) then) =
      _$SchemaCopyWithImpl<$Res>;
  $Res call({Type type});
}

/// @nodoc
class _$SchemaCopyWithImpl<$Res> implements $SchemaCopyWith<$Res> {
  _$SchemaCopyWithImpl(this._value, this._then);

  final Schema _value;
  // ignore: unused_field
  final $Res Function(Schema) _then;

  @override
  $Res call({
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
    ));
  }
}

/// @nodoc
abstract class _$$_SchemaCopyWith<$Res> implements $SchemaCopyWith<$Res> {
  factory _$$_SchemaCopyWith(_$_Schema value, $Res Function(_$_Schema) then) =
      __$$_SchemaCopyWithImpl<$Res>;
  @override
  $Res call({Type type});
}

/// @nodoc
class __$$_SchemaCopyWithImpl<$Res> extends _$SchemaCopyWithImpl<$Res>
    implements _$$_SchemaCopyWith<$Res> {
  __$$_SchemaCopyWithImpl(_$_Schema _value, $Res Function(_$_Schema) _then)
      : super(_value, (v) => _then(v as _$_Schema));

  @override
  _$_Schema get _value => super._value as _$_Schema;

  @override
  $Res call({
    Object? type = freezed,
  }) {
    return _then(_$_Schema(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Schema implements _Schema {
  const _$_Schema({required this.type});

  factory _$_Schema.fromJson(Map<String, dynamic> json) =>
      _$$_SchemaFromJson(json);

  @override
  final Type type;

  @override
  String toString() {
    return 'Schema(type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Schema &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$$_SchemaCopyWith<_$_Schema> get copyWith =>
      __$$_SchemaCopyWithImpl<_$_Schema>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SchemaToJson(this);
  }
}

abstract class _Schema implements Schema {
  const factory _Schema({required final Type type}) = _$_Schema;

  factory _Schema.fromJson(Map<String, dynamic> json) = _$_Schema.fromJson;

  @override
  Type get type => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SchemaCopyWith<_$_Schema> get copyWith =>
      throw _privateConstructorUsedError;
}

Responses _$ResponsesFromJson(Map<String, dynamic> json) {
  return _Responses.fromJson(json);
}

/// @nodoc
mixin _$Responses {
  The200 get the200 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResponsesCopyWith<Responses> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponsesCopyWith<$Res> {
  factory $ResponsesCopyWith(Responses value, $Res Function(Responses) then) =
      _$ResponsesCopyWithImpl<$Res>;
  $Res call({The200 the200});

  $The200CopyWith<$Res> get the200;
}

/// @nodoc
class _$ResponsesCopyWithImpl<$Res> implements $ResponsesCopyWith<$Res> {
  _$ResponsesCopyWithImpl(this._value, this._then);

  final Responses _value;
  // ignore: unused_field
  final $Res Function(Responses) _then;

  @override
  $Res call({
    Object? the200 = freezed,
  }) {
    return _then(_value.copyWith(
      the200: the200 == freezed
          ? _value.the200
          : the200 // ignore: cast_nullable_to_non_nullable
              as The200,
    ));
  }

  @override
  $The200CopyWith<$Res> get the200 {
    return $The200CopyWith<$Res>(_value.the200, (value) {
      return _then(_value.copyWith(the200: value));
    });
  }
}

/// @nodoc
abstract class _$$_ResponsesCopyWith<$Res> implements $ResponsesCopyWith<$Res> {
  factory _$$_ResponsesCopyWith(
          _$_Responses value, $Res Function(_$_Responses) then) =
      __$$_ResponsesCopyWithImpl<$Res>;
  @override
  $Res call({The200 the200});

  @override
  $The200CopyWith<$Res> get the200;
}

/// @nodoc
class __$$_ResponsesCopyWithImpl<$Res> extends _$ResponsesCopyWithImpl<$Res>
    implements _$$_ResponsesCopyWith<$Res> {
  __$$_ResponsesCopyWithImpl(
      _$_Responses _value, $Res Function(_$_Responses) _then)
      : super(_value, (v) => _then(v as _$_Responses));

  @override
  _$_Responses get _value => super._value as _$_Responses;

  @override
  $Res call({
    Object? the200 = freezed,
  }) {
    return _then(_$_Responses(
      the200: the200 == freezed
          ? _value.the200
          : the200 // ignore: cast_nullable_to_non_nullable
              as The200,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Responses implements _Responses {
  const _$_Responses({required this.the200});

  factory _$_Responses.fromJson(Map<String, dynamic> json) =>
      _$$_ResponsesFromJson(json);

  @override
  final The200 the200;

  @override
  String toString() {
    return 'Responses(the200: $the200)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Responses &&
            const DeepCollectionEquality().equals(other.the200, the200));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(the200));

  @JsonKey(ignore: true)
  @override
  _$$_ResponsesCopyWith<_$_Responses> get copyWith =>
      __$$_ResponsesCopyWithImpl<_$_Responses>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ResponsesToJson(this);
  }
}

abstract class _Responses implements Responses {
  const factory _Responses({required final The200 the200}) = _$_Responses;

  factory _Responses.fromJson(Map<String, dynamic> json) =
      _$_Responses.fromJson;

  @override
  The200 get the200 => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ResponsesCopyWith<_$_Responses> get copyWith =>
      throw _privateConstructorUsedError;
}

The200 _$The200FromJson(Map<String, dynamic> json) {
  return _The200.fromJson(json);
}

/// @nodoc
mixin _$The200 {
  Description get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $The200CopyWith<The200> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $The200CopyWith<$Res> {
  factory $The200CopyWith(The200 value, $Res Function(The200) then) =
      _$The200CopyWithImpl<$Res>;
  $Res call({Description description});
}

/// @nodoc
class _$The200CopyWithImpl<$Res> implements $The200CopyWith<$Res> {
  _$The200CopyWithImpl(this._value, this._then);

  final The200 _value;
  // ignore: unused_field
  final $Res Function(The200) _then;

  @override
  $Res call({
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as Description,
    ));
  }
}

/// @nodoc
abstract class _$$_The200CopyWith<$Res> implements $The200CopyWith<$Res> {
  factory _$$_The200CopyWith(_$_The200 value, $Res Function(_$_The200) then) =
      __$$_The200CopyWithImpl<$Res>;
  @override
  $Res call({Description description});
}

/// @nodoc
class __$$_The200CopyWithImpl<$Res> extends _$The200CopyWithImpl<$Res>
    implements _$$_The200CopyWith<$Res> {
  __$$_The200CopyWithImpl(_$_The200 _value, $Res Function(_$_The200) _then)
      : super(_value, (v) => _then(v as _$_The200));

  @override
  _$_The200 get _value => super._value as _$_The200;

  @override
  $Res call({
    Object? description = freezed,
  }) {
    return _then(_$_The200(
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as Description,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_The200 implements _The200 {
  const _$_The200({required this.description});

  factory _$_The200.fromJson(Map<String, dynamic> json) =>
      _$$_The200FromJson(json);

  @override
  final Description description;

  @override
  String toString() {
    return 'The200(description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_The200 &&
            const DeepCollectionEquality()
                .equals(other.description, description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(description));

  @JsonKey(ignore: true)
  @override
  _$$_The200CopyWith<_$_The200> get copyWith =>
      __$$_The200CopyWithImpl<_$_The200>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_The200ToJson(this);
  }
}

abstract class _The200 implements The200 {
  const factory _The200({required final Description description}) = _$_The200;

  factory _The200.fromJson(Map<String, dynamic> json) = _$_The200.fromJson;

  @override
  Description get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_The200CopyWith<_$_The200> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesCompanyIdRegisterUser _$CompaniesCompanyIdRegisterUserFromJson(
    Map<String, dynamic> json) {
  return _CompaniesCompanyIdRegisterUser.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyIdRegisterUser {
  GetClass get post => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdRegisterUserCopyWith<CompaniesCompanyIdRegisterUser>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdRegisterUserCopyWith<$Res> {
  factory $CompaniesCompanyIdRegisterUserCopyWith(
          CompaniesCompanyIdRegisterUser value,
          $Res Function(CompaniesCompanyIdRegisterUser) then) =
      _$CompaniesCompanyIdRegisterUserCopyWithImpl<$Res>;
  $Res call({GetClass post});

  $GetClassCopyWith<$Res> get post;
}

/// @nodoc
class _$CompaniesCompanyIdRegisterUserCopyWithImpl<$Res>
    implements $CompaniesCompanyIdRegisterUserCopyWith<$Res> {
  _$CompaniesCompanyIdRegisterUserCopyWithImpl(this._value, this._then);

  final CompaniesCompanyIdRegisterUser _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyIdRegisterUser) _then;

  @override
  $Res call({
    Object? post = freezed,
  }) {
    return _then(_value.copyWith(
      post: post == freezed
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as GetClass,
    ));
  }

  @override
  $GetClassCopyWith<$Res> get post {
    return $GetClassCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdRegisterUserCopyWith<$Res>
    implements $CompaniesCompanyIdRegisterUserCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdRegisterUserCopyWith(
          _$_CompaniesCompanyIdRegisterUser value,
          $Res Function(_$_CompaniesCompanyIdRegisterUser) then) =
      __$$_CompaniesCompanyIdRegisterUserCopyWithImpl<$Res>;
  @override
  $Res call({GetClass post});

  @override
  $GetClassCopyWith<$Res> get post;
}

/// @nodoc
class __$$_CompaniesCompanyIdRegisterUserCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdRegisterUserCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdRegisterUserCopyWith<$Res> {
  __$$_CompaniesCompanyIdRegisterUserCopyWithImpl(
      _$_CompaniesCompanyIdRegisterUser _value,
      $Res Function(_$_CompaniesCompanyIdRegisterUser) _then)
      : super(_value, (v) => _then(v as _$_CompaniesCompanyIdRegisterUser));

  @override
  _$_CompaniesCompanyIdRegisterUser get _value =>
      super._value as _$_CompaniesCompanyIdRegisterUser;

  @override
  $Res call({
    Object? post = freezed,
  }) {
    return _then(_$_CompaniesCompanyIdRegisterUser(
      post: post == freezed
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as GetClass,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyIdRegisterUser
    implements _CompaniesCompanyIdRegisterUser {
  const _$_CompaniesCompanyIdRegisterUser({required this.post});

  factory _$_CompaniesCompanyIdRegisterUser.fromJson(
          Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdRegisterUserFromJson(json);

  @override
  final GetClass post;

  @override
  String toString() {
    return 'CompaniesCompanyIdRegisterUser(post: $post)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyIdRegisterUser &&
            const DeepCollectionEquality().equals(other.post, post));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(post));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdRegisterUserCopyWith<_$_CompaniesCompanyIdRegisterUser>
      get copyWith => __$$_CompaniesCompanyIdRegisterUserCopyWithImpl<
          _$_CompaniesCompanyIdRegisterUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdRegisterUserToJson(this);
  }
}

abstract class _CompaniesCompanyIdRegisterUser
    implements CompaniesCompanyIdRegisterUser {
  const factory _CompaniesCompanyIdRegisterUser(
      {required final GetClass post}) = _$_CompaniesCompanyIdRegisterUser;

  factory _CompaniesCompanyIdRegisterUser.fromJson(Map<String, dynamic> json) =
      _$_CompaniesCompanyIdRegisterUser.fromJson;

  @override
  GetClass get post => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdRegisterUserCopyWith<_$_CompaniesCompanyIdRegisterUser>
      get copyWith => throw _privateConstructorUsedError;
}

GetClass _$GetClassFromJson(Map<String, dynamic> json) {
  return _GetClass.fromJson(json);
}

/// @nodoc
mixin _$GetClass {
  List<String> get tags => throw _privateConstructorUsedError;
  List<PostParameter> get parameters => throw _privateConstructorUsedError;
  GetRequestBody get requestBody => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetClassCopyWith<GetClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetClassCopyWith<$Res> {
  factory $GetClassCopyWith(GetClass value, $Res Function(GetClass) then) =
      _$GetClassCopyWithImpl<$Res>;
  $Res call(
      {List<String> tags,
      List<PostParameter> parameters,
      GetRequestBody requestBody,
      Responses responses});

  $GetRequestBodyCopyWith<$Res> get requestBody;
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class _$GetClassCopyWithImpl<$Res> implements $GetClassCopyWith<$Res> {
  _$GetClassCopyWithImpl(this._value, this._then);

  final GetClass _value;
  // ignore: unused_field
  final $Res Function(GetClass) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? requestBody = freezed,
    Object? responses = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<PostParameter>,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as GetRequestBody,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }

  @override
  $GetRequestBodyCopyWith<$Res> get requestBody {
    return $GetRequestBodyCopyWith<$Res>(_value.requestBody, (value) {
      return _then(_value.copyWith(requestBody: value));
    });
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }
}

/// @nodoc
abstract class _$$_GetClassCopyWith<$Res> implements $GetClassCopyWith<$Res> {
  factory _$$_GetClassCopyWith(
          _$_GetClass value, $Res Function(_$_GetClass) then) =
      __$$_GetClassCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> tags,
      List<PostParameter> parameters,
      GetRequestBody requestBody,
      Responses responses});

  @override
  $GetRequestBodyCopyWith<$Res> get requestBody;
  @override
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class __$$_GetClassCopyWithImpl<$Res> extends _$GetClassCopyWithImpl<$Res>
    implements _$$_GetClassCopyWith<$Res> {
  __$$_GetClassCopyWithImpl(
      _$_GetClass _value, $Res Function(_$_GetClass) _then)
      : super(_value, (v) => _then(v as _$_GetClass));

  @override
  _$_GetClass get _value => super._value as _$_GetClass;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? requestBody = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$_GetClass(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<PostParameter>,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as GetRequestBody,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GetClass implements _GetClass {
  const _$_GetClass(
      {required final List<String> tags,
      required final List<PostParameter> parameters,
      required this.requestBody,
      required this.responses})
      : _tags = tags,
        _parameters = parameters;

  factory _$_GetClass.fromJson(Map<String, dynamic> json) =>
      _$$_GetClassFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<PostParameter> _parameters;
  @override
  List<PostParameter> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  final GetRequestBody requestBody;
  @override
  final Responses responses;

  @override
  String toString() {
    return 'GetClass(tags: $tags, parameters: $parameters, requestBody: $requestBody, responses: $responses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetClass &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality()
                .equals(other.requestBody, requestBody) &&
            const DeepCollectionEquality().equals(other.responses, responses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(requestBody),
      const DeepCollectionEquality().hash(responses));

  @JsonKey(ignore: true)
  @override
  _$$_GetClassCopyWith<_$_GetClass> get copyWith =>
      __$$_GetClassCopyWithImpl<_$_GetClass>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GetClassToJson(this);
  }
}

abstract class _GetClass implements GetClass {
  const factory _GetClass(
      {required final List<String> tags,
      required final List<PostParameter> parameters,
      required final GetRequestBody requestBody,
      required final Responses responses}) = _$_GetClass;

  factory _GetClass.fromJson(Map<String, dynamic> json) = _$_GetClass.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  List<PostParameter> get parameters => throw _privateConstructorUsedError;
  @override
  GetRequestBody get requestBody => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_GetClassCopyWith<_$_GetClass> get copyWith =>
      throw _privateConstructorUsedError;
}

GetRequestBody _$GetRequestBodyFromJson(Map<String, dynamic> json) {
  return _GetRequestBody.fromJson(json);
}

/// @nodoc
mixin _$GetRequestBody {
  Content get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetRequestBodyCopyWith<GetRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetRequestBodyCopyWith<$Res> {
  factory $GetRequestBodyCopyWith(
          GetRequestBody value, $Res Function(GetRequestBody) then) =
      _$GetRequestBodyCopyWithImpl<$Res>;
  $Res call({Content content});

  $ContentCopyWith<$Res> get content;
}

/// @nodoc
class _$GetRequestBodyCopyWithImpl<$Res>
    implements $GetRequestBodyCopyWith<$Res> {
  _$GetRequestBodyCopyWithImpl(this._value, this._then);

  final GetRequestBody _value;
  // ignore: unused_field
  final $Res Function(GetRequestBody) _then;

  @override
  $Res call({
    Object? content = freezed,
  }) {
    return _then(_value.copyWith(
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content,
    ));
  }

  @override
  $ContentCopyWith<$Res> get content {
    return $ContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value));
    });
  }
}

/// @nodoc
abstract class _$$_GetRequestBodyCopyWith<$Res>
    implements $GetRequestBodyCopyWith<$Res> {
  factory _$$_GetRequestBodyCopyWith(
          _$_GetRequestBody value, $Res Function(_$_GetRequestBody) then) =
      __$$_GetRequestBodyCopyWithImpl<$Res>;
  @override
  $Res call({Content content});

  @override
  $ContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$_GetRequestBodyCopyWithImpl<$Res>
    extends _$GetRequestBodyCopyWithImpl<$Res>
    implements _$$_GetRequestBodyCopyWith<$Res> {
  __$$_GetRequestBodyCopyWithImpl(
      _$_GetRequestBody _value, $Res Function(_$_GetRequestBody) _then)
      : super(_value, (v) => _then(v as _$_GetRequestBody));

  @override
  _$_GetRequestBody get _value => super._value as _$_GetRequestBody;

  @override
  $Res call({
    Object? content = freezed,
  }) {
    return _then(_$_GetRequestBody(
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GetRequestBody implements _GetRequestBody {
  const _$_GetRequestBody({required this.content});

  factory _$_GetRequestBody.fromJson(Map<String, dynamic> json) =>
      _$$_GetRequestBodyFromJson(json);

  @override
  final Content content;

  @override
  String toString() {
    return 'GetRequestBody(content: $content)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetRequestBody &&
            const DeepCollectionEquality().equals(other.content, content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(content));

  @JsonKey(ignore: true)
  @override
  _$$_GetRequestBodyCopyWith<_$_GetRequestBody> get copyWith =>
      __$$_GetRequestBodyCopyWithImpl<_$_GetRequestBody>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GetRequestBodyToJson(this);
  }
}

abstract class _GetRequestBody implements GetRequestBody {
  const factory _GetRequestBody({required final Content content}) =
      _$_GetRequestBody;

  factory _GetRequestBody.fromJson(Map<String, dynamic> json) =
      _$_GetRequestBody.fromJson;

  @override
  Content get content => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_GetRequestBodyCopyWith<_$_GetRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

Content _$ContentFromJson(Map<String, dynamic> json) {
  return _Content.fromJson(json);
}

/// @nodoc
mixin _$Content {
  Json get contentApplicationJson => throw _privateConstructorUsedError;
  Json get textJson => throw _privateConstructorUsedError;
  Json get applicationJson => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentCopyWith<Content> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res>;
  $Res call({Json contentApplicationJson, Json textJson, Json applicationJson});

  $JsonCopyWith<$Res> get contentApplicationJson;
  $JsonCopyWith<$Res> get textJson;
  $JsonCopyWith<$Res> get applicationJson;
}

/// @nodoc
class _$ContentCopyWithImpl<$Res> implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._value, this._then);

  final Content _value;
  // ignore: unused_field
  final $Res Function(Content) _then;

  @override
  $Res call({
    Object? contentApplicationJson = freezed,
    Object? textJson = freezed,
    Object? applicationJson = freezed,
  }) {
    return _then(_value.copyWith(
      contentApplicationJson: contentApplicationJson == freezed
          ? _value.contentApplicationJson
          : contentApplicationJson // ignore: cast_nullable_to_non_nullable
              as Json,
      textJson: textJson == freezed
          ? _value.textJson
          : textJson // ignore: cast_nullable_to_non_nullable
              as Json,
      applicationJson: applicationJson == freezed
          ? _value.applicationJson
          : applicationJson // ignore: cast_nullable_to_non_nullable
              as Json,
    ));
  }

  @override
  $JsonCopyWith<$Res> get contentApplicationJson {
    return $JsonCopyWith<$Res>(_value.contentApplicationJson, (value) {
      return _then(_value.copyWith(contentApplicationJson: value));
    });
  }

  @override
  $JsonCopyWith<$Res> get textJson {
    return $JsonCopyWith<$Res>(_value.textJson, (value) {
      return _then(_value.copyWith(textJson: value));
    });
  }

  @override
  $JsonCopyWith<$Res> get applicationJson {
    return $JsonCopyWith<$Res>(_value.applicationJson, (value) {
      return _then(_value.copyWith(applicationJson: value));
    });
  }
}

/// @nodoc
abstract class _$$_ContentCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$$_ContentCopyWith(
          _$_Content value, $Res Function(_$_Content) then) =
      __$$_ContentCopyWithImpl<$Res>;
  @override
  $Res call({Json contentApplicationJson, Json textJson, Json applicationJson});

  @override
  $JsonCopyWith<$Res> get contentApplicationJson;
  @override
  $JsonCopyWith<$Res> get textJson;
  @override
  $JsonCopyWith<$Res> get applicationJson;
}

/// @nodoc
class __$$_ContentCopyWithImpl<$Res> extends _$ContentCopyWithImpl<$Res>
    implements _$$_ContentCopyWith<$Res> {
  __$$_ContentCopyWithImpl(_$_Content _value, $Res Function(_$_Content) _then)
      : super(_value, (v) => _then(v as _$_Content));

  @override
  _$_Content get _value => super._value as _$_Content;

  @override
  $Res call({
    Object? contentApplicationJson = freezed,
    Object? textJson = freezed,
    Object? applicationJson = freezed,
  }) {
    return _then(_$_Content(
      contentApplicationJson: contentApplicationJson == freezed
          ? _value.contentApplicationJson
          : contentApplicationJson // ignore: cast_nullable_to_non_nullable
              as Json,
      textJson: textJson == freezed
          ? _value.textJson
          : textJson // ignore: cast_nullable_to_non_nullable
              as Json,
      applicationJson: applicationJson == freezed
          ? _value.applicationJson
          : applicationJson // ignore: cast_nullable_to_non_nullable
              as Json,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Content implements _Content {
  const _$_Content(
      {required this.contentApplicationJson,
      required this.textJson,
      required this.applicationJson});

  factory _$_Content.fromJson(Map<String, dynamic> json) =>
      _$$_ContentFromJson(json);

  @override
  final Json contentApplicationJson;
  @override
  final Json textJson;
  @override
  final Json applicationJson;

  @override
  String toString() {
    return 'Content(contentApplicationJson: $contentApplicationJson, textJson: $textJson, applicationJson: $applicationJson)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Content &&
            const DeepCollectionEquality()
                .equals(other.contentApplicationJson, contentApplicationJson) &&
            const DeepCollectionEquality().equals(other.textJson, textJson) &&
            const DeepCollectionEquality()
                .equals(other.applicationJson, applicationJson));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(contentApplicationJson),
      const DeepCollectionEquality().hash(textJson),
      const DeepCollectionEquality().hash(applicationJson));

  @JsonKey(ignore: true)
  @override
  _$$_ContentCopyWith<_$_Content> get copyWith =>
      __$$_ContentCopyWithImpl<_$_Content>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentToJson(this);
  }
}

abstract class _Content implements Content {
  const factory _Content(
      {required final Json contentApplicationJson,
      required final Json textJson,
      required final Json applicationJson}) = _$_Content;

  factory _Content.fromJson(Map<String, dynamic> json) = _$_Content.fromJson;

  @override
  Json get contentApplicationJson => throw _privateConstructorUsedError;
  @override
  Json get textJson => throw _privateConstructorUsedError;
  @override
  Json get applicationJson => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ContentCopyWith<_$_Content> get copyWith =>
      throw _privateConstructorUsedError;
}

Json _$JsonFromJson(Map<String, dynamic> json) {
  return _Json.fromJson(json);
}

/// @nodoc
mixin _$Json {
  Address get schema => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JsonCopyWith<Json> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JsonCopyWith<$Res> {
  factory $JsonCopyWith(Json value, $Res Function(Json) then) =
      _$JsonCopyWithImpl<$Res>;
  $Res call({Address schema});

  $AddressCopyWith<$Res> get schema;
}

/// @nodoc
class _$JsonCopyWithImpl<$Res> implements $JsonCopyWith<$Res> {
  _$JsonCopyWithImpl(this._value, this._then);

  final Json _value;
  // ignore: unused_field
  final $Res Function(Json) _then;

  @override
  $Res call({
    Object? schema = freezed,
  }) {
    return _then(_value.copyWith(
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }

  @override
  $AddressCopyWith<$Res> get schema {
    return $AddressCopyWith<$Res>(_value.schema, (value) {
      return _then(_value.copyWith(schema: value));
    });
  }
}

/// @nodoc
abstract class _$$_JsonCopyWith<$Res> implements $JsonCopyWith<$Res> {
  factory _$$_JsonCopyWith(_$_Json value, $Res Function(_$_Json) then) =
      __$$_JsonCopyWithImpl<$Res>;
  @override
  $Res call({Address schema});

  @override
  $AddressCopyWith<$Res> get schema;
}

/// @nodoc
class __$$_JsonCopyWithImpl<$Res> extends _$JsonCopyWithImpl<$Res>
    implements _$$_JsonCopyWith<$Res> {
  __$$_JsonCopyWithImpl(_$_Json _value, $Res Function(_$_Json) _then)
      : super(_value, (v) => _then(v as _$_Json));

  @override
  _$_Json get _value => super._value as _$_Json;

  @override
  $Res call({
    Object? schema = freezed,
  }) {
    return _then(_$_Json(
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Json implements _Json {
  const _$_Json({required this.schema});

  factory _$_Json.fromJson(Map<String, dynamic> json) => _$$_JsonFromJson(json);

  @override
  final Address schema;

  @override
  String toString() {
    return 'Json(schema: $schema)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Json &&
            const DeepCollectionEquality().equals(other.schema, schema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(schema));

  @JsonKey(ignore: true)
  @override
  _$$_JsonCopyWith<_$_Json> get copyWith =>
      __$$_JsonCopyWithImpl<_$_Json>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JsonToJson(this);
  }
}

abstract class _Json implements Json {
  const factory _Json({required final Address schema}) = _$_Json;

  factory _Json.fromJson(Map<String, dynamic> json) = _$_Json.fromJson;

  @override
  Address get schema => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_JsonCopyWith<_$_Json> get copyWith => throw _privateConstructorUsedError;
}

Companies _$CompaniesFromJson(Map<String, dynamic> json) {
  return _Companies.fromJson(json);
}

/// @nodoc
mixin _$Companies {
  CompaniesGet get companiesGet => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCopyWith<Companies> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCopyWith<$Res> {
  factory $CompaniesCopyWith(Companies value, $Res Function(Companies) then) =
      _$CompaniesCopyWithImpl<$Res>;
  $Res call({CompaniesGet companiesGet});

  $CompaniesGetCopyWith<$Res> get companiesGet;
}

/// @nodoc
class _$CompaniesCopyWithImpl<$Res> implements $CompaniesCopyWith<$Res> {
  _$CompaniesCopyWithImpl(this._value, this._then);

  final Companies _value;
  // ignore: unused_field
  final $Res Function(Companies) _then;

  @override
  $Res call({
    Object? companiesGet = freezed,
  }) {
    return _then(_value.copyWith(
      companiesGet: companiesGet == freezed
          ? _value.companiesGet
          : companiesGet // ignore: cast_nullable_to_non_nullable
              as CompaniesGet,
    ));
  }

  @override
  $CompaniesGetCopyWith<$Res> get companiesGet {
    return $CompaniesGetCopyWith<$Res>(_value.companiesGet, (value) {
      return _then(_value.copyWith(companiesGet: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCopyWith<$Res> implements $CompaniesCopyWith<$Res> {
  factory _$$_CompaniesCopyWith(
          _$_Companies value, $Res Function(_$_Companies) then) =
      __$$_CompaniesCopyWithImpl<$Res>;
  @override
  $Res call({CompaniesGet companiesGet});

  @override
  $CompaniesGetCopyWith<$Res> get companiesGet;
}

/// @nodoc
class __$$_CompaniesCopyWithImpl<$Res> extends _$CompaniesCopyWithImpl<$Res>
    implements _$$_CompaniesCopyWith<$Res> {
  __$$_CompaniesCopyWithImpl(
      _$_Companies _value, $Res Function(_$_Companies) _then)
      : super(_value, (v) => _then(v as _$_Companies));

  @override
  _$_Companies get _value => super._value as _$_Companies;

  @override
  $Res call({
    Object? companiesGet = freezed,
  }) {
    return _then(_$_Companies(
      companiesGet: companiesGet == freezed
          ? _value.companiesGet
          : companiesGet // ignore: cast_nullable_to_non_nullable
              as CompaniesGet,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Companies implements _Companies {
  const _$_Companies({required this.companiesGet});

  factory _$_Companies.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesFromJson(json);

  @override
  final CompaniesGet companiesGet;

  @override
  String toString() {
    return 'Companies(companiesGet: $companiesGet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Companies &&
            const DeepCollectionEquality()
                .equals(other.companiesGet, companiesGet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(companiesGet));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCopyWith<_$_Companies> get copyWith =>
      __$$_CompaniesCopyWithImpl<_$_Companies>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesToJson(this);
  }
}

abstract class _Companies implements Companies {
  const factory _Companies({required final CompaniesGet companiesGet}) =
      _$_Companies;

  factory _Companies.fromJson(Map<String, dynamic> json) =
      _$_Companies.fromJson;

  @override
  CompaniesGet get companiesGet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCopyWith<_$_Companies> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesGet _$CompaniesGetFromJson(Map<String, dynamic> json) {
  return _CompaniesGet.fromJson(json);
}

/// @nodoc
mixin _$CompaniesGet {
  List<String> get tags => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesGetCopyWith<CompaniesGet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesGetCopyWith<$Res> {
  factory $CompaniesGetCopyWith(
          CompaniesGet value, $Res Function(CompaniesGet) then) =
      _$CompaniesGetCopyWithImpl<$Res>;
  $Res call({List<String> tags, Responses responses});

  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class _$CompaniesGetCopyWithImpl<$Res> implements $CompaniesGetCopyWith<$Res> {
  _$CompaniesGetCopyWithImpl(this._value, this._then);

  final CompaniesGet _value;
  // ignore: unused_field
  final $Res Function(CompaniesGet) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? responses = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesGetCopyWith<$Res>
    implements $CompaniesGetCopyWith<$Res> {
  factory _$$_CompaniesGetCopyWith(
          _$_CompaniesGet value, $Res Function(_$_CompaniesGet) then) =
      __$$_CompaniesGetCopyWithImpl<$Res>;
  @override
  $Res call({List<String> tags, Responses responses});

  @override
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class __$$_CompaniesGetCopyWithImpl<$Res>
    extends _$CompaniesGetCopyWithImpl<$Res>
    implements _$$_CompaniesGetCopyWith<$Res> {
  __$$_CompaniesGetCopyWithImpl(
      _$_CompaniesGet _value, $Res Function(_$_CompaniesGet) _then)
      : super(_value, (v) => _then(v as _$_CompaniesGet));

  @override
  _$_CompaniesGet get _value => super._value as _$_CompaniesGet;

  @override
  $Res call({
    Object? tags = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$_CompaniesGet(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesGet implements _CompaniesGet {
  const _$_CompaniesGet(
      {required final List<String> tags, required this.responses})
      : _tags = tags;

  factory _$_CompaniesGet.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesGetFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final Responses responses;

  @override
  String toString() {
    return 'CompaniesGet(tags: $tags, responses: $responses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesGet &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other.responses, responses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(responses));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesGetCopyWith<_$_CompaniesGet> get copyWith =>
      __$$_CompaniesGetCopyWithImpl<_$_CompaniesGet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesGetToJson(this);
  }
}

abstract class _CompaniesGet implements CompaniesGet {
  const factory _CompaniesGet(
      {required final List<String> tags,
      required final Responses responses}) = _$_CompaniesGet;

  factory _CompaniesGet.fromJson(Map<String, dynamic> json) =
      _$_CompaniesGet.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesGetCopyWith<_$_CompaniesGet> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesCompanyId _$CompaniesCompanyIdFromJson(Map<String, dynamic> json) {
  return _CompaniesCompanyId.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyId {
  CompaniesCompanyIdGet get companiesCompanyIdGet =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdCopyWith<CompaniesCompanyId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdCopyWith<$Res> {
  factory $CompaniesCompanyIdCopyWith(
          CompaniesCompanyId value, $Res Function(CompaniesCompanyId) then) =
      _$CompaniesCompanyIdCopyWithImpl<$Res>;
  $Res call({CompaniesCompanyIdGet companiesCompanyIdGet});

  $CompaniesCompanyIdGetCopyWith<$Res> get companiesCompanyIdGet;
}

/// @nodoc
class _$CompaniesCompanyIdCopyWithImpl<$Res>
    implements $CompaniesCompanyIdCopyWith<$Res> {
  _$CompaniesCompanyIdCopyWithImpl(this._value, this._then);

  final CompaniesCompanyId _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyId) _then;

  @override
  $Res call({
    Object? companiesCompanyIdGet = freezed,
  }) {
    return _then(_value.copyWith(
      companiesCompanyIdGet: companiesCompanyIdGet == freezed
          ? _value.companiesCompanyIdGet
          : companiesCompanyIdGet // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdGet,
    ));
  }

  @override
  $CompaniesCompanyIdGetCopyWith<$Res> get companiesCompanyIdGet {
    return $CompaniesCompanyIdGetCopyWith<$Res>(_value.companiesCompanyIdGet,
        (value) {
      return _then(_value.copyWith(companiesCompanyIdGet: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdCopyWith<$Res>
    implements $CompaniesCompanyIdCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdCopyWith(_$_CompaniesCompanyId value,
          $Res Function(_$_CompaniesCompanyId) then) =
      __$$_CompaniesCompanyIdCopyWithImpl<$Res>;
  @override
  $Res call({CompaniesCompanyIdGet companiesCompanyIdGet});

  @override
  $CompaniesCompanyIdGetCopyWith<$Res> get companiesCompanyIdGet;
}

/// @nodoc
class __$$_CompaniesCompanyIdCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdCopyWith<$Res> {
  __$$_CompaniesCompanyIdCopyWithImpl(
      _$_CompaniesCompanyId _value, $Res Function(_$_CompaniesCompanyId) _then)
      : super(_value, (v) => _then(v as _$_CompaniesCompanyId));

  @override
  _$_CompaniesCompanyId get _value => super._value as _$_CompaniesCompanyId;

  @override
  $Res call({
    Object? companiesCompanyIdGet = freezed,
  }) {
    return _then(_$_CompaniesCompanyId(
      companiesCompanyIdGet: companiesCompanyIdGet == freezed
          ? _value.companiesCompanyIdGet
          : companiesCompanyIdGet // ignore: cast_nullable_to_non_nullable
              as CompaniesCompanyIdGet,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyId implements _CompaniesCompanyId {
  const _$_CompaniesCompanyId({required this.companiesCompanyIdGet});

  factory _$_CompaniesCompanyId.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdFromJson(json);

  @override
  final CompaniesCompanyIdGet companiesCompanyIdGet;

  @override
  String toString() {
    return 'CompaniesCompanyId(companiesCompanyIdGet: $companiesCompanyIdGet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyId &&
            const DeepCollectionEquality()
                .equals(other.companiesCompanyIdGet, companiesCompanyIdGet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(companiesCompanyIdGet));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdCopyWith<_$_CompaniesCompanyId> get copyWith =>
      __$$_CompaniesCompanyIdCopyWithImpl<_$_CompaniesCompanyId>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdToJson(this);
  }
}

abstract class _CompaniesCompanyId implements CompaniesCompanyId {
  const factory _CompaniesCompanyId(
          {required final CompaniesCompanyIdGet companiesCompanyIdGet}) =
      _$_CompaniesCompanyId;

  factory _CompaniesCompanyId.fromJson(Map<String, dynamic> json) =
      _$_CompaniesCompanyId.fromJson;

  @override
  CompaniesCompanyIdGet get companiesCompanyIdGet =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdCopyWith<_$_CompaniesCompanyId> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesCompanyIdGet _$CompaniesCompanyIdGetFromJson(
    Map<String, dynamic> json) {
  return _CompaniesCompanyIdGet.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyIdGet {
  List<String> get tags => throw _privateConstructorUsedError;
  List<DeleteParameter> get parameters => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdGetCopyWith<CompaniesCompanyIdGet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdGetCopyWith<$Res> {
  factory $CompaniesCompanyIdGetCopyWith(CompaniesCompanyIdGet value,
          $Res Function(CompaniesCompanyIdGet) then) =
      _$CompaniesCompanyIdGetCopyWithImpl<$Res>;
  $Res call(
      {List<String> tags,
      List<DeleteParameter> parameters,
      Responses responses});

  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class _$CompaniesCompanyIdGetCopyWithImpl<$Res>
    implements $CompaniesCompanyIdGetCopyWith<$Res> {
  _$CompaniesCompanyIdGetCopyWithImpl(this._value, this._then);

  final CompaniesCompanyIdGet _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyIdGet) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<DeleteParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdGetCopyWith<$Res>
    implements $CompaniesCompanyIdGetCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdGetCopyWith(_$_CompaniesCompanyIdGet value,
          $Res Function(_$_CompaniesCompanyIdGet) then) =
      __$$_CompaniesCompanyIdGetCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> tags,
      List<DeleteParameter> parameters,
      Responses responses});

  @override
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class __$$_CompaniesCompanyIdGetCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdGetCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdGetCopyWith<$Res> {
  __$$_CompaniesCompanyIdGetCopyWithImpl(_$_CompaniesCompanyIdGet _value,
      $Res Function(_$_CompaniesCompanyIdGet) _then)
      : super(_value, (v) => _then(v as _$_CompaniesCompanyIdGet));

  @override
  _$_CompaniesCompanyIdGet get _value =>
      super._value as _$_CompaniesCompanyIdGet;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$_CompaniesCompanyIdGet(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<DeleteParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyIdGet implements _CompaniesCompanyIdGet {
  const _$_CompaniesCompanyIdGet(
      {required final List<String> tags,
      required final List<DeleteParameter> parameters,
      required this.responses})
      : _tags = tags,
        _parameters = parameters;

  factory _$_CompaniesCompanyIdGet.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdGetFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<DeleteParameter> _parameters;
  @override
  List<DeleteParameter> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  final Responses responses;

  @override
  String toString() {
    return 'CompaniesCompanyIdGet(tags: $tags, parameters: $parameters, responses: $responses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyIdGet &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other.responses, responses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(responses));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdGetCopyWith<_$_CompaniesCompanyIdGet> get copyWith =>
      __$$_CompaniesCompanyIdGetCopyWithImpl<_$_CompaniesCompanyIdGet>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdGetToJson(this);
  }
}

abstract class _CompaniesCompanyIdGet implements CompaniesCompanyIdGet {
  const factory _CompaniesCompanyIdGet(
      {required final List<String> tags,
      required final List<DeleteParameter> parameters,
      required final Responses responses}) = _$_CompaniesCompanyIdGet;

  factory _CompaniesCompanyIdGet.fromJson(Map<String, dynamic> json) =
      _$_CompaniesCompanyIdGet.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  List<DeleteParameter> get parameters => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdGetCopyWith<_$_CompaniesCompanyIdGet> get copyWith =>
      throw _privateConstructorUsedError;
}

DeleteParameter _$DeleteParameterFromJson(Map<String, dynamic> json) {
  return _DeleteParameter.fromJson(json);
}

/// @nodoc
mixin _$DeleteParameter {
  String get name => throw _privateConstructorUsedError;
  String get parameterIn => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;
  SubscriptionPlanId get schema => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeleteParameterCopyWith<DeleteParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteParameterCopyWith<$Res> {
  factory $DeleteParameterCopyWith(
          DeleteParameter value, $Res Function(DeleteParameter) then) =
      _$DeleteParameterCopyWithImpl<$Res>;
  $Res call(
      {String name,
      String parameterIn,
      bool required,
      SubscriptionPlanId schema});

  $SubscriptionPlanIdCopyWith<$Res> get schema;
}

/// @nodoc
class _$DeleteParameterCopyWithImpl<$Res>
    implements $DeleteParameterCopyWith<$Res> {
  _$DeleteParameterCopyWithImpl(this._value, this._then);

  final DeleteParameter _value;
  // ignore: unused_field
  final $Res Function(DeleteParameter) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? parameterIn = freezed,
    Object? required = freezed,
    Object? schema = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameterIn: parameterIn == freezed
          ? _value.parameterIn
          : parameterIn // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }

  @override
  $SubscriptionPlanIdCopyWith<$Res> get schema {
    return $SubscriptionPlanIdCopyWith<$Res>(_value.schema, (value) {
      return _then(_value.copyWith(schema: value));
    });
  }
}

/// @nodoc
abstract class _$$_DeleteParameterCopyWith<$Res>
    implements $DeleteParameterCopyWith<$Res> {
  factory _$$_DeleteParameterCopyWith(
          _$_DeleteParameter value, $Res Function(_$_DeleteParameter) then) =
      __$$_DeleteParameterCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      String parameterIn,
      bool required,
      SubscriptionPlanId schema});

  @override
  $SubscriptionPlanIdCopyWith<$Res> get schema;
}

/// @nodoc
class __$$_DeleteParameterCopyWithImpl<$Res>
    extends _$DeleteParameterCopyWithImpl<$Res>
    implements _$$_DeleteParameterCopyWith<$Res> {
  __$$_DeleteParameterCopyWithImpl(
      _$_DeleteParameter _value, $Res Function(_$_DeleteParameter) _then)
      : super(_value, (v) => _then(v as _$_DeleteParameter));

  @override
  _$_DeleteParameter get _value => super._value as _$_DeleteParameter;

  @override
  $Res call({
    Object? name = freezed,
    Object? parameterIn = freezed,
    Object? required = freezed,
    Object? schema = freezed,
  }) {
    return _then(_$_DeleteParameter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parameterIn: parameterIn == freezed
          ? _value.parameterIn
          : parameterIn // ignore: cast_nullable_to_non_nullable
              as String,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      schema: schema == freezed
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as SubscriptionPlanId,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DeleteParameter implements _DeleteParameter {
  const _$_DeleteParameter(
      {required this.name,
      required this.parameterIn,
      required this.required,
      required this.schema});

  factory _$_DeleteParameter.fromJson(Map<String, dynamic> json) =>
      _$$_DeleteParameterFromJson(json);

  @override
  final String name;
  @override
  final String parameterIn;
  @override
  final bool required;
  @override
  final SubscriptionPlanId schema;

  @override
  String toString() {
    return 'DeleteParameter(name: $name, parameterIn: $parameterIn, required: $required, schema: $schema)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DeleteParameter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.parameterIn, parameterIn) &&
            const DeepCollectionEquality().equals(other.required, required) &&
            const DeepCollectionEquality().equals(other.schema, schema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(parameterIn),
      const DeepCollectionEquality().hash(required),
      const DeepCollectionEquality().hash(schema));

  @JsonKey(ignore: true)
  @override
  _$$_DeleteParameterCopyWith<_$_DeleteParameter> get copyWith =>
      __$$_DeleteParameterCopyWithImpl<_$_DeleteParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DeleteParameterToJson(this);
  }
}

abstract class _DeleteParameter implements DeleteParameter {
  const factory _DeleteParameter(
      {required final String name,
      required final String parameterIn,
      required final bool required,
      required final SubscriptionPlanId schema}) = _$_DeleteParameter;

  factory _DeleteParameter.fromJson(Map<String, dynamic> json) =
      _$_DeleteParameter.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get parameterIn => throw _privateConstructorUsedError;
  @override
  bool get required => throw _privateConstructorUsedError;
  @override
  SubscriptionPlanId get schema => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DeleteParameterCopyWith<_$_DeleteParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesCompanyIdUsers _$CompaniesCompanyIdUsersFromJson(
    Map<String, dynamic> json) {
  return _CompaniesCompanyIdUsers.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyIdUsers {
  GetClass get companiesCompanyIdUsersGet => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdUsersCopyWith<CompaniesCompanyIdUsers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdUsersCopyWith<$Res> {
  factory $CompaniesCompanyIdUsersCopyWith(CompaniesCompanyIdUsers value,
          $Res Function(CompaniesCompanyIdUsers) then) =
      _$CompaniesCompanyIdUsersCopyWithImpl<$Res>;
  $Res call({GetClass companiesCompanyIdUsersGet});

  $GetClassCopyWith<$Res> get companiesCompanyIdUsersGet;
}

/// @nodoc
class _$CompaniesCompanyIdUsersCopyWithImpl<$Res>
    implements $CompaniesCompanyIdUsersCopyWith<$Res> {
  _$CompaniesCompanyIdUsersCopyWithImpl(this._value, this._then);

  final CompaniesCompanyIdUsers _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyIdUsers) _then;

  @override
  $Res call({
    Object? companiesCompanyIdUsersGet = freezed,
  }) {
    return _then(_value.copyWith(
      companiesCompanyIdUsersGet: companiesCompanyIdUsersGet == freezed
          ? _value.companiesCompanyIdUsersGet
          : companiesCompanyIdUsersGet // ignore: cast_nullable_to_non_nullable
              as GetClass,
    ));
  }

  @override
  $GetClassCopyWith<$Res> get companiesCompanyIdUsersGet {
    return $GetClassCopyWith<$Res>(_value.companiesCompanyIdUsersGet, (value) {
      return _then(_value.copyWith(companiesCompanyIdUsersGet: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdUsersCopyWith<$Res>
    implements $CompaniesCompanyIdUsersCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdUsersCopyWith(_$_CompaniesCompanyIdUsers value,
          $Res Function(_$_CompaniesCompanyIdUsers) then) =
      __$$_CompaniesCompanyIdUsersCopyWithImpl<$Res>;
  @override
  $Res call({GetClass companiesCompanyIdUsersGet});

  @override
  $GetClassCopyWith<$Res> get companiesCompanyIdUsersGet;
}

/// @nodoc
class __$$_CompaniesCompanyIdUsersCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdUsersCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdUsersCopyWith<$Res> {
  __$$_CompaniesCompanyIdUsersCopyWithImpl(_$_CompaniesCompanyIdUsers _value,
      $Res Function(_$_CompaniesCompanyIdUsers) _then)
      : super(_value, (v) => _then(v as _$_CompaniesCompanyIdUsers));

  @override
  _$_CompaniesCompanyIdUsers get _value =>
      super._value as _$_CompaniesCompanyIdUsers;

  @override
  $Res call({
    Object? companiesCompanyIdUsersGet = freezed,
  }) {
    return _then(_$_CompaniesCompanyIdUsers(
      companiesCompanyIdUsersGet: companiesCompanyIdUsersGet == freezed
          ? _value.companiesCompanyIdUsersGet
          : companiesCompanyIdUsersGet // ignore: cast_nullable_to_non_nullable
              as GetClass,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyIdUsers implements _CompaniesCompanyIdUsers {
  const _$_CompaniesCompanyIdUsers({required this.companiesCompanyIdUsersGet});

  factory _$_CompaniesCompanyIdUsers.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdUsersFromJson(json);

  @override
  final GetClass companiesCompanyIdUsersGet;

  @override
  String toString() {
    return 'CompaniesCompanyIdUsers(companiesCompanyIdUsersGet: $companiesCompanyIdUsersGet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyIdUsers &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdUsersGet, companiesCompanyIdUsersGet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(companiesCompanyIdUsersGet));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdUsersCopyWith<_$_CompaniesCompanyIdUsers>
      get copyWith =>
          __$$_CompaniesCompanyIdUsersCopyWithImpl<_$_CompaniesCompanyIdUsers>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdUsersToJson(this);
  }
}

abstract class _CompaniesCompanyIdUsers implements CompaniesCompanyIdUsers {
  const factory _CompaniesCompanyIdUsers(
          {required final GetClass companiesCompanyIdUsersGet}) =
      _$_CompaniesCompanyIdUsers;

  factory _CompaniesCompanyIdUsers.fromJson(Map<String, dynamic> json) =
      _$_CompaniesCompanyIdUsers.fromJson;

  @override
  GetClass get companiesCompanyIdUsersGet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdUsersCopyWith<_$_CompaniesCompanyIdUsers>
      get copyWith => throw _privateConstructorUsedError;
}

CompaniesCompanyIdUsersUserId _$CompaniesCompanyIdUsersUserIdFromJson(
    Map<String, dynamic> json) {
  return _CompaniesCompanyIdUsersUserId.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyIdUsersUserId {
  Delete get companiesCompanyIdUsersUserIdGet =>
      throw _privateConstructorUsedError;
  Delete get delete => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdUsersUserIdCopyWith<CompaniesCompanyIdUsersUserId>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdUsersUserIdCopyWith<$Res> {
  factory $CompaniesCompanyIdUsersUserIdCopyWith(
          CompaniesCompanyIdUsersUserId value,
          $Res Function(CompaniesCompanyIdUsersUserId) then) =
      _$CompaniesCompanyIdUsersUserIdCopyWithImpl<$Res>;
  $Res call({Delete companiesCompanyIdUsersUserIdGet, Delete delete});

  $DeleteCopyWith<$Res> get companiesCompanyIdUsersUserIdGet;
  $DeleteCopyWith<$Res> get delete;
}

/// @nodoc
class _$CompaniesCompanyIdUsersUserIdCopyWithImpl<$Res>
    implements $CompaniesCompanyIdUsersUserIdCopyWith<$Res> {
  _$CompaniesCompanyIdUsersUserIdCopyWithImpl(this._value, this._then);

  final CompaniesCompanyIdUsersUserId _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyIdUsersUserId) _then;

  @override
  $Res call({
    Object? companiesCompanyIdUsersUserIdGet = freezed,
    Object? delete = freezed,
  }) {
    return _then(_value.copyWith(
      companiesCompanyIdUsersUserIdGet: companiesCompanyIdUsersUserIdGet ==
              freezed
          ? _value.companiesCompanyIdUsersUserIdGet
          : companiesCompanyIdUsersUserIdGet // ignore: cast_nullable_to_non_nullable
              as Delete,
      delete: delete == freezed
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as Delete,
    ));
  }

  @override
  $DeleteCopyWith<$Res> get companiesCompanyIdUsersUserIdGet {
    return $DeleteCopyWith<$Res>(_value.companiesCompanyIdUsersUserIdGet,
        (value) {
      return _then(_value.copyWith(companiesCompanyIdUsersUserIdGet: value));
    });
  }

  @override
  $DeleteCopyWith<$Res> get delete {
    return $DeleteCopyWith<$Res>(_value.delete, (value) {
      return _then(_value.copyWith(delete: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdUsersUserIdCopyWith<$Res>
    implements $CompaniesCompanyIdUsersUserIdCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdUsersUserIdCopyWith(
          _$_CompaniesCompanyIdUsersUserId value,
          $Res Function(_$_CompaniesCompanyIdUsersUserId) then) =
      __$$_CompaniesCompanyIdUsersUserIdCopyWithImpl<$Res>;
  @override
  $Res call({Delete companiesCompanyIdUsersUserIdGet, Delete delete});

  @override
  $DeleteCopyWith<$Res> get companiesCompanyIdUsersUserIdGet;
  @override
  $DeleteCopyWith<$Res> get delete;
}

/// @nodoc
class __$$_CompaniesCompanyIdUsersUserIdCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdUsersUserIdCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdUsersUserIdCopyWith<$Res> {
  __$$_CompaniesCompanyIdUsersUserIdCopyWithImpl(
      _$_CompaniesCompanyIdUsersUserId _value,
      $Res Function(_$_CompaniesCompanyIdUsersUserId) _then)
      : super(_value, (v) => _then(v as _$_CompaniesCompanyIdUsersUserId));

  @override
  _$_CompaniesCompanyIdUsersUserId get _value =>
      super._value as _$_CompaniesCompanyIdUsersUserId;

  @override
  $Res call({
    Object? companiesCompanyIdUsersUserIdGet = freezed,
    Object? delete = freezed,
  }) {
    return _then(_$_CompaniesCompanyIdUsersUserId(
      companiesCompanyIdUsersUserIdGet: companiesCompanyIdUsersUserIdGet ==
              freezed
          ? _value.companiesCompanyIdUsersUserIdGet
          : companiesCompanyIdUsersUserIdGet // ignore: cast_nullable_to_non_nullable
              as Delete,
      delete: delete == freezed
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as Delete,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyIdUsersUserId
    implements _CompaniesCompanyIdUsersUserId {
  const _$_CompaniesCompanyIdUsersUserId(
      {required this.companiesCompanyIdUsersUserIdGet, required this.delete});

  factory _$_CompaniesCompanyIdUsersUserId.fromJson(
          Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdUsersUserIdFromJson(json);

  @override
  final Delete companiesCompanyIdUsersUserIdGet;
  @override
  final Delete delete;

  @override
  String toString() {
    return 'CompaniesCompanyIdUsersUserId(companiesCompanyIdUsersUserIdGet: $companiesCompanyIdUsersUserIdGet, delete: $delete)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyIdUsersUserId &&
            const DeepCollectionEquality().equals(
                other.companiesCompanyIdUsersUserIdGet,
                companiesCompanyIdUsersUserIdGet) &&
            const DeepCollectionEquality().equals(other.delete, delete));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(companiesCompanyIdUsersUserIdGet),
      const DeepCollectionEquality().hash(delete));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdUsersUserIdCopyWith<_$_CompaniesCompanyIdUsersUserId>
      get copyWith => __$$_CompaniesCompanyIdUsersUserIdCopyWithImpl<
          _$_CompaniesCompanyIdUsersUserId>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdUsersUserIdToJson(this);
  }
}

abstract class _CompaniesCompanyIdUsersUserId
    implements CompaniesCompanyIdUsersUserId {
  const factory _CompaniesCompanyIdUsersUserId(
      {required final Delete companiesCompanyIdUsersUserIdGet,
      required final Delete delete}) = _$_CompaniesCompanyIdUsersUserId;

  factory _CompaniesCompanyIdUsersUserId.fromJson(Map<String, dynamic> json) =
      _$_CompaniesCompanyIdUsersUserId.fromJson;

  @override
  Delete get companiesCompanyIdUsersUserIdGet =>
      throw _privateConstructorUsedError;
  @override
  Delete get delete => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdUsersUserIdCopyWith<_$_CompaniesCompanyIdUsersUserId>
      get copyWith => throw _privateConstructorUsedError;
}

Delete _$DeleteFromJson(Map<String, dynamic> json) {
  return _Delete.fromJson(json);
}

/// @nodoc
mixin _$Delete {
  List<String> get tags => throw _privateConstructorUsedError;
  List<DeleteParameter> get parameters => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;
  GetRequestBody get requestBody => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeleteCopyWith<Delete> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteCopyWith<$Res> {
  factory $DeleteCopyWith(Delete value, $Res Function(Delete) then) =
      _$DeleteCopyWithImpl<$Res>;
  $Res call(
      {List<String> tags,
      List<DeleteParameter> parameters,
      Responses responses,
      GetRequestBody requestBody});

  $ResponsesCopyWith<$Res> get responses;
  $GetRequestBodyCopyWith<$Res> get requestBody;
}

/// @nodoc
class _$DeleteCopyWithImpl<$Res> implements $DeleteCopyWith<$Res> {
  _$DeleteCopyWithImpl(this._value, this._then);

  final Delete _value;
  // ignore: unused_field
  final $Res Function(Delete) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
    Object? requestBody = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<DeleteParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as GetRequestBody,
    ));
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }

  @override
  $GetRequestBodyCopyWith<$Res> get requestBody {
    return $GetRequestBodyCopyWith<$Res>(_value.requestBody, (value) {
      return _then(_value.copyWith(requestBody: value));
    });
  }
}

/// @nodoc
abstract class _$$_DeleteCopyWith<$Res> implements $DeleteCopyWith<$Res> {
  factory _$$_DeleteCopyWith(_$_Delete value, $Res Function(_$_Delete) then) =
      __$$_DeleteCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> tags,
      List<DeleteParameter> parameters,
      Responses responses,
      GetRequestBody requestBody});

  @override
  $ResponsesCopyWith<$Res> get responses;
  @override
  $GetRequestBodyCopyWith<$Res> get requestBody;
}

/// @nodoc
class __$$_DeleteCopyWithImpl<$Res> extends _$DeleteCopyWithImpl<$Res>
    implements _$$_DeleteCopyWith<$Res> {
  __$$_DeleteCopyWithImpl(_$_Delete _value, $Res Function(_$_Delete) _then)
      : super(_value, (v) => _then(v as _$_Delete));

  @override
  _$_Delete get _value => super._value as _$_Delete;

  @override
  $Res call({
    Object? tags = freezed,
    Object? parameters = freezed,
    Object? responses = freezed,
    Object? requestBody = freezed,
  }) {
    return _then(_$_Delete(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parameters: parameters == freezed
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<DeleteParameter>,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as GetRequestBody,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Delete implements _Delete {
  const _$_Delete(
      {required final List<String> tags,
      required final List<DeleteParameter> parameters,
      required this.responses,
      required this.requestBody})
      : _tags = tags,
        _parameters = parameters;

  factory _$_Delete.fromJson(Map<String, dynamic> json) =>
      _$$_DeleteFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<DeleteParameter> _parameters;
  @override
  List<DeleteParameter> get parameters {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parameters);
  }

  @override
  final Responses responses;
  @override
  final GetRequestBody requestBody;

  @override
  String toString() {
    return 'Delete(tags: $tags, parameters: $parameters, responses: $responses, requestBody: $requestBody)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Delete &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other.responses, responses) &&
            const DeepCollectionEquality()
                .equals(other.requestBody, requestBody));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(responses),
      const DeepCollectionEquality().hash(requestBody));

  @JsonKey(ignore: true)
  @override
  _$$_DeleteCopyWith<_$_Delete> get copyWith =>
      __$$_DeleteCopyWithImpl<_$_Delete>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DeleteToJson(this);
  }
}

abstract class _Delete implements Delete {
  const factory _Delete(
      {required final List<String> tags,
      required final List<DeleteParameter> parameters,
      required final Responses responses,
      required final GetRequestBody requestBody}) = _$_Delete;

  factory _Delete.fromJson(Map<String, dynamic> json) = _$_Delete.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  List<DeleteParameter> get parameters => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  GetRequestBody get requestBody => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DeleteCopyWith<_$_Delete> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesCompanyIdUsersUserIdUpdate
    _$CompaniesCompanyIdUsersUserIdUpdateFromJson(Map<String, dynamic> json) {
  return _CompaniesCompanyIdUsersUserIdUpdate.fromJson(json);
}

/// @nodoc
mixin _$CompaniesCompanyIdUsersUserIdUpdate {
  Delete get put => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesCompanyIdUsersUserIdUpdateCopyWith<
          CompaniesCompanyIdUsersUserIdUpdate>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res> {
  factory $CompaniesCompanyIdUsersUserIdUpdateCopyWith(
          CompaniesCompanyIdUsersUserIdUpdate value,
          $Res Function(CompaniesCompanyIdUsersUserIdUpdate) then) =
      _$CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<$Res>;
  $Res call({Delete put});

  $DeleteCopyWith<$Res> get put;
}

/// @nodoc
class _$CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<$Res>
    implements $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res> {
  _$CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl(this._value, this._then);

  final CompaniesCompanyIdUsersUserIdUpdate _value;
  // ignore: unused_field
  final $Res Function(CompaniesCompanyIdUsersUserIdUpdate) _then;

  @override
  $Res call({
    Object? put = freezed,
  }) {
    return _then(_value.copyWith(
      put: put == freezed
          ? _value.put
          : put // ignore: cast_nullable_to_non_nullable
              as Delete,
    ));
  }

  @override
  $DeleteCopyWith<$Res> get put {
    return $DeleteCopyWith<$Res>(_value.put, (value) {
      return _then(_value.copyWith(put: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res>
    implements $CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res> {
  factory _$$_CompaniesCompanyIdUsersUserIdUpdateCopyWith(
          _$_CompaniesCompanyIdUsersUserIdUpdate value,
          $Res Function(_$_CompaniesCompanyIdUsersUserIdUpdate) then) =
      __$$_CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<$Res>;
  @override
  $Res call({Delete put});

  @override
  $DeleteCopyWith<$Res> get put;
}

/// @nodoc
class __$$_CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<$Res>
    extends _$CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<$Res>
    implements _$$_CompaniesCompanyIdUsersUserIdUpdateCopyWith<$Res> {
  __$$_CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl(
      _$_CompaniesCompanyIdUsersUserIdUpdate _value,
      $Res Function(_$_CompaniesCompanyIdUsersUserIdUpdate) _then)
      : super(
            _value, (v) => _then(v as _$_CompaniesCompanyIdUsersUserIdUpdate));

  @override
  _$_CompaniesCompanyIdUsersUserIdUpdate get _value =>
      super._value as _$_CompaniesCompanyIdUsersUserIdUpdate;

  @override
  $Res call({
    Object? put = freezed,
  }) {
    return _then(_$_CompaniesCompanyIdUsersUserIdUpdate(
      put: put == freezed
          ? _value.put
          : put // ignore: cast_nullable_to_non_nullable
              as Delete,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesCompanyIdUsersUserIdUpdate
    implements _CompaniesCompanyIdUsersUserIdUpdate {
  const _$_CompaniesCompanyIdUsersUserIdUpdate({required this.put});

  factory _$_CompaniesCompanyIdUsersUserIdUpdate.fromJson(
          Map<String, dynamic> json) =>
      _$$_CompaniesCompanyIdUsersUserIdUpdateFromJson(json);

  @override
  final Delete put;

  @override
  String toString() {
    return 'CompaniesCompanyIdUsersUserIdUpdate(put: $put)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesCompanyIdUsersUserIdUpdate &&
            const DeepCollectionEquality().equals(other.put, put));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(put));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesCompanyIdUsersUserIdUpdateCopyWith<
          _$_CompaniesCompanyIdUsersUserIdUpdate>
      get copyWith => __$$_CompaniesCompanyIdUsersUserIdUpdateCopyWithImpl<
          _$_CompaniesCompanyIdUsersUserIdUpdate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesCompanyIdUsersUserIdUpdateToJson(this);
  }
}

abstract class _CompaniesCompanyIdUsersUserIdUpdate
    implements CompaniesCompanyIdUsersUserIdUpdate {
  const factory _CompaniesCompanyIdUsersUserIdUpdate(
      {required final Delete put}) = _$_CompaniesCompanyIdUsersUserIdUpdate;

  factory _CompaniesCompanyIdUsersUserIdUpdate.fromJson(
          Map<String, dynamic> json) =
      _$_CompaniesCompanyIdUsersUserIdUpdate.fromJson;

  @override
  Delete get put => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesCompanyIdUsersUserIdUpdateCopyWith<
          _$_CompaniesCompanyIdUsersUserIdUpdate>
      get copyWith => throw _privateConstructorUsedError;
}

CompaniesRegister _$CompaniesRegisterFromJson(Map<String, dynamic> json) {
  return _CompaniesRegister.fromJson(json);
}

/// @nodoc
mixin _$CompaniesRegister {
  CompaniesRegisterPost get post => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesRegisterCopyWith<CompaniesRegister> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesRegisterCopyWith<$Res> {
  factory $CompaniesRegisterCopyWith(
          CompaniesRegister value, $Res Function(CompaniesRegister) then) =
      _$CompaniesRegisterCopyWithImpl<$Res>;
  $Res call({CompaniesRegisterPost post});

  $CompaniesRegisterPostCopyWith<$Res> get post;
}

/// @nodoc
class _$CompaniesRegisterCopyWithImpl<$Res>
    implements $CompaniesRegisterCopyWith<$Res> {
  _$CompaniesRegisterCopyWithImpl(this._value, this._then);

  final CompaniesRegister _value;
  // ignore: unused_field
  final $Res Function(CompaniesRegister) _then;

  @override
  $Res call({
    Object? post = freezed,
  }) {
    return _then(_value.copyWith(
      post: post == freezed
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as CompaniesRegisterPost,
    ));
  }

  @override
  $CompaniesRegisterPostCopyWith<$Res> get post {
    return $CompaniesRegisterPostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesRegisterCopyWith<$Res>
    implements $CompaniesRegisterCopyWith<$Res> {
  factory _$$_CompaniesRegisterCopyWith(_$_CompaniesRegister value,
          $Res Function(_$_CompaniesRegister) then) =
      __$$_CompaniesRegisterCopyWithImpl<$Res>;
  @override
  $Res call({CompaniesRegisterPost post});

  @override
  $CompaniesRegisterPostCopyWith<$Res> get post;
}

/// @nodoc
class __$$_CompaniesRegisterCopyWithImpl<$Res>
    extends _$CompaniesRegisterCopyWithImpl<$Res>
    implements _$$_CompaniesRegisterCopyWith<$Res> {
  __$$_CompaniesRegisterCopyWithImpl(
      _$_CompaniesRegister _value, $Res Function(_$_CompaniesRegister) _then)
      : super(_value, (v) => _then(v as _$_CompaniesRegister));

  @override
  _$_CompaniesRegister get _value => super._value as _$_CompaniesRegister;

  @override
  $Res call({
    Object? post = freezed,
  }) {
    return _then(_$_CompaniesRegister(
      post: post == freezed
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as CompaniesRegisterPost,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesRegister implements _CompaniesRegister {
  const _$_CompaniesRegister({required this.post});

  factory _$_CompaniesRegister.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesRegisterFromJson(json);

  @override
  final CompaniesRegisterPost post;

  @override
  String toString() {
    return 'CompaniesRegister(post: $post)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesRegister &&
            const DeepCollectionEquality().equals(other.post, post));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(post));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesRegisterCopyWith<_$_CompaniesRegister> get copyWith =>
      __$$_CompaniesRegisterCopyWithImpl<_$_CompaniesRegister>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesRegisterToJson(this);
  }
}

abstract class _CompaniesRegister implements CompaniesRegister {
  const factory _CompaniesRegister(
      {required final CompaniesRegisterPost post}) = _$_CompaniesRegister;

  factory _CompaniesRegister.fromJson(Map<String, dynamic> json) =
      _$_CompaniesRegister.fromJson;

  @override
  CompaniesRegisterPost get post => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesRegisterCopyWith<_$_CompaniesRegister> get copyWith =>
      throw _privateConstructorUsedError;
}

CompaniesRegisterPost _$CompaniesRegisterPostFromJson(
    Map<String, dynamic> json) {
  return _CompaniesRegisterPost.fromJson(json);
}

/// @nodoc
mixin _$CompaniesRegisterPost {
  List<String> get tags => throw _privateConstructorUsedError;
  PurpleRequestBody get requestBody => throw _privateConstructorUsedError;
  Responses get responses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompaniesRegisterPostCopyWith<CompaniesRegisterPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompaniesRegisterPostCopyWith<$Res> {
  factory $CompaniesRegisterPostCopyWith(CompaniesRegisterPost value,
          $Res Function(CompaniesRegisterPost) then) =
      _$CompaniesRegisterPostCopyWithImpl<$Res>;
  $Res call(
      {List<String> tags, PurpleRequestBody requestBody, Responses responses});

  $PurpleRequestBodyCopyWith<$Res> get requestBody;
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class _$CompaniesRegisterPostCopyWithImpl<$Res>
    implements $CompaniesRegisterPostCopyWith<$Res> {
  _$CompaniesRegisterPostCopyWithImpl(this._value, this._then);

  final CompaniesRegisterPost _value;
  // ignore: unused_field
  final $Res Function(CompaniesRegisterPost) _then;

  @override
  $Res call({
    Object? tags = freezed,
    Object? requestBody = freezed,
    Object? responses = freezed,
  }) {
    return _then(_value.copyWith(
      tags: tags == freezed
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as PurpleRequestBody,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }

  @override
  $PurpleRequestBodyCopyWith<$Res> get requestBody {
    return $PurpleRequestBodyCopyWith<$Res>(_value.requestBody, (value) {
      return _then(_value.copyWith(requestBody: value));
    });
  }

  @override
  $ResponsesCopyWith<$Res> get responses {
    return $ResponsesCopyWith<$Res>(_value.responses, (value) {
      return _then(_value.copyWith(responses: value));
    });
  }
}

/// @nodoc
abstract class _$$_CompaniesRegisterPostCopyWith<$Res>
    implements $CompaniesRegisterPostCopyWith<$Res> {
  factory _$$_CompaniesRegisterPostCopyWith(_$_CompaniesRegisterPost value,
          $Res Function(_$_CompaniesRegisterPost) then) =
      __$$_CompaniesRegisterPostCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<String> tags, PurpleRequestBody requestBody, Responses responses});

  @override
  $PurpleRequestBodyCopyWith<$Res> get requestBody;
  @override
  $ResponsesCopyWith<$Res> get responses;
}

/// @nodoc
class __$$_CompaniesRegisterPostCopyWithImpl<$Res>
    extends _$CompaniesRegisterPostCopyWithImpl<$Res>
    implements _$$_CompaniesRegisterPostCopyWith<$Res> {
  __$$_CompaniesRegisterPostCopyWithImpl(_$_CompaniesRegisterPost _value,
      $Res Function(_$_CompaniesRegisterPost) _then)
      : super(_value, (v) => _then(v as _$_CompaniesRegisterPost));

  @override
  _$_CompaniesRegisterPost get _value =>
      super._value as _$_CompaniesRegisterPost;

  @override
  $Res call({
    Object? tags = freezed,
    Object? requestBody = freezed,
    Object? responses = freezed,
  }) {
    return _then(_$_CompaniesRegisterPost(
      tags: tags == freezed
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requestBody: requestBody == freezed
          ? _value.requestBody
          : requestBody // ignore: cast_nullable_to_non_nullable
              as PurpleRequestBody,
      responses: responses == freezed
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as Responses,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CompaniesRegisterPost implements _CompaniesRegisterPost {
  const _$_CompaniesRegisterPost(
      {required final List<String> tags,
      required this.requestBody,
      required this.responses})
      : _tags = tags;

  factory _$_CompaniesRegisterPost.fromJson(Map<String, dynamic> json) =>
      _$$_CompaniesRegisterPostFromJson(json);

  final List<String> _tags;
  @override
  List<String> get tags {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final PurpleRequestBody requestBody;
  @override
  final Responses responses;

  @override
  String toString() {
    return 'CompaniesRegisterPost(tags: $tags, requestBody: $requestBody, responses: $responses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompaniesRegisterPost &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other.requestBody, requestBody) &&
            const DeepCollectionEquality().equals(other.responses, responses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(requestBody),
      const DeepCollectionEquality().hash(responses));

  @JsonKey(ignore: true)
  @override
  _$$_CompaniesRegisterPostCopyWith<_$_CompaniesRegisterPost> get copyWith =>
      __$$_CompaniesRegisterPostCopyWithImpl<_$_CompaniesRegisterPost>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CompaniesRegisterPostToJson(this);
  }
}

abstract class _CompaniesRegisterPost implements CompaniesRegisterPost {
  const factory _CompaniesRegisterPost(
      {required final List<String> tags,
      required final PurpleRequestBody requestBody,
      required final Responses responses}) = _$_CompaniesRegisterPost;

  factory _CompaniesRegisterPost.fromJson(Map<String, dynamic> json) =
      _$_CompaniesRegisterPost.fromJson;

  @override
  List<String> get tags => throw _privateConstructorUsedError;
  @override
  PurpleRequestBody get requestBody => throw _privateConstructorUsedError;
  @override
  Responses get responses => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CompaniesRegisterPostCopyWith<_$_CompaniesRegisterPost> get copyWith =>
      throw _privateConstructorUsedError;
}

PurpleRequestBody _$PurpleRequestBodyFromJson(Map<String, dynamic> json) {
  return _PurpleRequestBody.fromJson(json);
}

/// @nodoc
mixin _$PurpleRequestBody {
  Content get content => throw _privateConstructorUsedError;
  bool get required => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurpleRequestBodyCopyWith<PurpleRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurpleRequestBodyCopyWith<$Res> {
  factory $PurpleRequestBodyCopyWith(
          PurpleRequestBody value, $Res Function(PurpleRequestBody) then) =
      _$PurpleRequestBodyCopyWithImpl<$Res>;
  $Res call({Content content, bool required});

  $ContentCopyWith<$Res> get content;
}

/// @nodoc
class _$PurpleRequestBodyCopyWithImpl<$Res>
    implements $PurpleRequestBodyCopyWith<$Res> {
  _$PurpleRequestBodyCopyWithImpl(this._value, this._then);

  final PurpleRequestBody _value;
  // ignore: unused_field
  final $Res Function(PurpleRequestBody) _then;

  @override
  $Res call({
    Object? content = freezed,
    Object? required = freezed,
  }) {
    return _then(_value.copyWith(
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $ContentCopyWith<$Res> get content {
    return $ContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value));
    });
  }
}

/// @nodoc
abstract class _$$_PurpleRequestBodyCopyWith<$Res>
    implements $PurpleRequestBodyCopyWith<$Res> {
  factory _$$_PurpleRequestBodyCopyWith(_$_PurpleRequestBody value,
          $Res Function(_$_PurpleRequestBody) then) =
      __$$_PurpleRequestBodyCopyWithImpl<$Res>;
  @override
  $Res call({Content content, bool required});

  @override
  $ContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$_PurpleRequestBodyCopyWithImpl<$Res>
    extends _$PurpleRequestBodyCopyWithImpl<$Res>
    implements _$$_PurpleRequestBodyCopyWith<$Res> {
  __$$_PurpleRequestBodyCopyWithImpl(
      _$_PurpleRequestBody _value, $Res Function(_$_PurpleRequestBody) _then)
      : super(_value, (v) => _then(v as _$_PurpleRequestBody));

  @override
  _$_PurpleRequestBody get _value => super._value as _$_PurpleRequestBody;

  @override
  $Res call({
    Object? content = freezed,
    Object? required = freezed,
  }) {
    return _then(_$_PurpleRequestBody(
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content,
      required: required == freezed
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PurpleRequestBody implements _PurpleRequestBody {
  const _$_PurpleRequestBody({required this.content, required this.required});

  factory _$_PurpleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$$_PurpleRequestBodyFromJson(json);

  @override
  final Content content;
  @override
  final bool required;

  @override
  String toString() {
    return 'PurpleRequestBody(content: $content, required: $required)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PurpleRequestBody &&
            const DeepCollectionEquality().equals(other.content, content) &&
            const DeepCollectionEquality().equals(other.required, required));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(content),
      const DeepCollectionEquality().hash(required));

  @JsonKey(ignore: true)
  @override
  _$$_PurpleRequestBodyCopyWith<_$_PurpleRequestBody> get copyWith =>
      __$$_PurpleRequestBodyCopyWithImpl<_$_PurpleRequestBody>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PurpleRequestBodyToJson(this);
  }
}

abstract class _PurpleRequestBody implements PurpleRequestBody {
  const factory _PurpleRequestBody(
      {required final Content content,
      required final bool required}) = _$_PurpleRequestBody;

  factory _PurpleRequestBody.fromJson(Map<String, dynamic> json) =
      _$_PurpleRequestBody.fromJson;

  @override
  Content get content => throw _privateConstructorUsedError;
  @override
  bool get required => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PurpleRequestBodyCopyWith<_$_PurpleRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}
