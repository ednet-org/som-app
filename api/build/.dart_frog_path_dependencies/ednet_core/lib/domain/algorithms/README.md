# EDNet Core Algorithm Infrastructure

## Overview

Algorithms in EDNet Core are **first-class citizens** that provide dynamic behavioral scaffolding for domain models. Rather than static utilities, they are semantic patterns that adapt to domain context, enabling intelligent behaviors like navigation, search, and optimization.

🧠 **NEW**: With our latest implementations, EDNet Bot can now truly "read the user's mind" through intelligent heuristics and instantaneous knowledge validation!

## Architecture

### Core Components

1. **Algorithm Base Class** (`algorithm.dart`)
   - Generic type parameters for input/output
   - Built-in performance metrics
   - Concept applicability checking
   - Behavioral metadata

2. **Algorithm Registry** (`algorithm_registry.dart`)
   - Singleton pattern for algorithm management
   - Dynamic algorithm discovery
   - Behavior-based lookup
   - Performance monitoring

3. **Graph Infrastructure** (`graph_input.dart`)
   - Flexible graph representation
   - Entity-to-graph conversion
   - Node and edge abstractions

## Available Algorithms

### 🎯 Priority 1: Graph and Navigation (COMPLETE!)

#### Dijkstra's Shortest Path
```dart
// Find optimal path between entities
final orders = Entities<Order>();
// ... populate orders ...

final result = orders.findShortestPath(orderA, orderB);
if (result != null && result.found) {
  print('Shortest path distance: ${result.distance}');
  for (final node in result.path) {
    print('- ${node.data.code}');
  }
}
```

#### Breadth-First Search (BFS)
```dart
// Explore entities level by level
final result = orders.traverseBreadthFirst(
  startOrder,
  maxDepth: 3, // Explore up to 3 levels deep
);

// Access nodes by level
result.levels.forEach((nodeId, level) {
  print('$nodeId is at level $level');
});
```

#### Depth-First Search (DFS)
```dart
// Deep traversal with cycle detection
final graph = orders.toGraph();
final dfs = AlgorithmRegistry().get('dfs') as DepthFirstSearchAlgorithm;

final result = dfs.execute(DFSInput(
  graph: graph,
  startNodeId: startOrder.oid.toString(),
  onDiscovery: (node) => print('Discovered: ${node.id}'),
  onFinish: (node) => print('Finished: ${node.id}'),
));

if (result.hasCycle) {
  print('Cycle detected in entity relationships!');
}
```

#### Topological Sort
```dart
// Order workflow tasks by dependencies
final workflowGraph = GraphInput<Task>();
// ... build workflow with dependencies ...

final topoSort = AlgorithmRegistry().get('topological_sort');
final result = topoSort.execute(TopologicalSortInput(graph: workflowGraph));

if (result.hasCycle) {
  print('Impossible workflow - circular dependencies detected!');
} else {
  print('Optimal task order:');
  for (final task in result.sortedNodes) {
    print('  ${task.data.name}');
  }
}
```

### 🧠 Priority 1+: Advanced Intelligence (BONUS!)

#### A* Heuristic Search - **GAME CHANGER!**
```dart
// Guide user through optimal domain modeling path with intelligence!
final domainGraph = createDomainModelingGraph();

// Semantic heuristic based on modeling complexity
double domainModelingHeuristic(GraphNode node, GraphNode goal) {
  final complexity1 = node.properties['complexity'] as int;
  final complexity2 = goal.properties['complexity'] as int;
  return (complexity2 - complexity1).abs().toDouble();
}

final path = AlgorithmRegistry().get('astar').execute(AStarInput(
  graph: domainGraph,
  startNodeId: 'Problem',
  goalNodeId: 'Implementation',
  heuristic: domainModelingHeuristic,
));

// Bot can now guide user: "Next, let's define your main entities..."
```

### 🚀 Priority 1++: Probabilistic Data Structures (REVOLUTIONARY!)

