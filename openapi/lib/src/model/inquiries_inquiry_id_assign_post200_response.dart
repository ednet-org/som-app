//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_assign_post200_response.g.dart';

/// InquiriesInquiryIdAssignPost200Response
///
/// Properties:
/// * [assignedProviders] 
/// * [skippedProviders] 
abstract class InquiriesInquiryIdAssignPost200Response implements Built<InquiriesInquiryIdAssignPost200Response, InquiriesInquiryIdAssignPost200ResponseBuilder> {
    @BuiltValueField(wireName: r'assignedProviders')
    BuiltList<String>? get assignedProviders;

    @BuiltValueField(wireName: r'skippedProviders')
    BuiltList<String>? get skippedProviders;

    InquiriesInquiryIdAssignPost200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiriesInquiryIdAssignPost200ResponseBuilder b) => b;

    factory InquiriesInquiryIdAssignPost200Response([void updates(InquiriesInquiryIdAssignPost200ResponseBuilder b)]) = _$InquiriesInquiryIdAssignPost200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<InquiriesInquiryIdAssignPost200Response> get serializer => _$InquiriesInquiryIdAssignPost200ResponseSerializer();
}

class _$InquiriesInquiryIdAssignPost200ResponseSerializer implements StructuredSerializer<InquiriesInquiryIdAssignPost200Response> {
    @override
    final Iterable<Type> types = const [InquiriesInquiryIdAssignPost200Response, _$InquiriesInquiryIdAssignPost200Response];

    @override
    final String wireName = r'InquiriesInquiryIdAssignPost200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, InquiriesInquiryIdAssignPost200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.assignedProviders != null) {
            result
                ..add(r'assignedProviders')
                ..add(serializers.serialize(object.assignedProviders,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        if (object.skippedProviders != null) {
            result
                ..add(r'skippedProviders')
                ..add(serializers.serialize(object.skippedProviders,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        return result;
    }

    @override
    InquiriesInquiryIdAssignPost200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiriesInquiryIdAssignPost200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'assignedProviders':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.assignedProviders.replace(valueDes);
                    break;
                case r'skippedProviders':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.skippedProviders.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

