import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/stock_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/models/party.dart';
import '../../../../data/models/purchase.dart';
import '../../../../data/providers/database_provider.dart';
import '../../../../routes/app_routes.dart';

class PurchaseListController extends GetxController {
  late final DatabaseProvider _db;
  late final StockService _stockService;

  // State
  final purchases = <Purchase>[].obs;
  final filteredPurchases = <Purchase>[].obs;
  final isLoading = false.obs;

  // Filters
  final searchQuery = ''.obs;
  final dateFrom = Rxn<int>();
  final dateTo = Rxn<int>();
  final selectedSupplier = Rxn<int>();

  // Dropdown data
  final suppliers = <Party>[].obs;

  // Stats
  final totalPurchases = 0.obs;
  final totalAmount = 0.0.obs;
  final thisMonthPurchases = 0.obs;
  final thisMonthAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();
    _stockService = Get.find<StockService>();
    loadData();

    ever(searchQuery, (_) => _applyFilters());
    ever(dateFrom, (_) => _applyFilters());
    ever(dateTo, (_) => _applyFilters());
    ever(selectedSupplier, (_) => _applyFilters());
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      purchases.value = await _db.purchaseRepository.getAll();
      suppliers.value = await _db.partyRepository.getSuppliers();
      _updateStats();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStats() {
    totalPurchases.value = purchases.length;
    totalAmount.value = purchases.fold(0.0, (sum, p) => sum + p.totalAmount);

    final startOfMonth = AppDateUtils.startOfMonth();
    final endOfMonth = AppDateUtils.endOfMonth();

    final thisMonth = purchases.where((p) =>
    p.purchaseDate >= startOfMonth && p.purchaseDate <= endOfMonth).toList();

    thisMonthPurchases.value = thisMonth.length;
    thisMonthAmount.value = thisMonth.fold(0.0, (sum, p) => sum + p.totalAmount);
  }

  void _applyFilters() {
    var result = purchases.toList();

    // Date filter
    if (dateFrom.value != null) {
      result = result.where((p) => p.purchaseDate >= dateFrom.value!).toList();
    }
    if (dateTo.value != null) {
      result = result.where((p) => p.purchaseDate <= dateTo.value!).toList();
    }

    // Supplier filter
    if (selectedSupplier.value != null) {
      result = result.where((p) => p.supplierPartyLocalId == selectedSupplier.value).toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((p) =>
      p.purchaseNumber.toLowerCase().contains(query) ||
          (p.supplierName?.toLowerCase().contains(query) ?? false) ||
          (p.invoiceNumber?.toLowerCase().contains(query) ?? false)).toList();
    }

    filteredPurchases.value = result;
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setDateRange(int? from, int? to) {
    dateFrom.value = from;
    dateTo.value = to;
  }

  void setSupplierFilter(int? supplierLocalId) {
    selectedSupplier.value = supplierLocalId;
  }

  void clearFilters() {
    searchQuery.value = '';
    dateFrom.value = null;
    dateTo.value = null;
    selectedSupplier.value = null;
  }

  Future<void> deletePurchase(int localId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Purchase'),
        content: const Text('Are you sure you want to delete this purchase? Stock will be restored.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Restore stock for each item
      final items = await _db.purchaseRepository.getItems(localId);
      for (final item in items) {
        if (item.materialLocalId != null) {
          await _stockService.returnStockFromSite(
            materialLocalId: item.materialLocalId!,
            quantity: item.quantity,
          );
        }
      }

      _db.purchaseRepository.delete(localId);
      Get.snackbar('Success', 'Purchase deleted and stock restored');
    }
  }

  void addNewPurchase() {
    Get.toNamed(AppRoutes.purchaseForm);
  }

  void editPurchase(Purchase purchase) {
    Get.toNamed(AppRoutes.purchaseForm, arguments: purchase);
  }

  void viewPurchase(Purchase purchase) {
    Get.toNamed(AppRoutes.purchaseForm, arguments: {'purchase': purchase, 'readonly': true});
  }

  void setQuickFilter(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'today':
        dateFrom.value = AppDateUtils.todayMidnight();
        dateTo.value = now.millisecondsSinceEpoch;
        break;
      case 'week':
        dateFrom.value = now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
        dateTo.value = now.millisecondsSinceEpoch;
        break;
      case 'month':
        dateFrom.value = AppDateUtils.startOfMonth();
        dateTo.value = AppDateUtils.endOfMonth();
        break;
      case 'all':
        dateFrom.value = null;
        dateTo.value = null;
        break;
    }
  }
}