//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_change_password_post200_response.g.dart';

/// AuthChangePasswordPost200Response
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class AuthChangePasswordPost200Response implements Built<AuthChangePasswordPost200Response, AuthChangePasswordPost200ResponseBuilder> {
  @BuiltValueField(wireName: r'status')
  String? get status;

  AuthChangePasswordPost200Response._();

  factory AuthChangePasswordPost200Response([void updates(AuthChangePasswordPost200ResponseBuilder b)]) = _$AuthChangePasswordPost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthChangePasswordPost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthChangePasswordPost200Response> get serializer => _$AuthChangePasswordPost200ResponseSerializer();
}

class _$AuthChangePasswordPost200ResponseSerializer implements PrimitiveSerializer<AuthChangePasswordPost200Response> {
  @override
  final Iterable<Type> types = const [AuthChangePasswordPost200Response, _$AuthChangePasswordPost200Response];

  @override
  final String wireName = r'AuthChangePasswordPost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthChangePasswordPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthChangePasswordPost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthChangePasswordPost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthChangePasswordPost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthChangePasswordPost200ResponseBuilder();
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

