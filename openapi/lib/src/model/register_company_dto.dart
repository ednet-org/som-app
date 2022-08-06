//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/create_company_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_company_dto.g.dart';

/// RegisterCompanyDto
///
/// Properties:
/// * [company] 
/// * [users] 
abstract class RegisterCompanyDto implements Built<RegisterCompanyDto, RegisterCompanyDtoBuilder> {
    @BuiltValueField(wireName: r'company')
    CreateCompanyDto? get company;

    @BuiltValueField(wireName: r'users')
    BuiltList<UserDto>? get users;

    RegisterCompanyDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(RegisterCompanyDtoBuilder b) => b;

    factory RegisterCompanyDto([void updates(RegisterCompanyDtoBuilder b)]) = _$RegisterCompanyDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<RegisterCompanyDto> get serializer => _$RegisterCompanyDtoSerializer();
}

class _$RegisterCompanyDtoSerializer implements StructuredSerializer<RegisterCompanyDto> {
    @override
    final Iterable<Type> types = const [RegisterCompanyDto, _$RegisterCompanyDto];

    @override
    final String wireName = r'RegisterCompanyDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, RegisterCompanyDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.company != null) {
            result
                ..add(r'company')
                ..add(serializers.serialize(object.company,
                    specifiedType: const FullType(CreateCompanyDto)));
        }
        if (object.users != null) {
            result
                ..add(r'users')
                ..add(serializers.serialize(object.users,
                    specifiedType: const FullType.nullable(BuiltList, [FullType(UserDto)])));
        }
        return result;
    }

    @override
    RegisterCompanyDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = RegisterCompanyDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'company':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(CreateCompanyDto)) as CreateCompanyDto;
                    result.company.replace(valueDes);
                    break;
                case r'users':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(BuiltList, [FullType(UserDto)])) as BuiltList<UserDto>?;
                    if (valueDes == null) continue;
                    result.users.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

