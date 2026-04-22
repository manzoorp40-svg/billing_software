import 'package:objectbox/objectbox.dart';
import 'package:super_market/objectbox.g.dart';
import 'package:super_market/app/data/models/party.dart';
import 'base_repository.dart';

class PartyRepository extends BaseRepository<Party> {
  final Box<Party> _box;

  PartyRepository(this._box);

  @override
  Box<Party> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Party>> getAll() async {
    final query = (_box.query(Party_.isActive.equals(true))
      ..order(Party_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Party>> watchAll() {
    return _box
        .query(Party_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Party? getById(int id) => _box.get(id);

  @override
  Party? getByRemoteId(String remoteId) {
    return _box.query(Party_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Party entity) async {
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
    // Soft delete
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
    return _box.query(Party_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Party>> getUnsynced() async {
    return _box.query(Party_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Party_.isSync.equals(false)).build().count();
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
  Party? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Party entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
      entity.isActive = existing.isActive; // Preserve active status
    }
    return save(entity);
  }

  /// Get by party type (supplier, client, subcontractor)
  Future<List<Party>> getByType(int partyType) async {
    final query = (_box.query(Party_.partyType.equals(partyType) & Party_.isActive.equals(true))
      ..order(Party_.name))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Stream by party type
  Stream<List<Party>> watchByType(int partyType) {
    return _box
        .query(Party_.partyType.equals(partyType) & Party_.isActive.equals(true))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Search parties by name
  Future<List<Party>> search(String query) async {
    return _box
        .query(Party_.name.contains(query, caseSensitive: false) & Party_.isActive.equals(true))
        .build()
        .findAsync();
  }

  /// Get suppliers only
  Future<List<Party>> getSuppliers() => getByType(0);

  /// Get clients only
  Future<List<Party>> getClients() => getByType(1);

  /// Get subcontractors only
  Future<List<Party>> getSubcontractors() => getByType(2);

  /// Get parties with receivable balance (> 0)
  Future<List<Party>> getReceivables() async {
    final query = (_box.query(Party_.balance.greaterThan(0) & Party_.isActive.equals(true))
      ..order(Party_.balance, flags: Order.descending))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Get parties with payable balance (< 0)
  Future<List<Party>> getPayables() async {
    final query = (_box.query(Party_.balance.lessThan(0) & Party_.isActive.equals(true))
      ..order(Party_.balance))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Update party balance
  Future<void> updateBalance(int localId, double newBalance) async {
    final entity = getById(localId);
    if (entity != null) {
      entity.balance = newBalance;
      entity.updatedAt = now();
      entity.isSync = false;
      _box.put(entity);
    }
  }

  /// Get total receivables
  double getTotalReceivables() {
    double total = 0;
    final query = _box.query(Party_.balance.greaterThan(0) & Party_.isActive.equals(true)).build();
    final parties = query.find();
    query.close();
    for (final party in parties) {
      total += party.balance;
    }
    return total;
  }

  /// Get total payables
  double getTotalPayables() {
    double total = 0;
    final query = _box.query(Party_.balance.lessThan(0) & Party_.isActive.equals(true)).build();
    final parties = query.find();
    query.close();
    for (final party in parties) {
      total += party.balance;
    }
    return total;
  }
}