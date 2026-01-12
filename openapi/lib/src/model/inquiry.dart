//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/contact_info.dart';
import 'package:openapi/src/model/provider_criteria.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inquiry.g.dart';

/// Inquiry
///
/// Properties:
/// * [id] 
/// * [buyerCompanyId] 
/// * [createdByUserId] 
/// * [status] 
/// * [branchId] 
/// * [categoryId] 
/// * [productTags] 
/// * [deadline] 
/// * [deliveryZips] 
/// * [numberOfProviders] 
/// * [description] 
/// * [pdfPath] 
/// * [providerCriteria] 
/// * [contactInfo] 
/// * [notifiedAt] 
/// * [createdAt] 
/// * [updatedAt] 
abstract class Inquiry implements Built<Inquiry, InquiryBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'buyerCompanyId')
    String? get buyerCompanyId;

    @BuiltValueField(wireName: r'createdByUserId')
    String? get createdByUserId;

    @BuiltValueField(wireName: r'status')
    String? get status;

    @BuiltValueField(wireName: r'branchId')
    String? get branchId;

    @BuiltValueField(wireName: r'categoryId')
    String? get categoryId;

    @BuiltValueField(wireName: r'productTags')
    BuiltList<String>? get productTags;

    @BuiltValueField(wireName: r'deadline')
    DateTime? get deadline;

    @BuiltValueField(wireName: r'deliveryZips')
    BuiltList<String>? get deliveryZips;

    @BuiltValueField(wireName: r'numberOfProviders')
    int? get numberOfProviders;

    @BuiltValueField(wireName: r'description')
    String? get description;

    @BuiltValueField(wireName: r'pdfPath')
    String? get pdfPath;

    @BuiltValueField(wireName: r'providerCriteria')
    ProviderCriteria? get providerCriteria;

    @BuiltValueField(wireName: r'contactInfo')
    ContactInfo? get contactInfo;

    @BuiltValueField(wireName: r'notifiedAt')
    DateTime? get notifiedAt;

    @BuiltValueField(wireName: r'createdAt')
    DateTime? get createdAt;

    @BuiltValueField(wireName: r'updatedAt')
    DateTime? get updatedAt;

    Inquiry._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(InquiryBuilder b) => b;

    factory Inquiry([void updates(InquiryBuilder b)]) = _$Inquiry;

    @BuiltValueSerializer(custom: true)
    static Serializer<Inquiry> get serializer => _$InquirySerializer();
}

class _$InquirySerializer implements StructuredSerializer<Inquiry> {
    @override
    final Iterable<Type> types = const [Inquiry, _$Inquiry];

    @override
    final String wireName = r'Inquiry';

    @override
    Iterable<Object?> serialize(Serializers serializers, Inquiry object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.buyerCompanyId != null) {
            result
                ..add(r'buyerCompanyId')
                ..add(serializers.serialize(object.buyerCompanyId,
                    specifiedType: const FullType(String)));
        }
        if (object.createdByUserId != null) {
            result
                ..add(r'createdByUserId')
                ..add(serializers.serialize(object.createdByUserId,
                    specifiedType: const FullType(String)));
        }
        if (object.status != null) {
            result
                ..add(r'status')
                ..add(serializers.serialize(object.status,
                    specifiedType: const FullType(String)));
        }
        if (object.branchId != null) {
            result
                ..add(r'branchId')
                ..add(serializers.serialize(object.branchId,
                    specifiedType: const FullType(String)));
        }
        if (object.categoryId != null) {
            result
                ..add(r'categoryId')
                ..add(serializers.serialize(object.categoryId,
                    specifiedType: const FullType(String)));
        }
        if (object.productTags != null) {
            result
                ..add(r'productTags')
                ..add(serializers.serialize(object.productTags,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        if (object.deadline != null) {
            result
                ..add(r'deadline')
                ..add(serializers.serialize(object.deadline,
                    specifiedType: const FullType(DateTime)));
        }
        if (object.deliveryZips != null) {
            result
                ..add(r'deliveryZips')
                ..add(serializers.serialize(object.deliveryZips,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        if (object.numberOfProviders != null) {
            result
                ..add(r'numberOfProviders')
                ..add(serializers.serialize(object.numberOfProviders,
                    specifiedType: const FullType(int)));
        }
        if (object.description != null) {
            result
                ..add(r'description')
                ..add(serializers.serialize(object.description,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.pdfPath != null) {
            result
                ..add(r'pdfPath')
                ..add(serializers.serialize(object.pdfPath,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.providerCriteria != null) {
            result
                ..add(r'providerCriteria')
                ..add(serializers.serialize(object.providerCriteria,
                    specifiedType: const FullType(ProviderCriteria)));
        }
        if (object.contactInfo != null) {
            result
                ..add(r'contactInfo')
                ..add(serializers.serialize(object.contactInfo,
                    specifiedType: const FullType(ContactInfo)));
        }
        if (object.notifiedAt != null) {
            result
                ..add(r'notifiedAt')
                ..add(serializers.serialize(object.notifiedAt,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        if (object.createdAt != null) {
            result
                ..add(r'createdAt')
                ..add(serializers.serialize(object.createdAt,
                    specifiedType: const FullType(DateTime)));
        }
        if (object.updatedAt != null) {
            result
                ..add(r'updatedAt')
                ..add(serializers.serialize(object.updatedAt,
                    specifiedType: const FullType(DateTime)));
        }
        return result;
    }

    @override
    Inquiry deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = InquiryBuilder();

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
                case r'buyerCompanyId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.buyerCompanyId = valueDes;
                    break;
                case r'createdByUserId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.createdByUserId = valueDes;
                    break;
                case r'status':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.status = valueDes;
                    break;
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
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.description = valueDes;
                    break;
                case r'pdfPath':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.pdfPath = valueDes;
                    break;
                case r'providerCriteria':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(ProviderCriteria)) as ProviderCriteria;
                    result.providerCriteria.replace(valueDes);
                    break;
                case r'contactInfo':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(ContactInfo)) as ContactInfo;
                    result.contactInfo.replace(valueDes);
                    break;
                case r'notifiedAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.notifiedAt = valueDes;
                    break;
                case r'createdAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(DateTime)) as DateTime;
                    result.createdAt = valueDes;
                    break;
                case r'updatedAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(DateTime)) as DateTime;
                    result.updatedAt = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

