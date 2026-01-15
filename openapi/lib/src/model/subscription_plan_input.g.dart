// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionPlanInput extends SubscriptionPlanInput {
  @override
  final String title;
  @override
  final int sortPriority;
  @override
  final bool? isActive;
  @override
  final int priceInSubunit;
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
  final bool? confirm;
  @override
  final BuiltList<SubscriptionPlanRulesInner>? rules;

  factory _$SubscriptionPlanInput(
          [void Function(SubscriptionPlanInputBuilder)? updates]) =>
      (SubscriptionPlanInputBuilder()..update(updates))._build();

  _$SubscriptionPlanInput._(
      {required this.title,
      required this.sortPriority,
      this.isActive,
      required this.priceInSubunit,
      this.maxUsers,
      this.setupFeeInSubunit,
      this.bannerAdsPerMonth,
      this.normalAdsPerMonth,
      this.freeMonths,
      this.commitmentPeriodMonths,
      this.confirm,
      this.rules})
      : super._();
  @override
  SubscriptionPlanInput rebuild(
          void Function(SubscriptionPlanInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionPlanInputBuilder toBuilder() =>
      SubscriptionPlanInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionPlanInput &&
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
        confirm == other.confirm &&
        rules == other.rules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jc(_$hash, confirm.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionPlanInput')
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
          ..add('confirm', confirm)
          ..add('rules', rules))
        .toString();
  }
}

class SubscriptionPlanInputBuilder
    implements Builder<SubscriptionPlanInput, SubscriptionPlanInputBuilder> {
  _$SubscriptionPlanInput? _$v;

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

  bool? _confirm;
  bool? get confirm => _$this._confirm;
  set confirm(bool? confirm) => _$this._confirm = confirm;

  ListBuilder<SubscriptionPlanRulesInner>? _rules;
  ListBuilder<SubscriptionPlanRulesInner> get rules =>
      _$this._rules ??= ListBuilder<SubscriptionPlanRulesInner>();
  set rules(ListBuilder<SubscriptionPlanRulesInner>? rules) =>
      _$this._rules = rules;

  SubscriptionPlanInputBuilder() {
    SubscriptionPlanInput._defaults(this);
  }

  SubscriptionPlanInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
      _confirm = $v.confirm;
      _rules = $v.rules?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionPlanInput other) {
    _$v = other as _$SubscriptionPlanInput;
  }

  @override
  void update(void Function(SubscriptionPlanInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionPlanInput build() => _build();

  _$SubscriptionPlanInput _build() {
    _$SubscriptionPlanInput _$result;
    try {
      _$result = _$v ??
          _$SubscriptionPlanInput._(
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'SubscriptionPlanInput', 'title'),
            sortPriority: BuiltValueNullFieldError.checkNotNull(
                sortPriority, r'SubscriptionPlanInput', 'sortPriority'),
            isActive: isActive,
            priceInSubunit: BuiltValueNullFieldError.checkNotNull(
                priceInSubunit, r'SubscriptionPlanInput', 'priceInSubunit'),
            maxUsers: maxUsers,
            setupFeeInSubunit: setupFeeInSubunit,
            bannerAdsPerMonth: bannerAdsPerMonth,
            normalAdsPerMonth: normalAdsPerMonth,
            freeMonths: freeMonths,
            commitmentPeriodMonths: commitmentPeriodMonths,
            confirm: confirm,
            rules: _rules?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        _rules?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SubscriptionPlanInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
