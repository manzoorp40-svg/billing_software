import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/sync_service.dart';
import '../../labor/attendance/controller/worker_attendance_controller.dart';
import '../../master/party/controllers/dashboard_controller.dart';
import '../../master/party/controllers/material_list_controller.dart';
import '../../master/party/controllers/party_list_controller.dart';
import '../../master/party/controllers/purchase_list_controller.dart';
import '../../master/site/controllers/site_list_controller.dart';
import '../../master/worker/controllers/worker_list_controller.dart';
import '../../master/unit/controllers/unit_list_controller.dart';
import '../../billing/controllers/bill_list_controller.dart';
import '../../reports/controllers/reports_controller.dart';

import '../../dashboard/view/dashboard_view.dart';
import '../../master/party/views/party_list_view.dart';
import '../../master/party/views/material_list_view.dart';
import '../../master/party/views/purchase_list_view.dart';
import '../../master/site/views/site_list_view.dart';
import '../../master/worker/views/worker_list_view.dart';
import '../../master/unit/views/unit_list_view.dart';
import '../../master/party/views/party_list_view.dart'; // Duplicate but checking
import '../../labor/attendance/view/attendance_view.dart';
import '../../billing/views/bill_list_view.dart';
import '../../reports/views/reports_menu_view.dart';

class MainLayoutController extends GetxController {
  final currentIndex = 0.obs;
  final pageTitle = 'Dashboard'.obs;
  final isSynced = true.obs;
  final pendingCount = 0.obs;

  late final List<Widget> _pages;

  @override
  void onInit() {
    super.onInit();
    _initPages();
    _initSyncListener();
  }

  void _initPages() {
    _pages = [
      GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (_) => const DashboardView(),
      ),
      GetBuilder<PartyListController>(
        init: PartyListController(),
        builder: (_) => const PartyListView(),
      ),
      GetBuilder<MaterialListController>(
        init: MaterialListController(),
        builder: (_) => const MaterialListView(),
      ),
      GetBuilder<SiteListController>(
        init: SiteListController(),
        builder: (_) => const SiteListView(),
      ),
      GetBuilder<WorkerListController>(
        init: WorkerListController(),
        builder: (_) => const WorkerListView(),
      ),
      GetBuilder<UnitListController>(
        init: UnitListController(),
        builder: (_) => const UnitListView(),
      ),
      GetBuilder<PurchaseListController>(
        init: PurchaseListController(),
        builder: (_) => const PurchaseListView(),
      ),
      // Material Allocation - placeholder
      const Center(child: Text('Material Allocation')),
      GetBuilder<AttendanceController>(
        init: AttendanceController(),
        builder: (_) => const AttendanceView(),
      ),
      GetBuilder<BillListController>(
        init: BillListController(),
        builder: (_) => const BillListView(),
      ),
      GetBuilder<ReportsController>(
        init: ReportsController(),
        builder: (_) => const ReportsMenuView(),
      ),
      // Ledger - placeholder
      const Center(child: Text('Ledger')),
      // Settings - placeholder
      const Center(child: Text('Settings')),
    ];
  }

  void _initSyncListener() {
    final syncService = Get.find<SyncService>();
    ever(syncService.pendingCount, (count) {
      pendingCount.value = count;
      isSynced.value = count == 0;
    });
  }

  List<Widget> get pages => _pages;

  void setPage(int index) {
    currentIndex.value = index;
    pageTitle.value = _getPageTitle(index);
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Parties';
      case 2:
        return 'Materials';
      case 3:
        return 'Sites';
      case 4:
        return 'Workers';
      case 5:
        return 'Units';
      case 6:
        return 'Purchases';
      case 7:
        return 'Material Allocation';
      case 8:
        return 'Labor';
      case 9:
        return 'Billing';
      case 10:
        return 'Reports';
      case 11:
        return 'Ledger';
      case 12:
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }
}