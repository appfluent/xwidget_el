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
  Expression condition;
  Expression<T> trueValue;
  Expression<T> falseValue;

  ConditionalExpression(this.condition, this.trueValue, this.falseValue);

  @override
  T evaluate(Dependencies dependencies) {
    final result = condition.evaluate(dependencies);
    if (result is bool) {
      return result ? trueValue.evaluate(dependencies) : falseValue.evaluate(dependencies);
    }
    throw Exception("Conditional expression expected bool, got '${result.runtimeType}'");
  }
}
