//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bank_details.g.dart';

/// BankDetails
///
/// Properties:
/// * [iban] 
/// * [bic] 
/// * [accountOwner] 
@BuiltValue()
abstract class BankDetails implements Built<BankDetails, BankDetailsBuilder> {
  @BuiltValueField(wireName: r'iban')
  String get iban;

  @BuiltValueField(wireName: r'bic')
  String get bic;

  @BuiltValueField(wireName: r'accountOwner')
  String get accountOwner;

  BankDetails._();

  factory BankDetails([void updates(BankDetailsBuilder b)]) = _$BankDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BankDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BankDetails> get serializer => _$BankDetailsSerializer();
}

class _$BankDetailsSerializer implements PrimitiveSerializer<BankDetails> {
  @override
  final Iterable<Type> types = const [BankDetails, _$BankDetails];

  @override
  final String wireName = r'BankDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BankDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'iban';
    yield serializers.serialize(
      object.iban,
      specifiedType: const FullType(String),
    );
    yield r'bic';
    yield serializers.serialize(
      object.bic,
      specifiedType: const FullType(String),
    );
    yield r'accountOwner';
    yield serializers.serialize(
      object.accountOwner,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BankDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BankDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'iban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iban = valueDes;
          break;
        case r'bic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bic = valueDes;
          break;
        case r'accountOwner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountOwner = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BankDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BankDetailsBuilder();
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

