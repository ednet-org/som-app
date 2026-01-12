//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/company_registration.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/user_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'consultants_register_company_post_request.g.dart';

/// ConsultantsRegisterCompanyPostRequest
///
/// Properties:
/// * [company] 
/// * [users] 
abstract class ConsultantsRegisterCompanyPostRequest implements Built<ConsultantsRegisterCompanyPostRequest, ConsultantsRegisterCompanyPostRequestBuilder> {
    @BuiltValueField(wireName: r'company')
    CompanyRegistration get company;

    @BuiltValueField(wireName: r'users')
    BuiltList<UserRegistration> get users;

    ConsultantsRegisterCompanyPostRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ConsultantsRegisterCompanyPostRequestBuilder b) => b;

    factory ConsultantsRegisterCompanyPostRequest([void updates(ConsultantsRegisterCompanyPostRequestBuilder b)]) = _$ConsultantsRegisterCompanyPostRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<ConsultantsRegisterCompanyPostRequest> get serializer => _$ConsultantsRegisterCompanyPostRequestSerializer();
}

class _$ConsultantsRegisterCompanyPostRequestSerializer implements StructuredSerializer<ConsultantsRegisterCompanyPostRequest> {
    @override
    final Iterable<Type> types = const [ConsultantsRegisterCompanyPostRequest, _$ConsultantsRegisterCompanyPostRequest];

    @override
    final String wireName = r'ConsultantsRegisterCompanyPostRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, ConsultantsRegisterCompanyPostRequest object,
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
    ConsultantsRegisterCompanyPostRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ConsultantsRegisterCompanyPostRequestBuilder();

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

