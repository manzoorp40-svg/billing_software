class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Construction Billing';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'construction_billing';

  // ID Generation
  static const int remoteIdLength = 24; // 12 bytes = 24 hex chars

  // Date/Time
  static const String dateFormat = 'dd-MM-yyyy';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'dd-MM-yyyy HH:mm:ss';

  // Pagination
  static const int defaultPageSize = 50;
  static const int maxPageSize = 500;

  // Window
  static const double minWindowWidth = 1024;
  static const double minWindowHeight = 768;
  static const double defaultWindowWidth = 1280;
  static const double defaultWindowHeight = 800;

  // Print
  static const int dotMatrixWidth = 80; // characters
  static const int a4Width = 210; // mm
  static const int a4Height = 297; // mm

  // Validation
  static const int maxNameLength = 100;
  static const int maxAddressLength = 500;
  static const int maxPhoneLength = 15;
  static const int maxGstinLength = 15;
}
