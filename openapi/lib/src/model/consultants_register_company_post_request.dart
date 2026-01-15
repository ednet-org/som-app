//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/company_registration.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'consultants_register_company_post_request.g.dart';

/// ConsultantsRegisterCompanyPostRequest
///
/// Properties:
/// * [company] 
/// * [users] 
@BuiltValue()
abstract class ConsultantsRegisterCompanyPostRequest implements Built<ConsultantsRegisterCompanyPostRequest, ConsultantsRegisterCompanyPostRequestBuilder> {
  @BuiltValueField(wireName: r'company')
  CompanyRegistration get company;

  @BuiltValueField(wireName: r'users')
  BuiltList<UserRegistration> get users;

  ConsultantsRegisterCompanyPostRequest._();

  factory ConsultantsRegisterCompanyPostRequest([void updates(ConsultantsRegisterCompanyPostRequestBuilder b)]) = _$ConsultantsRegisterCompanyPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConsultantsRegisterCompanyPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConsultantsRegisterCompanyPostRequest> get serializer => _$ConsultantsRegisterCompanyPostRequestSerializer();
}

class _$ConsultantsRegisterCompanyPostRequestSerializer implements PrimitiveSerializer<ConsultantsRegisterCompanyPostRequest> {
  @override
  final Iterable<Type> types = const [ConsultantsRegisterCompanyPostRequest, _$ConsultantsRegisterCompanyPostRequest];

  @override
  final String wireName = r'ConsultantsRegisterCompanyPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConsultantsRegisterCompanyPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'company';
    yield serializers.serialize(
      object.company,
      specifiedType: const FullType(CompanyRegistration),
    );
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(BuiltList, [FullType(UserRegistration)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConsultantsRegisterCompanyPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConsultantsRegisterCompanyPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'company':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompanyRegistration),
          ) as CompanyRegistration;
          result.company.replace(valueDes);
          break;
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserRegistration)]),
          ) as BuiltList<UserRegistration>;
          result.users.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConsultantsRegisterCompanyPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConsultantsRegisterCompanyPostRequestBuilder();
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

