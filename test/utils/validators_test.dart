import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/parser.dart';

void main() {
  final parser = ELParser();

  // ==================================
  // contains tests
  // ==================================

  test("Assert contains with string found", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("contains(text, 'World')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert contains with string not found", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("contains(text, 'xyz')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert contains with list found", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("contains(items, 2)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert contains with list not found", () {
    final deps = Dependencies({
      "items": [1, 2, 3],
    });
    final result = parser.parse("contains(items, 5)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert contains with set found", () {
    final deps = Dependencies({
      "items": {1, 2, 3},
    });
    final result = parser.parse("contains(items, 2)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert contains with null returns false", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("contains(value, 'x')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // containsKey tests
  // ==================================

  test("Assert containsKey with existing key", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("containsKey(data, 'a')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert containsKey with missing key", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("containsKey(data, 'c')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert containsKey with null map returns false", () {
    final deps = Dependencies({"data": null});
    final result = parser.parse("containsKey(data, 'a')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // containsValue tests
  // ==================================

  test("Assert containsValue with existing value", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("containsValue(data, 1)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert containsValue with missing value", () {
    final deps = Dependencies({
      "data": {"a": 1, "b": 2},
    });
    final result = parser.parse("containsValue(data, 5)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert containsValue with null map returns false", () {
    final deps = Dependencies({"data": null});
    final result = parser.parse("containsValue(data, 1)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // endsWith tests
  // ==================================

  test("Assert endsWith true", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("endsWith(text, 'lo')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert endsWith false", () {
    final deps = Dependencies({"text": "Hello"});
    final result = parser.parse("endsWith(text, 'He')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert endsWith with null returns false", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("endsWith(text, 'lo')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isBlank tests
  // ==================================

  test("Assert isBlank with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isBlank(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isBlank with empty string", () {
    final deps = Dependencies({"value": ""});
    final result = parser.parse("isBlank(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isBlank with whitespace only", () {
    final deps = Dependencies({"value": "   "});
    final result = parser.parse("isBlank(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isBlank with non-blank string", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isBlank(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isNotBlank tests
  // ==================================

  test("Assert isNotBlank with non-blank string", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNotBlank(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isNotBlank with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNotBlank(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isNotBlank with whitespace", () {
    final deps = Dependencies({"value": "   "});
    final result = parser.parse("isNotBlank(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isEmpty tests
  // ==================================

  test("Assert isEmpty with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isEmpty with empty string", () {
    final deps = Dependencies({"value": ""});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isEmpty with empty list", () {
    final deps = Dependencies({"value": []});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isEmpty with empty map", () {
    final deps = Dependencies({"value": <String, dynamic>{}});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isEmpty with empty set", () {
    final deps = Dependencies({"value": <int>{}});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isEmpty with non-empty string", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isEmpty with non-empty list", () {
    final deps = Dependencies({
      "value": [1],
    });
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isEmpty with unsupported type returns false", () {
    final deps = Dependencies({"value": 42});
    final result = parser.parse("isEmpty(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isNotEmpty tests
  // ==================================

  test("Assert isNotEmpty with non-empty string", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNotEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isNotEmpty with non-empty list", () {
    final deps = Dependencies({
      "value": [1, 2],
    });
    final result = parser.parse("isNotEmpty(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isNotEmpty with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNotEmpty(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isNotEmpty with empty list", () {
    final deps = Dependencies({"value": []});
    final result = parser.parse("isNotEmpty(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isNull tests
  // ==================================

  test("Assert isNull with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isNull with non-null", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNull(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isNull with unset reference", () {
    final result = parser.parse("isNull(missing)");
    expect(result.value.evaluate(Dependencies()), true);
  });

  // ==================================
  // isNotNull tests
  // ==================================

  test("Assert isNotNull with non-null", () {
    final deps = Dependencies({"value": "hello"});
    final result = parser.parse("isNotNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isNotNull with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isNotNull(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isTrue tests
  // ==================================

  test("Assert isTrue with true", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("isTrue(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isTrue with false", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("isTrue(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isTrue with non-zero int", () {
    final deps = Dependencies({"value": 1});
    final result = parser.parse("isTrue(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isTrue with zero int", () {
    final deps = Dependencies({"value": 0});
    final result = parser.parse("isTrue(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isTrue with string 'true'", () {
    final deps = Dependencies({"value": "true"});
    final result = parser.parse("isTrue(value)");
    expect(result.value.evaluate(deps), true);
  });

  // ==================================
  // isTrueOrNull tests
  // ==================================

  test("Assert isTrueOrNull with true", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("isTrueOrNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isTrueOrNull with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isTrueOrNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isTrueOrNull with false", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("isTrueOrNull(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isFalse tests
  // ==================================

  test("Assert isFalse with false", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("isFalse(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isFalse with true", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("isFalse(value)");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert isFalse with zero int", () {
    final deps = Dependencies({"value": 0});
    final result = parser.parse("isFalse(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isFalse with non-zero int", () {
    final deps = Dependencies({"value": 1});
    final result = parser.parse("isFalse(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // isFalseOrNull tests
  // ==================================

  test("Assert isFalseOrNull with false", () {
    final deps = Dependencies({"value": false});
    final result = parser.parse("isFalseOrNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isFalseOrNull with null", () {
    final deps = Dependencies({"value": null});
    final result = parser.parse("isFalseOrNull(value)");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert isFalseOrNull with true", () {
    final deps = Dependencies({"value": true});
    final result = parser.parse("isFalseOrNull(value)");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // matches tests
  // ==================================

  test("Assert matches full string match", () {
    final deps = Dependencies({"text": "abc123"});
    final result = parser.parse("matches(text, '[a-z]+[0-9]+')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert matches partial does not match", () {
    final deps = Dependencies({"text": "abc123xyz"});
    final result = parser.parse("matches(text, '[a-z]+[0-9]+')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert matches with email pattern", () {
    final deps = Dependencies({"email": "test@example.com"});
    final result = parser.parse("matches(email, '[a-zA-Z0-9.]+@[a-zA-Z0-9.]+')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert matches with null returns false", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("matches(text, '[a-z]+')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert matches with digits only", () {
    final deps = Dependencies({"text": "12345"});
    final result = parser.parse("matches(text, '[0-9]+')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert matches fails with non-matching pattern", () {
    final deps = Dependencies({"text": "hello"});
    final result = parser.parse("matches(text, '[0-9]+')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // startsWith tests
  // ==================================

  test("Assert startsWith true", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("startsWith(text, 'Hello')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert startsWith false", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("startsWith(text, 'World')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert startsWith with null returns false", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("startsWith(text, 'He')");
    expect(result.value.evaluate(deps), false);
  });

  // ==================================
  // endsWith tests
  // ==================================

  test("Assert endsWith true", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("endsWith(text, 'World')");
    expect(result.value.evaluate(deps), true);
  });

  test("Assert endsWith false", () {
    final deps = Dependencies({"text": "Hello World"});
    final result = parser.parse("endsWith(text, 'Hello')");
    expect(result.value.evaluate(deps), false);
  });

  test("Assert endsWith with null returns false", () {
    final deps = Dependencies({"text": null});
    final result = parser.parse("endsWith(text, 'lo')");
    expect(result.value.evaluate(deps), false);
  });
}
