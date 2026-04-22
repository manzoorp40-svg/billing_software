
import 'package:super_market/objectbox.g.dart';

import '../models/site.dart';
import 'base_repository.dart';

class SiteRepository extends BaseRepository<Site> {
  final Box<Site> _box;

  SiteRepository(this._box);

  @override
  Box<Site> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Site>> getAll() async {
    final query = (_box.query(Site_.isActive.equals(true))
      ..order(Site_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Site>> watchAll() {
    return _box
        .query(Site_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Site? getById(int id) => _box.get(id);

  @override
  Site? getByRemoteId(String remoteId) {
    return _box.query(Site_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Site entity) async {
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
    if (entity == null) return false;
    return delete(entity.localId);
  }

  @override
  int count() => _box.count();

  @override
  bool existsByRemoteId(String remoteId) {
    return _box.query(Site_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Site>> getUnsynced() async {
    return _box.query(Site_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Site_.isSync.equals(false)).build().count();
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
  Site? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Site entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
      entity.isActive = existing.isActive;
    }
    return save(entity);
  }

  /// Get sites by status
  Future<List<Site>> getByStatus(int status) async {
    final query = (_box.query(Site_.status.equals(status) & Site_.isActive.equals(true))
      ..order(Site_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Stream sites by status
  Stream<List<Site>> watchByStatus(int status) {
    return _box
        .query(Site_.status.equals(status) & Site_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Get active sites
  Future<List<Site>> getActiveSites() => getByStatus(0);

  /// Stream active sites
  Stream<List<Site>> watchActiveSites() => watchByStatus(0);

  /// Get completed sites
  Future<List<Site>> getCompletedSites() => getByStatus(2);

  /// Search sites by name
  Future<List<Site>> search(String query) async {
    return _box
        .query(Site_.name.contains(query, caseSensitive: false) & Site_.isActive.equals(true))
        .build()
        .findAsync();
  }

  /// Update spent amount
  Future<void> updateSpentAmount(int localId, double amount) async {
    final entity = getById(localId);
    if (entity != null) {
      entity.spentAmount = amount;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
    }
  }

  /// Get sites by client party
  Future<List<Site>> getByClientParty(int partyLocalId) async {
    final query = (_box.query(Site_.clientPartyLocalId.equals(partyLocalId) & Site_.isActive.equals(true))
      ..order(Site_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Get site statistics
  Map<String, dynamic> getStatistics() {
    int active = 0;
    int onHold = 0;
    int completed = 0;
    double totalBudget = 0;
    double totalSpent = 0;

    final query = _box.query(Site_.isActive.equals(true)).build();
    final sites = query.find();
    query.close();

    for (final site in sites) {
      switch (site.status) {
        case 0:
          active++;
          break;
        case 1:
          onHold++;
          break;
        case 2:
          completed++;
          break;
      }
      totalBudget += site.budget ?? 0;
      totalSpent += site.spentAmount ?? 0;
    }

    return {
      'active': active,
      'onHold': onHold,
      'completed': completed,
      'totalBudget': totalBudget,
      'totalSpent': totalSpent,
      'totalSites': active + onHold + completed,
    };
  }
}