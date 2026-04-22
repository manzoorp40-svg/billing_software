import 'package:super_market/app/data/models/purchase.dart';

import '../../../objectbox.g.dart';
import '../models/purchase_item.dart';
import 'base_repository.dart';

class PurchaseRepository extends BaseRepository<Purchase> {
  final Box<Purchase> _box;
  final Box<PurchaseItem> _itemBox;

  PurchaseRepository(this._box, this._itemBox);

  @override
  Box<Purchase> get box => _box;

  // ============ CRUD ============

  @override
  Future<List<Purchase>> getAll() async {
    final query = (_box.query()
      ..order(Purchase_.purchaseDate, flags: Order.descending))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  @override
  Stream<List<Purchase>> watchAll() {
    return _box
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Purchase? getById(int id) => _box.get(id);

  @override
  Purchase? getByRemoteId(String remoteId) {
    return _box.query(Purchase_.remoteId.equals(remoteId)).build().findFirst();
  }

  @override
  Future<int> save(Purchase entity) async {
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
      // Also delete items
      final items = _itemBox
          .query(PurchaseItem_.purchaseLocalId.equals(id))
          .build()
          .find();
      _itemBox.removeMany(items.map((e) => e.localId).toList());

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
    return _box.query(Purchase_.remoteId.equals(remoteId)).build().count() > 0;
  }

  // ============ SYNC ============

  @override
  Future<List<Purchase>> getUnsynced() async {
    return _box.query(Purchase_.isSync.equals(false)).build().findAsync();
  }

  @override
  int countUnsynced() {
    return _box.query(Purchase_.isSync.equals(false)).build().count();
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
  Purchase? findOneByRemoteId(String remoteId) => getByRemoteId(remoteId);

  @override
  Future<int> upsert(Purchase entity) async {
    final existing = getByRemoteId(entity.remoteId);
    if (existing != null) {
      entity.localId = existing.localId;
      entity.createdAt = existing.createdAt;
      entity.isActive = existing.isActive;
    }
    return save(entity);
  }

  /// Get purchases by date range
  Future<List<Purchase>> getByDateRange(int fromDate, int toDate) async {
    final query = (_box.query(
        Purchase_.purchaseDate.greaterOrEqual(fromDate) &
        Purchase_.purchaseDate.lessOrEqual(toDate)
    )..order(Purchase_.purchaseDate, flags: Order.descending))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Get purchases by supplier
  Future<List<Purchase>> getBySupplier(int supplierLocalId) async {
    final query = (_box.query(Purchase_.supplierPartyLocalId.equals(supplierLocalId))
      ..order(Purchase_.purchaseDate, flags: Order.descending))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Stream purchases by supplier
  Stream<List<Purchase>> watchBySupplier(int supplierLocalId) {
    return _box
        .query(Purchase_.supplierPartyLocalId.equals(supplierLocalId))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Get next purchase number
  String getNextPurchaseNumber() {
    final count = _box.count();
    return 'PUR-${DateTime.now().year}-${(count + 1).toString().padLeft(5, '0')}';
  }

  /// Get total purchases amount
  double getTotalPurchasesAmount({int? fromDate, int? toDate}) {
    double total = 0;
    final query = (fromDate != null && toDate != null)
        ? (_box.query(
          Purchase_.purchaseDate.greaterOrEqual(fromDate) &
          Purchase_.purchaseDate.lessOrEqual(toDate)
        )).build()
        : _box.query().build();
        
    final purchases = query.find();
    query.close();
    for (final p in purchases) {
      total += p.totalAmount;
    }
    return total;
  }

  /// Get purchases this month
  Future<List<Purchase>> getThisMonth() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getByDateRange(
      startOfMonth.toUtc().millisecondsSinceEpoch,
      endOfMonth.toUtc().millisecondsSinceEpoch,
    );
  }

  // ============ PURCHASE ITEMS ============

  /// Get items for a purchase
  Future<List<PurchaseItem>> getItems(int purchaseLocalId) async {
    final query = (_itemBox
        .query(PurchaseItem_.purchaseLocalId.equals(purchaseLocalId))
      ..order(PurchaseItem_.sortOrder))
      .build();
    final results = await query.findAsync();
    query.close();
    return results;
  }

  /// Save a purchase with items
  Future<int> saveWithItems(Purchase purchase, List<PurchaseItem> items) async {
    // Save purchase
    final purchaseId = await save(purchase);

    // Delete existing items
    final existingItems = await getItems(purchase.localId);
    _itemBox.removeMany(existingItems.map((e) => e.localId).toList());

    // Save new items
    for (final item in items) {
      item.purchaseLocalId = purchase.localId;
      item.purchaseRemoteId = purchase.remoteId;
      item.remoteId = item.remoteId.isEmpty ? generateRemoteId() : item.remoteId;
      item.isSync = false;
      item.createdAt = item.createdAt == 0 ? now() : item.createdAt;
      item.updatedAt = now();
      await _itemBox.putAsync(item);
    }

    return purchaseId;
  }
}