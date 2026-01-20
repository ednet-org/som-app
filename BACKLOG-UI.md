# UI/UX Optimization Backlog

Based on HCI principles, Nielsen's heuristics, and Material 3 guidance.

## Design System Spec (Source of Truth)

### 1) Design System & Tokens
#### Color Palette (Premium/Dark Mode)
- **Backgrounds**
  - `bg-primary`: `#0F172A` (Rich dark blue/slate)
  - `bg-secondary`: `#1E293B` (Lighter slate for cards/sidebar)
  - `bg-tertiary`: `#334155` (Hover states, specific widgets)
- **Accents**
  - `accent-primary`: `#38BDF8` (Bright distinct blue for primary actions)
  - `accent-secondary`: `#818CF8` (Soft indigo for secondary highlights)
  - `accent-gradient`: `Linear Gradient(135deg, #38BDF8 0%, #818CF8 100%)`
- **Text**
  - `text-primary`: `#F8FAFC` (Almost white)
  - `text-secondary`: `#94A3B8` (Muted blue-grey)
  - `text-disabled`: `#475569`
- **Semantic**
  - `success`: `#10B981` (Emerald)
  - `warning`: `#F59E0B` (Amber)
  - `error`: `#EF4444` (Red)
  - `info`: `#3B82F6` (Blue)

#### Typography (Modern Sans-Serif - e.g., Inter or Roboto)
- **H1 (Page Title)**: 32px, Bold, Tracking -0.5px
- **H2 (Section Title)**: 24px, SemiBold
- **H3 (Card Title)**: 18px, Medium
- **Body Regular**: 14px, Regular, Height 1.5
- **Body Small**: 12px, Regular
- **Label/Button**: 14px, SemiBold, Uppercase (optional)

#### Global Layout Specs
- **Sidebar**: Fixed width `280px`, `bg-secondary` with `1px` border-right (`#334155`). Glassmorphism overlay optional.
- **Top Bar**: Height `64px`, `bg-primary` (or transparent with blur), Sticky.
- **Content Area**: Padding `24px` or `32px` (responsive).
- **Cards**: `bg-secondary`, `borderRadius: 16px`, `shadow-lg` (`0 10px 15px -3px rgba(0, 0, 0, 0.1)`).

### 2) Global & Domain Assets (SVGs)
All assets located in `assets/design_system/` organized by context:

#### Global (`assets/design_system/`)
- `logo_full.svg`, `logo_mark.svg`
- `icon_dashboard.svg`, `icon_inquiries.svg`, `icon_offers.svg`, `icon_statistics.svg`, `icon_settings.svg`, `icon_user.svg`
- `illustration_empty_state.svg`

#### Common Actions (`assets/design_system/common/`)
- **Navigation**: `icon_menu.svg`, `icon_close.svg`, `icon_chevron_left.svg`, `icon_chevron_right.svg`, `icon_chevron_up.svg`, `icon_chevron_down.svg`
- **Actions**: `icon_search.svg`, `icon_filter.svg`, `icon_edit.svg`, `icon_delete.svg`, `icon_notification.svg`, `icon_calendar.svg`
- **Status Types**: `icon_warning.svg`, `icon_info.svg`
- **Input Controls**: `icon_visibility_on.svg`, `icon_visibility_off.svg`, `icon_clear_circle.svg` (for Inputs)

#### Patterns (`assets/design_system/patterns/`)
- **Textures**: `subtle_mesh.svg`, `dot_noise.svg` (For Cards/Backgrounds)

#### Illustrations (`assets/design_system/illustrations/`)
- **Hero**: `hero_landing_3d.svg` (Pseudo-3D isometric abstract composition)

#### Auth & Identity (`assets/design_system/auth/`)
- **Roles**: `role_buyer.svg`, `role_provider.svg` (Large selection cards)
- **Provider Types**: `type_wholesaler.svg`, `type_manufacturer.svg`, `type_service.svg`

