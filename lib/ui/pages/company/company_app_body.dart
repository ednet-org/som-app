import 'package:flutter/material.dart';
import 'package:som/ui/components/layout/app_body.dart';

import 'edit_company_form.dart';

class CompanyAppBody extends StatelessWidget {
  const CompanyAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: const Text('Company'),
      leftSplit: EditCompanyForm(
          company: CompanyDTO(
        id: '1',
        name: 'Company Name',
        branch: 'Company Branch',
        companySize: 'Company Size',
        paymentInterval: 'Company Payment Interval',
        providerType: 'Company Provider Type',
        claimed: false,
      )),
    );
  }
}
