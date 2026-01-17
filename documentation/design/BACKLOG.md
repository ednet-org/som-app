# Design Backlog - UI/UX Overhaul & Asset Generation

## Overview
This backlog defines the **Detailed Design Specifications** and **Asset Requirements** for the SOM App.
Implementation Agents should follow these specs strictly to ensure a premium, state-of-the-art aesthetic.

## 1. Design System & Tokens
### Color Palette (Premium/Dark Mode)
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

### Typography (Modern Sans-Serif - e.g., Inter or Roboto)
- **H1 (Page Title)**: 32px, Bold, Tracking -0.5px
- **H2 (Section Title)**: 24px, SemiBold
- **H3 (Card Title)**: 18px, Medium
- **Body Regular**: 14px, Regular, Height 1.5
- **Body Small**: 12px, Regular
- **Label/Button**: 14px, SemiBold, Uppercase (optional)

### Global Layout Specs
- **Sidebar**: Fixed width `280px`, `bg-secondary` with `1px` border-right (`#334155`). Glassmorphism overlay optional.
- **Top Bar**: Height `64px`, `bg-primary` (or transparent with blur), Sticky.
- **Content Area**: Padding `24px` or `32px` (responsive).
- **Cards**: `bg-secondary`, `borderRadius: 16px`, `shadow-lg` (`0 10px 15px -3px rgba(0, 0, 0, 0.1)`).

## 2. Global & Domain Assets (SVGs)
All assets located in `assets/design_system/` organized by context:

### Global (`assets/design_system/`)
- `logo_full.svg`, `logo_mark.svg`
- `icon_dashboard.svg`, `icon_inquiries.svg`, `icon_offers.svg`, `icon_statistics.svg`, `icon_settings.svg`, `icon_user.svg`
- `illustration_empty_state.svg`

### Auth & Identity (`assets/design_system/auth/`)
- **Roles**: `role_buyer.svg`, `role_provider.svg` (Large selection cards)
- **Provider Types**: `type_wholesaler.svg`, `type_manufacturer.svg`, `type_service.svg`

### Inquiry (`assets/design_system/inquiry/`)
- **Status**: `status_open.svg`, `status_won.svg`, `status_lost.svg`
- **States**: `empty_inquiries.svg`

### Offers (`assets/design_system/offers/`)
- **Status**: `status_accepted.svg`, `status_rejected.svg`
- **Files**: `icon_pdf.svg`

### Ads (`assets/design_system/ads/`)
- **Placeholders**: `banner_placeholder.svg`, `sidebar_placeholder.svg`

### Statistics (`assets/design_system/statistics/`)
- **Icons**: `chart_bar.svg`, `chart_pie.svg`

### Subscription (`assets/design_system/subscription/`)
- **Tiers**: `tier_standard.svg`, `tier_premium.svg`, `tier_enterprise.svg`

## 2. Authentication (All Roles)
**Global Auth Layout**: Split screen. Left 50% `bg-primary` with `logo_full.svg` centered + marketing copy. Right 50% `bg-secondary` with form card.

### 2.1 Login Screen
- **Components**
    - `Input(Email)`: Placeholder "name@company.com", `bg-tertiary` border `text-secondary`.
    - `Input(Password)`: Toggle visibility icon.
    - `Button(Primary)`: "Sign In", full width, `accent-gradient`.
    - `Link`: "Forgot Password?", `text-secondary` hover `text-primary`.
- **States**:
    - Error: Show Toast `bg-error` + red border on inputs.

### 2.2 Registration - Landing (Role Selection)
- **Layout**: Centered container, max-width `800px`.
- **Header**: "Join SOM Network - Choose your path".
- **Cards**: Two large cards (`350x400px`).
    - **Buyer Card**: Icon `icon_inquiries.svg` (large), Title "Buyer", Text "Source products & services.", Button "Register as Buyer".
    - **Provider Card**: Icon `icon_offers.svg` (large), Title "Provider", Text "Grow your business.", Button "Register as Provider".
- **Interaction**: Hover scales card 1.05x, border glow `accent-primary`.

### 2.3 Registration - Forms (Buyer & Provider)
- **Multi-step Wizard**:
    - **Step 1: Company**: Name, Address, UID.
    - **Step 2: Contact**: Admin User (Name, Email, Phone).
    - **Step 3 (Provider Only)**: Banking, Subscriptions (3 column pricing table).
- **Validation**: Real-time check for Email uniqueness.


## 3. Buyer Role
**Common Layout**: Sidebar `[Dashboard, Inquiries, Offers, Statistics]`. Top Bar `[Search, Notifications, UserAvatar]`.

### 3.1 Dashboard
- **Stats Row**: 3 Cards.
    - "Active Inquiries": Value `12`, Icon `icon_inquiries.svg` (`text-info`).
    - "New Offers": Value `5`, Icon `icon_offers.svg` (`text-success`).
    - "Offers expire soon": Value `2`, Icon `icon_time.svg` (`text-warning`).
