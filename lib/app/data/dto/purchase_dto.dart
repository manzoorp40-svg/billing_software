import 'package:super_market/app/data/dto/purchase_item_dto.dart';

import '../models/purchase.dart';

class PurchaseDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String purchaseNumber;
  final int purchaseDate;
  final int? supplierPartyLocalId;
  final String? supplierPartyRemoteId;
  final String? supplierName;
  final String? invoiceNumber;
  final int? invoiceDate;
  final double subtotal;
  final int gstRate;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final double totalGst;
  final double totalAmount;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  // Joined data
  final List<PurchaseItemDto>? items;

  PurchaseDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.items,
  });

  factory PurchaseDto.fromEntity(Purchase entity, {List<PurchaseItemDto>? items}) {
    return PurchaseDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      purchaseNumber: entity.purchaseNumber,
      purchaseDate: entity.purchaseDate,
      supplierPartyLocalId: entity.supplierPartyLocalId,
      supplierPartyRemoteId: entity.supplierPartyRemoteId,
      supplierName: entity.supplierName,
      invoiceNumber: entity.invoiceNumber,
      invoiceDate: entity.invoiceDate,
      subtotal: entity.subtotal,
      gstRate: entity.gstRate,
      cgstAmount: entity.cgstAmount,
      sgstAmount: entity.sgstAmount,
      igstAmount: entity.igstAmount,
      totalGst: entity.totalGst,
      totalAmount: entity.totalAmount,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
      items: items,
    );
  }

  Purchase toEntity() {
    return Purchase(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      purchaseNumber: purchaseNumber,
      purchaseDate: purchaseDate,
      supplierPartyLocalId: supplierPartyLocalId,
      supplierPartyRemoteId: supplierPartyRemoteId,
      supplierName: supplierName,
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      subtotal: subtotal,
      gstRate: gstRate,
      cgstAmount: cgstAmount,
      sgstAmount: sgstAmount,
      igstAmount: igstAmount,
      totalGst: totalGst,
      totalAmount: totalAmount,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  String get totalDisplay => '₹${totalAmount.toStringAsFixed(2)}';
  String get gstDisplay => '${gstRate}% (₹${totalGst.toStringAsFixed(2)})';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'purchaseNumber': purchaseNumber,
      'purchaseDate': purchaseDate,
      'supplierPartyLocalId': supplierPartyLocalId,
      'supplierPartyRemoteId': supplierPartyRemoteId,
      'supplierName': supplierName,
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate,
      'subtotal': subtotal,
      'gstRate': gstRate,
      'cgstAmount': cgstAmount,
      'sgstAmount': sgstAmount,
      'igstAmount': igstAmount,
      'totalGst': totalGst,
      'totalAmount': totalAmount,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory PurchaseDto.fromJson(Map<String, dynamic> json) {
    return PurchaseDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      purchaseNumber: json['purchaseNumber'] ?? '',
      purchaseDate: json['purchaseDate'] ?? 0,
      supplierPartyLocalId: json['supplierPartyLocalId'],
      supplierPartyRemoteId: json['supplierPartyRemoteId'],
      supplierName: json['supplierName'],
      invoiceNumber: json['invoiceNumber'],
      invoiceDate: json['invoiceDate'],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      gstRate: json['gstRate'] ?? 18,
      cgstAmount: (json['cgstAmount'] ?? 0).toDouble(),
      sgstAmount: (json['sgstAmount'] ?? 0).toDouble(),
      igstAmount: (json['igstAmount'] ?? 0).toDouble(),
      totalGst: (json['totalGst'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}