part of ednet_core;

/// **DomainRole Value Object - Domain-Driven Role System**
///
/// Replaces hardcoded role strings with configurable domain-driven roles.
/// Implements proper role-based access control with permissions and hierarchy.
///
/// **Key Features:**
/// - Configurable role definitions (not hardcoded)
/// - Permission-based authorization
/// - Role inheritance hierarchy
/// - Domain model integration
/// - Policy-driven evaluation
///
/// **Usage:**
/// ```dart
/// final adminRole = DomainRole(
///   code: 'admin',
///   name: 'Administrator',
///   permissions: {'create', 'read', 'update', 'delete', 'manage_users'},
///   description: 'Full system access'
/// );
///
/// final editorRole = DomainRole(
///   code: 'editor',
///   name: 'Content Editor',
///   permissions: {'create', 'read', 'update'},
///   parentRoles: {adminRole},
///   description: 'Content management access'
/// );
/// ```
class DomainRole {
  /// Unique role identifier
  final String code;

  /// Human-readable role name
  final String name;

  /// Set of permissions granted by this role
  final Set<String> permissions;

  /// Parent roles for inheritance
  final Set<DomainRole> parentRoles;

  /// Optional description
  final String? description;

  /// Role hierarchy level (higher numbers = more permissions)
  final int level;

  DomainRole({
    required this.code,
    required this.name,
    this.permissions = const {},
    this.parentRoles = const {},
    this.description,
    this.level = 0,
  });

  /// Creates a copy with modified properties
  DomainRole copyWith({
    String? code,
    String? name,
    Set<String>? permissions,
    Set<DomainRole>? parentRoles,
    String? description,
    int? level,
  }) {
    return DomainRole(
      code: code ?? this.code,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
      parentRoles: parentRoles ?? this.parentRoles,
      description: description ?? this.description,
      level: level ?? this.level,
    );
  }

  /// Gets all permissions including inherited ones
  Set<String> get allPermissions {
    final allPerms = <String>{};

    // Add direct permissions
    allPerms.addAll(permissions);

    // Add permissions from parent roles (recursive)
    for (final parent in parentRoles) {
      allPerms.addAll(parent.allPermissions);
    }

    return allPerms;
  }

  /// Checks if this role has a specific permission
  bool hasPermission(String permission) {
    return allPermissions.contains(permission);
  }

  /// Checks if this role inherits from another role
  bool inheritsFrom(DomainRole other) {
    // Check direct parent relationship by code
    if (parentRoles.any((parent) => parent.code == other.code)) {
      return true;
    }

    // Check recursively through parent hierarchy
    return parentRoles.any((parent) => parent.inheritsFrom(other));
  }

  /// Checks if this role is at or above another role in hierarchy
  bool isAtLeast(DomainRole other) {
    return level >= other.level;
  }

  /// Value-based equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DomainRole) return false;
    return code == other.code &&
        name == other.name &&
        permissions.difference(other.permissions).isEmpty &&
        other.permissions.difference(permissions).isEmpty &&
        _parentRoleCodes().difference(_parentRoleCodes(other)).isEmpty &&
        other._parentRoleCodes().difference(_parentRoleCodes()).isEmpty &&
        description == other.description &&
        level == other.level;
  }

  /// Helper method to get parent role codes for equality comparison
  Set<String> _parentRoleCodes([DomainRole? role]) {
    final targetRole = role ?? this;
    return targetRole.parentRoles.map((r) => r.code).toSet();
  }

  @override
  int get hashCode {
    return Object.hash(
      code,
      name,
      permissions,
      _parentRoleCodes(),
      description,
      level,
    );
  }

  @override
  String toString() {
    return 'Role(code: $code, name: $name, permissions: $permissions, level: $level)';
  }
}

/// **DomainRole Registry - Manages Available Roles**
///
/// Central registry for all system roles with validation and lookup.
/// Ensures role consistency across the application.
///
class DomainRoleRegistry {
  final Map<String, DomainRole> _roles = {};

  /// Registers a new role in the system
  void registerRole(DomainRole role) {
    if (_roles.containsKey(role.code)) {
      throw ArgumentError('Role with code "${role.code}" already exists');
    }
    _roles[role.code] = role;
  }

  /// Updates an existing role or registers if it doesn't exist
  void updateRole(DomainRole role) {
    _roles[role.code] = role;
  }

  /// Gets a role by its code
  DomainRole? getRole(String code) => _roles[code];

  /// Gets all registered roles
  List<DomainRole> get allRoles => _roles.values.toList();

