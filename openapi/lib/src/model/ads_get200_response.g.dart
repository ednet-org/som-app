// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdsGet200Response extends AdsGet200Response {
  @override
  final String? id;

  factory _$AdsGet200Response(
          [void Function(AdsGet200ResponseBuilder)? updates]) =>
      (new AdsGet200ResponseBuilder()..update(updates))._build();

  _$AdsGet200Response._({this.id}) : super._();

  @override
  AdsGet200Response rebuild(void Function(AdsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdsGet200ResponseBuilder toBuilder() =>
      new AdsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdsGet200Response && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdsGet200Response')..add('id', id))
        .toString();
  }
}

class AdsGet200ResponseBuilder
    implements Builder<AdsGet200Response, AdsGet200ResponseBuilder> {
  _$AdsGet200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdsGet200ResponseBuilder() {
    AdsGet200Response._defaults(this);
  }

  AdsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdsGet200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AdsGet200Response;
  }

  @override
  void update(void Function(AdsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdsGet200Response build() => _build();

  _$AdsGet200Response _build() {
    final _$result = _$v ??
        new _$AdsGet200Response._(
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
