import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/parser.dart';

void main() {
  final parser = ELParser();

  // ==================================
  // abs tests
  // ==================================

  test("Assert abs with negative int", () {
    final deps = Dependencies({"value": -5});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert abs with positive int", () {
    final deps = Dependencies({"value": 5});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert abs with negative double", () {
    final deps = Dependencies({"value": -3.14});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), 3.14);
  });

  test("Assert abs with string", () {
    final deps = Dependencies({"value": "-42"});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), 42.0);
  });

  test("Assert abs with zero", () {
    final deps = Dependencies({"value": 0});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), 0);
  });

  test("Assert abs with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // ceil tests
  // ==================================

  test("Assert ceil with double rounds up", () {
    final deps = Dependencies({"value": 3.2});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert ceil with negative double", () {
    final deps = Dependencies({"value": -3.7});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), -3);
  });

  test("Assert ceil with int returns same value", () {
    final deps = Dependencies({"value": 5});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert ceil with string", () {
    final deps = Dependencies({"value": "7.9"});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), 8);
  });

  test("Assert ceil with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // clamp tests
  // ==================================

  test("Assert clamp returns lower when value below range", () {
    final result = parser.parse("clamp(-5, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 0);
  });

  test("Assert clamp returns upper when value above range", () {
    final result = parser.parse("clamp(150, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 100);
  });

  test("Assert clamp returns value when within range", () {
    final result = parser.parse("clamp(50, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 50);
  });

  test("Assert clamp returns lower when value equals lower", () {
    final result = parser.parse("clamp(0, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 0);
  });

  test("Assert clamp returns upper when value equals upper", () {
    final result = parser.parse("clamp(100, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 100);
  });

  test("Assert clamp with doubles", () {
    final deps = Dependencies({"value": 1.5});
    final result = parser.parse("clamp(value, 0.0, 1.0)");
    expect(result.value.evaluate(deps), 1.0);
  });

  test("Assert clamp with null returns lower", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("clamp(value, 0, 100)");
    expect(result.value.evaluate(deps), 0);
  });

  test("Assert clamp with strings", () {
    final deps = Dependencies({"value": "m"});
    final result = parser.parse("clamp(value, 'a', 'f')");
    expect(result.value.evaluate(deps), "f");
  });

  // ==================================
  // floor tests
  // ==================================

  test("Assert floor with double rounds down", () {
    final deps = Dependencies({"value": 3.9});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert floor with negative double", () {
    final deps = Dependencies({"value": -3.2});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), -4);
  });

  test("Assert floor with int returns same value", () {
    final deps = Dependencies({"value": 5});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert floor with string", () {
    final deps = Dependencies({"value": "7.1"});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), 7);
  });

  test("Assert floor with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // max tests
  // ==================================

  test("Assert max returns larger int", () {
    final result = parser.parse("max(3, 7)");
    expect(result.value.evaluate(Dependencies()), 7);
  });

  test("Assert max returns larger double", () {
    final deps = Dependencies({"a": 10.5, "b": 2.3});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), 10.5);
  });

  test("Assert max with negative numbers", () {
    final result = parser.parse("max(-1, -5)");
    expect(result.value.evaluate(Dependencies()), -1);
  });

  test("Assert max with equal values", () {
    final result = parser.parse("max(5, 5)");
    expect(result.value.evaluate(Dependencies()), 5);
  });

  test("Assert max with null first returns second", () {
    final deps = Dependencies({"a": null, "b": 10});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert max with null second returns first", () {
    final deps = Dependencies({"a": 10, "b": null});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert max with both null returns null", () {
    final deps = Dependencies({"a": null, "b": null});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert max with strings", () {
    final deps = Dependencies({"a": "apple", "b": "banana"});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), "banana");
  });

  // ==================================
  // min tests
  // ==================================

  test("Assert min returns smaller int", () {
    final result = parser.parse("min(3, 7)");
    expect(result.value.evaluate(Dependencies()), 3);
  });

  test("Assert min returns smaller double", () {
    final deps = Dependencies({"a": 10.5, "b": 2.3});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), 2.3);
  });

  test("Assert min with negative numbers", () {
    final result = parser.parse("min(-1, -5)");
    expect(result.value.evaluate(Dependencies()), -5);
  });

  test("Assert min with equal values", () {
    final result = parser.parse("min(5, 5)");
    expect(result.value.evaluate(Dependencies()), 5);
  });

  test("Assert min with null first returns second", () {
    final deps = Dependencies({"a": null, "b": 10});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert min with null second returns first", () {
    final deps = Dependencies({"a": 10, "b": null});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert min with both null returns null", () {
    final deps = Dependencies({"a": null, "b": null});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert min with strings", () {
    final deps = Dependencies({"a": "apple", "b": "banana"});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), "apple");
  });

  // ==================================
  // randomInt tests
  // ==================================

  test("Assert randomInt returns value in range", () {
    final result = parser.parse("randomInt(100)");
    final value = result.value.evaluate(Dependencies());
    expect(value is int, true);
    expect(value >= 0 && value < 100, true);
  });

  test("Assert randomInt with max 1 returns 0", () {
    final result = parser.parse("randomInt(1)");
    expect(result.value.evaluate(Dependencies()), 0);
  });

  test("Assert randomInt returns values within bounds over multiple calls", () {
    for (int i = 0; i < 50; i++) {
      final result = parser.parse("randomInt(10)");
      final value = result.value.evaluate(Dependencies());
      expect(value >= 0 && value < 10, true);
    }
  });

  // ==================================
  // randomDouble tests
  // ==================================

  test("Assert randomDouble returns value in range", () {
    final result = parser.parse("randomDouble()");
    final value = result.value.evaluate(Dependencies());
    expect(value is double, true);
    expect(value >= 0.0 && value < 1.0, true);
  });

  test("Assert randomDouble returns values within bounds over multiple calls", () {
    for (int i = 0; i < 50; i++) {
      final result = parser.parse("randomDouble()");
      final value = result.value.evaluate(Dependencies());
      expect(value >= 0.0 && value < 1.0, true);
    }
  });

  // ==================================
  // round tests
  // ==================================

  test("Assert round with double rounds to nearest", () {
    final deps = Dependencies({"value": 3.6});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert round with double rounds down", () {
    final deps = Dependencies({"value": 3.4});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert round with 0.5 rounds up", () {
    final deps = Dependencies({"value": 3.5});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert round with negative double", () {
    final deps = Dependencies({"value": -3.6});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), -4);
  });

  test("Assert round with int returns same value", () {
    final deps = Dependencies({"value": 5});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert round with string", () {
    final deps = Dependencies({"value": "7.2"});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 7);
  });

  test("Assert round with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), null);
  });
}
