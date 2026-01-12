// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_company_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterCompanyRequest extends RegisterCompanyRequest {
  @override
  final CompanyRegistration company;
  @override
  final BuiltList<UserRegistration> users;

  factory _$RegisterCompanyRequest(
          [void Function(RegisterCompanyRequestBuilder)? updates]) =>
      (new RegisterCompanyRequestBuilder()..update(updates))._build();

  _$RegisterCompanyRequest._({required this.company, required this.users})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        company, r'RegisterCompanyRequest', 'company');
    BuiltValueNullFieldError.checkNotNull(
        users, r'RegisterCompanyRequest', 'users');
  }

  @override
  RegisterCompanyRequest rebuild(
          void Function(RegisterCompanyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterCompanyRequestBuilder toBuilder() =>
      new RegisterCompanyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterCompanyRequest &&
        company == other.company &&
        users == other.users;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, company.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterCompanyRequest')
          ..add('company', company)
          ..add('users', users))
        .toString();
  }
}

class RegisterCompanyRequestBuilder
    implements Builder<RegisterCompanyRequest, RegisterCompanyRequestBuilder> {
  _$RegisterCompanyRequest? _$v;

  CompanyRegistrationBuilder? _company;
  CompanyRegistrationBuilder get company =>
      _$this._company ??= new CompanyRegistrationBuilder();
  set company(CompanyRegistrationBuilder? company) => _$this._company = company;

  ListBuilder<UserRegistration>? _users;
  ListBuilder<UserRegistration> get users =>
      _$this._users ??= new ListBuilder<UserRegistration>();
  set users(ListBuilder<UserRegistration>? users) => _$this._users = users;

  RegisterCompanyRequestBuilder() {
    RegisterCompanyRequest._defaults(this);
  }

  RegisterCompanyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _company = $v.company.toBuilder();
      _users = $v.users.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterCompanyRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RegisterCompanyRequest;
  }

  @override
  void update(void Function(RegisterCompanyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterCompanyRequest build() => _build();

  _$RegisterCompanyRequest _build() {
    _$RegisterCompanyRequest _$result;
    try {
      _$result = _$v ??
          new _$RegisterCompanyRequest._(
            company: company.build(),
            users: users.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'company';
        company.build();
        _$failedField = 'users';
        users.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RegisterCompanyRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
