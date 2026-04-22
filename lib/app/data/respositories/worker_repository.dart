import 'package:super_market/objectbox.g.dart';

import '../models/worker.dart';
import 'base_repository.dart';

class WorkerRepository extends BaseRepository<Worker> {
  final Box<Worker> _box;

  WorkerRepository(this._box);

  @override
  Box<Worker> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Worker>> getAll() async {
    final query = (_box.query(Worker_.isActive.equals(true))
      ..order(Worker_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Worker>> watchAll() {
    return _box
        .query(Worker_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Worker? getById(int id) => _box.get(id);

  @override
  Worker? getByRemoteId(String remoteId) {
    return _box.query(Worker_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Worker entity) async {
    if (entity.localId == 0) {
      entity.remoteId = entity.remoteId.isEmpty ? generateRemoteId() : entity.remoteId;
      entity.isSync = false;
      entity.createdAt = entity.createdAt == 0 ? now() : entity.createdAt;
      entity.updatedAt = now();
    } else {
      entity.updatedAt = now();
      entity.isSync = false;
    }
    return _box.putAsync(entity);
  }

  @override
  bool delete(int id) {
    final entity = _box.get(id);
    if (entity != null) {
      entity.isActive = false;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
      return true;
    }
    return false;
  }

  @override
  bool deleteByRemoteId(String remoteId) {
    final entity = getByRemoteId(remoteId);
    if (entity != null) {
      entity.isActive = false;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
      return true;
    }
    return false;
  }

  @override
  int count() => _box.count();

  @override
  bool existsByRemoteId(String remoteId) {
    return _box.query(Worker_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Worker>> getUnsynced() async {
    return _box.query(Worker_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Worker_.isSync.equals(false)).build().count();
  }

  @override
  Future<void> markSynced(String remoteId) async {
    final entity = getByRemoteId(remoteId);
    if (entity != null) {
      entity.isSync = true;
      entity.syncedAt = now();
      _box.put(entity);
    }
  }

  @override
  Future<void> markAllSynced() async {
    final unsynced = await getUnsynced();
    for (final entity in unsynced) {
      entity.isSync = true;
      entity.syncedAt = now();
    }
    _box.putMany(unsynced);
  }

  // ============ QUERIES ============

  @override
  Worker? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Worker entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
      entity.isActive = existing.isActive;
    }
    return save(entity);
  }

  /// Get workers by category
  Future<List<Worker>> getByCategory(int category) async {
    final query = (_box.query(Worker_.category.equals(category) & Worker_.isActive.equals(true))
      ..order(Worker_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Stream workers by category
  Stream<List<Worker>> watchByCategory(int category) {
    return _box
        .query(Worker_.category.equals(category) & Worker_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Search workers by name
  Future<List<Worker>> search(String query) async {
    return _box
        .query(Worker_.name.contains(query, caseSensitive: false) & Worker_.isActive.equals(true))
        .build()
        .findAsync();
  }

  /// Get active workers count
  int getActiveCount() {
    return _box.query(Worker_.isActive.equals(true)).build().count();
  }

  /// Get workers by daily wage range
  Future<List<Worker>> getByWageRange(double min, double max) async {
    final query = (_box.query(
        Worker_.dailyWage.greaterOrEqual(min) &
        Worker_.dailyWage.lessOrEqual(max) &
        Worker_.isActive.equals(true)
    )..order(Worker_.dailyWage))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    int skilled = 0;
    int unskilled = 0;
    int supervisor = 0;
    int engineer = 0;
    double totalDailyWages = 0;

    final query = _box.query(Worker_.isActive.equals(true)).build();
    final workers = query.find();
    query.close();

    for (final worker in workers) {
      switch (worker.category) {
        case 0:
          skilled++;
          break;
        case 1:
          unskilled++;
          break;
        case 2:
          supervisor++;
          break;
        case 3:
          engineer++;
          break;
      }
      totalDailyWages += worker.dailyWage;
    }

    return {
      'skilled': skilled,
      'unskilled': unskilled,
      'supervisor': supervisor,
      'engineer': engineer,
      'total': skilled + unskilled + supervisor + engineer,
      'totalDailyWages': totalDailyWages,
    };
  }
}