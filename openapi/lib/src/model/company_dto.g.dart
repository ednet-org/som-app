// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyDto extends CompanyDto {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final Address? address;
  @override
  final String? uidNr;
  @override
  final String? registrationNr;
  @override
  final int? companySize;
  @override
  final int? type;
  @override
  final String? websiteUrl;

  factory _$CompanyDto([void Function(CompanyDtoBuilder)? updates]) =>
      (new CompanyDtoBuilder()..update(updates))._build();

  _$CompanyDto._(
      {this.id,
      this.name,
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
        id == other.id &&
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
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, uidNr.hashCode);
    _$hash = $jc(_$hash, registrationNr.hashCode);
    _$hash = $jc(_$hash, companySize.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, websiteUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyDto')
          ..add('id', id)
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

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AddressBuilder? _address;
  AddressBuilder get address => _$this._address ??= new AddressBuilder();
  set address(AddressBuilder? address) => _$this._address = address;

  String? _uidNr;
  String? get uidNr => _$this._uidNr;
  set uidNr(String? uidNr) => _$this._uidNr = uidNr;

  String? _registrationNr;
  String? get registrationNr => _$this._registrationNr;
  set registrationNr(String? registrationNr) =>
      _$this._registrationNr = registrationNr;

  int? _companySize;
  int? get companySize => _$this._companySize;
  set companySize(int? companySize) => _$this._companySize = companySize;

  int? _type;
  int? get type => _$this._type;
  set type(int? type) => _$this._type = type;

  String? _websiteUrl;
  String? get websiteUrl => _$this._websiteUrl;
  set websiteUrl(String? websiteUrl) => _$this._websiteUrl = websiteUrl;

  CompanyDtoBuilder() {
    CompanyDto._defaults(this);
  }

  CompanyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
            id: id,
            name: name,
            address: _address?.build(),
            uidNr: uidNr,
            registrationNr: registrationNr,
            companySize: companySize,
            type: type,
            websiteUrl: websiteUrl,
          );
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

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
