# UI/UX Optimization Backlog

Based on HCI principles, Nielsen's heuristics, and modern design best practices.

## Priority Legend
- **P0**: Critical (blocks usability)
- **P1**: High (significant UX improvement)
- **P2**: Medium (polish)
- **P3**: Low (nice-to-have)

---

## P0: Critical Fixes

### UUID Display Issue
- [ ] Replace raw UUIDs with meaningful identifiers in list views
- [ ] Files: `inquiry_list.dart`, `ads_list.dart`, `offers_app_body.dart`
- [ ] Use `SomFormatters.shortId()` utility for truncated display

### Date Formatting
- [ ] Replace ISO timestamps with human-readable dates
- [ ] Files: `inquiry_detail.dart` (lines 86-100), `ads_detail.dart`, `offers_app_body.dart`
- [ ] Use `SomFormatters.date()`, `dateTime()`, `relative()` utilities

### Theme Alpha Bug
- [ ] Fix seed color: `0x0044546a` (transparent!) to `0xFF44546A`
- [ ] File: `lib/main.dart`

---

## P1: High Priority

### Status Visualization
- [ ] Create `StatusBadge` widget with color coding
- [ ] Apply to: inquiry list, offer list, ads list
- [ ] Define semantic colors for each status type
- [ ] Files: Create `lib/ui/widgets/status_badge.dart`, `lib/ui/theme/semantic_colors.dart`

### Visual Hierarchy in Detail Views
- [ ] Bold labels, regular values (two-column layout)
- [ ] Group related fields with section headers
- [ ] Add proper spacing between field groups
- [ ] Files: `inquiry_detail.dart`, `ads_detail.dart`

### Empty States
- [ ] Add empty state messages for all lists
- [ ] Include helpful CTAs ("Create your first inquiry")
- [ ] Files: All list widgets

### Loading States
- [ ] Add loading indicators for async operations
- [ ] Consider skeleton loaders for lists
- [ ] Files: All page widgets

---

## P2: Medium Priority

### Design Tokens
- [ ] Create `lib/ui/theme/tokens.dart` (spacing: 4, 8, 16, 24, 32; radius: 4, 8, 12)
- [ ] Create `lib/ui/theme/semantic_colors.dart` (success, warning, error, info)
- [ ] Create `lib/ui/theme/som_theme.dart` (unified ThemeData)

### Component Standardization
- [ ] Unify card styling across app (elevation, border radius, padding)
- [ ] Standardize button hierarchy (primary/secondary/text)
- [ ] Create consistent form field styling

### Information Density
- [ ] Add collapsible sections in detail views
- [ ] Implement progressive disclosure for complex forms
- [ ] Reduce cognitive load with better grouping

### List Item Improvements
- [ ] Add leading avatars/icons for visual scanning
- [ ] Show relative timestamps ("2 days ago")
- [ ] Add subtle status indicators (colored dots/borders)

---

## P3: Nice-to-Have

### Animations
- [ ] Add subtle transitions between views
- [ ] Animate list item additions/removals
- [ ] Loading shimmer effects

### Accessibility
- [ ] Add semantic labels for screen readers
- [ ] Ensure sufficient color contrast (WCAG AA)
- [ ] Support dynamic type sizing
- [ ] Test with VoiceOver/TalkBack

### Dark Mode Polish
- [ ] Verify all semantic colors work in dark mode
- [ ] Test status colors for accessibility
- [ ] Ensure proper contrast ratios

### Micro-interactions
- [ ] Button press feedback
- [ ] Pull-to-refresh animations
- [ ] Success/error state transitions

---

## Nielsen's Heuristics Checklist

| Heuristic | Status | Notes |
|-----------|--------|-------|
| H1: Visibility of system status | Needs work | Missing loading/empty states |
| H2: Match between system and real world | Needs work | UUIDs, ISO dates visible |
| H3: User control and freedom | OK | Navigation works |
| H4: Consistency and standards | Needs work | Mixed button styles |
| H5: Error prevention | OK | Forms have validation |
| H6: Recognition over recall | Needs work | No status badges/icons |
| H7: Flexibility and efficiency | OK | Filters available |
| H8: Aesthetic and minimalist design | Needs work | Dense, no hierarchy |
| H9: Help users recognize errors | OK | Error messages shown |
| H10: Help and documentation | N/A | Admin tool |

---

## Files Reference

### To Create
| File | Priority | Purpose |
|------|----------|---------|
| `lib/ui/utils/formatters.dart` | P0 | Date/ID formatting utilities |
| `lib/ui/theme/tokens.dart` | P2 | Design tokens (spacing, radius) |
| `lib/ui/theme/semantic_colors.dart` | P1 | Status colors mapping |
| `lib/ui/widgets/status_badge.dart` | P1 | Reusable status chip |
| `lib/ui/widgets/empty_state.dart` | P1 | Empty list placeholder |

### To Modify
| File | Priority | Changes |
|------|----------|---------|
| `lib/main.dart` | P0 | Fix alpha bug |
| `lib/ui/pages/inquiry/widgets/inquiry_list.dart` | P0 | Better list items |
| `lib/ui/pages/inquiry/widgets/inquiry_detail.dart` | P0 | Better detail layout |
| `lib/ui/pages/ads/widgets/ads_list.dart` | P1 | Better list items |
| `lib/ui/pages/offers/offers_app_body.dart` | P1 | Better list items |

---

## Progress Tracking

### Sprint 1: Critical Fixes (P0)
- [ ] Formatters utility
- [ ] Fix UUIDs in inquiry list
- [ ] Fix dates in inquiry detail
- [ ] Fix theme alpha bug

### Sprint 2: Visual Polish (P1)
- [ ] StatusBadge widget
- [ ] Semantic colors
- [ ] Apply to all lists
- [ ] Empty states

### Sprint 3: Design System (P2)
- [ ] Design tokens
- [ ] Unified theme
- [ ] Component standardization
