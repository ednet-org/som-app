//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/bank_details.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_profile.g.dart';

/// ProviderProfile
///
/// Properties:
/// * [companyId] 
/// * [bankDetails] 
/// * [branchIds] 
/// * [pendingBranchIds] 
/// * [subscriptionPlanId] 
/// * [paymentInterval] 
/// * [providerType] 
/// * [status] 
/// * [rejectionReason] 
/// * [rejectedAt] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ProviderProfile implements Built<ProviderProfile, ProviderProfileBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String get companyId;

  @BuiltValueField(wireName: r'bankDetails')
  BankDetails get bankDetails;

  @BuiltValueField(wireName: r'branchIds')
  BuiltList<String> get branchIds;

  @BuiltValueField(wireName: r'pendingBranchIds')
  BuiltList<String> get pendingBranchIds;

  @BuiltValueField(wireName: r'subscriptionPlanId')
  String get subscriptionPlanId;

  @BuiltValueField(wireName: r'paymentInterval')
  String get paymentInterval;

  @BuiltValueField(wireName: r'providerType')
  String? get providerType;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'rejectedAt')
  DateTime? get rejectedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  ProviderProfile._();

  factory ProviderProfile([void updates(ProviderProfileBuilder b)]) = _$ProviderProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderProfile> get serializer => _$ProviderProfileSerializer();
}

class _$ProviderProfileSerializer implements PrimitiveSerializer<ProviderProfile> {
  @override
  final Iterable<Type> types = const [ProviderProfile, _$ProviderProfile];

  @override
  final String wireName = r'ProviderProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'companyId';
    yield serializers.serialize(
      object.companyId,
      specifiedType: const FullType(String),
    );
    yield r'bankDetails';
    yield serializers.serialize(
      object.bankDetails,
      specifiedType: const FullType(BankDetails),
    );
    yield r'branchIds';
    yield serializers.serialize(
      object.branchIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'pendingBranchIds';
    yield serializers.serialize(
      object.pendingBranchIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'subscriptionPlanId';
    yield serializers.serialize(
      object.subscriptionPlanId,
      specifiedType: const FullType(String),
    );
    yield r'paymentInterval';
    yield serializers.serialize(
      object.paymentInterval,
      specifiedType: const FullType(String),
    );
    if (object.providerType != null) {
      yield r'providerType';
      yield serializers.serialize(
        object.providerType,
        specifiedType: const FullType(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.rejectionReason != null) {
      yield r'rejectionReason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType(String),
      );
    }
    if (object.rejectedAt != null) {
      yield r'rejectedAt';
      yield serializers.serialize(
        object.rejectedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProviderProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'bankDetails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BankDetails),
          ) as BankDetails;
          result.bankDetails.replace(valueDes);
          break;
        case r'branchIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.branchIds.replace(valueDes);
          break;
        case r'pendingBranchIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.pendingBranchIds.replace(valueDes);
          break;
        case r'subscriptionPlanId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subscriptionPlanId = valueDes;
          break;
        case r'paymentInterval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentInterval = valueDes;
          break;
        case r'providerType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerType = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rejectionReason = valueDes;
          break;
        case r'rejectedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.rejectedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProviderProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderProfileBuilder();
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

