import 'package:objectbox/objectbox.dart';

@Entity()
class Purchase {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String purchaseNumber; // Auto-generated bill number

  @Index()
  int purchaseDate; // UTC timestamp

  int? supplierPartyLocalId; // Link to Party (supplier)
  String? supplierPartyRemoteId;
  String? supplierName;

  String? invoiceNumber;
  int? invoiceDate;

  double subtotal;
  int gstRate; // Overall GST rate
  double cgstAmount;
  double sgstAmount;
  double igstAmount;
  double totalGst;
  double totalAmount;

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Purchase({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.purchaseNumber,
    required this.purchaseDate,
    this.supplierPartyLocalId,
    this.supplierPartyRemoteId,
    this.supplierName,
    this.invoiceNumber,
    this.invoiceDate,
    required this.subtotal,
    this.gstRate = 18,
    this.cgstAmount = 0,
    this.sgstAmount = 0,
    this.igstAmount = 0,
    this.totalGst = 0,
    required this.totalAmount,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}