// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionsResponse extends SubscriptionsResponse {
  @override
  final BuiltList<SubscriptionPlanDto>? subscriptions;

  factory _$SubscriptionsResponse(
          [void Function(SubscriptionsResponseBuilder)? updates]) =>
      (new SubscriptionsResponseBuilder()..update(updates))._build();

  _$SubscriptionsResponse._({this.subscriptions}) : super._();

  @override
  SubscriptionsResponse rebuild(
          void Function(SubscriptionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionsResponseBuilder toBuilder() =>
      new SubscriptionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsResponse &&
        subscriptions == other.subscriptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subscriptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionsResponse')
          ..add('subscriptions', subscriptions))
        .toString();
  }
}

class SubscriptionsResponseBuilder
    implements Builder<SubscriptionsResponse, SubscriptionsResponseBuilder> {
  _$SubscriptionsResponse? _$v;

  ListBuilder<SubscriptionPlanDto>? _subscriptions;
  ListBuilder<SubscriptionPlanDto> get subscriptions =>
      _$this._subscriptions ??= new ListBuilder<SubscriptionPlanDto>();
  set subscriptions(ListBuilder<SubscriptionPlanDto>? subscriptions) =>
      _$this._subscriptions = subscriptions;

  SubscriptionsResponseBuilder() {
    SubscriptionsResponse._defaults(this);
  }

  SubscriptionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subscriptions = $v.subscriptions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionsResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubscriptionsResponse;
  }

  @override
  void update(void Function(SubscriptionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionsResponse build() => _build();

  _$SubscriptionsResponse _build() {
    _$SubscriptionsResponse _$result;
    try {
      _$result = _$v ??
          new _$SubscriptionsResponse._(
            subscriptions: _subscriptions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subscriptions';
        _subscriptions?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SubscriptionsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
