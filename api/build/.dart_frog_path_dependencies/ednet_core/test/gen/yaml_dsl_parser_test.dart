import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Enhanced YAML DSL Parser', () {
    late Domain domain;
    late Model model;

    setUp(() {
      domain = Domain('TestDomain');
    });

    group('Attribute: required field', () {
      test('should parse required: true', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: email
        type: string
        required: true
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        expect(userConcept, isNotNull);

        final emailAttribute =
            userConcept!.attributes.singleWhereCode('email') as Attribute?;
        expect(emailAttribute, isNotNull);
        expect(emailAttribute!.required, isTrue);
        expect(emailAttribute.minc, equals('1'));
      });

      test('should parse required: false', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: nickname
        type: string
        required: false
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final nicknameAttribute =
            userConcept!.attributes.singleWhereCode('nickname') as Attribute?;
        expect(nicknameAttribute!.required, isFalse);
        expect(nicknameAttribute.minc, equals('0'));
      });
    });

    group('Attribute: default field', () {
      test('should parse string default value', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: language
        type: string
        default: "en"
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final languageAttribute =
            userConcept!.attributes.singleWhereCode('language') as Attribute?;
        expect(languageAttribute!.init, equals('en'));
      });

      test('should parse boolean default value', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: isActive
        type: bool
        default: true
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final isActiveAttribute =
            userConcept!.attributes.singleWhereCode('isActive') as Attribute?;
        expect(isActiveAttribute!.init, isTrue);
      });

      test('should parse numeric default value', () {
        final yamlString = '''
concepts:
  - name: Product
    attributes:
      - name: quantity
        type: int
        default: 0
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final productConcept = parsedModel.concepts.singleWhereCode('Product');
        final quantityAttribute =
            productConcept!.attributes.singleWhereCode('quantity')
                as Attribute?;
        expect(quantityAttribute!.init, equals(0));
      });

      test('should prefer default over init field', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: status
        type: string
        init: "old"
        default: "new"
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final statusAttribute =
            userConcept!.attributes.singleWhereCode('status') as Attribute?;
        expect(statusAttribute!.init, equals('new'));
      });
    });

    group('Attribute: enumValues field', () {
      test('should parse enumValues list', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: role
        type: string
        enumValues: ["admin", "user", "guest"]
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final roleAttribute =
            userConcept!.attributes.singleWhereCode('role') as Attribute?;
        expect(roleAttribute, isNotNull);
        expect(roleAttribute!.metadata, isNotNull);
        expect(roleAttribute.metadata!['enumValues'], isNotNull);
        expect(roleAttribute.metadata!['enumValues'], isA<List<String>>());
        expect(
          roleAttribute.metadata!['enumValues'],
          equals(['admin', 'user', 'guest']),
        );
      });

      test('should parse enumValues with default', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: status
        type: string
        enumValues: ["active", "inactive", "suspended"]
        default: "active"
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final statusAttribute =
            userConcept!.attributes.singleWhereCode('status') as Attribute?;
        expect(
          statusAttribute!.metadata!['enumValues'],
          equals(['active', 'inactive', 'suspended']),
        );
        expect(statusAttribute.init, equals('active'));
      });

      test('should handle numeric enumValues', () {
        final yamlString = '''
concepts:
  - name: Priority
    attributes:
      - name: level
        type: int
        enumValues: [1, 2, 3, 4, 5]
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final priorityConcept = parsedModel.concepts.singleWhereCode(
          'Priority',
        );
        final levelAttribute =
            priorityConcept!.attributes.singleWhereCode('level') as Attribute?;
        expect(
          levelAttribute!.metadata!['enumValues'],
          equals(['1', '2', '3', '4', '5']),
        );
      });
    });

    group('Attribute: unique field', () {
      test('should parse unique: true', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: email
        type: string
        unique: true
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final emailAttribute =
            userConcept!.attributes.singleWhereCode('email') as Attribute?;
        expect(emailAttribute!.identifier, isTrue);
        expect(emailAttribute.minc, equals('1'));
        expect(emailAttribute.maxc, equals('1'));
      });

      test('should parse unique: false', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: name
        type: string
        unique: false
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final nameAttribute =
            userConcept!.attributes.singleWhereCode('name') as Attribute?;
        expect(nameAttribute!.identifier, isFalse);
      });
    });

    group('Concept: aggregateRoot field', () {
      test('should parse aggregateRoot: true', () {
        final yamlString = '''
concepts:
  - name: Order
    aggregateRoot: true
    attributes:
      - name: orderId
        type: string
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final orderConcept = parsedModel.concepts.singleWhereCode('Order');
        expect(orderConcept, isNotNull);
        expect(orderConcept!.category, equals('AggregateRoot'));
      });

      test('should parse aggregateRoot: false', () {
        final yamlString = '''
concepts:
  - name: LineItem
    aggregateRoot: false
    attributes:
      - name: itemId
        type: string
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final lineItemConcept = parsedModel.concepts.singleWhereCode(
          'LineItem',
        );
        expect(lineItemConcept, isNotNull);
        expect(lineItemConcept!.category, isNot(equals('AggregateRoot')));
      });
    });

    group('Complex YAML DSL scenarios', () {
      test('should parse real-world PlatformUser concept', () {
        final yamlString = '''
concepts:
  - name: PlatformUser
    description: "Core platform user abstraction"
    entry: true
    aggregateRoot: true
    attributes:
      - name: userId
        type: string
        required: true
        unique: true
      - name: isActive
        type: bool
        required: true
        default: true
      - name: trustedFlaggerStatus
        type: string
        enumValues: ["None", "Applicant", "Verified", "Suspended"]
        default: "None"
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'CoreServices',
          yaml as Map,
        );

        final platformUserConcept = parsedModel.concepts.singleWhereCode(
          'PlatformUser',
        );
        expect(platformUserConcept, isNotNull);
        expect(platformUserConcept!.entry, isTrue);
        expect(platformUserConcept.category, equals('AggregateRoot'));

        // userId attribute
        final userIdAttribute =
            platformUserConcept.attributes.singleWhereCode('userId')
                as Attribute?;
        expect(userIdAttribute!.required, isTrue);
        expect(userIdAttribute.identifier, isTrue);

        // isActive attribute
        final isActiveAttribute =
            platformUserConcept.attributes.singleWhereCode('isActive')
                as Attribute?;
        expect(isActiveAttribute!.required, isTrue);
        expect(isActiveAttribute.init, isTrue);

        // trustedFlaggerStatus attribute
        final statusAttribute =
            platformUserConcept.attributes.singleWhereCode(
                  'trustedFlaggerStatus',
                )
                as Attribute?;
        expect(
          statusAttribute!.metadata!['enumValues'],
          equals(['None', 'Applicant', 'Verified', 'Suspended']),
        );
        expect(statusAttribute.init, equals('None'));
      });

      test('should handle multiple concepts with mixed features', () {
        final yamlString = '''
concepts:
  - name: Product
    aggregateRoot: true
    attributes:
      - name: sku
        type: string
        required: true
        unique: true
      - name: status
        type: string
        enumValues: ["draft", "published", "archived"]
        default: "draft"
  - name: Review
    attributes:
      - name: rating
        type: int
        required: true
        enumValues: [1, 2, 3, 4, 5]
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel('', domain, 'Catalog', yaml as Map);

        final productConcept = parsedModel.concepts.singleWhereCode('Product');
        expect(productConcept!.category, equals('AggregateRoot'));

        final skuAttribute =
            productConcept.attributes.singleWhereCode('sku') as Attribute?;
        expect(skuAttribute!.identifier, isTrue);

        final productStatusAttribute =
            productConcept.attributes.singleWhereCode('status') as Attribute?;
        expect(
          productStatusAttribute!.metadata!['enumValues'],
          equals(['draft', 'published', 'archived']),
        );

        final reviewConcept = parsedModel.concepts.singleWhereCode('Review');
        final ratingAttribute =
            reviewConcept!.attributes.singleWhereCode('rating') as Attribute?;
        expect(ratingAttribute!.required, isTrue);
        expect(
          ratingAttribute.metadata!['enumValues'],
          equals(['1', '2', '3', '4', '5']),
        );
      });
    });

    group('Backward compatibility', () {
      test('should still support category: required', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: email
        type: string
        category: required
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final emailAttribute =
            userConcept!.attributes.singleWhereCode('email') as Attribute?;
        expect(emailAttribute!.minc, equals('1'));
      });

      test('should still support init field', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: status
        type: string
        init: "active"
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final statusAttribute =
            userConcept!.attributes.singleWhereCode('status') as Attribute?;
        expect(statusAttribute!.init, equals('active'));
      });

      test('should still support category: identifier', () {
        final yamlString = '''
concepts:
  - name: User
    attributes:
      - name: userId
        type: string
        category: identifier
''';
        final yaml = loadYaml(yamlString);
        final parsedModel = fromJsonToModel(
          '',
          domain,
          'TestModel',
          yaml as Map,
        );

        final userConcept = parsedModel.concepts.singleWhereCode('User');
        final userIdAttribute =
            userConcept!.attributes.singleWhereCode('userId') as Attribute?;
        expect(userIdAttribute!.identifier, isTrue);
      });
    });
  });
}
