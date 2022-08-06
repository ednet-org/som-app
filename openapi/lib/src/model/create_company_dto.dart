//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/create_provider_dto.dart';
import 'package:openapi/src/model/company_type.dart';
import 'package:openapi/src/model/address_dto.dart';
import 'package:openapi/src/model/company_size.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_company_dto.g.dart';

/// CreateCompanyDto
///
/// Properties:
/// * [name] 
/// * [address] 
/// * [uidNr] 
/// * [registrationNr] 
/// * [companySize] 
/// * [type] 
/// * [websiteUrl] 
/// * [providerData] 
abstract class CreateCompanyDto implements Built<CreateCompanyDto, CreateCompanyDtoBuilder> {
    @BuiltValueField(wireName: r'name')
    String? get name;

    @BuiltValueField(wireName: r'address')
    AddressDto? get address;

    @BuiltValueField(wireName: r'uidNr')
    String? get uidNr;

    @BuiltValueField(wireName: r'registrationNr')
    String? get registrationNr;

    @BuiltValueField(wireName: r'companySize')
    CompanySize? get companySize;
    // enum companySizeEnum {  0,  1,  2,  3,  4,  5,  6,  };

    @BuiltValueField(wireName: r'type')
    CompanyType? get type;
    // enum typeEnum {  0,  1,  };

    @BuiltValueField(wireName: r'websiteUrl')
    String? get websiteUrl;

    @BuiltValueField(wireName: r'providerData')
    CreateProviderDto? get providerData;

    CreateCompanyDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CreateCompanyDtoBuilder b) => b;

    factory CreateCompanyDto([void updates(CreateCompanyDtoBuilder b)]) = _$CreateCompanyDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<CreateCompanyDto> get serializer => _$CreateCompanyDtoSerializer();
}

class _$CreateCompanyDtoSerializer implements StructuredSerializer<CreateCompanyDto> {
    @override
    final Iterable<Type> types = const [CreateCompanyDto, _$CreateCompanyDto];

    @override
    final String wireName = r'CreateCompanyDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, CreateCompanyDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.name != null) {
            result
                ..add(r'name')
                ..add(serializers.serialize(object.name,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.address != null) {
            result
                ..add(r'address')
                ..add(serializers.serialize(object.address,
                    specifiedType: const FullType(AddressDto)));
        }
        if (object.uidNr != null) {
            result
                ..add(r'uidNr')
                ..add(serializers.serialize(object.uidNr,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.registrationNr != null) {
            result
                ..add(r'registrationNr')
                ..add(serializers.serialize(object.registrationNr,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.companySize != null) {
            result
                ..add(r'companySize')
                ..add(serializers.serialize(object.companySize,
                    specifiedType: const FullType(CompanySize)));
        }
        if (object.type != null) {
            result
                ..add(r'type')
                ..add(serializers.serialize(object.type,
                    specifiedType: const FullType(CompanyType)));
        }
        if (object.websiteUrl != null) {
            result
                ..add(r'websiteUrl')
                ..add(serializers.serialize(object.websiteUrl,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.providerData != null) {
            result
                ..add(r'providerData')
                ..add(serializers.serialize(object.providerData,
                    specifiedType: const FullType(CreateProviderDto)));
        }
        return result;
    }

    @override
    CreateCompanyDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CreateCompanyDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'name':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.name = valueDes;
                    break;
                case r'address':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(AddressDto)) as AddressDto;
                    result.address.replace(valueDes);
                    break;
                case r'uidNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.uidNr = valueDes;
                    break;
                case r'registrationNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.registrationNr = valueDes;
                    break;
                case r'companySize':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(CompanySize)) as CompanySize;
                    result.companySize = valueDes;
                    break;
                case r'type':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(CompanyType)) as CompanyType;
                    result.type = valueDes;
                    break;
                case r'websiteUrl':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.websiteUrl = valueDes;
                    break;
                case r'providerData':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(CreateProviderDto)) as CreateProviderDto;
                    result.providerData.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

