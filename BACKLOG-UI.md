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
- [x] Replace the current `contextMenu` layout with a top toolbar (no left column).
- [x] Add a shared `AppToolbar` that uses wrapping actions.
- [x] Remove the hard-coded “Filters” label from `ExpandedBodyContainer`.
- [x] Ensure toolbar actions never overflow on narrow widths.

### UUID + Date Formatting
- [x] Replace raw UUIDs with readable short IDs where displayed.
- [x] Replace ISO timestamps with readable dates/relative times.
- [ ] Audit remaining screens for raw IDs and raw timestamps.

### Theme Alpha Bug
- [x] Fix seed color alpha bug (`0x0044546a` -> `0xFF44546A`).

---

## P1: High Priority

### Material 3 Structure + Consistency
- [x] Shared layout widgets:
  - `AppToolbar` (title + actions + optional subtitle)
  - `DetailSection` / `DetailRow` for key-value blocks
  - `EmptyState` for empty lists
- [ ] Apply new toolbar + empty state on all remaining screens.
- [ ] Use M3 buttons consistently (Filled / Tonal / Outlined / Text).
- [ ] Standardize list tile density, padding, and hover/selection states.

### Status Visualization
- [x] Status badges + semantic colors.
- [ ] Apply status badges consistently in offers, ads, providers, companies, branches.
- [ ] Add status legend hints where needed.

### State of System (HCI)
- [ ] Replace plain text loading with M3 indicators/skeletons.
- [ ] Use `SnackBar` for action feedback with success/error tones.
- [ ] Add inline error states in detail panels (not only toast).

### Accessibility
- [x] Minimum touch target (48dp) for icon actions.
- [ ] Add `Tooltip`/`Semantics` for icon-only actions.
- [ ] Verify contrast ratios for status colors in dark theme.

---

## P1: Theme + Density + Aesthetics

### Theme Switcher
- [x] Add light/dark/system switcher.
- [x] Add density switcher (compact/standard/comfortable).
- [x] Persist theme + density using shared preferences.
- [ ] Add user-level preference indicators in profile menu.

### Material 3 Color System (Aesthetic)
- [x] Base theme on `ThemeData.from(colorScheme: ColorScheme.fromSeed(...))`.
- [x] Explicitly set `useMaterial3: true` in theme definitions.
- [ ] Normalize use of `surfaceContainer*` roles for layers, avoid legacy `surfaceVariant`.
- [ ] Define semantic feedback colors against M3 surface containers.
- [ ] Add component themes where `VisualDensity` is ignored (IconButton/Checkbox/etc).

### Typography (Aesthetic)
- [x] Use `Typography.material2021()` defaults for both light/dark themes.
- [ ] Align usage to M3 type scale: display/headline/title/body/label.
- [ ] Audit heading hierarchy across admin pages.

---

## P2: Medium Priority

### Design Tokens + Theme
- [x] Introduce spacing, radius, icon size tokens.
- [x] Create `som_theme.dart` with Material 3 color scheme + component theming.
- [ ] Expand tokens for typography scales and component density.
- [ ] Extend theme to cover tables, data grids, dialogs.

### Information Hierarchy
- [ ] Add section headers and visual grouping in detail views.
- [ ] Use two-column key/value layout for wider screens.
- [ ] Add “meta” styling for IDs and timestamps.

### Navigation + Responsiveness
- [ ] Evaluate `NavigationRail` on wide screens vs top bar.
- [ ] Adopt M3 `NavigationBar` on narrow screens.
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
- [x] Verified Flutter SDK version.
- [x] Bumped `provider`, `url_launcher`, `shared_preferences`, `cached_network_image`.
- [ ] Review remaining outdated packages with `flutter pub outdated`.

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

## Widget File Index (Audit / Future Updates)

### Layout + Theme
- `lib/ui/domain/model/layout/app_body.dart`
- `lib/ui/domain/model/layout/expanded_body_container.dart`
- `lib/ui/theme/som_theme.dart`
- `lib/ui/theme/tokens.dart`
- `lib/ui/theme/semantic_colors.dart`
- `lib/ui/som_application.dart`
- `lib/ui/widgets/funny_logo.dart`

### Shared Widgets
- `lib/ui/widgets/app_toolbar.dart`
- `lib/ui/widgets/detail_section.dart`
- `lib/ui/widgets/empty_state.dart`
- `lib/ui/widgets/status_badge.dart`

### Screens (List + Detail)
- `lib/ui/pages/inquiry/inquiry_page.dart`
- `lib/ui/pages/inquiry/widgets/inquiry_list.dart`
- `lib/ui/pages/inquiry/widgets/inquiry_detail.dart`
- `lib/ui/pages/inquiry/widgets/offer_list.dart`
- `lib/ui/pages/offers/offers_app_body.dart`
- `lib/ui/pages/ads/ads_page.dart`
- `lib/ui/pages/ads/widgets/ads_list.dart`
- `lib/ui/pages/providers/providers_app_body.dart`
- `lib/ui/pages/companies/companies_app_body.dart`
- `lib/ui/pages/company/company_app_body.dart`
- `lib/ui/pages/branches/branches_app_body.dart`
- `lib/ui/pages/consultants/consultants_app_body.dart`
- `lib/ui/pages/subscriptions/subscriptions_app_body.dart`
- `lib/ui/pages/roles/roles_app_body.dart`
- `lib/ui/pages/user/user_app_body.dart`
- `lib/ui/pages/audit/audit_app_body.dart`
- `lib/ui/pages/statistics/statistics_app_body.dart`

---

## Progress Tracking

### Sprint 1: Layout + Overflow (P0)
- [x] Toolbar layout refactor
- [x] AppBody/ExpandedBodyContainer update
- [x] Fix all toolbar overflow errors

### Sprint 2: Core Visual System (P1)
- [x] Shared toolbar + empty state
- [x] Status badges + semantic colors
- [ ] Apply status badges everywhere
- [ ] Detail cards + key/value layout everywhere

### Sprint 3: Appearance + Theme (P1/P2)
- [x] Material 3 theme file
- [x] Light/dark/system switcher
- [x] Density switcher
- [ ] Persist theme + density
- [ ] Contrast audit + typography alignment
