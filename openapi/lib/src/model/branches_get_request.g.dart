// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_get_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BranchesGetRequest extends BranchesGetRequest {
  @override
  final String name;

  factory _$BranchesGetRequest(
          [void Function(BranchesGetRequestBuilder)? updates]) =>
      (BranchesGetRequestBuilder()..update(updates))._build();

  _$BranchesGetRequest._({required this.name}) : super._();
  @override
  BranchesGetRequest rebuild(
          void Function(BranchesGetRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BranchesGetRequestBuilder toBuilder() =>
      BranchesGetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BranchesGetRequest && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BranchesGetRequest')
          ..add('name', name))
        .toString();
  }
}

class BranchesGetRequestBuilder
    implements Builder<BranchesGetRequest, BranchesGetRequestBuilder> {
  _$BranchesGetRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  BranchesGetRequestBuilder() {
    BranchesGetRequest._defaults(this);
  }

  BranchesGetRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BranchesGetRequest other) {
    _$v = other as _$BranchesGetRequest;
  }

  @override
  void update(void Function(BranchesGetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BranchesGetRequest build() => _build();

  _$BranchesGetRequest _build() {
    final _$result = _$v ??
        _$BranchesGetRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'BranchesGetRequest', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
