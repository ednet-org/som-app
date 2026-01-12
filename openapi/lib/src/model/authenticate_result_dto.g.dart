// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticateResultDto extends AuthenticateResultDto {
  @override
  final String? token;
  @override
  final String? refreshToken;

  factory _$AuthenticateResultDto(
          [void Function(AuthenticateResultDtoBuilder)? updates]) =>
      (new AuthenticateResultDtoBuilder()..update(updates))._build();

  _$AuthenticateResultDto._({this.token, this.refreshToken}) : super._();

  @override
  AuthenticateResultDto rebuild(
          void Function(AuthenticateResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticateResultDtoBuilder toBuilder() =>
      new AuthenticateResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticateResultDto &&
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
    return (newBuiltValueToStringHelper(r'AuthenticateResultDto')
          ..add('token', token)
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class AuthenticateResultDtoBuilder
    implements Builder<AuthenticateResultDto, AuthenticateResultDtoBuilder> {
  _$AuthenticateResultDto? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  AuthenticateResultDtoBuilder() {
    AuthenticateResultDto._defaults(this);
  }

  AuthenticateResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticateResultDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticateResultDto;
  }

  @override
  void update(void Function(AuthenticateResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticateResultDto build() => _build();

  _$AuthenticateResultDto _build() {
    final _$result = _$v ??
        new _$AuthenticateResultDto._(
          token: token,
          refreshToken: refreshToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
