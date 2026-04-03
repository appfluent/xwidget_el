import 'package:intl/intl.dart';

import 'converters.dart';

/// Units of time used for duration formatting.
///
/// Each unit has a short [code] and its equivalent in [millis].
enum DurationUnits {
  days("d", 86400000),
  hours("h", 3600000),
  minutes("M", 60000),
  seconds("s", 1000),
  milliseconds("m", 1);

  final String code;
  final int millis;
  const DurationUnits(this.code, this.millis);
}

/// Defines labels for formatting durations.
///
/// Provides human‑readable labels for each [DurationUnits].
class DurationFormat {
  final String days;
  final String hours;
  final String minutes;
  final String seconds;
  final String milliseconds;

  const DurationFormat(this.days, this.hours, this.minutes, this.seconds, this.milliseconds);

  /// Returns the label string corresponding to the given [unit].
  String getLabel(DurationUnits unit) {
    switch (unit) {
      case DurationUnits.days:
        return days;
      case DurationUnits.hours:
        return hours;
      case DurationUnits.minutes:
        return minutes;
      case DurationUnits.seconds:
        return seconds;
      case DurationUnits.milliseconds:
        return milliseconds;
    }
  }
}

/// Default duration format with English labels.
const defaultDurationFormat = DurationFormat(" d", " hr", " min", " sec", " ms");

/// Formats a byte count into a human-readable string with appropriate
/// unit suffix (B, KB, MB, GB, TB).
///
/// The [decimalPlaces] argument controls the number of fractional
/// digits shown. Defaults to 1.
///
/// Examples:
/// ```dart
/// formatBytes(0);              // -> "0 B"
/// formatBytes(512);            // -> "512 B"
/// formatBytes(14200, 1);       // -> "13.9 KB"
/// formatBytes(1048576, 1);     // -> "1.0 MB"
/// formatBytes(1073741824, 2);  // -> "1.00 GB"
/// ```
///
/// ```xml
/// <Text data="${formatBytes(bundleSize, 1)}"/>
/// ```
String formatBytes(dynamic value, [int decimalPlaces = 1]) {
  if (value == null) return '';
  final bytes = value is num ? value.toDouble() : double.parse(value.toString());

  if (bytes <= 0) return '0 B';

  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  int index = 0;
  double size = bytes;

  while (size >= 1024 && index < suffixes.length - 1) {
    size /= 1024;
    index++;
  }

  if (index == 0) {
    return '${size.toInt()} ${suffixes[index]}';
  }
  return '${size.toStringAsFixed(decimalPlaces)} ${suffixes[index]}';
}

/// Formats a number with a compact suffix (K, M, B, T).
///
/// The [decimalPlaces] argument controls the number of fractional
/// digits shown. Defaults to 1. Trailing zeros are removed.
///
/// Examples:
/// ```dart
/// formatCompact(500);          // -> "500"
/// formatCompact(1200, 1);      // -> "1.2K"
/// formatCompact(3400000, 1);   // -> "3.4M"
/// formatCompact(1500000000);   // -> "1.5B"
/// formatCompact(1000, 0);      // -> "1K"
/// ```
///
/// ```xml
/// <Text data="${formatCompact(totalUsers)}"/>
/// ```
String formatCompact(dynamic value, [int decimalPlaces = 1]) {
  if (value == null) return '';
  final number = value is num ? value.toDouble() : double.parse(value.toString());

  if (number.abs() < 1000) {
    return number == number.toInt() ? number.toInt().toString() : number.toString();
  }

  const suffixes = ['', 'K', 'M', 'B', 'T'];
  int index = 0;
  double compact = number.abs();

  while (compact >= 1000 && index < suffixes.length - 1) {
    compact /= 1000;
    index++;
  }

  String formatted = compact.toStringAsFixed(decimalPlaces);

  // Remove trailing zeros after decimal point
  if (formatted.contains('.')) {
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
  }

  final prefix = number < 0 ? '-' : '';
  return '$prefix$formatted${suffixes[index]}';
}

