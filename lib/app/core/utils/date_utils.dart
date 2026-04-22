import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  // ============ CONSTANTS ============

  static const String dateFormat = 'dd-MM-yyyy';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'dd-MM-yyyy HH:mm:ss';
  static const String monthYearFormat = 'MMMM yyyy';
  static const String shortMonthFormat = 'MMM yyyy';
  static const String isoFormat = 'yyyy-MM-dd';

  // ============ CONVERSIONS ============

  /// Convert DateTime to Unix timestamp (milliseconds)
  static int toTimestamp(DateTime? date) {
    return date?.toUtc().millisecondsSinceEpoch ?? 0;
  }

  /// Convert Unix timestamp to DateTime
  static DateTime fromTimestamp(int? timestamp) {
    if (timestamp == null || timestamp == 0) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
  }

  /// Convert Unix timestamp to local DateTime
  static DateTime fromTimestampLocal(int? timestamp) {
    if (timestamp == null || timestamp == 0) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
  }

  /// Get current timestamp
  static int now() => DateTime.now().toUtc().millisecondsSinceEpoch;

  /// Get today's date at midnight (local)
  static int todayMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  }

  /// Get start of month timestamp
  static int startOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1).toUtc().millisecondsSinceEpoch;
  }

  /// Get end of month timestamp
  static int endOfMonth([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month + 1, 0, 23, 59, 59).toUtc().millisecondsSinceEpoch;
  }

  /// Get start of year timestamp
  static int startOfYear([int? year]) {
    final y = year ?? DateTime.now().year;
    return DateTime(y, 1, 1).toUtc().millisecondsSinceEpoch;
  }

  /// Get end of year timestamp
  static int endOfYear([int? year]) {
    final y = year ?? DateTime.now().year;
    return DateTime(y, 12, 31, 23, 59, 59).toUtc().millisecondsSinceEpoch;
  }

  // ============ FORMATTING ============

  /// Format timestamp to date string
  static String formatDate(int? timestamp, [String format = dateFormat]) {
    if (timestamp == null || timestamp == 0) return '';
    return DateFormat(format).format(fromTimestampLocal(timestamp));
  }

  /// Format timestamp to datetime string
  static String formatDateTime(int? timestamp, [String format = dateTimeFormat]) {
    if (timestamp == null || timestamp == 0) return '';
    return DateFormat(format).format(fromTimestampLocal(timestamp));
  }

  /// Format timestamp to time string
  static String formatTime(int? timestamp) {
    if (timestamp == null || timestamp == 0) return '';
    return DateFormat(timeFormat).format(fromTimestampLocal(timestamp));
  }

  /// Format as relative date (Today, Yesterday, etc.)
  static String formatRelative(int? timestamp) {
    if (timestamp == null || timestamp == 0) return '';

    final date = fromTimestampLocal(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return formatDate(timestamp);
    }
  }

  /// Format date range
  static String formatDateRange(int? from, int? to) {
    return '${formatDate(from)} - ${formatDate(to)}';
  }

  /// Format month and year
  static String formatMonthYear(int? timestamp, [String format = shortMonthFormat]) {
    if (timestamp == null || timestamp == 0) return '';
    return DateFormat(format).format(fromTimestampLocal(timestamp));
  }

  /// Format for display in lists
  static String formatForList(int? timestamp) {
    if (timestamp == null || timestamp == 0) return '-';
    return formatDate(timestamp);
  }

  // ============ PARSING ============

  /// Parse date string to timestamp
  static int? parseDate(String dateStr, [String format = dateFormat]) {
    if (dateStr.isEmpty) return null;
    try {
      final date = DateFormat(format).parse(dateStr);
      return date.toUtc().millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }

  /// Parse natural date strings (today, yesterday, etc.)
  static int? parseNaturalDate(String dateStr) {
    final lower = dateStr.toLowerCase().trim();
    final now = DateTime.now();

    switch (lower) {
      case 'today':
        return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      case 'yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        return DateTime(yesterday.year, yesterday.month, yesterday.day).millisecondsSinceEpoch;
      case 'tomorrow':
        final tomorrow = now.add(const Duration(days: 1));
        return DateTime(tomorrow.year, tomorrow.month, tomorrow.day).millisecondsSinceEpoch;
      default:
        return parseDate(dateStr);
    }
  }

  // ============ CALCULATIONS ============

  /// Get difference in days between two timestamps
  static int daysBetween(int? from, int? to) {
    if (from == null || to == null) return 0;
    final dateFrom = fromTimestampLocal(from);
    final dateTo = fromTimestampLocal(to);
    return dateTo.difference(dateFrom).inDays;
  }

  /// Get difference in months between two timestamps
  static int monthsBetween(int? from, int? to) {
    if (from == null || to == null) return 0;
    final dateFrom = fromTimestampLocal(from);
    final dateTo = fromTimestampLocal(to);
    return (dateTo.year - dateFrom.year) * 12 + dateTo.month - dateFrom.month;
  }

  /// Check if date is today
  static bool isToday(int? timestamp) {
    if (timestamp == null) return false;
    final date = fromTimestampLocal(timestamp);
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date is in current month
  static bool isCurrentMonth(int? timestamp) {
    if (timestamp == null) return false;
    final date = fromTimestampLocal(timestamp);
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Get week number of the year
  static int weekNumber(int? timestamp) {
    if (timestamp == null) return 0;
    final date = fromTimestampLocal(timestamp);
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  /// Get month name
  static String monthName(int month, [bool short = true]) {
    if (month < 1 || month > 12) return '';
    final names = short
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month - 1];
  }

  /// Get list of months in a year
  static List<Map<String, dynamic>> getMonthsOfYear(int year) {
    return List.generate(12, (i) {
      final month = i + 1;
      return {
        'month': month,
        'name': monthName(month),
        'start': DateTime(year, month, 1).toUtc().millisecondsSinceEpoch,
        'end': DateTime(year, month + 1, 0, 23, 59, 59).toUtc().millisecondsSinceEpoch,
      };
    });
  }
}