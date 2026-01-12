// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_rules_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionPlanRulesInner extends SubscriptionPlanRulesInner {
  @override
  final int? restriction;
  @override
  final int? upperLimit;

  factory _$SubscriptionPlanRulesInner(
          [void Function(SubscriptionPlanRulesInnerBuilder)? updates]) =>
      (new SubscriptionPlanRulesInnerBuilder()..update(updates))._build();

  _$SubscriptionPlanRulesInner._({this.restriction, this.upperLimit})
      : super._();

  @override
  SubscriptionPlanRulesInner rebuild(
          void Function(SubscriptionPlanRulesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionPlanRulesInnerBuilder toBuilder() =>
      new SubscriptionPlanRulesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionPlanRulesInner &&
        restriction == other.restriction &&
        upperLimit == other.upperLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restriction.hashCode);
    _$hash = $jc(_$hash, upperLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionPlanRulesInner')
          ..add('restriction', restriction)
          ..add('upperLimit', upperLimit))
        .toString();
  }
}

class SubscriptionPlanRulesInnerBuilder
    implements
        Builder<SubscriptionPlanRulesInner, SubscriptionPlanRulesInnerBuilder> {
  _$SubscriptionPlanRulesInner? _$v;

  int? _restriction;
  int? get restriction => _$this._restriction;
  set restriction(int? restriction) => _$this._restriction = restriction;

  int? _upperLimit;
  int? get upperLimit => _$this._upperLimit;
  set upperLimit(int? upperLimit) => _$this._upperLimit = upperLimit;

  SubscriptionPlanRulesInnerBuilder() {
    SubscriptionPlanRulesInner._defaults(this);
  }

  SubscriptionPlanRulesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restriction = $v.restriction;
      _upperLimit = $v.upperLimit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionPlanRulesInner other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubscriptionPlanRulesInner;
  }

  @override
  void update(void Function(SubscriptionPlanRulesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionPlanRulesInner build() => _build();

  _$SubscriptionPlanRulesInner _build() {
    final _$result = _$v ??
        new _$SubscriptionPlanRulesInner._(
          restriction: restriction,
          upperLimit: upperLimit,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
