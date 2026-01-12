// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompanyType _$number0 = const CompanyType._('number0');
const CompanyType _$number1 = const CompanyType._('number1');

CompanyType _$valueOf(String name) {
  switch (name) {
    case 'number0':
      return _$number0;
    case 'number1':
      return _$number1;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CompanyType> _$values =
    new BuiltSet<CompanyType>(const <CompanyType>[
  _$number0,
  _$number1,
]);

class _$CompanyTypeMeta {
  const _$CompanyTypeMeta();
  CompanyType get number0 => _$number0;
  CompanyType get number1 => _$number1;
  CompanyType valueOf(String name) => _$valueOf(name);
  BuiltSet<CompanyType> get values => _$values;
}

mixin _$CompanyTypeMixin {
  // ignore: non_constant_identifier_names
  _$CompanyTypeMeta get CompanyType => const _$CompanyTypeMeta();
}

Serializer<CompanyType> _$companyTypeSerializer = new _$CompanyTypeSerializer();

class _$CompanyTypeSerializer implements PrimitiveSerializer<CompanyType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[CompanyType];
  @override
  final String wireName = 'CompanyType';

  @override
  Object serialize(Serializers serializers, CompanyType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompanyType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompanyType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
