//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_forgot_password_post_request.g.dart';

/// AuthForgotPasswordPostRequest
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class AuthForgotPasswordPostRequest implements Built<AuthForgotPasswordPostRequest, AuthForgotPasswordPostRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  AuthForgotPasswordPostRequest._();

  factory AuthForgotPasswordPostRequest([void updates(AuthForgotPasswordPostRequestBuilder b)]) = _$AuthForgotPasswordPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthForgotPasswordPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthForgotPasswordPostRequest> get serializer => _$AuthForgotPasswordPostRequestSerializer();
}

class _$AuthForgotPasswordPostRequestSerializer implements PrimitiveSerializer<AuthForgotPasswordPostRequest> {
  @override
  final Iterable<Type> types = const [AuthForgotPasswordPostRequest, _$AuthForgotPasswordPostRequest];

  @override
  final String wireName = r'AuthForgotPasswordPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthForgotPasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthForgotPasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthForgotPasswordPostRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthForgotPasswordPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthForgotPasswordPostRequestBuilder();
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

