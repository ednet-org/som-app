// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserDto extends UserDto {
  @override
  final String? email;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? salutation;
  @override
  final BuiltList<Roles>? roles;
  @override
  final String? telephoneNr;
  @override
  final String? title;
  @override
  final String? companyId;
  @override
  final String? id;

  factory _$UserDto([void Function(UserDtoBuilder)? updates]) =>
      (new UserDtoBuilder()..update(updates))._build();

  _$UserDto._(
      {this.email,
      this.firstName,
      this.lastName,
      this.salutation,
      this.roles,
      this.telephoneNr,
      this.title,
      this.companyId,
      this.id})
      : super._();

  @override
  UserDto rebuild(void Function(UserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDtoBuilder toBuilder() => new UserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDto &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        salutation == other.salutation &&
        roles == other.roles &&
        telephoneNr == other.telephoneNr &&
        title == other.title &&
        companyId == other.companyId &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, email.hashCode), firstName.hashCode),
                                lastName.hashCode),
                            salutation.hashCode),
                        roles.hashCode),
                    telephoneNr.hashCode),
                title.hashCode),
            companyId.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserDto')
          ..add('email', email)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('salutation', salutation)
          ..add('roles', roles)
          ..add('telephoneNr', telephoneNr)
          ..add('title', title)
          ..add('companyId', companyId)
          ..add('id', id))
        .toString();
  }
}

class UserDtoBuilder implements Builder<UserDto, UserDtoBuilder> {
  _$UserDto? _$v;

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

  ListBuilder<Roles>? _roles;
  ListBuilder<Roles> get roles => _$this._roles ??= new ListBuilder<Roles>();
  set roles(ListBuilder<Roles>? roles) => _$this._roles = roles;

  String? _telephoneNr;
  String? get telephoneNr => _$this._telephoneNr;
  set telephoneNr(String? telephoneNr) => _$this._telephoneNr = telephoneNr;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserDtoBuilder() {
    UserDto._defaults(this);
  }

  UserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _salutation = $v.salutation;
      _roles = $v.roles?.toBuilder();
      _telephoneNr = $v.telephoneNr;
      _title = $v.title;
      _companyId = $v.companyId;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserDto;
  }

  @override
  void update(void Function(UserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserDto build() => _build();

  _$UserDto _build() {
    _$UserDto _$result;
    try {
      _$result = _$v ??
          new _$UserDto._(
              email: email,
              firstName: firstName,
              lastName: lastName,
              salutation: salutation,
              roles: _roles?.build(),
              telephoneNr: telephoneNr,
              title: title,
              companyId: companyId,
              id: id);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'roles';
        _roles?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
