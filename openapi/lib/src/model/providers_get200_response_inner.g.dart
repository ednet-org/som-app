// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProvidersGet200ResponseInner extends ProvidersGet200ResponseInner {
  @override
  final String? companyId;
  @override
  final String? companyName;
  @override
  final String? companySize;
  @override
  final String? providerType;
  @override
  final String? postcode;
  @override
  final BuiltList<String>? branchIds;
  @override
  final String? status;
  @override
  final bool? claimed;
  @override
  final int? receivedInquiries;
  @override
  final int? sentOffers;
  @override
  final int? acceptedOffers;

  factory _$ProvidersGet200ResponseInner(
          [void Function(ProvidersGet200ResponseInnerBuilder)? updates]) =>
      (ProvidersGet200ResponseInnerBuilder()..update(updates))._build();

  _$ProvidersGet200ResponseInner._(
      {this.companyId,
      this.companyName,
      this.companySize,
      this.providerType,
      this.postcode,
      this.branchIds,
      this.status,
      this.claimed,
      this.receivedInquiries,
      this.sentOffers,
      this.acceptedOffers})
      : super._();
  @override
  ProvidersGet200ResponseInner rebuild(
          void Function(ProvidersGet200ResponseInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProvidersGet200ResponseInnerBuilder toBuilder() =>
      ProvidersGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProvidersGet200ResponseInner &&
        companyId == other.companyId &&
        companyName == other.companyName &&
        companySize == other.companySize &&
        providerType == other.providerType &&
        postcode == other.postcode &&
        branchIds == other.branchIds &&
        status == other.status &&
        claimed == other.claimed &&
        receivedInquiries == other.receivedInquiries &&
        sentOffers == other.sentOffers &&
        acceptedOffers == other.acceptedOffers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyId.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, companySize.hashCode);
    _$hash = $jc(_$hash, providerType.hashCode);
    _$hash = $jc(_$hash, postcode.hashCode);
    _$hash = $jc(_$hash, branchIds.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, claimed.hashCode);
    _$hash = $jc(_$hash, receivedInquiries.hashCode);
    _$hash = $jc(_$hash, sentOffers.hashCode);
    _$hash = $jc(_$hash, acceptedOffers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProvidersGet200ResponseInner')
          ..add('companyId', companyId)
          ..add('companyName', companyName)
          ..add('companySize', companySize)
          ..add('providerType', providerType)
          ..add('postcode', postcode)
          ..add('branchIds', branchIds)
          ..add('status', status)
          ..add('claimed', claimed)
          ..add('receivedInquiries', receivedInquiries)
          ..add('sentOffers', sentOffers)
          ..add('acceptedOffers', acceptedOffers))
        .toString();
  }
}

class ProvidersGet200ResponseInnerBuilder
    implements
        Builder<ProvidersGet200ResponseInner,
            ProvidersGet200ResponseInnerBuilder> {
  _$ProvidersGet200ResponseInner? _$v;

  String? _companyId;
  String? get companyId => _$this._companyId;
  set companyId(String? companyId) => _$this._companyId = companyId;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _companySize;
  String? get companySize => _$this._companySize;
  set companySize(String? companySize) => _$this._companySize = companySize;

  String? _providerType;
  String? get providerType => _$this._providerType;
  set providerType(String? providerType) => _$this._providerType = providerType;

  String? _postcode;
  String? get postcode => _$this._postcode;
  set postcode(String? postcode) => _$this._postcode = postcode;

  ListBuilder<String>? _branchIds;
  ListBuilder<String> get branchIds =>
      _$this._branchIds ??= ListBuilder<String>();
  set branchIds(ListBuilder<String>? branchIds) =>
      _$this._branchIds = branchIds;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _claimed;
  bool? get claimed => _$this._claimed;
  set claimed(bool? claimed) => _$this._claimed = claimed;

  int? _receivedInquiries;
  int? get receivedInquiries => _$this._receivedInquiries;
  set receivedInquiries(int? receivedInquiries) =>
      _$this._receivedInquiries = receivedInquiries;

  int? _sentOffers;
  int? get sentOffers => _$this._sentOffers;
  set sentOffers(int? sentOffers) => _$this._sentOffers = sentOffers;

  int? _acceptedOffers;
  int? get acceptedOffers => _$this._acceptedOffers;
  set acceptedOffers(int? acceptedOffers) =>
      _$this._acceptedOffers = acceptedOffers;

  ProvidersGet200ResponseInnerBuilder() {
    ProvidersGet200ResponseInner._defaults(this);
  }

  ProvidersGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyId = $v.companyId;
      _companyName = $v.companyName;
      _companySize = $v.companySize;
      _providerType = $v.providerType;
      _postcode = $v.postcode;
      _branchIds = $v.branchIds?.toBuilder();
      _status = $v.status;
      _claimed = $v.claimed;
      _receivedInquiries = $v.receivedInquiries;
      _sentOffers = $v.sentOffers;
      _acceptedOffers = $v.acceptedOffers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProvidersGet200ResponseInner other) {
    _$v = other as _$ProvidersGet200ResponseInner;
  }

  @override
  void update(void Function(ProvidersGet200ResponseInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProvidersGet200ResponseInner build() => _build();

  _$ProvidersGet200ResponseInner _build() {
    _$ProvidersGet200ResponseInner _$result;
    try {
      _$result = _$v ??
          _$ProvidersGet200ResponseInner._(
            companyId: companyId,
            companyName: companyName,
            companySize: companySize,
            providerType: providerType,
            postcode: postcode,
            branchIds: _branchIds?.build(),
            status: status,
            claimed: claimed,
            receivedInquiries: receivedInquiries,
            sentOffers: sentOffers,
            acceptedOffers: acceptedOffers,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'branchIds';
        _branchIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProvidersGet200ResponseInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
