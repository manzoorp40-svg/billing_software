abstract class AppRoutes {
  // Root
  static const String splash = '/splash';
  static const String main = '/main';

  // Authentication (future)
  static const String login = '/login';

  // Master Data
  static const String partyList = '/parties';
  static const String partyForm = '/parties/form';
  static const String materialList = '/materials';
  static const String materialForm = '/materials/form';
  static const String unitList = '/units';
  static const String unitForm = '/units/form';
  static const String workerList = '/workers';
  static const String workerForm = '/workers/form';

  // Sites
  static const String siteList = '/sites';
  static const String siteForm = '/sites/form';
  static const String siteDetail = '/sites/detail';

  // Transactions
  static const String purchaseList = '/purchases';
  static const String purchaseForm = '/purchases/form';
  static const String allocationList = '/allocations';
  static const String allocationForm = '/allocations/form';

  // Labor
  static const String attendance = '/labor/attendance';
  static const String workerPaymentList = '/labor/payments';
  static const String workerPaymentForm = '/labor/payments/form';
  static const String laborReport = '/labor/report';

  // Billing
  static const String billList = '/bills';
  static const String billForm = '/bills/form';

  // Reports
  static const String reports = '/reports';
  static const String stockReport = '/reports/stock';
  static const String partyLedger = '/ledger/:partyId';
  static const String gstReport = '/reports/gst';

  // Settings
  static const String settings = '/settings';
  static const String companyProfile = '/settings/company';
  static const String backupRestore = '/settings/backup';
  static const String syncSettings = '/settings/sync';
}