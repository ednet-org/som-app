# Prompt for High-Fidelity SOM App Asset Generation

**Role**: Expert UI/UX Designer, SVG Artist & Flutter Theme Specialist.

**Context**: 
We are building the SOM App, a B2B trading platform. We need "Higher Order" media to elevate the user experience. The design language is **Corporate Futuristic**, **Slick**, and **Minimalist**. 
**Core Palette**: Deep blue/slate backgrounds (`#0F172A`), electric blue/indigo accents (`#38BDF8`).

**Objective**: 
1. Generate missing SVG assets following strict "Futuristic/Slick" guidelines.
2. Define specific Flutter Material 3 `ThemeData` adjustments to enforce this identity.

## 1. Aesthetics & Style Guide (Strict Adherence)
- **Style**: Futuristic, Cyberpunk-Lite, Glassmorphism, Precision.
- **Stroke**: **ULTRA-THIN LINES ONLY** (`stroke-width="0.5"` to `1.0`). **NO BOLD LINES**.
- **Shapes**: Sharp or minimally rounded corners. Geometric precision.
- **Vibe**: High-tech, data-driven, premium business.
- **Colors**:
  - Primary Gradient: `#38BDF8` (Sky) to `#818CF8` (Indigo).
  - Background Elements: `#1E293B` (Slate-800) with low opacity.
  - Accent Glows: cyan/purple blurs.

## 2. Requested Assets (The "Missing" List)

### A. Wizard & Progression (Onboarding)
- **`stepper_company_info.svg`**: Thin-line abstract skyscraper or digital ID card.
- **`stepper_verification.svg`**: A shield outline with a scanning laser line.
- **`stepper_complete.svg`**: A minimalist flag or "mission accomplished" geometric symbol.

### B. Specific Empty States (Futuristic)
- **`empty_notifications.svg`**: A silent bell composed of dots or thin lines.
- **`empty_search_results.svg`**: A digital wireframe box searching the void.
- **`empty_ads.svg`**: A placeholder frame with "AD SPACE" in tech font.

### C. Rich Interaction Feedback
- **`state_upload_drag_drop.svg`**: A dashed data-stream rectangle with a download arrow.
- **`state_upload_success.svg`**: A thin-line checkmark constructing itself.
- **`state_tier_upgrade.svg`**: A chevron arrow pointing up with a glow effect.

### D. Decorative Background Patterns
- **`bg_pattern_finance.svg`**: Extremely subtle hex-grid or financial chart lines (5% opacity).
- **`bg_pattern_network.svg`**: Constellation/Node map connection lines (5% opacity).

## 3. Flutter Material 3 Theme Definitions
Please provide a Dart code snippet defining the `ThemeData` adjustments to match this "Slick" identity.
**Requirements**:
- **InputDecoration**: Minimalist. Underline or very thin outline. Floating labels.
- **CardTheme**: Low elevation, `clipBehavior.antiAlias`, thin border (`BorderSide(color: Colors.white10)`).
- **DividerTheme**: `thickness: 0.5`.
- **TextTheme**: Use "Inter" or "Exo 2" with tight tracking for headers.

## 4. Output Format
For each asset:
1.  **Filename**: e.g., `assets/design_system/wizards/stepper_company.svg`
2.  **SVG Code**: Clean, minimized SVG code.
3.  **UI Integration Instruction**: Snippet for `BACKLOG-UI.md`.
