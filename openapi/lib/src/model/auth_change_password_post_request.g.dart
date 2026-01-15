// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_change_password_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthChangePasswordPostRequest extends AuthChangePasswordPostRequest {
  @override
  final String currentPassword;
  @override
  final String newPassword;
  @override
  final String confirmPassword;

  factory _$AuthChangePasswordPostRequest(
          [void Function(AuthChangePasswordPostRequestBuilder)? updates]) =>
      (AuthChangePasswordPostRequestBuilder()..update(updates))._build();

  _$AuthChangePasswordPostRequest._(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword})
      : super._();
  @override
  AuthChangePasswordPostRequest rebuild(
          void Function(AuthChangePasswordPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthChangePasswordPostRequestBuilder toBuilder() =>
      AuthChangePasswordPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthChangePasswordPostRequest &&
        currentPassword == other.currentPassword &&
        newPassword == other.newPassword &&
        confirmPassword == other.confirmPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPassword.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jc(_$hash, confirmPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthChangePasswordPostRequest')
          ..add('currentPassword', currentPassword)
          ..add('newPassword', newPassword)
          ..add('confirmPassword', confirmPassword))
        .toString();
  }
}

class AuthChangePasswordPostRequestBuilder
    implements
        Builder<AuthChangePasswordPostRequest,
            AuthChangePasswordPostRequestBuilder> {
  _$AuthChangePasswordPostRequest? _$v;

  String? _currentPassword;
  String? get currentPassword => _$this._currentPassword;
  set currentPassword(String? currentPassword) =>
      _$this._currentPassword = currentPassword;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  String? _confirmPassword;
  String? get confirmPassword => _$this._confirmPassword;
  set confirmPassword(String? confirmPassword) =>
      _$this._confirmPassword = confirmPassword;

  AuthChangePasswordPostRequestBuilder() {
    AuthChangePasswordPostRequest._defaults(this);
  }

  AuthChangePasswordPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPassword = $v.currentPassword;
      _newPassword = $v.newPassword;
      _confirmPassword = $v.confirmPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthChangePasswordPostRequest other) {
    _$v = other as _$AuthChangePasswordPostRequest;
  }

  @override
  void update(void Function(AuthChangePasswordPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthChangePasswordPostRequest build() => _build();

  _$AuthChangePasswordPostRequest _build() {
    final _$result = _$v ??
        _$AuthChangePasswordPostRequest._(
          currentPassword: BuiltValueNullFieldError.checkNotNull(
              currentPassword,
              r'AuthChangePasswordPostRequest',
              'currentPassword'),
          newPassword: BuiltValueNullFieldError.checkNotNull(
              newPassword, r'AuthChangePasswordPostRequest', 'newPassword'),
          confirmPassword: BuiltValueNullFieldError.checkNotNull(
              confirmPassword,
              r'AuthChangePasswordPostRequest',
              'confirmPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
