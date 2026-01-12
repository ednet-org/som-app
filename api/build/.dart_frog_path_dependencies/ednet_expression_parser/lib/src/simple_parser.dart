import 'expression.dart';
import 'evaluation_context.dart';
import 'parse_exception.dart';

/// Simple expression parser for EDNet policy expressions
class ExpressionParser {
  /// Parse an expression from a string
  static Expression parse(String source) {
    return _SimpleParser(source).parseExpression();
  }

  /// Parse and validate an expression
  static Expression parseAndValidate(
    String source, {
    EvaluationContext? context,
  }) {
    final expression = parse(source);

    // Basic validation
    if (context != null) {
      final variables = expression.getVariables();
      for (final variable in variables) {
        if (!context.hasVariable(variable)) {
          throw ParseException('Undefined variable: $variable', source: source);
        }
      }
    }

    return expression;
  }
}

/// Internal parser implementation
class _SimpleParser {
  final String source;
  final List<String> tokens;
  int position = 0;

  _SimpleParser(this.source) : tokens = _tokenize(source);

  /// Tokenize the source string into a list of tokens
  static List<String> _tokenize(String source) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    var inString = false;

    for (var i = 0; i < source.length; i++) {
      final char = source[i];

      if (char == '"' || char == "'") {
        if (inString) {
          buffer.write(char);
          tokens.add(buffer.toString());
          buffer.clear();
          inString = false;
        } else {
          if (buffer.isNotEmpty) {
            tokens.add(buffer.toString().trim());
            buffer.clear();
          }
          buffer.write(char);
          inString = true;
        }
      } else if (inString) {
        buffer.write(char);
      } else if (char == ' ' || char == '\t' || char == '\n') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString().trim());
          buffer.clear();
        }
      } else if (_isOperatorChar(char)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString().trim());
          buffer.clear();
        }

        // Handle multi-character operators
        var operator = char;
        if (i + 1 < source.length) {
          final nextChar = source[i + 1];
          final twoChar = char + nextChar;
          if (_isMultiCharOperator(twoChar)) {
            operator = twoChar;
            i++; // Skip next character
          }
        }
        tokens.add(operator);
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString().trim());
    }

    return tokens.where((token) => token.isNotEmpty).toList();
  }

  static bool _isOperatorChar(String char) {
    return '()!&|=<>'.contains(char);
  }

  static bool _isMultiCharOperator(String twoChar) {
    return ['&&', '||', '==', '!=', '<=', '>='].contains(twoChar);
  }

  /// Parse the main expression
  Expression parseExpression() {
    if (tokens.isEmpty) {
      throw ParseException('Empty expression', source: source);
    }

    final expr = _parseOrExpression();

    if (position < tokens.length) {
      throw ParseException(
        'Unexpected token: ${tokens[position]}',
        source: source,
      );
    }

    return expr;
  }

  /// Parse OR expression (lowest precedence)
  Expression _parseOrExpression() {
    var expr = _parseAndExpression();

    while (position < tokens.length && tokens[position] == '||') {
      position++; // consume ||
      final right = _parseAndExpression();
      expr = BinaryExpression(expr, '||', right);
    }

    return expr;
  }

  /// Parse AND expression
  Expression _parseAndExpression() {
    var expr = _parseEqualityExpression();

    while (position < tokens.length && tokens[position] == '&&') {
      position++; // consume &&
      final right = _parseEqualityExpression();
      expr = BinaryExpression(expr, '&&', right);
    }

    return expr;
  }

  /// Parse equality expression (==, !=)
  Expression _parseEqualityExpression() {
    var expr = _parseRelationalExpression();

    while (position < tokens.length &&
        ['==', '!='].contains(tokens[position])) {
      final operator = tokens[position];
      position++; // consume operator
      final right = _parseRelationalExpression();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  /// Parse relational expression (>, <, >=, <=)
  Expression _parseRelationalExpression() {
    var expr = _parseUnaryExpression();

    while (position < tokens.length &&
        ['>', '<', '>=', '<='].contains(tokens[position])) {
      final operator = tokens[position];
      position++; // consume operator
      final right = _parseUnaryExpression();
      expr = BinaryExpression(expr, operator, right);
    }

    return expr;
  }

  /// Parse unary expression (!)
  Expression _parseUnaryExpression() {
    if (position < tokens.length && tokens[position] == '!') {
      position++; // consume !
      final operand = _parseUnaryExpression();
      return UnaryExpression('!', operand);
    }

    return _parsePrimaryExpression();
  }

  /// Parse primary expression (literals, properties, parentheses)
  Expression _parsePrimaryExpression() {
    if (position >= tokens.length) {
      throw ParseException('Expected expression', source: source);
    }

    final token = tokens[position];

    // Parentheses
    if (token == '(') {
      position++; // consume (
      final expr = _parseOrExpression();
      if (position >= tokens.length || tokens[position] != ')') {
        throw ParseException('Expected closing parenthesis', source: source);
      }
      position++; // consume )
      return expr;
    }

    // Boolean literals
    if (token == 'true') {
      position++;
      return LiteralExpression(true);
    }
    if (token == 'false') {
      position++;
      return LiteralExpression(false);
    }

    // String literals
    if (token.startsWith('"') || token.startsWith("'")) {
      position++;
      final value = token.substring(1, token.length - 1);
      return _StringLiteral(value);
    }

    // Number literals
    if (_isNumber(token)) {
      position++;
      final value = num.parse(token);
      return _NumberLiteral(value);
    }

    // Property access
    if (_isIdentifier(token)) {
      position++;
      return PropertyExpression(token);
    }

    throw ParseException('Unexpected token: $token', source: source);
  }

  bool _isNumber(String token) {
    return num.tryParse(token) != null;
  }

  bool _isIdentifier(String token) {
    if (token.isEmpty) return false;
    if (!RegExp(r'^[a-zA-Z_]').hasMatch(token[0])) return false;
    return RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(token);
  }
}

/// String literal expression
class _StringLiteral extends Expression {
  final String value;

  _StringLiteral(this.value);

  @override
  bool evaluate(EvaluationContext context) => value.isNotEmpty;

  @override
  String get source => '"$value"';

  @override
  Set<String> getVariables() => <String>{};

  @override
  bool isEquivalentTo(Expression other) {
    return other is _StringLiteral && other.value == value;
  }

  /// Get the string value for comparison operations
  String get stringValue => value;

  @override
  String toString() => source;
}

/// Number literal expression
class _NumberLiteral extends Expression {
  final num value;

  _NumberLiteral(this.value);

  @override
  bool evaluate(EvaluationContext context) => value != 0;

  @override
  String get source => value.toString();

  @override
  Set<String> getVariables() => <String>{};

  @override
  bool isEquivalentTo(Expression other) {
    return other is _NumberLiteral && other.value == value;
  }

  /// Get the numeric value for comparison operations
  num get numericValue => value;

  @override
  String toString() => source;
}
