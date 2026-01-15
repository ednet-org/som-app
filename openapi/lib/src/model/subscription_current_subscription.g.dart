// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_current_subscription.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionCurrentSubscription
    extends SubscriptionCurrentSubscription {
  @override
  final String? companyId;
  @override
  final String? planId;
  @override
  final String? status;
  @override
  final String? paymentInterval;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? createdAt;

  factory _$SubscriptionCurrentSubscription(
          [void Function(SubscriptionCurrentSubscriptionBuilder)? updates]) =>
      (SubscriptionCurrentSubscriptionBuilder()..update(updates))._build();

  _$SubscriptionCurrentSubscription._(
      {this.companyId,
      this.planId,
      this.status,
      this.paymentInterval,
      this.startDate,
      this.endDate,
      this.createdAt})
      : super._();
  @override
  SubscriptionCurrentSubscription rebuild(
          void Function(SubscriptionCurrentSubscriptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionCurrentSubscriptionBuilder toBuilder() =>
      SubscriptionCurrentSubscriptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionCurrentSubscription &&
        companyId == other.companyId &&
        planId == other.planId &&
        status == other.status &&
        paymentInterval == other.paymentInterval &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, planId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, paymentInterval.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionCurrentSubscription')
          ..add('companyId', companyId)
          ..add('planId', planId)
          ..add('status', status)
          ..add('paymentInterval', paymentInterval)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class SubscriptionCurrentSubscriptionBuilder
    implements
        Builder<SubscriptionCurrentSubscription,
            SubscriptionCurrentSubscriptionBuilder> {
  _$SubscriptionCurrentSubscription? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _planId;
  String? get planId => _$this._planId;
  set planId(String? planId) => _$this._planId = planId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _paymentInterval;
  String? get paymentInterval => _$this._paymentInterval;
  set paymentInterval(String? paymentInterval) =>
      _$this._paymentInterval = paymentInterval;

  DateTime? _startDate;
  DateTime? get startDate => _$this._startDate;
  set startDate(DateTime? startDate) => _$this._startDate = startDate;

  DateTime? _endDate;
  DateTime? get endDate => _$this._endDate;
  set endDate(DateTime? endDate) => _$this._endDate = endDate;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  SubscriptionCurrentSubscriptionBuilder() {
    SubscriptionCurrentSubscription._defaults(this);
  }

  SubscriptionCurrentSubscriptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _planId = $v.planId;
      _status = $v.status;
      _paymentInterval = $v.paymentInterval;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionCurrentSubscription other) {
    _$v = other as _$SubscriptionCurrentSubscription;
  }

  @override
  void update(void Function(SubscriptionCurrentSubscriptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionCurrentSubscription build() => _build();

  _$SubscriptionCurrentSubscription _build() {
    final _$result = _$v ??
        _$SubscriptionCurrentSubscription._(
          companyId: companyId,
          planId: planId,
          status: status,
          paymentInterval: paymentInterval,
          startDate: startDate,
          endDate: endDate,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
