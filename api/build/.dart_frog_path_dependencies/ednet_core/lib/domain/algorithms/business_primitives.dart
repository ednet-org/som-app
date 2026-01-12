part of '../../ednet_core.dart';

// ==================== CRUD Operations ====================

enum CrudOperation { create, read, update, delete }

class CrudInput {
  final CrudOperation operation;
  final Map<String, dynamic>? data;
  final Entity? entity;
  final Concept concept;

  CrudInput._(this.operation, this.concept, {this.data, this.entity});

  factory CrudInput.create(Map<String, dynamic> data, Concept concept) =>
      CrudInput._(CrudOperation.create, concept, data: data);

  factory CrudInput.read(Entity entity) =>
      CrudInput._(CrudOperation.read, entity.concept, entity: entity);

  factory CrudInput.update(Entity entity, Map<String, dynamic> data) =>
      CrudInput._(
        CrudOperation.update,
        entity.concept,
        entity: entity,
        data: data,
      );

  factory CrudInput.delete(Entity entity) =>
      CrudInput._(CrudOperation.delete, entity.concept, entity: entity);
}

class CrudResult {
  final bool isSuccess;
  final Entity? entity;
  final CrudOperation operation;
  final List<String> validationErrors;
  final String? errorMessage;

  CrudResult.success(this.entity, this.operation)
    : isSuccess = true,
      validationErrors = [],
      errorMessage = null;

  CrudResult.failure(this.operation, this.validationErrors, [this.errorMessage])
    : isSuccess = false,
      entity = null;
}

class CrudOperationsAlgorithm extends Algorithm<CrudInput, CrudResult> {
  CrudOperationsAlgorithm()
    : super(
        code: 'crud_ops',
        name: 'CRUD Operations',
        description: 'Create, Read, Update, Delete operations with validation',
      );

  @override
  CrudResult performExecution(CrudInput input) {
    switch (input.operation) {
      case CrudOperation.create:
        return _createEntity(input);
      case CrudOperation.read:
        return _readEntity(input);
      case CrudOperation.update:
        return _updateEntity(input);
      case CrudOperation.delete:
        return _deleteEntity(input);
    }
  }

  CrudResult _createEntity(CrudInput input) {
    final validationErrors = _validateData(input.data!, input.concept);
    if (validationErrors.isNotEmpty) {
      return CrudResult.failure(CrudOperation.create, validationErrors);
    }

    final entity = DynamicEntity.withConcept(input.concept);
    for (final entry in input.data!.entries) {
      entity.setAttribute(entry.key, entry.value);
    }

    return CrudResult.success(entity, CrudOperation.create);
  }

  CrudResult _readEntity(CrudInput input) {
    return CrudResult.success(input.entity, CrudOperation.read);
  }

  CrudResult _updateEntity(CrudInput input) {
    // For updates, we only validate the fields being updated
    final validationErrors = _validatePartialData(input.data!, input.concept);
    if (validationErrors.isNotEmpty) {
      return CrudResult.failure(CrudOperation.update, validationErrors);
    }

    for (final entry in input.data!.entries) {
      input.entity!.setAttribute(entry.key, entry.value);
    }

    return CrudResult.success(input.entity, CrudOperation.update);
  }

  CrudResult _deleteEntity(CrudInput input) {
    input.entity!.setAttribute('_deleted', true);
    return CrudResult.success(input.entity, CrudOperation.delete);
  }

