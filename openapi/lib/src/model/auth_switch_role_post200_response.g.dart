// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_switch_role_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthSwitchRolePost200Response extends AuthSwitchRolePost200Response {
  @override
  final String? token;

  factory _$AuthSwitchRolePost200Response(
          [void Function(AuthSwitchRolePost200ResponseBuilder)? updates]) =>
      (new AuthSwitchRolePost200ResponseBuilder()..update(updates))._build();

  _$AuthSwitchRolePost200Response._({this.token}) : super._();

  @override
  AuthSwitchRolePost200Response rebuild(
          void Function(AuthSwitchRolePost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthSwitchRolePost200ResponseBuilder toBuilder() =>
      new AuthSwitchRolePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthSwitchRolePost200Response && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthSwitchRolePost200Response')
          ..add('token', token))
        .toString();
  }
}

class AuthSwitchRolePost200ResponseBuilder
    implements
        Builder<AuthSwitchRolePost200Response,
            AuthSwitchRolePost200ResponseBuilder> {
  _$AuthSwitchRolePost200Response? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  AuthSwitchRolePost200ResponseBuilder() {
    AuthSwitchRolePost200Response._defaults(this);
  }

  AuthSwitchRolePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthSwitchRolePost200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthSwitchRolePost200Response;
  }

  @override
  void update(void Function(AuthSwitchRolePost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthSwitchRolePost200Response build() => _build();

  _$AuthSwitchRolePost200Response _build() {
    final _$result = _$v ??
        new _$AuthSwitchRolePost200Response._(
          token: token,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
