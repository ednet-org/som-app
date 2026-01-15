//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriptions_cancellations_cancellation_id_put_request.g.dart';

/// SubscriptionsCancellationsCancellationIdPutRequest
///
/// Properties:
/// * [status] 
abstract class SubscriptionsCancellationsCancellationIdPutRequest implements Built<SubscriptionsCancellationsCancellationIdPutRequest, SubscriptionsCancellationsCancellationIdPutRequestBuilder> {
    @BuiltValueField(wireName: r'status')
    String? get status;

    SubscriptionsCancellationsCancellationIdPutRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionsCancellationsCancellationIdPutRequestBuilder b) => b;

    factory SubscriptionsCancellationsCancellationIdPutRequest([void updates(SubscriptionsCancellationsCancellationIdPutRequestBuilder b)]) = _$SubscriptionsCancellationsCancellationIdPutRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionsCancellationsCancellationIdPutRequest> get serializer => _$SubscriptionsCancellationsCancellationIdPutRequestSerializer();
}

class _$SubscriptionsCancellationsCancellationIdPutRequestSerializer implements StructuredSerializer<SubscriptionsCancellationsCancellationIdPutRequest> {
    @override
    final Iterable<Type> types = const [SubscriptionsCancellationsCancellationIdPutRequest, _$SubscriptionsCancellationsCancellationIdPutRequest];

    @override
    final String wireName = r'SubscriptionsCancellationsCancellationIdPutRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionsCancellationsCancellationIdPutRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.status != null) {
            result
                ..add(r'status')
                ..add(serializers.serialize(object.status,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    SubscriptionsCancellationsCancellationIdPutRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionsCancellationsCancellationIdPutRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'status':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.status = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

