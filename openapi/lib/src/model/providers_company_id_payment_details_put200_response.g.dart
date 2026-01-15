// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_company_id_payment_details_put200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProvidersCompanyIdPaymentDetailsPut200Response
    extends ProvidersCompanyIdPaymentDetailsPut200Response {
  @override
  final String? companyId;
  @override
  final BankDetails? bankDetails;

  factory _$ProvidersCompanyIdPaymentDetailsPut200Response(
          [void Function(ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder)?
              updates]) =>
      (ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder()..update(updates))
          ._build();

  _$ProvidersCompanyIdPaymentDetailsPut200Response._(
      {this.companyId, this.bankDetails})
      : super._();
  @override
  ProvidersCompanyIdPaymentDetailsPut200Response rebuild(
          void Function(ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder toBuilder() =>
      ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProvidersCompanyIdPaymentDetailsPut200Response &&
        companyId == other.companyId &&
        bankDetails == other.bankDetails;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, bankDetails.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ProvidersCompanyIdPaymentDetailsPut200Response')
          ..add('companyId', companyId)
          ..add('bankDetails', bankDetails))
        .toString();
  }
}

class ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder
    implements
        Builder<ProvidersCompanyIdPaymentDetailsPut200Response,
            ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder> {
  _$ProvidersCompanyIdPaymentDetailsPut200Response? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  BankDetailsBuilder? _bankDetails;
  BankDetailsBuilder get bankDetails =>
      _$this._bankDetails ??= BankDetailsBuilder();
  set bankDetails(BankDetailsBuilder? bankDetails) =>
      _$this._bankDetails = bankDetails;

  ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder() {
    ProvidersCompanyIdPaymentDetailsPut200Response._defaults(this);
  }

  ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _bankDetails = $v.bankDetails?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProvidersCompanyIdPaymentDetailsPut200Response other) {
    _$v = other as _$ProvidersCompanyIdPaymentDetailsPut200Response;
  }

  @override
  void update(
      void Function(ProvidersCompanyIdPaymentDetailsPut200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ProvidersCompanyIdPaymentDetailsPut200Response build() => _build();

  _$ProvidersCompanyIdPaymentDetailsPut200Response _build() {
    _$ProvidersCompanyIdPaymentDetailsPut200Response _$result;
    try {
      _$result = _$v ??
          _$ProvidersCompanyIdPaymentDetailsPut200Response._(
            companyId: companyId,
            bankDetails: _bankDetails?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bankDetails';
        _bankDetails?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProvidersCompanyIdPaymentDetailsPut200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
