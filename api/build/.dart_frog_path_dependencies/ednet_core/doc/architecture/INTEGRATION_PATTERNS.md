# Enterprise Integration Patterns in ednet_core

## Overview

This document catalogs all Enterprise Integration Patterns (EIP) implemented in the `ednet_core` library, documenting their relationships, configuration points, and integration with the EDNet Core event-driven architecture.

**Location**: `lib/domain/patterns/`
**Total Patterns**: 24 pattern implementation files
**Test Coverage**: Pattern tests passing (264+ tests)

---

## Table of Contents

1. [Pattern Catalog](#pattern-catalog)
2. [Base Infrastructure](#base-infrastructure)
3. [Messaging Patterns](#messaging-patterns)
4. [Routing Patterns](#routing-patterns)
5. [Transformation Patterns](#transformation-patterns)
6. [System Management Patterns](#system-management-patterns)
7. [Pattern Composition](#pattern-composition)
8. [Configuration & Observability](#configuration--observability)
9. [Known Issues & Architectural Notes](#known-issues--architectural-notes)

---

## Pattern Catalog

### Base Infrastructure

#### 1. **Message** (`common/base_message.dart`)
- **Purpose**: Core message abstraction for all messaging patterns
- **Type**: Foundational value object
- **Key Features**:
  - Immutable message structure with payload, metadata, and ID
  - Strongly-typed `TypedMessage` subclass for domain-specific messages
  - Support for message expiration via `MessageExpiration`
  - Legacy `Message` class maintained for backward compatibility
- **Related Patterns**: Used by all messaging patterns
- **Deprecation Notice**: Legacy `Message` class deprecated in favor of `TypedMessage` subclasses

#### 2. **Channel** (`common/channel.dart`)
- **Purpose**: Communication channel abstraction for message exchange
- **Type**: Foundational interface
- **Implementations**:
  - `InMemoryChannel`: Broadcast or single-subscriber channels
- **Key Features**:
  - Async send/receive operations
  - Stream-based message delivery
  - Resource cleanup via `close()`
- **Configuration**: Broadcast mode toggle

#### 3. **Message Patterns Configuration** (`config/message_patterns_config.dart`)
- **Purpose**: Centralized configuration for pattern behaviors
- **Configuration Points**:
  - `defaultMessageExpirationCleanupInterval`: 5 minutes (default)
  - `defaultConsumerTimeout`: 30 seconds (default)
  - `defaultMessageTtl`: 24 hours (default)
  - `maxRetries`: 3 (default)
  - `retryDelay`: 1 second (default)
- **Environments**:
  - Development: Faster timeouts, fewer retries
  - Production: Longer timeouts, more retries
  - Environment-based: Read from environment variables
- **Provider Pattern**: `MessagePatternsConfigProvider` for dependency injection

---

### Messaging Patterns

#### 4. **Message Filter** (`filter/message_filter.dart`)
- **Purpose**: Selectively receive messages matching specific criteria
- **Implementations**:
  - `PredicateMessageFilter`: Function-based filtering
  - `SelectorMessageFilter<T>`: Field extraction and comparison
  - `CompositeMessageFilter`: AND/OR/NOT logical combinations
- **Use Cases** (Direct Democracy):
  - Topic-specific discussion threads
  - Jurisdiction-based voting channels
  - Relevance filtering by citizen interests
  - Content moderation for democratic discourse
- **Configuration**:
  - Predicates for message evaluation
  - Selector functions for field extraction
  - Logical operators for composite filters
- **Observability**: Statistics on filtered vs. passed messages

#### 5. **Content Filter** (`filter/content/content_filter.dart`)
- **Purpose**: Filter messages based on content patterns
- **Type**: Specialization of Message Filter
- **Use Cases**: Content validation, safety filtering

#### 6. **Publish-Subscribe** (`publish_subscribe/publish_subscribe.dart`)
- **Purpose**: One-to-many communication with topic-based routing
- **Implementations**:
  - `TopicBasedPublishSubscribeChannel`: Topic-specific broadcasting
  - `PublishSubscribeBroker`: Multi-channel management
- **Subscriber Types**:
  - `DurableSubscriber`: Persistent subscriptions with offline message queuing
  - `SelectiveSubscriber`: Type-based and criteria-based filtering
- **Use Cases** (Direct Democracy):
  - Election announcements to all citizens
  - Proposal updates to interested stakeholders
  - Real-time voting results distribution
  - Emergency alerts broadcasting
- **Configuration**:
  - Topic names and channel IDs
  - Subscriber filtering criteria
  - Message type subscriptions
- **Observability**:
  - Subscriber counts per channel
  - Message publication statistics
  - Delivery success rates

#### 7. **Request-Reply** (`request_reply/request_reply.dart`)
- **Purpose**: Synchronous communication with immediate responses
- **Message Types**:
  - `RequestMessage`: Request with reply-to information
  - `ReplyMessage`: Correlated response to request
- **Implementations**:
  - `BasicRequestReplyChannel`: Correlation-based request/reply matching
  - `RequestReplyHandler`: Multi-handler request processing
- **Predefined Handlers** (Direct Democracy):
  - `VoteRequestHandler`: Vote casting with validation
  - `AuthenticationRequestHandler`: Citizen authentication
  - `ProposalValidationRequestHandler`: Proposal submission validation
  - `StatusQueryRequestHandler`: Real-time status queries
  - `SupportRequestHandler`: Citizen support requests
- **Configuration**:
  - Request timeout durations (default 30s)
  - Handler priorities
  - Reply channel specifications
- **Observability**:
  - Request/reply counts
  - Success rates
  - Average response times
  - Timeout statistics

#### 8. **Competing Consumers** (`competing_consumers/competing_consumers.dart`)
- **Purpose**: Parallel message processing with load balancing
- **Implementations**:
  - `CompetingConsumersCoordinator`: Message distribution coordinator
  - `BaseMessageConsumer`: Base class for consumer implementations
- **Selection Strategies**:
  - Round-robin distribution
  - Least-busy consumer
  - Random selection
  - Priority-based (planned)
- **Predefined Consumers** (Direct Democracy):
  - `VoteProcessingConsumer`: Parallel vote validation
  - `ProposalReviewConsumer`: Concurrent proposal reviews
  - `DeliberationProcessingConsumer`: Citizen input analysis
  - `AuditProcessingConsumer`: Audit trail processing
  - `NotificationDeliveryConsumer`: Distributed notification delivery
- **Configuration**:
  - Consumer count
  - Selection strategy
  - Consumer timeout
  - Backpressure limits (max 100 concurrent messages)
- **Observability**:
  - Per-consumer statistics (processed, succeeded, failed)
  - Overall success rates
  - Processing time averages
  - Message type distribution
- **Concurrency Management**:
  - Synchronized lifecycle operations
  - Atomic message distribution
  - Deduplication via message ID tracking
  - Backpressure management with queue limits
- **Race Condition Prevention**:
  - Lifecycle operation locking
  - Atomic message check-and-process
  - Safe consumer addition/removal
  - Stream recovery on errors

#### 9. **Aggregator** (`aggregator/aggregator.dart`)
- **Purpose**: Combine related messages into aggregated results
- **Implementations**:
  - `CountBasedAggregator<T>`: Aggregate after N messages
  - `TimeBasedAggregator<T>`: Aggregate after timeout period
- **Use Cases** (Direct Democracy):
  - Combining individual votes into tallies
  - Gathering citizen feedback from multiple sources
  - Collecting initiative signatures
  - Assembling proposal documents and amendments
- **Configuration**:
  - Expected message count (count-based)
  - Timeout duration (time-based)
  - Correlation ID extraction function
  - Result builder function
- **Observability**: Completion status, aggregated message counts

---

### Routing Patterns

#### 10. **Dynamic Router** (`router/dynamic_router.dart`)
- **Purpose**: Content-based message routing with runtime-modifiable rules
- **Routing Rule Types**:
  - `ContentBasedRoutingRule`: Multi-condition evaluation (AND/OR/NOT)
  - `HeaderBasedRoutingRule`: Metadata-based routing
  - `ScriptBasedRoutingRule`: Dynamic script evaluation
- **Routing Conditions**:
  - Equals, NotEquals, Contains
  - GreaterThan, LessThan
  - Exists, NotExists
  - Regex matching
- **Predefined Routers** (Direct Democracy):
  - `TopicBasedRouter`: Route by discussion topics
  - `GeographicRouter`: Route by region/jurisdiction
  - `PriorityBasedRouter`: Route by message urgency
- **Use Cases**:
  - Routing citizen inputs to deliberation forums
  - Directing proposals to expert committees
  - Load balancing based on participation levels
  - Notification routing by citizen preferences
- **Configuration**:
  - Dynamic rule addition/removal/update
  - Routing strategies (all match, any match, none match)
  - Destination channels per rule
- **Observability**:
  - Total messages routed
  - Success/failure counts
  - Routes by rule ID
  - Routes by destination

#### 11. **Wire Tap** (`wire_tap/wire_tap.dart`)
- **Purpose**: Non-invasive message inspection for monitoring and auditing
- **Implementations**:
  - `BasicWireTap`: Simple message copying to tap channel
  - `CompositeWireTap`: Multiple parallel taps
- **Filtering**:
  - `ContentBasedWireTapFilter`: Selective tapping with conditions
- **Transformation**:
  - `MetadataWireTapTransformer`: Add tap metadata
  - `AuditWireTapTransformer`: Add audit information
- **Predefined Taps** (Direct Democracy):
  - `VotingAuditWireTap`: Monitor all voting-related messages
  - `ProposalMonitoringWireTap`: Track proposal activities
- **Use Cases**:
  - Auditing voting processes
  - Monitoring citizen engagement
  - Debugging workflows
  - Logging administrative actions
  - Real-time analytics
- **Configuration**:
  - Selective tapping toggle
  - Filter criteria
  - Transformation rules
- **Observability**:
  - Message count
  - Uptime tracking
  - Message types captured

---

### Transformation Patterns

#### 12. **Content Enricher** (`enricher/content_enricher.dart`)
- **Purpose**: Augment messages with additional data from external sources
- **Enrichment Sources**:
  - `InMemoryEnrichmentSource`: Simple key-based lookup
  - `DatabaseEnrichmentSource`: Database-backed enrichment
  - `ApiEnrichmentSource`: External API integration
- **Implementations**:
  - `BasicContentEnricher`: Single or multiple source enrichment
  - `CompositeContentEnricher`: Multi-enricher composition
  - `EnrichmentPipeline`: Sequential enrichment chain
- **Enrichment Strategies**:
  - First-only: Use first successful enrichment
  - Merge-override: Later enrichments override earlier
  - Merge-preserve: Keep existing values
  - Consensus: Require all enrichers to agree
- **Use Cases** (Direct Democracy):
  - Adding citizen profile to voting messages
  - Enriching proposals with historical context
  - Augmenting deliberation with participant expertise
  - Personalizing notifications with user preferences
- **Configuration**:
  - Enrichment source connections
  - Enrichment strategy selection
  - Conflict resolution rules
- **Observability**: Enrichment success/failure tracking per source

#### 13. **Claim Check** (`claim/claim_check.dart`)
- **Purpose**: Store large payloads externally, use lightweight references
- **Implementations**:
  - `InMemoryClaimStore`: In-memory payload storage
  - `ClaimCheckManager`: Threshold-based payload offloading
  - `ClaimCheckMessage`: Message with external payload reference
- **Use Cases** (Direct Democracy):
  - Large proposal documents
  - Citizen identity verification data
  - Multimedia engagement content
  - Sensitive voting data during transmission
  - Large statistical datasets
- **Configuration**:
  - Threshold size for payload offloading (default 1KB)
  - Storage backend type (memory, file, database)
  - Time-to-live for stored payloads
- **Observability**:
  - Payload count and total size
  - Average payload size
  - Storage statistics
- **Event-Driven Integration**:
  - `ClaimCheckCreatedEvent` (placeholder)
  - `ClaimCheckRestoredEvent` (placeholder)
  - Policy-driven error handling hooks
  - Command integration for retry/dead-letter

---

### System Management Patterns

#### 14. **Dead Letter Channel** (`dead_letter_channel/dead_letter_channel.dart`)
- **Purpose**: Handle undeliverable or failed messages with comprehensive error tracking
- **Dead Letter Reasons**:
  - Delivery failure
  - Processing failure
  - Message expiration
  - Validation failure
  - Routing failure
  - Max retries exceeded
  - Security quarantine
- **Implementations**:
  - `BasicDeadLetterChannel`: Basic dead letter handling
  - `RetryableDeadLetterChannel`: Automatic retry with backoff
  - `DeadLetterChannelProcessor`: Automated failure handling
- **Filtering**:
  - `ReasonBasedDeadLetterFilter`: Filter by failure reason
  - `TimeBasedDeadLetterFilter`: Filter by time range
  - `CompositeDeadLetterFilter`: AND/OR combinations
- **Predefined Channels** (Direct Democracy):
  - `VotingDeadLetterChannel`: Failed vote processing
  - `ProposalDeadLetterChannel`: Invalid proposals
  - `AuthenticationDeadLetterChannel`: Authentication failures
  - `SystemDeadLetterChannel`: General system errors
- **Use Cases**:
  - Capturing failed vote submissions for audit
  - Archiving invalid proposals with errors
  - Tracking routing failures
  - Logging authentication failures
  - Preserving expired messages
- **Configuration**:
  - Max retry attempts (default 3)
  - Retry delay (default 30s)
  - Domain-specific channels
- **Observability**:
  - Dead letters by reason
  - Dead letters by message type
  - Retry statistics
  - Replay success rates

#### 15. **Message Expiration** (`message_expiration/message_expiration.dart`)
- **Purpose**: Time-limited message validity with automatic handling
- **Expiration Handlers**:
  - `TtlExpirationHandler`: Time-to-live based expiration
  - `TypedTtlExpirationHandler`: Typed message expiration
- **Expiration Actions**:
  - Discard: Simply remove expired message
  - Archive: Store for later analysis
  - Notify: Alert relevant parties
  - Retry: Attempt reprocessing
  - Dead-letter: Send to dead letter channel
- **Predefined Handlers** (Direct Democracy):
  - `VotingExpirationHandler`: Election voting periods
  - `ProposalExpirationHandler`: Proposal amendment windows
  - `AuthenticationExpirationHandler`: Session timeouts
  - `DeliberationExpirationHandler`: Discussion time limits
  - `EmergencyExpirationHandler`: Alert staleness
  - `NotificationExpirationHandler`: Notification validity
- **Use Cases**:
  - Election voting deadlines
  - Proposal amendment windows
  - Authentication session timeouts
  - Deliberation period limits
  - Emergency alert staleness
- **Configuration**:
  - Default TTL (24 hours)
  - Type-specific TTLs
  - Expiration actions per type
  - Cleanup interval (5 minutes)
- **Observability**:
  - Expiration counts by type
  - Average time to expiry
  - Expiration rate

#### 16. **Message History** (`message_history/message_history.dart`)
- **Purpose**: Track message path and transformations through the system
- **Use Cases**: Audit trails, debugging, message lineage tracking

#### 17. **Correlation Identifier** (`correlation/correlation_identifier.dart`)
- **Purpose**: Associate related messages across workflows and conversations
- **Implementations**:
  - `BasicCorrelationManager`: Core correlation management
  - `MessageCorrelationEnricher`: Automatic correlation addition
  - `CorrelationChannelProcessor`: Correlation-aware processing
- **ID Generators**:
  - `TimestampCorrelationIdGenerator`: Timestamp-based IDs
  - `UuidCorrelationIdGenerator`: UUID-like generation
  - `BusinessContextCorrelationIdGenerator`: Domain-specific IDs
- **Predefined Managers** (Direct Democracy):
  - `VotingSessionCorrelationManager`: Voting session tracking
  - `ProposalCorrelationManager`: Proposal workflow correlation
  - `DeliberationCorrelationManager`: Discussion thread tracking
  - `AuditTrailCorrelationManager`: Audit event correlation
- **Use Cases**:
  - Linking voting sessions with ballots and results
  - Tracking proposal amendments to originals
  - Maintaining deliberation conversation threads
  - Correlating audit trail messages
  - Multi-step approval processes
- **Configuration**:
  - Correlation ID format and prefix
  - Context TTL for cleanup
  - Generator strategy selection
- **Observability**:
  - Total correlations
  - Active correlations
  - Correlations by type

---

### Channel Management Patterns

#### 18. **Channel Adapter** (`channel/adapter/channel_adapter.dart`)
- **Purpose**: Adapt external systems to channel interfaces
- **Use Cases**: Integration with non-EDNet systems

#### 19. **Channel Purger** (`channel/purger/channel_purger.dart`)
- **Purpose**: Clean up old or expired messages from channels
- **Use Cases**: Resource management, message lifecycle

---

### Canonical Patterns

#### 20. **Canonical Model** (`canonical/canonical_model.dart`)
- **Purpose**: Define standard data formats for interoperability
- **Use Cases**: Cross-system message normalization

---

### Additional Patterns

#### 21. **EDNet Core Message Filter** (`filter/ednet_core_message_filter.dart`)
- **Purpose**: EDNet-specific message filtering
- **Type**: Specialization layer

#### 22. **HTTP Types** (`common/http_types.dart`)
- **Purpose**: HTTP-specific message type definitions
- **Use Cases**: REST API integration

#### 23. **EDNet Messages** (`common/ednet_messages.dart`)
- **Purpose**: Strongly-typed message definitions for EDNet domains
- **Key Classes**:
  - `MessageIdentifier`: Base class for all identifiers
  - `MessageDomainContext`: Domain context for messages
  - `MessageCategory`: Message classification
  - `MessageExpiration`: Expiration metadata
  - `TypedMessage`: Base for all strongly-typed messages
  - `GenericTypedMessage`: Generic payload with identifiers
- **Migration Path**: From legacy `Message` to `TypedMessage` subclasses

#### 24. **Competing Consumers Config** (`competing_consumers/competing_consumers_config.dart`)
- **Purpose**: Business logic configuration for competing consumers
- **Configuration**: Recommendations, sentiments, engagement levels, delivery methods

---

## Pattern Composition

### Common Composition Patterns

#### 1. **Filter → Router → Channel**
```dart
// Filter messages → Route by topic → Deliver to channels
PredicateMessageFilter(predicate: isProposal)
  → DynamicRouter(topicRules)
  → PublishSubscribeChannel
```

#### 2. **Channel → Enricher → Aggregator**
```dart
// Receive messages → Enrich with context → Aggregate results
SourceChannel
  → ContentEnricher(citizenProfileSource)
  → CountBasedAggregator(expectedCount: 10)
```

#### 3. **Request-Reply with Dead Letter**
```dart
// Handle requests → Process → Send to dead letter on failure
RequestReplyChannel
  → RequestHandler
  → DeadLetterChannel (on error)
```

#### 4. **Competing Consumers with Wire Tap**
```dart
// Parallel processing with monitoring
CompetingConsumers(consumers: [consumer1, consumer2])
  + WireTap(auditChannel)
```

#### 5. **Expiration → Dead Letter → Archive**
```dart
// Expired messages → Dead letter → Archive for analysis
ExpirationHandler(action: deadLetter)
  → DeadLetterChannel
  → ArchiveStorage
```

### Shared Base Classes

- **`Message`**: Base message abstraction (legacy, deprecated)
- **`TypedMessage`**: Strongly-typed message base (preferred)
- **`Channel`**: Communication channel interface
- **`MessageConsumer`**: Consumer interface for competing consumers pattern
- **`RequestHandler`**: Handler interface for request-reply pattern
- **`EnrichmentSource`**: Source interface for content enrichment

### Pattern Dependencies

```
Base Layer:
├── Message (ValueObject)
├── TypedMessage (ValueObject)
├── Channel (Abstract Interface)
└── MessagePatternsConfig

Messaging Layer (depends on Base):
├── MessageFilter → Channel
├── PublishSubscribe → Channel + MessageConsumer
├── RequestReply → Channel + Message
├── CompetingConsumers → Channel + MessageConsumer + MessagePatternsConfig
└── Aggregator → Message

Routing Layer (depends on Messaging):
├── DynamicRouter → Channel + Message
└── WireTap → Channel + Message

Transformation Layer (depends on Messaging):
├── ContentEnricher → Message
└── ClaimCheck → Message + Channel

System Management (depends on all layers):
├── DeadLetterChannel → Channel + Message
├── MessageExpiration → Message + Channel + MessagePatternsConfig
└── CorrelationIdentifier → Message
```

---

## Configuration & Observability

### Global Configuration

**Provider**: `MessagePatternsConfigProvider`

**Environments**:
- **Development**: Fast feedback, lower thresholds
- **Production**: Robust, higher limits
- **Environment-based**: From environment variables

**Key Parameters**:
| Parameter | Default | Development | Production |
|-----------|---------|-------------|------------|
| Message Cleanup Interval | 5 min | 1 min | 15 min |
| Consumer Timeout | 30 sec | 10 sec | 60 sec |
| Message TTL | 24 hours | 1 hour | 7 days |
| Max Retries | 3 | 1 | 5 |
| Retry Delay | 1 sec | 500 ms | 2 sec |

### Observability Integration

#### Statistics Tracking
- **Per-Pattern Stats**: Each pattern provides `getStats()` method
- **Aggregated Stats**: Composite patterns aggregate child statistics
- **Real-time Metrics**: Stream-based metric emission

#### Event Emission (Claim Check example)
```dart
// Event-driven architecture integration points
_emitClaimCheckCreatedEvent(originalMessage, claimCheckMessage);
_emitClaimCheckRestoredEvent(claimCheckMessage, restoredMessage);
_emitProcessingSuccessEvent(message, processedMessage);
_emitProcessingFailureEvent(message, error);
```

#### Monitoring Points
- Message throughput
- Processing latencies
- Success/failure rates
- Resource utilization
- Queue depths
- Timeout occurrences

#### Typical Statistics Available
```dart
{
  'totalMessages': int,
  'successfullyProcessed': int,
  'failed': int,
  'averageProcessingTime': Duration,
  'successRate': double,
  'lastActivity': DateTime,
  'messagesByType': Map<String, int>,
}
```

---

## Known Issues & Architectural Notes

### Test Status
- **Pattern Tests**: All passing (264+ tests)
- **Integration Tests**: Comprehensive coverage of pattern composition
- **Performance Tests**: Load testing for competing consumers

### Architectural Smells Identified

#### 1. **Message Class Duplication**
- **Issue**: Both legacy `Message` and new `TypedMessage` exist
- **Impact**: Confusion about which to use
- **Resolution**: Deprecation notices added; migrate to `TypedMessage`
- **Migration Path**: Use strongly-typed subclasses instead of generic metadata maps

#### 2. **Competing Consumers Race Conditions** (FIXED)
- **Previous Issue**: Potential race conditions in message distribution
- **Fix Applied**:
  - Synchronized lifecycle operations with locking
  - Atomic message check-and-process
  - Message ID deduplication
  - Backpressure management with concurrent message limits
- **Current Status**: Race conditions resolved, tests passing

#### 3. **Channel State Management**
- **Issue**: Channel close() not always awaited properly
- **Impact**: Potential resource leaks
- **Recommendation**: Use try-finally blocks for channel lifecycle

#### 4. **Configuration Provider Injection**
- **Good Practice**: Dependency injection via `MessagePatternsConfigProvider`
- **Note**: Allows runtime configuration changes
- **Example**: Competing consumers timeout configuration

#### 5. **Event Bus Integration Placeholders**
- **Current**: Print statements for event emission
- **Future**: Full EventBus integration needed
- **Location**: `ClaimCheckChannelProcessor._emitXXXEvent()` methods
- **Note**: Design shows integration points for future enhancement

### Performance Considerations

#### 1. **In-Memory Channels**
- **Limitation**: Not suitable for persistence
- **Use Case**: Testing, in-process messaging
- **Production**: Implement persistent channel adapters

#### 2. **Aggregator Memory Usage**
- **Risk**: Unbounded message accumulation
- **Mitigation**: Time-based aggregator with TTL
- **Recommendation**: Implement max message limits

#### 3. **Wire Tap Overhead**
- **Impact**: Doubles message traffic
- **Mitigation**: Selective tapping with filters
- **Best Practice**: Use only for critical audit paths

#### 4. **Claim Check Storage**
- **Current**: In-memory only
- **Limitation**: No persistence across restarts
- **Future Work**: File-based and database-backed stores

#### 5. **Competing Consumers Backpressure**
- **Implementation**: Max 100 concurrent messages
- **Behavior**: Blocks on capacity
- **Tuning**: Adjust limit based on consumer processing speed

### Concurrency & Thread Safety

#### Thread-Safe Patterns
- **Competing Consumers**: Synchronized lifecycle, atomic distribution
- **Message Expiration**: Timer-based cleanup with locks
- **Correlation Manager**: Map-based storage (single-threaded Dart event loop)

#### Async/Await Discipline
- All channel operations are `async`
- Proper `await` on send/receive operations
- Stream-based processing with error handlers

### Error Handling Patterns

#### Dead Letter Integration
- **Automatic**: Expired messages → Dead letter
- **Manual**: Routing failures → Dead letter
- **Retry Logic**: Max retries → Dead letter

#### Error Propagation
- **Synchronous Errors**: Thrown and caught at call site
- **Asynchronous Errors**: Stream onError handlers
- **Timeout Errors**: `TimeoutException` on timeout

---

## Future Enhancements

### Planned Patterns
1. **Message Splitter**: Split composite messages
2. **Message Resequencer**: Restore message order
3. **Scatter-Gather**: Broadcast and collect responses
4. **Process Manager**: Long-running workflow coordination

### Integration Points
1. **Event Bus**: Full event-driven architecture
2. **Policy Engine**: Policy-driven routing and handling
3. **Command Bus**: Command pattern integration
4. **Persistent Channels**: Database-backed message persistence
5. **Distributed Coordination**: Multi-node message processing

### Observability Enhancements
1. **OpenTelemetry Integration**: Distributed tracing
2. **Prometheus Metrics**: Metric export
3. **Structured Logging**: Contextual logging
4. **Real-time Dashboards**: Pattern visualization

---

## References

### Enterprise Integration Patterns
- Hohpe, G., & Woolf, B. (2003). *Enterprise Integration Patterns*
- Pattern catalog: https://www.enterpriseintegrationpatterns.com/

### EDNet Core Architecture
- Domain-Driven Design principles
- Event-driven architecture
- CQRS and Event Sourcing
- Direct democracy domain model

### Related Documentation
- `lib/domain/patterns/` - Pattern implementations
- `test/domain/patterns/` - Pattern tests and examples
- `doc/architecture/` - Architectural decisions

---

## Conclusion

The ednet_core library provides a comprehensive implementation of 24 Enterprise Integration Patterns, specifically tailored for direct democracy systems. The patterns are:

- **Well-tested**: 264+ passing tests
- **Composable**: Designed for pattern composition and chaining
- **Observable**: Rich statistics and monitoring capabilities
- **Configurable**: Environment-based configuration with sensible defaults
- **Domain-aligned**: Direct democracy use cases integrated throughout
- **Future-ready**: Integration points for event-driven architecture

The patterns form a solid foundation for building robust, scalable messaging systems for democratic participation platforms.

---

**Document Version**: 1.0
**Last Updated**: 2025-10-04
**Status**: Complete - All patterns documented
