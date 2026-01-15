//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/address.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/provider_registration_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_registration.g.dart';

/// CompanyRegistration
///
/// Properties:
/// * [name] 
/// * [address] 
/// * [uidNr] 
/// * [registrationNr] 
/// * [companySize] - 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
/// * [type] - 0=buyer, 1=provider, 2=buyer+provider
/// * [websiteUrl] 
/// * [providerData] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
@BuiltValue()
abstract class CompanyRegistration implements Built<CompanyRegistration, CompanyRegistrationBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  Address get address;

  @BuiltValueField(wireName: r'uidNr')
  String get uidNr;

  @BuiltValueField(wireName: r'registrationNr')
  String get registrationNr;

  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueField(wireName: r'companySize')
  CompanyRegistrationCompanySizeEnum get companySize;
  // enum companySizeEnum {  0,  1,  2,  3,  4,  5,  };

  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueField(wireName: r'type')
  CompanyRegistrationTypeEnum get type;
  // enum typeEnum {  0,  1,  2,  };

  @BuiltValueField(wireName: r'websiteUrl')
  String? get websiteUrl;

  @BuiltValueField(wireName: r'providerData')
  ProviderRegistrationData? get providerData;

  @BuiltValueField(wireName: r'termsAccepted')
  bool get termsAccepted;

  @BuiltValueField(wireName: r'privacyAccepted')
  bool get privacyAccepted;

  CompanyRegistration._();

  factory CompanyRegistration([void updates(CompanyRegistrationBuilder b)]) = _$CompanyRegistration;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyRegistrationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyRegistration> get serializer => _$CompanyRegistrationSerializer();
}

class _$CompanyRegistrationSerializer implements PrimitiveSerializer<CompanyRegistration> {
  @override
  final Iterable<Type> types = const [CompanyRegistration, _$CompanyRegistration];

  @override
  final String wireName = r'CompanyRegistration';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyRegistration object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(Address),
    );
    yield r'uidNr';
    yield serializers.serialize(
      object.uidNr,
      specifiedType: const FullType(String),
    );
    yield r'registrationNr';
    yield serializers.serialize(
      object.registrationNr,
      specifiedType: const FullType(String),
    );
    yield r'companySize';
    yield serializers.serialize(
      object.companySize,
      specifiedType: const FullType(CompanyRegistrationCompanySizeEnum),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CompanyRegistrationTypeEnum),
    );
    if (object.websiteUrl != null) {
      yield r'websiteUrl';
      yield serializers.serialize(
        object.websiteUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerData != null) {
      yield r'providerData';
      yield serializers.serialize(
        object.providerData,
        specifiedType: const FullType(ProviderRegistrationData),
      );
    }
    yield r'termsAccepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(bool),
    );
    yield r'privacyAccepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyRegistration object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyRegistrationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(CompanyRegistrationCompanySizeEnum),
          ) as CompanyRegistrationCompanySizeEnum;
          result.companySize = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompanyRegistrationTypeEnum),
          ) as CompanyRegistrationTypeEnum;
          result.type = valueDes;
          break;
        case r'websiteUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.websiteUrl = valueDes;
          break;
        case r'providerData':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderRegistrationData),
          ) as ProviderRegistrationData;
          result.providerData.replace(valueDes);
          break;
        case r'termsAccepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.termsAccepted = valueDes;
          break;
        case r'privacyAccepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.privacyAccepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyRegistration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyRegistrationBuilder();
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

class CompanyRegistrationCompanySizeEnum extends EnumClass {

  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 0)
  static const CompanyRegistrationCompanySizeEnum number0 = _$companyRegistrationCompanySizeEnum_number0;
  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 1)
  static const CompanyRegistrationCompanySizeEnum number1 = _$companyRegistrationCompanySizeEnum_number1;
  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 2)
  static const CompanyRegistrationCompanySizeEnum number2 = _$companyRegistrationCompanySizeEnum_number2;
  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 3)
  static const CompanyRegistrationCompanySizeEnum number3 = _$companyRegistrationCompanySizeEnum_number3;
  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 4)
  static const CompanyRegistrationCompanySizeEnum number4 = _$companyRegistrationCompanySizeEnum_number4;
  /// 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+
  @BuiltValueEnumConst(wireNumber: 5)
  static const CompanyRegistrationCompanySizeEnum number5 = _$companyRegistrationCompanySizeEnum_number5;

  static Serializer<CompanyRegistrationCompanySizeEnum> get serializer => _$companyRegistrationCompanySizeEnumSerializer;

  const CompanyRegistrationCompanySizeEnum._(String name): super(name);

  static BuiltSet<CompanyRegistrationCompanySizeEnum> get values => _$companyRegistrationCompanySizeEnumValues;
  static CompanyRegistrationCompanySizeEnum valueOf(String name) => _$companyRegistrationCompanySizeEnumValueOf(name);
}

class CompanyRegistrationTypeEnum extends EnumClass {

  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 0)
  static const CompanyRegistrationTypeEnum number0 = _$companyRegistrationTypeEnum_number0;
  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 1)
  static const CompanyRegistrationTypeEnum number1 = _$companyRegistrationTypeEnum_number1;
  /// 0=buyer, 1=provider, 2=buyer+provider
  @BuiltValueEnumConst(wireNumber: 2)
  static const CompanyRegistrationTypeEnum number2 = _$companyRegistrationTypeEnum_number2;

  static Serializer<CompanyRegistrationTypeEnum> get serializer => _$companyRegistrationTypeEnumSerializer;

  const CompanyRegistrationTypeEnum._(String name): super(name);

  static BuiltSet<CompanyRegistrationTypeEnum> get values => _$companyRegistrationTypeEnumValues;
  static CompanyRegistrationTypeEnum valueOf(String name) => _$companyRegistrationTypeEnumValueOf(name);
}

