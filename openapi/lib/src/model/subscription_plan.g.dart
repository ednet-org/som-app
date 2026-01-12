// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionPlan extends SubscriptionPlan {
  @override
  final String? id;
  @override
  final int? sortPriority;
  @override
  final bool? isActive;
  @override
  final int? priceInSubunit;
  @override
  final BuiltList<SubscriptionPlanRulesInner>? rules;
  @override
  final DateTime? createdAt;

  factory _$SubscriptionPlan(
          [void Function(SubscriptionPlanBuilder)? updates]) =>
      (SubscriptionPlanBuilder()..update(updates))._build();

  _$SubscriptionPlan._(
      {this.id,
      this.sortPriority,
      this.isActive,
      this.priceInSubunit,
      this.rules,
      this.createdAt})
      : super._();
  @override
  SubscriptionPlan rebuild(void Function(SubscriptionPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionPlanBuilder toBuilder() =>
      SubscriptionPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionPlan &&
        id == other.id &&
        sortPriority == other.sortPriority &&
        isActive == other.isActive &&
        priceInSubunit == other.priceInSubunit &&
        rules == other.rules &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sortPriority.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, priceInSubunit.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionPlan')
          ..add('id', id)
          ..add('sortPriority', sortPriority)
          ..add('isActive', isActive)
          ..add('priceInSubunit', priceInSubunit)
          ..add('rules', rules)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class SubscriptionPlanBuilder
    implements Builder<SubscriptionPlan, SubscriptionPlanBuilder> {
  _$SubscriptionPlan? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _sortPriority;
  int? get sortPriority => _$this._sortPriority;
  set sortPriority(int? sortPriority) => _$this._sortPriority = sortPriority;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  int? _priceInSubunit;
  int? get priceInSubunit => _$this._priceInSubunit;
  set priceInSubunit(int? priceInSubunit) =>
      _$this._priceInSubunit = priceInSubunit;

  ListBuilder<SubscriptionPlanRulesInner>? _rules;
  ListBuilder<SubscriptionPlanRulesInner> get rules =>
      _$this._rules ??= ListBuilder<SubscriptionPlanRulesInner>();
  set rules(ListBuilder<SubscriptionPlanRulesInner>? rules) =>
      _$this._rules = rules;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  SubscriptionPlanBuilder() {
    SubscriptionPlan._defaults(this);
  }

  SubscriptionPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sortPriority = $v.sortPriority;
      _isActive = $v.isActive;
      _priceInSubunit = $v.priceInSubunit;
      _rules = $v.rules?.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionPlan other) {
    _$v = other as _$SubscriptionPlan;
  }

  @override
  void update(void Function(SubscriptionPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionPlan build() => _build();

  _$SubscriptionPlan _build() {
    _$SubscriptionPlan _$result;
    try {
      _$result = _$v ??
          _$SubscriptionPlan._(
            id: id,
            sortPriority: sortPriority,
            isActive: isActive,
            priceInSubunit: priceInSubunit,
            rules: _rules?.build(),
            createdAt: createdAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        _rules?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubscriptionPlan', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
