//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan_rules_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan.g.dart';

/// SubscriptionPlan
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [sortPriority] 
/// * [isActive] 
/// * [priceInSubunit] 
/// * [rules] 
/// * [createdAt] 
@BuiltValue()
abstract class SubscriptionPlan implements Built<SubscriptionPlan, SubscriptionPlanBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'sortPriority')
  int? get sortPriority;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  @BuiltValueField(wireName: r'priceInSubunit')
  int? get priceInSubunit;

  @BuiltValueField(wireName: r'rules')
  BuiltList<SubscriptionPlanRulesInner>? get rules;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  SubscriptionPlan._();

  factory SubscriptionPlan([void updates(SubscriptionPlanBuilder b)]) = _$SubscriptionPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionPlan> get serializer => _$SubscriptionPlanSerializer();
}

class _$SubscriptionPlanSerializer implements PrimitiveSerializer<SubscriptionPlan> {
  @override
  final Iterable<Type> types = const [SubscriptionPlan, _$SubscriptionPlan];

  @override
  final String wireName = r'SubscriptionPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.sortPriority != null) {
      yield r'sortPriority';
      yield serializers.serialize(
        object.sortPriority,
        specifiedType: const FullType(int),
      );
    }
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.priceInSubunit != null) {
      yield r'priceInSubunit';
      yield serializers.serialize(
        object.priceInSubunit,
        specifiedType: const FullType(int),
      );
    }
    if (object.rules != null) {
      yield r'rules';
      yield serializers.serialize(
        object.rules,
        specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)]),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionPlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'sortPriority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sortPriority = valueDes;
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'priceInSubunit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceInSubunit = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)]),
          ) as BuiltList<SubscriptionPlanRulesInner>;
          result.rules.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionPlanBuilder();
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

