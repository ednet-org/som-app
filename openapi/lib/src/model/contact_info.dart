//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_info.g.dart';

/// ContactInfo
///
/// Properties:
/// * [companyName] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephone] 
/// * [email] 
abstract class ContactInfo implements Built<ContactInfo, ContactInfoBuilder> {
    @BuiltValueField(wireName: r'companyName')
    String get companyName;

    @BuiltValueField(wireName: r'salutation')
    String get salutation;

    @BuiltValueField(wireName: r'title')
    String get title;

    @BuiltValueField(wireName: r'firstName')
    String get firstName;

    @BuiltValueField(wireName: r'lastName')
    String get lastName;

    @BuiltValueField(wireName: r'telephone')
    String get telephone;

    @BuiltValueField(wireName: r'email')
    String get email;

    ContactInfo._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ContactInfoBuilder b) => b;

    factory ContactInfo([void updates(ContactInfoBuilder b)]) = _$ContactInfo;

    @BuiltValueSerializer(custom: true)
    static Serializer<ContactInfo> get serializer => _$ContactInfoSerializer();
}

class _$ContactInfoSerializer implements StructuredSerializer<ContactInfo> {
    @override
    final Iterable<Type> types = const [ContactInfo, _$ContactInfo];

    @override
    final String wireName = r'ContactInfo';

    @override
    Iterable<Object?> serialize(Serializers serializers, ContactInfo object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'companyName')
            ..add(serializers.serialize(object.companyName,
                specifiedType: const FullType(String)));
        result
            ..add(r'salutation')
            ..add(serializers.serialize(object.salutation,
                specifiedType: const FullType(String)));
        result
            ..add(r'title')
            ..add(serializers.serialize(object.title,
                specifiedType: const FullType(String)));
        result
            ..add(r'firstName')
            ..add(serializers.serialize(object.firstName,
                specifiedType: const FullType(String)));
        result
            ..add(r'lastName')
            ..add(serializers.serialize(object.lastName,
                specifiedType: const FullType(String)));
        result
            ..add(r'telephone')
            ..add(serializers.serialize(object.telephone,
                specifiedType: const FullType(String)));
        result
            ..add(r'email')
            ..add(serializers.serialize(object.email,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    ContactInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ContactInfoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'companyName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companyName = valueDes;
                    break;
                case r'salutation':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.salutation = valueDes;
                    break;
                case r'title':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.title = valueDes;
                    break;
                case r'firstName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.firstName = valueDes;
                    break;
                case r'lastName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.lastName = valueDes;
                    break;
                case r'telephone':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.telephone = valueDes;
                    break;
                case r'email':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.email = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

