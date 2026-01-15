// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogEntry extends AuditLogEntry {
  @override
  final String? id;
  @override
  final String? actorId;
  @override
  final String? action;
  @override
  final String? entityType;
  @override
  final String? entityId;
  @override
  final JsonObject? metadata;
  @override
  final DateTime? createdAt;

  factory _$AuditLogEntry([void Function(AuditLogEntryBuilder)? updates]) =>
      (AuditLogEntryBuilder()..update(updates))._build();

  _$AuditLogEntry._(
      {this.id,
      this.actorId,
      this.action,
      this.entityType,
      this.entityId,
      this.metadata,
      this.createdAt})
      : super._();
  @override
  AuditLogEntry rebuild(void Function(AuditLogEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogEntryBuilder toBuilder() => AuditLogEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogEntry &&
        id == other.id &&
        actorId == other.actorId &&
        action == other.action &&
        entityType == other.entityType &&
        entityId == other.entityId &&
        metadata == other.metadata &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, actorId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, entityType.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogEntry')
          ..add('id', id)
          ..add('actorId', actorId)
          ..add('action', action)
          ..add('entityType', entityType)
          ..add('entityId', entityId)
          ..add('metadata', metadata)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AuditLogEntryBuilder
    implements Builder<AuditLogEntry, AuditLogEntryBuilder> {
  _$AuditLogEntry? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _actorId;
  String? get actorId => _$this._actorId;
  set actorId(String? actorId) => _$this._actorId = actorId;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _entityType;
  String? get entityType => _$this._entityType;
  set entityType(String? entityType) => _$this._entityType = entityType;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  JsonObject? _metadata;
  JsonObject? get metadata => _$this._metadata;
  set metadata(JsonObject? metadata) => _$this._metadata = metadata;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AuditLogEntryBuilder() {
    AuditLogEntry._defaults(this);
  }

  AuditLogEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _actorId = $v.actorId;
      _action = $v.action;
      _entityType = $v.entityType;
      _entityId = $v.entityId;
      _metadata = $v.metadata;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogEntry other) {
    _$v = other as _$AuditLogEntry;
  }

  @override
  void update(void Function(AuditLogEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogEntry build() => _build();

  _$AuditLogEntry _build() {
    final _$result = _$v ??
        _$AuditLogEntry._(
          id: id,
          actorId: actorId,
          action: action,
          entityType: entityType,
          entityId: entityId,
          metadata: metadata,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
