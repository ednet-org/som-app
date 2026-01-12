import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('ConceptValueObject', () {
    late Domain domain;
    late Model model;
    late Concept moneyConcept;
    late Concept addressConcept;

    setUp(() {
      domain = Domain('Commerce');
      model = Model(domain, 'Catalog');

      // Define Money concept
      moneyConcept = Concept(model, 'Money');
      Attribute(moneyConcept, 'amount')
        ..type = domain.getType('double')
        ..required = true;
      Attribute(moneyConcept, 'currency')
        ..type = domain.getType('String')
        ..required = true;

      // Define Address concept
      addressConcept = Concept(model, 'Address');
      Attribute(addressConcept, 'street')
        ..type = domain.getType('String')
        ..required = true;
      Attribute(addressConcept, 'city')
        ..type = domain.getType('String')
        ..required = true;
      Attribute(addressConcept, 'zipCode')
        ..type = domain.getType('String')
        ..required = false;
    });

    test('creates value object with concept', () {
      final money = ConceptValueObject(moneyConcept);

      expect(money.concept, equals(moneyConcept));
      expect(money.concept.code, equals('Money'));
    });

    test('sets and gets attributes', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      expect(money.getAttribute('amount'), equals(100.0));
      expect(money.getAttribute('currency'), equals('USD'));
    });

    test('throws when setting non-existent attribute', () {
      final money = ConceptValueObject(moneyConcept);

      expect(
        () => money.setAttribute('nonExistent', 'value'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when setting required attribute to null', () {
      final money = ConceptValueObject(moneyConcept);

      expect(
        () => money.setAttribute('amount', null),
        throwsA(isA<ValidationException>()),
      );
    });

    test('allows setting optional attribute to null', () {
      final address = ConceptValueObject(addressConcept)
        ..setAttribute('street', '123 Main St')
        ..setAttribute('city', 'NYC')
        ..setAttribute('zipCode', null);

      expect(address.getAttribute('zipCode'), isNull);
    });

    test('implements value equality - same values', () {
      final money1 = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final money2 = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      expect(money1, equals(money2));
      expect(money1.hashCode, equals(money2.hashCode));
    });

    test('implements value inequality - different values', () {
      final money1 = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final money2 = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'EUR');

      expect(money1, isNot(equals(money2)));
    });

    test('implements value inequality - different concepts', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final address = ConceptValueObject(addressConcept)
        ..setAttribute('street', '123 Main St')
        ..setAttribute('city', 'NYC');

      expect(money, isNot(equals(address)));
    });

    test('copyWith creates new instance with updated values', () {
      final dollars = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final euros = dollars.copyWith({'currency': 'EUR'});

      expect(euros.getAttribute('currency'), equals('EUR'));
      expect(euros.getAttribute('amount'), equals(100.0));
      expect(
        dollars.getAttribute('currency'),
        equals('USD'),
      ); // Original unchanged
    });

    test('copyWith creates new instance with multiple updates', () {
      final original = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final updated = original.copyWith({'amount': 200.0, 'currency': 'EUR'});

      expect(updated.getAttribute('amount'), equals(200.0));
      expect(updated.getAttribute('currency'), equals('EUR'));
      expect(
        original.getAttribute('amount'),
        equals(100.0),
      ); // Original unchanged
      expect(
        original.getAttribute('currency'),
        equals('USD'),
      ); // Original unchanged
    });

    test('validates required attributes', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0);
      // Missing required 'currency'

      expect(() => money.validate(), throwsA(isA<ValidationExceptions>()));
    });

    test('validates successfully when all required attributes set', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      expect(() => money.validate(), returnsNormally);
    });

    test('toJson serializes to map', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final json = money.toJson();

      expect(json['_type'], equals('Money'));
      expect(json['amount'], equals(100.0));
      expect(json['currency'], equals('USD'));
    });

    test('fromJson deserializes from map', () {
      final json = {'amount': 100.0, 'currency': 'USD'};

      final money = ConceptValueObject.fromJson(json, moneyConcept);

      expect(money.getAttribute('amount'), equals(100.0));
      expect(money.getAttribute('currency'), equals('USD'));
    });

    test('fromJson ignores unknown attributes', () {
      final json = {
        'amount': 100.0,
        'currency': 'USD',
        'unknownField': 'ignored',
      };

      final money = ConceptValueObject.fromJson(json, moneyConcept);

      expect(money.getAttribute('amount'), equals(100.0));
      expect(money.getAttribute('currency'), equals('USD'));
      expect(money.attributeCodes.contains('unknownField'), isFalse);
    });

    test('toString provides readable representation', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final str = money.toString();

      expect(str, contains('Money'));
      expect(str, contains('amount'));
      expect(str, contains('100.0'));
      expect(str, contains('currency'));
      expect(str, contains('USD'));
    });

    test('attributeCodes returns all attribute codes', () {
      final money = ConceptValueObject(moneyConcept);

      final codes = money.attributeCodes;

      expect(codes, contains('amount'));
      expect(codes, contains('currency'));
      expect(codes.length, equals(2));
    });

    test('attributeValues returns unmodifiable map', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      final values = money.attributeValues;

      expect(values['amount'], equals(100.0));
      expect(values['currency'], equals('USD'));
      expect(() => values['amount'] = 200.0, throwsUnsupportedError);
    });

    test('initializes attributes with default values', () {
      final conceptWithDefaults = Concept(model, 'ConfigWithDefaults');
      Attribute(conceptWithDefaults, 'enabled')
        ..type = domain.getType('bool')
        ..init = 'true';
      Attribute(conceptWithDefaults, 'count')
        ..type = domain.getType('int')
        ..init = '5';
      Attribute(conceptWithDefaults, 'name')
        ..type = domain.getType('String')
        ..init = 'default';

      final config = ConceptValueObject(conceptWithDefaults);

      expect(config.getAttribute('enabled'), equals(true));
      expect(config.getAttribute('count'), equals(5));
      expect(config.getAttribute('name'), equals('default'));
    });

    test('handles DateTime attribute with "now" init', () {
      final conceptWithTimestamp = Concept(model, 'EventWithTimestamp');
      Attribute(conceptWithTimestamp, 'createdAt')
        ..type = domain.getType('DateTime')
        ..init = 'now';

      final event = ConceptValueObject(conceptWithTimestamp);

      expect(event.getAttribute('createdAt'), isA<DateTime>());
    });

    test('supports nested value objects in JSON', () {
      final orderConcept = Concept(model, 'Order');
      Attribute(orderConcept, 'total')..type = domain.getType('double');

      final order = ConceptValueObject(orderConcept);
      final price = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      order.setAttribute('total', price);

      final json = order.toJson();
      expect(json['total'], isA<Map>());
      expect(json['total']['_type'], equals('Money'));
      expect(json['total']['amount'], equals(100.0));
    });

    test('identical instances are equal', () {
      final money = ConceptValueObject(moneyConcept)
        ..setAttribute('amount', 100.0)
        ..setAttribute('currency', 'USD');

      expect(money, equals(money));
    });

    test('multi-domain scenario - HR domain', () {
      final hrDomain = Domain('HumanResources');
      final hrModel = Model(hrDomain, 'Core');

      final salaryConcept = Concept(hrModel, 'Salary');
      Attribute(salaryConcept, 'amount')
        ..type = hrDomain.getType('double')
        ..required = true;
      Attribute(salaryConcept, 'currency')
        ..type = hrDomain.getType('String')
        ..required = true;
      Attribute(salaryConcept, 'period')
        ..type = hrDomain.getType('String')
        ..required = true;

      final salary = ConceptValueObject(salaryConcept)
        ..setAttribute('amount', 5000.0)
        ..setAttribute('currency', 'USD')
        ..setAttribute('period', 'monthly');

      expect(salary.concept.code, equals('Salary'));
      expect(salary.getAttribute('period'), equals('monthly'));
      expect(salary.attributeCodes.length, equals(3));
    });
  });
}
