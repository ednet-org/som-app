// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_ad_id_image_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdsAdIdImagePost200Response extends AdsAdIdImagePost200Response {
  @override
  final String? imagePath;

  factory _$AdsAdIdImagePost200Response(
          [void Function(AdsAdIdImagePost200ResponseBuilder)? updates]) =>
      (AdsAdIdImagePost200ResponseBuilder()..update(updates))._build();

  _$AdsAdIdImagePost200Response._({this.imagePath}) : super._();
  @override
  AdsAdIdImagePost200Response rebuild(
          void Function(AdsAdIdImagePost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdsAdIdImagePost200ResponseBuilder toBuilder() =>
      AdsAdIdImagePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdsAdIdImagePost200Response && imagePath == other.imagePath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, imagePath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdsAdIdImagePost200Response')
          ..add('imagePath', imagePath))
        .toString();
  }
}

class AdsAdIdImagePost200ResponseBuilder
    implements
        Builder<AdsAdIdImagePost200Response,
            AdsAdIdImagePost200ResponseBuilder> {
  _$AdsAdIdImagePost200Response? _$v;

  String? _imagePath;
  String? get imagePath => _$this._imagePath;
  set imagePath(String? imagePath) => _$this._imagePath = imagePath;

  AdsAdIdImagePost200ResponseBuilder() {
    AdsAdIdImagePost200Response._defaults(this);
  }

  AdsAdIdImagePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _imagePath = $v.imagePath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdsAdIdImagePost200Response other) {
    _$v = other as _$AdsAdIdImagePost200Response;
  }

  @override
  void update(void Function(AdsAdIdImagePost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdsAdIdImagePost200Response build() => _build();

  _$AdsAdIdImagePost200Response _build() {
    final _$result = _$v ??
        _$AdsAdIdImagePost200Response._(
          imagePath: imagePath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
