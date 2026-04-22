import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/enums.dart';
import '../../../../data/models/party.dart';
import '../../../../data/providers/database_provider.dart';
import '../../../../routes/app_routes.dart';

class PartyListController extends GetxController {
  late final DatabaseProvider _db;

  // State
  final parties = <Party>[].obs;
  final filteredParties = <Party>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedPartyType = Rxn<PartyType>();
  final sortBy = 'name'.obs;
  final sortAsc = true.obs;

  // Counts
  final totalCount = 0.obs;
  final supplierCount = 0.obs;
  final clientCount = 0.obs;
  final subcontractorCount = 0.obs;
  final totalReceivables = 0.0.obs;
  final totalPayables = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();
    loadParties();

    // Watch for changes
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedPartyType, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());
    ever(sortAsc, (_) => _applyFilters());

    // Watch database changes
    _db.partyRepository.watchAll().listen((data) {
      loadParties();
    });
  }

  Future<void> loadParties() async {
    isLoading.value = true;
    try {
      parties.value = await _db.partyRepository.getAll();
      _updateCounts();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCounts() {
    totalCount.value = parties.length;
    supplierCount.value = parties.where((p) => p.partyType == 0).length;
    clientCount.value = parties.where((p) => p.partyType == 1).length;
    subcontractorCount.value = parties.where((p) => p.partyType == 2).length;
    totalReceivables.value = _db.partyRepository.getTotalReceivables();
    totalPayables.value = _db.partyRepository.getTotalPayables();
  }

  void _applyFilters() {
    var result = parties.toList();

    // Filter by party type
    if (selectedPartyType.value != null) {
      result = result.where((p) => p.partyType == selectedPartyType.value!.value).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((p) =>
      p.name.toLowerCase().contains(query) ||
          (p.phone?.contains(query) ?? false) ||
          (p.gstin?.toLowerCase().contains(query) ?? false)).toList();
    }

    // Sort
    result.sort((a, b) {
      int comparison;
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'balance':
          comparison = a.balance.compareTo(b.balance);
          break;
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return sortAsc.value ? comparison : -comparison;
    });

    filteredParties.value = result;
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setPartyTypeFilter(PartyType? type) {
    selectedPartyType.value = type;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedPartyType.value = null;
  }

  void setSort(String field) {
    if (sortBy.value == field) {
      sortAsc.value = !sortAsc.value;
    } else {
      sortBy.value = field;
      sortAsc.value = true;
    }
  }

  Future<void> deleteParty(int localId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Party'),
        content: const Text('Are you sure you want to delete this party?'),
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
      _db.partyRepository.delete(localId);
      Get.snackbar('Success', 'Party deleted successfully');
    }
  }

  void viewPartyDetails(Party party) {
    Get.toNamed(AppRoutes.partyForm, arguments: party);
  }

  void addNewParty() {
    Get.toNamed(AppRoutes.partyForm);
  }
}