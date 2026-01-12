# Semantic Data Usage Examples

## Quick Start

### 1. Basic Entity Name Generation

```dart
import 'package:ednet_core/ednet_core.dart';

void main() {
  // E-commerce domain
  final ecomProvider = SemanticDataProvider.ecommerce();
  print(ecomProvider.generateEntityName());
  // Output: "Customer", "Product", "Order", "Payment"

  // Healthcare domain
  final healthProvider = SemanticDataProvider.healthcare();
  print(healthProvider.generateEntityName());
  // Output: "Patient", "MedicalAppointment", "HealthcareProvider"

  // Finance domain
  final financeProvider = SemanticDataProvider.finance();
  print(financeProvider.generateEntityName());
  // Output: "AccountHolder", "Transaction", "Payment"
}
```

### 2. Event-Driven Architecture Support

```dart
void generateEventHandlers() {
  final provider = SemanticDataProvider.ecommerce();

  // Generate event name
  final eventName = provider.generateEventName(pattern: 'Created');
  print(eventName); // "ProductCreated", "OrderCreated", etc.

  // Generate with specific domain entity
  final event = provider.generateEventName(
    domain: 'ecommerce',
    pattern: 'Completed'
  );
  print(event); // "OrderCompleted", "PaymentCompleted"
}
```

### 3. Command Pattern Generation

```dart
void generateCommands() {
  final provider = SemanticDataProvider.ecommerce();

  // Generate command names
  print(provider.generateCommandName(pattern: 'Create'));
  // "CreateProduct", "CreateOrder"

  print(provider.generateCommandName(pattern: 'Update'));
  // "UpdateCustomer", "UpdateProduct"

  print(provider.generateCommandName(pattern: 'Cancel'));
  // "CancelOrder", "CancelPayment"
}
```

### 4. BDD Test Scenario Generation

```dart
void generateBDDTests() {
  final provider = SemanticDataProvider.ecommerce();
  final scenario = provider.generateBDDScenario();

  // Generate test file content
  final testContent = '''
Feature: ${scenario.feature}

Scenario: ${scenario.scenario}
  Given ${scenario.given.join('\n  And ')}
  When ${scenario.when.join('\n  And ')}
  Then ${scenario.then.join('\n  And ')}
''';

  print(testContent);
}

// Output example:
/*
Feature: Product Purchase

Scenario: Customer completes successful purchase
  Given Customer is logged in
  And Product is in stock
  And Customer has valid payment method
  When Customer adds product to cart
  And Customer proceeds to checkout
  And Customer confirms payment
  Then Order is created with status Pending
  And Payment is processed
  And Order status changes to PaymentReceived
  And Customer receives order confirmation email
*/
```

### 5. Smart Test Value Generation

```dart
void generateTestValues() {
  final provider = SemanticDataProvider.ecommerce();

  // Generate email (uses customer personas)
  final email = provider.generateTestValue('customerEmail', 'String');
  print(email); // "sarah.johnson@example.com"

  // Generate price
  final price = provider.generateTestValue('price', 'double');
  print(price); // 899.99 (realistic product price)

  // Generate SKU
  final sku = provider.generateTestValue('productSku', 'String');
  print(sku); // "LAPTOP-HP-001" (semantic SKU)

  // Generate status
  final status = provider.generateTestValue('orderStatus', 'String');
  print(status); // "Active" or domain-appropriate status
}
```

## Advanced Use Cases

### 6. Multi-Domain Code Generation

```dart
void generateMultiDomainPackage() {
  final domains = {
    'ecommerce': SemanticDataProvider.ecommerce(),
    'healthcare': SemanticDataProvider.healthcare(),
    'finance': SemanticDataProvider.finance(),
  };

  for (final entry in domains.entries) {
    final domainName = entry.key;
    final provider = entry.value;

    print('\n=== $domainName Domain ===');
    print('Entity: ${provider.generateEntityName()}');
    print('Event: ${provider.generateEventName()}');
    print('Command: ${provider.generateCommandName()}');
  }
}

// Output:
/*
=== ecommerce Domain ===
Entity: Customer
Event: ProductCreated
Command: CreateOrder

=== healthcare Domain ===
Entity: Patient
Event: AppointmentScheduled
Command: CreateMedicalRecord

=== finance Domain ===
Entity: AccountHolder
Event: TransactionCompleted
Command: CreateAccount
*/
```

