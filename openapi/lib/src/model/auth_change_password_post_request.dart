//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_change_password_post_request.g.dart';

/// AuthChangePasswordPostRequest
///
/// Properties:
/// * [currentPassword] 
/// * [newPassword] 
/// * [confirmPassword] 
@BuiltValue()
abstract class AuthChangePasswordPostRequest implements Built<AuthChangePasswordPostRequest, AuthChangePasswordPostRequestBuilder> {
  @BuiltValueField(wireName: r'currentPassword')
  String get currentPassword;

  @BuiltValueField(wireName: r'newPassword')
  String get newPassword;

  @BuiltValueField(wireName: r'confirmPassword')
  String get confirmPassword;

  AuthChangePasswordPostRequest._();

  factory AuthChangePasswordPostRequest([void updates(AuthChangePasswordPostRequestBuilder b)]) = _$AuthChangePasswordPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthChangePasswordPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthChangePasswordPostRequest> get serializer => _$AuthChangePasswordPostRequestSerializer();
}

class _$AuthChangePasswordPostRequestSerializer implements PrimitiveSerializer<AuthChangePasswordPostRequest> {
  @override
  final Iterable<Type> types = const [AuthChangePasswordPostRequest, _$AuthChangePasswordPostRequest];

  @override
  final String wireName = r'AuthChangePasswordPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthChangePasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currentPassword';
    yield serializers.serialize(
      object.currentPassword,
      specifiedType: const FullType(String),
    );
    yield r'newPassword';
    yield serializers.serialize(
      object.newPassword,
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
    AuthChangePasswordPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthChangePasswordPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentPassword = valueDes;
          break;
        case r'newPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPassword = valueDes;
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
  AuthChangePasswordPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthChangePasswordPostRequestBuilder();
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

