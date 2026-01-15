import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:som/ui/pages/inquiry/inquiry_page.dart';

class InquiryBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('Inquiry page'),
        title: 'Inquiry',
        child: InquiryPage(),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        'inquiry',
        'inquiries',
      ];
}
