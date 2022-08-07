//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_rule_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan_dto.g.dart';

/// SubscriptionPlanDto
///
/// Properties:
/// * [id] 
/// * [sortPriority] 
/// * [isActive] 
/// * [priceInSubunit] 
/// * [rules] 
/// * [createdAt] 
abstract class SubscriptionPlanDto implements Built<SubscriptionPlanDto, SubscriptionPlanDtoBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'sortPriority')
    int? get sortPriority;

    @BuiltValueField(wireName: r'isActive')
    bool? get isActive;

    @BuiltValueField(wireName: r'priceInSubunit')
    int? get priceInSubunit;

    @BuiltValueField(wireName: r'rules')
    BuiltList<SubscriptionRuleDto>? get rules;

    @BuiltValueField(wireName: r'createdAt')
    DateTime? get createdAt;

    SubscriptionPlanDto._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionPlanDtoBuilder b) => b;

    factory SubscriptionPlanDto([void updates(SubscriptionPlanDtoBuilder b)]) = _$SubscriptionPlanDto;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionPlanDto> get serializer => _$SubscriptionPlanDtoSerializer();
}

class _$SubscriptionPlanDtoSerializer implements StructuredSerializer<SubscriptionPlanDto> {
    @override
    final Iterable<Type> types = const [SubscriptionPlanDto, _$SubscriptionPlanDto];

    @override
    final String wireName = r'SubscriptionPlanDto';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionPlanDto object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.sortPriority != null) {
            result
                ..add(r'sortPriority')
                ..add(serializers.serialize(object.sortPriority,
                    specifiedType: const FullType(int)));
        }
        if (object.isActive != null) {
            result
                ..add(r'isActive')
                ..add(serializers.serialize(object.isActive,
                    specifiedType: const FullType(bool)));
        }
        if (object.priceInSubunit != null) {
            result
                ..add(r'priceInSubunit')
                ..add(serializers.serialize(object.priceInSubunit,
                    specifiedType: const FullType(int)));
        }
        if (object.rules != null) {
            result
                ..add(r'rules')
                ..add(serializers.serialize(object.rules,
                    specifiedType: const FullType.nullable(BuiltList, [FullType(SubscriptionRuleDto)])));
        }
        if (object.createdAt != null) {
            result
                ..add(r'createdAt')
                ..add(serializers.serialize(object.createdAt,
                    specifiedType: const FullType(DateTime)));
        }
        return result;
    }

    @override
    SubscriptionPlanDto deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionPlanDtoBuilder();

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
                case r'sortPriority':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.sortPriority = valueDes;
                    break;
                case r'isActive':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(bool)) as bool;
                    result.isActive = valueDes;
                    break;
                case r'priceInSubunit':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.priceInSubunit = valueDes;
                    break;
                case r'rules':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType.nullable(BuiltList, [FullType(SubscriptionRuleDto)])) as BuiltList<SubscriptionRuleDto>?;
                    if (valueDes == null) continue;
                    result.rules.replace(valueDes);
                    break;
                case r'createdAt':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(DateTime)) as DateTime;
                    result.createdAt = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

