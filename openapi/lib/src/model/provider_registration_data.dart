//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/bank_details.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_registration_data.g.dart';

/// ProviderRegistrationData
///
/// Properties:
/// * [bankDetails] 
/// * [branchIds] 
/// * [subscriptionPlanId] 
/// * [paymentInterval] - 0 = monthly, 1 = yearly
abstract class ProviderRegistrationData implements Built<ProviderRegistrationData, ProviderRegistrationDataBuilder> {
    @BuiltValueField(wireName: r'bankDetails')
    BankDetails? get bankDetails;

    @BuiltValueField(wireName: r'branchIds')
    BuiltList<String>? get branchIds;

    @BuiltValueField(wireName: r'subscriptionPlanId')
    String? get subscriptionPlanId;

    /// 0 = monthly, 1 = yearly
    @BuiltValueField(wireName: r'paymentInterval')
    ProviderRegistrationDataPaymentIntervalEnum? get paymentInterval;
    // enum paymentIntervalEnum {  0,  1,  };

    ProviderRegistrationData._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ProviderRegistrationDataBuilder b) => b;

    factory ProviderRegistrationData([void updates(ProviderRegistrationDataBuilder b)]) = _$ProviderRegistrationData;

    @BuiltValueSerializer(custom: true)
    static Serializer<ProviderRegistrationData> get serializer => _$ProviderRegistrationDataSerializer();
}

class _$ProviderRegistrationDataSerializer implements StructuredSerializer<ProviderRegistrationData> {
    @override
    final Iterable<Type> types = const [ProviderRegistrationData, _$ProviderRegistrationData];

    @override
    final String wireName = r'ProviderRegistrationData';

    @override
    Iterable<Object?> serialize(Serializers serializers, ProviderRegistrationData object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.bankDetails != null) {
            result
                ..add(r'bankDetails')
                ..add(serializers.serialize(object.bankDetails,
                    specifiedType: const FullType(BankDetails)));
        }
        if (object.branchIds != null) {
            result
                ..add(r'branchIds')
                ..add(serializers.serialize(object.branchIds,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        if (object.subscriptionPlanId != null) {
            result
                ..add(r'subscriptionPlanId')
                ..add(serializers.serialize(object.subscriptionPlanId,
                    specifiedType: const FullType(String)));
        }
        if (object.paymentInterval != null) {
            result
                ..add(r'paymentInterval')
                ..add(serializers.serialize(object.paymentInterval,
                    specifiedType: const FullType(ProviderRegistrationDataPaymentIntervalEnum)));
        }
        return result;
    }

    @override
    ProviderRegistrationData deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ProviderRegistrationDataBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'bankDetails':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BankDetails)) as BankDetails;
                    result.bankDetails.replace(valueDes);
                    break;
                case r'branchIds':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.branchIds.replace(valueDes);
                    break;
                case r'subscriptionPlanId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.subscriptionPlanId = valueDes;
                    break;
                case r'paymentInterval':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(ProviderRegistrationDataPaymentIntervalEnum)) as ProviderRegistrationDataPaymentIntervalEnum;
                    result.paymentInterval = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

class ProviderRegistrationDataPaymentIntervalEnum extends EnumClass {

  /// 0 = monthly, 1 = yearly
  @BuiltValueEnumConst(wireNumber: 0)
  static const ProviderRegistrationDataPaymentIntervalEnum number0 = _$providerRegistrationDataPaymentIntervalEnum_number0;
  /// 0 = monthly, 1 = yearly
  @BuiltValueEnumConst(wireNumber: 1)
  static const ProviderRegistrationDataPaymentIntervalEnum number1 = _$providerRegistrationDataPaymentIntervalEnum_number1;

  static Serializer<ProviderRegistrationDataPaymentIntervalEnum> get serializer => _$providerRegistrationDataPaymentIntervalEnumSerializer;

  const ProviderRegistrationDataPaymentIntervalEnum._(String name): super(name);

  static BuiltSet<ProviderRegistrationDataPaymentIntervalEnum> get values => _$providerRegistrationDataPaymentIntervalEnumValues;
  static ProviderRegistrationDataPaymentIntervalEnum valueOf(String name) => _$providerRegistrationDataPaymentIntervalEnumValueOf(name);
}

