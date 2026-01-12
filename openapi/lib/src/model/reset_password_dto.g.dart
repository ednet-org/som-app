// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetPasswordDto extends ResetPasswordDto {
  @override
  final String password;
  @override
  final String? confirmPassword;
  @override
  final String? email;
  @override
  final String? token;

  factory _$ResetPasswordDto(
          [void Function(ResetPasswordDtoBuilder)? updates]) =>
      (new ResetPasswordDtoBuilder()..update(updates))._build();

  _$ResetPasswordDto._(
      {required this.password, this.confirmPassword, this.email, this.token})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        password, r'ResetPasswordDto', 'password');
  }

  @override
  ResetPasswordDto rebuild(void Function(ResetPasswordDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResetPasswordDtoBuilder toBuilder() =>
      new ResetPasswordDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetPasswordDto &&
        password == other.password &&
        confirmPassword == other.confirmPassword &&
        email == other.email &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, confirmPassword.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResetPasswordDto')
          ..add('password', password)
          ..add('confirmPassword', confirmPassword)
          ..add('email', email)
          ..add('token', token))
        .toString();
  }
}

class ResetPasswordDtoBuilder
    implements Builder<ResetPasswordDto, ResetPasswordDtoBuilder> {
  _$ResetPasswordDto? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _confirmPassword;
  String? get confirmPassword => _$this._confirmPassword;
  set confirmPassword(String? confirmPassword) =>
      _$this._confirmPassword = confirmPassword;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  ResetPasswordDtoBuilder() {
    ResetPasswordDto._defaults(this);
  }

  ResetPasswordDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _confirmPassword = $v.confirmPassword;
      _email = $v.email;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetPasswordDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ResetPasswordDto;
  }

  @override
  void update(void Function(ResetPasswordDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetPasswordDto build() => _build();

  _$ResetPasswordDto _build() {
    final _$result = _$v ??
        new _$ResetPasswordDto._(
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'ResetPasswordDto', 'password'),
          confirmPassword: confirmPassword,
          email: email,
          token: token,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
