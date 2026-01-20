// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Inquiry extends Inquiry {
  @override
  final String? id;
  @override
  final String? buyerCompanyId;
  @override
  final String? createdByUserId;
  @override
  final String? status;
  @override
  final String? branchId;
  @override
  final String? categoryId;
  @override
  final BuiltList<String>? productTags;
  @override
  final DateTime? deadline;
  @override
  final BuiltList<String>? deliveryZips;
  @override
  final int? numberOfProviders;
  @override
  final String? description;
  @override
  final String? pdfPath;
  @override
  final String? summaryPdfPath;
  @override
  final ProviderCriteria? providerCriteria;
  @override
  final ContactInfo? contactInfo;
  @override
  final DateTime? notifiedAt;
  @override
  final DateTime? assignedAt;
  @override
  final DateTime? closedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$Inquiry([void Function(InquiryBuilder)? updates]) =>
      (InquiryBuilder()..update(updates))._build();

  _$Inquiry._(
      {this.id,
      this.buyerCompanyId,
      this.createdByUserId,
      this.status,
      this.branchId,
      this.categoryId,
      this.productTags,
      this.deadline,
      this.deliveryZips,
      this.numberOfProviders,
      this.description,
      this.pdfPath,
      this.summaryPdfPath,
      this.providerCriteria,
      this.contactInfo,
      this.notifiedAt,
      this.assignedAt,
      this.closedAt,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  Inquiry rebuild(void Function(InquiryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InquiryBuilder toBuilder() => InquiryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Inquiry &&
        id == other.id &&
        buyerCompanyId == other.buyerCompanyId &&
        createdByUserId == other.createdByUserId &&
        status == other.status &&
        branchId == other.branchId &&
        categoryId == other.categoryId &&
        productTags == other.productTags &&
        deadline == other.deadline &&
        deliveryZips == other.deliveryZips &&
        numberOfProviders == other.numberOfProviders &&
        description == other.description &&
        pdfPath == other.pdfPath &&
        summaryPdfPath == other.summaryPdfPath &&
        providerCriteria == other.providerCriteria &&
        contactInfo == other.contactInfo &&
        notifiedAt == other.notifiedAt &&
        assignedAt == other.assignedAt &&
        closedAt == other.closedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, buyerCompanyId.hashCode);
    _$hash = $jc(_$hash, createdByUserId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, branchId.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, productTags.hashCode);
    _$hash = $jc(_$hash, deadline.hashCode);
    _$hash = $jc(_$hash, deliveryZips.hashCode);
    _$hash = $jc(_$hash, numberOfProviders.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, pdfPath.hashCode);
    _$hash = $jc(_$hash, summaryPdfPath.hashCode);
    _$hash = $jc(_$hash, providerCriteria.hashCode);
    _$hash = $jc(_$hash, contactInfo.hashCode);
    _$hash = $jc(_$hash, notifiedAt.hashCode);
    _$hash = $jc(_$hash, assignedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Inquiry')
          ..add('id', id)
          ..add('buyerCompanyId', buyerCompanyId)
          ..add('createdByUserId', createdByUserId)
          ..add('status', status)
          ..add('branchId', branchId)
          ..add('categoryId', categoryId)
          ..add('productTags', productTags)
          ..add('deadline', deadline)
          ..add('deliveryZips', deliveryZips)
          ..add('numberOfProviders', numberOfProviders)
          ..add('description', description)
          ..add('pdfPath', pdfPath)
          ..add('summaryPdfPath', summaryPdfPath)
          ..add('providerCriteria', providerCriteria)
          ..add('contactInfo', contactInfo)
          ..add('notifiedAt', notifiedAt)
          ..add('assignedAt', assignedAt)
          ..add('closedAt', closedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class InquiryBuilder implements Builder<Inquiry, InquiryBuilder> {
  _$Inquiry? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _buyerCompanyId;
  String? get buyerCompanyId => _$this._buyerCompanyId;
  set buyerCompanyId(String? buyerCompanyId) =>
      _$this._buyerCompanyId = buyerCompanyId;

  String? _createdByUserId;
  String? get createdByUserId => _$this._createdByUserId;
  set createdByUserId(String? createdByUserId) =>
      _$this._createdByUserId = createdByUserId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

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

  String? _pdfPath;
  String? get pdfPath => _$this._pdfPath;
  set pdfPath(String? pdfPath) => _$this._pdfPath = pdfPath;

  String? _summaryPdfPath;
  String? get summaryPdfPath => _$this._summaryPdfPath;
  set summaryPdfPath(String? summaryPdfPath) =>
      _$this._summaryPdfPath = summaryPdfPath;

  ProviderCriteriaBuilder? _providerCriteria;
  ProviderCriteriaBuilder get providerCriteria =>
      _$this._providerCriteria ??= ProviderCriteriaBuilder();
  set providerCriteria(ProviderCriteriaBuilder? providerCriteria) =>
      _$this._providerCriteria = providerCriteria;

  ContactInfoBuilder? _contactInfo;
  ContactInfoBuilder get contactInfo =>
      _$this._contactInfo ??= ContactInfoBuilder();
  set contactInfo(ContactInfoBuilder? contactInfo) =>
      _$this._contactInfo = contactInfo;

  DateTime? _notifiedAt;
  DateTime? get notifiedAt => _$this._notifiedAt;
  set notifiedAt(DateTime? notifiedAt) => _$this._notifiedAt = notifiedAt;

  DateTime? _assignedAt;
  DateTime? get assignedAt => _$this._assignedAt;
  set assignedAt(DateTime? assignedAt) => _$this._assignedAt = assignedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  InquiryBuilder() {
    Inquiry._defaults(this);
  }

  InquiryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _buyerCompanyId = $v.buyerCompanyId;
      _createdByUserId = $v.createdByUserId;
      _status = $v.status;
      _branchId = $v.branchId;
      _categoryId = $v.categoryId;
      _productTags = $v.productTags?.toBuilder();
      _deadline = $v.deadline;
      _deliveryZips = $v.deliveryZips?.toBuilder();
      _numberOfProviders = $v.numberOfProviders;
      _description = $v.description;
      _pdfPath = $v.pdfPath;
      _summaryPdfPath = $v.summaryPdfPath;
      _providerCriteria = $v.providerCriteria?.toBuilder();
      _contactInfo = $v.contactInfo?.toBuilder();
      _notifiedAt = $v.notifiedAt;
      _assignedAt = $v.assignedAt;
      _closedAt = $v.closedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Inquiry other) {
    _$v = other as _$Inquiry;
  }

  @override
  void update(void Function(InquiryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Inquiry build() => _build();

  _$Inquiry _build() {
    _$Inquiry _$result;
    try {
      _$result = _$v ??
          _$Inquiry._(
            id: id,
            buyerCompanyId: buyerCompanyId,
            createdByUserId: createdByUserId,
            status: status,
            branchId: branchId,
            categoryId: categoryId,
            productTags: _productTags?.build(),
            deadline: deadline,
            deliveryZips: _deliveryZips?.build(),
            numberOfProviders: numberOfProviders,
            description: description,
            pdfPath: pdfPath,
            summaryPdfPath: summaryPdfPath,
            providerCriteria: _providerCriteria?.build(),
            contactInfo: _contactInfo?.build(),
            notifiedAt: notifiedAt,
            assignedAt: assignedAt,
            closedAt: closedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'productTags';
        _productTags?.build();

        _$failedField = 'deliveryZips';
        _deliveryZips?.build();

        _$failedField = 'providerCriteria';
        _providerCriteria?.build();
        _$failedField = 'contactInfo';
        _contactInfo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Inquiry', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
