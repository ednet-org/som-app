// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactInfo extends ContactInfo {
  @override
  final String companyName;
  @override
  final String salutation;
  @override
  final String title;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String telephone;
  @override
  final String email;

  factory _$ContactInfo([void Function(ContactInfoBuilder)? updates]) =>
      (new ContactInfoBuilder()..update(updates))._build();

  _$ContactInfo._(
      {required this.companyName,
      required this.salutation,
      required this.title,
      required this.firstName,
      required this.lastName,
      required this.telephone,
      required this.email})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        companyName, r'ContactInfo', 'companyName');
    BuiltValueNullFieldError.checkNotNull(
        salutation, r'ContactInfo', 'salutation');
    BuiltValueNullFieldError.checkNotNull(title, r'ContactInfo', 'title');
    BuiltValueNullFieldError.checkNotNull(
        firstName, r'ContactInfo', 'firstName');
    BuiltValueNullFieldError.checkNotNull(lastName, r'ContactInfo', 'lastName');
    BuiltValueNullFieldError.checkNotNull(
        telephone, r'ContactInfo', 'telephone');
    BuiltValueNullFieldError.checkNotNull(email, r'ContactInfo', 'email');
  }

  @override
  ContactInfo rebuild(void Function(ContactInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactInfoBuilder toBuilder() => new ContactInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactInfo &&
        companyName == other.companyName &&
        salutation == other.salutation &&
        title == other.title &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        telephone == other.telephone &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, salutation.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, telephone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactInfo')
          ..add('companyName', companyName)
          ..add('salutation', salutation)
          ..add('title', title)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('telephone', telephone)
          ..add('email', email))
        .toString();
  }
}

class ContactInfoBuilder implements Builder<ContactInfo, ContactInfoBuilder> {
  _$ContactInfo? _$v;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _salutation;
  String? get salutation => _$this._salutation;
  set salutation(String? salutation) => _$this._salutation = salutation;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _telephone;
  String? get telephone => _$this._telephone;
  set telephone(String? telephone) => _$this._telephone = telephone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ContactInfoBuilder() {
    ContactInfo._defaults(this);
  }

  ContactInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyName = $v.companyName;
      _salutation = $v.salutation;
      _title = $v.title;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _telephone = $v.telephone;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ContactInfo;
  }

  @override
  void update(void Function(ContactInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactInfo build() => _build();

  _$ContactInfo _build() {
    final _$result = _$v ??
        new _$ContactInfo._(
          companyName: BuiltValueNullFieldError.checkNotNull(
              companyName, r'ContactInfo', 'companyName'),
          salutation: BuiltValueNullFieldError.checkNotNull(
              salutation, r'ContactInfo', 'salutation'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ContactInfo', 'title'),
          firstName: BuiltValueNullFieldError.checkNotNull(
              firstName, r'ContactInfo', 'firstName'),
          lastName: BuiltValueNullFieldError.checkNotNull(
              lastName, r'ContactInfo', 'lastName'),
          telephone: BuiltValueNullFieldError.checkNotNull(
              telephone, r'ContactInfo', 'telephone'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ContactInfo', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
