// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_load_user_with_company_get200_response_company_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number0 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
        ._('number0');
const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number1 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
        ._('number1');
const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number2 =
    const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
        ._('number2');

UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'number0':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number0;
    case 'number1':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number1;
    case 'number2':
      return _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number2;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum>
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumValues =
    BuiltSet<
        UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum>(const <UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum>[
  _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number0,
  _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number1,
  _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number2,
]);

Serializer<
        UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum>
    _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumSerializer =
    _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumSerializer();

class _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumSerializer
    implements
        PrimitiveSerializer<
            UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum> {
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
    UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
  ];
  @override
  final String wireName =
      'UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum';

  @override
  Object serialize(
          Serializers serializers,
          UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner
    extends UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner {
  @override
  final String? companyId;
  @override
  final String? companyName;
  @override
  final UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum?
      companyType;
  @override
  final BuiltList<String>? roles;
  @override
  final String? activeRole;

  factory _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner(
          [void Function(
                  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder)?
              updates]) =>
      (UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner._(
      {this.companyId,
      this.companyName,
      this.companyType,
      this.roles,
      this.activeRole})
      : super._();
  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner rebuild(
          void Function(
                  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder
      toBuilder() =>
          UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        companyType == other.companyType &&
        roles == other.roles &&
        activeRole == other.activeRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companyType.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, activeRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner')
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('companyType', companyType)
          ..add('roles', roles)
          ..add('activeRole', activeRole))
        .toString();
  }
}

class UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder
    implements
        Builder<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner,
            UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder> {
  _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum?
      _companyType;
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum?
      get companyType => _$this._companyType;
  set companyType(
          UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum?
              companyType) =>
      _$this._companyType = companyType;

  ListBuilder<String>? _roles;
  ListBuilder<String> get roles => _$this._roles ??= ListBuilder<String>();
  set roles(ListBuilder<String>? roles) => _$this._roles = roles;

  String? _activeRole;
  String? get activeRole => _$this._activeRole;
  set activeRole(String? activeRole) => _$this._activeRole = activeRole;

  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder() {
    UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner._defaults(this);
  }

  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _companyType = $v.companyType;
      _roles = $v.roles?.toBuilder();
      _activeRole = $v.activeRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner other) {
    _$v = other as _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner;
  }

  @override
  void update(
      void Function(
              UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner build() => _build();

  _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner _build() {
    _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner _$result;
    try {
      _$result = _$v ??
          _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner._(
            companyId: companyId,
            companyName: companyName,
            companyType: companyType,
            roles: _roles?.build(),
            activeRole: activeRole,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        _roles?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner',
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
