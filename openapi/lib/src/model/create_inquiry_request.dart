//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_inquiry_request.g.dart';

/// CreateInquiryRequest
///
/// Properties:
/// * [branchId] 
/// * [categoryId] 
/// * [productTags] 
/// * [deadline] 
/// * [deliveryZips] 
/// * [numberOfProviders] 
/// * [description] 
/// * [providerZip] 
/// * [radiusKm] 
/// * [providerType] 
/// * [providerCompanySize] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephone] 
/// * [email] 
@BuiltValue()
abstract class CreateInquiryRequest implements Built<CreateInquiryRequest, CreateInquiryRequestBuilder> {
  @BuiltValueField(wireName: r'branchId')
  String get branchId;

  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  @BuiltValueField(wireName: r'productTags')
  BuiltList<String>? get productTags;

  @BuiltValueField(wireName: r'deadline')
  DateTime get deadline;

  @BuiltValueField(wireName: r'deliveryZips')
  BuiltList<String> get deliveryZips;

  @BuiltValueField(wireName: r'numberOfProviders')
  int get numberOfProviders;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'providerZip')
  String? get providerZip;

  @BuiltValueField(wireName: r'radiusKm')
  int? get radiusKm;

  @BuiltValueField(wireName: r'providerType')
  String? get providerType;

  @BuiltValueField(wireName: r'providerCompanySize')
  String? get providerCompanySize;

  @BuiltValueField(wireName: r'salutation')
  String? get salutation;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'firstName')
  String? get firstName;

  @BuiltValueField(wireName: r'lastName')
  String? get lastName;

  @BuiltValueField(wireName: r'telephone')
  String? get telephone;

  @BuiltValueField(wireName: r'email')
  String? get email;

  CreateInquiryRequest._();

  factory CreateInquiryRequest([void updates(CreateInquiryRequestBuilder b)]) = _$CreateInquiryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateInquiryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateInquiryRequest> get serializer => _$CreateInquiryRequestSerializer();
}

class _$CreateInquiryRequestSerializer implements PrimitiveSerializer<CreateInquiryRequest> {
  @override
  final Iterable<Type> types = const [CreateInquiryRequest, _$CreateInquiryRequest];

  @override
  final String wireName = r'CreateInquiryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateInquiryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'branchId';
    yield serializers.serialize(
      object.branchId,
      specifiedType: const FullType(String),
    );
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    if (object.productTags != null) {
      yield r'productTags';
      yield serializers.serialize(
        object.productTags,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'deadline';
    yield serializers.serialize(
      object.deadline,
      specifiedType: const FullType(DateTime),
    );
    yield r'deliveryZips';
    yield serializers.serialize(
      object.deliveryZips,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'numberOfProviders';
    yield serializers.serialize(
      object.numberOfProviders,
      specifiedType: const FullType(int),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerZip != null) {
      yield r'providerZip';
      yield serializers.serialize(
        object.providerZip,
        specifiedType: const FullType(String),
      );
    }
    if (object.radiusKm != null) {
      yield r'radiusKm';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
    if (object.providerType != null) {
      yield r'providerType';
      yield serializers.serialize(
        object.providerType,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerCompanySize != null) {
      yield r'providerCompanySize';
      yield serializers.serialize(
        object.providerCompanySize,
        specifiedType: const FullType(String),
      );
    }
    if (object.salutation != null) {
      yield r'salutation';
      yield serializers.serialize(
        object.salutation,
        specifiedType: const FullType(String),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.firstName != null) {
      yield r'firstName';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastName != null) {
      yield r'lastName';
      yield serializers.serialize(
        object.lastName,
        specifiedType: const FullType(String),
      );
    }
    if (object.telephone != null) {
      yield r'telephone';
      yield serializers.serialize(
        object.telephone,
        specifiedType: const FullType(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateInquiryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateInquiryRequestBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'providerZip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerZip = valueDes;
          break;
        case r'radiusKm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.radiusKm = valueDes;
          break;
        case r'providerType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerType = valueDes;
          break;
        case r'providerCompanySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerCompanySize = valueDes;
          break;
        case r'salutation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salutation = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'telephone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.telephone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateInquiryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateInquiryRequestBuilder();
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

