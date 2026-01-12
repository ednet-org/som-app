// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_forgot_password_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthForgotPasswordPostRequest extends AuthForgotPasswordPostRequest {
  @override
  final String email;

  factory _$AuthForgotPasswordPostRequest(
          [void Function(AuthForgotPasswordPostRequestBuilder)? updates]) =>
      (AuthForgotPasswordPostRequestBuilder()..update(updates))._build();

  _$AuthForgotPasswordPostRequest._({required this.email}) : super._();
  @override
  AuthForgotPasswordPostRequest rebuild(
          void Function(AuthForgotPasswordPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthForgotPasswordPostRequestBuilder toBuilder() =>
      AuthForgotPasswordPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthForgotPasswordPostRequest && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthForgotPasswordPostRequest')
          ..add('email', email))
        .toString();
  }
}

class AuthForgotPasswordPostRequestBuilder
    implements
        Builder<AuthForgotPasswordPostRequest,
            AuthForgotPasswordPostRequestBuilder> {
  _$AuthForgotPasswordPostRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AuthForgotPasswordPostRequestBuilder() {
    AuthForgotPasswordPostRequest._defaults(this);
  }

  AuthForgotPasswordPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthForgotPasswordPostRequest other) {
    _$v = other as _$AuthForgotPasswordPostRequest;
  }

  @override
  void update(void Function(AuthForgotPasswordPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthForgotPasswordPostRequest build() => _build();

  _$AuthForgotPasswordPostRequest _build() {
    final _$result = _$v ??
        _$AuthForgotPasswordPostRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AuthForgotPasswordPostRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
