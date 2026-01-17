import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../../../domain/model/model.dart';
import '../form_section_header.dart';

/// Step widget for payment details in registration flow.
class PaymentDetailsStep extends StatelessWidget {
  const PaymentDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RegistrationRequest>(context);
    return Observer(
      builder: (_) => Column(
        children: [
          const FormSectionHeader(label: 'Bank details'),
          20.height,
          SomTextInput(
            label: 'IBAN',
            iconAsset: SomAssets.iconDashboard,
            hint: 'Enter IBAN',
            value: request.company.providerData.bankDetails?.iban,
            errorText: request.fieldError('provider.bankDetails.iban'),
            onChanged: (value) {
              request.company.providerData.bankDetails?.setIban(value);
              request.clearFieldError('provider.bankDetails.iban');
            },
            required: true,
          ),
          SomTextInput(
            label: 'BIC',
            iconAsset: SomAssets.iconInfo,
            hint: 'Enter BIC',
            value: request.company.providerData.bankDetails?.bic,
            errorText: request.fieldError('provider.bankDetails.bic'),
            onChanged: (value) {
              request.company.providerData.bankDetails?.setBic(value);
              request.clearFieldError('provider.bankDetails.bic');
            },
            required: true,
          ),
          SomTextInput(
            label: 'Account owner',
            iconAsset: SomAssets.iconUser,
            hint: 'Enter account owner',
            value: request.company.providerData.bankDetails?.accountOwner,
            errorText: request.fieldError('provider.bankDetails.accountOwner'),
            onChanged: (value) {
              request.company.providerData.bankDetails?.setAccountOwner(value);
              request.clearFieldError('provider.bankDetails.accountOwner');
            },
            required: true,
          ),
          30.height,
          const FormSectionHeader(label: 'Payment interval'),
          20.height,
          _PaymentIntervalSelector(request: request),
          50.height,
        ],
      ),
    );
  }
}

class _PaymentIntervalSelector extends StatelessWidget {
  const _PaymentIntervalSelector({required this.request});

  final RegistrationRequest request;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      children: [
        Radio(
          value: PaymentInterval.Monthly,
          groupValue: request.company.providerData.paymentInterval,
          onChanged: (dynamic value) {
            toast('$value Selected');
            request.company.providerData.setPaymentInterval(
              PaymentInterval.Monthly,
            );
          },
        ),
        GestureDetector(
          onTap: () {
            request.company.providerData.setPaymentInterval(
              PaymentInterval.Monthly,
            );
          },
          child: Text(PaymentInterval.Monthly.name),
        ),
        Radio(
          value: PaymentInterval.Yearly,
          groupValue: request.company.providerData.paymentInterval,
          onChanged: (dynamic value) {
            toast('$value Selected');
            request.company.providerData.setPaymentInterval(
              PaymentInterval.Yearly,
            );
          },
        ),
        GestureDetector(
          onTap: () {
            request.company.providerData.setPaymentInterval(
              PaymentInterval.Yearly,
            );
          },
          child: Text(PaymentInterval.Yearly.name),
        ),
      ],
    );
  }
}
