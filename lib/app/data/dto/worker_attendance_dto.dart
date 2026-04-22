import '../models/worker_attendance.dart';

class WorkerAttendanceDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final int workerLocalId;
  final String workerRemoteId;
  final int attendanceDate;
  final bool isPresent;
  final bool isHalfDay;
  final double regularHours;
  final double overtimeHours;
  final double wageAmount;
  final double overtimeAmount;
  final double totalAmount;
  final int? siteLocalId;
  final String? siteRemoteId;
  final String? siteName;
  final String? notes;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  // Joined data
  final String? workerName;
  final String? workerCategory;

  WorkerAttendanceDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.workerName,
    this.workerCategory,
  });

  factory WorkerAttendanceDto.fromEntity(WorkerAttendance entity, {String? workerName}) {
    return WorkerAttendanceDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      workerLocalId: entity.workerLocalId,
      workerRemoteId: entity.workerRemoteId,
      attendanceDate: entity.attendanceDate,
      isPresent: entity.isPresent,
      isHalfDay: entity.isHalfDay,
      regularHours: entity.regularHours,
      overtimeHours: entity.overtimeHours,
      wageAmount: entity.wageAmount,
      overtimeAmount: entity.overtimeAmount,
      totalAmount: entity.totalAmount,
      siteLocalId: entity.siteLocalId,
      siteRemoteId: entity.siteRemoteId,
      siteName: entity.siteName,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
      workerName: workerName ?? entity.workerRemoteId,
    );
  }

  WorkerAttendance toEntity() {
    return WorkerAttendance(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      workerLocalId: workerLocalId,
      workerRemoteId: workerRemoteId,
      attendanceDate: attendanceDate,
      isPresent: isPresent,
      isHalfDay: isHalfDay,
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      wageAmount: wageAmount,
      overtimeAmount: overtimeAmount,
      totalAmount: totalAmount,
      siteLocalId: siteLocalId,
      siteRemoteId: siteRemoteId,
      siteName: siteName,
      notes: notes,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  String get wageDisplay => '₹${wageAmount.toStringAsFixed(2)}';
  String get totalDisplay => '₹${totalAmount.toStringAsFixed(2)}';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'workerLocalId': workerLocalId,
      'workerRemoteId': workerRemoteId,
      'attendanceDate': attendanceDate,
      'isPresent': isPresent,
      'isHalfDay': isHalfDay,
      'regularHours': regularHours,
      'overtimeHours': overtimeHours,
      'wageAmount': wageAmount,
      'overtimeAmount': overtimeAmount,
      'totalAmount': totalAmount,
      'siteLocalId': siteLocalId,
      'siteRemoteId': siteRemoteId,
      'siteName': siteName,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory WorkerAttendanceDto.fromJson(Map<String, dynamic> json) {
    return WorkerAttendanceDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      workerLocalId: json['workerLocalId'] ?? 0,
      workerRemoteId: json['workerRemoteId'] ?? '',
      attendanceDate: json['attendanceDate'] ?? 0,
      isPresent: json['isPresent'] ?? false,
      isHalfDay: json['isHalfDay'] ?? false,
      regularHours: (json['regularHours'] ?? 8).toDouble(),
      overtimeHours: (json['overtimeHours'] ?? 0).toDouble(),
      wageAmount: (json['wageAmount'] ?? 0).toDouble(),
      overtimeAmount: (json['overtimeAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      siteLocalId: json['siteLocalId'],
      siteRemoteId: json['siteRemoteId'],
      siteName: json['siteName'],
      notes: json['notes'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}