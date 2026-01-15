// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiries_inquiry_id_assign_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InquiriesInquiryIdAssignPost200Response
    extends InquiriesInquiryIdAssignPost200Response {
  @override
  final BuiltList<String>? assignedProviders;
  @override
  final BuiltList<String>? skippedProviders;

  factory _$InquiriesInquiryIdAssignPost200Response(
          [void Function(InquiriesInquiryIdAssignPost200ResponseBuilder)?
              updates]) =>
      (InquiriesInquiryIdAssignPost200ResponseBuilder()..update(updates))
          ._build();

  _$InquiriesInquiryIdAssignPost200Response._(
      {this.assignedProviders, this.skippedProviders})
      : super._();
  @override
  InquiriesInquiryIdAssignPost200Response rebuild(
          void Function(InquiriesInquiryIdAssignPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiriesInquiryIdAssignPost200ResponseBuilder toBuilder() =>
      InquiriesInquiryIdAssignPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InquiriesInquiryIdAssignPost200Response &&
        assignedProviders == other.assignedProviders &&
        skippedProviders == other.skippedProviders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assignedProviders.hashCode);
    _$hash = $jc(_$hash, skippedProviders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'InquiriesInquiryIdAssignPost200Response')
          ..add('assignedProviders', assignedProviders)
          ..add('skippedProviders', skippedProviders))
        .toString();
  }
}

class InquiriesInquiryIdAssignPost200ResponseBuilder
    implements
        Builder<InquiriesInquiryIdAssignPost200Response,
            InquiriesInquiryIdAssignPost200ResponseBuilder> {
  _$InquiriesInquiryIdAssignPost200Response? _$v;

  ListBuilder<String>? _assignedProviders;
  ListBuilder<String> get assignedProviders =>
      _$this._assignedProviders ??= ListBuilder<String>();
  set assignedProviders(ListBuilder<String>? assignedProviders) =>
      _$this._assignedProviders = assignedProviders;

  ListBuilder<String>? _skippedProviders;
  ListBuilder<String> get skippedProviders =>
      _$this._skippedProviders ??= ListBuilder<String>();
  set skippedProviders(ListBuilder<String>? skippedProviders) =>
      _$this._skippedProviders = skippedProviders;

  InquiriesInquiryIdAssignPost200ResponseBuilder() {
    InquiriesInquiryIdAssignPost200Response._defaults(this);
  }

  InquiriesInquiryIdAssignPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assignedProviders = $v.assignedProviders?.toBuilder();
      _skippedProviders = $v.skippedProviders?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InquiriesInquiryIdAssignPost200Response other) {
    _$v = other as _$InquiriesInquiryIdAssignPost200Response;
  }

  @override
  void update(
      void Function(InquiriesInquiryIdAssignPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InquiriesInquiryIdAssignPost200Response build() => _build();

  _$InquiriesInquiryIdAssignPost200Response _build() {
    _$InquiriesInquiryIdAssignPost200Response _$result;
    try {
      _$result = _$v ??
          _$InquiriesInquiryIdAssignPost200Response._(
            assignedProviders: _assignedProviders?.build(),
            skippedProviders: _skippedProviders?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'assignedProviders';
        _assignedProviders?.build();
        _$failedField = 'skippedProviders';
        _skippedProviders?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InquiriesInquiryIdAssignPost200Response',
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
