import 'package:test/test.dart';
import 'package:ednet_expression_parser/ednet_expression_parser.dart';

void main() {
  group('ExpressionParser', () {
    test('parses simple boolean literals', () {
      expect(ExpressionParser.parse('true'), isA<LiteralExpression>());
      expect(ExpressionParser.parse('false'), isA<LiteralExpression>());
    });

    test('parses property access', () {
      final expr = ExpressionParser.parse('user.age');
      expect(expr, isA<PropertyExpression>());
      expect((expr as PropertyExpression).propertyPath, equals('user.age'));
    });

    test('parses binary expressions', () {
      final expr = ExpressionParser.parse('user.age >= 18');
      expect(expr, isA<BinaryExpression>());
      final binary = expr as BinaryExpression;
      expect(binary.operator, equals('>='));
    });

    test('parses unary expressions', () {
      final expr = ExpressionParser.parse('!user.disabled');
      expect(expr, isA<UnaryExpression>());
      final unary = expr as UnaryExpression;
      expect(unary.operator, equals('!'));
    });

    test('respects operator precedence', () {
      final expr = ExpressionParser.parse('a || b && c');
      expect(expr, isA<BinaryExpression>());
      final or = expr as BinaryExpression;
      expect(or.operator, equals('||'));
      expect(or.right, isA<BinaryExpression>());
    });

    test('handles parentheses', () {
      final expr = ExpressionParser.parse('(a || b) && c');
      expect(expr, isA<BinaryExpression>());
      final and = expr as BinaryExpression;
      expect(and.operator, equals('&&'));
    });
  });

  group('Expression Evaluation', () {
    late EvaluationContext context;

    setUp(() {
      context = EvaluationContext({
        'user': {'age': 25, 'verified': true, 'name': 'John Doe'},
        'order': {'amount': 150.0},
      });
    });

    test('evaluates boolean literals', () {
      expect(ExpressionParser.parse('true').evaluate(context), isTrue);
      expect(ExpressionParser.parse('false').evaluate(context), isFalse);
    });

    test('evaluates property access', () {
      expect(ExpressionParser.parse('user.verified').evaluate(context), isTrue);
      expect(
        ExpressionParser.parse('user.age').evaluate(context),
        isTrue,
      ); // 25 != 0
    });

    test('evaluates comparisons', () {
      expect(
        ExpressionParser.parse('user.age >= 18').evaluate(context),
        isTrue,
      );
      expect(
        ExpressionParser.parse('user.age < 18').evaluate(context),
        isFalse,
      );
      expect(
        ExpressionParser.parse('order.amount > 100').evaluate(context),
        isTrue,
      );
    });

    test('evaluates logical operations', () {
      expect(
        ExpressionParser.parse(
          'user.verified && user.age >= 18',
        ).evaluate(context),
        isTrue,
      );
      expect(
        ExpressionParser.parse(
          'user.verified || user.age < 18',
        ).evaluate(context),
        isTrue,
      );
      expect(
        ExpressionParser.parse('!user.verified').evaluate(context),
        isFalse,
      );
    });

    test('evaluates string comparisons', () {
      expect(
        ExpressionParser.parse('user.name == "John Doe"').evaluate(context),
        isTrue,
      );
      expect(
        ExpressionParser.parse('user.name != "Jane"').evaluate(context),
        isTrue,
      );
    });
  });

  group('Expression Variables', () {
    test('extracts variables', () {
      final expr = ExpressionParser.parse(
        'user.verified && order.amount > 100',
      );
      final variables = expr.getVariables();
      expect(variables, contains('user.verified'));
      expect(variables, contains('order.amount'));
    });

    test('excludes literals', () {
      final expr = ExpressionParser.parse('user.age >= 18');
      final variables = expr.getVariables();
      expect(variables, equals({'user.age'}));
    });
  });

  group('Validation', () {
    test('validates expressions with context', () {
      final context = EvaluationContext({
        'user': {'age': 25},
      });
      final expr = ExpressionParser.parse('user.age >= 18');
      final result = ExpressionValidator.validate(expr, context: context);
      expect(result.isValid, isTrue);
    });

    test('detects undefined variables', () {
      final context = EvaluationContext({});
      final expr = ExpressionParser.parse('user.age >= 18');
      final result = ExpressionValidator.validate(expr, context: context);
      expect(result.isValid, isFalse);
      expect(result.issues, contains(contains('Undefined variable')));
    });
  });

  group('Error Handling', () {
    test('throws on invalid syntax', () {
      expect(
        () => ExpressionParser.parse('user.age >='),
        throwsA(isA<ParseException>()),
      );
      expect(
        () => ExpressionParser.parse('&&'),
        throwsA(isA<ParseException>()),
      );
      expect(
        () => ExpressionParser.parse('(unclosed'),
        throwsA(isA<ParseException>()),
      );
    });

    test('throws on empty expression', () {
      expect(() => ExpressionParser.parse(''), throwsA(isA<ParseException>()));
      expect(
        () => ExpressionParser.parse('   '),
        throwsA(isA<ParseException>()),
      );
    });
  });
}
