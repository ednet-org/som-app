// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inquiry_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateInquiryRequest extends CreateInquiryRequest {
  @override
  final String branchId;
  @override
  final String categoryId;
  @override
  final BuiltList<String>? productTags;
  @override
  final DateTime deadline;
  @override
  final BuiltList<String> deliveryZips;
  @override
  final int numberOfProviders;
  @override
  final String? description;
  @override
  final String? providerZip;
  @override
  final int? radiusKm;
  @override
  final String? providerType;
  @override
  final String? providerCompanySize;
  @override
  final String? salutation;
  @override
  final String? title;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? telephone;
  @override
  final String? email;

  factory _$CreateInquiryRequest(
          [void Function(CreateInquiryRequestBuilder)? updates]) =>
      (CreateInquiryRequestBuilder()..update(updates))._build();

  _$CreateInquiryRequest._(
      {required this.branchId,
      required this.categoryId,
      this.productTags,
      required this.deadline,
      required this.deliveryZips,
      required this.numberOfProviders,
      this.description,
      this.providerZip,
      this.radiusKm,
      this.providerType,
      this.providerCompanySize,
      this.salutation,
      this.title,
      this.firstName,
      this.lastName,
      this.telephone,
      this.email})
      : super._();
  @override
  CreateInquiryRequest rebuild(
          void Function(CreateInquiryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateInquiryRequestBuilder toBuilder() =>
      CreateInquiryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateInquiryRequest &&
        branchId == other.branchId &&
        categoryId == other.categoryId &&
        productTags == other.productTags &&
        deadline == other.deadline &&
        deliveryZips == other.deliveryZips &&
        numberOfProviders == other.numberOfProviders &&
        description == other.description &&
        providerZip == other.providerZip &&
        radiusKm == other.radiusKm &&
        providerType == other.providerType &&
        providerCompanySize == other.providerCompanySize &&
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
    _$hash = $jc(_$hash, branchId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, productTags.hashCode);
    _$hash = $jc(_$hash, deadline.hashCode);
    _$hash = $jc(_$hash, deliveryZips.hashCode);
    _$hash = $jc(_$hash, numberOfProviders.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, providerZip.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, providerType.hashCode);
    _$hash = $jc(_$hash, providerCompanySize.hashCode);
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
    return (newBuiltValueToStringHelper(r'CreateInquiryRequest')
          ..add('branchId', branchId)
          ..add('categoryId', categoryId)
          ..add('productTags', productTags)
          ..add('deadline', deadline)
          ..add('deliveryZips', deliveryZips)
          ..add('numberOfProviders', numberOfProviders)
          ..add('description', description)
          ..add('providerZip', providerZip)
          ..add('radiusKm', radiusKm)
          ..add('providerType', providerType)
          ..add('providerCompanySize', providerCompanySize)
          ..add('salutation', salutation)
          ..add('title', title)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('telephone', telephone)
          ..add('email', email))
        .toString();
  }
}

class CreateInquiryRequestBuilder
    implements Builder<CreateInquiryRequest, CreateInquiryRequestBuilder> {
  _$CreateInquiryRequest? _$v;

  String? _branchId;
  String? get branchId => _$this._branchId;
  set branchId(String? branchId) => _$this._branchId = branchId;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  ListBuilder<String>? _productTags;
  ListBuilder<String> get productTags =>
      _$this._productTags ??= ListBuilder<String>();
  set productTags(ListBuilder<String>? productTags) =>
      _$this._productTags = productTags;

  DateTime? _deadline;
  DateTime? get deadline => _$this._deadline;
  set deadline(DateTime? deadline) => _$this._deadline = deadline;

  ListBuilder<String>? _deliveryZips;
  ListBuilder<String> get deliveryZips =>
      _$this._deliveryZips ??= ListBuilder<String>();
  set deliveryZips(ListBuilder<String>? deliveryZips) =>
      _$this._deliveryZips = deliveryZips;

  int? _numberOfProviders;
  int? get numberOfProviders => _$this._numberOfProviders;
  set numberOfProviders(int? numberOfProviders) =>
      _$this._numberOfProviders = numberOfProviders;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _providerZip;
  String? get providerZip => _$this._providerZip;
  set providerZip(String? providerZip) => _$this._providerZip = providerZip;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  String? _providerType;
  String? get providerType => _$this._providerType;
  set providerType(String? providerType) => _$this._providerType = providerType;

  String? _providerCompanySize;
  String? get providerCompanySize => _$this._providerCompanySize;
  set providerCompanySize(String? providerCompanySize) =>
      _$this._providerCompanySize = providerCompanySize;

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

  CreateInquiryRequestBuilder() {
    CreateInquiryRequest._defaults(this);
  }

  CreateInquiryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _branchId = $v.branchId;
      _categoryId = $v.categoryId;
      _productTags = $v.productTags?.toBuilder();
      _deadline = $v.deadline;
      _deliveryZips = $v.deliveryZips.toBuilder();
      _numberOfProviders = $v.numberOfProviders;
      _description = $v.description;
      _providerZip = $v.providerZip;
      _radiusKm = $v.radiusKm;
      _providerType = $v.providerType;
      _providerCompanySize = $v.providerCompanySize;
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
  void replace(CreateInquiryRequest other) {
    _$v = other as _$CreateInquiryRequest;
  }

  @override
  void update(void Function(CreateInquiryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateInquiryRequest build() => _build();

  _$CreateInquiryRequest _build() {
    _$CreateInquiryRequest _$result;
    try {
      _$result = _$v ??
          _$CreateInquiryRequest._(
            branchId: BuiltValueNullFieldError.checkNotNull(
                branchId, r'CreateInquiryRequest', 'branchId'),
            categoryId: BuiltValueNullFieldError.checkNotNull(
                categoryId, r'CreateInquiryRequest', 'categoryId'),
            productTags: _productTags?.build(),
            deadline: BuiltValueNullFieldError.checkNotNull(
                deadline, r'CreateInquiryRequest', 'deadline'),
            deliveryZips: deliveryZips.build(),
            numberOfProviders: BuiltValueNullFieldError.checkNotNull(
                numberOfProviders,
                r'CreateInquiryRequest',
                'numberOfProviders'),
            description: description,
            providerZip: providerZip,
            radiusKm: radiusKm,
            providerType: providerType,
            providerCompanySize: providerCompanySize,
            salutation: salutation,
            title: title,
            firstName: firstName,
            lastName: lastName,
            telephone: telephone,
            email: email,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'productTags';
        _productTags?.build();

        _$failedField = 'deliveryZips';
        deliveryZips.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateInquiryRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
