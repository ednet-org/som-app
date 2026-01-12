//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/company_registration.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_company_request.g.dart';

/// RegisterCompanyRequest
///
/// Properties:
/// * [company] 
/// * [users] 
abstract class RegisterCompanyRequest implements Built<RegisterCompanyRequest, RegisterCompanyRequestBuilder> {
    @BuiltValueField(wireName: r'company')
    CompanyRegistration get company;

    @BuiltValueField(wireName: r'users')
    BuiltList<UserRegistration> get users;

    RegisterCompanyRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(RegisterCompanyRequestBuilder b) => b;

    factory RegisterCompanyRequest([void updates(RegisterCompanyRequestBuilder b)]) = _$RegisterCompanyRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<RegisterCompanyRequest> get serializer => _$RegisterCompanyRequestSerializer();
}

class _$RegisterCompanyRequestSerializer implements StructuredSerializer<RegisterCompanyRequest> {
    @override
    final Iterable<Type> types = const [RegisterCompanyRequest, _$RegisterCompanyRequest];

    @override
    final String wireName = r'RegisterCompanyRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, RegisterCompanyRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'company')
            ..add(serializers.serialize(object.company,
                specifiedType: const FullType(CompanyRegistration)));
        result
            ..add(r'users')
            ..add(serializers.serialize(object.users,
                specifiedType: const FullType(BuiltList, [FullType(UserRegistration)])));
        return result;
    }

    @override
    RegisterCompanyRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = RegisterCompanyRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'company':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(CompanyRegistration)) as CompanyRegistration;
                    result.company.replace(valueDes);
                    break;
                case r'users':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(UserRegistration)])) as BuiltList<UserRegistration>;
                    result.users.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

