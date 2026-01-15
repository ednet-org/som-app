// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderSummary extends ProviderSummary {
  @override
  final String? companyId;
  @override
  final String? companyName;
  @override
  final String? companySize;
  @override
  final String? providerType;
  @override
  final String? postcode;
  @override
  final BuiltList<String>? branchIds;
  @override
  final BuiltList<String>? pendingBranchIds;
  @override
  final String? status;
  @override
  final String? rejectionReason;
  @override
  final DateTime? rejectedAt;
  @override
  final bool? claimed;
  @override
  final int? receivedInquiries;
  @override
  final int? sentOffers;
  @override
  final int? acceptedOffers;
  @override
  final String? subscriptionPlanId;
  @override
  final String? paymentInterval;
  @override
  final String? iban;
  @override
  final String? bic;
  @override
  final String? accountOwner;
  @override
  final DateTime? registrationDate;

  factory _$ProviderSummary([void Function(ProviderSummaryBuilder)? updates]) =>
      (ProviderSummaryBuilder()..update(updates))._build();

  _$ProviderSummary._(
      {this.companyId,
      this.companyName,
      this.companySize,
      this.providerType,
      this.postcode,
      this.branchIds,
      this.pendingBranchIds,
      this.status,
      this.rejectionReason,
      this.rejectedAt,
      this.claimed,
      this.receivedInquiries,
      this.sentOffers,
      this.acceptedOffers,
      this.subscriptionPlanId,
      this.paymentInterval,
      this.iban,
      this.bic,
      this.accountOwner,
      this.registrationDate})
      : super._();
  @override
  ProviderSummary rebuild(void Function(ProviderSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderSummaryBuilder toBuilder() => ProviderSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderSummary &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        companySize == other.companySize &&
        providerType == other.providerType &&
        postcode == other.postcode &&
        branchIds == other.branchIds &&
        pendingBranchIds == other.pendingBranchIds &&
        status == other.status &&
        rejectionReason == other.rejectionReason &&
        rejectedAt == other.rejectedAt &&
        claimed == other.claimed &&
        receivedInquiries == other.receivedInquiries &&
        sentOffers == other.sentOffers &&
        acceptedOffers == other.acceptedOffers &&
        subscriptionPlanId == other.subscriptionPlanId &&
        paymentInterval == other.paymentInterval &&
        iban == other.iban &&
        bic == other.bic &&
        accountOwner == other.accountOwner &&
        registrationDate == other.registrationDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companySize.hashCode);
    _$hash = $jc(_$hash, providerType.hashCode);
    _$hash = $jc(_$hash, postcode.hashCode);
    _$hash = $jc(_$hash, branchIds.hashCode);
    _$hash = $jc(_$hash, pendingBranchIds.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, rejectedAt.hashCode);
    _$hash = $jc(_$hash, claimed.hashCode);
    _$hash = $jc(_$hash, receivedInquiries.hashCode);
    _$hash = $jc(_$hash, sentOffers.hashCode);
    _$hash = $jc(_$hash, acceptedOffers.hashCode);
    _$hash = $jc(_$hash, subscriptionPlanId.hashCode);
    _$hash = $jc(_$hash, paymentInterval.hashCode);
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jc(_$hash, bic.hashCode);
    _$hash = $jc(_$hash, accountOwner.hashCode);
    _$hash = $jc(_$hash, registrationDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderSummary')
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('companySize', companySize)
          ..add('providerType', providerType)
          ..add('postcode', postcode)
          ..add('branchIds', branchIds)
          ..add('pendingBranchIds', pendingBranchIds)
          ..add('status', status)
          ..add('rejectionReason', rejectionReason)
          ..add('rejectedAt', rejectedAt)
          ..add('claimed', claimed)
          ..add('receivedInquiries', receivedInquiries)
          ..add('sentOffers', sentOffers)
          ..add('acceptedOffers', acceptedOffers)
          ..add('subscriptionPlanId', subscriptionPlanId)
          ..add('paymentInterval', paymentInterval)
          ..add('iban', iban)
          ..add('bic', bic)
          ..add('accountOwner', accountOwner)
          ..add('registrationDate', registrationDate))
        .toString();
  }
}

