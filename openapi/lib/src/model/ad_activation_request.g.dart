// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_activation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdActivationRequest extends AdActivationRequest {
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? bannerDate;

  factory _$AdActivationRequest(
          [void Function(AdActivationRequestBuilder)? updates]) =>
      (AdActivationRequestBuilder()..update(updates))._build();

  _$AdActivationRequest._({this.startDate, this.endDate, this.bannerDate})
      : super._();
  @override
  AdActivationRequest rebuild(
          void Function(AdActivationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdActivationRequestBuilder toBuilder() =>
      AdActivationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdActivationRequest &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        bannerDate == other.bannerDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, bannerDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdActivationRequest')
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('bannerDate', bannerDate))
        .toString();
  }
}

class AdActivationRequestBuilder
    implements Builder<AdActivationRequest, AdActivationRequestBuilder> {
  _$AdActivationRequest? _$v;

  DateTime? _startDate;
  DateTime? get startDate => _$this._startDate;
  set startDate(DateTime? startDate) => _$this._startDate = startDate;

  DateTime? _endDate;
  DateTime? get endDate => _$this._endDate;
  set endDate(DateTime? endDate) => _$this._endDate = endDate;

  DateTime? _bannerDate;
  DateTime? get bannerDate => _$this._bannerDate;
  set bannerDate(DateTime? bannerDate) => _$this._bannerDate = bannerDate;

  AdActivationRequestBuilder() {
    AdActivationRequest._defaults(this);
  }

  AdActivationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _bannerDate = $v.bannerDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdActivationRequest other) {
    _$v = other as _$AdActivationRequest;
  }

  @override
  void update(void Function(AdActivationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdActivationRequest build() => _build();

  _$AdActivationRequest _build() {
    final _$result = _$v ??
        _$AdActivationRequest._(
          startDate: startDate,
          endDate: endDate,
          bannerDate: bannerDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
