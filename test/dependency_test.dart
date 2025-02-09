import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/dependencies.dart';


void main() {
  test('Test map inside list', () {
    final deps = Dependencies();
    deps.setValue("users[0].name", "chris");
    expect(deps.getValue("users"), [{"name":"chris"}] );
  });

  test('Test map inside filled list', () {
    final deps = Dependencies();
    deps.setValue("users[2].name", "chris");
    expect(deps.getValue("users"), [null, null, {"name":"chris"}] );
  });

  test('Test listen for changes on list item', () {
    final deps = Dependencies();
    deps.setValue("users[0].first", "chris");
    deps.setValue("users[0].last", "jones");

    var changed = false;
    final notifier = deps.listenForChanges("users[0]");
    notifier.addListener(() => changed = true);
    deps.setValue("users[0].first", "mike");

    expect(changed, true);
    expect(deps.getValue("users[0].first"), "mike");
  });

  test('Test bracket operator with dot notation', () {
    final deps = Dependencies();
    deps["user.id"] = 123;
    deps["user.name"] = "chris";
    expect(deps["user"], null);
    expect(deps["user.id"], 123);
  });

  test('Test map create from individual calls', () {
    final deps = Dependencies();
    deps.setValue("user.id", 123);
    deps.setValue("user.name", "chris");
    expect(deps.getValue("user"), {"id":123, "name":"chris"});
  });

  test('Test global map create from individual calls', () {
    final deps = Dependencies();
    deps.setValue("global.user.id", 123);
    deps.setValue("global.user.name", "chris");
    expect(deps.getValue("global.user"), {"id":123, "name":"chris"});
    deps.removeValue("global.user");
  });

  test('Test formatted data', () {
    final deps = Dependencies();
    deps.setValue("user.id", 123);
    deps.setValue("user.name", "chris");
    expect(deps.toString(), '{\n'
        '  "data": {\n'
        '    "user": {\n'
        '      "id": 123,\n'
        '      "name": "chris"\n'
        '    }\n'
        '  },\n'
        '  "global": {}\n'
        '}');
  });
}