import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/parser.dart';
import 'package:xwidget_el/src/utils/converters.dart';

void main() {
  final parser = ELParser();

  // ==================================
  // toBool tests
  // ==================================

  test("Assert toBool with bool true", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert toBool with bool false", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert toBool with non-zero int returns true", () {
    final deps = Dependencies({"value": 1});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert toBool with zero int returns false", () {
    final deps = Dependencies({"value": 0});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert toBool with non-zero double returns true", () {
    final deps = Dependencies({"value": 3.14});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert toBool with zero double returns false", () {
    final deps = Dependencies({"value": 0.0});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert toBool with string 'true'", () {
    final deps = Dependencies({"value": "true"});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert toBool with string 'false'", () {
    final deps = Dependencies({"value": "false"});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert toBool with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert toBool with trueValues set", () {
    expect(toBool("yes", {"yes", "on"}, {"no", "off"}), true);
  });

  test("Assert toBool with falseValues set", () {
    expect(toBool("no", {"yes", "on"}, {"no", "off"}), false);
  });

  // ==================================
  // tryToBool tests
  // ==================================

  test("Assert tryToBool with valid value", () {
    final deps = Dependencies({"value": "true"});
    final result = parser.parse("tryToBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert tryToBool with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToBool(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toColor tests
  // ==================================

  test("Assert toColor with hex string", () {
    final deps = Dependencies({"value": "#FF0000"});
    final result = parser.parse("toColor(value)");
    final color = result.value.evaluate(deps) as Color;
    expect(color, isNotNull);
  });

  test("Assert toColor with int", () {
    expect(toColor(0xFFFF0000), isA<Color>());
  });

  test("Assert toColor with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toColor(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToColor tests
  // ==================================

  test("Assert tryToColor with valid value", () {
    final deps = Dependencies({"value": "#00FF00"});
    final result = parser.parse("tryToColor(value)");
    expect(result.value.evaluate(deps), isA<Color>());
  });

  test("Assert tryToColor with invalid value returns null", () {
    final deps = Dependencies({"value": "not_a_color"});
    final result = parser.parse("tryToColor(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toDateTime tests
  // ==================================

  test("Assert toDateTime with DateTime passthrough", () {
    final now = DateTime(2026, 4, 1, 12, 0);
    final deps = Dependencies({"value": now});
    final result = parser.parse("toDateTime(value)");
    expect(result.value.evaluate(deps), now);
  });

  test("Assert toDateTime with int millis", () {
    final millis = DateTime(2026, 4, 1).millisecondsSinceEpoch;
    final deps = Dependencies({"value": millis});
    final result = parser.parse("toDateTime(value)");
    final dt = result.value.evaluate(deps) as DateTime;
    expect(dt.year, 2026);
    expect(dt.month, 4);
    expect(dt.day, 1);
  });

  test("Assert toDateTime with ISO string", () {
    final deps = Dependencies({"value": "2026-04-01T12:00:00"});
    final result = parser.parse("toDateTime(value)");
    final dt = result.value.evaluate(deps) as DateTime;
    expect(dt.year, 2026);
    expect(dt.month, 4);
    expect(dt.day, 1);
  });

  test("Assert toDateTime with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toDateTime(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToDateTime tests
  // ==================================

  test("Assert tryToDateTime with valid value", () {
    final deps = Dependencies({"value": "2026-04-01"});
    final result = parser.parse("tryToDateTime(value)");
    expect(result.value.evaluate(deps), isA<DateTime>());
  });

  test("Assert tryToDateTime with invalid value returns null", () {
    final deps = Dependencies({"value": "not_a_date"});
    final result = parser.parse("tryToDateTime(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toDouble tests
  // ==================================

  test("Assert toDouble with double passthrough", () {
    final deps = Dependencies({"value": 3.14});
    final result = parser.parse("toDouble(value)");
    expect(result.value.evaluate(deps), 3.14);
  });

  test("Assert toDouble with int", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("toDouble(value)");
    expect(result.value.evaluate(deps), 42.0);
  });

  test("Assert toDouble with string", () {
    final deps = Dependencies({"value": "3.14"});
    final result = parser.parse("toDouble(value)");
    expect(result.value.evaluate(deps), 3.14);
  });

  test("Assert toDouble with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toDouble(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToDouble tests
  // ==================================

  test("Assert tryToDouble with valid value", () {
    final deps = Dependencies({"value": "3.14"});
    final result = parser.parse("tryToDouble(value)");
    expect(result.value.evaluate(deps), 3.14);
  });

  test("Assert tryToDouble with invalid value returns null", () {
    final deps = Dependencies({"value": "abc"});
    final result = parser.parse("tryToDouble(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toInt tests
  // ==================================

  test("Assert toInt with int passthrough", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert toInt with double truncates", () {
    final deps = Dependencies({"value": 3.9});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert toInt with bool true returns 1", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 1);
  });

  test("Assert toInt with bool false returns 0", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 0);
  });

  test("Assert toInt with string", () {
    final deps = Dependencies({"value": "42"});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert toInt with Color", () {
    final color = const Color(0xFFFF0000);
    expect(toInt(color), 0xFFFF0000);
  });

  test("Assert toInt with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToInt tests
  // ==================================

  test("Assert tryToInt with valid value", () {
    final deps = Dependencies({"value": "42"});
    final result = parser.parse("tryToInt(value)");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert tryToInt with invalid value returns null", () {
    final deps = Dependencies({"value": "abc"});
    final result = parser.parse("tryToInt(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toString tests
  // ==================================

  test("Assert toString with int", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("toString(value)");
    expect(result.value.evaluate(deps), "42");
  });

  test("Assert toString with double", () {
    final deps = Dependencies({"value": 3.14});
    final result = parser.parse("toString(value)");
    expect(result.value.evaluate(deps), "3.14");
  });

  test("Assert toString with bool", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("toString(value)");
    expect(result.value.evaluate(deps), "true");
  });

  test("Assert toString with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toString(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert toString with Color returns hex", () {
    final color = const Color(0xFFFF0000);
    expect(toString(color), "0xFFFF0000");
  });

  // ==================================
  // toDays tests
  // ==================================

  test("Assert toDays with int passthrough", () {
    final deps = Dependencies({"value": 7});
    final result = parser.parse("toDays(value)");
    expect(result.value.evaluate(deps), 7);
  });

  test("Assert toDays with Duration", () {
    final deps = Dependencies({"value": const Duration(days: 3)});
    final result = parser.parse("toDays(value)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert toDays with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toDays(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToDays tests
  // ==================================

  test("Assert tryToDays with valid value", () {
    final deps = Dependencies({"value": const Duration(days: 5)});
    final result = parser.parse("tryToDays(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert tryToDays with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToDays(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toHours tests
  // ==================================

  test("Assert toHours with int passthrough", () {
    final deps = Dependencies({"value": 24});
    final result = parser.parse("toHours(value)");
    expect(result.value.evaluate(deps), 24);
  });

  test("Assert toHours with Duration", () {
    final deps = Dependencies({"value": const Duration(hours: 5)});
    final result = parser.parse("toHours(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert toHours with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toHours(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToHours tests
  // ==================================

  test("Assert tryToHours with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToHours(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toMinutes tests
  // ==================================

  test("Assert toMinutes with int passthrough", () {
    final deps = Dependencies({"value": 60});
    final result = parser.parse("toMinutes(value)");
    expect(result.value.evaluate(deps), 60);
  });

  test("Assert toMinutes with Duration", () {
    final deps = Dependencies({"value": const Duration(minutes: 30)});
    final result = parser.parse("toMinutes(value)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert toMinutes with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toMinutes(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToMinutes tests
  // ==================================

  test("Assert tryToMinutes with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToMinutes(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toSeconds tests
  // ==================================

  test("Assert toSeconds with int passthrough", () {
    final deps = Dependencies({"value": 120});
    final result = parser.parse("toSeconds(value)");
    expect(result.value.evaluate(deps), 120);
  });

  test("Assert toSeconds with Duration", () {
    final deps = Dependencies({"value": const Duration(seconds: 45)});
    final result = parser.parse("toSeconds(value)");
    expect(result.value.evaluate(deps), 45);
  });

  test("Assert toSeconds with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toSeconds(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToSeconds tests
  // ==================================

  test("Assert tryToSeconds with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToSeconds(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toMillis tests
  // ==================================

  test("Assert toMillis with int passthrough", () {
    final deps = Dependencies({"value": 5000});
    final result = parser.parse("toMillis(value)");
    expect(result.value.evaluate(deps), 5000);
  });

  test("Assert toMillis with Duration", () {
    final deps = Dependencies({"value": const Duration(milliseconds: 1500)});
    final result = parser.parse("toMillis(value)");
    expect(result.value.evaluate(deps), 1500);
  });

  test("Assert toMillis with DateTime", () {
    final dt = DateTime(2026, 1, 1);
    final deps = Dependencies({"value": dt});
    final result = parser.parse("toMillis(value)");
    expect(result.value.evaluate(deps), dt.millisecondsSinceEpoch);
  });

  test("Assert toMillis with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toMillis(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // tryToMillis tests
  // ==================================

  test("Assert tryToMillis with invalid value returns null", () {
    final deps = Dependencies({"value": <int>[]});
    final result = parser.parse("tryToMillis(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // toDuration tests (direct — optional param not available via EL)
  // ==================================

  test("Assert toDuration with Duration passthrough", () {
    final d = const Duration(hours: 2);
    expect(toDuration(d), d);
  });

  test("Assert toDuration with int defaults to milliseconds", () {
    expect(toDuration(5000), const Duration(milliseconds: 5000));
  });

  test("Assert toDuration with int and unit 'days'", () {
    expect(toDuration(3, "days"), const Duration(days: 3));
  });

  test("Assert toDuration with int and unit 'd'", () {
    expect(toDuration(3, "d"), const Duration(days: 3));
  });

  test("Assert toDuration with int and unit 'hours'", () {
    expect(toDuration(5, "hours"), const Duration(hours: 5));
  });

  test("Assert toDuration with int and unit 'h'", () {
    expect(toDuration(5, "h"), const Duration(hours: 5));
  });

  test("Assert toDuration with int and unit 'minutes'", () {
    expect(toDuration(30, "minutes"), const Duration(minutes: 30));
  });

  test("Assert toDuration with int and unit 'M'", () {
    expect(toDuration(30, "M"), const Duration(minutes: 30));
  });

  test("Assert toDuration with int and unit 'seconds'", () {
    expect(toDuration(45, "seconds"), const Duration(seconds: 45));
  });

  test("Assert toDuration with int and unit 's'", () {
    expect(toDuration(45, "s"), const Duration(seconds: 45));
  });

  test("Assert toDuration with null returns null", () {
    expect(toDuration(null), null);
  });

  test("Assert toDuration with invalid type throws", () {
    expect(() => toDuration(3.14), throwsException);
  });

  // ==================================
  // tryToDuration tests
  // ==================================

  test("Assert tryToDuration with valid value", () {
    expect(tryToDuration(5000), const Duration(milliseconds: 5000));
  });

  test("Assert tryToDuration with invalid value returns null", () {
    expect(tryToDuration(3.14), null);
  });
}
