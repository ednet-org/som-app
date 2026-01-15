//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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
@BuiltValue()
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

  factory AuthResetPasswordPostRequest([void updates(AuthResetPasswordPostRequestBuilder b)]) = _$AuthResetPasswordPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthResetPasswordPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthResetPasswordPostRequest> get serializer => _$AuthResetPasswordPostRequestSerializer();
}

class _$AuthResetPasswordPostRequestSerializer implements PrimitiveSerializer<AuthResetPasswordPostRequest> {
  @override
  final Iterable<Type> types = const [AuthResetPasswordPostRequest, _$AuthResetPasswordPostRequest];

  @override
  final String wireName = r'AuthResetPasswordPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthResetPasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'confirmPassword';
    yield serializers.serialize(
      object.confirmPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthResetPasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthResetPasswordPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'confirmPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.confirmPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthResetPasswordPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthResetPasswordPostRequestBuilder();
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

