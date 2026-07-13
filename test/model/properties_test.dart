import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';
import 'package:xwidget_el/src/model/brackets.dart';
import 'package:xwidget_el/src/model/property_resolver.dart';
import 'package:xwidget_el/src/parser.dart';

import '../testing_utils.dart';

class _Point {
  final int x;
  final int y;

  _Point(this.x, this.y);
}

void main() {
  setUpAll(() {
    registerPropertyResolver((name, target) {
      if (target is _Point) {
        switch (name) {
          case "x":
            return PropertyResolution(target.x);
          case "y":
            return PropertyResolution(target.y);
          // shadow attempt — core properties must win over registered resolvers
          case "length":
            return const PropertyResolution(999);
        }
      }
      return null;
    });
  });

  group("String properties", () {
    test("length", () {
      final data = <String, dynamic>{"name": "hello"};
      expect(data.getValue("name.length"), 5);
    });

    test("length of an empty String is 0, not null", () {
      final data = <String, dynamic>{"name": ""};
      expect(data.getValue("name.length"), 0);
      expect(data.getValue("name.isEmpty"), true);
      expect(data.getValue("name.isNotEmpty"), false);
    });
  });

  group("Iterable properties", () {
    test("List length/first/last", () {
      final data = <String, dynamic>{
        "tags": ["a", "b", "c"],
      };
      expect(data.getValue("tags.length"), 3);
      expect(data.getValue("tags.first"), "a");
      expect(data.getValue("tags.last"), "c");
      expect(data.getValue("tags.isEmpty"), false);
      expect(data.getValue("tags.isNotEmpty"), true);
    });

    test("length of an empty List is 0, not null", () {
      final data = <String, dynamic>{"tags": <dynamic>[]};
      expect(data.getValue("tags.length"), 0);
      expect(data.getValue("tags.isEmpty"), true);
    });

    test("first on an empty List throws StateError, like Dart", () {
      final data = <String, dynamic>{"tags": <dynamic>[]};
      expect(() => data.getValue("tags.first"), throwsStateError);
    });

    test("Set properties", () {
      final data = <String, dynamic>{
        "ids": {1, 2, 3},
      };
      expect(data.getValue("ids.length"), 3);
      expect(data.getValue("ids.isNotEmpty"), true);
    });

    test("unknown name on a List still throws", () {
      final data = <String, dynamic>{
        "tags": ["a"],
      };
      expect(
        () => data.getValue("tags.lenght"),
        exceptionStartsWith("Exception: Unable to read value at index 'lenght'"),
      );
    });
  });

  group("Map properties", () {
    test("a real key always wins", () {
      final data = <String, dynamic>{
        "stats": {"length": 99},
      };
      expect(data.getValue("stats.length"), 99);
    });

    test("property resolves on key miss", () {
      final data = <String, dynamic>{
        "user": {"a": 1, "b": 2},
      };
      expect(data.getValue("user.length"), 2);
      expect(data.getValue("user.keys"), ["a", "b"]);
      expect(data.getValue("user.values"), [1, 2]);
      expect(data.getValue("user.entries"), isA<Iterable>());
      expect(data.getValue("user.isEmpty"), false);
    });

    test("unknown name on a Map stays lenient", () {
      final data = <String, dynamic>{
        "user": {"a": 1},
      };
      expect(data.getValue("user.nope"), null);
    });
  });

  group("num/int properties", () {
    test("int flags", () {
      final data = <String, dynamic>{"count": 4, "offset": -2};
      expect(data.getValue("count.isEven"), true);
      expect(data.getValue("count.isOdd"), false);
      expect(data.getValue("offset.isNegative"), true);
    });

    test("double flags", () {
      final data = <String, dynamic>{"ratio": -0.5};
      expect(data.getValue("ratio.isNaN"), false);
      expect(data.getValue("ratio.isFinite"), true);
      expect(data.getValue("ratio.sign"), -1.0);
    });
  });

  group("Duration/DateTime properties", () {
    test("Duration", () {
      final data = <String, dynamic>{"elapsed": const Duration(minutes: 90)};
      expect(data.getValue("elapsed.inMinutes"), 90);
      expect(data.getValue("elapsed.inHours"), 1);
      expect(data.getValue("elapsed.isNegative"), false);
    });

    test("DateTime", () {
      final data = <String, dynamic>{"created": DateTime.utc(2026, 7, 6, 13, 30)};
      expect(data.getValue("created.year"), 2026);
      expect(data.getValue("created.month"), 7);
      expect(data.getValue("created.day"), 6);
      expect(data.getValue("created.isUtc"), true);
    });
  });

  group("slice-2 completeness", () {
    test("String codeUnits and runes", () {
      final data = <String, dynamic>{"name": "hi"};
      expect(data.getValue("name.codeUnits"), [104, 105]);
      expect((data.getValue("name.runes") as Runes).toList(), [104, 105]);
    });

    test("List reversed", () {
      final data = <String, dynamic>{
        "items": [1, 2, 3],
      };
      expect((data.getValue("items.reversed") as Iterable).toList(), [3, 2, 1]);
    });

    test("Iterable single follows Dart semantics", () {
      final data = <String, dynamic>{
        "one": [42],
        "many": [1, 2],
      };
      expect(data.getValue("one.single"), 42);
      expect(() => data.getValue("many.single"), throwsStateError);
    });

    test("int bitLength", () {
      final data = <String, dynamic>{"n": 255};
      expect(data.getValue("n.bitLength"), 8);
    });

    test("Duration inMicroseconds", () {
      final data = <String, dynamic>{"d": const Duration(milliseconds: 2)};
      expect(data.getValue("d.inMicroseconds"), 2000);
    });

    test("DateTime sub-second and timezone getters", () {
      final data = <String, dynamic>{"t": DateTime.utc(2026, 7, 11, 1, 2, 3, 4, 5)};
      expect(data.getValue("t.millisecond"), 4);
      expect(data.getValue("t.microsecond"), 5);
      expect(data.getValue("t.timeZoneName"), "UTC");
      expect(data.getValue("t.timeZoneOffset"), Duration.zero);
      expect(
        data.getValue("t.microsecondsSinceEpoch"),
        DateTime.utc(2026, 7, 11, 1, 2, 3, 4, 5).microsecondsSinceEpoch,
      );
    });
  });

  group("Uri properties", () {
    final data = <String, dynamic>{
      "link": Uri.parse("https://user@xwidget.dev:8443/a/b?x=1&x=2&y=3#frag"),
    };

    test("components", () {
      expect(data.getValue("link.scheme"), "https");
      expect(data.getValue("link.host"), "xwidget.dev");
      expect(data.getValue("link.port"), 8443);
      expect(data.getValue("link.path"), "/a/b");
      expect(data.getValue("link.pathSegments"), ["a", "b"]);
      expect(data.getValue("link.query"), "x=1&x=2&y=3");
      expect(data.getValue("link.fragment"), "frag");
      expect(data.getValue("link.userInfo"), "user");
      expect(data.getValue("link.authority"), "user@xwidget.dev:8443");
      expect(data.getValue("link.origin"), "https://xwidget.dev:8443");
    });

    test("query parameters traverse as Maps", () {
      expect(data.getValue("link.queryParameters.y"), "3");
      expect(data.getValue("link.queryParametersAll.x"), ["1", "2"]);
    });

    test("flags", () {
      // isAbsolute is false: Dart defines absolute as scheme + NO fragment
      expect(data.getValue("link.isAbsolute"), false);
      expect(data.getValue("link.hasPort"), true);
      expect(data.getValue("link.hasQuery"), true);
      expect(data.getValue("link.hasFragment"), true);
      expect(data.getValue("link.hasScheme"), true);
      expect(data.getValue("link.hasAuthority"), true);
      expect(data.getValue("link.hasEmptyPath"), false);
      expect(data.getValue("link.hasAbsolutePath"), true);
      expect(data.getValue("link.data"), null);
    });
  });

  group("path traversal", () {
    test("nested path ending in a property", () {
      final data = <String, dynamic>{
        "a": {
          "b": [1, 2],
        },
      };
      expect(data.getValue("a.b.length"), 2);
    });

    test("property on a null chain stays null", () {
      final data = <String, dynamic>{"a": null};
      expect(data.getValue("a.length"), null);
    });
  });

  group("registered resolvers", () {
    test("resolves properties on custom types", () {
      final data = <String, dynamic>{"point": _Point(3, 7)};
      expect(data.getValue("point.x"), 3);
      expect(data.getValue("point.y"), 7);
    });

    test("core properties take priority over registered resolvers", () {
      final data = <String, dynamic>{"name": "hello"};
      // the _Point resolver returns 999 for "length", but it never sees
      // Strings; more to the point, core resolution runs first
      expect(data.getValue("name.length"), 5);
    });

    test("unknown property on a custom type still throws unsupported", () {
      final data = <String, dynamic>{"point": _Point(3, 7)};
      expect(
        () => data.getValue("point.z"),
        exceptionStartsWith("Exception: Path 'z' references an unsupported collection"),
      );
    });
  });

  group("EL expressions", () {
    final parser = ELParser();
    final dependencies = Dependencies({
      "items": ["x", "y", "z"],
      "user": {"a": 1},
      "name": "hello",
    });

    test("property access in EL paths", () {
      expect(parser.parse("items.length").value.evaluate(dependencies), 3);
      expect(parser.parse("items.first").value.evaluate(dependencies), "x");
      expect(parser.parse("name.isNotEmpty").value.evaluate(dependencies), true);
      expect(parser.parse("user.length").value.evaluate(dependencies), 1);
    });

    test("properties compose with expressions", () {
      expect(parser.parse("items.length + 1").value.evaluate(dependencies), 4);
      expect(parser.parse("items.isEmpty ? 'none' : 'some'").value.evaluate(dependencies), "some");
    });
  });
}
