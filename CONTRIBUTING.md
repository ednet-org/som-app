# Contributing to SOM

Thank you for your interest in contributing to SOM, a private B2B marketplace platform. This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Project Structure](#project-structure)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Requirements](#documentation-requirements)
- [Review Process](#review-process)
- [Additional Resources](#additional-resources)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please treat all community members with respect and professionalism. Any form of harassment, discrimination, or inappropriate behavior will not be tolerated.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.8 or higher
- **Dart SDK**: Included with Flutter, but ensure compatibility
- **Git**: For version control
- **Code Editor**: VS Code or Android Studio recommended
- **Supabase CLI**: For local database development (optional)

### Development Environment Setup

1. **Install Flutter SDK**

   Follow the official Flutter installation guide for your operating system:
   - [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

2. **Verify Installation**

   ```bash
   flutter doctor
   ```

   Ensure all required dependencies are installed.

### Clone and Setup

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd som-app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   cd api
   dart pub get
   cd ..
   ```

3. **Environment Configuration**

   Create a `.env` file in the root directory:

   ```bash
   cp .env.example .env
   ```

   Update the `.env` file with your local configuration:

   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   API_BASE_URL=http://localhost:8080
   ```

4. **Generate EDNet Domain Models** (if needed)

   ```bash
   # Follow EDNet Core generation instructions
   # Generated models will be placed in lib/generated/
   ```

5. **Run the Application**

   For Flutter app:
   ```bash
   flutter run
   ```

   For Dart Frog backend:
   ```bash
   cd api
   dart_frog dev
   ```

## Development Workflow

### Branch Naming Conventions

Use descriptive branch names following these patterns:

- `feature/<feature-name>` - New features
- `bugfix/<bug-description>` - Bug fixes
- `hotfix/<critical-fix>` - Critical production fixes
- `refactor/<refactor-scope>` - Code refactoring
- `docs/<documentation-update>` - Documentation updates

**Examples:**
- `feature/user-authentication`
- `bugfix/login-validation`
- `hotfix/payment-processing`

### Commit Message Format

Follow the conventional commit message format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, missing semicolons, etc.)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

**Examples:**
```
feat(auth): Add email verification flow.
fix(api): Resolve null pointer exception in user service.
docs(readme): Update installation instructions.
```

**Rules:**
- Use present tense ("Add feature" not "Added feature")
- Capitalize the first letter of the description
- End with a period
- Keep the subject line under 72 characters
- Provide detailed explanation in the body if needed

### Pull Request Process

1. **Create a Feature Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**

   - Write clean, readable code
   - Follow the code standards (see below)
   - Add or update tests as needed
   - Update documentation if required

3. **Run Quality Checks**

   ```bash
   # Analyze code
   dart analyze --fatal-infos

   # Run tests
   flutter test
   cd api && dart test
   ```

4. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "feat(scope): Your descriptive commit message."
   ```

5. **Push to Remote**

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**

   - Navigate to the repository on GitHub/GitLab
   - Click "New Pull Request"
   - Select your feature branch
   - Fill out the PR template with:
     - Description of changes
     - Related issue numbers
     - Testing performed
     - Screenshots (if UI changes)
   - Request review from maintainers

7. **Address Review Comments**

   - Make requested changes
   - Push additional commits
   - Respond to reviewer comments

8. **Merge**

   - Once approved, a maintainer will merge your PR
   - Delete your feature branch after merge

## Code Standards

### Dart/Flutter Style Guide

- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to automatically format code
- Adhere to Flutter best practices and widget conventions

### Analysis Options

All code must pass static analysis without errors or warnings:

```bash
dart analyze --fatal-infos
```

**Zero tolerance policy:**
- No errors
- No warnings
- No infos in core packages

Fix all analysis issues before submitting a PR.

### Testing Requirements

All contributions must include appropriate tests:

- **Unit Tests**: For business logic, services, and utilities
- **Widget Tests**: For Flutter widgets and UI components
- **Integration Tests**: For end-to-end user flows

**Minimum Coverage:**
- New features: 80% code coverage
- Bug fixes: Include regression tests
- Refactoring: Maintain or improve existing coverage

### Code Review Checklist

Before submitting a PR, ensure:

- [ ] Code follows Dart/Flutter style guide
- [ ] `dart analyze --fatal-infos` passes with zero issues
- [ ] All tests pass (`flutter test`, `dart test api/`)
- [ ] New code has adequate test coverage
- [ ] Documentation is updated (README, inline comments, dartdoc)
- [ ] Commit messages follow the format
- [ ] No secrets or sensitive data in code
- [ ] `.env` changes documented in `.env.example`

## Project Structure

```
som-app/
├── lib/                          # Flutter application code
│   ├── main.dart                 # Application entry point
│   ├── screens/                  # UI screens/pages
│   ├── widgets/                  # Reusable widgets
│   ├── services/                 # Business logic services
│   ├── models/                   # Data models
│   ├── generated/                # EDNet Core domain models (auto-generated)
│   ├── utils/                    # Utility functions
│   └── config/                   # Configuration files
├── api/                          # Dart Frog backend
│   ├── routes/                   # API route handlers
│   ├── middleware/               # API middleware
│   └── services/                 # Backend services
├── test/                         # Test files
│   ├── unit/                     # Unit tests
│   ├── widget/                   # Widget tests
│   └── integration/              # Integration tests
├── docs/                         # Additional documentation
│   └── ARCHITECTURE.md           # Architecture overview
├── .env.example                  # Environment variable template
├── pubspec.yaml                  # Flutter dependencies
└── analysis_options.yaml         # Dart analysis configuration
```

### Key Directories

- **`lib/`**: Contains all Flutter application code
- **`lib/generated/`**: Auto-generated EDNet domain models (do not edit manually)
- **`api/`**: Dart Frog backend API implementation
- **`test/`**: All test files mirroring the `lib/` structure

## Testing Guidelines

### Running Tests

**Flutter Tests:**
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
```

**Backend Tests:**
```bash
cd api
dart test

# Run with coverage
dart test --coverage=coverage
```

### Writing Tests

**Unit Test Example:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:som_app/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('login validates email format', () {
      final authService = AuthService();
      expect(
        () => authService.login('invalid-email', 'password'),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
```

**Widget Test Example:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:som_app/widgets/login_form.dart';

void main() {
  testWidgets('LoginForm displays email and password fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginForm()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
```

### Coverage Requirements

- **Minimum Coverage**: 80% for new code
- **Generate Coverage Report**:
  ```bash
  flutter test --coverage
  genhtml coverage/lcov.info -o coverage/html
  open coverage/html/index.html
  ```

## Documentation Requirements

All contributions should include appropriate documentation:

### Code Documentation

- **Public APIs**: Add dartdoc comments
- **Complex Logic**: Inline comments explaining why (not what)
- **Classes**: Document purpose and usage

**Example:**
```dart
/// Authenticates users and manages session state.
///
/// This service handles login, logout, and token refresh operations.
/// It integrates with Supabase authentication backend.
class AuthService {
  /// Logs in a user with email and password.
  ///
  /// Throws [ValidationException] if credentials are invalid.
  /// Returns a [User] object on successful authentication.
  Future<User> login(String email, String password) async {
    // Implementation
  }
}
```

### README Updates

Update `README.md` if your changes affect:
- Installation process
- Configuration
- Usage instructions
- Dependencies

### Architecture Documentation

For significant architectural changes, update `docs/ARCHITECTURE.md`.

## Review Process

### Peer Review

All PRs require at least one approval from a maintainer before merging.

**Reviewers will check:**
- Code quality and readability
- Test coverage and quality
- Adherence to standards
- Documentation completeness
- Performance implications
- Security considerations

### Addressing Feedback

- Respond to all review comments
- Make requested changes promptly
- Ask questions if feedback is unclear
- Keep discussions professional and constructive

### Merge Criteria

A PR can be merged when:
- [ ] All CI/CD checks pass
- [ ] At least one maintainer approval
- [ ] All review comments addressed
- [ ] No merge conflicts
- [ ] Documentation updated
- [ ] Tests pass with adequate coverage

## Additional Resources

- [README.md](./README.md) - Project overview and quick start
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) - System architecture and design
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- [Supabase Documentation](https://supabase.com/docs)
- [Dart Frog Documentation](https://dartfrog.vgv.dev/)
- [EDNet Core Documentation](https://github.com/dzenanr/ednet_core)

---

## Questions or Issues?

If you have questions or encounter issues:
- Check existing documentation
- Search through existing issues
- Open a new issue with detailed information
- Reach out to maintainers

Thank you for contributing to SOM! Your efforts help make this platform better for everyone.
