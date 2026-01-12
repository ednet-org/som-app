// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Ad extends Ad {
  @override
  final String? id;
  @override
  final String? companyId;
  @override
  final String? type;
  @override
  final String? status;
  @override
  final String? branchId;
  @override
  final String? url;
  @override
  final String? imagePath;
  @override
  final String? headline;
  @override
  final String? description;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? bannerDate;

  factory _$Ad([void Function(AdBuilder)? updates]) =>
      (AdBuilder()..update(updates))._build();

  _$Ad._(
      {this.id,
      this.companyId,
      this.type,
      this.status,
      this.branchId,
      this.url,
      this.imagePath,
      this.headline,
      this.description,
      this.startDate,
      this.endDate,
      this.bannerDate})
      : super._();
  @override
  Ad rebuild(void Function(AdBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdBuilder toBuilder() => AdBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ad &&
        id == other.id &&
        companyId == other.companyId &&
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
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, companyId.hashCode);
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
    return (newBuiltValueToStringHelper(r'Ad')
          ..add('id', id)
          ..add('companyId', companyId)
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

class AdBuilder implements Builder<Ad, AdBuilder> {
  _$Ad? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

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

  DateTime? _startDate;
  DateTime? get startDate => _$this._startDate;
  set startDate(DateTime? startDate) => _$this._startDate = startDate;

  DateTime? _endDate;
  DateTime? get endDate => _$this._endDate;
  set endDate(DateTime? endDate) => _$this._endDate = endDate;

  DateTime? _bannerDate;
  DateTime? get bannerDate => _$this._bannerDate;
  set bannerDate(DateTime? bannerDate) => _$this._bannerDate = bannerDate;

  AdBuilder() {
    Ad._defaults(this);
  }

  AdBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _companyId = $v.companyId;
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
  void replace(Ad other) {
    _$v = other as _$Ad;
  }

  @override
  void update(void Function(AdBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Ad build() => _build();

  _$Ad _build() {
    final _$result = _$v ??
        _$Ad._(
          id: id,
          companyId: companyId,
          type: type,
          status: status,
          branchId: branchId,
          url: url,
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
