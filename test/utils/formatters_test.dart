import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/parser.dart';

void main() {
  final parser = ELParser();
  final dependencies = Dependencies({
    "intValue": 24891,
    "doubleValue": 3.14159,
    "largeNumber": 1234567,
    "smallDecimal": 0.5,
    "negativeValue": -42,
    "zeroValue": 0,
    "bytesSmall": 512,
    "bytesKB": 14200,
    "bytesMB": 1048576,
    "bytesGB": 1073741824,
    "percentDecimal": 0.123,
    "percentHalf": 0.5,
    "percentSmall": 0.0812,
    "percentNegative": -0.021,
    "pastDate": DateTime(2026, 3, 31, 11, 0),
    "futureDate": DateTime(2099, 12, 31, 23, 59),
  });

  // ==================================
  // formatNumber tests
  // ==================================

  test("Assert formatNumber with grouping separator", () {
    final result = parser.parse("formatNumber(intValue, '#,##0')");
    expect(result.value.evaluate(dependencies), "24,891");
  });

  test("Assert formatNumber with fixed decimals", () {
    final result = parser.parse("formatNumber(doubleValue, '#,##0.00')");
    expect(result.value.evaluate(dependencies), "3.14");
  });

  test("Assert formatNumber with large number", () {
    final result = parser.parse("formatNumber(largeNumber, '#,##0')");
    expect(result.value.evaluate(dependencies), "1,234,567");
  });

  test("Assert formatNumber with literal value", () {
    final result = parser.parse("formatNumber(1000, '#,##0')");
    expect(result.value.evaluate(dependencies), "1,000");
  });

  test("Assert formatNumber with null returns empty string", () {
    final result = parser.parse("formatNumber(nullValue, '#,##0')");
    expect(result.value.evaluate(dependencies), "");
  });

  // ==================================
  // formatPercent tests
  // ==================================

  test("Assert formatPercent with 1 decimal place", () {
    final result = parser.parse("formatPercent(percentDecimal, 1)");
    expect(result.value.evaluate(dependencies), "12.3%");
  });

  test("Assert formatPercent with 0 decimal places", () {
    final result = parser.parse("formatPercent(percentHalf, 0)");
    expect(result.value.evaluate(dependencies), "50%");
  });

  test("Assert formatPercent with 2 decimal places", () {
    final result = parser.parse("formatPercent(percentSmall, 2)");
    expect(result.value.evaluate(dependencies), "8.12%");
  });

  test("Assert formatPercent with negative value", () {
    final result = parser.parse("formatPercent(percentNegative, 1)");
    expect(result.value.evaluate(dependencies), "-2.1%");
  });

  test("Assert formatPercent with null returns empty string", () {
    final result = parser.parse("formatPercent(nullValue, 1)");
    expect(result.value.evaluate(dependencies), "");
  });

  // ==================================
  // formatBytes tests
  // ==================================

  test("Assert formatBytes with zero", () {
    final result = parser.parse("formatBytes(zeroValue)");
    expect(result.value.evaluate(dependencies), "0 B");
  });

  test("Assert formatBytes with bytes", () {
    final result = parser.parse("formatBytes(bytesSmall)");
    expect(result.value.evaluate(dependencies), "512 B");
  });

  test("Assert formatBytes with kilobytes", () {
    final result = parser.parse("formatBytes(bytesKB, 1)");
    expect(result.value.evaluate(dependencies), "13.9 KB");
  });

  test("Assert formatBytes with megabytes", () {
    final result = parser.parse("formatBytes(bytesMB, 1)");
    expect(result.value.evaluate(dependencies), "1.0 MB");
  });

  test("Assert formatBytes with gigabytes and 2 decimals", () {
    final result = parser.parse("formatBytes(bytesGB, 2)");
    expect(result.value.evaluate(dependencies), "1.00 GB");
  });

  test("Assert formatBytes with null returns empty string", () {
    final result = parser.parse("formatBytes(nullValue)");
    expect(result.value.evaluate(dependencies), "");
  });

  // ==================================
  // formatCompact tests
  // ==================================

  test("Assert formatCompact with value under 1000", () {
    final result = parser.parse("formatCompact(bytesSmall)");
    expect(result.value.evaluate(dependencies), "512");
  });

  test("Assert formatCompact with thousands", () {
    final deps = Dependencies({"value": 1200});
    final result = parser.parse("formatCompact(value, 1)");
    expect(result.value.evaluate(deps), "1.2K");
  });

  test("Assert formatCompact with millions", () {
    final deps = Dependencies({"value": 3400000});
    final result = parser.parse("formatCompact(value, 1)");
    expect(result.value.evaluate(deps), "3.4M");
  });

  test("Assert formatCompact with billions", () {
    final deps = Dependencies({"value": 1500000000});
    final result = parser.parse("formatCompact(value)");
    expect(result.value.evaluate(deps), "1.5B");
  });

  test("Assert formatCompact with 0 decimal places", () {
    final deps = Dependencies({"value": 1000});
    final result = parser.parse("formatCompact(value, 0)");
    expect(result.value.evaluate(deps), "1K");
  });

  test("Assert formatCompact removes trailing zeros", () {
    final deps = Dependencies({"value": 2000000});
    final result = parser.parse("formatCompact(value, 1)");
    expect(result.value.evaluate(deps), "2M");
  });

  test("Assert formatCompact with negative value", () {
    final deps = Dependencies({"value": -5600});
    final result = parser.parse("formatCompact(value, 1)");
    expect(result.value.evaluate(deps), "-5.6K");
  });

  test("Assert formatCompact with null returns empty string", () {
    final result = parser.parse("formatCompact(nullValue)");
    expect(result.value.evaluate(dependencies), "");
  });

  // ==================================
  // formatOrdinal tests
  // ==================================

  test("Assert formatOrdinal with 1st", () {
    final deps = Dependencies({"value": 1});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "1st");
  });

  test("Assert formatOrdinal with 2nd", () {
    final deps = Dependencies({"value": 2});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "2nd");
  });

  test("Assert formatOrdinal with 3rd", () {
    final deps = Dependencies({"value": 3});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "3rd");
  });

  test("Assert formatOrdinal with 4th", () {
    final deps = Dependencies({"value": 4});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "4th");
  });

  test("Assert formatOrdinal with 11th (teen exception)", () {
    final deps = Dependencies({"value": 11});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "11th");
  });

  test("Assert formatOrdinal with 12th (teen exception)", () {
    final deps = Dependencies({"value": 12});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "12th");
  });

  test("Assert formatOrdinal with 13th (teen exception)", () {
    final deps = Dependencies({"value": 13});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "13th");
  });

  test("Assert formatOrdinal with 21st", () {
    final deps = Dependencies({"value": 21});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "21st");
  });

  test("Assert formatOrdinal with 22nd", () {
    final deps = Dependencies({"value": 22});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "22nd");
  });

  test("Assert formatOrdinal with 101st", () {
    final deps = Dependencies({"value": 101});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "101st");
  });

  test("Assert formatOrdinal with 111th (teen exception at hundreds)", () {
    final deps = Dependencies({"value": 111});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "111th");
  });

  test("Assert formatOrdinal with null returns empty string", () {
    final result = parser.parse("formatOrdinal(nullValue)");
    expect(result.value.evaluate(dependencies), "");
  });

  // ==================================
  // formatPlural tests
  // ==================================

  test("Assert formatPlural with 0 uses plural", () {
    final deps = Dependencies({"count": 0});
    final result = parser.parse("formatPlural(count, 'error', 'errors')");
    expect(result.value.evaluate(deps), "0 errors");
  });

  test("Assert formatPlural with 1 uses singular", () {
    final deps = Dependencies({"count": 1});
    final result = parser.parse("formatPlural(count, 'error', 'errors')");
    expect(result.value.evaluate(deps), "1 error");
  });

  test("Assert formatPlural with 5 uses plural", () {
    final deps = Dependencies({"count": 5});
    final result = parser.parse("formatPlural(count, 'error', 'errors')");
    expect(result.value.evaluate(deps), "5 errors");
  });

  test("Assert formatPlural with -1 uses singular", () {
    final deps = Dependencies({"count": -1});
    final result = parser.parse("formatPlural(count, 'error', 'errors')");
    expect(result.value.evaluate(deps), "-1 error");
  });

  test("Assert formatPlural with irregular plural", () {
    final deps = Dependencies({"count": 3});
    final result = parser.parse("formatPlural(count, 'child', 'children')");
    expect(result.value.evaluate(deps), "3 children");
  });

  test("Assert formatPlural with null uses 0 plural", () {
    final result = parser.parse("formatPlural(nullValue, 'error', 'errors')");
    expect(result.value.evaluate(dependencies), "0 errors");
  });

  // ==================================
  // formatElapsed tests
  // ==================================

  test("Assert formatElapsed with just now", () {
    final deps = Dependencies({"recentDate": DateTime.now().subtract(const Duration(seconds: 30))});
    final result = parser.parse("formatElapsed(recentDate)");
    expect(result.value.evaluate(deps), "just now");
  });

  test("Assert formatElapsed with minutes ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(minutes: 5))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "5 minutes ago");
  });

  test("Assert formatElapsed with 1 minute ago uses singular", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(minutes: 1))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "1 minute ago");
  });

  test("Assert formatElapsed with hours ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(hours: 3))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "3 hours ago");
  });

  test("Assert formatElapsed with 1 hour ago uses singular", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(hours: 1))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "1 hour ago");
  });

  test("Assert formatElapsed with days ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(days: 3))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "3 days ago");
  });

  test("Assert formatElapsed with weeks ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(days: 14))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "2 weeks ago");
  });

  test("Assert formatElapsed with months ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(days: 120))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "4 months ago");
  });

  test("Assert formatElapsed with years ago", () {
    final deps = Dependencies({"pastDate": DateTime.now().subtract(const Duration(days: 400))});
    final result = parser.parse("formatElapsed(pastDate)");
    expect(result.value.evaluate(deps), "1 year ago");
  });

  test("Assert formatElapsed with future date", () {
    final deps = Dependencies({
      "futureDate": DateTime.now().add(const Duration(hours: 5, minutes: 1)),
    });
    final result = parser.parse("formatElapsed(futureDate)");
    expect(result.value.evaluate(deps), "in 5 hours");
  });

  test("Assert formatElapsed with future date under 60 seconds", () {
    final deps = Dependencies({"futureDate": DateTime.now().add(const Duration(seconds: 10))});
    final result = parser.parse("formatElapsed(futureDate)");
    expect(result.value.evaluate(deps), "in a moment");
  });

  test("Assert formatElapsed with null returns empty string", () {
    final result = parser.parse("formatElapsed(nullValue)");
    expect(result.value.evaluate(dependencies), "");
  });
}
