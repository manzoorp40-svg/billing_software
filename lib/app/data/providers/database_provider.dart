import 'package:get/get.dart' hide Worker;
import 'package:objectbox/objectbox.dart';
import 'package:super_market/objectbox.g.dart';

import '../models/bill.dart';
import '../models/bill.item.dart';
import '../models/company_settings.dart';
import '../models/ledger_entry.dart';
import '../models/material.dart';
import '../models/party.dart';
import '../models/purchase.dart';
import '../models/purchase_item.dart';
import '../models/site.dart';
import '../models/site_material_allocation.dart';
import '../models/sync_log.dart';
import '../models/unit.dart';
import '../models/worker.dart';
import '../models/worker_attendance.dart';
import '../models/worker_payment.dart';
import '../respositories/unit_repository.dart';
import '../respositories/party_repository.dart';
import '../respositories/material_repository.dart';
import '../respositories/site_repository.dart';
import '../respositories/worker_repository.dart';
import '../respositories/purchase_repository.dart';
import '../respositories/worker_attendance_repository.dart';
import '../respositories/worker_payment_repository.dart';
import '../respositories/bill_repository.dart';
import '../respositories/site_material_repository.dart';
import '../respositories/ledger_repository.dart';
import '../respositories/company_settings_repository.dart';
import '../respositories/sync_log_repository.dart';


class DatabaseProvider extends GetxService {
  late final Store store;

  // Repositories
  late final UnitRepository unitRepository;
  late final PartyRepository partyRepository;
  late final MaterialRepository materialRepository;
  late final SiteRepository siteRepository;
  late final WorkerRepository workerRepository;
  late final PurchaseRepository purchaseRepository;
  late final WorkerAttendanceRepository workerAttendanceRepository;
  late final WorkerPaymentRepository workerPaymentRepository;
  late final BillRepository billRepository;
  late final SiteMaterialRepository siteMaterialRepository;
  late final LedgerRepository ledgerRepository;
  late final CompanySettingsRepository companySettingsRepository;
  late final SyncLogRepository syncLogRepository;

  Future<DatabaseProvider> init() async {
    store = await openStore();

    // Initialize repositories
    unitRepository = UnitRepository(store.box<Unit>());
    partyRepository = PartyRepository(store.box<Party>());
    materialRepository = MaterialRepository(store.box<Material>());
    siteRepository = SiteRepository(store.box<Site>());
    workerRepository = WorkerRepository(store.box<Worker>());
    purchaseRepository = PurchaseRepository(
      store.box<Purchase>(),
      store.box<PurchaseItem>(),
    );
    workerAttendanceRepository = WorkerAttendanceRepository(
      store.box<WorkerAttendance>(),
    );
    workerPaymentRepository = WorkerPaymentRepository(
      store.box<WorkerPayment>(),
    );
    billRepository = BillRepository(
      store.box<Bill>(),
      store.box<BillItem>(),
    );
    siteMaterialRepository = SiteMaterialRepository(
      store.box<SiteMaterialAllocation>(),
    );
    ledgerRepository = LedgerRepository(store.box<LedgerEntry>());
    companySettingsRepository = CompanySettingsRepository(
      store.box<CompanySettings>(),
    );
    syncLogRepository = SyncLogRepository(store.box<SyncLog>());

    // Seed default data
    await unitRepository.seedDefaultUnits();

    return this;
  }

  @override
  void onClose() {
    store.close();
    super.onClose();
  }
}