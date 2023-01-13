import 'dart:math' as math;
import 'package:flutter/material.dart';

class PositionedInfo extends StatelessWidget {
  final double top;
  final double left;
  final Widget child;

  const PositionedInfo(
      {super.key, required this.top, required this.left, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: child,
    );
  }
}

class InquiryInfoCard extends StatelessWidget {
  final Map<String, Object> inquiry;

  const InquiryInfoCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 306.00164794921875,
        height: 357,
        child: Stack(children: <Widget>[
          PositionedInfo(
              top: 0,
              left: 0,
              child: _InquiryInfoCardContainer(inquiry: inquiry)),
          _InquiryInfoCardTitle(inquiry: inquiry),
          _InquiryInfoCardDescription(inquiry: inquiry),
          _InquiryInfoCardStatus(inquiry: inquiry),
          _InquiryInfoCardDivider(),
        ]));
  }
}

class _InquiryInfoCardContainer extends StatelessWidget {
  final Map<String, Object> inquiry;

  const _InquiryInfoCardContainer({required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 305,
        height: 357,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0, 2),
                  blurRadius: 6)
            ],
            color: Color.fromRGBO(255, 251, 255, 1)));
  }
}

class _InquiryInfoCardTitle extends StatelessWidget {
  final Map<String, Object> inquiry;

  const _InquiryInfoCardTitle({required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return const PositionedInfo(
        top: 12,
        left: 20,
        child: Text(
          'Inquiry',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(56, 30, 114, 1),
              fontFamily: 'Work Sans',
              fontSize: 24,
              fontWeight: FontWeight.normal,
              height: 1),
        ));
  }
}

class _InquiryInfoCardDescription extends StatelessWidget {
  final Map<String, Object> inquiry;

  const _InquiryInfoCardDescription({required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
      top: 15,
      left: 108,
      child: Text(inquiry['description'].toString()),
    );
  }
}

class _InquiryInfoCardStatus extends StatelessWidget {
  final Map<String, Object> inquiry;

  const _InquiryInfoCardStatus({required this.inquiry});

  Color get inquiryStatusColor {
    var inquiryStatus = inquiry['status'];
    switch (inquiryStatus) {
      case 'closed':
        return Colors.green;
      case 'responded':
        return Colors.red;
      case 'published':
        return Colors.yellow;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 20.5,
        left: 270,
        child: Container(
            width: 17,
            height: 15,
            decoration: BoxDecoration(
              color: inquiryStatusColor,
              borderRadius: const BorderRadius.all(Radius.elliptical(17, 15)),
            )));
  }
}

class _InquiryInfoCardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PositionedInfo(
        top: 51,
        left: 1,
        child: Transform.rotate(
          angle: 2.4848083448933725e-17 * (math.pi / 180),
          child: const Divider(color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
        ));
  }
}
