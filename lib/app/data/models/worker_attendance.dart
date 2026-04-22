import 'package:objectbox/objectbox.dart';

@Entity()
class WorkerAttendance {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  int workerLocalId; // Link to Worker
  String workerRemoteId;

  @Index()
  int attendanceDate; // UTC timestamp (date only, time stripped)

  bool isPresent;
  bool isHalfDay;

  double regularHours;
  double overtimeHours;
  double wageAmount;
  double overtimeAmount;
  double totalAmount;

  int? siteLocalId; // Optional: link to site worked at
  String? siteRemoteId;
  String? siteName; // Denormalized

  String? notes;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  WorkerAttendance({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.workerLocalId,
    required this.workerRemoteId,
    required this.attendanceDate,
    required this.isPresent,
    this.isHalfDay = false,
    this.regularHours = 8,
    this.overtimeHours = 0,
    required this.wageAmount,
    this.overtimeAmount = 0,
    required this.totalAmount,
    this.siteLocalId,
    this.siteRemoteId,
    this.siteName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}