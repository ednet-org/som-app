import 'arr.dart';
import 'i_filter.dart';

class Filter<T extends Arr> extends IFilter<T> {
  Filter({
    required String name,
    required T value,
    required List<FilterOperand> operands,
    DisplayMode mode = DisplayMode.input,
    List<T>? allowedValues,
    Operand connectingOperand = Operand.and,
  }) {
    this.name = name;
    this.value = value;
    this.operands = operands;
    this.mode = mode;
    this.allowedValues = allowedValues;
    this.connectingOperand = connectingOperand;
  }

  bool equals(String name, String value) {
    return this.name == name && this.value == value;
  }

  static Filter greaterThan(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.greaterThan],
    );
  }

  static Filter greaterThanOrEquals(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.greaterThanOrEquals],
    );
  }

  static Filter lessThan(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.lessThan],
    );
  }

  static Filter lessThanOrEquals(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.lessThanOrEquals],
    );
  }

  static Filter contains(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.contains],
    );
  }

  static Filter startsWith(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.startsWith],
    );
  }

  static Filter endsWith(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.endsWith],
    );
  }

  static Filter between(String name, String value) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: value,
      ),
      operands: [FilterOperand.between],
    );
  }

  static Filter isNull(String name) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: null,
      ),
      operands: [FilterOperand.isNull],
    );
  }

  static Filter isEmpty(String name) {
    return Filter(
      name: name,
      value: Arr<String>(
        name: name,
        value: '',
      ),
      operands: [FilterOperand.isEmpty],
    );
  }
}
