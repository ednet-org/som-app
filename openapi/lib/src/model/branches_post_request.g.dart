// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BranchesPostRequest extends BranchesPostRequest {
  @override
  final String name;
  @override
  final String? status;

  factory _$BranchesPostRequest(
          [void Function(BranchesPostRequestBuilder)? updates]) =>
      (BranchesPostRequestBuilder()..update(updates))._build();

  _$BranchesPostRequest._({required this.name, this.status}) : super._();
  @override
  BranchesPostRequest rebuild(
          void Function(BranchesPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BranchesPostRequestBuilder toBuilder() =>
      BranchesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BranchesPostRequest &&
        name == other.name &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BranchesPostRequest')
          ..add('name', name)
          ..add('status', status))
        .toString();
  }
}

class BranchesPostRequestBuilder
    implements Builder<BranchesPostRequest, BranchesPostRequestBuilder> {
  _$BranchesPostRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  BranchesPostRequestBuilder() {
    BranchesPostRequest._defaults(this);
  }

  BranchesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BranchesPostRequest other) {
    _$v = other as _$BranchesPostRequest;
  }

  @override
  void update(void Function(BranchesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BranchesPostRequest build() => _build();

  _$BranchesPostRequest _build() {
    final _$result = _$v ??
        _$BranchesPostRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'BranchesPostRequest', 'name'),
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
