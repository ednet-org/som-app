// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_reset_password_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthResetPasswordPostRequest extends AuthResetPasswordPostRequest {
  @override
  final String email;
  @override
  final String token;
  @override
  final String password;
  @override
  final String confirmPassword;

  factory _$AuthResetPasswordPostRequest(
          [void Function(AuthResetPasswordPostRequestBuilder)? updates]) =>
      (AuthResetPasswordPostRequestBuilder()..update(updates))._build();

  _$AuthResetPasswordPostRequest._(
      {required this.email,
      required this.token,
      required this.password,
      required this.confirmPassword})
      : super._();
  @override
  AuthResetPasswordPostRequest rebuild(
          void Function(AuthResetPasswordPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthResetPasswordPostRequestBuilder toBuilder() =>
      AuthResetPasswordPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthResetPasswordPostRequest &&
        email == other.email &&
        token == other.token &&
        password == other.password &&
        confirmPassword == other.confirmPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, confirmPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthResetPasswordPostRequest')
          ..add('email', email)
          ..add('token', token)
          ..add('password', password)
          ..add('confirmPassword', confirmPassword))
        .toString();
  }
}

class AuthResetPasswordPostRequestBuilder
    implements
        Builder<AuthResetPasswordPostRequest,
            AuthResetPasswordPostRequestBuilder> {
  _$AuthResetPasswordPostRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _confirmPassword;
  String? get confirmPassword => _$this._confirmPassword;
  set confirmPassword(String? confirmPassword) =>
      _$this._confirmPassword = confirmPassword;

  AuthResetPasswordPostRequestBuilder() {
    AuthResetPasswordPostRequest._defaults(this);
  }

  AuthResetPasswordPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _token = $v.token;
      _password = $v.password;
      _confirmPassword = $v.confirmPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthResetPasswordPostRequest other) {
    _$v = other as _$AuthResetPasswordPostRequest;
  }

  @override
  void update(void Function(AuthResetPasswordPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthResetPasswordPostRequest build() => _build();

  _$AuthResetPasswordPostRequest _build() {
    final _$result = _$v ??
        _$AuthResetPasswordPostRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AuthResetPasswordPostRequest', 'email'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'AuthResetPasswordPostRequest', 'token'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'AuthResetPasswordPostRequest', 'password'),
          confirmPassword: BuiltValueNullFieldError.checkNotNull(
              confirmPassword,
              r'AuthResetPasswordPostRequest',
              'confirmPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
