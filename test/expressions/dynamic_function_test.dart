import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/expressions/dynamic_function.dart';
import 'package:xwidget_el/src/parser.dart';

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
}
