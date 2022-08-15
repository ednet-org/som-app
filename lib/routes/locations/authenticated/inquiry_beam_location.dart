import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class InquiryBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('Inquiry page'),
        title: 'Inquiry',
        child: Text('Inquiry'),
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        'iInquiry',
      ];
}
