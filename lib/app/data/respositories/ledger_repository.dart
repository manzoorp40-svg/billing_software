import 'package:super_market/objectbox.g.dart';
import '../models/ledger_entry.dart';
import 'base_repository.dart';

class LedgerRepository extends BaseRepository<LedgerEntry> {
  final Box<LedgerEntry> _box;

  LedgerRepository(this._box);

  @override
  Box<LedgerEntry> get box => _box;

  @override
  Future<List<LedgerEntry>> getAll() async => _box.getAll();

  @override
  Stream<List<LedgerEntry>> watchAll() => _box.query().watch(triggerImmediately: true).map((q) => q.find());

  @override
  LedgerEntry? getById(int id) => _box.get(id);

  @override
  LedgerEntry? getByRemoteId(String remoteId) => _box.query(LedgerEntry_.remoteId.equals(remoteId)).build().findFirst();

  @override
  Future<int> save(LedgerEntry entity) async {
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
  bool existsByRemoteId(String remoteId) => _box.query(LedgerEntry_.remoteId.equals(remoteId)).build().count() > 0;

  @override
  Future<List<LedgerEntry>> getUnsynced() async => _box.query(LedgerEntry_.isSync.equals(false)).build().findAsync();

  @override
  int countUnsynced() => _box.query(LedgerEntry_.isSync.equals(false)).build().count();

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
  LedgerEntry? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(LedgerEntry entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
    }
    return save(entity);
  }
}
