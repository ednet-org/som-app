// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ad_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateAdRequest extends CreateAdRequest {
  @override
  final String type;
  @override
  final String status;
  @override
  final String branchId;
  @override
  final String url;
  @override
  final String? imagePath;
  @override
  final String? headline;
  @override
  final String? description;
  @override
  final String? startDate;
  @override
  final String? endDate;
  @override
  final String? bannerDate;

  factory _$CreateAdRequest([void Function(CreateAdRequestBuilder)? updates]) =>
      (new CreateAdRequestBuilder()..update(updates))._build();

  _$CreateAdRequest._(
      {required this.type,
      required this.status,
      required this.branchId,
      required this.url,
      this.imagePath,
      this.headline,
      this.description,
      this.startDate,
      this.endDate,
      this.bannerDate})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'CreateAdRequest', 'type');
    BuiltValueNullFieldError.checkNotNull(status, r'CreateAdRequest', 'status');
    BuiltValueNullFieldError.checkNotNull(
        branchId, r'CreateAdRequest', 'branchId');
    BuiltValueNullFieldError.checkNotNull(url, r'CreateAdRequest', 'url');
  }

  @override
  CreateAdRequest rebuild(void Function(CreateAdRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAdRequestBuilder toBuilder() =>
      new CreateAdRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAdRequest &&
        type == other.type &&
        status == other.status &&
        branchId == other.branchId &&
        url == other.url &&
        imagePath == other.imagePath &&
        headline == other.headline &&
        description == other.description &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        bannerDate == other.bannerDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, branchId.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, imagePath.hashCode);
    _$hash = $jc(_$hash, headline.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, bannerDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAdRequest')
          ..add('type', type)
          ..add('status', status)
          ..add('branchId', branchId)
          ..add('url', url)
          ..add('imagePath', imagePath)
          ..add('headline', headline)
          ..add('description', description)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('bannerDate', bannerDate))
        .toString();
  }
}

class CreateAdRequestBuilder
    implements Builder<CreateAdRequest, CreateAdRequestBuilder> {
  _$CreateAdRequest? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _branchId;
  String? get branchId => _$this._branchId;
  set branchId(String? branchId) => _$this._branchId = branchId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _imagePath;
  String? get imagePath => _$this._imagePath;
  set imagePath(String? imagePath) => _$this._imagePath = imagePath;

  String? _headline;
  String? get headline => _$this._headline;
  set headline(String? headline) => _$this._headline = headline;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _startDate;
  String? get startDate => _$this._startDate;
  set startDate(String? startDate) => _$this._startDate = startDate;

  String? _endDate;
  String? get endDate => _$this._endDate;
  set endDate(String? endDate) => _$this._endDate = endDate;

  String? _bannerDate;
  String? get bannerDate => _$this._bannerDate;
  set bannerDate(String? bannerDate) => _$this._bannerDate = bannerDate;

  CreateAdRequestBuilder() {
    CreateAdRequest._defaults(this);
  }

  CreateAdRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _status = $v.status;
      _branchId = $v.branchId;
      _url = $v.url;
      _imagePath = $v.imagePath;
      _headline = $v.headline;
      _description = $v.description;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _bannerDate = $v.bannerDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAdRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAdRequest;
  }

  @override
  void update(void Function(CreateAdRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAdRequest build() => _build();

  _$CreateAdRequest _build() {
    final _$result = _$v ??
        new _$CreateAdRequest._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CreateAdRequest', 'type'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CreateAdRequest', 'status'),
          branchId: BuiltValueNullFieldError.checkNotNull(
              branchId, r'CreateAdRequest', 'branchId'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'CreateAdRequest', 'url'),
          imagePath: imagePath,
          headline: headline,
          description: description,
          startDate: startDate,
          endDate: endDate,
          bannerDate: bannerDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
