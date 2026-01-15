//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_current_subscription.g.dart';

/// SubscriptionCurrentSubscription
///
/// Properties:
/// * [companyId] 
/// * [planId] 
/// * [status] 
/// * [paymentInterval] 
/// * [startDate] 
/// * [endDate] 
/// * [createdAt] 
@BuiltValue()
abstract class SubscriptionCurrentSubscription implements Built<SubscriptionCurrentSubscription, SubscriptionCurrentSubscriptionBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'planId')
  String? get planId;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'paymentInterval')
  String? get paymentInterval;

  @BuiltValueField(wireName: r'startDate')
  DateTime? get startDate;

  @BuiltValueField(wireName: r'endDate')
  DateTime? get endDate;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  SubscriptionCurrentSubscription._();

  factory SubscriptionCurrentSubscription([void updates(SubscriptionCurrentSubscriptionBuilder b)]) = _$SubscriptionCurrentSubscription;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionCurrentSubscriptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionCurrentSubscription> get serializer => _$SubscriptionCurrentSubscriptionSerializer();
}

class _$SubscriptionCurrentSubscriptionSerializer implements PrimitiveSerializer<SubscriptionCurrentSubscription> {
  @override
  final Iterable<Type> types = const [SubscriptionCurrentSubscription, _$SubscriptionCurrentSubscription];

  @override
  final String wireName = r'SubscriptionCurrentSubscription';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionCurrentSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.planId != null) {
      yield r'planId';
      yield serializers.serialize(
        object.planId,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentInterval != null) {
      yield r'paymentInterval';
      yield serializers.serialize(
        object.paymentInterval,
        specifiedType: const FullType(String),
      );
    }
    if (object.startDate != null) {
      yield r'startDate';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.endDate != null) {
      yield r'endDate';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType(DateTime),
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
    SubscriptionCurrentSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionCurrentSubscriptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'planId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.planId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'paymentInterval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentInterval = valueDes;
          break;
        case r'startDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startDate = valueDes;
          break;
        case r'endDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endDate = valueDes;
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
  SubscriptionCurrentSubscription deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionCurrentSubscriptionBuilder();
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

