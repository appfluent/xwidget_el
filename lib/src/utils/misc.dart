/// Miscellaneous Functions
///
library;

import 'package:intl/intl.dart';

import 'converters.dart';
import 'extensions.dart';

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

  const DurationFormat(
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
    this.milliseconds
  );

  /// Returns the label string corresponding to the given [unit].
  String getLabel(DurationUnits unit) {
    switch (unit) {
      case DurationUnits.days: return days;
      case DurationUnits.hours: return hours;
      case DurationUnits.minutes: return minutes;
      case DurationUnits.seconds: return seconds;
      case DurationUnits.milliseconds: return milliseconds;
    }
  }
}

/// Default duration format with English labels.
const defaultDurationFormat = DurationFormat(" d"," hr"," min"," sec"," ms");

/// Performs a deep equality comparison between [obj1] and [obj2].
///
/// - Supports `Map`, `List`, `Set`, and primitive types.
/// - Recursively compares nested collections.
/// - Returns `true` if structures and values are equal, otherwise `false`.
bool deepEquals(dynamic obj1, dynamic obj2) {
  if (identical(obj1, obj2)) return true;
  if (obj1.runtimeType != obj2.runtimeType) return false;
  if (obj1 is Map && obj2 is Map) {
    // compare maps
    if (obj1.length != obj2.length) return false;
    for (final key in obj1.keys) {
      if (!obj2.containsKey(key)) return false;
      final value1 = obj1[key];
      final value2 = obj2[key];
      if (!deepEquals(value1, value2)) return false;
    }
    return true;
  } else if (obj1 is List && obj2 is List) {
    // compare lists
    if (obj1.length != obj2.length) return false;
    for (int i = 0; i < obj1.length; i++) {
      if (!deepEquals(obj1[i], obj2[i])) return false;
    }
    return true;
  } else if (obj1 is Set && obj2 is Set) {
    // compare sets
    if (obj1.length != obj2.length) return false;
    for (var element in obj1) {
      if (!obj2.contains(element)) return false;
    }
    return true;
  } else {
    // compare all other objects
    return obj1 == obj2;
  }
}

/// Computes a deep hash code for [value].
///
/// - Supports `Map`, `List`, `Set`, and primitive types.
/// - Recursively combines hash codes of nested structures.
/// - Useful for consistent hashing of complex objects.
int deepHashCode(dynamic value) {
  if (value is Map) {
    // Compute hash code for maps
    int hash = 0;
    for (var entry in value.entries) {
      int keyHash = entry.key.hashCode;
      int valueHash = deepHashCode(entry.value);

      // Combine hash codes of the key and value
      hash = hash ^ (keyHash * 31 + valueHash);
    }
    return hash;
  } else if (value is List) {
    // Compute hash code for lists
    int hash = 0;
    for (var item in value) {
      hash = hash ^ deepHashCode(item);
    }
    return hash;
  } else if (value is Set) {
    // Compute hash code for sets
    int hash = 0;
    for (var item in value) {
      hash = hash ^ deepHashCode(item);
    }
    return hash;
  } else {
    // Compute hash code for other values
    return value.hashCode;
  }
}

/// Returns the absolute difference between two [DateTime]s.
///
/// Always returns a non‑negative [Duration].
Duration diffDateTime(DateTime left, DateTime right) {
  final diff = left.difference(right);
  return (diff < const Duration(microseconds: 0)) ? (-diff) : diff;
}

/// Returns the first element of [value].
///
/// - Supports `List`, `Map`, and `Set`.
/// - For maps, returns the first entry.
/// - Throws [Exception] if [value] is not a supported type.
dynamic first(dynamic value) {
  if (value is List) return value.first;
  if (value is Map) return value.first();
  if (value is Set) return value.first;
  throw Exception("Function 'first' is invalid for type "
      "'${value.runtimeType}'. Valid types are List, Map, and Set.");
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
    DurationFormat? format = defaultDurationFormat
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
      final delimiter= isMillis ? "." : ":";
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

/// Returns the last element of [value].
///
/// - Supports `List`, `Map`, and `Set`.
/// - For maps, returns the last entry.
/// - Throws [Exception] if [value] is not a supported type.
dynamic last(dynamic value) {
  if (value is List) return value.last;
  if (value is Map) return value.last();
  if (value is Set) return value.last;
  throw Exception("Function 'last' is invalid for type "
      "'${value.runtimeType}'. Valid types are List, Map, and Set.");
}

/// Returns the length of [value].
///
/// - Supports `String`, `List`, `Map`, and `Set`.
/// - Throws [Exception] if [value] is not a supported type.
int length(dynamic value) {
  if (value is String) return value.length;
  if (value is List) return value.length;
  if (value is Map) return value.length;
  if (value is Set) return value.length;
  throw Exception("Function 'length' is invalid for type "
      "'${value.runtimeType}'. Valid types are String, List, Map, and Set.");
}

/// Compares two maps [a] and [b] for shallow equality.
///
/// - Returns `true` if both maps have the same keys and values.
/// - Does not perform deep comparison of nested structures.
bool mapsEqual(Map a, Map b) {
  if (a.length != b.length) {
    return false;
  }
  for (var key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) {
      return false;
    }
  }
  return true;
}

/// Replaces all substrings in [value] that match [regExp] with [replacement].
///
/// - Returns `null` if [value] is `null`.
String? replaceAll(String? value, String regExp, String replacement) {
  if (value == null) return null;
  final regex = RegExp(regExp);
  return value.replaceAll(regex, replacement);
}

/// Replaces the first substring in [value] that matches [regExp] with [replacement].
///
/// - Starts searching at [startIndex].
/// - Returns `null` if [value] is `null`.
String? replaceFirst(String? value, String regExp, String replacement, [int startIndex = 0]) {
  if (value == null) return null;
  final regex = RegExp(regExp);
  return value.replaceFirst(regex, replacement, startIndex);
}

/// Returns the [Type] of generic parameter [T].
Type typeOf<T>() {
  return T;
}

/// Returns a substring of [value] from [start] to [end].
///
/// - If [end] is `-1` or greater than the string length, uses the full length.
/// - Returns `null` if [value] is `null`.
String? substring(String? value, int start, [int end = -1]) {
  if (value == null) return null;
  final maxEnd = value.length;
  return value.substring(start, end > 0 && end <= maxEnd ? end : maxEnd);
}

/// Returns the non‑nullable form of a [Type].
///
/// - Removes a trailing `?` from the type’s string representation.
String nonNullType(Type type) {
  final typeString = type.toString();
  return typeString.endsWith("?")
      ? typeString.substring(0, typeString.length - 1)
      : typeString;
}

/// Returns the current UTC [DateTime].
///
/// Equivalent to:
/// ```dart
/// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: true)
/// ```
DateTime now() => DateTime.now();

/// Returns this DateTime value in the UTC time zone.
///
/// Returns [this] if it is already in UTC.
/// Otherwise this method is equivalent to:
///
/// ```dart template:expression
/// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: true)
/// ```
DateTime nowUtc() => DateTime.now().toUtc();