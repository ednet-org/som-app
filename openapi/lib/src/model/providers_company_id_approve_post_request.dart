//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'providers_company_id_approve_post_request.g.dart';

/// ProvidersCompanyIdApprovePostRequest
///
/// Properties:
/// * [approvedBranchIds] 
abstract class ProvidersCompanyIdApprovePostRequest implements Built<ProvidersCompanyIdApprovePostRequest, ProvidersCompanyIdApprovePostRequestBuilder> {
    @BuiltValueField(wireName: r'approvedBranchIds')
    BuiltList<String>? get approvedBranchIds;

    ProvidersCompanyIdApprovePostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ProvidersCompanyIdApprovePostRequestBuilder b) => b;

    factory ProvidersCompanyIdApprovePostRequest([void updates(ProvidersCompanyIdApprovePostRequestBuilder b)]) = _$ProvidersCompanyIdApprovePostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<ProvidersCompanyIdApprovePostRequest> get serializer => _$ProvidersCompanyIdApprovePostRequestSerializer();
}

class _$ProvidersCompanyIdApprovePostRequestSerializer implements StructuredSerializer<ProvidersCompanyIdApprovePostRequest> {
    @override
    final Iterable<Type> types = const [ProvidersCompanyIdApprovePostRequest, _$ProvidersCompanyIdApprovePostRequest];

    @override
    final String wireName = r'ProvidersCompanyIdApprovePostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, ProvidersCompanyIdApprovePostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.approvedBranchIds != null) {
            result
                ..add(r'approvedBranchIds')
                ..add(serializers.serialize(object.approvedBranchIds,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        return result;
    }

    @override
    ProvidersCompanyIdApprovePostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ProvidersCompanyIdApprovePostRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'approvedBranchIds':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.approvedBranchIds.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

