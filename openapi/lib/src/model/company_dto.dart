//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/address.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_dto.g.dart';

/// CompanyDto
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [address] 
/// * [uidNr] 
/// * [registrationNr] 
/// * [companySize] 
/// * [type] 
/// * [websiteUrl] 
/// * [status] 
@BuiltValue()
abstract class CompanyDto implements Built<CompanyDto, CompanyDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'address')
  Address? get address;

  @BuiltValueField(wireName: r'uidNr')
  String? get uidNr;

  @BuiltValueField(wireName: r'registrationNr')
  String? get registrationNr;

  @BuiltValueField(wireName: r'companySize')
  int? get companySize;

  @BuiltValueField(wireName: r'type')
  int? get type;

  @BuiltValueField(wireName: r'websiteUrl')
  String? get websiteUrl;

  @BuiltValueField(wireName: r'status')
  String? get status;

  CompanyDto._();

  factory CompanyDto([void updates(CompanyDtoBuilder b)]) = _$CompanyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyDto> get serializer => _$CompanyDtoSerializer();
}

class _$CompanyDtoSerializer implements PrimitiveSerializer<CompanyDto> {
  @override
  final Iterable<Type> types = const [CompanyDto, _$CompanyDto];

  @override
  final String wireName = r'CompanyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(Address),
      );
    }
    if (object.uidNr != null) {
      yield r'uidNr';
      yield serializers.serialize(
        object.uidNr,
        specifiedType: const FullType(String),
      );
    }
    if (object.registrationNr != null) {
      yield r'registrationNr';
      yield serializers.serialize(
        object.registrationNr,
        specifiedType: const FullType(String),
      );
    }
    if (object.companySize != null) {
      yield r'companySize';
      yield serializers.serialize(
        object.companySize,
        specifiedType: const FullType(int),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(int),
      );
    }
    if (object.websiteUrl != null) {
      yield r'websiteUrl';
      yield serializers.serialize(
        object.websiteUrl,
        specifiedType: const FullType.nullable(String),
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
    CompanyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyDtoBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Address),
          ) as Address;
          result.address.replace(valueDes);
          break;
        case r'uidNr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uidNr = valueDes;
          break;
        case r'registrationNr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.registrationNr = valueDes;
          break;
        case r'companySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.companySize = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.type = valueDes;
          break;
        case r'websiteUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.websiteUrl = valueDes;
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
  CompanyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyDtoBuilder();
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