/// Formats a [DateTime] value using the given [format] pattern.
///
/// - Accepts `DateTime`, `int` (milliseconds since epoch), or `String`.
/// - Returns `null` if [value] is `null`.
/// - Uses [intl.DateFormat] for formatting.
String? formatDateTime(String format, dynamic value) {
  if (value == null) return null;
  final dateTime = toDateTime(value);
  return dateTime != null ? DateFormat(format).format(dateTime) : null;
}

/// Formats a [Duration] into a human‑readable string.
///
/// - [precision] determines the smallest unit to include (e.g., `"s"`, `"ms"`).
/// - [format] provides labels; if `null`, outputs colon/dot‑delimited style.
/// - Returns `null` if [value] is `null`.
/// - Handles negative durations by prefixing with `-`.
String? formatDuration(
  Duration? value, [
  String precision = "s",
  DurationFormat? format = defaultDurationFormat,
]) {
  if (value == null) return null;
  String formatted = "";
  int millis = value.inMilliseconds.abs();
  for (final unit in DurationUnits.values) {
    final isLast = unit.code == precision || unit.name == precision;
    final unitCount = millis ~/ unit.millis;
    millis = millis - (unitCount * unit.millis);
    if (format == null) {
      final isMillis = unit == DurationUnits.milliseconds;
      final delimiter = isMillis ? "." : ":";
      if (formatted.isNotEmpty) {
        formatted += delimiter + "$unitCount".padLeft(isMillis ? 3 : 2, "0");
      } else if (isLast) {
        formatted += "0$delimiter${'$unitCount'.padLeft(isMillis ? 3 : 2, '0')}";
      } else if (unitCount > 0) {
        formatted += "$unitCount";
      }
    } else if (unitCount > 0 || isLast) {
      final spacer = formatted.isNotEmpty ? " " : "";
      final label = format.getLabel(unit);
      formatted += "$spacer$unitCount$label";
    }
    if (isLast) break;
  }
  return value.isNegative ? "-$formatted" : formatted;
}

/// Formats a [DateTime] as a human-readable elapsed time string
/// relative to now.
///
/// Returns strings like "just now", "2 minutes ago", "3 hours ago",
/// "5 days ago", "2 weeks ago", "4 months ago", "1 year ago".
///
/// If [value] is in the future, returns strings like "in 5 minutes",
/// "in 3 hours", etc.
///
/// Examples:
/// ```dart
/// // Assuming now is 2026-03-31 14:00:00
/// formatElapsed(DateTime(2026, 3, 31, 13, 58));  // -> "2 minutes ago"
/// formatElapsed(DateTime(2026, 3, 31, 11, 0));   // -> "3 hours ago"
/// formatElapsed(DateTime(2026, 3, 28, 14, 0));   // -> "3 days ago"
/// formatElapsed(DateTime(2026, 3, 17, 14, 0));   // -> "2 weeks ago"
/// formatElapsed(DateTime(2025, 11, 30, 14, 0));  // -> "4 months ago"
/// formatElapsed(DateTime(2025, 3, 31, 14, 0));   // -> "1 year ago"
/// ```
///
/// ```xml
/// <Text data="${formatElapsed(lastSeen)}"/>
/// ```
String formatElapsed(dynamic value) {
  if (value == null) return '';
  final dateTime = value is DateTime ? value : DateTime.parse(value.toString());
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  final isFuture = difference.isNegative;
  final duration = difference.abs();

  final String timeStr;
  if (duration.inSeconds < 60) {
    return isFuture ? 'in a moment' : 'just now';
  } else if (duration.inMinutes < 60) {
    final n = duration.inMinutes;
    timeStr = '$n ${n == 1 ? 'minute' : 'minutes'}';
  } else if (duration.inHours < 24) {
    final n = duration.inHours;
    timeStr = '$n ${n == 1 ? 'hour' : 'hours'}';
  } else if (duration.inDays < 7) {
    final n = duration.inDays;
    timeStr = '$n ${n == 1 ? 'day' : 'days'}';
  } else if (duration.inDays < 30) {
    final n = duration.inDays ~/ 7;
    timeStr = '$n ${n == 1 ? 'week' : 'weeks'}';
  } else if (duration.inDays < 365) {
    final n = duration.inDays ~/ 30;
    timeStr = '$n ${n == 1 ? 'month' : 'months'}';
  } else {
    final n = duration.inDays ~/ 365;
    timeStr = '$n ${n == 1 ? 'year' : 'years'}';
  }

  return isFuture ? 'in $timeStr' : '$timeStr ago';
}