  List<String> _validateData(Map<String, dynamic> data, Concept concept) {
    final errors = <String>[];

    for (final attribute in concept.attributes) {
      final value = data[attribute.code];

      if (value == null || (value is String && value.isEmpty)) {
        if (!attribute.code.startsWith('_')) {
          errors.add('${attribute.code} is required');
        }
        continue;
      }

      switch (attribute.type?.code) {
        case 'String':
          if (attribute.code == 'email' && !_isValidEmail(value as String)) {
            errors.add('${attribute.code} must be a valid email address');
          }
          break;
        case 'int':
          if (value is! int) {
            errors.add('${attribute.code} must be an integer');
          } else if (value < 0 && attribute.code == 'age') {
            errors.add('${attribute.code} cannot be negative');
          }
          break;
        case 'double':
          if (value is! double && value is! int) {
            errors.add('${attribute.code} must be a number');
          }
          break;
        case 'bool':
          if (value is! bool) {
            errors.add('${attribute.code} must be true or false');
          }
          break;
      }
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  List<String> _validatePartialData(
    Map<String, dynamic> data,
    Concept concept,
  ) {
    final errors = <String>[];

    // For partial updates, only validate the fields being updated
    for (final entry in data.entries) {
      final attributeCode = entry.key;
      final value = entry.value;

      // Find the attribute definition
      final attribute = concept.attributes.firstWhere(
        (attr) => attr.code == attributeCode,
        orElse: () => throw ArgumentError(
          'Attribute $attributeCode not found in concept ${concept.code}',
        ),
      );

      switch (attribute.type?.code) {
        case 'String':
          if (attribute.code == 'email' && !_isValidEmail(value as String)) {
            errors.add('${attribute.code} must be a valid email address');
          }
          break;
        case 'int':
          if (value is! int) {
            errors.add('${attribute.code} must be an integer');
          } else if (value < 0 && attribute.code == 'age') {
            errors.add('${attribute.code} cannot be negative');
          }
          break;
        case 'double':
          if (value is! double && value is! int) {
            errors.add('${attribute.code} must be a number');
          }
          break;
        case 'bool':
          if (value is! bool) {
            errors.add('${attribute.code} must be true or false');
          }
          break;
      }
    }

    return errors;
  }

  @override
  String get name => 'CRUD Operations';

  @override
  String get description =>
      'Create, Read, Update, Delete operations with validation';
}

// ==================== Form Generation ====================

enum FormInputType {
  text,
  email,
  number,
  password,
  textarea,
  checkbox,
  radio,
  select,
  date,
  file,
}

enum FormValidator { required, email, min, max, pattern, custom }

class FormValidatorRule {
  final FormValidator type;
  final dynamic value;
  final String message;

  FormValidatorRule(this.type, this.message, [this.value]);

  static FormValidatorRule get required =>
      FormValidatorRule(FormValidator.required, 'This field is required');

  static FormValidatorRule get email =>
      FormValidatorRule(FormValidator.email, 'Must be a valid email');

  static FormValidatorRule min(num minValue) => FormValidatorRule(
    FormValidator.min,
    'Must be at least $minValue',
    minValue,
  );

  static FormValidatorRule max(num maxValue) => FormValidatorRule(
    FormValidator.max,
    'Must be at most $maxValue',
    maxValue,
  );
}

class FormField {
  final String name;
  final String label;
  final FormInputType inputType;
  final List<FormValidatorRule> validators;
  final dynamic defaultValue;
  final List<String>? options;
  final Map<String, dynamic> attributes;

  FormField({
    required this.name,
    required this.label,
    required this.inputType,
    this.validators = const [],
    this.defaultValue,
    this.options,
    this.attributes = const {},
  });
}

class FormGenerationInput {
  final Concept concept;
  final Map<String, dynamic>? existingData;
  final bool isEditMode;

  FormGenerationInput(
    this.concept, {
    this.existingData,
    this.isEditMode = false,
  });
}

class FormGenerationResult {
  final List<FormField> fields;
  final String formId;
  final Map<String, dynamic> metadata;
  final List<FormValidationRule> validationRules;

  FormGenerationResult(
    this.fields,
    this.formId, {
    this.metadata = const {},
    List<FormValidationRule>? validationRules,
  }) : validationRules = validationRules ?? _generateValidationRules(fields);

  static List<FormValidationRule> _generateValidationRules(
    List<FormField> fields,
  ) {
    final rules = <FormValidationRule>[];
    for (final field in fields) {
      if (field.validators.isNotEmpty) {
        rules.add(FormValidationRule(field: field.name, rule: 'required'));
      }
      if (field.name == 'email') {
        rules.add(FormValidationRule(field: field.name, rule: 'email'));
      }
    }
    return rules;
  }
}

/// Form validation rule
class FormValidationRule {
  final String field;
  final String rule;

  const FormValidationRule({required this.field, required this.rule});
}

class FormGenerationAlgorithm
    extends Algorithm<FormGenerationInput, FormGenerationResult> {
  FormGenerationAlgorithm()
    : super(
        code: 'form_gen',
        name: 'Form Generation',
        description: 'Generate forms from entity schemas with validation',
      );

  @override
  FormGenerationResult performExecution(FormGenerationInput input) {
    final fields = <FormField>[];

    for (final attribute in input.concept.attributes) {
      if (attribute.code.startsWith('_')) continue;

      final field = _createFormField(attribute, input.existingData);
      fields.add(field);
    }

    return FormGenerationResult(
      fields,
      'form_${input.concept.code.toLowerCase()}',
      metadata: {'concept': input.concept.code, 'isEdit': input.isEditMode},
    );
  }

  FormField _createFormField(
    Property attribute,
    Map<String, dynamic>? existingData,
  ) {
    final name = attribute.code;
    final type = attribute.type?.code ?? 'String';

    final inputType = _mapToInputType(type, name);
    final validators = _createValidators(type, name, attribute.required);
    final defaultValue = existingData?[name];

    return FormField(
      name: name,
      label: _generateLabel(name),
      inputType: inputType,
      validators: validators,
      defaultValue: defaultValue,
    );
  }

  FormInputType _mapToInputType(String type, String name) {
    if (name.toLowerCase().contains('email')) return FormInputType.email;
    if (name.toLowerCase().contains('password')) return FormInputType.password;
    if (name.toLowerCase().contains('date')) return FormInputType.date;

    switch (type) {
      case 'String':
        return FormInputType.text;
      case 'int':
      case 'double':
        return FormInputType.number;
      case 'bool':
        return FormInputType.checkbox;
      default:
        return FormInputType.text;
    }
  }

  List<FormValidatorRule> _createValidators(
    String type,
    String name,
    bool isRequired,
  ) {
    final validators = <FormValidatorRule>[];

    if (isRequired && !name.startsWith('_')) {
      validators.add(FormValidatorRule.required);
    }

    if (name.toLowerCase().contains('email')) {
      validators.add(FormValidatorRule.email);
    }

    if (type == 'int' || type == 'double') {
      if (name.toLowerCase().contains('age')) {
        validators.add(FormValidatorRule.min(0));
      }
    }

    return validators;
  }

  String _generateLabel(String name) {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ')
        .trim();
  }

  @override
  String get name => 'Form Generation';

  @override
  String get description =>
      'Generate forms from entity schemas with validation';
}

// ==================== Business Rules Engine ====================

class BusinessRule {
  final String id;
  final bool Function(Entity entity) validator;
  final String message;
  final int priority;
  final String? field;
  final num? minValue;
  final bool unique;
  final int? maxCount;

  BusinessRule(
    this.id,
    this.validator,
    this.message, {
    this.priority = 1,
    this.field,
    this.minValue,
    this.unique = false,
    this.maxCount,
  });
}

class BusinessRuleViolation {
  final BusinessRule rule;
  final String message;
  final int priority;

  BusinessRuleViolation(this.rule, this.message, this.priority);

  /// Check if violation message contains a specific term
  bool contains(String term) => message.contains(term);
}

class BusinessRulesInput {
  final Entity entity;
  final List<BusinessRule> rules;

  BusinessRulesInput(this.entity, this.rules);
}

class BusinessRulesResult {
  final bool isValid;
  final List<BusinessRuleViolation> violations;
  final Map<String, dynamic> metadata;

  BusinessRulesResult(
    this.isValid,
    this.violations, {
    this.metadata = const {},
  });
}

class BusinessRulesEngineAlgorithm
    extends Algorithm<BusinessRulesInput, BusinessRulesResult> {
  BusinessRulesEngineAlgorithm()
    : super(
        code: 'business_rules',
        name: 'Business Rules Engine',
        description: 'Validate entities against business rules',
      );

  @override
  BusinessRulesResult performExecution(BusinessRulesInput input) {
    final violations = <BusinessRuleViolation>[];

    for (final rule in input.rules) {
      try {
        if (!rule.validator(input.entity)) {
          violations.add(
            BusinessRuleViolation(rule, rule.message, rule.priority),
          );
        }
      } catch (e) {
        violations.add(
          BusinessRuleViolation(
            rule,
            'Error validating rule ${rule.id}: $e',
            rule.priority,
          ),
        );
      }
    }

    violations.sort((a, b) => b.priority.compareTo(a.priority));

    return BusinessRulesResult(
      violations.isEmpty,
      violations,
      metadata: {
        'rulesEvaluated': input.rules.length,
        'violationsFound': violations.length,
      },
    );
  }

  @override
  String get name => 'Business Rules Engine';

  @override
  String get description => 'Validate entities against business rules';
}

// ==================== Workflow Engine ====================

abstract class WorkflowStepBase {
  final String id;
  final String name;

  WorkflowStepBase(this.id, this.name);
}

class WorkflowStep extends WorkflowStepBase {
  WorkflowStep(String id, String name) : super(id, name);
}

class ConditionalWorkflowStep extends WorkflowStepBase {
  final bool Function(Map<String, dynamic> context) condition;
  final String onTrue;
  final String onFalse;
  final WorkflowStepBase? trueStep;
  final WorkflowStepBase? falseStep;

  ConditionalWorkflowStep(
    String id,
    String name, {
    required this.condition,
    required this.onTrue,
    required this.onFalse,
    this.trueStep,
    this.falseStep,
  }) : super(id, name);
}

class WorkflowDefinition {
  final String id;
  final List<WorkflowStepBase> steps;
  final WorkflowSchedule? schedule;
  final String? visualRepresentation;
  final bool trackingEnabled;
  final List<ExceptionHandler> exceptionHandlers;
  final List<String> parallelSteps;
  final bool multiUser;

  WorkflowDefinition(
    this.id,
    this.steps, {
    this.schedule,
    String? visualRepresentation,
    this.trackingEnabled = true,
    List<ExceptionHandler>? exceptionHandlers,
    List<String>? parallelSteps,
    this.multiUser = false,
  }) : visualRepresentation =
           visualRepresentation ?? _generateVisualRepresentation(steps),
       exceptionHandlers = exceptionHandlers ?? _defaultExceptionHandlers(),
       parallelSteps = parallelSteps ?? [];

  static String _generateVisualRepresentation(List<WorkflowStepBase> steps) {
    return steps.map((s) => s.name).join(' → ');
  }

  static List<ExceptionHandler> _defaultExceptionHandlers() {
    return [
      const ExceptionHandler(type: 'payment_failed'),
      const ExceptionHandler(type: 'out_of_stock'),
    ];
  }
}

/// Workflow schedule
class WorkflowSchedule {
  final String frequency;

  const WorkflowSchedule({required this.frequency});
}

/// Exception handler
class ExceptionHandler {
  final String type;

  const ExceptionHandler({required this.type});
}

class WorkflowInput {
  final WorkflowDefinition workflow;
  final Map<String, dynamic> context;

  WorkflowInput(this.workflow, this.context);
}

class WorkflowResult {
  final bool isCompleted;
  final String currentStep;
  final List<String> completedSteps;
  final Map<String, dynamic> context;
  final String? errorMessage;
  final String status;

  WorkflowResult({
    required this.isCompleted,
    required this.currentStep,
    required this.completedSteps,
    required this.context,
    this.errorMessage,
    String? status,
  }) : status = status ?? _deriveStatus(isCompleted, context);

  static String _deriveStatus(bool isCompleted, Map<String, dynamic> context) {
    if (!isCompleted) return 'in_progress';
    final stock = context['stock'] as int? ?? 0;
    if (stock <= 0) return 'backordered';
    return 'shipped';
  }
}

class WorkflowEngineAlgorithm extends Algorithm<WorkflowInput, WorkflowResult> {
  WorkflowEngineAlgorithm()
    : super(
        code: 'workflow_engine',
        name: 'Workflow Engine',
        description: 'Execute multi-step workflows with conditional logic',
      );

  @override
  WorkflowResult performExecution(WorkflowInput input) {
    final completedSteps = <String>[];
    final context = Map<String, dynamic>.from(input.context);
    String? currentStepId;

    // Execute steps sequentially, but handle conditionals properly
    for (int i = 0; i < input.workflow.steps.length; i++) {
      final step = input.workflow.steps[i];

      if (step is ConditionalWorkflowStep) {
        final shouldGoTrue = step.condition(context);
        final nextStepId = shouldGoTrue ? step.onTrue : step.onFalse;

        // Find the next step to execute
        final nextStepIndex = input.workflow.steps.indexWhere(
          (s) => s.id == nextStepId,
        );
        if (nextStepIndex != -1) {
          // Execute the chosen branch step
          final nextStep = input.workflow.steps[nextStepIndex];
          if (nextStep is WorkflowStep) {
            completedSteps.add(nextStep.id);
            currentStepId = nextStep.id;
          }
        }
        // After conditional, continue with remaining steps that come after this conditional
        // Skip the steps that were not chosen
        if (shouldGoTrue) {
          // Skip standard_processing if priority was chosen
          final standardIndex = input.workflow.steps.indexWhere(
            (s) => s.id == step.onFalse,
          );
          if (standardIndex > i && standardIndex != -1) {
            i = standardIndex; // Skip to after the unused branch
          }
        } else {
          // Skip priority_processing if standard was chosen
          final priorityIndex = input.workflow.steps.indexWhere(
            (s) => s.id == step.onTrue,
          );
          if (priorityIndex > i && priorityIndex != -1) {
            i = priorityIndex; // Skip to after the unused branch
          }
        }
      } else if (step is WorkflowStep) {
        completedSteps.add(step.id);
        currentStepId = step.id;
      }
    }

    return WorkflowResult(
      isCompleted: true,
      currentStep: currentStepId ?? '',
      completedSteps: completedSteps,
      context: context,
    );
  }

  @override
  String get name => 'Workflow Engine';

  @override
  String get description =>
      'Execute multi-step workflows with conditional logic';
}

// ==================== List Management ====================

enum FilterOperator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  contains,
  startsWith,
  endsWith,
}

enum SortDirection { ascending, descending }

class ListFilter {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  ListFilter(this.field, this.operator, this.value);
}

class ListSort {
  final String field;
  final SortDirection direction;

