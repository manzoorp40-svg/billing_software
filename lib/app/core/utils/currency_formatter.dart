import 'dart:math';

class CurrencyFormatter {
  CurrencyFormatter._();

  static const String symbol = '₹';
  static const String currency = 'INR';
  static const String decimalSeparator = '.';
  static const String thousandSeparator = ',';

  // ============ FORMATTING ============

  /// Format number as currency with symbol
  static String format(double? amount, {
    int decimals = 2,
    String? symbol,
    bool showSymbol = true,
  }) {
    if (amount == null) return '${showSymbol ? (symbol ?? CurrencyFormatter.symbol) : ''}0.00';

    final formatted = _formatNumber(amount.abs(), decimals);
    final prefix = amount < 0 ? '-' : '';
    final sym = showSymbol ? (symbol ?? CurrencyFormatter.symbol) : '';

    return '$prefix$sym$formatted';
  }

  /// Format without currency symbol
  static String formatPlain(double? amount, {int decimals = 2}) {
    return _formatNumber(amount ?? 0, decimals);
  }

  /// Format for input fields (no symbol, max 2 decimals)
  static String formatInput(double? amount) {
    if (amount == null) return '';
    return amount.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }

  /// Format compact (1K, 1L, 1Cr)
  static String formatCompact(double? amount) {
    if (amount == null) return '$symbol 0';

    final abs = amount.abs();
    final sign = amount < 0 ? '-' : '';

    if (abs >= 10000000) {
      return '$sign$symbol${(abs / 10000000).toStringAsFixed(1)}Cr';
    } else if (abs >= 100000) {
      return '$sign$symbol${(abs / 100000).toStringAsFixed(1)}L';
    } else if (abs >= 1000) {
      return '$sign$symbol${(abs / 1000).toStringAsFixed(1)}K';
    } else {
      return format(amount);
    }
  }

  /// Format with sign (+/-)
  static String formatWithSign(double amount, {int decimals = 2}) {
    final sign = amount >= 0 ? '+' : '';
    return '$sign${format(amount, decimals: decimals)}';
  }

  // ============ PARSING ============

  /// Parse currency string to double
  static double? parse(String? value) {
    if (value == null || value.isEmpty) return null;

    // Remove currency symbol and separators
    var cleaned = value.replaceAll(symbol, '').replaceAll(',', '').trim();

    // Handle negative
    final isNegative = cleaned.startsWith('(') && cleaned.endsWith(')');
    if (isNegative) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Handle sign
    final hasMinus = cleaned.startsWith('-');
    if (hasMinus) {
      cleaned = cleaned.substring(1);
    }

    final result = double.tryParse(cleaned);
    if (result == null) return null;

    return (isNegative || hasMinus) ? -result : result;
  }

  /// Parse with default value
  static double parseWithDefault(String? value, double defaultValue) {
    return parse(value) ?? defaultValue;
  }

  // ============ CALCULATIONS ============

  /// Round to specified decimals
  static double round(double value, [int decimals = 2]) {
    final mod = pow(10, decimals);
    return (value * mod).round() / mod;
  }

  /// Round to nearest rupee
  static double roundToNearest(double value) {
    return value.roundToDouble();
  }

  /// Calculate percentage
  static double percentage(double value, double total, {int decimals = 2}) {
    if (total == 0) return 0;
    return round(value / total * 100, decimals);
  }

  /// Calculate percentage of amount
  static double percentOf(double amount, double percent) {
    return round(amount * percent / 100);
  }

  // ============ INTERNAL ============

  static String _formatNumber(double value, int decimals) {
    // Round to specified decimals
    value = round(value, decimals);

    // Split into integer and decimal parts
    final parts = value.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0];
    final decimalPart = decimals > 0 ? parts[1] : '';

    // Add thousand separators
    final buffer = StringBuffer();
    final length = integerPart.length;

    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(thousandSeparator);
      }
      buffer.write(integerPart[i]);
    }

    if (decimals > 0 && decimalPart.isNotEmpty) {
      // Remove trailing zeros from decimals
      final cleanDecimals = decimalPart.replaceAll(RegExp(r'0+$'), '');
      if (cleanDecimals.isNotEmpty) {
        return '${buffer.toString()}$decimalSeparator$cleanDecimals';
      }
    }

    return buffer.toString();
  }
}