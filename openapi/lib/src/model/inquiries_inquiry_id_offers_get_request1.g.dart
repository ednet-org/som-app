// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_offers_get_request1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdOffersGetRequest1
    extends InquiriesInquiryIdOffersGetRequest1 {
  @override
  final String? pdfBase64;

  factory _$InquiriesInquiryIdOffersGetRequest1(
          [void Function(InquiriesInquiryIdOffersGetRequest1Builder)?
              updates]) =>
      (new InquiriesInquiryIdOffersGetRequest1Builder()..update(updates))
          ._build();

  _$InquiriesInquiryIdOffersGetRequest1._({this.pdfBase64}) : super._();

  @override
  InquiriesInquiryIdOffersGetRequest1 rebuild(
          void Function(InquiriesInquiryIdOffersGetRequest1Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdOffersGetRequest1Builder toBuilder() =>
      new InquiriesInquiryIdOffersGetRequest1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdOffersGetRequest1 &&
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
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdOffersGetRequest1')
          ..add('pdfBase64', pdfBase64))
        .toString();
  }
}

class InquiriesInquiryIdOffersGetRequest1Builder
    implements
        Builder<InquiriesInquiryIdOffersGetRequest1,
            InquiriesInquiryIdOffersGetRequest1Builder> {
  _$InquiriesInquiryIdOffersGetRequest1? _$v;

  String? _pdfBase64;
  String? get pdfBase64 => _$this._pdfBase64;
  set pdfBase64(String? pdfBase64) => _$this._pdfBase64 = pdfBase64;

  InquiriesInquiryIdOffersGetRequest1Builder() {
    InquiriesInquiryIdOffersGetRequest1._defaults(this);
  }

  InquiriesInquiryIdOffersGetRequest1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdfBase64 = $v.pdfBase64;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdOffersGetRequest1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InquiriesInquiryIdOffersGetRequest1;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdOffersGetRequest1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdOffersGetRequest1 build() => _build();

  _$InquiriesInquiryIdOffersGetRequest1 _build() {
    final _$result = _$v ??
        new _$InquiriesInquiryIdOffersGetRequest1._(
          pdfBase64: pdfBase64,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
