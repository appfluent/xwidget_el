/// Conversion Functions
///
/// Conversion functions convert objects/primitives to other objects/primitives
/// and should begin with the prefix 'to' and accept a dynamic argument value.
/// They should not be confused with parsing functions.
library;

import 'dart:ui';

import 'parsers.dart';

const millisDays = 86400000;
const millisHours = 3600000;
const millisMins = 60000;
const millisSecs = 1000;

/// Converts a dynamic [value] to a [bool].
///
/// - Accepts `bool`, `int`, `double`, or `String`.
/// - Integers and doubles are treated as `true` if non‑zero.
/// - Strings are parsed via [parseBool].
/// - If [trueValues] or [falseValues] are provided, membership in those sets
///   determines the result.
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
bool? toBool(dynamic value, [Set<dynamic>? trueValues, Set<dynamic>? falseValues]) {
  if (trueValues != null || falseValues != null) {
    return trueValues?.contains(value) == true && falseValues?.contains(value) == false;
  }
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is double) return value != 0.0;
  if (value is String) return parseBool(value);
  throw Exception("Invalid bool value: $value");
}

/// Converts a dynamic [value] to a [Color].
///
/// - Accepts `int` (ARGB integer) or `String` (parsed via [parseColor]).
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
Color? toColor(dynamic value) {
  if (value == null) return null;
  if (value is int) return Color(value);
  if (value is String) return parseColor(value);
  throw Exception("Invalid Color value: $value");
}

/// Converts a dynamic [value] to a [DateTime].
///
/// - Accepts `DateTime`, `int` (milliseconds since epoch), or `String`
///   (parsed via [parseDateTime]).
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
DateTime? toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) return parseDateTime(value);
  throw Exception(
    "Invalid DateTime: value=$value, "
    "type=${value.runtimeType}",
  );
}

/// Converts a dynamic [value] to an integer representing days.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toDays(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is Duration) return value.inDays;

  dynamic copy = value;
  if (copy is String) copy = parseDateTime(copy);
  if (copy is DateTime) return copy.millisecondsSinceEpoch ~/ 86400000;
  throw Exception('Cannot convert ${value.runtimeType} to int: $value');
}

/// Converts a dynamic [value] to an integer representing days.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
double? toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return parseDouble(value);
  throw Exception('Invalid double value: $value');
}

/// Converts a dynamic [value] to a [Duration].
///
/// - Accepts `Duration` (returned as-is), `String` (parsed via [parseDuration]),
///   or `int` paired with [intUnit].
/// - When [value] is an `int`, [intUnit] selects the time unit. Defaults to
///   milliseconds when omitted or `null`. Accepts:
///   - days: `d`, `day`, `days`
///   - hours: `h`, `hour`, `hours`
///   - minutes: `M`, `min`, `mins`, `minutes`
///   - seconds: `s`, `sec`, `secs`, `seconds`
///   - milliseconds: `ms`, `milli`, `millis`, `milliseconds`
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] is an unsupported type, or an `int` paired
///   with an unrecognized [intUnit].
Duration? toDuration(dynamic value, [String? intUnit]) {
  if (value == null) return null;
  if (value is Duration) return value;
  if (value is String) return parseDuration(value);
  if (value is int) {
    switch (intUnit ?? "ms") {
      case "d":
      case "day":
      case "days":
        return Duration(days: value);
      case "h":
      case "hour":
      case "hours":
        return Duration(hours: value);
      case "M":
      case "min":
      case "mins":
      case "minutes":
        return Duration(minutes: value);
      case "s":
      case "sec":
      case "secs":
      case "seconds":
        return Duration(seconds: value);
      case "ms":
      case "milli":
      case "millis":
      case "milliseconds":
        return Duration(milliseconds: value);
    }
  }
  throw Exception("Invalid duration format: $value");
}

/// Converts a dynamic [value] to an enum constant of type [T].
///
/// - Accepts an enum value of type [T] or a `String` (parsed via [parseEnum]).
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] does not match any enum constant.
T? toEnum<T extends Enum>(dynamic value, List<T> values) {
  if (value == null) return null;
  if (value is T) return value;
  if (value is String) return parseEnum(values, value);
  throw Exception(
    "Enum $T doesn't contain the value '$value'. "
    "Valid values are ${values.asNameMap().keys}",
  );
}

