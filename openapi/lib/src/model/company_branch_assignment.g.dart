// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_branch_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyBranchAssignment extends CompanyBranchAssignment {
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

  factory _$CompanyBranchAssignment(
          [void Function(CompanyBranchAssignmentBuilder)? updates]) =>
      (CompanyBranchAssignmentBuilder()..update(updates))._build();

  _$CompanyBranchAssignment._(
      {this.branchId,
      this.branchName,
      this.source_,
      this.confidence,
      this.status})
      : super._();
  @override
  CompanyBranchAssignment rebuild(
          void Function(CompanyBranchAssignmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyBranchAssignmentBuilder toBuilder() =>
      CompanyBranchAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyBranchAssignment &&
        branchId == other.branchId &&
        branchName == other.branchName &&
        source_ == other.source_ &&
        confidence == other.confidence &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(r'CompanyBranchAssignment')
          ..add('branchId', branchId)
          ..add('branchName', branchName)
          ..add('source_', source_)
          ..add('confidence', confidence)
          ..add('status', status))
        .toString();
  }
}

class CompanyBranchAssignmentBuilder
    implements
        Builder<CompanyBranchAssignment, CompanyBranchAssignmentBuilder> {
  _$CompanyBranchAssignment? _$v;

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

  CompanyBranchAssignmentBuilder() {
    CompanyBranchAssignment._defaults(this);
  }

  CompanyBranchAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(CompanyBranchAssignment other) {
    _$v = other as _$CompanyBranchAssignment;
  }

  @override
  void update(void Function(CompanyBranchAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyBranchAssignment build() => _build();

  _$CompanyBranchAssignment _build() {
    final _$result = _$v ??
        _$CompanyBranchAssignment._(
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
