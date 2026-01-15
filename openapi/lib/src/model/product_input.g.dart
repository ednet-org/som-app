// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductInput extends ProductInput {
  @override
  final String name;

  factory _$ProductInput([void Function(ProductInputBuilder)? updates]) =>
      (ProductInputBuilder()..update(updates))._build();

  _$ProductInput._({required this.name}) : super._();
  @override
  ProductInput rebuild(void Function(ProductInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductInputBuilder toBuilder() => ProductInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductInput && name == other.name;
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
    return (newBuiltValueToStringHelper(r'ProductInput')..add('name', name))
        .toString();
  }
}

class ProductInputBuilder
    implements Builder<ProductInput, ProductInputBuilder> {
  _$ProductInput? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ProductInputBuilder() {
    ProductInput._defaults(this);
  }

  ProductInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductInput other) {
    _$v = other as _$ProductInput;
  }

  @override
  void update(void Function(ProductInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductInput build() => _build();

  _$ProductInput _build() {
    final _$result = _$v ??
        _$ProductInput._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProductInput', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