#### Inquiry (`assets/design_system/inquiry/`)
- **Status**: `status_open.svg`, `status_won.svg`, `status_lost.svg`
- **States**: `empty_inquiries.svg`

#### Offers (`assets/design_system/offers/`)
- **Status**: `status_accepted.svg`, `status_rejected.svg`
- **Files**: `icon_pdf.svg`

#### Ads (`assets/design_system/ads/`)
- **Placeholders**: `banner_placeholder.svg`, `sidebar_placeholder.svg`

#### Statistics (`assets/design_system/statistics/`)
- **Icons**: `chart_bar.svg`, `chart_pie.svg`

#### Subscription (`assets/design_system/subscription/`)
- **Tiers**: `tier_standard.svg`, `tier_premium.svg`, `tier_enterprise.svg`

### 3) Screen-Level Specifications (must follow)
#### Authentication (All Roles)
- **Global Auth Layout**: Split screen. Left 50% `bg-primary` with `logo_full.svg` centered + marketing copy. Right 50% `bg-secondary` with form card.

##### Login Screen
- **Components**:
  - `Input(Email)`: Placeholder "name@company.com", `bg-tertiary` border `text-secondary`.
  - `Input(Password)`: Toggle visibility icon.
  - `Button(Primary)`: "Sign In", full width, `accent-gradient`.
  - `Link`: "Forgot Password?", `text-secondary` hover `text-primary`.
- **States**:
  - Error: Show Toast `bg-error` + red border on inputs.

##### Registration - Landing (Role Selection)
- **Layout**: Centered container, max-width `800px`.
- **Header**: "Join SOM Network - Choose your path".
- **Cards**: Two large cards (`350x400px`).
  - **Buyer Card**: Illustration `assets/design_system/auth/role_buyer.svg`, Title "Buyer", Text "Source products & services.", Button "Register as Buyer".
  - **Provider Card**: Illustration `assets/design_system/auth/role_provider.svg`, Title "Provider", Text "Grow your business.", Button "Register as Provider".
- **Interaction**: Hover scales card 1.05x, border glow `accent-primary`.

##### Registration - Forms (Buyer & Provider)
- **Multi-step Wizard**:
  - **Step 1: Company**: Name, Address, UID.
  - **Step 2: Contact**: Admin User (Name, Email, Phone).
  - **Step 3 (Provider Only)**: Banking, Subscriptions (3 column pricing table).
- **Validation**: Real-time check for Email uniqueness.

#### Buyer Role (Layout: Sidebar + Top Bar)
##### Dashboard
- **Stats Row**: 3 Cards.
  - "Active Inquiries": Value `12`, Icon `icon_inquiries.svg` (`text-info`).
  - "New Offers": Value `5`, Icon `icon_offers.svg` (`text-success`).
  - "Offers expire soon": Value `2`, Icon `icon_time.svg` (`text-warning`).
- **Recent Activity**: Table showing last 5 actions.
- **Ads Banner**: `height: 120px`, `bg-tertiary` (placeholder for ad image), rounded corners.

##### Inquiry Management
- **List View**:
  - **Filter Bar**: `Dropdown(Status)`, `DateRangePicker`, `Input(Search)`.
  - **Table Columns**: ID, Branch (Tag), Deadline (Date), Offers (Count badge), Status (Badge `bg-success/warning/error`).
  - **Empty State**: Use `illustration_empty_state.svg` with text "No inquiries found. Create your first one!".
- **Create Inquiry (Wizard)**:
  - **Step 1: Basics**: `Dropdown(Branch)`, `TagsInput(Products)`.
  - **Step 2: Details**: `DatePicker(Deadline)`, `TextArea(Description)` + count, `FileUpload` (PDF only).
  - **Step 3: Provider**: `Slider(Radius)`, `CheckboxGroup(Type)` (Wholesaler/Manufacturer/Service).
  - **Summary**: Read-only view + "Confirm & Send".

