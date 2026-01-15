//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'billing_billing_id_put_request.g.dart';

/// BillingBillingIdPutRequest
///
/// Properties:
/// * [status] 
/// * [paidAt] 
@BuiltValue()
abstract class BillingBillingIdPutRequest implements Built<BillingBillingIdPutRequest, BillingBillingIdPutRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  BillingBillingIdPutRequest._();

  factory BillingBillingIdPutRequest([void updates(BillingBillingIdPutRequestBuilder b)]) = _$BillingBillingIdPutRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BillingBillingIdPutRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BillingBillingIdPutRequest> get serializer => _$BillingBillingIdPutRequestSerializer();
}

class _$BillingBillingIdPutRequestSerializer implements PrimitiveSerializer<BillingBillingIdPutRequest> {
  @override
  final Iterable<Type> types = const [BillingBillingIdPutRequest, _$BillingBillingIdPutRequest];

  @override
  final String wireName = r'BillingBillingIdPutRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BillingBillingIdPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.paidAt != null) {
      yield r'paidAt';
      yield serializers.serialize(
        object.paidAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BillingBillingIdPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BillingBillingIdPutRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'paidAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.paidAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BillingBillingIdPutRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BillingBillingIdPutRequestBuilder();
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

