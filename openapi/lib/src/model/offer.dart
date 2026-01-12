//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'offer.g.dart';

/// Offer
///
/// Properties:
/// * [id] 
/// * [inquiryId] 
/// * [providerCompanyId] 
/// * [status] 
/// * [pdfPath] 
/// * [forwardedAt] 
/// * [resolvedAt] 
/// * [buyerDecision] 
/// * [providerDecision] 
abstract class Offer implements Built<Offer, OfferBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'inquiryId')
    String? get inquiryId;

    @BuiltValueField(wireName: r'providerCompanyId')
    String? get providerCompanyId;

    @BuiltValueField(wireName: r'status')
    String? get status;

    @BuiltValueField(wireName: r'pdfPath')
    String? get pdfPath;

    @BuiltValueField(wireName: r'forwardedAt')
    DateTime? get forwardedAt;

    @BuiltValueField(wireName: r'resolvedAt')
    DateTime? get resolvedAt;

    @BuiltValueField(wireName: r'buyerDecision')
    String? get buyerDecision;

    @BuiltValueField(wireName: r'providerDecision')
    String? get providerDecision;

    Offer._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(OfferBuilder b) => b;

    factory Offer([void updates(OfferBuilder b)]) = _$Offer;

    @BuiltValueSerializer(custom: true)
    static Serializer<Offer> get serializer => _$OfferSerializer();
}

class _$OfferSerializer implements StructuredSerializer<Offer> {
    @override
    final Iterable<Type> types = const [Offer, _$Offer];

    @override
    final String wireName = r'Offer';

    @override
    Iterable<Object?> serialize(Serializers serializers, Offer object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.inquiryId != null) {
            result
                ..add(r'inquiryId')
                ..add(serializers.serialize(object.inquiryId,
                    specifiedType: const FullType(String)));
        }
        if (object.providerCompanyId != null) {
            result
                ..add(r'providerCompanyId')
                ..add(serializers.serialize(object.providerCompanyId,
                    specifiedType: const FullType(String)));
        }
        if (object.status != null) {
            result
                ..add(r'status')
                ..add(serializers.serialize(object.status,
                    specifiedType: const FullType(String)));
        }
        if (object.pdfPath != null) {
            result
                ..add(r'pdfPath')
                ..add(serializers.serialize(object.pdfPath,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.forwardedAt != null) {
            result
                ..add(r'forwardedAt')
                ..add(serializers.serialize(object.forwardedAt,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        if (object.resolvedAt != null) {
            result
                ..add(r'resolvedAt')
                ..add(serializers.serialize(object.resolvedAt,
                    specifiedType: const FullType.nullable(DateTime)));
        }
        if (object.buyerDecision != null) {
            result
                ..add(r'buyerDecision')
                ..add(serializers.serialize(object.buyerDecision,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.providerDecision != null) {
            result
                ..add(r'providerDecision')
                ..add(serializers.serialize(object.providerDecision,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    Offer deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = OfferBuilder();

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
                case r'inquiryId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.inquiryId = valueDes;
                    break;
                case r'providerCompanyId':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.providerCompanyId = valueDes;
                    break;
                case r'status':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.status = valueDes;
                    break;
                case r'pdfPath':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.pdfPath = valueDes;
                    break;
                case r'forwardedAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.forwardedAt = valueDes;
                    break;
                case r'resolvedAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(DateTime)) as DateTime?;
                    if (valueDes == null) continue;
                    result.resolvedAt = valueDes;
                    break;
                case r'buyerDecision':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.buyerDecision = valueDes;
                    break;
                case r'providerDecision':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.providerDecision = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

