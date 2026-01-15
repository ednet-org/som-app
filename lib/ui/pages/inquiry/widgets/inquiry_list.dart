import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

/// Widget for displaying a list of inquiries.
///
/// Shows inquiry ID, status, and branch with selection support.
class InquiryList extends StatelessWidget {
  const InquiryList({
    Key? key,
    required this.inquiries,
    required this.selectedInquiryId,
    required this.onInquirySelected,
  }) : super(key: key);

  final List<Inquiry> inquiries;
  final String? selectedInquiryId;
  final ValueChanged<Inquiry> onInquirySelected;

  @override
  Widget build(BuildContext context) {
    if (inquiries.isEmpty) {
      return const Center(
        child: Text('No inquiries found.'),
      );
    }

    return ListView.builder(
      itemCount: inquiries.length,
      itemBuilder: (context, index) {
        final inquiry = inquiries[index];
        return InquiryListTile(
          inquiry: inquiry,
          isSelected: selectedInquiryId == inquiry.id,
          onTap: () => onInquirySelected(inquiry),
        );
      },
    );
  }
}

/// Single list tile for an inquiry.
class InquiryListTile extends StatelessWidget {
  const InquiryListTile({
    Key? key,
    required this.inquiry,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final Inquiry inquiry;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(inquiry.id ?? 'Inquiry'),
      subtitle: Text(
        'Status: ${inquiry.status ?? '-'} | Branch: ${inquiry.branchId ?? '-'}',
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
