import '../models/purchase_item.dart';

class PurchaseItemDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final int purchaseLocalId;
  final String purchaseRemoteId;
  final int? materialLocalId;
  final String? materialRemoteId;
  final String materialName;
  final double quantity;
  final double rate;
  final double discountPercent;
  final double discountAmount;
  final double taxableAmount;
  final int gstRate;
  final double gstAmount;
  final double amount;
  final int unitLocalId;
  final String? unitRemoteId;
  final String unitSymbol;
  final int sortOrder;
  final String? description;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  PurchaseItemDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory PurchaseItemDto.fromEntity(PurchaseItem entity) {
    return PurchaseItemDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      purchaseLocalId: entity.purchaseLocalId,
      purchaseRemoteId: entity.purchaseRemoteId,
      materialLocalId: entity.materialLocalId,
      materialRemoteId: entity.materialRemoteId,
      materialName: entity.materialName,
      quantity: entity.quantity,
      rate: entity.rate,
      discountPercent: entity.discountPercent,
      discountAmount: entity.discountAmount,
      taxableAmount: entity.taxableAmount,
      gstRate: entity.gstRate,
      gstAmount: entity.gstAmount,
      amount: entity.amount,
      unitLocalId: entity.unitLocalId,
      unitRemoteId: entity.unitRemoteId,
      unitSymbol: entity.unitSymbol,
      sortOrder: entity.sortOrder,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  PurchaseItem toEntity() {
    return PurchaseItem(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      purchaseLocalId: purchaseLocalId,
      purchaseRemoteId: purchaseRemoteId,
      materialLocalId: materialLocalId,
      materialRemoteId: materialRemoteId,
      materialName: materialName,
      quantity: quantity,
      rate: rate,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      taxableAmount: taxableAmount,
      gstRate: gstRate,
      gstAmount: gstAmount,
      amount: amount,
      unitLocalId: unitLocalId,
      unitRemoteId: unitRemoteId,
      unitSymbol: unitSymbol,
      sortOrder: sortOrder,
      description: description,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  // Calculate amounts
  static double calculateTaxableAmount(double qty, double rate, double discountPct) {
    final base = qty * rate;
    return base - (base * discountPct / 100);
  }

  static double calculateGstAmount(double taxable, int gstRate) {
    return taxable * gstRate / 100;
  }

  static double calculateAmount(double taxable, double gst) {
    return taxable + gst;
  }

  String get amountDisplay => '₹${amount.toStringAsFixed(2)}';
  String get qtyDisplay => '${quantity.toStringAsFixed(2)} $unitSymbol';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'purchaseLocalId': purchaseLocalId,
      'purchaseRemoteId': purchaseRemoteId,
      'materialLocalId': materialLocalId,
      'materialRemoteId': materialRemoteId,
      'materialName': materialName,
      'quantity': quantity,
      'rate': rate,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'taxableAmount': taxableAmount,
      'gstRate': gstRate,
      'gstAmount': gstAmount,
      'amount': amount,
      'unitLocalId': unitLocalId,
      'unitRemoteId': unitRemoteId,
      'unitSymbol': unitSymbol,
      'sortOrder': sortOrder,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory PurchaseItemDto.fromJson(Map<String, dynamic> json) {
    return PurchaseItemDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      purchaseLocalId: json['purchaseLocalId'] ?? 0,
      purchaseRemoteId: json['purchaseRemoteId'] ?? '',
      materialLocalId: json['materialLocalId'],
      materialRemoteId: json['materialRemoteId'],
      materialName: json['materialName'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      discountPercent: (json['discountPercent'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      taxableAmount: (json['taxableAmount'] ?? 0).toDouble(),
      gstRate: json['gstRate'] ?? 0,
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      unitLocalId: json['unitLocalId'] ?? 0,
      unitRemoteId: json['unitRemoteId'],
      unitSymbol: json['unitSymbol'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}