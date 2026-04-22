import 'package:objectbox/objectbox.dart';

@Entity()
class BillItem {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  int billLocalId; // Link to Bill
  String billRemoteId;

  String description;
  String? itemCode;
  String? unit;

  double quantity;
  double rate;
  double amount;

  int sortOrder;

  String? remarks;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  BillItem({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.billLocalId,
    required this.billRemoteId,
    required this.description,
    this.itemCode,
    this.unit,
    required this.quantity,
    required this.rate,
    required this.amount,
    this.sortOrder = 0,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}