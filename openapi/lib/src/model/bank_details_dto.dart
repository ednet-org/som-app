//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bank_details_dto.g.dart';

/// BankDetailsDto
///
/// Properties:
/// * [iban] 
/// * [bic] 
/// * [accountOwner] 
abstract class BankDetailsDto implements Built<BankDetailsDto, BankDetailsDtoBuilder> {
    @BuiltValueField(wireName: r'iban')
    String? get iban;

    @BuiltValueField(wireName: r'bic')
    String? get bic;

    @BuiltValueField(wireName: r'accountOwner')
    String? get accountOwner;

    BankDetailsDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(BankDetailsDtoBuilder b) => b;

    factory BankDetailsDto([void updates(BankDetailsDtoBuilder b)]) = _$BankDetailsDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<BankDetailsDto> get serializer => _$BankDetailsDtoSerializer();
}

class _$BankDetailsDtoSerializer implements StructuredSerializer<BankDetailsDto> {
    @override
    final Iterable<Type> types = const [BankDetailsDto, _$BankDetailsDto];

    @override
    final String wireName = r'BankDetailsDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, BankDetailsDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.iban != null) {
            result
                ..add(r'iban')
                ..add(serializers.serialize(object.iban,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.bic != null) {
            result
                ..add(r'bic')
                ..add(serializers.serialize(object.bic,
                    specifiedType: const FullType.nullable(String)));
        }
        if (object.accountOwner != null) {
            result
                ..add(r'accountOwner')
                ..add(serializers.serialize(object.accountOwner,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    BankDetailsDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = BankDetailsDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'iban':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.iban = valueDes;
                    break;
                case r'bic':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.bic = valueDes;
                    break;
                case r'accountOwner':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.accountOwner = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

