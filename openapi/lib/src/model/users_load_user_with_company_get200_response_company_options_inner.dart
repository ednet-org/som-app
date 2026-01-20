//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'users_load_user_with_company_get200_response_company_options_inner.g.dart';

/// UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner
///
/// Properties:
/// * [companyId] 
/// * [companyName] 
/// * [companyType] 
/// * [roles] 
/// * [activeRole] 
@BuiltValue()
abstract class UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner implements Built<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner, UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'companyName')
  String? get companyName;

  @BuiltValueField(wireName: r'companyType')
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum? get companyType;
  // enum companyTypeEnum {  0,  1,  2,  };

  @BuiltValueField(wireName: r'roles')
  BuiltList<String>? get roles;

  @BuiltValueField(wireName: r'activeRole')
  String? get activeRole;

  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner._();

  factory UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner([void updates(UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder b)]) = _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner> get serializer => _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerSerializer();
}

class _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerSerializer implements PrimitiveSerializer<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner> {
  @override
  final Iterable<Type> types = const [UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner, _$UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner];

  @override
  final String wireName = r'UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.companyType != null) {
      yield r'companyType';
      yield serializers.serialize(
        object.companyType,
        specifiedType: const FullType(UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder result,
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
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'companyType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum),
          ) as UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum;
          result.companyType = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerBuilder();
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

class UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum number0 = _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number0;
  @BuiltValueEnumConst(wireNumber: 1)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum number1 = _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number1;
  @BuiltValueEnumConst(wireNumber: 2)
  static const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum number2 = _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum_number2;

  static Serializer<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum> get serializer => _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumSerializer;

  const UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum._(String name): super(name);

  static BuiltSet<UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum> get values => _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumValues;
  static UsersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnum valueOf(String name) => _$usersLoadUserWithCompanyGet200ResponseCompanyOptionsInnerCompanyTypeEnumValueOf(name);
}

