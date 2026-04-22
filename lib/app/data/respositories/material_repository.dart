

import 'package:super_market/objectbox.g.dart';

import '../models/material.dart';
import 'base_repository.dart';

class MaterialRepository extends BaseRepository<Material> {
  final Box<Material> _box;

  MaterialRepository(this._box);

  @override
  Box<Material> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Material>> getAll() async {
    final query = (_box.query(Material_.isActive.equals(true))
      ..order(Material_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Material>> watchAll() {
    return _box
        .query(Material_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Material? getById(int id) => _box.get(id);

  @override
  Material? getByRemoteId(String remoteId) {
    return _box.query(Material_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Material entity) async {
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
    return _box.query(Material_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Material>> getUnsynced() async {
    return _box.query(Material_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Material_.isSync.equals(false)).build().count();
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
  Material? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Material entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
      entity.isActive = existing.isActive;
    }
    return save(entity);
  }

  /// Get materials with low stock
  Future<List<Material>> getLowStock() async {
    // Property-to-property comparison is not directly supported in ObjectBox Dart query builder.
    // Fetch all active tracked materials and filter in memory.
    final query = (_box.query(
        Material_.trackStock.equals(true) &
        Material_.isActive.equals(true)
    )..order(Material_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    
    return results.where((m) => m.currentStock <= m.alertQuantity).toList();
  }

  /// Watch low stock materials
  Stream<List<Material>> watchLowStock() {
    return _box
        .query(
        Material_.trackStock.equals(true) &
        Material_.isActive.equals(true)
    )
        .watch(triggerImmediately: true)
        .map((query) {
          final results = query.find();
          return results.where((m) => m.currentStock <= m.alertQuantity).toList();
        });
  }

  /// Search materials by name
  Future<List<Material>> search(String query) async {
    return _box
        .query(Material_.name.contains(query, caseSensitive: false) & Material_.isActive.equals(true))
        .build()
        .findAsync();
  }

  /// Get materials by unit
  Future<List<Material>> getByUnit(int unitLocalId) async {
    final query = (_box.query(Material_.unitLocalId.equals(unitLocalId) & Material_.isActive.equals(true))
      ..order(Material_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Update stock quantity
  Future<void> updateStock(int localId, double newStock) async {
    final entity = getById(localId);
    if (entity != null) {
      entity.currentStock = newStock;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
    }
  }

  /// Add to stock (for purchases)
  Future<void> addToStock(int localId, double quantity) async {
    final entity = getById(localId);
    if (entity != null) {
      entity.currentStock += quantity;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
    }
  }

  /// Deduct from stock (for site allocations)
  Future<void> deductFromStock(int localId, double quantity) async {
    final entity = getById(localId);
    if (entity != null) {
      entity.currentStock = (entity.currentStock - quantity).clamp(0, double.infinity);
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
    }
  }

  /// Get all materials that track stock
  Future<List<Material>> getStockTracked() async {
    final query = (_box.query(Material_.trackStock.equals(true) & Material_.isActive.equals(true))
      ..order(Material_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Get total stock value
  double getTotalStockValue() {
    double total = 0;
    final query = _box.query(Material_.trackStock.equals(true) & Material_.isActive.equals(true)).build();
    final materials = query.find();
    query.close();
    for (final m in materials) {
      total += m.currentStock * m.rate;
    }
    return total;
  }
}