// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionCancellation extends SubscriptionCancellation {
  @override
  final String? id;
  @override
  final String? companyId;
  @override
  final String? requestedByUserId;
  @override
  final String? reason;
  @override
  final String? status;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? effectiveEndDate;
  @override
  final DateTime? resolvedAt;

  factory _$SubscriptionCancellation(
          [void Function(SubscriptionCancellationBuilder)? updates]) =>
      (SubscriptionCancellationBuilder()..update(updates))._build();

  _$SubscriptionCancellation._(
      {this.id,
      this.companyId,
      this.requestedByUserId,
      this.reason,
      this.status,
      this.requestedAt,
      this.effectiveEndDate,
      this.resolvedAt})
      : super._();
  @override
  SubscriptionCancellation rebuild(
          void Function(SubscriptionCancellationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionCancellationBuilder toBuilder() =>
      SubscriptionCancellationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionCancellation &&
        id == other.id &&
        companyId == other.companyId &&
        requestedByUserId == other.requestedByUserId &&
        reason == other.reason &&
        status == other.status &&
        requestedAt == other.requestedAt &&
        effectiveEndDate == other.effectiveEndDate &&
        resolvedAt == other.resolvedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, requestedByUserId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, effectiveEndDate.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionCancellation')
          ..add('id', id)
          ..add('companyId', companyId)
          ..add('requestedByUserId', requestedByUserId)
          ..add('reason', reason)
          ..add('status', status)
          ..add('requestedAt', requestedAt)
          ..add('effectiveEndDate', effectiveEndDate)
          ..add('resolvedAt', resolvedAt))
        .toString();
  }
}

class SubscriptionCancellationBuilder
    implements
        Builder<SubscriptionCancellation, SubscriptionCancellationBuilder> {
  _$SubscriptionCancellation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _requestedByUserId;
  String? get requestedByUserId => _$this._requestedByUserId;
  set requestedByUserId(String? requestedByUserId) =>
      _$this._requestedByUserId = requestedByUserId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _effectiveEndDate;
  DateTime? get effectiveEndDate => _$this._effectiveEndDate;
  set effectiveEndDate(DateTime? effectiveEndDate) =>
      _$this._effectiveEndDate = effectiveEndDate;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  SubscriptionCancellationBuilder() {
    SubscriptionCancellation._defaults(this);
  }

  SubscriptionCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _companyId = $v.companyId;
      _requestedByUserId = $v.requestedByUserId;
      _reason = $v.reason;
      _status = $v.status;
      _requestedAt = $v.requestedAt;
      _effectiveEndDate = $v.effectiveEndDate;
      _resolvedAt = $v.resolvedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionCancellation other) {
    _$v = other as _$SubscriptionCancellation;
  }

  @override
  void update(void Function(SubscriptionCancellationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionCancellation build() => _build();

  _$SubscriptionCancellation _build() {
    final _$result = _$v ??
        _$SubscriptionCancellation._(
          id: id,
          companyId: companyId,
          requestedByUserId: requestedByUserId,
          reason: reason,
          status: status,
          requestedAt: requestedAt,
          effectiveEndDate: effectiveEndDate,
          resolvedAt: resolvedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
