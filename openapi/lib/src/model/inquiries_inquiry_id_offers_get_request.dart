//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_offers_get_request.g.dart';

/// InquiriesInquiryIdOffersGetRequest
///
/// Properties:
/// * [pdfBase64] 
abstract class InquiriesInquiryIdOffersGetRequest implements Built<InquiriesInquiryIdOffersGetRequest, InquiriesInquiryIdOffersGetRequestBuilder> {
    @BuiltValueField(wireName: r'pdfBase64')
    String? get pdfBase64;

    InquiriesInquiryIdOffersGetRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiriesInquiryIdOffersGetRequestBuilder b) => b;

    factory InquiriesInquiryIdOffersGetRequest([void updates(InquiriesInquiryIdOffersGetRequestBuilder b)]) = _$InquiriesInquiryIdOffersGetRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<InquiriesInquiryIdOffersGetRequest> get serializer => _$InquiriesInquiryIdOffersGetRequestSerializer();
}

class _$InquiriesInquiryIdOffersGetRequestSerializer implements StructuredSerializer<InquiriesInquiryIdOffersGetRequest> {
    @override
    final Iterable<Type> types = const [InquiriesInquiryIdOffersGetRequest, _$InquiriesInquiryIdOffersGetRequest];

    @override
    final String wireName = r'InquiriesInquiryIdOffersGetRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, InquiriesInquiryIdOffersGetRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.pdfBase64 != null) {
            result
                ..add(r'pdfBase64')
                ..add(serializers.serialize(object.pdfBase64,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    InquiriesInquiryIdOffersGetRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiriesInquiryIdOffersGetRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'pdfBase64':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.pdfBase64 = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

