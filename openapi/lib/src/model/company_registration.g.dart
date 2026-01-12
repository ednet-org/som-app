// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_registration.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number0 =
    const CompanyRegistrationCompanySizeEnum._('number0');
const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number1 =
    const CompanyRegistrationCompanySizeEnum._('number1');
const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number2 =
    const CompanyRegistrationCompanySizeEnum._('number2');
const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number3 =
    const CompanyRegistrationCompanySizeEnum._('number3');
const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number4 =
    const CompanyRegistrationCompanySizeEnum._('number4');
const CompanyRegistrationCompanySizeEnum
    _$companyRegistrationCompanySizeEnum_number5 =
    const CompanyRegistrationCompanySizeEnum._('number5');

CompanyRegistrationCompanySizeEnum _$companyRegistrationCompanySizeEnumValueOf(
    String name) {
  switch (name) {
    case 'number0':
      return _$companyRegistrationCompanySizeEnum_number0;
    case 'number1':
      return _$companyRegistrationCompanySizeEnum_number1;
    case 'number2':
      return _$companyRegistrationCompanySizeEnum_number2;
    case 'number3':
      return _$companyRegistrationCompanySizeEnum_number3;
    case 'number4':
      return _$companyRegistrationCompanySizeEnum_number4;
    case 'number5':
      return _$companyRegistrationCompanySizeEnum_number5;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CompanyRegistrationCompanySizeEnum>
    _$companyRegistrationCompanySizeEnumValues = new BuiltSet<
        CompanyRegistrationCompanySizeEnum>(const <CompanyRegistrationCompanySizeEnum>[
  _$companyRegistrationCompanySizeEnum_number0,
  _$companyRegistrationCompanySizeEnum_number1,
  _$companyRegistrationCompanySizeEnum_number2,
  _$companyRegistrationCompanySizeEnum_number3,
  _$companyRegistrationCompanySizeEnum_number4,
  _$companyRegistrationCompanySizeEnum_number5,
]);

const CompanyRegistrationTypeEnum _$companyRegistrationTypeEnum_number0 =
    const CompanyRegistrationTypeEnum._('number0');
const CompanyRegistrationTypeEnum _$companyRegistrationTypeEnum_number1 =
    const CompanyRegistrationTypeEnum._('number1');

CompanyRegistrationTypeEnum _$companyRegistrationTypeEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$companyRegistrationTypeEnum_number0;
    case 'number1':
      return _$companyRegistrationTypeEnum_number1;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CompanyRegistrationTypeEnum>
    _$companyRegistrationTypeEnumValues = new BuiltSet<
        CompanyRegistrationTypeEnum>(const <CompanyRegistrationTypeEnum>[
  _$companyRegistrationTypeEnum_number0,
  _$companyRegistrationTypeEnum_number1,
]);

Serializer<CompanyRegistrationCompanySizeEnum>
    _$companyRegistrationCompanySizeEnumSerializer =
    new _$CompanyRegistrationCompanySizeEnumSerializer();
Serializer<CompanyRegistrationTypeEnum>
    _$companyRegistrationTypeEnumSerializer =
    new _$CompanyRegistrationTypeEnumSerializer();

class _$CompanyRegistrationCompanySizeEnumSerializer
    implements PrimitiveSerializer<CompanyRegistrationCompanySizeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
    'number2': 2,
    'number3': 3,
    'number4': 4,
    'number5': 5,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
    2: 'number2',
    3: 'number3',
    4: 'number4',
    5: 'number5',
  };

  @override
  final Iterable<Type> types = const <Type>[CompanyRegistrationCompanySizeEnum];
  @override
  final String wireName = 'CompanyRegistrationCompanySizeEnum';

  @override
  Object serialize(
          Serializers serializers, CompanyRegistrationCompanySizeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompanyRegistrationCompanySizeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompanyRegistrationCompanySizeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CompanyRegistrationTypeEnumSerializer
    implements PrimitiveSerializer<CompanyRegistrationTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[CompanyRegistrationTypeEnum];
  @override
  final String wireName = 'CompanyRegistrationTypeEnum';

  @override
  Object serialize(Serializers serializers, CompanyRegistrationTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompanyRegistrationTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompanyRegistrationTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CompanyRegistration extends CompanyRegistration {
  @override
  final String name;
  @override
  final Address address;
  @override
  final String uidNr;
  @override
  final String registrationNr;
  @override
  final CompanyRegistrationCompanySizeEnum companySize;
  @override
  final CompanyRegistrationTypeEnum type;
  @override
  final String? websiteUrl;
  @override
  final ProviderRegistrationData? providerData;

  factory _$CompanyRegistration(
          [void Function(CompanyRegistrationBuilder)? updates]) =>
      (new CompanyRegistrationBuilder()..update(updates))._build();

  _$CompanyRegistration._(
      {required this.name,
      required this.address,
      required this.uidNr,
      required this.registrationNr,
      required this.companySize,
      required this.type,
      this.websiteUrl,
      this.providerData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'CompanyRegistration', 'name');
    BuiltValueNullFieldError.checkNotNull(
        address, r'CompanyRegistration', 'address');
    BuiltValueNullFieldError.checkNotNull(
        uidNr, r'CompanyRegistration', 'uidNr');
    BuiltValueNullFieldError.checkNotNull(
        registrationNr, r'CompanyRegistration', 'registrationNr');
    BuiltValueNullFieldError.checkNotNull(
        companySize, r'CompanyRegistration', 'companySize');
    BuiltValueNullFieldError.checkNotNull(type, r'CompanyRegistration', 'type');
  }

  @override
  CompanyRegistration rebuild(
          void Function(CompanyRegistrationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyRegistrationBuilder toBuilder() =>
      new CompanyRegistrationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyRegistration &&
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
    return (newBuiltValueToStringHelper(r'CompanyRegistration')
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

class CompanyRegistrationBuilder
    implements Builder<CompanyRegistration, CompanyRegistrationBuilder> {
  _$CompanyRegistration? _$v;

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

  CompanyRegistrationCompanySizeEnum? _companySize;
  CompanyRegistrationCompanySizeEnum? get companySize => _$this._companySize;
  set companySize(CompanyRegistrationCompanySizeEnum? companySize) =>
      _$this._companySize = companySize;

  CompanyRegistrationTypeEnum? _type;
  CompanyRegistrationTypeEnum? get type => _$this._type;
  set type(CompanyRegistrationTypeEnum? type) => _$this._type = type;

  String? _websiteUrl;
  String? get websiteUrl => _$this._websiteUrl;
  set websiteUrl(String? websiteUrl) => _$this._websiteUrl = websiteUrl;

  ProviderRegistrationDataBuilder? _providerData;
  ProviderRegistrationDataBuilder get providerData =>
      _$this._providerData ??= new ProviderRegistrationDataBuilder();
  set providerData(ProviderRegistrationDataBuilder? providerData) =>
      _$this._providerData = providerData;

  CompanyRegistrationBuilder() {
    CompanyRegistration._defaults(this);
  }

  CompanyRegistrationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address.toBuilder();
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
  void replace(CompanyRegistration other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CompanyRegistration;
  }

  @override
  void update(void Function(CompanyRegistrationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyRegistration build() => _build();

  _$CompanyRegistration _build() {
    _$CompanyRegistration _$result;
    try {
      _$result = _$v ??
          new _$CompanyRegistration._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CompanyRegistration', 'name'),
            address: address.build(),
            uidNr: BuiltValueNullFieldError.checkNotNull(
                uidNr, r'CompanyRegistration', 'uidNr'),
            registrationNr: BuiltValueNullFieldError.checkNotNull(
                registrationNr, r'CompanyRegistration', 'registrationNr'),
            companySize: BuiltValueNullFieldError.checkNotNull(
                companySize, r'CompanyRegistration', 'companySize'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CompanyRegistration', 'type'),
            websiteUrl: websiteUrl,
            providerData: _providerData?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        address.build();

        _$failedField = 'providerData';
        _providerData?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CompanyRegistration', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
