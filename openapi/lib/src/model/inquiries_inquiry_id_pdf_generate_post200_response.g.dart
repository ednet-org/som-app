// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_pdf_generate_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdPdfGeneratePost200Response
    extends InquiriesInquiryIdPdfGeneratePost200Response {
  @override
  final String? summaryPdfPath;
  @override
  final String? signedUrl;

  factory _$InquiriesInquiryIdPdfGeneratePost200Response(
          [void Function(InquiriesInquiryIdPdfGeneratePost200ResponseBuilder)?
              updates]) =>
      (InquiriesInquiryIdPdfGeneratePost200ResponseBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdPdfGeneratePost200Response._(
      {this.summaryPdfPath, this.signedUrl})
      : super._();
  @override
  InquiriesInquiryIdPdfGeneratePost200Response rebuild(
          void Function(InquiriesInquiryIdPdfGeneratePost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdPdfGeneratePost200ResponseBuilder toBuilder() =>
      InquiriesInquiryIdPdfGeneratePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdPdfGeneratePost200Response &&
        summaryPdfPath == other.summaryPdfPath &&
        signedUrl == other.signedUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, summaryPdfPath.hashCode);
    _$hash = $jc(_$hash, signedUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'InquiriesInquiryIdPdfGeneratePost200Response')
          ..add('summaryPdfPath', summaryPdfPath)
          ..add('signedUrl', signedUrl))
        .toString();
  }
}

class InquiriesInquiryIdPdfGeneratePost200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdPdfGeneratePost200Response,
            InquiriesInquiryIdPdfGeneratePost200ResponseBuilder> {
  _$InquiriesInquiryIdPdfGeneratePost200Response? _$v;

  String? _summaryPdfPath;
  String? get summaryPdfPath => _$this._summaryPdfPath;
  set summaryPdfPath(String? summaryPdfPath) =>
      _$this._summaryPdfPath = summaryPdfPath;

  String? _signedUrl;
  String? get signedUrl => _$this._signedUrl;
  set signedUrl(String? signedUrl) => _$this._signedUrl = signedUrl;

  InquiriesInquiryIdPdfGeneratePost200ResponseBuilder() {
    InquiriesInquiryIdPdfGeneratePost200Response._defaults(this);
  }

  InquiriesInquiryIdPdfGeneratePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _summaryPdfPath = $v.summaryPdfPath;
      _signedUrl = $v.signedUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdPdfGeneratePost200Response other) {
    _$v = other as _$InquiriesInquiryIdPdfGeneratePost200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdPdfGeneratePost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdPdfGeneratePost200Response build() => _build();

  _$InquiriesInquiryIdPdfGeneratePost200Response _build() {
    final _$result = _$v ??
        _$InquiriesInquiryIdPdfGeneratePost200Response._(
          summaryPdfPath: summaryPdfPath,
          signedUrl: signedUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
