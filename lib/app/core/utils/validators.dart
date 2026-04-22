class Validators {
  Validators._();

  // ============ REQUIRED FIELDS ============

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? requiredNumber(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  static String? requiredInt(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName must be a whole number';
    }
    return null;
  }

  // ============ LENGTH VALIDATORS ============

  static String? minLength(String? value, int min, [String fieldName = 'This field']) {
    if (value != null && value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, [String fieldName = 'This field']) {
    if (value != null && value.length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  static String? lengthRange(String? value, int min, int max, [String fieldName = 'This field']) {
    if (value == null) return null;
    if (value.length < min || value.length > max) {
      return '$fieldName must be between $min and $max characters';
    }
    return null;
  }

  // ============ NUMBER VALIDATORS ============

  static String? positiveNumber(String? value, [String fieldName = 'Amount']) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }

  static String? nonZero(String? value, [String fieldName = 'Amount']) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number == 0) {
      return '$fieldName cannot be zero';
    }
    return null;
  }

  static String? range(String? value, double min, double max, [String fieldName = 'Value']) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  // ============ PHONE VALIDATOR ============

  static String? phone(String? value, [String fieldName = 'Phone']) {
    if (value == null || value.isEmpty) return null;

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Check length (10 digits for India)
    if (cleaned.length < 10) {
      return '$fieldName must be at least 10 digits';
    }
    if (cleaned.length > 15) {
      return '$fieldName must be at most 15 digits';
    }

    // Check if all digits
    if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(cleaned)) {
      return '$fieldName contains invalid characters';
    }

    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceAll(RegExp(r'[\s\-\+]'), '');

    // Indian mobile: 10 digits starting with 6-9
    if (cleaned.length == 10 && RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleaned)) {
      return null;
    }

    // With country code
    if (cleaned.length == 12 && cleaned.startsWith('91') && RegExp(r'^91[6-9][0-9]{9}$').hasMatch(cleaned)) {
      return null;
    }

    return 'Enter a valid 10-digit mobile number';
  }

  // ============ EMAIL VALIDATOR ============

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // ============ GSTIN VALIDATOR ============

  static String? gstin(String? value) {
    if (value == null || value.isEmpty) return null;

    // Format: 2 digits + 10 chars (alphanumeric) + 1 char (alphanumeric) + 1 char [A-Z0-9] + Z + 1 char [A-Z0-9]
    final gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );

    final upper = value.toUpperCase();

    if (upper.length != 15) {
      return 'GSTIN must be 15 characters';
    }

    if (!gstRegex.hasMatch(upper)) {
      return 'Invalid GSTIN format';
    }

    // Check PAN validation (first 10 chars)
    final pan = upper.substring(2, 12);
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    if (!panRegex.hasMatch(pan)) {
      return 'Invalid PAN in GSTIN';
    }

    return null;
  }

  // ============ PAN VALIDATOR ============

  static String? pan(String? value) {
    if (value == null || value.isEmpty) return null;

    final upper = value.toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

    if (upper.length != 10) {
      return 'PAN must be 10 characters';
    }

    if (!panRegex.hasMatch(upper)) {
      return 'Invalid PAN format (e.g., ABCDE1234F)';
    }

    return null;
  }

  // ============ AADHAR VALIDATOR ============

  static String? aadhar(String? value) {
    if (value == null || value.isEmpty) return null;

    // Remove spaces
    final cleaned = value.replaceAll(RegExp(r'\s'), '');

    // Aadhar is 12 digits
    if (cleaned.length != 12) {
      return 'Aadhar must be 12 digits';
    }

    if (!RegExp(r'^[0-9]{12}$').hasMatch(cleaned)) {
      return 'Aadhar must contain only digits';
    }

    // Basic checksum validation (Verhoeff algorithm would be more accurate)
    return null;
  }

  // ============ IFSC CODE VALIDATOR ============

  static String? ifsc(String? value) {
    if (value == null || value.isEmpty) return null;

    final upper = value.toUpperCase();
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

    if (upper.length != 11) {
      return 'IFSC must be 11 characters';
    }

    if (!ifscRegex.hasMatch(upper)) {
      return 'Invalid IFSC format (e.g., SBIN0001234)';
    }

    return null;
  }

  // ============ BANK ACCOUNT VALIDATOR ============

  static String? bankAccount(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceAll(RegExp(r'\s'), '');

    // Most Indian bank accounts are 9-18 digits
    if (cleaned.length < 9 || cleaned.length > 18) {
      return 'Account number must be 9-18 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Account number must contain only digits';
    }

    return null;
  }

  // ============ PINCODE VALIDATOR ============

  static String? pincode(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'PIN code must be 6 digits';
    }

    return null;
  }

  // ============ COMBINED VALIDATORS ============

  /// Name field: required, min 2 chars
  static String? name(String? value) {
    return required(value, 'Name') ??
        minLength(value, 2, 'Name') ??
        maxLength(value, 100, 'Name');
  }

  /// Address field: optional but max length
  static String? address(String? value) {
    return maxLength(value, 500, 'Address');
  }

  /// Description/Notes: optional but max length
  static String? notes(String? value) {
    return maxLength(value, 1000, 'Notes');
  }

  /// Invoice/Bill number: alphanumeric with some special chars
  static String? billNumber(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!RegExp(r'^[A-Za-z0-9\-\/]+$').hasMatch(value)) {
      return 'Bill number can only contain letters, numbers, - and /';
    }

    return maxLength(value, 50, 'Bill number');
  }

  // ============ UTILITY ============

  /// Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }
}