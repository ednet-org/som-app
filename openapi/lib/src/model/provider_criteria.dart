//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_criteria.g.dart';

/// ProviderCriteria
///
/// Properties:
/// * [providerZip] 
/// * [radiusKm] 
/// * [providerType] 
/// * [companySize] 
abstract class ProviderCriteria implements Built<ProviderCriteria, ProviderCriteriaBuilder> {
    @BuiltValueField(wireName: r'providerZip')
    String? get providerZip;

    @BuiltValueField(wireName: r'radiusKm')
    int? get radiusKm;

    @BuiltValueField(wireName: r'providerType')
    String? get providerType;

    @BuiltValueField(wireName: r'companySize')
    String? get companySize;

    ProviderCriteria._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ProviderCriteriaBuilder b) => b;

    factory ProviderCriteria([void updates(ProviderCriteriaBuilder b)]) = _$ProviderCriteria;

    @BuiltValueSerializer(custom: true)
    static Serializer<ProviderCriteria> get serializer => _$ProviderCriteriaSerializer();
}

class _$ProviderCriteriaSerializer implements StructuredSerializer<ProviderCriteria> {
    @override
    final Iterable<Type> types = const [ProviderCriteria, _$ProviderCriteria];

    @override
    final String wireName = r'ProviderCriteria';

    @override
    Iterable<Object?> serialize(Serializers serializers, ProviderCriteria object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.providerZip != null) {
            result
                ..add(r'providerZip')
                ..add(serializers.serialize(object.providerZip,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.radiusKm != null) {
            result
                ..add(r'radiusKm')
                ..add(serializers.serialize(object.radiusKm,
                    specifiedType: const FullType.nullable(int)));
        }
        if (object.providerType != null) {
            result
                ..add(r'providerType')
                ..add(serializers.serialize(object.providerType,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.companySize != null) {
            result
                ..add(r'companySize')
                ..add(serializers.serialize(object.companySize,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    ProviderCriteria deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ProviderCriteriaBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'providerZip':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.providerZip = valueDes;
                    break;
                case r'radiusKm':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(int)) as int?;
                    if (valueDes == null) continue;
                    result.radiusKm = valueDes;
                    break;
                case r'providerType':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.providerType = valueDes;
                    break;
                case r'companySize':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.companySize = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

