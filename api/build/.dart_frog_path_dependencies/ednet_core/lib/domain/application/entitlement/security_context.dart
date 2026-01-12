part of ednet_core;

/// A security context manages the current security subject and provides authorization functions.
///
/// The [SecurityContext] class is responsible for:
/// - Holding the current security subject (e.g., logged-in user)
/// - Checking permissions for operations
/// - Enforcing field-level access control
/// - Providing security predicates for query filtering
///
/// This class uses zone-local storage to maintain the current security context,
/// making it accessible throughout the application without explicit passing.
///
/// Example usage:
/// ```dart
/// // Set the current user
/// SecurityContext.setCurrentSubject(currentUser);
///
/// // Check permissions
/// if (SecurityContext.hasPermission(Permission('Task', 'create'))) {
///   // Create a task
/// }
///
/// // Run with elevated permissions temporarily
/// SecurityContext.runWithSystemPrivileges(() {
///   // Perform privileged operations
/// });
/// ```
class SecurityContext with ObservabilityMixin {
  @override
  String get componentName => 'SecurityContext';

  /// The default system subject with all permissions
  static final SecuritySubject _systemSubject = _SystemSubject();

  /// Zone key for storing the current security context
  static const _zoneKey = #securityContext;

  /// The security subject for this context
  final SecuritySubject _subject;

  /// Whether this context has system privileges
  final bool _isSystem;

  /// Creates a new security context.
  ///
  /// Parameters:
  /// - [subject]: The security subject for this context
  /// - [isSystem]: Whether this context has system privileges
  SecurityContext(this._subject, {bool isSystem = false})
    : _isSystem = isSystem;

  /// Gets the current security context.
  ///
  /// If no context has been set, returns a default context with the system subject.
  /// This ensures that authorization checks always have a context to work with.
  ///
  /// Returns:
  /// The current security context
  static SecurityContext getCurrent() {
    final context = Zone.current[_zoneKey] as SecurityContext?;
    return context ?? SecurityContext(_systemSubject, isSystem: true);
  }

  /// Sets the current security context within a zone.
  ///
  /// This method should be called at the beginning of each request or
  /// when changing the security context (e.g., after login).
  ///
  /// Parameters:
  /// - [context]: The security context to set
  /// - [callback]: The function to run with the security context
  ///
  /// Returns:
  /// The result of the callback function
  static T runWithContext<T>(SecurityContext context, T Function() callback) {
    return runZoned(callback, zoneValues: {_zoneKey: context});
  }

  /// Sets the current security subject within a zone.
  ///
  /// This is a convenience method that creates a new context with the
  /// specified subject and runs the callback with that context.
  ///
  /// Parameters:
  /// - [subject]: The security subject to set
  /// - [callback]: The function to run with the security subject
  ///
  /// Returns:
  /// The result of the callback function
  static T runWithSubject<T>(SecuritySubject subject, T Function() callback) {
    return runWithContext(SecurityContext(subject), callback);
  }

  /// Runs a function with system privileges.
  ///
  /// This method temporarily elevates the security context to
  /// system privileges, runs the specified function, and then
  /// restores the original context.
  ///
  /// Parameters:
  /// - [callback]: The function to run with system privileges
  ///
  /// Returns:
  /// The result of the function
  static T runWithSystemPrivileges<T>(T Function() callback) {
    return runWithContext(
      SecurityContext(_systemSubject, isSystem: true),
      callback,
    );
  }

  /// Gets the current security subject.
  ///
  /// Returns:
  /// The current security subject
  static SecuritySubject getCurrentSubject() {
    return getCurrent()._subject;
  }

  /// Checks if the current subject has a specific permission.
  ///
  /// Parameters:
  /// - [permission]: The permission to check for
  ///
  /// Returns:
  /// True if the current subject has the permission
  static bool hasPermission(Permission permission) {
    final context = getCurrent();

    context.observabilityTrace('permissionCheck', {
      'permission': permission.toString(),
      'isSystem': context._isSystem,
      'subjectId': context._subject.id,
    });

    if (context._isSystem) {
      context.observabilityTrace('systemPermissionGranted', {
        'permission': permission.toString(),
      });
      return true;
    }

    final hasPermission = context._subject.hasPermission(permission);

    context.observabilityDebug('permissionCheckResult', {
      'permission': permission.toString(),
      'granted': hasPermission,
      'subjectId': context._subject.id,
      'effectivePermissions': context._subject
          .getEffectivePermissions()
          .map((p) => p.toString())
          .toList(),
    });

    return hasPermission;
  }

  /// Checks if the current subject has a specific permission string.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to check for
  ///
  /// Returns:
  /// True if the current subject has the permission
  static bool hasPermissionString(String permissionString) {
    return hasPermission(Permission.fromString(permissionString));
  }

  /// Checks if the current subject has any of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the current subject has any of the permissions
  static bool hasAnyPermission(List<Permission> permissions) {
    final context = getCurrent();

    context.observabilityTrace('anyPermissionCheck', {
      'permissions': permissions.map((p) => p.toString()).toList(),
      'isSystem': context._isSystem,
      'subjectId': context._subject.id,
    });

    if (context._isSystem) return true;

    final hasAny = context._subject.hasAnyPermission(permissions);

    context.observabilityDebug('anyPermissionCheckResult', {
      'permissions': permissions.map((p) => p.toString()).toList(),
      'granted': hasAny,
      'subjectId': context._subject.id,
    });

    return hasAny;
  }

