// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthLoginPost200Response extends AuthLoginPost200Response {
  @override
  final String? token;
  @override
  final String? refreshToken;

  factory _$AuthLoginPost200Response(
          [void Function(AuthLoginPost200ResponseBuilder)? updates]) =>
      (new AuthLoginPost200ResponseBuilder()..update(updates))._build();

  _$AuthLoginPost200Response._({this.token, this.refreshToken}) : super._();

  @override
  AuthLoginPost200Response rebuild(
          void Function(AuthLoginPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthLoginPost200ResponseBuilder toBuilder() =>
      new AuthLoginPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthLoginPost200Response &&
        token == other.token &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthLoginPost200Response')
          ..add('token', token)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class AuthLoginPost200ResponseBuilder
    implements
        Builder<AuthLoginPost200Response, AuthLoginPost200ResponseBuilder> {
  _$AuthLoginPost200Response? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  AuthLoginPost200ResponseBuilder() {
    AuthLoginPost200Response._defaults(this);
  }

  AuthLoginPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthLoginPost200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthLoginPost200Response;
  }

  @override
  void update(void Function(AuthLoginPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthLoginPost200Response build() => _build();

  _$AuthLoginPost200Response _build() {
    final _$result = _$v ??
        new _$AuthLoginPost200Response._(
          token: token,
          refreshToken: refreshToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
