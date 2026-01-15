//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_cancel_post_request.g.dart';

/// SubscriptionsCancelPostRequest
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class SubscriptionsCancelPostRequest implements Built<SubscriptionsCancelPostRequest, SubscriptionsCancelPostRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  SubscriptionsCancelPostRequest._();

  factory SubscriptionsCancelPostRequest([void updates(SubscriptionsCancelPostRequestBuilder b)]) = _$SubscriptionsCancelPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionsCancelPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionsCancelPostRequest> get serializer => _$SubscriptionsCancelPostRequestSerializer();
}

class _$SubscriptionsCancelPostRequestSerializer implements PrimitiveSerializer<SubscriptionsCancelPostRequest> {
  @override
  final Iterable<Type> types = const [SubscriptionsCancelPostRequest, _$SubscriptionsCancelPostRequest];

  @override
  final String wireName = r'SubscriptionsCancelPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionsCancelPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionsCancelPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionsCancelPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionsCancelPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionsCancelPostRequestBuilder();
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

