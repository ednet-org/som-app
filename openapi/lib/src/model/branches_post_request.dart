//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'branches_post_request.g.dart';

/// BranchesPostRequest
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class BranchesPostRequest implements Built<BranchesPostRequest, BranchesPostRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  BranchesPostRequest._();

  factory BranchesPostRequest([void updates(BranchesPostRequestBuilder b)]) = _$BranchesPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BranchesPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BranchesPostRequest> get serializer => _$BranchesPostRequestSerializer();
}

class _$BranchesPostRequestSerializer implements PrimitiveSerializer<BranchesPostRequest> {
  @override
  final Iterable<Type> types = const [BranchesPostRequest, _$BranchesPostRequest];

  @override
  final String wireName = r'BranchesPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BranchesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BranchesPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BranchesPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BranchesPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BranchesPostRequestBuilder();
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

