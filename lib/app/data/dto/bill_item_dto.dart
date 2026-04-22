import '../models/bill.item.dart';

class BillItemDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final int billLocalId;
  final String billRemoteId;
  final String description;
  final String? itemCode;
  final String? unit;
  final double quantity;
  final double rate;
  final double amount;
  final int sortOrder;
  final String? remarks;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  BillItemDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory BillItemDto.fromEntity(BillItem entity) {
    return BillItemDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      billLocalId: entity.billLocalId,
      billRemoteId: entity.billRemoteId,
      description: entity.description,
      itemCode: entity.itemCode,
      unit: entity.unit,
      quantity: entity.quantity,
      rate: entity.rate,
      amount: entity.amount,
      sortOrder: entity.sortOrder,
      remarks: entity.remarks,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  BillItem toEntity() {
    return BillItem(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      billLocalId: billLocalId,
      billRemoteId: billRemoteId,
      description: description,
      itemCode: itemCode,
      unit: unit,
      quantity: quantity,
      rate: rate,
      amount: amount,
      sortOrder: sortOrder,
      remarks: remarks,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

String get amountDisplay => '₹${amount.toStringAsFixed(2)}';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'billLocalId': billLocalId,
      'billRemoteId': billRemoteId,
      'description': description,
      'itemCode': itemCode,
      'unit': unit,
      'quantity': quantity,
      'rate': rate,
      'amount': amount,
      'sortOrder': sortOrder,
      'remarks': remarks,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory BillItemDto.fromJson(Map<String, dynamic> json) {
    return BillItemDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      billLocalId: json['billLocalId'] ?? 0,
      billRemoteId: json['billRemoteId'] ?? '',
      description: json['description'] ?? '',
      itemCode: json['itemCode'],
      unit: json['unit'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      sortOrder: json['sortOrder'] ?? 0,
      remarks: json['remarks'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}