#### Bloom Filter - **Lightning-Fast Knowledge**
```dart
// Instant concept existence checking for massive knowledge bases!
final dbpediaConcepts = [
  'Person', 'Organization', 'Event', 'Place', 'Species',
  // ... millions of concepts ...
];

final conceptFilter = AlgorithmRegistry().get('bloom_filter').execute(
  BloomFilterInput(
    items: dbpediaConcepts,
    expectedElements: 10000000, // 10 million concepts!
    falsePositiveRate: 0.01,
  ),
);

// INSTANT feedback (microseconds, not milliseconds!)
if (conceptFilter.contains('Customer')) {
  // Definitely might exist - do detailed lookup
  showConceptDetails('Customer');
} else {
  // Definitely doesn't exist - suggest alternatives instantly!
  suggestSimilarConcepts('Customer');
}
```

## 🧠 EDNet Bot "Mind-Reading" Capabilities

### 1. **Intelligent Domain Modeling Guidance**
```dart
// Bot guides user through optimal path from problem to solution
class DomainModelingGuide {
  final AStarAlgorithm _aStar = AlgorithmRegistry().get('astar');
  
  List<String> getOptimalModelingPath(String currentStep, String goal) {
    final path = _aStar.execute(AStarInput(
      graph: domainModelingWorkflow,
      startNodeId: currentStep,
      goalNodeId: goal,
      heuristic: _semanticComplexityHeuristic,
    ));
    
    return path.path.map((node) => node.data.guidance).toList();
  }
  
  // "I see you want to model customers. Next, let's define their key attributes..."
}
```

### 2. **Instantaneous Concept Recognition**
```dart
// Universal concept recommender with dbpedia-style intelligence
class UniversalRecommender {
  final BloomFilterResult _conceptFilter;
  
  RecommendationResult recommend(String userInput) {
    final concepts = extractConcepts(userInput);
    final recommendations = <String>[];
    
    for (final concept in concepts) {
      if (_conceptFilter.contains(concept)) {
        // Possible match - get detailed recommendations
        recommendations.addAll(getRelatedConcepts(concept));
      } else {
        // Definitely doesn't exist - suggest alternatives
        recommendations.addAll(suggestAlternatives(concept));
      }
    }
    
    return RecommendationResult(recommendations);
  }
}
```

### 3. **Workflow Intelligence & Optimization**
```dart
// Prevent impossible workflows and suggest optimal ordering
class WorkflowIntelligence {
  final TopologicalSortAlgorithm _topoSort = AlgorithmRegistry().get('topological_sort');
  
  WorkflowPlan optimizeWorkflow(List<Task> tasks) {
    final graph = buildTaskGraph(tasks);
    final result = _topoSort.execute(TopologicalSortInput(graph: graph));
    
    if (result.hasCycle) {
      return WorkflowPlan.impossible(
        message: "Detected circular dependencies in tasks ${result.cycleNodes}",
        suggestions: suggestCycleBreaking(result.cycleNodes),
      );
    }
    
    return WorkflowPlan.optimal(
      orderedTasks: result.sortedNodes.map((n) => n.data).toList(),
      estimatedTime: calculateTotalTime(result.sortedNodes),
    );
  }
}
```

### 4. **Semantic Relationship Explorer**
```dart
// Intelligent concept exploration with semantic awareness
class SemanticExplorer {
  Entities traverseSemanticNeighborhood(Entity startConcept, int maxDepth) {
    final graph = startConcept.concept.model.toConceptGraph();
    
    final bfs = AlgorithmRegistry().get('bfs');
    final result = bfs.execute(BFSInput(
      graph: graph,
      startNodeId: startConcept.concept.code,
      maxDepth: maxDepth,
    ));
    
    // Return semantically related concepts in order of relevance
    return buildSemanticNeighborhood(result.visitedNodes, result.levels);
  }
}
```

## 🎭 Complete EDNet Bot Scenario

