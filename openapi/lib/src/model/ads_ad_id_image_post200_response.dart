//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ads_ad_id_image_post200_response.g.dart';

/// AdsAdIdImagePost200Response
///
/// Properties:
/// * [imagePath] 
@BuiltValue()
abstract class AdsAdIdImagePost200Response implements Built<AdsAdIdImagePost200Response, AdsAdIdImagePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'imagePath')
  String? get imagePath;

  AdsAdIdImagePost200Response._();

  factory AdsAdIdImagePost200Response([void updates(AdsAdIdImagePost200ResponseBuilder b)]) = _$AdsAdIdImagePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdsAdIdImagePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdsAdIdImagePost200Response> get serializer => _$AdsAdIdImagePost200ResponseSerializer();
}

class _$AdsAdIdImagePost200ResponseSerializer implements PrimitiveSerializer<AdsAdIdImagePost200Response> {
  @override
  final Iterable<Type> types = const [AdsAdIdImagePost200Response, _$AdsAdIdImagePost200Response];

  @override
  final String wireName = r'AdsAdIdImagePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdsAdIdImagePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.imagePath != null) {
      yield r'imagePath';
      yield serializers.serialize(
        object.imagePath,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdsAdIdImagePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdsAdIdImagePost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'imagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imagePath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdsAdIdImagePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdsAdIdImagePost200ResponseBuilder();
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

