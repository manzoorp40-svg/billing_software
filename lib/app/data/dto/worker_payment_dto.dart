import '../../core/constants/enums.dart';
import '../models/worker_payment.dart';

class WorkerPaymentDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String paymentNumber;
  final int paymentDate;
  final int workerLocalId;
  final String workerRemoteId;
  final String workerName;
  final PaymentType paymentType;
  final double amount;
  final double pendingWages;
  final double balanceAfter;
  final int? siteLocalId;
  final String? siteRemoteId;
  final String? siteName;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  WorkerPaymentDto({
    this.localId,
    this.remoteId,
    this.isSync = false,
    required this.paymentNumber,
    required this.paymentDate,
    required this.workerLocalId,
    required this.workerRemoteId,
    required this.workerName,
    this.paymentType = PaymentType.partial,
    required this.amount,
    this.pendingWages = 0,
    this.balanceAfter = 0,
    this.siteLocalId,
    this.siteRemoteId,
    this.siteName,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory WorkerPaymentDto.fromEntity(WorkerPayment entity) {
    return WorkerPaymentDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      paymentNumber: entity.paymentNumber,
      paymentDate: entity.paymentDate,
      workerLocalId: entity.workerLocalId,
      workerRemoteId: entity.workerRemoteId,
      workerName: entity.workerName,
      paymentType: PaymentType.fromIndex(entity.paymentType),
      amount: entity.amount,
      pendingWages: entity.pendingWages,
      balanceAfter: entity.balanceAfter,
      siteLocalId: entity.siteLocalId,
      siteRemoteId: entity.siteRemoteId,
      siteName: entity.siteName,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  WorkerPayment toEntity() {
    return WorkerPayment(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      paymentNumber: paymentNumber,
      paymentDate: paymentDate,
      workerLocalId: workerLocalId,
      workerRemoteId: workerRemoteId,
      workerName: workerName,
      paymentType: paymentType.value,
      amount: amount,
      pendingWages: pendingWages,
      balanceAfter: balanceAfter,
      siteLocalId: siteLocalId,
      siteRemoteId: siteRemoteId,
      siteName: siteName,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  String get amountDisplay => '₹${amount.toStringAsFixed(2)}';
  String get paymentTypeDisplay => paymentType.displayName;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'paymentNumber': paymentNumber,
      'paymentDate': paymentDate,
      'workerLocalId': workerLocalId,
      'workerRemoteId': workerRemoteId,
      'workerName': workerName,
      'paymentType': paymentType.value,
      'amount': amount,
      'pendingWages': pendingWages,
      'balanceAfter': balanceAfter,
      'siteLocalId': siteLocalId,
      'siteRemoteId': siteRemoteId,
      'siteName': siteName,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory WorkerPaymentDto.fromJson(Map<String, dynamic> json) {
    return WorkerPaymentDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      paymentNumber: json['paymentNumber'] ?? '',
      paymentDate: json['paymentDate'] ?? 0,
      workerLocalId: json['workerLocalId'] ?? 0,
      workerRemoteId: json['workerRemoteId'] ?? '',
      workerName: json['workerName'] ?? '',
      paymentType: PaymentType.fromIndex(json['paymentType'] ?? 1),
      amount: (json['amount'] ?? 0).toDouble(),
      pendingWages: (json['pendingWages'] ?? 0).toDouble(),
      balanceAfter: (json['balanceAfter'] ?? 0).toDouble(),
      siteLocalId: json['siteLocalId'],
      siteRemoteId: json['siteRemoteId'],
      siteName: json['siteName'],
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}