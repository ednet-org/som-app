// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultants_register_company_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConsultantsRegisterCompanyPostRequest
    extends ConsultantsRegisterCompanyPostRequest {
  @override
  final CompanyRegistration company;
  @override
  final BuiltList<UserRegistration> users;

  factory _$ConsultantsRegisterCompanyPostRequest(
          [void Function(ConsultantsRegisterCompanyPostRequestBuilder)?
              updates]) =>
      (ConsultantsRegisterCompanyPostRequestBuilder()..update(updates))
          ._build();

  _$ConsultantsRegisterCompanyPostRequest._(
      {required this.company, required this.users})
      : super._();
  @override
  ConsultantsRegisterCompanyPostRequest rebuild(
          void Function(ConsultantsRegisterCompanyPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConsultantsRegisterCompanyPostRequestBuilder toBuilder() =>
      ConsultantsRegisterCompanyPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsultantsRegisterCompanyPostRequest &&
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
    return (newBuiltValueToStringHelper(
            r'ConsultantsRegisterCompanyPostRequest')
          ..add('company', company)
          ..add('users', users))
        .toString();
  }
}

class ConsultantsRegisterCompanyPostRequestBuilder
    implements
        Builder<ConsultantsRegisterCompanyPostRequest,
            ConsultantsRegisterCompanyPostRequestBuilder> {
  _$ConsultantsRegisterCompanyPostRequest? _$v;

  CompanyRegistrationBuilder? _company;
  CompanyRegistrationBuilder get company =>
      _$this._company ??= CompanyRegistrationBuilder();
  set company(CompanyRegistrationBuilder? company) => _$this._company = company;

  ListBuilder<UserRegistration>? _users;
  ListBuilder<UserRegistration> get users =>
      _$this._users ??= ListBuilder<UserRegistration>();
  set users(ListBuilder<UserRegistration>? users) => _$this._users = users;

  ConsultantsRegisterCompanyPostRequestBuilder() {
    ConsultantsRegisterCompanyPostRequest._defaults(this);
  }

  ConsultantsRegisterCompanyPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _company = $v.company.toBuilder();
      _users = $v.users.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConsultantsRegisterCompanyPostRequest other) {
    _$v = other as _$ConsultantsRegisterCompanyPostRequest;
  }

  @override
  void update(
      void Function(ConsultantsRegisterCompanyPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConsultantsRegisterCompanyPostRequest build() => _build();

  _$ConsultantsRegisterCompanyPostRequest _build() {
    _$ConsultantsRegisterCompanyPostRequest _$result;
    try {
      _$result = _$v ??
          _$ConsultantsRegisterCompanyPostRequest._(
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
        throw BuiltValueNestedFieldError(
            r'ConsultantsRegisterCompanyPostRequest',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
