// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_company_id_approve_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProvidersCompanyIdApprovePostRequest
    extends ProvidersCompanyIdApprovePostRequest {
  @override
  final BuiltList<String>? approvedBranchIds;

  factory _$ProvidersCompanyIdApprovePostRequest(
          [void Function(ProvidersCompanyIdApprovePostRequestBuilder)?
              updates]) =>
      (ProvidersCompanyIdApprovePostRequestBuilder()..update(updates))._build();

  _$ProvidersCompanyIdApprovePostRequest._({this.approvedBranchIds})
      : super._();
  @override
  ProvidersCompanyIdApprovePostRequest rebuild(
          void Function(ProvidersCompanyIdApprovePostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProvidersCompanyIdApprovePostRequestBuilder toBuilder() =>
      ProvidersCompanyIdApprovePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProvidersCompanyIdApprovePostRequest &&
        approvedBranchIds == other.approvedBranchIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, approvedBranchIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProvidersCompanyIdApprovePostRequest')
          ..add('approvedBranchIds', approvedBranchIds))
        .toString();
  }
}

class ProvidersCompanyIdApprovePostRequestBuilder
    implements
        Builder<ProvidersCompanyIdApprovePostRequest,
            ProvidersCompanyIdApprovePostRequestBuilder> {
  _$ProvidersCompanyIdApprovePostRequest? _$v;

  ListBuilder<String>? _approvedBranchIds;
  ListBuilder<String> get approvedBranchIds =>
      _$this._approvedBranchIds ??= ListBuilder<String>();
  set approvedBranchIds(ListBuilder<String>? approvedBranchIds) =>
      _$this._approvedBranchIds = approvedBranchIds;

  ProvidersCompanyIdApprovePostRequestBuilder() {
    ProvidersCompanyIdApprovePostRequest._defaults(this);
  }

  ProvidersCompanyIdApprovePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _approvedBranchIds = $v.approvedBranchIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProvidersCompanyIdApprovePostRequest other) {
    _$v = other as _$ProvidersCompanyIdApprovePostRequest;
  }

  @override
  void update(
      void Function(ProvidersCompanyIdApprovePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProvidersCompanyIdApprovePostRequest build() => _build();

  _$ProvidersCompanyIdApprovePostRequest _build() {
    _$ProvidersCompanyIdApprovePostRequest _$result;
    try {
      _$result = _$v ??
          _$ProvidersCompanyIdApprovePostRequest._(
            approvedBranchIds: _approvedBranchIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvedBranchIds';
        _approvedBranchIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProvidersCompanyIdApprovePostRequest',
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
