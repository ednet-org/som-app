// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Roles _$number0 = const Roles._('number0');
const Roles _$number1 = const Roles._('number1');
const Roles _$number2 = const Roles._('number2');
const Roles _$number3 = const Roles._('number3');
const Roles _$number4 = const Roles._('number4');

Roles _$valueOf(String name) {
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
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Roles> _$values = new BuiltSet<Roles>(const <Roles>[
  _$number0,
  _$number1,
  _$number2,
  _$number3,
  _$number4,
]);

class _$RolesMeta {
  const _$RolesMeta();
  Roles get number0 => _$number0;
  Roles get number1 => _$number1;
  Roles get number2 => _$number2;
  Roles get number3 => _$number3;
  Roles get number4 => _$number4;
  Roles valueOf(String name) => _$valueOf(name);
  BuiltSet<Roles> get values => _$values;
}

mixin class _$RolesMixin {
  // ignore: non_constant_identifier_names
  _$RolesMeta get Roles => const _$RolesMeta();
}

Serializer<Roles> _$rolesSerializer = new _$RolesSerializer();

class _$RolesSerializer implements PrimitiveSerializer<Roles> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
    'number2': 2,
    'number3': 3,
    'number4': 4,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
    2: 'number2',
    3: 'number3',
    4: 'number4',
  };

  @override
  final Iterable<Type> types = const <Type>[Roles];
  @override
  final String wireName = 'Roles';

  @override
  Object serialize(Serializers serializers, Roles object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Roles deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Roles.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
