import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Business Primitive Algorithms Tests', () {
    late Domain domain;
    late Model model;
    late Concept customerConcept;
    late Entities customers;

    setUp(() {
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');

      // Create Customer concept for testing
      customerConcept = Concept(model, 'Customer');

      final nameAttr = Attribute(customerConcept, 'name');
      nameAttr.type = domain.getType('String');

      final emailAttr = Attribute(customerConcept, 'email');
      emailAttr.type = domain.getType('String');
      emailAttr.required = true;

      final ageAttr = Attribute(customerConcept, 'age');
      ageAttr.type = domain.getType('int');

      final isActiveAttr = Attribute(customerConcept, 'isActive');
      isActiveAttr.type = domain.getType('bool');

      final deletedAttr = Attribute(customerConcept, '_deleted');
      deletedAttr.type = domain.getType('bool');
      deletedAttr.required = false;

      customers = Entities<DynamicEntity>();
      customers.concept = customerConcept;
    });

    group('CRUD Operations Algorithm', () {
      test('create entity with validation should succeed for valid data', () {
        // Red: This should fail initially
        final crudAlgorithm = CrudOperationsAlgorithm();
        final input = CrudInput.create({
          'name': 'John Doe',
          'email': 'john@example.com',
          'age': 30,
          'isActive': true,
        }, customerConcept);

        final result = crudAlgorithm.execute(input);

        expect(result.isSuccess, isTrue);
        expect(result.entity?.getAttribute('name'), equals('John Doe'));
        expect(result.operation, equals(CrudOperation.create));
      });

      test('create entity with validation should fail for invalid data', () {
        final crudAlgorithm = CrudOperationsAlgorithm();
        final input = CrudInput.create({
          'name': '', // Invalid empty name
          'email': 'invalid-email', // Invalid email format
          'age': -5, // Invalid negative age
        }, customerConcept);

        final result = crudAlgorithm.execute(input);

        expect(result.isSuccess, isFalse);
        expect(result.validationErrors, isNotEmpty);
        expect(result.validationErrors.any((e) => e.contains('name')), isTrue);
        expect(result.validationErrors.any((e) => e.contains('email')), isTrue);
        expect(result.validationErrors.any((e) => e.contains('age')), isTrue);
      });

      test('update entity should preserve unchanged fields', () {
        // First create an entity
        final crudAlgorithm = CrudOperationsAlgorithm();
        final createInput = CrudInput.create({
          'name': 'John Doe',
          'email': 'john@example.com',
          'age': 30,
          'isActive': true,
        }, customerConcept);

        final createResult = crudAlgorithm.execute(createInput);
        final entity = createResult.entity!;

        // Now update only the name
        final updateInput = CrudInput.update(entity, {'name': 'Jane Doe'});
        final updateResult = crudAlgorithm.execute(updateInput);

        expect(updateResult.isSuccess, isTrue);
        expect(updateResult.entity?.getAttribute('name'), equals('Jane Doe'));
        expect(
          updateResult.entity?.getAttribute('email'),
          equals('john@example.com'),
        ); // Preserved
        expect(
          updateResult.entity?.getAttribute('age'),
          equals(30),
        ); // Preserved
      });

      test('delete entity should mark as deleted with soft delete', () {
        final crudAlgorithm = CrudOperationsAlgorithm();
        final createInput = CrudInput.create({
          'name': 'John Doe',
          'email': 'john@example.com',
          'age': 30,
          'isActive': true,
        }, customerConcept);

        final createResult = crudAlgorithm.execute(createInput);
        expect(
          createResult.isSuccess,
          isTrue,
          reason: 'Create should succeed: ${createResult.validationErrors}',
        );
        final entity = createResult.entity!;

        final deleteInput = CrudInput.delete(entity);
        final deleteResult = crudAlgorithm.execute(deleteInput);

        expect(deleteResult.isSuccess, isTrue);
        expect(deleteResult.operation, equals(CrudOperation.delete));
        expect(deleteResult.entity?.getAttribute('_deleted'), isTrue);
      });
    });

    group('Form Generation Algorithm', () {
      test('generate form from entity schema should create all fields', () {
        final formGenerator = FormGenerationAlgorithm();
        final input = FormGenerationInput(customerConcept);

        final result = formGenerator.execute(input);

        expect(result.fields, hasLength(4)); // name, email, age, isActive
        expect(result.fields.any((f) => f.name == 'name'), isTrue);
        expect(result.fields.any((f) => f.name == 'email'), isTrue);
        expect(result.fields.any((f) => f.name == 'age'), isTrue);
        expect(result.fields.any((f) => f.name == 'isActive'), isTrue);
      });

      test('generate form fields should have appropriate input types', () {
        final formGenerator = FormGenerationAlgorithm();
        final input = FormGenerationInput(customerConcept);

        final result = formGenerator.execute(input);

        final nameField = result.fields.firstWhere((f) => f.name == 'name');
        final emailField = result.fields.firstWhere((f) => f.name == 'email');
        final ageField = result.fields.firstWhere((f) => f.name == 'age');
        final isActiveField = result.fields.firstWhere(
          (f) => f.name == 'isActive',
        );

        expect(nameField.inputType, equals(FormInputType.text));
        expect(emailField.inputType, equals(FormInputType.email));
        expect(ageField.inputType, equals(FormInputType.number));
        expect(isActiveField.inputType, equals(FormInputType.checkbox));
      });

      test('generate form with validation rules from concept', () {
        final formGenerator = FormGenerationAlgorithm();
        final input = FormGenerationInput(customerConcept);

        final result = formGenerator.execute(input);

        final emailField = result.fields.firstWhere((f) => f.name == 'email');
        expect(
          emailField.validators.map((v) => v.type),
          contains(FormValidator.email),
        );
        expect(
          emailField.validators.map((v) => v.type),
          contains(FormValidator.required),
        );

        final ageField = result.fields.firstWhere((f) => f.name == 'age');
        expect(
          ageField.validators.any(
            (v) => v.type == FormValidator.min && v.value == 0,
          ),
          isTrue,
        );
      });
    });

    group('Business Rules Engine Algorithm', () {
      test('validate business rules should pass for valid entity', () {
        final rulesEngine = BusinessRulesEngineAlgorithm();

        // Define rules
        final rules = [
          BusinessRule(
            'age_minimum',
            (entity) =>
                (entity.getAttribute('age') as int?) != null &&
                (entity.getAttribute('age') as int) >= 18,
            'Customer must be 18 or older',
          ),
          BusinessRule(
            'email_required',
            (entity) =>
                entity.getAttribute('email') != null &&
                (entity.getAttribute('email') as String).isNotEmpty,
            'Email is required',
          ),
        ];

        final customer = DynamicEntity.withConcept(customerConcept)
          ..setAttribute('name', 'John Doe')
          ..setAttribute('email', 'john@example.com')
          ..setAttribute('age', 25);

        final input = BusinessRulesInput(customer, rules);

        final result = rulesEngine.execute(input);

        expect(result.isValid, isTrue);
        expect(result.violations, isEmpty);
      });

      test('validate business rules should fail for invalid entity', () {
        final rulesEngine = BusinessRulesEngineAlgorithm();

        final rules = [
          BusinessRule(
            'age_minimum',
            (entity) =>
                (entity.getAttribute('age') as int?) != null &&
                (entity.getAttribute('age') as int) >= 18,
            'Customer must be 18 or older',
          ),
        ];

        final input = BusinessRulesInput(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Young User')
            ..setAttribute('age', 16), // Too young
          rules,
        );

        final result = rulesEngine.execute(input);

        expect(result.isValid, isFalse);
        expect(result.violations, hasLength(1));
        expect(result.violations.first.message, contains('18 or older'));
      });
    });

    group('Workflow Engine Algorithm', () {
      test('execute simple linear workflow should complete all steps', () {
        final workflowEngine = WorkflowEngineAlgorithm();

        final workflow = WorkflowDefinition('customer_onboarding', [
          WorkflowStep('collect_info', 'Collect Customer Information'),
          WorkflowStep('validate_data', 'Validate Customer Data'),
          WorkflowStep('create_account', 'Create Customer Account'),
          WorkflowStep('send_welcome', 'Send Welcome Email'),
        ]);

        final input = WorkflowInput(workflow, {
          'name': 'John Doe',
          'email': 'john@example.com',
          'age': 30,
        });

        final result = workflowEngine.execute(input);

        expect(result.isCompleted, isTrue);
        expect(result.currentStep, equals('send_welcome'));
        expect(result.completedSteps, hasLength(4));
      });

      test('workflow with conditional branches should follow correct path', () {
        final workflowEngine = WorkflowEngineAlgorithm();

        final workflow = WorkflowDefinition('order_processing', [
          WorkflowStep('validate_order', 'Validate Order'),
          ConditionalWorkflowStep(
            'check_inventory',
            'Check Inventory',
            condition: (context) => (context['orderValue'] as double) > 100,
            onTrue: 'priority_processing',
            onFalse: 'standard_processing',
          ),
          WorkflowStep('priority_processing', 'Priority Processing'),
          WorkflowStep('standard_processing', 'Standard Processing'),
        ]);

        final highValueInput = WorkflowInput(workflow, {'orderValue': 150.0});
        final highValueResult = workflowEngine.execute(highValueInput);

        expect(highValueResult.completedSteps, contains('priority_processing'));
        expect(
          highValueResult.completedSteps,
          isNot(contains('standard_processing')),
        );

        final lowValueInput = WorkflowInput(workflow, {'orderValue': 50.0});
        final lowValueResult = workflowEngine.execute(lowValueInput);

        expect(lowValueResult.completedSteps, contains('standard_processing'));
        expect(
          lowValueResult.completedSteps,
          isNot(contains('priority_processing')),
        );
      });
    });

    group('List Management Algorithm', () {
      test('apply filters should return matching entities', () {
        final listManager = ListManagementAlgorithm();

        // Add test entities
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'John Doe')
            ..setAttribute('email', 'john@example.com')
            ..setAttribute('age', 30)
            ..setAttribute('isActive', true),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Jane Smith')
            ..setAttribute('email', 'jane@example.com')
            ..setAttribute('age', 25)
            ..setAttribute('isActive', false),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Bob Johnson')
            ..setAttribute('email', 'bob@example.com')
            ..setAttribute('age', 35)
            ..setAttribute('isActive', true),
        );

        final filters = [
          ListFilter('isActive', FilterOperator.equals, true),
          ListFilter('age', FilterOperator.greaterThan, 25),
        ];

        final input = ListManagementInput(customers, filters: filters);
        final result = listManager.execute(input);

        expect(result.items, hasLength(2)); // John and Bob
        expect(
          result.items.every((e) => e.getAttribute('isActive') == true),
          isTrue,
        );
        expect(
          result.items.every((e) => (e.getAttribute('age') as int) > 25),
          isTrue,
        );
      });

      test('apply sorting should order entities correctly', () {
        final listManager = ListManagementAlgorithm();

        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Charlie')
            ..setAttribute('email', 'charlie@example.com')
            ..setAttribute('age', 30)
            ..setAttribute('isActive', true),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Alice')
            ..setAttribute('email', 'alice@example.com')
            ..setAttribute('age', 25)
            ..setAttribute('isActive', true),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Bob')
            ..setAttribute('email', 'bob@example.com')
            ..setAttribute('age', 35)
            ..setAttribute('isActive', true),
        );

        final sorting = [ListSort('name', SortDirection.ascending)];

        final input = ListManagementInput(customers, sorting: sorting);
        final result = listManager.execute(input);

        expect(result.items[0].getAttribute('name'), equals('Alice'));
        expect(result.items[1].getAttribute('name'), equals('Bob'));
        expect(result.items[2].getAttribute('name'), equals('Charlie'));
      });

      test('apply pagination should return correct page', () {
        final listManager = ListManagementAlgorithm();

        // Add 10 entities
        for (int i = 0; i < 10; i++) {
          customers.add(
            DynamicEntity.withConcept(customerConcept)
              ..setAttribute('name', 'User $i')
              ..setAttribute('email', 'user$i@example.com')
              ..setAttribute('age', 20 + i)
              ..setAttribute('isActive', true),
          );
        }

        final pagination = ListPagination(
          page: 2,
          pageSize: 3,
        ); // Get items 3-5

        final input = ListManagementInput(customers, pagination: pagination);
        final result = listManager.execute(input);

        expect(result.items, hasLength(3));
        expect(result.totalCount, equals(10));
        expect(result.currentPage, equals(2));
        expect(result.totalPages, equals(4)); // ceil(10/3)
      });
    });

    group('Search Algorithm', () {
      test('full text search should find matching entities', () {
        final searchAlgorithm = SearchAlgorithm();

        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'John Developer')
            ..setAttribute('email', 'john@tech.com'),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Jane Designer')
            ..setAttribute('email', 'jane@creative.com'),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Bob Manager')
            ..setAttribute('email', 'bob@business.com'),
        );

        final input = SearchInput(customers, 'tech developer');
        final result = searchAlgorithm.execute(input);

        expect(result.results, hasLength(1));
        expect(
          result.results.first.entity.getAttribute('name'),
          equals('John Developer'),
        );
        expect(result.results.first.score, greaterThan(0));
      });

      test('faceted search should group results by categories', () {
        final searchAlgorithm = SearchAlgorithm();

        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'John')
            ..setAttribute('email', 'john@example.com')
            ..setAttribute('age', 25)
            ..setAttribute('isActive', true),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Jane')
            ..setAttribute('email', 'jane@example.com')
            ..setAttribute('age', 35)
            ..setAttribute('isActive', true),
        );
        customers.add(
          DynamicEntity.withConcept(customerConcept)
            ..setAttribute('name', 'Bob')
            ..setAttribute('email', 'bob@example.com')
            ..setAttribute('age', 25)
            ..setAttribute('isActive', false),
        );

        final facets = ['age', 'isActive'];
        final input = SearchInput(customers, '', facets: facets);
        final result = searchAlgorithm.execute(input);

        expect(result.facets.containsKey('age'), isTrue);
        expect(result.facets.containsKey('isActive'), isTrue);
        expect(result.facets['age']?['25'], equals(2)); // John and Bob
        expect(result.facets['age']?['35'], equals(1)); // Jane
        expect(result.facets['isActive']?['true'], equals(2)); // John and Jane
      });
    });

    /* Layout Algorithm tests are commented out since the AutoLayoutAlgorithm is not implemented
    group('Layout Algorithm', () {
      test('auto layout should organize elements without overlap', () {
        final layoutAlgorithm = AutoLayoutAlgorithm();
        
        final elements = [
          LayoutElement('customer', 100, 50),
          LayoutElement('order', 120, 60),
          LayoutElement('product', 90, 40),
          LayoutElement('payment', 110, 55),
        ];

        final input = LayoutInput(elements, canvasWidth: 800, canvasHeight: 600);
        final result = layoutAlgorithm.execute(input);

        expect(result.elements, hasLength(4));
        
        // Check no overlaps
        for (int i = 0; i < result.elements.length; i++) {
          for (int j = i + 1; j < result.elements.length; j++) {
            final a = result.elements[i];
            final b = result.elements[j];
            final hasOverlap = a.x < b.x + b.width && 
                              a.x + a.width > b.x &&
                              a.y < b.y + b.height && 
                              a.y + a.height > b.y;
            expect(hasOverlap, isFalse, reason: 'Elements ${a.id} and ${b.id} should not overlap');
          }
        }
      });

      test('grid layout should align elements to grid', () {
        final layoutAlgorithm = AutoLayoutAlgorithm();
        
        final elements = [
          LayoutElement('a', 100, 50),
          LayoutElement('b', 100, 50),
          LayoutElement('c', 100, 50),
        ];

        final input = LayoutInput(elements, 
          canvasWidth: 800, 
          canvasHeight: 600,
          layoutType: LayoutType.grid,
          gridSize: 50);
        final result = layoutAlgorithm.execute(input);

        // All positions should be multiples of grid size
        for (final element in result.elements) {
          expect(element.x % 50, equals(0));
          expect(element.y % 50, equals(0));
        }
      });
    });
    */

    group('State Management Algorithm', () {
      test('track changes should record all modifications', () {
        final stateManager = StateManagementAlgorithm();
        final entity = DynamicEntity.withConcept(customerConcept)
          ..setAttribute('name', 'John')
          ..setAttribute('age', 30);

        final input = StateManagementInput(entity);
        final tracker = stateManager.execute(input);

        // Make changes
        tracker.recordChange('name', 'John', 'Johnny');
        tracker.recordChange('age', 30, 31);
        tracker.recordChange('name', 'Johnny', 'John Doe');

        expect(tracker.changes, hasLength(3));
        expect(tracker.hasChanges, isTrue);
        expect(tracker.canUndo, isTrue);
        expect(tracker.canRedo, isFalse);
      });

      test('undo should revert last change', () {
        final stateManager = StateManagementAlgorithm();
        final entity = DynamicEntity.withConcept(customerConcept)
          ..setAttribute('name', 'John');

        final input = StateManagementInput(entity);
        final tracker = stateManager.execute(input);

        tracker.recordChange('name', 'John', 'Johnny');
        tracker.recordChange('name', 'Johnny', 'John Doe');

        final undoResult = tracker.undo();
        expect(undoResult.field, equals('name'));
        expect(undoResult.newValue, equals('Johnny'));
        expect(tracker.canRedo, isTrue);

        final redoResult = tracker.redo();
        expect(redoResult.field, equals('name'));
        expect(redoResult.newValue, equals('John Doe'));
      });

      test('create snapshot should capture complete state', () {
        final stateManager = StateManagementAlgorithm();
        final entity = DynamicEntity.withConcept(customerConcept)
          ..setAttribute('name', 'John')
          ..setAttribute('age', 30);

        final input = StateManagementInput(entity);
        final tracker = stateManager.execute(input);

        final snapshot = tracker.createSnapshot('before_update');

        entity.setAttribute('name', 'Johnny');
        entity.setAttribute('age', 31);

        tracker.restoreSnapshot(snapshot);
        expect(entity.getAttribute('name'), equals('John'));
        expect(entity.getAttribute('age'), equals(30));
      });
    });
  });
}
