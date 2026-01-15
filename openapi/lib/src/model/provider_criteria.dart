//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_criteria.g.dart';

/// ProviderCriteria
///
/// Properties:
/// * [providerZip] 
/// * [radiusKm] 
/// * [providerType] 
/// * [companySize] 
@BuiltValue()
abstract class ProviderCriteria implements Built<ProviderCriteria, ProviderCriteriaBuilder> {
  @BuiltValueField(wireName: r'providerZip')
  String? get providerZip;

  @BuiltValueField(wireName: r'radiusKm')
  int? get radiusKm;

  @BuiltValueField(wireName: r'providerType')
  String? get providerType;

  @BuiltValueField(wireName: r'companySize')
  String? get companySize;

  ProviderCriteria._();

  factory ProviderCriteria([void updates(ProviderCriteriaBuilder b)]) = _$ProviderCriteria;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderCriteriaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderCriteria> get serializer => _$ProviderCriteriaSerializer();
}

class _$ProviderCriteriaSerializer implements PrimitiveSerializer<ProviderCriteria> {
  @override
  final Iterable<Type> types = const [ProviderCriteria, _$ProviderCriteria];

  @override
  final String wireName = r'ProviderCriteria';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderCriteria object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.providerZip != null) {
      yield r'providerZip';
      yield serializers.serialize(
        object.providerZip,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.radiusKm != null) {
      yield r'radiusKm';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.providerType != null) {
      yield r'providerType';
      yield serializers.serialize(
        object.providerType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.companySize != null) {
      yield r'companySize';
      yield serializers.serialize(
        object.companySize,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProviderCriteria object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderCriteriaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerZip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerZip = valueDes;
          break;
        case r'radiusKm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        case r'providerType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerType = valueDes;
          break;
        case r'companySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companySize = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProviderCriteria deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderCriteriaBuilder();
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

