//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_branch_assignment.g.dart';

/// CompanyBranchAssignment
///
/// Properties:
/// * [branchId] 
/// * [branchName] 
/// * [source_] 
/// * [confidence] 
/// * [status] 
@BuiltValue()
abstract class CompanyBranchAssignment implements Built<CompanyBranchAssignment, CompanyBranchAssignmentBuilder> {
  @BuiltValueField(wireName: r'branchId')
  String? get branchId;

  @BuiltValueField(wireName: r'branchName')
  String? get branchName;

  @BuiltValueField(wireName: r'source')
  String? get source_;

  @BuiltValueField(wireName: r'confidence')
  num? get confidence;

  @BuiltValueField(wireName: r'status')
  String? get status;

  CompanyBranchAssignment._();

  factory CompanyBranchAssignment([void updates(CompanyBranchAssignmentBuilder b)]) = _$CompanyBranchAssignment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyBranchAssignmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyBranchAssignment> get serializer => _$CompanyBranchAssignmentSerializer();
}

class _$CompanyBranchAssignmentSerializer implements PrimitiveSerializer<CompanyBranchAssignment> {
  @override
  final Iterable<Type> types = const [CompanyBranchAssignment, _$CompanyBranchAssignment];

  @override
  final String wireName = r'CompanyBranchAssignment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyBranchAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.branchId != null) {
      yield r'branchId';
      yield serializers.serialize(
        object.branchId,
        specifiedType: const FullType(String),
      );
    }
    if (object.branchName != null) {
      yield r'branchName';
      yield serializers.serialize(
        object.branchName,
        specifiedType: const FullType(String),
      );
    }
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType(String),
      );
    }
    if (object.confidence != null) {
      yield r'confidence';
      yield serializers.serialize(
        object.confidence,
        specifiedType: const FullType.nullable(num),
      );
    }
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
    CompanyBranchAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyBranchAssignmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'branchId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.branchId = valueDes;
          break;
        case r'branchName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.branchName = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'confidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.confidence = valueDes;
          break;
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
  CompanyBranchAssignment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyBranchAssignmentBuilder();
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

