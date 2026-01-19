//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/company_branch_assignment.dart';
import 'package:openapi/src/model/company_category_assignment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_taxonomy.g.dart';

/// CompanyTaxonomy
///
/// Properties:
/// * [companyId] 
/// * [branches] 
/// * [categories] 
@BuiltValue()
abstract class CompanyTaxonomy implements Built<CompanyTaxonomy, CompanyTaxonomyBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'branches')
  BuiltList<CompanyBranchAssignment>? get branches;

  @BuiltValueField(wireName: r'categories')
  BuiltList<CompanyCategoryAssignment>? get categories;

  CompanyTaxonomy._();

  factory CompanyTaxonomy([void updates(CompanyTaxonomyBuilder b)]) = _$CompanyTaxonomy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyTaxonomyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyTaxonomy> get serializer => _$CompanyTaxonomySerializer();
}

class _$CompanyTaxonomySerializer implements PrimitiveSerializer<CompanyTaxonomy> {
  @override
  final Iterable<Type> types = const [CompanyTaxonomy, _$CompanyTaxonomy];

  @override
  final String wireName = r'CompanyTaxonomy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyTaxonomy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.branches != null) {
      yield r'branches';
      yield serializers.serialize(
        object.branches,
        specifiedType: const FullType(BuiltList, [FullType(CompanyBranchAssignment)]),
      );
    }
    if (object.categories != null) {
      yield r'categories';
      yield serializers.serialize(
        object.categories,
        specifiedType: const FullType(BuiltList, [FullType(CompanyCategoryAssignment)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyTaxonomy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyTaxonomyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'branches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyBranchAssignment)]),
          ) as BuiltList<CompanyBranchAssignment>;
          result.branches.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyCategoryAssignment)]),
          ) as BuiltList<CompanyCategoryAssignment>;
          result.categories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyTaxonomy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyTaxonomyBuilder();
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

