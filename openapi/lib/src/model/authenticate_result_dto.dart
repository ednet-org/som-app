//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'authenticate_result_dto.g.dart';

/// AuthenticateResultDto
///
/// Properties:
/// * [token] 
/// * [refreshToken] 
abstract class AuthenticateResultDto implements Built<AuthenticateResultDto, AuthenticateResultDtoBuilder> {
    @BuiltValueField(wireName: r'token')
    String? get token;

    @BuiltValueField(wireName: r'refreshToken')
    String? get refreshToken;

    AuthenticateResultDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthenticateResultDtoBuilder b) => b;

    factory AuthenticateResultDto([void updates(AuthenticateResultDtoBuilder b)]) = _$AuthenticateResultDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthenticateResultDto> get serializer => _$AuthenticateResultDtoSerializer();
}

class _$AuthenticateResultDtoSerializer implements StructuredSerializer<AuthenticateResultDto> {
    @override
    final Iterable<Type> types = const [AuthenticateResultDto, _$AuthenticateResultDto];

    @override
    final String wireName = r'AuthenticateResultDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthenticateResultDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.token != null) {
            result
                ..add(r'token')
                ..add(serializers.serialize(object.token,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.refreshToken != null) {
            result
                ..add(r'refreshToken')
                ..add(serializers.serialize(object.refreshToken,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    AuthenticateResultDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthenticateResultDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'token':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.token = valueDes;
                    break;
                case r'refreshToken':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.refreshToken = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

