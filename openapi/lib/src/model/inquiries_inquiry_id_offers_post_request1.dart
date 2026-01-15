//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_offers_post_request1.g.dart';

/// InquiriesInquiryIdOffersPostRequest1
///
/// Properties:
/// * [pdfBase64] 
@BuiltValue()
abstract class InquiriesInquiryIdOffersPostRequest1 implements Built<InquiriesInquiryIdOffersPostRequest1, InquiriesInquiryIdOffersPostRequest1Builder> {
  @BuiltValueField(wireName: r'pdfBase64')
  String? get pdfBase64;

  InquiriesInquiryIdOffersPostRequest1._();

  factory InquiriesInquiryIdOffersPostRequest1([void updates(InquiriesInquiryIdOffersPostRequest1Builder b)]) = _$InquiriesInquiryIdOffersPostRequest1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdOffersPostRequest1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdOffersPostRequest1> get serializer => _$InquiriesInquiryIdOffersPostRequest1Serializer();
}

class _$InquiriesInquiryIdOffersPostRequest1Serializer implements PrimitiveSerializer<InquiriesInquiryIdOffersPostRequest1> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdOffersPostRequest1, _$InquiriesInquiryIdOffersPostRequest1];

  @override
  final String wireName = r'InquiriesInquiryIdOffersPostRequest1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdOffersPostRequest1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pdfBase64 != null) {
      yield r'pdfBase64';
      yield serializers.serialize(
        object.pdfBase64,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InquiriesInquiryIdOffersPostRequest1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdOffersPostRequest1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pdfBase64':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pdfBase64 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InquiriesInquiryIdOffersPostRequest1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdOffersPostRequest1Builder();
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

