import 'package:som/ui/components/cards/inquiry/inquiry_card_components/arr.dart';

abstract class IFilter<T extends Arr> {
  late String name;
  late T value;
  late List<FilterOperand> operands;
  late DisplayMode mode;
  late List<T>? allowedValues;
  Operand connectingOperand = Operand.and;

  filter(List<T> items) {
    for (FilterOperand operand in operands) {
      switch (operand) {
        case FilterOperand.equals:
          items = items.where((item) => item.value == value).toList();
          break;
        case FilterOperand.greaterThan:
          items = items.where((item) => item.value > value).toList();
          break;
        case FilterOperand.greaterThanOrEquals:
          items = items.where((item) => item.value >= value).toList();
          break;
        case FilterOperand.lessThan:
          items = items.where((item) => item.value < value).toList();
          break;
        case FilterOperand.lessThanOrEquals:
          items = items.where((item) => item.value <= value).toList();
          break;
        case FilterOperand.contains:
          items = items.where((item) => item.value.contains(value)).toList();
          break;
        case FilterOperand.startsWith:
          items = items.where((item) => item.value.startsWith(value)).toList();
          break;
        case FilterOperand.endsWith:
          items = items.where((item) => item.value.endsWith(value)).toList();
          break;
        case FilterOperand.between:
          items = items
              .where((item) => item.value >= value && item.value <= value)
              .toList();
          break;
        case FilterOperand.isNull:
          items = items.where((item) => item.value == null).toList();
          break;
        case FilterOperand.isEmpty:
          items = items.where((item) => item.value.isEmpty).toList();
          break;
      }
    }
  }
}

enum SortDirection {
  ascending,
  descending,
}

class Sort {
  final String name;
  final String value;
  final SortDirection direction;

  const Sort({
    required this.name,
    required this.value,
    this.direction = SortDirection.ascending,
  });
}

enum FilterOperand {
  equals,
  greaterThan,
  greaterThanOrEquals,
  lessThan,
  lessThanOrEquals,
  contains,
  startsWith,
  endsWith,
  between,
  isNull,
  isEmpty,
}

enum Operand { and, or, not }

enum DisplayMode {
  label,
  dropdown,
  checkbox,
  input,
  list,
  grid,
}
