// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_company_id_taxonomy_put_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProvidersCompanyIdTaxonomyPutRequest
    extends ProvidersCompanyIdTaxonomyPutRequest {
  @override
  final BuiltList<String>? branchIds;
  @override
  final BuiltList<String>? categoryIds;

  factory _$ProvidersCompanyIdTaxonomyPutRequest(
          [void Function(ProvidersCompanyIdTaxonomyPutRequestBuilder)?
              updates]) =>
      (ProvidersCompanyIdTaxonomyPutRequestBuilder()..update(updates))._build();

  _$ProvidersCompanyIdTaxonomyPutRequest._({this.branchIds, this.categoryIds})
      : super._();
  @override
  ProvidersCompanyIdTaxonomyPutRequest rebuild(
          void Function(ProvidersCompanyIdTaxonomyPutRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProvidersCompanyIdTaxonomyPutRequestBuilder toBuilder() =>
      ProvidersCompanyIdTaxonomyPutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProvidersCompanyIdTaxonomyPutRequest &&
        branchIds == other.branchIds &&
        categoryIds == other.categoryIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, branchIds.hashCode);
    _$hash = $jc(_$hash, categoryIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProvidersCompanyIdTaxonomyPutRequest')
          ..add('branchIds', branchIds)
          ..add('categoryIds', categoryIds))
        .toString();
  }
}

class ProvidersCompanyIdTaxonomyPutRequestBuilder
    implements
        Builder<ProvidersCompanyIdTaxonomyPutRequest,
            ProvidersCompanyIdTaxonomyPutRequestBuilder> {
  _$ProvidersCompanyIdTaxonomyPutRequest? _$v;

  ListBuilder<String>? _branchIds;
  ListBuilder<String> get branchIds =>
      _$this._branchIds ??= ListBuilder<String>();
  set branchIds(ListBuilder<String>? branchIds) =>
      _$this._branchIds = branchIds;

  ListBuilder<String>? _categoryIds;
  ListBuilder<String> get categoryIds =>
      _$this._categoryIds ??= ListBuilder<String>();
  set categoryIds(ListBuilder<String>? categoryIds) =>
      _$this._categoryIds = categoryIds;

  ProvidersCompanyIdTaxonomyPutRequestBuilder() {
    ProvidersCompanyIdTaxonomyPutRequest._defaults(this);
  }

  ProvidersCompanyIdTaxonomyPutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _branchIds = $v.branchIds?.toBuilder();
      _categoryIds = $v.categoryIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProvidersCompanyIdTaxonomyPutRequest other) {
    _$v = other as _$ProvidersCompanyIdTaxonomyPutRequest;
  }

  @override
  void update(
      void Function(ProvidersCompanyIdTaxonomyPutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProvidersCompanyIdTaxonomyPutRequest build() => _build();

  _$ProvidersCompanyIdTaxonomyPutRequest _build() {
    _$ProvidersCompanyIdTaxonomyPutRequest _$result;
    try {
      _$result = _$v ??
          _$ProvidersCompanyIdTaxonomyPutRequest._(
            branchIds: _branchIds?.build(),
            categoryIds: _categoryIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'branchIds';
        _branchIds?.build();
        _$failedField = 'categoryIds';
        _categoryIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProvidersCompanyIdTaxonomyPutRequest',
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