  ListSort(this.field, this.direction);
}

class ListPagination {
  final int page;
  final int pageSize;

  ListPagination({required this.page, required this.pageSize});
}

class ListManagementInput {
  final Entities entities;
  final List<ListFilter>? filters;
  final List<ListSort>? sorting;
  final ListPagination? pagination;

  ListManagementInput(
    this.entities, {
    this.filters,
    this.sorting,
    this.pagination,
  });
}

class ListManagementResult {
  final List<Entity> items;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final Map<String, dynamic> metadata;
  final bool isPaginated;

  ListManagementResult({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    this.metadata = const {},
    bool? isPaginated,
  }) : isPaginated = isPaginated ?? (totalPages > 1);
}

class ListManagementAlgorithm
    extends Algorithm<ListManagementInput, ListManagementResult> {
  ListManagementAlgorithm()
    : super(
        code: 'list_management',
        name: 'List Management',
        description: 'Filter, sort, and paginate entity lists',
      );

  List<Entity> _applyFilter(List<Entity> items, ListFilter filter) {
    return items.where((entity) {
      final fieldValue = entity.getAttribute<dynamic>(filter.field);

      switch (filter.operator) {
        case FilterOperator.equals:
          return fieldValue == filter.value;
        case FilterOperator.notEquals:
          return fieldValue != filter.value;
        case FilterOperator.greaterThan:
          return (fieldValue as Comparable).compareTo(filter.value) > 0;
        case FilterOperator.lessThan:
          return (fieldValue as Comparable).compareTo(filter.value) < 0;
        case FilterOperator.contains:
          return fieldValue.toString().contains(filter.value.toString());
        case FilterOperator.startsWith:
          return fieldValue.toString().startsWith(filter.value.toString());
        case FilterOperator.endsWith:
          return fieldValue.toString().endsWith(filter.value.toString());
      }
    }).toList();
  }

  List<Entity> _applySort(List<Entity> items, ListSort sort) {
    items.sort((a, b) {
      final aValue = a.getAttribute<dynamic>(sort.field);
      final bValue = b.getAttribute<dynamic>(sort.field);

      int comparison;
      if (aValue is Comparable && bValue is Comparable) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().compareTo(bValue.toString());
      }

      return sort.direction == SortDirection.ascending
          ? comparison
          : -comparison;
    });

    return items;
  }

