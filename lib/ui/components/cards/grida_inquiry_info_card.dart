import 'package:flutter/material.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';

class GridaInquiryInfoCard extends StatelessWidget {
  final Inquiry inquiry;

  const GridaInquiryInfoCard({
    super.key,
    required this.inquiry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: _InquiryStatusIndicator(status: inquiry.status.name),
              ),
              Text(
                'Inquiry',
                style: theme.textTheme.headline6?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                inquiry.id,
                style: theme.textTheme.headline6?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Divider(color: theme.colorScheme.onSurface),
              const SizedBox(height: 8.0),
              Text(
                inquiry.description,
                style: theme.textTheme.subtitle2,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _InquiryStatusIndicator extends StatelessWidget {
  final String status;

  const _InquiryStatusIndicator({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color statusColor;

    switch (status) {
      case 'closed':
        statusColor = Colors.green;
        break;
      case 'responded':
        statusColor = theme.colorScheme.error;
        break;
      case 'published':
        statusColor = Colors.orange;
        break;
      case 'draft':
        statusColor = theme.colorScheme.onSurface.withOpacity(0.38);
        break;
      default:
        statusColor = theme.colorScheme.onSurface.withOpacity(0.38);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 20.0,
      height: 20.0,
    );
  }
}
