import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/pages/customer/registration/plan_modal.dart';

import '../../../domain/infrastructure/future_store.dart';
import '../../../domain/model/shared/som.dart';
import '../../../domain/model/customer_management/registration_request.dart';

class SubscriptionSelector extends StatefulWidget {
  const SubscriptionSelector({Key? key}) : super(key: key);

  @override
  State<SubscriptionSelector> createState() => _SubscriptionSelectorState();
}

class _SubscriptionSelectorState extends State<SubscriptionSelector> {
  int selectIndex = 0;

  int containerIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    final Som som = Provider.of<Som>(context, listen: false);
    som.populateAvailableSubscriptions();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Som som = Provider.of<Som>(context);
    final RegistrationRequest request =
        Provider.of<RegistrationRequest>(context);
    if (som.availableSubscriptions.futureState == FutureState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final plans = som.availableSubscriptions.data ?? [];
    if (plans.isEmpty) {
      return const Center(child: Text('No subscription plans found.'));
    }

    if (request.company.providerData.subscriptionPlanId == null) {
      request.company.providerData.setSubscriptionPlanId(plans.first.id ?? '');
      final maxUsers = plans.first.rules != null && plans.first.rules!.isNotEmpty
          ? plans.first.rules!.first.upperLimit
          : null;
      request.company.providerData.setMaxUsers(maxUsers);
    }

    final periodModal = plans
        .asMap()
        .entries
        .map((entry) {
          final plan = entry.value;
          final price = plan.priceInSubunit == null
              ? 'N/A'
              : '€ ${(plan.priceInSubunit! / 100).toStringAsFixed(2)} / Monat';
          final rules = plan.rules
                  ?.map((rule) =>
                      'Restriction ${rule.restriction ?? '-'}: ${rule.upperLimit ?? '-'}')
                  .toList() ??
              const <String>[];
          return PlanModal(
            title: 'Plan ${plan.sortPriority ?? entry.key + 1}',
            subTitle: price,
            optionList: rules.map((item) => PlanModal(title: item)).toList(),
            price: price,
          );
        })
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                UL(
                  edgeInsets: const EdgeInsets.symmetric(horizontal: 16),
                  symbolType: SymbolType.Custom,
                  customSymbol: Text('•', style: secondaryTextStyle(size: 20)),
                  children: List.generate(
                      periodModal[selectIndex].optionList!.length, (i) {
                    return Text(
                        periodModal[selectIndex]
                            .optionList![i]
                            .title
                            .validate(),
                        style: primaryTextStyle(size: 18));
                  }),
                ),
                10.height,
                const Divider(),
                Text(periodModal[selectIndex].price!),
                10.height,
              ],
            )),
        16.height,
        const Text('Choose subscription plan').paddingLeft(12.0),
        16.height,
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: periodModal.length,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            bool value = selectIndex == index;
            return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: value
                      ? context.cardColor.withOpacity(0.3)
                      : context.cardColor,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: value
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                          ).visible(value).center(),
                        ),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(periodModal[index].title.validate(),
                                style: boldTextStyle(size: 16)),
                            Text(periodModal[index].subTitle.validate(),
                                style: secondaryTextStyle()),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                )).onTap(
              () {
                selectIndex = index;
                final selectedPlan = plans[index];
                if (selectedPlan.id != null) {
                  request.company.providerData
                      .setSubscriptionPlanId(selectedPlan.id!);
                }
                final maxUsers = selectedPlan.rules != null &&
                        selectedPlan.rules!.isNotEmpty
                    ? selectedPlan.rules!.first.upperLimit
                    : null;
                request.company.providerData.setMaxUsers(maxUsers);

                setState(() {});
              },
              borderRadius: radius(16),
            ).paddingSymmetric(horizontal: 16, vertical: 4);
          },
        )
      ],
    ).paddingBottom(16);
  }
}
