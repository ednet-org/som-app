// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ad200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateAd200Response extends CreateAd200Response {
  @override
  final String? id;

  factory _$CreateAd200Response(
          [void Function(CreateAd200ResponseBuilder)? updates]) =>
      (new CreateAd200ResponseBuilder()..update(updates))._build();

  _$CreateAd200Response._({this.id}) : super._();

  @override
  CreateAd200Response rebuild(
          void Function(CreateAd200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAd200ResponseBuilder toBuilder() =>
      new CreateAd200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAd200Response && id == other.id;
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
    return (newBuiltValueToStringHelper(r'CreateAd200Response')..add('id', id))
        .toString();
  }
}

class CreateAd200ResponseBuilder
    implements Builder<CreateAd200Response, CreateAd200ResponseBuilder> {
  _$CreateAd200Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateAd200ResponseBuilder() {
    CreateAd200Response._defaults(this);
  }

  CreateAd200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAd200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAd200Response;
  }

  @override
  void update(void Function(CreateAd200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAd200Response build() => _build();

  _$CreateAd200Response _build() {
    final _$result = _$v ??
        new _$CreateAd200Response._(
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
