//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_company_dto_company_enum.g.dart';

class RegisterCompanyDtoCompanyEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const RegisterCompanyDtoCompanyEnum number0 = _$number0;
  @BuiltValueEnumConst(wireNumber: 1)
  static const RegisterCompanyDtoCompanyEnum number1 = _$number1;
  @BuiltValueEnumConst(wireNumber: 2)
  static const RegisterCompanyDtoCompanyEnum number2 = _$number2;
  @BuiltValueEnumConst(wireNumber: 3)
  static const RegisterCompanyDtoCompanyEnum number3 = _$number3;
  @BuiltValueEnumConst(wireNumber: 4)
  static const RegisterCompanyDtoCompanyEnum number4 = _$number4;
  @BuiltValueEnumConst(wireNumber: 5)
  static const RegisterCompanyDtoCompanyEnum number5 = _$number5;
  @BuiltValueEnumConst(wireNumber: 6)
  static const RegisterCompanyDtoCompanyEnum number6 = _$number6;

  static Serializer<RegisterCompanyDtoCompanyEnum> get serializer => _$registerCompanyDtoCompanyEnumSerializer;

  const RegisterCompanyDtoCompanyEnum._(String name): super(name);

  static BuiltSet<RegisterCompanyDtoCompanyEnum> get values => _$values;
  static RegisterCompanyDtoCompanyEnum valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class RegisterCompanyDtoCompanyEnumMixin = Object with _$RegisterCompanyDtoCompanyEnumMixin;

