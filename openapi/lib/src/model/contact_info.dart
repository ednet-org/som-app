//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_info.g.dart';

/// ContactInfo
///
/// Properties:
/// * [companyName] 
/// * [salutation] 
/// * [title] 
/// * [firstName] 
/// * [lastName] 
/// * [telephone] 
/// * [email] 
@BuiltValue()
abstract class ContactInfo implements Built<ContactInfo, ContactInfoBuilder> {
  @BuiltValueField(wireName: r'companyName')
  String get companyName;

  @BuiltValueField(wireName: r'salutation')
  String get salutation;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'telephone')
  String get telephone;

  @BuiltValueField(wireName: r'email')
  String get email;

  ContactInfo._();

  factory ContactInfo([void updates(ContactInfoBuilder b)]) = _$ContactInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactInfo> get serializer => _$ContactInfoSerializer();
}

class _$ContactInfoSerializer implements PrimitiveSerializer<ContactInfo> {
  @override
  final Iterable<Type> types = const [ContactInfo, _$ContactInfo];

  @override
  final String wireName = r'ContactInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'companyName';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    yield r'salutation';
    yield serializers.serialize(
      object.salutation,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    yield r'telephone';
    yield serializers.serialize(
      object.telephone,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'salutation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salutation = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'telephone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.telephone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactInfoBuilder();
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