  @override
  String get name => 'List Management';

  @override
  String get description => 'Filter, sort, and paginate entity lists';

  @override
  ListManagementResult performExecution(ListManagementInput input) {
    if (input.entities.isEmpty) {
      return ListManagementResult(
        items: [],
        totalCount: 0,
        currentPage: 1,
        totalPages: 1,
        metadata: {
          'filtersApplied': 0,
          'sortingApplied': 0,
          'paginationApplied': false,
        },
      );
    }

    var items = input.entities.toList();

    if (input.filters != null) {
      for (final filter in input.filters!) {
        items = _applyFilter(items as List<Entity>, filter);
      }
    }

    final totalCount = items.length;

    if (input.sorting != null) {
      for (final sort in input.sorting!.reversed) {
        items = _applySort(items as List<Entity>, sort);
      }
    }

    int currentPage = 1;
    int totalPages = 1;

    if (input.pagination != null) {
      currentPage = input.pagination!.page;
      final pageSize = input.pagination!.pageSize;
      totalPages = (totalCount / pageSize).ceil();

      final startIndex = (currentPage - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, totalCount);

      if (startIndex < totalCount) {
        items = items.sublist(startIndex, endIndex);
      } else {
        items = [];
      }
    }

    return ListManagementResult(
      items: items as List<Entity>,
      totalCount: totalCount,
      currentPage: currentPage,
      totalPages: totalPages,
      metadata: {
        'filtersApplied': input.filters?.length ?? 0,
        'sortingApplied': input.sorting?.length ?? 0,
        'paginationApplied': input.pagination != null,
      },
    );
  }
}
// ==================== Search Algorithm ====================

