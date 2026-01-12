import 'expression.dart';
import 'evaluation_context.dart';

/// Simple validator for expressions
class ExpressionValidator {
  /// Validate an expression
  static ValidationResult validate(
    Expression expression, {
    EvaluationContext? context,
  }) {
    final issues = <String>[];

    // Check for undefined variables
    if (context != null) {
      final variables = expression.getVariables();
      for (final variable in variables) {
        if (!context.hasVariable(variable)) {
          issues.add('Undefined variable: $variable');
        }
      }
    }

    // Check for common logical issues
    _checkLogicalIssues(expression, issues);

    return ValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      variables: expression.getVariables(),
    );
  }

  static void _checkLogicalIssues(Expression expression, List<String> issues) {
    if (expression is BinaryExpression) {
      // Check for always true/false conditions
      if (expression.left is LiteralExpression &&
          expression.right is LiteralExpression) {
        final leftLit = expression.left as LiteralExpression;
        final rightLit = expression.right as LiteralExpression;

        switch (expression.operator) {
          case '&&':
            if (!leftLit.value || !rightLit.value) {
              issues.add(
                'Expression "${expression.source}" always evaluates to false',
              );
            }
            break;
          case '||':
            if (leftLit.value || rightLit.value) {
              issues.add(
                'Expression "${expression.source}" always evaluates to true',
              );
            }
            break;
        }
      }

      // Recursively check sub-expressions
      _checkLogicalIssues(expression.left, issues);
      _checkLogicalIssues(expression.right, issues);
    } else if (expression is UnaryExpression) {
      _checkLogicalIssues(expression.operand, issues);
    }
  }
}

/// Result of expression validation
class ValidationResult {
  final bool isValid;
  final List<String> issues;
  final Set<String> variables;

  ValidationResult({
    required this.isValid,
    required this.issues,
    required this.variables,
  });

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult: Valid (${variables.length} variables)';
    } else {
      return 'ValidationResult: Invalid (${issues.length} issues)';
    }
  }
}
