import 'package:get/get.dart';

import '../../../../core/services/sync_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/models/bill.dart';
import '../../../../data/models/material.dart';
import '../../../../data/models/purchase.dart';
import '../../../../data/providers/database_provider.dart';

class DashboardController extends GetxController {
  late final DatabaseProvider _db;
  late final SyncService _syncService;

  // State
  final isLoading = false.obs;

  // Summary stats
  final totalSites = 0.obs;
  final activeSites = 0.obs;
  final completedSites = 0.obs;

  final totalWorkers = 0.obs;
  final workersPresentToday = 0.obs;

  final totalParties = 0.obs;
  final totalReceivables = 0.0.obs;
  final totalPayables = 0.0.obs;

  final lowStockMaterials = <Material>[].obs;
  final totalStockValue = 0.0.obs;

  // Recent data
  final recentPurchases = <Purchase>[].obs;
  final recentBills = <Bill>[].obs;

  // This month stats
  final purchasesThisMonth = 0.obs;
  final purchasesAmountThisMonth = 0.0.obs;
  final billsThisMonth = 0.obs;
  final billsAmountThisMonth = 0.0.obs;

  // Sync status
  final pendingSync = 0.obs;
  final lastSyncTime = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();
    _syncService = Get.find<SyncService>();

    loadDashboard();

    // Refresh periodically
    ever(_syncService.pendingCount, (_) {
      pendingSync.value = _syncService.pendingCount.value;
      lastSyncTime.value = _syncService.lastSyncTime.value;
    });
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      await _loadSiteStats();
      await _loadWorkerStats();
      await _loadPartyStats();
      await _loadMaterialStats();
      await _loadRecentData();
      await _loadMonthStats();
      await _loadSyncStatus();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSiteStats() async {
    final stats = _db.siteRepository.getStatistics();
    totalSites.value = stats['totalSites'] as int;
    activeSites.value = stats['active'] as int;
    completedSites.value = stats['completed'] as int;
  }

  Future<void> _loadWorkerStats() async {
    totalWorkers.value = _db.workerRepository.getActiveCount();

    // Count workers present today
    final todayMidnight = AppDateUtils.todayMidnight();
    final tomorrowMidnight = todayMidnight + (24 * 60 * 60 * 1000);

    final attendance = await _db.workerAttendanceRepository.getByDateRange(
      todayMidnight,
      tomorrowMidnight,
    );

    workersPresentToday.value = attendance.where((a) => a.isPresent).length;
  }

  Future<void> _loadPartyStats() async {
    totalParties.value = _db.partyRepository.count();
    totalReceivables.value = _db.partyRepository.getTotalReceivables();
    totalPayables.value = _db.partyRepository.getTotalPayables();
  }

  Future<void> _loadMaterialStats() async {
    lowStockMaterials.value = await _db.materialRepository.getLowStock();
    totalStockValue.value = _db.materialRepository.getTotalStockValue();
  }

  Future<void> _loadRecentData() async {
    final allPurchases = await _db.purchaseRepository.getAll();
    recentPurchases.value = allPurchases.take(5).toList();

    final allBills = await _db.billRepository.getAll();
    recentBills.value = allBills.take(5).toList();
  }

  Future<void> _loadMonthStats() async {
    final startOfMonth = AppDateUtils.startOfMonth();
    final endOfMonth = AppDateUtils.endOfMonth();

    final purchases = await _db.purchaseRepository.getByDateRange(
      startOfMonth,
      endOfMonth,
    );

    purchasesThisMonth.value = purchases.length;
    purchasesAmountThisMonth.value = purchases.fold(0.0, (sum, p) => sum + p.totalAmount);

    final bills = await _db.billRepository.getByDateRange(
      startOfMonth,
      endOfMonth,
    );

    billsThisMonth.value = bills.length;
    billsAmountThisMonth.value = bills.fold(0.0, (sum, b) => sum + b.totalAmount);
  }

  Future<void> _loadSyncStatus() async {
    pendingSync.value = _syncService.pendingCount.value;
    lastSyncTime.value = _syncService.lastSyncTime.value;
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  void navigateTo(String route) {
    Get.toNamed(route);
  }
}