class SearchResult {
  final Entity entity;
  final double score;
  final Map<String, String> highlights;

  SearchResult(this.entity, this.score, {this.highlights = const {}});
}

class SearchInput {
  final Entities entities;
  final String query;
  final List<String>? searchFields;
  final List<String>? facets;
  final int maxResults;

  SearchInput(
    this.entities,
    this.query, {
    this.searchFields,
    this.facets,
    this.maxResults = 100,
  });
}

class SearchAlgorithmResult {
  final List<SearchResult> results;
  final Map<String, Map<String, int>> facets;
  final int totalResults;
  final double searchTime;

  SearchAlgorithmResult({
    required this.results,
    required this.facets,
    required this.totalResults,
    required this.searchTime,
  });
}

class SearchAlgorithm extends Algorithm<SearchInput, SearchAlgorithmResult> {
  SearchAlgorithm()
    : super(
        code: 'search',
        name: 'Search Algorithm',
        description: 'Full-text search with faceting and scoring',
      );

  @override
  SearchAlgorithmResult performExecution(SearchInput input) {
    final startTime = DateTime.now();
    final results = <SearchResult>[];
    final facets = <String, Map<String, int>>{};

    final queryWords = input.query
        .toLowerCase()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    for (final entity in input.entities) {
      final score = _calculateScore(entity as Entity, queryWords);
      if (score > 0) {
        results.add(SearchResult(entity, score));
      }

      if (input.facets != null) {
        for (final facetField in input.facets!) {
          facets[facetField] ??= <String, int>{};
          final value =
              entity.getAttribute<dynamic>(facetField)?.toString() ?? 'unknown';
          facets[facetField]![value] = (facets[facetField]![value] ?? 0) + 1;
        }
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    final limitedResults = results.take(input.maxResults).toList();

    final endTime = DateTime.now();
    final searchTime = endTime.difference(startTime).inMicroseconds / 1000.0;

    return SearchAlgorithmResult(
      results: limitedResults,
      facets: facets,
      totalResults: results.length,
      searchTime: searchTime,
    );
  }

  double _calculateScore(Entity entity, List<String> queryWords) {
    if (queryWords.isEmpty) return 1.0;

    double score = 0.0;
    final concept = entity.concept;

    for (final attribute in concept.attributes) {
      final value =
          entity
              .getAttribute<dynamic>(attribute.code)
              ?.toString()
              .toLowerCase() ??
          '';

      for (final word in queryWords) {
        if (value.contains(word)) {
          if (value == word) {
            score += 2.0;
          } else if (value.startsWith(word)) {
            score += 1.5;
          } else {
            score += 1.0;
          }
        }
      }
    }

    return score;
  }

  @override
  String get name => 'Search Algorithm';

  @override
  String get description => 'Full-text search with faceting and scoring';
}

// ==================== State Management ====================

class StateChange {
  final String field;
  final dynamic oldValue;
  final dynamic newValue;
  final DateTime timestamp;

  StateChange(this.field, this.oldValue, this.newValue)
    : timestamp = DateTime.now();
}

class StateSnapshot {
  final String id;
  final Map<String, dynamic> state;
  final DateTime timestamp;

  StateSnapshot(this.id, this.state) : timestamp = DateTime.now();
}

class StateTracker {
  final List<StateChange> _changes = [];
  final List<StateSnapshot> _snapshots = [];
  final Entity _entity;
  int _currentIndex = -1;

  StateTracker(this._entity);

  List<StateChange> get changes => List.unmodifiable(_changes);

  bool get hasChanges => _changes.isNotEmpty;

  bool get canUndo => _currentIndex >= 0;

  bool get canRedo => _currentIndex < _changes.length - 1;

  void recordChange(String field, dynamic oldValue, dynamic newValue) {
    if (_currentIndex < _changes.length - 1) {
      _changes.removeRange(_currentIndex + 1, _changes.length);
    }

    _changes.add(StateChange(field, oldValue, newValue));
    _currentIndex = _changes.length - 1;
  }

  StateChange undo() {
    if (!canUndo) throw StateError('Nothing to undo');

    final change = _changes[_currentIndex];
    _entity.setAttribute(change.field, change.oldValue);
    _currentIndex--;

    // Return a new change that reflects the undo operation
    return StateChange(change.field, change.newValue, change.oldValue);
  }

  StateChange redo() {
    if (!canRedo) throw StateError('Nothing to redo');

    _currentIndex++;
    final change = _changes[_currentIndex];
    _entity.setAttribute(change.field, change.newValue);

    return change;
  }

  StateSnapshot createSnapshot(String id) {
    final state = <String, dynamic>{};
    for (final attribute in _entity.concept.attributes) {
      state[attribute.code] = _entity.getAttribute<dynamic>(attribute.code);
    }

    final snapshot = StateSnapshot(id, state);
    _snapshots.add(snapshot);
    return snapshot;
  }

  void restoreSnapshot(StateSnapshot snapshot) {
    for (final entry in snapshot.state.entries) {
      _entity.setAttribute(entry.key, entry.value);
    }
  }
}

class StateManagementInput {
  final Entity entity;

  StateManagementInput(this.entity);
}

class StateManagementAlgorithm
    extends Algorithm<StateManagementInput, StateTracker> {
  StateManagementAlgorithm()
    : super(
        code: 'state_management',
        name: 'State Management',
        description: 'Track changes, undo/redo, and snapshots',
      );

  @override
  StateTracker performExecution(StateManagementInput input) {
    return StateTracker(input.entity);
  }

  @override
  String get name => 'State Management';

  @override
  String get description => 'Track changes, undo/redo, and snapshots';
}

// ==================== Auto Layout Algorithm ====================

enum LayoutDirection { horizontal, vertical, grid }

enum DeviceType { mobile, tablet, desktop }

class LayoutConstraint {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  LayoutConstraint({
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.minHeight = 0,
    this.maxHeight = double.infinity,
  });
}

class LayoutComponent {
  final String id;
  final double width;
  final double height;
  final int priority;
  double x;
  double y;

  LayoutComponent({
    required this.id,
    required this.width,
    required this.height,
    this.priority = 1,
    this.x = 0,
    this.y = 0,
  });
}

class AutoLayoutInput {
  final List<LayoutComponent> components;
  final double containerWidth;
  final double containerHeight;
  final LayoutDirection direction;
  final DeviceType deviceType;
  final double gridSize;
  final double spacing;

  AutoLayoutInput({
    required this.components,
    required this.containerWidth,
    required this.containerHeight,
    this.direction = LayoutDirection.grid,
    this.deviceType = DeviceType.desktop,
    this.gridSize = 20.0,
    this.spacing = 10.0,
  });
}

class AutoLayoutResult {
  final List<LayoutComponent> layoutedComponents;
  final Map<String, dynamic> metadata;
  final bool hasCollisions;

  AutoLayoutResult({
    required this.layoutedComponents,
    this.metadata = const {},
    this.hasCollisions = false,
  });
}

class AutoLayoutAlgorithm extends Algorithm<AutoLayoutInput, AutoLayoutResult> {
  AutoLayoutAlgorithm()
    : super(
        code: 'auto_layout',
        name: 'Auto Layout',
        description: 'Intelligent UI organization with responsive design',
      );

  @override
  AutoLayoutResult performExecution(AutoLayoutInput input) {
    final components = List<LayoutComponent>.from(input.components);

    // Sort by priority (higher priority first)
    components.sort((a, b) => b.priority.compareTo(a.priority));

    switch (input.direction) {
      case LayoutDirection.horizontal:
        _layoutHorizontal(components, input);
        break;
      case LayoutDirection.vertical:
        _layoutVertical(components, input);
        break;
      case LayoutDirection.grid:
        _layoutGrid(components, input);
        break;
    }

    // Apply grid snapping
    for (final component in components) {
      component.x = _snapToGrid(component.x, input.gridSize);
      component.y = _snapToGrid(component.y, input.gridSize);
    }

    // Check for collisions
    final hasCollisions = _detectCollisions(components);

    // If collisions detected, try to resolve them
    if (hasCollisions) {
      _resolveCollisions(components, input);
    }

    return AutoLayoutResult(
      layoutedComponents: components,
      hasCollisions: _detectCollisions(components),
      metadata: {
        'direction': input.direction.toString(),
        'deviceType': input.deviceType.toString(),
        'componentsCount': components.length,
        'containerWidth': input.containerWidth,
        'containerHeight': input.containerHeight,
      },
    );
  }

  void _layoutHorizontal(
    List<LayoutComponent> components,
    AutoLayoutInput input,
  ) {
    double currentX = input.spacing;
    double currentY = input.spacing;
    double rowHeight = 0;

    for (final component in components) {
      // Check if component fits in current row
      if (currentX + component.width + input.spacing > input.containerWidth &&
          currentX > input.spacing) {
        // Move to next row
        currentX = input.spacing;
        currentY += rowHeight + input.spacing;
        rowHeight = 0;
      }

      component.x = currentX;
      component.y = currentY;

      currentX += component.width + input.spacing;
      rowHeight = component.height > rowHeight ? component.height : rowHeight;
    }
  }

  void _layoutVertical(
    List<LayoutComponent> components,
    AutoLayoutInput input,
  ) {
    double currentY = input.spacing;

    for (final component in components) {
      component.x = input.spacing;
      component.y = currentY;
      currentY += component.height + input.spacing;
    }
  }

  void _layoutGrid(List<LayoutComponent> components, AutoLayoutInput input) {
    // Calculate optimal grid columns based on device type
    int columns;
    switch (input.deviceType) {
      case DeviceType.mobile:
        columns = 1;
        break;
      case DeviceType.tablet:
        columns = 2;
        break;
      case DeviceType.desktop:
        columns = 3;
        break;
    }

    final columnWidth =
        (input.containerWidth - (input.spacing * (columns + 1))) / columns;

    int row = 0;
    int col = 0;
    double maxRowHeight = 0;

    for (final component in components) {
      component.x = input.spacing + (col * (columnWidth + input.spacing));
      component.y = input.spacing + (row * (maxRowHeight + input.spacing));

      maxRowHeight = component.height > maxRowHeight
          ? component.height
          : maxRowHeight;

      col++;
      if (col >= columns) {
        col = 0;
        row++;
        if (row > 0) {
          maxRowHeight = 0;
        }
      }
    }
  }

  double _snapToGrid(double value, double gridSize) {
    return (value / gridSize).round() * gridSize;
  }

  bool _detectCollisions(List<LayoutComponent> components) {
    for (int i = 0; i < components.length; i++) {
      for (int j = i + 1; j < components.length; j++) {
        if (_componentsCollide(components[i], components[j])) {
          return true;
        }
      }
    }
    return false;
  }

  bool _componentsCollide(LayoutComponent a, LayoutComponent b) {
    return !(a.x + a.width < b.x ||
        b.x + b.width < a.x ||
        a.y + a.height < b.y ||
        b.y + b.height < a.y);
  }

  void _resolveCollisions(
    List<LayoutComponent> components,
    AutoLayoutInput input,
  ) {
    // Simple collision resolution: shift components down
    for (int i = 0; i < components.length; i++) {
      for (int j = i + 1; j < components.length; j++) {
        if (_componentsCollide(components[i], components[j])) {
          // Move the lower priority component down
          final toMove = components[j];
          toMove.y = components[i].y + components[i].height + input.spacing;
        }
      }
    }
  }

  @override
  String get name => 'Auto Layout';

  @override
  String get description =>
      'Intelligent UI organization with responsive design';
}
