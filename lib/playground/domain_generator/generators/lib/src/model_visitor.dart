import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor2.dart';

class ModelVisitor extends SimpleElementVisitor2<void> {
  String? className;

  Map<String, dynamic> fields = <String, dynamic>{};

  @override
  void visitConstructorElement(ConstructorElement element) {
    final elementReturnType =
        element.type.returnType.getDisplayString(withNullability: true);

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    className = elementReturnType.replaceFirst('*', '');
  }

  @override
  void visitFieldElement(FieldElement element) {
    final elementType =
        element.type.getDisplayString(withNullability: true);
    final name = element.name;
    if (name == null) {
      return;
    }

    // DartType ends with '*', which needs to be eliminated
    // for the generated code to be accurate.
    fields[name] = elementType.replaceFirst('*', '');
  }
}
