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
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
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
    final _$result = _$v ??
        new _$AuthenticateDto._(
          email: email,
          password: password,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
