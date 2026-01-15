//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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
/// * [providerType] 
@BuiltValue()
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

  @BuiltValueField(wireName: r'providerType')
  String? get providerType;

  ProviderRegistrationData._();

  factory ProviderRegistrationData([void updates(ProviderRegistrationDataBuilder b)]) = _$ProviderRegistrationData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderRegistrationDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderRegistrationData> get serializer => _$ProviderRegistrationDataSerializer();
}

class _$ProviderRegistrationDataSerializer implements PrimitiveSerializer<ProviderRegistrationData> {
  @override
  final Iterable<Type> types = const [ProviderRegistrationData, _$ProviderRegistrationData];

  @override
  final String wireName = r'ProviderRegistrationData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderRegistrationData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bankDetails != null) {
      yield r'bankDetails';
      yield serializers.serialize(
        object.bankDetails,
        specifiedType: const FullType(BankDetails),
      );
    }
    if (object.branchIds != null) {
      yield r'branchIds';
      yield serializers.serialize(
        object.branchIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.subscriptionPlanId != null) {
      yield r'subscriptionPlanId';
      yield serializers.serialize(
        object.subscriptionPlanId,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentInterval != null) {
      yield r'paymentInterval';
      yield serializers.serialize(
        object.paymentInterval,
        specifiedType: const FullType(ProviderRegistrationDataPaymentIntervalEnum),
      );
    }
    if (object.providerType != null) {
      yield r'providerType';
      yield serializers.serialize(
        object.providerType,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProviderRegistrationData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderRegistrationDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bankDetails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BankDetails),
          ) as BankDetails;
          result.bankDetails.replace(valueDes);
          break;
        case r'branchIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.branchIds.replace(valueDes);
          break;
        case r'subscriptionPlanId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subscriptionPlanId = valueDes;
          break;
        case r'paymentInterval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderRegistrationDataPaymentIntervalEnum),
          ) as ProviderRegistrationDataPaymentIntervalEnum;
          result.paymentInterval = valueDes;
          break;
        case r'providerType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProviderRegistrationData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderRegistrationDataBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
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

