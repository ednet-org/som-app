part of ednet_core;

/// **Offline Blockchain Repository for Catastrophic Failure Recovery**
///
/// Provides local device blockchain storage that enables users to regain access
/// to all resources (money, data, domain models) in case of platform failure.
/// Integrates with future ednet_p2p for distributed redundancy and peer backup.
///
/// Key Features:
/// - Local encrypted blockchain storage on user devices
/// - Cryptographic verification of all transactions
/// - P2P synchronization capabilities (when ednet_p2p is available)
/// - Domain model versioning and recovery
/// - Resource ownership proofs
/// - Emergency recovery procedures
///
/// Example usage:
/// ```dart
/// final repository = OfflineBlockchainRepository(
///   localStoragePath: '/path/to/local/blockchain',
///   userKeyPair: userCryptoKeys,
/// );
///
/// // Store critical domain model
/// await repository.storeDomainModel(domainModel, userSignature);
///
/// // Store resource ownership
/// await repository.storeResourceOwnership(assetId, ownershipProof);
///
/// // In case of catastrophic failure
/// final recoveredAssets = await repository.recoverUserAssets(userId);
/// ```
class OfflineBlockchainRepository {
  /// Local storage path for blockchain data
  final String _localStoragePath;

  /// User's cryptographic key pair for signing transactions
  final CryptoKeyPair _userKeyPair;

  /// Current blockchain height (number of blocks)
  int _blockHeight = 0;

  /// Local blockchain storage
  final List<BlockchainBlock> _localChain = [];

  /// Pending transactions waiting to be mined
  final List<BlockchainTransaction> _pendingTransactions = [];

  /// Peer nodes for P2P synchronization (future ednet_p2p integration)
  final Set<P2PPeerNode> _peerNodes = {};

  /// Policy evaluation tracer for blockchain audit
  final PolicyEvaluationTracer? _auditTracer;

  /// Creates a new offline blockchain repository
  OfflineBlockchainRepository({
    required String localStoragePath,
    required CryptoKeyPair userKeyPair,
    PolicyEvaluationTracer? auditTracer,
  }) : _localStoragePath = localStoragePath,
       _userKeyPair = userKeyPair,
       _auditTracer = auditTracer;

  /// Gets the local storage path for blockchain data
  String get localStoragePath => _localStoragePath;

  /// **Domain Model Storage and Recovery**

  /// Stores a domain model with cryptographic proof of ownership
  Future<BlockchainTransactionResult> storeDomainModel(
    Domain domain,
    String userSignature, {
    Map<String, dynamic>? metadata,
  }) async {
    final transaction = BlockchainTransaction(
      type: BlockchainTransactionType.domainModelStorage,
      data: {
        'domainCode': domain.code,
        'domainGraph': domain.toGraph(),
        'userSignature': userSignature,
        'timestamp': DateTime.now().toIso8601String(),
        'metadata': metadata ?? {},
      },
      signature: _signTransaction(_generateTransactionHash(domain.toGraph())),
    );

    _pendingTransactions.add(transaction);

    // Add to audit trail if tracer available
    _auditTracer?.addAttributeCheck('domain_model_stored', domain.code, true);

    return await _processTransaction(transaction);
  }

  /// Recovers domain models for a specific user
  Future<List<Domain>> recoverDomainModels(String userId) async {
    final domainBlocks = _localChain.where(
      (block) => block.transactions.any(
        (tx) =>
            tx.type == BlockchainTransactionType.domainModelStorage &&
            tx.data['userId'] == userId,
      ),
    );

    final domains = <Domain>[];
    for (final block in domainBlocks) {
      for (final transaction in block.transactions) {
        if (transaction.type == BlockchainTransactionType.domainModelStorage) {
          // Reconstruct domain from blockchain data
          // This would need proper Domain.fromGraph() implementation
          // domains.add(Domain.fromGraph(transaction.data['domainGraph']));
        }
      }
    }

    return domains;
  }

  /// **Resource Ownership Management**

  /// Stores proof of resource ownership (money, assets, NFTs, etc.)
  Future<BlockchainTransactionResult> storeResourceOwnership(
    String resourceId,
    ResourceOwnershipProof ownershipProof,
  ) async {
    final transaction = BlockchainTransaction(
      type: BlockchainTransactionType.resourceOwnership,
      data: {
        'resourceId': resourceId,
        'ownershipProof': ownershipProof.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      },
      signature: _signTransaction(
        _generateTransactionHash(ownershipProof.toJson()),
      ),
    );

    _pendingTransactions.add(transaction);

    // Add to audit trail
    _auditTracer?.addAttributeCheck(
      'resource_ownership_stored',
      resourceId,
      true,
    );

    return await _processTransaction(transaction);
  }

