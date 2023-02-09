import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';
import 'package:som/domain/model/inquiry_management/offer.dart';
import 'package:som/domain/model/inquiry_management/offer_status.dart';
import 'package:som/domain/model/inquiry_management/test/mock.dart';
import 'package:som/ui/components/layout/app_body.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';
import '../../components/cards/inquiry/inquiry_card.dart';

class InquiryAppBody extends StatelessWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text(
        'Refine your search with Filters',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      leftSplit: Entities<Inquiry>(
        entities: mockJsonInquiries
            .map((inquiryJson) => Inquiry.fromJson(inquiryJson))
            .toList(),
        entityBuilder: (inquiry) => InquiryCard(
          inquiry: inquiry,
        ),
      ),
      rightSplit: Entities<Offer>(
        entities: mockJsonOffers
            .map((offerJson) => Offer.fromJson(offerJson))
            .toList(),
        entityBuilder: (offer) => Text(offer.id),
      ),
    );
  }
}

class Entities<T> extends StatelessWidget {
  final List<Filter> filters;
  final List<Sort> sorts;
  final List<T> entities;

  final Widget Function(T) entityBuilder;

  const Entities({
    super.key,
    required this.entities,
    required this.entityBuilder,
    this.filters = const [],
    this.sorts = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              return entityBuilder(entities[index]);
            },
          ),
        ),
      ],
    );
  }
}

class Sort {}

class Filter {}

// https://gist.github.com/slavisam/a4c08dac23b012fb7108d7eb4f2a3f72
