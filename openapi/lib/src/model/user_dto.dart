//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_dto.g.dart';

/// UserDto
///
/// Properties:
/// * [id] 
/// * [companyId] 
/// * [email] 
/// * [firstName] 
/// * [lastName] 
/// * [salutation] 
/// * [title] 
/// * [telephoneNr] 
/// * [roles] 
abstract class UserDto implements Built<UserDto, UserDtoBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'companyId')
    String? get companyId;

    @BuiltValueField(wireName: r'email')
    String? get email;

    @BuiltValueField(wireName: r'firstName')
    String? get firstName;

    @BuiltValueField(wireName: r'lastName')
    String? get lastName;

    @BuiltValueField(wireName: r'salutation')
    String? get salutation;

    @BuiltValueField(wireName: r'title')
    String? get title;

    @BuiltValueField(wireName: r'telephoneNr')
    String? get telephoneNr;

    @BuiltValueField(wireName: r'roles')
    BuiltList<int>? get roles;

    UserDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(UserDtoBuilder b) => b;

    factory UserDto([void updates(UserDtoBuilder b)]) = _$UserDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<UserDto> get serializer => _$UserDtoSerializer();
}

class _$UserDtoSerializer implements StructuredSerializer<UserDto> {
    @override
    final Iterable<Type> types = const [UserDto, _$UserDto];

    @override
    final String wireName = r'UserDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, UserDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.companyId != null) {
            result
                ..add(r'companyId')
                ..add(serializers.serialize(object.companyId,
                    specifiedType: const FullType(String)));
        }
        if (object.email != null) {
            result
                ..add(r'email')
                ..add(serializers.serialize(object.email,
                    specifiedType: const FullType(String)));
        }
        if (object.firstName != null) {
            result
                ..add(r'firstName')
                ..add(serializers.serialize(object.firstName,
                    specifiedType: const FullType(String)));
        }
        if (object.lastName != null) {
            result
                ..add(r'lastName')
                ..add(serializers.serialize(object.lastName,
                    specifiedType: const FullType(String)));
        }
        if (object.salutation != null) {
            result
                ..add(r'salutation')
                ..add(serializers.serialize(object.salutation,
                    specifiedType: const FullType(String)));
        }
        if (object.title != null) {
            result
                ..add(r'title')
                ..add(serializers.serialize(object.title,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.telephoneNr != null) {
            result
                ..add(r'telephoneNr')
                ..add(serializers.serialize(object.telephoneNr,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.roles != null) {
            result
                ..add(r'roles')
                ..add(serializers.serialize(object.roles,
                    specifiedType: const FullType(BuiltList, [FullType(int)])));
        }
        return result;
    }

    @override
    UserDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = UserDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'id':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.id = valueDes;
                    break;
                case r'companyId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companyId = valueDes;
                    break;
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
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.title = valueDes;
                    break;
                case r'telephoneNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.telephoneNr = valueDes;
                    break;
                case r'roles':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(int)])) as BuiltList<int>;
                    result.roles.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

