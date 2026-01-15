// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionPlan extends SubscriptionPlan {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final int? sortPriority;
  @override
  final bool? isActive;
  @override
  final int? priceInSubunit;
  @override
  final int? maxUsers;
  @override
  final int? setupFeeInSubunit;
  @override
  final int? bannerAdsPerMonth;
  @override
  final int? normalAdsPerMonth;
  @override
  final int? freeMonths;
  @override
  final int? commitmentPeriodMonths;
  @override
  final BuiltList<SubscriptionPlanRulesInner>? rules;
  @override
  final DateTime? createdAt;

  factory _$SubscriptionPlan(
          [void Function(SubscriptionPlanBuilder)? updates]) =>
      (SubscriptionPlanBuilder()..update(updates))._build();

  _$SubscriptionPlan._(
      {this.id,
      this.title,
      this.sortPriority,
      this.isActive,
      this.priceInSubunit,
      this.maxUsers,
      this.setupFeeInSubunit,
      this.bannerAdsPerMonth,
      this.normalAdsPerMonth,
      this.freeMonths,
      this.commitmentPeriodMonths,
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
        title == other.title &&
        sortPriority == other.sortPriority &&
        isActive == other.isActive &&
        priceInSubunit == other.priceInSubunit &&
        maxUsers == other.maxUsers &&
        setupFeeInSubunit == other.setupFeeInSubunit &&
        bannerAdsPerMonth == other.bannerAdsPerMonth &&
        normalAdsPerMonth == other.normalAdsPerMonth &&
        freeMonths == other.freeMonths &&
        commitmentPeriodMonths == other.commitmentPeriodMonths &&
        rules == other.rules &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, sortPriority.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, priceInSubunit.hashCode);
    _$hash = $jc(_$hash, maxUsers.hashCode);
    _$hash = $jc(_$hash, setupFeeInSubunit.hashCode);
    _$hash = $jc(_$hash, bannerAdsPerMonth.hashCode);
    _$hash = $jc(_$hash, normalAdsPerMonth.hashCode);
    _$hash = $jc(_$hash, freeMonths.hashCode);
    _$hash = $jc(_$hash, commitmentPeriodMonths.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionPlan')
          ..add('id', id)
          ..add('title', title)
          ..add('sortPriority', sortPriority)
          ..add('isActive', isActive)
          ..add('priceInSubunit', priceInSubunit)
          ..add('maxUsers', maxUsers)
          ..add('setupFeeInSubunit', setupFeeInSubunit)
          ..add('bannerAdsPerMonth', bannerAdsPerMonth)
          ..add('normalAdsPerMonth', normalAdsPerMonth)
          ..add('freeMonths', freeMonths)
          ..add('commitmentPeriodMonths', commitmentPeriodMonths)
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

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

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

  int? _maxUsers;
  int? get maxUsers => _$this._maxUsers;
  set maxUsers(int? maxUsers) => _$this._maxUsers = maxUsers;

  int? _setupFeeInSubunit;
  int? get setupFeeInSubunit => _$this._setupFeeInSubunit;
  set setupFeeInSubunit(int? setupFeeInSubunit) =>
      _$this._setupFeeInSubunit = setupFeeInSubunit;

  int? _bannerAdsPerMonth;
  int? get bannerAdsPerMonth => _$this._bannerAdsPerMonth;
  set bannerAdsPerMonth(int? bannerAdsPerMonth) =>
      _$this._bannerAdsPerMonth = bannerAdsPerMonth;

  int? _normalAdsPerMonth;
  int? get normalAdsPerMonth => _$this._normalAdsPerMonth;
  set normalAdsPerMonth(int? normalAdsPerMonth) =>
      _$this._normalAdsPerMonth = normalAdsPerMonth;

  int? _freeMonths;
  int? get freeMonths => _$this._freeMonths;
  set freeMonths(int? freeMonths) => _$this._freeMonths = freeMonths;

  int? _commitmentPeriodMonths;
  int? get commitmentPeriodMonths => _$this._commitmentPeriodMonths;
  set commitmentPeriodMonths(int? commitmentPeriodMonths) =>
      _$this._commitmentPeriodMonths = commitmentPeriodMonths;

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
      _title = $v.title;
      _sortPriority = $v.sortPriority;
      _isActive = $v.isActive;
      _priceInSubunit = $v.priceInSubunit;
      _maxUsers = $v.maxUsers;
      _setupFeeInSubunit = $v.setupFeeInSubunit;
      _bannerAdsPerMonth = $v.bannerAdsPerMonth;
      _normalAdsPerMonth = $v.normalAdsPerMonth;
      _freeMonths = $v.freeMonths;
      _commitmentPeriodMonths = $v.commitmentPeriodMonths;
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
            title: title,
            sortPriority: sortPriority,
            isActive: isActive,
            priceInSubunit: priceInSubunit,
            maxUsers: maxUsers,
            setupFeeInSubunit: setupFeeInSubunit,
            bannerAdsPerMonth: bannerAdsPerMonth,
            normalAdsPerMonth: normalAdsPerMonth,
            freeMonths: freeMonths,
            commitmentPeriodMonths: commitmentPeriodMonths,
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
