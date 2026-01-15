//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiries_inquiry_id_assign_post_request.g.dart';

/// InquiriesInquiryIdAssignPostRequest
///
/// Properties:
/// * [providerCompanyIds] 
@BuiltValue()
abstract class InquiriesInquiryIdAssignPostRequest implements Built<InquiriesInquiryIdAssignPostRequest, InquiriesInquiryIdAssignPostRequestBuilder> {
  @BuiltValueField(wireName: r'providerCompanyIds')
  BuiltList<String> get providerCompanyIds;

  InquiriesInquiryIdAssignPostRequest._();

  factory InquiriesInquiryIdAssignPostRequest([void updates(InquiriesInquiryIdAssignPostRequestBuilder b)]) = _$InquiriesInquiryIdAssignPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiriesInquiryIdAssignPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InquiriesInquiryIdAssignPostRequest> get serializer => _$InquiriesInquiryIdAssignPostRequestSerializer();
}

class _$InquiriesInquiryIdAssignPostRequestSerializer implements PrimitiveSerializer<InquiriesInquiryIdAssignPostRequest> {
  @override
  final Iterable<Type> types = const [InquiriesInquiryIdAssignPostRequest, _$InquiriesInquiryIdAssignPostRequest];

  @override
  final String wireName = r'InquiriesInquiryIdAssignPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InquiriesInquiryIdAssignPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'providerCompanyIds';
    yield serializers.serialize(
      object.providerCompanyIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InquiriesInquiryIdAssignPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiriesInquiryIdAssignPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'providerCompanyIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.providerCompanyIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InquiriesInquiryIdAssignPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiriesInquiryIdAssignPostRequestBuilder();
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

