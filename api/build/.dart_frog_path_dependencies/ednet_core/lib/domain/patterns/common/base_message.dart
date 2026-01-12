part of ednet_core;

/// A core message type used across Enterprise Integration Patterns.
///
/// The [Message] class represents the fundamental unit of communication in
/// messaging-based systems. Messages are immutable value objects that contain:
///
/// * [payload] - The main content/data of the message
/// * [metadata] - Additional information about the message (headers, routing information, etc.)
/// * [id] - Unique identifier for the message
///
/// In a direct democracy context, messages could represent:
/// * Votes being cast
/// * Proposals being submitted or amended
/// * Notifications about deliberation processes
/// * Results of collective decision-making
/// Legacy Message class - deprecated in favor of strongly-typed EDNetMessage subclasses
///
/// @deprecated Use strongly-typed EDNetMessage subclasses (VoteMessage, ProposalMessage, etc.)
/// instead of generic metadata maps. This class is maintained for backward compatibility only.
///
/// Migration path:
/// - Instead of: Message(payload: 'vote', metadata: {'messageType': 'vote', 'citizenId': '123'})
/// - Use: VoteMessage(citizenId: CitizenId('123'), proposalId: ProposalId('456'), choice: 'yes')
class Message extends ValueObject {
  /// The primary data/content carried by this message
  final dynamic payload;

  /// Additional properties that describe or contextualize the message
  /// @deprecated Use strongly-typed EDNetMessage subclasses instead
  final Map<String, dynamic> metadata;

  /// Unique identifier for this message instance
  final String id;

  /// Creates a new Message with the given [payload] and optional [metadata].
  ///
  /// If [id] is not provided, a new random ID will be generated.
  ///
  /// @deprecated Use strongly-typed EDNetMessage subclasses instead
  Message({required this.payload, Map<String, dynamic>? metadata, String? id})
    : metadata = metadata ?? {},
      id = id ?? _generateId() {
    validate();
  }

  /// Creates a Message from a strongly-typed TypedMessage (for backward compatibility)
  Message.fromTypedMessage(TypedMessage typedMessage)
    : payload = typedMessage is GenericTypedMessage ? typedMessage.payload : {},
      metadata = _extractMetadata(typedMessage),
      id = typedMessage.id {
    validate();
  }

  static Map<String, dynamic> _extractMetadata(TypedMessage message) {
    final metadata = <String, dynamic>{
      'messageType': message.messageType,
      'domain': message.domainContext.name,
      'createdAt': message.createdAt.toIso8601String(),
    };

    if (message.expiration != null) {
      metadata['expiresAt'] = message.expiration!.expiresAt.toIso8601String();
      if (message.expiration!.timeToLive != null) {
        metadata['ttl'] = message.expiration!.timeToLive!.inSeconds;
      }
    }

    // Add identifiers from generic typed message
    if (message is GenericTypedMessage) {
      message.identifiers.forEach((key, identifier) {
        metadata[key] = identifier.value;
      });
    }

    return metadata;
  }

  /// Creates a copy of this message with optionally modified properties
  @override
  Message copyWith({
    dynamic payload,
    Map<String, dynamic>? metadata,
    String? id,
  }) {
    return Message(
      payload: payload ?? this.payload,
      metadata: metadata ?? Map.from(this.metadata),
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, payload ?? Object(), metadata];

  /// Generates a random ID for a message
  static String _generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1000000).toString().padLeft(6, '0');
    return '$now-$random';
  }
}
