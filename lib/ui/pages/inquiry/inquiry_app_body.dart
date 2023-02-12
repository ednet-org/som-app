import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';
import 'package:som/domain/model/inquiry_management/offer.dart';
import 'package:som/domain/model/inquiry_management/test/mock.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/arr.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/filter.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/i_filter.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/entity_filters.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/entity_list.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/inquiry_card.dart';
import '../../components/low/layout/app_body.dart';

class InquiryAppBody extends StatefulWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  State<InquiryAppBody> createState() => _InquiryAppBodyState();
}

class _InquiryAppBodyState extends State<InquiryAppBody> {
  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: filters,
      leftSplit: EntityList<Inquiry>(
        filters: filters,
        entities: mockJsonInquiries
            .map((inquiryJson) => Inquiry.fromJson(inquiryJson))
            .toList(),
        entityBuilder: (inquiry) => InquiryCard(
          inquiry: inquiry,
        ),
      ),
      rightSplit: EntityList<Offer>(
        filters: filters,
        entities: mockJsonOffers
            .map((offerJson) => Offer.fromJson(offerJson))
            .toList(),
        entityBuilder: (offer) => Text(offer.id),
      ),
    );
  }
}

final EntityFilters<Inquiry> filters = EntityFilters(filters: [
  Filter(
    name: 'Status',
    value: const Arr<InquiryStatus>(
      name: 'Status',
      value: null,
    ),
    mode: DisplayMode.dropdown,
    allowedValues: [
      const Arr<InquiryStatus>(
        name: 'Draft',
        value: InquiryStatus.draft,
      ),
      const Arr<InquiryStatus>(
        name: 'Published',
        value: InquiryStatus.published,
      ),
      const Arr<InquiryStatus>(
        name: 'Expired',
        value: InquiryStatus.expired,
      ),
      const Arr<InquiryStatus>(
        name: 'Closed',
        value: InquiryStatus.closed,
      ),
    ],
    operands: [
      FilterOperand.equals,
    ],
  ),
  Filter(
    name: 'Title',
    value: const Arr<String>(
      name: 'Title',
      value: null,
    ),
    mode: DisplayMode.input,
    operands: [
      FilterOperand.equals,
      FilterOperand.contains,
    ],
  ),
  Filter(
    name: 'Description',
    value: const Arr<String>(
      name: 'Description',
      value: null,
    ),
    mode: DisplayMode.input,
    operands: [
      FilterOperand.equals,
      FilterOperand.contains,
    ],
  ),
]);
