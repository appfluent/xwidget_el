import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/parser.dart';
import 'package:xwidget_el/src/utils/misc.dart';

void main() {
  final parser = ELParser();

  // ==================================
  // deepEquals tests
  // ==================================

  test("Assert deepEquals with identical primitives", () {
    expect(deepEquals(42, 42), true);
    expect(deepEquals("hello", "hello"), true);
    expect(deepEquals(true, true), true);
  });

  test("Assert deepEquals with different primitives", () {
    expect(deepEquals(42, 43), false);
    expect(deepEquals("hello", "world"), false);
    expect(deepEquals(true, false), false);
  });

  test("Assert deepEquals with different types", () {
    expect(deepEquals(42, "42"), false);
    expect(deepEquals(1, true), false);
  });

  test("Assert deepEquals with flat maps", () {
    expect(deepEquals({"a": 1, "b": 2}, {"a": 1, "b": 2}), true);
    expect(deepEquals({"a": 1, "b": 2}, {"a": 1, "b": 3}), false);
    expect(deepEquals({"a": 1}, {"a": 1, "b": 2}), false);
  });

  test("Assert deepEquals with nested maps", () {
    final map1 = {
      "a": {
        "b": {"c": 1},
      },
    };
    final map2 = {
      "a": {
        "b": {"c": 1},
      },
    };
    final map3 = {
      "a": {
        "b": {"c": 2},
      },
    };
    expect(deepEquals(map1, map2), true);
    expect(deepEquals(map1, map3), false);
  });

  test("Assert deepEquals with flat lists", () {
    expect(deepEquals([1, 2, 3], [1, 2, 3]), true);
    expect(deepEquals([1, 2, 3], [1, 2, 4]), false);
    expect(deepEquals([1, 2], [1, 2, 3]), false);
  });

  test("Assert deepEquals with nested lists", () {
    expect(
      deepEquals(
        [
          1,
          [
            2,
            [3],
          ],
        ],
        [
          1,
          [
            2,
            [3],
          ],
        ],
      ),
      true,
    );
    expect(
      deepEquals(
        [
          1,
          [
            2,
            [3],
          ],
        ],
        [
          1,
          [
            2,
            [4],
          ],
        ],
      ),
      false,
    );
  });

  test("Assert deepEquals with sets", () {
    expect(deepEquals({1, 2, 3}, {1, 2, 3}), true);
    expect(deepEquals({1, 2, 3}, {1, 2, 4}), false);
    expect(deepEquals({1, 2}, {1, 2, 3}), false);
  });

  test("Assert deepEquals with mixed nested structures", () {
    final obj1 = {
      "list": [1, 2],
      "set": {3, 4},
      "map": {"a": 5},
    };
    final obj2 = {
      "list": [1, 2],
      "set": {3, 4},
      "map": {"a": 5},
    };
    final obj3 = {
      "list": [1, 2],
      "set": {3, 4},
      "map": {"a": 6},
    };
    expect(deepEquals(obj1, obj2), true);
    expect(deepEquals(obj1, obj3), false);
  });

  test("Assert deepEquals with identical references", () {
    final obj = {
      "a": [1, 2, 3],
    };
    expect(deepEquals(obj, obj), true);
  });

  // ==================================
  // deepHashCode tests
  // ==================================

  test("Assert deepHashCode equal for identical structures", () {
    final hash1 = deepHashCode({
      "a": 1,
      "b": [2, 3],
    });
    final hash2 = deepHashCode({
      "a": 1,
      "b": [2, 3],
    });
    expect(hash1, hash2);
  });

  test("Assert deepHashCode different for different structures", () {
    final hash1 = deepHashCode({
      "a": 1,
      "b": [2, 3],
    });
    final hash2 = deepHashCode({
      "a": 1,
      "b": [2, 4],
    });
    expect(hash1 != hash2, true);
  });

  test("Assert deepHashCode with nested maps", () {
    final hash1 = deepHashCode({
      "a": {
        "b": {"c": 1},
      },
    });
    final hash2 = deepHashCode({
      "a": {
        "b": {"c": 1},
      },
    });
    expect(hash1, hash2);
  });

  test("Assert deepHashCode with sets", () {
    final hash1 = deepHashCode({1, 2, 3});
    final hash2 = deepHashCode({1, 2, 3});
    expect(hash1, hash2);
  });

  test("Assert deepHashCode with primitives", () {
    expect(deepHashCode(42), 42.hashCode);
    expect(deepHashCode("hello"), "hello".hashCode);
  });

  // ==================================
  // diffDateTime tests (EL)
  // ==================================

  test("Assert diffDateTime returns positive duration", () {
    final deps = Dependencies({"date1": DateTime(2026, 4, 1), "date2": DateTime(2026, 3, 31)});
    final result = parser.parse("diffDateTime(date1, date2)");
    expect(result.value.evaluate(deps), const Duration(days: 1));
  });

  test("Assert diffDateTime returns absolute value when reversed", () {
    final deps = Dependencies({"date1": DateTime(2026, 3, 31), "date2": DateTime(2026, 4, 1)});
    final result = parser.parse("diffDateTime(date1, date2)");
    expect(result.value.evaluate(deps), const Duration(days: 1));
  });

  test("Assert diffDateTime returns zero for same date", () {
    final deps = Dependencies({
      "date1": DateTime(2026, 4, 1, 12, 0),
      "date2": DateTime(2026, 4, 1, 12, 0),
    });
    final result = parser.parse("diffDateTime(date1, date2)");
    expect(result.value.evaluate(deps), Duration.zero);
  });

  test("Assert diffDateTime with hours difference", () {
    final deps = Dependencies({
      "date1": DateTime(2026, 4, 1, 15, 0),
      "date2": DateTime(2026, 4, 1, 12, 0),
    });
    final result = parser.parse("diffDateTime(date1, date2)");
    expect(result.value.evaluate(deps), const Duration(hours: 3));
  });

  // ==================================
  // first tests (EL)
  // ==================================

  test("Assert first returns first element of list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("first(items)");
    expect(result.value.evaluate(deps), 10);
  });

  test("Assert first returns first element of set", () {
    final deps = Dependencies({
      "items": {42},
    });
    final result = parser.parse("first(items)");
    expect(result.value.evaluate(deps), 42);
  });

  test("Assert first throws for unsupported type", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("first(value)");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  // ==================================
  // last tests (EL)
  // ==================================

  test("Assert last returns last element of list", () {
    final deps = Dependencies({
      "items": [10, 20, 30],
    });
    final result = parser.parse("last(items)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert last returns last element of set", () {
    final deps = Dependencies({
      "items": {10, 20, 30},
    });
    final result = parser.parse("last(items)");
    expect(result.value.evaluate(deps), 30);
  });

  test("Assert last throws for unsupported type", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("last(value)");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  // ==================================
  // length tests (EL)
  // ==================================

  test("Assert length of string", () {
    final result = parser.parse("length('hello')");
    expect(result.value.evaluate(Dependencies()), 5);
  });

  test("Assert length of list", () {
    final deps = Dependencies({
      "items": [1, 2, 3, 4],
    });
    final result = parser.parse("length(items)");
    expect(result.value.evaluate(deps), 4);
  });

  test("Assert length of map", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("length(data)");
    expect(result.value.evaluate(deps), 2);
  });

  test("Assert length of set", () {
    final deps = Dependencies({
      "items": {1, 2, 3},
    });
    final result = parser.parse("length(items)");
    expect(result.value.evaluate(deps), 3);
  });

  test("Assert length of empty list", () {
    final deps = Dependencies({"items": []});
    final result = parser.parse("length(items)");
    expect(result.value.evaluate(deps), 0);
  });

  test("Assert length throws for unsupported type", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("length(value)");
    expect(() => result.value.evaluate(deps), throwsException);
  });

  // ==================================
  // mapsEqual tests
  // ==================================

  test("Assert mapsEqual with identical maps", () {
    expect(mapsEqual({"a": 1, "b": 2}, {"a": 1, "b": 2}), true);
  });

  test("Assert mapsEqual with different values", () {
    expect(mapsEqual({"a": 1, "b": 2}, {"a": 1, "b": 3}), false);
  });

  test("Assert mapsEqual with different keys", () {
    expect(mapsEqual({"a": 1, "b": 2}, {"a": 1, "c": 2}), false);
  });

  test("Assert mapsEqual with different lengths", () {
    expect(mapsEqual({"a": 1}, {"a": 1, "b": 2}), false);
  });

  test("Assert mapsEqual with empty maps", () {
    expect(mapsEqual({}, {}), true);
  });

  test("Assert mapsEqual is shallow (nested maps not deep compared)", () {
    final map1 = {
      "a": {"b": 1},
    };
    final map2 = {
      "a": {"b": 1},
    };
    // Shallow comparison — inner maps are different instances
    expect(mapsEqual(map1, map2), false);
  });

  // ==================================
  // replaceAll tests (EL)
  // ==================================

  test("Assert replaceAll replaces all matches", () {
    final deps = Dependencies({"text": "foo bar foo"});
    final result = parser.parse("replaceAll(text, 'foo', 'baz')");
    expect(result.value.evaluate(deps), "baz bar baz");
  });

  test("Assert replaceAll with regex pattern", () {
    final deps = Dependencies({"text": "abc 123 def 456"});
    final result = parser.parse(r"replaceAll(text, '[0-9]+', '#')");
    expect(result.value.evaluate(deps), "abc # def #");
  });

  test("Assert replaceAll with no matches returns original", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("replaceAll(text, 'xyz', 'abc')");
    expect(result.value.evaluate(deps), "hello");
  });

  test("Assert replaceAll with null returns null", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("replaceAll(text, 'a', 'b')");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // replaceFirst tests (EL)
  // ==================================

  test("Assert replaceFirst replaces only first match", () {
    final deps = Dependencies({"text": "foo bar foo"});
    final result = parser.parse("replaceFirst(text, 'foo', 'baz')");
    expect(result.value.evaluate(deps), "baz bar foo");
  });

  test("Assert replaceFirst with regex pattern", () {
    final deps = Dependencies({"text": "abc 123 def 456"});
    final result = parser.parse(r"replaceFirst(text, '[0-9]+', '#')");
    expect(result.value.evaluate(deps), "abc # def 456");
  });

  test("Assert replaceFirst with no match returns original", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("replaceFirst(text, 'xyz', 'abc')");
    expect(result.value.evaluate(deps), "hello");
  });

  test("Assert replaceFirst with null returns null", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("replaceFirst(text, 'a', 'b')");
    expect(result.value.evaluate(deps), null);
  });

  // ==================================
  // substring tests (EL)
  // ==================================

  test("Assert substring with start and end", () {
    final result = parser.parse("substring('Hello World', 0, 5)");
    expect(result.value.evaluate(Dependencies()), "Hello");
  });

  test("Assert substring with start only", () {
    final result = parser.parse("substring('Hello World', 6)");
    expect(result.value.evaluate(Dependencies()), "World");
  });

  test("Assert substring with end beyond length uses full length", () {
    final result = parser.parse("substring('Hello', 0, 100)");
    expect(result.value.evaluate(Dependencies()), "Hello");
  });

  test("Assert substring with -1 end uses full length", () {
    final result = parser.parse("substring('Hello World', 6, -1)");
    expect(result.value.evaluate(Dependencies()), "World");
  });

  test("Assert substring with null returns null", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("substring(text, 0, 5)");
    expect(result.value.evaluate(deps), null);
  });

  test("Assert substring single character", () {
    final result = parser.parse("substring('ABCDE', 2, 3)");
    expect(result.value.evaluate(Dependencies()), "C");
  });

  // ==================================
  // now tests (EL)
  // ==================================

  test("Assert now returns current DateTime", () {
    final before = DateTime.now();
    final result = parser.parse("now()");
    final value = result.value.evaluate(Dependencies());
    final after = DateTime.now();
    expect(value is DateTime, true);
    expect(value.isAfter(before) || value.isAtSameMomentAs(before), true);
    expect(value.isBefore(after) || value.isAtSameMomentAs(after), true);
  });

  test("Assert now returns local time (not UTC)", () {
    final result = parser.parse("now()");
    final value = result.value.evaluate(Dependencies()) as DateTime;
    expect(value.isUtc, false);
  });

  // ==================================
  // nowUtc tests (EL)
  // ==================================

  test("Assert nowUtc returns UTC DateTime", () {
    final result = parser.parse("nowUtc()");
    final value = result.value.evaluate(Dependencies()) as DateTime;
    expect(value.isUtc, true);
  });

  test("Assert nowUtc is close to now", () {
    final before = DateTime.now().toUtc();
    final result = parser.parse("nowUtc()");
    final value = result.value.evaluate(Dependencies()) as DateTime;
    final after = DateTime.now().toUtc();
    expect(value.isAfter(before) || value.isAtSameMomentAs(before), true);
    expect(value.isBefore(after) || value.isAtSameMomentAs(after), true);
  });

  // ==================================
  // nonNullType tests
  // ==================================

  test("Assert nonNullType strips nullable suffix", () {
    expect(nonNullType(String), "String");
  });

  test("Assert nonNullType with non-nullable type returns same", () {
    expect(nonNullType(int), "int");
  });

  // ==================================
  // typeOf tests
  // ==================================

  test("Assert typeOf returns correct type", () {
    expect(typeOf<String>(), String);
    expect(typeOf<int>(), int);
    expect(typeOf<List<String>>(), List<String>);
  });
}