/// Formats a number using an ICU/intl pattern string.
///
/// Supports the full [NumberFormat] pattern syntax including:
/// - `#` = optional digit
/// - `0` = required digit
/// - `,` = grouping separator
/// - `.` = decimal separator
/// - `%` = multiply by 100 and show percent sign
/// - `¤` = currency symbol
///
/// Examples:
/// ```dart
/// formatNumber(24891, '#,##0');       // -> "24,891"
/// formatNumber(3.14159, '#,##0.00');  // -> "3.14"
/// formatNumber(1234567, '#,##0');     // -> "1,234,567"
/// formatNumber(0.85, '#0.#%');        // -> "85%"
/// ```
///
/// ```xml
/// <Text data="${formatNumber(totalRenders, '#,##0')}"/>
/// ```
String formatNumber(dynamic value, String pattern) {
  if (value == null) return '';
  final number = value is num ? value : num.parse(value.toString());
  return NumberFormat(pattern).format(number);
}

/// Formats an integer with an English ordinal suffix
/// (st, nd, rd, th).
///
/// Examples:
/// ```dart
/// formatOrdinal(1);   // -> "1st"
/// formatOrdinal(2);   // -> "2nd"
/// formatOrdinal(3);   // -> "3rd"
/// formatOrdinal(4);   // -> "4th"
/// formatOrdinal(11);  // -> "11th"
/// formatOrdinal(12);  // -> "12th"
/// formatOrdinal(13);  // -> "13th"
/// formatOrdinal(21);  // -> "21st"
/// formatOrdinal(22);  // -> "22nd"
/// formatOrdinal(101); // -> "101st"
/// formatOrdinal(111); // -> "111th"
/// ```
///
/// ```xml
/// <Text data="${formatOrdinal(rank)}"/>
/// ```
String formatOrdinal(dynamic value) {
  if (value == null) return '';
  final number = value is int ? value : int.parse(value.toString());
  final abs = number.abs();
  final lastTwo = abs % 100;
  final lastOne = abs % 10;

  String suffix;
  if (lastTwo >= 11 && lastTwo <= 13) {
    suffix = 'th';
  } else {
    switch (lastOne) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  return '$number$suffix';
}

/// Formats a number as a percentage string.
///
/// Multiplies [value] by 100 and appends '%'. The [decimalPlaces]
/// argument controls the number of fractional digits shown.
///
/// Examples:
/// ```dart
/// formatPercent(0.123, 1);   // -> "12.3%"
/// formatPercent(0.5, 0);     // -> "50%"
/// formatPercent(0.0812, 2);  // -> "8.12%"
/// formatPercent(-0.021, 1);  // -> "-2.1%"
/// ```
///
/// ```xml
/// <Text data="${formatPercent(changeRate, 1)}"/>
/// ```
String formatPercent(dynamic value, [int decimalPlaces = 0]) {
  if (value == null) return '';
  final number = value is num ? value : num.parse(value.toString());
  final percent = number * 100;
  return '${percent.toStringAsFixed(decimalPlaces)}%';
}

/// Formats a count with a singular or plural label.
///
/// When [count] is 1 (or -1), the [singular] form is used.
/// Otherwise, the [plural] form is used. The count is prepended
/// to the label.
///
/// Examples:
/// ```dart
/// formatPlural(0, 'error', 'errors');   // -> "0 errors"
/// formatPlural(1, 'error', 'errors');   // -> "1 error"
/// formatPlural(5, 'error', 'errors');   // -> "5 errors"
/// formatPlural(1, 'child', 'children'); // -> "1 child"
/// ```
///
/// ```xml
/// <Text data="${formatPlural(errorCount, 'error', 'errors')}"/>
/// ```
String formatPlural(dynamic count, String singular, String plural) {
  if (count == null) return '0 $plural';
  final number = count is num ? count : num.parse(count.toString());
  final label = (number.abs() == 1) ? singular : plural;
  final display = number == number.toInt() ? number.toInt() : number;
  return '$display $label';
}
