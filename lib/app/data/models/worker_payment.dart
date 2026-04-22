import 'package:objectbox/objectbox.dart';

@Entity()
class WorkerPayment {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String paymentNumber;

  @Index()
  int paymentDate; // UTC timestamp

  int workerLocalId; // Link to Worker
  String workerRemoteId;
  String workerName; // Denormalized

  int paymentType; // 0=advance, 1=partial, 2=full

  double amount;
  double pendingWages;
  double balanceAfter;

  int? siteLocalId; // Optional: link to site
  String? siteRemoteId;
  String? siteName; // Denormalized

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  WorkerPayment({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.paymentNumber,
    required this.paymentDate,
    required this.workerLocalId,
    required this.workerRemoteId,
    required this.workerName,
    this.paymentType = 1,
    required this.amount,
    this.pendingWages = 0,
    this.balanceAfter = 0,
    this.siteLocalId,
    this.siteRemoteId,
    this.siteName,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}