- **Recent Activity**: Table showing last 5 actions.
- **Ads Banner**: `height: 120px`, `bg-tertiary` (placeholder for ad image), rounded corners.

### 3.2 Inquiry Management
#### List View
- **Filter Bar**: `Dropdown(Status)`, `DateRangePicker`, `Input(Search)`.
- **Table Columns**: ID, Branch (Tag), Deadline (Date), Offers (Count badge), Status (Badge `bg-success/warning/error`).
- **Empty State**: Use `illustration_empty_state.svg` with text "No inquiries found. Create your first one!".

#### Create Inquiry (Wizard)
- **Step 1: Basics**:
    - `Dropdown(Branch)`: Searchable.
    - `TagsInput(Products)`: Chips with delete 'x'.
- **Step 2: Details**:
    - `DatePicker(Deadline)`: Min date = today + 3 days.
    - `TextArea(Description)`: Character count indicator.
    - `FileUpload`: Drag & Drop zone (PDF only).
- **Step 3: Provider**:
    - `Slider(Radius)`: 50km, 150km, 250km, Unlimited.
    - `CheckboxGroup(Type)`: Wholesaler, Manufacturer, Service.
- **Summary**: Read-only view of all fields + "Confirm & Send" button.

### 3.3 Offer Management
- **Offer Detail**:
    - **Header**: Provider Name, Price/Terms summary.
    - **PDF Viewer**: Embedded or "Download" button.
    - **Actions**:
        - `Button(Accept)`: Opens modal "Confirm Contact Details".
        - `Button(Reject)`: Opens modal "Reason for rejection" (optional).


## 4. Provider Role
**Common Layout**: Similar to Buyer but with "Ads Management" (Admin only).

### 4.1 Dashboard
- **Stats Row**:
    - "New Inquiries": Badge `bg-info`.
    - "Won Offers": Badge `bg-success`.
    - "Lost Offers": Badge `bg-error`.
- **Subscription Status Widget**: "Premium Plan - Expires in 30 days" + `Button(Upgrade)`.

### 4.2 Inquiry Management (Provider View)
- **Received Inquiries**: List view similar to Buyer.
- **Inquiry Detail**: Read-only view of Buyer's request.
- **Offer Creation**:
    - **Actions**: `Button(Upload Offer)` | `Button(Pass)`.
    - **Upload Modal**: Large drag & drop area for PDF. "Drop your offer here".
    - **Success State**: "Offer Uploaded!" Toast.

### 4.3 Ads Management (Admin)
- **Create Ad Flow**:
    - **Type Selection**: Banner (Enterprise) vs Normal.
    - **Scheduler**: Calendar view to pick available slots (Banner only).
    - **Content**: Image Upload (fixed aspect ratio validation), URL, Headline.
- **My Ads List**:
    - Columns: Image Preview, Type, Period, Status (Active/Draft/Expired).

### 4.4 Statistics & Subscription
- **Performance**: Bar chart comparing Inquiry Count vs Offer Count vs Won Count.
- **Billing**: Simple invoice list + Upgrade tier cards (Standard, Premium, Enterprise).


## 5. Consultant Role
**Focus**: Administration and Oversight.

### 5.1 Dashboard
- **Inbox**: "Pending Categories" (Review needed), "New Registrations" (Pending approval if any).
- **Search**: Global search bar for "Companies" or "Users".

### 5.2 User & Company Management
- **Registered Companies List**:
    - Combined table (Buyers & Providers).
    - Filters: Role, Status, Subscription Tier.
    - Actions: `Edit`, `Deactivate/Churn` (Modal confirmation).
- **Manual Onboarding**:
    - "Create On Behalf" form: Same as registration wizard but without validation blocks.

### 5.3 Inquiry Oversight
- **Global Inquiry List**: View ALL inquiries in the system.
- **Category Review**:
    - Queue of new branches/categories requested by Providers.
    - Actions: `Approve` (adds to global list), `Reject`, `Edit`.

## 6. Shared Widget Catalog
The following widgets should be implemented first as reusable components:

- [ ] `SOMCard`: Standard container with border-radius 16px, background `bg-secondary`, shadow.
- [ ] `SOMButton`: Variants (Primary `accent-gradient`, Secondary `outline`, Danger `text-error`).
- [ ] `SOMInput`: Text field with Label, Hint, Error state.
- [ ] `SOMBadge`: Status pill (Success, Warning, Error, Info, Neutral).
- [ ] `SOMTable`: Sortable headers, pagination footer, row hover effects.
- [ ] `SOMModal`: Overlay with Title, Content, Footer (Cancel/Confirm actions).
- [ ] `SOMSidebar`: Responsive navigation drawer using new SVG icons.