class ProviderSummaryBuilder
    implements Builder<ProviderSummary, ProviderSummaryBuilder> {
  _$ProviderSummary? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _companySize;
  String? get companySize => _$this._companySize;
  set companySize(String? companySize) => _$this._companySize = companySize;

  String? _providerType;
  String? get providerType => _$this._providerType;
  set providerType(String? providerType) => _$this._providerType = providerType;

  String? _postcode;
  String? get postcode => _$this._postcode;
  set postcode(String? postcode) => _$this._postcode = postcode;

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

  bool? _claimed;
  bool? get claimed => _$this._claimed;
  set claimed(bool? claimed) => _$this._claimed = claimed;

  int? _receivedInquiries;
  int? get receivedInquiries => _$this._receivedInquiries;
  set receivedInquiries(int? receivedInquiries) =>
      _$this._receivedInquiries = receivedInquiries;

  int? _sentOffers;
  int? get sentOffers => _$this._sentOffers;
  set sentOffers(int? sentOffers) => _$this._sentOffers = sentOffers;

  int? _acceptedOffers;
  int? get acceptedOffers => _$this._acceptedOffers;
  set acceptedOffers(int? acceptedOffers) =>
      _$this._acceptedOffers = acceptedOffers;

  String? _subscriptionPlanId;
  String? get subscriptionPlanId => _$this._subscriptionPlanId;
  set subscriptionPlanId(String? subscriptionPlanId) =>
      _$this._subscriptionPlanId = subscriptionPlanId;

  String? _paymentInterval;
  String? get paymentInterval => _$this._paymentInterval;
  set paymentInterval(String? paymentInterval) =>
      _$this._paymentInterval = paymentInterval;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  String? _bic;
  String? get bic => _$this._bic;
  set bic(String? bic) => _$this._bic = bic;

  String? _accountOwner;
  String? get accountOwner => _$this._accountOwner;
  set accountOwner(String? accountOwner) => _$this._accountOwner = accountOwner;

  DateTime? _registrationDate;
  DateTime? get registrationDate => _$this._registrationDate;
  set registrationDate(DateTime? registrationDate) =>
      _$this._registrationDate = registrationDate;

  ProviderSummaryBuilder() {
    ProviderSummary._defaults(this);
  }

  ProviderSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _companySize = $v.companySize;
      _providerType = $v.providerType;
      _postcode = $v.postcode;
      _branchIds = $v.branchIds?.toBuilder();
      _pendingBranchIds = $v.pendingBranchIds?.toBuilder();
      _status = $v.status;
      _rejectionReason = $v.rejectionReason;
      _rejectedAt = $v.rejectedAt;
      _claimed = $v.claimed;
      _receivedInquiries = $v.receivedInquiries;
      _sentOffers = $v.sentOffers;
      _acceptedOffers = $v.acceptedOffers;
      _subscriptionPlanId = $v.subscriptionPlanId;
      _paymentInterval = $v.paymentInterval;
      _iban = $v.iban;
      _bic = $v.bic;
      _accountOwner = $v.accountOwner;
      _registrationDate = $v.registrationDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderSummary other) {
    _$v = other as _$ProviderSummary;
  }

  @override
  void update(void Function(ProviderSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderSummary build() => _build();

  _$ProviderSummary _build() {
    _$ProviderSummary _$result;
    try {
      _$result = _$v ??
          _$ProviderSummary._(
            companyId: companyId,
            companyName: companyName,
            companySize: companySize,
            providerType: providerType,
            postcode: postcode,
            branchIds: _branchIds?.build(),
            pendingBranchIds: _pendingBranchIds?.build(),
            status: status,
            rejectionReason: rejectionReason,
            rejectedAt: rejectedAt,
            claimed: claimed,
            receivedInquiries: receivedInquiries,
            sentOffers: sentOffers,
            acceptedOffers: acceptedOffers,
            subscriptionPlanId: subscriptionPlanId,
            paymentInterval: paymentInterval,
            iban: iban,
            bic: bic,
            accountOwner: accountOwner,
            registrationDate: registrationDate,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'branchIds';
        _branchIds?.build();
        _$failedField = 'pendingBranchIds';
        _pendingBranchIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProviderSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
