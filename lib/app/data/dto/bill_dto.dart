import 'package:super_market/app/data/dto/bill_item_dto.dart';
import 'package:super_market/app/data/models/bill.dart';

import '../../core/constants/enums.dart';

class BillDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String billNumber;
  final int billDate;
  final int? siteLocalId;
  final String? siteRemoteId;
  final String? siteName;
  final int? clientPartyLocalId;
  final String? clientPartyRemoteId;
  final String? clientName;
  final BillStatus status;
  final double subtotal;
  final int gstRate;
  final double cgstAmount;
  final double sgstAmount;
  final double igstAmount;
  final double totalGst;
  final double totalAmount;
  final double? previousBillAmount;
  final double? currentBillAmount;
  final double? grandTotal;
  final int? dueDate;
  final int? paidDate;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  // Joined data
  final List<BillItemDto>? items;

  BillDto({
    this.localId,
    this.remoteId,
    this.isSync = false,
    required this.billNumber,
    required this.billDate,
    this.siteLocalId,
    this.siteRemoteId,
    this.siteName,
    this.clientPartyLocalId,
    this.clientPartyRemoteId,
    this.clientName,
    this.status = BillStatus.draft,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.items,
  });

  factory BillDto.fromEntity(Bill entity, {List<BillItemDto>? items}) {
    return BillDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      billNumber: entity.billNumber,
      billDate: entity.billDate,
      siteLocalId: entity.siteLocalId,
      siteRemoteId: entity.siteRemoteId,
      siteName: entity.siteName,
      clientPartyLocalId: entity.clientPartyLocalId,
      clientPartyRemoteId: entity.clientPartyRemoteId,
      clientName: entity.clientName,
      status: BillStatus.fromIndex(entity.status),
      subtotal: entity.subtotal,
      gstRate: entity.gstRate,
      cgstAmount: entity.cgstAmount,
      sgstAmount: entity.sgstAmount,
      igstAmount: entity.igstAmount,
      totalGst: entity.totalGst,
      totalAmount: entity.totalAmount,
      previousBillAmount: entity.previousBillAmount,
      currentBillAmount: entity.currentBillAmount,
      grandTotal: entity.grandTotal,
      dueDate: entity.dueDate,
      paidDate: entity.paidDate,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
      items: items,
    );
  }

  Bill toEntity() {
    return Bill(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      billNumber: billNumber,
      billDate: billDate,
      siteLocalId: siteLocalId,
      siteRemoteId: siteRemoteId,
      siteName: siteName,
      clientPartyLocalId: clientPartyLocalId,
      clientPartyRemoteId: clientPartyRemoteId,
      clientName: clientName,
      status: status.value,
      subtotal: subtotal,
      gstRate: gstRate,
      cgstAmount: cgstAmount,
      sgstAmount: sgstAmount,
      igstAmount: igstAmount,
      totalGst: totalGst,
      totalAmount: totalAmount,
      previousBillAmount: previousBillAmount,
      currentBillAmount: currentBillAmount,
      grandTotal: grandTotal,
      dueDate: dueDate,
      paidDate: paidDate,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  String get totalDisplay => '₹${totalAmount.toStringAsFixed(2)}';
  String get statusDisplay => status.displayName;
  String get gstDisplay => '$gstRate% (₹${totalGst.toStringAsFixed(2)})';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'billNumber': billNumber,
      'billDate': billDate,
      'siteLocalId': siteLocalId,
      'siteRemoteId': siteRemoteId,
      'siteName': siteName,
      'clientPartyLocalId': clientPartyLocalId,
      'clientPartyRemoteId': clientPartyRemoteId,
      'clientName': clientName,
      'status': status.value,
      'subtotal': subtotal,
      'gstRate': gstRate,
      'cgstAmount': cgstAmount,
      'sgstAmount': sgstAmount,
      'igstAmount': igstAmount,
      'totalGst': totalGst,
      'totalAmount': totalAmount,
      'previousBillAmount': previousBillAmount,
      'currentBillAmount': currentBillAmount,
      'grandTotal': grandTotal,
      'dueDate': dueDate,
      'paidDate': paidDate,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory BillDto.fromJson(Map<String, dynamic> json) {
    return BillDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      billNumber: json['billNumber'] ?? '',
      billDate: json['billDate'] ?? 0,
      siteLocalId: json['siteLocalId'],
      siteRemoteId: json['siteRemoteId'],
      siteName: json['siteName'],
      clientPartyLocalId: json['clientPartyLocalId'],
      clientPartyRemoteId: json['clientPartyRemoteId'],
      clientName: json['clientName'],
      status: BillStatus.fromIndex(json['status'] ?? 0),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      gstRate: json['gstRate'] ?? 18,
      cgstAmount: (json['cgstAmount'] ?? 0).toDouble(),
      sgstAmount: (json['sgstAmount'] ?? 0).toDouble(),
      igstAmount: (json['igstAmount'] ?? 0).toDouble(),
      totalGst: (json['totalGst'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      previousBillAmount: json['previousBillAmount']?.toDouble(),
      currentBillAmount: json['currentBillAmount']?.toDouble(),
      grandTotal: json['grandTotal']?.toDouble(),
      dueDate: json['dueDate'],
      paidDate: json['paidDate'],
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}