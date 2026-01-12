/// Real expression parser integration for EDNet Core.
///
/// This implementation replaces the original stub with the actual
/// ednet_expression_parser package, enabling full boolean expression
/// evaluation for policies and business rules.

import 'package:ednet_expression_parser/ednet_expression_parser.dart' as parser;
import 'package:ednet_core/ednet_core.dart';

/// Represents a parsed expression using the EDNet expression parser.
class Expression {
  final String source;
  final parser.Expression _parsedExpression;

  Expression.parse(this.source)
    : _parsedExpression = parser.ExpressionParser.parse(source);

  /// Get the underlying parsed expression for advanced operations
  parser.Expression get parsedExpression => _parsedExpression;
}

/// Expression evaluator using the EDNet expression parser.
///
/// This implementation provides full boolean expression evaluation
/// supporting comparison operators, logical operators, and property access.
class ExpressionEvaluator with ObservabilityMixin {
  @override
  String get componentName => 'ExpressionEvaluator';

  /// Evaluates an expression with the given context
  dynamic eval(Expression expression, Map<String, dynamic> context) {
    try {
      final evaluationContext = parser.EvaluationContext(context);
      return expression._parsedExpression.evaluate(evaluationContext);
    } catch (e) {
      // For backward compatibility, return false on evaluation errors
      // but log the error for debugging
      observabilityWarning(
        'expressionEvaluationFailed',
        context: {'expression': expression.source, 'error': e.toString()},
      );

      // Fallback to simple literal evaluation for compatibility
      final trimmed = expression.source.trim();
      if (trimmed.toLowerCase() == 'false') return false;
      if (trimmed.toLowerCase() == 'true') return true;

      // If expression parsing fails, assume it evaluates to false for safety
      return false;
    }
  }

  /// Validates an expression without evaluating it
  bool validateExpression(String expressionSource) {
    try {
      parser.ExpressionParser.parse(expressionSource);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all variables referenced in an expression
  Set<String> getExpressionVariables(String expressionSource) {
    try {
      final expression = parser.ExpressionParser.parse(expressionSource);
      return expression.getVariables();
    } catch (e) {
      return <String>{};
    }
  }
}
