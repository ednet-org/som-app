//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_login_post200_response.g.dart';

/// AuthLoginPost200Response
///
/// Properties:
/// * [token] 
/// * [refreshToken] 
abstract class AuthLoginPost200Response implements Built<AuthLoginPost200Response, AuthLoginPost200ResponseBuilder> {
    @BuiltValueField(wireName: r'token')
    String? get token;

    @BuiltValueField(wireName: r'refreshToken')
    String? get refreshToken;

    AuthLoginPost200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthLoginPost200ResponseBuilder b) => b;

    factory AuthLoginPost200Response([void updates(AuthLoginPost200ResponseBuilder b)]) = _$AuthLoginPost200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthLoginPost200Response> get serializer => _$AuthLoginPost200ResponseSerializer();
}

class _$AuthLoginPost200ResponseSerializer implements StructuredSerializer<AuthLoginPost200Response> {
    @override
    final Iterable<Type> types = const [AuthLoginPost200Response, _$AuthLoginPost200Response];

    @override
    final String wireName = r'AuthLoginPost200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthLoginPost200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.token != null) {
            result
                ..add(r'token')
                ..add(serializers.serialize(object.token,
                    specifiedType: const FullType(String)));
        }
        if (object.refreshToken != null) {
            result
                ..add(r'refreshToken')
                ..add(serializers.serialize(object.refreshToken,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    AuthLoginPost200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthLoginPost200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'token':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.token = valueDes;
                    break;
                case r'refreshToken':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.refreshToken = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