  /// Checks if the current subject has all of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: The list of permissions to check for
  ///
  /// Returns:
  /// True if the current subject has all of the permissions
  static bool hasAllPermissions(List<Permission> permissions) {
    final context = getCurrent();

    context.observabilityTrace('allPermissionsCheck', {
      'permissions': permissions.map((p) => p.toString()).toList(),
      'isSystem': context._isSystem,
      'subjectId': context._subject.id,
    });

    if (context._isSystem) return true;

    final hasAll = context._subject.hasAllPermissions(permissions);

    context.observabilityDebug('allPermissionsCheckResult', {
      'permissions': permissions.map((p) => p.toString()).toList(),
      'granted': hasAll,
      'subjectId': context._subject.id,
    });

    return hasAll;
  }

  /// Checks if the current subject has a specific role.
  ///
  /// Parameters:
  /// - [roleName]: The name of the role to check for
  ///
  /// Returns:
  /// True if the current subject has the role
  static bool hasRole(String roleName) {
    final context = getCurrent();

    context.observabilityTrace('roleCheck', {
      'roleName': roleName,
      'isSystem': context._isSystem,
      'subjectId': context._subject.id,
    });

    if (context._isSystem) return true;

    final hasRole = context._subject.hasRole(roleName);

    context.observabilityDebug('roleCheckResult', {
      'roleName': roleName,
      'granted': hasRole,
      'subjectId': context._subject.id,
      'subjectRoles': context._subject.roles.map((r) => r.name).toList(),
    });

    return hasRole;
  }

  /// Checks if the current context has system privileges.
  ///
  /// Returns:
  /// True if the current context has system privileges
  static bool isSystem() {
    return getCurrent()._isSystem;
  }

  /// Checks if the current subject has permission to access a resource.
  ///
  /// This method constructs a permission with the specified resource and
  /// operation, then checks if the current subject has that permission.
  ///
  /// Parameters:
  /// - [resource]: The resource to check access for
  /// - [operation]: The operation to check access for
  ///
  /// Returns:
  /// True if the current subject has permission to access the resource
  static bool canAccess(String resource, String operation) {
    return hasPermission(Permission(resource, operation));
  }

  /// Requires that the current subject has a specific permission.
  ///
  /// This method checks if the current subject has the specified permission,
  /// and throws a [SecurityContextException] if they don't.
  ///
  /// Parameters:
  /// - [permission]: The permission to require
  ///
  /// Throws:
  /// [SecurityContextException] if the current subject doesn't have the permission
  static void requirePermission(Permission permission) {
    final context = getCurrent();

    if (!hasPermission(permission)) {
      context.observabilityError(
        'permissionRequired',
        context: {
          'permission': permission.toString(),
          'subjectId': context._subject.id,
          'denied': true,
        },
      );

      throw SecurityContextException(
        'Permission required: $permission',
        requiredPermission: permission,
        subject: context._subject,
      );
    }
  }

  /// Requires that the current subject has a specific permission string.
  ///
  /// Parameters:
  /// - [permissionString]: The permission string to require
  ///
  /// Throws:
  /// [SecurityContextException] if the current subject doesn't have the permission
  static void requirePermissionString(String permissionString) {
    requirePermission(Permission.fromString(permissionString));
  }

  /// Creates a function that checks if a field is accessible.
  ///
  /// This method returns a function that can be used to filter fields based on
  /// whether the current subject has permission to access them.
  ///
  /// Parameters:
  /// - [resourcePrefix]: The prefix to add to the field name to form the resource
  /// - [operation]: The operation to check for
  ///
  /// Returns:
  /// A function that returns true if the field is accessible
  static bool Function(String) createFieldAccessChecker(
    String resourcePrefix,
    String operation,
  ) {
    return (String fieldName) {
      return canAccess('$resourcePrefix.$fieldName', operation);
    };
  }
}

/// A system subject with all permissions.
///
/// This class implements the [SecuritySubject] interface to provide
/// a subject with all permissions that can be used for system operations.
class _SystemSubject implements SecuritySubject {
  @override
  String get id => 'system';

  @override
  String get displayName => 'System';

  @override
  List<Role> get roles => [
    Role('system', [const Permission('*', '*')]),
  ];

  @override
  bool hasPermission(Permission permission) => true;

  @override
  bool hasPermissionString(String permissionString) => true;

  @override
  bool hasAnyPermission(List<Permission> permissions) => true;

  @override
  bool hasAllPermissions(List<Permission> permissions) => true;

  @override
  bool hasRole(String roleName) => true;

  @override
  Set<Permission> getEffectivePermissions() => {const Permission('*', '*')};

  @override
  String toString() => 'SystemSubject(system)';
}

/// Exception thrown when a security check fails.
///
/// This exception is thrown when an operation requires a permission
/// that the current subject doesn't have.
class SecurityContextException implements Exception {
  /// The error message.
  final String message;

  /// The required permission.
  final Permission? requiredPermission;

  /// The subject that the permission check failed for.
  final SecuritySubject? subject;

  /// Creates a new security exception.
  ///
  /// Parameters:
  /// - [message]: The error message
  /// - [requiredPermission]: The required permission
  /// - [subject]: The subject that the permission check failed for
  SecurityContextException(
    this.message, {
    this.requiredPermission,
    this.subject,
  });

  @override
  String toString() => 'SecurityContextException: $message';
}
