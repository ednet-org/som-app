// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_size.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompanySize _$number0 = const CompanySize._('number0');
const CompanySize _$number1 = const CompanySize._('number1');
const CompanySize _$number2 = const CompanySize._('number2');
const CompanySize _$number3 = const CompanySize._('number3');
const CompanySize _$number4 = const CompanySize._('number4');
const CompanySize _$number5 = const CompanySize._('number5');
const CompanySize _$number6 = const CompanySize._('number6');

CompanySize _$valueOf(String name) {
  switch (name) {
    case 'number0':
      return _$number0;
    case 'number1':
      return _$number1;
    case 'number2':
      return _$number2;
    case 'number3':
      return _$number3;
    case 'number4':
      return _$number4;
    case 'number5':
      return _$number5;
    case 'number6':
      return _$number6;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CompanySize> _$values =
    new BuiltSet<CompanySize>(const <CompanySize>[
  _$number0,
  _$number1,
  _$number2,
  _$number3,
  _$number4,
  _$number5,
  _$number6,
]);

class _$CompanySizeMeta {
  const _$CompanySizeMeta();
  CompanySize get number0 => _$number0;
  CompanySize get number1 => _$number1;
  CompanySize get number2 => _$number2;
  CompanySize get number3 => _$number3;
  CompanySize get number4 => _$number4;
  CompanySize get number5 => _$number5;
  CompanySize get number6 => _$number6;
  CompanySize valueOf(String name) => _$valueOf(name);
  BuiltSet<CompanySize> get values => _$values;
}

mixin _$CompanySizeMixin {
  // ignore: non_constant_identifier_names
  _$CompanySizeMeta get CompanySize => const _$CompanySizeMeta();
}

Serializer<CompanySize> _$companySizeSerializer = new _$CompanySizeSerializer();

class _$CompanySizeSerializer implements PrimitiveSerializer<CompanySize> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
    'number2': 2,
    'number3': 3,
    'number4': 4,
    'number5': 5,
    'number6': 6,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
    2: 'number2',
    3: 'number3',
    4: 'number4',
    5: 'number5',
    6: 'number6',
  };

  @override
  final Iterable<Type> types = const <Type>[CompanySize];
  @override
  final String wireName = 'CompanySize';

  @override
  Object serialize(Serializers serializers, CompanySize object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompanySize deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompanySize.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
