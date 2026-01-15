// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_cancel_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionsCancelPostRequest extends SubscriptionsCancelPostRequest {
  @override
  final String? reason;

  factory _$SubscriptionsCancelPostRequest(
          [void Function(SubscriptionsCancelPostRequestBuilder)? updates]) =>
      (SubscriptionsCancelPostRequestBuilder()..update(updates))._build();

  _$SubscriptionsCancelPostRequest._({this.reason}) : super._();
  @override
  SubscriptionsCancelPostRequest rebuild(
          void Function(SubscriptionsCancelPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionsCancelPostRequestBuilder toBuilder() =>
      SubscriptionsCancelPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsCancelPostRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionsCancelPostRequest')
          ..add('reason', reason))
        .toString();
  }
}

class SubscriptionsCancelPostRequestBuilder
    implements
        Builder<SubscriptionsCancelPostRequest,
            SubscriptionsCancelPostRequestBuilder> {
  _$SubscriptionsCancelPostRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  SubscriptionsCancelPostRequestBuilder() {
    SubscriptionsCancelPostRequest._defaults(this);
  }

  SubscriptionsCancelPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionsCancelPostRequest other) {
    _$v = other as _$SubscriptionsCancelPostRequest;
  }

  @override
  void update(void Function(SubscriptionsCancelPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionsCancelPostRequest build() => _build();

  _$SubscriptionsCancelPostRequest _build() {
    final _$result = _$v ??
        _$SubscriptionsCancelPostRequest._(
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
