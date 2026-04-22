import '../../core/constants/enums.dart';
import '../models/party.dart';

class PartyDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String name;
  final PartyType partyType;
  final String? phone;
  final String? alternatePhone;
  final String? email;

  final String? address;
  final String? gstin;
  final double balance;
  final double openingBalance;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  PartyDto({
    this.localId,
    this.remoteId,
    this.isSync = false,
    required this.name,
    required this.partyType,
    this.phone,
    this.alternatePhone,
    this.email,
    this.address,
    this.gstin,
    this.balance = 0,
    this.openingBalance = 0,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory PartyDto.fromEntity(Party entity) {
    return PartyDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      name: entity.name,
      partyType: PartyType.fromIndex(entity.partyType),
      phone: entity.phone,
      alternatePhone: entity.alternatePhone,
      email: entity.email,
      address: entity.address,
      gstin: entity.gstin,
      balance: entity.balance,
      openingBalance: entity.openingBalance,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  Party toEntity() {
    return Party(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      name: name,
      partyType: partyType.value,
      phone: phone,
      alternatePhone: alternatePhone,
      email: email,
      address: address,
      gstin: gstin,
      balance: balance,
      openingBalance: openingBalance,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  PartyDto copyWith({
    int? localId,
    String? remoteId,
    bool? isSync,
    String? name,
    PartyType? partyType,
    String? phone,
    String? alternatePhone,
    String? email,
    String? address,
    String? gstin,
    double? balance,
    double? openingBalance,
    String? notes,
    bool? isActive,
  }) {
    return PartyDto(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      isSync: isSync ?? this.isSync,
      name: name ?? this.name,
      partyType: partyType ?? this.partyType,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      balance: balance ?? this.balance,
      openingBalance: openingBalance ?? this.openingBalance,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  String? validate() {
    if (name.trim().isEmpty) return 'Name is required';
    if (name.length > 100) return 'Name must be less than 100 characters';
    if (phone != null && phone!.length > 15) return 'Phone must be less than 15 digits';
    if (gstin != null && gstin!.isNotEmpty) {
      if (gstin!.length != 15) return 'GSTIN must be 15 characters';
      // Basic GSTIN format validation
      final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
      if (!gstRegex.hasMatch(gstin!.toUpperCase())) {
        return 'Invalid GSTIN format';
      }
    }
    return null;
  }

  String get balanceDisplay {
    if (balance > 0) return '₹${balance.toStringAsFixed(2)} (Receivable)';
    if (balance < 0) return '₹${(-balance).toStringAsFixed(2)} (Payable)';
    return '₹0.00';
  }

  String get typeDisplay => partyType.displayName;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'name': name,
      'partyType': partyType.value,
      'phone': phone,
      'alternatePhone': alternatePhone,
      'email': email,
      'address': address,
      'gstin': gstin,
      'balance': balance,
      'openingBalance': openingBalance,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory PartyDto.fromJson(Map<String, dynamic> json) {
    return PartyDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      name: json['name'] ?? '',
      partyType: PartyType.fromIndex(json['partyType'] ?? 0),
      phone: json['phone'],
      alternatePhone: json['alternatePhone'],
      email: json['email'],
      address: json['address'],
      gstin: json['gstin'],
      balance: (json['balance'] ?? 0).toDouble(),
      openingBalance: (json['openingBalance'] ?? 0).toDouble(),
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}