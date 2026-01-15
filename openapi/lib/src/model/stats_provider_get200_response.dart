//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stats_provider_get200_response.g.dart';

/// StatsProviderGet200Response
///
/// Properties:
/// * [open] 
/// * [offerCreated] 
/// * [lost] 
/// * [won] 
/// * [ignored] 
@BuiltValue()
abstract class StatsProviderGet200Response implements Built<StatsProviderGet200Response, StatsProviderGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'open')
  int? get open;

  @BuiltValueField(wireName: r'offer_created')
  int? get offerCreated;

  @BuiltValueField(wireName: r'lost')
  int? get lost;

  @BuiltValueField(wireName: r'won')
  int? get won;

  @BuiltValueField(wireName: r'ignored')
  int? get ignored;

  StatsProviderGet200Response._();

  factory StatsProviderGet200Response([void updates(StatsProviderGet200ResponseBuilder b)]) = _$StatsProviderGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatsProviderGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatsProviderGet200Response> get serializer => _$StatsProviderGet200ResponseSerializer();
}

class _$StatsProviderGet200ResponseSerializer implements PrimitiveSerializer<StatsProviderGet200Response> {
  @override
  final Iterable<Type> types = const [StatsProviderGet200Response, _$StatsProviderGet200Response];

  @override
  final String wireName = r'StatsProviderGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatsProviderGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.open != null) {
      yield r'open';
      yield serializers.serialize(
        object.open,
        specifiedType: const FullType(int),
      );
    }
    if (object.offerCreated != null) {
      yield r'offer_created';
      yield serializers.serialize(
        object.offerCreated,
        specifiedType: const FullType(int),
      );
    }
    if (object.lost != null) {
      yield r'lost';
      yield serializers.serialize(
        object.lost,
        specifiedType: const FullType(int),
      );
    }
    if (object.won != null) {
      yield r'won';
      yield serializers.serialize(
        object.won,
        specifiedType: const FullType(int),
      );
    }
    if (object.ignored != null) {
      yield r'ignored';
      yield serializers.serialize(
        object.ignored,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StatsProviderGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatsProviderGet200ResponseBuilder result,
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
        case r'offer_created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.offerCreated = valueDes;
          break;
        case r'lost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lost = valueDes;
          break;
        case r'won':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.won = valueDes;
          break;
        case r'ignored':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ignored = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatsProviderGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatsProviderGet200ResponseBuilder();
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

