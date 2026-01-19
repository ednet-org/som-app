library ednet_core;

// Dart imports
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// External packages
import 'package:logging/logging.dart';
import 'package:mustache_template/mustache_template.dart' as mustache;
import 'package:yaml/yaml.dart';

// The real `expressions` package is not available in the Codex environment.
// A lightweight stub is used instead for expression parsing in tests.
import 'expressions_stub.dart';

// Simulation framework exports

// Export existing model and domain components
// export 'domain/model/entity/entity.dart'
//    if (dart.library.html) 'domain/model/entity/entity_web.dart';
// export 'meta/concept.dart';
// export 'meta/attribute.dart';
// export 'domain/model.dart';
// export 'meta/domain.dart';
// export 'domain/model/entity/id.dart';

// Export patterns
// export 'domain/patterns/common/base_message.dart';
// export 'domain/patterns/common/channel.dart';
// export 'domain/patterns/filter/message_filter.dart';
// export 'domain/patterns/aggregator/aggregator.dart';
// export 'domain/patterns/canonical/canonical_model.dart';
// export 'domain/patterns/claim/claim_check.dart';
// export 'domain/patterns/channel/purger/channel_purger.dart';
// export 'domain/patterns/ui/ui_module.dart';
// Moved to part files below

// packages/core/lib/domain/patterns/canonical/canonical_model.dart
part 'domain/patterns/canonical/canonical_model.dart';

// packages/core/lib/domain/patterns/claim/claim_check.dart
part 'domain/patterns/claim/claim_check.dart';

// packages/core/lib/domain/patterns/channel/purger/channel_purger.dart
part 'domain/patterns/channel/purger/channel_purger.dart';

// packages/core/lib/domain/patterns/common/base_message.dart
part 'domain/patterns/common/base_message.dart';
part 'domain/patterns/common/ednet_messages.dart';

// Core components - existing parts
part 'domain/core/constants.dart';
part 'domain/core/random_id.dart';
part 'domain/core/time.dart';
part 'domain/core/type.dart';
part 'domain/core/validation.dart';
part 'domain/core/type_constraint_validator.dart';
part 'domain/core/constraints/constraint.dart';

// Comparator infrastructure for universal type comparison
part 'domain/core/comparators/value_comparator.dart';
part 'domain/core/comparators/primitive_comparators.dart';
part 'domain/core/comparators/collection_comparators.dart';
part 'domain/core/comparators/entity_comparator.dart';
part 'domain/core/comparators/comparator_registry.dart';

// Core components
part 'core_repository.dart';
part 'i_repository.dart';

// Domain modeling
part 'domain/core/serializable.dart';
part 'domain/domain_models.dart';
part 'domain/i_domain_models.dart';
part 'domain/model/aggregate_root/interfaces.dart';
part 'domain/model/aggregate_root/command_execution_strategies.dart';
part 'domain/model/aggregate_root/aggregate_root.dart';
part 'domain/model/aggregate_root/enhanced_aggregate_root.dart';

// Behavioral abstractions - UX interaction patterns
part 'domain/behavioral/ux_interaction_patterns.dart';

// Unified Identity Management System
part 'domain/model/unified_identity_management.dart';

// Platform Core Entities
part 'domain/model/platform/role.dart';
part 'domain/model/platform/platform_user.dart';
part 'domain/model/platform/user_invitation.dart';
part 'domain/model/platform/user_registration_process.dart';
part 'domain/model/platform/genossenschaft_member.dart';

// Identity and blockchain systems
part 'domain/model/blockchain/offline_blockchain_repository.dart';
part 'domain/model/auth/ednet_auth_providers.dart';

// Entity components
part 'domain/model/oid.dart';
part 'domain/model/entity/entity.dart';
part 'domain/model/entity/entities.dart';
part 'domain/model/entity/id.dart';
part 'domain/model/entity/dynamic_entity.dart';
part 'domain/model/entity/interfaces/i_entity.dart';
part 'domain/model/entity/interfaces/i_entities.dart';
part 'domain/model/entity/interfaces/i_id.dart';