  /// Checks if a role code is registered
  bool hasRole(String code) => _roles.containsKey(code);

  /// Gets roles that have a specific permission
  List<DomainRole> getRolesWithPermission(String permission) {
    return _roles.values
        .where((role) => role.hasPermission(permission))
        .toList();
  }

  /// Validates that a role code exists
  bool isValidRole(String code) => hasRole(code);

  /// Clears all registered roles (for testing)
  void clear() => _roles.clear();
}

/// **Standard Domain Roles - Predefined Common Roles**
///
/// Provides standard role definitions that can be used across applications.
/// These can be extended or customized as needed.
///
class StandardDomainRoles {
  // Administrative roles
  static final admin = DomainRole(
    code: 'admin',
    name: 'Administrator',
    permissions: {
      'create',
      'read',
      'update',
      'delete',
      'manage_users',
      'manage_system',
      'view_analytics',
    },
    level: 100,
    description: 'Full system access and user management',
  );

  static final moderator = DomainRole(
    code: 'moderator',
    name: 'Moderator',
    permissions: {
      'create',
      'read',
      'update',
      'delete',
      'moderate_content',
      'view_analytics',
    },
    level: 75,
    description: 'Content moderation and management',
  );

  // Content roles
  static final editor = DomainRole(
    code: 'editor',
    name: 'Editor',
    permissions: {'create', 'read', 'update', 'publish'},
    level: 50,
    description: 'Content creation and editing',
  );

  static final author = DomainRole(
    code: 'author',
    name: 'Author',
    permissions: {'create', 'read', 'update'},
    level: 40,
    description: 'Content creation',
  );

  // User roles
  static final member = DomainRole(
    code: 'member',
    name: 'Member',
    permissions: {'read'},
    level: 10,
    description: 'Basic membership access',
  );

  static final guest = DomainRole(
    code: 'guest',
    name: 'Guest',
    permissions: {'read_public'},
    level: 5,
    description: 'Limited public access',
  );

  /// Registers all standard roles with a registry
  static void registerStandardDomainRoles(DomainRoleRegistry registry) {
    registry.registerRole(admin);
    registry.registerRole(moderator);
    registry.registerRole(editor);
    registry.registerRole(author);
    registry.registerRole(member);
    registry.registerRole(guest);
  }

  /// Creates a role hierarchy with proper inheritance
  static void setupDomainRoleHierarchy(DomainRoleRegistry registry) {
    // Get the registered role instances to ensure proper references
    final registeredMember = registry.getRole('member')!;
    final registeredAuthor = registry.getRole('author')!;
    final registeredModerator = registry.getRole('moderator')!;
    final registeredEditor = registry.getRole('editor')!;

    // Update roles with parent relationships using registered instances
    final updatedModerator = registeredModerator.copyWith(
      parentRoles: {registeredMember},
    );
    registry.updateRole(updatedModerator);

    final updatedEditor = registeredEditor.copyWith(
      parentRoles: {registeredAuthor},
    );
    registry.updateRole(updatedEditor);

    final updatedAuthor = registeredAuthor.copyWith(
      parentRoles: {registeredMember},
    );
    registry.updateRole(updatedAuthor);
  }
}

/// **Domain Role-Based Policy - Domain-Driven Authorization**
///
/// Simple policy for evaluating role-based permissions.
/// Works with the test framework for role-based authorization.
///
class DomainRoleBasedPolicy {
  final DomainRole requiredRole;
  final String? requiredPermission;
  final bool requireAllPermissions;

  DomainRoleBasedPolicy(
    this.requiredRole, {
    this.requiredPermission,
    this.requireAllPermissions = false,
  });

  String get name => 'DomainRolePolicy_${requiredRole.code}';
  String get description => 'Policy requiring role: ${requiredRole.name}';

  /// Evaluates the policy against an entity with provided context
  bool evaluate(Object entity, [Map<String, dynamic>? context]) {
    if (context == null) return false;

    // Get role registry from context
    final roleRegistry = context['roleRegistry'] as DomainRoleRegistry?;
    if (roleRegistry == null) return false;

    // Get user role from context
    final userRoleCode = context['userRole'] as String?;
    if (userRoleCode == null) return false;

    // Get the user's role from registry
    final userRole = roleRegistry.getRole(userRoleCode);
    if (userRole == null) return false;

    // Check if user role meets the required role level
    if (!userRole.isAtLeast(requiredRole)) return false;

    // Check specific permission if required
    if (requiredPermission != null) {
      return userRole.hasPermission(requiredPermission!);
    }

    return true;
  }
}