##### Offer Management
- **Offer Detail**:
  - **Header**: Provider Name, Price/Terms summary.
  - **PDF Viewer**: Embedded or "Download".
  - **Actions**:
    - `Button(Accept)`: Modal "Confirm Contact Details".
    - `Button(Reject)`: Modal "Reason for rejection" (optional).

#### Provider Role
##### Dashboard
- "New Inquiries" (info), "Won Offers" (success), "Lost Offers" (error)
- Subscription widget: "Premium Plan - Expires in 30 days" + `Button(Upgrade)`

##### Inquiry Management (Provider View)
- Read-only inquiry details + offer creation (upload PDF / pass)
- Upload modal with drag & drop zone and toast "Offer Uploaded!"

##### Ads Management (Admin)
- Banner vs Normal, calendar scheduling for banners
- Image upload (aspect ratio validation), URL, headline
- Ads list with status

##### Statistics & Subscription
- Bar chart (Inquiry vs Offer vs Won)
- Billing list + tier cards (Standard, Premium, Enterprise)

#### Consultant Role
- Dashboard inbox for approvals
- Search for companies/users
- Registered companies table with filters + actions
- Manual onboarding flow
- Global inquiry list and category review queue

### 4) Shared Widget Catalog (Reusable Components)
#### `SOMCard`
- **Assets**: `assets/design_system/patterns/subtle_mesh.svg` overlay for featured cards.
- **Specs**: Background `bg-secondary`, radius `16px`, shadow `shadow-lg`, padding `24px`.

#### `SOMButton`
- **Variants**: Primary (gradient), Secondary (outline), Ghost (text).
- **Icon Support**: prefix/suffix icons (e.g., `icon_chevron_right.svg`).

#### `SOMInput`
- **Assets**: `icon_visibility_on/off.svg`, `icon_clear_circle.svg`.
- **Specs**: Height `56px`, floating label, error state (red border + caption).

#### `SOMBadge`
- **Assets**:
  - Success: `assets/design_system/offers/status_accepted.svg`
  - Warning: `assets/design_system/common/icon_warning.svg`
  - Error: `assets/design_system/common/icon_close.svg` or `icon_delete.svg`
  - Info: `assets/design_system/common/icon_info.svg`
- **Specs**: Pill radius `99px`, padding `4px 12px`, uppercase text.

#### `SOMTable`
- **Assets**: `icon_chevron_up/down.svg`, `icon_edit.svg`, `icon_delete.svg`.
- **Specs**: Header `bg-surface-variant`, rows hover `bg-primary/5`.

#### `SOMModal`
- **Assets**: `icon_close.svg` in top-right.
- **Specs**: Max width `600px`, backdrop `bg-black/80` blur-sm.

#### `SOMSidebar`
- **Assets**: `logo_full.svg`, `icon_menu.svg`, nav icons.
- **Specs**: Width `280px` (expanded) / `80px` (collapsed), glassmorphism effect.

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
- [x] Audit remaining screens for raw IDs and raw timestamps.

### Theme Alpha Bug
- [x] Fix seed color alpha bug (`0x0044546a` -> `0xFF44546A`).

---

## P1: High Priority

### Material 3 Structure + Consistency
- [x] Shared layout widgets:
  - `AppToolbar` (title + actions + optional subtitle)
  - `DetailSection` / `DetailRow` for key-value blocks
  - `EmptyState` for empty lists
- [x] Apply new toolbar + empty state on all remaining screens.
- [x] Use M3 buttons consistently (Filled / Tonal / Outlined / Text).
- [x] Standardize list tile density, padding, and hover/selection states.

### Status Visualization
- [x] Status badges + semantic colors.
- [x] Apply status badges consistently in offers, ads, providers, companies, branches.
- [x] Add status legend hints where needed.

### State of System (HCI)
- [x] Replace plain text loading with M3 indicators/skeletons.
- [x] Use `SnackBar` for action feedback with success/error tones.
- [x] Add inline error states in detail panels (not only toast).

