part of ednet_core;

/// Generic Message System - Framework-level abstractions

/// Base class for all identifiers in the messaging system
abstract class MessageIdentifier extends ValueObject {
  final String value;

  MessageIdentifier(this.value) {
    if (value.isEmpty) {
      throw ArgumentError('${runtimeType} cannot be empty');
    }
    validate();
  }

  @override
  String toString() => value;

  @override
  List<Object> get props => [value];
}

/// Base class for domain contexts in the messaging system
class MessageDomainContext extends ValueObject {
  final String name;

  MessageDomainContext(this.name) {
    if (name.isEmpty) {
      throw ArgumentError('Domain name cannot be empty');
    }
    validate();
  }

  @override
  String toString() => name;

  @override
  List<Object> get props => [name];

  @override
  MessageDomainContext copyWith({String? name}) {
    return MessageDomainContext(name ?? this.name);
  }
}

/// Base class for message categories/classifications
class MessageCategory extends ValueObject {
  final String name;

  MessageCategory(this.name) {
    if (name.isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }
    validate();
  }

  @override
  String toString() => name;

  @override
  List<Object> get props => [name];

  @override
  MessageCategory copyWith({String? name}) {
    return MessageCategory(name ?? this.name);
  }
}

/// Represents message expiration information
class MessageExpiration extends ValueObject {
  final DateTime expiresAt;
  final Duration? timeToLive;

  MessageExpiration.expiresAt(this.expiresAt) : timeToLive = null {
    validate();
  }

  MessageExpiration.timeToLive(this.timeToLive, {DateTime? createdAt})
    : expiresAt = (createdAt ?? DateTime.now()).add(timeToLive!) {
    if (timeToLive!.isNegative) {
      throw ArgumentError('TTL cannot be negative');
    }
    validate();
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration? get remainingTime {
    if (isExpired) return null;
    return expiresAt.difference(DateTime.now());
  }

  @override
  List<Object> get props => [expiresAt, timeToLive ?? Object()];

  @override
  MessageExpiration copyWith({DateTime? expiresAt, Duration? timeToLive}) {
    if (expiresAt != null) {
      return MessageExpiration.expiresAt(expiresAt);
    } else if (timeToLive != null) {
      return MessageExpiration.timeToLive(timeToLive);
    }
    return this;
  }
}

/// Base class for all strongly-typed Framework messages
/// Framework users should extend this to create domain-specific message types
abstract class TypedMessage extends ValueObject {
  final String id;
  final DateTime createdAt;
  final MessageExpiration? expiration;
  final MessageDomainContext domainContext;
  final MessageCategory category;

  TypedMessage({
    String? id,
    DateTime? createdAt,
    this.expiration,
    required this.domainContext,
    required this.category,
  }) : id = id ?? _generateId(),
       createdAt = createdAt ?? DateTime.now() {
    validate();
  }

  /// Gets the message type identifier
  String get messageType;

  /// Checks if this message has expired
  bool get isExpired => expiration?.isExpired ?? false;

  @override
  List<Object> get props => [
    id,
    createdAt,
    expiration ?? Object(),
    domainContext,
    category,
  ];

  static String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

// Removed unused _ExampleDomainMessage - was example code not used by framework

/// Base message with generic payload and identifiers - framework level
class GenericTypedMessage extends TypedMessage {
  final dynamic payload;
  final Map<String, MessageIdentifier> identifiers;

  GenericTypedMessage({
    required this.payload,
    this.identifiers = const {},
    required super.domainContext,
    required super.category,
    super.id,
    super.createdAt,
    super.expiration,
  });

  @override
  String get messageType => category.name;

  @override
  List<Object> get props => [...super.props, payload ?? Object(), identifiers];

  @override
  GenericTypedMessage copyWith({
    dynamic payload,
    Map<String, MessageIdentifier>? identifiers,
    MessageDomainContext? domainContext,
    MessageCategory? category,
    String? id,
    DateTime? createdAt,
    MessageExpiration? expiration,
  }) {
    return GenericTypedMessage(
      payload: payload ?? this.payload,
      identifiers: identifiers ?? this.identifiers,
      domainContext: domainContext ?? this.domainContext,
      category: category ?? this.category,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      expiration: expiration ?? this.expiration,
    );
  }
}
