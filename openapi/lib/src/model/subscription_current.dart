//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/subscription_plan.dart';
import 'package:openapi/src/model/subscription_current_subscription.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_current.g.dart';

/// SubscriptionCurrent
///
/// Properties:
/// * [subscription] 
/// * [plan] 
@BuiltValue()
abstract class SubscriptionCurrent implements Built<SubscriptionCurrent, SubscriptionCurrentBuilder> {
  @BuiltValueField(wireName: r'subscription')
  SubscriptionCurrentSubscription? get subscription;

  @BuiltValueField(wireName: r'plan')
  SubscriptionPlan? get plan;

  SubscriptionCurrent._();

  factory SubscriptionCurrent([void updates(SubscriptionCurrentBuilder b)]) = _$SubscriptionCurrent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionCurrentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionCurrent> get serializer => _$SubscriptionCurrentSerializer();
}

class _$SubscriptionCurrentSerializer implements PrimitiveSerializer<SubscriptionCurrent> {
  @override
  final Iterable<Type> types = const [SubscriptionCurrent, _$SubscriptionCurrent];

  @override
  final String wireName = r'SubscriptionCurrent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionCurrent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.subscription != null) {
      yield r'subscription';
      yield serializers.serialize(
        object.subscription,
        specifiedType: const FullType(SubscriptionCurrentSubscription),
      );
    }
    if (object.plan != null) {
      yield r'plan';
      yield serializers.serialize(
        object.plan,
        specifiedType: const FullType(SubscriptionPlan),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionCurrent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionCurrentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subscription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubscriptionCurrentSubscription),
          ) as SubscriptionCurrentSubscription;
          result.subscription.replace(valueDes);
          break;
        case r'plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubscriptionPlan),
          ) as SubscriptionPlan;
          result.plan.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionCurrent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionCurrentBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

