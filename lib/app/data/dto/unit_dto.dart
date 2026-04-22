import '../models/unit.dart';

class UnitDto {
  final int? localId;
  final String? remoteId;
  final bool isSync;
  final String name;
  final String symbol;
  final String? description;
  final int? createdAt;
  final int? updatedAt;
  final int? syncedAt;

  UnitDto({
    this.localId,
    this.remoteId,
    this.isSync = false,
    required this.name,
    required this.symbol,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  // Convert from Entity
  factory UnitDto.fromEntity(Unit entity) {
    return UnitDto(
      localId: entity.localId,
      remoteId: entity.remoteId,
      isSync: entity.isSync,
      name: entity.name,
      symbol: entity.symbol,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  // Convert to Entity
  Unit toEntity() {
    return Unit(
      localId: localId ?? 0,
      remoteId: remoteId ?? '',
      isSync: isSync,
      name: name,
      symbol: symbol,
      description: description,
      createdAt: createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  // Copy with modifications
  UnitDto copyWith({
    int? localId,
    String? remoteId,
    bool? isSync,
    String? name,
    String? symbol,
    String? description,
  }) {
    return UnitDto(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      isSync: isSync ?? this.isSync,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      syncedAt: syncedAt,
    );
  }

  // Validation
  String? validate() {
    if (name.trim().isEmpty) return 'Name is required';
    if (symbol.trim().isEmpty) return 'Symbol is required';
    if (name.length > 100) return 'Name must be less than 100 characters';
    if (symbol.length > 20) return 'Symbol must be less than 20 characters';
    return null;
  }

  // JSON for API sync
  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'isSync': isSync,
      'name': name,
      'symbol': symbol,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  factory UnitDto.fromJson(Map<String, dynamic> json) {
    return UnitDto(
      localId: json['localId'],
      remoteId: json['remoteId'],
      isSync: json['isSync'] ?? false,
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      syncedAt: json['syncedAt'],
    );
  }
}