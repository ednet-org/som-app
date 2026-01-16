//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_pdf_get200_response.g.dart';

/// InquiriesInquiryIdPdfGet200Response
///
/// Properties:
/// * [signedUrl] 
@BuiltValue()
abstract class InquiriesInquiryIdPdfGet200Response implements Built<InquiriesInquiryIdPdfGet200Response, InquiriesInquiryIdPdfGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'signedUrl')
  String? get signedUrl;

  InquiriesInquiryIdPdfGet200Response._();

  factory InquiriesInquiryIdPdfGet200Response([void updates(InquiriesInquiryIdPdfGet200ResponseBuilder b)]) = _$InquiriesInquiryIdPdfGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdPdfGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdPdfGet200Response> get serializer => _$InquiriesInquiryIdPdfGet200ResponseSerializer();
}

class _$InquiriesInquiryIdPdfGet200ResponseSerializer implements PrimitiveSerializer<InquiriesInquiryIdPdfGet200Response> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdPdfGet200Response, _$InquiriesInquiryIdPdfGet200Response];

  @override
  final String wireName = r'InquiriesInquiryIdPdfGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdPdfGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.signedUrl != null) {
      yield r'signedUrl';
      yield serializers.serialize(
        object.signedUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InquiriesInquiryIdPdfGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdPdfGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signedUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InquiriesInquiryIdPdfGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdPdfGet200ResponseBuilder();
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

