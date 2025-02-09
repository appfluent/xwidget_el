/// Parsing Functions
///
/// Parsing functions convert Strings to objects or primitives and
/// should begin with the prefix 'parse' and accept a String? argument.
/// They should not be confused with conversion functions.
library;

import 'dart:ui';

final _parseDurationRegExp = RegExp(r'^(\d+)([a-z]+)$');

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

DateTime? parseDateTime(String? value) {
  if (value != null && value.isNotEmpty) {
    return DateTime.parse(value);
  }
  return null;
}

double? parseDouble(String? value) {
  if (value != null && value.isNotEmpty) {
    if (value == "infinity") return double.infinity;
    return double.parse(value);
  }
  return null;
}

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

int? parseInt(String? value, {int? radix}) {
  if (value != null && value.isNotEmpty) {
    return int.parse(value, radix: radix);
  }
  return null;
}

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

bool? tryParseBool(String? value) {
  try {
    return parseBool(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

DateTime? tryParseDateTime(String? value) {
  try {
    return parseDateTime(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

double? tryParseDouble(String? value) {
  try {
    return parseDouble(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

Duration? tryParseDuration(String? value) {
  try {
    return parseDuration(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

T? tryParseEnum<T extends Enum>(List<T> values, String? value) {
  try {
    return parseEnum(values, value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}

int? tryParseInt(String? value) {
  try {
    return parseInt(value);
  } catch (e) {
    // intentionally ignored
    return null;
  }
}


