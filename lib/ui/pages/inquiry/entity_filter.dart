import 'package:flutter/material.dart';
import 'package:som/ui/components/forms/som_text_input.dart';
import 'package:som/ui/utils/AppWidget.dart';

import 'i_filter.dart';

class EntityFilter<T extends IFilter> extends StatelessWidget {
  final T filter;

  const EntityFilter(
    this.filter, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    getRender();

    return SizedBox(
      width: 295,
      child: Column(
        children: [],
      ),
    );
  }

  Widget getRender() {
    switch (filter.mode) {
      case DisplayMode.label:
        return Text(filter.name.toString());

        break;
      case DisplayMode.input:
        return SomTextInput(
          key: key,
          label: filter.toString(),
          onChanged: (value) {
            print(value);
          },
        );
      case DisplayMode.dropdown:
        return DropdownButton(
            items: filter.allowedValues
                ?.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString()),
                    ))
                .toList(),
            onChanged: (value) {
              print(value);
            });
      case DisplayMode.checkbox:
        return Checkbox(
          value: filter.value as bool,
          onChanged: (value) {
            print(value);
          },
        );
      default:
        return Text(filter.name.toString());

      // case DisplayMode.checkbox:
      //   render = _renderCheckbox();
      //   break;
      // case DisplayMode.radio:
      //   render = _renderRadio();
      //   break;
      // case DisplayMode.date:
      //   render = _renderDate();
      //   break;
      // case DisplayMode.dateRange:
      //   render = _renderDateRange();
      //   break;
      // case DisplayMode.time:
      //   render = _renderTime();
      //   break;
      // case DisplayMode.timeRange:
      //   render = _renderTimeRange();
      //   break;
      // case DisplayMode.dateTime:
      //   render = _renderDateTime();
      //   break;
      // case DisplayMode.dateTimeRange:
      //   render = _renderDateTimeRange();
      //   break;
      // case DisplayMode.slider:
      //   render = _renderSlider();
      //   break;
      // case DisplayMode.switch:
      //   render = _renderSwitch();
      //   break;
      //
    }
  }
}
