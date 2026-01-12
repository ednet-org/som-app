// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_upgrade_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionsUpgradePostRequest
    extends SubscriptionsUpgradePostRequest {
  @override
  final String planId;

  factory _$SubscriptionsUpgradePostRequest(
          [void Function(SubscriptionsUpgradePostRequestBuilder)? updates]) =>
      (SubscriptionsUpgradePostRequestBuilder()..update(updates))._build();

  _$SubscriptionsUpgradePostRequest._({required this.planId}) : super._();
  @override
  SubscriptionsUpgradePostRequest rebuild(
          void Function(SubscriptionsUpgradePostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionsUpgradePostRequestBuilder toBuilder() =>
      SubscriptionsUpgradePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsUpgradePostRequest && planId == other.planId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, planId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionsUpgradePostRequest')
          ..add('planId', planId))
        .toString();
  }
}

class SubscriptionsUpgradePostRequestBuilder
    implements
        Builder<SubscriptionsUpgradePostRequest,
            SubscriptionsUpgradePostRequestBuilder> {
  _$SubscriptionsUpgradePostRequest? _$v;

  String? _planId;
  String? get planId => _$this._planId;
  set planId(String? planId) => _$this._planId = planId;

  SubscriptionsUpgradePostRequestBuilder() {
    SubscriptionsUpgradePostRequest._defaults(this);
  }

  SubscriptionsUpgradePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _planId = $v.planId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionsUpgradePostRequest other) {
    _$v = other as _$SubscriptionsUpgradePostRequest;
  }

  @override
  void update(void Function(SubscriptionsUpgradePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionsUpgradePostRequest build() => _build();

  _$SubscriptionsUpgradePostRequest _build() {
    final _$result = _$v ??
        _$SubscriptionsUpgradePostRequest._(
          planId: BuiltValueNullFieldError.checkNotNull(
              planId, r'SubscriptionsUpgradePostRequest', 'planId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
