// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionsGet200Response extends SubscriptionsGet200Response {
  @override
  final BuiltList<SubscriptionPlan>? subscriptions;

  factory _$SubscriptionsGet200Response(
          [void Function(SubscriptionsGet200ResponseBuilder)? updates]) =>
      (SubscriptionsGet200ResponseBuilder()..update(updates))._build();

  _$SubscriptionsGet200Response._({this.subscriptions}) : super._();
  @override
  SubscriptionsGet200Response rebuild(
          void Function(SubscriptionsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionsGet200ResponseBuilder toBuilder() =>
      SubscriptionsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsGet200Response &&
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
    return (newBuiltValueToStringHelper(r'SubscriptionsGet200Response')
          ..add('subscriptions', subscriptions))
        .toString();
  }
}

class SubscriptionsGet200ResponseBuilder
    implements
        Builder<SubscriptionsGet200Response,
            SubscriptionsGet200ResponseBuilder> {
  _$SubscriptionsGet200Response? _$v;

  ListBuilder<SubscriptionPlan>? _subscriptions;
  ListBuilder<SubscriptionPlan> get subscriptions =>
      _$this._subscriptions ??= ListBuilder<SubscriptionPlan>();
  set subscriptions(ListBuilder<SubscriptionPlan>? subscriptions) =>
      _$this._subscriptions = subscriptions;

  SubscriptionsGet200ResponseBuilder() {
    SubscriptionsGet200Response._defaults(this);
  }

  SubscriptionsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subscriptions = $v.subscriptions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionsGet200Response other) {
    _$v = other as _$SubscriptionsGet200Response;
  }

  @override
  void update(void Function(SubscriptionsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionsGet200Response build() => _build();

  _$SubscriptionsGet200Response _build() {
    _$SubscriptionsGet200Response _$result;
    try {
      _$result = _$v ??
          _$SubscriptionsGet200Response._(
            subscriptions: _subscriptions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subscriptions';
        _subscriptions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubscriptionsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
