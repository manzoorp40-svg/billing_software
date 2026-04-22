import 'package:super_market/objectbox.g.dart';
import '../models/site_material_allocation.dart';
import 'base_repository.dart';

class SiteMaterialRepository extends BaseRepository<SiteMaterialAllocation> {
  final Box<SiteMaterialAllocation> _box;

  SiteMaterialRepository(this._box);

  @override
  Box<SiteMaterialAllocation> get box => _box;

  @override
  Future<List<SiteMaterialAllocation>> getAll() async => _box.getAll();

  @override
  Stream<List<SiteMaterialAllocation>> watchAll() => _box.query().watch(triggerImmediately: true).map((q) => q.find());

  @override
  SiteMaterialAllocation? getById(int id) => _box.get(id);

  @override
  SiteMaterialAllocation? getByRemoteId(String remoteId) => _box.query(SiteMaterialAllocation_.remoteId.equals(remoteId)).build().findFirst();

  @override
  Future<int> save(SiteMaterialAllocation entity) async {
    entity.updatedAt = now();
    return _box.putAsync(entity);
  }

  @override
  bool delete(int id) => _box.remove(id);

  @override
  bool deleteByRemoteId(String remoteId) {
    final entity = getByRemoteId(remoteId);
    if (entity == null) return false;
    return delete(entity.localId);
  }

  @override
  int count() => _box.count();

  @override
  bool existsByRemoteId(String remoteId) => _box.query(SiteMaterialAllocation_.remoteId.equals(remoteId)).build().count() > 0;

  @override
  Future<List<SiteMaterialAllocation>> getUnsynced() async => _box.query(SiteMaterialAllocation_.isSync.equals(false)).build().findAsync();

  @override
  int countUnsynced() => _box.query(SiteMaterialAllocation_.isSync.equals(false)).build().count();

  @override
  Future<void> markSynced(String remoteId) async {
    final entity = getByRemoteId(remoteId);
    if (entity != null) {
      entity.isSync = true;
      entity.syncedAt = now();
      await _box.putAsync(entity);
    }
  }

  @override
  Future<void> markAllSynced() async {
    final unsynced = await getUnsynced();
    for (final e in unsynced) {
      e.isSync = true;
      e.syncedAt = now();
    }
    await _box.putManyAsync(unsynced);
  }

  @override
  SiteMaterialAllocation? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(SiteMaterialAllocation entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
    }
    return save(entity);
  }
}