### 7. Entity Attribute Generation

```dart
void generateEntityWithAttributes() {
  final provider = SemanticDataProvider.ecommerce();

  final entityName = 'Product';
  final attributes = <String, dynamic>{};

  // Generate appropriate attributes
  for (var i = 0; i < 5; i++) {
    final attrName = provider.generateAttributeName(entityName);
    final attrValue = provider.generateTestValue(attrName, 'String');
    attributes[attrName] = attrValue;
  }

  print('$entityName attributes:');
  attributes.forEach((key, value) => print('  $key: $value'));
}

// Output example:
/*
Product attributes:
  name: HP Pavilion 15 Laptop
  description: Intel i5, 8GB RAM, 512GB SSD
  price: 899.99
  sku: LAPTOP-HP-001
  category: Electronics
*/
```

### 8. Complete Test Suite Generation

```dart
void generateCompleteTestSuite() {
  final provider = SemanticDataProvider.ecommerce();
  final scenario = provider.generateBDDScenario();

  // Generate test file
  final testCode = '''
import 'package:test/test.dart';
import 'package:my_package/my_package.dart';

/// ${scenario.feature} - ${scenario.scenario}
void main() {
  group('${scenario.feature}', () {
    test('${scenario.scenario}', () {
      // Given
${scenario.given.map((g) => '      // $g').join('\n')}

      // When
${scenario.when.map((w) => '      // $w').join('\n')}

      // Then
${scenario.then.map((t) => '      // $t\n      expect(true, isTrue); // NOTE: Implement assertion').join('\n')}
    });
  });
}
''';

  print(testCode);
}
```

### 9. Policy-Driven Validation

```dart
void generatePolicyTests() {
  final provider = SemanticDataProvider.ecommerce();

  // Generate policy names
  print(provider.generatePolicyName(pattern: 'UniqueConstraint'));
  // "CommerceUniqueConstraintPolicy"

  print(provider.generatePolicyName(pattern: 'RequiredFields'));
  // "CommerceRequiredFieldsPolicy"

  // Use ontology for validation rules
  final policy = DomainOntology.policyPatterns['RequiredFields']!;
  print('Policy: ${policy.name}');
  print('Description: ${policy.description}');
  print('Rules:');
  policy.rules.forEach((rule) => print('  - $rule'));
}
```

### 10. Integration with Package Generator

```dart
Future<void> generatePackageWithSemantics() async {
  final generator = PackageGenerator();
  final provider = SemanticDataProvider.ecommerce();

  // Create YAML DSL with semantic defaults
  final yamlContent = '''
domain: ${provider.generateEntityName()}
model:
  concepts:
    - ${provider.generateEntityName()}:
        attributes:
          - id: String
          - ${provider.generateAttributeName('Product')}: String
        events:
          - ${provider.generateEventName(pattern: 'Created')}
          - ${provider.generateEventName(pattern: 'Updated')}
        commands:
          - ${provider.generateCommandName(pattern: 'Create')}
          - ${provider.generateCommandName(pattern: 'Update')}
''';

  // Generate complete package
  final result = await generator.generatePackage(
    yamlFilePath: '/tmp/semantic_domain.yaml',
    outputPath: '/tmp/generated_package',
  );

  print('Generated ${result.fileCount} files');
  print('Success: ${result.success}');
}
```

## Domain-Specific Examples

### E-Commerce: Product Catalog System

