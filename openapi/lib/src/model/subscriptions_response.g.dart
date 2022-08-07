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
    return $jf($jc(0, subscriptions.hashCode));
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
          new _$SubscriptionsResponse._(subscriptions: _subscriptions?.build());
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
