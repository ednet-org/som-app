// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserRegistrationRolesEnum _$userRegistrationRolesEnum_number0 =
    const UserRegistrationRolesEnum._('number0');
const UserRegistrationRolesEnum _$userRegistrationRolesEnum_number1 =
    const UserRegistrationRolesEnum._('number1');
const UserRegistrationRolesEnum _$userRegistrationRolesEnum_number2 =
    const UserRegistrationRolesEnum._('number2');
const UserRegistrationRolesEnum _$userRegistrationRolesEnum_number3 =
    const UserRegistrationRolesEnum._('number3');
const UserRegistrationRolesEnum _$userRegistrationRolesEnum_number4 =
    const UserRegistrationRolesEnum._('number4');

UserRegistrationRolesEnum _$userRegistrationRolesEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$userRegistrationRolesEnum_number0;
    case 'number1':
      return _$userRegistrationRolesEnum_number1;
    case 'number2':
      return _$userRegistrationRolesEnum_number2;
    case 'number3':
      return _$userRegistrationRolesEnum_number3;
    case 'number4':
      return _$userRegistrationRolesEnum_number4;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserRegistrationRolesEnum> _$userRegistrationRolesEnumValues =
    BuiltSet<UserRegistrationRolesEnum>(const <UserRegistrationRolesEnum>[
  _$userRegistrationRolesEnum_number0,
  _$userRegistrationRolesEnum_number1,
  _$userRegistrationRolesEnum_number2,
  _$userRegistrationRolesEnum_number3,
  _$userRegistrationRolesEnum_number4,
]);

Serializer<UserRegistrationRolesEnum> _$userRegistrationRolesEnumSerializer =
    _$UserRegistrationRolesEnumSerializer();

class _$UserRegistrationRolesEnumSerializer
    implements PrimitiveSerializer<UserRegistrationRolesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
    'number2': 2,
    'number3': 3,
    'number4': 4,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
    2: 'number2',
    3: 'number3',
    4: 'number4',
  };

  @override
  final Iterable<Type> types = const <Type>[UserRegistrationRolesEnum];
  @override
  final String wireName = 'UserRegistrationRolesEnum';

  @override
  Object serialize(Serializers serializers, UserRegistrationRolesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserRegistrationRolesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserRegistrationRolesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserRegistration extends UserRegistration {
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String salutation;
  @override
  final String? title;
  @override
  final String? telephoneNr;
  @override
  final BuiltList<UserRegistrationRolesEnum> roles;

  factory _$UserRegistration(
          [void Function(UserRegistrationBuilder)? updates]) =>
      (UserRegistrationBuilder()..update(updates))._build();

  _$UserRegistration._(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.salutation,
      this.title,
      this.telephoneNr,
      required this.roles})
      : super._();
  @override
  UserRegistration rebuild(void Function(UserRegistrationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserRegistrationBuilder toBuilder() =>
      UserRegistrationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRegistration &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        salutation == other.salutation &&
        title == other.title &&
        telephoneNr == other.telephoneNr &&
        roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, salutation.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, telephoneNr.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserRegistration')
          ..add('email', email)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('salutation', salutation)
          ..add('title', title)
          ..add('telephoneNr', telephoneNr)
          ..add('roles', roles))
        .toString();
  }
}

class UserRegistrationBuilder
    implements Builder<UserRegistration, UserRegistrationBuilder> {
  _$UserRegistration? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _salutation;
  String? get salutation => _$this._salutation;
  set salutation(String? salutation) => _$this._salutation = salutation;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _telephoneNr;
  String? get telephoneNr => _$this._telephoneNr;
  set telephoneNr(String? telephoneNr) => _$this._telephoneNr = telephoneNr;

  ListBuilder<UserRegistrationRolesEnum>? _roles;
  ListBuilder<UserRegistrationRolesEnum> get roles =>
      _$this._roles ??= ListBuilder<UserRegistrationRolesEnum>();
  set roles(ListBuilder<UserRegistrationRolesEnum>? roles) =>
      _$this._roles = roles;

  UserRegistrationBuilder() {
    UserRegistration._defaults(this);
  }

  UserRegistrationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _salutation = $v.salutation;
      _title = $v.title;
      _telephoneNr = $v.telephoneNr;
      _roles = $v.roles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserRegistration other) {
    _$v = other as _$UserRegistration;
  }

  @override
  void update(void Function(UserRegistrationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserRegistration build() => _build();

  _$UserRegistration _build() {
    _$UserRegistration _$result;
    try {
      _$result = _$v ??
          _$UserRegistration._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'UserRegistration', 'email'),
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'UserRegistration', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'UserRegistration', 'lastName'),
            salutation: BuiltValueNullFieldError.checkNotNull(
                salutation, r'UserRegistration', 'salutation'),
            title: title,
            telephoneNr: telephoneNr,
            roles: roles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        roles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserRegistration', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
