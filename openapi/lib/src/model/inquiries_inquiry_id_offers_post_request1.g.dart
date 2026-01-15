// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_offers_post_request1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdOffersPostRequest1
    extends InquiriesInquiryIdOffersPostRequest1 {
  @override
  final String? pdfBase64;

  factory _$InquiriesInquiryIdOffersPostRequest1(
          [void Function(InquiriesInquiryIdOffersPostRequest1Builder)?
              updates]) =>
      (InquiriesInquiryIdOffersPostRequest1Builder()..update(updates))._build();

  _$InquiriesInquiryIdOffersPostRequest1._({this.pdfBase64}) : super._();
  @override
  InquiriesInquiryIdOffersPostRequest1 rebuild(
          void Function(InquiriesInquiryIdOffersPostRequest1Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdOffersPostRequest1Builder toBuilder() =>
      InquiriesInquiryIdOffersPostRequest1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdOffersPostRequest1 &&
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
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdOffersPostRequest1')
          ..add('pdfBase64', pdfBase64))
        .toString();
  }
}

class InquiriesInquiryIdOffersPostRequest1Builder
    implements
        Builder<InquiriesInquiryIdOffersPostRequest1,
            InquiriesInquiryIdOffersPostRequest1Builder> {
  _$InquiriesInquiryIdOffersPostRequest1? _$v;

  String? _pdfBase64;
  String? get pdfBase64 => _$this._pdfBase64;
  set pdfBase64(String? pdfBase64) => _$this._pdfBase64 = pdfBase64;

  InquiriesInquiryIdOffersPostRequest1Builder() {
    InquiriesInquiryIdOffersPostRequest1._defaults(this);
  }

  InquiriesInquiryIdOffersPostRequest1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdfBase64 = $v.pdfBase64;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdOffersPostRequest1 other) {
    _$v = other as _$InquiriesInquiryIdOffersPostRequest1;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdOffersPostRequest1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdOffersPostRequest1 build() => _build();

  _$InquiriesInquiryIdOffersPostRequest1 _build() {
    final _$result = _$v ??
        _$InquiriesInquiryIdOffersPostRequest1._(
          pdfBase64: pdfBase64,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
