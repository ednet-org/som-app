// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_company_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterCompanyDto extends RegisterCompanyDto {
  @override
  final CreateCompanyDto? company;
  @override
  final BuiltList<UserDto>? users;

  factory _$RegisterCompanyDto(
          [void Function(RegisterCompanyDtoBuilder)? updates]) =>
      (new RegisterCompanyDtoBuilder()..update(updates))._build();

  _$RegisterCompanyDto._({this.company, this.users}) : super._();

  @override
  RegisterCompanyDto rebuild(
          void Function(RegisterCompanyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterCompanyDtoBuilder toBuilder() =>
      new RegisterCompanyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterCompanyDto &&
        company == other.company &&
        users == other.users;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, company.hashCode), users.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterCompanyDto')
          ..add('company', company)
          ..add('users', users))
        .toString();
  }
}

class RegisterCompanyDtoBuilder
    implements Builder<RegisterCompanyDto, RegisterCompanyDtoBuilder> {
  _$RegisterCompanyDto? _$v;

  CreateCompanyDtoBuilder? _company;
  CreateCompanyDtoBuilder get company =>
      _$this._company ??= new CreateCompanyDtoBuilder();
  set company(CreateCompanyDtoBuilder? company) => _$this._company = company;

  ListBuilder<UserDto>? _users;
  ListBuilder<UserDto> get users =>
      _$this._users ??= new ListBuilder<UserDto>();
  set users(ListBuilder<UserDto>? users) => _$this._users = users;

  RegisterCompanyDtoBuilder() {
    RegisterCompanyDto._defaults(this);
  }

  RegisterCompanyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _company = $v.company?.toBuilder();
      _users = $v.users?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterCompanyDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RegisterCompanyDto;
  }

  @override
  void update(void Function(RegisterCompanyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterCompanyDto build() => _build();

  _$RegisterCompanyDto _build() {
    _$RegisterCompanyDto _$result;
    try {
      _$result = _$v ??
          new _$RegisterCompanyDto._(
              company: _company?.build(), users: _users?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'company';
        _company?.build();
        _$failedField = 'users';
        _users?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RegisterCompanyDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
