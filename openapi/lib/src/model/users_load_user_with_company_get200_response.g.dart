// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_load_user_with_company_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number0 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum._('number0');
const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number1 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum._('number1');
const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number2 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum._('number2');

UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'number0':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number0;
    case 'number1':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number1;
    case 'number2':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number2;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum>
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumValues = BuiltSet<
        UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum>(const <UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum>[
  _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number0,
  _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number1,
  _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number2,
]);

Serializer<UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum>
    _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumSerializer =
    _$UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnumSerializer();

class _$UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnumSerializer
    implements
        PrimitiveSerializer<
            UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
    'number2': 2,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
    2: 'number2',
  };

  @override
  final Iterable<Type> types = const <Type>[
    UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum
  ];
  @override
  final String wireName =
      'UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum';

  @override
  Object serialize(Serializers serializers,
          UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UsersLoadUserWithCompanyGet200Response
    extends UsersLoadUserWithCompanyGet200Response {
  @override
  final String? userId;
  @override
  final String? salutation;
  @override
  final String? title;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? telephoneNr;
  @override
  final String? emailAddress;
  @override
  final BuiltList<String>? roles;
  @override
  final String? activeRole;
  @override
  final String? companyId;
  @override
  final String? companyName;
  @override
  final Address? companyAddress;
  @override
  final UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? companyType;

  factory _$UsersLoadUserWithCompanyGet200Response(
          [void Function(UsersLoadUserWithCompanyGet200ResponseBuilder)?
              updates]) =>
      (UsersLoadUserWithCompanyGet200ResponseBuilder()..update(updates))
          ._build();

  _$UsersLoadUserWithCompanyGet200Response._(
      {this.userId,
      this.salutation,
      this.title,
      this.firstName,
      this.lastName,
      this.telephoneNr,
      this.emailAddress,
      this.roles,
      this.activeRole,
      this.companyId,
      this.companyName,
      this.companyAddress,
      this.companyType})
      : super._();
  @override
  UsersLoadUserWithCompanyGet200Response rebuild(
          void Function(UsersLoadUserWithCompanyGet200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsersLoadUserWithCompanyGet200ResponseBuilder toBuilder() =>
      UsersLoadUserWithCompanyGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsersLoadUserWithCompanyGet200Response &&
        userId == other.userId &&
        salutation == other.salutation &&
        title == other.title &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        telephoneNr == other.telephoneNr &&
        emailAddress == other.emailAddress &&
        roles == other.roles &&
        activeRole == other.activeRole &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        companyAddress == other.companyAddress &&
        companyType == other.companyType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, salutation.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, telephoneNr.hashCode);
    _$hash = $jc(_$hash, emailAddress.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, activeRole.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companyAddress.hashCode);
    _$hash = $jc(_$hash, companyType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'UsersLoadUserWithCompanyGet200Response')
          ..add('userId', userId)
          ..add('salutation', salutation)
          ..add('title', title)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('telephoneNr', telephoneNr)
          ..add('emailAddress', emailAddress)
          ..add('roles', roles)
          ..add('activeRole', activeRole)
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('companyAddress', companyAddress)
          ..add('companyType', companyType))
        .toString();
  }
}

class UsersLoadUserWithCompanyGet200ResponseBuilder
    implements
        Builder<UsersLoadUserWithCompanyGet200Response,
            UsersLoadUserWithCompanyGet200ResponseBuilder> {
  _$UsersLoadUserWithCompanyGet200Response? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _salutation;
  String? get salutation => _$this._salutation;
  set salutation(String? salutation) => _$this._salutation = salutation;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _telephoneNr;
  String? get telephoneNr => _$this._telephoneNr;
  set telephoneNr(String? telephoneNr) => _$this._telephoneNr = telephoneNr;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  ListBuilder<String>? _roles;
  ListBuilder<String> get roles => _$this._roles ??= ListBuilder<String>();
  set roles(ListBuilder<String>? roles) => _$this._roles = roles;

  String? _activeRole;
  String? get activeRole => _$this._activeRole;
  set activeRole(String? activeRole) => _$this._activeRole = activeRole;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  AddressBuilder? _companyAddress;
  AddressBuilder get companyAddress =>
      _$this._companyAddress ??= AddressBuilder();
  set companyAddress(AddressBuilder? companyAddress) =>
      _$this._companyAddress = companyAddress;

  UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? _companyType;
  UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? get companyType =>
      _$this._companyType;
  set companyType(
          UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? companyType) =>
      _$this._companyType = companyType;

  UsersLoadUserWithCompanyGet200ResponseBuilder() {
    UsersLoadUserWithCompanyGet200Response._defaults(this);
  }

  UsersLoadUserWithCompanyGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _salutation = $v.salutation;
      _title = $v.title;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _telephoneNr = $v.telephoneNr;
      _emailAddress = $v.emailAddress;
      _roles = $v.roles?.toBuilder();
      _activeRole = $v.activeRole;
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _companyAddress = $v.companyAddress?.toBuilder();
      _companyType = $v.companyType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsersLoadUserWithCompanyGet200Response other) {
    _$v = other as _$UsersLoadUserWithCompanyGet200Response;
  }

  @override
  void update(
      void Function(UsersLoadUserWithCompanyGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsersLoadUserWithCompanyGet200Response build() => _build();

  _$UsersLoadUserWithCompanyGet200Response _build() {
    _$UsersLoadUserWithCompanyGet200Response _$result;
    try {
      _$result = _$v ??
          _$UsersLoadUserWithCompanyGet200Response._(
            userId: userId,
            salutation: salutation,
            title: title,
            firstName: firstName,
            lastName: lastName,
            telephoneNr: telephoneNr,
            emailAddress: emailAddress,
            roles: _roles?.build(),
            activeRole: activeRole,
            companyId: companyId,
            companyName: companyName,
            companyAddress: _companyAddress?.build(),
            companyType: companyType,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        _roles?.build();

        _$failedField = 'companyAddress';
        _companyAddress?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UsersLoadUserWithCompanyGet200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
