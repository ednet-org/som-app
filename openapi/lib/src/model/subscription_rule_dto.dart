//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:openapi/src/model/restriction_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_rule_dto.g.dart';

/// SubscriptionRuleDto
///
/// Properties:
/// * [id] 
/// * [upperLimit] 
/// * [restriction] 
abstract class SubscriptionRuleDto implements Built<SubscriptionRuleDto, SubscriptionRuleDtoBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'upperLimit')
    int? get upperLimit;

    @BuiltValueField(wireName: r'restriction')
    RestrictionType? get restriction;
    // enum restrictionEnum {  0,  1,  2,  3,  4,  5,  };

    SubscriptionRuleDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionRuleDtoBuilder b) => b;

    factory SubscriptionRuleDto([void updates(SubscriptionRuleDtoBuilder b)]) = _$SubscriptionRuleDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionRuleDto> get serializer => _$SubscriptionRuleDtoSerializer();
}

class _$SubscriptionRuleDtoSerializer implements StructuredSerializer<SubscriptionRuleDto> {
    @override
    final Iterable<Type> types = const [SubscriptionRuleDto, _$SubscriptionRuleDto];

    @override
    final String wireName = r'SubscriptionRuleDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionRuleDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.upperLimit != null) {
            result
                ..add(r'upperLimit')
                ..add(serializers.serialize(object.upperLimit,
                    specifiedType: const FullType(int)));
        }
        if (object.restriction != null) {
            result
                ..add(r'restriction')
                ..add(serializers.serialize(object.restriction,
                    specifiedType: const FullType(RestrictionType)));
        }
        return result;
    }

    @override
    SubscriptionRuleDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionRuleDtoBuilder();

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
                case r'upperLimit':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.upperLimit = valueDes;
                    break;
                case r'restriction':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(RestrictionType)) as RestrictionType;
                    result.restriction = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

