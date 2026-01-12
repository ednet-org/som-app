//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ads_get200_response.g.dart';

/// AdsGet200Response
///
/// Properties:
/// * [id] 
abstract class AdsGet200Response implements Built<AdsGet200Response, AdsGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    AdsGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AdsGet200ResponseBuilder b) => b;

    factory AdsGet200Response([void updates(AdsGet200ResponseBuilder b)]) = _$AdsGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<AdsGet200Response> get serializer => _$AdsGet200ResponseSerializer();
}

class _$AdsGet200ResponseSerializer implements StructuredSerializer<AdsGet200Response> {
    @override
    final Iterable<Type> types = const [AdsGet200Response, _$AdsGet200Response];

    @override
    final String wireName = r'AdsGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, AdsGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    AdsGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AdsGet200ResponseBuilder();

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
            }
        }
        return result.build();
    }
}

