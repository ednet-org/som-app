# ADR-001: EDNet Core as Domain Foundation

## Status
Accepted

## Context

The EDNet ecosystem requires a foundational framework for domain modeling that can:

1. **Support Domain-Driven Design**: Provide rich abstractions for entities, value objects, aggregates, and domain services
2. **Enable Event Storming Integration**: Directly map Event Storming artifacts to code constructs
3. **Facilitate Code Generation**: Serve as a meta-model for generating code across multiple technology stacks
4. **Provide Cross-Platform Compatibility**: Work across Flutter, server-side Dart, and CLI applications
5. **Support Visual Domain Modeling**: Enable direct interpretation in visual modeling tools

Several options were considered:

### Option 1: Build Custom Framework from Scratch
- **Pros**: Complete control over design and features
- **Cons**: Significant development time, lack of community adoption, maintenance burden

### Option 2: Extend Existing DDD Framework
- **Pros**: Leverage existing work, faster initial development
- **Cons**: Limited by existing design decisions, potential licensing issues

### Option 3: Develop EDNet Core as Foundational Library
- **Pros**: Tailored to our specific needs, can evolve with ecosystem, published on pub.dev for community adoption
- **Cons**: Initial development investment, need to build community

## Decision

We will develop and maintain **EDNet Core** as the foundational domain modeling library for the entire EDNet ecosystem.

### Key Design Decisions:

1. **Pure Dart Implementation**: Ensures compatibility across all Dart platforms (Flutter, server-side, CLI)

2. **Meta-Model Architecture**: Provides reflection and metadata capabilities for code generation and visual interpretation

3. **Repository Pattern**: Abstracts persistence concerns with multiple adapter support (memory, JSON, Drift, Firebase, etc.)

4. **Enhanced Query System**: Type-safe, composable query expressions with fluent builder API

5. **Event Storming Alignment**: Direct mapping from Event Storming artifacts to EDNet Core constructs

6. **Security Integration**: Built-in support for multi-tenant, RBAC/ABAC authorization

### Core Components:

```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

title EDNet Core Foundation Architecture

Container_Boundary(ednet_core, "EDNet Core") {
    Component(domain, "Domain", "Dart", "Top-level domain boundary")
    Component(entities, "Entities", "Dart", "Business objects with identity")
    Component(concepts, "Concepts", "Dart", "Meta-model definitions")
    Component(repositories, "Repositories", "Dart", "Persistence abstractions")
    Component(queries, "Query System", "Dart", "Type-safe querying")
    Component(events, "Domain Events", "Dart", "Business event handling")
}

Container_Boundary(ecosystem, "EDNet Ecosystem") {
    Component(ednet_one, "EDNet.One", "Flutter", "Visual domain modeling")
    Component(code_gen, "Code Generation", "Dart", "Multi-stack generation")
    Component(cms, "EDNet CMS", "Flutter", "Content management")
    Component(apps, "Domain Apps", "Flutter", "Business applications")
}

Rel(ednet_one, domain, "Creates models using")
Rel(code_gen, concepts, "Reads meta-model from")
Rel(cms, entities, "Visualizes and manages")
Rel(apps, repositories, "Persists data via")
Rel(apps, queries, "Queries data using")
Rel(apps, events, "Handles business events via")
@enduml
```

## Consequences

### Positive

- **Unified Foundation**: Single source of truth for domain modeling across the entire ecosystem
- **Type Safety**: Compile-time validation of domain models and queries
- **Flexibility**: Multiple persistence adapters support different deployment scenarios
- **Extensibility**: Meta-model architecture enables rich tooling and code generation
- **Community Adoption**: Published on pub.dev with growing community engagement (120+ points)
- **Zero-Lag Interpretation**: Direct Flutter interpretation without code generation delays
- **Event Storming Integration**: Seamless mapping from visual models to executable code
- **Multi-Stack Support**: Foundation for generating code in Dart, Java, TypeScript, Python

### Negative

- **Learning Curve**: Developers need to learn EDNet Core concepts and patterns
- **Dependency**: Entire ecosystem depends on EDNet Core stability and evolution
- **Maintenance Burden**: Responsibility for maintaining core library and ensuring backward compatibility
- **Performance Overhead**: Meta-model and reflection capabilities may impact performance in some scenarios

### Neutral

- **Documentation Requirements**: Need comprehensive documentation and examples
- **Version Management**: Careful semantic versioning required for ecosystem stability
- **Testing Strategy**: Extensive testing required given foundational role
- **Migration Path**: Need clear migration strategies for breaking changes

## Implementation Guidelines

### 1. Domain Model Definition
```dart
// Define domain using EDNet Core
class ProjectDomain extends Domain {
  ProjectDomain() : super("Project");
}

class Project extends Entity<Project> {
  String name = "";
  String description = "";
  DateTime createdAt = DateTime.now();
  
  Project(Concept concept) : super(concept);
}

class Projects extends Entities<Project> {
  Projects(ModelEntries modelEntries) : super(modelEntries);
}
```

### 2. Repository Configuration
```dart
// Configure repository with multiple adapters
var repository = CoreRepository();
repository.addDomain(projectDomain, 
  persistenceAdapter: DriftRepositoryAdapter(database));

// Use enhanced query system
final query = QueryBuilder.forConcept(projectConcept, 'FindActiveProjects')
  .where('status').equals('active')
  .and('createdAt').greaterThan(DateTime.now().subtract(Duration(days: 30)))
  .orderBy('createdAt', descending: true)
  .build();
```

### 3. Event Storming Integration
```yaml
# Event Storming YAML definition
concepts:
  - name: Project
    attributes:
      - name: name
        type: String
      - name: description
        type: String

events:
  - name: ProjectCreated
    attributes:
      - name: projectId
      - name: name
```

### 4. Code Generation Integration
```dart
// Meta-model provides context for code generation
final context = GenerationContext.fromDomain(projectDomain);
final dartCode = DartGenerator().generate(context);
final javaCode = JavaGenerator().generate(context);
```

## Migration Strategy

### Phase 1: Core Foundation (Completed)
- ✅ Basic domain modeling abstractions
- ✅ Repository pattern implementation
- ✅ Memory and JSON persistence adapters
- ✅ Publication on pub.dev

### Phase 2: Enhanced Capabilities (In Progress)
- ✅ Enhanced query system with expression builders
- ✅ Drift database integration
- 🚧 Security and authorization framework
- 🚧 Event sourcing capabilities

### Phase 3: Ecosystem Integration (Planned)
- 📋 Visual domain modeling integration
- 📋 Multi-stack code generation
- 📋 Real-time collaboration support
- 📋 Advanced analytics and monitoring

## Success Metrics

- **Adoption**: 500+ downloads on pub.dev within 6 months
- **Community**: 10+ community contributors
- **Ecosystem Coverage**: 100% of EDNet applications using EDNet Core
- **Performance**: <50ms query execution for 95% of operations
- **Stability**: <5 breaking changes per year with clear migration paths

## References

- [EDNet Core on pub.dev](https://pub.dev/packages/ednet_core)
- [Domain-Driven Design by Eric Evans](https://domainlanguage.com/ddd/)
- [Event Storming by Alberto Brandolini](https://www.eventstorming.com/)
- [C4 Model for Software Architecture](https://c4model.com/)
- [EDNet Core GitHub Repository](https://github.com/ednet-dev/cms/tree/main/packages/core)

## Review History

- **2024-01-15**: Initial proposal and acceptance
- **2024-02-01**: Updated with enhanced query system capabilities
- **2024-02-15**: Added security framework and event sourcing roadmap 