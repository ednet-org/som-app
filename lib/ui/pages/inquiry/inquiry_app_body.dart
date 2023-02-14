import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';
import 'package:som/domain/model/inquiry_management/test/mock.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/arr.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/filter.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/core/i_filter.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/entity/document/document.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/entity_list.dart';
import '../../components/low/cards/inquiry/inquiry_card_components/flutter/entity_card.dart';
import '../../components/low/layout/app_body.dart';

class InquiryAppBody extends StatefulWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  State<InquiryAppBody> createState() => _InquiryAppBodyState();
}

class _InquiryAppBodyState extends State<InquiryAppBody> {
  late EntityList entityList;
  Widget? details;

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: entityList.filters,
      leftSplit: entityList,
      rightSplit: details,
    );
  }

  @override
  void initState() {
    super.initState();

    entityList = EntityList<Inquiry>(
      listMode: ListMode.list,
      entities: InquiryService.getParsedInquiries(),
      entityBuilder: (inquiry) => EntityCard<Inquiry>(
        entity: inquiry,
      ),
      detailsBuilder: (entity) => EntityDocument<Inquiry>(
        entity: entity,
      ),
      filters: [
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
      ],
      onEntitySelected: (entity) {
        if (entity != null) {
          setState(() {
            details = EntityDocument(entity: entity);
          });
        } else {
          setState(() => {details = null});
        }
        print('Entity selected');
        print(entity?.title);
      },
    );
  }
}

class InquiryService {
  static getParsedInquiries() {
    return mockJsonInquiries
        .map((inquiryJson) => Inquiry.fromJson(inquiryJson))
        .toList();
  }
}
