//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/bank_details.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'providers_company_id_payment_details_put200_response.g.dart';

/// ProvidersCompanyIdPaymentDetailsPut200Response
///
/// Properties:
/// * [companyId] 
/// * [bankDetails] 
@BuiltValue()
abstract class ProvidersCompanyIdPaymentDetailsPut200Response implements Built<ProvidersCompanyIdPaymentDetailsPut200Response, ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'bankDetails')
  BankDetails? get bankDetails;

  ProvidersCompanyIdPaymentDetailsPut200Response._();

  factory ProvidersCompanyIdPaymentDetailsPut200Response([void updates(ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder b)]) = _$ProvidersCompanyIdPaymentDetailsPut200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProvidersCompanyIdPaymentDetailsPut200Response> get serializer => _$ProvidersCompanyIdPaymentDetailsPut200ResponseSerializer();
}

class _$ProvidersCompanyIdPaymentDetailsPut200ResponseSerializer implements PrimitiveSerializer<ProvidersCompanyIdPaymentDetailsPut200Response> {
  @override
  final Iterable<Type> types = const [ProvidersCompanyIdPaymentDetailsPut200Response, _$ProvidersCompanyIdPaymentDetailsPut200Response];

  @override
  final String wireName = r'ProvidersCompanyIdPaymentDetailsPut200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProvidersCompanyIdPaymentDetailsPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.bankDetails != null) {
      yield r'bankDetails';
      yield serializers.serialize(
        object.bankDetails,
        specifiedType: const FullType(BankDetails),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProvidersCompanyIdPaymentDetailsPut200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'bankDetails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BankDetails),
          ) as BankDetails;
          result.bankDetails.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProvidersCompanyIdPaymentDetailsPut200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder();
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

