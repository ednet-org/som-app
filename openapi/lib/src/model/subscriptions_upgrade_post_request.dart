//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_upgrade_post_request.g.dart';

/// SubscriptionsUpgradePostRequest
///
/// Properties:
/// * [planId] 
@BuiltValue()
abstract class SubscriptionsUpgradePostRequest implements Built<SubscriptionsUpgradePostRequest, SubscriptionsUpgradePostRequestBuilder> {
  @BuiltValueField(wireName: r'planId')
  String get planId;

  SubscriptionsUpgradePostRequest._();

  factory SubscriptionsUpgradePostRequest([void updates(SubscriptionsUpgradePostRequestBuilder b)]) = _$SubscriptionsUpgradePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionsUpgradePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionsUpgradePostRequest> get serializer => _$SubscriptionsUpgradePostRequestSerializer();
}

class _$SubscriptionsUpgradePostRequestSerializer implements PrimitiveSerializer<SubscriptionsUpgradePostRequest> {
  @override
  final Iterable<Type> types = const [SubscriptionsUpgradePostRequest, _$SubscriptionsUpgradePostRequest];

  @override
  final String wireName = r'SubscriptionsUpgradePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionsUpgradePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'planId';
    yield serializers.serialize(
      object.planId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionsUpgradePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionsUpgradePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'planId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.planId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionsUpgradePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionsUpgradePostRequestBuilder();
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

