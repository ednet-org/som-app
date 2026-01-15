// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_cancellations_cancellation_id_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionsCancellationsCancellationIdPutRequest
    extends SubscriptionsCancellationsCancellationIdPutRequest {
  @override
  final String? status;

  factory _$SubscriptionsCancellationsCancellationIdPutRequest(
          [void Function(
                  SubscriptionsCancellationsCancellationIdPutRequestBuilder)?
              updates]) =>
      (SubscriptionsCancellationsCancellationIdPutRequestBuilder()
            ..update(updates))
          ._build();

  _$SubscriptionsCancellationsCancellationIdPutRequest._({this.status})
      : super._();
  @override
  SubscriptionsCancellationsCancellationIdPutRequest rebuild(
          void Function(
                  SubscriptionsCancellationsCancellationIdPutRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionsCancellationsCancellationIdPutRequestBuilder toBuilder() =>
      SubscriptionsCancellationsCancellationIdPutRequestBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsCancellationsCancellationIdPutRequest &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SubscriptionsCancellationsCancellationIdPutRequest')
          ..add('status', status))
        .toString();
  }
}

class SubscriptionsCancellationsCancellationIdPutRequestBuilder
    implements
        Builder<SubscriptionsCancellationsCancellationIdPutRequest,
            SubscriptionsCancellationsCancellationIdPutRequestBuilder> {
  _$SubscriptionsCancellationsCancellationIdPutRequest? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  SubscriptionsCancellationsCancellationIdPutRequestBuilder() {
    SubscriptionsCancellationsCancellationIdPutRequest._defaults(this);
  }

  SubscriptionsCancellationsCancellationIdPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionsCancellationsCancellationIdPutRequest other) {
    _$v = other as _$SubscriptionsCancellationsCancellationIdPutRequest;
  }

  @override
  void update(
      void Function(SubscriptionsCancellationsCancellationIdPutRequestBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionsCancellationsCancellationIdPutRequest build() => _build();

  _$SubscriptionsCancellationsCancellationIdPutRequest _build() {
    final _$result = _$v ??
        _$SubscriptionsCancellationsCancellationIdPutRequest._(
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
