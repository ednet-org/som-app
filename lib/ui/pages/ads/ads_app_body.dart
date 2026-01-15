// This file is deprecated. Use ads_page.dart instead.
// Maintained for backward compatibility.
import 'package:flutter/material.dart';

import 'ads_page.dart';

export 'ads_page.dart' show AdsPage;

/// @deprecated Use [AdsPage] instead.
class AdsAppBody extends StatelessWidget {
  const AdsAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdsPage();
  }
}
