//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_get200_response.g.dart';

/// SubscriptionsGet200Response
///
/// Properties:
/// * [subscriptions] 
abstract class SubscriptionsGet200Response implements Built<SubscriptionsGet200Response, SubscriptionsGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'subscriptions')
    BuiltList<SubscriptionPlan>? get subscriptions;

    SubscriptionsGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionsGet200ResponseBuilder b) => b;

    factory SubscriptionsGet200Response([void updates(SubscriptionsGet200ResponseBuilder b)]) = _$SubscriptionsGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionsGet200Response> get serializer => _$SubscriptionsGet200ResponseSerializer();
}

class _$SubscriptionsGet200ResponseSerializer implements StructuredSerializer<SubscriptionsGet200Response> {
    @override
    final Iterable<Type> types = const [SubscriptionsGet200Response, _$SubscriptionsGet200Response];

    @override
    final String wireName = r'SubscriptionsGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionsGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.subscriptions != null) {
            result
                ..add(r'subscriptions')
                ..add(serializers.serialize(object.subscriptions,
                    specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlan)])));
        }
        return result;
    }

    @override
    SubscriptionsGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionsGet200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'subscriptions':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlan)])) as BuiltList<SubscriptionPlan>;
                    result.subscriptions.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

