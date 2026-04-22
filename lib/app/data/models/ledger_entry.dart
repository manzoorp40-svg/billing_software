import 'package:objectbox/objectbox.dart';

@Entity()
class LedgerEntry {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  int partyLocalId; // Link to Party
  String partyRemoteId;

  @Index()
  int entryDate; // UTC timestamp

  String? referenceType; // purchase, payment, bill, receipt
  int? referenceLocalId;
  String? referenceRemoteId;
  String? referenceNumber;

  int transactionType; // 0=debit (payment made), 1=credit (amount received)

  double debitAmount;
  double creditAmount;
  double runningBalance;

  String? description;
  String? notes;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  LedgerEntry({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.partyLocalId,
    required this.partyRemoteId,
    required this.entryDate,
    this.referenceType,
    this.referenceLocalId,
    this.referenceRemoteId,
    this.referenceNumber,
    required this.transactionType,
    this.debitAmount = 0,
    this.creditAmount = 0,
    required this.runningBalance,
    this.description,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}