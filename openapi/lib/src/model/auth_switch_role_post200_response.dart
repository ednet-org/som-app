//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_switch_role_post200_response.g.dart';

/// AuthSwitchRolePost200Response
///
/// Properties:
/// * [token] 
@BuiltValue()
abstract class AuthSwitchRolePost200Response implements Built<AuthSwitchRolePost200Response, AuthSwitchRolePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'token')
  String? get token;

  AuthSwitchRolePost200Response._();

  factory AuthSwitchRolePost200Response([void updates(AuthSwitchRolePost200ResponseBuilder b)]) = _$AuthSwitchRolePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthSwitchRolePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthSwitchRolePost200Response> get serializer => _$AuthSwitchRolePost200ResponseSerializer();
}

class _$AuthSwitchRolePost200ResponseSerializer implements PrimitiveSerializer<AuthSwitchRolePost200Response> {
  @override
  final Iterable<Type> types = const [AuthSwitchRolePost200Response, _$AuthSwitchRolePost200Response];

  @override
  final String wireName = r'AuthSwitchRolePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthSwitchRolePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.token != null) {
      yield r'token';
      yield serializers.serialize(
        object.token,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthSwitchRolePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthSwitchRolePost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthSwitchRolePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthSwitchRolePost200ResponseBuilder();
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

