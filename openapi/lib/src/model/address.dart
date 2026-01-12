//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'address.g.dart';

/// Address
///
/// Properties:
/// * [country] 
/// * [city] 
/// * [street] 
/// * [number] 
/// * [zip] 
abstract class Address implements Built<Address, AddressBuilder> {
    @BuiltValueField(wireName: r'country')
    String get country;

    @BuiltValueField(wireName: r'city')
    String get city;

    @BuiltValueField(wireName: r'street')
    String get street;

    @BuiltValueField(wireName: r'number')
    String get number;

    @BuiltValueField(wireName: r'zip')
    String get zip;

    Address._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AddressBuilder b) => b;

    factory Address([void updates(AddressBuilder b)]) = _$Address;

    @BuiltValueSerializer(custom: true)
    static Serializer<Address> get serializer => _$AddressSerializer();
}

class _$AddressSerializer implements StructuredSerializer<Address> {
    @override
    final Iterable<Type> types = const [Address, _$Address];

    @override
    final String wireName = r'Address';

    @override
    Iterable<Object?> serialize(Serializers serializers, Address object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'country')
            ..add(serializers.serialize(object.country,
                specifiedType: const FullType(String)));
        result
            ..add(r'city')
            ..add(serializers.serialize(object.city,
                specifiedType: const FullType(String)));
        result
            ..add(r'street')
            ..add(serializers.serialize(object.street,
                specifiedType: const FullType(String)));
        result
            ..add(r'number')
            ..add(serializers.serialize(object.number,
                specifiedType: const FullType(String)));
        result
            ..add(r'zip')
            ..add(serializers.serialize(object.zip,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    Address deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AddressBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'country':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.country = valueDes;
                    break;
                case r'city':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.city = valueDes;
                    break;
                case r'street':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.street = valueDes;
                    break;
                case r'number':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.number = valueDes;
                    break;
                case r'zip':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.zip = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

