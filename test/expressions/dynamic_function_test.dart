import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/expressions/dynamic_function.dart';
import 'package:xwidget_el/src/parser.dart';

class _ResolverTestEntity {
  final int value;
  _ResolverTestEntity(this.value);
}

void main() {
  final parser = ELParser();

  // ==================================
  // registerFunction
  // ==================================

  test("Assert registered function can be called from EL", () {
    registerFunction("regDouble", (dynamic value) => (value as num) * 2);
    final result = parser.parse("regDouble(21)");
    expect(result.value.evaluate(Dependencies()), 42);
  });

  test("Assert registered function with multiple parameters", () {
    registerFunction("regAdd3", (dynamic a, dynamic b, dynamic c) => a + b + c);
    final result = parser.parse("regAdd3(10, 20, 12)");
    expect(result.value.evaluate(Dependencies()), 42);
  });

  test("Assert registered function with no parameters", () {
    registerFunction("regMagicNumber", () => 42);
    final result = parser.parse("regMagicNumber()");
    expect(result.value.evaluate(Dependencies()), 42);
  });

  test("Assert registered function returning string", () {
    registerFunction("regGreet", (dynamic name) => "Hello, $name!");
    final result = parser.parse("regGreet('World')");
    expect(result.value.evaluate(Dependencies()), "Hello, World!");
  });

  test("Assert registered function returning bool true", () {
    registerFunction("regIsPositive", (dynamic value) => (value as num) > 0);
    final result = parser.parse("regIsPositive(5)");
    expect(result.value.evaluate(Dependencies()), true);
  });

  test("Assert registered function returning bool false", () {
    registerFunction("regIsPositive", (dynamic value) => (value as num) > 0);
    final result = parser.parse("regIsPositive(-3)");
    expect(result.value.evaluate(Dependencies()), false);
  });

  test("Assert registered function can access dependency values", () {
    registerFunction("regShout", (dynamic value) => value.toString().toUpperCase());
    final deps = Dependencies({"name": "hello"});
    final result = parser.parse("regShout(name)");
    expect(result.value.evaluate(deps), "HELLO");
  });

  test("Assert registered function works in arithmetic expressions", () {
    registerFunction("regTriple", (dynamic value) => (value as num) * 3);
    final result = parser.parse("regTriple(10) + 5");
    expect(result.value.evaluate(Dependencies()), 35);
  });

  test("Assert registered function works in comparison", () {
    registerFunction("regSquare", (dynamic value) => (value as num) * (value));
    final result = parser.parse("regSquare(5) > 20");
    expect(result.value.evaluate(Dependencies()), true);
  });

  test("Assert registered function can be nested in built-in function", () {
    registerFunction("regSquare2", (dynamic value) => (value as num) * (value));
    final result = parser.parse("toString(regSquare2(5))");
    expect(result.value.evaluate(Dependencies()), "25");
  });

  test("Assert registered function can take built-in as argument", () {
    registerFunction("regNegate", (dynamic value) => -(value as num));
    final result = parser.parse("regNegate(abs(-7))");
    expect(result.value.evaluate(Dependencies()), -7);
  });

  test("Assert registered function replaces previous registration", () {
    registerFunction("regReplace", () => "first");
    registerFunction("regReplace", () => "second");
    final result = parser.parse("regReplace()");
    expect(result.value.evaluate(Dependencies()), "second");
  });

  // ==================================
  // Resolution priority
  // ==================================

  test("Assert built-in takes priority over registered function", () {
    registerFunction("length", (dynamic value) => -1);
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("length(items)");
    // Built-in length wins, returns 3 not -1
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert registered function takes priority over dependency function", () {
    registerFunction("regPriority", () => "registered");
    final deps = Dependencies({"regPriority": () => "dependency"});
    final result = parser.parse("regPriority()");
    expect(result.value.evaluate(deps), "registered");
  });

  test("Assert dependency function resolves when no built-in or registered match", () {
    final deps = Dependencies({"customDep": (dynamic a) => a * 10});
    final result = parser.parse("customDep(5)");
    expect(result.value.evaluate(deps), 50);
  });

  test("Assert unresolvable function throws exception", () {
    final result = parser.parse("totallyUnknownFunc(42)");
    expect(() => result.value.evaluate(Dependencies()), throwsException);
  });

  // ==================================
  // getDynamicFunction — built-in math
  // ==================================

  test("Assert built-in abs", () {
    final result = parser.parse("abs(-42)");
    expect(result.value.evaluate(Dependencies()), 42);
  });

  test("Assert built-in ceil", () {
    final result = parser.parse("ceil(3.2)");
    expect(result.value.evaluate(Dependencies()), 4);
  });

  test("Assert built-in floor", () {
    final result = parser.parse("floor(3.7)");
    expect(result.value.evaluate(Dependencies()), 3);
  });

  test("Assert built-in round", () {
    final result = parser.parse("round(3.5)");
    expect(result.value.evaluate(Dependencies()), 4);
  });

  test("Assert built-in min", () {
    final result = parser.parse("min(3, 7)");
    expect(result.value.evaluate(Dependencies()), 3);
  });

  test("Assert built-in max", () {
    final result = parser.parse("max(3, 7)");
    expect(result.value.evaluate(Dependencies()), 7);
  });

  test("Assert built-in clamp", () {
    final result = parser.parse("clamp(150, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 100);
  });

  test("Assert built-in randomInt returns value in range", () {
    final result = parser.parse("randomInt(100)");
    final value = result.value.evaluate(Dependencies());
    expect(value is int, true);
    expect(value >= 0 && value < 100, true);
  });

  test("Assert built-in randomDouble returns value in range", () {
    final result = parser.parse("randomDouble()");
    final value = result.value.evaluate(Dependencies());
    expect(value is double, true);
    expect(value >= 0.0 && value < 1.0, true);
  });

  // ==================================
  // getDynamicFunction — built-in validators
  // ==================================

  test("Assert built-in isNull", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isNotNull", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNotNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isEmpty with empty string", () {
    final deps = Dependencies({"text": ""});
    final result = parser.parse("isEmpty(text)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isNotEmpty with non-empty string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("isNotEmpty(text)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isBlank with whitespace string", () {
    final deps = Dependencies({"text": "   "});
    final result = parser.parse("isBlank(text)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isNotBlank with non-blank string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("isNotBlank(text)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isTrue", () {
    final deps = Dependencies({"flag": true});
    final result = parser.parse("isTrue(flag)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isFalse", () {
    final deps = Dependencies({"flag": false});
    final result = parser.parse("isFalse(flag)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isTrueOrNull with null", () {
    final deps = Dependencies({"flag": null});
    final result = parser.parse("isTrueOrNull(flag)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in isFalseOrNull with null", () {
    final deps = Dependencies({"flag": null});
    final result = parser.parse("isFalseOrNull(flag)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in contains with string", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("contains(text, 'World')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in startsWith", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("startsWith(text, 'He')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in endsWith", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("endsWith(text, 'lo')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in matches", () {
    final deps = Dependencies({"text": "abc123"});
    final result = parser.parse("matches(text, '[a-z]+[0-9]+')");
    expect(result.value.evaluate(deps), true);
  });

  // ==================================
  // getDynamicFunction — built-in converters
  // ==================================

  test("Assert built-in toInt", () {
    final deps = Dependencies({"value": "42"});
    final result = parser.parse("toInt(value)");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert built-in toDouble", () {
    final deps = Dependencies({"value": "3.14"});
    final result = parser.parse("toDouble(value)");
    expect(result.value.evaluate(deps), 3.14);
  });

  test("Assert built-in toBool", () {
    final deps = Dependencies({"value": "true"});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in toString", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("toString(value)");
    expect(result.value.evaluate(deps), "42");
  });

  test("Assert built-in tryToInt with invalid returns null", () {
    final deps = Dependencies({"value": "abc"});
    final result = parser.parse("tryToInt(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToDouble with invalid returns null", () {
    final deps = Dependencies({"value": "abc"});
    final result = parser.parse("tryToDouble(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // getDynamicFunction — built-in misc
  // ==================================

  test("Assert built-in length with list", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("length(items)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert built-in length with string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("length(text)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert built-in first with list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("first(items)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert built-in last with list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("last(items)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert built-in substring", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("substring(text, 0, 5)");
    expect(result.value.evaluate(deps), "Hello");
  });

  test("Assert built-in replaceAll", () {
    final deps = Dependencies({"text": "foo bar foo"});
    final result = parser.parse("replaceAll(text, 'foo', 'baz')");
    expect(result.value.evaluate(deps), "baz bar baz");
  });

  test("Assert built-in replaceFirst", () {
    final deps = Dependencies({"text": "foo bar foo"});
    final result = parser.parse("replaceFirst(text, 'foo', 'baz')");
    expect(result.value.evaluate(deps), "baz bar foo");
  });

  test("Assert built-in now returns DateTime", () {
    final result = parser.parse("now()");
    expect(result.value.evaluate(Dependencies()) is DateTime, true);
  });

  test("Assert built-in nowUtc returns UTC DateTime", () {
    final result = parser.parse("nowUtc()");
    final value = result.value.evaluate(Dependencies()) as DateTime;
    expect(value.isUtc, true);
  });

  // ==================================
  // getDynamicFunction — built-in formatters
  // ==================================

  test("Assert built-in formatNumber", () {
    final deps = Dependencies({"value": 24891});
    final result = parser.parse("formatNumber(value, '#,##0')");
    expect(result.value.evaluate(deps), "24,891");
  });

  test("Assert built-in formatPercent", () {
    final deps = Dependencies({"value": 0.123});
    final result = parser.parse("formatPercent(value, 1)");
    expect(result.value.evaluate(deps), "12.3%");
  });

  test("Assert built-in formatBytes", () {
    final deps = Dependencies({"value": 1048576});
    final result = parser.parse("formatBytes(value, 1)");
    expect(result.value.evaluate(deps), "1.0 MB");
  });

  test("Assert built-in formatCompact", () {
    final deps = Dependencies({"value": 3400000});
    final result = parser.parse("formatCompact(value, 1)");
    expect(result.value.evaluate(deps), "3.4M");
  });

  test("Assert built-in formatOrdinal", () {
    final deps = Dependencies({"value": 3});
    final result = parser.parse("formatOrdinal(value)");
    expect(result.value.evaluate(deps), "3rd");
  });

  test("Assert built-in formatPlural", () {
    final deps = Dependencies({"count": 5});
    final result = parser.parse("formatPlural(count, 'item', 'items')");
    expect(result.value.evaluate(deps), "5 items");
  });

  // ==================================
  // getDynamicFunctionOn — String methods
  // ==================================

  test("Assert instance toUpperCase on string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("text.toUpperCase()");
    expect(result.value.evaluate(deps), "HELLO");
  });

  test("Assert instance toLowerCase on string", () {
    final deps = Dependencies({"text": "HELLO"});
    final result = parser.parse("text.toLowerCase()");
    expect(result.value.evaluate(deps), "hello");
  });

  test("Assert instance trim on string", () {
    final deps = Dependencies({"text": "  hello  "});
    final result = parser.parse("text.trim()");
    expect(result.value.evaluate(deps), "hello");
  });

  test("Assert instance trimLeft on string", () {
    final deps = Dependencies({"text": "  hello  "});
    final result = parser.parse("text.trimLeft()");
    expect(result.value.evaluate(deps), "hello  ");
  });

  test("Assert instance trimRight on string", () {
    final deps = Dependencies({"text": "  hello  "});
    final result = parser.parse("text.trimRight()");
    expect(result.value.evaluate(deps), "  hello");
  });

  test("Assert instance contains on string", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("text.contains('World')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance startsWith on string", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("text.startsWith('He')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance endsWith on string", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("text.endsWith('lo')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance substring on string", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("text.substring(6)");
    expect(result.value.evaluate(deps), "World");
  });

  test("Assert instance indexOf on string", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("text.indexOf('l')");
    expect(result.value.evaluate(deps), 2);
  });

  test("Assert instance lastIndexOf on string", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("text.lastIndexOf('l')");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance split on string", () {
    final deps = Dependencies({"text": "a,b,c"});
    final result = parser.parse("text.split(',')");
    expect(result.value.evaluate(deps), ["a", "b", "c"]);
  });

  test("Assert instance replaceAll on string", () {
    final deps = Dependencies({"text": "aabbcc"});
    final result = parser.parse("text.replaceAll('b', 'x')");
    expect(result.value.evaluate(deps), "aaxxcc");
  });

  test("Assert instance replaceFirst on string", () {
    final deps = Dependencies({"text": "aabbcc"});
    final result = parser.parse("text.replaceFirst('b', 'x')");
    expect(result.value.evaluate(deps), "aaxbcc");
  });

  test("Assert instance padLeft on string", () {
    final deps = Dependencies({"text": "42"});
    final result = parser.parse("text.padLeft(5, '0')");
    expect(result.value.evaluate(deps), "00042");
  });

  test("Assert instance padRight on string", () {
    final deps = Dependencies({"text": "42"});
    final result = parser.parse("text.padRight(5, '0')");
    expect(result.value.evaluate(deps), "42000");
  });

  test("Assert instance length on string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("text.length()");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert instance isEmpty on empty string", () {
    final deps = Dependencies({"text": ""});
    final result = parser.parse("text.isEmpty()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isNotEmpty on string", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("text.isNotEmpty()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance method on string expression in parentheses", () {
    final result = parser.parse("('hello').toUpperCase()");
    expect(result.value.evaluate(Dependencies()), "HELLO");
  });

  // ==================================
  // getDynamicFunctionOn — List methods
  // ==================================

  test("Assert instance first on list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("items.first()");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert instance last on list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("items.last()");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert instance length on list", () {
    final deps = Dependencies({
      "items": [1, 2, 3, 4],
    });
    final result = parser.parse("items.length()");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert instance contains on list", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("items.contains(2)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isEmpty on empty list", () {
    final deps = Dependencies({"items": []});
    final result = parser.parse("items.isEmpty()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isNotEmpty on list", () {
    final deps = Dependencies({
      "items": [1],
    });
    final result = parser.parse("items.isNotEmpty()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance elementAt on list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("items.elementAt(1)");
    expect(result.value.evaluate(deps), 20);
  });

  test("Assert instance indexOf on list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("items.indexOf(20)");
    expect(result.value.evaluate(deps), 1);
  });

  test("Assert instance sublist on list", () {
    final deps = Dependencies({
      "items": [10, 20, 30, 40, 50],
    });
    final result = parser.parse("items.sublist(1, 3)");
    expect(result.value.evaluate(deps), [20, 30]);
  });

  test("Assert instance toSet on list", () {
    final deps = Dependencies({
      "items": [1, 2, 2, 3],
    });
    final result = parser.parse("items.toSet()");
    expect(result.value.evaluate(deps), {1, 2, 3});
  });

  test("Assert instance single on list", () {
    final deps = Dependencies({
      "items": [42],
    });
    final result = parser.parse("items.single()");
    expect(result.value.evaluate(deps), 42);
  });

  // ==================================
  // getDynamicFunctionOn — Map methods
  // ==================================

  test("Assert instance containsKey on map", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("data.containsKey('a')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance containsValue on map", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("data.containsValue(2)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance length on map", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2, "c": 3},
    });
    final result = parser.parse("data.length()");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance isEmpty on empty map", () {
    final deps = Dependencies({"data": {}});
    final result = parser.parse("data.isEmpty()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance keys on map", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"a": 1, "b": 2},
    });
    final result = parser.parse("data.keys()");
    final value = result.value.evaluate(deps);
    expect(value.toList(), ["a", "b"]);
  });

  test("Assert instance values on map", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"a": 1, "b": 2},
    });
    final result = parser.parse("data.values()");
    final value = result.value.evaluate(deps);
    expect(value.toList(), [1, 2]);
  });

  test("Assert map lookup resolves function stored as value", () {
    final deps = Dependencies({
      "funcs": <String, dynamic>{"dbl": (dynamic v) => (v as num) * 2},
    });
    final result = parser.parse("funcs.dbl(21)");
    expect(result.value.evaluate(deps), 42);
  });

  // ==================================
  // getDynamicFunctionOn — Set methods
  // ==================================

  test("Assert instance contains on set", () {
    final deps = Dependencies({
      "items": {1, 2, 3},
    });
    final result = parser.parse("items.contains(2)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance length on set", () {
    final deps = Dependencies({
      "items": {1, 2, 3},
    });
    final result = parser.parse("items.length()");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance toList on set", () {
    final deps = Dependencies({
      "items": {1, 2, 3},
    });
    final result = parser.parse("items.toList()");
    expect(result.value.evaluate(deps), [1, 2, 3]);
  });

  // ==================================
  // getDynamicFunctionOn — num methods
  // ==================================

  test("Assert instance abs on num", () {
    final deps = Dependencies({"value": -42});
    final result = parser.parse("value.abs()");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert instance ceil on double", () {
    final deps = Dependencies({"value": 3.2});
    final result = parser.parse("value.ceil()");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert instance floor on double", () {
    final deps = Dependencies({"value": 3.7});
    final result = parser.parse("value.floor()");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance round on double", () {
    final deps = Dependencies({"value": 3.5});
    final result = parser.parse("value.round()");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert instance truncate on double", () {
    final deps = Dependencies({"value": 3.9});
    final result = parser.parse("value.truncate()");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance toDouble on int", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("value.toDouble()");
    expect(result.value.evaluate(deps), 42.0);
  });

  test("Assert instance toInt on double", () {
    final deps = Dependencies({"value": 3.14});
    final result = parser.parse("value.toInt()");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance isEven on int", () {
    final deps = Dependencies({"value": 4});
    final result = parser.parse("value.isEven()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isOdd on int", () {
    final deps = Dependencies({"value": 3});
    final result = parser.parse("value.isOdd()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isNegative on num", () {
    final deps = Dependencies({"value": -5});
    final result = parser.parse("value.isNegative()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isFinite on num", () {
    final deps = Dependencies({"value": 42.0});
    final result = parser.parse("value.isFinite()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance compareTo on num", () {
    final deps = Dependencies({"value": 5});
    final result = parser.parse("value.compareTo(3)");
    expect(result.value.evaluate(deps), 1);
  });

  test("Assert instance toRadixString on int", () {
    final deps = Dependencies({"value": 255});
    final result = parser.parse("value.toRadixString(16)");
    expect(result.value.evaluate(deps), "ff");
  });

  test("Assert instance toString on num", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("value.toString()");
    expect(result.value.evaluate(deps), "42");
  });

  test("Assert instance runtimeType", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("value.runtimeType()");
    expect(result.value.evaluate(deps), String);
  });

  // ==================================
  // getDynamicFunctionOn — error cases
  // ==================================

  test("Assert instance function on null source returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("value.toUpperCase()");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert unknown instance function throws exception", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("value.nonExistentMethod()");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  // ==================================
  // eval function
  // ==================================

  test("Assert eval evaluates arithmetic expression", () {
    final deps = Dependencies({"expr": "1 + 2"});
    final result = parser.parse("eval(expr)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert eval evaluates string expression", () {
    final deps = Dependencies({"expr": "toString(42)"});
    final result = parser.parse("eval(expr)");
    expect(result.value.evaluate(deps), "42");
  });

  test("Assert eval evaluates expression with dependencies", () {
    final deps = Dependencies({"x": 10, "y": 20, "expr": "x + y"});
    final result = parser.parse("eval(expr)");
    expect(result.value.evaluate(deps), 30);
  });

  // ==================================
  // DynamicFunction — complex chains
  // ==================================

  test("Assert function chained with instance method", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("text.substring(0, 5).toUpperCase()");
    expect(result.value.evaluate(deps), "HELLO");
  });

  test("Assert expression in parentheses chained with methods", () {
    final result = parser.parse("('hello world').toUpperCase().substring(0, 5)");
    expect(result.value.evaluate(Dependencies()), "HELLO");
  });

  test("Assert nested function calls", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("toString(length(text))");
    expect(result.value.evaluate(deps), "5");
  });

  test("Assert function result used in comparison", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("length(items) > 2");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert function result used in ternary via comparison", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("length(items) > 0 ? 'has items' : 'empty'");
    expect(result.value.evaluate(deps), "has items");
  });

  test("Assert function result used in null coalescing", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("substring(text, 0, 5) ?? 'default'");
    expect(result.value.evaluate(deps), "default");
  });

  // ==================================
  // getDynamicFunction — static edge cases
  // ==================================

  test("Assert built-in abs with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("abs(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in ceil with string", () {
    final deps = Dependencies({"value": "3.1"});
    final result = parser.parse("ceil(value)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert built-in floor with string", () {
    final deps = Dependencies({"value": "3.9"});
    final result = parser.parse("floor(value)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert built-in round with string", () {
    final deps = Dependencies({"value": "3.7"});
    final result = parser.parse("round(value)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert built-in max returns non-null when first arg is null", () {
    final deps = Dependencies({"a": null, "b": 5});
    final result = parser.parse("max(a, b)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert built-in min returns non-null when second arg is null", () {
    final deps = Dependencies({"a": 3, "b": null});
    final result = parser.parse("min(a, b)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert built-in clamp below lower returns lower", () {
    final result = parser.parse("clamp(-5, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 0);
  });

  test("Assert built-in clamp within range returns value", () {
    final result = parser.parse("clamp(50, 0, 100)");
    expect(result.value.evaluate(Dependencies()), 50);
  });

  test("Assert built-in contains with list", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("contains(items, 2)");
    expect(result.value.evaluate(deps), true);
  });

  // ==================================
  // getDynamicFunction — containsKey / containsValue (static)
  // ==================================

  test("Assert built-in containsKey with matching key", () {
    final deps = Dependencies({
      "data": {"userId": 42, "name": "Alice"},
    });
    final result = parser.parse("containsKey(data, 'userId')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in containsKey with non-matching key", () {
    final deps = Dependencies({
      "data": {"userId": 42},
    });
    final result = parser.parse("containsKey(data, 'missing')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert built-in containsValue with matching value", () {
    final deps = Dependencies({
      "data": {"role": "admin", "status": "active"},
    });
    final result = parser.parse("containsValue(data, 'admin')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in containsValue with non-matching value", () {
    final deps = Dependencies({
      "data": {"role": "user"},
    });
    final result = parser.parse("containsValue(data, 'admin')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // getDynamicFunction — first / last / length on Set (static)
  // ==================================

  test("Assert built-in first with set", () {
    final deps = Dependencies({
      "items": {10, 20, 30},
    });
    final result = parser.parse("first(items)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert built-in last with set", () {
    final deps = Dependencies({
      "items": {10, 20, 30},
    });
    final result = parser.parse("last(items)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert built-in length with map", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2, "c": 3},
    });
    final result = parser.parse("length(data)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert built-in length with set", () {
    final deps = Dependencies({
      "items": {1, 2, 3, 4, 5},
    });
    final result = parser.parse("length(items)");
    expect(result.value.evaluate(deps), 5);
  });

  // ==================================
  // getDynamicFunction — diffDateTime
  // ==================================

  test("Assert built-in diffDateTime returns Duration", () {
    final deps = Dependencies({"start": DateTime(2024, 1, 10), "end": DateTime(2024, 1, 15)});
    final result = parser.parse("diffDateTime(start, end)");
    expect(result.value.evaluate(deps), const Duration(days: 5));
  });

  test("Assert built-in diffDateTime returns absolute difference", () {
    final deps = Dependencies({"later": DateTime(2024, 1, 15), "earlier": DateTime(2024, 1, 10)});
    final result = parser.parse("diffDateTime(later, earlier)");
    expect(result.value.evaluate(deps), const Duration(days: 5));
  });

  // ==================================
  // getDynamicFunction — formatDateTime / formatElapsed
  // ==================================

  test("Assert built-in formatDateTime with pattern", () {
    final deps = Dependencies({"dt": DateTime(2024, 3, 15)});
    final result = parser.parse("formatDateTime('yyyy-MM-dd', dt)");
    expect(result.value.evaluate(deps), "2024-03-15");
  });

  test("Assert built-in formatDateTime with time pattern", () {
    final deps = Dependencies({"dt": DateTime(2024, 1, 1, 14, 30, 45)});
    final result = parser.parse("formatDateTime('HH:mm:ss', dt)");
    expect(result.value.evaluate(deps), "14:30:45");
  });

  test("Assert built-in formatElapsed for past hours", () {
    final deps = Dependencies({"dt": DateTime.now().subtract(const Duration(hours: 3))});
    final result = parser.parse("formatElapsed(dt)");
    final value = result.value.evaluate(deps) as String;
    expect(value.contains('hour'), true);
    expect(value.endsWith('ago'), true);
  });

  test("Assert built-in formatElapsed for future returns 'in' prefix", () {
    final deps = Dependencies({"dt": DateTime.now().add(const Duration(hours: 5))});
    final result = parser.parse("formatElapsed(dt)");
    final value = result.value.evaluate(deps) as String;
    expect(value.startsWith('in '), true);
  });

  // ==================================
  // getDynamicFunction — logDebug
  // ==================================

  test("Assert built-in logDebug does not throw", () {
    final result = parser.parse("logDebug('test message')");
    expect(() => result.value.evaluate(Dependencies()), returnsNormally);
  });

  // ==================================
  // getDynamicFunction — converters (bool)
  // ==================================

  test("Assert built-in toBool with bool true passes through", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in toBool with bool false passes through", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert built-in toBool with 'false' string", () {
    final deps = Dependencies({"value": "false"});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert built-in toBool with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toBool(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToBool with valid string", () {
    final deps = Dependencies({"value": "true"});
    final result = parser.parse("tryToBool(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert built-in tryToBool with invalid string returns null", () {
    final deps = Dependencies({"value": "not-a-bool"});
    final result = parser.parse("tryToBool(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // getDynamicFunction — converters (Color)
  // ==================================

  test("Assert built-in toColor from hex with hash prefix", () {
    final result = parser.parse("toColor('#FF5733')");
    final value = result.value.evaluate(Dependencies());
    expect(value, isNotNull);
    expect(value.runtimeType.toString(), contains('Color'));
  });

  test("Assert built-in toColor from hex with 0x prefix", () {
    final result = parser.parse("toColor('0xFFFF5733')");
    final value = result.value.evaluate(Dependencies());
    expect(value, isNotNull);
    expect(value.runtimeType.toString(), contains('Color'));
  });

  test("Assert built-in toColor with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toColor(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToColor with valid hex", () {
    final result = parser.parse("tryToColor('#FF5733')");
    final value = result.value.evaluate(Dependencies());
    expect(value, isNotNull);
  });

  test("Assert built-in tryToColor with invalid returns null", () {
    final deps = Dependencies({"value": "not-a-color"});
    final result = parser.parse("tryToColor(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // getDynamicFunction — converters (DateTime)
  // ==================================

  test("Assert built-in toDateTime from ISO string", () {
    final result = parser.parse("toDateTime('2024-03-15')");
    final value = result.value.evaluate(Dependencies()) as DateTime;
    expect(value.year, 2024);
    expect(value.month, 3);
    expect(value.day, 15);
  });

  test("Assert built-in toDateTime from DateTime passes through", () {
    final dt = DateTime(2024, 6, 1);
    final deps = Dependencies({"value": dt});
    final result = parser.parse("toDateTime(value)");
    expect(result.value.evaluate(deps), dt);
  });

  test("Assert built-in toDateTime with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toDateTime(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToDateTime with valid string", () {
    final result = parser.parse("tryToDateTime('2024-01-01')");
    final value = result.value.evaluate(Dependencies());
    expect(value is DateTime, true);
  });

  test("Assert built-in tryToDateTime with invalid returns null", () {
    final deps = Dependencies({"value": "not-a-date"});
    final result = parser.parse("tryToDateTime(value)");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // getDynamicFunction — converters (Duration & Duration components)
  // ==================================

  test("Assert built-in toDays from Duration", () {
    final deps = Dependencies({"dur": const Duration(days: 5)});
    final result = parser.parse("toDays(dur)");
    expect(result.value.evaluate(deps), 5);
  });

  test("Assert built-in toDays from 48 hours returns 2", () {
    final deps = Dependencies({"dur": const Duration(hours: 48)});
    final result = parser.parse("toDays(dur)");
    expect(result.value.evaluate(deps), 2);
  });

  test("Assert built-in toHours from Duration", () {
    final deps = Dependencies({"dur": const Duration(hours: 10)});
    final result = parser.parse("toHours(dur)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert built-in toHours from 120 minutes returns 2", () {
    final deps = Dependencies({"dur": const Duration(minutes: 120)});
    final result = parser.parse("toHours(dur)");
    expect(result.value.evaluate(deps), 2);
  });

  test("Assert built-in toMinutes from Duration", () {
    final deps = Dependencies({"dur": const Duration(hours: 2)});
    final result = parser.parse("toMinutes(dur)");
    expect(result.value.evaluate(deps), 120);
  });

  test("Assert built-in toSeconds from Duration", () {
    final deps = Dependencies({"dur": const Duration(minutes: 2)});
    final result = parser.parse("toSeconds(dur)");
    expect(result.value.evaluate(deps), 120);
  });

  test("Assert built-in toMillis from Duration", () {
    final deps = Dependencies({"dur": const Duration(seconds: 3)});
    final result = parser.parse("toMillis(dur)");
    expect(result.value.evaluate(deps), 3000);
  });

  test("Assert built-in toDuration from int with seconds unit", () {
    final result = parser.parse("toDuration(60, 's')");
    expect(result.value.evaluate(Dependencies()), const Duration(seconds: 60));
  });

  test("Assert built-in toDuration from int with hours unit", () {
    final result = parser.parse("toDuration(2, 'h')");
    expect(result.value.evaluate(Dependencies()), const Duration(hours: 2));
  });

  test("Assert built-in toDuration from int with minutes unit", () {
    final result = parser.parse("toDuration(30, 'min')");
    expect(result.value.evaluate(Dependencies()), const Duration(minutes: 30));
  });

  test("Assert built-in toDuration from int with days unit", () {
    final result = parser.parse("toDuration(2, 'day')");
    expect(result.value.evaluate(Dependencies()), const Duration(days: 2));
  });

  test("Assert built-in toDuration from int with milliseconds unit", () {
    final result = parser.parse("toDuration(500, 'ms')");
    expect(result.value.evaluate(Dependencies()), const Duration(milliseconds: 500));
  });

  test("Assert built-in toDuration from Duration passes through", () {
    final deps = Dependencies({"value": const Duration(hours: 3)});
    final result = parser.parse("toDuration(value)");
    expect(result.value.evaluate(deps), const Duration(hours: 3));
  });

  test("Assert built-in toDuration from string", () {
    final result = parser.parse("toDuration('5s')");
    expect(result.value.evaluate(Dependencies()), const Duration(seconds: 5));
  });

  test("Assert built-in toDuration with null returns null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("toDuration(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToDuration with valid string", () {
    final result = parser.parse("tryToDuration('10min')");
    expect(result.value.evaluate(Dependencies()), const Duration(minutes: 10));
  });

  test("Assert built-in tryToDuration with invalid returns null", () {
    final deps = Dependencies({"value": "not-a-duration"});
    final result = parser.parse("tryToDuration(value)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert built-in tryToDays with Duration", () {
    final deps = Dependencies({"dur": const Duration(days: 3)});
    final result = parser.parse("tryToDays(dur)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert built-in tryToHours with Duration", () {
    final deps = Dependencies({"dur": const Duration(hours: 4)});
    final result = parser.parse("tryToHours(dur)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert built-in tryToMinutes with Duration", () {
    final deps = Dependencies({"dur": const Duration(minutes: 45)});
    final result = parser.parse("tryToMinutes(dur)");
    expect(result.value.evaluate(deps), 45);
  });

  test("Assert built-in tryToSeconds with Duration", () {
    final deps = Dependencies({"dur": const Duration(seconds: 30)});
    final result = parser.parse("tryToSeconds(dur)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert built-in tryToMillis with Duration", () {
    final deps = Dependencies({"dur": const Duration(milliseconds: 500)});
    final result = parser.parse("tryToMillis(dur)");
    expect(result.value.evaluate(deps), 500);
  });

  // ==================================
  // getDynamicFunctionOn — num (isInfinite, isNaN)
  // ==================================

  test("Assert instance isInfinite on finite double returns false", () {
    final deps = Dependencies({"value": 42.0});
    final result = parser.parse("value.isInfinite()");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert instance isInfinite on infinity returns true", () {
    final deps = Dependencies({"value": double.infinity});
    final result = parser.parse("value.isInfinite()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isInfinite on negative infinity returns true", () {
    final deps = Dependencies({"value": double.negativeInfinity});
    final result = parser.parse("value.isInfinite()");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert instance isNaN on normal double returns false", () {
    final deps = Dependencies({"value": 42.0});
    final result = parser.parse("value.isNaN()");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert instance isNaN on NaN returns true", () {
    final deps = Dependencies({"value": double.nan});
    final result = parser.parse("value.isNaN()");
    expect(result.value.evaluate(deps), true);
  });

  // ==================================
  // getDynamicFunctionOn — List lastIndexOf
  // ==================================

  test("Assert instance lastIndexOf on list with duplicates", () {
    final deps = Dependencies({
      "items": [1, 2, 3, 2, 1],
    });
    final result = parser.parse("items.lastIndexOf(2)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert instance lastIndexOf on list with missing element returns -1", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("items.lastIndexOf(99)");
    expect(result.value.evaluate(deps), -1);
  });

  // ==================================
  // getDynamicFunctionOn — String replaceRange
  // ==================================

  test("Assert instance replaceRange on string", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("text.replaceRange(6, 11, 'Dart!')");
    expect(result.value.evaluate(deps), "Hello Dart!");
  });

  test("Assert instance replaceRange with empty replacement deletes range", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("text.replaceRange(5, 11, '')");
    expect(result.value.evaluate(deps), "Hello");
  });

  // ==================================
  // getDynamicFunctionOn — Set operations
  // ==================================

  test("Assert instance difference on sets", () {
    final deps = Dependencies({
      "a": {1, 2, 3, 4},
      "b": {3, 4, 5},
    });
    final result = parser.parse("a.difference(b)");
    expect(result.value.evaluate(deps), {1, 2});
  });

  test("Assert instance difference with no overlap returns original", () {
    final deps = Dependencies({
      "a": {1, 2, 3},
      "b": {4, 5, 6},
    });
    final result = parser.parse("a.difference(b)");
    expect(result.value.evaluate(deps), {1, 2, 3});
  });

  test("Assert instance intersection on sets", () {
    final deps = Dependencies({
      "a": {1, 2, 3, 4},
      "b": {3, 4, 5},
    });
    final result = parser.parse("a.intersection(b)");
    expect(result.value.evaluate(deps), {3, 4});
  });

  test("Assert instance intersection with no overlap returns empty", () {
    final deps = Dependencies({
      "a": {1, 2, 3},
      "b": {4, 5, 6},
    });
    final result = parser.parse("a.intersection(b)");
    expect(result.value.evaluate(deps), <int>{});
  });

  test("Assert instance union on sets", () {
    final deps = Dependencies({
      "a": {1, 2, 3},
      "b": {3, 4, 5},
    });
    final result = parser.parse("a.union(b)");
    expect(result.value.evaluate(deps), {1, 2, 3, 4, 5});
  });

  test("Assert instance union with empty set returns original", () {
    final deps = Dependencies({
      "a": {1, 2, 3},
      "b": <int>{},
    });
    final result = parser.parse("a.union(b)");
    expect(result.value.evaluate(deps), {1, 2, 3});
  });

  // ==================================
  // getDynamicFunctionOn — Map entries
  // ==================================

  test("Assert instance entries on map returns iterable of MapEntry", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"a": 1, "b": 2},
    });
    final result = parser.parse("data.entries()");
    final value = result.value.evaluate(deps);
    expect(value is Iterable, true);
    expect(value.length, 2);
  });

  test("Assert instance entries preserves keys and values", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"name": "Alice", "age": 30},
    });
    final result = parser.parse("data.entries()");
    final list = result.value.evaluate(deps).toList();
    expect(list.length, 2);
    expect(list[0].key, "name");
    expect(list[0].value, "Alice");
    expect(list[1].key, "age");
    expect(list[1].value, 30);
  });

  test("Assert instance entries on empty map returns empty iterable", () {
    final deps = Dependencies({"data": <String, dynamic>{}});
    final result = parser.parse("data.entries()");
    final value = result.value.evaluate(deps);
    expect(value.isEmpty, true);
    expect(value.length, 0);
  });

  test("Assert instance entries on single-entry map", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"only": "entry"},
    });
    final result = parser.parse("data.entries()");
    final list = result.value.evaluate(deps).toList();
    expect(list.length, 1);
    expect(list[0].key, "only");
    expect(list[0].value, "entry");
  });

  test("Assert instance entries on map with int keys", () {
    final deps = Dependencies({
      "data": <int, String>{1: "one", 2: "two", 3: "three"},
    });
    final result = parser.parse("data.entries()");
    final list = result.value.evaluate(deps).toList();
    expect(list.length, 3);
    expect(list[0].key, 1);
    expect(list[0].value, "one");
    expect(list[2].key, 3);
    expect(list[2].value, "three");
  });

  test("Assert instance entries on map with mixed value types", () {
    final deps = Dependencies({
      "data": <String, dynamic>{
        "str": "hello",
        "num": 42,
        "bool": true,
        "list": [1, 2, 3],
      },
    });
    final result = parser.parse("data.entries()");
    final list = result.value.evaluate(deps).toList();
    expect(list.length, 4);
    expect(list[0].value, "hello");
    expect(list[1].value, 42);
    expect(list[2].value, true);
    expect(list[3].value, [1, 2, 3]);
  });

  test("Assert instance entries length matches map length", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"a": 1, "b": 2, "c": 3, "d": 4, "e": 5},
    });
    final result = parser.parse("data.entries()");
    final value = result.value.evaluate(deps);
    expect(value.length, 5);
  });

  test("Assert instance entries can be iterated with values summed", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"x": 10, "y": 20, "z": 30},
    });
    final result = parser.parse("data.entries()");
    final entries = result.value.evaluate(deps);
    int total = 0;
    for (final entry in entries) {
      total += entry.value as int;
    }
    expect(total, 60);
  });

  test("Assert instance entries keys can be collected", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"first": 1, "second": 2, "third": 3},
    });
    final result = parser.parse("data.entries()");
    final entries = result.value.evaluate(deps);
    final keys = entries.map((e) => e.key).toList();
    expect(keys, ["first", "second", "third"]);
  });

  test("Assert instance entries values can be collected", () {
    final deps = Dependencies({
      "data": <String, dynamic>{"a": 100, "b": 200, "c": 300},
    });
    final result = parser.parse("data.entries()");
    final entries = result.value.evaluate(deps);
    final values = entries.map((e) => e.value).toList();
    expect(values, [100, 200, 300]);
  });

  // ==================================
  // registerMethodResolver — custom type method dispatch
  // ==================================

  test("Assert registered resolver provides method on custom type", () {
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverDoubled") {
        return () => source.value * 2;
      }
      return null;
    });
    final deps = Dependencies({"entity": _ResolverTestEntity(21)});
    final result = parser.parse("entity.resolverDoubled()");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert registered resolver supports method with arguments", () {
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverScale") {
        return (factor) => source.value * factor;
      }
      return null;
    });
    final deps = Dependencies({"entity": _ResolverTestEntity(7)});
    final result = parser.parse("entity.resolverScale(3)");
    expect(result.value.evaluate(deps), 21);
  });

  test("Assert registered resolver wraps getter in closure", () {
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverGetter") {
        return () => source.value;
      }
      return null;
    });
    final deps = Dependencies({"entity": _ResolverTestEntity(99)});
    final result = parser.parse("entity.resolverGetter()");
    expect(result.value.evaluate(deps), 99);
  });

  test("Assert built-in instance method wins over registered resolver", () {
    registerMethodResolver((name, source) {
      if (source is String && name == "toUpperCase") {
        return () => "RESOLVER_WINS";
      }
      return null;
    });
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("text.toUpperCase()");
    // Built-in toUpperCase wins, returns "HELLO" not "RESOLVER_WINS"
    expect(result.value.evaluate(deps), "HELLO");
  });

  test("Assert null-returning resolver falls through to next resolver", () {
    registerMethodResolver((name, source) => null);
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverChained") {
        return () => "found";
      }
      return null;
    });
    final deps = Dependencies({"entity": _ResolverTestEntity(0)});
    final result = parser.parse("entity.resolverChained()");
    expect(result.value.evaluate(deps), "found");
  });

  test("Assert resolvers invoked in registration order (first non-null wins)", () {
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverOrdered") {
        return () => "first";
      }
      return null;
    });
    registerMethodResolver((name, source) {
      if (source is _ResolverTestEntity && name == "resolverOrdered") {
        return () => "second";
      }
      return null;
    });
    final deps = Dependencies({"entity": _ResolverTestEntity(0)});
    final result = parser.parse("entity.resolverOrdered()");
    expect(result.value.evaluate(deps), "first");
  });

  test("Assert unresolvable method on custom type throws when no resolver matches", () {
    final deps = Dependencies({"entity": _ResolverTestEntity(0)});
    final result = parser.parse("entity.resolverUnknownXyz()");
    expect(() => result.value.evaluate(deps), throwsException);
  });
}
