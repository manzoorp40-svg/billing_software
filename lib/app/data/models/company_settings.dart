import 'package:objectbox/objectbox.dart';

@Entity()
class CompanySettings {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  String companyName;
  String? ownerName;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? phone;
  String? mobile;
  String? email;
  String? website;

  String? gstin;
  String? pan;
  String? cin;

  String? logoPath;
  String? stampPath;

  String? bankName;
  String? bankAccountNumber;
  String? bankIfsc;
  String? bankBranch;

  int billPrefix; // e.g., "BILL"
  int billStartNumber;
  int purchasePrefix;
  int purchaseStartNumber;
  int workerPaymentPrefix;
  int workerPaymentStartNumber;

  int defaultGstRate;
  String? defaultNotes;

  String? termsAndConditions;
  String? footerMessage;

  int createdAt;
  int updatedAt;
  int? syncedAt;

  CompanySettings({
    this.localId = 0,
    required this.remoteId,
    this.isSync = false,
    required this.companyName,
    this.ownerName,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.phone,
    this.mobile,
    this.email,
    this.website,
    this.gstin,
    this.pan,
    this.cin,
    this.logoPath,
    this.stampPath,
    this.bankName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.bankBranch,
    this.billPrefix = 0,
    this.billStartNumber = 1,
    this.purchasePrefix = 0,
    this.purchaseStartNumber = 1,
    this.workerPaymentPrefix = 0,
    this.workerPaymentStartNumber = 1,
    this.defaultGstRate = 18,
    this.defaultNotes,
    this.termsAndConditions,
    this.footerMessage,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}