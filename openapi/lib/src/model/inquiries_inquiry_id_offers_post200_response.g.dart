// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_offers_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdOffersPost200Response
    extends InquiriesInquiryIdOffersPost200Response {
  @override
  final String? id;
  @override
  final String? status;

  factory _$InquiriesInquiryIdOffersPost200Response(
          [void Function(InquiriesInquiryIdOffersPost200ResponseBuilder)?
              updates]) =>
      (InquiriesInquiryIdOffersPost200ResponseBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdOffersPost200Response._({this.id, this.status})
      : super._();
  @override
  InquiriesInquiryIdOffersPost200Response rebuild(
          void Function(InquiriesInquiryIdOffersPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdOffersPost200ResponseBuilder toBuilder() =>
      InquiriesInquiryIdOffersPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdOffersPost200Response &&
        id == other.id &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'InquiriesInquiryIdOffersPost200Response')
          ..add('id', id)
          ..add('status', status))
        .toString();
  }
}

class InquiriesInquiryIdOffersPost200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdOffersPost200Response,
            InquiriesInquiryIdOffersPost200ResponseBuilder> {
  _$InquiriesInquiryIdOffersPost200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  InquiriesInquiryIdOffersPost200ResponseBuilder() {
    InquiriesInquiryIdOffersPost200Response._defaults(this);
  }

  InquiriesInquiryIdOffersPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdOffersPost200Response other) {
    _$v = other as _$InquiriesInquiryIdOffersPost200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdOffersPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdOffersPost200Response build() => _build();

  _$InquiriesInquiryIdOffersPost200Response _build() {
    final _$result = _$v ??
        _$InquiriesInquiryIdOffersPost200Response._(
          id: id,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
