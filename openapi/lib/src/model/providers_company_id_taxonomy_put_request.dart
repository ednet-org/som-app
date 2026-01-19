//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'providers_company_id_taxonomy_put_request.g.dart';

/// ProvidersCompanyIdTaxonomyPutRequest
///
/// Properties:
/// * [branchIds] 
/// * [categoryIds] 
@BuiltValue()
abstract class ProvidersCompanyIdTaxonomyPutRequest implements Built<ProvidersCompanyIdTaxonomyPutRequest, ProvidersCompanyIdTaxonomyPutRequestBuilder> {
  @BuiltValueField(wireName: r'branchIds')
  BuiltList<String>? get branchIds;

  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String>? get categoryIds;

  ProvidersCompanyIdTaxonomyPutRequest._();

  factory ProvidersCompanyIdTaxonomyPutRequest([void updates(ProvidersCompanyIdTaxonomyPutRequestBuilder b)]) = _$ProvidersCompanyIdTaxonomyPutRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProvidersCompanyIdTaxonomyPutRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProvidersCompanyIdTaxonomyPutRequest> get serializer => _$ProvidersCompanyIdTaxonomyPutRequestSerializer();
}

class _$ProvidersCompanyIdTaxonomyPutRequestSerializer implements PrimitiveSerializer<ProvidersCompanyIdTaxonomyPutRequest> {
  @override
  final Iterable<Type> types = const [ProvidersCompanyIdTaxonomyPutRequest, _$ProvidersCompanyIdTaxonomyPutRequest];

  @override
  final String wireName = r'ProvidersCompanyIdTaxonomyPutRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProvidersCompanyIdTaxonomyPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.branchIds != null) {
      yield r'branchIds';
      yield serializers.serialize(
        object.branchIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.categoryIds != null) {
      yield r'categoryIds';
      yield serializers.serialize(
        object.categoryIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProvidersCompanyIdTaxonomyPutRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProvidersCompanyIdTaxonomyPutRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'branchIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.branchIds.replace(valueDes);
          break;
        case r'categoryIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProvidersCompanyIdTaxonomyPutRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProvidersCompanyIdTaxonomyPutRequestBuilder();
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

