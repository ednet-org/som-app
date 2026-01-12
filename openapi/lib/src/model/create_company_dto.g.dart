// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_company_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCompanyDto extends CreateCompanyDto {
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
  @override
  final CreateProviderDto? providerData;

  factory _$CreateCompanyDto(
          [void Function(CreateCompanyDtoBuilder)? updates]) =>
      (new CreateCompanyDtoBuilder()..update(updates))._build();

  _$CreateCompanyDto._(
      {this.name,
      this.address,
      this.uidNr,
      this.registrationNr,
      this.companySize,
      this.type,
      this.websiteUrl,
      this.providerData})
      : super._();

  @override
  CreateCompanyDto rebuild(void Function(CreateCompanyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCompanyDtoBuilder toBuilder() =>
      new CreateCompanyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCompanyDto &&
        name == other.name &&
        address == other.address &&
        uidNr == other.uidNr &&
        registrationNr == other.registrationNr &&
        companySize == other.companySize &&
        type == other.type &&
        websiteUrl == other.websiteUrl &&
        providerData == other.providerData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, uidNr.hashCode);
    _$hash = $jc(_$hash, registrationNr.hashCode);
    _$hash = $jc(_$hash, companySize.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, websiteUrl.hashCode);
    _$hash = $jc(_$hash, providerData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCompanyDto')
          ..add('name', name)
          ..add('address', address)
          ..add('uidNr', uidNr)
          ..add('registrationNr', registrationNr)
          ..add('companySize', companySize)
          ..add('type', type)
          ..add('websiteUrl', websiteUrl)
          ..add('providerData', providerData))
        .toString();
  }
}

class CreateCompanyDtoBuilder
    implements Builder<CreateCompanyDto, CreateCompanyDtoBuilder> {
  _$CreateCompanyDto? _$v;

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

  CreateProviderDtoBuilder? _providerData;
  CreateProviderDtoBuilder get providerData =>
      _$this._providerData ??= new CreateProviderDtoBuilder();
  set providerData(CreateProviderDtoBuilder? providerData) =>
      _$this._providerData = providerData;

  CreateCompanyDtoBuilder() {
    CreateCompanyDto._defaults(this);
  }

  CreateCompanyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address?.toBuilder();
      _uidNr = $v.uidNr;
      _registrationNr = $v.registrationNr;
      _companySize = $v.companySize;
      _type = $v.type;
      _websiteUrl = $v.websiteUrl;
      _providerData = $v.providerData?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCompanyDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateCompanyDto;
  }

  @override
  void update(void Function(CreateCompanyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCompanyDto build() => _build();

  _$CreateCompanyDto _build() {
    _$CreateCompanyDto _$result;
    try {
      _$result = _$v ??
          new _$CreateCompanyDto._(
            name: name,
            address: _address?.build(),
            uidNr: uidNr,
            registrationNr: registrationNr,
            companySize: companySize,
            type: type,
            websiteUrl: websiteUrl,
            providerData: _providerData?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        _address?.build();

        _$failedField = 'providerData';
        _providerData?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateCompanyDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
