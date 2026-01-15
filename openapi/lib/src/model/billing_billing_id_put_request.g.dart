// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_billing_id_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BillingBillingIdPutRequest extends BillingBillingIdPutRequest {
  @override
  final String? status;
  @override
  final DateTime? paidAt;

  factory _$BillingBillingIdPutRequest(
          [void Function(BillingBillingIdPutRequestBuilder)? updates]) =>
      (BillingBillingIdPutRequestBuilder()..update(updates))._build();

  _$BillingBillingIdPutRequest._({this.status, this.paidAt}) : super._();
  @override
  BillingBillingIdPutRequest rebuild(
          void Function(BillingBillingIdPutRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BillingBillingIdPutRequestBuilder toBuilder() =>
      BillingBillingIdPutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BillingBillingIdPutRequest &&
        status == other.status &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BillingBillingIdPutRequest')
          ..add('status', status)
          ..add('paidAt', paidAt))
        .toString();
  }
}

class BillingBillingIdPutRequestBuilder
    implements
        Builder<BillingBillingIdPutRequest, BillingBillingIdPutRequestBuilder> {
  _$BillingBillingIdPutRequest? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  BillingBillingIdPutRequestBuilder() {
    BillingBillingIdPutRequest._defaults(this);
  }

  BillingBillingIdPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _paidAt = $v.paidAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BillingBillingIdPutRequest other) {
    _$v = other as _$BillingBillingIdPutRequest;
  }

  @override
  void update(void Function(BillingBillingIdPutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BillingBillingIdPutRequest build() => _build();

  _$BillingBillingIdPutRequest _build() {
    final _$result = _$v ??
        _$BillingBillingIdPutRequest._(
          status: status,
          paidAt: paidAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
