//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_get200_response.g.dart';

/// SubscriptionsGet200Response
///
/// Properties:
/// * [subscriptions] 
@BuiltValue()
abstract class SubscriptionsGet200Response implements Built<SubscriptionsGet200Response, SubscriptionsGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'subscriptions')
  BuiltList<SubscriptionPlan>? get subscriptions;

  SubscriptionsGet200Response._();

  factory SubscriptionsGet200Response([void updates(SubscriptionsGet200ResponseBuilder b)]) = _$SubscriptionsGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionsGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionsGet200Response> get serializer => _$SubscriptionsGet200ResponseSerializer();
}

class _$SubscriptionsGet200ResponseSerializer implements PrimitiveSerializer<SubscriptionsGet200Response> {
  @override
  final Iterable<Type> types = const [SubscriptionsGet200Response, _$SubscriptionsGet200Response];

  @override
  final String wireName = r'SubscriptionsGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.subscriptions != null) {
      yield r'subscriptions';
      yield serializers.serialize(
        object.subscriptions,
        specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlan)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionsGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionsGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subscriptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlan)]),
          ) as BuiltList<SubscriptionPlan>;
          result.subscriptions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionsGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionsGet200ResponseBuilder();
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

