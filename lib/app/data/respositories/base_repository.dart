import 'dart:math';
import 'package:objectbox/objectbox.dart';

/// Base repository with common CRUD operations
abstract class BaseRepository<T> {
  Box<T> get box;

  /// Generate a new remoteId (24 hex chars, ObjectID-style)
  String generateRemoteId() {
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000)
            .toRadixString(16)
            .padLeft(8, '0');
    final rng = Random.secure();
    final buffer = StringBuffer(timestamp);
    for (int i = 0; i < 8; i++) {
      buffer.write(rng.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  /// Get current UTC timestamp
  int now() => DateTime.now().toUtc().millisecondsSinceEpoch;

  // ============ CRUD OPERATIONS ============

  /// Get all records
  Future<List<T>> getAll();

  /// Get all records as a stream
  Stream<List<T>> watchAll();

  /// Get by local ID
  T? getById(int id);

  /// Get by remote ID
  T? getByRemoteId(String remoteId);

  /// Save (insert or update)
  Future<int> save(T entity);

  /// Save multiple records
  Future<List<int>> saveMany(List<T> entities) async {
    return box.putManyAsync(entities);
  }

  /// Delete by local ID
  bool delete(int id);

  /// Delete by remote ID
  bool deleteByRemoteId(String remoteId);

  /// Delete multiple by local IDs
  int deleteMany(List<int> ids) {
    return box.removeMany(ids);
  }

  /// Count total records
  int count();

  /// Check if remote ID exists
  bool existsByRemoteId(String remoteId);

  // ============ SYNC OPERATIONS ============

  /// Get all unsynced records
  Future<List<T>> getUnsynced();

  /// Count unsynced records
  int countUnsynced();

  /// Mark a record as synced
  Future<void> markSynced(String remoteId);

  /// Mark all records as synced
  Future<void> markAllSynced();

  /// Get records modified after a timestamp
  Future<List<T>> getModifiedAfter(int timestamp) async {
    // Default implementation: return all records (override in subclasses)
    return await getAll();
  }

  // ============ QUERY HELPERS ============

  /// Find by remote ID (used for upsert)
  T? findOneByRemoteId(String remoteId);

  /// Upsert: update if exists, insert if not
  Future<int> upsert(T entity);
}