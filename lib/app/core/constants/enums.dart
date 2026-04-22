enum PartyType {
  supplier,
  client,
  subcontractor;

  String get displayName {
    switch (this) {
      case PartyType.supplier:
        return 'Supplier';
      case PartyType.client:
        return 'Client';
      case PartyType.subcontractor:
        return 'Subcontractor';
    }
  }

  int get value => index;

  static PartyType fromIndex(int index) {
    return PartyType.values[index];
  }

  static PartyType fromString(String value) {
    return PartyType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => PartyType.supplier,
    );
  }
}

enum SiteStatus {
  active,
  onHold,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case SiteStatus.active:
        return 'Active';
      case SiteStatus.onHold:
        return 'On Hold';
      case SiteStatus.completed:
        return 'Completed';
      case SiteStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get value => index;

  static SiteStatus fromIndex(int index) {
    return SiteStatus.values[index];
  }

  static SiteStatus fromString(String value) {
    return SiteStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => SiteStatus.active,
    );
  }
}

enum WorkerCategory {
  skilled,
  unskilled,
  supervisor,
  engineer;

  String get displayName {
    switch (this) {
      case WorkerCategory.skilled:
        return 'Skilled';
      case WorkerCategory.unskilled:
        return 'Unskilled';
      case WorkerCategory.supervisor:
        return 'Supervisor';
      case WorkerCategory.engineer:
        return 'Engineer';
    }
  }

  int get value => index;

  static WorkerCategory fromIndex(int index) {
    return WorkerCategory.values[index];
  }

  static WorkerCategory fromString(String value) {
    return WorkerCategory.values.firstWhere(
          (e) => e.name == value,
      orElse: () => WorkerCategory.unskilled,
    );
  }
}

enum PaymentType {
  advance,
  partial,
  full;

  String get displayName {
    switch (this) {
      case PaymentType.advance:
        return 'Advance';
      case PaymentType.partial:
        return 'Partial';
      case PaymentType.full:
        return 'Full & Final';
    }
  }

  int get value => index;

  static PaymentType fromIndex(int index) {
    return PaymentType.values[index];
  }

  static PaymentType fromString(String value) {
    return PaymentType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => PaymentType.partial,
    );
  }
}

enum BillStatus {
  draft,
  submitted,
  approved,
  paid,
  rejected;

  String get displayName {
    switch (this) {
      case BillStatus.draft:
        return 'Draft';
      case BillStatus.submitted:
        return 'Submitted';
      case BillStatus.approved:
        return 'Approved';
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.rejected:
        return 'Rejected';
    }
  }

  int get value => index;

  static BillStatus fromIndex(int index) {
    return BillStatus.values[index];
  }

  static BillStatus fromString(String value) {
    return BillStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => BillStatus.draft,
    );
  }
}

enum AllocationType {
  allocated,
  used,
  returned;

  String get displayName {
    switch (this) {
      case AllocationType.allocated:
        return 'Allocated';
      case AllocationType.used:
        return 'Used';
      case AllocationType.returned:
        return 'Returned';
    }
  }

  int get value => index;

  static AllocationType fromIndex(int index) {
    return AllocationType.values[index];
  }

  static AllocationType fromString(String value) {
    return AllocationType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => AllocationType.allocated,
    );
  }
}

enum TransactionType {
  debit,
  credit;

  String get displayName {
    switch (this) {
      case TransactionType.debit:
        return 'Debit';
      case TransactionType.credit:
        return 'Credit';
    }
  }

  int get value => index;

  static TransactionType fromIndex(int index) {
    return TransactionType.values[index];
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TransactionType.debit,
    );
  }
}

enum GstRate {
  none(0, 'No GST'),
  rate5(5, '5%'),
  rate12(12, '12%'),
  rate18(18, '18%'),
  rate28(28, '28%');

  final int rate;
  final String displayName;

  const GstRate(this.rate, this.displayName);

  int get value => rate;

  double get decimal => rate / 100;

  static GstRate fromRate(int rate) {
    return GstRate.values.firstWhere(
          (e) => e.rate == rate,
      orElse: () => GstRate.none,
    );
  }
}