import '../models/material.dart';

class MaterialDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String name;
  final String? description;
  final String? hsnCode;
  final String? brand;
  final int unitLocalId;
  final String? unitRemoteId;
  final double rate;
  final double currentStock;
  final double openingStock;
  final double alertQuantity;
  final int gstRate;
  final String? notes;
  final bool isActive;
  final bool trackStock;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  // Helper fields (populated from joined queries)
  final String? unitName;
  final String? unitSymbol;

  MaterialDto({
    this.localId,
    this.remoteId,
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
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.unitName,
    this.unitSymbol,
  });

  factory MaterialDto.fromEntity(Material entity, {String? unitName, String? unitSymbol}) {
    return MaterialDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      name: entity.name,
      description: entity.description,
      hsnCode: entity.hsnCode,
      brand: entity.brand,
      unitLocalId: entity.unitLocalId,
      unitRemoteId: entity.unitRemoteId,
      rate: entity.rate,
      currentStock: entity.currentStock,
      openingStock: entity.openingStock,
      alertQuantity: entity.alertQuantity,
      gstRate: entity.gstRate,
      notes: entity.notes,
      isActive: entity.isActive,
      trackStock: entity.trackStock,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
      unitName: unitName,
      unitSymbol: unitSymbol,
    );
  }

  Material toEntity() {
    return Material(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      name: name,
      description: description,
      hsnCode: hsnCode,
      brand: brand,
      unitLocalId: unitLocalId,
      unitRemoteId: unitRemoteId,
      rate: rate,
      currentStock: currentStock,
      openingStock: openingStock,
      alertQuantity: alertQuantity,
      gstRate: gstRate,
      notes: notes,
      isActive: isActive,
      trackStock: trackStock,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  MaterialDto copyWith({
    int? localId,
    String? remoteId,
    bool? isSync,
    String? name,
    String? description,
    String? hsnCode,
    String? brand,
    int? unitLocalId,
    String? unitRemoteId,
    double? rate,
    double? currentStock,
    double? openingStock,
    double? alertQuantity,
    int? gstRate,
    String? notes,
    bool? isActive,
    bool? trackStock,
    String? unitName,
    String? unitSymbol,
  }) {
    return MaterialDto(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      isSync: isSync ?? this.isSync,
      name: name ?? this.name,
      description: description ?? this.description,
      hsnCode: hsnCode ?? this.hsnCode,
      brand: brand ?? this.brand,
      unitLocalId: unitLocalId ?? this.unitLocalId,
      unitRemoteId: unitRemoteId ?? this.unitRemoteId,
      rate: rate ?? this.rate,
      currentStock: currentStock ?? this.currentStock,
      openingStock: openingStock ?? this.openingStock,
      alertQuantity: alertQuantity ?? this.alertQuantity,
      gstRate: gstRate ?? this.gstRate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      trackStock: trackStock ?? this.trackStock,
      createdAt: createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
      unitName: unitName ?? this.unitName,
      unitSymbol: unitSymbol ?? this.unitSymbol,
    );
  }

  String? validate() {
    if (name.trim().isEmpty) return 'Name is required';
    if (name.length > 100) return 'Name must be less than 100 characters';
    if (rate < 0) return 'Rate cannot be negative';
    if (currentStock < 0) return 'Stock cannot be negative';
    return null;
  }

  bool get isLowStock => trackStock && currentStock <= alertQuantity;

  String get stockDisplay => '${currentStock.toStringAsFixed(2)} $unitSymbol';

  String get rateDisplay => '₹${rate.toStringAsFixed(2)}/$unitSymbol';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'name': name,
      'description': description,
      'hsnCode': hsnCode,
      'brand': brand,
      'unitLocalId': unitLocalId,
      'unitRemoteId': unitRemoteId,
      'rate': rate,
      'currentStock': currentStock,
      'openingStock': openingStock,
      'alertQuantity': alertQuantity,
      'gstRate': gstRate,
      'notes': notes,
      'isActive': isActive,
      'trackStock': trackStock,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory MaterialDto.fromJson(Map<String, dynamic> json) {
    return MaterialDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      name: json['name'] ?? '',
      description: json['description'],
      hsnCode: json['hsnCode'],
      brand: json['brand'],
      unitLocalId: json['unitLocalId'] ?? 0,
      unitRemoteId: json['unitRemoteId'],
      rate: (json['rate'] ?? 0).toDouble(),
      currentStock: (json['currentStock'] ?? 0).toDouble(),
      openingStock: (json['openingStock'] ?? 0).toDouble(),
      alertQuantity: (json['alertQuantity'] ?? 0).toDouble(),
      gstRate: json['gstRate'] ?? 0,
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      trackStock: json['trackStock'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}