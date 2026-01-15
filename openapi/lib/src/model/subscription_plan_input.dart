//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan_rules_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan_input.g.dart';

/// SubscriptionPlanInput
///
/// Properties:
/// * [title] 
/// * [sortPriority] 
/// * [isActive] 
/// * [priceInSubunit] 
/// * [maxUsers] 
/// * [setupFeeInSubunit] 
/// * [bannerAdsPerMonth] 
/// * [normalAdsPerMonth] 
/// * [freeMonths] 
/// * [commitmentPeriodMonths] 
/// * [confirm] - Require explicit confirmation when updating plans with active subscribers.
/// * [rules] 
@BuiltValue()
abstract class SubscriptionPlanInput implements Built<SubscriptionPlanInput, SubscriptionPlanInputBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'sortPriority')
  int get sortPriority;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  @BuiltValueField(wireName: r'priceInSubunit')
  int get priceInSubunit;

  @BuiltValueField(wireName: r'maxUsers')
  int? get maxUsers;

  @BuiltValueField(wireName: r'setupFeeInSubunit')
  int? get setupFeeInSubunit;

  @BuiltValueField(wireName: r'bannerAdsPerMonth')
  int? get bannerAdsPerMonth;

  @BuiltValueField(wireName: r'normalAdsPerMonth')
  int? get normalAdsPerMonth;

  @BuiltValueField(wireName: r'freeMonths')
  int? get freeMonths;

  @BuiltValueField(wireName: r'commitmentPeriodMonths')
  int? get commitmentPeriodMonths;

  /// Require explicit confirmation when updating plans with active subscribers.
  @BuiltValueField(wireName: r'confirm')
  bool? get confirm;

  @BuiltValueField(wireName: r'rules')
  BuiltList<SubscriptionPlanRulesInner>? get rules;

  SubscriptionPlanInput._();

  factory SubscriptionPlanInput([void updates(SubscriptionPlanInputBuilder b)]) = _$SubscriptionPlanInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionPlanInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionPlanInput> get serializer => _$SubscriptionPlanInputSerializer();
}

class _$SubscriptionPlanInputSerializer implements PrimitiveSerializer<SubscriptionPlanInput> {
  @override
  final Iterable<Type> types = const [SubscriptionPlanInput, _$SubscriptionPlanInput];

  @override
  final String wireName = r'SubscriptionPlanInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionPlanInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'sortPriority';
    yield serializers.serialize(
      object.sortPriority,
      specifiedType: const FullType(int),
    );
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    yield r'priceInSubunit';
    yield serializers.serialize(
      object.priceInSubunit,
      specifiedType: const FullType(int),
    );
    if (object.maxUsers != null) {
      yield r'maxUsers';
      yield serializers.serialize(
        object.maxUsers,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.setupFeeInSubunit != null) {
      yield r'setupFeeInSubunit';
      yield serializers.serialize(
        object.setupFeeInSubunit,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.bannerAdsPerMonth != null) {
      yield r'bannerAdsPerMonth';
      yield serializers.serialize(
        object.bannerAdsPerMonth,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.normalAdsPerMonth != null) {
      yield r'normalAdsPerMonth';
      yield serializers.serialize(
        object.normalAdsPerMonth,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.freeMonths != null) {
      yield r'freeMonths';
      yield serializers.serialize(
        object.freeMonths,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.commitmentPeriodMonths != null) {
      yield r'commitmentPeriodMonths';
      yield serializers.serialize(
        object.commitmentPeriodMonths,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.confirm != null) {
      yield r'confirm';
      yield serializers.serialize(
        object.confirm,
        specifiedType: const FullType(bool),
      );
    }
    if (object.rules != null) {
      yield r'rules';
      yield serializers.serialize(
        object.rules,
        specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionPlanInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionPlanInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'maxUsers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxUsers = valueDes;
          break;
        case r'setupFeeInSubunit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.setupFeeInSubunit = valueDes;
          break;
        case r'bannerAdsPerMonth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.bannerAdsPerMonth = valueDes;
          break;
        case r'normalAdsPerMonth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.normalAdsPerMonth = valueDes;
          break;
        case r'freeMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.freeMonths = valueDes;
          break;
        case r'commitmentPeriodMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.commitmentPeriodMonths = valueDes;
          break;
        case r'confirm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.confirm = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)]),
          ) as BuiltList<SubscriptionPlanRulesInner>;
          result.rules.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionPlanInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionPlanInputBuilder();
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

