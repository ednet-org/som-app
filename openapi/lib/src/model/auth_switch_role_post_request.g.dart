// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_switch_role_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthSwitchRolePostRequest extends AuthSwitchRolePostRequest {
  @override
  final String role;
  @override
  final String? companyId;

  factory _$AuthSwitchRolePostRequest(
          [void Function(AuthSwitchRolePostRequestBuilder)? updates]) =>
      (AuthSwitchRolePostRequestBuilder()..update(updates))._build();

  _$AuthSwitchRolePostRequest._({required this.role, this.companyId})
      : super._();
  @override
  AuthSwitchRolePostRequest rebuild(
          void Function(AuthSwitchRolePostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthSwitchRolePostRequestBuilder toBuilder() =>
      AuthSwitchRolePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthSwitchRolePostRequest &&
        role == other.role &&
        companyId == other.companyId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthSwitchRolePostRequest')
          ..add('role', role)
          ..add('companyId', companyId))
        .toString();
  }
}

class AuthSwitchRolePostRequestBuilder
    implements
        Builder<AuthSwitchRolePostRequest, AuthSwitchRolePostRequestBuilder> {
  _$AuthSwitchRolePostRequest? _$v;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  AuthSwitchRolePostRequestBuilder() {
    AuthSwitchRolePostRequest._defaults(this);
  }

  AuthSwitchRolePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _companyId = $v.companyId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthSwitchRolePostRequest other) {
    _$v = other as _$AuthSwitchRolePostRequest;
  }

  @override
  void update(void Function(AuthSwitchRolePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthSwitchRolePostRequest build() => _build();

  _$AuthSwitchRolePostRequest _build() {
    final _$result = _$v ??
        _$AuthSwitchRolePostRequest._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AuthSwitchRolePostRequest', 'role'),
          companyId: companyId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
