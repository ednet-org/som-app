//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_forgot_password_post_request.g.dart';

/// AuthForgotPasswordPostRequest
///
/// Properties:
/// * [email] 
abstract class AuthForgotPasswordPostRequest implements Built<AuthForgotPasswordPostRequest, AuthForgotPasswordPostRequestBuilder> {
    @BuiltValueField(wireName: r'email')
    String get email;

    AuthForgotPasswordPostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthForgotPasswordPostRequestBuilder b) => b;

    factory AuthForgotPasswordPostRequest([void updates(AuthForgotPasswordPostRequestBuilder b)]) = _$AuthForgotPasswordPostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthForgotPasswordPostRequest> get serializer => _$AuthForgotPasswordPostRequestSerializer();
}

class _$AuthForgotPasswordPostRequestSerializer implements StructuredSerializer<AuthForgotPasswordPostRequest> {
    @override
    final Iterable<Type> types = const [AuthForgotPasswordPostRequest, _$AuthForgotPasswordPostRequest];

    @override
    final String wireName = r'AuthForgotPasswordPostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthForgotPasswordPostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'email')
            ..add(serializers.serialize(object.email,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    AuthForgotPasswordPostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthForgotPasswordPostRequestBuilder();

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
            }
        }
        return result.build();
    }
}

