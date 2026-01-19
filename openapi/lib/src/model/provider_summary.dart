//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/company_branch_assignment.dart';
import 'package:openapi/src/model/company_category_assignment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_summary.g.dart';

/// ProviderSummary
///
/// Properties:
/// * [companyId] 
/// * [companyName] 
/// * [companySize] 
/// * [providerType] 
/// * [postcode] 
/// * [branchIds] 
/// * [pendingBranchIds] 
/// * [branchAssignments] 
/// * [categoryAssignments] 
/// * [status] 
/// * [rejectionReason] 
/// * [rejectedAt] 
/// * [claimed] 
/// * [receivedInquiries] 
/// * [sentOffers] 
/// * [acceptedOffers] 
/// * [subscriptionPlanId] 
/// * [paymentInterval] 
/// * [iban] 
/// * [bic] 
/// * [accountOwner] 
/// * [registrationDate] 
@BuiltValue()
abstract class ProviderSummary implements Built<ProviderSummary, ProviderSummaryBuilder> {
  @BuiltValueField(wireName: r'companyId')
  String? get companyId;

  @BuiltValueField(wireName: r'companyName')
  String? get companyName;

  @BuiltValueField(wireName: r'companySize')
  String? get companySize;

  @BuiltValueField(wireName: r'providerType')
  String? get providerType;

  @BuiltValueField(wireName: r'postcode')
  String? get postcode;

  @BuiltValueField(wireName: r'branchIds')
  BuiltList<String>? get branchIds;

  @BuiltValueField(wireName: r'pendingBranchIds')
  BuiltList<String>? get pendingBranchIds;

  @BuiltValueField(wireName: r'branchAssignments')
  BuiltList<CompanyBranchAssignment>? get branchAssignments;

  @BuiltValueField(wireName: r'categoryAssignments')
  BuiltList<CompanyCategoryAssignment>? get categoryAssignments;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'rejectedAt')
  DateTime? get rejectedAt;

  @BuiltValueField(wireName: r'claimed')
  bool? get claimed;

  @BuiltValueField(wireName: r'receivedInquiries')
  int? get receivedInquiries;

  @BuiltValueField(wireName: r'sentOffers')
  int? get sentOffers;

  @BuiltValueField(wireName: r'acceptedOffers')
  int? get acceptedOffers;

  @BuiltValueField(wireName: r'subscriptionPlanId')
  String? get subscriptionPlanId;

  @BuiltValueField(wireName: r'paymentInterval')
  String? get paymentInterval;

  @BuiltValueField(wireName: r'iban')
  String? get iban;

  @BuiltValueField(wireName: r'bic')
  String? get bic;

  @BuiltValueField(wireName: r'accountOwner')
  String? get accountOwner;

  @BuiltValueField(wireName: r'registrationDate')
  DateTime? get registrationDate;

  ProviderSummary._();

  factory ProviderSummary([void updates(ProviderSummaryBuilder b)]) = _$ProviderSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderSummary> get serializer => _$ProviderSummarySerializer();
}

class _$ProviderSummarySerializer implements PrimitiveSerializer<ProviderSummary> {
  @override
  final Iterable<Type> types = const [ProviderSummary, _$ProviderSummary];

  @override
  final String wireName = r'ProviderSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.companyId != null) {
      yield r'companyId';
      yield serializers.serialize(
        object.companyId,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyName != null) {
      yield r'companyName';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType(String),
      );
    }
    if (object.companySize != null) {
      yield r'companySize';
      yield serializers.serialize(
        object.companySize,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerType != null) {
      yield r'providerType';
      yield serializers.serialize(
        object.providerType,
        specifiedType: const FullType(String),
      );
    }
    if (object.postcode != null) {
      yield r'postcode';
      yield serializers.serialize(
        object.postcode,
        specifiedType: const FullType(String),
      );
    }
    if (object.branchIds != null) {
      yield r'branchIds';
      yield serializers.serialize(
        object.branchIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.pendingBranchIds != null) {
      yield r'pendingBranchIds';
      yield serializers.serialize(
        object.pendingBranchIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.branchAssignments != null) {
      yield r'branchAssignments';
      yield serializers.serialize(
        object.branchAssignments,
        specifiedType: const FullType(BuiltList, [FullType(CompanyBranchAssignment)]),
      );
    }
    if (object.categoryAssignments != null) {
      yield r'categoryAssignments';
      yield serializers.serialize(
        object.categoryAssignments,
        specifiedType: const FullType(BuiltList, [FullType(CompanyCategoryAssignment)]),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.rejectionReason != null) {
      yield r'rejectionReason';
      yield serializers.serialize(
        object.rejectionReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.rejectedAt != null) {
      yield r'rejectedAt';
      yield serializers.serialize(
        object.rejectedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.claimed != null) {
      yield r'claimed';
      yield serializers.serialize(
        object.claimed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.receivedInquiries != null) {
      yield r'receivedInquiries';
      yield serializers.serialize(
        object.receivedInquiries,
        specifiedType: const FullType(int),
      );
    }
    if (object.sentOffers != null) {
      yield r'sentOffers';
      yield serializers.serialize(
        object.sentOffers,
        specifiedType: const FullType(int),
      );
    }
    if (object.acceptedOffers != null) {
      yield r'acceptedOffers';
      yield serializers.serialize(
        object.acceptedOffers,
        specifiedType: const FullType(int),
      );
    }
    if (object.subscriptionPlanId != null) {
      yield r'subscriptionPlanId';
      yield serializers.serialize(
        object.subscriptionPlanId,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentInterval != null) {
      yield r'paymentInterval';
      yield serializers.serialize(
        object.paymentInterval,
        specifiedType: const FullType(String),
      );
    }
    if (object.iban != null) {
      yield r'iban';
      yield serializers.serialize(
        object.iban,
        specifiedType: const FullType(String),
      );
    }
    if (object.bic != null) {
      yield r'bic';
      yield serializers.serialize(
        object.bic,
        specifiedType: const FullType(String),
      );
    }
    if (object.accountOwner != null) {
      yield r'accountOwner';
      yield serializers.serialize(
        object.accountOwner,
        specifiedType: const FullType(String),
      );
    }
    if (object.registrationDate != null) {
      yield r'registrationDate';
      yield serializers.serialize(
        object.registrationDate,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProviderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderSummaryBuilder result,
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
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'companySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companySize = valueDes;
          break;
        case r'providerType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerType = valueDes;
          break;
        case r'postcode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.postcode = valueDes;
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
        case r'branchAssignments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyBranchAssignment)]),
          ) as BuiltList<CompanyBranchAssignment>;
          result.branchAssignments.replace(valueDes);
          break;
        case r'categoryAssignments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyCategoryAssignment)]),
          ) as BuiltList<CompanyCategoryAssignment>;
          result.categoryAssignments.replace(valueDes);
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        case r'rejectedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.rejectedAt = valueDes;
          break;
        case r'claimed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.claimed = valueDes;
          break;
        case r'receivedInquiries':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.receivedInquiries = valueDes;
          break;
        case r'sentOffers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sentOffers = valueDes;
          break;
        case r'acceptedOffers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.acceptedOffers = valueDes;
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
        case r'iban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iban = valueDes;
          break;
        case r'bic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bic = valueDes;
          break;
        case r'accountOwner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountOwner = valueDes;
          break;
        case r'registrationDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.registrationDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProviderSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderSummaryBuilder();
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

