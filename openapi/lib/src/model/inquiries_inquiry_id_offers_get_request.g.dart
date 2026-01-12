// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_offers_get_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdOffersGetRequest
    extends InquiriesInquiryIdOffersGetRequest {
  @override
  final String? pdfBase64;

  factory _$InquiriesInquiryIdOffersGetRequest(
          [void Function(InquiriesInquiryIdOffersGetRequestBuilder)?
              updates]) =>
      (new InquiriesInquiryIdOffersGetRequestBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdOffersGetRequest._({this.pdfBase64}) : super._();

  @override
  InquiriesInquiryIdOffersGetRequest rebuild(
          void Function(InquiriesInquiryIdOffersGetRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdOffersGetRequestBuilder toBuilder() =>
      new InquiriesInquiryIdOffersGetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdOffersGetRequest &&
        pdfBase64 == other.pdfBase64;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pdfBase64.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdOffersGetRequest')
          ..add('pdfBase64', pdfBase64))
        .toString();
  }
}

class InquiriesInquiryIdOffersGetRequestBuilder
    implements
        Builder<InquiriesInquiryIdOffersGetRequest,
            InquiriesInquiryIdOffersGetRequestBuilder> {
  _$InquiriesInquiryIdOffersGetRequest? _$v;

  String? _pdfBase64;
  String? get pdfBase64 => _$this._pdfBase64;
  set pdfBase64(String? pdfBase64) => _$this._pdfBase64 = pdfBase64;

  InquiriesInquiryIdOffersGetRequestBuilder() {
    InquiriesInquiryIdOffersGetRequest._defaults(this);
  }

  InquiriesInquiryIdOffersGetRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdfBase64 = $v.pdfBase64;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdOffersGetRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InquiriesInquiryIdOffersGetRequest;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdOffersGetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdOffersGetRequest build() => _build();

  _$InquiriesInquiryIdOffersGetRequest _build() {
    final _$result = _$v ??
        new _$InquiriesInquiryIdOffersGetRequest._(
          pdfBase64: pdfBase64,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
