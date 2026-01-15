//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ad200_response.g.dart';

/// CreateAd200Response
///
/// Properties:
/// * [id] 
@BuiltValue()
abstract class CreateAd200Response implements Built<CreateAd200Response, CreateAd200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  CreateAd200Response._();

  factory CreateAd200Response([void updates(CreateAd200ResponseBuilder b)]) = _$CreateAd200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAd200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAd200Response> get serializer => _$CreateAd200ResponseSerializer();
}

class _$CreateAd200ResponseSerializer implements PrimitiveSerializer<CreateAd200Response> {
  @override
  final Iterable<Type> types = const [CreateAd200Response, _$CreateAd200Response];

  @override
  final String wireName = r'CreateAd200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAd200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAd200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateAd200ResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAd200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAd200ResponseBuilder();
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

