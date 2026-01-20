//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_pdf_generate_post200_response.g.dart';

/// InquiriesInquiryIdPdfGeneratePost200Response
///
/// Properties:
/// * [summaryPdfPath] 
/// * [signedUrl] 
@BuiltValue()
abstract class InquiriesInquiryIdPdfGeneratePost200Response implements Built<InquiriesInquiryIdPdfGeneratePost200Response, InquiriesInquiryIdPdfGeneratePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'summaryPdfPath')
  String? get summaryPdfPath;

  @BuiltValueField(wireName: r'signedUrl')
  String? get signedUrl;

  InquiriesInquiryIdPdfGeneratePost200Response._();

  factory InquiriesInquiryIdPdfGeneratePost200Response([void updates(InquiriesInquiryIdPdfGeneratePost200ResponseBuilder b)]) = _$InquiriesInquiryIdPdfGeneratePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdPdfGeneratePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdPdfGeneratePost200Response> get serializer => _$InquiriesInquiryIdPdfGeneratePost200ResponseSerializer();
}

class _$InquiriesInquiryIdPdfGeneratePost200ResponseSerializer implements PrimitiveSerializer<InquiriesInquiryIdPdfGeneratePost200Response> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdPdfGeneratePost200Response, _$InquiriesInquiryIdPdfGeneratePost200Response];

  @override
  final String wireName = r'InquiriesInquiryIdPdfGeneratePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdPdfGeneratePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.summaryPdfPath != null) {
      yield r'summaryPdfPath';
      yield serializers.serialize(
        object.summaryPdfPath,
        specifiedType: const FullType(String),
      );
    }
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
    InquiriesInquiryIdPdfGeneratePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdPdfGeneratePost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'summaryPdfPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summaryPdfPath = valueDes;
          break;
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
  InquiriesInquiryIdPdfGeneratePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdPdfGeneratePost200ResponseBuilder();
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

