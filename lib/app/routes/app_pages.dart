import 'package:get/get.dart';

import '../modules/dashboard/view/dashboard_view.dart';
import '../modules/master/party/views/party_form_view.dart';
import '../modules/master/party/views/party_list_view.dart';
import 'app_placeholders.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainLayoutView(),
      binding: MainLayoutBinding(),
    ),

    // Dashboard
    GetPage(
      name: '/dashboard',
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

    // Parties
    GetPage(
      name: AppRoutes.partyList,
      page: () => const PartyListView(),
      binding: PartyListBinding(),
    ),
    GetPage(
      name: AppRoutes.partyForm,
      page: () => const PartyFormView(),
      binding: PartyFormBinding(),
    ),

    // Materials
    GetPage(
      name: AppRoutes.materialList,
      page: () => const MaterialListView(),
      binding: MaterialListBinding(),
    ),
    GetPage(
      name: AppRoutes.materialForm,
      page: () => const MaterialFormView(),
      binding: MaterialFormBinding(),
    ),

    // Units
    GetPage(
      name: AppRoutes.unitList,
      page: () => const UnitListView(),
      binding: UnitListBinding(),
    ),
    GetPage(
      name: AppRoutes.unitForm,
      page: () => const UnitFormView(),
      binding: UnitFormBinding(),
    ),

    // Workers
    GetPage(
      name: AppRoutes.workerList,
      page: () => const WorkerListView(),
      binding: WorkerListBinding(),
    ),
    GetPage(
      name: AppRoutes.workerForm,
      page: () => const WorkerFormView(),
      binding: WorkerFormBinding(),
    ),

    // Sites
    GetPage(
      name: AppRoutes.siteList,
      page: () => const SiteListView(),
      binding: SiteListBinding(),
    ),
    GetPage(
      name: AppRoutes.siteForm,
      page: () => const SiteFormView(),
      binding: SiteFormBinding(),
    ),
    GetPage(
      name: AppRoutes.siteDetail,
      page: () => const SiteDetailView(),
      binding: SiteDetailBinding(),
    ),

    // Purchases
    GetPage(
      name: AppRoutes.purchaseList,
      page: () => const PurchaseListView(),
      binding: PurchaseListBinding(),
    ),
    GetPage(
      name: AppRoutes.purchaseForm,
      page: () => const PurchaseFormView(),
      binding: PurchaseFormBinding(),
    ),

    // Labor - Attendance
    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),

    // Labor - Payments
    GetPage(
      name: AppRoutes.workerPaymentList,
      page: () => const WorkerPaymentListView(),
      binding: WorkerPaymentListBinding(),
    ),
    GetPage(
      name: AppRoutes.workerPaymentForm,
      page: () => const WorkerPaymentFormView(),
      binding: WorkerPaymentFormBinding(),
    ),

    // Billing
    GetPage(
      name: AppRoutes.billList,
      page: () => const BillListView(),
      binding: BillListBinding(),
    ),
    GetPage(
      name: AppRoutes.billForm,
      page: () => const BillFormView(),
      binding: BillFormBinding(),
    ),

    // Reports
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsMenuView(),
      binding: ReportsBinding(),
    ),

    // Settings
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}