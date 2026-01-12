# EDNet Core - Local Backlog

## 📊 Package Overview

**Purpose**: DDD primitives and meta-modeling framework providing the foundational abstractions for all EDNet applications.

**Key Capabilities**:
- Domain, Model, Concept, Entity abstractions
- Command, Event, Policy patterns
- Repository pattern and aggregates
- Value objects and meta-modeling infrastructure
- Pure framework with zero business logic

---

## 🔄 **SPIRAL DEVELOPMENT PARTITIONS**

### **SPIRAL 1: Foundation Hardening** - Target: Week 2

**Focus**: Eliminate hardcoded business logic, achieve 0/0/0 compliance, pure meta-modeling

**Deliverables**:
- All hardcoded business logic extracted to domain models
- Zero analyzer warnings/errors (0/0/0)
- Test suite 100% passing with domain-driven fixtures
- Core framework pure and business-agnostic
- Meta-modeling principles fully realized

**Exit Criteria**:
- [ ] ✅ `dart analyze --fatal-warnings` passes (0/0/0)
- [ ] ✅ All 426+ tests passing without hardcoded mocks
- [ ] ✅ Business logic extracted to YAML-driven domain models
- [ ] ✅ Policy engine used for all validation
- [ ] ✅ ConfigurableTestDataService operational
- [ ] ✅ Documentation complete (README + meta-modeling guide)
- [ ] ✅ No hardcoded business assumptions remain

**Tasks**: See sections marked `[S1]` below

### **SPIRAL 2: Meta-Modeling Enhancement** - Target: Week 4

**Focus**: Advanced meta-modeling features, dynamic domain loading, type system enhancement

**Deliverables**:
- Dynamic domain loading and versioning
- Enhanced type system with constraints
- Policy composition and templates
- Domain compatibility checker
- Domain marketplace foundations

**Exit Criteria**:
- [ ] Dynamic domains loadable at runtime
- [ ] Type inference and compatibility matrix operational
- [ ] Policy templates and composition working
- [ ] Domain versioning and migration tools ready
- [ ] Integration tests passing with multiple domains

**Tasks**: See sections marked `[S2]` below

### **SPIRAL 3: Universal Domain Support** - Target: Week 6

**Focus**: Enterprise features, advanced meta-modeling, domain ecosystem

**Deliverables**:
- Domain marketplace integration
- Advanced policy engine features
- Complex value object support
- Domain analytics and metrics
- Production-ready meta-modeling

**Exit Criteria**:
- [ ] Domain marketplace operational
- [ ] Support for any business domain proven
- [ ] Advanced policy features production-ready
- [ ] Performance optimized for large domains
- [ ] Enterprise documentation complete

**Tasks**: See sections marked `[S3]` below

---

## SRP Coherence Analysis

### ✅ Responsibility: PERFECTLY DEFINED
DDD primitives and meta-modeling framework:
- Domain, Model, Concept, Entity abstractions
- Command, Event, Policy patterns
- Repository pattern
- Value objects and aggregates
- Meta-modeling infrastructure

**SRP Assessment**: ✅ EXCELLENT - Core framework only, no violations

### 🔴 Hardcoded Issues Found

#### CRITICAL: Business Logic in Test Mocks
**Locations**:
1. Role validation in platform_user.dart
2. Business logic in mock implementations
3. Process manager timeouts hardcoded
4. Marketing concepts in core framework
5. Saga logic hardcoded in tests

**Impact**: Violates meta-modeling principles
**Action**: Extract to proper domain models

### Sub-Stream: Remove Hardcoded Business Logic **[SPIRAL 1]**

#### Phase 1: Audit Test Mocks [Week 1] **[S1]**
- [ ] Review all mock implementations
  - [ ] Identify hardcoded business rules
  - [ ] Find hardcoded timeouts
  - [ ] Locate hardcoded validation
  - [ ] Document domain assumptions
  - [ ] Create extraction plan

#### Phase 2: Extract to Domain Models [Week 2] **[S1]**
- [ ] Create proper domain model fixtures
  - [ ] Move role validation to domain YAML
  - [ ] Extract timeouts to configuration
  - [ ] Move business logic to policies
  - [ ] Create reusable test domains
  - [ ] Remove hardcoded assumptions

#### Phase 3: Refactor Test Suite [Week 3] **[S1]**
- [ ] Update tests to use domain models
  - [ ] Replace mocks with domain fixtures
  - [ ] Use ConfigurableTestDataService
  - [ ] Load validation from YAML
  - [ ] Make tests domain-agnostic
  - [ ] Verify 426+ tests still passing

### Sub-Stream: Meta-Modeling Enhancement **[SPIRAL 2]** [Parallelizable]

#### Improve Domain Model Registry **[S2]**
- [ ] Add dynamic domain loading
- [ ] Implement domain versioning
- [ ] Create domain compatibility checker
- [ ] Build domain migration tools
- [ ] Add domain marketplace support

#### Enhance Type System **[S2]**
- [ ] Add more primitive types
- [ ] Support complex value objects
- [ ] Implement type constraints
- [ ] Add type inference
- [ ] Create type compatibility matrix

#### Policy Engine Enhancement **[S2]**
- [ ] Improve policy evaluation
- [ ] Add policy composition
- [ ] Create policy templates
- [ ] Build policy versioning
- [ ] Add policy testing tools

### Sub-Stream: Documentation **[SPIRAL 3]** [Parallelizable]
- [ ] Update architecture guide
- [ ] Add meta-modeling examples
- [ ] Create migration guide from hardcoded
- [ ] Document test patterns
- [ ] Add domain model best practices

## Quality Assurance

### Current Status
- Tests: ✅ 426+ passing
- Compilation: ✅ 0/0/0
- Hardcoded Issues: 🔴 5 critical
- SRP Compliance: ✅ Perfect architecture

### Target Status
- Tests: ✅ All passing (no hardcoded mocks)
- Hardcoded Issues: ✅ All resolved
- Domain Fixtures: ✅ YAML-driven
- Meta-Modeling: ✅ Pure framework

## Priority

- **Hardcoded Removal**: P1 HIGH
- **Timeline**: 3 weeks
- **Impact**: Enables true meta-modeling
- **Dependencies**: Blocks universal domain support

## Notes

- Core architecture is excellent
- Only issue is hardcoded test data
- Removal will perfect the meta-modeling framework
- Critical for universal domain support vision
- See packages/INDEX.md for details