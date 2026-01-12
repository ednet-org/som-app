//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'branches_get_request.g.dart';

/// BranchesGetRequest
///
/// Properties:
/// * [name] 
abstract class BranchesGetRequest implements Built<BranchesGetRequest, BranchesGetRequestBuilder> {
    @BuiltValueField(wireName: r'name')
    String get name;

    BranchesGetRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(BranchesGetRequestBuilder b) => b;

    factory BranchesGetRequest([void updates(BranchesGetRequestBuilder b)]) = _$BranchesGetRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<BranchesGetRequest> get serializer => _$BranchesGetRequestSerializer();
}

class _$BranchesGetRequestSerializer implements StructuredSerializer<BranchesGetRequest> {
    @override
    final Iterable<Type> types = const [BranchesGetRequest, _$BranchesGetRequest];

    @override
    final String wireName = r'BranchesGetRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, BranchesGetRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'name')
            ..add(serializers.serialize(object.name,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    BranchesGetRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = BranchesGetRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'name':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.name = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

