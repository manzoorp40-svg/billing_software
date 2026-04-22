import 'package:get/get.dart';


import '../../data/models/sync_log.dart';
import '../../data/providers/database_provider.dart';
import '../utils/id_generator.dart';

class SyncService extends GetxService {
  late final DatabaseProvider _db;

  final isSyncing = false.obs;
  final lastSyncTime = 0.obs;
  final pendingCount = 0.obs;
  final lastError = Rxn<String>();

  Future<SyncService> init() async {
    _db = Get.find<DatabaseProvider>();
    await updatePendingCount();
    return this;
  }

  /// Update count of pending items
  Future<void> updatePendingCount() async {
    int count = 0;
    count += _db.unitRepository.countUnsynced();
    count += _db.partyRepository.countUnsynced();
    count += _db.materialRepository.countUnsynced();
    count += _db.siteRepository.countUnsynced();
    count += _db.workerRepository.countUnsynced();
    count += _db.purchaseRepository.countUnsynced();
    count += _db.billRepository.countUnsynced();
    count += _db.workerPaymentRepository.countUnsynced();
    pendingCount.value = count;
  }

  /// Perform full sync (push local + pull remote)
  Future<bool> sync() async {
    if (isSyncing.value) return false;
    if (pendingCount.value == 0) return true;

    isSyncing.value = true;
    lastError.value = null;

    try {
      final startTime = DateTime.now().millisecondsSinceEpoch;

      // 1. Push local changes
      final pushed = await _pushLocalChanges();

      // 2. Pull remote changes (mock for now)
      final pulled = await _pullRemoteChanges();

      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;

      // Log sync
      await _logSync(pushed: pushed, pulled: pulled, duration: duration);

      lastSyncTime.value = endTime;
      await updatePendingCount();

      isSyncing.value = false;
      return true;
    } catch (e) {
      lastError.value = e.toString();
      isSyncing.value = false;
      return false;
    }
  }

  /// Push local unsynced changes to server
  Future<int> _pushLocalChanges() async {
    int total = 0;

    // Get all unsynced entities from each repository
    final unsyncedUnits = await _db.unitRepository.getUnsynced();
    final unsyncedParties = await _db.partyRepository.getUnsynced();
    final unsyncedMaterials = await _db.materialRepository.getUnsynced();
    final unsyncedSites = await _db.siteRepository.getUnsynced();
    final unsyncedWorkers = await _db.workerRepository.getUnsynced();
    final unsyncedPurchases = await _db.purchaseRepository.getUnsynced();
    final unsyncedBills = await _db.billRepository.getUnsynced();

    // In a real implementation, this would call the API
    // For now, we just mark them as synced

    for (final unit in unsyncedUnits) {
      // await api.push('units', unit);
      await _db.unitRepository.markSynced(unit.remoteId);
      total++;
    }

    for (final party in unsyncedParties) {
      // await api.push('parties', party);
      await _db.partyRepository.markSynced(party.remoteId);
      total++;
    }

    for (final material in unsyncedMaterials) {
      // await api.push('materials', material);
      await _db.materialRepository.markSynced(material.remoteId);
      total++;
    }

    for (final site in unsyncedSites) {
      // await api.push('sites', site);
      await _db.siteRepository.markSynced(site.remoteId);
      total++;
    }

    for (final worker in unsyncedWorkers) {
      // await api.push('workers', worker);
      await _db.workerRepository.markSynced(worker.remoteId);
      total++;
    }

    for (final purchase in unsyncedPurchases) {
      // await api.push('purchases', purchase);
      await _db.purchaseRepository.markSynced(purchase.remoteId);
      total++;
    }

    for (final bill in unsyncedBills) {
      // await api.push('bills', bill);
      await _db.billRepository.markSynced(bill.remoteId);
      total++;
    }

    return total;
  }

  /// Pull remote changes and upsert locally
  Future<int> _pullRemoteChanges() async {
    // In a real implementation, this would:
    // 1. Fetch changes from server since lastSyncTime
    // 2. For each entity, call repository.upsert()
    // 3. Handle conflicts

    // Mock implementation
    return 0;
  }

  /// Log sync operation
  Future<void> _logSync({
    required int pushed,
    required int pulled,
    required int duration,
  }) async {
    final log = SyncLog(
      remoteId: IdGenerator.generate(),
      syncDate: DateTime.now().toUtc().millisecondsSinceEpoch,
      entitiesPushed: pushed,
      entitiesPulled: pulled,
      errors: lastError.value != null ? 1 : 0,
      errorMessage: lastError.value,
      duration: duration,
      createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    await _db.syncLogRepository.save(log);
  }

  /// Force push all unsynced (useful before closing app)
  Future<int> forcePushAll() async {
    int total = 0;

    final unsyncedUnits = await _db.unitRepository.getUnsynced();
    final unsyncedParties = await _db.partyRepository.getUnsynced();
    final unsyncedMaterials = await _db.materialRepository.getUnsynced();
    final unsyncedSites = await _db.siteRepository.getUnsynced();
    final unsyncedWorkers = await _db.workerRepository.getUnsynced();
    final unsyncedPurchases = await _db.purchaseRepository.getUnsynced();
    final unsyncedBills = await _db.billRepository.getUnsynced();

    for (final unit in unsyncedUnits) {
      unit.isSync = true;
      unit.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.unitRepository.save(unit);
      total++;
    }

    for (final party in unsyncedParties) {
      party.isSync = true;
      party.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.partyRepository.save(party);
      total++;
    }

    for (final material in unsyncedMaterials) {
      material.isSync = true;
      material.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.materialRepository.save(material);
      total++;
    }

    for (final site in unsyncedSites) {
      site.isSync = true;
      site.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.siteRepository.save(site);
      total++;
    }

    for (final worker in unsyncedWorkers) {
      worker.isSync = true;
      worker.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.workerRepository.save(worker);
      total++;
    }

    for (final purchase in unsyncedPurchases) {
      purchase.isSync = true;
      purchase.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.purchaseRepository.save(purchase);
      total++;
    }

    for (final bill in unsyncedBills) {
      bill.isSync = true;
      bill.syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.billRepository.save(bill);
      total++;
    }

    await updatePendingCount();
    return total;
  }
}