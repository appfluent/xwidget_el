/// Math Functions
///
library;

import 'dart:math';

import 'parsers.dart';

final _random = Random();

/// Returns the absolute value of [value].
///
/// - Accepts `int`, `double`, or `String`.
/// - Strings are parsed via [parseDouble] before applying `.abs()`.
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] is not a supported type.
///
/// Example:
/// ```dart
/// abs(-5);        // -> 5
/// abs("-3.14");   // -> 3.14
/// ```
num? abs(dynamic value) {
  if (value == null) return null;
  if (value is int) return value.abs();
  if (value is double) return value.abs();
  if (value is String) return parseDouble(value)?.abs();
  throw Exception("Invalid value '$value' for 'abs' function.");
}

/// Returns the smallest integer greater than or equal to [value].
///
/// - Accepts `int`, `double`, or `String`.
/// - Strings are parsed via [parseDouble] before applying `.ceil()`.
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] is not a supported type.
///
/// Example:
/// ```dart
/// ceil(3.2);      // -> 4
/// ceil("7.9");    // -> 8
/// ```
int? ceil(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.ceil();
  if (value is String) return parseDouble(value)?.ceil();
  throw Exception("Invalid value '$value' for 'ceil' function.");
}

/// Returns the largest integer less than or equal to [value].
///
/// - Accepts `int`, `double`, or `String`.
/// - Strings are parsed via [parseDouble] before applying `.floor()`.
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] is not a supported type.
///
/// Example:
/// ```dart
/// floor(3.9);     // -> 3
/// floor("7.1");   // -> 7
/// ```
int? floor(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.floor();
  if (value is String) return parseDouble(value)?.floor();
  throw Exception("Invalid value '$value' for 'floor' function.");
}

/// Generates a non-negative random integer uniformly distributed in the range
/// from 0, inclusive, to [max], exclusive.
///
/// Implementation note: The default implementation supports [max] values
/// between 1 and (1<<32) inclusive.
///
/// Example:
/// ```dart
/// var intValue = Random().nextInt(10); // Value is >= 0 and < 10.
/// intValue = Random().nextInt(100) + 50; // Value is >= 50 and < 150.
/// ```
int randomInt(int max) => _random.nextInt(max);

/// Generates a non-negative random floating point value uniformly distributed
/// in the range from 0.0, inclusive, to 1.0, exclusive.
///
/// Example:
/// ```dart
/// var doubleValue = Random().nextDouble(); // Value is >= 0.0 and < 1.0.
/// doubleValue = Random().nextDouble() * 256; // Value is >= 0.0 and < 256.0.
/// ```
double randomDouble() => _random.nextDouble();

/// Rounds [value] to the nearest integer.
///
/// - Accepts `int`, `double`, or numeric `String`.
/// - If [value] is already an `int`, it is returned unchanged.
/// - If [value] is a `double`, returns the result of `.round()`.
/// - If [value] is a `String`, attempts to parse it as a `double` and then
///   rounds the result.
/// - Returns `null` if [value] is `null`.
/// - Throws [Exception] if [value] is not a supported type.
///
/// Example:
/// ```dart
/// round(3.6);       // -> 4
/// round("7.2");     // -> 7
/// round(5);         // -> 5
/// round(null);      // -> null
/// ```
int? round(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return double.parse(value).round();
  throw Exception("Invalid value '$value' for 'round' function.");
}