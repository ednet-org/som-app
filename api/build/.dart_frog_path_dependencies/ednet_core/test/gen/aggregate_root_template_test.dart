import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('AggregateRoot Template', () {
    late TemplateRenderer renderer;

    setUp(() {
      renderer = TemplateRenderer();
    });

    group('Basic AggregateRoot', () {
      test('should render basic aggregate root without events', () {
        final data = {
          'entityName': 'Order',
          'entityCollectionName': 'Orders',
          'isEnhanced': false,
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'customerId', 'type': 'String', 'isId': false},
            {'code': 'total', 'type': 'double', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
          'hasEvents': false,
        };

        final result = renderer.render('aggregate_root', data);

        expect(
          result,
          contains('abstract class OrderGen extends AggregateRoot<Order>'),
        );
        expect(result, contains('String get customerId'));
        expect(result, contains('double get total'));
        expect(result, contains('@override'));
        expect(result, contains('void applyEvent(dynamic event)'));
        expect(
          result,
          contains('// Override this method to handle your domain events'),
        );
      });

      test('should render enhanced aggregate root', () {
        final data = {
          'entityName': 'Order',
          'entityCollectionName': 'Orders',
          'isEnhanced': true,
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'status', 'type': 'String', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
          'hasEvents': false,
        };

        final result = renderer.render('aggregate_root', data);

        expect(
          result,
          contains(
            'abstract class OrderGen extends EnhancedAggregateRoot<Order>',
          ),
        );
      });
    });

    group('AggregateRoot with Events', () {
      test('should render aggregate root with event handling', () {
        final data = {
          'entityName': 'Order',
          'entityCollectionName': 'Orders',
          'isEnhanced': true,
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'status', 'type': 'String', 'isId': false},
            {'code': 'total', 'type': 'double', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
          'hasEvents': true,
          'events': [
            {
              'eventName': 'OrderPlaced',
              'stateChanges': [
                {'stateChange': 'status = "Placed";'},
              ],
            },
            {
              'eventName': 'OrderShipped',
              'stateChanges': [
                {'stateChange': 'status = "Shipped";'},
              ],
            },
          ],
        };

        final result = renderer.render('aggregate_root', data);

        expect(result, contains('void applyEvent(dynamic event)'));
        expect(result, contains("case 'OrderPlaced':"));
        expect(result, contains("case 'OrderShipped':"));
        expect(result, contains('void _applyOrderPlaced(Event event)'));
        expect(result, contains('void _applyOrderShipped(Event event)'));
        expect(result, contains('// status = &quot;Placed&quot;;'));
        expect(result, contains('// status = &quot;Shipped&quot;;'));
      });

      test('should render multiple event handlers', () {
        final data = {
          'entityName': 'ShoppingCart',
          'entityCollectionName': 'ShoppingCarts',
          'isEnhanced': true,
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'totalItems', 'type': 'int', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
          'hasEvents': true,
          'events': [
            {
              'eventName': 'ItemAdded',
              'stateChanges': [
                {'stateChange': 'totalItems++;'},
              ],
            },
            {
              'eventName': 'ItemRemoved',
              'stateChanges': [
                {'stateChange': 'totalItems--;'},
              ],
            },
            {
              'eventName': 'CartCleared',
              'stateChanges': [
                {'stateChange': 'totalItems = 0;'},
              ],
            },
          ],
        };

        final result = renderer.render('aggregate_root', data);

        expect(result, contains("case 'ItemAdded':"));
        expect(result, contains("case 'ItemRemoved':"));
        expect(result, contains("case 'CartCleared':"));
        expect(result, contains('void _applyItemAdded(Event event)'));
        expect(result, contains('void _applyItemRemoved(Event event)'));
        expect(result, contains('void _applyCartCleared(Event event)'));
      });
    });

    group('AggregateRoot with Children and Parents', () {
      test('should render aggregate root with child entities', () {
        final data = {
          'entityName': 'Order',
          'entityCollectionName': 'Orders',
          'isEnhanced': true,
          'hasChildren': true,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'status', 'type': 'String', 'isId': false},
          ],
          'children': [
            {
              'childCode': 'lineItems',
              'childConceptName': 'LineItem',
              'childConceptVar': 'lineItem',
              'childCollectionName': 'LineItems',
              'needsConcept': true,
            },
          ],
          'hasSingleIdAttribute': false,
          'hasEvents': false,
        };

        final result = renderer.render('aggregate_root', data);

        expect(result, contains('final lineItemConcept ='));
        expect(
          result,
          contains("concept.model.concepts.singleWhereCode('LineItem')"),
        );
        expect(
          result,
          contains("setChild('lineItems', LineItems(lineItemConcept!))"),
        );
        expect(result, contains('LineItems get lineItems'));
      });

      test('should render aggregate root with parent relationships', () {
        final data = {
          'entityName': 'LineItem',
          'entityCollectionName': 'LineItems',
          'isEnhanced': false,
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': [
            {'code': 'order', 'parentType': 'Order', 'accessorName': 'order'},
          ],
          'attributes': [
            {'code': 'quantity', 'type': 'int', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
          'hasEvents': false,
        };

        final result = renderer.render('aggregate_root', data);

        expect(result, contains('Reference get orderReference'));
        expect(result, contains('Order get order'));
        expect(result, contains("getParent('order')! as Order"));
      });
    });

    group('AggregateRoot with ID Attributes', () {
      test('should render aggregate root with withId constructor', () {
        final data = {
          'entityName': 'Order',
          'entityCollectionName': 'Orders',
          'isEnhanced': true,
          'hasChildren': false,
          'hasIdAttributes': true,
          'idParams': [
            {'type': 'Concept', 'name': 'concept', 'isLast': false},
            {'type': 'String', 'name': 'orderId', 'isLast': true},
          ],
          'idParents': <Map<String, dynamic>>[],
          'idAttributes': [
            {'code': 'orderId'},
          ],
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'orderId', 'type': 'String', 'isId': false},
            {'code': 'status', 'type': 'String', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': true,
          'compareMethod': 'orderId',
          'compareExpression': 'orderId.compareTo(other.orderId)',
          'hasEvents': false,
        };

        final result = renderer.render('aggregate_root', data);

        expect(
          result,
          contains('OrderGen.withId(Concept concept, String orderId)'),
        );
        expect(result, contains("setAttribute('orderId', orderId)"));
        expect(
          result,
          contains(
            'int orderIdCompareTo(Order other) => orderId.compareTo(other.orderId)',
          ),
        );
      });
    });
  });

  group('Event Sourced Template', () {
    late TemplateRenderer renderer;

    setUp(() {
      renderer = TemplateRenderer();
    });

    test('should render event sourcing scaffolding with commands', () {
      final data = {
        'entityName': 'Order',
        'hasCommands': true,
        'commands': [
          {
            'commandMethod': 'placeOrder',
            'commandDescription': 'Place the order',
            'commandParams': <Map<String, dynamic>>[],
            'hasPreconditions': true,
            'preconditions': [
              {
                'condition': "status != 'Draft'",
                'errorMessage': 'Order must be in Draft status to be placed',
              },
            ],
            'eventName': 'OrderPlaced',
            'eventDescription': 'Order was placed by customer',
            'eventHandlers': [
              {'handlerName': 'OrderFulfillmentHandler', 'isLast': false},
              {'handlerName': 'NotificationHandler', 'isLast': true},
            ],
            'hasEventData': true,
            'eventData': [
              {'key': 'customerId', 'value': 'customerId'},
              {'key': 'total', 'value': 'calculateTotal()'},
            ],
            'hasPostconditions': false,
            'hasResultData': false,
          },
        ],
      };

      final result = renderer.render('event_sourced', data);

      expect(result, contains('// Event sourcing scaffolding for Order'));
      expect(result, contains('CommandResult placeOrder()'));
      expect(result, contains("if (status != &#x27;Draft&#x27;)"));
      expect(
        result,
        contains(
          "return CommandResult.failure('Order must be in Draft status to be placed')",
        ),
      );
      expect(result, contains("recordEvent("));
      expect(result, contains("'OrderPlaced'"));
      expect(result, contains("'OrderFulfillmentHandler'"));
      expect(result, contains("'NotificationHandler'"));
      expect(result, contains("'customerId': customerId"));
      expect(result, contains('class CommandResult'));
    });

    test('should render command with parameters', () {
      final data = {
        'entityName': 'ShoppingCart',
        'hasCommands': true,
        'commands': [
          {
            'commandMethod': 'addItem',
            'commandDescription': 'Add item to cart',
            'commandParams': [
              {
                'paramType': 'String',
                'paramName': 'productId',
                'isLast': false,
              },
              {'paramType': 'int', 'paramName': 'quantity', 'isLast': true},
            ],
            'hasPreconditions': false,
            'eventName': 'ItemAdded',
            'eventDescription': 'Item was added to shopping cart',
            'eventHandlers': [
              {'handlerName': 'InventoryHandler', 'isLast': true},
            ],
            'hasEventData': true,
            'eventData': [
              {'key': 'productId', 'value': 'productId'},
              {'key': 'quantity', 'value': 'quantity'},
            ],
            'hasPostconditions': false,
            'hasResultData': false,
          },
        ],
      };

      final result = renderer.render('event_sourced', data);

      expect(
        result,
        contains('CommandResult addItem(String productId, int quantity)'),
      );
      expect(result, contains("'productId': productId"));
      expect(result, contains("'quantity': quantity"));
    });

    test('should render command with result data', () {
      final data = {
        'entityName': 'Order',
        'hasCommands': true,
        'commands': [
          {
            'commandMethod': 'confirmOrder',
            'commandDescription': 'Confirm the order',
            'commandParams': <Map<String, dynamic>>[],
            'hasPreconditions': false,
            'eventName': 'OrderConfirmed',
            'eventDescription': 'Order was confirmed',
            'eventHandlers': [
              {'handlerName': 'PaymentHandler', 'isLast': true},
            ],
            'hasEventData': false,
            'hasPostconditions': false,
            'hasResultData': true,
            'resultData': [
              {'key': 'orderId', 'value': 'id'},
              {
                'key': 'confirmationNumber',
                'value': 'generateConfirmationNumber()',
              },
            ],
          },
        ],
      };

      final result = renderer.render('event_sourced', data);

      expect(result, contains('CommandResult.success(data: {'));
      expect(result, contains("'orderId': id"));
      expect(
        result,
        contains("'confirmationNumber': generateConfirmationNumber()"),
      );
    });

    test('should handle empty scaffolding', () {
      final data = {'entityName': 'Product', 'hasCommands': false};

      final result = renderer.render('event_sourced', data);

      expect(result, contains('// Event sourcing scaffolding for Product'));
      expect(result, contains('class CommandResult'));
      expect(result, isNot(contains('CommandResult placeOrder')));
    });
  });
}
