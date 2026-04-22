import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../data/dto/party_dto.dart';
import '../../../../data/models/party.dart';
import '../../../../data/providers/database_provider.dart';

class PartyFormController extends GetxController {
  late final DatabaseProvider _db;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Edit mode
  final isEditMode = false.obs;
  final Party? editingParty;

  // Form fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final alternatePhoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final gstinController = TextEditingController();
  final openingBalanceController = TextEditingController();
  final notesController = TextEditingController();

  // Dropdown values
  final selectedPartyType = PartyType.supplier.obs;
  final balanceType = 0.obs; // 0 = receivable, 1 = payable

  // State
  final isLoading = false.obs;
  final isSaving = false.obs;
  final hasChanges = false.obs;

  // DTO for form data
  final Rx<PartyDto> formData = PartyDto(
    name: '',
    partyType: PartyType.supplier,
  ).obs;

  PartyFormController({this.editingParty}) {
    if (editingParty != null) {
      isEditMode.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();

    if (isEditMode.value) {
      _loadPartyData();
    }

    // Mark as changed when any field changes
    nameController.addListener(_markChanged);
    phoneController.addListener(_markChanged);
    // ... add listeners to other fields
  }

  void _markChanged() {
    hasChanges.value = true;
  }

  void _loadPartyData() {
    if (editingParty == null) return;

    nameController.text = editingParty!.name;
    phoneController.text = editingParty!.phone ?? '';
    alternatePhoneController.text = editingParty!.alternatePhone ?? '';
    emailController.text = editingParty!.email ?? '';
    addressController.text = editingParty!.address ?? '';
    gstinController.text = editingParty!.gstin ?? '';
    openingBalanceController.text = editingParty!.openingBalance.toString();
    notesController.text = editingParty!.notes ?? '';

    selectedPartyType.value = PartyType.fromIndex(editingParty!.partyType);
    balanceType.value = editingParty!.balance >= 0 ? 0 : 1;

    hasChanges.value = false;
  }

  void setPartyType(PartyType type) {
    selectedPartyType.value = type;
    hasChanges.value = true;
  }

  void setBalanceType(int type) {
    balanceType.value = type;
    hasChanges.value = true;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 10) {
        return 'Phone must be at least 10 digits';
      }
    }
    return null;
  }

  String? validateGstin(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 15) {
        return 'GSTIN must be 15 characters';
      }
      final regex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
      if (!regex.hasMatch(value.toUpperCase())) {
        return 'Invalid GSTIN format';
      }
    }
    return null;
  }

  String? validateOpeningBalance(String? value) {
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Enter a valid number';
      }
    }
    return null;
  }

  Future<void> saveParty() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSaving.value = true;

    try {
      final openingBalance = double.tryParse(openingBalanceController.text) ?? 0;
      final adjustedBalance = balanceType.value == 1 ? -openingBalance : openingBalance;

      final party = Party(
        localId: editingParty?.localId ?? 0,
        remoteId: editingParty?.remoteId ?? IdGenerator.generate(),
        isSync: false,
        name: nameController.text.trim(),
        partyType: selectedPartyType.value.value,
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        alternatePhone: alternatePhoneController.text.trim().isEmpty ? null : alternatePhoneController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        gstin: gstinController.text.trim().isEmpty ? null : gstinController.text.toUpperCase().trim(),
        balance: adjustedBalance,
        openingBalance: openingBalance,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        isActive: true,
        createdAt: editingParty?.createdAt ?? DateTime.now().toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );

      await _db.partyRepository.save(party);

      hasChanges.value = false;
      Get.back();
      Get.snackbar(
        'Success',
        isEditMode.value ? 'Party updated successfully' : 'Party created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save party: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> onWillPop() async {
    if (!hasChanges.value) return true;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    gstinController.dispose();
    openingBalanceController.dispose();
    notesController.dispose();
    super.onClose();
  }
}