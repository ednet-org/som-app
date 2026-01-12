// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Branch extends Branch {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final BuiltList<Category>? categories;

  factory _$Branch([void Function(BranchBuilder)? updates]) =>
      (new BranchBuilder()..update(updates))._build();

  _$Branch._({this.id, this.name, this.categories}) : super._();

  @override
  Branch rebuild(void Function(BranchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BranchBuilder toBuilder() => new BranchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Branch &&
        id == other.id &&
        name == other.name &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Branch')
          ..add('id', id)
          ..add('name', name)
          ..add('categories', categories))
        .toString();
  }
}

class BranchBuilder implements Builder<Branch, BranchBuilder> {
  _$Branch? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<Category>? _categories;
  ListBuilder<Category> get categories =>
      _$this._categories ??= new ListBuilder<Category>();
  set categories(ListBuilder<Category>? categories) =>
      _$this._categories = categories;

  BranchBuilder() {
    Branch._defaults(this);
  }

  BranchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _categories = $v.categories?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Branch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Branch;
  }

  @override
  void update(void Function(BranchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Branch build() => _build();

  _$Branch _build() {
    _$Branch _$result;
    try {
      _$result = _$v ??
          new _$Branch._(
            id: id,
            name: name,
            categories: _categories?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        _categories?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Branch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
