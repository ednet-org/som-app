// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BankDetailsDto extends BankDetailsDto {
  @override
  final String? iban;
  @override
  final String? bic;
  @override
  final String? accountOwner;

  factory _$BankDetailsDto([void Function(BankDetailsDtoBuilder)? updates]) =>
      (new BankDetailsDtoBuilder()..update(updates))._build();

  _$BankDetailsDto._({this.iban, this.bic, this.accountOwner}) : super._();

  @override
  BankDetailsDto rebuild(void Function(BankDetailsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BankDetailsDtoBuilder toBuilder() =>
      new BankDetailsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BankDetailsDto &&
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
    return (newBuiltValueToStringHelper(r'BankDetailsDto')
          ..add('iban', iban)
          ..add('bic', bic)
          ..add('accountOwner', accountOwner))
        .toString();
  }
}

class BankDetailsDtoBuilder
    implements Builder<BankDetailsDto, BankDetailsDtoBuilder> {
  _$BankDetailsDto? _$v;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  String? _bic;
  String? get bic => _$this._bic;
  set bic(String? bic) => _$this._bic = bic;

  String? _accountOwner;
  String? get accountOwner => _$this._accountOwner;
  set accountOwner(String? accountOwner) => _$this._accountOwner = accountOwner;

  BankDetailsDtoBuilder() {
    BankDetailsDto._defaults(this);
  }

  BankDetailsDtoBuilder get _$this {
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
  void replace(BankDetailsDto other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BankDetailsDto;
  }

  @override
  void update(void Function(BankDetailsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BankDetailsDto build() => _build();

  _$BankDetailsDto _build() {
    final _$result = _$v ??
        new _$BankDetailsDto._(
          iban: iban,
          bic: bic,
          accountOwner: accountOwner,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
