//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ad.g.dart';

/// Ad
///
/// Properties:
/// * [id] 
/// * [companyId] 
/// * [type] 
/// * [status] 
/// * [branchId] 
/// * [url] 
/// * [imagePath] 
/// * [headline] 
/// * [description] 
/// * [startDate] 
/// * [endDate] 
/// * [bannerDate] 
abstract class Ad implements Built<Ad, AdBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'companyId')
    String? get companyId;

    @BuiltValueField(wireName: r'type')
    String? get type;

    @BuiltValueField(wireName: r'status')
    String? get status;

    @BuiltValueField(wireName: r'branchId')
    String? get branchId;

    @BuiltValueField(wireName: r'url')
    String? get url;

    @BuiltValueField(wireName: r'imagePath')
    String? get imagePath;

    @BuiltValueField(wireName: r'headline')
    String? get headline;

    @BuiltValueField(wireName: r'description')
    String? get description;

    @BuiltValueField(wireName: r'startDate')
    DateTime? get startDate;

    @BuiltValueField(wireName: r'endDate')
    DateTime? get endDate;

    @BuiltValueField(wireName: r'bannerDate')
    DateTime? get bannerDate;

    Ad._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(AdBuilder b) => b;

    factory Ad([void updates(AdBuilder b)]) = _$Ad;

    @BuiltValueSerializer(custom: true)
    static Serializer<Ad> get serializer => _$AdSerializer();
}

class _$AdSerializer implements StructuredSerializer<Ad> {
    @override
    final Iterable<Type> types = const [Ad, _$Ad];

    @override
    final String wireName = r'Ad';

    @override
    Iterable<Object?> serialize(Serializers serializers, Ad object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.companyId != null) {
            result
                ..add(r'companyId')
                ..add(serializers.serialize(object.companyId,
                    specifiedType: const FullType(String)));
        }
        if (object.type != null) {
            result
                ..add(r'type')
                ..add(serializers.serialize(object.type,
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
        if (object.url != null) {
            result
                ..add(r'url')
                ..add(serializers.serialize(object.url,
                    specifiedType: const FullType(String)));
        }
        if (object.imagePath != null) {
            result
                ..add(r'imagePath')
                ..add(serializers.serialize(object.imagePath,
                    specifiedType: const FullType(String)));
        }
        if (object.headline != null) {
            result
                ..add(r'headline')
                ..add(serializers.serialize(object.headline,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.description != null) {
            result
                ..add(r'description')
                ..add(serializers.serialize(object.description,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.startDate != null) {
            result
                ..add(r'startDate')
                ..add(serializers.serialize(object.startDate,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        if (object.endDate != null) {
            result
                ..add(r'endDate')
                ..add(serializers.serialize(object.endDate,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        if (object.bannerDate != null) {
            result
                ..add(r'bannerDate')
                ..add(serializers.serialize(object.bannerDate,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        return result;
    }

    @override
    Ad deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = AdBuilder();

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
                case r'companyId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companyId = valueDes;
                    break;
                case r'type':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.type = valueDes;
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
                case r'url':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.url = valueDes;
                    break;
                case r'imagePath':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.imagePath = valueDes;
                    break;
                case r'headline':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.headline = valueDes;
                    break;
                case r'description':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.description = valueDes;
                    break;
                case r'startDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.startDate = valueDes;
                    break;
                case r'endDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.endDate = valueDes;
                    break;
                case r'bannerDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.bannerDate = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

