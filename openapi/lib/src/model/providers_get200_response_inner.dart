//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'providers_get200_response_inner.g.dart';

/// ProvidersGet200ResponseInner
///
/// Properties:
/// * [companyId] 
/// * [companyName] 
/// * [companySize] 
/// * [providerType] 
/// * [postcode] 
/// * [branchIds] 
/// * [status] 
/// * [claimed] 
/// * [receivedInquiries] 
/// * [sentOffers] 
/// * [acceptedOffers] 
abstract class ProvidersGet200ResponseInner implements Built<ProvidersGet200ResponseInner, ProvidersGet200ResponseInnerBuilder> {
    @BuiltValueField(wireName: r'companyId')
    String? get companyId;

    @BuiltValueField(wireName: r'companyName')
    String? get companyName;

    @BuiltValueField(wireName: r'companySize')
    String? get companySize;

    @BuiltValueField(wireName: r'providerType')
    String? get providerType;

    @BuiltValueField(wireName: r'postcode')
    String? get postcode;

    @BuiltValueField(wireName: r'branchIds')
    BuiltList<String>? get branchIds;

    @BuiltValueField(wireName: r'status')
    String? get status;

    @BuiltValueField(wireName: r'claimed')
    bool? get claimed;

    @BuiltValueField(wireName: r'receivedInquiries')
    int? get receivedInquiries;

    @BuiltValueField(wireName: r'sentOffers')
    int? get sentOffers;

    @BuiltValueField(wireName: r'acceptedOffers')
    int? get acceptedOffers;

    ProvidersGet200ResponseInner._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ProvidersGet200ResponseInnerBuilder b) => b;

    factory ProvidersGet200ResponseInner([void updates(ProvidersGet200ResponseInnerBuilder b)]) = _$ProvidersGet200ResponseInner;

    @BuiltValueSerializer(custom: true)
    static Serializer<ProvidersGet200ResponseInner> get serializer => _$ProvidersGet200ResponseInnerSerializer();
}

class _$ProvidersGet200ResponseInnerSerializer implements StructuredSerializer<ProvidersGet200ResponseInner> {
    @override
    final Iterable<Type> types = const [ProvidersGet200ResponseInner, _$ProvidersGet200ResponseInner];

    @override
    final String wireName = r'ProvidersGet200ResponseInner';

    @override
    Iterable<Object?> serialize(Serializers serializers, ProvidersGet200ResponseInner object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
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
        if (object.companySize != null) {
            result
                ..add(r'companySize')
                ..add(serializers.serialize(object.companySize,
                    specifiedType: const FullType(String)));
        }
        if (object.providerType != null) {
            result
                ..add(r'providerType')
                ..add(serializers.serialize(object.providerType,
                    specifiedType: const FullType(String)));
        }
        if (object.postcode != null) {
            result
                ..add(r'postcode')
                ..add(serializers.serialize(object.postcode,
                    specifiedType: const FullType(String)));
        }
        if (object.branchIds != null) {
            result
                ..add(r'branchIds')
                ..add(serializers.serialize(object.branchIds,
                    specifiedType: const FullType(BuiltList, [FullType(String)])));
        }
        if (object.status != null) {
            result
                ..add(r'status')
                ..add(serializers.serialize(object.status,
                    specifiedType: const FullType(String)));
        }
        if (object.claimed != null) {
            result
                ..add(r'claimed')
                ..add(serializers.serialize(object.claimed,
                    specifiedType: const FullType(bool)));
        }
        if (object.receivedInquiries != null) {
            result
                ..add(r'receivedInquiries')
                ..add(serializers.serialize(object.receivedInquiries,
                    specifiedType: const FullType(int)));
        }
        if (object.sentOffers != null) {
            result
                ..add(r'sentOffers')
                ..add(serializers.serialize(object.sentOffers,
                    specifiedType: const FullType(int)));
        }
        if (object.acceptedOffers != null) {
            result
                ..add(r'acceptedOffers')
                ..add(serializers.serialize(object.acceptedOffers,
                    specifiedType: const FullType(int)));
        }
        return result;
    }

    @override
    ProvidersGet200ResponseInner deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ProvidersGet200ResponseInnerBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
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
                case r'companySize':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.companySize = valueDes;
                    break;
                case r'providerType':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.providerType = valueDes;
                    break;
                case r'postcode':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.postcode = valueDes;
                    break;
                case r'branchIds':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(String)])) as BuiltList<String>;
                    result.branchIds.replace(valueDes);
                    break;
                case r'status':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.status = valueDes;
                    break;
                case r'claimed':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(bool)) as bool;
                    result.claimed = valueDes;
                    break;
                case r'receivedInquiries':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.receivedInquiries = valueDes;
                    break;
                case r'sentOffers':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.sentOffers = valueDes;
                    break;
                case r'acceptedOffers':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.acceptedOffers = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