// Commands
part 'domain/model/commands/add_command.dart';
part 'domain/model/commands/interfaces/i_basic_command.dart';
part 'domain/model/commands/interfaces/i_command.dart';
part 'domain/model/commands/interfaces/i_entities_command.dart';
part 'domain/model/commands/interfaces/i_entity_command.dart';
part 'domain/model/commands/interfaces/i_transaction.dart';
part 'domain/model/commands/interfaces/i_command_reaction.dart';
part 'domain/model/commands/interfaces/i_source_of_command_reaction.dart';
part 'domain/model/commands/interfaces/i_source_of_past_reaction.dart';
part 'domain/model/commands/interfaces/i_past.dart';
part 'domain/model/commands/interfaces/i_past_command.dart';
part 'domain/model/commands/remove_command.dart';
part 'domain/model/commands/set_attribute_command.dart';
part 'domain/model/commands/transaction.dart';
part 'domain/model/commands/past.dart';
part 'domain/model/commands/set_child_command.dart';
part 'domain/model/commands/set_parent_command.dart';

// Application services
part 'domain/application/command_result.dart';
part 'domain/application/value_object.dart';
part 'domain/application/concept_value_object.dart';
part 'domain/application/domain_event.dart';
part 'domain/application/events/concept_metadata_changed_event.dart';
part 'domain/application/event_publisher.dart';
part 'domain/application/event_store.dart';
part 'domain/application/application_service/i_application_service.dart';
part 'domain/application/application_service/enhanced_application_service.dart';
part 'domain/application/application_service/application_service.dart';

// Command Bus Infrastructure
part 'domain/application/command_bus/i_command_bus_command.dart';
part 'domain/application/command_bus/i_command_handler.dart';
part 'domain/application/command_bus/command_bus.dart';

// Event Bus Infrastructure
part 'domain/application/event_bus/i_event_handler.dart';
part 'domain/application/event_bus/event_bus.dart';

// Process Managers (Sagas) - moved after dependencies are loaded
part 'domain/application/process_manager/process_manager.dart';

// Infrastructure
part 'domain/infrastructure/database/ednet_database.dart';

// Repository components
part 'domain/model/repository/repository.dart';
part 'repository/filter_criteria.dart';

// Event components
part 'domain/model/event/event.dart';

// Query components
part 'domain/model/queries/entity_query_result.dart';
part 'domain/model/queries/query.dart';

// Policy components
part 'domain/model/policy/attribute_policy.dart';
part 'domain/model/policy/composite_policy.dart';
part 'domain/model/policy/i_policy.dart';
part 'domain/model/policy/i_event_triggered_policy.dart';
part 'domain/model/policy/i_policy_engine.dart';
part 'domain/model/policy/policy_engine.dart';
part 'domain/model/policy/policy_evaluator.dart';
part 'domain/model/policy/policy_registry.dart';
part 'domain/model/policy/policy_scope.dart';
part 'domain/model/policy/relationship_policy.dart';
part 'domain/model/policy/time_based_policy.dart';
part 'domain/model/policy/policy_violation_exception.dart';
part 'domain/model/policy/policy_evaluation_tracer.dart';

// Observability components
part 'domain/model/observability/observability_policy.dart';

// Error handling
part 'domain/model/error/i_validation_exception.dart';
part 'domain/model/error/validation_exception.dart';
part 'domain/model/error/validation_exceptions.dart';
part 'domain/model/error/exceptions.dart';

// Utilities
part 'util/text_transformers.dart';
part 'domain/model/reference.dart';
part 'domain/model/transfer/json.dart';
part 'domain/session.dart';