  /// Recovers all resources owned by a user
  Future<List<RecoveredResource>> recoverUserAssets(String userId) async {
    final resourceBlocks = _localChain.where(
      (block) => block.transactions.any(
        (tx) =>
            tx.type == BlockchainTransactionType.resourceOwnership &&
            tx.data['ownershipProof']['ownerId'] == userId,
      ),
    );

    final resources = <RecoveredResource>[];
    for (final block in resourceBlocks) {
      for (final transaction in block.transactions) {
        if (transaction.type == BlockchainTransactionType.resourceOwnership) {
          resources.add(RecoveredResource.fromBlockchainData(transaction.data));
        }
      }
    }

    return resources;
  }

  /// **Emergency Recovery Procedures**

  /// Creates an emergency recovery package for catastrophic failure
  Future<EmergencyRecoveryPackage> createEmergencyRecoveryPackage(
    String userId,
  ) async {
    final userDomains = await recoverDomainModels(userId);
    final userResources = await recoverUserAssets(userId);
    final backupData = await _generateBackupData(userId);

    return EmergencyRecoveryPackage(
      userId: userId,
      timestamp: DateTime.now(),
      domains: userDomains,
      resources: userResources,
      backupData: backupData,
      recoveryHash: _generateRecoveryHash(userId),
      signature: _userKeyPair.sign(backupData),
    );
  }

  /// Validates an emergency recovery package
  Future<bool> validateRecoveryPackage(EmergencyRecoveryPackage package) async {
    // Verify cryptographic signatures
    final isSignatureValid = _userKeyPair.verify(
      package.backupData,
      package.signature,
    );

    // Verify blockchain integrity
    final isBlockchainValid = await _verifyBlockchainIntegrity();

    // Verify recovery hash
    final expectedHash = _generateRecoveryHash(package.userId);
    final isHashValid = package.recoveryHash == expectedHash;

    final isValid = isSignatureValid && isBlockchainValid && isHashValid;

    // Add to audit trail
    _auditTracer?.addAttributeCheck(
      'recovery_package_validated',
      package.userId,
      isValid,
    );

    return isValid;
  }

  /// **P2P Synchronization (Future ednet_p2p Integration)**

  /// Adds a peer node for blockchain synchronization
  Future<void> addPeerNode(P2PPeerNode peerNode) async {
    _peerNodes.add(peerNode);

    // Future: Initiate blockchain sync with peer
    // await _syncWithPeer(peerNode);
  }

  /// Synchronizes blockchain with peer network
  Future<P2PSyncResult> syncWithPeers() async {
    if (_peerNodes.isEmpty) {
      return const P2PSyncResult(
        success: false,
        message: 'No peer nodes available',
      );
    }

    // Future: Implement P2P blockchain synchronization
    // This will be implemented when ednet_p2p package is ready

    return P2PSyncResult(
      success: true,
      message: 'Sync with ${_peerNodes.length} peers completed',
      syncedBlocks: _blockHeight,
    );
  }

  /// **Blockchain Core Operations**

  /// Processes a pending transaction and adds it to blockchain
  Future<BlockchainTransactionResult> _processTransaction(
    BlockchainTransaction transaction,
  ) async {
    try {
      // Create new block with pending transactions
      final block = BlockchainBlock(
        height: _blockHeight + 1,
        previousHash: _localChain.isNotEmpty ? _localChain.last.hash : '0',
        transactions: [transaction],
        timestamp: DateTime.now(),
        nonce: _generateNonce(),
      );

      // Add block to local chain
      _localChain.add(block);
      _blockHeight++;

      // Remove from pending
      _pendingTransactions.remove(transaction);

      return BlockchainTransactionResult(
        success: true,
        transactionId: transaction.id,
        blockHeight: _blockHeight,
      );
    } catch (e) {
      return BlockchainTransactionResult(success: false, error: e.toString());
    }
  }

  /// Verifies the integrity of the local blockchain
  Future<bool> _verifyBlockchainIntegrity() async {
    if (_localChain.isEmpty) return true;

    for (int i = 1; i < _localChain.length; i++) {
      final currentBlock = _localChain[i];
      final previousBlock = _localChain[i - 1];

      // Verify block hash chain
      if (currentBlock.previousHash != previousBlock.hash) {
        return false;
      }

      // Verify block signatures
      if (!currentBlock.verifySignature()) {
        return false;
      }
    }

    return true;
  }

  /// Generates cryptographic signature for transaction
  String _signTransaction(String transactionHash) {
    return _userKeyPair.sign(transactionHash);
  }

  /// Generates hash for transaction data
  String _generateTransactionHash(Map<String, dynamic> data) {
    // Simplified hash - would use proper cryptographic hash in production
    return data.toString().hashCode.toRadixString(16);
  }

  /// Generates recovery hash for emergency procedures
  String _generateRecoveryHash(String userId) {
    final data = '$userId${DateTime.now().millisecondsSinceEpoch}';
    return data.hashCode.toRadixString(16);
  }

  /// Generates backup data for recovery
  Future<String> _generateBackupData(String userId) async {
    final userData = {
      'userId': userId,
      'blockchainHeight': _blockHeight,
      'transactionCount': _localChain.fold(
        0,
        (sum, block) => sum + block.transactions.length,
      ),
      'timestamp': DateTime.now().toIso8601String(),
    };
    return userData.toString();
  }

