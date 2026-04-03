import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/expressions/dynamic_function.dart';
import 'package:xwidget_el/src/parser.dart';

void main() {
  final parser = ELParser();

  // ==================================
  // Basic ternary with bool values
  // ==================================

  test("Assert ternary with true literal returns true branch", () {
    final result = parser.parse("true ? 'yes' : 'no'");
    expect(result.value.evaluate(Dependencies()), "yes");
  });

  test("Assert ternary with false literal returns false branch", () {
    final result = parser.parse("false ? 'yes' : 'no'");
    expect(result.value.evaluate(Dependencies()), "no");
  });

  test("Assert ternary with bool reference true", () {
    final deps = Dependencies({"isAdmin": true});
    final result = parser.parse("isAdmin ? 'admin' : 'user'");
    expect(result.value.evaluate(deps), "admin");
  });

  test("Assert ternary with bool reference false", () {
    final deps = Dependencies({"isAdmin": false});
    final result = parser.parse("isAdmin ? 'admin' : 'user'");
    expect(result.value.evaluate(deps), "user");
  });

  // ==================================
  // Ternary with comparison operators
  // ==================================

  test("Assert ternary with greater than comparison", () {
    final deps = Dependencies({"count": 5});
    final result = parser.parse("count > 3 ? 'many' : 'few'");
    expect(result.value.evaluate(deps), "many");
  });

  test("Assert ternary with less than comparison", () {
    final deps = Dependencies({"count": 2});
    final result = parser.parse("count < 3 ? 'few' : 'many'");
    expect(result.value.evaluate(deps), "few");
  });

  test("Assert ternary with equality comparison", () {
    final deps = Dependencies({"status": "active"});
    final result = parser.parse("status == 'active' ? 'on' : 'off'");
    expect(result.value.evaluate(deps), "on");
  });

  test("Assert ternary with inequality comparison", () {
    final deps = Dependencies({"status": "inactive"});
    final result = parser.parse("status != 'active' ? 'off' : 'on'");
    expect(result.value.evaluate(deps), "off");
  });

  test("Assert ternary with greater than or equal", () {
    final deps = Dependencies({"score": 100});
    final result = parser.parse("score >= 100 ? 'perfect' : 'try again'");
    expect(result.value.evaluate(deps), "perfect");
  });

  test("Assert ternary with less than or equal", () {
    final deps = Dependencies({"score": 0});
    final result = parser.parse("score <= 0 ? 'zero' : 'positive'");
    expect(result.value.evaluate(deps), "zero");
  });

  // ==================================
  // Ternary with logical operators
  // ==================================

  test("Assert ternary with logical AND", () {
    final deps = Dependencies({"isAdmin": true, "isActive": true});
    final result = parser.parse("isAdmin && isActive ? 'full access' : 'restricted'");
    expect(result.value.evaluate(deps), "full access");
  });

  test("Assert ternary with logical AND false", () {
    final deps = Dependencies({"isAdmin": true, "isActive": false});
    final result = parser.parse("isAdmin && isActive ? 'full access' : 'restricted'");
    expect(result.value.evaluate(deps), "restricted");
  });

  test("Assert ternary with logical OR", () {
    final deps = Dependencies({"isAdmin": false, "isModerator": true});
    final result = parser.parse("isAdmin || isModerator ? 'elevated' : 'normal'");
    expect(result.value.evaluate(deps), "elevated");
  });

  test("Assert ternary with negation", () {
    final deps = Dependencies({"isDisabled": false});
    final result = parser.parse("!isDisabled ? 'enabled' : 'disabled'");
    expect(result.value.evaluate(deps), "enabled");
  });

  // ==================================
  // Ternary with built-in functions
  // ==================================

  test("Assert ternary with isNull function", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNull(value) ? 'empty' : 'has value'");
    expect(result.value.evaluate(deps), "empty");
  });

  test("Assert ternary with isNotNull function", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNotNull(value) ? 'has value' : 'empty'");
    expect(result.value.evaluate(deps), "has value");
  });

  test("Assert ternary with isEmpty function", () {
    final deps = Dependencies({"items": []});
    final result = parser.parse("isEmpty(items) ? 'no items' : 'has items'");
    expect(result.value.evaluate(deps), "no items");
  });

  test("Assert ternary with isNotEmpty function", () {
    final deps = Dependencies({
      "items": [1, 2],
    });
    final result = parser.parse("isNotEmpty(items) ? 'has items' : 'no items'");
    expect(result.value.evaluate(deps), "has items");
  });

  test("Assert ternary with isTrue function", () {
    final deps = Dependencies({"flag": true});
    final result = parser.parse("isTrue(flag) ? 'on' : 'off'");
    expect(result.value.evaluate(deps), "on");
  });

  test("Assert ternary with isFalse function", () {
    final deps = Dependencies({"flag": false});
    final result = parser.parse("isFalse(flag) ? 'off' : 'on'");
    expect(result.value.evaluate(deps), "off");
  });

  test("Assert ternary with contains function", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("contains(text, 'World') ? 'found' : 'not found'");
    expect(result.value.evaluate(deps), "found");
  });

  test("Assert ternary with startsWith function", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("startsWith(text, 'He') ? 'yes' : 'no'");
    expect(result.value.evaluate(deps), "yes");
  });

  // ==================================
  // Ternary with custom/registered functions
  // ==================================

  test("Assert ternary with registered function returning bool", () {
    registerFunction("regIsEven", (dynamic v) => (v as int) % 2 == 0);
    final deps = Dependencies({"num": 4});
    final result = parser.parse("regIsEven(num) ? 'even' : 'odd'");
    expect(result.value.evaluate(deps), "even");
  });

  test("Assert ternary with registered function returning bool false", () {
    registerFunction("regIsEven2", (dynamic v) => (v as int) % 2 == 0);
    final deps = Dependencies({"num": 3});
    final result = parser.parse("regIsEven2(num) ? 'even' : 'odd'");
    expect(result.value.evaluate(deps), "odd");
  });

  test("Assert ternary with dependency function returning bool", () {
    final deps = Dependencies({"checkAge": (dynamic age) => (age as int) >= 18, "age": 21});
    final result = parser.parse("checkAge(age) ? 'adult' : 'minor'");
    expect(result.value.evaluate(deps), "adult");
  });

  // ==================================
  // Ternary with instance functions
  // ==================================

  test("Assert ternary with instance isEmpty on string", () {
    final deps = Dependencies({"text": ""});
    final result = parser.parse("text.isEmpty() ? 'blank' : 'filled'");
    expect(result.value.evaluate(deps), "blank");
  });

  test("Assert ternary with instance contains on list", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("items.contains(2) ? 'found' : 'missing'");
    expect(result.value.evaluate(deps), "found");
  });

  test("Assert ternary with instance isEven on int", () {
    final deps = Dependencies({"value": 4});
    final result = parser.parse("value.isEven() ? 'even' : 'odd'");
    expect(result.value.evaluate(deps), "even");
  });

  // ==================================
  // Ternary with function result comparison
  // ==================================

  test("Assert ternary comparing function result to value", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("length(items) > 2 ? 'long' : 'short'");
    expect(result.value.evaluate(deps), "long");
  });

  test("Assert ternary comparing function result to zero", () {
    final deps = Dependencies({"items": []});
    final result = parser.parse("length(items) == 0 ? 'empty' : 'filled'");
    expect(result.value.evaluate(deps), "empty");
  });

  // ==================================
  // Ternary branch expressions
  // ==================================

  test("Assert ternary branches can be numbers", () {
    final deps = Dependencies({"isDouble": true});
    final result = parser.parse("isDouble ? 200 : 100");
    expect(result.value.evaluate(deps), 200);
  });

  test("Assert ternary branches can be arithmetic", () {
    final deps = Dependencies({"x": 10, "useDouble": true});
    final result = parser.parse("useDouble ? x * 2 : x");
    expect(result.value.evaluate(deps), 20);
  });

  test("Assert ternary branches can be function calls", () {
    final deps = Dependencies({"value": -5, "useAbs": true});
    final result = parser.parse("useAbs ? abs(value) : value");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert ternary branches can be references", () {
    final deps = Dependencies({"usePrimary": true, "primary": "#FF0000", "secondary": "#00FF00"});
    final result = parser.parse("usePrimary ? primary : secondary");
    expect(result.value.evaluate(deps), "#FF0000");
  });

  // ==================================
  // Nested ternaries
  // ==================================

  test("Assert nested ternary in false branch", () {
    final deps = Dependencies({"score": 75});
    final result = parser.parse("score >= 90 ? 'A' : score >= 80 ? 'B' : 'C'");
    expect(result.value.evaluate(deps), "C");
  });

  test("Assert nested ternary resolves to middle branch", () {
    final deps = Dependencies({"score": 85});
    final result = parser.parse("score >= 90 ? 'A' : score >= 80 ? 'B' : 'C'");
    expect(result.value.evaluate(deps), "B");
  });

  test("Assert nested ternary resolves to first branch", () {
    final deps = Dependencies({"score": 95});
    final result = parser.parse("score >= 90 ? 'A' : score >= 80 ? 'B' : 'C'");
    expect(result.value.evaluate(deps), "A");
  });

  // ==================================
  // Ternary with non-bool condition
  // ==================================

  test("Assert ternary with non-bool condition throws exception", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("value ? 'yes' : 'no'");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  test("Assert ternary with string condition throws exception", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("value ? 'yes' : 'no'");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  test("Assert ternary with null condition throws exception", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("value ? 'yes' : 'no'");
    expect(() => result.value.evaluate(deps), throwsException);
  });
}
