//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subscription_plan_rules_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan.g.dart';

/// SubscriptionPlan
///
/// Properties:
/// * [id] 
/// * [sortPriority] 
/// * [isActive] 
/// * [priceInSubunit] 
/// * [rules] 
/// * [createdAt] 
abstract class SubscriptionPlan implements Built<SubscriptionPlan, SubscriptionPlanBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'sortPriority')
    int? get sortPriority;

    @BuiltValueField(wireName: r'isActive')
    bool? get isActive;

    @BuiltValueField(wireName: r'priceInSubunit')
    int? get priceInSubunit;

    @BuiltValueField(wireName: r'rules')
    BuiltList<SubscriptionPlanRulesInner>? get rules;

    @BuiltValueField(wireName: r'createdAt')
    DateTime? get createdAt;

    SubscriptionPlan._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionPlanBuilder b) => b;

    factory SubscriptionPlan([void updates(SubscriptionPlanBuilder b)]) = _$SubscriptionPlan;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionPlan> get serializer => _$SubscriptionPlanSerializer();
}

class _$SubscriptionPlanSerializer implements StructuredSerializer<SubscriptionPlan> {
    @override
    final Iterable<Type> types = const [SubscriptionPlan, _$SubscriptionPlan];

    @override
    final String wireName = r'SubscriptionPlan';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionPlan object,
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
                    specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)])));
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
    SubscriptionPlan deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionPlanBuilder();

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
                        specifiedType: const FullType(BuiltList, [FullType(SubscriptionPlanRulesInner)])) as BuiltList<SubscriptionPlanRulesInner>;
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

