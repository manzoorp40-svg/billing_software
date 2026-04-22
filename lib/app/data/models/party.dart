import 'package:objectbox/objectbox.dart';

@Entity()
class Party {
  @Id()
  int localId;

  bool isSync;

  @Index()
  @Unique()
  String remoteId;

  @Index()
  String name;

  int partyType; // 0=supplier, 1=client, 2=subcontractor

  String? phone;
  String? alternatePhone;
  String? email;
  String? address;

  @Index()
  String? gstin;

  double balance; // Positive = receivable, Negative = payable
  double openingBalance;

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Party({
    this.localId = 0,
    required this.remoteId,
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
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}