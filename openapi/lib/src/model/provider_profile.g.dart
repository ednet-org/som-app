// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderProfile extends ProviderProfile {
  @override
  final String companyId;
  @override
  final BankDetails bankDetails;
  @override
  final BuiltList<String> branchIds;
  @override
  final BuiltList<String> pendingBranchIds;
  @override
  final String subscriptionPlanId;
  @override
  final String paymentInterval;
  @override
  final String? providerType;
  @override
  final String status;
  @override
  final String? rejectionReason;
  @override
  final DateTime? rejectedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ProviderProfile([void Function(ProviderProfileBuilder)? updates]) =>
      (ProviderProfileBuilder()..update(updates))._build();

  _$ProviderProfile._(
      {required this.companyId,
      required this.bankDetails,
      required this.branchIds,
      required this.pendingBranchIds,
      required this.subscriptionPlanId,
      required this.paymentInterval,
      this.providerType,
      required this.status,
      this.rejectionReason,
      this.rejectedAt,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  ProviderProfile rebuild(void Function(ProviderProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderProfileBuilder toBuilder() => ProviderProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderProfile &&
        companyId == other.companyId &&
        bankDetails == other.bankDetails &&
        branchIds == other.branchIds &&
        pendingBranchIds == other.pendingBranchIds &&
        subscriptionPlanId == other.subscriptionPlanId &&
        paymentInterval == other.paymentInterval &&
        providerType == other.providerType &&
        status == other.status &&
        rejectionReason == other.rejectionReason &&
        rejectedAt == other.rejectedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, bankDetails.hashCode);
    _$hash = $jc(_$hash, branchIds.hashCode);
    _$hash = $jc(_$hash, pendingBranchIds.hashCode);
    _$hash = $jc(_$hash, subscriptionPlanId.hashCode);
    _$hash = $jc(_$hash, paymentInterval.hashCode);
    _$hash = $jc(_$hash, providerType.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, rejectedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderProfile')
          ..add('companyId', companyId)
          ..add('bankDetails', bankDetails)
          ..add('branchIds', branchIds)
          ..add('pendingBranchIds', pendingBranchIds)
          ..add('subscriptionPlanId', subscriptionPlanId)
          ..add('paymentInterval', paymentInterval)
          ..add('providerType', providerType)
          ..add('status', status)
          ..add('rejectionReason', rejectionReason)
          ..add('rejectedAt', rejectedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ProviderProfileBuilder
    implements Builder<ProviderProfile, ProviderProfileBuilder> {
  _$ProviderProfile? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  BankDetailsBuilder? _bankDetails;
  BankDetailsBuilder get bankDetails =>
      _$this._bankDetails ??= BankDetailsBuilder();
  set bankDetails(BankDetailsBuilder? bankDetails) =>
      _$this._bankDetails = bankDetails;

  ListBuilder<String>? _branchIds;
  ListBuilder<String> get branchIds =>
      _$this._branchIds ??= ListBuilder<String>();
  set branchIds(ListBuilder<String>? branchIds) =>
      _$this._branchIds = branchIds;

  ListBuilder<String>? _pendingBranchIds;
  ListBuilder<String> get pendingBranchIds =>
      _$this._pendingBranchIds ??= ListBuilder<String>();
  set pendingBranchIds(ListBuilder<String>? pendingBranchIds) =>
      _$this._pendingBranchIds = pendingBranchIds;

  String? _subscriptionPlanId;
  String? get subscriptionPlanId => _$this._subscriptionPlanId;
  set subscriptionPlanId(String? subscriptionPlanId) =>
      _$this._subscriptionPlanId = subscriptionPlanId;

  String? _paymentInterval;
  String? get paymentInterval => _$this._paymentInterval;
  set paymentInterval(String? paymentInterval) =>
      _$this._paymentInterval = paymentInterval;

  String? _providerType;
  String? get providerType => _$this._providerType;
  set providerType(String? providerType) => _$this._providerType = providerType;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  DateTime? _rejectedAt;
  DateTime? get rejectedAt => _$this._rejectedAt;
  set rejectedAt(DateTime? rejectedAt) => _$this._rejectedAt = rejectedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ProviderProfileBuilder() {
    ProviderProfile._defaults(this);
  }

  ProviderProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _bankDetails = $v.bankDetails.toBuilder();
      _branchIds = $v.branchIds.toBuilder();
      _pendingBranchIds = $v.pendingBranchIds.toBuilder();
      _subscriptionPlanId = $v.subscriptionPlanId;
      _paymentInterval = $v.paymentInterval;
      _providerType = $v.providerType;
      _status = $v.status;
      _rejectionReason = $v.rejectionReason;
      _rejectedAt = $v.rejectedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderProfile other) {
    _$v = other as _$ProviderProfile;
  }

  @override
  void update(void Function(ProviderProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderProfile build() => _build();

  _$ProviderProfile _build() {
    _$ProviderProfile _$result;
    try {
      _$result = _$v ??
          _$ProviderProfile._(
            companyId: BuiltValueNullFieldError.checkNotNull(
                companyId, r'ProviderProfile', 'companyId'),
            bankDetails: bankDetails.build(),
            branchIds: branchIds.build(),
            pendingBranchIds: pendingBranchIds.build(),
            subscriptionPlanId: BuiltValueNullFieldError.checkNotNull(
                subscriptionPlanId, r'ProviderProfile', 'subscriptionPlanId'),
            paymentInterval: BuiltValueNullFieldError.checkNotNull(
                paymentInterval, r'ProviderProfile', 'paymentInterval'),
            providerType: providerType,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProviderProfile', 'status'),
            rejectionReason: rejectionReason,
            rejectedAt: rejectedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bankDetails';
        bankDetails.build();
        _$failedField = 'branchIds';
        branchIds.build();
        _$failedField = 'pendingBranchIds';
        pendingBranchIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProviderProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
