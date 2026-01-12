//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'branch.g.dart';

/// Branch
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [categories] 
abstract class Branch implements Built<Branch, BranchBuilder> {
    @BuiltValueField(wireName: r'id')
    String? get id;

    @BuiltValueField(wireName: r'name')
    String? get name;

    @BuiltValueField(wireName: r'categories')
    BuiltList<Category>? get categories;

    Branch._();

    @BuiltValueHook(initializeBuilder: true)
    static void _defaults(BranchBuilder b) => b;

    factory Branch([void updates(BranchBuilder b)]) = _$Branch;

    @BuiltValueSerializer(custom: true)
    static Serializer<Branch> get serializer => _$BranchSerializer();
}

class _$BranchSerializer implements StructuredSerializer<Branch> {
    @override
    final Iterable<Type> types = const [Branch, _$Branch];

    @override
    final String wireName = r'Branch';

    @override
    Iterable<Object?> serialize(Serializers serializers, Branch object,
        {FullType specifiedType = FullType.unspecified}) {
        final result = <Object?>[];
        if (object.id != null) {
            result
                ..add(r'id')
                ..add(serializers.serialize(object.id,
                    specifiedType: const FullType(String)));
        }
        if (object.name != null) {
            result
                ..add(r'name')
                ..add(serializers.serialize(object.name,
                    specifiedType: const FullType(String)));
        }
        if (object.categories != null) {
            result
                ..add(r'categories')
                ..add(serializers.serialize(object.categories,
                    specifiedType: const FullType(BuiltList, [FullType(Category)])));
        }
        return result;
    }

    @override
    Branch deserialize(Serializers serializers, Iterable<Object?> serialized,
        {FullType specifiedType = FullType.unspecified}) {
        final result = BranchBuilder();

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
                case r'name':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(String)) as String;
                    result.name = valueDes;
                    break;
                case r'categories':
                    final valueDes = serializers.deserialize(value,
                        specifiedType: const FullType(BuiltList, [FullType(Category)])) as BuiltList<Category>;
                    result.categories.replace(valueDes);
                    break;
            }
        }
        return result.build();
    }
}

