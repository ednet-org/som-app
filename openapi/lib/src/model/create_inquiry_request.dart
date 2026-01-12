//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_inquiry_request.g.dart';

/// CreateInquiryRequest
///
/// Properties:
/// * [branchId] 
/// * [categoryId] 
/// * [productTags] 
/// * [deadline] 
/// * [deliveryZips] 
/// * [numberOfProviders] 
/// * [description] 
/// * [providerZip] 
/// * [radiusKm] 
/// * [providerType] 
/// * [providerCompanySize] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephone] 
/// * [email] 
abstract class CreateInquiryRequest implements Built<CreateInquiryRequest, CreateInquiryRequestBuilder> {
    @BuiltValueField(wireName: r'branchId')
    String get branchId;

    @BuiltValueField(wireName: r'categoryId')
    String get categoryId;

    @BuiltValueField(wireName: r'productTags')
    BuiltList<String>? get productTags;

    @BuiltValueField(wireName: r'deadline')
    DateTime get deadline;

    @BuiltValueField(wireName: r'deliveryZips')
    BuiltList<String> get deliveryZips;

    @BuiltValueField(wireName: r'numberOfProviders')
    int get numberOfProviders;

    @BuiltValueField(wireName: r'description')
    String? get description;

    @BuiltValueField(wireName: r'providerZip')
    String? get providerZip;

    @BuiltValueField(wireName: r'radiusKm')
    int? get radiusKm;

    @BuiltValueField(wireName: r'providerType')
    String? get providerType;

    @BuiltValueField(wireName: r'providerCompanySize')
    String? get providerCompanySize;

    @BuiltValueField(wireName: r'salutation')
    String? get salutation;

    @BuiltValueField(wireName: r'title')
    String? get title;

    @BuiltValueField(wireName: r'firstName')
    String? get firstName;

    @BuiltValueField(wireName: r'lastName')
    String? get lastName;

    @BuiltValueField(wireName: r'telephone')
    String? get telephone;

    @BuiltValueField(wireName: r'email')
    String? get email;

    CreateInquiryRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CreateInquiryRequestBuilder b) => b;

    factory CreateInquiryRequest([void updates(CreateInquiryRequestBuilder b)]) = _$CreateInquiryRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<CreateInquiryRequest> get serializer => _$CreateInquiryRequestSerializer();
}

class _$CreateInquiryRequestSerializer implements StructuredSerializer<CreateInquiryRequest> {
    @override
    final Iterable<Type> types = const [CreateInquiryRequest, _$CreateInquiryRequest];

    @override
    final String wireName = r'CreateInquiryRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, CreateInquiryRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'branchId')
            ..add(serializers.serialize(object.branchId,
                specifiedType: const FullType(String)));
        result
            ..add(r'categoryId')
            ..add(serializers.serialize(object.categoryId,
                specifiedType: const FullType(String)));
        if (object.productTags != null) {
            result
                ..add(r'productTags')
                ..add(serializers.serialize(object.productTags,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        result
            ..add(r'deadline')
            ..add(serializers.serialize(object.deadline,
                specifiedType: const FullType(DateTime)));
        result
            ..add(r'deliveryZips')
            ..add(serializers.serialize(object.deliveryZips,
                specifiedType: const FullType(BuiltList, [FullType(String)])));
        result
            ..add(r'numberOfProviders')
            ..add(serializers.serialize(object.numberOfProviders,
                specifiedType: const FullType(int)));
        if (object.description != null) {
            result
                ..add(r'description')
                ..add(serializers.serialize(object.description,
                    specifiedType: const FullType(String)));
        }
        if (object.providerZip != null) {
            result
                ..add(r'providerZip')
                ..add(serializers.serialize(object.providerZip,
                    specifiedType: const FullType(String)));
        }
        if (object.radiusKm != null) {
            result
                ..add(r'radiusKm')
                ..add(serializers.serialize(object.radiusKm,
                    specifiedType: const FullType(int)));
        }
        if (object.providerType != null) {
            result
                ..add(r'providerType')
                ..add(serializers.serialize(object.providerType,
                    specifiedType: const FullType(String)));
        }
        if (object.providerCompanySize != null) {
            result
                ..add(r'providerCompanySize')
                ..add(serializers.serialize(object.providerCompanySize,
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
        if (object.telephone != null) {
            result
                ..add(r'telephone')
                ..add(serializers.serialize(object.telephone,
                    specifiedType: const FullType(String)));
        }
        if (object.email != null) {
            result
                ..add(r'email')
                ..add(serializers.serialize(object.email,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    CreateInquiryRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CreateInquiryRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'branchId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.branchId = valueDes;
                    break;
                case r'categoryId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.categoryId = valueDes;
                    break;
                case r'productTags':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.productTags.replace(valueDes);
                    break;
                case r'deadline':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(DateTime)) as DateTime;
                    result.deadline = valueDes;
                    break;
                case r'deliveryZips':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.deliveryZips.replace(valueDes);
                    break;
                case r'numberOfProviders':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.numberOfProviders = valueDes;
                    break;
                case r'description':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.description = valueDes;
                    break;
                case r'providerZip':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.providerZip = valueDes;
                    break;
                case r'radiusKm':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.radiusKm = valueDes;
                    break;
                case r'providerType':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.providerType = valueDes;
                    break;
                case r'providerCompanySize':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.providerCompanySize = valueDes;
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

