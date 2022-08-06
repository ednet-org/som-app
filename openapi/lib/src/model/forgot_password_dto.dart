//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forgot_password_dto.g.dart';

/// ForgotPasswordDto
///
/// Properties:
/// * [email] 
abstract class ForgotPasswordDto implements Built<ForgotPasswordDto, ForgotPasswordDtoBuilder> {
    @BuiltValueField(wireName: r'email')
    String? get email;

    ForgotPasswordDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(ForgotPasswordDtoBuilder b) => b;

    factory ForgotPasswordDto([void updates(ForgotPasswordDtoBuilder b)]) = _$ForgotPasswordDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<ForgotPasswordDto> get serializer => _$ForgotPasswordDtoSerializer();
}

class _$ForgotPasswordDtoSerializer implements StructuredSerializer<ForgotPasswordDto> {
    @override
    final Iterable<Type> types = const [ForgotPasswordDto, _$ForgotPasswordDto];

    @override
    final String wireName = r'ForgotPasswordDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, ForgotPasswordDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.email != null) {
            result
                ..add(r'email')
                ..add(serializers.serialize(object.email,
                    specifiedType: const FullType.nullable(String)));
        }
        return result;
    }

    @override
    ForgotPasswordDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = ForgotPasswordDtoBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'email':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(String)) as String?;
                    if (valueDes == null) continue;
                    result.email = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

