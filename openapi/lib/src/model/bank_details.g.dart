// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BankDetails extends BankDetails {
  @override
  final String iban;
  @override
  final String bic;
  @override
  final String accountOwner;

  factory _$BankDetails([void Function(BankDetailsBuilder)? updates]) =>
      (new BankDetailsBuilder()..update(updates))._build();

  _$BankDetails._(
      {required this.iban, required this.bic, required this.accountOwner})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(iban, r'BankDetails', 'iban');
    BuiltValueNullFieldError.checkNotNull(bic, r'BankDetails', 'bic');
    BuiltValueNullFieldError.checkNotNull(
        accountOwner, r'BankDetails', 'accountOwner');
  }

  @override
  BankDetails rebuild(void Function(BankDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BankDetailsBuilder toBuilder() => new BankDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BankDetails &&
        iban == other.iban &&
        bic == other.bic &&
        accountOwner == other.accountOwner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jc(_$hash, bic.hashCode);
    _$hash = $jc(_$hash, accountOwner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BankDetails')
          ..add('iban', iban)
          ..add('bic', bic)
          ..add('accountOwner', accountOwner))
        .toString();
  }
}

class BankDetailsBuilder implements Builder<BankDetails, BankDetailsBuilder> {
  _$BankDetails? _$v;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  String? _bic;
  String? get bic => _$this._bic;
  set bic(String? bic) => _$this._bic = bic;

  String? _accountOwner;
  String? get accountOwner => _$this._accountOwner;
  set accountOwner(String? accountOwner) => _$this._accountOwner = accountOwner;

  BankDetailsBuilder() {
    BankDetails._defaults(this);
  }

  BankDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _iban = $v.iban;
      _bic = $v.bic;
      _accountOwner = $v.accountOwner;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BankDetails other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BankDetails;
  }

  @override
  void update(void Function(BankDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BankDetails build() => _build();

  _$BankDetails _build() {
    final _$result = _$v ??
        new _$BankDetails._(
          iban: BuiltValueNullFieldError.checkNotNull(
              iban, r'BankDetails', 'iban'),
          bic:
              BuiltValueNullFieldError.checkNotNull(bic, r'BankDetails', 'bic'),
          accountOwner: BuiltValueNullFieldError.checkNotNull(
              accountOwner, r'BankDetails', 'accountOwner'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
