//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/address.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'users_load_user_with_company_get200_response.g.dart';

/// UsersLoadUserWithCompanyGet200Response
///
/// Properties:
/// * [userId] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephoneNr] 
/// * [emailAddress] 
/// * [roles] 
/// * [activeRole] 
/// * [companyId] 
/// * [companyName] 
/// * [companyAddress] 
/// * [companyType] - 0=buyer, 1=provider, 2=buyer+provider
@BuiltValue()
abstract class UsersLoadUserWithCompanyGet200Response implements Built<UsersLoadUserWithCompanyGet200Response, UsersLoadUserWithCompanyGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  @BuiltValueField(wireName: r'salutation')
  String? get salutation;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'firstName')
  String? get firstName;

  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  @BuiltValueField(wireName: r'telephoneNr')
  String? get telephoneNr;

  @BuiltValueField(wireName: r'emailAddress')
  String? get emailAddress;

  @BuiltValueField(wireName: r'roles')
  BuiltList<String>? get roles;

  @BuiltValueField(wireName: r'activeRole')
  String? get activeRole;

  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'companyName')
  String? get companyName;

  @BuiltValueField(wireName: r'companyAddress')
  Address? get companyAddress;

  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueField(wireName: r'companyType')
  UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? get companyType;
  // enum companyTypeEnum {  0,  1,  2,  };

  UsersLoadUserWithCompanyGet200Response._();

  factory UsersLoadUserWithCompanyGet200Response([void updates(UsersLoadUserWithCompanyGet200ResponseBuilder b)]) = _$UsersLoadUserWithCompanyGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsersLoadUserWithCompanyGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsersLoadUserWithCompanyGet200Response> get serializer => _$UsersLoadUserWithCompanyGet200ResponseSerializer();
}

class _$UsersLoadUserWithCompanyGet200ResponseSerializer implements PrimitiveSerializer<UsersLoadUserWithCompanyGet200Response> {
  @override
  final Iterable<Type> types = const [UsersLoadUserWithCompanyGet200Response, _$UsersLoadUserWithCompanyGet200Response];

  @override
  final String wireName = r'UsersLoadUserWithCompanyGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsersLoadUserWithCompanyGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    if (object.salutation != null) {
      yield r'salutation';
      yield serializers.serialize(
        object.salutation,
        specifiedType: const FullType(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.firstName != null) {
      yield r'firstName';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastName != null) {
      yield r'lastName';
      yield serializers.serialize(
        object.lastName,
        specifiedType: const FullType(String),
      );
    }
    if (object.telephoneNr != null) {
      yield r'telephoneNr';
      yield serializers.serialize(
        object.telephoneNr,
        specifiedType: const FullType(String),
      );
    }
    if (object.emailAddress != null) {
      yield r'emailAddress';
      yield serializers.serialize(
        object.emailAddress,
        specifiedType: const FullType(String),
      );
    }
    if (object.roles != null) {
      yield r'roles';
      yield serializers.serialize(
        object.roles,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.activeRole != null) {
      yield r'activeRole';
      yield serializers.serialize(
        object.activeRole,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyName != null) {
      yield r'companyName';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyAddress != null) {
      yield r'companyAddress';
      yield serializers.serialize(
        object.companyAddress,
        specifiedType: const FullType(Address),
      );
    }
    if (object.companyType != null) {
      yield r'companyType';
      yield serializers.serialize(
        object.companyType,
        specifiedType: const FullType(UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UsersLoadUserWithCompanyGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsersLoadUserWithCompanyGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'salutation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salutation = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'telephoneNr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.telephoneNr = valueDes;
          break;
        case r'emailAddress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emailAddress = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.roles.replace(valueDes);
          break;
        case r'activeRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.activeRole = valueDes;
          break;
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'companyAddress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Address),
          ) as Address;
          result.companyAddress.replace(valueDes);
          break;
        case r'companyType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum),
          ) as UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum;
          result.companyType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsersLoadUserWithCompanyGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsersLoadUserWithCompanyGet200ResponseBuilder();
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

class UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum extends EnumClass {

  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 0)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum number0 = _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number0;
  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 1)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum number1 = _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number1;
  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 2)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum number2 = _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnum_number2;

  static Serializer<UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum> get serializer => _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumSerializer;

  const UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum._(String name): super(name);

  static BuiltSet<UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum> get values => _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumValues;
  static UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum valueOf(String name) => _$usersLoadUserWithCompanyGet200ResponseCompanyTypeEnumValueOf(name);
}

