// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_pdf_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdPdfPost200Response
    extends InquiriesInquiryIdPdfPost200Response {
  @override
  final String? pdfPath;

  factory _$InquiriesInquiryIdPdfPost200Response(
          [void Function(InquiriesInquiryIdPdfPost200ResponseBuilder)?
              updates]) =>
      (InquiriesInquiryIdPdfPost200ResponseBuilder()..update(updates))._build();

  _$InquiriesInquiryIdPdfPost200Response._({this.pdfPath}) : super._();
  @override
  InquiriesInquiryIdPdfPost200Response rebuild(
          void Function(InquiriesInquiryIdPdfPost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdPdfPost200ResponseBuilder toBuilder() =>
      InquiriesInquiryIdPdfPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdPdfPost200Response &&
        pdfPath == other.pdfPath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pdfPath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdPdfPost200Response')
          ..add('pdfPath', pdfPath))
        .toString();
  }
}

class InquiriesInquiryIdPdfPost200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdPdfPost200Response,
            InquiriesInquiryIdPdfPost200ResponseBuilder> {
  _$InquiriesInquiryIdPdfPost200Response? _$v;

  String? _pdfPath;
  String? get pdfPath => _$this._pdfPath;
  set pdfPath(String? pdfPath) => _$this._pdfPath = pdfPath;

  InquiriesInquiryIdPdfPost200ResponseBuilder() {
    InquiriesInquiryIdPdfPost200Response._defaults(this);
  }

  InquiriesInquiryIdPdfPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdfPath = $v.pdfPath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdPdfPost200Response other) {
    _$v = other as _$InquiriesInquiryIdPdfPost200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdPdfPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdPdfPost200Response build() => _build();

  _$InquiriesInquiryIdPdfPost200Response _build() {
    final _$result = _$v ??
        _$InquiriesInquiryIdPdfPost200Response._(
          pdfPath: pdfPath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
