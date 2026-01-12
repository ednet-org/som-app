//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_switch_role_post_request.g.dart';

/// AuthSwitchRolePostRequest
///
/// Properties:
/// * [role] 
abstract class AuthSwitchRolePostRequest implements Built<AuthSwitchRolePostRequest, AuthSwitchRolePostRequestBuilder> {
    @BuiltValueField(wireName: r'role')
    String get role;

    AuthSwitchRolePostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AuthSwitchRolePostRequestBuilder b) => b;

    factory AuthSwitchRolePostRequest([void updates(AuthSwitchRolePostRequestBuilder b)]) = _$AuthSwitchRolePostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<AuthSwitchRolePostRequest> get serializer => _$AuthSwitchRolePostRequestSerializer();
}

class _$AuthSwitchRolePostRequestSerializer implements StructuredSerializer<AuthSwitchRolePostRequest> {
    @override
    final Iterable<Type> types = const [AuthSwitchRolePostRequest, _$AuthSwitchRolePostRequest];

    @override
    final String wireName = r'AuthSwitchRolePostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, AuthSwitchRolePostRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'role')
            ..add(serializers.serialize(object.role,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    AuthSwitchRolePostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AuthSwitchRolePostRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'role':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.role = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

