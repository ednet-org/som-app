//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_pdf_post200_response.g.dart';

/// InquiriesInquiryIdPdfPost200Response
///
/// Properties:
/// * [pdfPath] 
@BuiltValue()
abstract class InquiriesInquiryIdPdfPost200Response implements Built<InquiriesInquiryIdPdfPost200Response, InquiriesInquiryIdPdfPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'pdfPath')
  String? get pdfPath;

  InquiriesInquiryIdPdfPost200Response._();

  factory InquiriesInquiryIdPdfPost200Response([void updates(InquiriesInquiryIdPdfPost200ResponseBuilder b)]) = _$InquiriesInquiryIdPdfPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdPdfPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdPdfPost200Response> get serializer => _$InquiriesInquiryIdPdfPost200ResponseSerializer();
}

class _$InquiriesInquiryIdPdfPost200ResponseSerializer implements PrimitiveSerializer<InquiriesInquiryIdPdfPost200Response> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdPdfPost200Response, _$InquiriesInquiryIdPdfPost200Response];

  @override
  final String wireName = r'InquiriesInquiryIdPdfPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdPdfPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pdfPath != null) {
      yield r'pdfPath';
      yield serializers.serialize(
        object.pdfPath,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InquiriesInquiryIdPdfPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdPdfPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pdfPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pdfPath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InquiriesInquiryIdPdfPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdPdfPost200ResponseBuilder();
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

