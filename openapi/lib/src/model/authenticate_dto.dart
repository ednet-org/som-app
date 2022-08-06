//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'authenticate_dto.g.dart';

/// AuthenticateDto
///
/// Properties:
/// * [email] 
/// * [password] 
abstract class AuthenticateDto implements Built<AuthenticateDto, AuthenticateDtoBuilder> {
    @BuiltValueField(wireName: r'email')
    String? get email;

    @BuiltValueField(wireName: r'password')
    String? get password;

    AuthenticateDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthenticateDtoBuilder b) => b;

    factory AuthenticateDto([void updates(AuthenticateDtoBuilder b)]) = _$AuthenticateDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthenticateDto> get serializer => _$AuthenticateDtoSerializer();
}

class _$AuthenticateDtoSerializer implements StructuredSerializer<AuthenticateDto> {
    @override
    final Iterable<Type> types = const [AuthenticateDto, _$AuthenticateDto];

    @override
    final String wireName = r'AuthenticateDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthenticateDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.email != null) {
            result
                ..add(r'email')
                ..add(serializers.serialize(object.email,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.password != null) {
            result
                ..add(r'password')
                ..add(serializers.serialize(object.password,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    AuthenticateDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthenticateDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'email':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.email = valueDes;
                    break;
                case r'password':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.password = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

