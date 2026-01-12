// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Address extends Address {
  @override
  final String country;
  @override
  final String city;
  @override
  final String street;
  @override
  final String number;
  @override
  final String zip;

  factory _$Address([void Function(AddressBuilder)? updates]) =>
      (new AddressBuilder()..update(updates))._build();

  _$Address._(
      {required this.country,
      required this.city,
      required this.street,
      required this.number,
      required this.zip})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(country, r'Address', 'country');
    BuiltValueNullFieldError.checkNotNull(city, r'Address', 'city');
    BuiltValueNullFieldError.checkNotNull(street, r'Address', 'street');
    BuiltValueNullFieldError.checkNotNull(number, r'Address', 'number');
    BuiltValueNullFieldError.checkNotNull(zip, r'Address', 'zip');
  }

  @override
  Address rebuild(void Function(AddressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressBuilder toBuilder() => new AddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Address &&
        country == other.country &&
        city == other.city &&
        street == other.street &&
        number == other.number &&
        zip == other.zip;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, zip.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Address')
          ..add('country', country)
          ..add('city', city)
          ..add('street', street)
          ..add('number', number)
          ..add('zip', zip))
        .toString();
  }
}

class AddressBuilder implements Builder<Address, AddressBuilder> {
  _$Address? _$v;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _zip;
  String? get zip => _$this._zip;
  set zip(String? zip) => _$this._zip = zip;

  AddressBuilder() {
    Address._defaults(this);
  }

  AddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _country = $v.country;
      _city = $v.city;
      _street = $v.street;
      _number = $v.number;
      _zip = $v.zip;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Address other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Address;
  }

  @override
  void update(void Function(AddressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Address build() => _build();

  _$Address _build() {
    final _$result = _$v ??
        new _$Address._(
          country: BuiltValueNullFieldError.checkNotNull(
              country, r'Address', 'country'),
          city: BuiltValueNullFieldError.checkNotNull(city, r'Address', 'city'),
          street: BuiltValueNullFieldError.checkNotNull(
              street, r'Address', 'street'),
          number: BuiltValueNullFieldError.checkNotNull(
              number, r'Address', 'number'),
          zip: BuiltValueNullFieldError.checkNotNull(zip, r'Address', 'zip'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
