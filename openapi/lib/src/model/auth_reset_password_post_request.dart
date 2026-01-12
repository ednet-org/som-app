//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_reset_password_post_request.g.dart';

/// AuthResetPasswordPostRequest
///
/// Properties:
/// * [email] 
/// * [token] 
/// * [password] 
/// * [confirmPassword] 
abstract class AuthResetPasswordPostRequest implements Built<AuthResetPasswordPostRequest, AuthResetPasswordPostRequestBuilder> {
    @BuiltValueField(wireName: r'email')
    String get email;

    @BuiltValueField(wireName: r'token')
    String get token;

    @BuiltValueField(wireName: r'password')
    String get password;

    @BuiltValueField(wireName: r'confirmPassword')
    String get confirmPassword;

    AuthResetPasswordPostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthResetPasswordPostRequestBuilder b) => b;

    factory AuthResetPasswordPostRequest([void updates(AuthResetPasswordPostRequestBuilder b)]) = _$AuthResetPasswordPostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthResetPasswordPostRequest> get serializer => _$AuthResetPasswordPostRequestSerializer();
}

class _$AuthResetPasswordPostRequestSerializer implements StructuredSerializer<AuthResetPasswordPostRequest> {
    @override
    final Iterable<Type> types = const [AuthResetPasswordPostRequest, _$AuthResetPasswordPostRequest];

    @override
    final String wireName = r'AuthResetPasswordPostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthResetPasswordPostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'email')
            ..add(serializers.serialize(object.email,
                specifiedType: const FullType(String)));
        result
            ..add(r'token')
            ..add(serializers.serialize(object.token,
                specifiedType: const FullType(String)));
        result
            ..add(r'password')
            ..add(serializers.serialize(object.password,
                specifiedType: const FullType(String)));
        result
            ..add(r'confirmPassword')
            ..add(serializers.serialize(object.confirmPassword,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    AuthResetPasswordPostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthResetPasswordPostRequestBuilder();

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
                case r'token':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.token = valueDes;
                    break;
                case r'password':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.password = valueDes;
                    break;
                case r'confirmPassword':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.confirmPassword = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

