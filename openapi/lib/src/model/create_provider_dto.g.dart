// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_provider_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateProviderDto extends CreateProviderDto {
  @override
  final BankDetailsDto? bankDetails;
  @override
  final BuiltList<String>? branchIds;
  @override
  final PaymentInterval? paymentInterval;
  @override
  final String? subscriptionPlanId;

  factory _$CreateProviderDto(
          [void Function(CreateProviderDtoBuilder)? updates]) =>
      (new CreateProviderDtoBuilder()..update(updates))._build();

  _$CreateProviderDto._(
      {this.bankDetails,
      this.branchIds,
      this.paymentInterval,
      this.subscriptionPlanId})
      : super._();

  @override
  CreateProviderDto rebuild(void Function(CreateProviderDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateProviderDtoBuilder toBuilder() =>
      new CreateProviderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateProviderDto &&
        bankDetails == other.bankDetails &&
        branchIds == other.branchIds &&
        paymentInterval == other.paymentInterval &&
        subscriptionPlanId == other.subscriptionPlanId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, bankDetails.hashCode), branchIds.hashCode),
            paymentInterval.hashCode),
        subscriptionPlanId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateProviderDto')
          ..add('bankDetails', bankDetails)
          ..add('branchIds', branchIds)
          ..add('paymentInterval', paymentInterval)
          ..add('subscriptionPlanId', subscriptionPlanId))
        .toString();
  }
}

class CreateProviderDtoBuilder
    implements Builder<CreateProviderDto, CreateProviderDtoBuilder> {
  _$CreateProviderDto? _$v;

  BankDetailsDtoBuilder? _bankDetails;
  BankDetailsDtoBuilder get bankDetails =>
      _$this._bankDetails ??= new BankDetailsDtoBuilder();
  set bankDetails(BankDetailsDtoBuilder? bankDetails) =>
      _$this._bankDetails = bankDetails;

  ListBuilder<String>? _branchIds;
  ListBuilder<String> get branchIds =>
      _$this._branchIds ??= new ListBuilder<String>();
  set branchIds(ListBuilder<String>? branchIds) =>
      _$this._branchIds = branchIds;

  PaymentInterval? _paymentInterval;
  PaymentInterval? get paymentInterval => _$this._paymentInterval;
  set paymentInterval(PaymentInterval? paymentInterval) =>
      _$this._paymentInterval = paymentInterval;

  String? _subscriptionPlanId;
  String? get subscriptionPlanId => _$this._subscriptionPlanId;
  set subscriptionPlanId(String? subscriptionPlanId) =>
      _$this._subscriptionPlanId = subscriptionPlanId;

  CreateProviderDtoBuilder() {
    CreateProviderDto._defaults(this);
  }

  CreateProviderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankDetails = $v.bankDetails?.toBuilder();
      _branchIds = $v.branchIds?.toBuilder();
      _paymentInterval = $v.paymentInterval;
      _subscriptionPlanId = $v.subscriptionPlanId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateProviderDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateProviderDto;
  }

  @override
  void update(void Function(CreateProviderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateProviderDto build() => _build();

  _$CreateProviderDto _build() {
    _$CreateProviderDto _$result;
    try {
      _$result = _$v ??
          new _$CreateProviderDto._(
              bankDetails: _bankDetails?.build(),
              branchIds: _branchIds?.build(),
              paymentInterval: paymentInterval,
              subscriptionPlanId: subscriptionPlanId);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bankDetails';
        _bankDetails?.build();
        _$failedField = 'branchIds';
        _branchIds?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CreateProviderDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
