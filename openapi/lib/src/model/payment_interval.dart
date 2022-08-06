//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_interval.g.dart';

class PaymentInterval extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const PaymentInterval number0 = _$number0;
  @BuiltValueEnumConst(wireNumber: 1)
  static const PaymentInterval number1 = _$number1;

  static Serializer<PaymentInterval> get serializer => _$paymentIntervalSerializer;

  const PaymentInterval._(String name): super(name);

  static BuiltSet<PaymentInterval> get values => _$values;
  static PaymentInterval valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PaymentIntervalMixin = Object with _$PaymentIntervalMixin;

