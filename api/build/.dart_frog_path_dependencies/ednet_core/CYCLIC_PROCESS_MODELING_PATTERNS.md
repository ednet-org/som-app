# Cyclic Process Modeling Patterns in EDNet Core

## Discovery Context
During TDD development of the event storming integration test, we encountered an **infinite loop** in the Command-Event-Policy cycle. This led to the discovery of fundamental patterns for modeling cyclic processes with proper termination conditions.

## Core Insight
> **"Every business cycle must have semantic termination conditions, otherwise it's not modeling reality—it's modeling a bug."**

## Pattern Catalog

### Pattern 1: State-Aware Policies (Book Chapter 4)

**Problem**: Policies triggering on the results of their own actions create infinite loops.

**Bad Example**:
```dart
// Infinite loop - policy triggers on its own command result
policy.shouldTriggerOnEvent(event) => event is ComplianceCheckRequired;
```

**Good Example**:
```dart
// State-aware - only triggers on meaningful state transitions
policy.shouldTriggerOnEvent(event) => 
  event is CustomerJourneyStarted ||     // Start condition
  event is ComplianceCheckFailed;        // Retry condition (with limits)
```

**Implementation Requirements**:
- Policies must differentiate between **starting events** and **completion events**
- Use attempt counters or state tracking for retry logic
- Provide escalation paths instead of infinite retry

### Pattern 2: Semantic Event Design (Book Chapter 6)

**Problem**: Ambiguous events that represent both intentions and facts.

**Bad Example**:
```dart
// Ambiguous - could mean "start" or "retry"
ComplianceCheckRequired(customerId: "123", checkType: "verification")
```

**Good Example**:
```dart
// Clear semantic meaning - represents facts
ComplianceCheckCompleted(result: 'passed', customerId: "123")
ComplianceCheckFailed(attemptCount: 2, reason: "incomplete_documents")
ComplianceEscalated(requiresManualReview: true)
```

**Implementation Requirements**:
- Events must represent **facts** that happened, not **intentions**
- Use past tense naming convention
- Include termination-relevant data (attempt counts, failure reasons)

### Pattern 3: Process Manager/Saga Orchestration (Book Chapter 5)

**Problem**: Complex workflows need sophisticated termination logic.

**Solution**: Use Process Managers with explicit termination conditions.

```dart
class ComplianceProcessSaga extends ProcessManager<ComplianceState> {
  Future<void> handleFailure(ComplianceCheckFailed event) async {
    state.attemptCount++;
    
    if (state.attemptCount < 3) {
      // CONTROLLED RETRY: Continue cycle with limit
      await sendCommand(InitiateComplianceCheckCommand(...));
    } else {
      // TERMINATION: Escalate instead of infinite retry
      await publishEvent(ComplianceEscalated(...));
    }
  }
}
```

**Implementation Requirements**:
- Track process state including attempt counters
- Define multiple termination conditions (success, failure, timeout)
- Implement compensation logic for failed processes
- Use timeout mechanisms for long-running processes

### Pattern 4: Continuous Processes

**Problem**: Some processes should run indefinitely but need health monitoring.

**Solution**: Self-perpetuating cycles with circuit breakers and health checks.

```dart
// SELF-PERPETUATING: But with health checks
if (event is MonitoringHeartbeat) {
  // Schedule next heartbeat (continuous cycle)
  commands.add(ScheduleMonitoringHeartbeatCommand(
    accountId: event.accountId,
    nextCheckIn: Duration(minutes: 30),
  ));
}
```

**Implementation Requirements**:
- Include circuit breaker patterns
- Implement health monitoring and failure detection
- Provide manual termination mechanisms
- Track process health metrics

## Termination Strategies

### 1. Counter-Based Termination
Track attempts in saga/policy state and stop after maximum.

### 2. Time-Based Termination
Use saga timeouts and step deadlines.

### 3. Condition-Based Termination
Evaluate business rules to determine when to stop.

### 4. Escalation Paths
Provide alternative flows instead of infinite retry.

### 5. Manual Override
Allow operators to terminate runaway processes.

## Implementation Checklist

### For Policies:
- [ ] Differentiate between starting events and completion events
- [ ] Include attempt tracking for retry scenarios
- [ ] Implement escalation logic for failure cases
- [ ] Use semantic event names and data

### For Sagas:
- [ ] Define clear completion criteria
- [ ] Track state including attempt counters
- [ ] Implement timeout mechanisms
- [ ] Provide compensation/rollback logic
- [ ] Handle multiple termination paths

### For Events:
- [ ] Use past tense naming (facts, not intentions)
- [ ] Include termination-relevant data
- [ ] Separate event types for different outcomes
- [ ] Maintain semantic clarity

## Book Alignment Requirements

### Chapter 4 (Policies) Updates Needed:
- Add section on "State-Aware Policy Design"
- Include examples of infinite loop anti-patterns
- Document retry and escalation patterns

### Chapter 5 (Command-Event-Policy Cycle) Updates Needed:
- Add section on "Cyclic Process Termination"
- Document saga-based termination strategies
- Include continuous process patterns

### Chapter 6 (Event Sourcing) Updates Needed:
- Emphasize semantic event design for cycles
- Document event naming conventions for process states
- Include examples of fact-based vs intention-based events

## Testing Requirements

### Integration Tests Must Verify:
- Processes terminate properly under normal conditions
- Retry limits are respected
- Escalation paths work correctly
- Continuous processes can be stopped
- Timeouts are enforced

### Unit Tests Must Cover:
- Policy trigger conditions
- Saga state transitions
- Event semantic correctness
- Termination logic branches

## Observability Requirements

### Monitoring Points:
- Process attempt counters
- Saga completion rates
- Policy execution frequency
- Event loop detection
- Process duration metrics

### Alerting Conditions:
- Processes exceeding retry limits
- Sagas timing out
- Suspicious event loop patterns
- Policy execution spikes

## Real-World Examples

### Financial Compliance Process:
- **Start**: Customer registration
- **Retry**: Failed verification (max 3 attempts)
- **Escalate**: Manual review required
- **Complete**: Compliance approved

### Account Monitoring:
- **Start**: Account activation
- **Continue**: Heartbeat every 30 minutes
- **Alert**: Suspicious activity detected
- **Stop**: Account closure or manual override

## Implementation Status

- [x] Infinite loop bug identified and fixed
- [x] Semantic event patterns documented
- [x] Book Chapter 5 updated with cyclic process guidance
- [ ] Core policy implementations reviewed
- [ ] Saga termination patterns implemented
- [ ] Book Chapters 4 & 6 updated
- [ ] Integration tests expanded
- [ ] Monitoring dashboards created

## Next Steps

1. Review all existing policies for infinite loop potential
2. Update saga implementations with proper termination logic
3. Enhance book chapters with cyclic process guidance
4. Expand test coverage for termination scenarios
5. Implement monitoring for process health

---

*Last Updated: 2025-01-20*
*Discovery Context: TDD session on event storming integration test*
*Related: EDNet Core Book Chapters 4, 5, 6* 