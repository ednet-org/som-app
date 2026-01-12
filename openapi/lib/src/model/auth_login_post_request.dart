//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_login_post_request.g.dart';

/// AuthLoginPostRequest
///
/// Properties:
/// * [email] 
/// * [password] 
abstract class AuthLoginPostRequest implements Built<AuthLoginPostRequest, AuthLoginPostRequestBuilder> {
    @BuiltValueField(wireName: r'email')
    String get email;

    @BuiltValueField(wireName: r'password')
    String get password;

    AuthLoginPostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthLoginPostRequestBuilder b) => b;

    factory AuthLoginPostRequest([void updates(AuthLoginPostRequestBuilder b)]) = _$AuthLoginPostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthLoginPostRequest> get serializer => _$AuthLoginPostRequestSerializer();
}

class _$AuthLoginPostRequestSerializer implements StructuredSerializer<AuthLoginPostRequest> {
    @override
    final Iterable<Type> types = const [AuthLoginPostRequest, _$AuthLoginPostRequest];

    @override
    final String wireName = r'AuthLoginPostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthLoginPostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'email')
            ..add(serializers.serialize(object.email,
                specifiedType: const FullType(String)));
        result
            ..add(r'password')
            ..add(serializers.serialize(object.password,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    AuthLoginPostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthLoginPostRequestBuilder();

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
                case r'password':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.password = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

