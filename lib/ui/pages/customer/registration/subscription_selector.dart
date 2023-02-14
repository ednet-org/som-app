import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/pages/customer/registration/plan_modal.dart';

import '../../../domain/infrastructure/future_store.dart';
import '../../../domain/model/shared/som.dart';

class SubscriptionSelector extends StatefulWidget {
  const SubscriptionSelector({Key? key}) : super(key: key);

  @override
  State<SubscriptionSelector> createState() => _SubscriptionSelectorState();
}

class _SubscriptionSelectorState extends State<SubscriptionSelector> {
  List<PlanModal> periodModal = [];
  int selectIndex = 0;

  int containerIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    periodModal.add(
      PlanModal(
        title: 'SOM Standard',
        subTitle: "€ 39,90 / Monat",
        optionList: [
          PlanModal(title: '1 Benutzer anlegen'),
          PlanModal(title: 'keine Werbeanzeigen bei SOM Ads'),
          PlanModal(
              title:
                  'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
        ],
        price: '€ 39,90 / Monat + Einrichtungspauschale € 49,-',
      ),
    );
    periodModal.add(PlanModal(
      title: 'SOM Premium',
      subTitle: '€ 79,90 / Monat',
      optionList: [
        PlanModal(title: 'bis zu 5 Benutzer anlegen'),
        PlanModal(
            title:
                '1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So)'),
        PlanModal(title: 'Detaillierte Statistik mit Exportmöglichkeit'),
        PlanModal(
            title:
                'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
        PlanModal(title: 'die ersten zwei Monate Gratis'),
      ],
      price: '€ 79,90 / Monat, Einrichtungspauschale entfällt',
    ));
    periodModal.add(
      PlanModal(
        title: 'SOM Enterprise',
        subTitle: '€ 149,90 / Monat',
        optionList: [
          PlanModal(
              title: 'bis zu 15 Benutzer anlegen',
              subTitle: '(jeder weitere Benutzer kostet €10,-)'),
          PlanModal(
              title:
                  '1 Werbeanzeige pro Monat bei SOM Ads für min zwei Wochen (Mo-So)'),
          PlanModal(
              title: '1 Banneranzeige pro Monatbei SOM Ads für einen Tag'),
          PlanModal(title: 'Detaillierte Statistik mit Exportmöglichkeit'),
          PlanModal(
              title:
                  'Zentrales Management Ihrer Firmen & User-Daten durch den Adminuser'),
          PlanModal(title: 'die ersten zwei Monate Gratis'),
        ],
        price: '€ 149,90 / Monat, Einrichtungspauschale entfällt',
      ),
    );
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
    if (som.availableSubscriptions.futureState == FutureState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // // show empty message
    // if ((som.availableSubscriptions.data?.length ?? 0) == 0) {
    //   return const Center(child: Text("No subscription plans found."));
    // }

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