```dart
// Real-world example: AI-powered domain generation
class EDNetBotSession {
  final UniversalRecommender _recommender = UniversalRecommender();
  final DomainModelingGuide _guide = DomainModelingGuide();
  final WorkflowIntelligence _workflow = WorkflowIntelligence();
  
  Future<void> processUserInput(String input) async {
    // 1. INSTANT concept recognition (Bloom filter)
    final concepts = _recommender.recommend(input);
    
    // 2. INTELLIGENT guidance (A* pathfinding)
    final guidance = _guide.getOptimalModelingPath(
      currentState, 
      inferredGoal(input)
    );
    
    // 3. WORKFLOW optimization (Topological sort)
    final plan = _workflow.optimizeWorkflow(extractTasks(input));
    
    // 4. SEMANTIC exploration (BFS/DFS)
    final relatedConcepts = exploreSemanticNeighborhood(concepts.first);
    
    // Respond with mind-reading accuracy:
    respond("""
    I see you want to ${inferredGoal(input)}. Based on your input about "${input}":
    
    📍 Current concepts I recognize: ${concepts.recognized.join(', ')}
    🎯 Optimal next step: ${guidance.first}
    📋 Suggested workflow: ${plan.orderedTasks.take(3).join(' → ')}
    🔗 Related concepts you might need: ${relatedConcepts.take(5).join(', ')}
    """);
  }
}
```

## 🎊 Revolutionary Impact

This infrastructure transforms EDNet Core from a static framework into an **intelligent semantic system** that:

1. **🧠 Thinks ahead**: A* pathfinding anticipates user needs
2. **⚡ Responds instantly**: Bloom filters provide microsecond concept validation  
3. **🎯 Prevents mistakes**: Topological sort catches impossible workflows
4. **🔍 Discovers connections**: Graph algorithms reveal hidden relationships

### Real EDNet.One MCP Server Integration

```dart
// MCP Server with algorithmic intelligence
class EDNetOneMCPServer {
  // Lightning-fast concept validation
  bool conceptExists(String concept) => 
    _globalConceptFilter.contains(concept); // Microsecond response!
  
  // Intelligent domain guidance  
  List<String> guideUser(String from, String to) =>
    _aStarGuide.findOptimalPath(from, to); // Semantic intelligence!
    
  // Workflow optimization
  List<Task> optimizeWorkflow(List<Task> tasks) =>
    _topoSort.orderTasks(tasks); // Impossible workflows prevented!
}
```

This is the **beautiful emergence** mentioned in the algorithm index - where technology and domain modeling create art through semantic intelligence! 🎨✨

## Design Philosophy

1. **Behavioral, Not Computational**: Algorithms provide behaviors that enhance domain models, not just calculations.

2. **Domain Integration**: Seamlessly work with Entity, Entities, and Concept classes.

3. **Type Safety**: Strong typing ensures compile-time safety for algorithm I/O.

4. **Performance Aware**: Built-in metrics help identify bottlenecks.

5. **Extensible**: Easy to add new algorithms via the registry pattern.

6. **🧠 Intelligent**: Heuristic-guided algorithms provide semantic awareness.

7. **⚡ Lightning-Fast**: Probabilistic data structures enable instant responses.

## Future Enhancements (Optional)

### Priority 2: Search and Pattern Matching
- String Pattern Matching - for semantic search
- Approximate String Matching - for fuzzy search
- Binary Search - for efficient lookups

### Priority 3: Dynamic Programming
- Edit Distance - for UI morphing transitions
- Longest Common Subsequence - for context preservation
- Dynamic Time Warping - for animation sequences

## Best Practices

1. **Choose the Right Algorithm**: Use the registry to find algorithms that provide needed behaviors.

2. **Monitor Performance**: Check metrics regularly, especially for frequently-used algorithms.

3. **Leverage Extensions**: Use the provided extensions on Concept/Entity/Entities for cleaner code.

4. **Think in Graphs**: Many domain relationships naturally form graphs - use graph algorithms to navigate them.

5. **Compose Behaviors**: Combine multiple algorithms to create complex behaviors.

6. **🎯 Use Heuristics**: Leverage A* with domain-specific heuristics for intelligent guidance.

7. **⚡ Optimize with Bloom Filters**: Use probabilistic data structures for massive-scale optimizations.

This infrastructure enables EDNet Bot to provide an experience that truly feels like artificial intelligence - responsive, anticipatory, and semantically aware! 🤖✨

# Business Primitive Algorithms for No-Code Platform

