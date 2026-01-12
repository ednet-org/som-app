//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ad200_response.g.dart';

/// CreateAd200Response
///
/// Properties:
/// * [id] 
abstract class CreateAd200Response implements Built<CreateAd200Response, CreateAd200ResponseBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    CreateAd200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CreateAd200ResponseBuilder b) => b;

    factory CreateAd200Response([void updates(CreateAd200ResponseBuilder b)]) = _$CreateAd200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<CreateAd200Response> get serializer => _$CreateAd200ResponseSerializer();
}

class _$CreateAd200ResponseSerializer implements StructuredSerializer<CreateAd200Response> {
    @override
    final Iterable<Type> types = const [CreateAd200Response, _$CreateAd200Response];

    @override
    final String wireName = r'CreateAd200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, CreateAd200Response object,
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
    CreateAd200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CreateAd200ResponseBuilder();

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

