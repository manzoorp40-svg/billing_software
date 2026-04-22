import 'package:super_market/objectbox.g.dart';
import '../models/company_settings.dart';
import 'base_repository.dart';

class CompanySettingsRepository extends BaseRepository<CompanySettings> {
  final Box<CompanySettings> _box;

  CompanySettingsRepository(this._box);

  @override
  Box<CompanySettings> get box => _box;

  @override
  Future<List<CompanySettings>> getAll() async => _box.getAll();

  @override
  Stream<List<CompanySettings>> watchAll() => _box.query().watch(triggerImmediately: true).map((q) => q.find());

  @override
  CompanySettings? getById(int id) => _box.get(id);

  @override
  CompanySettings? getByRemoteId(String remoteId) => _box.query(CompanySettings_.remoteId.equals(remoteId)).build().findFirst();

  @override
  Future<int> save(CompanySettings entity) async {
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
  bool existsByRemoteId(String remoteId) => _box.query(CompanySettings_.remoteId.equals(remoteId)).build().count() > 0;

  @override
  Future<List<CompanySettings>> getUnsynced() async => _box.query(CompanySettings_.isSync.equals(false)).build().findAsync();

  @override
  int countUnsynced() => _box.query(CompanySettings_.isSync.equals(false)).build().count();

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
  CompanySettings? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(CompanySettings entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
    }
    return save(entity);
  }

  /// Get settings or create default
  Future<CompanySettings> getOrCreate() async {
    final results = _box.getAll();
    if (results.isNotEmpty) return results.first;

    final settings = CompanySettings(
      companyName: 'My Construction Company',
      createdAt: now(),
      updatedAt: now(),
      remoteId: generateRemoteId(),
    );
    final id = await _box.putAsync(settings);
    settings.localId = id;
    return settings;
  }
}
