// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_current.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionCurrent extends SubscriptionCurrent {
  @override
  final SubscriptionCurrentSubscription? subscription;
  @override
  final SubscriptionPlan? plan;

  factory _$SubscriptionCurrent(
          [void Function(SubscriptionCurrentBuilder)? updates]) =>
      (SubscriptionCurrentBuilder()..update(updates))._build();

  _$SubscriptionCurrent._({this.subscription, this.plan}) : super._();
  @override
  SubscriptionCurrent rebuild(
          void Function(SubscriptionCurrentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionCurrentBuilder toBuilder() =>
      SubscriptionCurrentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionCurrent &&
        subscription == other.subscription &&
        plan == other.plan;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subscription.hashCode);
    _$hash = $jc(_$hash, plan.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionCurrent')
          ..add('subscription', subscription)
          ..add('plan', plan))
        .toString();
  }
}

class SubscriptionCurrentBuilder
    implements Builder<SubscriptionCurrent, SubscriptionCurrentBuilder> {
  _$SubscriptionCurrent? _$v;

  SubscriptionCurrentSubscriptionBuilder? _subscription;
  SubscriptionCurrentSubscriptionBuilder get subscription =>
      _$this._subscription ??= SubscriptionCurrentSubscriptionBuilder();
  set subscription(SubscriptionCurrentSubscriptionBuilder? subscription) =>
      _$this._subscription = subscription;

  SubscriptionPlanBuilder? _plan;
  SubscriptionPlanBuilder get plan =>
      _$this._plan ??= SubscriptionPlanBuilder();
  set plan(SubscriptionPlanBuilder? plan) => _$this._plan = plan;

  SubscriptionCurrentBuilder() {
    SubscriptionCurrent._defaults(this);
  }

  SubscriptionCurrentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subscription = $v.subscription?.toBuilder();
      _plan = $v.plan?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionCurrent other) {
    _$v = other as _$SubscriptionCurrent;
  }

  @override
  void update(void Function(SubscriptionCurrentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionCurrent build() => _build();

  _$SubscriptionCurrent _build() {
    _$SubscriptionCurrent _$result;
    try {
      _$result = _$v ??
          _$SubscriptionCurrent._(
            subscription: _subscription?.build(),
            plan: _plan?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subscription';
        _subscription?.build();
        _$failedField = 'plan';
        _plan?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubscriptionCurrent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
