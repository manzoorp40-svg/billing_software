import 'package:flutter/material.dart' hide Material;
import 'package:get/get.dart';

import '../../../../data/models/unit.dart';
import '../../../../data/models/material.dart';
import '../../../../data/providers/database_provider.dart';
import '../../../../routes/app_routes.dart';

class MaterialListController extends GetxController {
  late final DatabaseProvider _db;

  // State
  final materials = <Material>[].obs;
  final filteredMaterials = <Material>[].obs;
  final units = <Unit>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedUnit = Rxn<int>();
  final showLowStockOnly = false.obs;
  final sortBy = 'name'.obs;
  final sortAsc = true.obs;

  // Counts
  final totalCount = 0.obs;
  final lowStockCount = 0.obs;
  final totalStockValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();
    loadData();

    ever(searchQuery, (_) => _applyFilters());
    ever(selectedUnit, (_) => _applyFilters());
    ever(showLowStockOnly, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());
    ever(sortAsc, (_) => _applyFilters());

    _db.materialRepository.watchAll().listen((data) {
      loadData();
    });
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      materials.value = await _db.materialRepository.getAll();
      units.value = await _db.unitRepository.getAll();
      _updateCounts();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCounts() {
    totalCount.value = materials.length;
    lowStockCount.value = materials.where((m) => m.trackStock && m.currentStock <= m.alertQuantity).length;
    totalStockValue.value = _db.materialRepository.getTotalStockValue();
  }

  void _applyFilters() {
    var result = materials.toList();

    // Filter by unit
    if (selectedUnit.value != null) {
      result = result.where((m) => m.unitLocalId == selectedUnit.value).toList();
    }

    // Filter by low stock
    if (showLowStockOnly.value) {
      result = result.where((m) => m.trackStock && m.currentStock <= m.alertQuantity).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((m) =>
      m.name.toLowerCase().contains(query) ||
          (m.hsnCode?.toLowerCase().contains(query) ?? false) ||
          (m.brand?.toLowerCase().contains(query) ?? false)).toList();
    }

    // Sort
    result.sort((a, b) {
      int comparison;
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'stock':
          comparison = a.currentStock.compareTo(b.currentStock);
          break;
        case 'rate':
          comparison = a.rate.compareTo(b.rate);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return sortAsc.value ? comparison : -comparison;
    });

    filteredMaterials.value = result;
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setUnitFilter(int? unitLocalId) {
    selectedUnit.value = unitLocalId;
  }

  void toggleLowStockFilter() {
    showLowStockOnly.value = !showLowStockOnly.value;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedUnit.value = null;
    showLowStockOnly.value = false;
  }

  void setSort(String field) {
    if (sortBy.value == field) {
      sortAsc.value = !sortAsc.value;
    } else {
      sortBy.value = field;
      sortAsc.value = true;
    }
  }

  Future<void> deleteMaterial(int localId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Material'),
        content: const Text('Are you sure you want to delete this material?'),
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
      _db.materialRepository.delete(localId);
      Get.snackbar('Success', 'Material deleted successfully');
    }
  }

  void addNewMaterial() {
    Get.toNamed(AppRoutes.materialForm);
  }

  void editMaterial(Material material) {
    Get.toNamed(AppRoutes.materialForm, arguments: material);
  }

  String getUnitSymbol(int unitLocalId) {
    final unit = units.firstWhereOrNull((u) => u.localId == unitLocalId);
    return unit?.symbol ?? '';
  }
}