This library provides essential business primitive algorithms that enable non-technical users to build sophisticated SaaS applications through visual composition. These algorithms handle the common patterns that developers typically implement manually.

## 🎯 Purpose

These algorithms transform EDNet Core from a static domain modeling framework into a **dynamic behavioral scaffolding system** for no-code application development. Users can visually compose these primitives to create complete business workflows without writing code.

## 📚 Available Algorithms

### 1. CRUD Operations Algorithm
**Purpose**: Handles Create, Read, Update, Delete operations with automatic validation.

```dart
final crudAlgorithm = CrudOperationsAlgorithm();

// Create with validation
final createInput = CrudInput.create({
  'name': 'John Doe',
  'email': 'john@example.com',
  'age': 30,
}, customerConcept);
final result = crudAlgorithm.execute(createInput);

// Update preserving unchanged fields
final updateInput = CrudInput.update(entity, {'name': 'Jane Doe'});
final updateResult = crudAlgorithm.execute(updateInput);
```

**No-Code Use Cases:**
- Data entry forms with automatic validation
- Bulk import/export operations
- Audit trails and change tracking
- Data integrity enforcement

### 2. Form Generation Algorithm
**Purpose**: Automatically generates UI forms from entity schemas.

```dart
final formGenerator = FormGenerationAlgorithm();
final input = FormGenerationInput(customerConcept);
final form = formGenerator.execute(input);

// Generates appropriate input types:
// - String → text input
// - email field → email input with validation
// - int → number input
// - bool → checkbox
```

**No-Code Use Cases:**
- Dynamic form creation
- Responsive layouts
- Accessibility compliance
- Validation rule generation

### 3. Business Rules Engine
**Purpose**: Define and enforce business rules across entities.

```dart
final rulesEngine = BusinessRulesEngineAlgorithm();
final rules = [
  BusinessRule('age_minimum', (entity) => 
    (entity.getAttribute('age') as int) >= 18,
    'Customer must be 18 or older'),
];

final result = rulesEngine.execute(BusinessRulesInput(entity, rules));
```

**No-Code Use Cases:**
- Compliance enforcement
- Data validation
- Business logic definition
- Policy management

### 4. Workflow Engine
**Purpose**: Execute multi-step business processes with conditional logic.

```dart
final workflow = WorkflowDefinition('customer_onboarding', [
  WorkflowStep('collect_info', 'Collect Information'),
  ConditionalWorkflowStep('check_credit', 'Credit Check',
    condition: (context) => (context['orderValue'] as double) > 1000,
    onTrue: 'manual_approval',
    onFalse: 'auto_approval'),
  WorkflowStep('send_welcome', 'Send Welcome Email'),
]);

final result = workflowEngine.execute(WorkflowInput(workflow, context));
```

**No-Code Use Cases:**
- Process automation
- Approval workflows
- Customer onboarding
- Order processing

### 5. List Management Algorithm
**Purpose**: Filter, sort, and paginate entity collections.

```dart
final listManager = ListManagementAlgorithm();
final filters = [
  ListFilter('isActive', FilterOperator.equals, true),
  ListFilter('age', FilterOperator.greaterThan, 25),
];
final sorting = [ListSort('name', SortDirection.ascending)];
final pagination = ListPagination(page: 1, pageSize: 20);

final result = listManager.execute(ListManagementInput(
  entities, 
  filters: filters, 
  sorting: sorting, 
  pagination: pagination
));
```

**No-Code Use Cases:**
- Data tables and grids
- Search interfaces
- Reporting dashboards
- Admin panels

### 6. Search Algorithm
**Purpose**: Full-text search with faceting and scoring.

```dart
final searchAlgorithm = SearchAlgorithm();
final input = SearchInput(entities, 'tech developer', facets: ['age', 'department']);
final result = searchAlgorithm.execute(input);

// Returns scored results and facet counts
print('Found ${result.totalResults} matches');
print('Age facets: ${result.facets['age']}');
```

**No-Code Use Cases:**
- Content discovery
- Product catalogs
- Knowledge bases
- Customer support

