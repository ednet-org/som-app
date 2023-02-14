import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../ui/components/low/cards/inquiry/inquiry_card_components/core/arr.dart';
import '../../../ui/components/low/cards/inquiry/inquiry_card_components/flutter/entity.dart';
import 'attachment.dart';
import 'enums/inquiry_status.dart';
import 'offer.dart';
import 'provider_criteria.dart';
import 'user.dart';

const uuid = Uuid();

/// [Inquiry] is a [Buyer] business request to the [Provider]
class Inquiry extends Entity<Arr> {
  final Arr<String> id;
  final Arr<String> title;
  final Arr<String> description;
  final Arr<String> category;
  final Arr<String> branch;
  final Arr<DateTime> publishingDate;
  final Arr<DateTime> expirationDate;

  final Arr<User> buyer;
  final Arr<String> deliveryLocation;
  final Arr<ProviderCriteria> providerCriteria;
  final Arr<List<Attachment>> attachments;
  final Arr<List<Offer>> offers;

  @override
  final Arr<InquiryStatus> status;

  Inquiry({
    id,
    required this.title,
    required this.description,
    required this.category,
    required this.branch,
    required this.buyer,
    required this.publishingDate,
    required this.expirationDate,
    required this.deliveryLocation,
    required this.providerCriteria,
    required this.attachments,
    required this.status,
    required this.offers,
  }) : id = id ?? Arr<String>(name: 'id', value: uuid.v4());

  static Inquiry fromJson(Map<String, dynamic> json) {
    const dateFormat = 'dd.MM.yyyy';
    var uuid = const Uuid();
    var arrUuid = Arr<String>(name: 'Id', value: json['id'] ?? uuid.v4());

    // DateFormat(dateFormat).parse(json['publishingDate'])
    return Inquiry(
      id: arrUuid,
      title: Arr<String>(name: 'title', value: json['title']),
      description: Arr<String>(name: 'description', value: json['description']),
      category: Arr<String>(name: 'category', value: json['category']),
      branch: Arr<String>(name: 'branch', value: json['branch']),
      publishingDate: Arr<DateTime>(
          name: 'publishingDate',
          value: DateFormat(dateFormat).parse(json['publishingDate'])),
      expirationDate: Arr<DateTime>(
          name: 'expirationDate',
          value: DateFormat(dateFormat).parse(json['expirationDate'])),
      buyer: Arr<User>(name: 'buyer', value: User.fromJson(json['buyer'])),
      deliveryLocation: Arr<String>(
          name: 'deliveryLocation', value: json['deliveryLocation']),
      providerCriteria: Arr<ProviderCriteria>(
          name: 'providerCriteria',
          value: ProviderCriteria.fromJson(json['providerCriteria'])),
      attachments: const Arr<List<Attachment>>(name: 'attachments', value: []),
      status: Arr<InquiryStatus>(
          name: 'status', value: InquiryStatus.fromJson(json['status'])),
      offers: const Arr<List<Offer>>(name: 'offers', value: []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.value,
      'title': title.value,
      'description': description.value,
      'category': category.value,
      'branch': branch.value,
      'publishingDate': publishingDate.value?.toIso8601String(),
      'expirationDate': expirationDate.value?.toIso8601String(),
      'user': buyer.value?.toJson(),
      'deliveryLocation': deliveryLocation.value,
      'provider': providerCriteria.value?.toJson(),
      'attachments': attachments.value?.map((e) => e.toJson()).toList(),
      'status': status.value?.toJson(),
      'offers': offers.value?.map((e) => e.toJson()).toList(),
    };
  }

  Inquiry copyWith({
    Arr<String>? id,
    Arr<String>? title,
    Arr<String>? description,
    Arr<String>? category,
    Arr<String>? branch,
    Arr<DateTime>? publishingDate,
    Arr<DateTime>? expirationDate,
    Arr<User>? buyer,
    Arr<String>? deliveryLocation,
    Arr<ProviderCriteria>? providerCriteria,
    Arr<List<Attachment>>? attachments,
    Arr<InquiryStatus>? status,
    Arr<List<Offer>>? offers,
  }) {
    return Inquiry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      branch: branch ?? this.branch,
      publishingDate: publishingDate ?? this.publishingDate,
      expirationDate: expirationDate ?? this.expirationDate,
      buyer: buyer ?? this.buyer,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      providerCriteria: providerCriteria ?? this.providerCriteria,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      offers: offers ?? this.offers,
    );
  }

  // get attributes that can be used in filters
  @override
  List<Arr> getFilterableAttributes() {
    return [
      title,
      description,
      category,
      branch,
      publishingDate,
      expirationDate,
      buyer,
      deliveryLocation,
      providerCriteria,
      attachments,
      status,
      offers,
    ];
  }

  @override
  Iterable<Arr> getDocumentAttributes() {
    // all attributes that are editable
    return [
      title,
      description,
      category,
      branch,
      expirationDate,
      deliveryLocation,
      providerCriteria,
      attachments,
      status,
      offers,
      providerCriteria,
    ];
  }

  @override
  Iterable<Arr> getSummaryAttributes() {
    return [
      id,
      title,
      status,
      description,
      category,
      branch,
      attachments,
      offers,
    ];
}
