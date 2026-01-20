// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Offer extends Offer {
  @override
  final String? id;
  @override
  final String? inquiryId;
  @override
  final String? providerCompanyId;
  @override
  final String? status;
  @override
  final String? pdfPath;
  @override
  final String? summaryPdfPath;
  @override
  final DateTime? forwardedAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? buyerDecision;
  @override
  final String? providerDecision;

  factory _$Offer([void Function(OfferBuilder)? updates]) =>
      (OfferBuilder()..update(updates))._build();

  _$Offer._(
      {this.id,
      this.inquiryId,
      this.providerCompanyId,
      this.status,
      this.pdfPath,
      this.summaryPdfPath,
      this.forwardedAt,
      this.resolvedAt,
      this.buyerDecision,
      this.providerDecision})
      : super._();
  @override
  Offer rebuild(void Function(OfferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OfferBuilder toBuilder() => OfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Offer &&
        id == other.id &&
        inquiryId == other.inquiryId &&
        providerCompanyId == other.providerCompanyId &&
        status == other.status &&
        pdfPath == other.pdfPath &&
        summaryPdfPath == other.summaryPdfPath &&
        forwardedAt == other.forwardedAt &&
        resolvedAt == other.resolvedAt &&
        buyerDecision == other.buyerDecision &&
        providerDecision == other.providerDecision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inquiryId.hashCode);
    _$hash = $jc(_$hash, providerCompanyId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, pdfPath.hashCode);
    _$hash = $jc(_$hash, summaryPdfPath.hashCode);
    _$hash = $jc(_$hash, forwardedAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, buyerDecision.hashCode);
    _$hash = $jc(_$hash, providerDecision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Offer')
          ..add('id', id)
          ..add('inquiryId', inquiryId)
          ..add('providerCompanyId', providerCompanyId)
          ..add('status', status)
          ..add('pdfPath', pdfPath)
          ..add('summaryPdfPath', summaryPdfPath)
          ..add('forwardedAt', forwardedAt)
          ..add('resolvedAt', resolvedAt)
          ..add('buyerDecision', buyerDecision)
          ..add('providerDecision', providerDecision))
        .toString();
  }
}

class OfferBuilder implements Builder<Offer, OfferBuilder> {
  _$Offer? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _inquiryId;
  String? get inquiryId => _$this._inquiryId;
  set inquiryId(String? inquiryId) => _$this._inquiryId = inquiryId;

  String? _providerCompanyId;
  String? get providerCompanyId => _$this._providerCompanyId;
  set providerCompanyId(String? providerCompanyId) =>
      _$this._providerCompanyId = providerCompanyId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _pdfPath;
  String? get pdfPath => _$this._pdfPath;
  set pdfPath(String? pdfPath) => _$this._pdfPath = pdfPath;

  String? _summaryPdfPath;
  String? get summaryPdfPath => _$this._summaryPdfPath;
  set summaryPdfPath(String? summaryPdfPath) =>
      _$this._summaryPdfPath = summaryPdfPath;

  DateTime? _forwardedAt;
  DateTime? get forwardedAt => _$this._forwardedAt;
  set forwardedAt(DateTime? forwardedAt) => _$this._forwardedAt = forwardedAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  String? _buyerDecision;
  String? get buyerDecision => _$this._buyerDecision;
  set buyerDecision(String? buyerDecision) =>
      _$this._buyerDecision = buyerDecision;

  String? _providerDecision;
  String? get providerDecision => _$this._providerDecision;
  set providerDecision(String? providerDecision) =>
      _$this._providerDecision = providerDecision;

  OfferBuilder() {
    Offer._defaults(this);
  }

  OfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _inquiryId = $v.inquiryId;
      _providerCompanyId = $v.providerCompanyId;
      _status = $v.status;
      _pdfPath = $v.pdfPath;
      _summaryPdfPath = $v.summaryPdfPath;
      _forwardedAt = $v.forwardedAt;
      _resolvedAt = $v.resolvedAt;
      _buyerDecision = $v.buyerDecision;
      _providerDecision = $v.providerDecision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Offer other) {
    _$v = other as _$Offer;
  }

  @override
  void update(void Function(OfferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Offer build() => _build();

  _$Offer _build() {
    final _$result = _$v ??
        _$Offer._(
          id: id,
          inquiryId: inquiryId,
          providerCompanyId: providerCompanyId,
          status: status,
          pdfPath: pdfPath,
          summaryPdfPath: summaryPdfPath,
          forwardedAt: forwardedAt,
          resolvedAt: resolvedAt,
          buyerDecision: buyerDecision,
          providerDecision: providerDecision,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