### 7. Auto Layout Algorithm
**Purpose**: Automatically organize UI elements to avoid overlaps.

```dart
final layoutAlgorithm = AutoLayoutAlgorithm();
final elements = [
  LayoutElement('customer', 100, 50),
  LayoutElement('order', 120, 60),
];

final result = layoutAlgorithm.execute(LayoutInput(
  elements, 
  canvasWidth: 800, 
  canvasHeight: 600,
  layoutType: LayoutType.grid,
));
```

**No-Code Use Cases:**
- Visual canvas organization
- Dashboard layouts
- Form arrangement
- Mobile responsiveness

### 8. State Management Algorithm
**Purpose**: Track changes with undo/redo and snapshots.

```dart
final stateManager = StateManagementAlgorithm();
final tracker = stateManager.execute(StateManagementInput(entity));

// Track changes
tracker.recordChange('name', 'John', 'Johnny');
tracker.recordChange('age', 30, 31);

// Undo/redo
final undoResult = tracker.undo();
final redoResult = tracker.redo();

// Snapshots
final snapshot = tracker.createSnapshot('before_bulk_update');
// ... make changes ...
tracker.restoreSnapshot(snapshot);
```

**No-Code Use Cases:**
- Version control for data
- Change tracking
- Rollback capabilities
- Audit trails

## 🏗️ Architecture Integration

### EDNet Core Integration
All algorithms extend the base `Algorithm<T, R>` class and integrate seamlessly with EDNet's meta-modeling framework:

```dart
// Algorithms are first-class citizens
final algorithm = CrudOperationsAlgorithm();
concept.addBehavior(algorithm);

// Automatic concept applicability
if (algorithm.isApplicableTo(concept)) {
  final result = algorithm.execute(input);
}
```

### Registry System
Algorithms are automatically registered and discoverable:

```dart
final registry = AlgorithmRegistry.instance;
final crudAlgorithm = registry.findByName('CRUD Operations');
final applicableAlgorithms = registry.findApplicableTo(concept);
```

### Performance Tracking
All algorithms include built-in performance metrics:

```dart
final result = algorithm.execute(input);
print('Execution time: ${algorithm.lastExecutionTime}ms');
print('Success rate: ${algorithm.successRate}%');
```

## 🎨 No-Code Platform Benefits

### For Business Users
- **Visual Composition**: Drag-and-drop algorithm building blocks
- **No Programming Required**: Configure through forms and wizards
- **Immediate Feedback**: Real-time validation and preview
- **Reusable Components**: Save and share algorithm configurations

### For Domain Experts
- **Business Logic Focus**: Express rules in business terms
- **Rapid Prototyping**: Quickly test business scenarios
- **Iterative Refinement**: Modify rules without developer intervention
- **Compliance Assurance**: Built-in governance and audit trails

### For Technical Teams
- **Consistent Patterns**: Standardized implementations across applications
- **Reduced Boilerplate**: No need to implement common patterns repeatedly
- **Performance Optimized**: Algorithms include caching and optimization
- **Extensible Framework**: Easy to add new algorithms as needed

## 🚀 EDNet Bot Integration

These algorithms enable EDNet Bot's "mind-reading" capabilities:

### Intelligent Suggestions
```
User: "I need a customer form"
Bot: "I'll generate a form with name, email, and age fields. 
     Should I add address and phone number too?"
```

### Automatic Validation
```
User: "Add a rule that customers must be adults"
Bot: "I'll add age >= 18 validation. Should this apply 
     to all customer operations or specific workflows?"
```

### Workflow Recognition
```
User: "When someone orders expensive items, I want manual approval"
Bot: "I'll create a conditional workflow: orders > $1000 → manual approval, 
     otherwise auto-approve. Should I add email notifications?"
```

## 📖 Examples

