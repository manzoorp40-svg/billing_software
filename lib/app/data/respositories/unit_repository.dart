import 'package:objectbox/objectbox.dart';
import 'package:super_market/objectbox.g.dart';

import '../models/unit.dart';
import 'base_repository.dart';

class UnitRepository extends BaseRepository<Unit> {
  final Box<Unit> _box;

  UnitRepository(this._box);

  @override
  Box<Unit> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Unit>> getAll() async {
    final query = (_box.query()
      ..order(Unit_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Unit>> watchAll() {
    return _box
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Unit? getById(int id) => _box.get(id);

  @override
  Unit? getByRemoteId(String remoteId) {
    return _box.query(Unit_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Unit entity) async {
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
  bool delete(int id) => _box.remove(id);

  @override
  bool deleteByRemoteId(String remoteId) {
    final entity = getByRemoteId(remoteId);
    if (entity == null) return false;
    return _box.remove(entity.localId);
  }

  @override
  int count() => _box.count();

  @override
  bool existsByRemoteId(String remoteId) {
    return _box.query(Unit_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Unit>> getUnsynced() async {
    return _box.query(Unit_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Unit_.isSync.equals(false)).build().count();
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
  Unit? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Unit entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
    }
    return save(entity);
  }

  /// Find by symbol
  Unit? findBySymbol(String symbol) {
    return _box.query(Unit_.symbol.equals(symbol)).build().findFirst();
  }

  /// Search by name
  Future<List<Unit>> search(String query) async {
    return _box
        .query(Unit_.name.contains(query, caseSensitive: false))
        .build()
        .findAsync();
  }

  /// Get all default units (preloaded)
  Future<void> seedDefaultUnits() async {
    if (count() > 0) return; // Already seeded

    final defaultUnits = [
      Unit(name: 'Bags', symbol: 'bag', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Kilograms', symbol: 'kg', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Metric Tonnes', symbol: 'mt', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Cubic Feet', symbol: 'cft', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Cubic Meters', symbol: 'cum', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Square Feet', symbol: 'sft', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Square Meters', symbol: 'sqm', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Pieces', symbol: 'pcs', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Numbers', symbol: 'nos', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Liters', symbol: 'ltr', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Meters', symbol: 'm', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
      Unit(name: 'Running Feet', symbol: 'rft', createdAt: now(), updatedAt: now(), remoteId: generateRemoteId()),
    ];

    await saveMany(defaultUnits);
  }
}