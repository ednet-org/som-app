//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_offers_post200_response.g.dart';

/// InquiriesInquiryIdOffersPost200Response
///
/// Properties:
/// * [id] 
/// * [status] 
@BuiltValue()
abstract class InquiriesInquiryIdOffersPost200Response implements Built<InquiriesInquiryIdOffersPost200Response, InquiriesInquiryIdOffersPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'status')
  String? get status;

  InquiriesInquiryIdOffersPost200Response._();

  factory InquiriesInquiryIdOffersPost200Response([void updates(InquiriesInquiryIdOffersPost200ResponseBuilder b)]) = _$InquiriesInquiryIdOffersPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdOffersPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdOffersPost200Response> get serializer => _$InquiriesInquiryIdOffersPost200ResponseSerializer();
}

class _$InquiriesInquiryIdOffersPost200ResponseSerializer implements PrimitiveSerializer<InquiriesInquiryIdOffersPost200Response> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdOffersPost200Response, _$InquiriesInquiryIdOffersPost200Response];

  @override
  final String wireName = r'InquiriesInquiryIdOffersPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdOffersPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    InquiriesInquiryIdOffersPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdOffersPost200ResponseBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InquiriesInquiryIdOffersPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdOffersPost200ResponseBuilder();
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