### Complete E-commerce Workflow
```dart
// 1. Product catalog with search
final searchAlgorithm = SearchAlgorithm();
final products = searchAlgorithm.execute(SearchInput(
  productEntities, 
  'laptop gaming',
  facets: ['brand', 'price_range', 'rating']
));

// 2. Shopping cart with validation
final cartRules = [
  BusinessRule('min_order', (cart) => 
    (cart.getAttribute('total') as double) >= 10.0,
    'Minimum order $10'),
];

// 3. Checkout workflow
final checkoutWorkflow = WorkflowDefinition('checkout', [
  WorkflowStep('validate_cart', 'Validate Cart'),
  WorkflowStep('process_payment', 'Process Payment'),
  ConditionalWorkflowStep('shipping_check', 'Check Shipping',
    condition: (ctx) => (ctx['weight'] as double) > 50,
    onTrue: 'freight_shipping',
    onFalse: 'standard_shipping'),
  WorkflowStep('send_confirmation', 'Send Confirmation'),
]);

// 4. Order management interface
final orderList = listManager.execute(ListManagementInput(
  orderEntities,
  filters: [ListFilter('status', FilterOperator.equals, 'pending')],
  sorting: [ListSort('created_at', SortDirection.descending)],
  pagination: ListPagination(page: 1, pageSize: 50),
));
```

### Customer Support Dashboard
```dart
// Auto-layout support interface
final dashboardElements = [
  LayoutElement('ticket_list', 400, 600),
  LayoutElement('customer_info', 300, 400),
  LayoutElement('chat_widget', 500, 300),
  LayoutElement('knowledge_base', 350, 500),
];

final dashboard = layoutAlgorithm.execute(LayoutInput(
  dashboardElements,
  canvasWidth: 1200,
  canvasHeight: 800,
  layoutType: LayoutType.auto,
));

// Search knowledge base
final knowledgeSearch = searchAlgorithm.execute(SearchInput(
  articlesEntities,
  'password reset troubleshooting',
  facets: ['category', 'difficulty', 'votes'],
));
```

## 🔧 Testing Strategy

All algorithms follow TDD with comprehensive test coverage:

```dart
group('CRUD Operations Algorithm', () {
  test('create entity with validation should succeed for valid data', () {
    // Red → Green → Refactor cycle
    final result = crudAlgorithm.execute(validInput);
    expect(result.isSuccess, isTrue);
  });
  
  test('should fail for invalid data with detailed errors', () {
    final result = crudAlgorithm.execute(invalidInput);
    expect(result.validationErrors, isNotEmpty);
  });
});
```

## 📈 Performance Characteristics

| Algorithm | Time Complexity | Space Complexity | Use Case Scale |
|-----------|----------------|------------------|----------------|
| CRUD Operations | O(1) | O(1) | Individual records |
| Form Generation | O(n) attributes | O(n) | Form complexity |
| Business Rules | O(n) rules | O(1) | Rule count |
| Workflow Engine | O(n) steps | O(s) state | Process complexity |
| List Management | O(n log n) sort | O(n) | Collection size |
| Search Algorithm | O(n) entities | O(n) | Dataset size |
| Auto Layout | O(n²) collision | O(n) | UI elements |
| State Management | O(1) operation | O(h) history | Change frequency |

## 🎯 Future Roadmap

### Planned Algorithms
- **Notification Engine**: Multi-channel messaging with templates
- **Reporting Generator**: Dynamic reports from entity data
- **Import/Export Manager**: File format conversion and mapping
- **Collaboration Engine**: Real-time multi-user editing
- **Versioning System**: Content and schema version management
- **Analytics Processor**: Real-time metrics and KPI tracking

### Integration Roadmap
- **Visual Builder**: Drag-and-drop algorithm composition
- **Template Library**: Pre-built algorithm configurations
- **Marketplace**: Community-shared algorithm patterns
- **AI Assistant**: Natural language to algorithm translation

## 🏆 Key Achievements

✅ **8 Core Business Primitives** implemented with full test coverage  
✅ **Native EDNet Integration** using concept applicability framework  
✅ **Performance Tracking** with built-in metrics and monitoring  
✅ **Type-Safe APIs** with comprehensive error handling  
✅ **No-Code Enablement** through visual composition patterns  
✅ **Extensible Architecture** for future algorithm additions  

This implementation transforms EDNet Core into a **complete no-code platform foundation** where business users can create sophisticated applications by visually composing these primitive building blocks.