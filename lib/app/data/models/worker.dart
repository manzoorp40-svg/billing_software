import 'package:objectbox/objectbox.dart';

@Entity()
class Worker {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String name;

  String? fatherName;
  String? phone;
  String? alternatePhone;
  String? address;
  String? aadharNumber;

  int category; // 0=skilled, 1=unskilled, 2=supervisor, 3=engineer

  double dailyWage;
  double overtimeRate; // Per hour

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Worker({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.name,
    this.fatherName,
    this.phone,
    this.alternatePhone,
    this.address,
    this.aadharNumber,
    required this.category,
    required this.dailyWage,
    this.overtimeRate = 0,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}