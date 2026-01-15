//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_cancellation.g.dart';

/// SubscriptionCancellation
///
/// Properties:
/// * [id] 
/// * [companyId] 
/// * [requestedByUserId] 
/// * [reason] 
/// * [status] 
/// * [requestedAt] 
/// * [effectiveEndDate] 
/// * [resolvedAt] 
@BuiltValue()
abstract class SubscriptionCancellation implements Built<SubscriptionCancellation, SubscriptionCancellationBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'requestedByUserId')
  String? get requestedByUserId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'effectiveEndDate')
  DateTime? get effectiveEndDate;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  SubscriptionCancellation._();

  factory SubscriptionCancellation([void updates(SubscriptionCancellationBuilder b)]) = _$SubscriptionCancellation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriptionCancellationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriptionCancellation> get serializer => _$SubscriptionCancellationSerializer();
}

class _$SubscriptionCancellationSerializer implements PrimitiveSerializer<SubscriptionCancellation> {
  @override
  final Iterable<Type> types = const [SubscriptionCancellation, _$SubscriptionCancellation];

  @override
  final String wireName = r'SubscriptionCancellation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriptionCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.requestedByUserId != null) {
      yield r'requestedByUserId';
      yield serializers.serialize(
        object.requestedByUserId,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.requestedAt != null) {
      yield r'requestedAt';
      yield serializers.serialize(
        object.requestedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.effectiveEndDate != null) {
      yield r'effectiveEndDate';
      yield serializers.serialize(
        object.effectiveEndDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.resolvedAt != null) {
      yield r'resolvedAt';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubscriptionCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubscriptionCancellationBuilder result,
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
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'requestedByUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestedByUserId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'requestedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'effectiveEndDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveEndDate = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubscriptionCancellation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriptionCancellationBuilder();
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

