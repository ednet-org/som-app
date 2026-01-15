//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/contact_info.dart';
import 'package:openapi/src/model/provider_criteria.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiry.g.dart';

/// Inquiry
///
/// Properties:
/// * [id] 
/// * [buyerCompanyId] 
/// * [createdByUserId] 
/// * [status] 
/// * [branchId] 
/// * [categoryId] 
/// * [productTags] 
/// * [deadline] 
/// * [deliveryZips] 
/// * [numberOfProviders] 
/// * [description] 
/// * [pdfPath] 
/// * [providerCriteria] 
/// * [contactInfo] 
/// * [notifiedAt] 
/// * [assignedAt] 
/// * [closedAt] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class Inquiry implements Built<Inquiry, InquiryBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'buyerCompanyId')
  String? get buyerCompanyId;

  @BuiltValueField(wireName: r'createdByUserId')
  String? get createdByUserId;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'branchId')
  String? get branchId;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'productTags')
  BuiltList<String>? get productTags;

  @BuiltValueField(wireName: r'deadline')
  DateTime? get deadline;

  @BuiltValueField(wireName: r'deliveryZips')
  BuiltList<String>? get deliveryZips;

  @BuiltValueField(wireName: r'numberOfProviders')
  int? get numberOfProviders;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'pdfPath')
  String? get pdfPath;

  @BuiltValueField(wireName: r'providerCriteria')
  ProviderCriteria? get providerCriteria;

  @BuiltValueField(wireName: r'contactInfo')
  ContactInfo? get contactInfo;

  @BuiltValueField(wireName: r'notifiedAt')
  DateTime? get notifiedAt;

  @BuiltValueField(wireName: r'assignedAt')
  DateTime? get assignedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  Inquiry._();

  factory Inquiry([void updates(InquiryBuilder b)]) = _$Inquiry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InquiryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Inquiry> get serializer => _$InquirySerializer();
}

class _$InquirySerializer implements PrimitiveSerializer<Inquiry> {
  @override
  final Iterable<Type> types = const [Inquiry, _$Inquiry];

  @override
  final String wireName = r'Inquiry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Inquiry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.buyerCompanyId != null) {
      yield r'buyerCompanyId';
      yield serializers.serialize(
        object.buyerCompanyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdByUserId != null) {
      yield r'createdByUserId';
      yield serializers.serialize(
        object.createdByUserId,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.branchId != null) {
      yield r'branchId';
      yield serializers.serialize(
        object.branchId,
        specifiedType: const FullType(String),
      );
    }
    if (object.categoryId != null) {
      yield r'categoryId';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.productTags != null) {
      yield r'productTags';
      yield serializers.serialize(
        object.productTags,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.deadline != null) {
      yield r'deadline';
      yield serializers.serialize(
        object.deadline,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.deliveryZips != null) {
      yield r'deliveryZips';
      yield serializers.serialize(
        object.deliveryZips,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.numberOfProviders != null) {
      yield r'numberOfProviders';
      yield serializers.serialize(
        object.numberOfProviders,
        specifiedType: const FullType(int),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.pdfPath != null) {
      yield r'pdfPath';
      yield serializers.serialize(
        object.pdfPath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.providerCriteria != null) {
      yield r'providerCriteria';
      yield serializers.serialize(
        object.providerCriteria,
        specifiedType: const FullType(ProviderCriteria),
      );
    }
    if (object.contactInfo != null) {
      yield r'contactInfo';
      yield serializers.serialize(
        object.contactInfo,
        specifiedType: const FullType(ContactInfo),
      );
    }
    if (object.notifiedAt != null) {
      yield r'notifiedAt';
      yield serializers.serialize(
        object.notifiedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.assignedAt != null) {
      yield r'assignedAt';
      yield serializers.serialize(
        object.assignedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.closedAt != null) {
      yield r'closedAt';
      yield serializers.serialize(
        object.closedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Inquiry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InquiryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'buyerCompanyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buyerCompanyId = valueDes;
          break;
        case r'createdByUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdByUserId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'branchId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.branchId = valueDes;
          break;
        case r'categoryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryId = valueDes;
          break;
        case r'productTags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.productTags.replace(valueDes);
          break;
        case r'deadline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deadline = valueDes;
          break;
        case r'deliveryZips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.deliveryZips.replace(valueDes);
          break;
        case r'numberOfProviders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numberOfProviders = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'pdfPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pdfPath = valueDes;
          break;
        case r'providerCriteria':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderCriteria),
          ) as ProviderCriteria;
          result.providerCriteria.replace(valueDes);
          break;
        case r'contactInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactInfo),
          ) as ContactInfo;
          result.contactInfo.replace(valueDes);
          break;
        case r'notifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.notifiedAt = valueDes;
          break;
        case r'assignedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.assignedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Inquiry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InquiryBuilder();
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

