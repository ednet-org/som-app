// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restriction_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RestrictionType _$number0 = const RestrictionType._('number0');
const RestrictionType _$number1 = const RestrictionType._('number1');
const RestrictionType _$number2 = const RestrictionType._('number2');
const RestrictionType _$number3 = const RestrictionType._('number3');
const RestrictionType _$number4 = const RestrictionType._('number4');
const RestrictionType _$number5 = const RestrictionType._('number5');

RestrictionType _$valueOf(String name) {
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
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RestrictionType> _$values =
    new BuiltSet<RestrictionType>(const <RestrictionType>[
  _$number0,
  _$number1,
  _$number2,
  _$number3,
  _$number4,
  _$number5,
]);

class _$RestrictionTypeMeta {
  const _$RestrictionTypeMeta();
  RestrictionType get number0 => _$number0;
  RestrictionType get number1 => _$number1;
  RestrictionType get number2 => _$number2;
  RestrictionType get number3 => _$number3;
  RestrictionType get number4 => _$number4;
  RestrictionType get number5 => _$number5;
  RestrictionType valueOf(String name) => _$valueOf(name);
  BuiltSet<RestrictionType> get values => _$values;
}

mixin class _$RestrictionTypeMixin {
  // ignore: non_constant_identifier_names
  _$RestrictionTypeMeta get RestrictionType => const _$RestrictionTypeMeta();
}

Serializer<RestrictionType> _$restrictionTypeSerializer =
    new _$RestrictionTypeSerializer();

class _$RestrictionTypeSerializer
    implements PrimitiveSerializer<RestrictionType> {
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
  final Iterable<Type> types = const <Type>[RestrictionType];
  @override
  final String wireName = 'RestrictionType';

  @override
  Object serialize(Serializers serializers, RestrictionType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RestrictionType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RestrictionType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
