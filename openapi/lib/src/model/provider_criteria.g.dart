// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_criteria.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderCriteria extends ProviderCriteria {
  @override
  final String? providerZip;
  @override
  final int? radiusKm;
  @override
  final String? providerType;
  @override
  final String? companySize;

  factory _$ProviderCriteria(
          [void Function(ProviderCriteriaBuilder)? updates]) =>
      (ProviderCriteriaBuilder()..update(updates))._build();

  _$ProviderCriteria._(
      {this.providerZip, this.radiusKm, this.providerType, this.companySize})
      : super._();
  @override
  ProviderCriteria rebuild(void Function(ProviderCriteriaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderCriteriaBuilder toBuilder() =>
      ProviderCriteriaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderCriteria &&
        providerZip == other.providerZip &&
        radiusKm == other.radiusKm &&
        providerType == other.providerType &&
        companySize == other.companySize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, providerZip.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, providerType.hashCode);
    _$hash = $jc(_$hash, companySize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderCriteria')
          ..add('providerZip', providerZip)
          ..add('radiusKm', radiusKm)
          ..add('providerType', providerType)
          ..add('companySize', companySize))
        .toString();
  }
}

class ProviderCriteriaBuilder
    implements Builder<ProviderCriteria, ProviderCriteriaBuilder> {
  _$ProviderCriteria? _$v;

  String? _providerZip;
  String? get providerZip => _$this._providerZip;
  set providerZip(String? providerZip) => _$this._providerZip = providerZip;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  String? _providerType;
  String? get providerType => _$this._providerType;
  set providerType(String? providerType) => _$this._providerType = providerType;

  String? _companySize;
  String? get companySize => _$this._companySize;
  set companySize(String? companySize) => _$this._companySize = companySize;

  ProviderCriteriaBuilder() {
    ProviderCriteria._defaults(this);
  }

  ProviderCriteriaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _providerZip = $v.providerZip;
      _radiusKm = $v.radiusKm;
      _providerType = $v.providerType;
      _companySize = $v.companySize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderCriteria other) {
    _$v = other as _$ProviderCriteria;
  }

  @override
  void update(void Function(ProviderCriteriaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderCriteria build() => _build();

  _$ProviderCriteria _build() {
    final _$result = _$v ??
        _$ProviderCriteria._(
          providerZip: providerZip,
          radiusKm: radiusKm,
          providerType: providerType,
          companySize: companySize,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
