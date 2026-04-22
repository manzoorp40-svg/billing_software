import 'package:objectbox/objectbox.dart';

@Entity()
class Bill {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String billNumber; // Auto-generated bill number

  @Index()
  int billDate; // UTC timestamp

  int? siteLocalId; // Link to Site
  String? siteRemoteId;
  String? siteName; // Denormalized

  int? clientPartyLocalId; // Link to Party (client)
  String? clientPartyRemoteId;
  String? clientName;

  int status; // 0=draft, 1=submitted, 2=approved, 3=paid, 4=rejected

  double subtotal;
  int gstRate;
  double cgstAmount;
  double sgstAmount;
  double igstAmount;
  double totalGst;
  double totalAmount;

  double? previousBillAmount; // Cumulative of previous bills
  double? currentBillAmount;
  double? grandTotal;

  int? dueDate;
  int? paidDate;

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Bill({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.billNumber,
    required this.billDate,
    this.siteLocalId,
    this.siteRemoteId,
    this.siteName,
    this.clientPartyLocalId,
    this.clientPartyRemoteId,
    this.clientName,
    this.status = 0,
    required this.subtotal,
    this.gstRate = 18,
    this.cgstAmount = 0,
    this.sgstAmount = 0,
    this.igstAmount = 0,
    this.totalGst = 0,
    required this.totalAmount,
    this.previousBillAmount,
    this.currentBillAmount,
    this.grandTotal,
    this.dueDate,
    this.paidDate,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}