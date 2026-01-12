//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_offers_get_request1.g.dart';

/// InquiriesInquiryIdOffersGetRequest1
///
/// Properties:
/// * [pdfBase64] 
abstract class InquiriesInquiryIdOffersGetRequest1 implements Built<InquiriesInquiryIdOffersGetRequest1, InquiriesInquiryIdOffersGetRequest1Builder> {
    @BuiltValueField(wireName: r'pdfBase64')
    String? get pdfBase64;

    InquiriesInquiryIdOffersGetRequest1._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiriesInquiryIdOffersGetRequest1Builder b) => b;

    factory InquiriesInquiryIdOffersGetRequest1([void updates(InquiriesInquiryIdOffersGetRequest1Builder b)]) = _$InquiriesInquiryIdOffersGetRequest1;

    @BuiltValueSerializer(custom: true)
    static Serializer<InquiriesInquiryIdOffersGetRequest1> get serializer => _$InquiriesInquiryIdOffersGetRequest1Serializer();
}

class _$InquiriesInquiryIdOffersGetRequest1Serializer implements StructuredSerializer<InquiriesInquiryIdOffersGetRequest1> {
    @override
    final Iterable<Type> types = const [InquiriesInquiryIdOffersGetRequest1, _$InquiriesInquiryIdOffersGetRequest1];

    @override
    final String wireName = r'InquiriesInquiryIdOffersGetRequest1';

    @override
    Iterable<Object?> serialize(Serializers serializers, InquiriesInquiryIdOffersGetRequest1 object,
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
    InquiriesInquiryIdOffersGetRequest1 deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiriesInquiryIdOffersGetRequest1Builder();

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

