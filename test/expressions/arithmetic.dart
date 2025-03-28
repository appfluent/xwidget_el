import 'package:flutter_test/flutter_test.dart';
import 'package:xwidget_el/src/expressions/addition.dart';
import 'package:xwidget_el/src/expressions/division.dart';
import 'package:xwidget_el/src/expressions/integer_division.dart';
import 'package:xwidget_el/src/expressions/modulo.dart';
import 'package:xwidget_el/src/expressions/multiplication.dart';
import 'package:xwidget_el/src/expressions/subtraction.dart';
import 'package:xwidget_el/xwidget_el.dart';


main() {

  // addition
  final dependencies = Dependencies();

  test('Assert + implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = AdditionExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left + right"));
  });

  test('Assert string concatenation', () {
    final exp = AdditionExpression("left", "right");
    expect(exp.evaluate(dependencies), "leftright");
  });

  test('Assert Duration + DateTime addition', () {
    const left = Duration(seconds: 10);
    final right = DateTime.parse("2000-01-01 00:00:00");
    final exp = AdditionExpression(left, right);
    expect(exp.evaluate(dependencies), DateTime.parse("2000-01-01 00:00:10"));
  });

  test('Assert DateTime + Duration addition', () {
    final left = DateTime.parse("2000-01-01 00:00:00");
    const right = Duration(seconds: 10);
    final exp = AdditionExpression(left, right);
    expect(exp.evaluate(dependencies), DateTime.parse("2000-01-01 00:00:10"));
  });

  // subtraction

  test('Assert - implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = SubtractionExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left - right"));
  });

  test('Assert DateTime - Duration subtraction', () {
    final left = DateTime.parse("2000-01-01 00:00:00");
    const right = Duration(seconds: 10);
    final exp = SubtractionExpression(left, right);
    expect(exp.evaluate(dependencies), DateTime.parse("1999-12-31 23:59:50"));
  });

  // multiplication

  test('Assert * implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = MultiplicationExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left * right"));
  });

  test('Assert int * Duration multiplication', () {
    const left = 2;
    const right = Duration(seconds: 10);
    final exp = MultiplicationExpression(left, right);
    expect(exp.evaluate(dependencies), const Duration(seconds: 20));
  });

  test('Assert Duration * int multiplication', () {
    const left = Duration(seconds: 10);
    const right = 3;
    final exp = MultiplicationExpression(left, right);
    expect(exp.evaluate(dependencies), const Duration(seconds: 30));
  });

  test('Assert double * Duration multiplication', () {
    const left = 2.5;
    const right = Duration(seconds: 10);
    final exp = MultiplicationExpression(left, right);
    expect(exp.evaluate(dependencies), const Duration(seconds: 25));
  });

  test('Assert Duration * double multiplication', () {
    const left = Duration(seconds: 10);
    const right = 3.5;
    final exp = MultiplicationExpression(left, right);
    expect(exp.evaluate(dependencies), const Duration(seconds: 35));
  });

  // division

  test('Assert / implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = DivisionExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left / right"));
  });

  test('Assert Duration / int division', () {
    const left = Duration(seconds: 10);
    const right = 3;
    final exp = DivisionExpression(left, right);
    expect(exp.evaluate(dependencies), const Duration(microseconds: 3333333));
  });

  // modulo

  test('Assert % implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = ModuloExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left % right"));
  });

  // integer division

  test('Assert ~/ implementation', () {
    final left = Arithmetic("left");
    final right = Arithmetic("right");
    final exp = IntegerDivisionExpression(left, right);
    expect(exp.evaluate(dependencies), Arithmetic("left ~/ right"));
  });
}

class Arithmetic {
  final String value;

  Arithmetic(this.value);

  Arithmetic operator +(Arithmetic right) {
    return Arithmetic("$value + ${right.value}");
  }

  Arithmetic operator -(Arithmetic right) {
    return Arithmetic("$value - ${right.value}");
  }

  Arithmetic operator *(Arithmetic right) {
    return Arithmetic("$value * ${right.value}");
  }

  Arithmetic operator /(Arithmetic right) {
    return Arithmetic("$value / ${right.value}");
  }

  Arithmetic operator %(Arithmetic right) {
    return Arithmetic("$value % ${right.value}");
  }

  Arithmetic operator ~/(Arithmetic right) {
    return Arithmetic("$value ~/ ${right.value}");
  }

  @override
  String toString() {
    return 'Arithmetic{value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Arithmetic &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}