### Accessibility
- [x] Minimum touch target (48dp) for icon actions.
- [x] Add `Tooltip`/`Semantics` for icon-only actions.
- [ ] Verify contrast ratios for status colors in dark theme.

---

## P1: Theme + Density + Aesthetics

### Theme Switcher
- [x] Add light/dark/system switcher.
- [x] Add density switcher (compact/standard/comfortable).
- [x] Persist theme + density using shared preferences.
- [x] Add user-level preference indicators in profile menu.

### Design System Assets Integration
- [x] Register all `assets/design_system/**` entries in `pubspec.yaml`.
- [x] Create a single source of truth for asset paths (e.g., `SomAssets`).
- [x] Replace default Material icons with design system SVGs.
- [x] Add SVG placeholders for ads + empty states.
- [x] Add pattern overlays to cards where specified.

### Material 3 Color System (Aesthetic)
- [x] Base theme on `ThemeData.from(colorScheme: ColorScheme.fromSeed(...))`.
- [x] Explicitly set `useMaterial3: true` in theme definitions.
- [x] Normalize use of `surfaceContainer*` roles for layers, avoid legacy `surfaceVariant`.
- [x] Define semantic feedback colors against M3 surface containers.
- [x] Add component themes where `VisualDensity` is ignored (IconButton/Checkbox/etc).

### Typography (Aesthetic)
- [x] Use `Typography.material2021()` defaults for both light/dark themes.
- [ ] Align usage to M3 type scale: display/headline/title/body/label.
- [ ] Audit heading hierarchy across admin pages.

---

## P2: Medium Priority

### Design Tokens + Theme
- [x] Introduce spacing, radius, icon size tokens.
- [x] Create `som_theme.dart` with Material 3 color scheme + component theming.
- [x] Expand tokens for typography scales and component density.
- [x] Extend theme to cover tables, data grids, dialogs.

### Information Hierarchy
- [x] Add section headers and visual grouping in detail views.
- [x] Use two-column key/value layout for wider screens.
- [x] Add “meta” styling for IDs and timestamps.

### Navigation + Responsiveness
- [x] Evaluate `NavigationRail` on wide screens vs top bar.
- [x] Adopt M3 `NavigationBar` on narrow screens.
- [x] Ensure filters are collapsible on smaller widths.
- [x] Add responsive breakpoints for list/detail split widths.

---

## P3: Nice-to-Have

### Motion
- [x] Staggered list animations for initial load.
- [x] Subtle transition between list selection states.

### UX Enhancements
- [x] Inline search filtering with debounced input.
- [x] Keyboard shortcuts for list navigation (desktop).
- [x] Multi-select bulk actions (delete/approve/decline).

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

### High-Fidelity Illustrations (`assets/design_system/illustrations/`)
These higher-abstraction assets replace standard material placeholders for premium impact.

- **Onboarding**:
  - `hero_landing_3d.svg`: (Landing Page) Pseudo-3D isometric abstract composition using brand gradient.
- **Feature Highlights**:
  - `feature_analytics.svg`: (Features) Floating 3D charts and glassmorphism data cards.
  - `feature_secure_auth.svg`: (Features) Shield lock concept for trust badges.
- **Complex States**:
  - `state_success_celebration.svg`: (Success) Confetti and motion lines for major completion events.
  - `state_server_error.svg`: (Error) Robot/Server crash metaphor for 500 errors.
  - `state_no_connection.svg`: (Offline) Stylized disconnected cloud.
- **Hero**: `login_hero.svg` (Abstract network concept)

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
- [x] Apply status badges everywhere
- [x] Detail cards + key/value layout everywhere

### Sprint 3: Appearance + Theme (P1/P2)
- [x] Material 3 theme file
- [x] Light/dark/system switcher
- [x] Density switcher
- [x] Persist theme + density
- [ ] Contrast audit + typography alignment
