# Repository Guidelines

## Project Structure & Module Organization
The Flutter app code lives in `lib/` (notably `lib/domain`, `lib/data`, `lib/ui`, and `lib/generated`). Assets and localization are under `assets/`, `images/`, `fonts/`, and `lang/`. Tests are in `test/` (unit/widget) and `integration_test/` (end-to-end). Platform shells live in `android/`, `ios/`, `web/`, `linux/`, and `windows/`. API specs and tooling are in `openapi/`, `swagger.json`, and `scripts/`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run` launches the app locally.
- `flutter test` runs unit/widget tests.
- `flutter test integration_test` runs integration tests.
- `flutter analyze` runs the Dart analyzer (required before commits).
- `dart format .` formats Dart code.
- `dart run build_runner build --delete-conflicting-outputs` regenerates code (e.g., `lib/generated`).

## Coding Style & Naming Conventions
Follow `flutter_lints` from `analysis_options.yaml`. Use 2-space indentation; the formatter is the source of truth. Use `lower_snake_case.dart` for files, `UpperCamelCase` for types, and `lowerCamelCase` for variables and methods. Keep business rules in `lib/domain` and use `ednet_core` for domain modeling and refactors.

## Testing Guidelines
Primary frameworks are `flutter_test` and `integration_test`. Name tests with the `_test.dart` suffix (e.g., `test/widget_test.dart`). Use Red–Green–Refactor for new behavior. Keep mocks inside test suites and centralize shared test models.

## Commit & Pull Request Guidelines
Commit subjects are short and present-tense; history shows plain subjects and optional prefixes like `feat(som):` or `impl:`. PRs should include a concise summary, linked issue/ticket, and screenshots for UI changes. Call out any code generation steps required to reproduce changes.

## Agent-Specific Instructions (EDNet)
Run the analyzer and resolve all issues before committing. Keep generated code separate from hand-written code and maintain YAML compatibility for generators. If you add repo-specific learnings, update `Learned.Knowledge`.
