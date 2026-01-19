// This file is deprecated. Use inquiry_page.dart instead.
// Maintained for backward compatibility.
import 'package:flutter/material.dart';

import 'inquiry_page.dart';

export 'inquiry_page.dart' show InquiryPage;

/// @deprecated Use [InquiryPage] instead.
class InquiryAppBody extends StatelessWidget {
  const InquiryAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const InquiryPage();
  }
}
