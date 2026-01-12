// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_assign_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdAssignPostRequest
    extends InquiriesInquiryIdAssignPostRequest {
  @override
  final BuiltList<String> providerCompanyIds;

  factory _$InquiriesInquiryIdAssignPostRequest(
          [void Function(InquiriesInquiryIdAssignPostRequestBuilder)?
              updates]) =>
      (new InquiriesInquiryIdAssignPostRequestBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdAssignPostRequest._({required this.providerCompanyIds})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(providerCompanyIds,
        r'InquiriesInquiryIdAssignPostRequest', 'providerCompanyIds');
  }

  @override
  InquiriesInquiryIdAssignPostRequest rebuild(
          void Function(InquiriesInquiryIdAssignPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdAssignPostRequestBuilder toBuilder() =>
      new InquiriesInquiryIdAssignPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdAssignPostRequest &&
        providerCompanyIds == other.providerCompanyIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerCompanyIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InquiriesInquiryIdAssignPostRequest')
          ..add('providerCompanyIds', providerCompanyIds))
        .toString();
  }
}

class InquiriesInquiryIdAssignPostRequestBuilder
    implements
        Builder<InquiriesInquiryIdAssignPostRequest,
            InquiriesInquiryIdAssignPostRequestBuilder> {
  _$InquiriesInquiryIdAssignPostRequest? _$v;

  ListBuilder<String>? _providerCompanyIds;
  ListBuilder<String> get providerCompanyIds =>
      _$this._providerCompanyIds ??= new ListBuilder<String>();
  set providerCompanyIds(ListBuilder<String>? providerCompanyIds) =>
      _$this._providerCompanyIds = providerCompanyIds;

  InquiriesInquiryIdAssignPostRequestBuilder() {
    InquiriesInquiryIdAssignPostRequest._defaults(this);
  }

  InquiriesInquiryIdAssignPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerCompanyIds = $v.providerCompanyIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdAssignPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InquiriesInquiryIdAssignPostRequest;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdAssignPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdAssignPostRequest build() => _build();

  _$InquiriesInquiryIdAssignPostRequest _build() {
    _$InquiriesInquiryIdAssignPostRequest _$result;
    try {
      _$result = _$v ??
          new _$InquiriesInquiryIdAssignPostRequest._(
            providerCompanyIds: providerCompanyIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'providerCompanyIds';
        providerCompanyIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'InquiriesInquiryIdAssignPostRequest',
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
