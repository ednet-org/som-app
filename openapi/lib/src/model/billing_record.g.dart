// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingRecord extends BillingRecord {
  @override
  final String? id;
  @override
  final String? companyId;
  @override
  final int? amountInSubunit;
  @override
  final String? currency;
  @override
  final String? status;
  @override
  final DateTime? periodStart;
  @override
  final DateTime? periodEnd;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? paidAt;

  factory _$BillingRecord([void Function(BillingRecordBuilder)? updates]) =>
      (BillingRecordBuilder()..update(updates))._build();

  _$BillingRecord._(
      {this.id,
      this.companyId,
      this.amountInSubunit,
      this.currency,
      this.status,
      this.periodStart,
      this.periodEnd,
      this.createdAt,
      this.paidAt})
      : super._();
  @override
  BillingRecord rebuild(void Function(BillingRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingRecordBuilder toBuilder() => BillingRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingRecord &&
        id == other.id &&
        companyId == other.companyId &&
        amountInSubunit == other.amountInSubunit &&
        currency == other.currency &&
        status == other.status &&
        periodStart == other.periodStart &&
        periodEnd == other.periodEnd &&
        createdAt == other.createdAt &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, amountInSubunit.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, periodEnd.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingRecord')
          ..add('id', id)
          ..add('companyId', companyId)
          ..add('amountInSubunit', amountInSubunit)
          ..add('currency', currency)
          ..add('status', status)
          ..add('periodStart', periodStart)
          ..add('periodEnd', periodEnd)
          ..add('createdAt', createdAt)
          ..add('paidAt', paidAt))
        .toString();
  }
}

class BillingRecordBuilder
    implements Builder<BillingRecord, BillingRecordBuilder> {
  _$BillingRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  int? _amountInSubunit;
  int? get amountInSubunit => _$this._amountInSubunit;
  set amountInSubunit(int? amountInSubunit) =>
      _$this._amountInSubunit = amountInSubunit;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _periodStart;
  DateTime? get periodStart => _$this._periodStart;
  set periodStart(DateTime? periodStart) => _$this._periodStart = periodStart;

  DateTime? _periodEnd;
  DateTime? get periodEnd => _$this._periodEnd;
  set periodEnd(DateTime? periodEnd) => _$this._periodEnd = periodEnd;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  BillingRecordBuilder() {
    BillingRecord._defaults(this);
  }

  BillingRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _companyId = $v.companyId;
      _amountInSubunit = $v.amountInSubunit;
      _currency = $v.currency;
      _status = $v.status;
      _periodStart = $v.periodStart;
      _periodEnd = $v.periodEnd;
      _createdAt = $v.createdAt;
      _paidAt = $v.paidAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingRecord other) {
    _$v = other as _$BillingRecord;
  }

  @override
  void update(void Function(BillingRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingRecord build() => _build();

  _$BillingRecord _build() {
    final _$result = _$v ??
        _$BillingRecord._(
          id: id,
          companyId: companyId,
          amountInSubunit: amountInSubunit,
          currency: currency,
          status: status,
          periodStart: periodStart,
          periodEnd: periodEnd,
          createdAt: createdAt,
          paidAt: paidAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
