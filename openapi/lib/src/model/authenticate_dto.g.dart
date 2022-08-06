// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticateDto extends AuthenticateDto {
  @override
  final String? email;
  @override
  final String? password;

  factory _$AuthenticateDto([void Function(AuthenticateDtoBuilder)? updates]) =>
      (new AuthenticateDtoBuilder()..update(updates))._build();

  _$AuthenticateDto._({this.email, this.password}) : super._();

  @override
  AuthenticateDto rebuild(void Function(AuthenticateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticateDtoBuilder toBuilder() =>
      new AuthenticateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticateDto &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, email.hashCode), password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthenticateDto')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class AuthenticateDtoBuilder
    implements Builder<AuthenticateDto, AuthenticateDtoBuilder> {
  _$AuthenticateDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  AuthenticateDtoBuilder() {
    AuthenticateDto._defaults(this);
  }

  AuthenticateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticateDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticateDto;
  }

  @override
  void update(void Function(AuthenticateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticateDto build() => _build();

  _$AuthenticateDto _build() {
    final _$result =
        _$v ?? new _$AuthenticateDto._(email: email, password: password);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