```dart
void generateProductCatalog() {
  final provider = SemanticDataProvider.ecommerce();

  // Use actual product data
  for (final product in ECommerceDomain.products) {
    print('''
Product: ${product.name}
  SKU: ${product.sku}
  Category: ${product.category} > ${product.subcategory}
  Price: \$${product.price} ${product.currency}
  In Stock: ${product.inStock} (${product.stockQuantity} units)
  Tags: ${product.tags.join(', ')}
''');
  }
}
```

### Healthcare: Patient Management

```dart
void generatePatientRecords() {
  final provider = SemanticDataProvider.healthcare();

  for (final patient in HealthcareDomain.patientPersonas) {
    print('''
Patient ID: ${patient.id}
Name: ${patient.firstName} ${patient.lastName}
DOB: ${patient.dateOfBirth}
Blood Type: ${patient.bloodType}
Allergies: ${patient.allergies.isEmpty ? 'None' : patient.allergies.join(', ')}
Chronic Conditions: ${patient.chronicConditions.isEmpty ? 'None' : patient.chronicConditions.join(', ')}
Insurance: ${patient.insuranceProvider} (${patient.insuranceId})
''');
  }
}
```

### Finance: Transaction Processing

```dart
void generateTransactionScenarios() {
  final provider = SemanticDataProvider.finance();

  for (final txn in FinanceDomain.creditCardTransactions) {
    print('''
Transaction: ${txn.transactionId}
Card: ${txn.cardNumber}
Merchant: ${txn.merchantName} (${txn.merchantCategory})
Amount: \$${txn.amount} ${txn.currency}
Date: ${txn.transactionDate}
Auth: ${txn.authorizationCode}
''');
  }
}
```

### Education: Course Enrollment

```dart
void generateCourseEnrollment() {
  final provider = SemanticDataProvider.education();

  for (final course in EducationDomain.courses) {
    print('''
Course: ${course.courseId} - ${course.courseName}
Subject: ${course.subject}
Credits: ${course.credits}
Difficulty: ${course.difficulty}
Prerequisites: ${course.prerequisites.isEmpty ? 'None' : course.prerequisites.join(', ')}
Description: ${course.description}
''');
  }
}
```

### Logistics: Shipment Tracking

```dart
void generateShipmentTracking() {
  final provider = SemanticDataProvider.logistics();

  for (final shipment in LogisticsDomain.shipmentScenarios) {
    print('''
Tracking: ${shipment.trackingNumber}
Route: ${shipment.origin} → ${shipment.destination}
Weight: ${shipment.weight} lbs (${shipment.dimensions})
Carrier: ${shipment.carrier} (${shipment.service})
ETA: ${shipment.estimatedDays} days
Insurance: ${shipment.insured ? '\$${shipment.insuranceValue}' : 'None'}
''');
  }
}
```

## Testing the Semantic Data

```dart
void testSemanticData() {
  // Test all domains
  final providers = [
    SemanticDataProvider.ecommerce(),
    SemanticDataProvider.healthcare(),
    SemanticDataProvider.finance(),
    SemanticDataProvider.education(),
    SemanticDataProvider.logistics(),
  ];

  for (final provider in providers) {
    final domains = provider.availableDomains;
    print('Available domains: ${domains.join(', ')}');

    // Generate sample data
    print('Entity: ${provider.generateEntityName()}');
    print('Event: ${provider.generateEventName()}');
    print('Command: ${provider.generateCommandName()}');
    print('Policy: ${provider.generatePolicyName()}');
    print('---');
  }
}
```

## Tips for Best Results

1. **Match domain to use case**: Use domain-specific providers for coherent data
2. **Leverage BDD scenarios**: They provide complete workflow coverage
3. **Use ontology patterns**: Reference `DomainOntology` for standard patterns
4. **Combine personas**: Mix customer/patient/student personas for realistic tests
5. **Generate complete workflows**: Use event chains from BDD scenarios

## Next Steps

- Extend with your own domain data
- Add custom BDD scenarios
- Create domain-specific test templates
- Integrate with CI/CD for automated test generation
