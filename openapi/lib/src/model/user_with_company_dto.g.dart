// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_company_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserWithCompanyDto extends UserWithCompanyDto {
  @override
  final String? userId;
  @override
  final String? salutation;
  @override
  final String? title;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? telephoneNr;
  @override
  final String? emailAddress;
  @override
  final String? companyId;
  @override
  final String? companyName;
  @override
  final AddressDto? companyAddress;

  factory _$UserWithCompanyDto(
          [void Function(UserWithCompanyDtoBuilder)? updates]) =>
      (new UserWithCompanyDtoBuilder()..update(updates))._build();

  _$UserWithCompanyDto._(
      {this.userId,
      this.salutation,
      this.title,
      this.firstName,
      this.lastName,
      this.telephoneNr,
      this.emailAddress,
      this.companyId,
      this.companyName,
      this.companyAddress})
      : super._();

  @override
  UserWithCompanyDto rebuild(
          void Function(UserWithCompanyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserWithCompanyDtoBuilder toBuilder() =>
      new UserWithCompanyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserWithCompanyDto &&
        userId == other.userId &&
        salutation == other.salutation &&
        title == other.title &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        telephoneNr == other.telephoneNr &&
        emailAddress == other.emailAddress &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        companyAddress == other.companyAddress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, salutation.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, telephoneNr.hashCode);
    _$hash = $jc(_$hash, emailAddress.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companyAddress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserWithCompanyDto')
          ..add('userId', userId)
          ..add('salutation', salutation)
          ..add('title', title)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('telephoneNr', telephoneNr)
          ..add('emailAddress', emailAddress)
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('companyAddress', companyAddress))
        .toString();
  }
}

class UserWithCompanyDtoBuilder
    implements Builder<UserWithCompanyDto, UserWithCompanyDtoBuilder> {
  _$UserWithCompanyDto? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _salutation;
  String? get salutation => _$this._salutation;
  set salutation(String? salutation) => _$this._salutation = salutation;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _telephoneNr;
  String? get telephoneNr => _$this._telephoneNr;
  set telephoneNr(String? telephoneNr) => _$this._telephoneNr = telephoneNr;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  AddressDtoBuilder? _companyAddress;
  AddressDtoBuilder get companyAddress =>
      _$this._companyAddress ??= new AddressDtoBuilder();
  set companyAddress(AddressDtoBuilder? companyAddress) =>
      _$this._companyAddress = companyAddress;

  UserWithCompanyDtoBuilder() {
    UserWithCompanyDto._defaults(this);
  }

  UserWithCompanyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _salutation = $v.salutation;
      _title = $v.title;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _telephoneNr = $v.telephoneNr;
      _emailAddress = $v.emailAddress;
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _companyAddress = $v.companyAddress?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserWithCompanyDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserWithCompanyDto;
  }

  @override
  void update(void Function(UserWithCompanyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserWithCompanyDto build() => _build();

  _$UserWithCompanyDto _build() {
    _$UserWithCompanyDto _$result;
    try {
      _$result = _$v ??
          new _$UserWithCompanyDto._(
            userId: userId,
            salutation: salutation,
            title: title,
            firstName: firstName,
            lastName: lastName,
            telephoneNr: telephoneNr,
            emailAddress: emailAddress,
            companyId: companyId,
            companyName: companyName,
            companyAddress: _companyAddress?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'companyAddress';
        _companyAddress?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserWithCompanyDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
