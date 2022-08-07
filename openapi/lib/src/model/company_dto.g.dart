// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyDto extends CompanyDto {
  @override
  final String? name;
  @override
  final AddressDto? address;
  @override
  final String? uidNr;
  @override
  final String? registrationNr;
  @override
  final CompanySize? companySize;
  @override
  final CompanyType? type;
  @override
  final String? websiteUrl;

  factory _$CompanyDto([void Function(CompanyDtoBuilder)? updates]) =>
      (new CompanyDtoBuilder()..update(updates))._build();

  _$CompanyDto._(
      {this.name,
      this.address,
      this.uidNr,
      this.registrationNr,
      this.companySize,
      this.type,
      this.websiteUrl})
      : super._();

  @override
  CompanyDto rebuild(void Function(CompanyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyDtoBuilder toBuilder() => new CompanyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyDto &&
        name == other.name &&
        address == other.address &&
        uidNr == other.uidNr &&
        registrationNr == other.registrationNr &&
        companySize == other.companySize &&
        type == other.type &&
        websiteUrl == other.websiteUrl;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, name.hashCode), address.hashCode),
                        uidNr.hashCode),
                    registrationNr.hashCode),
                companySize.hashCode),
            type.hashCode),
        websiteUrl.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyDto')
          ..add('name', name)
          ..add('address', address)
          ..add('uidNr', uidNr)
          ..add('registrationNr', registrationNr)
          ..add('companySize', companySize)
          ..add('type', type)
          ..add('websiteUrl', websiteUrl))
        .toString();
  }
}

class CompanyDtoBuilder implements Builder<CompanyDto, CompanyDtoBuilder> {
  _$CompanyDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AddressDtoBuilder? _address;
  AddressDtoBuilder get address => _$this._address ??= new AddressDtoBuilder();
  set address(AddressDtoBuilder? address) => _$this._address = address;

  String? _uidNr;
  String? get uidNr => _$this._uidNr;
  set uidNr(String? uidNr) => _$this._uidNr = uidNr;

  String? _registrationNr;
  String? get registrationNr => _$this._registrationNr;
  set registrationNr(String? registrationNr) =>
      _$this._registrationNr = registrationNr;

  CompanySize? _companySize;
  CompanySize? get companySize => _$this._companySize;
  set companySize(CompanySize? companySize) =>
      _$this._companySize = companySize;

  CompanyType? _type;
  CompanyType? get type => _$this._type;
  set type(CompanyType? type) => _$this._type = type;

  String? _websiteUrl;
  String? get websiteUrl => _$this._websiteUrl;
  set websiteUrl(String? websiteUrl) => _$this._websiteUrl = websiteUrl;

  CompanyDtoBuilder() {
    CompanyDto._defaults(this);
  }

  CompanyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address?.toBuilder();
      _uidNr = $v.uidNr;
      _registrationNr = $v.registrationNr;
      _companySize = $v.companySize;
      _type = $v.type;
      _websiteUrl = $v.websiteUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyDto;
  }

  @override
  void update(void Function(CompanyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyDto build() => _build();

  _$CompanyDto _build() {
    _$CompanyDto _$result;
    try {
      _$result = _$v ??
          new _$CompanyDto._(
              name: name,
              address: _address?.build(),
              uidNr: uidNr,
              registrationNr: registrationNr,
              companySize: companySize,
              type: type,
              websiteUrl: websiteUrl);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        _address?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompanyDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
