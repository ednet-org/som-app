//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_provider_get200_response.g.dart';

/// StatsProviderGet200Response
///
/// Properties:
/// * [open] 
/// * [offerCreated] 
/// * [lost] 
/// * [won] 
/// * [ignored] 
abstract class StatsProviderGet200Response implements Built<StatsProviderGet200Response, StatsProviderGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'open')
    int? get open;

    @BuiltValueField(wireName: r'offer_created')
    int? get offerCreated;

    @BuiltValueField(wireName: r'lost')
    int? get lost;

    @BuiltValueField(wireName: r'won')
    int? get won;

    @BuiltValueField(wireName: r'ignored')
    int? get ignored;

    StatsProviderGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(StatsProviderGet200ResponseBuilder b) => b;

    factory StatsProviderGet200Response([void updates(StatsProviderGet200ResponseBuilder b)]) = _$StatsProviderGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<StatsProviderGet200Response> get serializer => _$StatsProviderGet200ResponseSerializer();
}

class _$StatsProviderGet200ResponseSerializer implements StructuredSerializer<StatsProviderGet200Response> {
    @override
    final Iterable<Type> types = const [StatsProviderGet200Response, _$StatsProviderGet200Response];

    @override
    final String wireName = r'StatsProviderGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, StatsProviderGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.open != null) {
            result
                ..add(r'open')
                ..add(serializers.serialize(object.open,
                    specifiedType: const FullType(int)));
        }
        if (object.offerCreated != null) {
            result
                ..add(r'offer_created')
                ..add(serializers.serialize(object.offerCreated,
                    specifiedType: const FullType(int)));
        }
        if (object.lost != null) {
            result
                ..add(r'lost')
                ..add(serializers.serialize(object.lost,
                    specifiedType: const FullType(int)));
        }
        if (object.won != null) {
            result
                ..add(r'won')
                ..add(serializers.serialize(object.won,
                    specifiedType: const FullType(int)));
        }
        if (object.ignored != null) {
            result
                ..add(r'ignored')
                ..add(serializers.serialize(object.ignored,
                    specifiedType: const FullType(int)));
        }
        return result;
    }

    @override
    StatsProviderGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = StatsProviderGet200ResponseBuilder();

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
                case r'offer_created':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.offerCreated = valueDes;
                    break;
                case r'lost':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.lost = valueDes;
                    break;
                case r'won':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.won = valueDes;
                    break;
                case r'ignored':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.ignored = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

