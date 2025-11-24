import '../dependencies.dart';
import 'expression.dart';

/// Represents a constant value in the expression language.
///
/// A [ConstantExpression] always evaluates to the same value, regardless
/// of any [Dependencies] provided. It is useful for representing literal
/// values such as numbers, strings, or booleans in parsed expressions.
///
/// Example:
/// ```dart
/// final expr = ConstantExpression<int>(42);
/// print(expr.evaluate(dependencies)); // -> 42
/// ```
class ConstantExpression<T> extends Expression<T> {
  final T value;

  ConstantExpression(this.value);

  @override
  T evaluate(Dependencies dependencies) {
    return value;
  }
}
