import 'package:get/get.dart';

import '../../data/models/company_settings.dart';
import '../../data/providers/database_provider.dart';

class NumberSeriesService extends GetxService {
  late final DatabaseProvider _db;
  late final CompanySettings _settings;

  Future<NumberSeriesService> init() async {
    _db = Get.find<DatabaseProvider>();
    _settings = await _db.companySettingsRepository.getOrCreate();
    return this;
  }

  /// Generate next purchase number
  String getNextPurchaseNumber() {
    final prefix = _getPrefix(_settings.purchasePrefix);
    final number = _settings.purchaseStartNumber;
    return '$prefix${DateTime.now().year}/${number.toString().padLeft(5, '0')}';
  }

  /// Generate next bill number
  String getNextBillNumber() {
    final prefix = _getPrefix(_settings.billPrefix);
    final number = _settings.billStartNumber;
    return '$prefix${DateTime.now().year}/${number.toString().padLeft(5, '0')}';
  }

  /// Generate next worker payment number
  String getNextWorkerPaymentNumber() {
    final prefix = _getPrefix(_settings.workerPaymentPrefix);
    final number = _settings.workerPaymentStartNumber;
    return '$prefix${DateTime.now().year}/${number.toString().padLeft(5, '0')}';
  }

  String _getPrefix(int prefixType) {
    switch (prefixType) {
      case 0:
        return 'CB'; // Construction Billing
      case 1:
        return 'EST'; // Estimate
      case 2:
        return 'INV'; // Invoice
      default:
        return 'CB';
    }
  }

  /// Increment purchase number
  Future<void> incrementPurchaseNumber() async {
    _settings.purchaseStartNumber++;
    _settings.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    _settings.isSync = false;
    await _db.companySettingsRepository.save(_settings);
  }

  /// Increment bill number
  Future<void> incrementBillNumber() async {
    _settings.billStartNumber++;
    _settings.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    _settings.isSync = false;
    await _db.companySettingsRepository.save(_settings);
  }

  /// Increment worker payment number
  Future<void> incrementWorkerPaymentNumber() async {
    _settings.workerPaymentStartNumber++;
    _settings.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    _settings.isSync = false;
    await _db.companySettingsRepository.save(_settings);
  }

  /// Reset number series for new year
  Future<void> resetForNewYear() async {
    // Optionally reset numbers at start of new year
    final currentYear = DateTime.now().year;
    if (_settings.updatedAt > 0) {
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
        _settings.updatedAt,
        isUtc: true,
      );
      if (lastUpdate.year < currentYear) {
        // Keep current numbers but they will naturally increment with year
      }
    }
  }
}