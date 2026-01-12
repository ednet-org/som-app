//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_assign_post_request.g.dart';

/// InquiriesInquiryIdAssignPostRequest
///
/// Properties:
/// * [providerCompanyIds] 
abstract class InquiriesInquiryIdAssignPostRequest implements Built<InquiriesInquiryIdAssignPostRequest, InquiriesInquiryIdAssignPostRequestBuilder> {
    @BuiltValueField(wireName: r'providerCompanyIds')
    BuiltList<String> get providerCompanyIds;

    InquiriesInquiryIdAssignPostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiriesInquiryIdAssignPostRequestBuilder b) => b;

    factory InquiriesInquiryIdAssignPostRequest([void updates(InquiriesInquiryIdAssignPostRequestBuilder b)]) = _$InquiriesInquiryIdAssignPostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<InquiriesInquiryIdAssignPostRequest> get serializer => _$InquiriesInquiryIdAssignPostRequestSerializer();
}

class _$InquiriesInquiryIdAssignPostRequestSerializer implements StructuredSerializer<InquiriesInquiryIdAssignPostRequest> {
    @override
    final Iterable<Type> types = const [InquiriesInquiryIdAssignPostRequest, _$InquiriesInquiryIdAssignPostRequest];

    @override
    final String wireName = r'InquiriesInquiryIdAssignPostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, InquiriesInquiryIdAssignPostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'providerCompanyIds')
            ..add(serializers.serialize(object.providerCompanyIds,
                specifiedType: const FullType(BuiltList, [FullType(String)])));
        return result;
    }

    @override
    InquiriesInquiryIdAssignPostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiriesInquiryIdAssignPostRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'providerCompanyIds':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.providerCompanyIds.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

