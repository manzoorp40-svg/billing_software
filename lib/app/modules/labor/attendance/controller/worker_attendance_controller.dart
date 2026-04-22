import 'package:get/get.dart' hide Worker;

import '../../../../core/constants/enums.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../data/models/site.dart';
import '../../../../data/models/worker.dart';
import '../../../../data/models/worker_attendance.dart';
import '../../../../data/providers/database_provider.dart';

class AttendanceController extends GetxController {
  late final DatabaseProvider _db;

  // State
  final selectedDate = DateTime.now().obs;
  final workers = <Worker>[].obs;
  final attendanceMap = <int, WorkerAttendance>{}.obs; // workerId -> attendance
  final sites = <Site>[].obs;
  final selectedSite = Rxn<int>();

  final isLoading = false.obs;
  final isSaving = false.obs;

  // Stats
  final totalWorkers = 0.obs;
  final presentCount = 0.obs;
  final absentCount = 0.obs;
  final halfDayCount = 0.obs;
  final totalWages = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _db = Get.find<DatabaseProvider>();
    loadData();

    ever(selectedDate, (_) => loadAttendance());
    ever(selectedSite, (_) => loadAttendance());
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      workers.value = await _db.workerRepository.getAll();
      sites.value = await _db.siteRepository.getActiveSites();
      await loadAttendance();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAttendance() async {
    final date = selectedDate.value;
    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).millisecondsSinceEpoch;

    final allAttendance = await _db.workerAttendanceRepository.getByDateRange(
      startOfDay,
      endOfDay,
    );

    attendanceMap.clear();

    for (final a in allAttendance) {
      attendanceMap[a.workerLocalId] = a;
    }

    _updateStats();
  }

  void _updateStats() {
    totalWorkers.value = workers.length;

    int present = 0;
    int absent = 0;
    int halfDay = 0;
    double wages = 0;

    for (final worker in workers) {
      final attendance = attendanceMap[worker.localId];
      if (attendance != null) {
        if (attendance.isPresent) {
          present++;
          wages += attendance.totalAmount;
          if (attendance.isHalfDay) {
            halfDay++;
            present--;
            absent++;
          }
        } else {
          absent++;
        }
      } else {
        absent++; // Not marked = absent
      }
    }

    presentCount.value = present;
    absentCount.value = absent;
    halfDayCount.value = halfDay;
    totalWages.value = wages;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
  }

  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
  }

  void goToToday() {
    selectedDate.value = DateTime.now();
  }

  void setSite(int? siteLocalId) {
    selectedSite.value = siteLocalId;
  }

  bool isPresent(int workerLocalId) {
    return attendanceMap[workerLocalId]?.isPresent ?? false;
  }

  bool isHalfDay(int workerLocalId) {
    return attendanceMap[workerLocalId]?.isHalfDay ?? false;
  }

  double getWage(int workerLocalId) {
    return attendanceMap[workerLocalId]?.totalAmount ??
        (workers.firstWhereOrNull((w) => w.localId == workerLocalId)?.dailyWage ?? 0);
  }

  Future<void> markPresent(Worker worker) async {
    final existing = attendanceMap[worker.localId];
    final wage = worker.dailyWage;

    if (existing != null) {
      existing.isPresent = true;
      existing.isHalfDay = false;
      existing.wageAmount = wage;
      existing.overtimeAmount = 0;
      existing.totalAmount = wage;
      existing.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      existing.isSync = false;
      await _db.workerAttendanceRepository.save(existing);
    } else {
      final attendance = WorkerAttendance(
        remoteId: IdGenerator.generate(),
        workerLocalId: worker.localId,
        workerRemoteId: worker.remoteId,
        attendanceDate: _getDateOnlyTimestamp(selectedDate.value),
        isPresent: true,
        isHalfDay: false,
        regularHours: 8,
        overtimeHours: 0,
        wageAmount: wage,
        overtimeAmount: 0,
        totalAmount: wage,
        siteLocalId: selectedSite.value,
        siteRemoteId: sites.firstWhereOrNull((s) => s.localId == selectedSite.value)?.remoteId,
        siteName: sites.firstWhereOrNull((s) => s.localId == selectedSite.value)?.name,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
      await _db.workerAttendanceRepository.save(attendance);
    }

    attendanceMap[worker.localId] = existing ?? attendanceMap[worker.localId]!;
    if (attendanceMap[worker.localId] == null) {
      // Reload if new
      await loadAttendance();
    } else {
      _updateStats();
    }
  }

  Future<void> markAbsent(Worker worker) async {
    final existing = attendanceMap[worker.localId];

    if (existing != null) {
      existing.isPresent = false;
      existing.isHalfDay = false;
      existing.wageAmount = 0;
      existing.totalAmount = 0;
      existing.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      existing.isSync = false;
      await _db.workerAttendanceRepository.save(existing);
    } else {
      final attendance = WorkerAttendance(
        remoteId: IdGenerator.generate(),
        workerLocalId: worker.localId,
        workerRemoteId: worker.remoteId,
        attendanceDate: _getDateOnlyTimestamp(selectedDate.value),
        isPresent: false,
        isHalfDay: false,
        wageAmount: 0,
        totalAmount: 0,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
      await _db.workerAttendanceRepository.save(attendance);
    }

    await loadAttendance();
  }

  Future<void> markHalfDay(Worker worker) async {
    final existing = attendanceMap[worker.localId];
    final wage = worker.dailyWage / 2;

    if (existing != null) {
      existing.isPresent = true;
      existing.isHalfDay = true;
      existing.wageAmount = wage;
      existing.totalAmount = wage;
      existing.updatedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      existing.isSync = false;
      await _db.workerAttendanceRepository.save(existing);
    } else {
      final attendance = WorkerAttendance(
        remoteId: IdGenerator.generate(),
        workerLocalId: worker.localId,
        workerRemoteId: worker.remoteId,
        attendanceDate: _getDateOnlyTimestamp(selectedDate.value),
        isPresent: true,
        isHalfDay: true,
        regularHours: 4,
        wageAmount: wage,
        totalAmount: wage,
        siteLocalId: selectedSite.value,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
      await _db.workerAttendanceRepository.save(attendance);
    }

    await loadAttendance();
  }

  int _getDateOnlyTimestamp(DateTime date) {
    return DateTime(date.year, date.month, date.day).toUtc().millisecondsSinceEpoch;
  }

  Future<void> saveAllAttendance() async {
    isSaving.value = true;
    try {
      // All attendance records are saved individually, just show success
      Get.snackbar('Success', 'Attendance saved successfully');
    } finally {
      isSaving.value = false;
    }
  }

  String getWorkerCategory(Worker worker) {
    return WorkerCategory.fromIndex(worker.category).displayName;
  }
}