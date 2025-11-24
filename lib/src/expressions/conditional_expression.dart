import '../dependencies.dart';
import 'expression.dart';

/// Represents a conditional (ternary) expression in the expression language.
///
/// A conditional expression evaluates a [condition] and returns either
/// [trueValue] or [falseValue] depending on the result.
///
/// This is equivalent to the ternary operator in Dart:
/// ```dart
/// condition ? trueValue : falseValue
/// ```
///
/// Evaluation rules:
/// - The [condition] must evaluate to a `bool`.
/// - If [condition] evaluates to `true`, the [trueValue] expression is evaluated and returned.
/// - If [condition] evaluates to `false`, the [falseValue] expression is evaluated and returned.
/// - Throws an [Exception] if [condition] does not evaluate to a boolean.
class ConditionalExpression<T> extends Expression<T> {
  Expression<bool> condition;
  Expression<T> trueValue;
  Expression<T> falseValue;

  ConditionalExpression(this.condition, this.trueValue, this.falseValue);

  @override
  T evaluate(Dependencies dependencies) {
    return condition.evaluate(dependencies)
        ? trueValue.evaluate(dependencies)
        : falseValue.evaluate(dependencies);
  }
}
