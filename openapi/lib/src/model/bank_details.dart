//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bank_details.g.dart';

/// BankDetails
///
/// Properties:
/// * [iban] 
/// * [bic] 
/// * [accountOwner] 
abstract class BankDetails implements Built<BankDetails, BankDetailsBuilder> {
    @BuiltValueField(wireName: r'iban')
    String get iban;

    @BuiltValueField(wireName: r'bic')
    String get bic;

    @BuiltValueField(wireName: r'accountOwner')
    String get accountOwner;

    BankDetails._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(BankDetailsBuilder b) => b;

    factory BankDetails([void updates(BankDetailsBuilder b)]) = _$BankDetails;

    @BuiltValueSerializer(custom: true)
    static Serializer<BankDetails> get serializer => _$BankDetailsSerializer();
}

class _$BankDetailsSerializer implements StructuredSerializer<BankDetails> {
    @override
    final Iterable<Type> types = const [BankDetails, _$BankDetails];

    @override
    final String wireName = r'BankDetails';

    @override
    Iterable<Object?> serialize(Serializers serializers, BankDetails object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        result
            ..add(r'iban')
            ..add(serializers.serialize(object.iban,
                specifiedType: const FullType(String)));
        result
            ..add(r'bic')
            ..add(serializers.serialize(object.bic,
                specifiedType: const FullType(String)));
        result
            ..add(r'accountOwner')
            ..add(serializers.serialize(object.accountOwner,
                specifiedType: const FullType(String)));
        return result;
    }

    @override
    BankDetails deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = BankDetailsBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'iban':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.iban = valueDes;
                    break;
                case r'bic':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.bic = valueDes;
                    break;
                case r'accountOwner':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.accountOwner = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

