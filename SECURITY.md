# Security Policy

## Overview

SOM (Sistem Otvorenog Tržišta) is a B2B marketplace platform that handles sensitive business data including company registration details, user credentials, business inquiries, subscription information, and banking details. We take security seriously and are committed to protecting our users' data.

## Supported Versions

We actively support and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We appreciate the security research community's efforts in helping us maintain a secure platform. If you discover a security vulnerability, please report it responsibly.

### How to Report

**Contact**: Please send security vulnerability reports to **security@som-app.com**

**DO NOT** create public GitHub issues for security vulnerabilities.

### What to Include

When reporting a vulnerability, please provide:

- Detailed description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Proof of concept (if applicable)
- Suggested remediation (if available)
- Your contact information for follow-up

### Response Timeline

- **Acknowledgment**: We will acknowledge receipt of your report within **48 hours**
- **Initial Assessment**: We will provide an initial assessment within **7 days**
- **Progress Updates**: We will keep you informed of our progress throughout the investigation
- **Resolution**: We will work to resolve confirmed vulnerabilities as quickly as possible based on severity

## Security Measures

### Authentication & Access Control

#### JWT Authentication
- Secure JWT token-based authentication for all API requests
- Token expiration and refresh mechanisms
- Secure token storage in Flutter secure storage
- Automatic token invalidation on logout

#### Role-Based Access Control (RBAC)
- **Buyer**: Access to browse offers, submit inquiries, manage company profile
- **Provider**: Access to create/manage offers, respond to inquiries
- **Consultant**: Access to both buyer and provider features
- **Admin**: Full platform access with moderation capabilities

#### Session Management
- Secure session handling with configurable timeout
- Automatic session invalidation after inactivity
- Single sign-out across all devices (optional)

### Network Security

#### HTTPS Enforcement
- All API communications are conducted over HTTPS/TLS 1.3
- Strict Transport Security (HSTS) headers enforced
- Certificate pinning for critical API endpoints
- No plaintext transmission of sensitive data

#### CORS Configuration
- Restrictive Cross-Origin Resource Sharing (CORS) policies
- Whitelist-based allowed origins
- Credentials handling properly configured

### Data Security

#### Input Validation
- Client-side validation for immediate user feedback
- Server-side validation for all user inputs
- Sanitization of user-generated content
- Type-safe data models with validation constraints

#### SQL Injection Prevention
- Supabase PostgreSQL with parameterized queries
- Row Level Security (RLS) policies enforced
- Prepared statements for all database operations
- No dynamic SQL query construction from user input

#### XSS Prevention
- Content Security Policy (CSP) headers
- Output encoding for user-generated content
- Sanitization of HTML in rich text fields

### Data Protection

#### GDPR Compliance
- Right to access personal data
- Right to data portability
- Right to erasure (right to be forgotten)
- Data processing consent management
- Privacy by design and default
- Data minimization principles

#### Encryption

**At Rest**:
- Database encryption using Supabase's encryption at rest
- Encrypted local storage for sensitive cached data
- Passwords hashed using bcrypt (server-side)
- Secure key management for encryption keys

**In Transit**:
- TLS 1.3 for all network communications
- Certificate validation enforced
- Encrypted WebSocket connections for real-time features

#### Sensitive Data Handling

**Passwords**:
- Never stored in plaintext
- Bcrypt hashing with appropriate cost factor (server-side)
- Password strength requirements enforced
- Secure password reset mechanism

**Banking Information (IBAN/BIC)**:
- Encrypted storage with field-level encryption
- Access restricted to authorized roles only
- Masked display in UI (e.g., `AL** **** **** **** **34`)
- Audit logging for all access to banking data

**Personal Identifiable Information (PII)**:
- Minimal data collection principle
- Encrypted storage for sensitive fields
- Access logging and monitoring
- Secure deletion when no longer needed

### Dependency Security

- Regular dependency audits using `flutter pub outdated`
- Automated vulnerability scanning with Dependabot
- Prompt updates for security patches
- Review of third-party package security advisories
- Pinned dependency versions in `pubspec.lock`

### Mobile App Security

- Secure local storage using `flutter_secure_storage`
- Biometric authentication support (fingerprint/Face ID)
- Root/jailbreak detection
- Certificate pinning for API endpoints
- Obfuscated code in release builds
- No sensitive data in logs or crash reports

## Disclosure Policy

### Responsible Disclosure

We follow a responsible disclosure process:

1. Security researcher reports vulnerability privately
2. We acknowledge and investigate the report
3. We develop and test a fix
4. We deploy the fix to production
5. We coordinate public disclosure with the researcher

### Public Disclosure Timeline

- **90 days** after initial report, we will publicly disclose the vulnerability
- Earlier disclosure may occur if:
  - The vulnerability is already publicly known
  - Active exploitation is detected
  - Mutual agreement with the researcher
- We will credit researchers who report vulnerabilities (unless they prefer to remain anonymous)

## Security Best Practices for Contributors

If you are contributing to the SOM project, please follow these security guidelines:

### Code Security

- Never commit secrets, API keys, or credentials to the repository
- Use environment variables for configuration
- Follow secure coding guidelines for Flutter/Dart
- Perform code reviews with security in mind
- Write unit and integration tests for security-critical code

### Dependencies

- Only add dependencies from trusted sources
- Review dependency licenses and security advisories
- Keep dependencies up to date
- Avoid deprecated or unmaintained packages

### Data Handling

- Minimize collection and storage of sensitive data
- Never log sensitive information (passwords, tokens, banking details)
- Use parameterized queries for database operations
- Validate and sanitize all user inputs

### Authentication & Authorization

- Never bypass authentication checks
- Implement proper authorization for all sensitive operations
- Use secure session management
- Test access control thoroughly

### Testing

- Include security test cases in test suites
- Test for common vulnerabilities (SQL injection, XSS, CSRF)
- Perform penetration testing for critical features
- Use static analysis tools (e.g., `dart analyze --fatal-infos`)

## Security Contact

For security-related inquiries, please contact:

**Email**: security@som-app.com

For general support, please use the standard support channels.

## Acknowledgments

We appreciate the security researchers and contributors who help keep SOM secure. Researchers who responsibly disclose vulnerabilities will be acknowledged in our security advisories (unless they prefer anonymity).

---

**Last Updated**: January 22, 2026
**Version**: 1.0.0
