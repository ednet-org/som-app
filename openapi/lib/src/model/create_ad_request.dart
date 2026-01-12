//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ad_request.g.dart';

/// CreateAdRequest
///
/// Properties:
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
abstract class CreateAdRequest implements Built<CreateAdRequest, CreateAdRequestBuilder> {
    @BuiltValueField(wireName: r'type')
    String get type;

    @BuiltValueField(wireName: r'status')
    String get status;

    @BuiltValueField(wireName: r'branchId')
    String get branchId;

    @BuiltValueField(wireName: r'url')
    String get url;

    @BuiltValueField(wireName: r'imagePath')
    String? get imagePath;

    @BuiltValueField(wireName: r'headline')
    String? get headline;

    @BuiltValueField(wireName: r'description')
    String? get description;

    @BuiltValueField(wireName: r'startDate')
    String? get startDate;

    @BuiltValueField(wireName: r'endDate')
    String? get endDate;

    @BuiltValueField(wireName: r'bannerDate')
    String? get bannerDate;

    CreateAdRequest._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(CreateAdRequestBuilder b) => b;

    factory CreateAdRequest([void updates(CreateAdRequestBuilder b)]) = _$CreateAdRequest;

    @BuiltValueSerializer(custom: true)
    static Serializer<CreateAdRequest> get serializer => _$CreateAdRequestSerializer();
}

class _$CreateAdRequestSerializer implements StructuredSerializer<CreateAdRequest> {
    @override
    final Iterable<Type> types = const [CreateAdRequest, _$CreateAdRequest];

    @override
    final String wireName = r'CreateAdRequest';

    @override
    Iterable<Object?> serialize(Serializers serializers, CreateAdRequest object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'type')
            ..add(serializers.serialize(object.type,
                specifiedType: const FullType(String)));
        result
            ..add(r'status')
            ..add(serializers.serialize(object.status,
                specifiedType: const FullType(String)));
        result
            ..add(r'branchId')
            ..add(serializers.serialize(object.branchId,
                specifiedType: const FullType(String)));
        result
            ..add(r'url')
            ..add(serializers.serialize(object.url,
                specifiedType: const FullType(String)));
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
                    specifiedType: const FullType(String)));
        }
        if (object.description != null) {
            result
                ..add(r'description')
                ..add(serializers.serialize(object.description,
                    specifiedType: const FullType(String)));
        }
        if (object.startDate != null) {
            result
                ..add(r'startDate')
                ..add(serializers.serialize(object.startDate,
                    specifiedType: const FullType(String)));
        }
        if (object.endDate != null) {
            result
                ..add(r'endDate')
                ..add(serializers.serialize(object.endDate,
                    specifiedType: const FullType(String)));
        }
        if (object.bannerDate != null) {
            result
                ..add(r'bannerDate')
                ..add(serializers.serialize(object.bannerDate,
                    specifiedType: const FullType(String)));
        }
        return result;
    }

    @override
    CreateAdRequest deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = CreateAdRequestBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
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
                        specifiedType: const FullType(String)) as String;
                    result.headline = valueDes;
                    break;
                case r'description':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.description = valueDes;
                    break;
                case r'startDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.startDate = valueDes;
                    break;
                case r'endDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.endDate = valueDes;
                    break;
                case r'bannerDate':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.bannerDate = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

