// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AddressDto extends AddressDto {
  @override
  final String? country;
  @override
  final String? city;
  @override
  final String? street;
  @override
  final String? number;
  @override
  final String? zip;

  factory _$AddressDto([void Function(AddressDtoBuilder)? updates]) =>
      (new AddressDtoBuilder()..update(updates))._build();

  _$AddressDto._({this.country, this.city, this.street, this.number, this.zip})
      : super._();

  @override
  AddressDto rebuild(void Function(AddressDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressDtoBuilder toBuilder() => new AddressDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddressDto &&
        country == other.country &&
        city == other.city &&
        street == other.street &&
        number == other.number &&
        zip == other.zip;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, country.hashCode), city.hashCode), street.hashCode),
            number.hashCode),
        zip.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddressDto')
          ..add('country', country)
          ..add('city', city)
          ..add('street', street)
          ..add('number', number)
          ..add('zip', zip))
        .toString();
  }
}

class AddressDtoBuilder implements Builder<AddressDto, AddressDtoBuilder> {
  _$AddressDto? _$v;

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

  AddressDtoBuilder() {
    AddressDto._defaults(this);
  }

  AddressDtoBuilder get _$this {
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
  void replace(AddressDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AddressDto;
  }

  @override
  void update(void Function(AddressDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddressDto build() => _build();

  _$AddressDto _build() {
    final _$result = _$v ??
        new _$AddressDto._(
            country: country,
            city: city,
            street: street,
            number: number,
            zip: zip);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
