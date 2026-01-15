//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/company_registration.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_company_request.g.dart';

/// RegisterCompanyRequest
///
/// Properties:
/// * [company] 
/// * [users] 
@BuiltValue()
abstract class RegisterCompanyRequest implements Built<RegisterCompanyRequest, RegisterCompanyRequestBuilder> {
  @BuiltValueField(wireName: r'company')
  CompanyRegistration get company;

  @BuiltValueField(wireName: r'users')
  BuiltList<UserRegistration> get users;

  RegisterCompanyRequest._();

  factory RegisterCompanyRequest([void updates(RegisterCompanyRequestBuilder b)]) = _$RegisterCompanyRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterCompanyRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterCompanyRequest> get serializer => _$RegisterCompanyRequestSerializer();
}

class _$RegisterCompanyRequestSerializer implements PrimitiveSerializer<RegisterCompanyRequest> {
  @override
  final Iterable<Type> types = const [RegisterCompanyRequest, _$RegisterCompanyRequest];

  @override
  final String wireName = r'RegisterCompanyRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterCompanyRequest object, {
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
    RegisterCompanyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterCompanyRequestBuilder result,
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
  RegisterCompanyRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterCompanyRequestBuilder();
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

