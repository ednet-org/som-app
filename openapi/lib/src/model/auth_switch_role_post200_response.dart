//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_switch_role_post200_response.g.dart';

/// AuthSwitchRolePost200Response
///
/// Properties:
/// * [token] 
abstract class AuthSwitchRolePost200Response implements Built<AuthSwitchRolePost200Response, AuthSwitchRolePost200ResponseBuilder> {
    @BuiltValueField(wireName: r'token')
    String? get token;

    AuthSwitchRolePost200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthSwitchRolePost200ResponseBuilder b) => b;

    factory AuthSwitchRolePost200Response([void updates(AuthSwitchRolePost200ResponseBuilder b)]) = _$AuthSwitchRolePost200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthSwitchRolePost200Response> get serializer => _$AuthSwitchRolePost200ResponseSerializer();
}

class _$AuthSwitchRolePost200ResponseSerializer implements StructuredSerializer<AuthSwitchRolePost200Response> {
    @override
    final Iterable<Type> types = const [AuthSwitchRolePost200Response, _$AuthSwitchRolePost200Response];

    @override
    final String wireName = r'AuthSwitchRolePost200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthSwitchRolePost200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.token != null) {
            result
                ..add(r'token')
                ..add(serializers.serialize(object.token,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    AuthSwitchRolePost200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthSwitchRolePost200ResponseBuilder();

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
            }
        }
        return result.build();
    }
}

