//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

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

    CompanyDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CompanyDtoBuilder b) => b;

    factory CompanyDto([void updates(CompanyDtoBuilder b)]) = _$CompanyDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<CompanyDto> get serializer => _$CompanyDtoSerializer();
}

class _$CompanyDtoSerializer implements StructuredSerializer<CompanyDto> {
    @override
    final Iterable<Type> types = const [CompanyDto, _$CompanyDto];

    @override
    final String wireName = r'CompanyDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, CompanyDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.name != null) {
            result
                ..add(r'name')
                ..add(serializers.serialize(object.name,
                    specifiedType: const FullType(String)));
        }
        if (object.address != null) {
            result
                ..add(r'address')
                ..add(serializers.serialize(object.address,
                    specifiedType: const FullType(Address)));
        }
        if (object.uidNr != null) {
            result
                ..add(r'uidNr')
                ..add(serializers.serialize(object.uidNr,
                    specifiedType: const FullType(String)));
        }
        if (object.registrationNr != null) {
            result
                ..add(r'registrationNr')
                ..add(serializers.serialize(object.registrationNr,
                    specifiedType: const FullType(String)));
        }
        if (object.companySize != null) {
            result
                ..add(r'companySize')
                ..add(serializers.serialize(object.companySize,
                    specifiedType: const FullType(int)));
        }
        if (object.type != null) {
            result
                ..add(r'type')
                ..add(serializers.serialize(object.type,
                    specifiedType: const FullType(int)));
        }
        if (object.websiteUrl != null) {
            result
                ..add(r'websiteUrl')
                ..add(serializers.serialize(object.websiteUrl,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    CompanyDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CompanyDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'id':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.id = valueDes;
                    break;
                case r'name':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.name = valueDes;
                    break;
                case r'address':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(Address)) as Address;
                    result.address.replace(valueDes);
                    break;
                case r'uidNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.uidNr = valueDes;
                    break;
                case r'registrationNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.registrationNr = valueDes;
                    break;
                case r'companySize':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.companySize = valueDes;
                    break;
                case r'type':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.type = valueDes;
                    break;
                case r'websiteUrl':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.websiteUrl = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

