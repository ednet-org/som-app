// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsProviderGet200Response extends StatsProviderGet200Response {
  @override
  final int? open;
  @override
  final int? offerCreated;
  @override
  final int? lost;
  @override
  final int? won;
  @override
  final int? ignored;

  factory _$StatsProviderGet200Response(
          [void Function(StatsProviderGet200ResponseBuilder)? updates]) =>
      (StatsProviderGet200ResponseBuilder()..update(updates))._build();

  _$StatsProviderGet200Response._(
      {this.open, this.offerCreated, this.lost, this.won, this.ignored})
      : super._();
  @override
  StatsProviderGet200Response rebuild(
          void Function(StatsProviderGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsProviderGet200ResponseBuilder toBuilder() =>
      StatsProviderGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsProviderGet200Response &&
        open == other.open &&
        offerCreated == other.offerCreated &&
        lost == other.lost &&
        won == other.won &&
        ignored == other.ignored;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, offerCreated.hashCode);
    _$hash = $jc(_$hash, lost.hashCode);
    _$hash = $jc(_$hash, won.hashCode);
    _$hash = $jc(_$hash, ignored.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsProviderGet200Response')
          ..add('open', open)
          ..add('offerCreated', offerCreated)
          ..add('lost', lost)
          ..add('won', won)
          ..add('ignored', ignored))
        .toString();
  }
}

class StatsProviderGet200ResponseBuilder
    implements
        Builder<StatsProviderGet200Response,
            StatsProviderGet200ResponseBuilder> {
  _$StatsProviderGet200Response? _$v;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  int? _offerCreated;
  int? get offerCreated => _$this._offerCreated;
  set offerCreated(int? offerCreated) => _$this._offerCreated = offerCreated;

  int? _lost;
  int? get lost => _$this._lost;
  set lost(int? lost) => _$this._lost = lost;

  int? _won;
  int? get won => _$this._won;
  set won(int? won) => _$this._won = won;

  int? _ignored;
  int? get ignored => _$this._ignored;
  set ignored(int? ignored) => _$this._ignored = ignored;

  StatsProviderGet200ResponseBuilder() {
    StatsProviderGet200Response._defaults(this);
  }

  StatsProviderGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _offerCreated = $v.offerCreated;
      _lost = $v.lost;
      _won = $v.won;
      _ignored = $v.ignored;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsProviderGet200Response other) {
    _$v = other as _$StatsProviderGet200Response;
  }

  @override
  void update(void Function(StatsProviderGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsProviderGet200Response build() => _build();

  _$StatsProviderGet200Response _build() {
    final _$result = _$v ??
        _$StatsProviderGet200Response._(
          open: open,
          offerCreated: offerCreated,
          lost: lost,
          won: won,
          ignored: ignored,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