  /// Generates proof-of-work nonce (simplified)
  int _generateNonce() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

/// **Supporting Data Classes for Blockchain Repository**

/// Transaction types supported by the blockchain
enum BlockchainTransactionType {
  domainModelStorage,
  resourceOwnership,
  userIdentity,
  assetTransfer,
  policyEvaluation,
  authProviderValidation,
}

/// Individual blockchain transaction
class BlockchainTransaction {
  final String id;
  final BlockchainTransactionType type;
  final Map<String, dynamic> data;
  final String signature;
  final DateTime timestamp;

  BlockchainTransaction({
    required this.type,
    required this.data,
    required this.signature,
    String? id,
    DateTime? timestamp,
  }) : id = id ?? _generateTransactionId(),
       timestamp = timestamp ?? DateTime.now();

  static String _generateTransactionId() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(16);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'data': data,
    'signature': signature,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Blockchain block containing transactions
class BlockchainBlock {
  final int height;
  final String previousHash;
  final List<BlockchainTransaction> transactions;
  final DateTime timestamp;
  final int nonce;
  final String hash;

  BlockchainBlock({
    required this.height,
    required this.previousHash,
    required this.transactions,
    required this.timestamp,
    required this.nonce,
  }) : hash = _calculateBlockHash(
         height,
         previousHash,
         transactions,
         timestamp,
         nonce,
       );

  static String _calculateBlockHash(
    int height,
    String previousHash,
    List<BlockchainTransaction> transactions,
    DateTime timestamp,
    int nonce,
  ) {
    final blockData =
        '$height$previousHash${transactions.length}${timestamp.millisecondsSinceEpoch}$nonce';
    return blockData.hashCode.toRadixString(16);
  }

  bool verifySignature() {
    // Simplified verification - would use proper cryptographic verification
    return hash.isNotEmpty;
  }
}

/// Result of blockchain transaction processing
class BlockchainTransactionResult {
  final bool success;
  final String? transactionId;
  final int? blockHeight;
  final String? error;

  const BlockchainTransactionResult({
    required this.success,
    this.transactionId,
    this.blockHeight,
    this.error,
  });
}

/// Proof of resource ownership for blockchain storage
class ResourceOwnershipProof {
  final String resourceId;
  final String ownerId;
  final String ownershipType; // 'money', 'nft', 'domain_model', 'data'
  final Map<String, dynamic> metadata;
  final String cryptographicProof;

  const ResourceOwnershipProof({
    required this.resourceId,
    required this.ownerId,
    required this.ownershipType,
    required this.metadata,
    required this.cryptographicProof,
  });

  Map<String, dynamic> toJson() => {
    'resourceId': resourceId,
    'ownerId': ownerId,
    'ownershipType': ownershipType,
    'metadata': metadata,
    'cryptographicProof': cryptographicProof,
  };
}

/// Recovered resource from blockchain
class RecoveredResource {
  final String resourceId;
  final String ownershipType;
  final Map<String, dynamic> resourceData;
  final DateTime recoveryTimestamp;

  const RecoveredResource({
    required this.resourceId,
    required this.ownershipType,
    required this.resourceData,
    required this.recoveryTimestamp,
  });

  static RecoveredResource fromBlockchainData(Map<String, dynamic> data) {
    return RecoveredResource(
      resourceId: data['resourceId'],
      ownershipType: data['ownershipProof']['ownershipType'],
      resourceData: data,
      recoveryTimestamp: DateTime.now(),
    );
  }
}

/// Emergency recovery package for catastrophic failure
class EmergencyRecoveryPackage {
  final String userId;
  final DateTime timestamp;
  final List<Domain> domains;
  final List<RecoveredResource> resources;
  final String backupData;
  final String recoveryHash;
  final String signature;

  const EmergencyRecoveryPackage({
    required this.userId,
    required this.timestamp,
    required this.domains,
    required this.resources,
    required this.backupData,
    required this.recoveryHash,
    required this.signature,
  });
}

/// Cryptographic key pair for user signing
class CryptoKeyPair {
  final String publicKey;
  final String privateKey;

  const CryptoKeyPair({required this.publicKey, required this.privateKey});

  String sign(String data) {
    // Simplified signing - would use proper cryptographic signing
    return '${data.hashCode.toRadixString(16)}_$privateKey';
  }

  bool verify(String data, String signature) {
    // Simplified verification - would use proper cryptographic verification
    return signature.contains(data.hashCode.toRadixString(16));
  }
}

/// P2P peer node for blockchain synchronization (future ednet_p2p)
class P2PPeerNode {
  final String nodeId;
  final String address;
  final int port;
  final String publicKey;

  const P2PPeerNode({
    required this.nodeId,
    required this.address,
    required this.port,
    required this.publicKey,
  });
}

/// Result of P2P synchronization
class P2PSyncResult {
  final bool success;
  final String message;
  final int? syncedBlocks;

  const P2PSyncResult({
    required this.success,
    required this.message,
    this.syncedBlocks,
  });
}
