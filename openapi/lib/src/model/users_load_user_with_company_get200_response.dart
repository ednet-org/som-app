//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/address.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'users_load_user_with_company_get200_response.g.dart';

/// UsersLoadUserWithCompanyGet200Response
///
/// Properties:
/// * [userId] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephoneNr] 
/// * [emailAddress] 
/// * [companyId] 
/// * [companyName] 
/// * [companyAddress] 
abstract class UsersLoadUserWithCompanyGet200Response implements Built<UsersLoadUserWithCompanyGet200Response, UsersLoadUserWithCompanyGet200ResponseBuilder> {
    @BuiltValueField(wireName: r'userId')
    String? get userId;

    @BuiltValueField(wireName: r'salutation')
    String? get salutation;

    @BuiltValueField(wireName: r'title')
    String? get title;

    @BuiltValueField(wireName: r'firstName')
    String? get firstName;

    @BuiltValueField(wireName: r'lastName')
    String? get lastName;

    @BuiltValueField(wireName: r'telephoneNr')
    String? get telephoneNr;

    @BuiltValueField(wireName: r'emailAddress')
    String? get emailAddress;

    @BuiltValueField(wireName: r'companyId')
    String? get companyId;

    @BuiltValueField(wireName: r'companyName')
    String? get companyName;

    @BuiltValueField(wireName: r'companyAddress')
    Address? get companyAddress;

    UsersLoadUserWithCompanyGet200Response._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(UsersLoadUserWithCompanyGet200ResponseBuilder b) => b;

    factory UsersLoadUserWithCompanyGet200Response([void updates(UsersLoadUserWithCompanyGet200ResponseBuilder b)]) = _$UsersLoadUserWithCompanyGet200Response;

    @BuiltValueSerializer(custom: true)
    static Serializer<UsersLoadUserWithCompanyGet200Response> get serializer => _$UsersLoadUserWithCompanyGet200ResponseSerializer();
}

class _$UsersLoadUserWithCompanyGet200ResponseSerializer implements StructuredSerializer<UsersLoadUserWithCompanyGet200Response> {
    @override
    final Iterable<Type> types = const [UsersLoadUserWithCompanyGet200Response, _$UsersLoadUserWithCompanyGet200Response];

    @override
    final String wireName = r'UsersLoadUserWithCompanyGet200Response';

    @override
    Iterable<Object?> serialize(Serializers serializers, UsersLoadUserWithCompanyGet200Response object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.userId != null) {
            result
                ..add(r'userId')
                ..add(serializers.serialize(object.userId,
                    specifiedType: const FullType(String)));
        }
        if (object.salutation != null) {
            result
                ..add(r'salutation')
                ..add(serializers.serialize(object.salutation,
                    specifiedType: const FullType(String)));
        }
        if (object.title != null) {
            result
                ..add(r'title')
                ..add(serializers.serialize(object.title,
                    specifiedType: const FullType(String)));
        }
        if (object.firstName != null) {
            result
                ..add(r'firstName')
                ..add(serializers.serialize(object.firstName,
                    specifiedType: const FullType(String)));
        }
        if (object.lastName != null) {
            result
                ..add(r'lastName')
                ..add(serializers.serialize(object.lastName,
                    specifiedType: const FullType(String)));
        }
        if (object.telephoneNr != null) {
            result
                ..add(r'telephoneNr')
                ..add(serializers.serialize(object.telephoneNr,
                    specifiedType: const FullType(String)));
        }
        if (object.emailAddress != null) {
            result
                ..add(r'emailAddress')
                ..add(serializers.serialize(object.emailAddress,
                    specifiedType: const FullType(String)));
        }
        if (object.companyId != null) {
            result
                ..add(r'companyId')
                ..add(serializers.serialize(object.companyId,
                    specifiedType: const FullType(String)));
        }
        if (object.companyName != null) {
            result
                ..add(r'companyName')
                ..add(serializers.serialize(object.companyName,
                    specifiedType: const FullType(String)));
        }
        if (object.companyAddress != null) {
            result
                ..add(r'companyAddress')
                ..add(serializers.serialize(object.companyAddress,
                    specifiedType: const FullType(Address)));
        }
        return result;
    }

    @override
    UsersLoadUserWithCompanyGet200Response deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = UsersLoadUserWithCompanyGet200ResponseBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'userId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.userId = valueDes;
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
                case r'telephoneNr':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.telephoneNr = valueDes;
                    break;
                case r'emailAddress':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.emailAddress = valueDes;
                    break;
                case r'companyId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companyId = valueDes;
                    break;
                case r'companyName':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companyName = valueDes;
                    break;
                case r'companyAddress':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(Address)) as Address;
                    result.companyAddress.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

