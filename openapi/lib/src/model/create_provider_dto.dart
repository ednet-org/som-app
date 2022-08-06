//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/bank_details_dto.dart';
import 'package:openapi/src/model/payment_interval.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_provider_dto.g.dart';

/// CreateProviderDto
///
/// Properties:
/// * [bankDetails] 
/// * [branchIds] 
/// * [paymentInterval] 
/// * [subscriptionPlanId] 
abstract class CreateProviderDto implements Built<CreateProviderDto, CreateProviderDtoBuilder> {
    @BuiltValueField(wireName: r'bankDetails')
    BankDetailsDto? get bankDetails;

    @BuiltValueField(wireName: r'branchIds')
    BuiltList<String>? get branchIds;

    @BuiltValueField(wireName: r'paymentInterval')
    PaymentInterval? get paymentInterval;
    // enum paymentIntervalEnum {  0,  1,  };

    @BuiltValueField(wireName: r'subscriptionPlanId')
    String? get subscriptionPlanId;

    CreateProviderDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CreateProviderDtoBuilder b) => b;

    factory CreateProviderDto([void updates(CreateProviderDtoBuilder b)]) = _$CreateProviderDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<CreateProviderDto> get serializer => _$CreateProviderDtoSerializer();
}

class _$CreateProviderDtoSerializer implements StructuredSerializer<CreateProviderDto> {
    @override
    final Iterable<Type> types = const [CreateProviderDto, _$CreateProviderDto];

    @override
    final String wireName = r'CreateProviderDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, CreateProviderDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.bankDetails != null) {
            result
                ..add(r'bankDetails')
                ..add(serializers.serialize(object.bankDetails,
                    specifiedType: const FullType(BankDetailsDto)));
        }
        if (object.branchIds != null) {
            result
                ..add(r'branchIds')
                ..add(serializers.serialize(object.branchIds,
                    specifiedType: const FullType.nullable(BuiltList, [FullType(String)])));
        }
        if (object.paymentInterval != null) {
            result
                ..add(r'paymentInterval')
                ..add(serializers.serialize(object.paymentInterval,
                    specifiedType: const FullType(PaymentInterval)));
        }
        if (object.subscriptionPlanId != null) {
            result
                ..add(r'subscriptionPlanId')
                ..add(serializers.serialize(object.subscriptionPlanId,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    CreateProviderDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CreateProviderDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'bankDetails':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BankDetailsDto)) as BankDetailsDto;
                    result.bankDetails.replace(valueDes);
                    break;
                case r'branchIds':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(BuiltList, [FullType(String)])) as BuiltList<String>?;
                    if (valueDes == null) continue;
                    result.branchIds.replace(valueDes);
                    break;
                case r'paymentInterval':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(PaymentInterval)) as PaymentInterval;
                    result.paymentInterval = valueDes;
                    break;
                case r'subscriptionPlanId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.subscriptionPlanId = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

