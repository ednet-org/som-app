//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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
/// * [summaryPdfPath] 
/// * [forwardedAt] 
/// * [resolvedAt] 
/// * [buyerDecision] 
/// * [providerDecision] 
@BuiltValue()
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

  @BuiltValueField(wireName: r'summaryPdfPath')
  String? get summaryPdfPath;

  @BuiltValueField(wireName: r'forwardedAt')
  DateTime? get forwardedAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'buyerDecision')
  String? get buyerDecision;

  @BuiltValueField(wireName: r'providerDecision')
  String? get providerDecision;

  Offer._();

  factory Offer([void updates(OfferBuilder b)]) = _$Offer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Offer> get serializer => _$OfferSerializer();
}

class _$OfferSerializer implements PrimitiveSerializer<Offer> {
  @override
  final Iterable<Type> types = const [Offer, _$Offer];

  @override
  final String wireName = r'Offer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Offer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.inquiryId != null) {
      yield r'inquiryId';
      yield serializers.serialize(
        object.inquiryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerCompanyId != null) {
      yield r'providerCompanyId';
      yield serializers.serialize(
        object.providerCompanyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.pdfPath != null) {
      yield r'pdfPath';
      yield serializers.serialize(
        object.pdfPath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.summaryPdfPath != null) {
      yield r'summaryPdfPath';
      yield serializers.serialize(
        object.summaryPdfPath,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.forwardedAt != null) {
      yield r'forwardedAt';
      yield serializers.serialize(
        object.forwardedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.resolvedAt != null) {
      yield r'resolvedAt';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.buyerDecision != null) {
      yield r'buyerDecision';
      yield serializers.serialize(
        object.buyerDecision,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.providerDecision != null) {
      yield r'providerDecision';
      yield serializers.serialize(
        object.providerDecision,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Offer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OfferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'inquiryId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inquiryId = valueDes;
          break;
        case r'providerCompanyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerCompanyId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'pdfPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pdfPath = valueDes;
          break;
        case r'summaryPdfPath':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.summaryPdfPath = valueDes;
          break;
        case r'forwardedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.forwardedAt = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        case r'buyerDecision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buyerDecision = valueDes;
          break;
        case r'providerDecision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerDecision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Offer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OfferBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

