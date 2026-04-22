import 'package:objectbox/objectbox.dart';

@Entity()
class PurchaseItem {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  int purchaseLocalId; // Link to Purchase
  String purchaseRemoteId;

  int? materialLocalId; // Link to Material
  String? materialRemoteId;
  String materialName; // Denormalized for offline use

  double quantity;
  double rate;
  double discountPercent;
  double discountAmount;
  double taxableAmount;
  int gstRate;
  double gstAmount;
  double amount; // Final amount including GST

  int unitLocalId; // Link to Unit
  String? unitRemoteId;
  String unitSymbol; // Denormalized

  int sortOrder;

  String? description;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  PurchaseItem({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.purchaseLocalId,
    required this.purchaseRemoteId,
    this.materialLocalId,
    this.materialRemoteId,
    required this.materialName,
    required this.quantity,
    required this.rate,
    this.discountPercent = 0,
    this.discountAmount = 0,
    required this.taxableAmount,
    this.gstRate = 0,
    this.gstAmount = 0,
    required this.amount,
    required this.unitLocalId,
    this.unitRemoteId,
    required this.unitSymbol,
    this.sortOrder = 0,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}