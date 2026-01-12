//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscription_plan_rules_inner.g.dart';

/// SubscriptionPlanRulesInner
///
/// Properties:
/// * [restriction] 
/// * [upperLimit] 
abstract class SubscriptionPlanRulesInner implements Built<SubscriptionPlanRulesInner, SubscriptionPlanRulesInnerBuilder> {
    @BuiltValueField(wireName: r'restriction')
    int? get restriction;

    @BuiltValueField(wireName: r'upperLimit')
    int? get upperLimit;

    SubscriptionPlanRulesInner._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(SubscriptionPlanRulesInnerBuilder b) => b;

    factory SubscriptionPlanRulesInner([void updates(SubscriptionPlanRulesInnerBuilder b)]) = _$SubscriptionPlanRulesInner;

    @BuiltValueSerializer(custom: true)
    static Serializer<SubscriptionPlanRulesInner> get serializer => _$SubscriptionPlanRulesInnerSerializer();
}

class _$SubscriptionPlanRulesInnerSerializer implements StructuredSerializer<SubscriptionPlanRulesInner> {
    @override
    final Iterable<Type> types = const [SubscriptionPlanRulesInner, _$SubscriptionPlanRulesInner];

    @override
    final String wireName = r'SubscriptionPlanRulesInner';

    @override
    Iterable<Object?> serialize(Serializers serializers, SubscriptionPlanRulesInner object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.restriction != null) {
            result
                ..add(r'restriction')
                ..add(serializers.serialize(object.restriction,
                    specifiedType: const FullType(int)));
        }
        if (object.upperLimit != null) {
            result
                ..add(r'upperLimit')
                ..add(serializers.serialize(object.upperLimit,
                    specifiedType: const FullType(int)));
        }
        return result;
    }

    @override
    SubscriptionPlanRulesInner deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = SubscriptionPlanRulesInnerBuilder();

        final iterator = serialized.iterator;
        while (iterator.moveNext()) {
            final key = iterator.current as String;
            iterator.moveNext();
            final Object? value = iterator.current;
            
            switch (key) {
                case r'restriction':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.restriction = valueDes;
                    break;
                case r'upperLimit':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(int)) as int;
                    result.upperLimit = valueDes;
                    break;
            }
        }
        return result.build();
    }
}

