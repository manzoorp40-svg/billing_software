import 'package:objectbox/objectbox.dart';

@Entity()
class SiteMaterialAllocation {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  int siteLocalId; // Link to Site
  String siteRemoteId;

  int? materialLocalId; // Link to Material
  String? materialRemoteId;
  String materialName; // Denormalized

  int unitLocalId; // Link to Unit
  String? unitRemoteId;
  String unitSymbol; // Denormalized

  double quantity;
  double rate; // Rate at time of allocation
  double amount;

  int allocationType; // 0=allocated, 1=used, 2=returned

  int allocationDate; // UTC timestamp
  int? usedDate;
  int? returnDate;

  String? referenceNumber; // e.g., challan number
  String? notes;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  SiteMaterialAllocation({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.siteLocalId,
    required this.siteRemoteId,
    this.materialLocalId,
    this.materialRemoteId,
    required this.materialName,
    required this.unitLocalId,
    this.unitRemoteId,
    required this.unitSymbol,
    required this.quantity,
    required this.rate,
    required this.amount,
    this.allocationType = 0,
    required this.allocationDate,
    this.usedDate,
    this.returnDate,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}