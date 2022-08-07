//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_response.g.dart';

/// SubscriptionsResponse
///
/// Properties:
/// * [subscriptions] 
abstract class SubscriptionsResponse implements Built<SubscriptionsResponse, SubscriptionsResponseBuilder> {
    @BuiltValueField(wireName: r'subscriptions')
    BuiltList<SubscriptionPlanDto>? get subscriptions;

    SubscriptionsResponse._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionsResponseBuilder b) => b;

    factory SubscriptionsResponse([void updates(SubscriptionsResponseBuilder b)]) = _$SubscriptionsResponse;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionsResponse> get serializer => _$SubscriptionsResponseSerializer();
}

class _$SubscriptionsResponseSerializer implements StructuredSerializer<SubscriptionsResponse> {
    @override
    final Iterable<Type> types = const [SubscriptionsResponse, _$SubscriptionsResponse];

    @override
    final String wireName = r'SubscriptionsResponse';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionsResponse object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.subscriptions != null) {
            result
                ..add(r'subscriptions')
                ..add(serializers.serialize(object.subscriptions,
                    specifiedType: const FullType.nullable(BuiltList, [FullType(SubscriptionPlanDto)])));
        }
        return result;
    }

    @override
    SubscriptionsResponse deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionsResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'subscriptions':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(BuiltList, [FullType(SubscriptionPlanDto)])) as BuiltList<SubscriptionPlanDto>?;
                    if (valueDes == null) continue;
                    result.subscriptions.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

