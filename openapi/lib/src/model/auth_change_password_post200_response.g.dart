// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_change_password_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthChangePasswordPost200Response
    extends AuthChangePasswordPost200Response {
  @override
  final String? status;

  factory _$AuthChangePasswordPost200Response(
          [void Function(AuthChangePasswordPost200ResponseBuilder)? updates]) =>
      (AuthChangePasswordPost200ResponseBuilder()..update(updates))._build();

  _$AuthChangePasswordPost200Response._({this.status}) : super._();
  @override
  AuthChangePasswordPost200Response rebuild(
          void Function(AuthChangePasswordPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthChangePasswordPost200ResponseBuilder toBuilder() =>
      AuthChangePasswordPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthChangePasswordPost200Response && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthChangePasswordPost200Response')
          ..add('status', status))
        .toString();
  }
}

class AuthChangePasswordPost200ResponseBuilder
    implements
        Builder<AuthChangePasswordPost200Response,
            AuthChangePasswordPost200ResponseBuilder> {
  _$AuthChangePasswordPost200Response? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  AuthChangePasswordPost200ResponseBuilder() {
    AuthChangePasswordPost200Response._defaults(this);
  }

  AuthChangePasswordPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthChangePasswordPost200Response other) {
    _$v = other as _$AuthChangePasswordPost200Response;
  }

  @override
  void update(
      void Function(AuthChangePasswordPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthChangePasswordPost200Response build() => _build();

  _$AuthChangePasswordPost200Response _build() {
    final _$result = _$v ??
        _$AuthChangePasswordPost200Response._(
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
