import 'package:objectbox/objectbox.dart';

@Entity()
class Material {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String name;

  String? description;
  String? hsnCode;
  String? brand;

  int unitLocalId; // Link to Unit entity
  String? unitRemoteId;

  double rate; // Rate per unit
  double currentStock;
  double openingStock;
  double alertQuantity;

  int gstRate; // 0, 5, 12, 18, 28

  String? notes;
  bool isActive;
  bool trackStock; // Whether to track stock for this material

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Material({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.name,
    this.description,
    this.hsnCode,
    this.brand,
    required this.unitLocalId,
    this.unitRemoteId,
    required this.rate,
    this.currentStock = 0,
    this.openingStock = 0,
    this.alertQuantity = 0,
    this.gstRate = 0,
    this.notes,
    this.isActive = true,
    this.trackStock = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}