//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_type.g.dart';

class CompanyType extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const CompanyType number0 = _$number0;
  @BuiltValueEnumConst(wireNumber: 1)
  static const CompanyType number1 = _$number1;

  static Serializer<CompanyType> get serializer => _$companyTypeSerializer;

  const CompanyType._(String name): super(name);

  static BuiltSet<CompanyType> get values => _$values;
  static CompanyType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CompanyTypeMixin = Object with _$CompanyTypeMixin;

