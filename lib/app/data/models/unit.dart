import 'package:objectbox/objectbox.dart';

@Entity()
class Unit {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  @Unique()
  String name; // e.g., "Bags", "Kilograms", "Cubic Feet"

  @Unique()
  String symbol; // e.g., "bag", "kg", "cft", "pcs"

  String? description;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Unit({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.name,
    required this.symbol,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}