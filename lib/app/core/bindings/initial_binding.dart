import 'package:get/get.dart';

import '../../data/providers/database_provider.dart';
import '../services/backup_service.dart';
import '../services/number_series_service.dart';
import '../services/stock_service.dart';
import '../services/sync_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services (singleton)
    Get.putAsync<SyncService>(() async {
      final service = SyncService();
      return await service.init();
    }, permanent: true);

    Get.putAsync<BackupService>(() async {
      final service = BackupService();
      return await service.init();
    }, permanent: true);

    Get.putAsync<StockService>(() async {
      final service = StockService();
      return await service.init();
    }, permanent: true);

    Get.putAsync<NumberSeriesService>(() async {
      final service = NumberSeriesService();
      return await service.init();
    }, permanent: true);
  }
}