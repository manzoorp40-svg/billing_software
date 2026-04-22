import '../../core/constants/enums.dart';
import '../models/site.dart';

class SiteDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String name;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final int? clientPartyLocalId;
  final String? clientPartyRemoteId;
  final String? clientName;
  final String? clientPhone;
  final double? budget;
  final double? spentAmount;
  final SiteStatus status;
  final int? startDate;
  final int? endDate;
  final int? estimatedCompletionDate;
  final String? notes;
  final bool isActive;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  SiteDto({
    this.localId,
    this.remoteId,
    this.isSync = false,
    required this.name,
    this.description,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.clientPartyLocalId,
    this.clientPartyRemoteId,
    this.clientName,
    this.clientPhone,
    this.budget,
    this.spentAmount = 0,
    this.status = SiteStatus.active,
    this.startDate,
    this.endDate,
    this.estimatedCompletionDate,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory SiteDto.fromEntity(Site entity) {
    return SiteDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      pincode: entity.pincode,
      clientPartyLocalId: entity.clientPartyLocalId,
      clientPartyRemoteId: entity.clientPartyRemoteId,
      clientName: entity.clientName,
      clientPhone: entity.clientPhone,
      budget: entity.budget,
      spentAmount: entity.spentAmount,
      status: SiteStatus.fromIndex(entity.status),
      startDate: entity.startDate,
      endDate: entity.endDate,
      estimatedCompletionDate: entity.estimatedCompletionDate,
      notes: entity.notes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  Site toEntity() {
    return Site(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      name: name,
      description: description,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      clientPartyLocalId: clientPartyLocalId,
      clientPartyRemoteId: clientPartyRemoteId,
      clientName: clientName,
      clientPhone: clientPhone,
      budget: budget,
      spentAmount: spentAmount,
      status: status.value,
      startDate: startDate,
      endDate: endDate,
      estimatedCompletionDate: estimatedCompletionDate,
      notes: notes,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  SiteDto copyWith({
    int? localId,
    String? remoteId,
    bool? isSync,
    String? name,
    String? description,
    String? address,
    String? city,
    String? state,
    String? pincode,
    int? clientPartyLocalId,
    String? clientPartyRemoteId,
    String? clientName,
    String? clientPhone,
    double? budget,
    double? spentAmount,
    SiteStatus? status,
    int? startDate,
    int? endDate,
    int? estimatedCompletionDate,
    String? notes,
    bool? isActive,
  }) {
    return SiteDto(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      isSync: isSync ?? this.isSync,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      clientPartyLocalId: clientPartyLocalId ?? this.clientPartyLocalId,
      clientPartyRemoteId: clientPartyRemoteId ?? this.clientPartyRemoteId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      budget: budget ?? this.budget,
      spentAmount: spentAmount ?? this.spentAmount,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      estimatedCompletionDate: estimatedCompletionDate ?? this.estimatedCompletionDate,
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
    if (budget != null && budget! < 0) return 'Budget cannot be negative';
    return null;
  }

  double get remainingBudget => (budget ?? 0) - (spentAmount ?? 0);

  double get utilizationPercent {
    if (budget == null || budget == 0) return 0;
    return ((spentAmount ?? 0) / budget! * 100);
  }

  String get budgetDisplay {
    if (budget == null) return 'N/A';
    return '₹${budget!.toStringAsFixed(2)}';
  }

  String get statusDisplay => status.displayName;

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'clientPartyLocalId': clientPartyLocalId,
      'clientPartyRemoteId': clientPartyRemoteId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'budget': budget,
      'spentAmount': spentAmount,
      'status': status.value,
      'startDate': startDate,
      'endDate': endDate,
      'estimatedCompletionDate': estimatedCompletionDate,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory SiteDto.fromJson(Map<String, dynamic> json) {
    return SiteDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      clientPartyLocalId: json['clientPartyLocalId'],
      clientPartyRemoteId: json['clientPartyRemoteId'],
      clientName: json['clientName'],
      clientPhone: json['clientPhone'],
      budget: json['budget']?.toDouble(),
      spentAmount: json['spentAmount']?.toDouble(),
      status: SiteStatus.fromIndex(json['status'] ?? 0),
      startDate: json['startDate'],
      endDate: json['endDate'],
      estimatedCompletionDate: json['estimatedCompletionDate'],
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}