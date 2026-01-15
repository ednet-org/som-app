//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_switch_role_post_request.g.dart';

/// AuthSwitchRolePostRequest
///
/// Properties:
/// * [role] 
@BuiltValue()
abstract class AuthSwitchRolePostRequest implements Built<AuthSwitchRolePostRequest, AuthSwitchRolePostRequestBuilder> {
  @BuiltValueField(wireName: r'role')
  String get role;

  AuthSwitchRolePostRequest._();

  factory AuthSwitchRolePostRequest([void updates(AuthSwitchRolePostRequestBuilder b)]) = _$AuthSwitchRolePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthSwitchRolePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthSwitchRolePostRequest> get serializer => _$AuthSwitchRolePostRequestSerializer();
}

class _$AuthSwitchRolePostRequestSerializer implements PrimitiveSerializer<AuthSwitchRolePostRequest> {
  @override
  final Iterable<Type> types = const [AuthSwitchRolePostRequest, _$AuthSwitchRolePostRequest];

  @override
  final String wireName = r'AuthSwitchRolePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthSwitchRolePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthSwitchRolePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthSwitchRolePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthSwitchRolePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthSwitchRolePostRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

