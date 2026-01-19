// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_taxonomy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyTaxonomy extends CompanyTaxonomy {
  @override
  final String? companyId;
  @override
  final BuiltList<CompanyBranchAssignment>? branches;
  @override
  final BuiltList<CompanyCategoryAssignment>? categories;

  factory _$CompanyTaxonomy([void Function(CompanyTaxonomyBuilder)? updates]) =>
      (CompanyTaxonomyBuilder()..update(updates))._build();

  _$CompanyTaxonomy._({this.companyId, this.branches, this.categories})
      : super._();
  @override
  CompanyTaxonomy rebuild(void Function(CompanyTaxonomyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyTaxonomyBuilder toBuilder() => CompanyTaxonomyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyTaxonomy &&
        companyId == other.companyId &&
        branches == other.branches &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, branches.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyTaxonomy')
          ..add('companyId', companyId)
          ..add('branches', branches)
          ..add('categories', categories))
        .toString();
  }
}

class CompanyTaxonomyBuilder
    implements Builder<CompanyTaxonomy, CompanyTaxonomyBuilder> {
  _$CompanyTaxonomy? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  ListBuilder<CompanyBranchAssignment>? _branches;
  ListBuilder<CompanyBranchAssignment> get branches =>
      _$this._branches ??= ListBuilder<CompanyBranchAssignment>();
  set branches(ListBuilder<CompanyBranchAssignment>? branches) =>
      _$this._branches = branches;

  ListBuilder<CompanyCategoryAssignment>? _categories;
  ListBuilder<CompanyCategoryAssignment> get categories =>
      _$this._categories ??= ListBuilder<CompanyCategoryAssignment>();
  set categories(ListBuilder<CompanyCategoryAssignment>? categories) =>
      _$this._categories = categories;

  CompanyTaxonomyBuilder() {
    CompanyTaxonomy._defaults(this);
  }

  CompanyTaxonomyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _branches = $v.branches?.toBuilder();
      _categories = $v.categories?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyTaxonomy other) {
    _$v = other as _$CompanyTaxonomy;
  }

  @override
  void update(void Function(CompanyTaxonomyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyTaxonomy build() => _build();

  _$CompanyTaxonomy _build() {
    _$CompanyTaxonomy _$result;
    try {
      _$result = _$v ??
          _$CompanyTaxonomy._(
            companyId: companyId,
            branches: _branches?.build(),
            categories: _categories?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'branches';
        _branches?.build();
        _$failedField = 'categories';
        _categories?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CompanyTaxonomy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
