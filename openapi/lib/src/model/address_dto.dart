//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'address_dto.g.dart';

/// AddressDto
///
/// Properties:
/// * [country] 
/// * [city] 
/// * [street] 
/// * [number] 
/// * [zip] 
abstract class AddressDto implements Built<AddressDto, AddressDtoBuilder> {
    @BuiltValueField(wireName: r'country')
    String? get country;

    @BuiltValueField(wireName: r'city')
    String? get city;

    @BuiltValueField(wireName: r'street')
    String? get street;

    @BuiltValueField(wireName: r'number')
    String? get number;

    @BuiltValueField(wireName: r'zip')
    String? get zip;

    AddressDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AddressDtoBuilder b) => b;

    factory AddressDto([void updates(AddressDtoBuilder b)]) = _$AddressDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<AddressDto> get serializer => _$AddressDtoSerializer();
}

class _$AddressDtoSerializer implements StructuredSerializer<AddressDto> {
    @override
    final Iterable<Type> types = const [AddressDto, _$AddressDto];

    @override
    final String wireName = r'AddressDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, AddressDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.country != null) {
            result
                ..add(r'country')
                ..add(serializers.serialize(object.country,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.city != null) {
            result
                ..add(r'city')
                ..add(serializers.serialize(object.city,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.street != null) {
            result
                ..add(r'street')
                ..add(serializers.serialize(object.street,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.number != null) {
            result
                ..add(r'number')
                ..add(serializers.serialize(object.number,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.zip != null) {
            result
                ..add(r'zip')
                ..add(serializers.serialize(object.zip,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    AddressDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AddressDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'country':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.country = valueDes;
                    break;
                case r'city':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.city = valueDes;
                    break;
                case r'street':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.street = valueDes;
                    break;
                case r'number':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.number = valueDes;
                    break;
                case r'zip':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.zip = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

