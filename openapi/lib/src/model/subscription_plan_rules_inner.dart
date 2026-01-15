//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan_rules_inner.g.dart';

/// SubscriptionPlanRulesInner
///
/// Properties:
/// * [restriction] 
/// * [upperLimit] 
@BuiltValue()
abstract class SubscriptionPlanRulesInner implements Built<SubscriptionPlanRulesInner, SubscriptionPlanRulesInnerBuilder> {
  @BuiltValueField(wireName: r'restriction')
  int? get restriction;

  @BuiltValueField(wireName: r'upperLimit')
  int? get upperLimit;

  SubscriptionPlanRulesInner._();

  factory SubscriptionPlanRulesInner([void updates(SubscriptionPlanRulesInnerBuilder b)]) = _$SubscriptionPlanRulesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionPlanRulesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionPlanRulesInner> get serializer => _$SubscriptionPlanRulesInnerSerializer();
}

class _$SubscriptionPlanRulesInnerSerializer implements PrimitiveSerializer<SubscriptionPlanRulesInner> {
  @override
  final Iterable<Type> types = const [SubscriptionPlanRulesInner, _$SubscriptionPlanRulesInner];

  @override
  final String wireName = r'SubscriptionPlanRulesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionPlanRulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.restriction != null) {
      yield r'restriction';
      yield serializers.serialize(
        object.restriction,
        specifiedType: const FullType(int),
      );
    }
    if (object.upperLimit != null) {
      yield r'upperLimit';
      yield serializers.serialize(
        object.upperLimit,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionPlanRulesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionPlanRulesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.restriction = valueDes;
          break;
        case r'upperLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.upperLimit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionPlanRulesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionPlanRulesInnerBuilder();
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

