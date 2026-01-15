// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleInput extends RoleInput {
  @override
  final String name;
  @override
  final String? description;

  factory _$RoleInput([void Function(RoleInputBuilder)? updates]) =>
      (RoleInputBuilder()..update(updates))._build();

  _$RoleInput._({required this.name, this.description}) : super._();
  @override
  RoleInput rebuild(void Function(RoleInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleInputBuilder toBuilder() => RoleInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleInput &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoleInput')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class RoleInputBuilder implements Builder<RoleInput, RoleInputBuilder> {
  _$RoleInput? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  RoleInputBuilder() {
    RoleInput._defaults(this);
  }

  RoleInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleInput other) {
    _$v = other as _$RoleInput;
  }

  @override
  void update(void Function(RoleInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleInput build() => _build();

  _$RoleInput _build() {
    final _$result = _$v ??
        _$RoleInput._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'RoleInput', 'name'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
