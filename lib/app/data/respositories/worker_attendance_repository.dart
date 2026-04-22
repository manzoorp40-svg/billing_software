import 'package:super_market/objectbox.g.dart';
import '../models/worker_attendance.dart';
import 'base_repository.dart';

class WorkerAttendanceRepository extends BaseRepository<WorkerAttendance> {
  final Box<WorkerAttendance> _box;

  WorkerAttendanceRepository(this._box);

  @override
  Box<WorkerAttendance> get box => _box;

  @override
  Future<List<WorkerAttendance>> getAll() async => _box.getAll();

  @override
  Stream<List<WorkerAttendance>> watchAll() => _box.query().watch(triggerImmediately: true).map((q) => q.find());

  @override
  WorkerAttendance? getById(int id) => _box.get(id);

  @override
  WorkerAttendance? getByRemoteId(String remoteId) => _box.query(WorkerAttendance_.remoteId.equals(remoteId)).build().findFirst();

  @override
  Future<int> save(WorkerAttendance entity) async {
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
  bool existsByRemoteId(String remoteId) => _box.query(WorkerAttendance_.remoteId.equals(remoteId)).build().count() > 0;

  @override
  Future<List<WorkerAttendance>> getUnsynced() async => _box.query(WorkerAttendance_.isSync.equals(false)).build().findAsync();

  @override
  int countUnsynced() => _box.query(WorkerAttendance_.isSync.equals(false)).build().count();

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
  WorkerAttendance? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(WorkerAttendance entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
    }
    return save(entity);
  }

  Future<List<WorkerAttendance>> getByDateRange(int start, int end) async {
    return _box.query(WorkerAttendance_.attendanceDate.between(start, end)).build().findAsync();
  }
}
