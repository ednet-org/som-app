//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_buyer_get200_response.g.dart';

/// StatsBuyerGet200Response
///
/// Properties:
/// * [open] 
/// * [closed] 
@BuiltValue()
abstract class StatsBuyerGet200Response implements Built<StatsBuyerGet200Response, StatsBuyerGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'open')
  int? get open;

  @BuiltValueField(wireName: r'closed')
  int? get closed;

  StatsBuyerGet200Response._();

  factory StatsBuyerGet200Response([void updates(StatsBuyerGet200ResponseBuilder b)]) = _$StatsBuyerGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsBuyerGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsBuyerGet200Response> get serializer => _$StatsBuyerGet200ResponseSerializer();
}

class _$StatsBuyerGet200ResponseSerializer implements PrimitiveSerializer<StatsBuyerGet200Response> {
  @override
  final Iterable<Type> types = const [StatsBuyerGet200Response, _$StatsBuyerGet200Response];

  @override
  final String wireName = r'StatsBuyerGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsBuyerGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.open != null) {
      yield r'open';
      yield serializers.serialize(
        object.open,
        specifiedType: const FullType(int),
      );
    }
    if (object.closed != null) {
      yield r'closed';
      yield serializers.serialize(
        object.closed,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsBuyerGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatsBuyerGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.open = valueDes;
          break;
        case r'closed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.closed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsBuyerGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsBuyerGet200ResponseBuilder();
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

