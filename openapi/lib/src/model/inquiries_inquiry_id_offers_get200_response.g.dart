// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_offers_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdOffersGet200Response
    extends InquiriesInquiryIdOffersGet200Response {
  @override
  final String? id;
  @override
  final String? status;

  factory _$InquiriesInquiryIdOffersGet200Response(
          [void Function(InquiriesInquiryIdOffersGet200ResponseBuilder)?
              updates]) =>
      (new InquiriesInquiryIdOffersGet200ResponseBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdOffersGet200Response._({this.id, this.status})
      : super._();

  @override
  InquiriesInquiryIdOffersGet200Response rebuild(
          void Function(InquiriesInquiryIdOffersGet200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdOffersGet200ResponseBuilder toBuilder() =>
      new InquiriesInquiryIdOffersGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdOffersGet200Response &&
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
            r'InquiriesInquiryIdOffersGet200Response')
          ..add('id', id)
          ..add('status', status))
        .toString();
  }
}

class InquiriesInquiryIdOffersGet200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdOffersGet200Response,
            InquiriesInquiryIdOffersGet200ResponseBuilder> {
  _$InquiriesInquiryIdOffersGet200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  InquiriesInquiryIdOffersGet200ResponseBuilder() {
    InquiriesInquiryIdOffersGet200Response._defaults(this);
  }

  InquiriesInquiryIdOffersGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdOffersGet200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InquiriesInquiryIdOffersGet200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdOffersGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdOffersGet200Response build() => _build();

  _$InquiriesInquiryIdOffersGet200Response _build() {
    final _$result = _$v ??
        new _$InquiriesInquiryIdOffersGet200Response._(
          id: id,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
