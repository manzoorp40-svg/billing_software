import '../../core/constants/enums.dart';
import '../models/worker.dart';

class WorkerDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String name;
  final String? fatherName;
  final String? phone;
  final String? alternatePhone;
  final String? address;
  final String? aadharNumber;
  final WorkerCategory category;
  final double dailyWage;
  final double overtimeRate;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  WorkerDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory WorkerDto.fromEntity(Worker entity) {
    return WorkerDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      name: entity.name,
      fatherName: entity.fatherName,
      phone: entity.phone,
      alternatePhone: entity.alternatePhone,
      address: entity.address,
      aadharNumber: entity.aadharNumber,
      category: WorkerCategory.fromIndex(entity.category),
      dailyWage: entity.dailyWage,
      overtimeRate: entity.overtimeRate,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  Worker toEntity() {
    return Worker(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      name: name,
      fatherName: fatherName,
      phone: phone,
      alternatePhone: alternatePhone,
      address: address,
      aadharNumber: aadharNumber,
      category: category.value,
      dailyWage: dailyWage,
      overtimeRate: overtimeRate,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  WorkerDto copyWith({
    int? localId,
    String? remoteId,
    bool? isSync,
    String? name,
    String? fatherName,
    String? phone,
    String? alternatePhone,
    String? address,
    String? aadharNumber,
    WorkerCategory? category,
    double? dailyWage,
    double? overtimeRate,
    String? notes,
    bool? isActive,
  }) {
    return WorkerDto(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      isSync: isSync ?? this.isSync,
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      address: address ?? this.address,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      category: category ?? this.category,
      dailyWage: dailyWage ?? this.dailyWage,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

String? validate() {
  if (name.trim().isEmpty) return 'Name is required';
  if (dailyWage <= 0) return 'Daily wage must be greater than 0';
  return null;
}

String get wageDisplay => '₹${dailyWage.toStringAsFixed(2)}/day';
String get categoryDisplay => category.displayName;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'name': name,
      'fatherName': fatherName,
      'phone': phone,
      'alternatePhone': alternatePhone,
      'address': address,
      'aadharNumber': aadharNumber,
      'category': category.value,
      'dailyWage': dailyWage,
      'overtimeRate': overtimeRate,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory WorkerDto.fromJson(Map<String, dynamic> json) {
    return WorkerDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      name: json['name'] ?? '',
      fatherName: json['fatherName'],
      phone: json['phone'],
      alternatePhone: json['alternatePhone'],
      address: json['address'],
      aadharNumber: json['aadharNumber'],
      category: WorkerCategory.fromIndex(json['category'] ?? 0),
      dailyWage: (json['dailyWage'] ?? 0).toDouble(),
      overtimeRate: (json['overtimeRate'] ?? 0).toDouble(),
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}