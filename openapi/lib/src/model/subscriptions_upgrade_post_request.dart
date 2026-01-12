//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_upgrade_post_request.g.dart';

/// SubscriptionsUpgradePostRequest
///
/// Properties:
/// * [planId] 
abstract class SubscriptionsUpgradePostRequest implements Built<SubscriptionsUpgradePostRequest, SubscriptionsUpgradePostRequestBuilder> {
    @BuiltValueField(wireName: r'planId')
    String get planId;

    SubscriptionsUpgradePostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionsUpgradePostRequestBuilder b) => b;

    factory SubscriptionsUpgradePostRequest([void updates(SubscriptionsUpgradePostRequestBuilder b)]) = _$SubscriptionsUpgradePostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionsUpgradePostRequest> get serializer => _$SubscriptionsUpgradePostRequestSerializer();
}

class _$SubscriptionsUpgradePostRequestSerializer implements StructuredSerializer<SubscriptionsUpgradePostRequest> {
    @override
    final Iterable<Type> types = const [SubscriptionsUpgradePostRequest, _$SubscriptionsUpgradePostRequest];

    @override
    final String wireName = r'SubscriptionsUpgradePostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionsUpgradePostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'planId')
            ..add(serializers.serialize(object.planId,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    SubscriptionsUpgradePostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionsUpgradePostRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'planId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.planId = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

