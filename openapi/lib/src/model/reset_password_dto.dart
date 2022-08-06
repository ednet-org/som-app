//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_password_dto.g.dart';

/// ResetPasswordDto
///
/// Properties:
/// * [password] 
/// * [confirmPassword] 
/// * [email] 
/// * [token] 
abstract class ResetPasswordDto implements Built<ResetPasswordDto, ResetPasswordDtoBuilder> {
    @BuiltValueField(wireName: r'password')
    String get password;

    @BuiltValueField(wireName: r'confirmPassword')
    String? get confirmPassword;

    @BuiltValueField(wireName: r'email')
    String? get email;

    @BuiltValueField(wireName: r'token')
    String? get token;

    ResetPasswordDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ResetPasswordDtoBuilder b) => b;

    factory ResetPasswordDto([void updates(ResetPasswordDtoBuilder b)]) = _$ResetPasswordDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<ResetPasswordDto> get serializer => _$ResetPasswordDtoSerializer();
}

class _$ResetPasswordDtoSerializer implements StructuredSerializer<ResetPasswordDto> {
    @override
    final Iterable<Type> types = const [ResetPasswordDto, _$ResetPasswordDto];

    @override
    final String wireName = r'ResetPasswordDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, ResetPasswordDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'password')
            ..add(serializers.serialize(object.password,
                specifiedType: const FullType(String)));
        if (object.confirmPassword != null) {
            result
                ..add(r'confirmPassword')
                ..add(serializers.serialize(object.confirmPassword,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.email != null) {
            result
                ..add(r'email')
                ..add(serializers.serialize(object.email,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.token != null) {
            result
                ..add(r'token')
                ..add(serializers.serialize(object.token,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    ResetPasswordDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ResetPasswordDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'password':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.password = valueDes;
                    break;
                case r'confirmPassword':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.confirmPassword = valueDes;
                    break;
                case r'email':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.email = valueDes;
                    break;
                case r'token':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.token = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

