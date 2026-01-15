//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ad_request.g.dart';

/// CreateAdRequest
///
/// Properties:
/// * [type] 
/// * [status] - Must be draft; activate via /ads/{id}/activate
/// * [branchId] 
/// * [url] 
/// * [imagePath] 
/// * [headline] 
/// * [description] 
/// * [startDate] 
/// * [endDate] 
/// * [bannerDate] 
@BuiltValue()
abstract class CreateAdRequest implements Built<CreateAdRequest, CreateAdRequestBuilder> {
  @BuiltValueField(wireName: r'type')
  String get type;

  /// Must be draft; activate via /ads/{id}/activate
  @BuiltValueField(wireName: r'status')
  CreateAdRequestStatusEnum get status;
  // enum statusEnum {  draft,  };

  @BuiltValueField(wireName: r'branchId')
  String get branchId;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'imagePath')
  String? get imagePath;

  @BuiltValueField(wireName: r'headline')
  String? get headline;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'startDate')
  String? get startDate;

  @BuiltValueField(wireName: r'endDate')
  String? get endDate;

  @BuiltValueField(wireName: r'bannerDate')
  String? get bannerDate;

  CreateAdRequest._();

  factory CreateAdRequest([void updates(CreateAdRequestBuilder b)]) = _$CreateAdRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAdRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAdRequest> get serializer => _$CreateAdRequestSerializer();
}

class _$CreateAdRequestSerializer implements PrimitiveSerializer<CreateAdRequest> {
  @override
  final Iterable<Type> types = const [CreateAdRequest, _$CreateAdRequest];

  @override
  final String wireName = r'CreateAdRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAdRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CreateAdRequestStatusEnum),
    );
    yield r'branchId';
    yield serializers.serialize(
      object.branchId,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    if (object.imagePath != null) {
      yield r'imagePath';
      yield serializers.serialize(
        object.imagePath,
        specifiedType: const FullType(String),
      );
    }
    if (object.headline != null) {
      yield r'headline';
      yield serializers.serialize(
        object.headline,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.startDate != null) {
      yield r'startDate';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(String),
      );
    }
    if (object.endDate != null) {
      yield r'endDate';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType(String),
      );
    }
    if (object.bannerDate != null) {
      yield r'bannerDate';
      yield serializers.serialize(
        object.bannerDate,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAdRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateAdRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateAdRequestStatusEnum),
          ) as CreateAdRequestStatusEnum;
          result.status = valueDes;
          break;
        case r'branchId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.branchId = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'imagePath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imagePath = valueDes;
          break;
        case r'headline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.headline = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'startDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.startDate = valueDes;
          break;
        case r'endDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.endDate = valueDes;
          break;
        case r'bannerDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bannerDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAdRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAdRequestBuilder();
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

class CreateAdRequestStatusEnum extends EnumClass {

  /// Must be draft; activate via /ads/{id}/activate
  @BuiltValueEnumConst(wireName: r'draft')
  static const CreateAdRequestStatusEnum draft = _$createAdRequestStatusEnum_draft;

  static Serializer<CreateAdRequestStatusEnum> get serializer => _$createAdRequestStatusEnumSerializer;

  const CreateAdRequestStatusEnum._(String name): super(name);

  static BuiltSet<CreateAdRequestStatusEnum> get values => _$createAdRequestStatusEnumValues;
  static CreateAdRequestStatusEnum valueOf(String name) => _$createAdRequestStatusEnumValueOf(name);
}