// Generated code
part 'domain/model/model_entries.dart';
part 'domain/model/i_model_entries.dart';
part 'gen/ednet_concept_generic.dart';
part 'gen/ednet_concept_specific.dart';
part 'gen/ednet_domain_generic.dart';
part 'gen/ednet_domain_specific.dart';
part 'gen/ednet_library.dart';
part 'gen/ednet_library_app.dart';
part 'gen/ednet_model_generic.dart';
part 'gen/ednet_model_specific.dart';
part 'gen/ednet_repository.dart';
part 'gen/ednet_web.dart';
part 'gen/i_one_application.dart';
part 'gen/random.dart';
part 'gen/random_data.dart';
part 'gen/random_data_legacy.dart';
part 'gen/random_data_config.dart';
part 'gen/random_data_service.dart';
part 'gen/search.dart';
part 'gen/ednet_event_storming.dart';
part 'gen/template_renderer.dart';
part 'gen/package_generator.dart';

// Metadata
part 'meta/attribute.dart';
part 'meta/attributes.dart';
part 'meta/children.dart';
part 'meta/concept.dart';
part 'meta/concepts.dart';
part 'meta/domain.dart';
part 'meta/domains.dart';
part 'meta/models.dart';
part 'meta/neighbor.dart';
part 'meta/parent.dart';
part 'meta/parents.dart';
part 'meta/property.dart';
part 'meta/types.dart';
part 'meta/comparison_metadata.dart';

// Enterprise Integration Patterns
part 'domain/patterns/aggregator/aggregator.dart';
part 'domain/patterns/common/channel.dart';
part 'domain/patterns/common/http_types.dart';
part 'domain/patterns/enricher/content_enricher.dart';
part 'domain/patterns/filter/ednet_core_message_filter.dart';
part 'domain/patterns/filter/content/content_filter.dart';
part 'domain/patterns/channel/adapter/channel_adapter.dart';
part 'domain/patterns/filter/message_filter.dart';
part 'domain/patterns/wire_tap/wire_tap.dart';
part 'domain/patterns/router/dynamic_router.dart';
part 'domain/patterns/correlation/correlation_identifier.dart';
part 'domain/patterns/competing_consumers/competing_consumers.dart';
part 'domain/patterns/competing_consumers/competing_consumers_config.dart';
part 'domain/patterns/config/message_patterns_config.dart';
part 'domain/patterns/publish_subscribe/publish_subscribe.dart';
part 'domain/patterns/request_reply/request_reply.dart';
part 'domain/patterns/message_expiration/message_expiration.dart';
part 'domain/patterns/dead_letter_channel/dead_letter_channel.dart';
part 'domain/patterns/message_history/message_history.dart';

// Meta-Domain Modeling Framework
part 'meta/meta_domain_modeling_framework.dart';
part 'meta/mathematical_meta.dart';

// Mathematical Foundations - 100% Opinionated Architecture
part 'mathematical_foundations/mathematical_types.dart';
part 'mathematical_foundations/category_theory_foundation.dart';
part 'mathematical_foundations/business_primitives.dart';
// part 'mathematical_foundations/live_domain_interpreter.dart'; // re-disabled due to compilation issues
// part 'mathematical_foundations/cep_cycle_interpreter.dart'; // re-disabled due to compilation issues

// CQRS Infrastructure
part 'domain/application/cqrs/read_models/read_model.dart';
part 'domain/application/cqrs/projections/projection.dart';
part 'domain/application/cqrs/queries/query.dart';

// Entitlement and Security Infrastructure
part 'domain/application/entitlement/entitlement.dart';
part 'domain/application/entitlement/security_context.dart';

// Algorithm infrastructure - first-class behavioral scaffolding
part 'domain/algorithms/algorithm.dart';
part 'domain/algorithms/graph_input.dart';
part 'domain/algorithms/algorithm_registry.dart';

// Graph algorithms
part 'domain/algorithms/dijkstra.dart';
part 'domain/algorithms/bfs.dart';
part 'domain/algorithms/dfs.dart';
part 'domain/algorithms/topological_sort.dart';
part 'domain/algorithms/astar.dart';
part 'domain/algorithms/bloom_filter.dart';

// Business primitive algorithms for no-code platform
part 'domain/algorithms/business_primitives.dart';

// Simulation framework
part 'src/simulation/cooperative_simulator.dart';
