import 'package:get/get.dart';

import '../../data/models/material.dart';
import '../../data/providers/database_provider.dart';

class StockService extends GetxService {
  late final DatabaseProvider _db;

  final lowStockItems = <Material>[].obs;

  Future<StockService> init() async {
    _db = Get.find<DatabaseProvider>();
    await _loadLowStock();
    return this;
  }

  Future<void> _loadLowStock() async {
    lowStockItems.value = await _db.materialRepository.getLowStock();
  }

  /// Add stock when material is purchased
  Future<void> addStockOnPurchase({
    required int materialLocalId,
    required double quantity,
  }) async {
    final material = _db.materialRepository.getById(materialLocalId);
    if (material == null) return;

    await _db.materialRepository.addToStock(materialLocalId, quantity);
    await _loadLowStock();
  }

  /// Deduct stock when allocated to site
  Future<void> deductStockOnAllocation({
    required int materialLocalId,
    required double quantity,
  }) async {
    final material = _db.materialRepository.getById(materialLocalId);
    if (material == null) return;

    await _db.materialRepository.deductFromStock(materialLocalId, quantity);
    await _loadLowStock();
  }

  /// Return stock when material returned from site
  Future<void> returnStockFromSite({
    required int materialLocalId,
    required double quantity,
  }) async {
    final material = _db.materialRepository.getById(materialLocalId);
    if (material == null) return;

    await _db.materialRepository.addToStock(materialLocalId, quantity);
    await _loadLowStock();
  }

  /// Get stock for a specific material
  Future<Material?> getStock(int materialLocalId) async {
    return _db.materialRepository.getById(materialLocalId);
  }

  /// Get total stock value
  double getTotalStockValue() {
    return _db.materialRepository.getTotalStockValue();
  }

  /// Get stock summary
  Map<String, dynamic> getStockSummary() {
    final materials = lowStockItems;
    final total = _db.materialRepository.count();

    return {
      'totalMaterials': total,
      'lowStockCount': materials.length,
      'outOfStockCount': materials.where((m) => m.currentStock <= 0).length,
      'totalValue': getTotalStockValue(),
    };
  }
}