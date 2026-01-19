// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_category_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyCategoryAssignment extends CompanyCategoryAssignment {
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final String? branchId;
  @override
  final String? branchName;
  @override
  final String? source_;
  @override
  final num? confidence;
  @override
  final String? status;

  factory _$CompanyCategoryAssignment(
          [void Function(CompanyCategoryAssignmentBuilder)? updates]) =>
      (CompanyCategoryAssignmentBuilder()..update(updates))._build();

  _$CompanyCategoryAssignment._(
      {this.categoryId,
      this.categoryName,
      this.branchId,
      this.branchName,
      this.source_,
      this.confidence,
      this.status})
      : super._();
  @override
  CompanyCategoryAssignment rebuild(
          void Function(CompanyCategoryAssignmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyCategoryAssignmentBuilder toBuilder() =>
      CompanyCategoryAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyCategoryAssignment &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        branchId == other.branchId &&
        branchName == other.branchName &&
        source_ == other.source_ &&
        confidence == other.confidence &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, branchId.hashCode);
    _$hash = $jc(_$hash, branchName.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, confidence.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyCategoryAssignment')
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('branchId', branchId)
          ..add('branchName', branchName)
          ..add('source_', source_)
          ..add('confidence', confidence)
          ..add('status', status))
        .toString();
  }
}

class CompanyCategoryAssignmentBuilder
    implements
        Builder<CompanyCategoryAssignment, CompanyCategoryAssignmentBuilder> {
  _$CompanyCategoryAssignment? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  String? _branchId;
  String? get branchId => _$this._branchId;
  set branchId(String? branchId) => _$this._branchId = branchId;

  String? _branchName;
  String? get branchName => _$this._branchName;
  set branchName(String? branchName) => _$this._branchName = branchName;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  num? _confidence;
  num? get confidence => _$this._confidence;
  set confidence(num? confidence) => _$this._confidence = confidence;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  CompanyCategoryAssignmentBuilder() {
    CompanyCategoryAssignment._defaults(this);
  }

  CompanyCategoryAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _categoryName = $v.categoryName;
      _branchId = $v.branchId;
      _branchName = $v.branchName;
      _source_ = $v.source_;
      _confidence = $v.confidence;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyCategoryAssignment other) {
    _$v = other as _$CompanyCategoryAssignment;
  }

  @override
  void update(void Function(CompanyCategoryAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyCategoryAssignment build() => _build();

  _$CompanyCategoryAssignment _build() {
    final _$result = _$v ??
        _$CompanyCategoryAssignment._(
          categoryId: categoryId,
          categoryName: categoryName,
          branchId: branchId,
          branchName: branchName,
          source_: source_,
          confidence: confidence,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
