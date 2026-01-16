// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_pdf_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdPdfGet200Response
    extends InquiriesInquiryIdPdfGet200Response {
  @override
  final String? signedUrl;

  factory _$InquiriesInquiryIdPdfGet200Response(
          [void Function(InquiriesInquiryIdPdfGet200ResponseBuilder)?
              updates]) =>
      (InquiriesInquiryIdPdfGet200ResponseBuilder()..update(updates))._build();

  _$InquiriesInquiryIdPdfGet200Response._({this.signedUrl}) : super._();
  @override
  InquiriesInquiryIdPdfGet200Response rebuild(
          void Function(InquiriesInquiryIdPdfGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdPdfGet200ResponseBuilder toBuilder() =>
      InquiriesInquiryIdPdfGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdPdfGet200Response &&
        signedUrl == other.signedUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdPdfGet200Response')
          ..add('signedUrl', signedUrl))
        .toString();
  }
}

class InquiriesInquiryIdPdfGet200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdPdfGet200Response,
            InquiriesInquiryIdPdfGet200ResponseBuilder> {
  _$InquiriesInquiryIdPdfGet200Response? _$v;

  String? _signedUrl;
  String? get signedUrl => _$this._signedUrl;
  set signedUrl(String? signedUrl) => _$this._signedUrl = signedUrl;

  InquiriesInquiryIdPdfGet200ResponseBuilder() {
    InquiriesInquiryIdPdfGet200Response._defaults(this);
  }

  InquiriesInquiryIdPdfGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedUrl = $v.signedUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdPdfGet200Response other) {
    _$v = other as _$InquiriesInquiryIdPdfGet200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdPdfGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdPdfGet200Response build() => _build();

  _$InquiriesInquiryIdPdfGet200Response _build() {
    final _$result = _$v ??
        _$InquiriesInquiryIdPdfGet200Response._(
          signedUrl: signedUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
