// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_registration_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProviderRegistrationDataPaymentIntervalEnum
    _$providerRegistrationDataPaymentIntervalEnum_number0 =
    const ProviderRegistrationDataPaymentIntervalEnum._('number0');
const ProviderRegistrationDataPaymentIntervalEnum
    _$providerRegistrationDataPaymentIntervalEnum_number1 =
    const ProviderRegistrationDataPaymentIntervalEnum._('number1');

ProviderRegistrationDataPaymentIntervalEnum
    _$providerRegistrationDataPaymentIntervalEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$providerRegistrationDataPaymentIntervalEnum_number0;
    case 'number1':
      return _$providerRegistrationDataPaymentIntervalEnum_number1;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProviderRegistrationDataPaymentIntervalEnum>
    _$providerRegistrationDataPaymentIntervalEnumValues = BuiltSet<
        ProviderRegistrationDataPaymentIntervalEnum>(const <ProviderRegistrationDataPaymentIntervalEnum>[
  _$providerRegistrationDataPaymentIntervalEnum_number0,
  _$providerRegistrationDataPaymentIntervalEnum_number1,
]);

Serializer<ProviderRegistrationDataPaymentIntervalEnum>
    _$providerRegistrationDataPaymentIntervalEnumSerializer =
    _$ProviderRegistrationDataPaymentIntervalEnumSerializer();

class _$ProviderRegistrationDataPaymentIntervalEnumSerializer
    implements
        PrimitiveSerializer<ProviderRegistrationDataPaymentIntervalEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProviderRegistrationDataPaymentIntervalEnum
  ];
  @override
  final String wireName = 'ProviderRegistrationDataPaymentIntervalEnum';

  @override
  Object serialize(Serializers serializers,
          ProviderRegistrationDataPaymentIntervalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProviderRegistrationDataPaymentIntervalEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProviderRegistrationDataPaymentIntervalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProviderRegistrationData extends ProviderRegistrationData {
  @override
  final BankDetails? bankDetails;
  @override
  final BuiltList<String>? branchIds;
  @override
  final String? subscriptionPlanId;
  @override
  final ProviderRegistrationDataPaymentIntervalEnum? paymentInterval;

  factory _$ProviderRegistrationData(
          [void Function(ProviderRegistrationDataBuilder)? updates]) =>
      (ProviderRegistrationDataBuilder()..update(updates))._build();

  _$ProviderRegistrationData._(
      {this.bankDetails,
      this.branchIds,
      this.subscriptionPlanId,
      this.paymentInterval})
      : super._();
  @override
  ProviderRegistrationData rebuild(
          void Function(ProviderRegistrationDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderRegistrationDataBuilder toBuilder() =>
      ProviderRegistrationDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderRegistrationData &&
        bankDetails == other.bankDetails &&
        branchIds == other.branchIds &&
        subscriptionPlanId == other.subscriptionPlanId &&
        paymentInterval == other.paymentInterval;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bankDetails.hashCode);
    _$hash = $jc(_$hash, branchIds.hashCode);
    _$hash = $jc(_$hash, subscriptionPlanId.hashCode);
    _$hash = $jc(_$hash, paymentInterval.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderRegistrationData')
          ..add('bankDetails', bankDetails)
          ..add('branchIds', branchIds)
          ..add('subscriptionPlanId', subscriptionPlanId)
          ..add('paymentInterval', paymentInterval))
        .toString();
  }
}

class ProviderRegistrationDataBuilder
    implements
        Builder<ProviderRegistrationData, ProviderRegistrationDataBuilder> {
  _$ProviderRegistrationData? _$v;

  BankDetailsBuilder? _bankDetails;
  BankDetailsBuilder get bankDetails =>
      _$this._bankDetails ??= BankDetailsBuilder();
  set bankDetails(BankDetailsBuilder? bankDetails) =>
      _$this._bankDetails = bankDetails;

  ListBuilder<String>? _branchIds;
  ListBuilder<String> get branchIds =>
      _$this._branchIds ??= ListBuilder<String>();
  set branchIds(ListBuilder<String>? branchIds) =>
      _$this._branchIds = branchIds;

  String? _subscriptionPlanId;
  String? get subscriptionPlanId => _$this._subscriptionPlanId;
  set subscriptionPlanId(String? subscriptionPlanId) =>
      _$this._subscriptionPlanId = subscriptionPlanId;

  ProviderRegistrationDataPaymentIntervalEnum? _paymentInterval;
  ProviderRegistrationDataPaymentIntervalEnum? get paymentInterval =>
      _$this._paymentInterval;
  set paymentInterval(
          ProviderRegistrationDataPaymentIntervalEnum? paymentInterval) =>
      _$this._paymentInterval = paymentInterval;

  ProviderRegistrationDataBuilder() {
    ProviderRegistrationData._defaults(this);
  }

  ProviderRegistrationDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bankDetails = $v.bankDetails?.toBuilder();
      _branchIds = $v.branchIds?.toBuilder();
      _subscriptionPlanId = $v.subscriptionPlanId;
      _paymentInterval = $v.paymentInterval;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderRegistrationData other) {
    _$v = other as _$ProviderRegistrationData;
  }

  @override
  void update(void Function(ProviderRegistrationDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderRegistrationData build() => _build();

  _$ProviderRegistrationData _build() {
    _$ProviderRegistrationData _$result;
    try {
      _$result = _$v ??
          _$ProviderRegistrationData._(
            bankDetails: _bankDetails?.build(),
            branchIds: _branchIds?.build(),
            subscriptionPlanId: subscriptionPlanId,
            paymentInterval: paymentInterval,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bankDetails';
        _bankDetails?.build();
        _$failedField = 'branchIds';
        _branchIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProviderRegistrationData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
