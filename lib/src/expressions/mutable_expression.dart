import '../dependencies.dart';
import 'expression.dart';

/// Represents a mutable expression in the expression language.
///
/// Unlike [ConstantExpression], which always evaluates to the same immutable
/// value, a [MutableExpression] allows its [value] to be reassigned at runtime.
/// This makes it useful for scenarios where the expression result needs to
/// change dynamically during evaluation.
///
/// Evaluation rules:
/// - Returns the current [value] when evaluated.
/// - The [value] can be updated externally, and subsequent evaluations will
///   reflect the new value.
/// - Provides a [getType] helper to inspect the runtime type of the current value.
///
/// Example:
/// ```dart
/// final expr = MutableExpression<int>(10);
/// print(expr.evaluate(dependencies)); // -> 10
///
/// expr.value = 42;
/// print(expr.evaluate(dependencies)); // -> 42
///
/// print(expr.getType()); // -> int
/// ```
class MutableExpression<T> extends Expression<T> {
  T value;

  MutableExpression(this.value);

  @override
  T evaluate(Dependencies dependencies) {
    return value;
  }

  Type getType() {
    return value.runtimeType;
  }
}
