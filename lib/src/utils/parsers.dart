/// Parsing Functions
///
/// Parsing functions convert Strings to objects or primitives and
/// should begin with the prefix 'parse' and accept a String? argument.
/// They should not be confused with conversion functions.
library;

import 'dart:ui';

final _parseDurationRegExp = RegExp(r'^(\d+)([a-z]+)$');

/// Parses a hex string into a [Color].
///
/// - Accepts strings with or without `#` or `0x` prefix.
/// - If 6 hex digits are provided, assumes opaque (`FF` alpha).
/// - If 8 hex digits are provided, interprets as ARGB.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [Exception] if the string is not valid.
Color? parseColor(String? value) {
  if (value != null && value.isNotEmpty) {
    var argb = value;
    if (argb.startsWith("#")) {
      argb = argb.substring(1, argb.length);
    } else if (argb.startsWith("0x")) {
      argb = argb.substring(2, argb.length);
    }
    if (argb.length == 6) {
      argb = "FF$argb";
    }
    if (argb.length == 8) {
      final colorInt = int.parse(argb, radix: 16);
      return Color(colorInt);
    }
    throw Exception("Problem parsing Color value: $value");
  }
  return null;
}

/// Parses a string into a [bool].
///
/// - Accepts `"true"` or `"false"` (case‑insensitive).
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [Exception] if the string is not valid.
bool? parseBool(String? value) {
  if (value != null && value.isNotEmpty) {
    switch (value.toLowerCase()) {
      case "true": return true;
      case "false": return false;
      default: throw Exception("Problem parsing bool value: $value");
    }
  }
  return null;
}

/// Parses a string into a [DateTime].
///
/// - Uses [DateTime.parse].
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [FormatException] if the string is not a valid ISO date.
DateTime? parseDateTime(String? value) {
  if (value != null && value.isNotEmpty) {
    return DateTime.parse(value);
  }
  return null;
}

/// Parses a string into a [double].
///
/// - Accepts numeric strings and `"infinity"`.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [FormatException] if the string is not valid.
double? parseDouble(String? value) {
  if (value != null && value.isNotEmpty) {
    if (value == "infinity") return double.infinity;
    return double.parse(value);
  }
  return null;
}

/// Parses a string into a [Duration].
///
/// - Accepts formats like `"5s"`, `"10min"`, `"2hrs"`, `"1day"`.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [Exception] if the string is not valid.
Duration? parseDuration(String? value) {
  if (value != null && value.isNotEmpty) {
    final match = _parseDurationRegExp.firstMatch(value);
    if (match != null) {
      final digits = int.parse(match.group(1)!);
      final unit = match.group(2);
      switch (unit) {
        case "ms": return Duration(milliseconds: digits);
        case "s": return Duration(seconds: digits);
        case "m": return Duration(minutes: digits);
        case "min": return Duration(minutes: digits);
        case "mins": return Duration(minutes: digits);
        case "h": return Duration(hours: digits);
        case "hr": return Duration(hours: digits);
        case "hrs": return Duration(hours: digits);
        case "d": return Duration(days: digits);
        case "day": return Duration(days: digits);
        case "days": return Duration(days: digits);
      }
    }
    throw Exception("Problem parsing Duration value: $value");
  }
  return null;
}

/// Parses a string into an enum constant of type [T].
///
/// - Matches against the `.name` of each enum value.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [Exception] if no match is found.
T? parseEnum<T extends Enum>(List<T> values, String? value) {
  if (value == null || value.isEmpty) return null;
  for (final type in values) {
    if (type.name == value) {
      return type;
    }
  }
  throw Exception("Problem parsing enum '$value'. Valid values are "
      "${values.asNameMap().keys}");
}

/// Parses a string into an [int].
///
/// - Accepts optional [radix] for base conversion.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [FormatException] if the string is not valid.
int? parseInt(String? value, {int? radix}) {
  if (value != null && value.isNotEmpty) {
    return int.parse(value, radix: radix);
  }
  return null;
}

/// Parses a comma‑separated string into a list of strings.
///
/// - Trims whitespace around each element.
/// - Returns `null` if [value] is `null` or empty.
List<String>? parseListOfStrings(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!value.contains(",")) {
    return [value.trim()];
  } else {
    final strings = <String>[];
    final values = value.split(',');
    for (final string in values) {
      strings.add(string.trim());
    }
    return strings;
  }
}

/// Parses a comma‑separated string into a list of doubles.
///
/// - Trims whitespace around each element.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [FormatException] if any element is not a valid double.
List<double>? parseListOfDoubles(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!value.contains(",")) {
    return [double.parse(value.trim())];
  } else {
    final doubles = <double>[];
    final values = value.split(',');
    for (final val in values) {
      doubles.add(double.parse(val.trim()));
    }
    return doubles;
  }
}

/// Parses a comma‑separated string into a list of ints.
///
/// - Trims whitespace around each element.
/// - Returns `null` if [value] is `null` or empty.
/// - Throws [FormatException] if any element is not a valid int.
List<int>? parseListOfInts(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!value.contains(",")) {
    return [int.parse(value.trim())];
  } else {
    final ints = <int>[];
    final values = value.split(',');
    for (final val in values) {
      ints.add(int.parse(val.trim()));
    }
    return ints;
  }
}

//=============================================
// "try" parser functions
//
// They don't throw exceptions if parsing fails.
//==============================================

/// Attempts to parse [value] into a bool.
/// Returns `null` instead of throwing if parsing fails.
bool? tryParseBool(String? value) {
  try {
    return parseBool(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to parse [value] into a DateTime.
/// Returns `null` instead of throwing if parsing fails.
DateTime? tryParseDateTime(String? value) {
  try {
    return parseDateTime(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to parse [value] into a double.
/// Returns `null` instead of throwing if parsing fails.
double? tryParseDouble(String? value) {
  try {
    return parseDouble(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to parse [value] into a Duration.
/// Returns `null` instead of throwing if parsing fails.
Duration? tryParseDuration(String? value) {
  try {
    return parseDuration(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to parse [value] into an enum constant of type [T].
/// Returns `null` instead of throwing if parsing fails.
T? tryParseEnum<T extends Enum>(List<T> values, String? value) {
  try {
    return parseEnum(values, value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

/// Attempts to parse [value] into an int.
/// Returns `null` instead of throwing if parsing fails.
int? tryParseInt(String? value) {
  try {
    return parseInt(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}
