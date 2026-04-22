import 'package:objectbox/objectbox.dart';

@Entity()
class Site {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  String name;

  String? description;
  String? address;
  String? city;
  String? state;
  String? pincode;

  int? clientPartyLocalId; // Link to Party (client)
  String? clientPartyRemoteId;
  String? clientName;
  String? clientPhone;

  double? budget;
  double? spentAmount;

  @Index()
  int status; // 0=active, 1=onHold, 2=completed, 3=cancelled

  int? startDate;
  int? endDate;
  int? estimatedCompletionDate;

  String? notes;
  bool isActive;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  Site({
    this.localId = 0,
    required this.remoteId,
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
    this.status = 0,
    this.startDate,
    this.endDate,
    this.estimatedCompletionDate,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}