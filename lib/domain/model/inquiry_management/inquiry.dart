import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'attachment.dart';
import 'inquiry_status.dart';
import 'offer.dart';
import 'provider_criteria.dart';
import 'user.dart';

/// [Inquiry] is a [Buyer] business request to the [Provider]
class Inquiry {
  final String id;
  final String title;
  final String description;
  final String category;
  final String branch;
  final DateTime publishingDate;
  final DateTime expirationDate;

  final User buyer;
  final String deliveryLocation;
  final ProviderCriteria providerCriteria;
  final List<Attachment> attachments;
  final List<Offer> offers;

  final InquiryStatus status;

  const Inquiry({
    required this.id,
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
  });

  static Inquiry fromJson(Map<String, dynamic> json) {
    const dateFormat = 'dd.MM.yyyy';
    var uuid = const Uuid();

    return Inquiry(
      id: json['id'] ?? uuid.v4(),
      title: json['title'],
      description: json['description'],
      category: json['category'],
      branch: json['branch'],
      publishingDate: DateFormat(dateFormat).parse(json['publishingDate']),
      expirationDate: DateFormat(dateFormat).parse(json['expirationDate']),
      buyer: User.fromJson(json['user']),
      deliveryLocation: json['deliveryLocation'],
      providerCriteria: ProviderCriteria.fromJson(json['provider']),
      attachments: json['attachments'] != null
          ? jsonDecode(json['attachments'])
              .map<Attachment>((e) => Attachment.fromJson(e))
              .toList()
          : [],
      status: InquiryStatus.fromJson(json['status']),
      offers: json['offers'] != null && json['offers'].isNotEmpty
          ? jsonDecode(json['offers'])
              .map<Offer>((e) => Offer.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'branch': branch,
      'publishingDate': publishingDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'user': buyer.toJson(),
      'deliveryLocation': deliveryLocation,
      'provider': providerCriteria.toJson(),
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'status': status.toJson(),
      'offers': offers.map((e) => e.toJson()).toList(),
    };
  }

  Inquiry copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? branch,
    DateTime? publishingDate,
    DateTime? expirationDate,
    User? buyer,
    String? deliveryLocation,
    ProviderCriteria? providerCriteria,
    List<Attachment>? attachments,
    InquiryStatus? status,
    List<Offer>? offers,
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
}
