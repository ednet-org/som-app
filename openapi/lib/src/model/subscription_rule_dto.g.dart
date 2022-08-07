// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_rule_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubscriptionRuleDto extends SubscriptionRuleDto {
  @override
  final String? id;
  @override
  final int? upperLimit;
  @override
  final RestrictionType? restriction;

  factory _$SubscriptionRuleDto(
          [void Function(SubscriptionRuleDtoBuilder)? updates]) =>
      (new SubscriptionRuleDtoBuilder()..update(updates))._build();

  _$SubscriptionRuleDto._({this.id, this.upperLimit, this.restriction})
      : super._();

  @override
  SubscriptionRuleDto rebuild(
          void Function(SubscriptionRuleDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubscriptionRuleDtoBuilder toBuilder() =>
      new SubscriptionRuleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionRuleDto &&
        id == other.id &&
        upperLimit == other.upperLimit &&
        restriction == other.restriction;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, id.hashCode), upperLimit.hashCode), restriction.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubscriptionRuleDto')
          ..add('id', id)
          ..add('upperLimit', upperLimit)
          ..add('restriction', restriction))
        .toString();
  }
}

class SubscriptionRuleDtoBuilder
    implements Builder<SubscriptionRuleDto, SubscriptionRuleDtoBuilder> {
  _$SubscriptionRuleDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _upperLimit;
  int? get upperLimit => _$this._upperLimit;
  set upperLimit(int? upperLimit) => _$this._upperLimit = upperLimit;

  RestrictionType? _restriction;
  RestrictionType? get restriction => _$this._restriction;
  set restriction(RestrictionType? restriction) =>
      _$this._restriction = restriction;

  SubscriptionRuleDtoBuilder() {
    SubscriptionRuleDto._defaults(this);
  }

  SubscriptionRuleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _upperLimit = $v.upperLimit;
      _restriction = $v.restriction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubscriptionRuleDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubscriptionRuleDto;
  }

  @override
  void update(void Function(SubscriptionRuleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubscriptionRuleDto build() => _build();

  _$SubscriptionRuleDto _build() {
    final _$result = _$v ??
        new _$SubscriptionRuleDto._(
            id: id, upperLimit: upperLimit, restriction: restriction);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
