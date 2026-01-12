# EDNet Core Package Guidelines

## Scope
- `lib/` implements the mathematical backbone of EDNet Core: concepts, aggregates, CEP engine, policy interpreter, and category-theory primitives.
- `test/` mirrors each module; extend coverage before modifying framework behavior.
- Do not place app-specific logic here—reference `docs/book/07-meta-modeling-with-concepts.md` for acceptable abstractions.

## Distributed Agent Protocols

**For parallel agent work**: See `docs/agent-protocols/UNIVERSAL_AGENT_PROTOCOL.md`

**Key Protocols**:
- **Lock Format**: `docs/agent-protocols/LOCK_FORMAT.md` - Unified lock format: `[Locked: <agent-id>, <timestamp-utc>, <release>]`
- **PR Workflow**: `docs/agent-protocols/PR_WORKFLOW.md` - Standard pull request process
- **Backlog Parallelization**: `docs/agent-protocols/BACKLOG_PARALLELIZATION.md` - Structuring tasks for parallel work
- **CLI Scripts**: `scripts/agent/` provides optional wrappers for common workflows

**Helper Scripts**: `scripts/agent/` - Optional wrappers for repeatable CLI workflows (analyze/test/bootstrap)

## Architectural Anchors
- **Foundations**: Chapters 1-2 define ubiquitous language and aggregate boundaries—align new APIs with these definitions.
- **Behavioral Engine**: Chapters 4-6 and `docs/book/05-the-command-event-policy-cycle.md` govern command/event/policy contracts; keep naming and lifecycle consistent.
- **Mathematical Proofs**: Appendix D (persistence) and Appendix E (type safety) are mandatory reading before touching storage adapters or value objects.
- **Category Theory**: Reference `lib/mathematical_foundations/*` with Chapter 7’s meta-modeling narrative when adding morphisms or transformations.

## Quality Gates (0/0/0 + Green)
- Run `melos exec --scope="ednet_core" -- dart analyze` and ensure zero errors/warnings/infos.
- Execute `melos exec --scope="ednet_core" -- dart test --coverage` before submitting patches; CEP cycle suites may not be skipped without an RGR note.
- Update `coverage/` reports only via tooling; never hand-edit generated summaries.

## Contribution Workflow
- Prefer extension methods or new abstractions over modifying base classes; document rationale in `COMMAND_EVENT_POLICY_IMPLEMENTATION.md` when altering core semantics.
- Keep public API changes accompanied by migration guidance in `CHANGELOG.md` and cross-reference the relevant book chapter in the PR description.
- When integrating new analyzers or generators, stage experiments under `apps/` or `tools/` until stabilized.
- Track outstanding work for core in `BACKLOG.md`; avoid standalone WIP documents within this package.
- Respect the Backlog Protocol: select unlocked `[Stream: …]` items, add lock tags while working, and release them once analyzer/tests are green and docs updated.
- After passing quality gates, document the change as a single English sentence in `packages/core/CHANGELOG.md` before clearing the backlog entry; ensure the eventual commit message is one capitalized sentence ending with a period.

## Security: Secret Handling

**CRITICAL**: Never expose secrets (API keys, tokens, credentials) to LLM context or human output.

**See root `AGENTS.md` for full protocol.** Security tooling: `~/projects/security/`

### Key Patterns

**✅ SAFE**:
```bash
op-read-safe "op://vault/item/field" | command        # Direct piping
cmd --secret <(op-read-safe "op://vault/item/field")  # Process substitution
curl -H "Authorization: Bearer $(op-read-safe op://...)" https://api.example.com
```

**❌ FORBIDDEN**:
```bash
KEY=$(op read ...); echo $KEY  # Never echo secrets!
echo "Response: $response"     # May contain secrets
```

### Security Tooling

```bash
# Audit scripts for secret exposure
check-secret-exposure script.sh
check-secret-exposure --strict scripts/  # CI/CD mode
check-secret-exposure --fix script.sh    # Show fixes

# Safe 1Password wrapper
op-read-safe "op://vault/item/field"
op-read-safe --validate "op://..."       # Check existence
op-read-safe --check-format "op://..." "^sk-"  # Validate format
```

### Pre-Commit Checklist

- [ ] No secrets in `echo`/`printf`/`cat` statements
- [ ] All secret vars use piping/process substitution
- [ ] Debug output shows structure only, not values
- [ ] Tested with mock secrets first
- [ ] Ran `check-secret-exposure` on all shell scripts
