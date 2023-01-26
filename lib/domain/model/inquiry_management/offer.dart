import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'attachment.dart';
import 'inquiry.dart';
import 'offer_status.dart';
import 'user.dart';

/// [Offer] is [Provider] business response to the [Inquiry]
class Offer {
  final String id;
  final Inquiry inquiry;

  final Provider provider;
  final String? description;
  final String? deliveryTime;
  final List<Attachment> attachments;

  final OfferStatus status;
  final DateTime expirationDate;

  final double? price;

  const Offer({
    required this.id,
    required this.inquiry,
    required this.provider,
    required this.price,
    required this.deliveryTime,
    this.attachments = const [],
    required this.status,
    required this.expirationDate,
    this.description,
  });

  static Offer fromJson(Map<String, dynamic> json) {
    const dateFormat = 'dd.MM.yyyy';
    var uuid = const Uuid();

    return Offer(
      id: json['id'] ?? uuid.v4(),
      inquiry: Inquiry.fromJson(json['inquiry']),
      provider: Provider.fromJson(json['provider']),
      price: json['price'],
      deliveryTime: json['deliveryTime'],
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((attachment) => Attachment.fromJson(attachment))
              .toList()
          : [],
      status: json['status'] as OfferStatus,
      expirationDate: DateFormat(dateFormat).parse(json['expirationDate']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inquiry': inquiry.toJson(),
      'provider': provider.toJson(),
      'price': price,
      'deliveryTime': deliveryTime,
      'attachments':
          attachments.map((attachment) => attachment.toJson()).toList(),
      'status': status,
      'expirationDate': expirationDate.toIso8601String(),
      'description': description,
    };
  }

  Offer copyWith({
    String? id,
    Inquiry? inquiry,
    Provider? provider,
    double? price,
    String? deliveryTime,
    List<Attachment>? attachments,
    OfferStatus? status,
    String? description,
    DateTime? expirationDate,
  }) {
    return Offer(
      id: id ?? this.id,
      inquiry: inquiry ?? this.inquiry,
      provider: provider ?? this.provider,
      price: price ?? this.price,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      description: description ?? this.description,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}
