//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ad_activation_request.g.dart';

/// AdActivationRequest
///
/// Properties:
/// * [startDate] 
/// * [endDate] 
/// * [bannerDate] 
@BuiltValue()
abstract class AdActivationRequest implements Built<AdActivationRequest, AdActivationRequestBuilder> {
  @BuiltValueField(wireName: r'startDate')
  DateTime? get startDate;

  @BuiltValueField(wireName: r'endDate')
  DateTime? get endDate;

  @BuiltValueField(wireName: r'bannerDate')
  DateTime? get bannerDate;

  AdActivationRequest._();

  factory AdActivationRequest([void updates(AdActivationRequestBuilder b)]) = _$AdActivationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdActivationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdActivationRequest> get serializer => _$AdActivationRequestSerializer();
}

class _$AdActivationRequestSerializer implements PrimitiveSerializer<AdActivationRequest> {
  @override
  final Iterable<Type> types = const [AdActivationRequest, _$AdActivationRequest];

  @override
  final String wireName = r'AdActivationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdActivationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.startDate != null) {
      yield r'startDate';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.endDate != null) {
      yield r'endDate';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.bannerDate != null) {
      yield r'bannerDate';
      yield serializers.serialize(
        object.bannerDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdActivationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdActivationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startDate = valueDes;
          break;
        case r'endDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.endDate = valueDes;
          break;
        case r'bannerDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.bannerDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdActivationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdActivationRequestBuilder();
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

