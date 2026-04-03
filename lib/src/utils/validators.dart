/// Validator Functions
///
/// Validator functions assert that a condition is true or false and return
/// a bool value.
library;

import 'converters.dart';

/// Returns `true` if [value] contains [searchValue].
///
/// - Supports `String`, `List`, and `Set`.
/// - For strings, converts [searchValue] to a string before searching.
/// - Returns `false` if [value] is `null`.
/// - Throws [Exception] if [value] is not a supported type.
bool contains(dynamic value, dynamic searchValue) {
  if (value == null) return false;
  if (value is String) return value.contains(searchValue.toString());
  if (value is List) return value.contains(searchValue);
  if (value is Set) return value.contains(searchValue);
  throw Exception(
    "Invalid type '${value.runtimeType}' for 'contains' "
    "function. Valid types are String, List and Set.",
  );
}

/// Returns `true` if [map] contains the given [searchKey].
///
/// - Returns `false` if [map] is `null`.
bool containsKey(Map? map, dynamic searchKey) {
  return (map != null) ? map.containsKey(searchKey) : false;
}

/// Returns `true` if [map] contains the given [searchValue].
///
/// - Returns `false` if [map] is `null`.
bool containsValue(Map? map, dynamic searchValue) {
  return (map != null) ? map.containsValue(searchValue) : false;
}

/// Returns `true` if [value] ends with [searchValue].
///
/// - Returns `false` if [value] is `null`.
bool endsWith(String? value, String searchValue) {
  return value?.endsWith(searchValue) == true;
}

/// Returns `true` if [value] is `null` or consists only of whitespace.
bool isBlank(String? value) {
  return value == null || value.trim().isEmpty;
}

/// Returns `true` if [value] is empty or `null`.
///
/// - Supports `String`, `List`, `Map`, and `Set`.
/// - Returns `false` for unsupported types.
bool isEmpty(dynamic value) {
  if (value == null) return true;
  if (value is String) return value.isEmpty;
  if (value is List) return value.isEmpty;
  if (value is Map) return value.isEmpty;
  if (value is Set) return value.isEmpty;
  return false;
}

/// Returns `true` if [value] is not blank.
bool isNotBlank(String? value) {
  return !isBlank(value);
}

/// Returns `true` if [value] is not empty.
///
/// - Supports `String`, `List`, `Map`, and `Set`.
bool isNotEmpty(dynamic value) {
  return !isEmpty(value);
}

/// Returns `true` if [value] is `null`.
bool isNull(dynamic value) {
  return value == null;
}

/// Returns `true` if [value] is not `null`.
bool isNotNull(dynamic value) {
  return value != null;
}

/// Returns `true` if [value] evaluates to boolean `true`.
///
/// - Uses [toBool] for conversion.
bool isTrue(dynamic value) {
  return toBool(value) == true;
}

/// Returns `true` if [value] is `null` or evaluates to boolean `true`.
bool isTrueOrNull(dynamic value) {
  return value == null || toBool(value) == true;
}

/// Returns `true` if [value] evaluates to boolean `false`.
///
/// - Uses [toBool] for conversion.
bool isFalse(dynamic value) {
  return toBool(value) == false;
}

/// Returns `true` if [value] is `null` or evaluates to boolean `false`.
bool isFalseOrNull(dynamic value) {
  return value == null || toBool(value) == false;
}

/// Returns `true` if [value] fully matches the given [regExp].
///
/// - Uses [RegExp] to test the entire string.
/// - Returns `false` if [value] is `null`.
/// - Throws [Exception] if [regExp] is invalid.
bool matches(String? value, String regExp) {
  try {
    if (value != null) {
      final regex = RegExp(regExp);
      final matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
    }
    return false;
  } catch (e) {
    throw Exception('Regular expression $regExp is invalid');
  }
}

/// Returns `true` if [value] starts with [searchFor].
///
/// - Returns `false` if [value] is `null`.
bool startsWith(String? value, String searchFor) {
  return value?.startsWith(searchFor) == true;
}
