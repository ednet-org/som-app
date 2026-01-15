//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'providers_company_id_approve_post_request.g.dart';

/// ProvidersCompanyIdApprovePostRequest
///
/// Properties:
/// * [approvedBranchIds] 
@BuiltValue()
abstract class ProvidersCompanyIdApprovePostRequest implements Built<ProvidersCompanyIdApprovePostRequest, ProvidersCompanyIdApprovePostRequestBuilder> {
  @BuiltValueField(wireName: r'approvedBranchIds')
  BuiltList<String>? get approvedBranchIds;

  ProvidersCompanyIdApprovePostRequest._();

  factory ProvidersCompanyIdApprovePostRequest([void updates(ProvidersCompanyIdApprovePostRequestBuilder b)]) = _$ProvidersCompanyIdApprovePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProvidersCompanyIdApprovePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProvidersCompanyIdApprovePostRequest> get serializer => _$ProvidersCompanyIdApprovePostRequestSerializer();
}

class _$ProvidersCompanyIdApprovePostRequestSerializer implements PrimitiveSerializer<ProvidersCompanyIdApprovePostRequest> {
  @override
  final Iterable<Type> types = const [ProvidersCompanyIdApprovePostRequest, _$ProvidersCompanyIdApprovePostRequest];

  @override
  final String wireName = r'ProvidersCompanyIdApprovePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProvidersCompanyIdApprovePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.approvedBranchIds != null) {
      yield r'approvedBranchIds';
      yield serializers.serialize(
        object.approvedBranchIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProvidersCompanyIdApprovePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProvidersCompanyIdApprovePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approvedBranchIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.approvedBranchIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProvidersCompanyIdApprovePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProvidersCompanyIdApprovePostRequestBuilder();
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

