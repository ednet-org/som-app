# UI/UX Optimization Backlog

Based on HCI principles, Nielsen's heuristics, and Material 3 guidance.

## Priority Legend
- **P0**: Critical (blocks usability)
- **P1**: High (significant UX improvement)
- **P2**: Medium (polish)
- **P3**: Low (nice-to-have)

---

## P0: Critical Fixes

### Layout Overflow + Action Bars (Screenshots #1, #3, #6, #7)
- [ ] Replace the current `contextMenu` layout with a top toolbar (no left column).
- [ ] Add a shared `AppToolbar` that uses `Wrap`/`OverflowBar` for actions.
- [ ] Remove the hard-coded “Filters” label from `ExpandedBodyContainer`.
- [ ] Ensure toolbar actions never overflow on narrow widths.

### UUID + Date Formatting
- [x] Replace raw UUIDs with readable short IDs where displayed.
- [x] Replace ISO timestamps with readable dates/relative times.
- [ ] Audit remaining screens for raw IDs and raw timestamps.

### Theme Alpha Bug
- [x] Fix seed color alpha bug (`0x0044546a` -> `0xFF44546A`).

---

## P1: High Priority

### Material 3 Structure + Consistency
- [ ] Create shared layout widgets:
  - `AppToolbar` (title + actions + optional subtitle)
  - `SectionCard` / `DetailRow` for key-value blocks
  - `EmptyState` for empty lists
- [ ] Use M3 buttons consistently (Filled / Tonal / Outlined / Text).
- [ ] Standardize list tile density, padding, and hover/selection states.

### Status Visualization
- [x] Status badges and semantic colors.
- [ ] Apply status badges consistently in offers, ads, providers, companies.
- [ ] Add status legend hints where needed.

### State of System (HCI)
- [ ] Replace plain text loading with M3 indicators/skeletons.
- [ ] Use `SnackBar` for action feedback with success/error tones.
- [ ] Add inline error states in detail panels (not only toast).

### Accessibility
- [ ] Ensure minimum touch target (48dp) for icon actions.
- [ ] Add `Tooltip`/`Semantics` for icon-only actions.
- [ ] Verify contrast ratios for status colors in dark theme.

---

## P2: Medium Priority

### Design Tokens + Theme
- [x] Introduce spacing, radius, icon size tokens.
- [ ] Expand tokens for typography scales and component density.
- [ ] Create `som_theme.dart` to unify `ThemeData` (inputs, cards, dividers, buttons).

### Information Hierarchy
- [ ] Add section headers and visual grouping in detail views.
- [ ] Use two-column key/value layout for wider screens.
- [ ] Add “meta” styling for IDs and timestamps.

### Navigation + Responsiveness
- [ ] Evaluate `NavigationRail` on wide screens vs top bar.
- [ ] Ensure filters are collapsible on smaller widths.
- [ ] Add responsive breakpoints for list/detail split widths.

---

## P3: Nice-to-Have

### Motion
- [ ] Staggered list animations for initial load.
- [ ] Subtle transition between list selection states.

### UX Enhancements
- [ ] Inline search filtering with debounced input.
- [ ] Keyboard shortcuts for list navigation (desktop).
- [ ] Multi-select bulk actions (delete/approve/decline).

---

## Dependency + Platform Hygiene (P1)

### Flutter SDK + Packages
- [ ] Verify Flutter SDK is current stable; upgrade if behind.
- [ ] Upgrade key UI dependencies (provider, url_launcher, cached_network_image, shared_preferences).
- [ ] Re-run `flutter pub get` + full test suite.

---

## Nielsen's Heuristics Checklist

| Heuristic | Status | Notes |
|-----------|--------|-------|
| H1: Visibility of system status | Needs work | Missing loading/empty states |
| H2: Match between system and real world | Improving | Short IDs + dates applied |
| H3: User control and freedom | OK | Navigation works |
| H4: Consistency and standards | Needs work | Mixed button styles/layouts |
| H5: Error prevention | OK | Forms have validation |
| H6: Recognition over recall | Needs work | No consistent status badges |
| H7: Flexibility and efficiency | OK | Filters available |
| H8: Aesthetic and minimalist design | Needs work | Dense, no hierarchy |
| H9: Help users recognize errors | OK | Error messages shown |
| H10: Help and documentation | N/A | Admin tool |

---

## Progress Tracking

### Sprint 1: Layout + Overflow (P0)
- [ ] Toolbar layout refactor
- [ ] AppBody/ExpandedBodyContainer update
- [ ] Fix all toolbar overflow errors

### Sprint 2: Core Visual System (P1)
- [ ] Shared toolbar + empty state
- [ ] Status badges everywhere
- [ ] Detail cards + key/value layout

### Sprint 3: Accessibility + Theme (P2)
- [ ] Accessibility annotations + touch targets
- [ ] Unified Material 3 theme

