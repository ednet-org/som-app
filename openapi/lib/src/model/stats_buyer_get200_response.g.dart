// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_buyer_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsBuyerGet200Response extends StatsBuyerGet200Response {
  @override
  final int? open;
  @override
  final int? closed;

  factory _$StatsBuyerGet200Response(
          [void Function(StatsBuyerGet200ResponseBuilder)? updates]) =>
      (new StatsBuyerGet200ResponseBuilder()..update(updates))._build();

  _$StatsBuyerGet200Response._({this.open, this.closed}) : super._();

  @override
  StatsBuyerGet200Response rebuild(
          void Function(StatsBuyerGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsBuyerGet200ResponseBuilder toBuilder() =>
      new StatsBuyerGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsBuyerGet200Response &&
        open == other.open &&
        closed == other.closed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, closed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsBuyerGet200Response')
          ..add('open', open)
          ..add('closed', closed))
        .toString();
  }
}

class StatsBuyerGet200ResponseBuilder
    implements
        Builder<StatsBuyerGet200Response, StatsBuyerGet200ResponseBuilder> {
  _$StatsBuyerGet200Response? _$v;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  int? _closed;
  int? get closed => _$this._closed;
  set closed(int? closed) => _$this._closed = closed;

  StatsBuyerGet200ResponseBuilder() {
    StatsBuyerGet200Response._defaults(this);
  }

  StatsBuyerGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _closed = $v.closed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsBuyerGet200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StatsBuyerGet200Response;
  }

  @override
  void update(void Function(StatsBuyerGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsBuyerGet200Response build() => _build();

  _$StatsBuyerGet200Response _build() {
    final _$result = _$v ??
        new _$StatsBuyerGet200Response._(
          open: open,
          closed: closed,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
