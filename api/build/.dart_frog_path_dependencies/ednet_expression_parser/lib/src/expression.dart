import 'evaluation_context.dart';

/// Core expression interface for boolean expressions
abstract class Expression {
  /// Evaluate this expression with the given context
  bool evaluate(EvaluationContext context);

  /// Get the source string representation of this expression
  String get source;

  /// Get all variable names referenced in this expression
  Set<String> getVariables();

  /// Check if this expression is mathematically equivalent to another
  bool isEquivalentTo(Expression other);
}

/// A simple boolean literal expression
class LiteralExpression extends Expression {
  final bool value;

  LiteralExpression(this.value);

  @override
  bool evaluate(EvaluationContext context) => value;

  @override
  String get source => value.toString();

  @override
  Set<String> getVariables() => <String>{};

  @override
  bool isEquivalentTo(Expression other) {
    return other is LiteralExpression && other.value == value;
  }

  @override
  String toString() => source;
}

/// A property access expression (e.g., user.age)
class PropertyExpression extends Expression {
  final String propertyPath;

  PropertyExpression(this.propertyPath);

  @override
  bool evaluate(EvaluationContext context) {
    final value = context.getValue(propertyPath);
    if (value is bool) return value;
    if (value is String) return value.isNotEmpty;
    if (value is num) return value != 0;
    return value != null;
  }

  @override
  String get source => propertyPath;

  @override
  Set<String> getVariables() => {propertyPath};

  @override
  bool isEquivalentTo(Expression other) {
    return other is PropertyExpression && other.propertyPath == propertyPath;
  }

  @override
  String toString() => source;
}

/// A binary operation expression (e.g., a && b, x > 5)
class BinaryExpression extends Expression {
  final Expression left;
  final Expression right;
  final String operator;

  BinaryExpression(this.left, this.operator, this.right);

  @override
  bool evaluate(EvaluationContext context) {
    switch (operator) {
      case '&&':
        return left.evaluate(context) && right.evaluate(context);
      case '||':
        return left.evaluate(context) || right.evaluate(context);
      case '==':
        return _evaluateComparison(context, (a, b) => a == b);
      case '!=':
        return _evaluateComparison(context, (a, b) => a != b);
      case '>':
        return _evaluateComparison(context, (a, b) => _compare(a, b) > 0);
      case '<':
        return _evaluateComparison(context, (a, b) => _compare(a, b) < 0);
      case '>=':
        return _evaluateComparison(context, (a, b) => _compare(a, b) >= 0);
      case '<=':
        return _evaluateComparison(context, (a, b) => _compare(a, b) <= 0);
      default:
        throw UnsupportedError('Unknown operator: $operator');
    }
  }

  bool _evaluateComparison(
    EvaluationContext context,
    bool Function(Object?, Object?) compare,
  ) {
    final leftValue = _getRawValue(left, context);
    final rightValue = _getRawValue(right, context);
    return compare(leftValue, rightValue);
  }

  dynamic _getRawValue(Expression expr, EvaluationContext context) {
    if (expr is PropertyExpression) {
      return context.getValue(expr.propertyPath);
    } else if (expr is LiteralExpression) {
      return expr.value;
    } else {
      // For other expression types, try to get the raw value through source parsing
      final source = expr.source;
      if (source.startsWith('"') && source.endsWith('"')) {
        return source.substring(1, source.length - 1);
      }
      final numValue = num.tryParse(source);
      if (numValue != null) {
        return numValue;
      }
      return expr.evaluate(context);
    }
  }

  int _compare(Object? a, Object? b) {
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    if (a is String && b is String) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  @override
  String get source => '${left.source} $operator ${right.source}';

  @override
  Set<String> getVariables() => {
    ...left.getVariables(),
    ...right.getVariables(),
  };

  @override
  bool isEquivalentTo(Expression other) {
    if (other is! BinaryExpression) return false;
    return operator == other.operator &&
        left.isEquivalentTo(other.left) &&
        right.isEquivalentTo(other.right);
  }

  @override
  String toString() => source;
}

/// A unary operation expression (e.g., !expr)
class UnaryExpression extends Expression {
  final Expression operand;
  final String operator;

  UnaryExpression(this.operator, this.operand);

  @override
  bool evaluate(EvaluationContext context) {
    switch (operator) {
      case '!':
        return !operand.evaluate(context);
      default:
        throw UnsupportedError('Unknown unary operator: $operator');
    }
  }

  @override
  String get source => '$operator${operand.source}';

  @override
  Set<String> getVariables() => operand.getVariables();

  @override
  bool isEquivalentTo(Expression other) {
    return other is UnaryExpression &&
        operator == other.operator &&
        operand.isEquivalentTo(other.operand);
  }

  @override
  String toString() => source;
}
