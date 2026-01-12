// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionPlanDto extends SubscriptionPlanDto {
  @override
  final String? id;
  @override
  final int? sortPriority;
  @override
  final bool? isActive;
  @override
  final int? priceInSubunit;
  @override
  final BuiltList<SubscriptionRuleDto>? rules;
  @override
  final DateTime? createdAt;

  factory _$SubscriptionPlanDto(
          [void Function(SubscriptionPlanDtoBuilder)? updates]) =>
      (new SubscriptionPlanDtoBuilder()..update(updates))._build();

  _$SubscriptionPlanDto._(
      {this.id,
      this.sortPriority,
      this.isActive,
      this.priceInSubunit,
      this.rules,
      this.createdAt})
      : super._();

  @override
  SubscriptionPlanDto rebuild(
          void Function(SubscriptionPlanDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionPlanDtoBuilder toBuilder() =>
      new SubscriptionPlanDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionPlanDto &&
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
    return (newBuiltValueToStringHelper(r'SubscriptionPlanDto')
          ..add('id', id)
          ..add('sortPriority', sortPriority)
          ..add('isActive', isActive)
          ..add('priceInSubunit', priceInSubunit)
          ..add('rules', rules)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class SubscriptionPlanDtoBuilder
    implements Builder<SubscriptionPlanDto, SubscriptionPlanDtoBuilder> {
  _$SubscriptionPlanDto? _$v;

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

  ListBuilder<SubscriptionRuleDto>? _rules;
  ListBuilder<SubscriptionRuleDto> get rules =>
      _$this._rules ??= new ListBuilder<SubscriptionRuleDto>();
  set rules(ListBuilder<SubscriptionRuleDto>? rules) => _$this._rules = rules;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  SubscriptionPlanDtoBuilder() {
    SubscriptionPlanDto._defaults(this);
  }

  SubscriptionPlanDtoBuilder get _$this {
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
  void replace(SubscriptionPlanDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubscriptionPlanDto;
  }

  @override
  void update(void Function(SubscriptionPlanDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionPlanDto build() => _build();

  _$SubscriptionPlanDto _build() {
    _$SubscriptionPlanDto _$result;
    try {
      _$result = _$v ??
          new _$SubscriptionPlanDto._(
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
        throw new BuiltValueNestedFieldError(
            r'SubscriptionPlanDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