/// Converts a dynamic [value] to an integer representing hours.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toHours(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is Duration) return value.inHours;

  dynamic valueCopy = value;
  if (valueCopy is String) valueCopy = parseDateTime(valueCopy);
  if (valueCopy is DateTime) return valueCopy.millisecondsSinceEpoch ~/ 3600000;
  throw Exception('Cannot convert ${value.runtimeType} to int: $value');
}

/// Converts a dynamic [value] to an [int].
///
/// - Accepts `int`, `double`, `bool`, `String` (parsed via [parseInt]), or [Color].
/// - Booleans map to `1` (true) or `0` (false).
/// - Colors are converted via [Color.toARGB32].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is bool) return value ? 1 : 0;
  if (value is String) return parseInt(value);
  if (value is Color) return value.toARGB32();
  return throw Exception('Invalid int value: $value');
}

/// Converts a dynamic [value] to an integer representing milliseconds.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toMillis(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is Duration) return value.inMilliseconds;

  dynamic valueCopy = value;
  if (valueCopy is String) valueCopy = parseDateTime(valueCopy);
  if (valueCopy is DateTime) return valueCopy.millisecondsSinceEpoch;
  throw Exception('Cannot convert ${value.runtimeType} to int: $value');
}

/// Converts a dynamic [value] to an integer representing minutes.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toMinutes(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is Duration) return value.inMinutes;

  dynamic valueCopy = value;
  if (valueCopy is String) valueCopy = parseDateTime(valueCopy);
  if (valueCopy is DateTime) return valueCopy.millisecondsSinceEpoch ~/ 60000;
  throw Exception('Cannot convert ${value.runtimeType} to int: $value');
}

/// Converts a dynamic [value] to an integer representing seconds.
///
/// - Accepts `int`, `Duration`, `String` (parsed to [DateTime]), or [DateTime].
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if conversion fails.
int? toSeconds(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is Duration) return value.inSeconds;

  dynamic valueCopy = value;
  if (valueCopy is String) valueCopy = parseDateTime(valueCopy);
  if (valueCopy is DateTime) return valueCopy.millisecondsSinceEpoch ~/ 1000;
  throw Exception('Cannot convert ${value.runtimeType} to int: $value');
}

/// Converts a dynamic [value] to a [String].
///
/// - Returns `null` if [value] is `null`.
/// - Colors are formatted as uppercase ARGB hex strings (`0xAARRGGBB`).
/// - Other values use their `toString()` representation.
String? toString(dynamic value) {
  if (value == null) return null;
  if (value is Color) {
    return "0x${value.toARGB32().toRadixString(16).toUpperCase().padLeft(8, "0")}";
  }
  return value.toString();
}

//=================================================
// "try" converter functions
//
// They don't throw exceptions if conversion fails.
//=================================================

/// Attempts to convert [value] to a bool.
/// Returns `null` instead of throwing if conversion fails.
bool? tryToBool(dynamic value) {
  try {
    return toBool(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to a Color.
/// Returns `null` instead of throwing if conversion fails.
Color? tryToColor(dynamic value) {
  try {
    return toColor(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to a DateTime.
/// Returns `null` instead of throwing if conversion fails.
DateTime? tryToDateTime(dynamic value) {
  try {
    return toDateTime(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to days.
/// Returns `null` instead of throwing if conversion fails.
int? tryToDays(dynamic value) {
  try {
    return toDays(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to a double.
/// Returns `null` instead of throwing if conversion fails.
double? tryToDouble(dynamic value) {
  try {
    return toDouble(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to a Duration.
/// Returns `null` instead of throwing if conversion fails.
Duration? tryToDuration(dynamic value, [String? unit]) {
  try {
    return toDuration(value, unit);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to an enum constant of type [T].
/// Returns `null` instead of throwing if conversion fails.
T? tryToEnum<T extends Enum>(List<T> values, dynamic value) {
  try {
    return toEnum(values, value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to hours.
/// Returns `null` instead of throwing if conversion fails.
int? tryToHours(dynamic value) {
  try {
    return toHours(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to an int.
/// Returns `null` instead of throwing if conversion fails.
int? tryToInt(dynamic value) {
  try {
    return toInt(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to milliseconds.
/// Returns `null` instead of throwing if conversion fails.
int? tryToMillis(dynamic value) {
  try {
    return toMillis(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to minutes.
/// Returns `null` instead of throwing if conversion fails.
int? tryToMinutes(dynamic value) {
  try {
    return toMinutes(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to convert [value] to seconds.
/// Returns `null` instead of throwing if conversion fails.
int? tryToSeconds(dynamic value) {
  try {
    return toSeconds(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}
