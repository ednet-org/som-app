//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_registration.g.dart';

/// UserRegistration
///
/// Properties:
/// * [email] 
/// * [firstName] 
/// * [lastName] 
/// * [salutation] 
/// * [title] 
/// * [telephoneNr] 
/// * [roles] - 0=buyer,1=provider,2=buyer(default),3=consultant,4=admin
abstract class UserRegistration implements Built<UserRegistration, UserRegistrationBuilder> {
    @BuiltValueField(wireName: r'email')
    String get email;

    @BuiltValueField(wireName: r'firstName')
    String get firstName;

    @BuiltValueField(wireName: r'lastName')
    String get lastName;

    @BuiltValueField(wireName: r'salutation')
    String get salutation;

    @BuiltValueField(wireName: r'title')
    String? get title;

    @BuiltValueField(wireName: r'telephoneNr')
    String? get telephoneNr;

    /// 0=buyer,1=provider,2=buyer(default),3=consultant,4=admin
    @BuiltValueField(wireName: r'roles')
    BuiltList<UserRegistrationRolesEnum> get roles;
    // enum rolesEnum {  0,  1,  2,  3,  4,  };

    UserRegistration._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(UserRegistrationBuilder b) => b;

    factory UserRegistration([void updates(UserRegistrationBuilder b)]) = _$UserRegistration;

    @BuiltValueSerializer(custom: true)
    static Serializer<UserRegistration> get serializer => _$UserRegistrationSerializer();
}

class _$UserRegistrationSerializer implements StructuredSerializer<UserRegistration> {
    @override
    final Iterable<Type> types = const [UserRegistration, _$UserRegistration];

    @override
    final String wireName = r'UserRegistration';

    @override
    Iterable<Object?> serialize(Serializers serializers, UserRegistration object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'email')
            ..add(serializers.serialize(object.email,
                specifiedType: const FullType(String)));
        result
            ..add(r'firstName')
            ..add(serializers.serialize(object.firstName,
                specifiedType: const FullType(String)));
        result
            ..add(r'lastName')
            ..add(serializers.serialize(object.lastName,
                specifiedType: const FullType(String)));
        result
            ..add(r'salutation')
            ..add(serializers.serialize(object.salutation,
                specifiedType: const FullType(String)));
        if (object.title != null) {
            result
                ..add(r'title')
                ..add(serializers.serialize(object.title,
                    specifiedType: const FullType(String)));
        }
        if (object.telephoneNr != null) {
            result
                ..add(r'telephoneNr')
                ..add(serializers.serialize(object.telephoneNr,
                    specifiedType: const FullType(String)));
        }
        result
            ..add(r'roles')
            ..add(serializers.serialize(object.roles,
                specifiedType: const FullType(BuiltList, [FullType(UserRegistrationRolesEnum)])));
        return result;
    }

    @override
    UserRegistration deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = UserRegistrationBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'email':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.email = valueDes;
                    break;
                case r'firstName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.firstName = valueDes;
                    break;
                case r'lastName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.lastName = valueDes;
                    break;
                case r'salutation':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.salutation = valueDes;
                    break;
                case r'title':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.title = valueDes;
                    break;
                case r'telephoneNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.telephoneNr = valueDes;
                    break;
                case r'roles':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(UserRegistrationRolesEnum)])) as BuiltList<UserRegistrationRolesEnum>;
                    result.roles.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

class UserRegistrationRolesEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const UserRegistrationRolesEnum number0 = _$userRegistrationRolesEnum_number0;
  @BuiltValueEnumConst(wireNumber: 1)
  static const UserRegistrationRolesEnum number1 = _$userRegistrationRolesEnum_number1;
  @BuiltValueEnumConst(wireNumber: 2)
  static const UserRegistrationRolesEnum number2 = _$userRegistrationRolesEnum_number2;
  @BuiltValueEnumConst(wireNumber: 3)
  static const UserRegistrationRolesEnum number3 = _$userRegistrationRolesEnum_number3;
  @BuiltValueEnumConst(wireNumber: 4)
  static const UserRegistrationRolesEnum number4 = _$userRegistrationRolesEnum_number4;

  static Serializer<UserRegistrationRolesEnum> get serializer => _$userRegistrationRolesEnumSerializer;

  const UserRegistrationRolesEnum._(String name): super(name);

  static BuiltSet<UserRegistrationRolesEnum> get values => _$userRegistrationRolesEnumValues;
  static UserRegistrationRolesEnum valueOf(String name) => _$userRegistrationRolesEnumValueOf(name);
}

