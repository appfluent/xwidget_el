import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/model/brackets.dart';

void main() {
  test('Assert setValue is fast', () {
    final data = <String, dynamic>{};
    final start = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < 1000000; i++) {
      data.setValue("topicsFollowed.top_news", true);
    }
    final millis = DateTime.now().millisecondsSinceEpoch - start;
    expect(data, {
      'topicsFollowed': {'top_news': true},
    });
    // loose bound: catches pathological regressions, not machine variance
    expect(millis, lessThan(30000));
  });

  test('Assert getValue is fast', () {
    final data = <String, dynamic>{};
    data.setValue("topicsFollowed.top_news.fun.fun", true);
    final start = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < 1000000; i++) {
      data.getValue("topicsFollowed.top_news.fun.fun");
    }
    final millis = DateTime.now().millisecondsSinceEpoch - start;
    expect(data.getValue("topicsFollowed.top_news.fun.fun"), true);
    // loose bound: catches pathological regressions, not machine variance
    expect(millis, lessThan(30000));
  });
}
