//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_buyer_get200_response.g.dart';

/// StatsBuyerGet200Response
///
/// Properties:
/// * [open] 
/// * [closed] 
abstract class StatsBuyerGet200Response implements Built<StatsBuyerGet200Response, StatsBuyerGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'open')
    int? get open;

    @BuiltValueField(wireName: r'closed')
    int? get closed;

    StatsBuyerGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(StatsBuyerGet200ResponseBuilder b) => b;

    factory StatsBuyerGet200Response([void updates(StatsBuyerGet200ResponseBuilder b)]) = _$StatsBuyerGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<StatsBuyerGet200Response> get serializer => _$StatsBuyerGet200ResponseSerializer();
}

class _$StatsBuyerGet200ResponseSerializer implements StructuredSerializer<StatsBuyerGet200Response> {
    @override
    final Iterable<Type> types = const [StatsBuyerGet200Response, _$StatsBuyerGet200Response];

    @override
    final String wireName = r'StatsBuyerGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, StatsBuyerGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.open != null) {
            result
                ..add(r'open')
                ..add(serializers.serialize(object.open,
                    specifiedType: const FullType(int)));
        }
        if (object.closed != null) {
            result
                ..add(r'closed')
                ..add(serializers.serialize(object.closed,
                    specifiedType: const FullType(int)));
        }
        return result;
    }

    @override
    StatsBuyerGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = StatsBuyerGet200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'open':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.open = valueDes;
                    break;
                case r'closed':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.closed = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

