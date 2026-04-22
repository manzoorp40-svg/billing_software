import 'package:super_market/objectbox.g.dart';
import '../models/bill.dart';
import '../models/bill.item.dart';
import 'base_repository.dart';

class BillRepository extends BaseRepository<Bill> {
  final Box<Bill> _box;
  final Box<BillItem> _itemBox;

  BillRepository(this._box, this._itemBox);

  @override
  Box<Bill> get box => _box;

  @override
  Future<List<Bill>> getAll() async => _box.getAll();

  @override
  Stream<List<Bill>> watchAll() => _box.query().watch(triggerImmediately: true).map((q) => q.find());

  @override
  Bill? getById(int id) => _box.get(id);

  @override
  Bill? getByRemoteId(String remoteId) => _box.query(Bill_.remoteId.equals(remoteId)).build().findFirst();

  @override
  Future<int> save(Bill entity) async {
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
  bool existsByRemoteId(String remoteId) => _box.query(Bill_.remoteId.equals(remoteId)).build().count() > 0;

  @override
  Future<List<Bill>> getUnsynced() async => _box.query(Bill_.isSync.equals(false)).build().findAsync();

  @override
  int countUnsynced() => _box.query(Bill_.isSync.equals(false)).build().count();

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
  Bill? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Bill entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
    }
    return save(entity);
  }

  Future<List<Bill>> getByDateRange(int start, int end) async {
    final query = (_box.query(Bill_.billDate.between(start, end))
      ..order(Bill_.billDate, flags: Order.descending))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }
}
