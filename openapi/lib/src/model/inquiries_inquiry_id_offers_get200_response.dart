//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_offers_get200_response.g.dart';

/// InquiriesInquiryIdOffersGet200Response
///
/// Properties:
/// * [id] 
/// * [status] 
abstract class InquiriesInquiryIdOffersGet200Response implements Built<InquiriesInquiryIdOffersGet200Response, InquiriesInquiryIdOffersGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'status')
    String? get status;

    InquiriesInquiryIdOffersGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiriesInquiryIdOffersGet200ResponseBuilder b) => b;

    factory InquiriesInquiryIdOffersGet200Response([void updates(InquiriesInquiryIdOffersGet200ResponseBuilder b)]) = _$InquiriesInquiryIdOffersGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<InquiriesInquiryIdOffersGet200Response> get serializer => _$InquiriesInquiryIdOffersGet200ResponseSerializer();
}

class _$InquiriesInquiryIdOffersGet200ResponseSerializer implements StructuredSerializer<InquiriesInquiryIdOffersGet200Response> {
    @override
    final Iterable<Type> types = const [InquiriesInquiryIdOffersGet200Response, _$InquiriesInquiryIdOffersGet200Response];

    @override
    final String wireName = r'InquiriesInquiryIdOffersGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, InquiriesInquiryIdOffersGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.status != null) {
            result
                ..add(r'status')
                ..add(serializers.serialize(object.status,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    InquiriesInquiryIdOffersGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiriesInquiryIdOffersGet200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'id':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.id = valueDes;
                    break;
                case r'status':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.status = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

